Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab1CGKh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 05:37:26 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52074 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab1CGKhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 05:37:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MOv1ulBWKiQw4/+zLFjPVxWMli7H5rTQ+yhqayrOWuGMdQ8zrEpWoWlDXOJLlrj2kx
         PpMCQtjtgWDOiLAviB7gqqGg0Kjk488xBNme6f3xYnPlFPgHpmjeBFJdIYoVaztQfLYr
         WAFo6vL/rc5vIEXgqExjA1M/ZpS1tjvPHw7es=
From: Johan Wessfeldt <johan.wessfeldt@gmail.com>
Cc: x86@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Johan Wessfeldt <johan.wessfeldt@gmail.com>
Subject: [PATCH V2] x86: mce: Potential memory leaks when initializing mcheck devices
Date: Mon,  7 Mar 2011 11:36:23 +0100
Message-Id: <1299494183-7380-1-git-send-email-johan.wessfeldt@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <AANLkTikMY+7ApHCXY_jjue9RRCE-ORKrj4pAyy5H0W8_@mail.gmail.com>
References: <AANLkTikMY+7ApHCXY_jjue9RRCE-ORKrj4pAyy5H0W8_@mail.gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes sure cleanup is done properly when mcheck fails
initializing any of its resources.

Signed-off-by: Johan Wessfeldt <johan.wessfeldt@gmail.com>
---
v2: call free_cpumask_var() if sysdev_class_register() fails

 arch/x86/kernel/cpu/mcheck/mce.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d916183..3cbd5a0 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2131,20 +2131,32 @@ static __init int mcheck_init_device(void)
 
 	err = sysdev_class_register(&mce_sysclass);
 	if (err)
-		return err;
+		goto out_free;
 
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
 
+	return 0;
+
+out_unreg_hotcpu:
+	unregister_hotcpu_notifier(&mce_cpu_notifier);
+out_unreg:
+	for_each_online_cpu(i)
+		mce_remove_device(i);
+
+	sysdev_class_unregister(&mce_sysclass);
+out_free:
+	free_cpumask_var(mce_dev_initialized);
 	return err;
 }
-
 device_initcall(mcheck_init_device);
 
 /*
-- 
1.7.2.3

