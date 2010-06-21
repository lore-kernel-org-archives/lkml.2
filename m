Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab0FUWc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 18:32:26 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55619 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab0FUWcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 18:32:23 -0400
Subject: [PATCH v2 4/5] of/irq: merge irq mapping code
To: microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
       linuxppc-dev@lists.ozlabs.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: sfr@canb.auug.org.au, monstr@monstr.eu, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
Date: Mon, 21 Jun 2010 16:32:18 -0600
Message-ID: <20100621223207.18925.46404.stgit@angua>
In-Reply-To: <20100621222052.18925.61569.stgit@angua>
References: <20100621222052.18925.61569.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge common irq mapping code between PowerPC and Microblaze.

This patch merges of_irq_find_parent(), of_irq_map_raw() and
of_irq_map_one().  The functions are dependent on one another, so all
three are merged in a single patch.  Other than cosmetic difference
(ie. DBG() vs. pr_debug()), the implementations are identical.

of_irq_to_resource() is also merged, but in this case the
implementations are different.  This patch drops the microblaze version
and uses the powerpc implementation unchanged.  The microblaze version
essentially open-coded irq_of_parse_and_map() which it does not need
to do.  Therefore the powerpc version is safe to adopt.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
CC: Michal Simek <monstr@monstr.eu>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/microblaze/include/asm/prom.h  |   31 ----
 arch/microblaze/kernel/prom_parse.c |  290 ----------------------------------
 arch/powerpc/include/asm/prom.h     |   47 -----
 arch/powerpc/kernel/prom_parse.c    |  266 -------------------------------
 drivers/of/irq.c                    |  301 +++++++++++++++++++++++++++++++++++
 include/linux/of_irq.h              |   29 +++
 6 files changed, 330 insertions(+), 634 deletions(-)

diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
index 4f34bc5..5fbdfe7 100644
--- a/arch/microblaze/include/asm/prom.h
+++ b/arch/microblaze/include/asm/prom.h
@@ -89,34 +89,6 @@ struct device_node *of_get_cpu_node(int cpu, unsigned int *thread);
 /* Get the MAC address */
 extern const void *of_get_mac_address(struct device_node *np);
 
-/*
- * OF interrupt mapping
- */
-
-#define OF_IMAP_OLDWORLD_MAC	0x00000001
-#define OF_IMAP_NO_PHANDLE	0x00000002
-
-/**
- * of_irq_map_raw - Low level interrupt tree parsing
- * @parent:	the device interrupt parent
- * @intspec:	interrupt specifier ("interrupts" property of the device)
- * @ointsize:	size of the passed in interrupt specifier
- * @addr:	address specifier (start of "reg" property of the device)
- * @out_irq:	structure of_irq filled by this function
- *
- * Returns 0 on success and a negative number on error
- *
- * This function is a low-level interrupt tree walking function. It
- * can be used to do a partial walk with synthetized reg and interrupts
- * properties, for example when resolving PCI interrupts when no device
- * node exist for the parent.
- *
- */
-
-extern int of_irq_map_raw(struct device_node *parent, const u32 *intspec,
-			u32 ointsize, const u32 *addr,
-			struct of_irq *out_irq);
-
 /**
  * of_irq_map_pci - Resolve the interrupt for a PCI device
  * @pdev:	the device whose interrupt is to be resolved
@@ -131,9 +103,6 @@ extern int of_irq_map_raw(struct device_node *parent, const u32 *intspec,
 struct pci_dev;
 extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
 
-extern int of_irq_to_resource(struct device_node *dev, int index,
-			struct resource *r);
-
 /**
  * of_iomap - Maps the memory mapped IO for a given device_node
  * @device:	the device whose io range will be mapped
diff --git a/arch/microblaze/kernel/prom_parse.c b/arch/microblaze/kernel/prom_parse.c
index cba0581..e28968f 100644
--- a/arch/microblaze/kernel/prom_parse.c
+++ b/arch/microblaze/kernel/prom_parse.c
@@ -644,267 +644,6 @@ void of_parse_dma_window(struct device_node *dn, const void *dma_window_prop,
 	*size = of_read_number(dma_window, cells);
 }
 
-/*
- * Interrupt remapper
- */
-
-static unsigned int of_irq_workarounds;
-static struct device_node *of_irq_dflt_pic;
-
-static struct device_node *of_irq_find_parent(struct device_node *child)
-{
-	struct device_node *p;
-	const phandle *parp;
-
-	if (!of_node_get(child))
-		return NULL;
-
-	do {
-		parp = of_get_property(child, "interrupt-parent", NULL);
-		if (parp == NULL)
-			p = of_get_parent(child);
-		else {
-			if (of_irq_workarounds & OF_IMAP_NO_PHANDLE)
-				p = of_node_get(of_irq_dflt_pic);
-			else
-				p = of_find_node_by_phandle(*parp);
-		}
-		of_node_put(child);
-		child = p;
-	} while (p && of_get_property(p, "#interrupt-cells", NULL) == NULL);
-
-	return p;
-}
-
-int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
-		const u32 *addr, struct of_irq *out_irq)
-{
-	struct device_node *ipar, *tnode, *old = NULL, *newpar = NULL;
-	const u32 *tmp, *imap, *imask;
-	u32 intsize = 1, addrsize, newintsize = 0, newaddrsize = 0;
-	int imaplen, match, i;
-
-	pr_debug("of_irq_map_raw: par=%s,intspec=[0x%08x 0x%08x...],"
-		"ointsize=%d\n",
-		parent->full_name, intspec[0], intspec[1], ointsize);
-
-	ipar = of_node_get(parent);
-
-	/* First get the #interrupt-cells property of the current cursor
-	 * that tells us how to interpret the passed-in intspec. If there
-	 * is none, we are nice and just walk up the tree
-	 */
-	do {
-		tmp = of_get_property(ipar, "#interrupt-cells", NULL);
-		if (tmp != NULL) {
-			intsize = *tmp;
-			break;
-		}
-		tnode = ipar;
-		ipar = of_irq_find_parent(ipar);
-		of_node_put(tnode);
-	} while (ipar);
-	if (ipar == NULL) {
-		pr_debug(" -> no parent found !\n");
-		goto fail;
-	}
-
-	pr_debug("of_irq_map_raw: ipar=%s, size=%d\n",
-			ipar->full_name, intsize);
-
-	if (ointsize != intsize)
-		return -EINVAL;
-
-	/* Look for this #address-cells. We have to implement the old linux
-	 * trick of looking for the parent here as some device-trees rely on it
-	 */
-	old = of_node_get(ipar);
-	do {
-		tmp = of_get_property(old, "#address-cells", NULL);
-		tnode = of_get_parent(old);
-		of_node_put(old);
-		old = tnode;
-	} while (old && tmp == NULL);
-	of_node_put(old);
-	old = NULL;
-	addrsize = (tmp == NULL) ? 2 : *tmp;
-
-	pr_debug(" -> addrsize=%d\n", addrsize);
-
-	/* Now start the actual "proper" walk of the interrupt tree */
-	while (ipar != NULL) {
-		/* Now check if cursor is an interrupt-controller and if it is
-		 * then we are done
-		 */
-		if (of_get_property(ipar, "interrupt-controller", NULL) !=
-				NULL) {
-			pr_debug(" -> got it !\n");
-			memcpy(out_irq->specifier, intspec,
-				intsize * sizeof(u32));
-			out_irq->size = intsize;
-			out_irq->controller = ipar;
-			of_node_put(old);
-			return 0;
-		}
-
-		/* Now look for an interrupt-map */
-		imap = of_get_property(ipar, "interrupt-map", &imaplen);
-		/* No interrupt map, check for an interrupt parent */
-		if (imap == NULL) {
-			pr_debug(" -> no map, getting parent\n");
-			newpar = of_irq_find_parent(ipar);
-			goto skiplevel;
-		}
-		imaplen /= sizeof(u32);
-
-		/* Look for a mask */
-		imask = of_get_property(ipar, "interrupt-map-mask", NULL);
-
-		/* If we were passed no "reg" property and we attempt to parse
-		 * an interrupt-map, then #address-cells must be 0.
-		 * Fail if it's not.
-		 */
-		if (addr == NULL && addrsize != 0) {
-			pr_debug(" -> no reg passed in when needed !\n");
-			goto fail;
-		}
-
-		/* Parse interrupt-map */
-		match = 0;
-		while (imaplen > (addrsize + intsize + 1) && !match) {
-			/* Compare specifiers */
-			match = 1;
-			for (i = 0; i < addrsize && match; ++i) {
-				u32 mask = imask ? imask[i] : 0xffffffffu;
-				match = ((addr[i] ^ imap[i]) & mask) == 0;
-			}
-			for (; i < (addrsize + intsize) && match; ++i) {
-				u32 mask = imask ? imask[i] : 0xffffffffu;
-				match =
-					((intspec[i-addrsize] ^ imap[i])
-						& mask) == 0;
-			}
-			imap += addrsize + intsize;
-			imaplen -= addrsize + intsize;
-
-			pr_debug(" -> match=%d (imaplen=%d)\n", match, imaplen);
-
-			/* Get the interrupt parent */
-			if (of_irq_workarounds & OF_IMAP_NO_PHANDLE)
-				newpar = of_node_get(of_irq_dflt_pic);
-			else
-				newpar =
-					of_find_node_by_phandle((phandle)*imap);
-			imap++;
-			--imaplen;
-
-			/* Check if not found */
-			if (newpar == NULL) {
-				pr_debug(" -> imap parent not found !\n");
-				goto fail;
-			}
-
-			/* Get #interrupt-cells and #address-cells of new
-			 * parent
-			 */
-			tmp = of_get_property(newpar, "#interrupt-cells", NULL);
-			if (tmp == NULL) {
-				pr_debug(" -> parent lacks "
-						"#interrupt-cells!\n");
-				goto fail;
-			}
-			newintsize = *tmp;
-			tmp = of_get_property(newpar, "#address-cells", NULL);
-			newaddrsize = (tmp == NULL) ? 0 : *tmp;
-
-			pr_debug(" -> newintsize=%d, newaddrsize=%d\n",
-				newintsize, newaddrsize);
-
-			/* Check for malformed properties */
-			if (imaplen < (newaddrsize + newintsize))
-				goto fail;
-
-			imap += newaddrsize + newintsize;
-			imaplen -= newaddrsize + newintsize;
-
-			pr_debug(" -> imaplen=%d\n", imaplen);
-		}
-		if (!match)
-			goto fail;
-
-		of_node_put(old);
-		old = of_node_get(newpar);
-		addrsize = newaddrsize;
-		intsize = newintsize;
-		intspec = imap - intsize;
-		addr = intspec - addrsize;
-
-skiplevel:
-		/* Iterate again with new parent */
-		pr_debug(" -> new parent: %s\n",
-				newpar ? newpar->full_name : "<>");
-		of_node_put(ipar);
-		ipar = newpar;
-		newpar = NULL;
-	}
-fail:
-	of_node_put(ipar);
-	of_node_put(old);
-	of_node_put(newpar);
-
-	return -EINVAL;
-}
-EXPORT_SYMBOL_GPL(of_irq_map_raw);
-
-int of_irq_map_one(struct device_node *device,
-			int index, struct of_irq *out_irq)
-{
-	struct device_node *p;
-	const u32 *intspec, *tmp, *addr;
-	u32 intsize, intlen;
-	int res;
-
-	pr_debug("of_irq_map_one: dev=%s, index=%d\n",
-			device->full_name, index);
-
-	/* Get the interrupts property */
-	intspec = of_get_property(device, "interrupts", (int *) &intlen);
-	if (intspec == NULL)
-		return -EINVAL;
-	intlen /= sizeof(u32);
-
-	pr_debug(" intspec=%d intlen=%d\n", *intspec, intlen);
-
-	/* Get the reg property (if any) */
-	addr = of_get_property(device, "reg", NULL);
-
-	/* Look for the interrupt parent. */
-	p = of_irq_find_parent(device);
-	if (p == NULL)
-		return -EINVAL;
-
-	/* Get size of interrupt specifier */
-	tmp = of_get_property(p, "#interrupt-cells", NULL);
-	if (tmp == NULL) {
-		of_node_put(p);
-		return -EINVAL;
-	}
-	intsize = *tmp;
-
-	pr_debug(" intsize=%d intlen=%d\n", intsize, intlen);
-
-	/* Check index */
-	if ((index + 1) * intsize > intlen)
-		return -EINVAL;
-
-	/* Get new specifier and map it */
-	res = of_irq_map_raw(p, intspec + index * intsize, intsize,
-				addr, out_irq);
-	of_node_put(p);
-	return res;
-}
-EXPORT_SYMBOL_GPL(of_irq_map_one);
-
 /**
  * Search the device tree for the best MAC address to use.  'mac-address' is
  * checked first, because that is supposed to contain to "most recent" MAC
@@ -943,35 +682,6 @@ const void *of_get_mac_address(struct device_node *np)
 }
 EXPORT_SYMBOL(of_get_mac_address);
 
-int of_irq_to_resource(struct device_node *dev, int index, struct resource *r)
-{
-	struct of_irq out_irq;
-	int irq;
-	int res;
-
-	res = of_irq_map_one(dev, index, &out_irq);
-
-	/* Get irq for the device */
-	if (res) {
-		pr_debug("IRQ not found... code = %d", res);
-		return NO_IRQ;
-	}
-	/* Assuming single interrupt controller... */
-	irq = out_irq.specifier[0];
-
-	pr_debug("IRQ found = %d", irq);
-
-	/* Only dereference the resource if both the
-	 * resource and the irq are valid. */
-	if (r && irq != NO_IRQ) {
-		r->start = r->end = irq;
-		r->flags = IORESOURCE_IRQ;
-	}
-
-	return irq;
-}
-EXPORT_SYMBOL_GPL(of_irq_to_resource);
-
 void __iomem *of_iomap(struct device_node *np, int index)
 {
 	struct resource res;
diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
index 4486765..10d5ee5 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -105,50 +105,6 @@ struct device_node *of_find_next_cache_node(struct device_node *np);
 /* Get the MAC address */
 extern const void *of_get_mac_address(struct device_node *np);
 
-/*
- * OF interrupt mapping
- */
-
-#define OF_IMAP_OLDWORLD_MAC	0x00000001
-#define OF_IMAP_NO_PHANDLE	0x00000002
-
-#if defined(CONFIG_PPC32) && defined(CONFIG_PPC_PMAC)
-/* Workarounds only needed for 32bit powermac machines */
-extern unsigned int of_irq_workarounds;
-extern struct device_node *of_irq_dflt_pic;
-extern int of_irq_map_oldworld(struct device_node *device, int index,
-			       struct of_irq *out_irq);
-#else
-#define of_irq_workarounds (0)
-#define of_irq_dflt_pic (NULL)
-static inline int of_irq_map_oldworld(struct device_node *device, int index,
-				      struct of_irq *out_irq)
-{
-	return -EINVAL;
-}
-#endif
-
-/**
- * of_irq_map_raw - Low level interrupt tree parsing
- * @parent:	the device interrupt parent
- * @intspec:	interrupt specifier ("interrupts" property of the device)
- * @ointsize:   size of the passed in interrupt specifier
- * @addr:	address specifier (start of "reg" property of the device)
- * @out_irq:	structure of_irq filled by this function
- *
- * Returns 0 on success and a negative number on error
- *
- * This function is a low-level interrupt tree walking function. It
- * can be used to do a partial walk with synthetized reg and interrupts
- * properties, for example when resolving PCI interrupts when no device
- * node exist for the parent.
- *
- */
-
-extern int of_irq_map_raw(struct device_node *parent, const u32 *intspec,
-			  u32 ointsize, const u32 *addr,
-			  struct of_irq *out_irq);
-
 /**
  * of_irq_map_pci - Resolve the interrupt for a PCI device
  * @pdev:	the device whose interrupt is to be resolved
@@ -163,9 +119,6 @@ extern int of_irq_map_raw(struct device_node *parent, const u32 *intspec,
 struct pci_dev;
 extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
 
-extern int of_irq_to_resource(struct device_node *dev, int index,
-			struct resource *r);
-
 /**
  * of_iomap - Maps the memory mapped IO for a given device_node
  * @device:	the device whose io range will be mapped
diff --git a/arch/powerpc/kernel/prom_parse.c b/arch/powerpc/kernel/prom_parse.c
index dfa6de6..d61a5c5 100644
--- a/arch/powerpc/kernel/prom_parse.c
+++ b/arch/powerpc/kernel/prom_parse.c
@@ -678,257 +678,6 @@ void of_parse_dma_window(struct device_node *dn, const void *dma_window_prop,
 	*size = of_read_number(dma_window, cells);
 }
 
-/*
- * Interrupt remapper
- */
-
-static struct device_node *of_irq_find_parent(struct device_node *child)
-{
-	struct device_node *p;
-	const phandle *parp;
-
-	if (!of_node_get(child))
-		return NULL;
-
-	do {
-		parp = of_get_property(child, "interrupt-parent", NULL);
-		if (parp == NULL)
-			p = of_get_parent(child);
-		else {
-			if (of_irq_workarounds & OF_IMAP_NO_PHANDLE)
-				p = of_node_get(of_irq_dflt_pic);
-			else
-				p = of_find_node_by_phandle(*parp);
-		}
-		of_node_put(child);
-		child = p;
-	} while (p && of_get_property(p, "#interrupt-cells", NULL) == NULL);
-
-	return p;
-}
-
-int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
-		const u32 *addr, struct of_irq *out_irq)
-{
-	struct device_node *ipar, *tnode, *old = NULL, *newpar = NULL;
-	const u32 *tmp, *imap, *imask;
-	u32 intsize = 1, addrsize, newintsize = 0, newaddrsize = 0;
-	int imaplen, match, i;
-
-	DBG("of_irq_map_raw: par=%s,intspec=[0x%08x 0x%08x...],ointsize=%d\n",
-	    parent->full_name, intspec[0], intspec[1], ointsize);
-
-	ipar = of_node_get(parent);
-
-	/* First get the #interrupt-cells property of the current cursor
-	 * that tells us how to interpret the passed-in intspec. If there
-	 * is none, we are nice and just walk up the tree
-	 */
-	do {
-		tmp = of_get_property(ipar, "#interrupt-cells", NULL);
-		if (tmp != NULL) {
-			intsize = *tmp;
-			break;
-		}
-		tnode = ipar;
-		ipar = of_irq_find_parent(ipar);
-		of_node_put(tnode);
-	} while (ipar);
-	if (ipar == NULL) {
-		DBG(" -> no parent found !\n");
-		goto fail;
-	}
-
-	DBG("of_irq_map_raw: ipar=%s, size=%d\n", ipar->full_name, intsize);
-
-	if (ointsize != intsize)
-		return -EINVAL;
-
-	/* Look for this #address-cells. We have to implement the old linux
-	 * trick of looking for the parent here as some device-trees rely on it
-	 */
-	old = of_node_get(ipar);
-	do {
-		tmp = of_get_property(old, "#address-cells", NULL);
-		tnode = of_get_parent(old);
-		of_node_put(old);
-		old = tnode;
-	} while(old && tmp == NULL);
-	of_node_put(old);
-	old = NULL;
-	addrsize = (tmp == NULL) ? 2 : *tmp;
-
-	DBG(" -> addrsize=%d\n", addrsize);
-
-	/* Now start the actual "proper" walk of the interrupt tree */
-	while (ipar != NULL) {
-		/* Now check if cursor is an interrupt-controller and if it is
-		 * then we are done
-		 */
-		if (of_get_property(ipar, "interrupt-controller", NULL) !=
-				NULL) {
-			DBG(" -> got it !\n");
-			memcpy(out_irq->specifier, intspec,
-			       intsize * sizeof(u32));
-			out_irq->size = intsize;
-			out_irq->controller = ipar;
-			of_node_put(old);
-			return 0;
-		}
-
-		/* Now look for an interrupt-map */
-		imap = of_get_property(ipar, "interrupt-map", &imaplen);
-		/* No interrupt map, check for an interrupt parent */
-		if (imap == NULL) {
-			DBG(" -> no map, getting parent\n");
-			newpar = of_irq_find_parent(ipar);
-			goto skiplevel;
-		}
-		imaplen /= sizeof(u32);
-
-		/* Look for a mask */
-		imask = of_get_property(ipar, "interrupt-map-mask", NULL);
-
-		/* If we were passed no "reg" property and we attempt to parse
-		 * an interrupt-map, then #address-cells must be 0.
-		 * Fail if it's not.
-		 */
-		if (addr == NULL && addrsize != 0) {
-			DBG(" -> no reg passed in when needed !\n");
-			goto fail;
-		}
-
-		/* Parse interrupt-map */
-		match = 0;
-		while (imaplen > (addrsize + intsize + 1) && !match) {
-			/* Compare specifiers */
-			match = 1;
-			for (i = 0; i < addrsize && match; ++i) {
-				u32 mask = imask ? imask[i] : 0xffffffffu;
-				match = ((addr[i] ^ imap[i]) & mask) == 0;
-			}
-			for (; i < (addrsize + intsize) && match; ++i) {
-				u32 mask = imask ? imask[i] : 0xffffffffu;
-				match =
-				   ((intspec[i-addrsize] ^ imap[i]) & mask) == 0;
-			}
-			imap += addrsize + intsize;
-			imaplen -= addrsize + intsize;
-
-			DBG(" -> match=%d (imaplen=%d)\n", match, imaplen);
-
-			/* Get the interrupt parent */
-			if (of_irq_workarounds & OF_IMAP_NO_PHANDLE)
-				newpar = of_node_get(of_irq_dflt_pic);
-			else
-				newpar = of_find_node_by_phandle((phandle)*imap);
-			imap++;
-			--imaplen;
-
-			/* Check if not found */
-			if (newpar == NULL) {
-				DBG(" -> imap parent not found !\n");
-				goto fail;
-			}
-
-			/* Get #interrupt-cells and #address-cells of new
-			 * parent
-			 */
-			tmp = of_get_property(newpar, "#interrupt-cells", NULL);
-			if (tmp == NULL) {
-				DBG(" -> parent lacks #interrupt-cells !\n");
-				goto fail;
-			}
-			newintsize = *tmp;
-			tmp = of_get_property(newpar, "#address-cells", NULL);
-			newaddrsize = (tmp == NULL) ? 0 : *tmp;
-
-			DBG(" -> newintsize=%d, newaddrsize=%d\n",
-			    newintsize, newaddrsize);
-
-			/* Check for malformed properties */
-			if (imaplen < (newaddrsize + newintsize))
-				goto fail;
-
-			imap += newaddrsize + newintsize;
-			imaplen -= newaddrsize + newintsize;
-
-			DBG(" -> imaplen=%d\n", imaplen);
-		}
-		if (!match)
-			goto fail;
-
-		of_node_put(old);
-		old = of_node_get(newpar);
-		addrsize = newaddrsize;
-		intsize = newintsize;
-		intspec = imap - intsize;
-		addr = intspec - addrsize;
-
-	skiplevel:
-		/* Iterate again with new parent */
-		DBG(" -> new parent: %s\n", newpar ? newpar->full_name : "<>");
-		of_node_put(ipar);
-		ipar = newpar;
-		newpar = NULL;
-	}
- fail:
-	of_node_put(ipar);
-	of_node_put(old);
-	of_node_put(newpar);
-
-	return -EINVAL;
-}
-EXPORT_SYMBOL_GPL(of_irq_map_raw);
-
-int of_irq_map_one(struct device_node *device, int index, struct of_irq *out_irq)
-{
-	struct device_node *p;
-	const u32 *intspec, *tmp, *addr;
-	u32 intsize, intlen;
-	int res = -EINVAL;
-
-	DBG("of_irq_map_one: dev=%s, index=%d\n", device->full_name, index);
-
-	/* OldWorld mac stuff is "special", handle out of line */
-	if (of_irq_workarounds & OF_IMAP_OLDWORLD_MAC)
-		return of_irq_map_oldworld(device, index, out_irq);
-
-	/* Get the interrupts property */
-	intspec = of_get_property(device, "interrupts", &intlen);
-	if (intspec == NULL)
-		return -EINVAL;
-	intlen /= sizeof(u32);
-
-	/* Get the reg property (if any) */
-	addr = of_get_property(device, "reg", NULL);
-
-	/* Look for the interrupt parent. */
-	p = of_irq_find_parent(device);
-	if (p == NULL)
-		return -EINVAL;
-
-	/* Get size of interrupt specifier */
-	tmp = of_get_property(p, "#interrupt-cells", NULL);
-	if (tmp == NULL)
-		goto out;
-	intsize = *tmp;
-
-	DBG(" intsize=%d intlen=%d\n", intsize, intlen);
-
-	/* Check index */
-	if ((index + 1) * intsize > intlen)
-		goto out;
-
-	/* Get new specifier and map it */
-	res = of_irq_map_raw(p, intspec + index * intsize, intsize,
-			     addr, out_irq);
-out:
-	of_node_put(p);
-	return res;
-}
-EXPORT_SYMBOL_GPL(of_irq_map_one);
-
 /**
  * Search the device tree for the best MAC address to use.  'mac-address' is
  * checked first, because that is supposed to contain to "most recent" MAC
@@ -967,21 +716,6 @@ const void *of_get_mac_address(struct device_node *np)
 }
 EXPORT_SYMBOL(of_get_mac_address);
 
-int of_irq_to_resource(struct device_node *dev, int index, struct resource *r)
-{
-	int irq = irq_of_parse_and_map(dev, index);
-
-	/* Only dereference the resource if both the
-	 * resource and the irq are valid. */
-	if (r && irq != NO_IRQ) {
-		r->start = r->end = irq;
-		r->flags = IORESOURCE_IRQ;
-	}
-
-	return irq;
-}
-EXPORT_SYMBOL_GPL(of_irq_to_resource);
-
 void __iomem *of_iomap(struct device_node *np, int index)
 {
 	struct resource res;
diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 56ad1aa..0b0518f 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -35,3 +35,304 @@ unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
 				     oirq.size);
 }
 EXPORT_SYMBOL_GPL(irq_of_parse_and_map);
+
+/**
+ * of_irq_find_parent - Given a device node, find its interrupt parent node
+ * @child: pointer to device node
+ *
+ * Returns a pointer to the interrupt parent node, or NULL if the interrupt
+ * parent could not be determined.
+ */
+static struct device_node *of_irq_find_parent(struct device_node *child)
+{
+	struct device_node *p;
+	const phandle *parp;
+
+	if (!of_node_get(child))
+		return NULL;
+
+	do {
+		parp = of_get_property(child, "interrupt-parent", NULL);
+		if (parp == NULL)
+			p = of_get_parent(child);
+		else {
+			if (of_irq_workarounds & OF_IMAP_NO_PHANDLE)
+				p = of_node_get(of_irq_dflt_pic);
+			else
+				p = of_find_node_by_phandle(*parp);
+		}
+		of_node_put(child);
+		child = p;
+	} while (p && of_get_property(p, "#interrupt-cells", NULL) == NULL);
+
+	return p;
+}
+
+/**
+ * of_irq_map_raw - Low level interrupt tree parsing
+ * @parent:	the device interrupt parent
+ * @intspec:	interrupt specifier ("interrupts" property of the device)
+ * @ointsize:   size of the passed in interrupt specifier
+ * @addr:	address specifier (start of "reg" property of the device)
+ * @out_irq:	structure of_irq filled by this function
+ *
+ * Returns 0 on success and a negative number on error
+ *
+ * This function is a low-level interrupt tree walking function. It
+ * can be used to do a partial walk with synthetized reg and interrupts
+ * properties, for example when resolving PCI interrupts when no device
+ * node exist for the parent.
+ */
+int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
+		const u32 *addr, struct of_irq *out_irq)
+{
+	struct device_node *ipar, *tnode, *old = NULL, *newpar = NULL;
+	const u32 *tmp, *imap, *imask;
+	u32 intsize = 1, addrsize, newintsize = 0, newaddrsize = 0;
+	int imaplen, match, i;
+
+	pr_debug("of_irq_map_raw: par=%s,intspec=[0x%08x 0x%08x...],ointsize=%d\n",
+	    parent->full_name, intspec[0], intspec[1], ointsize);
+
+	ipar = of_node_get(parent);
+
+	/* First get the #interrupt-cells property of the current cursor
+	 * that tells us how to interpret the passed-in intspec. If there
+	 * is none, we are nice and just walk up the tree
+	 */
+	do {
+		tmp = of_get_property(ipar, "#interrupt-cells", NULL);
+		if (tmp != NULL) {
+			intsize = *tmp;
+			break;
+		}
+		tnode = ipar;
+		ipar = of_irq_find_parent(ipar);
+		of_node_put(tnode);
+	} while (ipar);
+	if (ipar == NULL) {
+		pr_debug(" -> no parent found !\n");
+		goto fail;
+	}
+
+	pr_debug("of_irq_map_raw: ipar=%s, size=%d\n", ipar->full_name, intsize);
+
+	if (ointsize != intsize)
+		return -EINVAL;
+
+	/* Look for this #address-cells. We have to implement the old linux
+	 * trick of looking for the parent here as some device-trees rely on it
+	 */
+	old = of_node_get(ipar);
+	do {
+		tmp = of_get_property(old, "#address-cells", NULL);
+		tnode = of_get_parent(old);
+		of_node_put(old);
+		old = tnode;
+	} while (old && tmp == NULL);
+	of_node_put(old);
+	old = NULL;
+	addrsize = (tmp == NULL) ? 2 : *tmp;
+
+	pr_debug(" -> addrsize=%d\n", addrsize);
+
+	/* Now start the actual "proper" walk of the interrupt tree */
+	while (ipar != NULL) {
+		/* Now check if cursor is an interrupt-controller and if it is
+		 * then we are done
+		 */
+		if (of_get_property(ipar, "interrupt-controller", NULL) !=
+				NULL) {
+			pr_debug(" -> got it !\n");
+			memcpy(out_irq->specifier, intspec,
+			       intsize * sizeof(u32));
+			out_irq->size = intsize;
+			out_irq->controller = ipar;
+			of_node_put(old);
+			return 0;
+		}
+
+		/* Now look for an interrupt-map */
+		imap = of_get_property(ipar, "interrupt-map", &imaplen);
+		/* No interrupt map, check for an interrupt parent */
+		if (imap == NULL) {
+			pr_debug(" -> no map, getting parent\n");
+			newpar = of_irq_find_parent(ipar);
+			goto skiplevel;
+		}
+		imaplen /= sizeof(u32);
+
+		/* Look for a mask */
+		imask = of_get_property(ipar, "interrupt-map-mask", NULL);
+
+		/* If we were passed no "reg" property and we attempt to parse
+		 * an interrupt-map, then #address-cells must be 0.
+		 * Fail if it's not.
+		 */
+		if (addr == NULL && addrsize != 0) {
+			pr_debug(" -> no reg passed in when needed !\n");
+			goto fail;
+		}
+
+		/* Parse interrupt-map */
+		match = 0;
+		while (imaplen > (addrsize + intsize + 1) && !match) {
+			/* Compare specifiers */
+			match = 1;
+			for (i = 0; i < addrsize && match; ++i) {
+				u32 mask = imask ? imask[i] : 0xffffffffu;
+				match = ((addr[i] ^ imap[i]) & mask) == 0;
+			}
+			for (; i < (addrsize + intsize) && match; ++i) {
+				u32 mask = imask ? imask[i] : 0xffffffffu;
+				match =
+				   ((intspec[i-addrsize] ^ imap[i]) & mask) == 0;
+			}
+			imap += addrsize + intsize;
+			imaplen -= addrsize + intsize;
+
+			pr_debug(" -> match=%d (imaplen=%d)\n", match, imaplen);
+
+			/* Get the interrupt parent */
+			if (of_irq_workarounds & OF_IMAP_NO_PHANDLE)
+				newpar = of_node_get(of_irq_dflt_pic);
+			else
+				newpar = of_find_node_by_phandle((phandle)*imap);
+			imap++;
+			--imaplen;
+
+			/* Check if not found */
+			if (newpar == NULL) {
+				pr_debug(" -> imap parent not found !\n");
+				goto fail;
+			}
+
+			/* Get #interrupt-cells and #address-cells of new
+			 * parent
+			 */
+			tmp = of_get_property(newpar, "#interrupt-cells", NULL);
+			if (tmp == NULL) {
+				pr_debug(" -> parent lacks #interrupt-cells!\n");
+				goto fail;
+			}
+			newintsize = *tmp;
+			tmp = of_get_property(newpar, "#address-cells", NULL);
+			newaddrsize = (tmp == NULL) ? 0 : *tmp;
+
+			pr_debug(" -> newintsize=%d, newaddrsize=%d\n",
+			    newintsize, newaddrsize);
+
+			/* Check for malformed properties */
+			if (imaplen < (newaddrsize + newintsize))
+				goto fail;
+
+			imap += newaddrsize + newintsize;
+			imaplen -= newaddrsize + newintsize;
+
+			pr_debug(" -> imaplen=%d\n", imaplen);
+		}
+		if (!match)
+			goto fail;
+
+		of_node_put(old);
+		old = of_node_get(newpar);
+		addrsize = newaddrsize;
+		intsize = newintsize;
+		intspec = imap - intsize;
+		addr = intspec - addrsize;
+
+	skiplevel:
+		/* Iterate again with new parent */
+		pr_debug(" -> new parent: %s\n", newpar ? newpar->full_name : "<>");
+		of_node_put(ipar);
+		ipar = newpar;
+		newpar = NULL;
+	}
+ fail:
+	of_node_put(ipar);
+	of_node_put(old);
+	of_node_put(newpar);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(of_irq_map_raw);
+
+/**
+ * of_irq_map_one - Resolve an interrupt for a device
+ * @device: the device whose interrupt is to be resolved
+ * @index: index of the interrupt to resolve
+ * @out_irq: structure of_irq filled by this function
+ *
+ * This function resolves an interrupt, walking the tree, for a given
+ * device-tree node. It's the high level pendant to of_irq_map_raw().
+ */
+int of_irq_map_one(struct device_node *device, int index, struct of_irq *out_irq)
+{
+	struct device_node *p;
+	const u32 *intspec, *tmp, *addr;
+	u32 intsize, intlen;
+	int res = -EINVAL;
+
+	pr_debug("of_irq_map_one: dev=%s, index=%d\n", device->full_name, index);
+
+	/* OldWorld mac stuff is "special", handle out of line */
+	if (of_irq_workarounds & OF_IMAP_OLDWORLD_MAC)
+		return of_irq_map_oldworld(device, index, out_irq);
+
+	/* Get the interrupts property */
+	intspec = of_get_property(device, "interrupts", &intlen);
+	if (intspec == NULL)
+		return -EINVAL;
+	intlen /= sizeof(u32);
+
+	pr_debug(" intspec=%d intlen=%d\n", *intspec, intlen);
+
+	/* Get the reg property (if any) */
+	addr = of_get_property(device, "reg", NULL);
+
+	/* Look for the interrupt parent. */
+	p = of_irq_find_parent(device);
+	if (p == NULL)
+		return -EINVAL;
+
+	/* Get size of interrupt specifier */
+	tmp = of_get_property(p, "#interrupt-cells", NULL);
+	if (tmp == NULL)
+		goto out;
+	intsize = *tmp;
+
+	pr_debug(" intsize=%d intlen=%d\n", intsize, intlen);
+
+	/* Check index */
+	if ((index + 1) * intsize > intlen)
+		goto out;
+
+	/* Get new specifier and map it */
+	res = of_irq_map_raw(p, intspec + index * intsize, intsize,
+			     addr, out_irq);
+ out:
+	of_node_put(p);
+	return res;
+}
+EXPORT_SYMBOL_GPL(of_irq_map_one);
+
+/**
+ * of_irq_to_resource - Decode a node's IRQ and return it as a resource
+ * @dev: pointer to device tree node
+ * @index: zero-based index of the irq
+ * @r: pointer to resource structure to return result into.
+ */
+int of_irq_to_resource(struct device_node *dev, int index, struct resource *r)
+{
+	int irq = irq_of_parse_and_map(dev, index);
+
+	/* Only dereference the resource if both the
+	 * resource and the irq are valid. */
+	if (r && irq != NO_IRQ) {
+		r->start = r->end = irq;
+		r->flags = IORESOURCE_IRQ;
+	}
+
+	return irq;
+}
+EXPORT_SYMBOL_GPL(of_irq_to_resource);
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index 0e37c05..5929781 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -4,6 +4,8 @@
 #if defined(CONFIG_OF)
 struct of_irq;
 #include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/ioport.h>
 #include <linux/of.h>
 
 /*
@@ -30,11 +32,38 @@ struct of_irq {
 	u32 specifier[OF_MAX_IRQ_SPEC]; /* Specifier copy */
 };
 
+/*
+ * Workarounds only applied to 32bit powermac machines
+ */
+#define OF_IMAP_OLDWORLD_MAC	0x00000001
+#define OF_IMAP_NO_PHANDLE	0x00000002
+
+#if defined(CONFIG_PPC32) && defined(CONFIG_PPC_PMAC)
+extern unsigned int of_irq_workarounds;
+extern struct device_node *of_irq_dflt_pic;
+extern int of_irq_map_oldworld(struct device_node *device, int index,
+			       struct of_irq *out_irq);
+#else /* CONFIG_PPC32 && CONFIG_PPC_PMAC */
+#define of_irq_workarounds (0)
+#define of_irq_dflt_pic (NULL)
+static inline int of_irq_map_oldworld(struct device_node *device, int index,
+				      struct of_irq *out_irq)
+{
+	return -EINVAL;
+}
+#endif /* CONFIG_PPC32 && CONFIG_PPC_PMAC */
+
+
+extern int of_irq_map_raw(struct device_node *parent, const u32 *intspec,
+			  u32 ointsize, const u32 *addr,
+			  struct of_irq *out_irq);
 extern int of_irq_map_one(struct device_node *device, int index,
 			  struct of_irq *out_irq);
 extern unsigned int irq_create_of_mapping(struct device_node *controller,
 					  const u32 *intspec,
 					  unsigned int intsize);
+extern int of_irq_to_resource(struct device_node *dev, int index,
+			      struct resource *r);
 
 #endif /* CONFIG_OF_IRQ */
 #endif /* CONFIG_OF */

