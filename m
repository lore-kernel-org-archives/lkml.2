Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab1CRAdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 20:33:18 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:56469 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755953Ab1CRAcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 20:32:45 -0400
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, Daniel Drake <dsd@laptop.org>,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        sparclinux@vger.kernel.org
Subject: [PATCH 2/4] of/promtree: switch to building the DT using of_attach_node
Date: Thu, 17 Mar 2011 17:32:34 -0700
Message-Id: <1300408356-15253-3-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1300408356-15253-1-git-send-email-dilinger@queued.net>
References: <1300408356-15253-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common functions (of_attach_node) to build the device tree.  This
allows us to drop a bit of code, and improves readability of the
tree building code.

Note that this changes what gets passed to the of_pdt_build_more()
hook.  The only user of this hook is sparc's leon_kernel.c, which ends
up using it to call prom_amba_init.  However, prom_amba_init isn't
actually set in the kernel, so I can't tell whether this actually breaks
behavior or not.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/of/pdt.c |   30 ++++++------------------------
 1 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
index 4d87b5d..f3ddc2d 100644
--- a/drivers/of/pdt.c
+++ b/drivers/of/pdt.c
@@ -193,11 +193,8 @@ static struct device_node * __init of_pdt_create_node(phandle node,
 	return dp;
 }
 
-static struct device_node * __init of_pdt_build_tree(struct device_node *parent,
-						   phandle node,
-						   struct device_node ***nextp)
+static void __init of_pdt_build_tree(struct device_node *parent, phandle node)
 {
-	struct device_node *ret = NULL, *prev_sibling = NULL;
 	struct device_node *dp;
 
 	while (1) {
@@ -205,34 +202,20 @@ static struct device_node * __init of_pdt_build_tree(struct device_node *parent,
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
-
 	BUG_ON(!ops);
 	of_pdt_prom_ops = ops;
 
@@ -242,7 +225,6 @@ void __init of_pdt_build_devicetree(phandle root_node, struct of_pdt_ops *ops)
 #endif
 	allnodes->full_name = "/";
 
-	nextp = &allnodes->allnext;
-	allnodes->child = of_pdt_build_tree(allnodes,
-			of_pdt_prom_ops->getchild(allnodes->phandle), &nextp);
+	of_pdt_build_tree(allnodes,
+			of_pdt_prom_ops->getchild(allnodes->phandle));
 }
-- 
1.7.2.3

