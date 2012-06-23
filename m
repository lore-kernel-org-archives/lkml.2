Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab2FWO7p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 10:59:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37147 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab2FWO7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 10:59:04 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Greg KH <greg@kroah.com>,
        linux-mm@kvack.org
Subject: [PATCH -v4 4/6] memory: memory notifier error injection module
Date: Sat, 23 Jun 2012 23:58:20 +0900
Message-Id: <1340463502-15341-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340463502-15341-1-git-send-email-akinobu.mita@gmail.com>
References: <1340463502-15341-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides the ability to inject artifical errors to memory hotplug
notifier chain callbacks.  It is controlled through debugfs interface
under /sys/kernel/debug/notifier-error-inject/memory

If the notifier call chain should be failed with some events notified,
write the error code to "actions/<notifier event>/error".

Example: Inject memory hotplug offline error (-12 == -ENOMEM)

	# cd /sys/kernel/debug/notifier-error-inject/memory
	# echo -12 > actions/MEM_GOING_OFFLINE/error
	# echo offline > /sys/devices/system/memory/memoryXXX/state
	bash: echo: write error: Cannot allocate memory

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: linux-mm@kvack.org
---
* v4
- update modules to follow new interface

 lib/Kconfig.debug                  |   23 +++++++++++++++++
 lib/Makefile                       |    1 +
 lib/memory-notifier-error-inject.c |   48 ++++++++++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+)
 create mode 100644 lib/memory-notifier-error-inject.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 246cea6..7cceddc 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1143,6 +1143,29 @@ config PM_NOTIFIER_ERROR_INJECT
 
 	  If unsure, say N.
 
+config MEMORY_NOTIFIER_ERROR_INJECT
+	tristate "Memory hotplug notifier error injection module"
+	depends on MEMORY_HOTPLUG_SPARSE && NOTIFIER_ERROR_INJECTION
+	help
+	  This option provides the ability to inject artifical errors to
+	  memory hotplug notifier chain callbacks.  It is controlled through
+	  debugfs interface under /sys/kernel/debug/notifier-error-inject/memory
+
+	  If the notifier call chain should be failed with some events
+	  notified, write the error code to "actions/<notifier event>/error".
+
+	  Example: Inject memory hotplug offline error (-12 == -ENOMEM)
+
+	  # cd /sys/kernel/debug/notifier-error-inject/memory
+	  # echo -12 > actions/MEM_GOING_OFFLINE/error
+	  # echo offline > /sys/devices/system/memory/memoryXXX/state
+	  bash: echo: write error: Cannot allocate memory
+
+	  To compile this code as a module, choose M here: the module will
+	  be called memory-notifier-error-inject.
+
+	  If unsure, say N.
+
 config FAULT_INJECTION
 	bool "Fault-injection framework"
 	depends on DEBUG_KERNEL
diff --git a/lib/Makefile b/lib/Makefile
index 230a949..a867aa5 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -93,6 +93,7 @@ obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 obj-$(CONFIG_NOTIFIER_ERROR_INJECTION) += notifier-error-inject.o
 obj-$(CONFIG_CPU_NOTIFIER_ERROR_INJECT) += cpu-notifier-error-inject.o
 obj-$(CONFIG_PM_NOTIFIER_ERROR_INJECT) += pm-notifier-error-inject.o
+obj-$(CONFIG_MEMORY_NOTIFIER_ERROR_INJECT) += memory-notifier-error-inject.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
diff --git a/lib/memory-notifier-error-inject.c b/lib/memory-notifier-error-inject.c
new file mode 100644
index 0000000..e6239bf
--- /dev/null
+++ b/lib/memory-notifier-error-inject.c
@@ -0,0 +1,48 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/memory.h>
+
+#include "notifier-error-inject.h"
+
+static int priority;
+module_param(priority, int, 0);
+MODULE_PARM_DESC(priority, "specify memory notifier priority");
+
+static struct notifier_err_inject memory_notifier_err_inject = {
+	.actions = {
+		{ NOTIFIER_ERR_INJECT_ACTION(MEM_GOING_ONLINE) },
+		{ NOTIFIER_ERR_INJECT_ACTION(MEM_GOING_OFFLINE) },
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
+	dir = notifier_err_inject_init("memory", notifier_err_inject_dir,
+					&memory_notifier_err_inject, priority);
+	if (IS_ERR(dir))
+		return PTR_ERR(dir);
+
+	err = register_memory_notifier(&memory_notifier_err_inject.nb);
+	if (err)
+		debugfs_remove_recursive(dir);
+
+	return err;
+}
+
+static void err_inject_exit(void)
+{
+	unregister_memory_notifier(&memory_notifier_err_inject.nb);
+	debugfs_remove_recursive(dir);
+}
+
+module_init(err_inject_init);
+module_exit(err_inject_exit);
+
+MODULE_DESCRIPTION("memory notifier error injection module");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Akinobu Mita <akinobu.mita@gmail.com>");
-- 
1.7.10.2

