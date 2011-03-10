Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1CJAQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:16:38 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:43645 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab1CJAQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:16:20 -0500
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, Daniel Drake <dsd@laptop.org>,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        sparclinux@vger.kernel.org
Subject: [PATCH 2/3] of/promtree: switch to building the DT using of_attach_node
Date: Wed,  9 Mar 2011 16:16:06 -0800
Message-Id: <1299716167-9656-3-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299716167-9656-1-git-send-email-dilinger@queued.net>
References: <1299716167-9656-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common functions (of_attach_node) to build the device tree.  This
allows us to drop a bit of code, and provides a more understandable
tree building.  It does change the order of the allnodes/allnext list;
the old tree looked something like this:

allnodes --> root (/)
             allnext ------> np1 (/pci)
                             allnext --> np2 (/pci/foo)
                                         allnext=NULL

Pretend that was a tree.  The new tree looks something like this:

allnodes     root (/)
      |      allnext=NULL    np1 (/pci)
      |        ^------------ allnext     np2 (/pci/foo)
      |                        ^-------- allnext
      |_____________________________________^

That shouldn't actually matter for anything, but it's worth noting in case
anyone notices odd behavior changes.  Plus, it's a good excuse to make
beautiful art.

Also note that this changes what gets passed to the of_pdt_build_more()
hook.  The only user of this hook is sparc's leon_kernel.c, which ends
up using it to call prom_amba_init.  However, prom_amba_init isn't
actually set in the kernel, so I can't tell whether this actually breaks
behavior or not.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/of/pdt.c |   39 ++++++++++++---------------------------
 1 files changed, 12 insertions(+), 27 deletions(-)

diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
index 4d87b5d..5933127 100644
--- a/drivers/of/pdt.c
+++ b/drivers/of/pdt.c
@@ -193,56 +193,41 @@ static struct device_node * __init of_pdt_create_node(phandle node,
 	return dp;
 }
 
-static struct device_node * __init of_pdt_build_tree(struct device_node *parent,
-						   phandle node,
-						   struct device_node ***nextp)
+static void __init of_pdt_build_tree(struct device_node *parent, phandle node)
 {
-	struct device_node *ret = NULL, *prev_sibling = NULL;
 	struct device_node *dp;
 
-	while (1) {
+	while (node) {
 		dp = of_pdt_create_node(node, parent);
 		if (!dp)
 			break;
 
-		if (prev_sibling)
-			prev_sibling->sibling = dp;
-
-		if (!ret)
-			ret = dp;
-		prev_sibling = dp;
-
-		*(*nextp) = dp;
-		*nextp = &dp->allnext;
-
 		dp->full_name = of_pdt_build_full_name(dp);
+		of_attach_node(dp);
 
-		dp->child = of_pdt_build_tree(dp,
-				of_pdt_prom_ops->getchild(node), nextp);
+		/* process child nodes prior to siblings */
+		of_pdt_build_tree(dp, of_pdt_prom_ops->getchild(node));
 
 		if (of_pdt_build_more)
-			of_pdt_build_more(dp, nextp);
+			of_pdt_build_more(dp, NULL);
 
 		node = of_pdt_prom_ops->getsibling(node);
 	}
-
-	return ret;
 }
 
 void __init of_pdt_build_devicetree(phandle root_node, struct of_pdt_ops *ops)
 {
-	struct device_node **nextp;
+	struct device_node *dp;
 
 	BUG_ON(!ops);
 	of_pdt_prom_ops = ops;
 
-	allnodes = of_pdt_create_node(root_node, NULL);
+	dp = of_pdt_create_node(root_node, NULL);
 #if defined(CONFIG_SPARC)
-	allnodes->path_component_name = "";
+	dp->path_component_name = "";
 #endif
-	allnodes->full_name = "/";
+	dp->full_name = "/";
 
-	nextp = &allnodes->allnext;
-	allnodes->child = of_pdt_build_tree(allnodes,
-			of_pdt_prom_ops->getchild(allnodes->phandle), &nextp);
+	of_attach_node(dp);
+	of_pdt_build_tree(dp, of_pdt_prom_ops->getchild(dp->phandle));
 }
-- 
1.7.2.3

