Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab1GWItz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 04:49:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59668 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab1GWItf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 04:49:35 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 2/6] cpu: rewrite cpu-notifier-error-inject module
Date: Sat, 23 Jul 2011 17:50:56 +0900
Message-Id: <1311411060-30124-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1311411060-30124-1-git-send-email-akinobu.mita@gmail.com>
References: <1311411060-30124-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite existing cpu-notifier-error-inject module to use debugfs based
brand-new framework.

This change removes cpu_up_prepare_error and cpu_down_prepare_error module
parameters which were used to specify error code to be injected.  We could
keep these module parameters for backward compatibility by module_param_cb
but it seems overkill for this module.

This provides the ability to inject artifical errors to CPU notifier chain
callbacks.  It is controlled through debugfs interface under
/sys/kernel/debug/cpu-notifier-error-inject/

Each of the files in the directory represents an event which can be failed
and contains the error code.  If the notifier call chain should be failed
with some events notified, write the error code to the files.

Example1: inject CPU offline error (-1 == -EPERM)

	# echo -1 > /sys/kernel/debug/cpu-notifier-error-inject/CPU_UP_PREPARE
	# echo 0 > /sys/devices/system/cpu/cpu1/online
	bash: echo: write error: Operation not permitted

Example2: inject CPU online error (-2 == -ENOENT)

	# echo -2 > /sys/kernel/debug/cpu-notifier-error-inject/CPU_DOWN_PREPARE
	# echo 1 > /sys/devices/system/cpu/cpu1/online
	bash: echo: write error: No such file or directory

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v3
- rewrite to be kernel modules instead of initializing at late_initcall()s
- notifier priority can be specified as a module parameter

 lib/Kconfig.debug               |   18 +++++++++++-
 lib/cpu-notifier-error-inject.c |   56 ++++++++++++++-------------------------
 2 files changed, 36 insertions(+), 38 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2a62c5a..55d56bb 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1034,10 +1034,24 @@ config NOTIFIER_ERROR_INJECTION
 
 config CPU_NOTIFIER_ERROR_INJECT
 	tristate "CPU notifier error injection module"
-	depends on HOTPLUG_CPU && DEBUG_KERNEL
+	depends on HOTPLUG_CPU && NOTIFIER_ERROR_INJECTION
 	help
 	  This option provides a kernel module that can be used to test
-	  the error handling of the cpu notifiers
+	  the error handling of the cpu notifiers by injecting artifical
+	  errors to CPU notifier chain callbacks.  It is controlled through
+	  debugfs interface under /sys/kernel/debug/cpu-notifier-error-inject
+
+	  Each of the files in the directory represents an event which can be
+	  failed and contains the error code.  If the notifier call chain
+	  should be failed with some events notified, write the error code to
+	  the files.
+
+	  Example: Inject CPU offline error (-1 == -EPERM)
+
+	  # cd /sys/kernel/debug/cpu-notifier-error-inject
+	  # echo -1 > CPU_UP_PREPARE
+	  # echo 0 > /sys/devices/system/cpu/cpu1/online
+	  bash: echo: write error: Operation not permitted
 
 	  To compile this code as a module, choose M here: the module will
 	  be called cpu-notifier-error-inject.
diff --git a/lib/cpu-notifier-error-inject.c b/lib/cpu-notifier-error-inject.c
index 4dc2032..1601b72 100644
--- a/lib/cpu-notifier-error-inject.c
+++ b/lib/cpu-notifier-error-inject.c
@@ -4,55 +4,39 @@
 #include <linux/notifier.h>
 
 static int priority;
-static int cpu_up_prepare_error;
-static int cpu_down_prepare_error;
-
 module_param(priority, int, 0);
 MODULE_PARM_DESC(priority, "specify cpu notifier priority");
 
-module_param(cpu_up_prepare_error, int, 0644);
-MODULE_PARM_DESC(cpu_up_prepare_error,
-		"specify error code to inject CPU_UP_PREPARE action");
-
-module_param(cpu_down_prepare_error, int, 0644);
-MODULE_PARM_DESC(cpu_down_prepare_error,
-		"specify error code to inject CPU_DOWN_PREPARE action");
-
-static int err_inject_cpu_callback(struct notifier_block *nfb,
-				unsigned long action, void *hcpu)
-{
-	int err = 0;
-
-	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		err = cpu_up_prepare_error;
-		break;
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
-		err = cpu_down_prepare_error;
-		break;
+static struct err_inject_notifier_block err_inject_cpu_notifier = {
+	.actions = {
+		{ ERR_INJECT_NOTIFIER_ACTION(CPU_UP_PREPARE) },
+		{ ERR_INJECT_NOTIFIER_ACTION(CPU_UP_PREPARE_FROZEN) },
+		{ ERR_INJECT_NOTIFIER_ACTION(CPU_DOWN_PREPARE) },
+		{ ERR_INJECT_NOTIFIER_ACTION(CPU_DOWN_PREPARE_FROZEN) },
+		{}
 	}
-	if (err)
-		printk(KERN_INFO "Injecting error (%d) at cpu notifier\n", err);
-
-	return notifier_from_errno(err);
-}
-
-static struct notifier_block err_inject_cpu_notifier = {
-	.notifier_call = err_inject_cpu_callback,
 };
 
 static int err_inject_init(void)
 {
-	err_inject_cpu_notifier.priority = priority;
+	int err;
+
+	err = err_inject_notifier_block_init(&err_inject_cpu_notifier,
+				"cpu-notifier-error-inject", priority);
+	if (err)
+		return err;
+
+	err = register_hotcpu_notifier(&err_inject_cpu_notifier.nb);
+	if (err)
+		err_inject_notifier_block_cleanup(&err_inject_cpu_notifier);
 
-	return register_hotcpu_notifier(&err_inject_cpu_notifier);
+	return err;
 }
 
 static void err_inject_exit(void)
 {
-	unregister_hotcpu_notifier(&err_inject_cpu_notifier);
+	unregister_hotcpu_notifier(&err_inject_cpu_notifier.nb);
+	err_inject_notifier_block_cleanup(&err_inject_cpu_notifier);
 }
 
 module_init(err_inject_init);
-- 
1.7.4.4

