Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab1KXB5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 20:57:39 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:23956
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753665Ab1KXB5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 20:57:38 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: <b35362@freescale.com>
To: <dwmw2@infradead.org>, <Artem.Bityutskiy@nokia.com>,
        <scottwood@freescale.com>
CC: <linux-mtd@lists.infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>
Subject: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support large-page Nand chip
Date: Thu, 24 Nov 2011 08:41:46 +0800
Message-ID: <1322095306-13156-3-git-send-email-b35362@freescale.com>
X-Mailer: git-send-email 1.6.4
In-Reply-To: <1322095306-13156-1-git-send-email-b35362@freescale.com>
References: <1322095306-13156-1-git-send-email-b35362@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Shuo <b35362@freescale.com>

Freescale FCM controller has a 2K size limitation of buffer RAM. In order
to support the Nand flash chip whose page size is larger than 2K bytes,
we read/write 2k data repeatedly by issuing FIR_OP_RB/FIR_OP_WB and save
them to a large buffer.

Signed-off-by: Liu Shuo <b35362@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
---
 drivers/mtd/nand/fsl_elbc_nand.c |  211 +++++++++++++++++++++++++++++++++++---
 1 files changed, 194 insertions(+), 17 deletions(-)

diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
index d634c5f..c96e714 100644
--- a/drivers/mtd/nand/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/fsl_elbc_nand.c
@@ -55,7 +55,9 @@ struct fsl_elbc_mtd {
 	struct device *dev;
 	int bank;               /* Chip select bank number           */
 	u8 __iomem *vbase;      /* Chip select base virtual address  */
-	int page_size;          /* NAND page size (0=512, 1=2048)    */
+	int page_size;          /* NAND page size, the mutiple of 2048.
+				 * (0=512, 1=2048, 2=4096, 4=8192....)
+				 */
 	unsigned int fmr;       /* FCM Flash Mode Register value     */
 };
 
@@ -75,6 +77,8 @@ struct fsl_elbc_fcm_ctrl {
 	unsigned int use_mdr;    /* Non zero if the MDR is to be set      */
 	unsigned int oob;        /* Non zero if operating on OOB data     */
 	unsigned int counter;	 /* counter for the initializations	  */
+
+	char *buffer;            /* just be used when pagesize > 2048     */
 };
 
 /* These map to the positions used by the FCM hardware ECC generator */
@@ -150,6 +154,42 @@ static struct nand_bbt_descr bbt_mirror_descr = {
 };
 
 /*=================================*/
+static void io_to_buffer(struct mtd_info *mtd, int subpage, int oob)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct fsl_elbc_mtd *priv = chip->priv;
+	struct fsl_elbc_fcm_ctrl *elbc_fcm_ctrl = priv->ctrl->nand;
+	void *src, *dst;
+	int len = (oob ? 64 : 2048);
+
+	if (oob)
+		dst = elbc_fcm_ctrl->buffer + mtd->writesize + subpage * 64;
+	else
+		dst = elbc_fcm_ctrl->buffer + subpage * 2048;
+
+	src = elbc_fcm_ctrl->addr + (oob ? 2048 : 0);
+	memcpy_fromio(dst, src, len);
+}
+
+static void buffer_to_io(struct mtd_info *mtd, int subpage, int oob)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct fsl_elbc_mtd *priv = chip->priv;
+	struct fsl_elbc_fcm_ctrl *elbc_fcm_ctrl = priv->ctrl->nand;
+	void *src, *dst;
+	int len = (oob ? 64 : 2048);
+
+	if (oob)
+		src = elbc_fcm_ctrl->buffer + mtd->writesize + subpage * 64;
+	else
+		src = elbc_fcm_ctrl->buffer + subpage * 2048;
+
+	dst = elbc_fcm_ctrl->addr + (oob ? 2048 : 0);
+	memcpy_toio(dst, src, len);
+
+	/* See the in_8() in fsl_elbc_write_buf() */
+	in_8(elbc_fcm_ctrl->addr);
+}
 
 /*
  * Set up the FCM hardware block and page address fields, and the fcm
@@ -193,7 +233,7 @@ static void set_addr(struct mtd_info *mtd, int column, int page_addr, int oob)
 
 	/* for OOB data point to the second half of the buffer */
 	if (oob)
-		elbc_fcm_ctrl->index += priv->page_size ? 2048 : 512;
+		elbc_fcm_ctrl->index += mtd->writesize;
 
 	dev_vdbg(priv->dev, "set_addr: bank=%d, "
 			    "elbc_fcm_ctrl->addr=0x%p (0x%p), "
@@ -311,6 +351,7 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 	struct fsl_lbc_ctrl *ctrl = priv->ctrl;
 	struct fsl_elbc_fcm_ctrl *elbc_fcm_ctrl = ctrl->nand;
 	struct fsl_lbc_regs __iomem *lbc = ctrl->regs;
+	int i;
 
 	elbc_fcm_ctrl->use_mdr = 0;
 
@@ -339,6 +380,26 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 
 		fsl_elbc_do_read(chip, 0);
 		fsl_elbc_run_command(mtd);
+
+		if (priv->page_size <= 1)
+			return;
+
+		/* Continue to read the rest bytes if writesize > 2048 */
+		io_to_buffer(mtd, 0, 0);
+		io_to_buffer(mtd, 0, 1);
+
+		out_be32(&lbc->fir, FIR_OP_RB << FIR_OP1_SHIFT);
+
+		for (i = 1; i < priv->page_size; i++) {
+			/*
+			 * Maybe there are some reasons of FCM hardware timing,
+			 * we must insert a FIR_OP_NOP(0x00) before FIR_OP_RB.
+			 */
+			fsl_elbc_run_command(mtd);
+			io_to_buffer(mtd, i, 0);
+			io_to_buffer(mtd, i, 1);
+		}
+
 		return;
 
 	/* READOOB reads only the OOB because no ECC is performed. */
@@ -347,13 +408,36 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 		         "fsl_elbc_cmdfunc: NAND_CMD_READOOB, page_addr:"
 			 " 0x%x, column: 0x%x.\n", page_addr, column);
 
-		out_be32(&lbc->fbcr, mtd->oobsize - column);
-		set_addr(mtd, column, page_addr, 1);
+		if (priv->page_size <= 1) {
+			out_be32(&lbc->fbcr, mtd->oobsize - column);
+			set_addr(mtd, column, page_addr, 1);
+		} else {
+			out_be32(&lbc->fbcr, 64);
+			set_addr(mtd, 0, page_addr, 1);
+			elbc_fcm_ctrl->index += column;
+		}
 
 		elbc_fcm_ctrl->read_bytes = mtd->writesize + mtd->oobsize;
 
 		fsl_elbc_do_read(chip, 1);
 		fsl_elbc_run_command(mtd);
+
+		if (priv->page_size <= 1)
+			return;
+
+		if (column < 64)
+			io_to_buffer(mtd, 0, 1);
+
+		out_be32(&lbc->fbcr, 2112);
+		out_be32(&lbc->fir, FIR_OP_RB << FIR_OP1_SHIFT);
+		out_be32(&lbc->fpar, in_be32(&lbc->fpar) & ~FPAR_LP_MS);
+
+		for (i = 1; i < priv->page_size; i++) {
+			fsl_elbc_run_command(mtd);
+			if (column < (64 * (i + 1)))
+				io_to_buffer(mtd, i, 1);
+		}
+
 		return;
 
 	/* READID must read all 5 possible bytes while CEB is active */
@@ -429,7 +513,14 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 		      (NAND_CMD_SEQIN    << FCR_CMD2_SHIFT) |
 		      (NAND_CMD_PAGEPROG << FCR_CMD3_SHIFT);
 
-		if (priv->page_size) {
+		if (priv->page_size > 1) {
+			/* writesize > 2048 */
+			out_be32(&lbc->fir,
+				 (FIR_OP_CM2 << FIR_OP0_SHIFT) |
+				 (FIR_OP_CA  << FIR_OP1_SHIFT) |
+				 (FIR_OP_PA  << FIR_OP2_SHIFT) |
+				 (FIR_OP_WB  << FIR_OP3_SHIFT));
+		} else if (priv->page_size) {
 			out_be32(&lbc->fir,
 			         (FIR_OP_CM2 << FIR_OP0_SHIFT) |
 			         (FIR_OP_CA  << FIR_OP1_SHIFT) |
@@ -458,7 +549,13 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 		}
 
 		out_be32(&lbc->fcr, fcr);
-		set_addr(mtd, column, page_addr, elbc_fcm_ctrl->oob);
+		if (elbc_fcm_ctrl->oob && priv->page_size > 1) {
+			set_addr(mtd, 0, page_addr, 0);
+			elbc_fcm_ctrl->index = elbc_fcm_ctrl->column;
+		} else {
+			set_addr(mtd, column, page_addr, elbc_fcm_ctrl->oob);
+		}
+
 		return;
 	}
 
@@ -472,14 +569,59 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 		 * then set the exact length, otherwise use a full page
 		 * write so the HW generates the ECC.
 		 */
-		if (elbc_fcm_ctrl->oob || elbc_fcm_ctrl->column != 0 ||
-		    elbc_fcm_ctrl->index != mtd->writesize + mtd->oobsize)
+		if (elbc_fcm_ctrl->oob) {
+			int len;
+			/* write oob */
+			if (priv->page_size > 1) {
+				/* when pagesize of chip is greater than 2048,
+				 * we have to write full page to write spare
+				 * region, so we fill '0xff' to main region
+				 * and some bytes of spare region which we
+				 * don't want to rewrite.
+				 * (write '1' won't change the original value)
+				 */
+				memset(elbc_fcm_ctrl->buffer, 0xff,
+						elbc_fcm_ctrl->column);
+				len = 2112;
+			} else {
+				len = elbc_fcm_ctrl->index -
+						elbc_fcm_ctrl->column;
+			}
+			out_be32(&lbc->fbcr, len);
+		} else if (elbc_fcm_ctrl->column != 0 ||
+		    elbc_fcm_ctrl->index != mtd->writesize + mtd->oobsize) {
 			out_be32(&lbc->fbcr,
 				elbc_fcm_ctrl->index - elbc_fcm_ctrl->column);
-		else
+		} else {
 			out_be32(&lbc->fbcr, 0);
+		}
+
+		if (priv->page_size > 1) {
+			buffer_to_io(mtd, 0, 0);
+			buffer_to_io(mtd, 0, 1);
+		}
 
 		fsl_elbc_run_command(mtd);
+
+		if (priv->page_size <= 1)
+			return;
+
+		out_be32(&lbc->fir, FIR_OP_WB << FIR_OP1_SHIFT);
+		for (i = 1; i < priv->page_size; i++) {
+			elbc_fcm_ctrl->use_mdr = 1;
+			/* For the last subpage */
+			if (i == priv->page_size - 1)
+				out_be32(&lbc->fir,
+					(FIR_OP_WB  << FIR_OP1_SHIFT) |
+					(FIR_OP_CM3 << FIR_OP2_SHIFT) |
+					(FIR_OP_CW1 << FIR_OP3_SHIFT) |
+					(FIR_OP_RS  << FIR_OP4_SHIFT));
+
+			buffer_to_io(mtd, i, 0);
+			buffer_to_io(mtd, i, 1);
+			fsl_elbc_run_command(mtd);
+		}
+
 		return;
 	}
 
@@ -548,7 +690,14 @@ static void fsl_elbc_write_buf(struct mtd_info *mtd, const u8 *buf, int len)
 		len = bufsize - elbc_fcm_ctrl->index;
 	}
 
-	memcpy_toio(&elbc_fcm_ctrl->addr[elbc_fcm_ctrl->index], buf, len);
+	if (mtd->writesize > 2048) {
+		memcpy(&elbc_fcm_ctrl->buffer[elbc_fcm_ctrl->index],
+				buf, len);
+	} else {
+		memcpy_toio(&elbc_fcm_ctrl->addr[elbc_fcm_ctrl->index],
+				buf, len);
+	}
+
 	/*
 	 * This is workaround for the weird elbc hangs during nand write,
 	 * Scott Wood says: "...perhaps difference in how long it takes a
@@ -594,7 +743,13 @@ static void fsl_elbc_read_buf(struct mtd_info *mtd, u8 *buf, int len)
 
 	avail = min((unsigned int)len,
 			elbc_fcm_ctrl->read_bytes - elbc_fcm_ctrl->index);
-	memcpy_fromio(buf, &elbc_fcm_ctrl->addr[elbc_fcm_ctrl->index], avail);
+	if (mtd->writesize > 2048) {
+		memcpy(buf, &elbc_fcm_ctrl->buffer[elbc_fcm_ctrl->index],
+				avail);
+	} else {
+		memcpy_fromio(buf, &elbc_fcm_ctrl->addr[elbc_fcm_ctrl->index],
+				avail);
+	}
 	elbc_fcm_ctrl->index += avail;
 
 	if (len > avail)
@@ -630,10 +785,17 @@ static int fsl_elbc_verify_buf(struct mtd_info *mtd, const u_char *buf, int len)
 		return -EINVAL;
 	}
 
-	for (i = 0; i < len; i++)
-		if (in_8(&elbc_fcm_ctrl->addr[elbc_fcm_ctrl->index + i])
-				!= buf[i])
-			break;
+	if (mtd->writesize > 2048) {
+		for (i = 0; i < len; i++)
+			if (elbc_fcm_ctrl->buffer[elbc_fcm_ctrl->index + i]
+					!= buf[i])
+				break;
+	} else {
+		for (i = 0; i < len; i++)
+			if (in_8(&elbc_fcm_ctrl->addr[elbc_fcm_ctrl->index + i])
+					!= buf[i])
+				break;
+	}
 
 	elbc_fcm_ctrl->index += len;
 	return i == len && elbc_fcm_ctrl->status == LTESR_CC ? 0 : -EIO;
@@ -716,8 +878,9 @@ static int fsl_elbc_chip_init_tail(struct mtd_info *mtd)
 	if (mtd->writesize == 512) {
 		priv->page_size = 0;
 		clrbits32(&lbc->bank[priv->bank].or, OR_FCM_PGS);
-	} else if (mtd->writesize == 2048) {
-		priv->page_size = 1;
+	} else if (mtd->writesize >= 2048 && mtd->writesize <= 16 * 1024) {
+		priv->page_size = mtd->writesize / 2048;
+
 		setbits32(&lbc->bank[priv->bank].or, OR_FCM_PGS);
 		/* adjust ecc setup if needed */
 		if ((in_be32(&lbc->bank[priv->bank].br) & BR_DECC) ==
@@ -891,6 +1054,19 @@ static int __devinit fsl_elbc_nand_probe(struct platform_device *pdev)
 			goto err;
 		}
 		elbc_fcm_ctrl->counter++;
+		/*
+		 * Freescale FCM controller has a 2K size limitation of buffer
+		 * RAM, so elbc_fcm_ctrl->buffer have to be used if writesize
+		 * of chip is greater than 2048.
+		 * We malloc a large enough buffer (maximum page size is 16K).
+		 */
+		elbc_fcm_ctrl->buffer = kmalloc(1024 * 16 + 1024, GFP_KERNEL);
+		if (!elbc_fcm_ctrl->buffer) {
+			dev_err(dev, "failed to allocate memory\n");
+			mutex_unlock(&fsl_elbc_nand_mutex);
+			ret = -ENOMEM;
+			goto err;
+		}
 
 		spin_lock_init(&elbc_fcm_ctrl->controller.lock);
 		init_waitqueue_head(&elbc_fcm_ctrl->controller.wq);
@@ -960,6 +1136,7 @@ static int fsl_elbc_nand_remove(struct platform_device *pdev)
 	elbc_fcm_ctrl->counter--;
 	if (!elbc_fcm_ctrl->counter) {
 		fsl_lbc_ctrl_dev->nand = NULL;
+		kfree(elbc_fcm_ctrl->buffer);
 		kfree(elbc_fcm_ctrl);
 	}
 	mutex_unlock(&fsl_elbc_nand_mutex);
-- 
1.7.1


