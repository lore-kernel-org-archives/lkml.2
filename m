Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab0EOVWq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:22:46 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35472 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331Ab0EOVWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:22:43 -0400
Date: Sat, 15 May 2010 23:22:38 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 31/37] drivers/infiniband/core: Use kmemdup
Message-ID: <Pine.LNX.4.64.1005152322190.21345@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kmemdup when some other buffer is immediately copied into the
allocated region.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
statement S;
@@

-  to = \(kmalloc\|kzalloc\)(size,flag);
+  to = kmemdup(from,size,flag);
   if (to==NULL || ...) S
-  memcpy(to, from, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/infiniband/core/cma.c |    4 ++--
 drivers/infiniband/core/mad.c |    4 +---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff -u -p a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1676,13 +1676,13 @@ int rdma_set_ib_paths(struct rdma_cm_id 
 	if (!cma_comp_exch(id_priv, CMA_ADDR_RESOLVED, CMA_ROUTE_RESOLVED))
 		return -EINVAL;
 
-	id->route.path_rec = kmalloc(sizeof *path_rec * num_paths, GFP_KERNEL);
+	id->route.path_rec = kmemdup(path_rec, sizeof *path_rec * num_paths,
+				     GFP_KERNEL);
 	if (!id->route.path_rec) {
 		ret = -ENOMEM;
 		goto err;
 	}
 
-	memcpy(id->route.path_rec, path_rec, sizeof *path_rec * num_paths);
 	id->route.num_paths = num_paths;
 	return 0;
 err:
diff -u -p a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -291,13 +291,11 @@ struct ib_mad_agent *ib_register_mad_age
 	}
 
 	if (mad_reg_req) {
-		reg_req = kmalloc(sizeof *reg_req, GFP_KERNEL);
+		reg_req = kmemdup(mad_reg_req, sizeof *reg_req, GFP_KERNEL);
 		if (!reg_req) {
 			ret = ERR_PTR(-ENOMEM);
 			goto error3;
 		}
-		/* Make a copy of the MAD registration request */
-		memcpy(reg_req, mad_reg_req, sizeof *reg_req);
 	}
 
 	/* Now, fill in the various structures */
