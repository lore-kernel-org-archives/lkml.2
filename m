Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161862Ab2GLWlC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:41:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161845Ab2GLWkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:40:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marc Kleine-Budde <mkl@pengutronix.de>, Rajendra Nayak <rnayak@ti.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [ 093/187] clk: fix parent validation in __clk_set_parent()
Date: Thu, 12 Jul 2012 15:34:09 -0700
Message-Id: <20120712191531.026731538@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajendra Nayak <rnayak@ti.com>

commit 863b13271f1608ab3af6f7a371047d9a66693e38 upstream.

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
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1062,26 +1062,24 @@ static int __clk_set_parent(struct clk *
 
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


