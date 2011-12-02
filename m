Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab1LBNf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 08:35:26 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:12443 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095Ab1LBNfV convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 2 Dec 2011 08:35:21 -0500
Message-Id: <4ED8E2270200007800065120@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 02 Dec 2011 13:35:19 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix error paths in microcode_init()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After failure of platform_device_register_simple(), microcode_dev_exit()
got called without the call to microcode_dev_init() already having taken
place.

After failure of microcode_dev_init(), no cleanup of previously carried
out setup was done at all.

As a result, microcode_dev_exit() can now get __exit tagged on it.

(Noticed while looking at the code, not because of having experienced
an actual problem.)

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/kernel/microcode_core.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- 3.2-rc4/arch/x86/kernel/microcode_core.c
+++ 3.2-rc4-x86-ucode-init-eh/arch/x86/kernel/microcode_core.c
@@ -256,7 +256,7 @@ static int __init microcode_dev_init(voi
 	return 0;
 }
 
-static void microcode_dev_exit(void)
+static void __exit microcode_dev_exit(void)
 {
 	misc_deregister(&microcode_dev);
 }
@@ -519,10 +519,8 @@ static int __init microcode_init(void)
 
 	microcode_pdev = platform_device_register_simple("microcode", -1,
 							 NULL, 0);
-	if (IS_ERR(microcode_pdev)) {
-		microcode_dev_exit();
+	if (IS_ERR(microcode_pdev))
 		return PTR_ERR(microcode_pdev);
-	}
 
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
@@ -538,8 +536,18 @@ static int __init microcode_init(void)
 	}
 
 	error = microcode_dev_init();
-	if (error)
+	if (error) {
+		get_online_cpus();
+		mutex_lock(&microcode_mutex);
+
+		sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);
+
+		mutex_unlock(&microcode_mutex);
+		put_online_cpus();
+
+		platform_device_unregister(microcode_pdev);
 		return error;
+	}
 
 	register_syscore_ops(&mc_syscore_ops);
 	register_hotcpu_notifier(&mc_cpu_notifier);



