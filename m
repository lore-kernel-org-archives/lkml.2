Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab2FFJLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:11:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44248 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893Ab2FFJLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:11:41 -0400
From: Rajendra Nayak <rnayak@ti.com>
To: <mturquette@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Rajendra Nayak <rnayak@ti.com>
Subject: [PATCH 2/2] clk: Allow late cache allocation for clk->parents
Date: Wed, 6 Jun 2012 14:41:31 +0530
Message-ID: <1338973891-28719-3-git-send-email-rnayak@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1338973891-28719-1-git-send-email-rnayak@ti.com>
References: <1338973891-28719-1-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parent clocks for muxes are cached in clk->parents to
avoid frequent lookups, however the cache allocation happens
only during clock registeration and later clk_set_parent()
assumes a cache space available and allocated.

This is not entirely true for platforms which do early clock
registerations wherein the cache allocation using kzalloc
could fail during clock registeration.

Allow cache allocation to happen later as part of clk_set_parent()
to help such cases and avoid crashes assuming a cache being
available.

While here also replace existing kmalloc() with kzalloc()
in the file.

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
---
 drivers/clk/clk.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 40568e9..0d67745 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -999,7 +999,7 @@ static struct clk *__clk_init_parent(struct clk *clk)
 
 	if (!clk->parents)
 		clk->parents =
-			kmalloc((sizeof(struct clk*) * clk->num_parents),
+			kzalloc((sizeof(struct clk*) * clk->num_parents),
 					GFP_KERNEL);
 
 	if (!clk->parents)
@@ -1065,9 +1065,13 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent)
 	old_parent = clk->parent;
 
 	/* find index of new parent clock using cached parent ptrs */
-	for (i = 0; i < clk->num_parents; i++)
-		if (clk->parents[i] == parent)
-			break;
+	if (clk->parents)
+		for (i = 0; i < clk->num_parents; i++)
+			if (clk->parents[i] == parent)
+				break;
+	else
+		clk->parents = kzalloc((sizeof(struct clk*) * clk->num_parents),
+								GFP_KERNEL);
 
 	/*
 	 * find index of new parent clock using string name comparison
@@ -1076,7 +1080,8 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent)
 	if (i == clk->num_parents)
 		for (i = 0; i < clk->num_parents; i++)
 			if (!strcmp(clk->parent_names[i], parent->name)) {
-				clk->parents[i] = __clk_lookup(parent->name);
+				if (clk->parents)
+					clk->parents[i] = __clk_lookup(parent->name);
 				break;
 			}
 
@@ -1230,7 +1235,7 @@ int __clk_init(struct device *dev, struct clk *clk)
 	 * for clock drivers to statically initialize clk->parents.
 	 */
 	if ((clk->num_parents > 1) && !clk->parents) {
-		clk->parents = kmalloc((sizeof(struct clk*) * clk->num_parents),
+		clk->parents = kzalloc((sizeof(struct clk*) * clk->num_parents),
 				GFP_KERNEL);
 		/*
 		 * __clk_lookup returns NULL for parents that have not been
-- 
1.7.1

