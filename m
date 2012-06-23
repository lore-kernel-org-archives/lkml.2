Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab2FWO7F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 10:59:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37147 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab2FWO7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 10:59:00 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH -v4 2/6] cpu: rewrite cpu-notifier-error-inject module
Date: Sat, 23 Jun 2012 23:58:18 +0900
Message-Id: <1340463502-15341-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340463502-15341-1-git-send-email-akinobu.mita@gmail.com>
References: <1340463502-15341-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite existing cpu-notifier-error-inject module to use debugfs based
new framework.

This change removes cpu_up_prepare_error and cpu_down_prepare_error module
parameters which were used to specify error code to be injected.  We could
keep these module parameters for backward compatibility by module_param_cb
but it seems overkill for this module.

This provides the ability to inject artifical errors to CPU notifier chain
callbacks.  It is controlled through debugfs interface under
/sys/kernel/debug/notifier-error-inject/cpu

If the notifier call chain should be failed with some events
notified, write the error code to "actions/<notifier event>/error".

Example1: inject CPU offline error (-1 == -EPERM)

	# cd /sys/kernel/debug/notifier-error-inject/cpu
	# echo -1 > actions/CPU_DOWN_PREPARE/error
	# echo 0 > /sys/devices/system/cpu/cpu1/online
	bash: echo: write error: Operation not permitted

Example2: inject CPU online error (-2 == -ENOENT)

	# cd /sys/kernel/debug/notifier-error-inject/cpu
	# echo -2 > actions/CPU_UP_PREPARE/error
	# echo 1 > /sys/devices/system/cpu/cpu1/online
	bash: echo: write error: No such file or directory

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v4
- update modules to follow new interface

 lib/Kconfig.debug               |   16 ++++++++--
 lib/cpu-notifier-error-inject.c |   63 ++++++++++++++++-----------------------
 2 files changed, 39 insertions(+), 40 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c848758..be0c197 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1097,10 +1097,22 @@ config NOTIFIER_ERROR_INJECTION
 
 config CPU_NOTIFIER_ERROR_INJECT
 	tristate "CPU notifier error injection module"
-	depends on HOTPLUG_CPU && DEBUG_KERNEL
+	depends on HOTPLUG_CPU && NOTIFIER_ERROR_INJECTION
 	help
 	  This option provides a kernel module that can be used to test
-	  the error handling of the cpu notifiers
+	  the error handling of the cpu notifiers by injecting artifical
+	  errors to CPU notifier chain callbacks.  It is controlled through
+	  debugfs interface under /sys/kernel/debug/notifier-error-inject/cpu
+
+	  If the notifier call chain should be failed with some events
+	  notified, write the error code to "actions/<notifier event>/error".
+
+	  Example: Inject CPU offline error (-1 == -EPERM)
+
+	  # cd /sys/kernel/debug/notifier-error-inject/cpu
+	  # echo -1 > actions/CPU_DOWN_PREPARE/error
+	  # echo 0 > /sys/devices/system/cpu/cpu1/online
+	  bash: echo: write error: Operation not permitted
 
 	  To compile this code as a module, choose M here: the module will
 	  be called cpu-notifier-error-inject.
diff --git a/lib/cpu-notifier-error-inject.c b/lib/cpu-notifier-error-inject.c
index 4dc2032..707ca24 100644
--- a/lib/cpu-notifier-error-inject.c
+++ b/lib/cpu-notifier-error-inject.c
@@ -1,58 +1,45 @@
 #include <linux/kernel.h>
-#include <linux/cpu.h>
 #include <linux/module.h>
-#include <linux/notifier.h>
+#include <linux/cpu.h>
 
-static int priority;
-static int cpu_up_prepare_error;
-static int cpu_down_prepare_error;
+#include "notifier-error-inject.h"
 
+static int priority;
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
+static struct notifier_err_inject cpu_notifier_err_inject = {
+	.actions = {
+		{ NOTIFIER_ERR_INJECT_ACTION(CPU_UP_PREPARE) },
+		{ NOTIFIER_ERR_INJECT_ACTION(CPU_UP_PREPARE_FROZEN) },
+		{ NOTIFIER_ERR_INJECT_ACTION(CPU_DOWN_PREPARE) },
+		{ NOTIFIER_ERR_INJECT_ACTION(CPU_DOWN_PREPARE_FROZEN) },
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
 
+static struct dentry *dir;
+
 static int err_inject_init(void)
 {
-	err_inject_cpu_notifier.priority = priority;
+	int err;
+
+	dir = notifier_err_inject_init("cpu", notifier_err_inject_dir,
+					&cpu_notifier_err_inject, priority);
+	if (IS_ERR(dir))
+		return PTR_ERR(dir);
+
+	err = register_hotcpu_notifier(&cpu_notifier_err_inject.nb);
+	if (err)
+		debugfs_remove_recursive(dir);
 
-	return register_hotcpu_notifier(&err_inject_cpu_notifier);
+	return err;
 }
 
 static void err_inject_exit(void)
 {
-	unregister_hotcpu_notifier(&err_inject_cpu_notifier);
+	unregister_hotcpu_notifier(&cpu_notifier_err_inject.nb);
+	debugfs_remove_recursive(dir);
 }
 
 module_init(err_inject_init);
-- 
1.7.10.2

