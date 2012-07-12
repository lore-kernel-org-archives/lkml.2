Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162018Ab2GLXcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:32:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161837Ab2GLWkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:40:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajendra Nayak <rnayak@ti.com>, Mike Turquette <mturquette@linaro.org>
Subject: [ 092/187] clk: Allow late cache allocation for clk->parents
Date: Thu, 12 Jul 2012 15:34:08 -0700
Message-Id: <20120712191530.932186013@linuxfoundation.org>
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

commit 7975059db572eb47f0fb272a62afeae272a4b209 upstream.

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
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -997,7 +997,7 @@ static struct clk *__clk_init_parent(str
 
 	if (!clk->parents)
 		clk->parents =
-			kmalloc((sizeof(struct clk*) * clk->num_parents),
+			kzalloc((sizeof(struct clk*) * clk->num_parents),
 					GFP_KERNEL);
 
 	if (!clk->parents)
@@ -1063,9 +1063,13 @@ static int __clk_set_parent(struct clk *
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
@@ -1074,7 +1078,8 @@ static int __clk_set_parent(struct clk *
 	if (i == clk->num_parents)
 		for (i = 0; i < clk->num_parents; i++)
 			if (!strcmp(clk->parent_names[i], parent->name)) {
-				clk->parents[i] = __clk_lookup(parent->name);
+				if (clk->parents)
+					clk->parents[i] = __clk_lookup(parent->name);
 				break;
 			}
 


