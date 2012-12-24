Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab2LXCTF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 21:19:05 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:46963 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab2LXCOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 21:14:51 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Steve Wise <swise@chelsio.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 09/29] infiniband: rename random32() and net_random() to prandom_u32()
Date: Mon, 24 Dec 2012 11:13:56 +0900
Message-Id: <1356315256-6572-10-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356315256-6572-1-git-send-email-akinobu.mita@gmail.com>
References: <1356315256-6572-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Steve Wise <swise@chelsio.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/core/cma.c               | 2 +-
 drivers/infiniband/hw/cxgb3/cxio_resource.c | 4 ++--
 drivers/infiniband/hw/cxgb4/id_table.c      | 4 ++--
 drivers/infiniband/hw/mlx4/mad.c            | 2 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c     | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index d789eea..ddeac735 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2180,7 +2180,7 @@ static int cma_alloc_any_port(struct idr *ps, struct rdma_id_private *id_priv)
 
 	inet_get_local_port_range(&low, &high);
 	remaining = (high - low) + 1;
-	rover = net_random() % remaining + low;
+	rover = prandom_u32() % remaining + low;
 retry:
 	if (last_used_port != rover &&
 	    !idr_find(ps, (unsigned short) rover)) {
diff --git a/drivers/infiniband/hw/cxgb3/cxio_resource.c b/drivers/infiniband/hw/cxgb3/cxio_resource.c
index 31f9201..c40088e 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_resource.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_resource.c
@@ -62,13 +62,13 @@ static int __cxio_init_resource_fifo(struct kfifo *fifo,
 		kfifo_in(fifo, (unsigned char *) &entry, sizeof(u32));
 	if (random) {
 		j = 0;
-		random_bytes = random32();
+		random_bytes = prandom_u32();
 		for (i = 0; i < RANDOM_SIZE; i++)
 			rarray[i] = i + skip_low;
 		for (i = skip_low + RANDOM_SIZE; i < nr - skip_high; i++) {
 			if (j >= RANDOM_SIZE) {
 				j = 0;
-				random_bytes = random32();
+				random_bytes = prandom_u32();
 			}
 			idx = (random_bytes >> (j * 2)) & 0xF;
 			kfifo_in(fifo,
diff --git a/drivers/infiniband/hw/cxgb4/id_table.c b/drivers/infiniband/hw/cxgb4/id_table.c
index f95e5df..0161ae6 100644
--- a/drivers/infiniband/hw/cxgb4/id_table.c
+++ b/drivers/infiniband/hw/cxgb4/id_table.c
@@ -54,7 +54,7 @@ u32 c4iw_id_alloc(struct c4iw_id_table *alloc)
 
 	if (obj < alloc->max) {
 		if (alloc->flags & C4IW_ID_TABLE_F_RANDOM)
-			alloc->last += random32() % RANDOM_SKIP;
+			alloc->last += prandom_u32() % RANDOM_SKIP;
 		else
 			alloc->last = obj + 1;
 		if (alloc->last >= alloc->max)
@@ -88,7 +88,7 @@ int c4iw_id_table_alloc(struct c4iw_id_table *alloc, u32 start, u32 num,
 	alloc->start = start;
 	alloc->flags = flags;
 	if (flags & C4IW_ID_TABLE_F_RANDOM)
-		alloc->last = random32() % RANDOM_SKIP;
+		alloc->last = prandom_u32() % RANDOM_SKIP;
 	else
 		alloc->last = 0;
 	alloc->max  = num;
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 0a903c1..b247c5b 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -93,7 +93,7 @@ static void __propagate_pkey_ev(struct mlx4_ib_dev *dev, int port_num,
 __be64 mlx4_ib_gen_node_guid(void)
 {
 #define NODE_GUID_HI	((u64) (((u64)IB_OPENIB_OUI) << 40))
-	return cpu_to_be64(NODE_GUID_HI | random32());
+	return cpu_to_be64(NODE_GUID_HI | prandom_u32());
 }
 
 __be64 mlx4_ib_get_new_demux_tid(struct mlx4_ib_demux_ctx *ctx)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 03103d2..0e0016d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -460,7 +460,7 @@ static int ipoib_cm_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *even
 		goto err_qp;
 	}
 
-	psn = random32() & 0xffffff;
+	psn = prandom_u32() & 0xffffff;
 	ret = ipoib_cm_modify_rx_qp(dev, cm_id, p->qp, psn);
 	if (ret)
 		goto err_modify;
-- 
1.7.11.7

