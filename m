Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903Ab2BNRZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 12:25:40 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57780 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab2BNRZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 12:25:39 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH] of: Only compile OF_DYNAMIC on PowerPC pseries and iseries
Date: Tue, 14 Feb 2012 10:25:30 -0700
Message-Id: <1329240330-3539-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only two architectures use the OF node reference counting and reclaim bits.
There is no need to compile it for the rest of the PowerPC platforms or for
any of the other architectures.  This patch makes iseries and pseries
select CONFIG_OF_DYNAMIC, and makes it default to off for everything else.

It is still safe to turn on CONFIG_OF_DYNAMIC on all architectures, it just
isn't necessary.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 arch/powerpc/platforms/iseries/Kconfig |    1 +
 arch/powerpc/platforms/pseries/Kconfig |    1 +
 drivers/of/Kconfig                     |    5 +++--
 drivers/of/base.c                      |    4 ++--
 include/linux/of.h                     |   14 ++++++--------
 5 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/platforms/iseries/Kconfig b/arch/powerpc/platforms/iseries/Kconfig
index b57cda3..63835e0 100644
--- a/arch/powerpc/platforms/iseries/Kconfig
+++ b/arch/powerpc/platforms/iseries/Kconfig
@@ -1,6 +1,7 @@
 config PPC_ISERIES
 	bool "IBM Legacy iSeries"
 	depends on PPC64 && PPC_BOOK3S
+	select OF_DYNAMIC
 	select PPC_SMP_MUXED_IPI
 	select PPC_INDIRECT_PIO
 	select PPC_INDIRECT_MMIO
diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
index 31f22c1..f255625 100644
--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -3,6 +3,7 @@ config PPC_PSERIES
 	bool "IBM pSeries & new (POWER5-based) iSeries"
 	select HAVE_PCSPKR_PLATFORM
 	select MPIC
+	select OF_DYNAMIC
 	select PCI_MSI
 	select PPC_XICS
 	select PPC_ICP_NATIVE
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 268163d..6ea51dc 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -35,9 +35,10 @@ config OF_EARLY_FLATTREE
 config OF_PROMTREE
 	bool
 
+# Hardly any platforms need this.  It is safe to select, but only do so if you
+# need it.
 config OF_DYNAMIC
-	def_bool y
-	depends on PPC_OF
+	bool
 
 config OF_ADDRESS
 	def_bool y
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 133908a..df6da08 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -88,7 +88,7 @@ int of_n_size_cells(struct device_node *np)
 }
 EXPORT_SYMBOL(of_n_size_cells);
 
-#if !defined(CONFIG_SPARC)   /* SPARC doesn't do ref counting (yet) */
+#if defined(CONFIG_OF_DYNAMIC)
 /**
  *	of_node_get - Increment refcount of a node
  *	@node:	Node to inc refcount, NULL is supported to
@@ -161,7 +161,7 @@ void of_node_put(struct device_node *node)
 		kref_put(&node->kref, of_node_release);
 }
 EXPORT_SYMBOL(of_node_put);
-#endif /* !CONFIG_SPARC */
+#endif /* CONFIG_OF_DYNAMIC */
 
 struct property *of_find_property(const struct device_node *np,
 				  const char *name,
diff --git a/include/linux/of.h b/include/linux/of.h
index a75a831..b6ff1f7 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -72,19 +72,17 @@ struct of_phandle_args {
 	uint32_t args[MAX_PHANDLE_ARGS];
 };
 
-#if defined(CONFIG_SPARC) || !defined(CONFIG_OF)
+#ifdef CONFIG_OF_DYNAMIC
+extern struct device_node *of_node_get(struct device_node *node);
+extern void of_node_put(struct device_node *node);
+#else /* CONFIG_OF_DYNAMIC */
 /* Dummy ref counting routines - to be implemented later */
 static inline struct device_node *of_node_get(struct device_node *node)
 {
 	return node;
 }
-static inline void of_node_put(struct device_node *node)
-{
-}
-#else
-extern struct device_node *of_node_get(struct device_node *node);
-extern void of_node_put(struct device_node *node);
-#endif
+static inline void of_node_put(struct device_node *node) { }
+#endif /* !CONFIG_OF_DYNAMIC */
 
 #ifdef CONFIG_OF
 
-- 
1.7.9

