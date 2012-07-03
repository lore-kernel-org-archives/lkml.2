Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab2GCLNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 07:13:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43675 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab2GCLNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 07:13:13 -0400
From: Rajendra Nayak <rnayak@ti.com>
To: <mturquette@ti.com>, <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <mkl@pengutronix.de>, Rajendra Nayak <rnayak@ti.com>
Subject: [PATCH] clk: fix parent validation in __clk_set_parent()
Date: Tue, 3 Jul 2012 16:42:18 +0530
Message-ID: <1341313938-17861-1-git-send-email-rnayak@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below commit introduced a bug in __clk_set_parent()
which could cause it to *skip* the parent validation
which makes sure the parent passed to the api is a valid
one.

    commit 7975059db572eb47f0fb272a62afeae272a4b209
    Author: Rajendra Nayak <rnayak@ti.com>
    Date:   Wed Jun 6 14:41:31 2012 +0530

        clk: Allow late cache allocation for clk->parents

This was identified by the following compiler warning..

    drivers/clk/clk.c: In function '__clk_set_parent':
    drivers/clk/clk.c:1083:5: warning: 'i' may be used uninitialized in this function [-Wuninitialized]

.. as reported by Marc Kleine-Budde.

There were various options discussed on how to fix this, one
being initing 'i' to clk->num_parents, but the below approach
was found to be more appropriate as it also makes the 'parent
validation' code simpler to read.

Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Rajendra Nayak <rnayak@ti.com>
---
 drivers/clk/clk.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 8996f46..46317cb 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1067,26 +1067,24 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent)
 
 	old_parent = clk->parent;
 
-	/* find index of new parent clock using cached parent ptrs */
-	if (clk->parents)
-		for (i = 0; i < clk->num_parents; i++)
-			if (clk->parents[i] == parent)
-				break;
-	else
+	if (!clk->parents)
 		clk->parents = kzalloc((sizeof(struct clk*) * clk->num_parents),
 								GFP_KERNEL);
 
 	/*
-	 * find index of new parent clock using string name comparison
-	 * also try to cache the parent to avoid future calls to __clk_lookup
+	 * find index of new parent clock using cached parent ptrs,
+	 * or if not yet cached, use string name comparison and cache
+	 * them now to avoid future calls to __clk_lookup.
 	 */
-	if (i == clk->num_parents)
-		for (i = 0; i < clk->num_parents; i++)
-			if (!strcmp(clk->parent_names[i], parent->name)) {
-				if (clk->parents)
-					clk->parents[i] = __clk_lookup(parent->name);
-				break;
-			}
+	for (i = 0; i < clk->num_parents; i++) {
+		if (clk->parents && clk->parents[i] == parent)
+			break;
+		else if (!strcmp(clk->parent_names[i], parent->name)) {
+			if (clk->parents)
+				clk->parents[i] = __clk_lookup(parent->name);
+			break;
+		}
+	}
 
 	if (i == clk->num_parents) {
 		pr_debug("%s: clock %s is not a possible parent of clock %s\n",
-- 
1.7.1

