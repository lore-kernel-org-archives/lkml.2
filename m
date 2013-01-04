Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3ADH5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 02:57:40 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:55868 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab3ADH5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 02:57:34 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>,
        <tony@atomide.com>, <rmk+kernel@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <zonque@gmail.com>
CC: <afzal@ti.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>, <ivan.djelic@parrot.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH v4 3/3] mtd: nand: omap2: Support for hardware BCH error correction.
Date: Fri, 4 Jan 2013 13:26:51 +0530
Message-ID: <1357286211-5012-4-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357286211-5012-1-git-send-email-avinashphilip@ti.com>
References: <1357286211-5012-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ELM module can be used for hardware error correction of BCH 4 & 8 bit.
ELM module functionality is verified by checking the availability of
handle for ELM module in device tree. Hence supporting
1. ELM module available, BCH error correction done by ELM module. Also
support read & write page in one shot by adding custom read_page and
write_page methods. This helps in optimizing code for NAND flashes with
page size less than 4 KB.
2. If ELM module not available fall back to software BCH error
correction support.

New structure member is added to omap_nand_info
1. "is_elm_used" to know the status of whether the ELM module is used for
   error correction or not.
2. "elm_dev" device pointer to elm device on detection of ELM module.

Also being here update the device tree documentation of gpmc-nand for
adding optional property elm_id.

Note:
ECC layout uses 1 extra bytes for 512 byte of data to handle erased
pages. Extra byte programmed to zero for programmed pages. Also BCH8
requires 14 byte ecc to maintain compatibility with RBL ECC layout.
This results a common ecc layout across RBL, U-boot & Linux with BCH8.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
This patch depend on http://www.spinics.net/lists/linux-omap/msg83504.html
for GPMC DT binding.

Changes since v3:
	- ELM module availability is find by checking device tree handle
	  for ELM module. Hence remove support for elm_request and
	  configure ELM module directly from NAND driver for required BCH
	  ecc algorithm.
	- device tree binding document update for gpmc nand.
Changes since v2:
	- Threshold for erased bit flip in erased page set to minimum
	  of 4 or half of ecc.strength. So max bit flips allowed
	  at fixed offset is 4.
	- Add dependency on runtime detection of ELM module
	  instead of platform data. Dependency on is_elm_used
	  flag in platform data removed.
	- Return number of bit flips from read_page().
	- Add bit correction support in case of bit flip in OOB
	  as BCH scheme can correct bit flips in ECC.
Changes since v1:
	- Incorporated GPMC modification to nand driver
	- Erased page detects by checking OOB byte at fixed offset.

 .../devicetree/bindings/mtd/gpmc-nand.txt          |    4 +
 drivers/mtd/nand/omap2.c                           |  573 ++++++++++++++++++--
 include/linux/platform_data/elm.h                  |    3 +-
 3 files changed, 540 insertions(+), 40 deletions(-)

diff --git a/Documentation/devicetree/bindings/mtd/gpmc-nand.txt b/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
index 9f464f9..e7f8d7e 100644
--- a/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
+++ b/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
@@ -29,6 +29,9 @@ Optional properties:
 		"bch4"		4-bit BCH ecc code
 		"bch8"		8-bit BCH ecc code
 
+ - elm_id:	Specifies elm device node. This is required to support BCH
+ 		error correction using ELM module.
+
 For inline partiton table parsing (optional):
 
  - #address-cells: should be set to 1
@@ -46,6 +49,7 @@ Example for an AM33xx board:
 		#address-cells = <2>;
 		#size-cells = <1>;
 		ranges = <0 0 0x08000000 0x2000>;	/* CS0: NAND */
+		elm_id = <&elm>;
 
 		nand@0,0 {
 			reg = <0 0 0>; /* CS0, offset 0 */
diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 7d907b7..8e820dd 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -22,9 +22,12 @@
 #include <linux/omap-dma.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 #ifdef CONFIG_MTD_NAND_OMAP_BCH
 #include <linux/bch.h>
+#include <linux/platform_data/elm.h>
 #endif
 
 #include <linux/platform_data/mtd-nand-omap2.h>
@@ -120,6 +123,30 @@
 #define BCH8_MAX_ERROR		8	/* upto 8 bit correctable */
 #define BCH4_MAX_ERROR		4	/* upto 4 bit correctable */
 
+#define SECTOR_BYTES		512
+/* 4 bit padding to make byte aligned, 56 = 52 + 4 */
+#define BCH4_BIT_PAD		4
+#define BCH8_ECC_MAX		((SECTOR_BYTES + BCH8_ECC_OOB_BYTES) * 8)
+#define BCH4_ECC_MAX		((SECTOR_BYTES + BCH4_ECC_OOB_BYTES) * 8)
+
+/* GPMC ecc engine settings for read */
+#define BCH_WRAPMODE_1		1	/* BCH wrap mode 1 */
+#define BCH8R_ECC_SIZE0		0x1a	/* ecc_size0 = 26 */
+#define BCH8R_ECC_SIZE1		0x2	/* ecc_size1 = 2 */
+#define BCH4R_ECC_SIZE0		0xd	/* ecc_size0 = 13 */
+#define BCH4R_ECC_SIZE1		0x3	/* ecc_size1 = 3 */
+
+/* GPMC ecc engine settings for write */
+#define BCH_WRAPMODE_6		6	/* BCH wrap mode 6 */
+#define BCH_ECC_SIZE0		0x0	/* ecc_size0 = 0, no oob protection */
+#define BCH_ECC_SIZE1		0x20	/* ecc_size1 = 32 */
+
+#ifdef CONFIG_MTD_NAND_OMAP_BCH
+static u_char bch8_vector[] = {0xf3, 0xdb, 0x14, 0x16, 0x8b, 0xd2, 0xbe, 0xcc,
+	0xac, 0x6b, 0xff, 0x99, 0x7b};
+static u_char bch4_vector[] = {0x00, 0x6b, 0x31, 0xdd, 0x41, 0xbc, 0x10};
+#endif
+
 /* oob info generated runtime depending on ecc algorithm and layout selected */
 static struct nand_ecclayout omap_oobinfo;
 /* Define some generic bad / good block scan pattern which are used
@@ -159,6 +186,9 @@ struct omap_nand_info {
 #ifdef CONFIG_MTD_NAND_OMAP_BCH
 	struct bch_control             *bch;
 	struct nand_ecclayout           ecclayout;
+	bool				is_elm_used;
+	struct device			*elm_dev;
+	struct device_node		*of_node;
 #endif
 };
 
@@ -1034,6 +1064,13 @@ static int omap_dev_ready(struct mtd_info *mtd)
  * omap3_enable_hwecc_bch - Program OMAP3 GPMC to perform BCH ECC correction
  * @mtd: MTD device structure
  * @mode: Read/Write mode
+ *
+ * When using BCH, sector size is hardcoded to 512 bytes.
+ * Using wrapping mode 6 both for reading and writing if ELM module not uses
+ * for error correction.
+ * On writing,
+ * eccsize0 = 0  (no additional protected byte in spare area)
+ * eccsize1 = 32 (skip 32 nibbles = 16 bytes per sector in spare area)
  */
 static void omap3_enable_hwecc_bch(struct mtd_info *mtd, int mode)
 {
@@ -1042,32 +1079,57 @@ static void omap3_enable_hwecc_bch(struct mtd_info *mtd, int mode)
 	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
 						   mtd);
 	struct nand_chip *chip = mtd->priv;
-	u32 val;
+	u32 val, wr_mode;
+	unsigned int ecc_size1, ecc_size0;
+
+	/* Using wrapping mode 6 for writing */
+	wr_mode = BCH_WRAPMODE_6;
 
-	nerrors = info->nand.ecc.strength;
-	dev_width = (chip->options & NAND_BUSWIDTH_16) ? 1 : 0;
-	nsectors = 1;
 	/*
-	 * Program GPMC to perform correction on one 512-byte sector at a time.
-	 * Using 4 sectors at a time (i.e. ecc.size = 2048) is also possible and
-	 * gives a slight (5%) performance gain (but requires additional code).
+	 * ECC engine enabled for valid ecc_size0 nibbles
+	 * and disabled for ecc_size1 nibbles.
 	 */
+	ecc_size0 = BCH_ECC_SIZE0;
+	ecc_size1 = BCH_ECC_SIZE1;
+
+	/* Perform ecc calculation on 512-byte sector */
+	nsectors = 1;
+
+	/* Update number of error correction */
+	nerrors = info->nand.ecc.strength;
+
+	/* Multi sector reading/writing for NAND flash with page size < 4096 */
+	if (info->is_elm_used && (mtd->writesize <= 4096)) {
+		if (mode == NAND_ECC_READ) {
+			/* Using wrapping mode 1 for reading */
+			wr_mode = BCH_WRAPMODE_1;
+
+			/*
+			 * ECC engine enabled for ecc_size0 nibbles
+			 * and disabled for ecc_size1 nibbles.
+			 */
+			ecc_size0 = (nerrors == 8) ?
+				BCH8R_ECC_SIZE0 : BCH4R_ECC_SIZE0;
+			ecc_size1 = (nerrors == 8) ?
+				BCH8R_ECC_SIZE1 : BCH4R_ECC_SIZE1;
+		}
+
+		/* Perform ecc calculation for one page (< 4096) */
+		nsectors = info->nand.ecc.steps;
+	}
 
 	writel(ECC1, info->reg.gpmc_ecc_control);
 
-	/*
-	 * When using BCH, sector size is hardcoded to 512 bytes.
-	 * Here we are using wrapping mode 6 both for reading and writing, with:
-	 *  size0 = 0  (no additional protected byte in spare area)
-	 *  size1 = 32 (skip 32 nibbles = 16 bytes per sector in spare area)
-	 */
-	val = (32 << ECCSIZE1_SHIFT) | (0 << ECCSIZE0_SHIFT);
+	/* Configure ecc size for BCH */
+	val = (ecc_size1 << ECCSIZE1_SHIFT) | (ecc_size0 << ECCSIZE0_SHIFT);
 	writel(val, info->reg.gpmc_ecc_size_config);
 
+	dev_width = (chip->options & NAND_BUSWIDTH_16) ? 1 : 0;
+
 	/* BCH configuration */
 	val = ((1                        << 16) | /* enable BCH */
 	       (((nerrors == 8) ? 1 : 0) << 12) | /* 8 or 4 bits */
-	       (0x06                     <<  8) | /* wrap mode = 6 */
+	       (wr_mode                  <<  8) | /* wrap mode */
 	       (dev_width                <<  7) | /* bus width */
 	       (((nsectors-1) & 0x7)     <<  4) | /* number of sectors */
 	       (info->gpmc_cs            <<  1) | /* ECC CS */
@@ -1075,7 +1137,7 @@ static void omap3_enable_hwecc_bch(struct mtd_info *mtd, int mode)
 
 	writel(val, info->reg.gpmc_ecc_config);
 
-	/* clear ecc and enable bits */
+	/* Clear ecc and enable bits */
 	writel(ECCCLEAR | ECC1, info->reg.gpmc_ecc_control);
 }
 
@@ -1165,6 +1227,298 @@ static int omap3_calculate_ecc_bch8(struct mtd_info *mtd, const u_char *dat,
 }
 
 /**
+ * omap3_calculate_ecc_bch - Generate bytes of ECC bytes
+ * @mtd:	MTD device structure
+ * @dat:	The pointer to data on which ecc is computed
+ * @ecc_code:	The ecc_code buffer
+ *
+ * Support calculating of BCH4/8 ecc vectors for the page
+ */
+static int omap3_calculate_ecc_bch(struct mtd_info *mtd, const u_char *dat,
+				    u_char *ecc_code)
+{
+	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
+						   mtd);
+	unsigned long nsectors, bch_val1, bch_val2, bch_val3, bch_val4;
+	int i, eccbchtsel;
+
+	nsectors = ((readl(info->reg.gpmc_ecc_config) >> 4) & 0x7) + 1;
+	/*
+	 * find BCH scheme used
+	 * 0 -> BCH4
+	 * 1 -> BCH8
+	 */
+	eccbchtsel = ((readl(info->reg.gpmc_ecc_config) >> 12) & 0x3);
+
+	for (i = 0; i < nsectors; i++) {
+
+		/* Read hw-computed remainder */
+		bch_val1 = readl(info->reg.gpmc_bch_result0[i]);
+		bch_val2 = readl(info->reg.gpmc_bch_result1[i]);
+		if (eccbchtsel) {
+			bch_val3 = readl(info->reg.gpmc_bch_result2[i]);
+			bch_val4 = readl(info->reg.gpmc_bch_result3[i]);
+		}
+
+		if (eccbchtsel) {
+			/* BCH8 ecc scheme */
+			*ecc_code++ = (bch_val4 & 0xFF);
+			*ecc_code++ = ((bch_val3 >> 24) & 0xFF);
+			*ecc_code++ = ((bch_val3 >> 16) & 0xFF);
+			*ecc_code++ = ((bch_val3 >> 8) & 0xFF);
+			*ecc_code++ = (bch_val3 & 0xFF);
+			*ecc_code++ = ((bch_val2 >> 24) & 0xFF);
+			*ecc_code++ = ((bch_val2 >> 16) & 0xFF);
+			*ecc_code++ = ((bch_val2 >> 8) & 0xFF);
+			*ecc_code++ = (bch_val2 & 0xFF);
+			*ecc_code++ = ((bch_val1 >> 24) & 0xFF);
+			*ecc_code++ = ((bch_val1 >> 16) & 0xFF);
+			*ecc_code++ = ((bch_val1 >> 8) & 0xFF);
+			*ecc_code++ = (bch_val1 & 0xFF);
+			/*
+			 * Setting 14th byte to zero to handle
+			 * erased page & maintain compatibility
+			 * with RBL
+			 */
+			*ecc_code++ = 0x0;
+		} else {
+			/* BCH4 ecc scheme */
+			*ecc_code++ = ((bch_val2 >> 12) & 0xFF);
+			*ecc_code++ = ((bch_val2 >> 4) & 0xFF);
+			*ecc_code++ = ((bch_val2 & 0xF) << 4) |
+				((bch_val1 >> 28) & 0xF);
+			*ecc_code++ = ((bch_val1 >> 20) & 0xFF);
+			*ecc_code++ = ((bch_val1 >> 12) & 0xFF);
+			*ecc_code++ = ((bch_val1 >> 4) & 0xFF);
+			*ecc_code++ = ((bch_val1 & 0xF) << 4);
+			/*
+			 * Setting 8th byte to zero to handle
+			 * erased page
+			 */
+			*ecc_code++ = 0x0;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * erased_sector_bitflips - count bit flips
+ * @data:	data sector buffer
+ * @oob:	oob buffer
+ * @info:	omap_nand_info
+ *
+ * Check the bit flips in erased page falls below correctable level.
+ * If falls below, report the page as erased with correctable bit
+ * flip, else report as uncorrectable page.
+ */
+static int erased_sector_bitflips(u_char *data, u_char *oob,
+		struct omap_nand_info *info)
+{
+	int flip_bits = 0, i;
+
+	for (i = 0; i < info->nand.ecc.size; i++) {
+		flip_bits += hweight8(~data[i]);
+		if (flip_bits > info->nand.ecc.strength)
+			return 0;
+	}
+
+	for (i = 0; i < info->nand.ecc.bytes - 1; i++) {
+		flip_bits += hweight8(~oob[i]);
+		if (flip_bits > info->nand.ecc.strength)
+			return 0;
+	}
+
+	/*
+	 * Bit flips falls in correctable level.
+	 * Fill data area with 0xFF
+	 */
+	if (flip_bits) {
+		memset(data, 0xFF, info->nand.ecc.size);
+		memset(oob, 0xFF, info->nand.ecc.bytes);
+	}
+
+	return flip_bits;
+}
+
+/**
+ * omap_elm_correct_data - corrects page data area in case error reported
+ * @mtd:	MTD device structure
+ * @data:	page data
+ * @read_ecc:	ecc read from nand flash
+ * @calc_ecc:	ecc read from HW ECC registers
+ *
+ * Calculated ecc vector reported as zero in case of non-error pages.
+ * In case of error/erased pages non-zero error vector is reported.
+ * In case of non-zero ecc vector, check read_ecc at fixed offset
+ * (x = 13/7 in case of BCH8/4 == 0) to find page programmed or not.
+ * To handle bit flips in this data, count the number of 0's in
+ * read_ecc[x] and check if it greater than 4. If it is less, it is
+ * programmed page, else erased page.
+ *
+ * 1. If page is erased, check with standard ecc vector (ecc vector
+ * for erased page to find any bit flip). If check fails, bit flip
+ * is present in erased page. Count the bit flips in erased page and
+ * if it falls under correctable level, report page with 0xFF and
+ * update the correctable bit information.
+ * 2. If error is reported on programmed page, update elm error
+ * vector and correct the page with ELM error correction routine.
+ *
+ */
+static int omap_elm_correct_data(struct mtd_info *mtd, u_char *data,
+				u_char *read_ecc, u_char *calc_ecc)
+{
+	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
+			mtd);
+	int eccsteps = info->nand.ecc.steps;
+	int i , j, stat = 0;
+	int eccsize, eccflag, ecc_vector_size;
+	struct elm_errorvec err_vec[ERROR_VECTOR_MAX];
+	u_char *ecc_vec = calc_ecc;
+	u_char *spare_ecc = read_ecc;
+	u_char *erased_ecc_vec;
+	enum bch_ecc type;
+	bool is_error_reported = false;
+
+	/* Initialize elm error vector to zero */
+	memset(err_vec, 0, sizeof(err_vec));
+
+	if (info->nand.ecc.strength == BCH8_MAX_ERROR) {
+		type = BCH8_ECC;
+		erased_ecc_vec = bch8_vector;
+	} else {
+		type = BCH4_ECC;
+		erased_ecc_vec = bch4_vector;
+	}
+
+	ecc_vector_size = info->nand.ecc.bytes;
+
+	/*
+	 * Remove extra byte padding for BCH8 RBL
+	 * compatibility and erased page handling
+	 */
+	eccsize = ecc_vector_size - 1;
+
+	for (i = 0; i < eccsteps ; i++) {
+		eccflag = 0;	/* initialize eccflag */
+
+		/*
+		 * Check any error reported,
+		 * In case of error, non zero ecc reported.
+		 */
+
+		for (j = 0; (j < eccsize); j++) {
+			if (calc_ecc[j] != 0) {
+				eccflag = 1; /* non zero ecc, error present */
+				break;
+			}
+		}
+
+		if (eccflag == 1) {
+			/*
+			 * Set threshold to minimum of 4, half of ecc.strength/2
+			 * to allow max bit flip in byte to 4
+			 */
+			unsigned int threshold = min_t(unsigned int, 4,
+					info->nand.ecc.strength / 2);
+
+			/*
+			 * Check data area is programmed by counting
+			 * number of 0's at fixed offset in spare area.
+			 * Checking count of 0's against threshold.
+			 * In case programmed page expects at least threshold
+			 * zeros in byte.
+			 * If zeros are less than threshold for programmed page/
+			 * zeros are more than threshold erased page, either
+			 * case page reported as uncorrectable.
+			 */
+			if (hweight8(~read_ecc[eccsize]) >= threshold) {
+				/*
+				 * Update elm error vector as
+				 * data area is programmed
+				 */
+				err_vec[i].error_reported = true;
+				is_error_reported = true;
+			} else {
+				/* Error reported in erased page */
+				int bitflip_count;
+				u_char *buf = &data[info->nand.ecc.size * i];
+
+				if (memcmp(calc_ecc, erased_ecc_vec, eccsize)) {
+					bitflip_count = erased_sector_bitflips(
+							buf, read_ecc, info);
+
+					if (bitflip_count)
+						stat += bitflip_count;
+					else
+						return -EINVAL;
+				}
+			}
+		}
+
+		/* Update the ecc vector */
+		calc_ecc += ecc_vector_size;
+		read_ecc += ecc_vector_size;
+	}
+
+	/* Check if any error reported */
+	if (!is_error_reported)
+		return 0;
+
+	/* Decode BCH error using ELM module */
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
+					/* Add 4 to take care 4 bit padding */
+					pos = err_vec[i].error_loc[j] +
+						BCH4_BIT_PAD;
+
+				/* Calculate bit position of error */
+				bit_pos = pos % 8;
+
+				/* Calculate byte position of error */
+				byte_pos = (error_max - pos - 1) / 8;
+
+				if (pos < error_max) {
+					if (byte_pos < 512)
+						data[byte_pos] ^= 1 << bit_pos;
+					else
+						spare_ecc[byte_pos - 512] ^=
+							1 << bit_pos;
+				}
+				/* else, not interested to correct ecc */
+			}
+		}
+
+		/* Update number of correctable errors */
+		stat += err_vec[i].error_count;
+
+		/* Update page data with sector size */
+		data += info->nand.ecc.size;
+		spare_ecc += ecc_vector_size;
+	}
+
+	for (i = 0; i < eccsteps; i++)
+		/* Return error if uncorrectable error present */
+		if (err_vec[i].error_uncorrectable)
+			return -EINVAL;
+
+	return stat;
+}
+
+/**
  * omap3_correct_data_bch - Decode received data and correct errors
  * @mtd: MTD device structure
  * @data: page data
@@ -1197,6 +1551,92 @@ static int omap3_correct_data_bch(struct mtd_info *mtd, u_char *data,
 }
 
 /**
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
+	/* Enable GPMC ecc engine */
+	chip->ecc.hwctl(mtd, NAND_ECC_WRITE);
+
+	/* Write data */
+	chip->write_buf(mtd, buf, mtd->writesize);
+
+	/* Update ecc vector from GPMC result registers */
+	chip->ecc.calculate(mtd, buf, &ecc_calc[0]);
+
+	for (i = 0; i < chip->ecc.total; i++)
+		chip->oob_poi[eccpos[i]] = ecc_calc[i];
+
+	/* Write ecc vector to OOB area */
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
+ * Custom method evolved to support ELM error correction & multi sector
+ * reading. On reading page data area is read along with OOB data with
+ * ecc engine enabled. ecc vector updated after read of OOB data.
+ * For non error pages ecc vector reported as zero.
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
+	unsigned int max_bitflips = 0;
+
+	/* Enable GPMC ecc engine */
+	chip->ecc.hwctl(mtd, NAND_ECC_READ);
+
+	/* Read data */
+	chip->read_buf(mtd, buf, mtd->writesize);
+
+	/* Read oob bytes */
+	chip->cmdfunc(mtd, NAND_CMD_RNDOUT, oob_pos, -1);
+	chip->read_buf(mtd, oob, chip->ecc.total);
+
+	/* Calculate ecc bytes */
+	chip->ecc.calculate(mtd, buf, ecc_calc);
+
+	memcpy(ecc_code, &chip->oob_poi[eccpos[0]], chip->ecc.total);
+
+	stat = chip->ecc.correct(mtd, buf, ecc_code, ecc_calc);
+
+	if (stat < 0) {
+		mtd->ecc_stats.failed++;
+	} else {
+		mtd->ecc_stats.corrected += stat;
+		max_bitflips = max_t(unsigned int, max_bitflips, stat);
+	}
+
+	return max_bitflips;
+}
+
+/**
  * omap3_free_bch - Release BCH ecc resources
  * @mtd: MTD device structure
  */
@@ -1225,6 +1665,11 @@ static int omap3_init_bch(struct mtd_info *mtd, int ecc_opt)
 #else
 	const int hw_errors = BCH4_MAX_ERROR;
 #endif
+	enum bch_ecc bch_type;
+	const __be32 *parp;
+	int lenp;
+	struct device_node *elm_node;
+
 	info->bch = NULL;
 
 	max_errors = (ecc_opt == OMAP_ECC_BCH8_CODE_HW) ?
@@ -1235,30 +1680,67 @@ static int omap3_init_bch(struct mtd_info *mtd, int ecc_opt)
 		goto fail;
 	}
 
-	/* software bch library is only used to detect and locate errors */
-	info->bch = init_bch(13, max_errors, 0x201b /* hw polynomial */);
-	if (!info->bch)
-		goto fail;
+	info->nand.ecc.size = 512;
+	info->nand.ecc.hwctl = omap3_enable_hwecc_bch;
+	info->nand.ecc.mode = NAND_ECC_HW;
+	info->nand.ecc.strength = max_errors;
 
-	info->nand.ecc.size    = 512;
-	info->nand.ecc.hwctl   = omap3_enable_hwecc_bch;
-	info->nand.ecc.correct = omap3_correct_data_bch;
-	info->nand.ecc.mode    = NAND_ECC_HW;
+	if (hw_errors == BCH8_MAX_ERROR)
+		bch_type = BCH8_ECC;
+	else
+		bch_type = BCH4_ECC;
 
-	/*
-	 * The number of corrected errors in an ecc block that will trigger
-	 * block scrubbing defaults to the ecc strength (4 or 8).
-	 * Set mtd->bitflip_threshold here to define a custom threshold.
-	 */
+	/* Detect availability of ELM module */
+	parp = of_get_property(info->of_node, "elm_id", &lenp);
+	if ((parp == NULL) && (lenp != (sizeof(void *) * 2))) {
+		pr_err("Missing elm_id property, fall back to Software BCH\n");
+		info->is_elm_used = false;
+	} else {
+		struct platform_device *pdev;
 
-	if (max_errors == 8) {
-		info->nand.ecc.strength  = 8;
-		info->nand.ecc.bytes     = 13;
-		info->nand.ecc.calculate = omap3_calculate_ecc_bch8;
+		elm_node = of_find_node_by_phandle(be32_to_cpup(parp));
+		pdev = of_find_device_by_node(elm_node);
+		info->elm_dev = &pdev->dev;
+		elm_config(info->elm_dev, bch_type);
+		info->is_elm_used = true;
+	}
+
+	if (info->is_elm_used && (mtd->writesize <= 4096)) {
+
+		if (hw_errors == BCH8_MAX_ERROR)
+			info->nand.ecc.bytes = BCH8_SIZE;
+		else
+			info->nand.ecc.bytes = BCH4_SIZE;
+
+		info->nand.ecc.correct = omap_elm_correct_data;
+		info->nand.ecc.calculate = omap3_calculate_ecc_bch;
+		info->nand.ecc.read_page = omap_read_page_bch;
+		info->nand.ecc.write_page = omap_write_page_bch;
 	} else {
-		info->nand.ecc.strength  = 4;
-		info->nand.ecc.bytes     = 7;
-		info->nand.ecc.calculate = omap3_calculate_ecc_bch4;
+		/*
+		 * software bch library is only used to detect and
+		 * locate errors
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
@@ -1274,7 +1756,7 @@ fail:
  */
 static int omap3_init_bch_tail(struct mtd_info *mtd)
 {
-	int i, steps;
+	int i, steps, offset;
 	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
 						   mtd);
 	struct nand_ecclayout *layout = &info->ecclayout;
@@ -1296,11 +1778,21 @@ static int omap3_init_bch_tail(struct mtd_info *mtd)
 		goto fail;
 	}
 
+	/* ECC layout compatible with RBL for BCH8 */
+	if (info->is_elm_used && (info->nand.ecc.bytes == BCH8_SIZE))
+		offset = 2;
+	else
+		offset = mtd->oobsize - layout->eccbytes;
+
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
 
@@ -1364,6 +1856,9 @@ static int omap_nand_probe(struct platform_device *pdev)
 
 	info->nand.options	= pdata->devsize;
 	info->nand.options	|= NAND_SKIP_BBTSCAN;
+#ifdef CONFIG_MTD_NAND_OMAP_BCH
+	info->of_node		= pdata->of_node;
+#endif
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
diff --git a/include/linux/platform_data/elm.h b/include/linux/platform_data/elm.h
index 11ab6aa..1bd5244 100644
--- a/include/linux/platform_data/elm.h
+++ b/include/linux/platform_data/elm.h
@@ -30,7 +30,8 @@ enum bch_ecc {
 #define BCH4_ECC_OOB_BYTES		7
 /* RBL requires 14 byte even though BCH8 uses only 13 byte */
 #define BCH8_SIZE			(BCH8_ECC_OOB_BYTES + 1)
-#define BCH4_SIZE			(BCH4_ECC_OOB_BYTES)
+/* Uses 1 extra byte to handle erased pages */
+#define BCH4_SIZE			(BCH4_ECC_OOB_BYTES + 1)
 
 /**
  * struct elm_errorvec - error vector for elm
-- 
1.7.9.5

