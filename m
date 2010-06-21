Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab0FUWcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 18:32:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53681 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab0FUWcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 18:32:07 -0400
Subject: [PATCH v2 3/5] of/powerpc: Move Powermac irq quirk code into powermac
	pic driver code
To: microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
       linuxppc-dev@lists.ozlabs.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: sfr@canb.auug.org.au, monstr@monstr.eu, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
Date: Mon, 21 Jun 2010 16:32:02 -0600
Message-ID: <20100621223043.18925.782.stgit@angua>
In-Reply-To: <20100621222052.18925.61569.stgit@angua>
References: <20100621222052.18925.61569.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code that figures out what is wrong with the powermac irq device
tree data belongs with the rest of the powermac irq code.  This patch
moves it out of prom_parse.c and into powermac/pic.c so that it is only
compiled in when actually needed.

The quirk flags are also conditionally compiled out to discourage their
use by other platforms.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/include/asm/prom.h       |   24 ++++++---
 arch/powerpc/kernel/prom_parse.c      |   85 ---------------------------------
 arch/powerpc/platforms/powermac/pic.c |   72 ++++++++++++++++++++++++++--
 3 files changed, 81 insertions(+), 100 deletions(-)

diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
index 47d41b6..4486765 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -109,18 +109,24 @@ extern const void *of_get_mac_address(struct device_node *np);
  * OF interrupt mapping
  */
 
-/**
- * of_irq_map_init - Initialize the irq remapper
- * @flags:	flags defining workarounds to enable
- *
- * Some machines have bugs in the device-tree which require certain workarounds
- * to be applied. Call this before any interrupt mapping attempts to enable
- * those workarounds.
- */
 #define OF_IMAP_OLDWORLD_MAC	0x00000001
 #define OF_IMAP_NO_PHANDLE	0x00000002
 
-extern void of_irq_map_init(unsigned int flags);
+#if defined(CONFIG_PPC32) && defined(CONFIG_PPC_PMAC)
+/* Workarounds only needed for 32bit powermac machines */
+extern unsigned int of_irq_workarounds;
+extern struct device_node *of_irq_dflt_pic;
+extern int of_irq_map_oldworld(struct device_node *device, int index,
+			       struct of_irq *out_irq);
+#else
+#define of_irq_workarounds (0)
+#define of_irq_dflt_pic (NULL)
+static inline int of_irq_map_oldworld(struct device_node *device, int index,
+				      struct of_irq *out_irq)
+{
+	return -EINVAL;
+}
+#endif
 
 /**
  * of_irq_map_raw - Low level interrupt tree parsing
diff --git a/arch/powerpc/kernel/prom_parse.c b/arch/powerpc/kernel/prom_parse.c
index 8362620..dfa6de6 100644
--- a/arch/powerpc/kernel/prom_parse.c
+++ b/arch/powerpc/kernel/prom_parse.c
@@ -682,9 +682,6 @@ void of_parse_dma_window(struct device_node *dn, const void *dma_window_prop,
  * Interrupt remapper
  */
 
-static unsigned int of_irq_workarounds;
-static struct device_node *of_irq_dflt_pic;
-
 static struct device_node *of_irq_find_parent(struct device_node *child)
 {
 	struct device_node *p;
@@ -710,44 +707,6 @@ static struct device_node *of_irq_find_parent(struct device_node *child)
 	return p;
 }
 
-/* This doesn't need to be called if you don't have any special workaround
- * flags to pass
- */
-void of_irq_map_init(unsigned int flags)
-{
-	of_irq_workarounds = flags;
-
-	/* OldWorld, don't bother looking at other things */
-	if (flags & OF_IMAP_OLDWORLD_MAC)
-		return;
-
-	/* If we don't have phandles, let's try to locate a default interrupt
-	 * controller (happens when booting with BootX). We do a first match
-	 * here, hopefully, that only ever happens on machines with one
-	 * controller.
-	 */
-	if (flags & OF_IMAP_NO_PHANDLE) {
-		struct device_node *np;
-
-		for_each_node_with_property(np, "interrupt-controller") {
-			/* Skip /chosen/interrupt-controller */
-			if (strcmp(np->name, "chosen") == 0)
-				continue;
-			/* It seems like at least one person on this planet wants
-			 * to use BootX on a machine with an AppleKiwi controller
-			 * which happens to pretend to be an interrupt
-			 * controller too.
-			 */
-			if (strcmp(np->name, "AppleKiwi") == 0)
-				continue;
-			/* I think we found one ! */
-			of_irq_dflt_pic = np;
-			break;
-		}
-	}
-
-}
-
 int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
 		const u32 *addr, struct of_irq *out_irq)
 {
@@ -922,50 +881,6 @@ int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
 }
 EXPORT_SYMBOL_GPL(of_irq_map_raw);
 
-#if defined(CONFIG_PPC_PMAC) && defined(CONFIG_PPC32)
-static int of_irq_map_oldworld(struct device_node *device, int index,
-			       struct of_irq *out_irq)
-{
-	const u32 *ints = NULL;
-	int intlen;
-
-	/*
-	 * Old machines just have a list of interrupt numbers
-	 * and no interrupt-controller nodes. We also have dodgy
-	 * cases where the APPL,interrupts property is completely
-	 * missing behind pci-pci bridges and we have to get it
-	 * from the parent (the bridge itself, as apple just wired
-	 * everything together on these)
-	 */
-	while (device) {
-		ints = of_get_property(device, "AAPL,interrupts", &intlen);
-		if (ints != NULL)
-			break;
-		device = device->parent;
-		if (device && strcmp(device->type, "pci") != 0)
-			break;
-	}
-	if (ints == NULL)
-		return -EINVAL;
-	intlen /= sizeof(u32);
-
-	if (index >= intlen)
-		return -EINVAL;
-
-	out_irq->controller = NULL;
-	out_irq->specifier[0] = ints[index];
-	out_irq->size = 1;
-
-	return 0;
-}
-#else /* defined(CONFIG_PPC_PMAC) && defined(CONFIG_PPC32) */
-static int of_irq_map_oldworld(struct device_node *device, int index,
-			       struct of_irq *out_irq)
-{
-	return -EINVAL;
-}
-#endif /* !(defined(CONFIG_PPC_PMAC) && defined(CONFIG_PPC32)) */
-
 int of_irq_map_one(struct device_node *device, int index, struct of_irq *out_irq)
 {
 	struct device_node *p;
diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index 630a533..890d5f7 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -46,6 +46,10 @@ struct pmac_irq_hw {
         unsigned int    level;
 };
 
+/* Workaround flags for 32bit powermac machines */
+unsigned int of_irq_workarounds;
+struct device_node *of_irq_dflt_pic;
+
 /* Default addresses */
 static volatile struct pmac_irq_hw __iomem *pmac_irq_hw[4];
 
@@ -428,6 +432,42 @@ static void __init pmac_pic_probe_oldstyle(void)
 	setup_irq(irq_create_mapping(NULL, 20), &xmon_action);
 #endif
 }
+
+int of_irq_map_oldworld(struct device_node *device, int index,
+			struct of_irq *out_irq)
+{
+	const u32 *ints = NULL;
+	int intlen;
+
+	/*
+	 * Old machines just have a list of interrupt numbers
+	 * and no interrupt-controller nodes. We also have dodgy
+	 * cases where the APPL,interrupts property is completely
+	 * missing behind pci-pci bridges and we have to get it
+	 * from the parent (the bridge itself, as apple just wired
+	 * everything together on these)
+	 */
+	while (device) {
+		ints = of_get_property(device, "AAPL,interrupts", &intlen);
+		if (ints != NULL)
+			break;
+		device = device->parent;
+		if (device && strcmp(device->type, "pci") != 0)
+			break;
+	}
+	if (ints == NULL)
+		return -EINVAL;
+	intlen /= sizeof(u32);
+
+	if (index >= intlen)
+		return -EINVAL;
+
+	out_irq->controller = NULL;
+	out_irq->specifier[0] = ints[index];
+	out_irq->size = 1;
+
+	return 0;
+}
 #endif /* CONFIG_PPC32 */
 
 static void pmac_u3_cascade(unsigned int irq, struct irq_desc *desc)
@@ -559,19 +599,39 @@ static int __init pmac_pic_probe_mpic(void)
 
 void __init pmac_pic_init(void)
 {
-	unsigned int flags = 0;
-
 	/* We configure the OF parsing based on our oldworld vs. newworld
 	 * platform type and wether we were booted by BootX.
 	 */
 #ifdef CONFIG_PPC32
 	if (!pmac_newworld)
-		flags |= OF_IMAP_OLDWORLD_MAC;
+		of_irq_workarounds |= OF_IMAP_OLDWORLD_MAC;
 	if (of_get_property(of_chosen, "linux,bootx", NULL) != NULL)
-		flags |= OF_IMAP_NO_PHANDLE;
-#endif /* CONFIG_PPC_32 */
+		of_irq_workarounds |= OF_IMAP_NO_PHANDLE;
 
-	of_irq_map_init(flags);
+	/* If we don't have phandles on a newworld, then try to locate a
+	 * default interrupt controller (happens when booting with BootX).
+	 * We do a first match here, hopefully, that only ever happens on
+	 * machines with one controller.
+	 */
+	if (pmac_newworld && (of_irq_workarounds & OF_IMAP_NO_PHANDLE)) {
+		struct device_node *np;
+
+		for_each_node_with_property(np, "interrupt-controller") {
+			/* Skip /chosen/interrupt-controller */
+			if (strcmp(np->name, "chosen") == 0)
+				continue;
+			/* It seems like at least one person wants
+			 * to use BootX on a machine with an AppleKiwi
+			 * controller which happens to pretend to be an
+			 * interrupt controller too. */
+			if (strcmp(np->name, "AppleKiwi") == 0)
+				continue;
+			/* I think we found one ! */
+			of_irq_dflt_pic = np;
+			break;
+		}
+	}
+#endif /* CONFIG_PPC32 */
 
 	/* We first try to detect Apple's new Core99 chipset, since mac-io
 	 * is quite different on those machines and contains an IBM MPIC2.

