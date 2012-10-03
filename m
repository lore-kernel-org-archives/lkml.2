Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab2JCOxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:53:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41339 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764Ab2JCOxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:53:51 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>,
        <tony@atomide.com>
CC: <afzal@ti.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <ivan.djelic@parrot.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH 3/4] ARM: OMAP2: gpmc: Add support for BCH ECC scheme
Date: Wed, 3 Oct 2012 19:59:48 +0530
Message-ID: <1349274589-11389-4-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
References: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for BCH ECC scheme to gpmc driver and also enabling multi
sector read/write. This helps in doing single shot NAND page read and
write.

ECC engine configurations
BCH 4 bit support
1. write => ECC engine configured in wrap mode 6 and with ecc_size0 as 32.
2. read  => ECC engine configured in wrap mode 1 and with ecc_size0 as
13 and ecc_size1 as 1.

BCH 8 bit support
1. write => ECC engine configured in wrap mode 6 and with ecc_size0 as 32.
2. read  => ECC engine configured in wrap mode 1 and with ecc_size0 as
26 and ecc_size1 as 2.

Note: For BCH8 ECC bytes set to 14 to make compatible with RBL.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
:100644 100644 72428bd... c9bc3cf... M	arch/arm/mach-omap2/gpmc.c
:100644 100644 2e6e259... c916510... M	arch/arm/plat-omap/include/plat/gpmc.h
 arch/arm/mach-omap2/gpmc.c             |  120 +++++++++++++++++++++++++++++---
 arch/arm/plat-omap/include/plat/gpmc.h |    1 +
 2 files changed, 112 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 72428bd..c9bc3cf 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -24,6 +24,7 @@
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/mtd/nand.h>
 
 #include <asm/mach-types.h>
 #include <plat/gpmc.h>
@@ -83,6 +84,18 @@
 #define ENABLE_PREFETCH		(0x1 << 7)
 #define DMA_MPU_MODE		2
 
+/* GPMC ecc engine settings for read */
+#define BCH_WRAPMODE_1		1	/* BCH wrap mode 6 */
+#define BCH8R_ECC_SIZE0		0x1a	/* ecc_size0 = 26 */
+#define BCH8R_ECC_SIZE1		0x2	/* ecc_size1 = 2 */
+#define BCH4R_ECC_SIZE0		0xd	/* ecc_size0 = 13 */
+#define BCH4R_ECC_SIZE1		0x1	/* ecc_size1 = 1 4bit padding in BCH4 */
+
+/* GPMC ecc engine settings for write */
+#define BCH_WRAPMODE_6		6	/* BCH wrap mode 6 */
+#define BCH_ECC_SIZE0		0x0	/* ecc_size0 = 0, no oob protection */
+#define BCH_ECC_SIZE1		0x20	/* ecc_size1 = 32 */
+
 /* XXX: Only NAND irq has been considered,currently these are the only ones used
  */
 #define	GPMC_NR_IRQ		2
@@ -1119,7 +1132,8 @@ EXPORT_SYMBOL_GPL(gpmc_init_hwecc_bch);
 int gpmc_enable_hwecc_bch(int cs, int mode, int dev_width, int nsectors,
 			  int nerrors)
 {
-	unsigned int val;
+	unsigned int val, wr_mode;
+	unsigned int ecc_size1, ecc_size0;
 
 	/* check if ecc module is in use */
 	if (gpmc_ecc_used != -EINVAL)
@@ -1130,18 +1144,35 @@ int gpmc_enable_hwecc_bch(int cs, int mode, int dev_width, int nsectors,
 	/* clear ecc and enable bits */
 	gpmc_write_reg(GPMC_ECC_CONTROL, 0x1);
 
-	/*
-	 * When using BCH, sector size is hardcoded to 512 bytes.
-	 * Here we are using wrapping mode 6 both for reading and writing, with:
-	 *  size0 = 0  (no additional protected byte in spare area)
-	 *  size1 = 32 (skip 32 nibbles = 16 bytes per sector in spare area)
-	 */
-	gpmc_write_reg(GPMC_ECC_SIZE_CONFIG, (32 << 22) | (0 << 12));
+	/*  When using BCH, sector size is hard coded to 512 bytes. */
+	if ((mode == NAND_ECC_READ) && (nsectors != 1)) {
+		/*
+		 * Here we are using wrapping mode 1 for reading, for
+		 * supporting multi sector reading.
+		 * Read mode, ECC engine enabled for valid ecc_size0 nibbles
+		 * & disabled for ecc_size1 nibbles.
+		 */
+		ecc_size0 = (nerrors == 8) ? BCH8R_ECC_SIZE0 : BCH4R_ECC_SIZE0;
+		ecc_size1 = (nerrors == 8) ? BCH8R_ECC_SIZE1 : BCH4R_ECC_SIZE1;
+		wr_mode = BCH_WRAPMODE_1;
+	} else {
+		/*
+		 * Here we are using wrapping mode 6 for writing,
+		 * ECC engine enabled for valid ecc_size0 nibbles
+		 * & disabled for ecc_size1 nibbles.
+		 */
+		ecc_size0 = BCH_ECC_SIZE0;
+		ecc_size1 = BCH_ECC_SIZE1;
+		wr_mode = BCH_WRAPMODE_6;
+	}
+
+	gpmc_write_reg(GPMC_ECC_SIZE_CONFIG, (ecc_size1 << 22) |
+			(ecc_size0 << 12));
 
 	/* BCH configuration */
 	val = ((1                        << 16) | /* enable BCH */
 	       (((nerrors == 8) ? 1 : 0) << 12) | /* 8 or 4 bits */
-	       (0x06                     <<  8) | /* wrap mode = 6 */
+	       (wr_mode                  <<  8) | /* wrap mode = 6 or 1 */
 	       (dev_width                <<  7) | /* bus width */
 	       (((nsectors-1) & 0x7)     <<  4) | /* number of sectors */
 	       (cs                       <<  1) | /* ECC CS */
@@ -1154,6 +1185,77 @@ int gpmc_enable_hwecc_bch(int cs, int mode, int dev_width, int nsectors,
 EXPORT_SYMBOL_GPL(gpmc_enable_hwecc_bch);
 
 /**
+ * gpmc_calculate_ecc_bch	- Generate ecc bytes per block of 512 data bytes for entire page
+ * @cs:  chip select number
+ * @dat: The pointer to data on which ECC is computed
+ * @ecc: The ECC output buffer
+ */
+int gpmc_calculate_ecc_bch(int cs, const u_char *dat, u_char *ecc)
+{
+	int i, eccbchtsel;
+	u32 nsectors, reg, bch_val1, bch_val2, bch_val3, bch_val4;
+
+	if (gpmc_ecc_used != cs)
+		return -EINVAL;
+
+	/* read number of sectors for ecc to be calculated */
+	nsectors = ((gpmc_read_reg(GPMC_ECC_CONFIG) >> 4) & 0x7) + 1;
+	/*
+	 * find BCH scheme used
+	 * 0 -> BCH4
+	 * 1 -> BCH8
+	 */
+	eccbchtsel = ((gpmc_read_reg(GPMC_ECC_CONFIG) >> 12) & 0x3);
+
+	/* update ecc bytes for entire page */
+	for (i = 0; i < nsectors; i++) {
+
+		reg = GPMC_ECC_BCH_RESULT_0 + 16 * i;
+
+		/* Read hw-computed remainder */
+		bch_val1 = gpmc_read_reg(reg + 0);
+		bch_val2 = gpmc_read_reg(reg + 4);
+		if (eccbchtsel) {
+			bch_val3 = gpmc_read_reg(reg + 8);
+			bch_val4 = gpmc_read_reg(reg + 12);
+		}
+
+		if (eccbchtsel) {
+			/* BCH8 ecc scheme */
+			*ecc++ = (bch_val4 & 0xFF);
+			*ecc++ = ((bch_val3 >> 24) & 0xFF);
+			*ecc++ = ((bch_val3 >> 16) & 0xFF);
+			*ecc++ = ((bch_val3 >> 8) & 0xFF);
+			*ecc++ = (bch_val3 & 0xFF);
+			*ecc++ = ((bch_val2 >> 24) & 0xFF);
+			*ecc++ = ((bch_val2 >> 16) & 0xFF);
+			*ecc++ = ((bch_val2 >> 8) & 0xFF);
+			*ecc++ = (bch_val2 & 0xFF);
+			*ecc++ = ((bch_val1 >> 24) & 0xFF);
+			*ecc++ = ((bch_val1 >> 16) & 0xFF);
+			*ecc++ = ((bch_val1 >> 8) & 0xFF);
+			*ecc++ = (bch_val1 & 0xFF);
+			/* 14th byte of ecc not used */
+			*ecc++ = 0;
+		} else {
+			/* BCH4 ecc scheme */
+			*ecc++ = ((bch_val2 >> 12) & 0xFF);
+			*ecc++ = ((bch_val2 >> 4) & 0xFF);
+			*ecc++ = (((bch_val2 & 0xF) << 4) |
+					((bch_val1 >> 28) & 0xF));
+			*ecc++ = ((bch_val1 >> 20) & 0xFF);
+			*ecc++ = ((bch_val1 >> 12) & 0xFF);
+			*ecc++ = ((bch_val1 >> 4) & 0xFF);
+			*ecc++ = ((bch_val1 & 0xF) << 4);
+		}
+	}
+
+	gpmc_ecc_used = -EINVAL;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(gpmc_calculate_ecc_bch);
+
+/**
  * gpmc_calculate_ecc_bch4 - Generate 7 ecc bytes per sector of 512 data bytes
  * @cs:  chip select number
  * @dat: The pointer to data on which ecc is computed
diff --git a/arch/arm/plat-omap/include/plat/gpmc.h b/arch/arm/plat-omap/include/plat/gpmc.h
index 2e6e259..c916510 100644
--- a/arch/arm/plat-omap/include/plat/gpmc.h
+++ b/arch/arm/plat-omap/include/plat/gpmc.h
@@ -185,6 +185,7 @@ int gpmc_enable_hwecc_bch(int cs, int mode, int dev_width, int nsectors,
 			  int nerrors);
 int gpmc_calculate_ecc_bch4(int cs, const u_char *dat, u_char *ecc);
 int gpmc_calculate_ecc_bch8(int cs, const u_char *dat, u_char *ecc);
+int gpmc_calculate_ecc_bch(int cs, const u_char *dat, u_char *ecc);
 #endif /* CONFIG_ARCH_OMAP3 */
 
 #endif
-- 
1.7.0.4

