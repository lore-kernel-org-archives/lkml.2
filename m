Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238Ab1B1FJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 00:09:41 -0500
Received: from mga03.intel.com ([143.182.124.21]:20768 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab1B1FJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 00:09:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,238,1297065600"; 
   d="scan'208";a="394871780"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, mark.a.allyn@intel.com,
        alan@linux.intel.com
Subject: RFC: [PATCH 5/5] staging: sep: add sep_crypto.c
Date: Sun, 27 Feb 2011 21:12:07 -0800
Message-Id: <1298869927-4431-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sep crypto.c has the kernel crypto api functionality for sep driver

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/Makefile     |    2 +-
 drivers/staging/sep/sep_crypto.c | 3328 ++++++++++++++++++++++++++++++++++++++
 drivers/staging/sep/sep_main.c   |    9 +
 3 files changed, 3338 insertions(+), 1 deletions(-)
 create mode 100644 drivers/staging/sep/sep_crypto.c

diff --git a/drivers/staging/sep/Makefile b/drivers/staging/sep/Makefile
index faa90a4..581829d 100644
--- a/drivers/staging/sep/Makefile
+++ b/drivers/staging/sep/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_DX_SEP) := sep_driver.o
-sep_driver-objs := sep_main.o
+sep_driver-objs := sep_main.o sep_crypto.o
diff --git a/drivers/staging/sep/sep_crypto.c b/drivers/staging/sep/sep_crypto.c
new file mode 100644
index 0000000..789efd6
--- /dev/null
+++ b/drivers/staging/sep/sep_crypto.c
@@ -0,0 +1,3328 @@
+/*
+ *
+ *  sep_crypto.c - Crypto interface structures
+ *
+ *  Copyright(c) 2009,2011 Intel Corporation. All rights reserved.
+ *  Contributions(c) 2009,2010 Discretix. All rights reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under the terms of the GNU General Public License as published by the Free
+ *  Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but WITHOUT
+ *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ *  more details.
+ *
+ *  You should have received a copy of the GNU General Public License along with
+ *  this program; if not, write to the Free Software Foundation, Inc., 59
+ *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ *
+ *  CONTACTS:
+ *
+ *  Mark Allyn		mark.a.allyn@intel.com
+ *  Jayant Mangalampalli jayant.mangalampalli@intel.com
+ *
+ *  CHANGES:
+ *
+ *  2009.06.26	Initial publish
+ *  2010.09.14  Upgrade to Medfield
+ *  2011.02.22  Enable Kernel Crypto
+ *
+ */
+/* #define DEBUG */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/kdev_t.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/poll.h>
+#include <linux/wait.h>
+#include <linux/pci.h>
+#include <linux/err.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/irq.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/jiffies.h>
+#include <linux/list.h>
+#include <linux/dma-mapping.h>
+#include <linux/delay.h>
+#include <linux/crypto.h>
+#include <crypto/internal/hash.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/sha.h>
+#include <crypto/md5.h>
+#include <crypto/aes.h>
+#include <crypto/des.h>
+#include <crypto/hash.h>
+#include "sep_driver_hw_defs.h"
+#include "sep_driver_config.h"
+#include "sep_driver_api.h"
+#include "sep_dev.h"
+#include "sep_crypto.h"
+
+/**
+ *	sep_alloc_sg_buf -
+ *	@sep: pinter to struct sep_device
+ *	@size: total size of area
+ *	@block_size: minimum size of chunks
+ *	each page is minimum or modulo this size
+ *	@returns: pointer to struct scatterlist for new
+ *	buffer
+ **/
+static struct scatterlist *sep_alloc_sg_buf(
+	struct sep_device *sep,
+	size_t size,
+	size_t block_size)
+{
+	u32 nbr_pages;
+	u32 ct1;
+	void *buf;
+	size_t current_size;
+	size_t real_page_size;
+
+	struct scatterlist *sg, *sg_temp;
+
+	if (size == 0)
+		return NULL;
+
+	dev_dbg(&sep->pdev->dev, "sep alloc sg buf\n");
+
+	current_size = 0;
+	nbr_pages = 0;
+	real_page_size = PAGE_SIZE - (PAGE_SIZE % block_size);
+	/**
+	 * The size of each page must be modulo of the operation
+	 * block size; increment by the modified page size until
+	 * the total size is reached, then you have the number of
+	 * pages
+	 */
+	while (current_size < size) {
+		current_size += real_page_size;
+		nbr_pages += 1;
+	}
+
+	sg = kmalloc((sizeof(struct scatterlist) * nbr_pages), GFP_ATOMIC);
+	if (!sg) {
+		dev_warn(&sep->pdev->dev, "Cannot allocate page for new sg\n");
+		return NULL;
+	}
+
+	sg_init_table(sg, nbr_pages);
+
+	current_size = 0;
+	sg_temp = sg;
+	for (ct1 = 0; ct1 < nbr_pages; ct1 += 1) {
+		buf = (void *)get_zeroed_page(GFP_ATOMIC);
+		if (!buf) {
+			dev_warn(&sep->pdev->dev,
+				"Cannot allocate page for new buffer\n");
+			kfree(sg);
+			return NULL;
+		}
+
+		sg_set_buf(sg_temp, buf, PAGE_SIZE);
+		if ((size - current_size) > real_page_size) {
+			sg_temp->length = real_page_size;
+			current_size += real_page_size;
+		} else {
+			sg_temp->length = (size - current_size);
+			current_size = size;
+		}
+		sg_temp = sg_next(sg);
+	}
+	return sg;
+}
+
+/**
+ *	sep_free_sg_buf -
+ *	@sg: pointer to struct scatterlist; points to area to free
+ */
+static void sep_free_sg_buf(struct scatterlist *sg)
+{
+	struct scatterlist *sg_temp = sg;
+		while (sg_temp) {
+			free_page((unsigned long)sg_virt(sg_temp));
+			sg_temp = sg_next(sg_temp);
+		}
+		kfree(sg);
+}
+
+/**
+ *	sep_copy_sg -
+ *	@sep: pointer to struct sep_device
+ *	@sg_src: pointer to struct scatterlist for source
+ *	@sg_dst: pointer to struct scatterlist for destination
+ *      @size: size (in bytes) of data to copy
+ *
+ *	Copy data from one scatterlist to another; both must
+ *	be the same size
+ */
+static void sep_copy_sg(
+	struct sep_device *sep,
+	struct scatterlist *sg_src,
+	struct scatterlist *sg_dst,
+	size_t size)
+{
+	u32 seg_size;
+	u32 in_offset, out_offset;
+
+	u32 count = 0;
+	struct scatterlist *sg_src_tmp = sg_src;
+	struct scatterlist *sg_dst_tmp = sg_dst;
+	in_offset = 0;
+	out_offset = 0;
+
+	dev_dbg(&sep->pdev->dev, "sep copy sg\n");
+
+	if ((sg_src == NULL) || (sg_dst == NULL) || (size == 0))
+		return;
+
+	dev_dbg(&sep->pdev->dev, "sep copy sg not null\n");
+
+	while (count < size) {
+		if ((sg_src_tmp->length - in_offset) >
+			(sg_dst_tmp->length - out_offset))
+			seg_size = sg_dst_tmp->length - out_offset;
+		else
+			seg_size = sg_src_tmp->length - in_offset;
+
+		if (seg_size > (size - count))
+			seg_size = (size = count);
+
+		memcpy(sg_virt(sg_dst_tmp) + out_offset,
+			sg_virt(sg_src_tmp) + in_offset,
+			seg_size);
+
+		in_offset += seg_size;
+		out_offset += seg_size;
+		count += seg_size;
+
+		if (in_offset >= sg_src_tmp->length) {
+			sg_src_tmp = sg_next(sg_src_tmp);
+			in_offset = 0;
+		}
+
+		if (out_offset >= sg_dst_tmp->length) {
+			sg_dst_tmp = sg_next(sg_dst_tmp);
+			out_offset = 0;
+		}
+	}
+}
+
+/**
+ *	sep_oddball_pages -
+ *	@sep: pointer to struct sep_device
+ *	@sg: pointer to struct scatterlist - buffer to check
+ *	@size: total data size
+ *	@blocksize: minimum block size; must be multiples of this size
+ *	@to_copy: 1 means do copy, 0 means do not copy
+ *	@new_sg: pointer to location to put pointer to new sg area
+ *	@returns: 1 if new scatterlist is needed; 0 if not needed;
+ *		error value if operation failed
+ *
+ *	The SEP device requires all pages to be multiples of the
+ *	minimum block size appropriate for the operation
+ *	This function check all pages; if any are oddball sizes
+ *	(not multiple of block sizes), it creates a new scatterlist.
+ *	If the to_copy parameter is set to 1, then a scatter list
+ *	copy is performed. The pointer to the new scatterlist is
+ *	put into the address supplied by the new_sg parameter; if
+ *	no new scatterlist is needed, then a NULL is put into
+ *	the location at new_sg.
+ *
+ */
+static int sep_oddball_pages(
+	struct sep_device *sep,
+	struct scatterlist *sg,
+	size_t data_size,
+	u32 block_size,
+	struct scatterlist **new_sg,
+	u32 do_copy)
+{
+	struct scatterlist *sg_temp;
+	u32 flag;
+	u32 nbr_pages, page_count;
+
+	dev_dbg(&sep->pdev->dev, "sep oddball\n");
+	if ((sg == NULL) || (data_size == 0) || (data_size < block_size))
+		return 0;
+
+	dev_dbg(&sep->pdev->dev, "sep oddball not null\n");
+	flag = 0;
+	nbr_pages = 0;
+	page_count = 0;
+	sg_temp = sg;
+
+	while (sg_temp) {
+		nbr_pages += 1;
+		sg_temp = sg_next(sg_temp);
+	}
+
+	sg_temp = sg;
+	while ((sg_temp) && (flag == 0)) {
+		page_count += 1;
+		if (sg_temp->length % block_size)
+			flag = 1;
+		else
+			sg_temp = sg_next(sg_temp);
+	}
+
+	/* Do not process if last (or only) page is oddball */
+	if (nbr_pages == page_count)
+		flag = 0;
+
+	if (flag) {
+		dev_dbg(&sep->pdev->dev, "sep oddball processing\n");
+		*new_sg = sep_alloc_sg_buf(sep, data_size, block_size);
+		if (*new_sg == NULL) {
+			dev_warn(&sep->pdev->dev, "cannot allocate new sg\n");
+			return -ENOMEM;
+		}
+
+		if (do_copy)
+			sep_copy_sg(sep, sg, *new_sg, data_size);
+
+		return 1;
+	} else {
+		return 0;
+	}
+}
+
+/**
+ *	sep_copy_offset_sg -
+ *	@sep: pointer to struct sep_device;
+ *	@sg: pointer to struct scatterlist
+ *	@offset: offset into scatterlist memory
+ *	@dst: place to put data
+ *	@len: length of data
+ *	@returns: number of bytes copies
+ *
+ *	This copies data from scatterlist buffer
+ *	offset from beginning - it is needed for
+ *	handling tail data in hash
+ */
+static size_t sep_copy_offset_sg(
+	struct sep_device *sep,
+	struct scatterlist *sg,
+	u32 offset,
+	void *dst,
+	u32 len)
+{
+	size_t page_start;
+	size_t page_end;
+	size_t offset_within_page;
+	size_t length_within_page;
+	size_t length_remaining;
+	size_t current_offset;
+
+	/* Find which page is beginning of segment */
+	page_start = 0;
+	page_end = sg->length;
+	while ((sg) && (offset > page_end)) {
+		page_start += sg->length;
+		sg = sg_next(sg);
+		if (sg)
+			page_end += sg->length;
+	}
+
+	if (sg == NULL)
+		return -ENOMEM;
+
+	offset_within_page = offset - page_start;
+	if ((sg->length - offset_within_page) >= len) {
+		/* All within this page */
+		memcpy(dst, sg_virt(sg) + offset_within_page, len);
+		return len;
+	} else {
+		/* Scattered multiple pages */
+		current_offset = 0;
+		length_remaining = len;
+		while ((sg) && (current_offset < len)) {
+			length_within_page = sg->length - offset_within_page;
+			if (length_within_page >= length_remaining) {
+				memcpy(dst+current_offset,
+					sg_virt(sg) + offset_within_page,
+					length_remaining);
+				length_remaining = 0;
+				current_offset = len;
+			} else {
+				memcpy(dst+current_offset,
+					sg_virt(sg) + offset_within_page,
+					length_within_page);
+				length_remaining -= length_within_page;
+				current_offset += length_within_page;
+				offset_within_page = 0;
+				sg = sg_next(sg);
+			}
+		}
+
+		if (sg == NULL)
+			return -ENOMEM;
+	}
+	return len;
+}
+
+/**
+ *	partial_overlap -
+ *	@src_ptr: source pointer
+ *	@dst_ptr: destination pointer
+ *	@nbytes: number of bytes
+ *	@returns: 0 for success; -1 for failure
+ *	We cannot have any partial overlap. Total overlap
+ *	where src is the same as dst is okay
+ */
+static int partial_overlap(void *src_ptr, void *dst_ptr, u32 nbytes)
+{
+	/* Check for partial overlap */
+	if (src_ptr != dst_ptr) {
+		if (src_ptr < dst_ptr) {
+			if ((src_ptr + nbytes) > dst_ptr)
+				return -EINVAL;
+		} else {
+			if ((dst_ptr + nbytes) > src_ptr)
+				return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+/* Debug - prints only if DEBUG is defined; follows kernel debug model */
+void sep_dump(struct sep_device *sep, char *stg, void *start, int len)
+{
+	int ct1;
+	u8 *ptt;
+	dev_dbg(&sep->pdev->dev,
+		"Dump of %s starting at %08lx for %08x bytes\n",
+		stg, (unsigned long)start, len);
+	for (ct1 = 0; ct1 < len; ct1 += 1) {
+		ptt = (u8 *)(start + ct1);
+		dev_dbg(&sep->pdev->dev, "%02x ", *ptt);
+		if (ct1 % 16 == 15)
+			dev_dbg(&sep->pdev->dev, "\n");
+	}
+	dev_dbg(&sep->pdev->dev, "\n");
+}
+
+/* Debug - prints only if DEBUG is defined; follows kernel debug model */
+void sep_dump_sg(struct sep_device *sep, char *stg, struct scatterlist *sg)
+{
+	int ct1, ct2;
+	u8 *ptt;
+	dev_dbg(&sep->pdev->dev, "Dump of scatterlist %s\n", stg);
+
+	ct1 = 0;
+	while (sg) {
+		dev_dbg(&sep->pdev->dev, "page %x\n size %x", ct1,
+			sg->length);
+		dev_dbg(&sep->pdev->dev, "phys addr is %lx",
+			(unsigned long)sg_phys(sg));
+		ptt = sg_virt(sg);
+		for (ct2 = 0; ct2 < sg->length; ct2 += 1) {
+			dev_dbg(&sep->pdev->dev, "byte %x is %02x\n",
+				ct2, (unsigned char)*(ptt + ct2));
+		}
+
+		ct1 += 1;
+		sg = sg_next(sg);
+	}
+	dev_dbg(&sep->pdev->dev, "\n");
+}
+
+/**
+  * Length must be in increments of block size
+  */
+u32 cipher_len(int nbytes, int block_size)
+{
+	int this_len = nbytes;
+	this_len -= (nbytes & (block_size - 1));
+	return this_len > (1 << 16) ? (1 << 16) : this_len;
+}
+
+/**
+ * RFC2451: Weak key check
+ * Returns: 1 (weak), 0 (not weak)
+ */
+int sep_weak_key(const u8 *key, unsigned int keylen)
+{
+	static const u8 parity[] = {
+	8, 1, 0, 8, 0, 8, 8, 0, 0, 8, 8, 0, 8, 0, 2, 8,
+	0, 8, 8, 0, 8, 0, 0, 8, 8,
+	0, 0, 8, 0, 8, 8, 3,
+	0, 8, 8, 0, 8, 0, 0, 8, 8, 0, 0, 8, 0, 8, 8, 0,
+	8, 0, 0, 8, 0, 8, 8, 0, 0,
+	8, 8, 0, 8, 0, 0, 8,
+	0, 8, 8, 0, 8, 0, 0, 8, 8, 0, 0, 8, 0, 8, 8, 0,
+	8, 0, 0, 8, 0, 8, 8, 0, 0,
+	8, 8, 0, 8, 0, 0, 8,
+	8, 0, 0, 8, 0, 8, 8, 0, 0, 8, 8, 0, 8, 0, 0, 8,
+	0, 8, 8, 0, 8, 0, 0, 8, 8,
+	0, 0, 8, 0, 8, 8, 0,
+	0, 8, 8, 0, 8, 0, 0, 8, 8, 0, 0, 8, 0, 8, 8, 0,
+	8, 0, 0, 8, 0, 8, 8, 0, 0,
+	8, 8, 0, 8, 0, 0, 8,
+	8, 0, 0, 8, 0, 8, 8, 0, 0, 8, 8, 0, 8, 0, 0, 8,
+	0, 8, 8, 0, 8, 0, 0, 8, 8,
+	0, 0, 8, 0, 8, 8, 0,
+	8, 0, 0, 8, 0, 8, 8, 0, 0, 8, 8, 0, 8, 0, 0, 8,
+	0, 8, 8, 0, 8, 0, 0, 8, 8,
+	0, 0, 8, 0, 8, 8, 0,
+	4, 8, 8, 0, 8, 0, 0, 8, 8, 0, 0, 8, 0, 8, 8, 0,
+	8, 5, 0, 8, 0, 8, 8, 0, 0,
+	8, 8, 0, 8, 0, 6, 8,
+	};
+
+	u32 n, w;
+
+	n  = parity[key[0]]; n <<= 4;
+	n |= parity[key[1]]; n <<= 4;
+	n |= parity[key[2]]; n <<= 4;
+	n |= parity[key[3]]; n <<= 4;
+	n |= parity[key[4]]; n <<= 4;
+	n |= parity[key[5]]; n <<= 4;
+	n |= parity[key[6]]; n <<= 4;
+	n |= parity[key[7]];
+	w = 0x88888888L;
+
+	/* 1 in 10^10 keys passes this test */
+	if (!((n - (w >> 3)) & w)) {
+		if (n < 0x41415151) {
+			if (n < 0x31312121) {
+				if (n < 0x14141515) {
+					/* 01 01 01 01 01 01 01 01 */
+					if (n == 0x11111111)
+						goto weak;
+					/* 01 1F 01 1F 01 0E 01 0E */
+					if (n == 0x13131212)
+						goto weak;
+				} else {
+					/* 01 E0 01 E0 01 F1 01 F1 */
+					if (n == 0x14141515)
+						goto weak;
+					/* 01 FE 01 FE 01 FE 01 FE */
+					if (n == 0x16161616)
+						goto weak;
+				}
+			} else {
+				if (n < 0x34342525) {
+					/* 1F 01 1F 01 0E 01 0E 01 */
+					if (n == 0x31312121)
+						goto weak;
+					/* 1F 1F 1F 1F 0E 0E 0E 0E (?) */
+					if (n == 0x33332222)
+						goto weak;
+				} else {
+					/* 1F E0 1F E0 0E F1 0E F1 */
+					if (n == 0x34342525)
+						goto weak;
+					/* 1F FE 1F FE 0E FE 0E FE */
+					if (n == 0x36362626)
+						goto weak;
+				}
+			}
+		} else {
+			if (n < 0x61616161) {
+				if (n < 0x44445555) {
+					/* E0 01 E0 01 F1 01 F1 01 */
+					if (n == 0x41415151)
+						goto weak;
+					/* E0 1F E0 1F F1 0E F1 0E */
+					if (n == 0x43435252)
+						goto weak;
+				} else {
+					/* E0 E0 E0 E0 F1 F1 F1 F1 (?) */
+					if (n == 0x44445555)
+						goto weak;
+					/* E0 FE E0 FE F1 FE F1 FE */
+					if (n == 0x46465656)
+						goto weak;
+				}
+			} else {
+				if (n < 0x64646565) {
+					/* FE 01 FE 01 FE 01 FE 01 */
+					if (n == 0x61616161)
+						goto weak;
+					/* FE 1F FE 1F FE 0E FE 0E */
+					if (n == 0x63636262)
+						goto weak;
+				} else {
+					/* FE E0 FE E0 FE F1 FE F1 */
+					if (n == 0x64646565)
+						goto weak;
+					/* FE FE FE FE FE FE FE FE */
+					if (n == 0x66666666)
+						goto weak;
+				}
+			}
+		}
+	}
+	return 0;
+weak:
+	return 1;
+}
+/**
+ *	sep_sg_nents
+ */
+static u32 sep_sg_nents(struct scatterlist *sg)
+{
+	u32 ct1 = 0;
+	while (sg) {
+		ct1 += 1;
+		sg = sg_next(sg);
+	}
+
+	return ct1;
+}
+
+/**
+ *	sep_start_msg -
+ *	@sep: pointer to struct sep_device
+ *	@returns: offset to place for the next word in the message
+ *	Set up pointer in message pool for new message
+ */
+u32 sep_start_msg(struct sep_device *sep)
+{
+	u32 *word_ptr;
+	sep->current_msg_ptr = sep->shared_addr;
+	sep->current_msg_ptr += sizeof(u32) * 2;
+	/* Clear area */
+	memset(sep->current_msg_ptr, 0, 4 * 1024);
+	word_ptr = (u32 *)sep->current_msg_ptr;
+	*word_ptr = SEP_START_MSG_TOKEN;
+	return sizeof(u32) * 2;
+}
+
+/**
+ *	sep_end_msg -
+ *	@sep: pointer to struct sep_device
+ *	@messages_offset: current message offset
+ *	End message; set length and CRC; and
+ *	send interrupt to the SEP
+ */
+void sep_end_msg(struct sep_device *sep, u32 msg_offset)
+{
+	u32 *word_ptr;
+	/* Msg size goes into msg after token */
+	sep->out_msg_size = msg_offset / sizeof(u32) + 1;
+	word_ptr = (u32 *)sep->current_msg_ptr;
+	word_ptr += 1;
+	*word_ptr = sep->out_msg_size;
+
+	/* CRC (currently 0) goes at end of msg */
+	word_ptr = (u32 *)(sep->current_msg_ptr + msg_offset);
+	*word_ptr = 0;
+
+	/* Send interrupt to sep */
+	dev_dbg(&sep->pdev->dev, "Sending following message to SEP\n");
+	/* sep_dump_message(sep); */
+	sep_send_msg_rdy_cmd();
+}
+
+/**
+ *	sep_start_inbound_msg -
+ *	@sep: pointer to struct sep_device
+ *	@msg_offset: offset to place for the next word in the message
+ *	@returns: 0 for success; error value for failure
+ *	Set up pointer in message pool for inbound message
+ */
+u32 sep_start_inbound_msg(struct sep_device *sep, u32 *msg_offset)
+{
+	u32 *word_ptr;
+	u32 token;
+	u32 error = SEP_OK;
+
+	*msg_offset = sizeof(u32) * 2;
+	word_ptr = (u32 *)sep->current_msg_ptr;
+	token = *word_ptr;
+	sep->in_msg_size = *(word_ptr + 1);
+
+	if (token != SEP_START_MSG_TOKEN) {
+		error = SEP_INVALID_START;
+		goto end_function;
+	}
+
+end_function:
+
+	return error;
+}
+
+/**
+ *	sep_write_msg -
+ *	@sep: pointer to struct sep_device
+ *	@in_addr: pointer to start of parameter
+ *	@size: size of parameter to copy (in bytes)
+ *	@max_size: size to move up offset; SEP mesg is in word sizes
+ *	@msg_offset: pointer to current offset (is updated)
+ *	@byte_array: flag ti indicate wheter endian must be changed
+ *	Copies data into the message area from caller
+ */
+void sep_write_msg(struct sep_device *sep, void *in_addr,
+	u32 size, u32 max_size, u32 *msg_offset, u32 byte_array)
+{
+	u32 *word_ptr;
+	void *void_ptr;
+	void_ptr = sep->current_msg_ptr + *msg_offset;
+	word_ptr = (u32 *)void_ptr;
+	memcpy(void_ptr, in_addr, size);
+	*msg_offset += max_size;
+
+	/* Do we need to manipulate endian? */
+	if (byte_array) {
+		u32 i;
+		for (i = 0; i < ((size + 3) / 4); i += 1)
+			*(word_ptr + i) = CHG_ENDIAN(*(word_ptr + i));
+	}
+}
+
+/**
+ *	sep_make_header
+ *	@sep: pointer to struct sep_device
+ *	@msg_offset: pointer to current offset (is updated)
+ *	@op_code: op code to put into message
+ *	Puts op code into message and updates offset
+ */
+void sep_make_header(struct sep_device *sep, u32 *msg_offset, u32 op_code)
+{
+	u32 *word_ptr;
+
+	*msg_offset = sep_start_msg(sep);
+	word_ptr = (u32 *)(sep->current_msg_ptr + *msg_offset);
+	*word_ptr = op_code;
+	*msg_offset += sizeof(u32);
+}
+
+
+
+/**
+ *	sep_read_msg -
+ *	@sep: pointer to struct sep_device
+ *	@in_addr: pointer to start of parameter
+ *	@size: size of parameter to copy (in bytes)
+ *	@max_size: size to move up offset; SEP mesg is in word sizes
+ *	@msg_offset: pointer to current offset (is updated)
+ *	@byte_array: flag ti indicate wheter endian must be changed
+ *	Copies data out of the message area to caller
+ */
+void sep_read_msg(struct sep_device *sep, void *in_addr,
+	u32 size, u32 max_size, u32 *msg_offset, u32 byte_array)
+{
+	u32 *word_ptr;
+	void *void_ptr;
+	void_ptr = sep->current_msg_ptr + *msg_offset;
+	word_ptr = (u32 *)void_ptr;
+
+	/* Do we need to manipulate endian? */
+	if (byte_array) {
+		u32 i;
+		for (i = 0; i < ((size + 3) / 4); i += 1)
+			*(word_ptr + i) = CHG_ENDIAN(*(word_ptr + i));
+	}
+
+	memcpy(in_addr, void_ptr, size);
+	*msg_offset += max_size;
+}
+
+/**
+ *	sep_verify_op -
+ *      @sep: pointer to struct sep_device
+ *	@op_code: expected op_code
+ *      @msg_offset: pointer to current offset (is updated)
+ *	@returns: 0 for success; error for failure
+ */
+u32 sep_verify_op(struct sep_device *sep, u32 op_code, u32 *msg_offset)
+{
+	u32 error;
+	u32 in_ary[2];
+
+	dev_dbg(&sep->pdev->dev, "dumping return message\n");
+	sep_dump_message(sep);
+	error = sep_start_inbound_msg(sep, msg_offset);
+	if (error) {
+		dev_warn(&sep->pdev->dev,
+			"sep_start_inbound_msg error\n");
+		return error;
+	}
+
+	sep_read_msg(sep, in_ary, sizeof(u32) * 2, sizeof(u32) * 2,
+		msg_offset, 0);
+
+	if (in_ary[0] != op_code) {
+		dev_warn(&sep->pdev->dev,
+			"sep got back wrong opcode\n");
+		dev_warn(&sep->pdev->dev,
+			"got back %x; expected %x\n",
+			in_ary[0], op_code);
+		return SEP_WRONG_OPCODE;
+	}
+
+	if (in_ary[1] != SEP_OK) {
+		dev_warn(&sep->pdev->dev,
+			"sep execution error\n");
+		dev_warn(&sep->pdev->dev,
+			"got back %x; expected %x\n",
+			in_ary[1], SEP_OK);
+		return in_ary[0];
+	}
+
+return 0;
+}
+
+/**
+ * sep_read_context -
+ * @sep: pointer to struct sep_device
+ * @msg_offset: point to current place in SEP msg; is updated
+ * @dst: pointer to place to put the context
+ * @len: size of the context structure (differs for crypro/hash)
+ * This function reads the context from the msg area
+ * There is a special way the vendor needs to have the maximum
+ * length calculated so that the msg_offset is updated properly;
+ * it skips over some words in the msg area depending on the size
+ * of the context
+ */
+void sep_read_context(struct sep_device *sep, u32 *msg_offset,
+	void *dst, u32 len)
+{
+	u32 max_length = ((len + 3) / sizeof(u32)) * sizeof(u32);
+	sep_read_msg(sep, dst, len, max_length, msg_offset, 0);
+}
+
+/**
+ * sep_write_context -
+ * @sep: pointer to struct sep_device
+ * @msg_offset: point to current place in SEP msg; is updated
+ * @src: pointer to the current context
+ * @len: size of the context structure (differs for crypro/hash)
+ * This function writes the context to the msg area
+ * There is a special way the vendor needs to have the maximum
+ * length calculated so that the msg_offset is updated properly;
+ * it skips over some words in the msg area depending on the size
+ * of the context
+ */
+void sep_write_context(struct sep_device *sep, u32 *msg_offset,
+	void *src, u32 len)
+{
+	u32 max_length = ((len + 3) / sizeof(u32)) * sizeof(u32);
+	sep_write_msg(sep, src, len, max_length, msg_offset, 0);
+}
+
+/**
+ * sep_clear_out -
+ * @sep: pointer to struct sep_device
+ * Clear out crypto related values in sep device structure
+ * to enable device to be used by anyone; either kernel
+ * crypto or userspace app via middleware
+ */
+void sep_clear_out(struct sep_device *sep)
+{
+	unsigned long flags;
+
+	if (sep->src_sg_hold) {
+		sep_free_sg_buf(sep->src_sg_hold);
+		sep->src_sg_hold = NULL;
+	}
+
+	if (sep->dst_sg_hold) {
+		sep_free_sg_buf(sep->dst_sg_hold);
+		sep->dst_sg_hold = NULL;
+	}
+
+	sep->src_sg = NULL;
+	sep->dst_sg = NULL;
+
+	sep_free_dma_table_kernel_data();
+
+	spin_lock_irqsave(&sep->busy_lock, flags);
+	sep_unlock();
+	sep->in_kernel = (u32)0;
+	sep->current_request = NO_REQUEST;
+	sep->current_cypher_req = NULL;
+	sep->current_hash_req = NULL;
+	if (sep->num_of_data_allocations > 0) {
+		memset((void *)(sep->shared_addr +
+			SEP_DRIVER_DATA_POOL_ALLOCATION_OFFSET_IN_BYTES),
+			0, sep->num_of_data_allocations * 2 * sizeof(u32));
+		sep->num_of_data_allocations = 0;
+		sep->data_pool_bytes_allocated = 0;
+	}
+
+	spin_unlock_irqrestore(&sep->busy_lock, flags);
+}
+
+/**
+  * Release crypto infrastructure from EINPROGRESS and
+  * clear sep_dev so that SEP is available to anyone
+  */
+void sep_crypto_release(struct sep_system_ctx *sctx, u32 error)
+{
+	struct ahash_request *hash_req = sctx->sep_used->current_hash_req;
+	struct ablkcipher_request *cypher_req =
+		sctx->sep_used->current_cypher_req;
+	struct sep_device *sep = sctx->sep_used;
+
+	sep_clear_out(sep);
+
+	if (cypher_req != NULL) {
+		if (cypher_req->base.complete == NULL) {
+			dev_dbg(&sep->pdev->dev,
+				"release is null for cypher!");
+		} else {
+			cypher_req->base.complete(
+				&cypher_req->base, error);
+		}
+	}
+
+	if (hash_req != NULL) {
+		if (hash_req->base.complete == NULL) {
+			dev_dbg(&sep->pdev->dev,
+				"release is null for hash!");
+		} else {
+			hash_req->base.complete(
+				&hash_req->base, error);
+		}
+	}
+}
+
+/**
+ * Post operation (after interrupt) for AES
+ */
+u32 aes_post_op(struct sep_device *sep)
+{
+	/* HERE */
+	int int_error;
+	u32 u32_error;
+	u32 msg_offset;
+	static u32 msg[10];
+	void *src_ptr;
+	void *dst_ptr;
+	dma_addr_t lli_in_table;
+	dma_addr_t lli_out_table;
+	u32 in_nbr_entries;
+	u32 out_nbr_entries;
+	u32 table_data_size;
+
+	struct sep_block_ctx *bctx =
+		ablkcipher_request_ctx(sep->current_cypher_req);
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(sep->current_cypher_req));
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "aes_post_op\n");
+
+	/* Is this the result of performing init (key to SEP */
+	if (sctx->key_sent == 0) {
+
+		/* Did SEP do it okay */
+		dev_dbg(&sctx->sep_used->pdev->dev,
+			"aes_post_op init response\n");
+		u32_error = sep_verify_op(sep, SEP_AES_INIT_OPCODE,
+			&msg_offset);
+		if (u32_error) {
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"aes init error %x\n", u32_error);
+			sep_crypto_release(sctx, u32_error);
+			return u32_error;
+			}
+
+		/* Read Context */
+		sep_read_context(sctx->sep_used, &msg_offset,
+			&bctx->aes_private_ctx,
+			sizeof(struct sep_aes_private_context));
+
+		sep_dump(sctx->sep_used, "ctx init aes", &bctx->aes_private_ctx,
+			20);
+
+		 /* We are done with init. Now send out the data */
+		sctx->key_sent = 1;
+
+		src_ptr = sg_virt(sctx->sep_used->src_sg);
+		dst_ptr = sg_virt(sctx->sep_used->dst_sg);
+
+		/* put together message to SEP */
+		/* Start with op code */
+		sep_make_header(sctx->sep_used, &msg_offset,
+			SEP_AES_BLOCK_OPCODE);
+
+		int_error = sep_prepare_input_output_dma_table(
+			sctx->sep_used, (unsigned long)src_ptr,
+			(unsigned long)dst_ptr,
+			sctx->sep_used->current_cypher_req->nbytes,
+			SEP_AES_BLOCK_SIZE_BYTES, &lli_in_table,
+			&lli_out_table, &in_nbr_entries,
+			&out_nbr_entries, &table_data_size,
+			true);
+
+		if (int_error) {
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"des response dma table prep failed\n");
+			sep_crypto_release(sctx, -ENOMEM);
+			return int_error;
+		}
+
+		msg[0] = (u32)lli_in_table;
+		msg[1] = (u32)in_nbr_entries;
+		msg[2] = (u32)lli_out_table;
+		msg[3] = (u32)out_nbr_entries;
+		msg[4] = (u32)table_data_size;
+		sep_write_msg(sctx->sep_used, (void *)msg,
+			sizeof(u32) * 5,
+			sizeof(u32) * 5,
+			&msg_offset, 0);
+
+		/* Send Context */
+		sep_write_context(sctx->sep_used, &msg_offset,
+			&bctx->aes_private_ctx,
+			sizeof(struct sep_aes_private_context));
+
+		sep_dump(sctx->sep_used, "ctx to block", &bctx->aes_private_ctx,
+			20);
+
+		/* Send message */
+		sep_end_msg(sctx->sep_used, msg_offset);
+
+	} else {
+		/**
+		 * This is the result of a block request
+		 * First, free the dma tables
+		 */
+		dev_dbg(&sctx->sep_used->pdev->dev,
+			"aes_post_op block response\n");
+		sep_free_dma_table_kernel_data();
+
+		sep_dump_sg(sctx->sep_used,
+			"aes block sg out", sctx->sep_used->dst_sg);
+
+		u32_error = sep_verify_op(sep,
+			SEP_AES_BLOCK_OPCODE, &msg_offset);
+
+		if (u32_error) {
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"aes block error %x\n", u32_error);
+			sep_crypto_release(sctx, u32_error);
+			return u32_error;
+			}
+
+		/* Skip the MAC Output */
+		msg_offset += (sizeof(u32) * 4);
+
+		/* Read Context */
+		sep_read_context(sctx->sep_used, &msg_offset,
+			&bctx->aes_private_ctx,
+			sizeof(struct sep_aes_private_context));
+
+		sep_dump(sctx->sep_used,
+			"ctx from aes block", &bctx->aes_private_ctx, 20);
+		dev_dbg(&sctx->sep_used->pdev->dev, "hash aes post op done\n");
+
+		/* Copy to correct sg if this block had oddball pages */
+		if (sctx->sep_used->dst_sg_hold)
+			sep_copy_sg(sctx->sep_used,
+				sctx->sep_used->dst_sg,
+				sctx->sep_used->current_cypher_req->dst,
+				sctx->sep_used->current_cypher_req->nbytes);
+
+		sep_crypto_release(sctx, 0);
+	}
+	return 0;
+}
+
+/**
+ * Post operation (after interrupt) for DES
+ */
+u32 des_post_op(struct sep_device *sep)
+{
+	/* HERE */
+	int int_error;
+	u32 u32_error;
+	u32 msg_offset;
+	static u32 msg[10];
+	static char small_buf[100];
+	void *src_ptr;
+	void *dst_ptr;
+	dma_addr_t lli_in_table;
+	dma_addr_t lli_out_table;
+	u32 in_nbr_entries;
+	u32 out_nbr_entries;
+	u32 table_data_size;
+	size_t copy_result;
+
+	struct sep_block_ctx *bctx =
+		ablkcipher_request_ctx(sep->current_cypher_req);
+
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(sep->current_cypher_req));
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "des_post_op\n");
+
+	/* Is this the result of performing init (key to SEP) */
+	if (sctx->key_sent == 0) {
+
+		/* Did SEP do it okay */
+		dev_dbg(&sctx->sep_used->pdev->dev,
+			"des_post_op init response\n");
+		u32_error = sep_verify_op(sep, SEP_DES_INIT_OPCODE,
+			&msg_offset);
+		if (u32_error) {
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"des init error %x\n", u32_error);
+			sep_crypto_release(sctx, u32_error);
+			return u32_error;
+			}
+
+		/* Read Context */
+		sep_read_context(sctx->sep_used, &msg_offset,
+			&bctx->des_private_ctx,
+			sizeof(struct sep_des_private_context));
+
+		sep_dump(sctx->sep_used, "ctx init des", &bctx->des_private_ctx,
+			20);
+
+		/* We are done with init. Now do the block */
+		sctx->key_sent = 1;
+
+		src_ptr = sg_virt(sctx->sep_used->src_sg);
+		dst_ptr = sg_virt(sctx->sep_used->dst_sg);
+
+		/* put together message to SEP */
+		/* Start with op code */
+		sep_make_header(sctx->sep_used, &msg_offset,
+			SEP_DES_BLOCK_OPCODE);
+
+		if (sctx->sep_used->current_cypher_req->nbytes
+			!= SEP_DES_BLOCK_SIZE) {
+			/* Build tables */
+
+			int_error = sep_prepare_input_output_dma_table(
+				sctx->sep_used, (unsigned long)src_ptr,
+				(unsigned long)dst_ptr,
+				sctx->sep_used->current_cypher_req->nbytes,
+				SEP_DES_BLOCK_SIZE, &lli_in_table,
+				&lli_out_table, &in_nbr_entries,
+				&out_nbr_entries, &table_data_size,
+				true);
+
+			if (int_error) {
+				dev_warn(&sctx->sep_used->pdev->dev,
+					"des response table prep failed\n");
+				sep_crypto_release(sctx, u32_error);
+				return u32_error;
+			}
+
+			msg[0] = (u32)lli_in_table;
+			msg[1] = (u32)in_nbr_entries;
+			msg[2] = (u32)lli_out_table;
+			msg[3] = (u32)out_nbr_entries;
+			msg[4] = (u32)table_data_size;
+			sep_write_msg(sctx->sep_used, (void *)msg,
+				sizeof(u32) * 5,
+				sizeof(u32) * 5,
+				&msg_offset, 0);
+		} else {
+			/* Put single block msg directly into msg */
+			dev_dbg(&sctx->sep_used->pdev->dev,
+				"writing out one block des\n");
+			copy_result = sg_copy_to_buffer(
+				sep->src_sg,
+				sep_sg_nents(sep->src_sg),
+				small_buf, SEP_DES_BLOCK_SIZE);
+
+			if (copy_result != SEP_DES_BLOCK_SIZE) {
+				dev_warn(&sctx->sep_used->pdev->dev,
+					"des block copy faild\n");
+				sep_crypto_release(sctx, -ENOMEM);
+				return -ENOMEM;
+			}
+
+			sep_write_msg(sctx->sep_used, small_buf,
+			SEP_DES_BLOCK_SIZE,
+			SEP_DES_BLOCK_SIZE * 2, &msg_offset, 1);
+
+			/* Put size into msg */
+
+			sep_write_msg(sctx->sep_used,
+				&sctx->sep_used->current_cypher_req->nbytes,
+				sizeof(u32), sizeof(u32), &msg_offset, 0);
+		}
+
+		/* Write Context */
+		dev_dbg(&sctx->sep_used->pdev->dev,
+			"msg_offset writing ctx %d\n", msg_offset);
+
+		sep_write_context(sctx->sep_used, &msg_offset,
+			&bctx->des_private_ctx,
+			sizeof(struct sep_des_private_context));
+
+		sep_dump(sctx->sep_used, "ctx into block des",
+			&bctx->des_private_ctx, 40);
+
+		/* Send message */
+		sep_end_msg(sctx->sep_used, msg_offset);
+
+	} else {
+		/**
+		 * This is the result of a block request
+		 * First, free the dma tables
+		 */
+		dev_dbg(&sctx->sep_used->pdev->dev,
+			"aes_post_op block response\n");
+		sep_free_dma_table_kernel_data();
+
+
+		u32_error = sep_verify_op(sep,
+			SEP_DES_BLOCK_OPCODE, &msg_offset);
+
+		if (u32_error) {
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"aes block error %x\n", u32_error);
+			sep_crypto_release(sctx, u32_error);
+			return u32_error;
+			}
+
+		/* Read in if only one block */
+		if (sctx->sep_used->current_cypher_req->nbytes
+			== SEP_DES_BLOCK_SIZE) {
+
+			sep_read_msg(sctx->sep_used, small_buf,
+			SEP_DES_BLOCK_SIZE,
+			SEP_DES_BLOCK_SIZE * 2, &msg_offset, 1);
+
+			dev_dbg(&sctx->sep_used->pdev->dev,
+				"reading in block des\n");
+
+			copy_result = sg_copy_from_buffer(
+				sep->dst_sg,
+				sep_sg_nents(sep->dst_sg),
+				small_buf, SEP_DES_BLOCK_SIZE);
+
+			if (copy_result != SEP_DES_BLOCK_SIZE) {
+				dev_warn(&sctx->sep_used->pdev->dev,
+					"des block copy faild\n");
+				sep_crypto_release(sctx, -ENOMEM);
+				return -ENOMEM;
+			}
+
+		}
+
+		sep_dump_sg(sctx->sep_used,
+			"des block sg out", sctx->sep_used->dst_sg);
+
+		/* Read Context */
+		sep_read_context(sctx->sep_used, &msg_offset,
+			&bctx->aes_private_ctx,
+			sizeof(struct sep_aes_private_context));
+
+		sep_dump(sctx->sep_used,
+			"ctx from des block", &bctx->aes_private_ctx, 20);
+
+		dev_dbg(&sctx->sep_used->pdev->dev, "des post op done\n");
+
+		/* Copy to correct sg if this block had oddball pages */
+		if (sctx->sep_used->dst_sg_hold) {
+			sep_copy_sg(sctx->sep_used,
+				sctx->sep_used->dst_sg,
+				sctx->sep_used->current_cypher_req->dst,
+				sctx->sep_used->current_cypher_req->nbytes);
+
+			sep_dump_sg(sctx->sep_used,
+				"des block sg after oddballout",
+				sctx->sep_used->current_cypher_req->dst);
+		}
+
+		sep_crypto_release(sctx, 0);
+	}
+	return 0;
+}
+
+u32 hash_init_post_op(struct sep_device *sep)
+{
+	u32 u32_error;
+	u32 msg_offset;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(sep->current_hash_req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(sep->current_hash_req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"hash init post op\n");
+
+	u32_error = sep_verify_op(sctx->sep_used, SEP_HASH_INIT_OPCODE,
+		&msg_offset);
+
+	if (u32_error) {
+		dev_warn(&sctx->sep_used->pdev->dev, "hash init error %x\n",
+			u32_error);
+		sep_crypto_release(sctx, u32_error);
+		return u32_error;
+		}
+
+	/* Read Context */
+	sep_read_context(sctx->sep_used, &msg_offset,
+		&ctx->hash_private_ctx,
+		sizeof(struct sep_hash_private_context));
+
+	/* Signal to crypto infrastructure and clear out */
+	dev_dbg(&sctx->sep_used->pdev->dev, "hash init post op done\n");
+	sep_crypto_release(sctx, 0);
+	return 0;
+}
+
+u32 hash_update_post_op(struct sep_device *sep)
+{
+	u32 u32_error;
+	u32 msg_offset;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(sep->current_hash_req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(sep->current_hash_req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"hash update post op\n");
+
+	/* First, close out the previous page */
+	sep_free_dma_table_kernel_data();
+
+	u32_error = sep_verify_op(sctx->sep_used, SEP_HASH_UPDATE_OPCODE,
+		&msg_offset);
+
+	if (u32_error) {
+		dev_warn(&sctx->sep_used->pdev->dev, "hash init error %x\n",
+			u32_error);
+		sep_crypto_release(sctx, u32_error);
+		return u32_error;
+		}
+
+	/* Read Context */
+	sep_read_context(sctx->sep_used, &msg_offset,
+		&ctx->hash_private_ctx,
+		sizeof(struct sep_hash_private_context));
+
+	sep_crypto_release(sctx, 0);
+	return 0;
+}
+
+u32 hash_final_post_op(struct sep_device *sep)
+{
+	int max_length;
+	u32 u32_error;
+	u32 msg_offset;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(sep->current_hash_req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(sep->current_hash_req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"hash final post op\n");
+
+	u32_error = sep_verify_op(sctx->sep_used, SEP_HASH_FINISH_OPCODE,
+		&msg_offset);
+
+	if (u32_error) {
+		dev_warn(&sctx->sep_used->pdev->dev, "hash finish error %x\n",
+			u32_error);
+		sep_crypto_release(sctx, u32_error);
+		return u32_error;
+		}
+
+	/* Grab the result */
+	if (sctx->sep_used->current_hash_req->result == NULL) {
+		/* Oops, null buffer; error out here */
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"hash finish null buffer\n");
+		sep_crypto_release(sctx, (u32)-ENOMEM);
+		return -ENOMEM;
+		}
+
+	max_length = (((SEP_HASH_RESULT_SIZE_WORDS * sizeof(u32)) + 3) /
+		sizeof(u32)) * sizeof(u32);
+
+	sep_read_msg(sctx->sep_used,
+		sctx->sep_used->current_hash_req->result,
+		ctx->digest_size_bytes, max_length,
+		&msg_offset, 0);
+
+	/* Signal to crypto infrastructure and clear out */
+	dev_dbg(&sctx->sep_used->pdev->dev, "hash finish post op done\n");
+	sep_crypto_release(sctx, 0);
+	return 0;
+}
+
+u32 hash_digest_post_op(struct sep_device *sep)
+{
+	int max_length;
+	u32 u32_error;
+	u32 msg_offset;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(sep->current_hash_req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(sep->current_hash_req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"hash digest post op\n");
+
+	u32_error = sep_verify_op(sctx->sep_used, SEP_HASH_SINGLE_OPCODE,
+		&msg_offset);
+
+	if (u32_error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"hash digest finish error %x\n", u32_error);
+
+		sep_crypto_release(sctx, u32_error);
+		return u32_error;
+		}
+
+	/* Grab the result */
+	if (sctx->sep_used->current_hash_req->result == NULL) {
+		/* Oops, null buffer; error out here */
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"hash digest finish null buffer\n");
+		sep_crypto_release(sctx, (u32)-ENOMEM);
+		return -ENOMEM;
+		}
+
+	max_length = (((SEP_HASH_RESULT_SIZE_WORDS * sizeof(u32)) + 3) /
+		sizeof(u32)) * sizeof(u32);
+
+	sep_read_msg(sctx->sep_used,
+		sctx->sep_used->current_hash_req->result,
+		ctx->digest_size_bytes, max_length,
+		&msg_offset, 0);
+
+	/* Signal to crypto infrastructure and clear out */
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"hash digest finish post op done\n");
+
+	sep_crypto_release(sctx, 0);
+	return 0;
+}
+
+/**
+ * The sep_finish function is the function that is schedule (via tasket)
+ * by the interrupt service routine when the SEP sends and interrupt
+ */
+static void sep_finish(unsigned long data)
+{
+	unsigned long flags;
+	struct sep_device *sep_dev;
+	int res;
+
+	res = 0;
+
+	if (data == 0) {
+		pr_debug("sep_finish called with null data\n");
+		return;
+	}
+
+	sep_dev = (struct sep_device *)data;
+	if (sep_dev == NULL) {
+		pr_debug("sep_finish; sep_dev is NULL\n");
+		return;
+	}
+
+	spin_lock_irqsave(&sep_dev->busy_lock, flags);
+	if (sep_dev->in_kernel == (u32)0) {
+		spin_unlock_irqrestore(&sep_dev->busy_lock, flags);
+		dev_warn(&sep_dev->pdev->dev,
+			"sep_finish; not in kernel operation\n");
+		return;
+	}
+	spin_unlock_irqrestore(&sep_dev->busy_lock, flags);
+
+	if (sep_driver_poll()) {
+		dev_warn(&sep_dev->pdev->dev,
+			"interrupt was for something else\n");
+		return;
+	}
+
+	dev_dbg(&sep_dev->pdev->dev,
+		"sep_finish: request %d\n", (int)sep_dev->current_request);
+
+	switch (sep_dev->current_request) {
+	case AES_CBC:
+	case AES_ECB:
+		res = aes_post_op(sep_dev);
+		break;
+	case DES_CBC:
+	case DES_ECB:
+		res = des_post_op(sep_dev);
+		break;
+	case SHA1:
+	case MD5:
+	case SHA224:
+	case SHA256:
+		switch (sep_dev->current_hash_stage) {
+		case HASH_INIT:
+			res = hash_init_post_op(sep_dev);
+			break;
+		case HASH_UPDATE:
+			res = hash_update_post_op(sep_dev);
+			break;
+		case HASH_FINISH:
+			res = hash_final_post_op(sep_dev);
+			break;
+		case HASH_DIGEST:
+			res = hash_digest_post_op(sep_dev);
+			break;
+		default:
+			dev_warn(&sep_dev->pdev->dev,
+			"invalid stage for hash finish\n");
+		}
+		break;
+	default:
+		dev_warn(&sep_dev->pdev->dev,
+		"invalid request for finish\n");
+	}
+
+	if (res) {
+		dev_warn(&sep_dev->pdev->dev,
+		"finish returned error %x\n", res);
+	}
+}
+
+static int sep_hash_cra_init(struct crypto_tfm *tfm)
+	{
+	struct sep_system_ctx *sctx = crypto_tfm_ctx(tfm);
+	const char *alg_name = crypto_tfm_alg_name(tfm);
+
+	sctx->sep_used = sep_dev;
+
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"sep_hash_cra_init name is %s\n", alg_name);
+
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+		sizeof(struct sep_hash_ctx));
+	return 0;
+	}
+
+static void sep_hash_cra_exit(struct crypto_tfm *tfm)
+{
+	struct sep_system_ctx *sctx = crypto_tfm_ctx(tfm);
+
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"sep_hash_cra_exit\n");
+	sctx->sep_used = NULL;
+}
+
+static int sep_hash_init(struct ahash_request *req)
+{
+	u32 msg_offset;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"sep_hash_init\n");
+	sctx->sep_used->current_hash_stage = HASH_INIT;
+	/* opcode and mode */
+	sep_make_header(sctx->sep_used, &msg_offset, SEP_HASH_INIT_OPCODE);
+	sep_write_msg(sctx->sep_used, &ctx->hash_opmode,
+		sizeof(u32), sizeof(u32), &msg_offset, 0);
+	sep_end_msg(sctx->sep_used, msg_offset);
+	return -EINPROGRESS;
+}
+
+static int sep_hash_update(struct ahash_request *req)
+{
+	int int_error;
+	u32 msg_offset;
+	u32 len;
+	struct sep_hash_internal_context *int_ctx;
+	dma_addr_t lli_table_ptr;
+	u32 num_entries;
+	u32 table_data_size;
+	u32 block_size;
+	u32 head_len;
+	u32 tail_len;
+	static u32 msg[10];
+	static char small_buf[100];
+	void *src_ptr;
+	ssize_t copy_result;
+	struct scatterlist *new_sg;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"sep_hash_update\n");
+	sctx->sep_used->current_hash_stage = HASH_UPDATE;
+	len = req->nbytes;
+
+	block_size = ctx->block_size_bytes;
+	tail_len = req->nbytes % block_size;
+	dev_dbg(&sctx->sep_used->pdev->dev, "length is %x\n", len);
+	dev_dbg(&sctx->sep_used->pdev->dev, "block_size is %x\n", block_size);
+	dev_dbg(&sctx->sep_used->pdev->dev, "tail len is %x\n", tail_len);
+
+	/* Compute header/tail sizes */
+	block_size = ctx->block_size_bytes;
+	int_ctx = (struct sep_hash_internal_context *)&ctx->
+		hash_private_ctx.internal_context;
+	block_size = int_ctx->op_mode_block_size;
+	head_len = (block_size - int_ctx->prev_update_bytes) % block_size;
+	tail_len = (req->nbytes - head_len) % block_size;
+
+	/* Make sure all pages are even block */
+	int_error = sep_oddball_pages(sctx->sep_used, req->src,
+		req->nbytes,
+		block_size, &new_sg, 1);
+
+	if (int_error < 0) {
+		sep_clear_out(sctx->sep_used);
+		return -ENOMEM;
+	} else if (int_error == 1) {
+		sctx->sep_used->src_sg = new_sg;
+		sctx->sep_used->src_sg_hold = new_sg;
+	} else {
+		sctx->sep_used->src_sg = req->src;
+		sctx->sep_used->src_sg_hold = NULL;
+	}
+
+	src_ptr = sg_virt(sctx->sep_used->src_sg);
+
+	if ((!req->nbytes) || (!ctx->sg)) {
+		/* null data */
+		src_ptr = NULL;
+	}
+
+	sep_dump_sg(sctx->sep_used, "hash block sg in", sctx->sep_used->src_sg);
+
+	/* SEP DMA tables */
+	int_error = sep_prepare_input_dma_table(
+		sctx->sep_used, (unsigned long)src_ptr,
+		req->nbytes - (head_len + tail_len),
+		block_size,
+		&lli_table_ptr,
+		&num_entries,
+		&table_data_size, 1);
+
+	if (int_error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"dma table error on hash block %x\n", int_error);
+		sep_clear_out(sctx->sep_used);
+		return -ENOMEM;
+	}
+
+	/* Construct message to SEP */
+	sep_make_header(sctx->sep_used, &msg_offset, SEP_HASH_UPDATE_OPCODE);
+
+	msg[0] = (u32)lli_table_ptr;
+	msg[1] = (u32)num_entries;
+	msg[2] = (u32)table_data_size;
+
+	sep_write_msg(sctx->sep_used, msg, sizeof(u32) * 3, sizeof(u32) * 3,
+		&msg_offset, 0);
+
+	/* Handle remainders */
+
+	/* Head */
+	sep_write_msg(sctx->sep_used, &head_len, sizeof(u32),
+		sizeof(u32), &msg_offset, 0);
+
+	if (head_len) {
+		copy_result = sg_copy_to_buffer(
+			req->src,
+			sep_sg_nents(sctx->sep_used->src_sg),
+			small_buf, head_len);
+
+		if (copy_result != head_len) {
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"sg head copy failure in hash block\n");
+			sep_clear_out(sctx->sep_used);
+			return -ENOMEM;
+		}
+
+		sep_write_msg(sctx->sep_used, small_buf, head_len,
+			sizeof(u32) * 32, &msg_offset, 1);
+	} else {
+		msg_offset += sizeof(u32) * 32;
+	}
+
+	/* Tail */
+	sep_write_msg(sctx->sep_used, &tail_len, sizeof(u32),
+		sizeof(u32), &msg_offset, 0);
+
+	if (tail_len) {
+		copy_result = sep_copy_offset_sg(
+			sctx->sep_used,
+			sctx->sep_used->src_sg,
+			req->nbytes - tail_len,
+			small_buf, tail_len);
+
+		if (copy_result != tail_len) {
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"sg tail copy failure in hash block\n");
+			sep_clear_out(sctx->sep_used);
+			return -ENOMEM;
+		}
+
+		sep_write_msg(sctx->sep_used, small_buf, tail_len,
+			sizeof(u32) * 32, &msg_offset, 1);
+	} else {
+		msg_offset += sizeof(u32) * 32;
+	}
+
+	/* Context */
+	sep_write_context(sctx->sep_used, &msg_offset, &ctx->hash_private_ctx,
+		sizeof(struct sep_hash_private_context));
+
+	sep_end_msg(sctx->sep_used, msg_offset);
+	return -EINPROGRESS;
+}
+
+static int sep_hash_final(struct ahash_request *req)
+{
+	u32 msg_offset;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"sep_hash_final\n");
+	sctx->sep_used->current_hash_stage = HASH_FINISH;
+
+	/* opcode and mode */
+	sep_make_header(sctx->sep_used, &msg_offset, SEP_HASH_FINISH_OPCODE);
+
+	/* Context */
+	sep_write_context(sctx->sep_used, &msg_offset, &ctx->hash_private_ctx,
+		sizeof(struct sep_hash_private_context));
+
+	sep_end_msg(sctx->sep_used, msg_offset);
+	return -EINPROGRESS;
+}
+
+static int sep_hash_digest(struct ahash_request *req)
+{
+	int int_error;
+	u32 msg_offset;
+	dma_addr_t lli_table_ptr;
+	u32 num_entries;
+	u32 table_data_size;
+	u32 block_size;
+	u32 msg[10];
+	size_t copy_result;
+	u32 tail_len;
+	static char small_buf[100];
+	struct scatterlist *new_sg;
+	void *src_ptr;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"sep_hash_digest\n");
+	sctx->sep_used->current_hash_stage = HASH_DIGEST;
+
+	block_size = ctx->block_size_bytes;
+	tail_len = req->nbytes % block_size;
+	dev_dbg(&sctx->sep_used->pdev->dev, "length is %x\n", req->nbytes);
+	dev_dbg(&sctx->sep_used->pdev->dev, "block_size is %x\n", block_size);
+	dev_dbg(&sctx->sep_used->pdev->dev, "tail len is %x\n", tail_len);
+
+	/* Make sure all pages are even block */
+	int_error = sep_oddball_pages(sctx->sep_used, req->src,
+		req->nbytes,
+		block_size, &new_sg, 1);
+
+	if (int_error < 0) {
+		sep_clear_out(sctx->sep_used);
+		return -ENOMEM;
+	} else if (int_error == 1) {
+		sctx->sep_used->src_sg = new_sg;
+		sctx->sep_used->src_sg_hold = new_sg;
+	} else {
+		sctx->sep_used->src_sg = req->src;
+		sctx->sep_used->src_sg_hold = NULL;
+	}
+
+	src_ptr = sg_virt(sctx->sep_used->src_sg);
+
+	if ((!req->nbytes) || (!ctx->sg)) {
+		/* null data */
+		src_ptr = NULL;
+	}
+
+	sep_dump_sg(sctx->sep_used, "hash digest sg in",
+		sctx->sep_used->src_sg);
+
+	/* SEP DMA tables */
+	int_error = sep_prepare_input_dma_table(
+		sctx->sep_used, (unsigned long)src_ptr,
+		req->nbytes - tail_len, block_size,
+		&lli_table_ptr,
+		&num_entries,
+		&table_data_size, 1);
+
+	if (int_error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"dma table error on hash block %x\n", int_error);
+		return -ENOMEM;
+	}
+
+	/* Construct message to SEP */
+	sep_make_header(sctx->sep_used, &msg_offset, SEP_HASH_SINGLE_OPCODE);
+	sep_write_msg(sctx->sep_used, &ctx->hash_opmode,
+		sizeof(u32), sizeof(u32), &msg_offset, 0);
+
+	msg[0] = (u32)lli_table_ptr;
+	msg[1] = (u32)num_entries;
+	msg[2] = (u32)table_data_size;
+
+	sep_write_msg(sctx->sep_used, msg, sizeof(u32) * 3, sizeof(u32) * 3,
+		&msg_offset, 0);
+
+	/* Tail */
+	sep_write_msg(sctx->sep_used, &tail_len, sizeof(u32),
+		sizeof(u32), &msg_offset, 0);
+
+	if (tail_len) {
+		copy_result = sep_copy_offset_sg(
+			sctx->sep_used,
+			sctx->sep_used->src_sg,
+			req->nbytes - tail_len,
+			small_buf, tail_len);
+
+		if (copy_result != tail_len) {
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"sg tail copy failure in hash block\n");
+			return -ENOMEM;
+		}
+
+		sep_write_msg(sctx->sep_used, small_buf, tail_len,
+			sizeof(u32) * 32, &msg_offset, 1);
+	} else {
+		msg_offset += sizeof(u32) * 32;
+	}
+
+	sep_end_msg(sctx->sep_used, msg_offset);
+	return -EINPROGRESS;
+}
+
+static int sep_sha1_init(struct ahash_request *req)
+{
+	int error;
+	unsigned long flags;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha1 init\n");
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = SHA1;
+	sctx->sep_used->current_hash_req = req;
+	sctx->sep_used->current_cypher_req = NULL;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	ctx->hash_opmode = SEP_HASH_SHA1;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+
+	error = sep_hash_init(req);
+
+	return error;
+}
+
+static int sep_sha1_update(struct ahash_request *req)
+{
+	int error;
+	unsigned long flags;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha1 update\n");
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = SHA1;
+	sctx->sep_used->current_hash_req = req;
+	sctx->sep_used->current_cypher_req = NULL;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	ctx->hash_opmode = SEP_HASH_SHA1;
+	ctx->digest_size_words = SEP_SHA1_DIGEST_SIZE_WORDS;
+	ctx->digest_size_bytes = SEP_SHA1_DIGEST_SIZE_BYTES;
+	ctx->block_size_words = SEP_HASH_BLOCK_SIZE_WORDS;
+	ctx->block_size_bytes = SEP_HASH_BLOCK_SIZE_BYTES;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+
+	error = sep_hash_update(req);
+
+	return error;
+}
+
+static int sep_sha1_final(struct ahash_request *req)
+{
+	int error;
+	unsigned long flags;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha1 final\n");
+
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = SHA1;
+	sctx->sep_used->current_hash_req = req;
+	sctx->sep_used->current_cypher_req = NULL;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	ctx->hash_opmode = SEP_HASH_SHA1;
+	ctx->digest_size_words = SEP_SHA1_DIGEST_SIZE_WORDS;
+	ctx->digest_size_bytes = SEP_SHA1_DIGEST_SIZE_BYTES;
+	ctx->block_size_words = SEP_HASH_BLOCK_SIZE_WORDS;
+	ctx->block_size_bytes = SEP_HASH_BLOCK_SIZE_BYTES;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+
+	error = sep_hash_final(req);
+
+	return error;
+}
+
+static int sep_sha1_digest(struct ahash_request *req)
+{
+	int error;
+	unsigned long flags;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha1 digest\n");
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = SHA1;
+	sctx->sep_used->current_hash_req = req;
+	sctx->sep_used->current_cypher_req = NULL;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	ctx->hash_opmode = SEP_HASH_SHA1;
+	ctx->digest_size_words = SEP_SHA1_DIGEST_SIZE_WORDS;
+	ctx->digest_size_bytes = SEP_SHA1_DIGEST_SIZE_BYTES;
+	ctx->block_size_words = SEP_HASH_BLOCK_SIZE_WORDS;
+	ctx->block_size_bytes = SEP_HASH_BLOCK_SIZE_BYTES;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+
+	error = sep_hash_digest(req);
+
+	return error;
+}
+
+static int sep_md5_init(struct ahash_request *req)
+{
+	int error;
+	unsigned long flags;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing md5 init\n");
+
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = MD5;
+	sctx->sep_used->current_hash_req = req;
+	sctx->sep_used->current_cypher_req = NULL;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	ctx->hash_opmode = SEP_HASH_MD5;
+	ctx->digest_size_words = SEP_MD5_DIGEST_SIZE_WORDS;
+	ctx->digest_size_bytes = SEP_MD5_DIGEST_SIZE_BYTES;
+	ctx->block_size_words = SEP_HASH_BLOCK_SIZE_WORDS;
+	ctx->block_size_bytes = SEP_HASH_BLOCK_SIZE_BYTES;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+
+	error = sep_hash_init(req);
+
+	return error;
+}
+
+static int sep_md5_update(struct ahash_request *req)
+{
+	int error;
+	unsigned long flags;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing md5 update\n");
+
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = MD5;
+	sctx->sep_used->current_hash_req = req;
+	sctx->sep_used->current_cypher_req = NULL;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	ctx->hash_opmode = SEP_HASH_MD5;
+	ctx->digest_size_words = SEP_MD5_DIGEST_SIZE_WORDS;
+	ctx->digest_size_bytes = SEP_MD5_DIGEST_SIZE_BYTES;
+	ctx->block_size_words = SEP_HASH_BLOCK_SIZE_WORDS;
+	ctx->block_size_bytes = SEP_HASH_BLOCK_SIZE_BYTES;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+
+	error = sep_hash_update(req);
+
+	return error;
+}
+
+static int sep_md5_final(struct ahash_request *req)
+{
+	int error;
+	unsigned long flags;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing md5 final\n");
+
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = MD5;
+	sctx->sep_used->current_hash_req = req;
+	sctx->sep_used->current_cypher_req = NULL;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	ctx->hash_opmode = SEP_HASH_MD5;
+	ctx->digest_size_words = SEP_MD5_DIGEST_SIZE_WORDS;
+	ctx->digest_size_bytes = SEP_MD5_DIGEST_SIZE_BYTES;
+	ctx->block_size_words = SEP_HASH_BLOCK_SIZE_WORDS;
+	ctx->block_size_bytes = SEP_HASH_BLOCK_SIZE_BYTES;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+
+	error = sep_hash_final(req);
+
+	return error;
+}
+
+static int sep_md5_digest(struct ahash_request *req)
+{
+	int error;
+	unsigned long flags;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing md5 digest\n");
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = MD5;
+	sctx->sep_used->current_hash_req = req;
+	sctx->sep_used->current_cypher_req = NULL;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	ctx->hash_opmode = SEP_HASH_MD5;
+	ctx->digest_size_words = SEP_MD5_DIGEST_SIZE_WORDS;
+	ctx->digest_size_bytes = SEP_MD5_DIGEST_SIZE_BYTES;
+	ctx->block_size_words = SEP_HASH_BLOCK_SIZE_WORDS;
+	ctx->block_size_bytes = SEP_HASH_BLOCK_SIZE_BYTES;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+
+	error = sep_hash_digest(req);
+
+	return error;
+}
+
+static int sep_sha224_init(struct ahash_request *req)
+{
+	int error;
+	unsigned long flags;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha224 init\n");
+
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = SHA224;
+	sctx->sep_used->current_hash_req = req;
+	sctx->sep_used->current_cypher_req = NULL;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	ctx->hash_opmode = SEP_HASH_SHA224;
+	ctx->digest_size_words = SEP_SHA224_DIGEST_SIZE_WORDS;
+	ctx->digest_size_bytes = SEP_SHA224_DIGEST_SIZE_BYTES;
+	ctx->block_size_words = SEP_SHA2_BLOCK_SIZE_WORDS;
+	ctx->block_size_bytes = SEP_SHA2_BLOCK_SIZE_BYTES;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+
+	error = sep_hash_init(req);
+
+	return error;
+}
+
+static int sep_sha224_update(struct ahash_request *req)
+{
+	int error;
+	unsigned long flags;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha224 update\n");
+
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = SHA224;
+	sctx->sep_used->current_hash_req = req;
+	sctx->sep_used->current_cypher_req = NULL;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	ctx->hash_opmode = SEP_HASH_SHA224;
+	ctx->digest_size_words = SEP_SHA224_DIGEST_SIZE_WORDS;
+	ctx->digest_size_bytes = SEP_SHA224_DIGEST_SIZE_BYTES;
+	ctx->block_size_words = SEP_SHA2_BLOCK_SIZE_WORDS;
+	ctx->block_size_bytes = SEP_SHA2_BLOCK_SIZE_BYTES;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+
+	error = sep_hash_update(req);
+
+	return error;
+}
+
+static int sep_sha224_final(struct ahash_request *req)
+{
+	int error;
+	unsigned long flags;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha224 final\n");
+
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = SHA224;
+	sctx->sep_used->current_hash_req = req;
+	sctx->sep_used->current_cypher_req = NULL;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	ctx->hash_opmode = SEP_HASH_SHA224;
+	ctx->digest_size_words = SEP_SHA224_DIGEST_SIZE_WORDS;
+	ctx->digest_size_bytes = SEP_SHA224_DIGEST_SIZE_BYTES;
+	ctx->block_size_words = SEP_SHA2_BLOCK_SIZE_WORDS;
+	ctx->block_size_bytes = SEP_SHA2_BLOCK_SIZE_BYTES;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+
+	error = sep_hash_final(req);
+
+	return error;
+}
+
+static int sep_sha224_digest(struct ahash_request *req)
+{
+	int error;
+	unsigned long flags;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing 224 digest\n");
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = SHA224;
+	sctx->sep_used->current_hash_req = req;
+	sctx->sep_used->current_cypher_req = NULL;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	ctx->hash_opmode = SEP_HASH_SHA224;
+	ctx->digest_size_words = SEP_SHA224_DIGEST_SIZE_WORDS;
+	ctx->digest_size_bytes = SEP_SHA224_DIGEST_SIZE_BYTES;
+	ctx->block_size_words = SEP_SHA2_BLOCK_SIZE_WORDS;
+	ctx->block_size_bytes = SEP_SHA2_BLOCK_SIZE_BYTES;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+
+	error = sep_hash_digest(req);
+
+	return error;
+}
+
+static int sep_sha256_init(struct ahash_request *req)
+{
+	int error;
+	unsigned long flags;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha256 init\n");
+
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = SHA256;
+	sctx->sep_used->current_hash_req = req;
+	sctx->sep_used->current_cypher_req = NULL;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	ctx->hash_opmode = SEP_HASH_SHA256;
+	ctx->digest_size_words = SEP_SHA256_DIGEST_SIZE_WORDS;
+	ctx->digest_size_bytes = SEP_SHA256_DIGEST_SIZE_BYTES;
+	ctx->block_size_words = SEP_SHA2_BLOCK_SIZE_WORDS;
+	ctx->block_size_bytes = SEP_SHA2_BLOCK_SIZE_BYTES;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+
+	error = sep_hash_init(req);
+
+	return error;
+}
+
+static int sep_sha256_update(struct ahash_request *req)
+{
+	int error;
+	unsigned long flags;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha256 update\n");
+
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = SHA256;
+	sctx->sep_used->current_hash_req = req;
+	sctx->sep_used->current_cypher_req = NULL;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	ctx->hash_opmode = SEP_HASH_SHA256;
+	ctx->digest_size_words = SEP_SHA256_DIGEST_SIZE_WORDS;
+	ctx->digest_size_bytes = SEP_SHA256_DIGEST_SIZE_BYTES;
+	ctx->block_size_words = SEP_SHA2_BLOCK_SIZE_WORDS;
+	ctx->block_size_bytes = SEP_SHA2_BLOCK_SIZE_BYTES;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+
+	error = sep_hash_update(req);
+
+	return error;
+}
+
+static int sep_sha256_final(struct ahash_request *req)
+{
+	int error;
+	unsigned long flags;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha256 final\n");
+
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = SHA256;
+	sctx->sep_used->current_hash_req = req;
+	sctx->sep_used->current_cypher_req = NULL;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	ctx->hash_opmode = SEP_HASH_SHA256;
+	ctx->digest_size_words = SEP_SHA256_DIGEST_SIZE_WORDS;
+	ctx->digest_size_bytes = SEP_SHA256_DIGEST_SIZE_BYTES;
+	ctx->block_size_words = SEP_SHA2_BLOCK_SIZE_WORDS;
+	ctx->block_size_bytes = SEP_SHA2_BLOCK_SIZE_BYTES;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+
+	error = sep_hash_final(req);
+
+	return error;
+}
+
+static int sep_sha256_digest(struct ahash_request *req)
+{
+	int error;
+	unsigned long flags;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha256 digest\n");
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = SHA256;
+	sctx->sep_used->current_hash_req = req;
+	sctx->sep_used->current_cypher_req = NULL;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	ctx->hash_opmode = SEP_HASH_SHA256;
+	ctx->digest_size_words = SEP_SHA256_DIGEST_SIZE_WORDS;
+	ctx->digest_size_bytes = SEP_SHA256_DIGEST_SIZE_BYTES;
+	ctx->block_size_words = SEP_SHA2_BLOCK_SIZE_WORDS;
+	ctx->block_size_bytes = SEP_SHA2_BLOCK_SIZE_BYTES;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+
+	error = sep_hash_digest(req);
+
+	return error;
+}
+
+static int sep_crypto_init(struct crypto_tfm *tfm)
+{
+	struct sep_system_ctx *sctx = crypto_tfm_ctx(tfm);
+	const char *alg_name = crypto_tfm_alg_name(tfm);
+
+	sctx->sep_used = sep_dev;
+
+	if (alg_name == NULL)
+		dev_dbg(&sctx->sep_used->pdev->dev, "alg is NULL\n");
+	else
+		dev_dbg(&sctx->sep_used->pdev->dev, "alg is %s\n", alg_name);
+
+	tfm->crt_ablkcipher.reqsize = sizeof(struct sep_block_ctx);
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep_crypto_init\n");
+	return 0;
+}
+
+static void sep_crypto_exit(struct crypto_tfm *tfm)
+{
+	struct sep_system_ctx *sctx = crypto_tfm_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep_crypto_exit\n");
+	sctx->sep_used = NULL;
+}
+
+static int sep_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+	unsigned int keylen)
+{
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(tfm);
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep aes setkey\n");
+
+	switch (keylen) {
+	case SEP_AES_KEY_128_SIZE:
+		sctx->aes_key_size = AES_128;
+		break;
+	case SEP_AES_KEY_192_SIZE:
+		sctx->aes_key_size = AES_192;
+		break;
+	case SEP_AES_KEY_256_SIZE:
+		sctx->aes_key_size = AES_256;
+		break;
+	case SEP_AES_KEY_512_SIZE:
+		sctx->aes_key_size = AES_512;
+		break;
+	default:
+		dev_warn(&sctx->sep_used->pdev->dev, "sep aes key size %x\n",
+			keylen);
+		return -EINVAL;
+	}
+
+	memset(&sctx->key.aes, 0, sizeof(u32) *
+		SEP_AES_MAX_KEY_SIZE_WORDS);
+	memcpy(&sctx->key.aes, key, keylen);
+	sctx->keylen = keylen;
+	/* Indicate to encrypt/decrypt function to send key to SEP */
+	sctx->key_sent = 0;
+	sctx->last_block = 0;
+
+	return 0;
+}
+
+static int sep_aes_block(struct ablkcipher_request *req)
+{
+	int int_error;
+	u32 msg_offset;
+	static u32 msg[10];
+	void *src_ptr;
+	void *dst_ptr;
+
+	dma_addr_t lli_in_table;
+	dma_addr_t lli_out_table;
+	u32 in_nbr_entries;
+	u32 out_nbr_entries;
+	u32 table_data_size;
+	u32 max_length;
+	struct scatterlist *new_sg;
+
+	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(req));
+
+	/* start the walk on scatterlists */
+	ablkcipher_walk_init(&bctx->walk, req->src, req->dst, req->nbytes);
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep aes block data size of %x\n",
+		req->nbytes);
+
+	int_error = ablkcipher_walk_phys(req, &bctx->walk);
+	if (int_error) {
+		dev_warn(&sctx->sep_used->pdev->dev, "walk phys error %x\n",
+			int_error);
+		sep_clear_out(sctx->sep_used);
+		return -ENOMEM;
+	}
+
+	/* Make sure all pages are even block */
+	int_error = sep_oddball_pages(sctx->sep_used, req->src,
+		req->nbytes, bctx->walk.blocksize, &new_sg, 1);
+
+	if (int_error < 0) {
+		sep_clear_out(sctx->sep_used);
+		return -ENOMEM;
+	} else if (int_error == 1) {
+		sctx->sep_used->src_sg = new_sg;
+		sctx->sep_used->src_sg_hold = new_sg;
+	} else {
+		sctx->sep_used->src_sg = req->src;
+		sctx->sep_used->src_sg_hold = NULL;
+	}
+
+	int_error = sep_oddball_pages(sctx->sep_used, req->dst,
+		req->nbytes, bctx->walk.blocksize, &new_sg, 0);
+
+	if (int_error < 0) {
+		sep_clear_out(sctx->sep_used);
+		return -ENOMEM;
+	} else if (int_error == 1) {
+		sctx->sep_used->dst_sg = new_sg;
+		sctx->sep_used->dst_sg_hold = new_sg;
+	} else {
+		sctx->sep_used->dst_sg = req->dst;
+		sctx->sep_used->dst_sg_hold = NULL;
+	}
+
+	sep_dump_sg(sctx->sep_used, "aes block sg in", sctx->sep_used->src_sg);
+
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"sep aes block walk nbytes is of %x\n", bctx->walk.nbytes);
+
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"sep aes block walk blocksize is %x\n", bctx->walk.blocksize);
+
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"sep aes block walk cypher len is %x\n",
+		cipher_len(bctx->walk.nbytes, bctx->walk.blocksize));
+
+	sep_dump(sctx->sep_used, "key", &sctx->key.aes, sctx->keylen);
+
+	if ((bctx->aes_opmode == SEP_AES_CBC) &&
+		(bctx->walk.iv == NULL)) {
+
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"aea block page null IV pointer for CBC\n");
+		sep_clear_out(sctx->sep_used);
+		return -EINVAL;
+	}
+
+	/* Do we need to perform init; ie; send key to sep? */
+	if (sctx->key_sent == 0) {
+
+		dev_dbg(&sctx->sep_used->pdev->dev, "sending key\n");
+		/* put together message to SEP */
+		/* Start with op code */
+		sep_make_header(sctx->sep_used, &msg_offset,
+			SEP_AES_INIT_OPCODE);
+
+		/* Max IV size */
+		max_length = ((SEP_AES_IV_SIZE_BYTES + 3) /  sizeof(u32)) *
+			sizeof(u32);
+
+		if (bctx->aes_opmode == SEP_AES_CBC) {
+			/* IV value */
+			sep_write_msg(sctx->sep_used, bctx->walk.iv,
+				SEP_AES_IV_SIZE_BYTES,
+				max_length,
+				&msg_offset, 1);
+			sep_dump(sctx->sep_used, "initial IV", bctx->walk.iv,
+				SEP_AES_IV_SIZE_BYTES);
+		} else {
+			/* Skip if ECB */
+			msg_offset += max_length;
+		}
+
+		/* Key */
+		sep_write_msg(sctx->sep_used, (void *)&sctx->key.aes,
+			sctx->keylen,
+			SEP_AES_MAX_KEY_SIZE_BYTES,
+			&msg_offset, 1);
+
+		/* Flags */
+		msg[0] = (u32)sctx->aes_key_size;
+		msg[1] = (u32)bctx->aes_encmode;
+		msg[2] = (u32)bctx->aes_opmode;
+		msg[3] = (u32)0; /* Secret key is not used */
+		sep_write_msg(sctx->sep_used, (void *)msg,
+			sizeof(u32) * 4,
+			sizeof(u32) * 4,
+			&msg_offset, 0);
+	} else {
+
+		src_ptr = sg_virt(sctx->sep_used->src_sg);
+		dst_ptr = sg_virt(sctx->sep_used->dst_sg);
+
+		if (!src_ptr || !dst_ptr ||
+			(sctx->sep_used->current_cypher_req->nbytes
+				% SEP_AES_BLOCK_SIZE_BYTES)) {
+
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"aea block page info invalid\n");
+			sep_clear_out(sctx->sep_used);
+			return -EINVAL;
+		}
+
+		if (partial_overlap(src_ptr, dst_ptr,
+				sctx->sep_used->current_cypher_req->nbytes)) {
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"partial overlap error in AES\n");
+			sep_clear_out(sctx->sep_used);
+			return -EINVAL;
+		}
+
+		/* put together message to SEP */
+		/* Start with op code */
+		sep_make_header(sctx->sep_used, &msg_offset,
+			SEP_AES_BLOCK_OPCODE);
+
+		int_error = sep_prepare_input_output_dma_table(
+			sctx->sep_used, (unsigned long)src_ptr,
+			(unsigned long)dst_ptr,
+			sctx->sep_used->current_cypher_req->nbytes,
+			SEP_AES_BLOCK_SIZE_BYTES, &lli_in_table,
+			&lli_out_table, &in_nbr_entries,
+			&out_nbr_entries, &table_data_size,
+			true);
+
+		if (int_error) {
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"des response dma table prep failed\n");
+			sep_clear_out(sctx->sep_used);
+			return -EINVAL;
+		}
+
+		msg[0] = (u32)lli_in_table;
+		msg[1] = (u32)in_nbr_entries;
+		msg[2] = (u32)lli_out_table;
+		msg[3] = (u32)out_nbr_entries;
+		msg[4] = (u32)table_data_size;
+		sep_write_msg(sctx->sep_used, (void *)msg,
+			sizeof(u32) * 5,
+			sizeof(u32) * 5,
+			&msg_offset, 0);
+
+		/* Send Context */
+		sep_write_context(sctx->sep_used, &msg_offset,
+			&bctx->aes_private_ctx,
+			sizeof(struct sep_aes_private_context));
+
+		sep_dump(sctx->sep_used, "ctx to block", &bctx->aes_private_ctx,
+			20);
+	}
+
+	/* Send message & return -EINPROGRESS to caller */
+	sep_end_msg(sctx->sep_used, msg_offset);
+	return -EINPROGRESS;
+}
+
+static int sep_aes_ecb_encrypt(struct ablkcipher_request *req)
+{
+	unsigned long flags;
+	int error;
+	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(req));
+
+	/* Claim the device */
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = AES_ECB;
+	sctx->sep_used->current_hash_req = NULL;
+	sctx->sep_used->current_cypher_req = req;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+	bctx->aes_encmode = SEP_AES_ENCRYPT;
+	bctx->aes_opmode = SEP_AES_ECB;
+
+	error = sep_aes_block(req);
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep aes ecb encrypt\n");
+	return error;
+}
+
+static int sep_aes_ecb_decrypt(struct ablkcipher_request *req)
+{
+	unsigned long flags;
+	int error;
+	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(req));
+
+	/* Claim the device */
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = AES_ECB;
+	sctx->sep_used->current_hash_req = NULL;
+	sctx->sep_used->current_cypher_req = req;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+	bctx->aes_encmode = SEP_AES_DECRYPT;
+	bctx->aes_opmode = SEP_AES_ECB;
+
+	error = sep_aes_block(req);
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep aes ecb decrypt\n");
+	return error;
+}
+
+static int sep_aes_cbc_encrypt(struct ablkcipher_request *req)
+{
+	unsigned long flags;
+	int error;
+	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(req));
+
+	/* Claim the device */
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = AES_CBC;
+	sctx->sep_used->current_hash_req = NULL;
+	sctx->sep_used->current_cypher_req = req;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+	bctx->aes_encmode = SEP_AES_ENCRYPT;
+	bctx->aes_opmode = SEP_AES_CBC;
+
+	error = sep_aes_block(req);
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep aes cbc encrypt\n");
+	return error;
+}
+
+static int sep_aes_cbc_decrypt(struct ablkcipher_request *req)
+{
+	unsigned long flags;
+	int error;
+	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(req));
+
+	/* Claim the device */
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = AES_CBC;
+	sctx->sep_used->current_hash_req = NULL;
+	sctx->sep_used->current_cypher_req = req;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+	bctx->aes_encmode = SEP_AES_DECRYPT;
+	bctx->aes_opmode = SEP_AES_CBC;
+
+	error = sep_aes_block(req);
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep aes cbc decrypt\n");
+	return error;
+}
+
+static int sep_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+	unsigned int keylen)
+{
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(tfm);
+	struct crypto_tfm *ctfm = crypto_ablkcipher_tfm(tfm);
+	u32 *flags  = &ctfm->crt_flags;
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep des setkey\n");
+
+	switch (keylen) {
+	case DES_KEY_SIZE:
+		sctx->des_nbr_keys = DES_KEY_1;
+		break;
+	case DES_KEY_SIZE * 2:
+		sctx->des_nbr_keys = DES_KEY_2;
+		break;
+	case DES_KEY_SIZE * 3:
+		sctx->des_nbr_keys = DES_KEY_3;
+		break;
+		dev_dbg(&sctx->sep_used->pdev->dev, "invalid key size %x\n",
+			keylen);
+		return -EINVAL;
+	}
+
+	if ((*flags & CRYPTO_TFM_REQ_WEAK_KEY) &&
+		(sep_weak_key(key, keylen))) {
+
+		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
+		dev_warn(&sctx->sep_used->pdev->dev, "weak key\n");
+		return -EINVAL;
+	}
+
+	memset(&sctx->key.des, 0, sizeof(struct sep_des_key));
+	memcpy(&sctx->key.des.key1, key, keylen);
+	sctx->keylen = keylen;
+	/* Indicate to encrypt/decrypt function to send key to SEP */
+	sctx->key_sent = 0;
+	sctx->last_block = 0;
+
+	return 0;
+}
+
+static int sep_des_block(struct ablkcipher_request *req)
+{
+	int int_error;
+	u32 msg_offset;
+	static u32 msg[10];
+	void *src_ptr;
+	void *dst_ptr;
+
+	dma_addr_t lli_in_table;
+	dma_addr_t lli_out_table;
+	u32 in_nbr_entries;
+	u32 out_nbr_entries;
+	u32 table_data_size;
+	struct scatterlist *new_sg;
+	static char small_buf[100];
+	size_t copy_result;
+
+	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(req));
+
+	/* start the walk on scatterlists */
+	ablkcipher_walk_init(&bctx->walk, req->src, req->dst, req->nbytes);
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep des block size of %x\n",
+		req->nbytes);
+
+	/* pull first page */
+	int_error = ablkcipher_walk_phys(req, &bctx->walk);
+	if (int_error) {
+		dev_warn(&sctx->sep_used->pdev->dev, "walk phys error %x\n",
+			int_error);
+		return int_error;
+	}
+
+	if (bctx->des_opmode == SEP_DES_CBC) {
+		if (!bctx->walk.iv) {
+			dev_warn(&sctx->sep_used->pdev->dev, "no iv found\n");
+			sep_clear_out(sctx->sep_used);
+			return -EINVAL;
+		}
+
+		memcpy(bctx->iv, bctx->walk.iv, SEP_DES_IV_SIZE_BYTES);
+		sep_dump(sctx->sep_used, "iv", bctx->iv, SEP_DES_IV_SIZE_BYTES);
+	}
+
+	/* Make sure all pages are even block */
+	int_error = sep_oddball_pages(sctx->sep_used, req->src,
+		req->nbytes, bctx->walk.blocksize, &new_sg, 1);
+
+	if (int_error < 0) {
+		sep_clear_out(sctx->sep_used);
+		return -ENOMEM;
+	} else if (int_error == 1) {
+		sctx->sep_used->src_sg = new_sg;
+		sctx->sep_used->src_sg_hold = new_sg;
+	} else {
+		sctx->sep_used->src_sg = req->src;
+		sctx->sep_used->src_sg_hold = NULL;
+	}
+
+	int_error = sep_oddball_pages(sctx->sep_used, req->dst,
+		req->nbytes, bctx->walk.blocksize, &new_sg, 0);
+
+	if (int_error < 0) {
+		sep_clear_out(sctx->sep_used);
+		return -ENOMEM;
+	} else if (int_error == 1) {
+		sctx->sep_used->dst_sg = new_sg;
+		sctx->sep_used->dst_sg_hold = new_sg;
+	} else {
+		sctx->sep_used->dst_sg = req->dst;
+		sctx->sep_used->dst_sg_hold = NULL;
+	}
+
+	sep_dump_sg(sctx->sep_used, "des block sg in", sctx->sep_used->src_sg);
+
+	sep_dump(sctx->sep_used, "key", &sctx->key.des.key1, 8 * 4);
+
+	/* Do we need to perform init; ie; send key to sep? */
+	if (sctx->key_sent == 0) {
+
+		dev_dbg(&sctx->sep_used->pdev->dev, "sending key\n");
+		/* put together message to SEP */
+		/* Start with op code */
+		sep_make_header(sctx->sep_used, &msg_offset,
+			SEP_DES_INIT_OPCODE);
+
+		if (bctx->des_opmode == SEP_DES_CBC) {
+			/* IV value */
+			sep_write_msg(sctx->sep_used, bctx->iv,
+				SEP_DES_IV_SIZE_BYTES, sizeof(u32) * 4,
+				&msg_offset, 1);
+		} else {
+			/* Skip if ECB */
+			msg_offset += 4 * sizeof(u32);
+		}
+
+		/* Key */
+		sep_write_msg(sctx->sep_used, (void *)&sctx->key.des.key1,
+			sizeof(u32) * 8,
+			sizeof(u32) * 8,
+			&msg_offset, 1);
+
+		/* Flags */
+		msg[0] = (u32)sctx->des_nbr_keys;
+		msg[1] = (u32)bctx->des_encmode;
+		msg[2] = (u32)bctx->des_opmode;
+		sep_write_msg(sctx->sep_used, (void *)msg,
+			sizeof(u32) * 3,
+			sizeof(u32) * 3,
+			&msg_offset, 0);
+	} else {
+
+		/* Key is done; send off data */
+		dev_dbg(&sctx->sep_used->pdev->dev, "sending data\n");
+
+		src_ptr = sg_virt(sctx->sep_used->src_sg);
+		dst_ptr = sg_virt(sctx->sep_used->dst_sg);
+
+		if (!src_ptr || !dst_ptr ||
+			(sctx->sep_used->current_cypher_req->nbytes
+				% SEP_DES_BLOCK_SIZE)) {
+
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"des block page info invalid\n");
+			sep_clear_out(sctx->sep_used);
+			return -EINVAL;
+		}
+
+		if (partial_overlap(src_ptr, dst_ptr,
+				sctx->sep_used->current_cypher_req->nbytes)) {
+			sep_clear_out(sctx->sep_used);
+			return -EINVAL;
+		}
+
+		/* put together message to SEP */
+		/* Start with op code */
+		sep_make_header(sctx->sep_used, &msg_offset,
+			SEP_DES_BLOCK_OPCODE);
+
+		if (sctx->sep_used->current_cypher_req->nbytes
+			!= SEP_DES_BLOCK_SIZE) {
+			/* Build tables */
+
+			int_error = sep_prepare_input_output_dma_table(
+				sctx->sep_used, (unsigned long)src_ptr,
+				(unsigned long)dst_ptr,
+				sctx->sep_used->current_cypher_req->nbytes,
+				SEP_DES_BLOCK_SIZE, &lli_in_table,
+				&lli_out_table, &in_nbr_entries,
+				&out_nbr_entries, &table_data_size,
+				true);
+
+			if (int_error) {
+				dev_warn(&sctx->sep_used->pdev->dev,
+					"des response table prep failed\n");
+				sep_clear_out(sctx->sep_used);
+				return -ENOMEM;
+			}
+
+			msg[0] = (u32)lli_in_table;
+			msg[1] = (u32)in_nbr_entries;
+			msg[2] = (u32)lli_out_table;
+			msg[3] = (u32)out_nbr_entries;
+			msg[4] = (u32)table_data_size;
+			sep_write_msg(sctx->sep_used, (void *)msg,
+				sizeof(u32) * 5,
+				sizeof(u32) * 5,
+				&msg_offset, 0);
+		} else {
+			/* Put single block msg directly into msg */
+			dev_dbg(&sctx->sep_used->pdev->dev,
+				"writing out one block des\n");
+			copy_result = sg_copy_to_buffer(
+				sctx->sep_used->src_sg,
+				sep_sg_nents(sctx->sep_used->src_sg),
+				small_buf, SEP_DES_BLOCK_SIZE);
+
+			if (copy_result != SEP_DES_BLOCK_SIZE) {
+				dev_warn(&sctx->sep_used->pdev->dev,
+					"des block copy faild\n");
+				sep_crypto_release(sctx, -ENOMEM);
+				return -ENOMEM;
+			}
+
+			sep_write_msg(sctx->sep_used, small_buf,
+			SEP_DES_BLOCK_SIZE,
+			SEP_DES_BLOCK_SIZE * 2, &msg_offset, 1);
+
+			/* Put size into msg */
+
+			sep_write_msg(sctx->sep_used,
+				&sctx->sep_used->current_cypher_req->nbytes,
+				sizeof(u32), sizeof(u32), &msg_offset, 0);
+		}
+
+		/* Write Context */
+		dev_dbg(&sctx->sep_used->pdev->dev,
+			"msg_offset writing ctx %d\n", msg_offset);
+
+		sep_write_context(sctx->sep_used, &msg_offset,
+			&bctx->des_private_ctx,
+			sizeof(struct sep_des_private_context));
+
+		sep_dump(sctx->sep_used, "ctx into block des",
+			&bctx->des_private_ctx, 40);
+
+	}
+
+	/* Send message & return -EINPROGRESS to caller */
+	sep_end_msg(sctx->sep_used, msg_offset);
+	return -EINPROGRESS;
+}
+
+static int sep_des_ebc_encrypt(struct ablkcipher_request *req)
+{
+	unsigned long flags;
+	int error;
+	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(req));
+
+	/* Claim the device */
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = DES_ECB;
+	sctx->sep_used->current_hash_req = NULL;
+	sctx->sep_used->current_cypher_req = req;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+	bctx->des_encmode = SEP_DES_ENCRYPT;
+	bctx->des_opmode = SEP_DES_ECB;
+
+	error = sep_des_block(req);
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep des ecb encrypt\n");
+	return error;
+}
+
+static int sep_des_ebc_decrypt(struct ablkcipher_request *req)
+{
+	unsigned long flags;
+	int error;
+	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(req));
+
+	/* Claim the device */
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = DES_ECB;
+	sctx->sep_used->current_hash_req = NULL;
+	sctx->sep_used->current_cypher_req = req;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+	bctx->des_encmode = SEP_DES_DECRYPT;
+	bctx->des_opmode = SEP_DES_ECB;
+
+	error = sep_des_block(req);
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep des ecb decrypt\n");
+	return error;
+}
+
+static int sep_des_cbc_encrypt(struct ablkcipher_request *req)
+{
+	unsigned long flags;
+	int error;
+	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(req));
+
+	/* Claim the device */
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = DES_CBC;
+	sctx->sep_used->current_hash_req = NULL;
+	sctx->sep_used->current_cypher_req = req;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+	bctx->des_encmode = SEP_DES_ENCRYPT;
+	bctx->des_opmode = SEP_DES_CBC;
+
+	error = sep_des_block(req);
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep des cbc encrypt\n");
+	return error;
+}
+
+static int sep_des_cbc_decrypt(struct ablkcipher_request *req)
+{
+	unsigned long flags;
+	int error;
+	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(req));
+
+	/* Claim the device */
+	spin_lock_irqsave(&sctx->sep_used->busy_lock, flags);
+	if (sep_lock()) {
+		spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+		return -EBUSY;
+	}
+	sctx->sep_used->in_kernel = (u32)1;
+	sctx->sep_used->current_request = DES_CBC;
+	sctx->sep_used->current_hash_req = NULL;
+	sctx->sep_used->current_cypher_req = req;
+	sctx->sep_used->current_msg_ptr = NULL;
+	sctx->sep_used->out_msg_size = 0;
+	sctx->sep_used->in_msg_size = 0;
+	spin_unlock_irqrestore(&sctx->sep_used->busy_lock, flags);
+	bctx->des_encmode = SEP_DES_DECRYPT;
+	bctx->des_opmode = SEP_DES_CBC;
+
+	error = sep_des_block(req);
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep des cbc decrypt\n");
+	return error;
+}
+
+static struct ahash_alg hash_algs[] = {
+{
+	.init		= sep_sha1_init,
+	.update		= sep_sha1_update,
+	.final		= sep_sha1_final,
+	.digest		= sep_sha1_digest,
+	.halg.digestsize	= SHA1_DIGEST_SIZE,
+	.halg.base	= {
+		.cra_name		= "sha1",
+		.cra_driver_name	= "sha1-sep",
+		.cra_priority		= 100,
+		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
+						CRYPTO_ALG_ASYNC,
+		.cra_blocksize		= SHA1_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct sep_system_ctx),
+		.cra_alignmask		= 0,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= sep_hash_cra_init,
+		.cra_exit		= sep_hash_cra_exit,
+	}
+},
+{
+	.digest		= sep_md5_digest,
+	.init		= sep_md5_init,
+	.update		= sep_md5_update,
+	.final		= sep_md5_final,
+	.digest		= sep_md5_digest,
+	.halg.digestsize	= MD5_DIGEST_SIZE,
+	.halg.base	= {
+		.cra_name		= "md5",
+		.cra_driver_name	= "md5-sep",
+		.cra_priority		= 100,
+		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
+						CRYPTO_ALG_ASYNC,
+		.cra_blocksize		= SHA1_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct sep_system_ctx),
+		.cra_alignmask		= 0,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= sep_hash_cra_init,
+		.cra_exit		= sep_hash_cra_exit,
+	}
+},
+{
+	.init		= sep_sha224_init,
+	.update		= sep_sha224_update,
+	.final		= sep_sha224_final,
+	.digest		= sep_sha224_digest,
+	.halg.digestsize	= SHA224_DIGEST_SIZE,
+	.halg.base	= {
+		.cra_name		= "sha224",
+		.cra_driver_name	= "sha224-sep",
+		.cra_priority		= 100,
+		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
+						CRYPTO_ALG_ASYNC,
+		.cra_blocksize		= SHA224_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct sep_system_ctx),
+		.cra_alignmask		= 0,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= sep_hash_cra_init,
+		.cra_exit		= sep_hash_cra_exit,
+	}
+},
+{
+	.init		= sep_sha256_init,
+	.update		= sep_sha256_update,
+	.final		= sep_sha256_final,
+	.digest		= sep_sha256_digest,
+	.halg.digestsize	= SHA256_DIGEST_SIZE,
+	.halg.base	= {
+		.cra_name		= "sha256",
+		.cra_driver_name	= "sha256-sep",
+		.cra_priority		= 100,
+		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
+						CRYPTO_ALG_ASYNC,
+		.cra_blocksize		= SHA256_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct sep_system_ctx),
+		.cra_alignmask		= 0,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= sep_hash_cra_init,
+		.cra_exit		= sep_hash_cra_exit,
+	}
+}
+};
+
+static struct crypto_alg crypto_algs[] = {
+{
+	.cra_name		= "ecb(aes)",
+	.cra_driver_name	= "ecb-aes-sep",
+	.cra_priority		= 100,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct sep_system_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= sep_crypto_init,
+	.cra_exit		= sep_crypto_exit,
+	.cra_u.ablkcipher = {
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.setkey		= sep_aes_setkey,
+		.encrypt	= sep_aes_ecb_encrypt,
+		.decrypt	= sep_aes_ecb_decrypt,
+	}
+},
+{
+	.cra_name		= "cbc(aes)",
+	.cra_driver_name	= "cbc-aes-sep",
+	.cra_priority		= 100,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct sep_system_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= sep_crypto_init,
+	.cra_exit		= sep_crypto_exit,
+	.cra_u.ablkcipher = {
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.setkey		= sep_aes_setkey,
+		.encrypt	= sep_aes_cbc_encrypt,
+		.decrypt	= sep_aes_cbc_decrypt,
+	}
+},
+{
+	.cra_name		= "ebc(des)",
+	.cra_driver_name	= "ebc-des-sep",
+	.cra_priority		= 100,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= DES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct sep_system_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= sep_crypto_init,
+	.cra_exit		= sep_crypto_exit,
+	.cra_u.ablkcipher = {
+		.min_keysize	= DES_KEY_SIZE,
+		.max_keysize	= DES_KEY_SIZE,
+		.setkey		= sep_des_setkey,
+		.encrypt	= sep_des_ebc_encrypt,
+		.decrypt	= sep_des_ebc_decrypt,
+	}
+},
+{
+	.cra_name		= "cbc(des)",
+	.cra_driver_name	= "cbc-des-sep",
+	.cra_priority		= 100,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= DES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct sep_system_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= sep_crypto_init,
+	.cra_exit		= sep_crypto_exit,
+	.cra_u.ablkcipher = {
+		.min_keysize	= DES_KEY_SIZE,
+		.max_keysize	= DES_KEY_SIZE,
+		.setkey		= sep_des_setkey,
+		.encrypt	= sep_des_cbc_encrypt,
+		.decrypt	= sep_des_cbc_decrypt,
+	}
+},
+{
+	.cra_name		= "ebc(des3-ede)",
+	.cra_driver_name	= "ebc-des3-ede-sep",
+	.cra_priority		= 100,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= DES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct sep_system_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= sep_crypto_init,
+	.cra_exit		= sep_crypto_exit,
+	.cra_u.ablkcipher = {
+		.min_keysize	= DES3_EDE_KEY_SIZE,
+		.max_keysize	= DES3_EDE_KEY_SIZE,
+		.setkey		= sep_des_setkey,
+		.encrypt	= sep_des_ebc_encrypt,
+		.decrypt	= sep_des_ebc_decrypt,
+	}
+},
+{
+	.cra_name		= "cbc(des3-ede)",
+	.cra_driver_name	= "cbc-des3--ede-sep",
+	.cra_priority		= 100,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= DES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct sep_system_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= sep_crypto_init,
+	.cra_exit		= sep_crypto_exit,
+	.cra_u.ablkcipher = {
+		.min_keysize	= DES3_EDE_KEY_SIZE,
+		.max_keysize	= DES3_EDE_KEY_SIZE,
+		.setkey		= sep_des_setkey,
+		.encrypt	= sep_des_cbc_encrypt,
+		.decrypt	= sep_des_cbc_decrypt,
+	}
+}
+};
+int sep_crypto_setup(void)
+{
+	int err, i, j, k;
+	tasklet_init(&sep_dev->finish_tasklet, sep_finish,
+		(unsigned long)sep_dev);
+
+	i = 0;
+	j = 0;
+
+	spin_lock_init(&sep_dev->busy_lock);
+
+	err = 0;
+
+	/* Commented out because there are still some SEP errors */
+	for (i = 0; i < ARRAY_SIZE(hash_algs); i++) {
+		err = crypto_register_ahash(&hash_algs[i]);
+		if (err)
+			goto err_algs;
+	}
+
+	err = 0;
+	for (j = 0; j < ARRAY_SIZE(crypto_algs); j++) {
+		err = crypto_register_alg(&crypto_algs[j]);
+		if (err)
+			goto err_algs;
+	}
+
+
+	return err;
+
+err_algs:
+	for (k = 0; k < i; k++)
+		crypto_unregister_ahash(&hash_algs[k]);
+	return err;
+	for (k = 0; k < j; k++)
+		crypto_unregister_alg(&crypto_algs[k]);
+	return err;
+
+}
+
+void sep_crypto_takedown(void)
+{
+
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(hash_algs); i++)
+		crypto_unregister_ahash(&hash_algs[i]);
+	for (i = 0; i < ARRAY_SIZE(crypto_algs); i++)
+		crypto_unregister_alg(&crypto_algs[i]);
+
+	tasklet_kill(&sep_dev->finish_tasklet);
+}
diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index 988d7cb..98c2f38 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -3688,6 +3688,12 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 		if (error)
 			goto end_function_free_irq;
 	}
+
+	/* register with kernel crypto */
+	error = sep_crypto_setup();
+	if (error)
+		dev_warn(&sep->pdev->dev, "error registering with crypto\n");
+
 	/* Finally magic up the device nodes */
 	/* Register driver with the fs */
 	error = sep_register_driver_with_fs(sep);
@@ -3727,6 +3733,9 @@ static void sep_remove(struct pci_dev *pdev)
 {
 	struct sep_device *sep = sep_dev;
 
+	/* Remove from kernel crypto */
+	sep_crypto_takedown();
+
 	/* Unregister from fs */
 	misc_deregister(&sep->miscdev_sep);
 	misc_deregister(&sep->miscdev_singleton);
-- 
1.6.3.3

