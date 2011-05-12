Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab1ELR2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:28:09 -0400
Received: from [69.28.251.93] ([69.28.251.93]:43818 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758008Ab1ELR2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:28:06 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Cc: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] mtd: m25p80: Use CFI to identify unknown flash chips
Date: Thu, 12 May 2011 10:26:36 -0700
Message-Id: <44968e74c437515e1785e468f1f7a347@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the newer SPI flash devices support both JEDEC and CFI queries.
While JEDEC RDID only returns the device ID, CFI provides the device
size, eraseblock size, and other information.  In some cases this may
allow previously unknown devices to be supported without adding yet
another entry to m25p_ids[].

This patch replaces jedec_probe() with a new cfi_probe() function.  The
existing JEDEC probe/match logic is attempted first, and CFI is only used
if no match is found.

Additionally, platform_data.type may now specify "auto", which instructs
m25p80.c to autodetect the chip type rather than trying to match a
specific entry.  In some situations, board manufacturers have multiple
sources for flash parts (usually with identical geometries), but do not
know in advance which specific part will be used on a given board.  The
"auto" parameter allows the BSP to indicate this to the driver, so that
the driver does not warn the user about a flash device mismatch.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---

v2: Rebase on the latest l2-mtd-2.6.git

 drivers/mtd/devices/m25p80.c |  180 ++++++++++++++++++++++++++++--------------
 1 files changed, 120 insertions(+), 60 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 2b0d054..7506ccb 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -25,6 +25,7 @@
 #include <linux/math64.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/kernel.h>
 #include <linux/mod_devicetable.h>
 
 #include <linux/mtd/cfi.h>
@@ -72,6 +73,11 @@
 #define	MAX_READY_WAIT_JIFFIES	(40 * HZ)	/* M25P16 specs 40s max chip erase */
 #define	MAX_CMD_SIZE		5
 
+#define	SPI_CFI_OFFSET		0x10	/* Start of CFI data in RDID result */
+#define	SPI_CFI_ERASE_REGIONS	2	/* Max EraseRegionInfo's supported */
+#define	SPI_CFI_LEN		(sizeof(struct cfi_ident) + \
+				 SPI_CFI_ERASE_REGIONS * 4)
+
 #ifdef CONFIG_M25PXX_USE_FAST_READ
 #define OPCODE_READ 	OPCODE_FAST_READ
 #define FAST_READ_DUMMY_BYTE 1
@@ -652,8 +658,8 @@ struct flash_info {
 	})
 
 /* NOTE: double check command sets and memory organization when you add
- * more flash chips.  This current list focusses on newer chips, which
- * have been converging on command sets which including JEDEC ID.
+ * new flash chips.  This current list focuses on newer chips, which
+ * have been converging on command sets which include JEDEC ID.
  */
 static const struct spi_device_id m25p_ids[] = {
 	/* Atmel -- some are (confusingly) marketed as "DataFlash" */
@@ -773,45 +779,87 @@ static const struct spi_device_id m25p_ids[] = {
 };
 MODULE_DEVICE_TABLE(spi, m25p_ids);
 
-static const struct spi_device_id *__devinit jedec_probe(struct spi_device *spi)
+static int __devinit cfi_probe(struct spi_device *spi, struct flash_info *det)
 {
 	int			tmp;
 	u8			code = OPCODE_RDID;
-	u8			id[5];
-	u32			jedec;
-	u16                     ext_jedec;
+	u8			id[SPI_CFI_OFFSET + SPI_CFI_LEN];
 	struct flash_info	*info;
+	struct cfi_ident	*cfi;
+	u32			device_size;
+
+	memset(det, 0, sizeof(*det));
 
-	/* JEDEC also defines an optional "extended device information"
-	 * string for after vendor-specific data, after the three bytes
-	 * we use here.  Supporting some chips might require using it.
+	/*
+	 * Read JEDEC 3-byte ID + extended 2-byte manufacturer ID + any
+	 * CFI data that might be present.  Then look for a match with
+	 * known devices.
 	 */
-	tmp = spi_write_then_read(spi, &code, 1, id, 5);
+
+	tmp = spi_write_then_read(spi, &code, 1, id, sizeof(id));
 	if (tmp < 0) {
 		DEBUG(MTD_DEBUG_LEVEL0, "%s: error %d reading JEDEC ID\n",
 			dev_name(&spi->dev), tmp);
-		return ERR_PTR(tmp);
+		return tmp;
 	}
-	jedec = id[0];
-	jedec = jedec << 8;
-	jedec |= id[1];
-	jedec = jedec << 8;
-	jedec |= id[2];
 
-	ext_jedec = id[3] << 8 | id[4];
+	det->jedec_id = id[0] << 16 | id[1] << 8 | id[2];
+	det->ext_id = id[3] << 8 | id[4];
 
 	for (tmp = 0; tmp < ARRAY_SIZE(m25p_ids) - 1; tmp++) {
 		info = (void *)m25p_ids[tmp].driver_data;
-		if (info->jedec_id == jedec) {
-			if (info->ext_id != 0 && info->ext_id != ext_jedec)
+		if (info->jedec_id == det->jedec_id) {
+			if (info->ext_id != 0 && info->ext_id != det->ext_id)
 				continue;
-			return &m25p_ids[tmp];
+			*det = *info;
+			dev_info(&spi->dev,
+				 "identified known JEDEC device %s (%d KiB)\n",
+				 m25p_ids[tmp].name,
+				 det->sector_size * det->n_sectors / 1024);
+			return 0;
 		}
 	}
-	dev_err(&spi->dev, "unrecognized JEDEC id %06x\n", jedec);
-	return ERR_PTR(-ENODEV);
-}
 
+	/* No match in the table; try obtaining the params via CFI instead. */
+
+	cfi = (struct cfi_ident *)&id[SPI_CFI_OFFSET];
+	if (cfi->qry[0] != 'Q' || cfi->qry[1] != 'R' || cfi->qry[2] != 'Y') {
+		dev_err(&spi->dev, "unrecognized JEDEC id %06x\n",
+			det->jedec_id);
+		return -ENODEV;
+	}
+
+	/*
+	 * m25p80.c always uses "uniform sector" mode.  If multiple regions
+	 * are defined, find the first >4KiB region and then calculate the
+	 * number of sectors from the reported device size.
+	 */
+
+	device_size = 1 << cfi->DevSize;
+	cfi->NumEraseRegions = min(cfi->NumEraseRegions,
+		(uint8_t)SPI_CFI_ERASE_REGIONS);
+
+	for (tmp = 0; tmp < cfi->NumEraseRegions; tmp++) {
+		det->sector_size =
+			(le32_to_cpu(cfi->EraseRegionInfo[tmp]) >> 8) & ~0xff;
+
+		if ((cfi->NumEraseRegions == 1 || det->sector_size > 4096) &&
+		    det->sector_size != 0 && device_size != 0 &&
+		    device_size >= det->sector_size &&
+		    device_size % det->sector_size == 0) {
+			det->n_sectors = device_size / det->sector_size;
+			dev_info(&spi->dev,
+				"found CFI device (%d KiB, id %06x-%04x)\n",
+				det->sector_size * det->n_sectors / 1024,
+				det->jedec_id, det->ext_id);
+			return 0;
+		}
+	}
+
+	dev_err(&spi->dev, "device id %06x has invalid CFI data\n",
+		det->jedec_id);
+	return -ENODEV;
+}
 
 /*
  * board specific setup should have ensured the SPI clock used here
@@ -823,52 +871,67 @@ static int __devinit m25p_probe(struct spi_device *spi)
 	const struct spi_device_id	*id = spi_get_device_id(spi);
 	struct flash_platform_data	*data;
 	struct m25p			*flash;
-	struct flash_info		*info;
+	struct flash_info		*info, cfi_info;
 	unsigned			i;
+	int				autodetect = 0;
 
-	/* Platform data helps sort out which chip type we have, as
-	 * well as how this board partitions it.  If we don't have
-	 * a chip ID, try the JEDEC id commands; they'll work for most
-	 * newer chips, even if we don't recognize the particular chip.
+	/*
+	 * "id" currently points to the m25p_ids[] entry matching
+	 * spi_board_info.modalias.  This could be a specific chip name
+	 * (ala "s25fl129p1") or it could just be our driver name ("m25p80").
+	 *
+	 * If a specific chip name is set in platform_data->type, try to look
+	 * up that name instead of using the modalias as the chip name.
+	 *
+	 * If platform_data->type says "auto", assume "id" is meaningless,
+	 * and just probe via JEDEC/CFI.
 	 */
+
 	data = spi->dev.platform_data;
 	if (data && data->type) {
 		const struct spi_device_id *plat_id;
 
-		for (i = 0; i < ARRAY_SIZE(m25p_ids) - 1; i++) {
-			plat_id = &m25p_ids[i];
-			if (strcmp(data->type, plat_id->name))
-				continue;
-			break;
-		}
+		if (strcmp(data->type, "auto") == 0)
+			autodetect = 1;
+		else {
+			for (i = 0; i < ARRAY_SIZE(m25p_ids) - 1; i++) {
+				plat_id = &m25p_ids[i];
+				if (strcmp(data->type, plat_id->name))
+					continue;
+				break;
+			}
 
-		if (i < ARRAY_SIZE(m25p_ids) - 1)
-			id = plat_id;
-		else
-			dev_warn(&spi->dev, "unrecognized id %s\n", data->type);
+			if (i < ARRAY_SIZE(m25p_ids) - 1)
+				id = plat_id;
+			else
+				dev_warn(&spi->dev, "unrecognized chip %s\n",
+					data->type);
+		}
 	}
 
 	info = (void *)id->driver_data;
 
-	if (info->jedec_id) {
-		const struct spi_device_id *jid;
-
-		jid = jedec_probe(spi);
-		if (IS_ERR(jid)) {
-			return PTR_ERR(jid);
-		} else if (jid != id) {
-			/*
-			 * JEDEC knows better, so overwrite platform ID. We
-			 * can't trust partitions any longer, but we'll let
-			 * mtd apply them anyway, since some partitions may be
-			 * marked read-only, and we don't want to lose that
-			 * information, even if it's not 100% accurate.
-			 */
-			dev_warn(&spi->dev, "found %s, expected %s\n",
-				 jid->name, id->name);
-			id = jid;
-			info = (void *)jid->driver_data;
-		}
+	/*
+	 * If we found an entry that claims to be JEDEC-compliant, read
+	 * the ID and make sure it matches.  (If not, print a warning but
+	 * continue anyway.)
+	 *
+	 * If we were asked to autodetect the chip type, go ahead and do so.
+	 */
+
+	if (info->jedec_id || autodetect) {
+		int rc = cfi_probe(spi, &cfi_info);
+		if (rc)
+			return rc;
+
+		if (!autodetect &&
+		    (info->jedec_id != cfi_info.jedec_id ||
+		     info->ext_id != cfi_info.ext_id))
+			dev_warn(&spi->dev,
+				"found id %06x, expected %06x (%s)\n",
+				cfi_info.jedec_id, info->jedec_id,
+				id->name);
+		info = &cfi_info;
 	}
 
 	flash = kzalloc(sizeof *flash, GFP_KERNEL);
@@ -940,9 +1003,6 @@ static int __devinit m25p_probe(struct spi_device *spi)
 			flash->addr_width = 3;
 	}
 
-	dev_info(&spi->dev, "%s (%lld Kbytes)\n", id->name,
-			(long long)flash->mtd.size >> 10);
-
 	DEBUG(MTD_DEBUG_LEVEL2,
 		"mtd .name = %s, .size = 0x%llx (%lldMiB) "
 			".erasesize = 0x%.8x (%uKiB) .numeraseregions = %d\n",
-- 
1.7.5

