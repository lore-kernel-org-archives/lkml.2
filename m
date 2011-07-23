Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab1GWIuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 04:50:13 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51893 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab1GWItk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 04:49:40 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 5/6] powerpc: pSeries reconfig notifier error injection module
Date: Sat, 23 Jul 2011 17:50:59 +0900
Message-Id: <1311411060-30124-6-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1311411060-30124-1-git-send-email-akinobu.mita@gmail.com>
References: <1311411060-30124-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides the ability to inject artifical errors to pSeries reconfig
notifier chain callbacks.  It is controlled through debugfs interface
under /sys/kernel/debug/pSeries-reconfig-notifier-error-inject/

Each of the files in the directory represents an event which can be failed
and contains the error code.  If the notifier call chain should be failed
with some events notified, write the error code to the files.

This module needs pSeries_reconfig_notifier_{,un}register symbols to be
exported.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
---
* v3
- rewrite to be kernel modules instead of initializing at late_initcall()s
- export pSeries_reconfig_notifier_{,un}register symbols for this module
- notifier priority can be specified as a module parameter

 arch/powerpc/platforms/pseries/reconfig.c    |    2 +
 lib/Kconfig.debug                            |   14 +++++++
 lib/Makefile                                 |    2 +
 lib/pSeries-reconfig-notifier-error-inject.c |   48 ++++++++++++++++++++++++++
 4 files changed, 66 insertions(+), 0 deletions(-)
 create mode 100644 lib/pSeries-reconfig-notifier-error-inject.c

diff --git a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/platforms/pseries/reconfig.c
index 168651a..b9808e9 100644
--- a/arch/powerpc/platforms/pseries/reconfig.c
+++ b/arch/powerpc/platforms/pseries/reconfig.c
@@ -103,11 +103,13 @@ int pSeries_reconfig_notifier_register(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_register(&pSeries_reconfig_chain, nb);
 }
+EXPORT_SYMBOL_GPL(pSeries_reconfig_notifier_register);
 
 void pSeries_reconfig_notifier_unregister(struct notifier_block *nb)
 {
 	blocking_notifier_chain_unregister(&pSeries_reconfig_chain, nb);
 }
+EXPORT_SYMBOL_GPL(pSeries_reconfig_notifier_unregister);
 
 int pSeries_reconfig_notify(unsigned long action, void *p)
 {
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a2b0856..46298d7 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1099,6 +1099,20 @@ config MEMORY_NOTIFIER_ERROR_INJECT
 
 	  If unsure, say N.
 
+config PSERIES_RECONFIG_NOTIFIER_ERROR_INJECT
+	tristate "pSeries reconfig notifier error injection module"
+	depends on PPC_PSERIES && NOTIFIER_ERROR_INJECTION
+	help
+	  This option provides the ability to inject artifical errors to
+	  pSeries reconfig notifier chain callbacks.  It is controlled
+	  through debugfs interface under
+	  /sys/kernel/debug/pSeries-reconfig-notifier-error-inject/
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
index f28914b..e68cea7 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -92,6 +92,8 @@ obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 obj-$(CONFIG_CPU_NOTIFIER_ERROR_INJECT) += cpu-notifier-error-inject.o
 obj-$(CONFIG_PM_NOTIFIER_ERROR_INJECT) += pm-notifier-error-inject.o
 obj-$(CONFIG_MEMORY_NOTIFIER_ERROR_INJECT) += memory-notifier-error-inject.o
+obj-$(CONFIG_PSERIES_RECONFIG_NOTIFIER_ERROR_INJECT) += \
+	pSeries-reconfig-notifier-error-inject.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
diff --git a/lib/pSeries-reconfig-notifier-error-inject.c b/lib/pSeries-reconfig-notifier-error-inject.c
new file mode 100644
index 0000000..f4ed2b3
--- /dev/null
+++ b/lib/pSeries-reconfig-notifier-error-inject.c
@@ -0,0 +1,48 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
+
+#include <asm/pSeries_reconfig.h>
+
+static int priority;
+module_param(priority, int, 0);
+MODULE_PARM_DESC(priority, "specify pSeries reconfig notifier priority");
+
+static struct err_inject_notifier_block err_inject_reconfig_nb = {
+	.actions = {
+		{ ERR_INJECT_NOTIFIER_ACTION(PSERIES_RECONFIG_ADD) },
+		{ ERR_INJECT_NOTIFIER_ACTION(PSERIES_RECONFIG_REMOVE) },
+		{ ERR_INJECT_NOTIFIER_ACTION(PSERIES_DRCONF_MEM_ADD) },
+		{ ERR_INJECT_NOTIFIER_ACTION(PSERIES_DRCONF_MEM_REMOVE) },
+		{}
+	}
+};
+
+static int err_inject_init(void)
+{
+	int err;
+
+	err = err_inject_notifier_block_init(&err_inject_reconfig_nb,
+			"pSeries-reconfig-notifier-error-inject", priority);
+	if (err)
+		return err;
+
+	err = pSeries_reconfig_notifier_register(&err_inject_reconfig_nb.nb);
+	if (err)
+		err_inject_notifier_block_cleanup(&err_inject_reconfig_nb);
+
+	return err;
+}
+
+static void err_inject_exit(void)
+{
+	pSeries_reconfig_notifier_unregister(&err_inject_reconfig_nb.nb);
+	err_inject_notifier_block_cleanup(&err_inject_reconfig_nb);
+}
+
+module_init(err_inject_init);
+module_exit(err_inject_exit);
+
+MODULE_DESCRIPTION("pSeries reconfig notifier error injection module");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Akinobu Mita <akinobu.mita@gmail.com>");
-- 
1.7.4.4

