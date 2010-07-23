Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101Ab0GWXFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 19:05:30 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41692 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962Ab0GWXF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 19:05:28 -0400
Subject: [PATCH v2 2/2] of/irq: Fix endian issues in parsing interrupt
	specifiers
To: devicetree-discuss@lists.ozlabs.org, jeremy.kerr@canonical.com,
        linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 23 Jul 2010 17:05:25 -0600
Message-ID: <20100723230514.28579.65527.stgit@angua>
In-Reply-To: <20100723230437.28579.19577.stgit@angua>
References: <20100723230437.28579.19577.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some instances where interrupt specifiers are
dereferenced directly instead of doing a be32_to_cpu() conversion first.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/of/irq.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 65cfae1..2d14eac 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -91,8 +91,8 @@ static struct device_node *of_irq_find_parent(struct device_node *child)
  * properties, for example when resolving PCI interrupts when no device
  * node exist for the parent.
  */
-int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
-		const u32 *addr, struct of_irq *out_irq)
+int of_irq_map_raw(struct device_node *parent, const __be32 *intspec,
+		   u32 ointsize, const __be32 *addr, struct of_irq *out_irq)
 {
 	struct device_node *ipar, *tnode, *old = NULL, *newpar = NULL;
 	const __be32 *tmp, *imap, *imask;
@@ -100,7 +100,8 @@ int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
 	int imaplen, match, i;
 
 	pr_debug("of_irq_map_raw: par=%s,intspec=[0x%08x 0x%08x...],ointsize=%d\n",
-	    parent->full_name, intspec[0], intspec[1], ointsize);
+		 parent->full_name, be32_to_cpup(intspec),
+		 be32_to_cpu(intspec + 1), ointsize);
 
 	ipar = of_node_get(parent);
 
@@ -278,7 +279,7 @@ EXPORT_SYMBOL_GPL(of_irq_map_raw);
 int of_irq_map_one(struct device_node *device, int index, struct of_irq *out_irq)
 {
 	struct device_node *p;
-	const u32 *intspec, *tmp, *addr;
+	const __be32 *intspec, *tmp, *addr;
 	u32 intsize, intlen;
 	int res = -EINVAL;
 
@@ -292,9 +293,9 @@ int of_irq_map_one(struct device_node *device, int index, struct of_irq *out_irq
 	intspec = of_get_property(device, "interrupts", &intlen);
 	if (intspec == NULL)
 		return -EINVAL;
-	intlen /= sizeof(u32);
+	intlen /= sizeof(*intspec);
 
-	pr_debug(" intspec=%d intlen=%d\n", *intspec, intlen);
+	pr_debug(" intspec=%d intlen=%d\n", be32_to_cpup(intspec), intlen);
 
 	/* Get the reg property (if any) */
 	addr = of_get_property(device, "reg", NULL);

