Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab2COSHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:07:49 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:8087 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab2COSHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:07:48 -0400
From: Don Morris <don.morris@hp.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: dan.j.williams@intel.com, vinod.koul@intel.com,
        Don Morris <don.morris@hp.com>
Subject: [PATCH V2] iop-adma: Corrected array overflow in RAID6 Xscale(R) test.
Date: Thu, 15 Mar 2012 11:07:30 -0700
Message-Id: <1331834850-27409-1-git-send-email-don.morris@hp.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bug: cppcheck reported overflow in array assignment (for loop walks
0 to IOP_ADMA_NUM_SRC_TEST+2, array size is IOP_ADMA_NUM_SRC_TEST).

Reported as: https://bugzilla.kernel.org/show_bug.cgi?id=42677

Test code pq_src array was grown by two elements to correspond with actual
usage (IOP_ADMA_NUM_SRC_TEST+2), stack consumption was kept constant by
modifying the pq_dest two element array which is only used when pq_src
is referenced up to IOP_ADMA_NUM_SRC_TEST elements into the address
of the new last two elements of the pq_src array. This is presumed to
be the original intent but would be reliant on compilers always having
pq_dest contiguous with the final element of pq_src.

Note: This is a re-send of a request for review from two weeks ago.
Looking for review (or shootdown), adding LKML to list for a wider
audience. Thanks.

Updated per review comments of Sergei Shtylyov <sshtylyov@mvista.com>

Signed-off-by: Don Morris <don.morris@hp.com>
---
 drivers/dma/iop-adma.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 04be90b..9b1951d 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -1271,8 +1271,8 @@ iop_adma_pq_zero_sum_self_test(struct iop_adma_device *device)
 	struct page **pq_hw = &pq[IOP_ADMA_NUM_SRC_TEST+2];
 	/* address conversion buffers (dma_map / page_address) */
 	void *pq_sw[IOP_ADMA_NUM_SRC_TEST+2];
-	dma_addr_t pq_src[IOP_ADMA_NUM_SRC_TEST];
-	dma_addr_t pq_dest[2];
+	dma_addr_t pq_src[IOP_ADMA_NUM_SRC_TEST+2];
+	dma_addr_t *pq_dest = &pq_src[IOP_ADMA_NUM_SRC_TEST];
 
 	int i;
 	struct dma_async_tx_descriptor *tx;
-- 
1.7.9.111.gf3fb0

