Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab2FWO7D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 10:59:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54163 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab2FWO65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 10:58:57 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
        Greg KH <greg@kroah.com>, linux-mm@kvack.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH -v4 1/6] fault-injection: notifier error injection
Date: Sat, 23 Jun 2012 23:58:17 +0900
Message-Id: <1340463502-15341-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340463502-15341-1-git-send-email-akinobu.mita@gmail.com>
References: <1340463502-15341-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The notifier error injection provides the ability to inject artifical
errors to specified notifier chain callbacks.  It is useful to test the
error handling of notifier call chain failures.

This adds common basic functions to define which type of events can be
fail and to initialize the debugfs interface to control what error code
should be returned and which event should be failed.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org
Cc: Greg KH <greg@kroah.com>
Cc: linux-mm@kvack.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Michael Ellerman <michael@ellerman.id.au>
---
* v4
- prefix all APIs with notifier_err_inject_*
- rearrange debugfs interface
  (e.g. $DEBUGFS/cpu-notifier-error-inject/CPU_DOWN_PREPARE -->
        $DEBUGFS/notifier-error-inject/cpu/actions/CPU_DOWN_PREPARE/error)

 lib/Kconfig.debug           |   11 +++++
 lib/Makefile                |    1 +
 lib/notifier-error-inject.c |  112 +++++++++++++++++++++++++++++++++++++++++++
 lib/notifier-error-inject.h |   24 ++++++++++
 4 files changed, 148 insertions(+)
 create mode 100644 lib/notifier-error-inject.c
 create mode 100644 lib/notifier-error-inject.h

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index ff5bdee..c848758 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1084,6 +1084,17 @@ config LKDTM
 	Documentation on how to use the module can be found in
 	Documentation/fault-injection/provoke-crashes.txt
 
+config NOTIFIER_ERROR_INJECTION
+	tristate "Notifier error injection"
+	depends on DEBUG_KERNEL
+	select DEBUG_FS
+	help
+	  This option provides the ability to inject artifical errors to
+	  specified notifier chain callbacks. It is useful to test the error
+	  handling of notifier call chain failures.
+
+	  Say N if unsure.
+
 config CPU_NOTIFIER_ERROR_INJECT
 	tristate "CPU notifier error injection module"
 	depends on HOTPLUG_CPU && DEBUG_KERNEL
diff --git a/lib/Makefile b/lib/Makefile
index 8c31a0c..23fba9e 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -90,6 +90,7 @@ obj-$(CONFIG_AUDIT_GENERIC) += audit.o
 obj-$(CONFIG_SWIOTLB) += swiotlb.o
 obj-$(CONFIG_IOMMU_HELPER) += iommu-helper.o
 obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
+obj-$(CONFIG_NOTIFIER_ERROR_INJECTION) += notifier-error-inject.o
 obj-$(CONFIG_CPU_NOTIFIER_ERROR_INJECT) += cpu-notifier-error-inject.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
diff --git a/lib/notifier-error-inject.c b/lib/notifier-error-inject.c
new file mode 100644
index 0000000..44b92cb
--- /dev/null
+++ b/lib/notifier-error-inject.c
@@ -0,0 +1,112 @@
+#include <linux/module.h>
+
+#include "notifier-error-inject.h"
+
+static int debugfs_errno_set(void *data, u64 val)
+{
+	*(int *)data = clamp_t(int, val, -MAX_ERRNO, 0);
+	return 0;
+}
+
+static int debugfs_errno_get(void *data, u64 *val)
+{
+	*val = *(int *)data;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_errno, debugfs_errno_get, debugfs_errno_set,
+			"%lld\n");
+
+static struct dentry *debugfs_create_errno(const char *name, mode_t mode,
+				struct dentry *parent, int *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_errno);
+}
+
+static int notifier_err_inject_callback(struct notifier_block *nb,
+				unsigned long val, void *p)
+{
+	int err = 0;
+	struct notifier_err_inject *err_inject =
+		container_of(nb, struct notifier_err_inject, nb);
+	struct notifier_err_inject_action *action;
+
+	for (action = err_inject->actions; action->name; action++) {
+		if (action->val == val) {
+			err = action->error;
+			break;
+		}
+	}
+	if (err)
+		pr_info("Injecting error (%d) to %s\n", err, action->name);
+
+	return notifier_from_errno(err);
+}
+
+struct dentry *notifier_err_inject_dir;
+EXPORT_SYMBOL_GPL(notifier_err_inject_dir);
+
+struct dentry *notifier_err_inject_init(const char *name, struct dentry *parent,
+			struct notifier_err_inject *err_inject, int priority)
+{
+	struct notifier_err_inject_action *action;
+	mode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
+	struct dentry *dir;
+	struct dentry *actions_dir;
+
+	err_inject->nb.notifier_call = notifier_err_inject_callback;
+	err_inject->nb.priority = priority;
+
+	dir = debugfs_create_dir(name, parent);
+	if (!dir)
+		return ERR_PTR(-ENOMEM);
+
+	actions_dir = debugfs_create_dir("actions", dir);
+	if (!actions_dir)
+		goto fail;
+
+	for (action = err_inject->actions; action->name; action++) {
+		struct dentry *action_dir;
+
+		action_dir = debugfs_create_dir(action->name, actions_dir);
+		if (!action_dir)
+			goto fail;
+
+		/*
+		 * Create debugfs r/w file containing action->error. If
+		 * notifier call chain is called with action->val, it will
+		 * fail with the error code
+		 */
+		if (!debugfs_create_errno("error", mode, action_dir,
+					&action->error))
+			goto fail;
+	}
+	return dir;
+fail:
+	debugfs_remove_recursive(dir);
+	return ERR_PTR(-ENOMEM);
+}
+EXPORT_SYMBOL_GPL(notifier_err_inject_init);
+
+static int __init err_inject_init(void)
+{
+	notifier_err_inject_dir =
+		debugfs_create_dir("notifier-error-inject", NULL);
+
+	if (!notifier_err_inject_dir)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void __exit err_inject_exit(void)
+{
+	debugfs_remove_recursive(notifier_err_inject_dir);
+}
+
+module_init(err_inject_init);
+module_exit(err_inject_exit);
+
+MODULE_DESCRIPTION("Notifier error injection module");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Akinobu Mita <akinobu.mita@gmail.com>");
diff --git a/lib/notifier-error-inject.h b/lib/notifier-error-inject.h
new file mode 100644
index 0000000..99b3b6f
--- /dev/null
+++ b/lib/notifier-error-inject.h
@@ -0,0 +1,24 @@
+#include <linux/atomic.h>
+#include <linux/debugfs.h>
+#include <linux/notifier.h>
+
+struct notifier_err_inject_action {
+	unsigned long val;
+	int error;
+	const char *name;
+};
+
+#define NOTIFIER_ERR_INJECT_ACTION(action)	\
+	.name = #action, .val = (action),
+
+struct notifier_err_inject {
+	struct notifier_block nb;
+	struct notifier_err_inject_action actions[];
+	/* The last slot must be terminated with zero sentinel */
+};
+
+extern struct dentry *notifier_err_inject_dir;
+
+extern struct dentry *notifier_err_inject_init(const char *name,
+		struct dentry *parent, struct notifier_err_inject *err_inject,
+		int priority);
-- 
1.7.10.2

