Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab1GCOPN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 10:15:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39777 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab1GCOPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 10:15:07 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 7/7] powerpc: pSeries reconfig notifier error injection
Date: Sun,  3 Jul 2011 23:16:21 +0900
Message-Id: <1309702581-16863-8-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309702581-16863-1-git-send-email-akinobu.mita@gmail.com>
References: <1309702581-16863-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides the ability to inject artifical errors to pSeries reconfig
notifier chain callbacks.  It is controlled through debugfs interface
under /sys/kernel/debug/pSeries-reconfig-notifier-error-inject/

Each of the files in the directory represents an event which can be
failed and contains the error code.  If the notifier call chain should
be failed with some events notified, write the error code to the files.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/platforms/pseries/reconfig.c |   31 +++++++++++++++++++++++++++++
 lib/Kconfig.debug                         |    9 ++++++++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/platforms/pseries/reconfig.c
index 168651a..31d9b0f 100644
--- a/arch/powerpc/platforms/pseries/reconfig.c
+++ b/arch/powerpc/platforms/pseries/reconfig.c
@@ -117,6 +117,37 @@ int pSeries_reconfig_notify(unsigned long action, void *p)
 	return notifier_to_errno(err);
 }
 
+#ifdef CONFIG_PSERIES_RECONFIG_NOTIFIER_ERROR_INJECTION
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
+static int __init err_inject_reconfig_notifier_init(void)
+{
+	int err;
+
+	err = err_inject_notifier_block_init(&err_inject_reconfig_nb,
+			"pSeries-reconfig-notifier-error-inject", -1);
+	if (err)
+		return err;
+
+	err = pSeries_reconfig_notifier_register(&err_inject_reconfig_nb.nb);
+	if (err)
+		err_inject_notifier_block_cleanup(&err_inject_reconfig_nb);
+
+	return err;
+}
+late_initcall(err_inject_reconfig_notifier_init);
+
+#endif /* CONFIG_PSERIES_RECONFIG_NOTIFIER_ERROR_INJECTION */
+
 static int pSeries_reconfig_add_node(const char *path, struct property *proplist)
 {
 	struct device_node *np;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 52f0b0e..2becf8c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1059,6 +1059,15 @@ config MEMORY_NOTIFIER_ERROR_INJECTION
 	  memory hotplug notifier chain callbacks.  It is controlled through
 	  debugfs interface under /sys/kernel/debug/memory-notifier-error-inject/
 
+config PSERIES_RECONFIG_NOTIFIER_ERROR_INJECTION
+	bool "pSeries reconfig notifier error injection"
+	depends on PPC_PSERIES && NOTIFIER_ERROR_INJECTION
+	help
+	  This option provides the ability to inject artifical errors to
+	  pSeries reconfig notifier chain callbacks.  It is controlled
+	  through debugfs interface under
+	  /sys/kernel/debug/pSeries-reconfig-notifier-error-inject/
+
 config CPU_NOTIFIER_ERROR_INJECT
 	tristate "CPU notifier error injection module"
 	depends on HOTPLUG_CPU && DEBUG_KERNEL
-- 
1.7.4.4

