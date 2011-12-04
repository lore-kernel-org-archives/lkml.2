Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab1LDFtB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 00:49:01 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:1428
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751955Ab1LDFs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 00:48:56 -0500
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
Subject: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support large-page Nand chip
Date: Sun, 4 Dec 2011 12:31:38 +0800
Message-ID: <1322973098-2528-3-git-send-email-shuo.liu@freescale.com>
X-Mailer: git-send-email 1.6.4
In-Reply-To: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com>
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Shuo <shuo.liu@freescale.com>

Freescale FCM controller has a 2K size limitation of buffer RAM. In order
to support the Nand flash chip whose page size is larger than 2K bytes,
we read/write 2k data repeatedly by issuing FIR_OP_RB/FIR_OP_WB and save
them to a large buffer.

Signed-off-by: Liu Shuo <shuo.liu@freescale.com>
---
v3:
    -remove page_size of struct fsl_elbc_mtd.
    -do a oob write by NAND_CMD_RNDIN. 

 drivers/mtd/nand/fsl_elbc_nand.c |  243 ++++++++++++++++++++++++++++++++++----
 1 files changed, 218 insertions(+), 25 deletions(-)

diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
index d634c5f..a92411a 100644
--- a/drivers/mtd/nand/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/fsl_elbc_nand.c
@@ -55,7 +55,6 @@ struct fsl_elbc_mtd {
 	struct device *dev;
 	int bank;               /* Chip select bank number           */
 	u8 __iomem *vbase;      /* Chip select base virtual address  */
-	int page_size;          /* NAND page size (0=512, 1=2048)    */
 	unsigned int fmr;       /* FCM Flash Mode Register value     */
 };
 
@@ -75,6 +74,8 @@ struct fsl_elbc_fcm_ctrl {
 	unsigned int use_mdr;    /* Non zero if the MDR is to be set      */
 	unsigned int oob;        /* Non zero if operating on OOB data     */
 	unsigned int counter;	 /* counter for the initializations	  */
+
+	char *buffer;            /* just be used when pagesize > 2048     */
 };
 
 /* These map to the positions used by the FCM hardware ECC generator */
@@ -150,6 +151,42 @@ static struct nand_bbt_descr bbt_mirror_descr = {
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
+	in_8(elbc_fcm_ctrl->addr + (oob ? 2111 : 2047));
+}
 
 /*
  * Set up the FCM hardware block and page address fields, and the fcm
@@ -166,7 +203,7 @@ static void set_addr(struct mtd_info *mtd, int column, int page_addr, int oob)
 
 	elbc_fcm_ctrl->page = page_addr;
 
-	if (priv->page_size) {
+	if (mtd->writesize >= 2048) {
 		/*
 		 * large page size chip : FPAR[PI] save the lowest 6 bits,
 		 *                        FBAR[BLK] save the other bits.
@@ -193,7 +230,7 @@ static void set_addr(struct mtd_info *mtd, int column, int page_addr, int oob)
 
 	/* for OOB data point to the second half of the buffer */
 	if (oob)
-		elbc_fcm_ctrl->index += priv->page_size ? 2048 : 512;
+		elbc_fcm_ctrl->index += mtd->writesize;
 
 	dev_vdbg(priv->dev, "set_addr: bank=%d, "
 			    "elbc_fcm_ctrl->addr=0x%p (0x%p), "
@@ -272,13 +309,14 @@ static int fsl_elbc_run_command(struct mtd_info *mtd)
 	return 0;
 }
 
-static void fsl_elbc_do_read(struct nand_chip *chip, int oob)
+static void fsl_elbc_do_read(struct mtd_info *mtd, int oob)
 {
+	struct nand_chip *chip = mtd->priv;
 	struct fsl_elbc_mtd *priv = chip->priv;
 	struct fsl_lbc_ctrl *ctrl = priv->ctrl;
 	struct fsl_lbc_regs __iomem *lbc = ctrl->regs;
 
-	if (priv->page_size) {
+	if (mtd->writesize >= 2048) {
 		out_be32(&lbc->fir,
 		         (FIR_OP_CM0 << FIR_OP0_SHIFT) |
 		         (FIR_OP_CA  << FIR_OP1_SHIFT) |
@@ -311,6 +349,7 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 	struct fsl_lbc_ctrl *ctrl = priv->ctrl;
 	struct fsl_elbc_fcm_ctrl *elbc_fcm_ctrl = ctrl->nand;
 	struct fsl_lbc_regs __iomem *lbc = ctrl->regs;
+	int i, n;
 
 	elbc_fcm_ctrl->use_mdr = 0;
 
@@ -337,8 +376,29 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 		elbc_fcm_ctrl->read_bytes = mtd->writesize + mtd->oobsize;
 		elbc_fcm_ctrl->index += column;
 
-		fsl_elbc_do_read(chip, 0);
+		fsl_elbc_do_read(mtd, 0);
 		fsl_elbc_run_command(mtd);
+
+		if (mtd->writesize <= 2048)
+			return;
+
+		/* Continue to read the rest bytes if writesize > 2048 */
+		io_to_buffer(mtd, 0, 0);
+		io_to_buffer(mtd, 0, 1);
+
+		out_be32(&lbc->fir, FIR_OP_RB << FIR_OP1_SHIFT);
+
+		n = mtd->writesize / 2048;
+		for (i = 1; i < n; i++) {
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
@@ -347,13 +407,37 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 		         "fsl_elbc_cmdfunc: NAND_CMD_READOOB, page_addr:"
 			 " 0x%x, column: 0x%x.\n", page_addr, column);
 
-		out_be32(&lbc->fbcr, mtd->oobsize - column);
-		set_addr(mtd, column, page_addr, 1);
+		if (mtd->writesize <= 2048) {
+			out_be32(&lbc->fbcr, mtd->oobsize - column);
+			set_addr(mtd, column, page_addr, 1);
+		} else {
+			out_be32(&lbc->fbcr, 64);
+			set_addr(mtd, 0, page_addr, 1);
+			elbc_fcm_ctrl->index += column;
+		}
 
 		elbc_fcm_ctrl->read_bytes = mtd->writesize + mtd->oobsize;
 
-		fsl_elbc_do_read(chip, 1);
+		fsl_elbc_do_read(mtd, 1);
 		fsl_elbc_run_command(mtd);
+
+		if (mtd->writesize <= 2048)
+			return;
+
+		if (column < 64)
+			io_to_buffer(mtd, 0, 1);
+
+		out_be32(&lbc->fbcr, 2112);
+		out_be32(&lbc->fir, FIR_OP_RB << FIR_OP1_SHIFT);
+		out_be32(&lbc->fpar, in_be32(&lbc->fpar) & ~FPAR_LP_MS);
+
+		n = mtd->writesize / 2048;
+		for (i = 1; i < n; i++) {
+			fsl_elbc_run_command(mtd);
+			if (column < (64 * (i + 1)))
+				io_to_buffer(mtd, i, 1);
+		}
+
 		return;
 
 	/* READID must read all 5 possible bytes while CEB is active */
@@ -429,7 +513,17 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 		      (NAND_CMD_SEQIN    << FCR_CMD2_SHIFT) |
 		      (NAND_CMD_PAGEPROG << FCR_CMD3_SHIFT);
 
-		if (priv->page_size) {
+		if (mtd->writesize > 2048) {
+			/* writesize > 2048 */
+			out_be32(&lbc->fir,
+				 (FIR_OP_CM2 << FIR_OP0_SHIFT) |
+				 (FIR_OP_CA  << FIR_OP1_SHIFT) |
+				 (FIR_OP_PA  << FIR_OP2_SHIFT) |
+				 (FIR_OP_WB  << FIR_OP3_SHIFT));
+
+			if (elbc_fcm_ctrl->oob)
+				fcr |= NAND_CMD_RNDIN << FCR_CMD0_SHIFT;
+		} else if (mtd->writesize == 2048) {
 			out_be32(&lbc->fir,
 			         (FIR_OP_CM2 << FIR_OP0_SHIFT) |
 			         (FIR_OP_CA  << FIR_OP1_SHIFT) |
@@ -464,6 +558,7 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 
 	/* PAGEPROG reuses all of the setup from SEQIN and adds the length */
 	case NAND_CMD_PAGEPROG: {
+		int pos;
 		dev_vdbg(priv->dev,
 		         "fsl_elbc_cmdfunc: NAND_CMD_PAGEPROG "
 			 "writing %d bytes.\n", elbc_fcm_ctrl->index);
@@ -473,13 +568,72 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 		 * write so the HW generates the ECC.
 		 */
 		if (elbc_fcm_ctrl->oob || elbc_fcm_ctrl->column != 0 ||
-		    elbc_fcm_ctrl->index != mtd->writesize + mtd->oobsize)
-			out_be32(&lbc->fbcr,
-				elbc_fcm_ctrl->index - elbc_fcm_ctrl->column);
-		else
+		    elbc_fcm_ctrl->index != mtd->writesize + mtd->oobsize) {
+			if (elbc_fcm_ctrl->oob && mtd->writesize > 2048) {
+				out_be32(&lbc->fbcr, 64);
+			} else {
+				out_be32(&lbc->fbcr, elbc_fcm_ctrl->index
+						- elbc_fcm_ctrl->column);
+			}
+		} else {
 			out_be32(&lbc->fbcr, 0);
+		}
+
+		if (mtd->writesize > 2048) {
+			if (!elbc_fcm_ctrl->oob)
+				buffer_to_io(mtd, 0, 0);
+			buffer_to_io(mtd, 0, 1);
+		}
 
 		fsl_elbc_run_command(mtd);
+
+		if (mtd->writesize <= 2048)
+			return;
+
+		n = mtd->writesize / 2048;
+
+		if (elbc_fcm_ctrl->oob) {
+			pos = 2048;
+			out_be32(&lbc->fir,
+				(FIR_OP_CM0 << FIR_OP0_SHIFT) |
+				(FIR_OP_UA  << FIR_OP1_SHIFT) |
+				(FIR_OP_UA  << FIR_OP2_SHIFT) |
+				(FIR_OP_WB  << FIR_OP3_SHIFT));
+
+			for (i = 1; i < n; i++) {
+				pos += 2112;
+				elbc_fcm_ctrl->mdr = pos;
+				elbc_fcm_ctrl->use_mdr = 1;
+				if (i == n - 1) {
+					out_be32(&lbc->fir,
+						(FIR_OP_CM0 << FIR_OP1_SHIFT) |
+						(FIR_OP_UA  << FIR_OP2_SHIFT) |
+						(FIR_OP_UA  << FIR_OP3_SHIFT) |
+						(FIR_OP_WB  << FIR_OP4_SHIFT) |
+						(FIR_OP_CM3 << FIR_OP5_SHIFT) |
+						(FIR_OP_CW1 << FIR_OP6_SHIFT) |
+						(FIR_OP_RS  << FIR_OP7_SHIFT));
+				}
+				buffer_to_io(mtd, i, 1);
+				fsl_elbc_run_command(mtd);
+			}
+		} else {
+			out_be32(&lbc->fir, FIR_OP_WB << FIR_OP1_SHIFT);
+			for (i = 1; i < n; i++) {
+				if (i == n - 1) {
+					elbc_fcm_ctrl->use_mdr = 1;
+					out_be32(&lbc->fir,
+						(FIR_OP_WB  << FIR_OP1_SHIFT) |
+						(FIR_OP_CM3 << FIR_OP2_SHIFT) |
+						(FIR_OP_CW1 << FIR_OP3_SHIFT) |
+						(FIR_OP_RS  << FIR_OP4_SHIFT));
+				}
+				buffer_to_io(mtd, i, 0);
+				buffer_to_io(mtd, i, 1);
+				fsl_elbc_run_command(mtd);
+			}
+		}
+
 		return;
 	}
 
@@ -500,6 +654,7 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 		 * write-protected, even when it is not.
 		 */
 		setbits8(elbc_fcm_ctrl->addr, NAND_STATUS_WP);
+		elbc_fcm_ctrl->buffer[0] = in_8(elbc_fcm_ctrl->addr);
 		return;
 
 	/* RESET without waiting for the ready line */
@@ -548,7 +703,14 @@ static void fsl_elbc_write_buf(struct mtd_info *mtd, const u8 *buf, int len)
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
@@ -572,8 +734,13 @@ static u8 fsl_elbc_read_byte(struct mtd_info *mtd)
 	struct fsl_elbc_fcm_ctrl *elbc_fcm_ctrl = priv->ctrl->nand;
 
 	/* If there are still bytes in the FCM, then use the next byte. */
-	if (elbc_fcm_ctrl->index < elbc_fcm_ctrl->read_bytes)
-		return in_8(&elbc_fcm_ctrl->addr[elbc_fcm_ctrl->index++]);
+	if (elbc_fcm_ctrl->index < elbc_fcm_ctrl->read_bytes) {
+		int index = elbc_fcm_ctrl->index++;
+		if (mtd->writesize > 2048)
+			return elbc_fcm_ctrl->buffer[index];
+		else
+			return in_8(&elbc_fcm_ctrl->addr[index]);
+	}
 
 	dev_err(priv->dev, "read_byte beyond end of buffer\n");
 	return ERR_BYTE;
@@ -594,7 +761,13 @@ static void fsl_elbc_read_buf(struct mtd_info *mtd, u8 *buf, int len)
 
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
@@ -630,10 +803,17 @@ static int fsl_elbc_verify_buf(struct mtd_info *mtd, const u_char *buf, int len)
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
@@ -714,10 +894,9 @@ static int fsl_elbc_chip_init_tail(struct mtd_info *mtd)
 
 	/* adjust Option Register and ECC to match Flash page size */
 	if (mtd->writesize == 512) {
-		priv->page_size = 0;
 		clrbits32(&lbc->bank[priv->bank].or, OR_FCM_PGS);
-	} else if (mtd->writesize == 2048) {
-		priv->page_size = 1;
+	} else if (mtd->writesize >= 2048 && mtd->writesize <= 16 * 1024) {
+
 		setbits32(&lbc->bank[priv->bank].or, OR_FCM_PGS);
 		/* adjust ecc setup if needed */
 		if ((in_be32(&lbc->bank[priv->bank].br) & BR_DECC) ==
@@ -891,6 +1070,19 @@ static int __devinit fsl_elbc_nand_probe(struct platform_device *pdev)
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
@@ -960,6 +1152,7 @@ static int fsl_elbc_nand_remove(struct platform_device *pdev)
 	elbc_fcm_ctrl->counter--;
 	if (!elbc_fcm_ctrl->counter) {
 		fsl_lbc_ctrl_dev->nand = NULL;
+		kfree(elbc_fcm_ctrl->buffer);
 		kfree(elbc_fcm_ctrl);
 	}
 	mutex_unlock(&fsl_elbc_nand_mutex);
-- 
1.7.1


