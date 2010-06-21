Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab0FUWcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 18:32:35 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55619 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab0FUWca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 18:32:30 -0400
Subject: [PATCH v2 5/5] of/irq: little endian fixes
To: microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
       linuxppc-dev@lists.ozlabs.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: sfr@canb.auug.org.au, monstr@monstr.eu, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
Date: Mon, 21 Jun 2010 16:32:25 -0600
Message-ID: <20100621223223.18925.66253.stgit@angua>
In-Reply-To: <20100621222052.18925.61569.stgit@angua>
References: <20100621222052.18925.61569.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <r.herring@freescale.com>

Fix some endian issues in the irq mapping OF code.

Signed-off-by: Rob Herring <r.herring@freescale.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
CC: Michal Simek <monstr@monstr.eu>
CC: Wolfram Sang <w.sang@pengutronix.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 drivers/of/irq.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 0b0518f..b68a924 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -87,7 +87,7 @@ int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
 		const u32 *addr, struct of_irq *out_irq)
 {
 	struct device_node *ipar, *tnode, *old = NULL, *newpar = NULL;
-	const u32 *tmp, *imap, *imask;
+	const __be32 *tmp, *imap, *imask;
 	u32 intsize = 1, addrsize, newintsize = 0, newaddrsize = 0;
 	int imaplen, match, i;
 
@@ -103,7 +103,7 @@ int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
 	do {
 		tmp = of_get_property(ipar, "#interrupt-cells", NULL);
 		if (tmp != NULL) {
-			intsize = *tmp;
+			intsize = be32_to_cpu(*tmp);
 			break;
 		}
 		tnode = ipar;
@@ -132,7 +132,7 @@ int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
 	} while (old && tmp == NULL);
 	of_node_put(old);
 	old = NULL;
-	addrsize = (tmp == NULL) ? 2 : *tmp;
+	addrsize = (tmp == NULL) ? 2 : be32_to_cpu(*tmp);
 
 	pr_debug(" -> addrsize=%d\n", addrsize);
 
@@ -144,8 +144,9 @@ int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
 		if (of_get_property(ipar, "interrupt-controller", NULL) !=
 				NULL) {
 			pr_debug(" -> got it !\n");
-			memcpy(out_irq->specifier, intspec,
-			       intsize * sizeof(u32));
+			for (i = 0; i < intsize; i++)
+				out_irq->specifier[i] =
+						of_read_number(intspec +i, 1);
 			out_irq->size = intsize;
 			out_irq->controller = ipar;
 			of_node_put(old);
@@ -215,9 +216,9 @@ int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
 				pr_debug(" -> parent lacks #interrupt-cells!\n");
 				goto fail;
 			}
-			newintsize = *tmp;
+			newintsize = be32_to_cpu(*tmp);
 			tmp = of_get_property(newpar, "#address-cells", NULL);
-			newaddrsize = (tmp == NULL) ? 0 : *tmp;
+			newaddrsize = (tmp == NULL) ? 0 : be32_to_cpu(*tmp);
 
 			pr_debug(" -> newintsize=%d, newaddrsize=%d\n",
 			    newintsize, newaddrsize);
@@ -299,7 +300,7 @@ int of_irq_map_one(struct device_node *device, int index, struct of_irq *out_irq
 	tmp = of_get_property(p, "#interrupt-cells", NULL);
 	if (tmp == NULL)
 		goto out;
-	intsize = *tmp;
+	intsize = be32_to_cpu(*tmp);
 
 	pr_debug(" intsize=%d intlen=%d\n", intsize, intlen);
 

