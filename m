Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532Ab0ENTbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:31:36 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:33687 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab0ENTbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:31:32 -0400
Date: Fri, 14 May 2010 21:31:26 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 10/10] arch/powerpc/platforms/iseries: Use kstrdup
Message-ID: <Pine.LNX.4.64.1005142131080.28935@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kstrdup when the goal of an allocation is copy a string into the
allocated region.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to;
expression flag,E1,E2;
statement S;
@@

-  to = kmalloc(strlen(from) + 1,flag);
+  to = kstrdup(from, flag);
   ... when != \(from = E1 \| to = E1 \)
   if (to==NULL || ...) S
   ... when != \(from = E2 \| to = E2 \)
-  strcpy(to, from);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/powerpc/platforms/iseries/vio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/arch/powerpc/platforms/iseries/vio.c b/arch/powerpc/platforms/iseries/vio.c
--- a/arch/powerpc/platforms/iseries/vio.c
+++ b/arch/powerpc/platforms/iseries/vio.c
@@ -87,12 +87,11 @@ static struct device_node *new_node(cons
 
 	if (!np)
 		return NULL;
-	np->full_name = kmalloc(strlen(path) + 1, GFP_KERNEL);
+	np->full_name = kstrdup(path, GFP_KERNEL);
 	if (!np->full_name) {
 		kfree(np);
 		return NULL;
 	}
-	strcpy(np->full_name, path);
 	of_node_set_flag(np, OF_DYNAMIC);
 	kref_init(&np->kref);
 	np->parent = of_node_get(parent);
