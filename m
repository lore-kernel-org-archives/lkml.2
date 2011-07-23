Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab1GWIuF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 04:50:05 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51893 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab1GWItg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 04:49:36 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org
Subject: [PATCH v3 3/6] PM: PM notifier error injection module
Date: Sat, 23 Jul 2011 17:50:57 +0900
Message-Id: <1311411060-30124-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1311411060-30124-1-git-send-email-akinobu.mita@gmail.com>
References: <1311411060-30124-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides the ability to inject artifical errors to PM notifier chain
callbacks.  It is controlled through debugfs interface under
/sys/kernel/debug/pm-notifier-error-inject/

Each of the files in the directory represents an event which can be
failed and contains the error code.  If the notifier call chain should
be failed with some events notified, write the error code to the files.

Example: Inject PM suspend error (-12 = -ENOMEM)

	# cd /sys/kernel/debug/pm-notifier-error-inject
	# echo -12 > PM_SUSPEND_PREPARE
	# echo mem > /sys/power/state
	bash: echo: write error: Cannot allocate memory

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org
---
* v3
- rewrite to be kernel modules instead of initializing at late_initcall()s
- notifier priority can be specified as a module parameter

 lib/Kconfig.debug              |   21 ++++++++++++++++++
 lib/Makefile                   |    1 +
 lib/pm-notifier-error-inject.c |   46 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 0 deletions(-)
 create mode 100644 lib/pm-notifier-error-inject.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 55d56bb..69ecd50 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1058,6 +1058,27 @@ config CPU_NOTIFIER_ERROR_INJECT
 
 	  If unsure, say N.
 
+config PM_NOTIFIER_ERROR_INJECT
+	tristate "PM notifier error injection module"
+	depends on PM && NOTIFIER_ERROR_INJECTION
+	default m if PM_DEBUG
+	help
+	  This option provides the ability to inject artifical errors to
+	  PM notifier chain callbacks.  It is controlled through debugfs
+	  interface.
+
+	  Example: Inject PM suspend error (-12 = -ENOMEM)
+
+	  # cd /sys/kernel/debug/pm-notifier-error-inject
+	  # echo -12 > PM_SUSPEND_PREPARE
+	  # echo mem > /sys/power/state
+	  bash: echo: write error: Cannot allocate memory
+
+	  To compile this code as a module, choose M here: the module will
+	  be called pm-notifier-error-inject.
+
+	  If unsure, say N.
+
 config FAULT_INJECTION
 	bool "Fault-injection framework"
 	depends on DEBUG_KERNEL
diff --git a/lib/Makefile b/lib/Makefile
index 892f4e2..4dca6c0 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -90,6 +90,7 @@ obj-$(CONFIG_SWIOTLB) += swiotlb.o
 obj-$(CONFIG_IOMMU_HELPER) += iommu-helper.o
 obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 obj-$(CONFIG_CPU_NOTIFIER_ERROR_INJECT) += cpu-notifier-error-inject.o
+obj-$(CONFIG_PM_NOTIFIER_ERROR_INJECT) += pm-notifier-error-inject.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
diff --git a/lib/pm-notifier-error-inject.c b/lib/pm-notifier-error-inject.c
new file mode 100644
index 0000000..821b3db
--- /dev/null
+++ b/lib/pm-notifier-error-inject.c
@@ -0,0 +1,46 @@
+#include <linux/kernel.h>
+#include <linux/suspend.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
+
+static int priority;
+module_param(priority, int, 0);
+MODULE_PARM_DESC(priority, "specify PM notifier priority");
+
+static struct err_inject_notifier_block err_inject_pm_notifier = {
+	.actions = {
+		{ ERR_INJECT_NOTIFIER_ACTION(PM_HIBERNATION_PREPARE) },
+		{ ERR_INJECT_NOTIFIER_ACTION(PM_SUSPEND_PREPARE) },
+		{ ERR_INJECT_NOTIFIER_ACTION(PM_RESTORE_PREPARE) },
+		{}
+	}
+};
+
+static int err_inject_init(void)
+{
+	int err;
+
+	err = err_inject_notifier_block_init(&err_inject_pm_notifier,
+				"pm-notifier-error-inject", priority);
+	if (err)
+		return err;
+
+	err = register_pm_notifier(&err_inject_pm_notifier.nb);
+	if (err)
+		err_inject_notifier_block_cleanup(&err_inject_pm_notifier);
+
+	return err;
+}
+
+static void err_inject_exit(void)
+{
+	unregister_pm_notifier(&err_inject_pm_notifier.nb);
+	err_inject_notifier_block_cleanup(&err_inject_pm_notifier);
+}
+
+module_init(err_inject_init);
+module_exit(err_inject_exit);
+
+MODULE_DESCRIPTION("PM notifier error injection module");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Akinobu Mita <akinobu.mita@gmail.com>");
-- 
1.7.4.4

