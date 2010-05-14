Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab0ENTaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:30:24 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:54885 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758476Ab0ENTaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:30:18 -0400
Date: Fri, 14 May 2010 21:30:13 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 6/10] arch/powerpc/platforms/pseries: Use kstrdup
Message-ID: <Pine.LNX.4.64.1005142129520.28935@ask.diku.dk>
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
 arch/powerpc/platforms/pseries/reconfig.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -u -p a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/platforms/pseries/reconfig.c
--- a/arch/powerpc/platforms/pseries/reconfig.c
+++ b/arch/powerpc/platforms/pseries/reconfig.c
@@ -118,12 +118,10 @@ static int pSeries_reconfig_add_node(con
 	if (!np)
 		goto out_err;
 
-	np->full_name = kmalloc(strlen(path) + 1, GFP_KERNEL);
+	np->full_name = kstrdup(path, GFP_KERNEL);
 	if (!np->full_name)
 		goto out_err;
 
-	strcpy(np->full_name, path);
-
 	np->properties = proplist;
 	of_node_set_flag(np, OF_DYNAMIC);
 	kref_init(&np->kref);
