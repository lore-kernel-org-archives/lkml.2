Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab2FUISw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:18:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60951 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758714Ab2FUISs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:18:48 -0400
From: Keng-Yu Lin <kengyu@canonical.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        wwang <wei_wang@realsil.com.cn>,
        Hitoshi NAKAMORI <hitoshi.nakamori@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Keng-Yu Lin <kengyu@canonical.com>
Subject: [PATCH 3.2.y 3.3.y] staging:rts_pstor:Fix possible panic by NULL pointer dereference
Date: Thu, 21 Jun 2012 16:18:39 +0800
Message-Id: <1340266719-31983-1-git-send-email-kengyu@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wwang <wei_wang@realsil.com.cn>

commit 0d05568ac79bfc595f1eadc3e0fd7a20a45f7b69 upstream.

rtsx_transport.c (rtsx_transfer_sglist_adma_partial):
pointer struct scatterlist *sg, which is mapped in dma_map_sg,
is used as an iterator in later transfer operation. It is corrupted and
passed to dma_unmap_sg, thus causing fatal unmap of some erroneous address.
Fix it by duplicating *sg_ptr for iterating.

Signed-off-by: wwang <wei_wang@realsil.com.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
---
 drivers/staging/rts_pstor/rtsx_transport.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx_transport.c b/drivers/staging/rts_pstor/rtsx_transport.c
index 4e3d2c1..9b2e5c9 100644
--- a/drivers/staging/rts_pstor/rtsx_transport.c
+++ b/drivers/staging/rts_pstor/rtsx_transport.c
@@ -335,6 +335,7 @@ static int rtsx_transfer_sglist_adma_partial(struct rtsx_chip *chip, u8 card,
 	int sg_cnt, i, resid;
 	int err = 0;
 	long timeleft;
+	struct scatterlist *sg_ptr;
 	u32 val = TRIG_DMA;
 
 	if ((sg == NULL) || (num_sg <= 0) || !offset || !index)
@@ -371,7 +372,7 @@ static int rtsx_transfer_sglist_adma_partial(struct rtsx_chip *chip, u8 card,
 	sg_cnt = dma_map_sg(&(rtsx->pci->dev), sg, num_sg, dma_dir);
 
 	resid = size;
-
+	sg_ptr = sg;
 	chip->sgi = 0;
 	/* Usually the next entry will be @sg@ + 1, but if this sg element
 	 * is part of a chained scatterlist, it could jump to the start of
@@ -379,14 +380,14 @@ static int rtsx_transfer_sglist_adma_partial(struct rtsx_chip *chip, u8 card,
 	 * the proper sg
 	 */
 	for (i = 0; i < *index; i++)
-		sg = sg_next(sg);
+		sg_ptr = sg_next(sg_ptr);
 	for (i = *index; i < sg_cnt; i++) {
 		dma_addr_t addr;
 		unsigned int len;
 		u8 option;
 
-		addr = sg_dma_address(sg);
-		len = sg_dma_len(sg);
+		addr = sg_dma_address(sg_ptr);
+		len = sg_dma_len(sg_ptr);
 
 		RTSX_DEBUGP("DMA addr: 0x%x, Len: 0x%x\n",
 			     (unsigned int)addr, len);
@@ -415,7 +416,7 @@ static int rtsx_transfer_sglist_adma_partial(struct rtsx_chip *chip, u8 card,
 		if (!resid)
 			break;
 
-		sg = sg_next(sg);
+		sg_ptr = sg_next(sg_ptr);
 	}
 
 	RTSX_DEBUGP("SG table count = %d\n", chip->sgi);
-- 
1.7.9.5

