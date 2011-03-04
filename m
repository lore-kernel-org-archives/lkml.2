Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044Ab1CDNsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 08:48:00 -0500
Received: from auth.codethink.co.uk ([208.78.96.188]:49297 "EHLO
	auth.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab1CDNr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 08:47:59 -0500
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Mar 2011 08:47:59 EST
From: "J.P. Lacerda" <jp.lacerda@codethink.co.uk>
To: <akpm@linux-foundation.org>, <johan.wessfeldt@gmail.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <x86@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: "J.P. Lacerda" <jp.lacerda@codethink.co.uk>
Subject: [PATCH 1/1] x86: Fix mcheck_init_device() to handle misc_register() correctly
Date: Fri,  4 Mar 2011 13:29:27 +0000
Message-Id: <1299245367-20279-1-git-send-email-jp.lacerda@codethink.co.uk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value for misc_register() was not being taken into account.
Furthermore, if misc_register() fails, we must rollback any changes made by
mcheck_init_device()

Signed-off-by: J.P. Lacerda <jp.lacerda@codethink.co.uk>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d916183..20c2c44 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2140,7 +2140,18 @@ static __init int mcheck_init_device(void)
 	}
 
 	register_hotcpu_notifier(&mce_cpu_notifier);
-	misc_register(&mce_log_device);
+	err = misc_register(&mce_log_device);
+
+	if (err) {
+		unregister_hotcpu_notifier(&mce_cpu_notifier);
+
+		for_each_online_cpu(i) {
+			mce_remove_device(i);
+		}
+
+		sysdev_class_unregister(&mce_sysclass);
+		free_cpumask_var(mce_dev_initialized);
+	}
 
 	return err;
 }
-- 
1.7.1

