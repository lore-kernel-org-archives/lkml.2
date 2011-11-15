Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab1KOKnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 05:43:46 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:41245
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754748Ab1KOKnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 05:43:45 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
From: <b35362@freescale.com>
To: <dwmw2@infradead.org>, <Artem.Bityutskiy@nokia.com>
CC: <linux-mtd@lists.infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <scottwood@freescale.com>,
        Liu Shuo <b35362@freescale.com>, Liu Shuo <Shuo.Liu@freescale.com>,
        Shengzhou Liu <Shengzhou.Liu@freescale.com>
Subject: [PATCH v3 3/3] mtd/nand : workaround for Freescale FCM to support large-page Nand chip
Date: Tue, 15 Nov 2011 17:29:15 +0800
Message-ID: <1321349355-1639-3-git-send-email-b35362@freescale.com>
X-Mailer: git-send-email 1.6.4
In-Reply-To: <1321349355-1639-2-git-send-email-b35362@freescale.com>
References: <1321349355-1639-1-git-send-email-b35362@freescale.com>
 <1321349355-1639-2-git-send-email-b35362@freescale.com>
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

Signed-off-by: Liu Shuo <Shuo.Liu@freescale.com>
Signed-off-by: Shengzhou Liu <Shengzhou.Liu@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
---
 drivers/mtd/nand/fsl_elbc_nand.c |  216 +++++++++++++++++++++++++++++++++++---
 1 files changed, 199 insertions(+), 17 deletions(-)

diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
index c2c231b..415f87e 100644
--- a/drivers/mtd/nand/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/fsl_elbc_nand.c
@@ -55,7 +55,9 @@ struct fsl_elbc_mtd {
 	struct device *dev;
 	int bank;               /* Chip select bank number           */
 	u8 __iomem *vbase;      /* Chip select base virtual address  */
-	int page_size;          /* NAND page size (0=512, 1=2048)    */
+	int page_size;          /* NAND page size (0=512, 1=2048, 2=4096...),
+				 * the mutiple of 2048.
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
 
@@ -339,21 +380,63 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 
 		fsl_elbc_do_read(chip, 0);
 		fsl_elbc_run_command(mtd);
-		return;
 
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
+			 * Maybe there are some reasons of FCM hardware timming,
+			 * we must insert a FIR_OP_NOP(0x00) before FIR_OP_RB.
+			 */
+			fsl_elbc_run_command(mtd);
+			io_to_buffer(mtd, i, 0);
+			io_to_buffer(mtd, i, 1);
+		}
+
+		return;
 	/* READOOB reads only the OOB because no ECC is performed. */
 	case NAND_CMD_READOOB:
 		dev_vdbg(priv->dev,
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
@@ -421,7 +504,14 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
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
@@ -454,27 +544,76 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 		}
 
 		out_be32(&lbc->fcr, fcr);
-		set_addr(mtd, column, page_addr, elbc_fcm_ctrl->oob);
+		if (column >= mtd->writesize && priv->page_size > 1) {
+			/* write oob && writesize > 2048 */
+			set_addr(mtd, 0, page_addr, 0);
+			elbc_fcm_ctrl->index = column;
+		} else {
+			set_addr(mtd, column, page_addr, elbc_fcm_ctrl->oob);
+		}
+
 		return;
 	}
 
 	/* PAGEPROG reuses all of the setup from SEQIN and adds the length */
 	case NAND_CMD_PAGEPROG: {
+		int len;
 		dev_vdbg(priv->dev,
 			 "fsl_elbc_cmdfunc: NAND_CMD_PAGEPROG "
 			 "writing %d bytes.\n", elbc_fcm_ctrl->index);
-
 		/* if the write did not start at 0 or is not a full page
 		 * then set the exact length, otherwise use a full page
 		 * write so the HW generates the ECC.
 		 */
-		if (elbc_fcm_ctrl->oob || elbc_fcm_ctrl->column != 0 ||
+		if (elbc_fcm_ctrl->column >= mtd->writesize) {
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
+			} else
+				len = mtd->writesize + mtd->oobsize -
+					elbc_fcm_ctrl->column;
+			out_be32(&lbc->fbcr, len);
+		} else if (elbc_fcm_ctrl->column != 0 ||
 		    elbc_fcm_ctrl->index != mtd->writesize + mtd->oobsize)
 			out_be32(&lbc->fbcr, elbc_fcm_ctrl->index);
 		else
 			out_be32(&lbc->fbcr, 0);
 
+		if (priv->page_size > 1) {
+			buffer_to_io(mtd, 0, 0);
+			buffer_to_io(mtd, 0, 1);
+		}
+
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
 
@@ -543,7 +682,14 @@ static void fsl_elbc_write_buf(struct mtd_info *mtd, const u8 *buf, int len)
 		len = bufsize - elbc_fcm_ctrl->index;
 	}
 
-	memcpy_toio(&elbc_fcm_ctrl->addr[elbc_fcm_ctrl->index], buf, len);
+	if (mtd->writesize > 2048)
+		memcpy(&elbc_fcm_ctrl->buffer[elbc_fcm_ctrl->index],
+				buf, len);
+	else {
+		memcpy_toio(&elbc_fcm_ctrl->addr[elbc_fcm_ctrl->index],
+				buf, len);
+	}
+
 	/*
 	 * This is workaround for the weird elbc hangs during nand write,
 	 * Scott Wood says: "...perhaps difference in how long it takes a
@@ -589,7 +735,12 @@ static void fsl_elbc_read_buf(struct mtd_info *mtd, u8 *buf, int len)
 
 	avail = min((unsigned int)len,
 			elbc_fcm_ctrl->read_bytes - elbc_fcm_ctrl->index);
-	memcpy_fromio(buf, &elbc_fcm_ctrl->addr[elbc_fcm_ctrl->index], avail);
+	if (mtd->writesize > 2048)
+		memcpy(buf, &elbc_fcm_ctrl->buffer[elbc_fcm_ctrl->index],
+				avail);
+	else
+		memcpy_fromio(buf, &elbc_fcm_ctrl->addr[elbc_fcm_ctrl->index],
+				avail);
 	elbc_fcm_ctrl->index += avail;
 
 	if (len > avail)
@@ -625,10 +776,16 @@ static int fsl_elbc_verify_buf(struct mtd_info *mtd, const u_char *buf, int len)
 		return -EINVAL;
 	}
 
-	for (i = 0; i < len; i++)
-		if (in_8(&elbc_fcm_ctrl->addr[elbc_fcm_ctrl->index + i])
-				!= buf[i])
-			break;
+	if (mtd->writesize > 2048)
+		for (i = 0; i < len; i++)
+			if (elbc_fcm_ctrl->buffer[elbc_fcm_ctrl->index + i]
+					!= buf[i])
+				break;
+	else
+		for (i = 0; i < len; i++)
+			if (in_8(&elbc_fcm_ctrl->addr[elbc_fcm_ctrl->index + i])
+					!= buf[i])
+				break;
 
 	elbc_fcm_ctrl->index += len;
 	return i == len && elbc_fcm_ctrl->status == LTESR_CC ? 0 : -EIO;
@@ -657,6 +814,7 @@ static int fsl_elbc_chip_init_tail(struct mtd_info *mtd)
 	struct fsl_elbc_mtd *priv = chip->priv;
 	struct fsl_lbc_ctrl *ctrl = priv->ctrl;
 	struct fsl_lbc_regs __iomem *lbc = ctrl->regs;
+	struct fsl_elbc_fcm_ctrl *elbc_fcm_ctrl = ctrl->nand;
 	unsigned int al;
 
 	/* calculate FMR Address Length field */
@@ -707,12 +865,17 @@ static int fsl_elbc_chip_init_tail(struct mtd_info *mtd)
 	dev_dbg(priv->dev, "fsl_elbc_init: mtd->oobsize = %d\n",
 		mtd->oobsize);
 
+	kfree(elbc_fcm_ctrl->buffer);
+	elbc_fcm_ctrl->buffer = NULL;
+
 	/* adjust Option Register and ECC to match Flash page size */
 	if (mtd->writesize == 512) {
 		priv->page_size = 0;
 		clrbits32(&lbc->bank[priv->bank].or, OR_FCM_PGS);
-	} else if (mtd->writesize == 2048) {
-		priv->page_size = 1;
+	} else if (mtd->writesize >= 2048) {
+		/* page_size = writesize / 2048 */
+		priv->page_size = mtd->writesize >> 11;
+
 		setbits32(&lbc->bank[priv->bank].or, OR_FCM_PGS);
 		/* adjust ecc setup if needed */
 		if ((in_be32(&lbc->bank[priv->bank].br) & BR_DECC) ==
@@ -723,6 +886,14 @@ static int fsl_elbc_chip_init_tail(struct mtd_info *mtd)
 					   &fsl_elbc_oob_lp_eccm0;
 			chip->badblock_pattern = &largepage_memorybased;
 		}
+
+		/* re-malloc if pagesize > 2048*/
+		if (mtd->writesize > 2048) {
+			elbc_fcm_ctrl->buffer = kmalloc(mtd->writesize +
+						    mtd->oobsize, GFP_KERNEL);
+			if (!elbc_fcm_ctrl->buffer)
+				return -ENOMEM;
+		}
 	} else {
 		dev_err(priv->dev,
 			"fsl_elbc_init: page size %d is not supported\n",
@@ -886,6 +1057,17 @@ static int __devinit fsl_elbc_nand_probe(struct platform_device *pdev)
 			goto err;
 		}
 		elbc_fcm_ctrl->counter++;
+		/*
+		 * Freescale FCM controller has a 2K size limitation of buffer
+		 * RAM, so elbc_fcm_ctrl->buffer have to be used if writesize
+		 * of chip is greater than 2048.
+		 * We malloc a large enough buffer at this point, because we
+		 * don't know writesize before calling nand_scan(). We will
+		 * re-malloc later if needed.
+		 */
+		elbc_fcm_ctrl->buffer = kmalloc(4096 * 6, GFP_KERNEL);
+		if (!elbc_fcm_ctrl->buffer)
+			return -ENOMEM;
 
 		spin_lock_init(&elbc_fcm_ctrl->controller.lock);
 		init_waitqueue_head(&elbc_fcm_ctrl->controller.wq);
-- 
1.7.1


