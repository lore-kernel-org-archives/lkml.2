Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178Ab1LIK1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 05:27:54 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:29347
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844Ab1LIK1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 05:27:52 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
From: <shuo.liu@freescale.com>
To: <dwmw2@infradead.org>, <Artem.Bityutskiy@nokia.com>,
        <scottwood@freescale.com>
CC: <linux-mtd@lists.infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <shuo.liu@freescale.com>
Subject: [PATCH 1/2] mtd/nand : set Nand flash page address to FBAR and FPAR correctly
Date: Fri, 9 Dec 2011 17:42:54 +0800
Message-ID: <1323423775-26951-1-git-send-email-shuo.liu@freescale.com>
X-Mailer: git-send-email 1.6.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Shuo <b35362@freescale.com>

If we use the Nand flash chip whose number of pages in a block is greater
than 64(for large page), we must treat the low bit of FBAR as being the
high bit of the page address due to the limitation of FCM, it simply uses
the low 6-bits (for large page) of the combined block/page address as the
FPAR component, rather than considering the actual block size.

Signed-off-by: Liu Shuo <b35362@freescale.com>
Signed-off-by: Jerry Huang <Chang-Ming.Huang@freescale.com>
Signed-off-by: Tang Yuantian <b29983@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
---
 drivers/mtd/nand/fsl_elbc_nand.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
index 7db573e..d29479a 100644
--- a/drivers/mtd/nand/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/fsl_elbc_nand.c
@@ -166,15 +166,22 @@ static void set_addr(struct mtd_info *mtd, int column, int page_addr, int oob)
 
 	elbc_fcm_ctrl->page = page_addr;
 
-	out_be32(&lbc->fbar,
-	         page_addr >> (chip->phys_erase_shift - chip->page_shift));
-
 	if (priv->page_size) {
+		/*
+		 * large page size chip : FPAR[PI] save the lowest 6 bits,
+		 *                        FBAR[BLK] save the other bits.
+		 */
+		out_be32(&lbc->fbar, page_addr >> 6);
 		out_be32(&lbc->fpar,
 		         ((page_addr << FPAR_LP_PI_SHIFT) & FPAR_LP_PI) |
 		         (oob ? FPAR_LP_MS : 0) | column);
 		buf_num = (page_addr & 1) << 2;
 	} else {
+		/*
+		 * small page size chip : FPAR[PI] save the lowest 5 bits,
+		 *                        FBAR[BLK] save the other bits.
+		 */
+		out_be32(&lbc->fbar, page_addr >> 5);
 		out_be32(&lbc->fpar,
 		         ((page_addr << FPAR_SP_PI_SHIFT) & FPAR_SP_PI) |
 		         (oob ? FPAR_SP_MS : 0) | column);
-- 
1.7.1


