Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab1J1RxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:53:08 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:40310 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987Ab1J1RxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:53:03 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dwmw2@infradead.org, dedekind1@gmail.com, mikedunn@newsguy.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 09/13] mtd/docg3: add write functions
Date: Fri, 28 Oct 2011 19:51:28 +0200
Message-Id: <1319824292-11085-10-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
References: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add write capability to the docg3 driver. The writes are
possible on a single page (512 bytes + 16 bytes), even if
that page is split on 2 physical pages on 2 blocks (each on
one plane).

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/mtd/devices/docg3.c |  434 +++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 421 insertions(+), 13 deletions(-)

diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index 26fc135..92522e0 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -248,6 +248,40 @@ static void doc_read_data_area(struct docg3 *docg3, void *buf, int len,
 }
 
 /**
+ * doc_write_data_area - Write data into data area
+ * @docg3: the device
+ * @buf: the buffer to get input bytes from
+ * @len: the length to write
+ *
+ * Writes bytes into flash data. Handles the single byte / even bytes writes.
+ */
+static void doc_write_data_area(struct docg3 *docg3, const void *buf, int len)
+{
+	int i, cdr, len4;
+	u16 *src16;
+	u8 *src8;
+
+	doc_dbg("doc_write_data_area(buf=%p, len=%d)\n", buf, len);
+	cdr = len & 0x3;
+	len4 = len - cdr;
+
+	doc_writew(docg3, DOC_IOSPACE_DATA, DOC_READADDRESS);
+	src16 = (u16 *)buf;
+	for (i = 0; i < len4; i += 2) {
+		doc_writew(docg3, *src16, DOC_IOSPACE_DATA);
+		src16++;
+	}
+
+	src8 = (u8 *)src16;
+	for (i = 0; i < cdr; i++) {
+		doc_writew(docg3, DOC_IOSPACE_DATA | DOC_READADDR_ONE_BYTE,
+			   DOC_READADDRESS);
+		doc_writeb(docg3, *src8, DOC_IOSPACE_DATA);
+		src8++;
+	}
+}
+
+/**
  * doc_set_data_mode - Sets the flash to reliable data mode
  * @docg3: the device
  *
@@ -337,6 +371,37 @@ static int doc_set_extra_page_mode(struct docg3 *docg3)
 }
 
 /**
+ * doc_setup_addr_sector - Setup blocks/page/ofs address for one plane
+ * @docg3: the device
+ * @sector: the sector
+ */
+static void doc_setup_addr_sector(struct docg3 *docg3, int sector)
+{
+	doc_delay(docg3, 1);
+	doc_flash_address(docg3, sector & 0xff);
+	doc_flash_address(docg3, (sector >> 8) & 0xff);
+	doc_flash_address(docg3, (sector >> 16) & 0xff);
+	doc_delay(docg3, 1);
+}
+
+/**
+ * doc_setup_writeaddr_sector - Setup blocks/page/ofs address for one plane
+ * @docg3: the device
+ * @sector: the sector
+ * @ofs: the offset in the page, between 0 and (512 + 16 + 512)
+ */
+static void doc_setup_writeaddr_sector(struct docg3 *docg3, int sector, int ofs)
+{
+	ofs = ofs >> 2;
+	doc_delay(docg3, 1);
+	doc_flash_address(docg3, ofs & 0xff);
+	doc_flash_address(docg3, sector & 0xff);
+	doc_flash_address(docg3, (sector >> 8) & 0xff);
+	doc_flash_address(docg3, (sector >> 16) & 0xff);
+	doc_delay(docg3, 1);
+}
+
+/**
  * doc_seek - Set both flash planes to the specified block, page for reading
  * @docg3: the device
  * @block0: the first plane block index
@@ -372,27 +437,73 @@ static int doc_read_seek(struct docg3 *docg3, int block0, int block1, int page,
 	if (ret)
 		goto out;
 
-	sector = (block0 << DOC_ADDR_BLOCK_SHIFT) + (page & DOC_ADDR_PAGE_MASK);
 	doc_flash_sequence(docg3, DOC_SEQ_READ);
+	sector = (block0 << DOC_ADDR_BLOCK_SHIFT) + (page & DOC_ADDR_PAGE_MASK);
 	doc_flash_command(docg3, DOC_CMD_PROG_BLOCK_ADDR);
-	doc_delay(docg3, 1);
-	doc_flash_address(docg3, sector & 0xff);
-	doc_flash_address(docg3, (sector >> 8) & 0xff);
-	doc_flash_address(docg3, (sector >> 16) & 0xff);
-	doc_delay(docg3, 1);
+	doc_setup_addr_sector(docg3, sector);
 
 	sector = (block1 << DOC_ADDR_BLOCK_SHIFT) + (page & DOC_ADDR_PAGE_MASK);
 	doc_flash_command(docg3, DOC_CMD_PROG_BLOCK_ADDR);
+	doc_setup_addr_sector(docg3, sector);
 	doc_delay(docg3, 1);
-	doc_flash_address(docg3, sector & 0xff);
-	doc_flash_address(docg3, (sector >> 8) & 0xff);
-	doc_flash_address(docg3, (sector >> 16) & 0xff);
+
+out:
+	return ret;
+}
+
+/**
+ * doc_write_seek - Set both flash planes to the specified block, page for writing
+ * @docg3: the device
+ * @block0: the first plane block index
+ * @block1: the second plane block index
+ * @page: the page index within the block
+ * @ofs: offset in page to write
+ *
+ * Programs the flash even and odd planes to the specific block and page.
+ * Alternatively, programs the flash to the wear area of the specified page.
+ */
+static int doc_write_seek(struct docg3 *docg3, int block0, int block1, int page,
+			 int ofs)
+{
+	int ret = 0, sector;
+
+	doc_dbg("doc_write_seek(blocks=(%d,%d), page=%d, ofs=%d)\n",
+		block0, block1, page, ofs);
+
+	doc_set_reliable_mode(docg3);
+
+	if (ofs < 2 * DOC_LAYOUT_PAGE_SIZE) {
+		doc_flash_sequence(docg3, DOC_SEQ_SET_PLANE1);
+		doc_flash_command(docg3, DOC_CMD_READ_PLANE1);
+		doc_delay(docg3, 2);
+	} else {
+		doc_flash_sequence(docg3, DOC_SEQ_SET_PLANE2);
+		doc_flash_command(docg3, DOC_CMD_READ_PLANE2);
+		doc_delay(docg3, 2);
+	}
+
+	doc_flash_sequence(docg3, DOC_SEQ_PAGE_SETUP);
+	doc_flash_command(docg3, DOC_CMD_PROG_CYCLE1);
+
+	sector = (block0 << DOC_ADDR_BLOCK_SHIFT) + (page & DOC_ADDR_PAGE_MASK);
+	doc_setup_writeaddr_sector(docg3, sector, ofs);
+
+	doc_flash_command(docg3, DOC_CMD_PROG_CYCLE3);
 	doc_delay(docg3, 2);
+	ret = doc_wait_ready(docg3);
+	if (ret)
+		goto out;
+
+	doc_flash_command(docg3, DOC_CMD_PROG_CYCLE1);
+	sector = (block1 << DOC_ADDR_BLOCK_SHIFT) + (page & DOC_ADDR_PAGE_MASK);
+	doc_setup_writeaddr_sector(docg3, sector, ofs);
+	doc_delay(docg3, 1);
 
 out:
 	return ret;
 }
 
+
 /**
  * doc_read_page_ecc_init - Initialize hardware ECC engine
  * @docg3: the device
@@ -415,6 +526,58 @@ static int doc_read_page_ecc_init(struct docg3 *docg3, int len)
 }
 
 /**
+ * doc_write_page_ecc_init - Initialize hardware BCH ECC engine
+ * @docg3: the device
+ * @len: the number of bytes covered by the ECC (BCH covered)
+ *
+ * The function does initialize the hardware ECC engine to compute the Hamming
+ * ECC (on 1 byte) and the BCH Syndroms (on 7 bytes).
+ *
+ * Return 0 if succeeded, -EIO on error
+ */
+static int doc_write_page_ecc_init(struct docg3 *docg3, int len)
+{
+	doc_writew(docg3, !DOC_ECCCONF0_READ_MODE
+		   | DOC_ECCCONF0_BCH_ENABLE | DOC_ECCCONF0_HAMMING_ENABLE
+		   | (len & DOC_ECCCONF0_DATA_BYTES_MASK),
+		   DOC_ECCCONF0);
+	doc_delay(docg3, 4);
+	doc_register_readb(docg3, DOC_FLASHCONTROL);
+	return doc_wait_ready(docg3);
+}
+
+/**
+ * doc_ecc_disable - Disable Hamming and BCH ECC hardware calculator
+ * @docg3: the device
+ *
+ * Disables the hardware ECC generator and checker, for unchecked reads (as when
+ * reading OOB only or write status byte).
+ */
+static void doc_ecc_disable(struct docg3 *docg3)
+{
+	doc_writew(docg3, DOC_ECCCONF0_READ_MODE, DOC_ECCCONF0);
+	doc_delay(docg3, 4);
+}
+
+/**
+ * doc_hamming_ecc_init - Initialize hardware Hamming ECC engine
+ * @docg3: the device
+ * @nb_bytes: the number of bytes covered by the ECC (Hamming covered)
+ *
+ * This function programs the ECC hardware to compute the hamming code on the
+ * last provided N bytes to the hardware generator.
+ */
+static void doc_hamming_ecc_init(struct docg3 *docg3, int nb_bytes)
+{
+	u8 ecc_conf1;
+
+	ecc_conf1 = doc_register_readb(docg3, DOC_ECCCONF1);
+	ecc_conf1 &= ~DOC_ECCCONF1_HAMMING_BITS_MASK;
+	ecc_conf1 |= (nb_bytes & DOC_ECCCONF1_HAMMING_BITS_MASK);
+	doc_writeb(docg3, ecc_conf1, DOC_ECCCONF1);
+}
+
+/**
  * doc_read_page_prepare - Prepares reading data from a flash page
  * @docg3: the device
  * @block0: the first plane block index on flash memory
@@ -500,11 +663,25 @@ static int doc_read_page_getbytes(struct docg3 *docg3, int len, u_char *buf,
 }
 
 /**
+ * doc_write_page_putbytes - Writes bytes into a prepared page
+ * @docg3: the device
+ * @len: the number of bytes to be written
+ * @buf: the buffer of input bytes
+ *
+ */
+static void doc_write_page_putbytes(struct docg3 *docg3, int len,
+				    const u_char *buf)
+{
+	doc_write_data_area(docg3, buf, len);
+	doc_delay(docg3, 2);
+}
+
+/**
  * doc_get_hw_bch_syndroms - Get hardware calculated BCH syndroms
  * @docg3: the device
  * @syns:  the array of 7 integers where the syndroms will be stored
  */
-static void doc_get_hw_bch_syndroms(struct docg3 *docg3, int *syns)
+static void doc_get_hw_bch_syndroms(struct docg3 *docg3, u8 *syns)
 {
 	int i;
 
@@ -513,6 +690,16 @@ static void doc_get_hw_bch_syndroms(struct docg3 *docg3, int *syns)
 }
 
 /**
+ * doc_page_finish - Ends reading/writing of a flash page
+ * @docg3: the device
+ */
+static void doc_page_finish(struct docg3 *docg3)
+{
+	doc_writeb(docg3, 0, DOC_DATAEND);
+	doc_delay(docg3, 2);
+}
+
+/**
  * doc_read_page_finish - Ends reading of a flash page
  * @docg3: the device
  *
@@ -522,8 +709,7 @@ static void doc_get_hw_bch_syndroms(struct docg3 *docg3, int *syns)
  */
 static void doc_read_page_finish(struct docg3 *docg3)
 {
-	doc_writeb(docg3, 0, DOC_DATAEND);
-	doc_delay(docg3, 2);
+	doc_page_finish(docg3);
 	doc_set_device_id(docg3, 0);
 }
 
@@ -572,7 +758,7 @@ static int doc_read(struct mtd_info *mtd, loff_t from, size_t len,
 {
 	struct docg3 *docg3 = mtd->priv;
 	int block0, block1, page, readlen, ret, ofs = 0;
-	int syn[DOC_ECC_BCH_SIZE], eccconf1;
+	u8 syn[DOC_ECC_BCH_SIZE], eccconf1;
 	u8 oob[DOC_LAYOUT_OOB_SIZE];
 
 	ret = -EINVAL;
@@ -793,6 +979,227 @@ static int doc_get_erase_count(struct docg3 *docg3, loff_t from)
 	return max(plane1_erase_count, plane2_erase_count);
 }
 
+/**
+ * doc_get_op_status - get erase/write operation status
+ * @docg3: the device
+ *
+ * Queries the status from the chip, and returns it
+ *
+ * Returns the status (bits DOC_PLANES_STATUS_*)
+ */
+static int doc_get_op_status(struct docg3 *docg3)
+{
+	u8 status;
+
+	doc_flash_sequence(docg3, DOC_SEQ_PLANES_STATUS);
+	doc_flash_command(docg3, DOC_CMD_PLANES_STATUS);
+	doc_delay(docg3, 5);
+
+	doc_ecc_disable(docg3);
+	doc_read_data_area(docg3, &status, 1, 1);
+	doc_page_finish(docg3);
+	return status;
+}
+
+/**
+ * doc_write_erase_wait_status - wait for write or erase completion
+ * @docg3: the device
+ *
+ * Wait for the chip to be ready again after erase or write operation, and check
+ * erase/write status.
+ *
+ * Returns 0 if erase successfull, -EIO if erase/write issue, -ETIMEOUT if
+ * timeout
+ */
+static int doc_write_erase_wait_status(struct docg3 *docg3)
+{
+	int status, ret = 0;
+
+	if (!doc_is_ready(docg3))
+		usleep_range(3000, 3000);
+	if (!doc_is_ready(docg3)) {
+		doc_dbg("Timeout reached and the chip is still not ready\n");
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	status = doc_get_op_status(docg3);
+	if (status & DOC_PLANES_STATUS_FAIL) {
+		doc_dbg("Erase/Write failed on (a) plane(s), status = %x\n",
+			status);
+		ret = -EIO;
+	}
+
+out:
+	doc_writeb(docg3, 0, DOC_DATAEND);
+	doc_delay(docg3, 2);
+	return ret;
+}
+
+/**
+ * doc_write_page - Write a single page to the chip
+ * @docg3: the device
+ * @to: the offset from first block and first page, in bytes, aligned on page
+ *      size
+ * @buf: buffer to get bytes from
+ * @oob: buffer to get out of band bytes from (can be NULL if no OOB should be
+ *       written)
+ * @autoecc: if 0, all 16 bytes from OOB are taken, regardless of HW Hamming or
+ *           BCH computations. If 1, only bytes 0-7 and byte 15 are taken,
+ *           remaining ones are filled with hardware Hamming and BCH
+ *           computations. Its value is not meaningfull is oob == NULL.
+ *
+ * Write one full page (ie. 1 page split on two planes), of 512 bytes, with the
+ * OOB data. The OOB ECC is automatically computed by the hardware Hamming and
+ * BCH generator if autoecc is not null.
+ *
+ * Returns 0 if write successful, -EIO if write error, -EAGAIN if timeout
+ */
+static int doc_write_page(struct docg3 *docg3, loff_t to, const u_char *buf,
+			  const u_char *oob, int autoecc)
+{
+	int block0, block1, page, ret, ofs = 0;
+	u8 syn[DOC_ECC_BCH_SIZE], hamming;
+
+	doc_dbg("doc_write_page(to=%lld)\n", to);
+	calc_block_sector(to, &block0, &block1, &page, &ofs);
+
+	doc_set_device_id(docg3, docg3->device_id);
+	ret = doc_reset_seq(docg3);
+	if (ret)
+		goto err;
+
+	/* Program the flash address block and page */
+	ret = doc_write_seek(docg3, block0, block1, page, ofs);
+	if (ret)
+		goto err;
+
+	doc_write_page_ecc_init(docg3, DOC_ECC_BCH_COVERED_BYTES);
+	doc_delay(docg3, 2);
+	doc_write_page_putbytes(docg3, DOC_LAYOUT_PAGE_SIZE, buf);
+
+	if (oob && autoecc) {
+		doc_write_page_putbytes(docg3, DOC_LAYOUT_OOB_PAGEINFO_SZ, oob);
+		doc_delay(docg3, 2);
+		oob += DOC_LAYOUT_OOB_UNUSED_OFS;
+
+		hamming = doc_register_readb(docg3, DOC_HAMMINGPARITY);
+		doc_delay(docg3, 2);
+		doc_write_page_putbytes(docg3, DOC_LAYOUT_OOB_HAMMING_SZ,
+					&hamming);
+		doc_delay(docg3, 2);
+
+		doc_get_hw_bch_syndroms(docg3, syn);
+		doc_write_page_putbytes(docg3, DOC_LAYOUT_OOB_BCH_SZ, syn);
+		doc_delay(docg3, 2);
+
+		doc_write_page_putbytes(docg3, DOC_LAYOUT_OOB_UNUSED_SZ, oob);
+	}
+	if (oob && !autoecc)
+		doc_write_page_putbytes(docg3, DOC_LAYOUT_OOB_SIZE, oob);
+
+	doc_delay(docg3, 2);
+	doc_page_finish(docg3);
+	doc_delay(docg3, 2);
+	doc_flash_command(docg3, DOC_CMD_PROG_CYCLE2);
+	doc_delay(docg3, 2);
+
+	/*
+	 * The wait status will perform another doc_page_finish() call, but that
+	 * seems to please the docg3, so leave it.
+	 */
+	ret = doc_write_erase_wait_status(docg3);
+	return ret;
+err:
+	doc_read_page_finish(docg3);
+	return ret;
+}
+
+/**
+ * doc_write - Write a buffer to the chip
+ * @mtd: the device
+ * @to: the offset from first block and first page, in bytes, aligned on page
+ *      size
+ * @len: the number of bytes to write (must be a full page size, ie. 512)
+ * @retlen: the number of bytes actually written (0 or 512)
+ * @buf: the buffer to get bytes from
+ *
+ * Writes data to the chip. As there is need to have an OOB at hand, and only
+ * one OOB data is in the docg3 private data, only one page can be written at
+ * once.
+ *
+ * Returns 0 if write successful, -EIO if write error
+ */
+static int doc_write(struct mtd_info *mtd, loff_t to, size_t len,
+		     size_t *retlen, const u_char *buf)
+{
+	struct docg3 *docg3 = mtd->priv;
+	int block0, block1, page, ofs, ret = 0;
+
+	doc_dbg("doc_write(to=%lld, len=%zu)\n", to, len);
+	calc_block_sector(to, &block0, &block1, &page, &ofs);
+	if (block1 > docg3->max_block || len != mtd->writesize ||
+	    to + len > mtd->size || to != docg3->oob_write_ofs)
+		return -EINVAL;
+
+	*retlen = 0;
+	while (!ret && len > 0) {
+		ret = doc_write_page(docg3, to, buf, docg3->oob_write_buf,
+				     docg3->oob_autoecc);
+		to += DOC_LAYOUT_PAGE_SIZE;
+		len -= DOC_LAYOUT_PAGE_SIZE;
+		buf += DOC_LAYOUT_PAGE_SIZE;
+		*retlen += DOC_LAYOUT_PAGE_SIZE;
+	}
+
+	doc_set_device_id(docg3, 0);
+	return ret;
+}
+
+/**
+ * doc_write_oob - Write out of band bytes to flash
+ * @mtd: the device
+ * @ofs: the offset from first block and first page, in bytes, aligned on page
+ *       size
+ * @ops: the mtd oob structure
+ *
+ * Write OOB data into a temporary buffer, for the subsequent write page. The
+ * provided OOB should be 16 bytes long. If a data buffer is provided as well,
+ * issue the page write.
+ *
+ * Returns 0 is successfull, EINVAL if length is not 14 bytes
+ */
+static int doc_write_oob(struct mtd_info *mtd, loff_t ofs,
+			 struct mtd_oob_ops *ops)
+{
+	struct docg3 *docg3 = mtd->priv;
+
+	doc_dbg("doc_write_oob(from=%lld, buf=%p, len=%zu, mode=%d, "
+		"oob=%p, ooblen=%zu)\n", ofs, ops->datbuf, ops->len, ops->mode,
+		ops->oobbuf, ops->ooblen);
+	if (ops->oobbuf) {
+		if (ops->ooblen != DOC_LAYOUT_OOB_SIZE)
+			return -EINVAL;
+		switch (ops->mode) {
+		case MTD_OPS_PLACE_OOB:
+		case MTD_OPS_RAW:
+			docg3->oob_autoecc = 1;
+			docg3->oob_write_ofs = ofs;
+			memcpy(docg3->oob_write_buf, ops->oobbuf,
+			       DOC_LAYOUT_OOB_SIZE);
+			return 0;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	ops->retlen = 0;
+	if (ops->datbuf)
+		return doc_write(mtd, ofs, ops->len, &ops->retlen, ops->datbuf);
+	else
+		return 0;
+}
+
 /*
  * Debug sysfs entries
  */
@@ -1054,6 +1461,7 @@ static struct mtd_info *doc_probe_device(void __iomem *base, int floor,
 
 	doc_set_driver_info(chip_id, mtd);
 
+	doc_hamming_ecc_init(docg3, DOC_LAYOUT_OOB_PAGEINFO_SZ);
 	doc_reload_bbt(docg3);
 	return mtd;
 
-- 
1.7.5.4

