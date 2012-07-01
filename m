Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab2GAS1C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:27:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46930 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288Ab2GASQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:27 -0400
Message-Id: <20120701172009.084561579@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:23 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, wwang <wei_wang@realsil.com.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 17/48] staging:rts_pstor:Fix possible panic by NULL pointer dereference
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wwang <wei_wang@realsil.com.cn>

commit 0d05568ac79bfc595f1eadc3e0fd7a20a45f7b69 upstream.

rtsx_transport.c (rtsx_transfer_sglist_adma_partial):
pointer struct scatterlist *sg, which is mapped in dma_map_sg,
is used as an iterator in later transfer operation. It is corrupted and
passed to dma_unmap_sg, thus causing fatal unmap of some erroneous address.
Fix it by duplicating *sg_ptr for iterating.

Signed-off-by: wwang <wei_wang@realsil.com.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


