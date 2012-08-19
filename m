Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab2HSR4E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 13:56:04 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36195 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab2HSR4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 13:56:00 -0400
From: Emil Goode <emilgoode@gmail.com>
To: swise@chelsio.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] DMA/cxgb4: Fix error handling
Date: Sun, 19 Aug 2012 19:59:40 +0200
Message-Id: <1345399180-17132-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable ret is assigned return values in a couple
of places, but it's value is never returned.
This patch makes use of the ret variable so that the caller
get correct error codes returned.
The following changes are also introduced:

- The alloc_oc_sq function can return -ENOSYS or -ENOMEM so
  we want to get the return value from it.

- Change the lable names to improve readability.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/infiniband/hw/cxgb4/qp.c |   62 +++++++++++++++++++++++---------------
 1 file changed, 38 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 45aedf1..e2bf9c6 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -137,19 +137,25 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 		return -ENOMEM;
 
 	wq->rq.qid = c4iw_get_qpid(rdev, uctx);
-	if (!wq->rq.qid)
-		goto err1;
+	if (!wq->rq.qid) {
+		ret = -ENOMEM;
+		goto free_sq_qid;
+	}
 
 	if (!user) {
 		wq->sq.sw_sq = kzalloc(wq->sq.size * sizeof *wq->sq.sw_sq,
 				 GFP_KERNEL);
-		if (!wq->sq.sw_sq)
-			goto err2;
+		if (!wq->sq.sw_sq) {
+			ret = -ENOMEM;
+			goto free_rq_qid;
+		}
 
 		wq->rq.sw_rq = kzalloc(wq->rq.size * sizeof *wq->rq.sw_rq,
 				 GFP_KERNEL);
-		if (!wq->rq.sw_rq)
-			goto err3;
+		if (!wq->rq.sw_rq) {
+			ret = -ENOMEM;
+			goto free_sw_sq;
+		}
 	}
 
 	/*
@@ -157,15 +163,23 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	 */
 	wq->rq.rqt_size = roundup_pow_of_two(wq->rq.size);
 	wq->rq.rqt_hwaddr = c4iw_rqtpool_alloc(rdev, wq->rq.rqt_size);
-	if (!wq->rq.rqt_hwaddr)
-		goto err4;
+	if (!wq->rq.rqt_hwaddr) {
+		ret = -ENOMEM;
+		goto free_sw_rq;
+	}
 
 	if (user) {
-		if (alloc_oc_sq(rdev, &wq->sq) && alloc_host_sq(rdev, &wq->sq))
-			goto err5;
+		ret = alloc_oc_sq(rdev, &wq->sq);
+		if (ret)
+			goto free_hwaddr;
+
+		ret = alloc_host_sq(rdev, &wq->sq);
+		if (ret)
+			goto free_sq;
 	} else
-		if (alloc_host_sq(rdev, &wq->sq))
-			goto err5;
+		ret = alloc_host_sq(rdev, &wq->sq);
+		if (ret)
+			goto free_hwaddr;
 	memset(wq->sq.queue, 0, wq->sq.memsize);
 	dma_unmap_addr_set(&wq->sq, mapping, wq->sq.dma_addr);
 
@@ -173,7 +187,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 					  wq->rq.memsize, &(wq->rq.dma_addr),
 					  GFP_KERNEL);
 	if (!wq->rq.queue)
-		goto err6;
+		goto free_sq;
 	PDBG("%s sq base va 0x%p pa 0x%llx rq base va 0x%p pa 0x%llx\n",
 		__func__, wq->sq.queue,
 		(unsigned long long)virt_to_phys(wq->sq.queue),
@@ -201,7 +215,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	skb = alloc_skb(wr_len, GFP_KERNEL);
 	if (!skb) {
 		ret = -ENOMEM;
-		goto err7;
+		goto free_dma;
 	}
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
 
@@ -266,33 +280,33 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 
 	ret = c4iw_ofld_send(rdev, skb);
 	if (ret)
-		goto err7;
+		goto free_dma;
 	ret = c4iw_wait_for_reply(rdev, &wr_wait, 0, wq->sq.qid, __func__);
 	if (ret)
-		goto err7;
+		goto free_dma;
 
 	PDBG("%s sqid 0x%x rqid 0x%x kdb 0x%p squdb 0x%llx rqudb 0x%llx\n",
 	     __func__, wq->sq.qid, wq->rq.qid, wq->db,
 	     (unsigned long long)wq->sq.udb, (unsigned long long)wq->rq.udb);
 
 	return 0;
-err7:
+free_dma:
 	dma_free_coherent(&(rdev->lldi.pdev->dev),
 			  wq->rq.memsize, wq->rq.queue,
 			  dma_unmap_addr(&wq->rq, mapping));
-err6:
+free_sq:
 	dealloc_sq(rdev, &wq->sq);
-err5:
+free_hwaddr:
 	c4iw_rqtpool_free(rdev, wq->rq.rqt_hwaddr, wq->rq.rqt_size);
-err4:
+free_sw_rq:
 	kfree(wq->rq.sw_rq);
-err3:
+free_sw_sq:
 	kfree(wq->sq.sw_sq);
-err2:
+free_rq_qid:
 	c4iw_put_qpid(rdev, wq->rq.qid, uctx);
-err1:
+free_sq_qid:
 	c4iw_put_qpid(rdev, wq->sq.qid, uctx);
-	return -ENOMEM;
+	return ret;
 }
 
 static int build_immd(struct t4_sq *sq, struct fw_ri_immd *immdp,
-- 
1.7.10.4

