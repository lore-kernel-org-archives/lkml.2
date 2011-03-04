Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996Ab1CDScF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 13:32:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab1CDScD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 13:32:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=V7h2jqBw9IOGv3DeWYYe2k9De7TT7LGnH4XiHczuzhbn11R4oXcOq+aCXTOpsz6pzA
         MseCfElqG0ZXzjuCj609mUi7qPno1/pYUlKDaAYsuDp/K2lJjdl4pUGRgxSWEt8tTSI0
         Tkj4A9qsLNMzWY65946bKh8f0YtpOoYiqOEQA=
From: Johan Wessfeldt <johan.wessfeldt@gmail.com>
To: tglx@linutronix.de
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Johan Wessfeldt <johan.wessfeldt@gmail.com>
Subject: [PATCH] x86: mce: Potential memory leaks when initializing mcheck devices
Date: Fri,  4 Mar 2011 19:31:56 +0100
Message-Id: <1299263516-18858-1-git-send-email-johan.wessfeldt@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes sure cleanup is done properly when mcheck fails
initializing any of its resources.

Note!
It should be safe to call mce_remove_device on ANY of the cpus as
mce_remove_device checks if corresponding cpu was initialized
before removing its resources.

Please review.

Signed-off-by: Johan Wessfeldt <johan.wessfeldt@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d916183..273f2f6 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2136,15 +2136,26 @@ static __init int mcheck_init_device(void)
 	for_each_online_cpu(i) {
 		err = mce_create_device(i);
 		if (err)
-			return err;
+			goto out_unreg;
 	}
 
 	register_hotcpu_notifier(&mce_cpu_notifier);
-	misc_register(&mce_log_device);
+	err = misc_register(&mce_log_device);
+	if (err)
+		goto out_unreg_hotcpu;
+
+	return 0;
+
+out_unreg_hotcpu:
+	unregister_hotcpu_notifier(&mce_cpu_notifier);
+out_unreg:
+	for_each_online_cpu(i)
+		mce_remove_device(i);
 
+	sysdev_class_unregister(&mce_sysclass);
+	free_cpumask_var(mce_dev_initialized);
 	return err;
 }
-
 device_initcall(mcheck_init_device);
 
 /*
-- 
1.7.2.3

