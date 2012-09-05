Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab2IEHI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 03:08:58 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:36909 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab2IEHI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 03:08:57 -0400
MIME-Version: 1.0
Date: Wed, 5 Sep 2012 15:08:56 +0800
Message-ID: <CAPgLHd9DHDY9-oxFRK6coarc8JqKGporKSXTFG5fkRioZz6xFw@mail.gmail.com>
Subject: [PATCH] dma: tegra: use list_move_tail instead of list_del/list_add_tail
From: Wei Yongjun <weiyj.lk@gmail.com>
To: vinod.koul@intel.com, djbw@fb.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move_tail() instead of list_del() + list_add_tail().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/dma/tegra20-apb-dma.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 24acd71..6ed3f43 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -475,8 +475,7 @@ static void tegra_dma_abort_all(struct tegra_dma_channel *tdc)
 	while (!list_empty(&tdc->pending_sg_req)) {
 		sgreq = list_first_entry(&tdc->pending_sg_req,
 						typeof(*sgreq), node);
-		list_del(&sgreq->node);
-		list_add_tail(&sgreq->node, &tdc->free_sg_req);
+		list_move_tail(&sgreq->node, &tdc->free_sg_req);
 		if (sgreq->last_sg) {
 			dma_desc = sgreq->dma_desc;
 			dma_desc->dma_status = DMA_ERROR;
@@ -570,8 +569,7 @@ static void handle_cont_sngl_cycle_dma_done(struct tegra_dma_channel *tdc,
 
 	/* If not last req then put at end of pending list */
 	if (!list_is_last(&sgreq->node, &tdc->pending_sg_req)) {
-		list_del(&sgreq->node);
-		list_add_tail(&sgreq->node, &tdc->pending_sg_req);
+		list_move_tail(&sgreq->node, &tdc->pending_sg_req);
 		sgreq->configured = false;
 		st = handle_continuous_head_request(tdc, sgreq, to_terminate);
 		if (!st)


