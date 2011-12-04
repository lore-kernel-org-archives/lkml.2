Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab1LDFsn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 00:48:43 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:43876 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab1LDFsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 00:48:42 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: <shuo.liu@freescale.com>
To: <dwmw2@infradead.org>, <Artem.Bityutskiy@nokia.com>,
        <scottwood@freescale.com>
CC: <linux-mtd@lists.infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <shuo.liu@freescale.com>
Subject: [PATCH 1/3] mtd/nand : use elbc_fcm_ctrl->oob to set FPAR_MS bit of FPAR
Date: Sun, 4 Dec 2011 12:31:36 +0800
Message-ID: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com>
X-Mailer: git-send-email 1.6.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Shuo <b35362@freescale.com>

On both of large-page chip and small-page chip, we always should use
'elbc_fcm_ctrl->oob' to set the FPAR_LP_MS/FPAR_SP_MS bit of FPAR, don't
use a overflowed 'column' to set it.

Signed-off-by: Liu Shuo <b35362@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
---
 drivers/mtd/nand/fsl_elbc_nand.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
index cc08a11..6fce7da 100644
--- a/drivers/mtd/nand/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/fsl_elbc_nand.c
@@ -414,9 +414,17 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 		         page_addr, column);
 
 		elbc_fcm_ctrl->column = column;
-		elbc_fcm_ctrl->oob = 0;
 		elbc_fcm_ctrl->use_mdr = 1;
 
+		if (column >= mtd->writesize) {
+			/* OOB area */
+			column -= mtd->writesize;
+			elbc_fcm_ctrl->oob = 1;
+		} else {
+			WARN_ON(column != 0);
+			elbc_fcm_ctrl->oob = 0;
+		}
+
 		fcr = (NAND_CMD_STATUS   << FCR_CMD1_SHIFT) |
 		      (NAND_CMD_SEQIN    << FCR_CMD2_SHIFT) |
 		      (NAND_CMD_PAGEPROG << FCR_CMD3_SHIFT);
@@ -441,16 +449,12 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 			         (FIR_OP_CW1 << FIR_OP6_SHIFT) |
 			         (FIR_OP_RS  << FIR_OP7_SHIFT));
 
-			if (column >= mtd->writesize) {
+			if (elbc_fcm_ctrl->oob)
 				/* OOB area --> READOOB */
-				column -= mtd->writesize;
 				fcr |= NAND_CMD_READOOB << FCR_CMD0_SHIFT;
-				elbc_fcm_ctrl->oob = 1;
-			} else {
-				WARN_ON(column != 0);
+			else
 				/* First 256 bytes --> READ0 */
 				fcr |= NAND_CMD_READ0 << FCR_CMD0_SHIFT;
-			}
 		}
 
 		out_be32(&lbc->fcr, fcr);
-- 
1.7.1


