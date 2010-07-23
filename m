Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703Ab0GWXFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 19:05:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53243 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab0GWXFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 19:05:12 -0400
Subject: [PATCH v2 1/2] of: Fix phandle endian issues
To: devicetree-discuss@lists.ozlabs.org, jeremy.kerr@canonical.com,
        linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 23 Jul 2010 17:05:09 -0600
Message-ID: <20100723230437.28579.19577.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flat tree code wasn't fixing the endianness on phandle values when
unflattening the tree, and the code in drivers/of wasn't always doing a
be32_to_cpu before trying to dereference the phandle values.  This patch
fixes them.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
changed in v2: fixed up reference in drivers/of/irq.c too

 drivers/of/base.c |   12 ++++++------
 drivers/of/fdt.c  |    4 ++--
 drivers/of/irq.c  |    6 +++---
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index e3f7af8..aa80525 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -605,14 +605,14 @@ EXPORT_SYMBOL(of_find_node_by_phandle);
 struct device_node *
 of_parse_phandle(struct device_node *np, const char *phandle_name, int index)
 {
-	const phandle *phandle;
+	const __be32 *phandle;
 	int size;
 
 	phandle = of_get_property(np, phandle_name, &size);
 	if ((!phandle) || (size < sizeof(*phandle) * (index + 1)))
 		return NULL;
 
-	return of_find_node_by_phandle(phandle[index]);
+	return of_find_node_by_phandle(be32_to_cpup(phandle + index));
 }
 EXPORT_SYMBOL(of_parse_phandle);
 
@@ -668,16 +668,16 @@ int of_parse_phandles_with_args(struct device_node *np, const char *list_name,
 
 	while (list < list_end) {
 		const __be32 *cells;
-		const phandle *phandle;
+		phandle phandle;
 
-		phandle = list++;
+		phandle = be32_to_cpup(list++);
 		args = list;
 
 		/* one cell hole in the list = <>; */
-		if (!*phandle)
+		if (!phandle)
 			goto next;
 
-		node = of_find_node_by_phandle(*phandle);
+		node = of_find_node_by_phandle(phandle);
 		if (!node) {
 			pr_debug("%s: could not find phandle\n",
 				 np->full_name);
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index d61fda8..f3a7b4f 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -320,13 +320,13 @@ unsigned long __init unflatten_dt_node(unsigned long mem,
 			if ((strcmp(pname, "phandle") == 0) ||
 			    (strcmp(pname, "linux,phandle") == 0)) {
 				if (np->phandle == 0)
-					np->phandle = *((u32 *)*p);
+					np->phandle = be32_to_cpup((__be32*)*p);
 			}
 			/* And we process the "ibm,phandle" property
 			 * used in pSeries dynamic device tree
 			 * stuff */
 			if (strcmp(pname, "ibm,phandle") == 0)
-				np->phandle = *((u32 *)*p);
+				np->phandle = be32_to_cpup((__be32 *)*p);
 			pp->name = pname;
 			pp->length = sz;
 			pp->value = (void *)*p;
diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 6cfb307..65cfae1 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -54,7 +54,7 @@ EXPORT_SYMBOL_GPL(irq_of_parse_and_map);
 static struct device_node *of_irq_find_parent(struct device_node *child)
 {
 	struct device_node *p;
-	const phandle *parp;
+	const __be32 *parp;
 
 	if (!of_node_get(child))
 		return NULL;
@@ -67,7 +67,7 @@ static struct device_node *of_irq_find_parent(struct device_node *child)
 			if (of_irq_workarounds & OF_IMAP_NO_PHANDLE)
 				p = of_node_get(of_irq_dflt_pic);
 			else
-				p = of_find_node_by_phandle(*parp);
+				p = of_find_node_by_phandle(be32_to_cpup(parp));
 		}
 		of_node_put(child);
 		child = p;
@@ -206,7 +206,7 @@ int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
 			if (of_irq_workarounds & OF_IMAP_NO_PHANDLE)
 				newpar = of_node_get(of_irq_dflt_pic);
 			else
-				newpar = of_find_node_by_phandle((phandle)*imap);
+				newpar = of_find_node_by_phandle(be32_to_cpup(imap));
 			imap++;
 			--imaplen;
 

