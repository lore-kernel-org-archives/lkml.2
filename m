Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab2JCOyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:54:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48350 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310Ab2JCOyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:54:08 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>,
        <tony@atomide.com>
CC: <afzal@ti.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <ivan.djelic@parrot.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH 4/4] mtd: nand: omap2: Add data correction support
Date: Wed, 3 Oct 2012 19:59:49 +0530
Message-ID: <1349274589-11389-5-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
References: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ELM module can be used for error correction of BCH 4 & 8 bit. Also
support read & write page in one shot by adding custom read_page &
write_page methods. This helps in optimizing code.

New structure member "is_elm_used" is added to know the status of
whether the ELM module is used for error correction or not.

Note:
ECC layout of BCH8 uses 14 bytes for 512 byte of data to make compatible
with RBL ECC layout, even though the requirement was only 13 byte. This
results a common ecc layout across RBL, U-boot & Linux.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
:100644 100644 af511a9... 8fd6ddb... M	drivers/mtd/nand/omap2.c
:100644 100644 1a68c1e... 5b7054e... M	include/linux/platform_data/mtd-nand-omap2.h
 drivers/mtd/nand/omap2.c                     |  359 +++++++++++++++++++++++---
 include/linux/platform_data/mtd-nand-omap2.h |    1 +
 2 files changed, 328 insertions(+), 32 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index af511a9..8fd6ddb 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -30,6 +30,7 @@
 #include <plat/dma.h>
 #include <plat/gpmc.h>
 #include <linux/platform_data/mtd-nand-omap2.h>
+#include <linux/platform_data/elm.h>
 
 #define	DRIVER_NAME	"omap2-nand"
 #define	OMAP_NAND_TIMEOUT_MS	5000
@@ -114,6 +115,12 @@
 #define BCH8_MAX_ERROR		8	/* upto 8 bit coorectable */
 #define BCH4_MAX_ERROR		4	/* upto 4 bit correctable */
 
+#define SECTOR_BYTES		512
+/* 4 bit padding to make byte aligned, 56 = 52 + 4 */
+#define BCH4_BIT_PAD		4
+#define BCH8_ECC_MAX		((SECTOR_BYTES + BCH8_ECC_OOB_BYTES) * 8)
+#define BCH4_ECC_MAX		((SECTOR_BYTES + BCH4_SIZE) * 8)
+
 /* oob info generated runtime depending on ecc algorithm and layout selected */
 static struct nand_ecclayout omap_oobinfo;
 /* Define some generic bad / good block scan pattern which are used
@@ -153,6 +160,8 @@ struct omap_nand_info {
 #ifdef CONFIG_MTD_NAND_OMAP_BCH
 	struct bch_control             *bch;
 	struct nand_ecclayout           ecclayout;
+	bool				is_elm_used;
+	struct device			*elm_dev;
 #endif
 };
 
@@ -892,6 +901,138 @@ static int omap_correct_data(struct mtd_info *mtd, u_char *dat,
 	return stat;
 }
 
+#ifdef CONFIG_MTD_NAND_OMAP_BCH
+/**
+ * omap_elm_correct_data - corrects page data area in case error reported
+ * @mtd:	MTD device structure
+ * @dat:	page data
+ * @read_ecc:	ecc read from nand flash
+ * @calc_ecc:	ecc read from HW ECC registers
+ *
+ * Check the read ecc vector from OOB area to see the page is flashed.
+ * If flashed, check any error reported by checking calculated ecc vector.
+ * For non error page, calculated ecc will be zero. For error pages,
+ * a non-zero valid syndrome polynomial reported in calculated ecc vector.
+ * Pass this non-zero syndrome polynomial to 'elm_decode_bch_error_page'
+ * with elm error vector updated for error reported sectors.
+ * On returning from this function, elm error vector updated with
+ * - number of correctable errors, error location if correctable.
+ * - if pages are non-correctable, updated with elm error vector
+ *   error uncorrectable.
+ */
+static int omap_elm_correct_data(struct mtd_info *mtd, u_char *dat,
+				u_char *read_ecc, u_char *calc_ecc)
+{
+	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
+			mtd);
+	int eccsteps = info->nand.ecc.steps;
+	int i , j, stat = 0;
+	int eccsize, eccflag, size;
+	struct elm_errorvec err_vec[ERROR_VECTOR_MAX];
+	u_char *ecc_vec = calc_ecc;
+	enum bch_ecc type;
+	bool is_error_reported = false;
+
+	/* initialize elm error vector to zero */
+	memset(err_vec, 0, sizeof(err_vec));
+	if (info->nand.ecc.strength == BCH8_MAX_ERROR) {
+		size = BCH8_SIZE;
+		eccsize = BCH8_ECC_OOB_BYTES;
+		type = BCH8_ECC;
+	} else {
+		size = BCH4_SIZE;
+		eccsize = BCH4_SIZE;
+		type = BCH4_ECC;
+	}
+
+	for (i = 0; i < eccsteps ; i++) {
+		eccflag = 0;	/* initialize eccflag */
+
+		for (j = 0; (j < eccsize); j++) {
+			if (read_ecc[j] != 0xFF) {
+				eccflag = 1;	/* data area is flashed */
+				break;
+			}
+		}
+
+		/* check calculated ecc if data area is flashed */
+		if (eccflag == 1) {
+			eccflag = 0;
+			/*
+			 * check any error reported, in case of error
+			 * non zero ecc reported.
+			 */
+			for (j = 0; (j < eccsize); j++) {
+				if (calc_ecc[j] != 0) {
+					/* non zero ecc, error present */
+					eccflag = 1;
+					break;
+				}
+			}
+		}
+
+		/* update elm error vector */
+		if (eccflag == 1) {
+			err_vec[i].error_reported = true;
+			is_error_reported = true;
+		}
+
+		/* update the ecc vector */
+		calc_ecc = calc_ecc + size;
+		read_ecc = read_ecc + size;
+	}
+
+	/* Check if any error reported */
+	if (!is_error_reported)
+		return 0;
+
+	/* decode BCH error using ELM module */
+	elm_decode_bch_error_page(info->elm_dev, ecc_vec, err_vec);
+
+	for (i = 0; i < eccsteps; i++) {
+		if (err_vec[i].error_reported) {
+			for (j = 0; j < err_vec[i].error_count; j++) {
+				u32 bit_pos, byte_pos, error_max, pos;
+
+				if (type == BCH8_ECC)
+					error_max = BCH8_ECC_MAX;
+				else
+					error_max = BCH4_ECC_MAX;
+
+				if (info->nand.ecc.strength == BCH8_MAX_ERROR)
+					pos = err_vec[i].error_loc[j];
+				else
+					/* add 4 to take care 4 bit padding */
+					pos = err_vec[i].error_loc[j] +
+						BCH4_BIT_PAD;
+
+				/* calculate bit position of error */
+				bit_pos = pos % 8;
+				/* calculate byte position of error */
+				byte_pos = (error_max - pos - 1) / 8;
+
+				if (pos < error_max)
+					dat[byte_pos] ^= 1 << bit_pos;
+				/* else, not interested to correct ecc */
+			}
+
+			/* update number of correctable errors */
+			stat += err_vec[i].error_count;
+		}
+
+		/* update page data with sector size */
+		dat += info->nand.ecc.size;
+	}
+
+	for (i = 0; i < eccsteps; i++)
+		/* return error if uncorrectable error present */
+		if (err_vec[i].error_uncorrectable)
+			return -EINVAL;
+
+	return stat;
+}
+#endif
+
 /**
  * omap_calcuate_ecc - Generate non-inverted ECC bytes.
  * @mtd: MTD device structure
@@ -1039,14 +1180,45 @@ static void omap3_enable_hwecc_bch(struct mtd_info *mtd, int mode)
 
 	nerrors = info->nand.ecc.strength;
 	dev_width = (chip->options & NAND_BUSWIDTH_16) ? 1 : 0;
+#ifdef CONFIG_MTD_NAND_OMAP_BCH
+	if (info->is_elm_used) {
+		/*
+		 * Program GPMC to perform correction on (steps * 512) byte
+		 * sector at a time.
+		 */
+		gpmc_enable_hwecc_bch(info->gpmc_cs, mode, dev_width,
+				info->nand.ecc.steps, nerrors);
+		return;
+	}
+#endif
 	/*
-	 * Program GPMC to perform correction on one 512-byte sector at a time.
-	 * Using 4 sectors at a time (i.e. ecc.size = 2048) is also possible and
-	 * gives a slight (5%) performance gain (but requires additional code).
+	 * Program GPMC to perform correction on one 512-byte sector at
+	 * a time.
 	 */
-	(void)gpmc_enable_hwecc_bch(info->gpmc_cs, mode, dev_width, 1, nerrors);
+	(void)gpmc_enable_hwecc_bch(info->gpmc_cs, mode, dev_width, 1,
+				nerrors);
 }
 
+
+#ifdef CONFIG_MTD_NAND_OMAP_BCH
+/**
+ * omap3_calculate_ecc_bch - Generate bytes of ECC bytes
+ * @mtd:	MTD device structure
+ * @dat:	The pointer to data on which ecc is computed
+ * @ecc_code:	The ecc_code buffer
+ *
+ * support reading og BCH4/8 ecc vectors for the page
+ */
+static int omap3_calculate_ecc_bch(struct mtd_info *mtd, const u_char *dat,
+				    u_char *ecc_code)
+{
+	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
+			mtd);
+
+	return gpmc_calculate_ecc_bch(info->gpmc_cs, dat, ecc_code);
+}
+#endif
+
 /**
  * omap3_calculate_ecc_bch4 - Generate 7 bytes of ECC bytes
  * @mtd: MTD device structure
@@ -1121,6 +1293,90 @@ static void omap3_free_bch(struct mtd_info *mtd)
 	}
 }
 
+#ifdef CONFIG_MTD_NAND_OMAP_BCH
+/**
+ * omap_write_page_bch - BCH ecc based write page function for entire page
+ * @mtd:		mtd info structure
+ * @chip:		nand chip info structure
+ * @buf:		data buffer
+ * @oob_required:	must write chip->oob_poi to OOB
+ *
+ * Custom write page method evolved to support multi sector writing in one shot
+ */
+static int omap_write_page_bch(struct mtd_info *mtd, struct nand_chip *chip,
+				  const uint8_t *buf, int oob_required)
+{
+	int i;
+	uint8_t *ecc_calc = chip->buffers->ecccalc;
+	uint32_t *eccpos = chip->ecc.layout->eccpos;
+
+	/*
+	 * setting ecc vector with zero to support RBL compatibility.
+	 * RBL requires 14 byte of ecc with 14 byte as zero
+	 * even though BCH8 requires only 13 byte of ecc bytes.
+	 */
+	memset(ecc_calc, 0x0, chip->ecc.total);
+	chip->ecc.hwctl(mtd, NAND_ECC_WRITE);
+	chip->write_buf(mtd, buf, mtd->writesize);
+	chip->ecc.calculate(mtd, buf, &ecc_calc[0]);
+
+	for (i = 0; i < chip->ecc.total; i++)
+		chip->oob_poi[eccpos[i]] = ecc_calc[i];
+
+	chip->write_buf(mtd, chip->oob_poi, mtd->oobsize);
+	return 0;
+}
+
+/**
+ * omap_read_page_bch - BCH ecc based page read function for entire page
+ * @mtd:		mtd info structure
+ * @chip:		nand chip info structure
+ * @buf:		buffer to store read data
+ * @oob_required:	caller requires OOB data read to chip->oob_poi
+ * @page:		page number to read
+ *
+ * For BCH ecc scheme, GPMC used for syndrome calculation and ELM module
+ * used for error correction.
+ * Custom method evolved to support ELM error correction. On reading page
+ * data area is read along with OOB data with ecc engine enabled. ecc vector
+ * updated after read of OOB data. For non error pages ecc vector reported as
+ * zero.
+ */
+static int omap_read_page_bch(struct mtd_info *mtd, struct nand_chip *chip,
+				uint8_t *buf, int oob_required, int page)
+{
+	uint8_t *ecc_calc = chip->buffers->ecccalc;
+	uint8_t *ecc_code = chip->buffers->ecccode;
+	uint32_t *eccpos = chip->ecc.layout->eccpos;
+	uint8_t *oob = &chip->oob_poi[eccpos[0]];
+	uint32_t oob_pos = mtd->writesize + chip->ecc.layout->eccpos[0];
+	int stat;
+
+	/* enable GPMC ecc engine */
+	chip->ecc.hwctl(mtd, NAND_ECC_READ);
+	/* read data */
+	chip->read_buf(mtd, buf, mtd->writesize);
+
+	/* read oob bytes */
+	chip->cmdfunc(mtd, NAND_CMD_RNDOUT, oob_pos, -1);
+	chip->read_buf(mtd, oob, chip->ecc.total);
+
+	/* calculate ecc bytes */
+	chip->ecc.calculate(mtd, buf, ecc_calc);
+
+	memcpy(ecc_code, &chip->oob_poi[eccpos[0]], chip->ecc.total);
+
+	stat = chip->ecc.correct(mtd, buf, ecc_code, ecc_calc);
+
+	if (stat < 0)
+		mtd->ecc_stats.failed++;
+	else
+		mtd->ecc_stats.corrected += stat;
+
+	return 0;
+}
+#endif
+
 /**
  * omap3_init_bch - Initialize BCH ECC
  * @mtd: MTD device structure
@@ -1146,35 +1402,62 @@ static int omap3_init_bch(struct mtd_info *mtd, int ecc_opt)
 		goto fail;
 	}
 
-	/* initialize GPMC BCH engine */
-	ret = gpmc_init_hwecc_bch(info->gpmc_cs, 1, max_errors);
-	if (ret)
-		goto fail;
-
-	/* software bch library is only used to detect and locate errors */
-	info->bch = init_bch(13, max_errors, 0x201b /* hw polynomial */);
-	if (!info->bch)
-		goto fail;
+	info->nand.ecc.size = 512;
+	info->nand.ecc.hwctl = omap3_enable_hwecc_bch;
+	info->nand.ecc.mode = NAND_ECC_HW;
+	info->nand.ecc.strength = hw_errors;
 
-	info->nand.ecc.size    = 512;
-	info->nand.ecc.hwctl   = omap3_enable_hwecc_bch;
-	info->nand.ecc.correct = omap3_correct_data_bch;
-	info->nand.ecc.mode    = NAND_ECC_HW;
+	if (info->is_elm_used && (mtd->writesize <= 4096)) {
+		enum bch_ecc bch_type;
 
-	/*
-	 * The number of corrected errors in an ecc block that will trigger
-	 * block scrubbing defaults to the ecc strength (4 or 8).
-	 * Set mtd->bitflip_threshold here to define a custom threshold.
-	 */
+		if (hw_errors == BCH8_MAX_ERROR) {
+			bch_type = BCH8_ECC;
+			info->nand.ecc.bytes = BCH8_SIZE;
+		} else {
+			bch_type = BCH4_ECC;
+			info->nand.ecc.bytes = BCH4_SIZE;
+		}
 
-	if (max_errors == 8) {
-		info->nand.ecc.strength  = 8;
-		info->nand.ecc.bytes     = 13;
-		info->nand.ecc.calculate = omap3_calculate_ecc_bch8;
+		info->nand.ecc.correct = omap_elm_correct_data;
+		info->nand.ecc.calculate = omap3_calculate_ecc_bch;
+		info->nand.ecc.read_page = omap_read_page_bch;
+		info->nand.ecc.write_page = omap_write_page_bch;
+		info->elm_dev = elm_request(bch_type);
+		if (!info->elm_dev) {
+			pr_err("Request to elm module failed\n");
+			goto fail;
+		}
 	} else {
-		info->nand.ecc.strength  = 4;
-		info->nand.ecc.bytes     = 7;
-		info->nand.ecc.calculate = omap3_calculate_ecc_bch4;
+
+		/* initialize GPMC BCH engine */
+		ret = gpmc_init_hwecc_bch(info->gpmc_cs, 1, max_errors);
+		if (ret)
+			goto fail;
+
+		/*
+		 * software bch library is only used to detect and
+		 * locateerrors
+		 */
+		info->bch = init_bch(13, max_errors,
+				0x201b /* hw polynomial */);
+		if (!info->bch)
+			goto fail;
+
+		info->nand.ecc.correct = omap3_correct_data_bch;
+
+		/*
+		 * The number of corrected errors in an ecc block that will
+		 * trigger block scrubbing defaults to the ecc strength (4 or 8)
+		 * Set mtd->bitflip_threshold here to define a custom threshold.
+		 */
+
+		if (max_errors == 8) {
+			info->nand.ecc.bytes = 13;
+			info->nand.ecc.calculate = omap3_calculate_ecc_bch8;
+		} else {
+			info->nand.ecc.bytes = 7;
+			info->nand.ecc.calculate = omap3_calculate_ecc_bch4;
+		}
 	}
 
 	pr_info("enabling NAND BCH ecc with %d-bit correction\n", max_errors);
@@ -1190,7 +1473,7 @@ fail:
  */
 static int omap3_init_bch_tail(struct mtd_info *mtd)
 {
-	int i, steps;
+	int i, steps, offset;
 	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
 						   mtd);
 	struct nand_ecclayout *layout = &info->ecclayout;
@@ -1212,11 +1495,20 @@ static int omap3_init_bch_tail(struct mtd_info *mtd)
 		goto fail;
 	}
 
+	/* ECC layout compatible with RBL for BCH8 */
+	if (info->is_elm_used && (info->nand.ecc.bytes == BCH8_SIZE))
+		offset = 2;
+	else
+		offset = mtd->oobsize - layout->eccbytes;
 	/* put ecc bytes at oob tail */
 	for (i = 0; i < layout->eccbytes; i++)
-		layout->eccpos[i] = mtd->oobsize-layout->eccbytes+i;
+		layout->eccpos[i] = offset + i;
+
+	if (info->is_elm_used && (info->nand.ecc.bytes == BCH8_SIZE))
+		layout->oobfree[0].offset = 2 + layout->eccbytes * steps;
+	else
+		layout->oobfree[0].offset = 2;
 
-	layout->oobfree[0].offset = 2;
 	layout->oobfree[0].length = mtd->oobsize-2-layout->eccbytes;
 	info->nand.ecc.layout = layout;
 
@@ -1279,6 +1571,9 @@ static int __devinit omap_nand_probe(struct platform_device *pdev)
 
 	info->nand.options	= pdata->devsize;
 	info->nand.options	|= NAND_SKIP_BBTSCAN;
+#ifdef CONFIG_MTD_NAND_OMAP_BCH
+	info->is_elm_used	= pdata->is_elm_used;
+#endif
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
diff --git a/include/linux/platform_data/mtd-nand-omap2.h b/include/linux/platform_data/mtd-nand-omap2.h
index 1a68c1e..5b7054e 100644
--- a/include/linux/platform_data/mtd-nand-omap2.h
+++ b/include/linux/platform_data/mtd-nand-omap2.h
@@ -28,6 +28,7 @@ struct omap_nand_platform_data {
 	int			devsize;
 	enum omap_ecc           ecc_opt;
 	struct gpmc_nand_regs	reg;
+	bool			is_elm_used;
 };
 
 /* minimum size for IO mapping */
-- 
1.7.0.4

