Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab2HNOh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:37:57 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44446 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2HNOhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:37:54 -0400
From: Huang Shijie <shijie8@gmail.com>
To: dwmw2@infradead.org
Cc: jdzheng@broadcom.com, sbranden@broadcom.com, mcuos.com@gmail.com,
        maximlevitsky@gmail.com, dedekind1@gmail.com, arnd@arndb.de,
        stigge@antcom.de, tony@atomide.com, jkrzyszt@tis.icnet.pl,
        ralf@linux-mips.org, manuel.lauss@googlemail.com,
        computersforpeace@gmail.com, mikedunn@newsguy.com,
        dbaryshkov@gmail.com, paul.gortmaker@windriver.com,
        b35362@freescale.com, scottwood@freescale.com, jamie@jamieiles.com,
        aletes.xgr@gmail.com, u.kleine-koenig@pengutronix.de,
        s.hauer@pengutronix.de, shmulik.ladkani@gmail.com, nico@linaro.org,
        axel.lin@gmail.com, rmk+kernel@arm.linux.org.uk,
        ivan.djelic@parrot.com, leiwen@marvell.com, hechtb@gmail.com,
        laurent.pinchart@ideasonboard.com, julia@diku.dk,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, fabio.estevam@freescale.com,
        marex@denx.de, Huang Shijie <shijie8@gmail.com>
Subject: [PATCH] mtd: kill MTD_NAND_VERIFY_WRITE
Date: Tue, 14 Aug 2012 22:38:45 -0400
Message-Id: <1344998325-3279-1-git-send-email-shijie8@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just as Artem suggested:

"Both UBI and JFFS2 are able to read verify what they wrote already.
There are also MTD tests which do this verification. So I think there
is no reason to keep this in the NAND layer, let alone wasting RAM in
the driver to support this feature."

So kill MTD_NAND_VERIFY_WRITE entirely.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 drivers/mtd/nand/Kconfig         |    9 -----
 drivers/mtd/nand/ams-delta.c     |   13 --------
 drivers/mtd/nand/au1550nd.c      |   46 ---------------------------
 drivers/mtd/nand/bcm_umi_nand.c  |   22 -------------
 drivers/mtd/nand/cafe_nand.c     |    7 ----
 drivers/mtd/nand/cmx270_nand.c   |   13 --------
 drivers/mtd/nand/diskonchip.c    |   63 --------------------------------------
 drivers/mtd/nand/fsl_elbc_nand.c |   36 ---------------------
 drivers/mtd/nand/fsl_ifc_nand.c  |   41 ------------------------
 drivers/mtd/nand/gpio.c          |   39 -----------------------
 drivers/mtd/nand/lpc32xx_slc.c   |   19 -----------
 drivers/mtd/nand/mpc5121_nfc.c   |   22 -------------
 drivers/mtd/nand/mxc_nand.c      |    9 -----
 drivers/mtd/nand/nand_base.c     |   53 --------------------------------
 drivers/mtd/nand/nandsim.c       |   16 ---------
 drivers/mtd/nand/ndfc.c          |   13 --------
 drivers/mtd/nand/nuc900_nand.c   |   17 ----------
 drivers/mtd/nand/omap2.c         |   23 --------------
 drivers/mtd/nand/pxa3xx_nand.c   |    7 ----
 drivers/mtd/nand/r852.c          |   22 -------------
 drivers/mtd/nand/sh_flctl.c      |   11 ------
 drivers/mtd/nand/socrates_nand.c |   19 -----------
 drivers/mtd/nand/tmio_nand.c     |   13 --------
 drivers/mtd/nand/txx9ndfmc.c     |   13 --------
 include/linux/mtd/nand.h         |    3 --
 25 files changed, 0 insertions(+), 549 deletions(-)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 588e989..0ca7257 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -22,15 +22,6 @@ menuconfig MTD_NAND
 
 if MTD_NAND
 
-config MTD_NAND_VERIFY_WRITE
-	bool "Verify NAND page writes"
-	help
-	  This adds an extra check when data is written to the flash. The
-	  NAND flash device internally checks only bits transitioning
-	  from 1 to 0. There is a rare possibility that even though the
-	  device thinks the write was successful, a bit could have been
-	  flipped accidentally due to device wear or something else.
-
 config MTD_NAND_BCH
 	tristate
 	select BCH
diff --git a/drivers/mtd/nand/ams-delta.c b/drivers/mtd/nand/ams-delta.c
index 861ca8f..2d73f23 100644
--- a/drivers/mtd/nand/ams-delta.c
+++ b/drivers/mtd/nand/ams-delta.c
@@ -103,18 +103,6 @@ static void ams_delta_read_buf(struct mtd_info *mtd, u_char *buf, int len)
 		buf[i] = ams_delta_read_byte(mtd);
 }
 
-static int ams_delta_verify_buf(struct mtd_info *mtd, const u_char *buf,
-				int len)
-{
-	int i;
-
-	for (i=0; i<len; i++)
-		if (buf[i] != ams_delta_read_byte(mtd))
-			return -EFAULT;
-
-	return 0;
-}
-
 /*
  * Command control function
  *
@@ -233,7 +221,6 @@ static int __devinit ams_delta_init(struct platform_device *pdev)
 	this->read_byte = ams_delta_read_byte;
 	this->write_buf = ams_delta_write_buf;
 	this->read_buf = ams_delta_read_buf;
-	this->verify_buf = ams_delta_verify_buf;
 	this->cmd_ctrl = ams_delta_hwcontrol;
 	if (gpio_request(AMS_DELTA_GPIO_PIN_NAND_RB, "nand_rdy") == 0) {
 		this->dev_ready = ams_delta_nand_ready;
diff --git a/drivers/mtd/nand/au1550nd.c b/drivers/mtd/nand/au1550nd.c
index 9f609d2..5c47b20 100644
--- a/drivers/mtd/nand/au1550nd.c
+++ b/drivers/mtd/nand/au1550nd.c
@@ -141,28 +141,6 @@ static void au_read_buf(struct mtd_info *mtd, u_char *buf, int len)
 }
 
 /**
- * au_verify_buf -  Verify chip data against buffer
- * @mtd:	MTD device structure
- * @buf:	buffer containing the data to compare
- * @len:	number of bytes to compare
- *
- * verify function for 8bit buswidth
- */
-static int au_verify_buf(struct mtd_info *mtd, const u_char *buf, int len)
-{
-	int i;
-	struct nand_chip *this = mtd->priv;
-
-	for (i = 0; i < len; i++) {
-		if (buf[i] != readb(this->IO_ADDR_R))
-			return -EFAULT;
-		au_sync();
-	}
-
-	return 0;
-}
-
-/**
  * au_write_buf16 -  write buffer to chip
  * @mtd:	MTD device structure
  * @buf:	data buffer
@@ -205,29 +183,6 @@ static void au_read_buf16(struct mtd_info *mtd, u_char *buf, int len)
 	}
 }
 
-/**
- * au_verify_buf16 -  Verify chip data against buffer
- * @mtd:	MTD device structure
- * @buf:	buffer containing the data to compare
- * @len:	number of bytes to compare
- *
- * verify function for 16bit buswidth
- */
-static int au_verify_buf16(struct mtd_info *mtd, const u_char *buf, int len)
-{
-	int i;
-	struct nand_chip *this = mtd->priv;
-	u16 *p = (u16 *) buf;
-	len >>= 1;
-
-	for (i = 0; i < len; i++) {
-		if (p[i] != readw(this->IO_ADDR_R))
-			return -EFAULT;
-		au_sync();
-	}
-	return 0;
-}
-
 /* Select the chip by setting nCE to low */
 #define NAND_CTL_SETNCE		1
 /* Deselect the chip by setting nCE to high */
@@ -516,7 +471,6 @@ static int __devinit au1550nd_probe(struct platform_device *pdev)
 	this->read_word = au_read_word;
 	this->write_buf = (pd->devwidth) ? au_write_buf16 : au_write_buf;
 	this->read_buf = (pd->devwidth) ? au_read_buf16 : au_read_buf;
-	this->verify_buf = (pd->devwidth) ? au_verify_buf16 : au_verify_buf;
 
 	ret = nand_scan(&ctx->info, 1);
 	if (ret) {
diff --git a/drivers/mtd/nand/bcm_umi_nand.c b/drivers/mtd/nand/bcm_umi_nand.c
index c855e7c..3fcbcbc 100644
--- a/drivers/mtd/nand/bcm_umi_nand.c
+++ b/drivers/mtd/nand/bcm_umi_nand.c
@@ -332,27 +332,6 @@ static void bcm_umi_nand_read_buf(struct mtd_info *mtd, u_char * buf, int len)
 #endif
 }
 
-static uint8_t readbackbuf[NAND_MAX_PAGESIZE];
-static int bcm_umi_nand_verify_buf(struct mtd_info *mtd, const u_char * buf,
-				   int len)
-{
-	/*
-	 * Try to readback page with ECC correction. This is necessary
-	 * for MLC parts which may have permanently stuck bits.
-	 */
-	struct nand_chip *chip = mtd->priv;
-	int ret = chip->ecc.read_page(mtd, chip, readbackbuf, 0, 0);
-	if (ret < 0)
-		return -EFAULT;
-	else {
-		if (memcmp(readbackbuf, buf, len) == 0)
-			return 0;
-
-		return -EFAULT;
-	}
-	return 0;
-}
-
 static int __devinit bcm_umi_nand_probe(struct platform_device *pdev)
 {
 	struct nand_chip *this;
@@ -416,7 +395,6 @@ static int __devinit bcm_umi_nand_probe(struct platform_device *pdev)
 
 	this->write_buf = bcm_umi_nand_write_buf;
 	this->read_buf = bcm_umi_nand_read_buf;
-	this->verify_buf = bcm_umi_nand_verify_buf;
 
 	this->cmd_ctrl = bcm_umi_nand_hwcontrol;
 	this->ecc.mode = NAND_ECC_HW;
diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
index 08248a0..2bb7170 100644
--- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -576,13 +576,6 @@ static int cafe_nand_write_page(struct mtd_info *mtd, struct nand_chip *chip,
 		status = chip->waitfunc(mtd, chip);
 	}
 
-#ifdef CONFIG_MTD_NAND_VERIFY_WRITE
-	/* Send command to read back the data */
-	chip->cmdfunc(mtd, NAND_CMD_READ0, 0, page);
-
-	if (chip->verify_buf(mtd, buf, mtd->writesize))
-		return -EIO;
-#endif
 	return 0;
 }
 
diff --git a/drivers/mtd/nand/cmx270_nand.c b/drivers/mtd/nand/cmx270_nand.c
index 1024bfc..39b2ef8 100644
--- a/drivers/mtd/nand/cmx270_nand.c
+++ b/drivers/mtd/nand/cmx270_nand.c
@@ -76,18 +76,6 @@ static void cmx270_read_buf(struct mtd_info *mtd, u_char *buf, int len)
 		*buf++ = readl(this->IO_ADDR_R) >> 16;
 }
 
-static int cmx270_verify_buf(struct mtd_info *mtd, const u_char *buf, int len)
-{
-	int i;
-	struct nand_chip *this = mtd->priv;
-
-	for (i=0; i<len; i++)
-		if (buf[i] != (u_char)(readl(this->IO_ADDR_R) >> 16))
-			return -EFAULT;
-
-	return 0;
-}
-
 static inline void nand_cs_on(void)
 {
 	gpio_set_value(GPIO_NAND_CS, 0);
@@ -209,7 +197,6 @@ static int __init cmx270_init(void)
 	this->read_byte = cmx270_read_byte;
 	this->read_buf = cmx270_read_buf;
 	this->write_buf = cmx270_write_buf;
-	this->verify_buf = cmx270_verify_buf;
 
 	/* Scan to find existence of the device */
 	if (nand_scan (cmx270_nand_mtd, 1)) {
diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
index e2ca067..256eb30 100644
--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -376,19 +376,6 @@ static void doc2000_readbuf_dword(struct mtd_info *mtd, u_char *buf, int len)
 	}
 }
 
-static int doc2000_verifybuf(struct mtd_info *mtd, const u_char *buf, int len)
-{
-	struct nand_chip *this = mtd->priv;
-	struct doc_priv *doc = this->priv;
-	void __iomem *docptr = doc->virtadr;
-	int i;
-
-	for (i = 0; i < len; i++)
-		if (buf[i] != ReadDOC(docptr, 2k_CDSN_IO))
-			return -EFAULT;
-	return 0;
-}
-
 static uint16_t __init doc200x_ident_chip(struct mtd_info *mtd, int nr)
 {
 	struct nand_chip *this = mtd->priv;
@@ -526,26 +513,6 @@ static void doc2001_readbuf(struct mtd_info *mtd, u_char *buf, int len)
 	buf[i] = ReadDOC(docptr, LastDataRead);
 }
 
-static int doc2001_verifybuf(struct mtd_info *mtd, const u_char *buf, int len)
-{
-	struct nand_chip *this = mtd->priv;
-	struct doc_priv *doc = this->priv;
-	void __iomem *docptr = doc->virtadr;
-	int i;
-
-	/* Start read pipeline */
-	ReadDOC(docptr, ReadPipeInit);
-
-	for (i = 0; i < len - 1; i++)
-		if (buf[i] != ReadDOC(docptr, Mil_CDSN_IO)) {
-			ReadDOC(docptr, LastDataRead);
-			return i;
-		}
-	if (buf[i] != ReadDOC(docptr, LastDataRead))
-		return i;
-	return 0;
-}
-
 static u_char doc2001plus_read_byte(struct mtd_info *mtd)
 {
 	struct nand_chip *this = mtd->priv;
@@ -610,33 +577,6 @@ static void doc2001plus_readbuf(struct mtd_info *mtd, u_char *buf, int len)
 		printk("\n");
 }
 
-static int doc2001plus_verifybuf(struct mtd_info *mtd, const u_char *buf, int len)
-{
-	struct nand_chip *this = mtd->priv;
-	struct doc_priv *doc = this->priv;
-	void __iomem *docptr = doc->virtadr;
-	int i;
-
-	if (debug)
-		printk("verifybuf of %d bytes: ", len);
-
-	/* Start read pipeline */
-	ReadDOC(docptr, Mplus_ReadPipeInit);
-	ReadDOC(docptr, Mplus_ReadPipeInit);
-
-	for (i = 0; i < len - 2; i++)
-		if (buf[i] != ReadDOC(docptr, Mil_CDSN_IO)) {
-			ReadDOC(docptr, Mplus_LastDataRead);
-			ReadDOC(docptr, Mplus_LastDataRead);
-			return i;
-		}
-	if (buf[len - 2] != ReadDOC(docptr, Mplus_LastDataRead))
-		return len - 2;
-	if (buf[len - 1] != ReadDOC(docptr, Mplus_LastDataRead))
-		return len - 1;
-	return 0;
-}
-
 static void doc2001plus_select_chip(struct mtd_info *mtd, int chip)
 {
 	struct nand_chip *this = mtd->priv;
@@ -1432,7 +1372,6 @@ static inline int __init doc2000_init(struct mtd_info *mtd)
 	this->read_byte = doc2000_read_byte;
 	this->write_buf = doc2000_writebuf;
 	this->read_buf = doc2000_readbuf;
-	this->verify_buf = doc2000_verifybuf;
 	this->scan_bbt = nftl_scan_bbt;
 
 	doc->CDSNControl = CDSN_CTRL_FLASH_IO | CDSN_CTRL_ECC_IO;
@@ -1449,7 +1388,6 @@ static inline int __init doc2001_init(struct mtd_info *mtd)
 	this->read_byte = doc2001_read_byte;
 	this->write_buf = doc2001_writebuf;
 	this->read_buf = doc2001_readbuf;
-	this->verify_buf = doc2001_verifybuf;
 
 	ReadDOC(doc->virtadr, ChipID);
 	ReadDOC(doc->virtadr, ChipID);
@@ -1480,7 +1418,6 @@ static inline int __init doc2001plus_init(struct mtd_info *mtd)
 	this->read_byte = doc2001plus_read_byte;
 	this->write_buf = doc2001plus_writebuf;
 	this->read_buf = doc2001plus_readbuf;
-	this->verify_buf = doc2001plus_verifybuf;
 	this->scan_bbt = inftl_scan_bbt;
 	this->cmd_ctrl = NULL;
 	this->select_chip = doc2001plus_select_chip;
diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
index 8143873..cc1480a 100644
--- a/drivers/mtd/nand/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/fsl_elbc_nand.c
@@ -614,41 +614,6 @@ static void fsl_elbc_read_buf(struct mtd_info *mtd, u8 *buf, int len)
 		        len, avail);
 }
 
-/*
- * Verify buffer against the FCM Controller Data Buffer
- */
-static int fsl_elbc_verify_buf(struct mtd_info *mtd, const u_char *buf, int len)
-{
-	struct nand_chip *chip = mtd->priv;
-	struct fsl_elbc_mtd *priv = chip->priv;
-	struct fsl_elbc_fcm_ctrl *elbc_fcm_ctrl = priv->ctrl->nand;
-	int i;
-
-	if (len < 0) {
-		dev_err(priv->dev, "write_buf of %d bytes", len);
-		return -EINVAL;
-	}
-
-	if ((unsigned int)len >
-			elbc_fcm_ctrl->read_bytes - elbc_fcm_ctrl->index) {
-		dev_err(priv->dev,
-			"verify_buf beyond end of buffer "
-			"(%d requested, %u available)\n",
-			len, elbc_fcm_ctrl->read_bytes - elbc_fcm_ctrl->index);
-
-		elbc_fcm_ctrl->index = elbc_fcm_ctrl->read_bytes;
-		return -EINVAL;
-	}
-
-	for (i = 0; i < len; i++)
-		if (in_8(&elbc_fcm_ctrl->addr[elbc_fcm_ctrl->index + i])
-				!= buf[i])
-			break;
-
-	elbc_fcm_ctrl->index += len;
-	return i == len && elbc_fcm_ctrl->status == LTESR_CC ? 0 : -EIO;
-}
-
 /* This function is called after Program and Erase Operations to
  * check for success or failure.
  */
@@ -798,7 +763,6 @@ static int fsl_elbc_chip_init(struct fsl_elbc_mtd *priv)
 	chip->read_byte = fsl_elbc_read_byte;
 	chip->write_buf = fsl_elbc_write_buf;
 	chip->read_buf = fsl_elbc_read_buf;
-	chip->verify_buf = fsl_elbc_verify_buf;
 	chip->select_chip = fsl_elbc_select_chip;
 	chip->cmdfunc = fsl_elbc_cmdfunc;
 	chip->waitfunc = fsl_elbc_wait;
diff --git a/drivers/mtd/nand/fsl_ifc_nand.c b/drivers/mtd/nand/fsl_ifc_nand.c
index 1f71b54..e92d223 100644
--- a/drivers/mtd/nand/fsl_ifc_nand.c
+++ b/drivers/mtd/nand/fsl_ifc_nand.c
@@ -627,46 +627,6 @@ static void fsl_ifc_read_buf(struct mtd_info *mtd, u8 *buf, int len)
 }
 
 /*
- * Verify buffer against the IFC Controller Data Buffer
- */
-static int fsl_ifc_verify_buf(struct mtd_info *mtd,
-			       const u_char *buf, int len)
-{
-	struct nand_chip *chip = mtd->priv;
-	struct fsl_ifc_mtd *priv = chip->priv;
-	struct fsl_ifc_ctrl *ctrl = priv->ctrl;
-	struct fsl_ifc_nand_ctrl *nctrl = ifc_nand_ctrl;
-	int i;
-
-	if (len < 0) {
-		dev_err(priv->dev, "%s: write_buf of %d bytes", __func__, len);
-		return -EINVAL;
-	}
-
-	if ((unsigned int)len > nctrl->read_bytes - nctrl->index) {
-		dev_err(priv->dev,
-			"%s: beyond end of buffer (%d requested, %u available)\n",
-			__func__, len, nctrl->read_bytes - nctrl->index);
-
-		nctrl->index = nctrl->read_bytes;
-		return -EINVAL;
-	}
-
-	for (i = 0; i < len; i++)
-		if (in_8(&nctrl->addr[nctrl->index + i]) != buf[i])
-			break;
-
-	nctrl->index += len;
-
-	if (i != len)
-		return -EIO;
-	if (ctrl->nand_stat != IFC_NAND_EVTER_STAT_OPC)
-		return -EIO;
-
-	return 0;
-}
-
-/*
  * This function is called after Program and Erase Operations to
  * check for success or failure.
  */
@@ -796,7 +756,6 @@ static int fsl_ifc_chip_init(struct fsl_ifc_mtd *priv)
 
 	chip->write_buf = fsl_ifc_write_buf;
 	chip->read_buf = fsl_ifc_read_buf;
-	chip->verify_buf = fsl_ifc_verify_buf;
 	chip->select_chip = fsl_ifc_select_chip;
 	chip->cmdfunc = fsl_ifc_cmdfunc;
 	chip->waitfunc = fsl_ifc_wait;
diff --git a/drivers/mtd/nand/gpio.c b/drivers/mtd/nand/gpio.c
index 27000a5..ce6a284 100644
--- a/drivers/mtd/nand/gpio.c
+++ b/drivers/mtd/nand/gpio.c
@@ -100,23 +100,6 @@ static void gpio_nand_readbuf(struct mtd_info *mtd, u_char *buf, int len)
 	readsb(this->IO_ADDR_R, buf, len);
 }
 
-static int gpio_nand_verifybuf(struct mtd_info *mtd, const u_char *buf, int len)
-{
-	struct nand_chip *this = mtd->priv;
-	unsigned char read, *p = (unsigned char *) buf;
-	int i, err = 0;
-
-	for (i = 0; i < len; i++) {
-		read = readb(this->IO_ADDR_R);
-		if (read != p[i]) {
-			pr_debug("%s: err at %d (read %04x vs %04x)\n",
-			       __func__, i, read, p[i]);
-			err = -EFAULT;
-		}
-	}
-	return err;
-}
-
 static void gpio_nand_writebuf16(struct mtd_info *mtd, const u_char *buf,
 				 int len)
 {
@@ -148,26 +131,6 @@ static void gpio_nand_readbuf16(struct mtd_info *mtd, u_char *buf, int len)
 	}
 }
 
-static int gpio_nand_verifybuf16(struct mtd_info *mtd, const u_char *buf,
-				 int len)
-{
-	struct nand_chip *this = mtd->priv;
-	unsigned short read, *p = (unsigned short *) buf;
-	int i, err = 0;
-	len >>= 1;
-
-	for (i = 0; i < len; i++) {
-		read = readw(this->IO_ADDR_R);
-		if (read != p[i]) {
-			pr_debug("%s: err at %d (read %04x vs %04x)\n",
-			       __func__, i, read, p[i]);
-			err = -EFAULT;
-		}
-	}
-	return err;
-}
-
-
 static int gpio_nand_devready(struct mtd_info *mtd)
 {
 	struct gpiomtd *gpiomtd = gpio_nand_getpriv(mtd);
@@ -391,11 +354,9 @@ static int __devinit gpio_nand_probe(struct platform_device *dev)
 	if (this->options & NAND_BUSWIDTH_16) {
 		this->read_buf   = gpio_nand_readbuf16;
 		this->write_buf  = gpio_nand_writebuf16;
-		this->verify_buf = gpio_nand_verifybuf16;
 	} else {
 		this->read_buf   = gpio_nand_readbuf;
 		this->write_buf  = gpio_nand_writebuf;
-		this->verify_buf = gpio_nand_verifybuf;
 	}
 
 	/* set the mtd private data for the nand driver */
diff --git a/drivers/mtd/nand/lpc32xx_slc.c b/drivers/mtd/nand/lpc32xx_slc.c
index c8c1d06..6d7d3cb 100644
--- a/drivers/mtd/nand/lpc32xx_slc.c
+++ b/drivers/mtd/nand/lpc32xx_slc.c
@@ -368,24 +368,6 @@ static void lpc32xx_nand_write_buf(struct mtd_info *mtd, const uint8_t *buf, int
 }
 
 /*
- * Verify data in buffer to data on device
- */
-static int lpc32xx_verify_buf(struct mtd_info *mtd, const uint8_t *buf, int len)
-{
-	struct nand_chip *chip = mtd->priv;
-	struct lpc32xx_nand_host *host = chip->priv;
-	int i;
-
-	/* DATA register must be read as 32 bits or it will fail */
-	for (i = 0; i < len; i++) {
-		if (buf[i] != (uint8_t)readl(SLC_DATA(host->io_base)))
-			return -EFAULT;
-	}
-
-	return 0;
-}
-
-/*
  * Read the OOB data from the device without ECC using FIFO method
  */
 static int lpc32xx_nand_read_oob_syndrome(struct mtd_info *mtd,
@@ -862,7 +844,6 @@ static int __devinit lpc32xx_nand_probe(struct platform_device *pdev)
 	chip->ecc.correct = nand_correct_data;
 	chip->ecc.strength = 1;
 	chip->ecc.hwctl = lpc32xx_nand_ecc_enable;
-	chip->verify_buf = lpc32xx_verify_buf;
 
 	/* bitflip_threshold's default is defined as ecc_strength anyway.
 	 * Unfortunately, it is set only later at add_mtd_device(). Meanwhile
diff --git a/drivers/mtd/nand/mpc5121_nfc.c b/drivers/mtd/nand/mpc5121_nfc.c
index c259c24..f776c85 100644
--- a/drivers/mtd/nand/mpc5121_nfc.c
+++ b/drivers/mtd/nand/mpc5121_nfc.c
@@ -506,27 +506,6 @@ static void mpc5121_nfc_write_buf(struct mtd_info *mtd,
 	mpc5121_nfc_buf_copy(mtd, (u_char *)buf, len, 1);
 }
 
-/* Compare buffer with NAND flash */
-static int mpc5121_nfc_verify_buf(struct mtd_info *mtd,
-						const u_char *buf, int len)
-{
-	u_char tmp[256];
-	uint bsize;
-
-	while (len) {
-		bsize = min(len, 256);
-		mpc5121_nfc_read_buf(mtd, tmp, bsize);
-
-		if (memcmp(buf, tmp, bsize))
-			return 1;
-
-		buf += bsize;
-		len -= bsize;
-	}
-
-	return 0;
-}
-
 /* Read byte from NFC buffers */
 static u8 mpc5121_nfc_read_byte(struct mtd_info *mtd)
 {
@@ -732,7 +711,6 @@ static int __devinit mpc5121_nfc_probe(struct platform_device *op)
 	chip->read_word = mpc5121_nfc_read_word;
 	chip->read_buf = mpc5121_nfc_read_buf;
 	chip->write_buf = mpc5121_nfc_write_buf;
-	chip->verify_buf = mpc5121_nfc_verify_buf;
 	chip->select_chip = mpc5121_nfc_select_chip;
 	chip->bbt_options = NAND_BBT_USE_FLASH;
 	chip->ecc.mode = NAND_ECC_SOFT;
diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index 3f94e1f..bfee9eb 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -746,14 +746,6 @@ static void mxc_nand_read_buf(struct mtd_info *mtd, u_char *buf, int len)
 	host->buf_start += n;
 }
 
-/* Used by the upper layer to verify the data in NAND Flash
- * with the data in the buf. */
-static int mxc_nand_verify_buf(struct mtd_info *mtd,
-				const u_char *buf, int len)
-{
-	return -EFAULT;
-}
-
 /* This function is used by upper layer for select and
  * deselect of the NAND chip */
 static void mxc_nand_select_chip_v1_v3(struct mtd_info *mtd, int chip)
@@ -1406,7 +1398,6 @@ static int __init mxcnd_probe(struct platform_device *pdev)
 	this->read_word = mxc_nand_read_word;
 	this->write_buf = mxc_nand_write_buf;
 	this->read_buf = mxc_nand_read_buf;
-	this->verify_buf = mxc_nand_verify_buf;
 
 	host->clk = devm_clk_get(&pdev->dev, "nfc");
 	if (IS_ERR(host->clk))
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index ead301a..5a1689a 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -243,25 +243,6 @@ static void nand_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
 }
 
 /**
- * nand_verify_buf - [DEFAULT] Verify chip data against buffer
- * @mtd: MTD device structure
- * @buf: buffer containing the data to compare
- * @len: number of bytes to compare
- *
- * Default verify function for 8bit buswidth.
- */
-static int nand_verify_buf(struct mtd_info *mtd, const uint8_t *buf, int len)
-{
-	int i;
-	struct nand_chip *chip = mtd->priv;
-
-	for (i = 0; i < len; i++)
-		if (buf[i] != readb(chip->IO_ADDR_R))
-			return -EFAULT;
-	return 0;
-}
-
-/**
  * nand_write_buf16 - [DEFAULT] write buffer to chip
  * @mtd: MTD device structure
  * @buf: data buffer
@@ -301,28 +282,6 @@ static void nand_read_buf16(struct mtd_info *mtd, uint8_t *buf, int len)
 }
 
 /**
- * nand_verify_buf16 - [DEFAULT] Verify chip data against buffer
- * @mtd: MTD device structure
- * @buf: buffer containing the data to compare
- * @len: number of bytes to compare
- *
- * Default verify function for 16bit buswidth.
- */
-static int nand_verify_buf16(struct mtd_info *mtd, const uint8_t *buf, int len)
-{
-	int i;
-	struct nand_chip *chip = mtd->priv;
-	u16 *p = (u16 *) buf;
-	len >>= 1;
-
-	for (i = 0; i < len; i++)
-		if (p[i] != readw(chip->IO_ADDR_R))
-			return -EFAULT;
-
-	return 0;
-}
-
-/**
  * nand_block_bad - [DEFAULT] Read bad block marker from the chip
  * @mtd: MTD device structure
  * @ofs: offset from device start
@@ -2120,16 +2079,6 @@ static int nand_write_page(struct mtd_info *mtd, struct nand_chip *chip,
 		status = chip->waitfunc(mtd, chip);
 	}
 
-#ifdef CONFIG_MTD_NAND_VERIFY_WRITE
-	/* Send command to read back the data */
-	chip->cmdfunc(mtd, NAND_CMD_READ0, 0, page);
-
-	if (chip->verify_buf(mtd, buf, mtd->writesize))
-		return -EIO;
-
-	/* Make sure the next page prog is preceded by a status read */
-	chip->cmdfunc(mtd, NAND_CMD_STATUS, -1, -1);
-#endif
 	return 0;
 }
 
@@ -2804,8 +2753,6 @@ static void nand_set_defaults(struct nand_chip *chip, int busw)
 		chip->write_buf = busw ? nand_write_buf16 : nand_write_buf;
 	if (!chip->read_buf)
 		chip->read_buf = busw ? nand_read_buf16 : nand_read_buf;
-	if (!chip->verify_buf)
-		chip->verify_buf = busw ? nand_verify_buf16 : nand_verify_buf;
 	if (!chip->scan_bbt)
 		chip->scan_bbt = nand_default_bbt;
 
diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
index cf0cd31..21e64b5 100644
--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -447,8 +447,6 @@ static unsigned int rptwear_cnt = 0;
 /* MTD structure for NAND controller */
 static struct mtd_info *nsmtd;
 
-static u_char ns_verify_buf[NS_LARGEST_PAGE_SIZE];
-
 /*
  * Allocate array of page pointers, create slab allocation for an array
  * and initialize the array by NULL pointers.
@@ -2189,19 +2187,6 @@ static void ns_nand_read_buf(struct mtd_info *mtd, u_char *buf, int len)
 	return;
 }
 
-static int ns_nand_verify_buf(struct mtd_info *mtd, const u_char *buf, int len)
-{
-	ns_nand_read_buf(mtd, (u_char *)&ns_verify_buf[0], len);
-
-	if (!memcmp(buf, &ns_verify_buf[0], len)) {
-		NS_DBG("verify_buf: the buffer is OK\n");
-		return 0;
-	} else {
-		NS_DBG("verify_buf: the buffer is wrong\n");
-		return -EFAULT;
-	}
-}
-
 /*
  * Module initialization function
  */
@@ -2236,7 +2221,6 @@ static int __init ns_init_module(void)
 	chip->dev_ready  = ns_device_ready;
 	chip->write_buf  = ns_nand_write_buf;
 	chip->read_buf   = ns_nand_read_buf;
-	chip->verify_buf = ns_nand_verify_buf;
 	chip->read_word  = ns_nand_read_word;
 	chip->ecc.mode   = NAND_ECC_SOFT;
 	/* The NAND_SKIP_BBTSCAN option is necessary for 'overridesize' */
diff --git a/drivers/mtd/nand/ndfc.c b/drivers/mtd/nand/ndfc.c
index 2b6f632..5fd3f01 100644
--- a/drivers/mtd/nand/ndfc.c
+++ b/drivers/mtd/nand/ndfc.c
@@ -140,18 +140,6 @@ static void ndfc_write_buf(struct mtd_info *mtd, const uint8_t *buf, int len)
 		out_be32(ndfc->ndfcbase + NDFC_DATA, *p++);
 }
 
-static int ndfc_verify_buf(struct mtd_info *mtd, const uint8_t *buf, int len)
-{
-	struct nand_chip *chip = mtd->priv;
-	struct ndfc_controller *ndfc = chip->priv;
-	uint32_t *p = (uint32_t *) buf;
-
-	for(;len > 0; len -= 4)
-		if (*p++ != in_be32(ndfc->ndfcbase + NDFC_DATA))
-			return -EFAULT;
-	return 0;
-}
-
 /*
  * Initialize chip structure
  */
@@ -172,7 +160,6 @@ static int ndfc_chip_init(struct ndfc_controller *ndfc,
 	chip->controller = &ndfc->ndfc_control;
 	chip->read_buf = ndfc_read_buf;
 	chip->write_buf = ndfc_write_buf;
-	chip->verify_buf = ndfc_verify_buf;
 	chip->ecc.correct = nand_correct_data;
 	chip->ecc.hwctl = ndfc_enable_hwecc;
 	chip->ecc.calculate = ndfc_calculate_ecc;
diff --git a/drivers/mtd/nand/nuc900_nand.c b/drivers/mtd/nand/nuc900_nand.c
index 8febe46..94dc46b 100644
--- a/drivers/mtd/nand/nuc900_nand.c
+++ b/drivers/mtd/nand/nuc900_nand.c
@@ -112,22 +112,6 @@ static void nuc900_nand_write_buf(struct mtd_info *mtd,
 		write_data_reg(nand, buf[i]);
 }
 
-static int nuc900_verify_buf(struct mtd_info *mtd,
-			     const unsigned char *buf, int len)
-{
-	int i;
-	struct nuc900_nand *nand;
-
-	nand = container_of(mtd, struct nuc900_nand, mtd);
-
-	for (i = 0; i < len; i++) {
-		if (buf[i] != (unsigned char)read_data_reg(nand))
-			return -EFAULT;
-	}
-
-	return 0;
-}
-
 static int nuc900_check_rb(struct nuc900_nand *nand)
 {
 	unsigned int val;
@@ -292,7 +276,6 @@ static int __devinit nuc900_nand_probe(struct platform_device *pdev)
 	chip->read_byte		= nuc900_nand_read_byte;
 	chip->write_buf		= nuc900_nand_write_buf;
 	chip->read_buf		= nuc900_nand_read_buf;
-	chip->verify_buf	= nuc900_verify_buf;
 	chip->chip_delay	= 50;
 	chip->options		= 0;
 	chip->ecc.mode		= NAND_ECC_SOFT;
diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index ac4fd75..1c46300 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -614,27 +614,6 @@ out_copy:
 }
 
 /**
- * omap_verify_buf - Verify chip data against buffer
- * @mtd: MTD device structure
- * @buf: buffer containing the data to compare
- * @len: number of bytes to compare
- */
-static int omap_verify_buf(struct mtd_info *mtd, const u_char * buf, int len)
-{
-	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
-							mtd);
-	u16 *p = (u16 *) buf;
-
-	len >>= 1;
-	while (len--) {
-		if (*p++ != cpu_to_le16(readw(info->nand.IO_ADDR_R)))
-			return -EFAULT;
-	}
-
-	return 0;
-}
-
-/**
  * gen_true_ecc - This function will generate true ECC value
  * @ecc_buf: buffer to store ecc code
  *
@@ -1285,8 +1264,6 @@ static int __devinit omap_nand_probe(struct platform_device *pdev)
 		goto out_release_mem_region;
 	}
 
-	info->nand.verify_buf = omap_verify_buf;
-
 	/* selsect the ecc type */
 	if (pdata->ecc_opt == OMAP_ECC_HAMMING_CODE_DEFAULT)
 		info->nand.ecc.mode = NAND_ECC_SOFT;
diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
index e8a1ae9..5df91d5 100644
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -771,12 +771,6 @@ static void pxa3xx_nand_write_buf(struct mtd_info *mtd,
 	info->buf_start += real_len;
 }
 
-static int pxa3xx_nand_verify_buf(struct mtd_info *mtd,
-		const uint8_t *buf, int len)
-{
-	return 0;
-}
-
 static void pxa3xx_nand_select_chip(struct mtd_info *mtd, int chip)
 {
 	return;
@@ -1069,7 +1063,6 @@ static int alloc_nand_resource(struct platform_device *pdev)
 		chip->read_byte		= pxa3xx_nand_read_byte;
 		chip->read_buf		= pxa3xx_nand_read_buf;
 		chip->write_buf		= pxa3xx_nand_write_buf;
-		chip->verify_buf	= pxa3xx_nand_verify_buf;
 	}
 
 	spin_lock_init(&chip->controller->lock);
diff --git a/drivers/mtd/nand/r852.c b/drivers/mtd/nand/r852.c
index 8cb6277..4495f85 100644
--- a/drivers/mtd/nand/r852.c
+++ b/drivers/mtd/nand/r852.c
@@ -309,27 +309,6 @@ static uint8_t r852_read_byte(struct mtd_info *mtd)
 	return r852_read_reg(dev, R852_DATALINE);
 }
 
-
-/*
- * Readback the buffer to verify it
- */
-int r852_verify_buf(struct mtd_info *mtd, const uint8_t *buf, int len)
-{
-	struct r852_device *dev = r852_get_dev(mtd);
-
-	/* We can't be sure about anything here... */
-	if (dev->card_unstable)
-		return -1;
-
-	/* This will never happen, unless you wired up a nand chip
-		with > 512 bytes page size to the reader */
-	if (len > SM_SECTOR_SIZE)
-		return 0;
-
-	r852_read_buf(mtd, dev->tmp_buffer, len);
-	return memcmp(buf, dev->tmp_buffer, len);
-}
-
 /*
  * Control several chip lines & send commands
  */
@@ -882,7 +861,6 @@ int  r852_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	chip->read_byte = r852_read_byte;
 	chip->read_buf = r852_read_buf;
 	chip->write_buf = r852_write_buf;
-	chip->verify_buf = r852_verify_buf;
 
 	/* ecc */
 	chip->ecc.mode = NAND_ECC_HW_SYNDROME;
diff --git a/drivers/mtd/nand/sh_flctl.c b/drivers/mtd/nand/sh_flctl.c
index 0b798fb..319ffb4 100644
--- a/drivers/mtd/nand/sh_flctl.c
+++ b/drivers/mtd/nand/sh_flctl.c
@@ -788,16 +788,6 @@ static void flctl_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
 	flctl->index += len;
 }
 
-static int flctl_verify_buf(struct mtd_info *mtd, const u_char *buf, int len)
-{
-	int i;
-
-	for (i = 0; i < len; i++)
-		if (buf[i] != flctl_read_byte(mtd))
-			return -EFAULT;
-	return 0;
-}
-
 static int flctl_chip_init_tail(struct mtd_info *mtd)
 {
 	struct sh_flctl *flctl = mtd_to_flctl(mtd);
@@ -931,7 +921,6 @@ static int __devinit flctl_probe(struct platform_device *pdev)
 	nand->read_byte = flctl_read_byte;
 	nand->write_buf = flctl_write_buf;
 	nand->read_buf = flctl_read_buf;
-	nand->verify_buf = flctl_verify_buf;
 	nand->select_chip = flctl_select_chip;
 	nand->cmdfunc = flctl_cmdfunc;
 
diff --git a/drivers/mtd/nand/socrates_nand.c b/drivers/mtd/nand/socrates_nand.c
index e02b08b..f3f28fa 100644
--- a/drivers/mtd/nand/socrates_nand.c
+++ b/drivers/mtd/nand/socrates_nand.c
@@ -98,24 +98,6 @@ static uint16_t socrates_nand_read_word(struct mtd_info *mtd)
 	return word;
 }
 
-/**
- * socrates_nand_verify_buf -  Verify chip data against buffer
- * @mtd:	MTD device structure
- * @buf:	buffer containing the data to compare
- * @len:	number of bytes to compare
- */
-static int socrates_nand_verify_buf(struct mtd_info *mtd, const u8 *buf,
-		int len)
-{
-	int i;
-
-	for (i = 0; i < len; i++) {
-		if (buf[i] != socrates_nand_read_byte(mtd))
-			return -EFAULT;
-	}
-	return 0;
-}
-
 /*
  * Hardware specific access to control-lines
  */
@@ -201,7 +183,6 @@ static int __devinit socrates_nand_probe(struct platform_device *ofdev)
 	nand_chip->read_word = socrates_nand_read_word;
 	nand_chip->write_buf = socrates_nand_write_buf;
 	nand_chip->read_buf = socrates_nand_read_buf;
-	nand_chip->verify_buf = socrates_nand_verify_buf;
 	nand_chip->dev_ready = socrates_nand_device_ready;
 
 	nand_chip->ecc.mode = NAND_ECC_SOFT;	/* enable ECC */
diff --git a/drivers/mtd/nand/tmio_nand.c b/drivers/mtd/nand/tmio_nand.c
index 5aa5180..508e9e0 100644
--- a/drivers/mtd/nand/tmio_nand.c
+++ b/drivers/mtd/nand/tmio_nand.c
@@ -256,18 +256,6 @@ static void tmio_nand_read_buf(struct mtd_info *mtd, u_char *buf, int len)
 	tmio_ioread16_rep(tmio->fcr + FCR_DATA, buf, len >> 1);
 }
 
-static int
-tmio_nand_verify_buf(struct mtd_info *mtd, const u_char *buf, int len)
-{
-	struct tmio_nand *tmio = mtd_to_tmio(mtd);
-	u16				*p = (u16 *) buf;
-
-	for (len >>= 1; len; len--)
-		if (*(p++) != tmio_ioread16(tmio->fcr + FCR_DATA))
-			return -EFAULT;
-	return 0;
-}
-
 static void tmio_nand_enable_hwecc(struct mtd_info *mtd, int mode)
 {
 	struct tmio_nand *tmio = mtd_to_tmio(mtd);
@@ -424,7 +412,6 @@ static int tmio_probe(struct platform_device *dev)
 	nand_chip->read_byte = tmio_nand_read_byte;
 	nand_chip->write_buf = tmio_nand_write_buf;
 	nand_chip->read_buf = tmio_nand_read_buf;
-	nand_chip->verify_buf = tmio_nand_verify_buf;
 
 	/* set eccmode using hardware ECC */
 	nand_chip->ecc.mode = NAND_ECC_HW;
diff --git a/drivers/mtd/nand/txx9ndfmc.c b/drivers/mtd/nand/txx9ndfmc.c
index 26398dc..e3d7266 100644
--- a/drivers/mtd/nand/txx9ndfmc.c
+++ b/drivers/mtd/nand/txx9ndfmc.c
@@ -131,18 +131,6 @@ static void txx9ndfmc_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
 		*buf++ = __raw_readl(ndfdtr);
 }
 
-static int txx9ndfmc_verify_buf(struct mtd_info *mtd, const uint8_t *buf,
-				int len)
-{
-	struct platform_device *dev = mtd_to_platdev(mtd);
-	void __iomem *ndfdtr = ndregaddr(dev, TXX9_NDFDTR);
-
-	while (len--)
-		if (*buf++ != (uint8_t)__raw_readl(ndfdtr))
-			return -EFAULT;
-	return 0;
-}
-
 static void txx9ndfmc_cmd_ctrl(struct mtd_info *mtd, int cmd,
 			       unsigned int ctrl)
 {
@@ -346,7 +334,6 @@ static int __init txx9ndfmc_probe(struct platform_device *dev)
 		chip->read_byte = txx9ndfmc_read_byte;
 		chip->read_buf = txx9ndfmc_read_buf;
 		chip->write_buf = txx9ndfmc_write_buf;
-		chip->verify_buf = txx9ndfmc_verify_buf;
 		chip->cmd_ctrl = txx9ndfmc_cmd_ctrl;
 		chip->dev_ready = txx9ndfmc_dev_ready;
 		chip->ecc.calculate = txx9ndfmc_calculate_ecc;
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 6dce5a7..9be3873 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -397,8 +397,6 @@ struct nand_buffers {
  * @read_word:		[REPLACEABLE] read one word from the chip
  * @write_buf:		[REPLACEABLE] write data from the buffer to the chip
  * @read_buf:		[REPLACEABLE] read data from the chip into the buffer
- * @verify_buf:		[REPLACEABLE] verify buffer contents against the chip
- *			data.
  * @select_chip:	[REPLACEABLE] select chip nr
  * @block_bad:		[REPLACEABLE] check, if the block is bad
  * @block_markbad:	[REPLACEABLE] mark the block bad
@@ -481,7 +479,6 @@ struct nand_chip {
 	u16 (*read_word)(struct mtd_info *mtd);
 	void (*write_buf)(struct mtd_info *mtd, const uint8_t *buf, int len);
 	void (*read_buf)(struct mtd_info *mtd, uint8_t *buf, int len);
-	int (*verify_buf)(struct mtd_info *mtd, const uint8_t *buf, int len);
 	void (*select_chip)(struct mtd_info *mtd, int chip);
 	int (*block_bad)(struct mtd_info *mtd, loff_t ofs, int getchip);
 	int (*block_markbad)(struct mtd_info *mtd, loff_t ofs);
-- 
1.7.4.4

