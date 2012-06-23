Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab2FWPAR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 11:00:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54163 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2FWO7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 10:59:02 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org
Subject: [PATCH -v4 3/6] PM: PM notifier error injection module
Date: Sat, 23 Jun 2012 23:58:19 +0900
Message-Id: <1340463502-15341-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340463502-15341-1-git-send-email-akinobu.mita@gmail.com>
References: <1340463502-15341-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides the ability to inject artifical errors to PM notifier chain
callbacks.  It is controlled through debugfs interface under
/sys/kernel/debug/notifier-error-inject/pm

Each of the files in "error" directory represents an event which can be
failed and contains the error code.  If the notifier call chain should
be failed with some events notified, write the error code to the files.

If the notifier call chain should be failed with some events notified,
write the error code to "actions/<notifier event>/error".

Example: Inject PM suspend error (-12 = -ENOMEM)

	# cd /sys/kernel/debug/notifier-error-inject/pm
	# echo -12 > actions/PM_SUSPEND_PREPARE/error
	# echo mem > /sys/power/state
	bash: echo: write error: Cannot allocate memory

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org
---
* v4
- update modules to follow new interface

 lib/Kconfig.debug              |   24 ++++++++++++++++++++
 lib/Makefile                   |    1 +
 lib/pm-notifier-error-inject.c |   49 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 74 insertions(+)
 create mode 100644 lib/pm-notifier-error-inject.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index be0c197..246cea6 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1119,6 +1119,30 @@ config CPU_NOTIFIER_ERROR_INJECT
 
 	  If unsure, say N.
 
+config PM_NOTIFIER_ERROR_INJECT
+	tristate "PM notifier error injection module"
+	depends on PM && NOTIFIER_ERROR_INJECTION
+	default m if PM_DEBUG
+	help
+	  This option provides the ability to inject artifical errors to
+	  PM notifier chain callbacks.  It is controlled through debugfs
+	  interface /sys/kernel/debug/notifier-error-inject/pm
+
+	  If the notifier call chain should be failed with some events
+	  notified, write the error code to "actions/<notifier event>/error".
+
+	  Example: Inject PM suspend error (-12 = -ENOMEM)
+
+	  # cd /sys/kernel/debug/notifier-error-inject/pm/
+	  # echo -12 > actions/PM_SUSPEND_PREPARE/error
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
index 23fba9e..230a949 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -92,6 +92,7 @@ obj-$(CONFIG_IOMMU_HELPER) += iommu-helper.o
 obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 obj-$(CONFIG_NOTIFIER_ERROR_INJECTION) += notifier-error-inject.o
 obj-$(CONFIG_CPU_NOTIFIER_ERROR_INJECT) += cpu-notifier-error-inject.o
+obj-$(CONFIG_PM_NOTIFIER_ERROR_INJECT) += pm-notifier-error-inject.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
diff --git a/lib/pm-notifier-error-inject.c b/lib/pm-notifier-error-inject.c
new file mode 100644
index 0000000..c094b2d
--- /dev/null
+++ b/lib/pm-notifier-error-inject.c
@@ -0,0 +1,49 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/suspend.h>
+
+#include "notifier-error-inject.h"
+
+static int priority;
+module_param(priority, int, 0);
+MODULE_PARM_DESC(priority, "specify PM notifier priority");
+
+static struct notifier_err_inject pm_notifier_err_inject = {
+	.actions = {
+		{ NOTIFIER_ERR_INJECT_ACTION(PM_HIBERNATION_PREPARE) },
+		{ NOTIFIER_ERR_INJECT_ACTION(PM_SUSPEND_PREPARE) },
+		{ NOTIFIER_ERR_INJECT_ACTION(PM_RESTORE_PREPARE) },
+		{}
+	}
+};
+
+static struct dentry *dir;
+
+static int err_inject_init(void)
+{
+	int err;
+
+	dir = notifier_err_inject_init("pm", notifier_err_inject_dir,
+					&pm_notifier_err_inject, priority);
+	if (IS_ERR(dir))
+		return PTR_ERR(dir);
+
+	err = register_pm_notifier(&pm_notifier_err_inject.nb);
+	if (err)
+		debugfs_remove_recursive(dir);
+
+	return err;
+}
+
+static void err_inject_exit(void)
+{
+	unregister_pm_notifier(&pm_notifier_err_inject.nb);
+	debugfs_remove_recursive(dir);
+}
+
+module_init(err_inject_init);
+module_exit(err_inject_exit);
+
+MODULE_DESCRIPTION("PM notifier error injection module");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Akinobu Mita <akinobu.mita@gmail.com>");
-- 
1.7.10.2

