Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab1L1RZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 12:25:33 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49136 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab1L1RZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 12:25:27 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] sep: SEP update
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 28 Dec 2011 17:37:59 +0000
Message-ID: <20111228173748.3323.89307.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Allyn <mark.a.allyn@intel.com>

This is basically a rewrite so there isn't a nice easy to present way of
providing this as a patch series. This patch is a pull of Mark's new driver into
the upstream staging area. On top of that are a series of patches by
Andy Shevchenko to make it build on the current tree, fix a few things and
even get it passed sparse.

The new driver supports the kernel crypto layer, passes the coding style checks,
passes human taste checks and has proper kernel-doc formatted comments.

I've then folded back in some later fixes it was missing that got applied to
to the kernel tree.

This should be ready for more serious review with a view to migration from
the staging tree shortly.

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
[Forward port and some bug fixing]
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
[Fold and tweaks for 3.2]
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/sep/Kconfig              |    3 
 drivers/staging/sep/Makefile             |    5 
 drivers/staging/sep/TODO                 |    5 
 drivers/staging/sep/sep_crypto.c         | 3768 ++++++++++++++++++++++++++
 drivers/staging/sep/sep_crypto.h         |  348 ++
 drivers/staging/sep/sep_dev.h            |   99 -
 drivers/staging/sep/sep_driver.c         | 2932 ---------------------
 drivers/staging/sep/sep_driver_api.h     |  280 ++
 drivers/staging/sep/sep_driver_config.h  |   79 -
 drivers/staging/sep/sep_driver_hw_defs.h |  182 -
 drivers/staging/sep/sep_main.c           | 4286 ++++++++++++++++++++++++++++++
 drivers/staging/sep/sep_trace_events.h   |  188 +
 12 files changed, 8960 insertions(+), 3215 deletions(-)
 create mode 100644 drivers/staging/sep/sep_crypto.c
 create mode 100644 drivers/staging/sep/sep_crypto.h
 delete mode 100644 drivers/staging/sep/sep_driver.c
 create mode 100644 drivers/staging/sep/sep_main.c
 create mode 100644 drivers/staging/sep/sep_trace_events.h


diff --git a/drivers/staging/sep/Kconfig b/drivers/staging/sep/Kconfig
index 92bf166..185b676 100644
--- a/drivers/staging/sep/Kconfig
+++ b/drivers/staging/sep/Kconfig
@@ -3,7 +3,8 @@ config DX_SEP
 	depends on PCI
 	help
 	  Discretix SEP driver; used for the security processor subsystem
-	  on bard the Intel Mobile Internet Device.
+	  on board the Intel Mobile Internet Device and adds SEP availability
+	  to the kernel crypto infrastructure
 
 	  The driver's name is sep_driver.
 
diff --git a/drivers/staging/sep/Makefile b/drivers/staging/sep/Makefile
index 628d5f9..e48a795 100644
--- a/drivers/staging/sep/Makefile
+++ b/drivers/staging/sep/Makefile
@@ -1,2 +1,3 @@
-obj-$(CONFIG_DX_SEP) := sep_driver.o
-
+ccflags-y += -I$(srctree)/$(src)
+obj-$(CONFIG_DX_SEP) += sep_driver.o
+sep_driver-objs := sep_crypto.o sep_main.o
diff --git a/drivers/staging/sep/TODO b/drivers/staging/sep/TODO
index 8f3b878..3524d0c 100644
--- a/drivers/staging/sep/TODO
+++ b/drivers/staging/sep/TODO
@@ -1,4 +1,3 @@
 Todo's so far (from Alan Cox)
-- Check whether it can be plugged into any of the kernel crypto API
-  interfaces - Crypto API 'glue' is still not ready to submit
-- Clean up un-needed debug prints - Started to work on this
+- Clean up unused ioctls
+- Clean up unused fields in ioctl structures
diff --git a/drivers/staging/sep/sep_crypto.c b/drivers/staging/sep/sep_crypto.c
new file mode 100644
index 0000000..a6b0f83
--- /dev/null
+++ b/drivers/staging/sep/sep_crypto.c
@@ -0,0 +1,3768 @@
+/*
+ *
+ *  sep_crypto.c - Crypto interface structures
+ *
+ *  Copyright(c) 2009-2011 Intel Corporation. All rights reserved.
+ *  Contributions(c) 2009-2010 Discretix. All rights reserved.
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
+
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
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+#include <linux/err.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/irq.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/list.h>
+#include <linux/dma-mapping.h>
+#include <linux/delay.h>
+#include <linux/jiffies.h>
+#include <linux/workqueue.h>
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
+/* Globals for queuing */
+static spinlock_t queue_lock;
+static struct crypto_queue sep_queue;
+
+/* Declare of dequeuer */
+static void sep_dequeuer(void *data);
+
+/* TESTING */
+/**
+ * crypto_sep_dump_message - dump the message that is pending
+ * @sep: SEP device
+ * This will only print dump if DEBUG is set; it does
+ * follow kernel debug print enabling
+ */
+static void crypto_sep_dump_message(struct sep_system_ctx *sctx)
+{
+#if 0
+	u32 *p;
+	u32 *i;
+	int count;
+
+	p = sctx->sep_used->shared_addr;
+	i = (u32 *)sctx->msg;
+	for (count = 0; count < 40 * 4; count += 4)
+		dev_dbg(&sctx->sep_used->pdev->dev,
+			"[PID%d] Word %d of the message is %x (local)%x\n",
+				current->pid, count/4, *p++, *i++);
+#endif
+}
+
+/**
+ *	sep_do_callback
+ *	@work: pointer to work_struct
+ *	This is what is called by the queue; it is generic so that it
+ *	can be used by any type of operation as each different callback
+ *	function can use the data parameter in its own way
+ */
+static void sep_do_callback(struct work_struct *work)
+{
+	struct sep_work_struct *sep_work = container_of(work,
+		struct sep_work_struct, work);
+	if (sep_work != NULL) {
+		(sep_work->callback)(sep_work->data);
+		kfree(sep_work);
+	} else {
+		pr_debug("sep crypto: do callback - NULL container\n");
+	}
+}
+
+/**
+ *	sep_submit_work
+ *	@work_queue: pointer to struct_workqueue
+ *	@funct: pointer to function to execute
+ *	@data: pointer to data; function will know
+ *		how to use it
+ *	This is a generic API to submit something to
+ *	the queue. The callback function will depend
+ *	on what operation is to be done
+ */
+static int sep_submit_work(struct workqueue_struct *work_queue,
+	void(*funct)(void *),
+	void *data)
+{
+	struct sep_work_struct *sep_work;
+	int result;
+
+	sep_work = kmalloc(sizeof(struct sep_work_struct), GFP_ATOMIC);
+
+	if (sep_work == NULL) {
+		pr_debug("sep crypto: cant allocate work structure\n");
+		return -ENOMEM;
+	}
+
+	sep_work->callback = funct;
+	sep_work->data = data;
+	INIT_WORK(&sep_work->work, sep_do_callback);
+	result = queue_work(work_queue, &sep_work->work);
+	if (!result) {
+		pr_debug("sep_crypto: queue_work failed\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/**
+ *	sep_alloc_sg_buf -
+ *	@sep: pointer to struct sep_device
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
+		sg_set_buf(sg_temp, buf, real_page_size);
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
+static void sep_dump(struct sep_device *sep, char *stg, void *start, int len)
+{
+#if 0
+	int ct1;
+	u8 *ptt;
+
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
+#endif
+}
+
+/* Debug - prints only if DEBUG is defined; follows kernel debug model */
+static void sep_dump_sg(struct sep_device *sep, char *stg,
+			struct scatterlist *sg)
+{
+#if 0
+	int ct1, ct2;
+	u8 *ptt;
+
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
+#endif
+}
+
+/**
+ * RFC2451: Weak key check
+ * Returns: 1 (weak), 0 (not weak)
+ */
+static int sep_weak_key(const u8 *key, unsigned int keylen)
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
+ *	@sctx: pointer to struct sep_system_ctx
+ *	@returns: offset to place for the next word in the message
+ *	Set up pointer in message pool for new message
+ */
+static u32 sep_start_msg(struct sep_system_ctx *sctx)
+{
+	u32 *word_ptr;
+	sctx->msg_len_words = 2;
+	sctx->msgptr = sctx->msg;
+	memset(sctx->msg, 0, SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES);
+	sctx->msgptr += sizeof(u32) * 2;
+	word_ptr = (u32 *)sctx->msgptr;
+	*word_ptr = SEP_START_MSG_TOKEN;
+	return sizeof(u32) * 2;
+}
+
+/**
+ *	sep_end_msg -
+ *	@sctx: pointer to struct sep_system_ctx
+ *	@messages_offset: current message offset
+ *	Returns: 0 for success; <0 otherwise
+ *	End message; set length and CRC; and
+ *	send interrupt to the SEP
+ */
+static void sep_end_msg(struct sep_system_ctx *sctx, u32 msg_offset)
+{
+	u32 *word_ptr;
+	/* Msg size goes into msg after token */
+	sctx->msg_len_words = msg_offset / sizeof(u32) + 1;
+	word_ptr = (u32 *)sctx->msgptr;
+	word_ptr += 1;
+	*word_ptr = sctx->msg_len_words;
+
+	/* CRC (currently 0) goes at end of msg */
+	word_ptr = (u32 *)(sctx->msgptr + msg_offset);
+	*word_ptr = 0;
+}
+
+/**
+ *	sep_start_inbound_msg -
+ *	@sctx: pointer to struct sep_system_ctx
+ *	@msg_offset: offset to place for the next word in the message
+ *	@returns: 0 for success; error value for failure
+ *	Set up pointer in message pool for inbound message
+ */
+static u32 sep_start_inbound_msg(struct sep_system_ctx *sctx, u32 *msg_offset)
+{
+	u32 *word_ptr;
+	u32 token;
+	u32 error = SEP_OK;
+
+	*msg_offset = sizeof(u32) * 2;
+	word_ptr = (u32 *)sctx->msgptr;
+	token = *word_ptr;
+	sctx->msg_len_words = *(word_ptr + 1);
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
+ *	@sctx: pointer to struct sep_system_ctx
+ *	@in_addr: pointer to start of parameter
+ *	@size: size of parameter to copy (in bytes)
+ *	@max_size: size to move up offset; SEP mesg is in word sizes
+ *	@msg_offset: pointer to current offset (is updated)
+ *	@byte_array: flag ti indicate wheter endian must be changed
+ *	Copies data into the message area from caller
+ */
+static void sep_write_msg(struct sep_system_ctx *sctx, void *in_addr,
+	u32 size, u32 max_size, u32 *msg_offset, u32 byte_array)
+{
+	u32 *word_ptr;
+	void *void_ptr;
+	void_ptr = sctx->msgptr + *msg_offset;
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
+ *	@sctx: pointer to struct sep_system_ctx
+ *	@msg_offset: pointer to current offset (is updated)
+ *	@op_code: op code to put into message
+ *	Puts op code into message and updates offset
+ */
+static void sep_make_header(struct sep_system_ctx *sctx, u32 *msg_offset,
+			    u32 op_code)
+{
+	u32 *word_ptr;
+
+	*msg_offset = sep_start_msg(sctx);
+	word_ptr = (u32 *)(sctx->msgptr + *msg_offset);
+	*word_ptr = op_code;
+	*msg_offset += sizeof(u32);
+}
+
+
+
+/**
+ *	sep_read_msg -
+ *	@sctx: pointer to struct sep_system_ctx
+ *	@in_addr: pointer to start of parameter
+ *	@size: size of parameter to copy (in bytes)
+ *	@max_size: size to move up offset; SEP mesg is in word sizes
+ *	@msg_offset: pointer to current offset (is updated)
+ *	@byte_array: flag ti indicate wheter endian must be changed
+ *	Copies data out of the message area to caller
+ */
+static void sep_read_msg(struct sep_system_ctx *sctx, void *in_addr,
+	u32 size, u32 max_size, u32 *msg_offset, u32 byte_array)
+{
+	u32 *word_ptr;
+	void *void_ptr;
+	void_ptr = sctx->msgptr + *msg_offset;
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
+ *      @sctx: pointer to struct sep_system_ctx
+ *	@op_code: expected op_code
+ *      @msg_offset: pointer to current offset (is updated)
+ *	@returns: 0 for success; error for failure
+ */
+static u32 sep_verify_op(struct sep_system_ctx *sctx, u32 op_code,
+			 u32 *msg_offset)
+{
+	u32 error;
+	u32 in_ary[2];
+
+	struct sep_device *sep = sctx->sep_used;
+
+	dev_dbg(&sep->pdev->dev, "dumping return message\n");
+	error = sep_start_inbound_msg(sctx, msg_offset);
+	if (error) {
+		dev_warn(&sep->pdev->dev,
+			"sep_start_inbound_msg error\n");
+		return error;
+	}
+
+	sep_read_msg(sctx, in_ary, sizeof(u32) * 2, sizeof(u32) * 2,
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
+ * @sctx: pointer to struct sep_system_ctx
+ * @msg_offset: point to current place in SEP msg; is updated
+ * @dst: pointer to place to put the context
+ * @len: size of the context structure (differs for crypro/hash)
+ * This function reads the context from the msg area
+ * There is a special way the vendor needs to have the maximum
+ * length calculated so that the msg_offset is updated properly;
+ * it skips over some words in the msg area depending on the size
+ * of the context
+ */
+static void sep_read_context(struct sep_system_ctx *sctx, u32 *msg_offset,
+	void *dst, u32 len)
+{
+	u32 max_length = ((len + 3) / sizeof(u32)) * sizeof(u32);
+	sep_read_msg(sctx, dst, len, max_length, msg_offset, 0);
+}
+
+/**
+ * sep_write_context -
+ * @sctx: pointer to struct sep_system_ctx
+ * @msg_offset: point to current place in SEP msg; is updated
+ * @src: pointer to the current context
+ * @len: size of the context structure (differs for crypro/hash)
+ * This function writes the context to the msg area
+ * There is a special way the vendor needs to have the maximum
+ * length calculated so that the msg_offset is updated properly;
+ * it skips over some words in the msg area depending on the size
+ * of the context
+ */
+static void sep_write_context(struct sep_system_ctx *sctx, u32 *msg_offset,
+	void *src, u32 len)
+{
+	u32 max_length = ((len + 3) / sizeof(u32)) * sizeof(u32);
+	sep_write_msg(sctx, src, len, max_length, msg_offset, 0);
+}
+
+/**
+ * sep_clear_out -
+ * @sctx: pointer to struct sep_system_ctx
+ * Clear out crypto related values in sep device structure
+ * to enable device to be used by anyone; either kernel
+ * crypto or userspace app via middleware
+ */
+static void sep_clear_out(struct sep_system_ctx *sctx)
+{
+	if (sctx->src_sg_hold) {
+		sep_free_sg_buf(sctx->src_sg_hold);
+		sctx->src_sg_hold = NULL;
+	}
+
+	if (sctx->dst_sg_hold) {
+		sep_free_sg_buf(sctx->dst_sg_hold);
+		sctx->dst_sg_hold = NULL;
+	}
+
+	sctx->src_sg = NULL;
+	sctx->dst_sg = NULL;
+
+	sep_free_dma_table_data_handler(sctx->sep_used, &sctx->dma_ctx);
+
+	if (sctx->i_own_sep) {
+		/**
+		 * The following unlocks the sep and makes it available
+		 * to any other application
+		 * First, null out crypto entries in sep before relesing it
+		 */
+		sctx->sep_used->current_hash_req = NULL;
+		sctx->sep_used->current_cypher_req = NULL;
+		sctx->sep_used->current_request = 0;
+		sctx->sep_used->current_hash_stage = 0;
+		sctx->sep_used->sctx = NULL;
+		sctx->sep_used->in_kernel = 0;
+
+		sctx->call_status.status = 0;
+
+		/* Remove anything confidentail */
+		memset(sctx->sep_used->shared_addr, 0,
+			SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES);
+
+		sep_queue_status_remove(sctx->sep_used, &sctx->queue_elem);
+
+#ifdef SEP_ENABLE_RUNTIME_PM
+		sctx->sep_used->in_use = 0;
+		pm_runtime_mark_last_busy(&sctx->sep_used->pdev->dev);
+		pm_runtime_put_autosuspend(&sctx->sep_used->pdev->dev);
+#endif
+
+		clear_bit(SEP_WORKING_LOCK_BIT, &sctx->sep_used->in_use_flags);
+		sctx->sep_used->pid_doing_transaction = 0;
+
+		dev_dbg(&sctx->sep_used->pdev->dev,
+			"[PID%d] waking up next transaction\n",
+			current->pid);
+
+		clear_bit(SEP_TRANSACTION_STARTED_LOCK_BIT,
+			&sctx->sep_used->in_use_flags);
+		wake_up(&sctx->sep_used->event_transactions);
+
+		sctx->i_own_sep = 0;
+	}
+}
+
+/**
+  * Release crypto infrastructure from EINPROGRESS and
+  * clear sep_dev so that SEP is available to anyone
+  */
+static void sep_crypto_release(struct sep_system_ctx *sctx, u32 error)
+{
+	struct ahash_request *hash_req = sctx->current_hash_req;
+	struct ablkcipher_request *cypher_req =
+		sctx->current_cypher_req;
+	struct sep_device *sep = sctx->sep_used;
+
+	sep_clear_out(sctx);
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
+ *	This is where we grab the sep itself and tell it to do something.
+ *	It will sleep if the sep is currently busy
+ *	and it will return 0 if sep is now ours; error value if there
+ *	were problems
+ */
+static int sep_crypto_take_sep(struct sep_system_ctx *sctx)
+{
+	struct sep_device *sep = sctx->sep_used;
+	int result;
+	struct sep_msgarea_hdr *my_msg_header;
+
+	my_msg_header = (struct sep_msgarea_hdr *)sctx->msg;
+
+	/* add to status queue */
+	sctx->queue_elem = sep_queue_status_add(sep, my_msg_header->opcode,
+		sctx->nbytes, current->pid,
+		current->comm, sizeof(current->comm));
+
+	if (!sctx->queue_elem) {
+		dev_dbg(&sep->pdev->dev, "[PID%d] updating queue"
+			" status error\n", current->pid);
+		return -EINVAL;
+	}
+
+	/* get the device; this can sleep */
+	result = sep_wait_transaction(sep);
+	if (result)
+		return result;
+
+	if (sep_dev->power_save_setup == 1)
+		pm_runtime_get_sync(&sep_dev->pdev->dev);
+
+	/* Copy in the message */
+	memcpy(sep->shared_addr, sctx->msg,
+		SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES);
+
+	/* Copy in the dcb information if there is any */
+	if (sctx->dcb_region) {
+		result = sep_activate_dcb_dmatables_context(sep,
+			&sctx->dcb_region, &sctx->dmatables_region,
+			sctx->dma_ctx);
+		if (result)
+			return result;
+	}
+
+	/* Mark the device so we know how to finish the job in the tasklet */
+	if (sctx->current_hash_req)
+		sep->current_hash_req = sctx->current_hash_req;
+	else
+		sep->current_cypher_req = sctx->current_cypher_req;
+
+	sep->current_request = sctx->current_request;
+	sep->current_hash_stage = sctx->current_hash_stage;
+	sep->sctx = sctx;
+	sep->in_kernel = 1;
+	sctx->i_own_sep = 1;
+
+	result = sep_send_command_handler(sep);
+
+	dev_dbg(&sep->pdev->dev, "[PID%d]: sending command to the sep\n",
+		current->pid);
+
+	if (!result) {
+		set_bit(SEP_LEGACY_SENDMSG_DONE_OFFSET,
+			&sctx->call_status.status);
+		dev_dbg(&sep->pdev->dev, "[PID%d]: command sent okay\n",
+			current->pid);
+	}
+
+	return result;
+}
+
+/* This needs to be run as a work queue as it can be put asleep */
+static void sep_crypto_block(void *data)
+{
+	int int_error;
+	u32 msg_offset;
+	static u32 msg[10];
+	void *src_ptr;
+	void *dst_ptr;
+
+	static char small_buf[100];
+	ssize_t copy_result;
+	int result;
+
+	u32 max_length;
+	struct scatterlist *new_sg;
+	struct ablkcipher_request *req;
+	struct sep_block_ctx *bctx;
+	struct crypto_ablkcipher *tfm;
+	struct sep_system_ctx *sctx;
+
+	req = (struct ablkcipher_request *)data;
+	bctx = ablkcipher_request_ctx(req);
+	tfm = crypto_ablkcipher_reqtfm(req);
+	sctx = crypto_ablkcipher_ctx(tfm);
+
+	/* start the walk on scatterlists */
+	ablkcipher_walk_init(&bctx->walk, req->src, req->dst, req->nbytes);
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep crypto block data size of %x\n",
+		req->nbytes);
+
+	int_error = ablkcipher_walk_phys(req, &bctx->walk);
+	if (int_error) {
+		dev_warn(&sctx->sep_used->pdev->dev, "walk phys error %x\n",
+			int_error);
+		sep_crypto_release(sctx, -ENOMEM);
+		return;
+	}
+
+	/* check iv */
+	if (bctx->des_opmode == SEP_DES_CBC) {
+		if (!bctx->walk.iv) {
+			dev_warn(&sctx->sep_used->pdev->dev, "no iv found\n");
+			sep_crypto_release(sctx, -EINVAL);
+			return;
+		}
+
+		memcpy(bctx->iv, bctx->walk.iv, SEP_DES_IV_SIZE_BYTES);
+		sep_dump(sctx->sep_used, "iv", bctx->iv, SEP_DES_IV_SIZE_BYTES);
+	}
+
+	if (bctx->aes_opmode == SEP_AES_CBC) {
+		if (!bctx->walk.iv) {
+			dev_warn(&sctx->sep_used->pdev->dev, "no iv found\n");
+			sep_crypto_release(sctx, -EINVAL);
+			return;
+		}
+
+		memcpy(bctx->iv, bctx->walk.iv, SEP_AES_IV_SIZE_BYTES);
+		sep_dump(sctx->sep_used, "iv", bctx->iv, SEP_AES_IV_SIZE_BYTES);
+	}
+
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"crypto block: src is %lx dst is %lx\n",
+		(unsigned long)req->src, (unsigned long)req->dst);
+
+	/* Make sure all pages are even block */
+	int_error = sep_oddball_pages(sctx->sep_used, req->src,
+		req->nbytes, bctx->walk.blocksize, &new_sg, 1);
+
+	if (int_error < 0) {
+		dev_warn(&sctx->sep_used->pdev->dev, "oddball page eerror\n");
+		sep_crypto_release(sctx, -ENOMEM);
+		return;
+	} else if (int_error == 1) {
+		sctx->src_sg = new_sg;
+		sctx->src_sg_hold = new_sg;
+	} else {
+		sctx->src_sg = req->src;
+		sctx->src_sg_hold = NULL;
+	}
+
+	int_error = sep_oddball_pages(sctx->sep_used, req->dst,
+		req->nbytes, bctx->walk.blocksize, &new_sg, 0);
+
+	if (int_error < 0) {
+		dev_warn(&sctx->sep_used->pdev->dev, "walk phys error %x\n",
+			int_error);
+		sep_crypto_release(sctx, -ENOMEM);
+		return;
+	} else if (int_error == 1) {
+		sctx->dst_sg = new_sg;
+		sctx->dst_sg_hold = new_sg;
+	} else {
+		sctx->dst_sg = req->dst;
+		sctx->dst_sg_hold = NULL;
+	}
+
+	/* Do we need to perform init; ie; send key to sep? */
+	if (sctx->key_sent == 0) {
+
+		dev_dbg(&sctx->sep_used->pdev->dev, "sending key\n");
+
+		/* put together message to SEP */
+		/* Start with op code */
+		sep_make_header(sctx, &msg_offset, bctx->init_opcode);
+
+		/* now deal with IV */
+		if (bctx->init_opcode == SEP_DES_INIT_OPCODE) {
+			if (bctx->des_opmode == SEP_DES_CBC) {
+				sep_write_msg(sctx, bctx->iv,
+					SEP_DES_IV_SIZE_BYTES, sizeof(u32) * 4,
+					&msg_offset, 1);
+				sep_dump(sctx->sep_used, "initial IV",
+					bctx->walk.iv, SEP_DES_IV_SIZE_BYTES);
+			} else {
+				/* Skip if ECB */
+				msg_offset += 4 * sizeof(u32);
+			}
+		} else {
+			max_length = ((SEP_AES_IV_SIZE_BYTES + 3) /
+				sizeof(u32)) * sizeof(u32);
+			if (bctx->aes_opmode == SEP_AES_CBC) {
+				sep_write_msg(sctx, bctx->iv,
+					SEP_AES_IV_SIZE_BYTES, max_length,
+					&msg_offset, 1);
+				sep_dump(sctx->sep_used, "initial IV",
+					bctx->walk.iv, SEP_AES_IV_SIZE_BYTES);
+			} else {
+				/* Skip if ECB */
+				msg_offset += max_length;
+			}
+		}
+
+		/* load the key */
+		if (bctx->init_opcode == SEP_DES_INIT_OPCODE) {
+			sep_write_msg(sctx, (void *)&sctx->key.des.key1,
+				sizeof(u32) * 8, sizeof(u32) * 8,
+				&msg_offset, 1);
+
+			msg[0] = (u32)sctx->des_nbr_keys;
+			msg[1] = (u32)bctx->des_encmode;
+			msg[2] = (u32)bctx->des_opmode;
+
+			sep_write_msg(sctx, (void *)msg,
+				sizeof(u32) * 3, sizeof(u32) * 3,
+				&msg_offset, 0);
+		} else {
+			sep_write_msg(sctx, (void *)&sctx->key.aes,
+				sctx->keylen,
+				SEP_AES_MAX_KEY_SIZE_BYTES,
+				&msg_offset, 1);
+
+			msg[0] = (u32)sctx->aes_key_size;
+			msg[1] = (u32)bctx->aes_encmode;
+			msg[2] = (u32)bctx->aes_opmode;
+			msg[3] = (u32)0; /* Secret key is not used */
+			sep_write_msg(sctx, (void *)msg,
+				sizeof(u32) * 4, sizeof(u32) * 4,
+				&msg_offset, 0);
+		}
+
+	} else {
+
+		/* set nbytes for queue status */
+		sctx->nbytes = req->nbytes;
+
+		/* Key already done; this is for data */
+		dev_dbg(&sctx->sep_used->pdev->dev, "sending data\n");
+
+		sep_dump_sg(sctx->sep_used,
+			"block sg in", sctx->src_sg);
+
+		/* check for valid data and proper spacing */
+		src_ptr = sg_virt(sctx->src_sg);
+		dst_ptr = sg_virt(sctx->dst_sg);
+
+		if (!src_ptr || !dst_ptr ||
+			(sctx->current_cypher_req->nbytes %
+			crypto_ablkcipher_blocksize(tfm))) {
+
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"cipher block size odd\n");
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"cipher block size is %x\n",
+				crypto_ablkcipher_blocksize(tfm));
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"cipher data size is %x\n",
+				sctx->current_cypher_req->nbytes);
+			sep_crypto_release(sctx, -EINVAL);
+			return;
+		}
+
+		if (partial_overlap(src_ptr, dst_ptr,
+			sctx->current_cypher_req->nbytes)) {
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"block partial overlap\n");
+			sep_crypto_release(sctx, -EINVAL);
+			return;
+		}
+
+		/* Put together the message */
+		sep_make_header(sctx, &msg_offset, bctx->block_opcode);
+
+		/* If des, and size is 1 block, put directly in msg */
+		if ((bctx->block_opcode == SEP_DES_BLOCK_OPCODE) &&
+			(req->nbytes == crypto_ablkcipher_blocksize(tfm))) {
+
+			dev_dbg(&sctx->sep_used->pdev->dev,
+				"writing out one block des\n");
+
+			copy_result = sg_copy_to_buffer(
+				sctx->src_sg, sep_sg_nents(sctx->src_sg),
+				small_buf, crypto_ablkcipher_blocksize(tfm));
+
+			if (copy_result != crypto_ablkcipher_blocksize(tfm)) {
+				dev_warn(&sctx->sep_used->pdev->dev,
+					"des block copy faild\n");
+				sep_crypto_release(sctx, -ENOMEM);
+				return;
+			}
+
+			/* Put data into message */
+			sep_write_msg(sctx, small_buf,
+				crypto_ablkcipher_blocksize(tfm),
+				crypto_ablkcipher_blocksize(tfm) * 2,
+				&msg_offset, 1);
+
+			/* Put size into message */
+			sep_write_msg(sctx, &req->nbytes,
+				sizeof(u32), sizeof(u32), &msg_offset, 0);
+		} else {
+			/* Otherwise, fill out dma tables */
+			sctx->dcb_input_data.app_in_address = src_ptr;
+			sctx->dcb_input_data.data_in_size = req->nbytes;
+			sctx->dcb_input_data.app_out_address = dst_ptr;
+			sctx->dcb_input_data.block_size =
+				crypto_ablkcipher_blocksize(tfm);
+			sctx->dcb_input_data.tail_block_size = 0;
+			sctx->dcb_input_data.is_applet = 0;
+			sctx->dcb_input_data.src_sg = sctx->src_sg;
+			sctx->dcb_input_data.dst_sg = sctx->dst_sg;
+
+			result = sep_create_dcb_dmatables_context_kernel(
+				sctx->sep_used,
+				&sctx->dcb_region,
+				&sctx->dmatables_region,
+				&sctx->dma_ctx,
+				&sctx->dcb_input_data,
+				1);
+			if (result) {
+				dev_warn(&sctx->sep_used->pdev->dev,
+					"crypto dma table create failed\n");
+				sep_crypto_release(sctx, -EINVAL);
+				return;
+			}
+
+			/* Portion of msg is nulled (no data) */
+			msg[0] = (u32)0;
+			msg[1] = (u32)0;
+			msg[2] = (u32)0;
+			msg[3] = (u32)0;
+			msg[4] = (u32)0;
+			sep_write_msg(sctx, (void *)msg,
+				sizeof(u32) * 5,
+				sizeof(u32) * 5,
+				&msg_offset, 0);
+		}
+
+		/* Write context into message */
+		if (bctx->block_opcode == SEP_DES_BLOCK_OPCODE) {
+			sep_write_context(sctx, &msg_offset,
+				&bctx->des_private_ctx,
+				sizeof(struct sep_des_private_context));
+			sep_dump(sctx->sep_used, "ctx to block des",
+				&bctx->des_private_ctx, 40);
+		} else {
+			sep_write_context(sctx, &msg_offset,
+				&bctx->aes_private_ctx,
+				sizeof(struct sep_aes_private_context));
+			sep_dump(sctx->sep_used, "ctx to block aes",
+				&bctx->aes_private_ctx, 20);
+		}
+	}
+
+	/* conclude message and then tell sep to do its thing */
+	sctx->done_with_transaction = 0;
+
+	sep_end_msg(sctx, msg_offset);
+	result = sep_crypto_take_sep(sctx);
+	if (result) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep_crypto_take_sep failed\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return;
+	}
+
+	/**
+	 * Sep is now working. Lets wait up to 5 seconds
+	 * for completion. If it does not complete, we will do
+	 * a crypto release with -EINVAL to release the
+	 * kernel crypto infrastructure and let the system
+	 * continue to boot up
+	 * We have to wait this long because some crypto
+	 * operations can take a while
+	 */
+
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"waiting for done with transaction\n");
+
+	sctx->end_time = jiffies + (SEP_TRANSACTION_WAIT_TIME * HZ);
+	while ((time_before(jiffies, sctx->end_time)) &&
+		(!sctx->done_with_transaction))
+		schedule();
+
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"done waiting for done with transaction\n");
+
+	/* are we done? */
+	if (!sctx->done_with_transaction) {
+		/* Nope, lets release and tell crypto no */
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"[PID%d] sep_crypto_block never finished\n",
+			current->pid);
+		sep_crypto_release(sctx, -EINVAL);
+	}
+}
+
+/**
+ * Post operation (after interrupt) for crypto block
+ */
+static u32 crypto_post_op(struct sep_device *sep)
+{
+	/* HERE */
+	int int_error;
+	u32 u32_error;
+	u32 msg_offset;
+
+	ssize_t copy_result;
+	static char small_buf[100];
+
+	struct ablkcipher_request *req;
+	struct sep_block_ctx *bctx;
+	struct sep_system_ctx *sctx;
+	struct crypto_ablkcipher *tfm;
+
+	if (!sep->current_cypher_req)
+		return -EINVAL;
+
+	/* hold req since we need to submit work after clearing sep */
+	req = sep->current_cypher_req;
+
+	bctx = ablkcipher_request_ctx(sep->current_cypher_req);
+	tfm = crypto_ablkcipher_reqtfm(sep->current_cypher_req);
+	sctx = crypto_ablkcipher_ctx(tfm);
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "crypto post_op\n");
+	dev_dbg(&sctx->sep_used->pdev->dev, "crypto post_op message dump\n");
+	crypto_sep_dump_message(sctx);
+
+	sctx->done_with_transaction = 1;
+
+	/* first bring msg from shared area to local area */
+	memcpy(sctx->msg, sep->shared_addr,
+		SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES);
+
+	/* Is this the result of performing init (key to SEP */
+	if (sctx->key_sent == 0) {
+
+		/* Did SEP do it okay */
+		u32_error = sep_verify_op(sctx, bctx->init_opcode,
+			&msg_offset);
+		if (u32_error) {
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"aes init error %x\n", u32_error);
+			sep_crypto_release(sctx, u32_error);
+			return u32_error;
+			}
+
+		/* Read Context */
+		if (bctx->init_opcode == SEP_DES_INIT_OPCODE) {
+			sep_read_context(sctx, &msg_offset,
+			&bctx->des_private_ctx,
+			sizeof(struct sep_des_private_context));
+
+			sep_dump(sctx->sep_used, "ctx init des",
+				&bctx->des_private_ctx, 40);
+		} else {
+			sep_read_context(sctx, &msg_offset,
+			&bctx->aes_private_ctx,
+			sizeof(struct sep_des_private_context));
+
+			sep_dump(sctx->sep_used, "ctx init aes",
+				&bctx->aes_private_ctx, 20);
+		}
+
+		/* We are done with init. Now send out the data */
+		/* first release the sep */
+		sctx->key_sent = 1;
+		sep_crypto_release(sctx, -EINPROGRESS);
+
+		spin_lock_irq(&queue_lock);
+		int_error = crypto_enqueue_request(&sep_queue, &req->base);
+		spin_unlock_irq(&queue_lock);
+
+		if ((int_error != 0) && (int_error != -EINPROGRESS)) {
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"spe cypher post op cant queue\n");
+			sep_crypto_release(sctx, int_error);
+			return int_error;
+		}
+
+		/* schedule the data send */
+		int_error = sep_submit_work(sep->workqueue, sep_dequeuer,
+			(void *)&sep_queue);
+
+		if (int_error) {
+			dev_warn(&sep->pdev->dev,
+				"cant submit work sep_crypto_block\n");
+			sep_crypto_release(sctx, -EINVAL);
+			return -EINVAL;
+		}
+
+	} else {
+
+		/**
+		 * This is the result of a block request
+		 */
+		dev_dbg(&sctx->sep_used->pdev->dev,
+			"crypto_post_op block response\n");
+
+		u32_error = sep_verify_op(sctx, bctx->block_opcode,
+			&msg_offset);
+
+		if (u32_error) {
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"sep block error %x\n", u32_error);
+			sep_crypto_release(sctx, u32_error);
+			return -EINVAL;
+			}
+
+		if (bctx->block_opcode == SEP_DES_BLOCK_OPCODE) {
+
+			dev_dbg(&sctx->sep_used->pdev->dev,
+				"post op for DES\n");
+
+			/* special case for 1 block des */
+			if (sep->current_cypher_req->nbytes ==
+				crypto_ablkcipher_blocksize(tfm)) {
+
+				sep_read_msg(sctx, small_buf,
+					crypto_ablkcipher_blocksize(tfm),
+					crypto_ablkcipher_blocksize(tfm) * 2,
+					&msg_offset, 1);
+
+				dev_dbg(&sctx->sep_used->pdev->dev,
+					"reading in block des\n");
+
+				copy_result = sg_copy_from_buffer(
+					sctx->dst_sg,
+					sep_sg_nents(sctx->dst_sg),
+					small_buf,
+					crypto_ablkcipher_blocksize(tfm));
+
+				if (copy_result !=
+					crypto_ablkcipher_blocksize(tfm)) {
+
+					dev_warn(&sctx->sep_used->pdev->dev,
+						"des block copy faild\n");
+					sep_crypto_release(sctx, -ENOMEM);
+					return -ENOMEM;
+				}
+			}
+
+			/* Read Context */
+			sep_read_context(sctx, &msg_offset,
+				&bctx->des_private_ctx,
+				sizeof(struct sep_des_private_context));
+		} else {
+
+			dev_dbg(&sctx->sep_used->pdev->dev,
+				"post op for AES\n");
+
+			/* Skip the MAC Output */
+			msg_offset += (sizeof(u32) * 4);
+
+			/* Read Context */
+			sep_read_context(sctx, &msg_offset,
+				&bctx->aes_private_ctx,
+				sizeof(struct sep_aes_private_context));
+		}
+
+		sep_dump_sg(sctx->sep_used,
+			"block sg out", sctx->dst_sg);
+
+		/* Copy to correct sg if this block had oddball pages */
+		if (sctx->dst_sg_hold)
+			sep_copy_sg(sctx->sep_used,
+				sctx->dst_sg,
+				sctx->current_cypher_req->dst,
+				sctx->current_cypher_req->nbytes);
+
+		/* finished, release everything */
+		sep_crypto_release(sctx, 0);
+	}
+	return 0;
+}
+
+static u32 hash_init_post_op(struct sep_device *sep)
+{
+	u32 u32_error;
+	u32 msg_offset;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(sep->current_hash_req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(sep->current_hash_req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"hash init post op\n");
+
+	sctx->done_with_transaction = 1;
+
+	/* first bring msg from shared area to local area */
+	memcpy(sctx->msg, sep->shared_addr,
+		SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES);
+
+	u32_error = sep_verify_op(sctx, SEP_HASH_INIT_OPCODE,
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
+	sep_read_context(sctx, &msg_offset,
+		&ctx->hash_private_ctx,
+		sizeof(struct sep_hash_private_context));
+
+	/* Signal to crypto infrastructure and clear out */
+	dev_dbg(&sctx->sep_used->pdev->dev, "hash init post op done\n");
+	sep_crypto_release(sctx, 0);
+	return 0;
+}
+
+static u32 hash_update_post_op(struct sep_device *sep)
+{
+	u32 u32_error;
+	u32 msg_offset;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(sep->current_hash_req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(sep->current_hash_req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"hash update post op\n");
+
+	sctx->done_with_transaction = 1;
+
+	/* first bring msg from shared area to local area */
+	memcpy(sctx->msg, sep->shared_addr,
+		SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES);
+
+	u32_error = sep_verify_op(sctx, SEP_HASH_UPDATE_OPCODE,
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
+	sep_read_context(sctx, &msg_offset,
+		&ctx->hash_private_ctx,
+		sizeof(struct sep_hash_private_context));
+
+	sep_crypto_release(sctx, 0);
+	return 0;
+}
+
+static u32 hash_final_post_op(struct sep_device *sep)
+{
+	int max_length;
+	u32 u32_error;
+	u32 msg_offset;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(sep->current_hash_req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"hash final post op\n");
+
+	sctx->done_with_transaction = 1;
+
+	/* first bring msg from shared area to local area */
+	memcpy(sctx->msg, sep->shared_addr,
+		SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES);
+
+	u32_error = sep_verify_op(sctx, SEP_HASH_FINISH_OPCODE,
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
+	if (sctx->current_hash_req->result == NULL) {
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
+	sep_read_msg(sctx,
+		sctx->current_hash_req->result,
+		crypto_ahash_digestsize(tfm), max_length,
+		&msg_offset, 0);
+
+	/* Signal to crypto infrastructure and clear out */
+	dev_dbg(&sctx->sep_used->pdev->dev, "hash finish post op done\n");
+	sep_crypto_release(sctx, 0);
+	return 0;
+}
+
+static u32 hash_digest_post_op(struct sep_device *sep)
+{
+	int max_length;
+	u32 u32_error;
+	u32 msg_offset;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(sep->current_hash_req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"hash digest post op\n");
+
+	sctx->done_with_transaction = 1;
+
+	/* first bring msg from shared area to local area */
+	memcpy(sctx->msg, sep->shared_addr,
+		SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES);
+
+	u32_error = sep_verify_op(sctx, SEP_HASH_SINGLE_OPCODE,
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
+	if (sctx->current_hash_req->result == NULL) {
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
+	sep_read_msg(sctx,
+		sctx->current_hash_req->result,
+		crypto_ahash_digestsize(tfm), max_length,
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
+ * This is only called by the interrupt handler as a tasklet.
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
+	/* Did we really do a sep command prior to this? */
+	if (0 == test_bit(SEP_LEGACY_SENDMSG_DONE_OFFSET,
+		&sep_dev->sctx->call_status.status)) {
+
+		dev_warn(&sep_dev->pdev->dev, "[PID%d] sendmsg not called\n",
+			current->pid);
+		return;
+	}
+
+	if (sep_dev->send_ct != sep_dev->reply_ct) {
+		dev_warn(&sep_dev->pdev->dev,
+			"[PID%d] poll; no message came back\n",
+			current->pid);
+		return;
+	}
+
+	/* Check for error (In case time ran out) */
+	if ((res != 0x0) && (res != 0x8)) {
+		dev_warn(&sep_dev->pdev->dev,
+			"[PID%d] poll; poll error GPR3 is %x\n",
+			current->pid, res);
+		return;
+	}
+
+	/* What kind of interrupt from sep was this? */
+	res = sep_read_reg(sep_dev, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
+
+	dev_dbg(&sep_dev->pdev->dev, "[PID%d] GPR2 at crypto finish is %x\n",
+		current->pid, res);
+
+	/* Print request? */
+	if ((res >> 30) & 0x1) {
+		dev_dbg(&sep_dev->pdev->dev, "[PID%d] sep print req\n",
+			current->pid);
+		dev_dbg(&sep_dev->pdev->dev, "[PID%d] contents: %s\n",
+			current->pid,
+			(char *)(sep_dev->shared_addr +
+			SEP_DRIVER_PRINTF_OFFSET_IN_BYTES));
+		return;
+	}
+
+	/* Request for daemon (not currently in POR)? */
+	if (res >> 31) {
+		dev_dbg(&sep_dev->pdev->dev,
+			"[PID%d] sep request; ignoring\n",
+			current->pid);
+		return;
+	}
+
+	/* If we got here, then we have a replay to a sep command */
+
+	dev_dbg(&sep_dev->pdev->dev,
+		"[PID%d] sep reply to command; processing request: %x\n",
+		current->pid, sep_dev->current_request);
+
+	switch (sep_dev->current_request) {
+	case AES_CBC:
+	case AES_ECB:
+	case DES_CBC:
+	case DES_ECB:
+		res = crypto_post_op(sep_dev);
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
+static void sep_hash_init(void *data)
+{
+	u32 msg_offset;
+	int result;
+	struct ahash_request *req;
+	struct crypto_ahash *tfm;
+	struct sep_hash_ctx *ctx;
+	struct sep_system_ctx *sctx;
+
+	req = (struct ahash_request *)data;
+	tfm = crypto_ahash_reqtfm(req);
+	ctx = ahash_request_ctx(req);
+	sctx = crypto_ahash_ctx(tfm);
+
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"sep_hash_init\n");
+	sctx->current_hash_stage = HASH_INIT;
+	/* opcode and mode */
+	sep_make_header(sctx, &msg_offset, SEP_HASH_INIT_OPCODE);
+	sep_write_msg(sctx, &ctx->hash_opmode,
+		sizeof(u32), sizeof(u32), &msg_offset, 0);
+	sep_end_msg(sctx, msg_offset);
+
+	sctx->done_with_transaction = 0;
+
+	result = sep_crypto_take_sep(sctx);
+	if (result) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep_hash_init take sep failed\n");
+		sep_crypto_release(sctx, -EINVAL);
+	}
+
+	/**
+	 * Sep is now working. Lets wait up to 5 seconds
+	 * for completion. If it does not complete, we will do
+	 * a crypto release with -EINVAL to release the
+	 * kernel crypto infrastructure and let the system
+	 * continue to boot up
+	 * We have to wait this long because some crypto
+	 * operations can take a while
+	 */
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"waiting for done with transaction\n");
+
+	sctx->end_time = jiffies + (SEP_TRANSACTION_WAIT_TIME * HZ);
+	while ((time_before(jiffies, sctx->end_time)) &&
+		(!sctx->done_with_transaction))
+		schedule();
+
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"done waiting for done with transaction\n");
+
+	/* are we done? */
+	if (!sctx->done_with_transaction) {
+		/* Nope, lets release and tell crypto no */
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"[PID%d] sep_hash_init never finished\n",
+			current->pid);
+		sep_crypto_release(sctx, -EINVAL);
+	}
+}
+
+static void sep_hash_update(void *data)
+{
+	int int_error;
+	u32 msg_offset;
+	u32 len;
+	struct sep_hash_internal_context *int_ctx;
+	u32 block_size;
+	u32 head_len;
+	u32 tail_len;
+	static u32 msg[10];
+	static char small_buf[100];
+	void *src_ptr;
+	struct scatterlist *new_sg;
+	ssize_t copy_result;
+	struct ahash_request *req;
+	struct crypto_ahash *tfm;
+	struct sep_hash_ctx *ctx;
+	struct sep_system_ctx *sctx;
+
+	req = (struct ahash_request *)data;
+	tfm = crypto_ahash_reqtfm(req);
+	ctx = ahash_request_ctx(req);
+	sctx = crypto_ahash_ctx(tfm);
+
+	/* length for queue status */
+	sctx->nbytes = req->nbytes;
+
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"sep_hash_update\n");
+	sctx->current_hash_stage = HASH_UPDATE;
+	len = req->nbytes;
+
+	block_size = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
+	tail_len = req->nbytes % block_size;
+	dev_dbg(&sctx->sep_used->pdev->dev, "length is %x\n", len);
+	dev_dbg(&sctx->sep_used->pdev->dev, "block_size is %x\n", block_size);
+	dev_dbg(&sctx->sep_used->pdev->dev, "tail len is %x\n", tail_len);
+
+	/* Compute header/tail sizes */
+	int_ctx = (struct sep_hash_internal_context *)&ctx->
+		hash_private_ctx.internal_context;
+	head_len = (block_size - int_ctx->prev_update_bytes) % block_size;
+	tail_len = (req->nbytes - head_len) % block_size;
+
+	/* Make sure all pages are even block */
+	int_error = sep_oddball_pages(sctx->sep_used, req->src,
+		req->nbytes,
+		block_size, &new_sg, 1);
+
+	if (int_error < 0) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"oddball pages error in crash update\n");
+		sep_crypto_release(sctx, -ENOMEM);
+		return;
+	} else if (int_error == 1) {
+		sctx->src_sg = new_sg;
+		sctx->src_sg_hold = new_sg;
+	} else {
+		sctx->src_sg = req->src;
+		sctx->src_sg_hold = NULL;
+	}
+
+	src_ptr = sg_virt(sctx->src_sg);
+
+	if ((!req->nbytes) || (!ctx->sg)) {
+		/* null data */
+		src_ptr = NULL;
+	}
+
+	sep_dump_sg(sctx->sep_used, "hash block sg in", sctx->src_sg);
+
+	sctx->dcb_input_data.app_in_address = src_ptr;
+	sctx->dcb_input_data.data_in_size = req->nbytes - (head_len + tail_len);
+	sctx->dcb_input_data.app_out_address = NULL;
+	sctx->dcb_input_data.block_size = block_size;
+	sctx->dcb_input_data.tail_block_size = 0;
+	sctx->dcb_input_data.is_applet = 0;
+	sctx->dcb_input_data.src_sg = sctx->src_sg;
+	sctx->dcb_input_data.dst_sg = NULL;
+
+	int_error = sep_create_dcb_dmatables_context_kernel(
+		sctx->sep_used,
+		&sctx->dcb_region,
+		&sctx->dmatables_region,
+		&sctx->dma_ctx,
+		&sctx->dcb_input_data,
+		1);
+	if (int_error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"hash update dma table create failed\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return;
+	}
+
+	/* Construct message to SEP */
+	sep_make_header(sctx, &msg_offset, SEP_HASH_UPDATE_OPCODE);
+
+	msg[0] = (u32)0;
+	msg[1] = (u32)0;
+	msg[2] = (u32)0;
+
+	sep_write_msg(sctx, msg, sizeof(u32) * 3, sizeof(u32) * 3,
+		&msg_offset, 0);
+
+	/* Handle remainders */
+
+	/* Head */
+	sep_write_msg(sctx, &head_len, sizeof(u32),
+		sizeof(u32), &msg_offset, 0);
+
+	if (head_len) {
+		copy_result = sg_copy_to_buffer(
+			req->src,
+			sep_sg_nents(sctx->src_sg),
+			small_buf, head_len);
+
+		if (copy_result != head_len) {
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"sg head copy failure in hash block\n");
+			sep_crypto_release(sctx, -ENOMEM);
+			return;
+		}
+
+		sep_write_msg(sctx, small_buf, head_len,
+			sizeof(u32) * 32, &msg_offset, 1);
+	} else {
+		msg_offset += sizeof(u32) * 32;
+	}
+
+	/* Tail */
+	sep_write_msg(sctx, &tail_len, sizeof(u32),
+		sizeof(u32), &msg_offset, 0);
+
+	if (tail_len) {
+		copy_result = sep_copy_offset_sg(
+			sctx->sep_used,
+			sctx->src_sg,
+			req->nbytes - tail_len,
+			small_buf, tail_len);
+
+		if (copy_result != tail_len) {
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"sg tail copy failure in hash block\n");
+			sep_crypto_release(sctx, -ENOMEM);
+			return;
+		}
+
+		sep_write_msg(sctx, small_buf, tail_len,
+			sizeof(u32) * 32, &msg_offset, 1);
+	} else {
+		msg_offset += sizeof(u32) * 32;
+	}
+
+	/* Context */
+	sep_write_context(sctx, &msg_offset, &ctx->hash_private_ctx,
+		sizeof(struct sep_hash_private_context));
+
+	sep_end_msg(sctx, msg_offset);
+	sctx->done_with_transaction = 0;
+	int_error = sep_crypto_take_sep(sctx);
+	if (int_error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep_hash_update take sep failed\n");
+		sep_crypto_release(sctx, -EINVAL);
+	}
+
+	/**
+	 * Sep is now working. Lets wait up to 5 seconds
+	 * for completion. If it does not complete, we will do
+	 * a crypto release with -EINVAL to release the
+	 * kernel crypto infrastructure and let the system
+	 * continue to boot up
+	 * We have to wait this long because some crypto
+	 * operations can take a while
+	 */
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"waiting for done with transaction\n");
+
+	sctx->end_time = jiffies + (SEP_TRANSACTION_WAIT_TIME * HZ);
+	while ((time_before(jiffies, sctx->end_time)) &&
+		(!sctx->done_with_transaction))
+		schedule();
+
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"done waiting for done with transaction\n");
+
+	/* are we done? */
+	if (!sctx->done_with_transaction) {
+		/* Nope, lets release and tell crypto no */
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"[PID%d] sep_hash_update never finished\n",
+			current->pid);
+		sep_crypto_release(sctx, -EINVAL);
+	}
+}
+
+static void sep_hash_final(void *data)
+{
+	u32 msg_offset;
+	struct ahash_request *req;
+	struct crypto_ahash *tfm;
+	struct sep_hash_ctx *ctx;
+	struct sep_system_ctx *sctx;
+	int result;
+
+	req = (struct ahash_request *)data;
+	tfm = crypto_ahash_reqtfm(req);
+	ctx = ahash_request_ctx(req);
+	sctx = crypto_ahash_ctx(tfm);
+
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"sep_hash_final\n");
+	sctx->current_hash_stage = HASH_FINISH;
+
+	/* opcode and mode */
+	sep_make_header(sctx, &msg_offset, SEP_HASH_FINISH_OPCODE);
+
+	/* Context */
+	sep_write_context(sctx, &msg_offset, &ctx->hash_private_ctx,
+		sizeof(struct sep_hash_private_context));
+
+	sep_end_msg(sctx, msg_offset);
+	sctx->done_with_transaction = 0;
+	result = sep_crypto_take_sep(sctx);
+	if (result) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep_hash_final take sep failed\n");
+		sep_crypto_release(sctx, -EINVAL);
+	}
+
+	/**
+	 * Sep is now working. Lets wait up to 5 seconds
+	 * for completion. If it does not complete, we will do
+	 * a crypto release with -EINVAL to release the
+	 * kernel crypto infrastructure and let the system
+	 * continue to boot up
+	 * We have to wait this long because some crypto
+	 * operations can take a while
+	 */
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"waiting for done with transaction\n");
+
+	sctx->end_time = jiffies + (SEP_TRANSACTION_WAIT_TIME * HZ);
+	while ((time_before(jiffies, sctx->end_time)) &&
+		(!sctx->done_with_transaction))
+		schedule();
+
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"done waiting for done with transaction\n");
+
+	/* are we done? */
+	if (!sctx->done_with_transaction) {
+		/* Nope, lets release and tell crypto no */
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"[PID%d] sep_hash_final never finished\n",
+			current->pid);
+		sep_crypto_release(sctx, -EINVAL);
+	}
+}
+
+static void sep_hash_digest(void *data)
+{
+	int int_error;
+	u32 msg_offset;
+	u32 block_size;
+	u32 msg[10];
+	size_t copy_result;
+	int result;
+	u32 tail_len;
+	static char small_buf[100];
+	struct scatterlist *new_sg;
+	void *src_ptr;
+
+	struct ahash_request *req;
+	struct crypto_ahash *tfm;
+	struct sep_hash_ctx *ctx;
+	struct sep_system_ctx *sctx;
+
+	req = (struct ahash_request *)data;
+	tfm = crypto_ahash_reqtfm(req);
+	ctx = ahash_request_ctx(req);
+	sctx = crypto_ahash_ctx(tfm);
+
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"sep_hash_digest\n");
+	sctx->current_hash_stage = HASH_DIGEST;
+
+	/* length for queue status */
+	sctx->nbytes = req->nbytes;
+
+	block_size = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
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
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"oddball pages error in crash update\n");
+		sep_crypto_release(sctx, -ENOMEM);
+		return;
+	} else if (int_error == 1) {
+		sctx->src_sg = new_sg;
+		sctx->src_sg_hold = new_sg;
+	} else {
+		sctx->src_sg = req->src;
+		sctx->src_sg_hold = NULL;
+	}
+
+	src_ptr = sg_virt(sctx->src_sg);
+
+	if ((!req->nbytes) || (!ctx->sg)) {
+		/* null data */
+		src_ptr = NULL;
+	}
+
+	sep_dump_sg(sctx->sep_used, "hash block sg in", sctx->src_sg);
+
+	sctx->dcb_input_data.app_in_address = src_ptr;
+	sctx->dcb_input_data.data_in_size = req->nbytes - tail_len;
+	sctx->dcb_input_data.app_out_address = NULL;
+	sctx->dcb_input_data.block_size = block_size;
+	sctx->dcb_input_data.tail_block_size = 0;
+	sctx->dcb_input_data.is_applet = 0;
+	sctx->dcb_input_data.src_sg = sctx->src_sg;
+	sctx->dcb_input_data.dst_sg = NULL;
+
+	int_error = sep_create_dcb_dmatables_context_kernel(
+		sctx->sep_used,
+		&sctx->dcb_region,
+		&sctx->dmatables_region,
+		&sctx->dma_ctx,
+		&sctx->dcb_input_data,
+		1);
+	if (int_error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"hash update dma table create failed\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return;
+	}
+
+	/* Construct message to SEP */
+	sep_make_header(sctx, &msg_offset, SEP_HASH_SINGLE_OPCODE);
+	sep_write_msg(sctx, &ctx->hash_opmode,
+		sizeof(u32), sizeof(u32), &msg_offset, 0);
+
+	msg[0] = (u32)0;
+	msg[1] = (u32)0;
+	msg[2] = (u32)0;
+
+	sep_write_msg(sctx, msg, sizeof(u32) * 3, sizeof(u32) * 3,
+		&msg_offset, 0);
+
+	/* Tail */
+	sep_write_msg(sctx, &tail_len, sizeof(u32),
+		sizeof(u32), &msg_offset, 0);
+
+	if (tail_len) {
+		copy_result = sep_copy_offset_sg(
+			sctx->sep_used,
+			sctx->src_sg,
+			req->nbytes - tail_len,
+			small_buf, tail_len);
+
+		if (copy_result != tail_len) {
+			dev_warn(&sctx->sep_used->pdev->dev,
+				"sg tail copy failure in hash block\n");
+			sep_crypto_release(sctx, -ENOMEM);
+			return;
+		}
+
+		sep_write_msg(sctx, small_buf, tail_len,
+			sizeof(u32) * 32, &msg_offset, 1);
+	} else {
+		msg_offset += sizeof(u32) * 32;
+	}
+
+	sep_end_msg(sctx, msg_offset);
+
+	sctx->done_with_transaction = 0;
+
+	result = sep_crypto_take_sep(sctx);
+	if (result) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep_hash_digest take sep failed\n");
+		sep_crypto_release(sctx, -EINVAL);
+	}
+
+	/**
+	 * Sep is now working. Lets wait up to 5 seconds
+	 * for completion. If it does not complete, we will do
+	 * a crypto release with -EINVAL to release the
+	 * kernel crypto infrastructure and let the system
+	 * continue to boot up
+	 * We have to wait this long because some crypto
+	 * operations can take a while
+	 */
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"waiting for done with transaction\n");
+
+	sctx->end_time = jiffies + (SEP_TRANSACTION_WAIT_TIME * HZ);
+	while ((time_before(jiffies, sctx->end_time)) &&
+		(!sctx->done_with_transaction))
+		schedule();
+
+	dev_dbg(&sctx->sep_used->pdev->dev,
+		"done waiting for done with transaction\n");
+
+	/* are we done? */
+	if (!sctx->done_with_transaction) {
+		/* Nope, lets release and tell crypto no */
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"[PID%d] sep_hash_digest never finished\n",
+			current->pid);
+		sep_crypto_release(sctx, -EINVAL);
+	}
+}
+
+/**
+ * This is what is called by each of the API's provided
+ * in the kernel crypto descriptors. It is run in a process
+ * context using the kernel workqueues. Therefore it can
+ * be put to sleep.
+ */
+static void sep_dequeuer(void *data)
+{
+	struct crypto_queue *this_queue;
+	struct crypto_async_request *async_req;
+	struct crypto_async_request *backlog;
+	struct ablkcipher_request *cypher_req;
+	struct ahash_request *hash_req;
+	struct sep_system_ctx *sctx;
+	struct crypto_ahash *hash_tfm;
+
+
+	this_queue = (struct crypto_queue *)data;
+
+	spin_lock_irq(&queue_lock);
+	backlog = crypto_get_backlog(this_queue);
+	async_req = crypto_dequeue_request(this_queue);
+	spin_unlock_irq(&queue_lock);
+
+	if (!async_req) {
+		pr_debug("sep crypto queue is empty\n");
+		return;
+	}
+
+	if (backlog) {
+		pr_debug("sep crypto backlog set\n");
+		if (backlog->complete)
+			backlog->complete(backlog, -EINPROGRESS);
+		backlog = NULL;
+	}
+
+	if (!async_req->tfm) {
+		pr_debug("sep crypto queue null tfm\n");
+		return;
+	}
+
+	if (!async_req->tfm->__crt_alg) {
+		pr_debug("sep crypto queue null __crt_alg\n");
+		return;
+	}
+
+	if (!async_req->tfm->__crt_alg->cra_type) {
+		pr_debug("sep crypto queue null cra_type\n");
+		return;
+	}
+
+	/* we have stuff in the queue */
+	if (async_req->tfm->__crt_alg->cra_type !=
+		&crypto_ahash_type) {
+		/* This is for a cypher */
+		pr_debug("sep crypto queue doing cipher\n");
+		cypher_req = container_of(async_req,
+			struct ablkcipher_request,
+			base);
+		if (!cypher_req) {
+			pr_debug("sep crypto queue null cypher_req\n");
+			return;
+		}
+
+		sep_crypto_block((void *)cypher_req);
+		return;
+	} else {
+		/* This is a hash */
+		pr_debug("sep crypto queue doing hash\n");
+		/**
+		 * This is a bit more complex than cipher; we
+		 * need to figure out what type of operation
+		 */
+		hash_req = ahash_request_cast(async_req);
+		if (!hash_req) {
+			pr_debug("sep crypto queue null hash_req\n");
+			return;
+		}
+
+		hash_tfm = crypto_ahash_reqtfm(hash_req);
+		if (!hash_tfm) {
+			pr_debug("sep crypto queue null hash_tfm\n");
+			return;
+		}
+
+
+		sctx = crypto_ahash_ctx(hash_tfm);
+		if (!sctx) {
+			pr_debug("sep crypto queue null sctx\n");
+			return;
+		}
+
+		if (sctx->current_hash_stage == HASH_INIT) {
+			pr_debug("sep crypto queue hash init\n");
+			sep_hash_init((void *)hash_req);
+			return;
+		} else if (sctx->current_hash_stage == HASH_UPDATE) {
+			pr_debug("sep crypto queue hash update\n");
+			sep_hash_update((void *)hash_req);
+			return;
+		} else if (sctx->current_hash_stage == HASH_FINISH) {
+			pr_debug("sep crypto queue hash final\n");
+			sep_hash_final((void *)hash_req);
+			return;
+		} else if (sctx->current_hash_stage == HASH_DIGEST) {
+			pr_debug("sep crypto queue hash digest\n");
+			sep_hash_digest((void *)hash_req);
+			return;
+		} else {
+			pr_debug("sep crypto queue hash oops nothing\n");
+			return;
+		}
+	}
+}
+
+static int sep_sha1_init(struct ahash_request *req)
+{
+	int error;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha1 init\n");
+	sctx->current_request = SHA1;
+	sctx->current_hash_req = req;
+	sctx->current_cypher_req = NULL;
+	ctx->hash_opmode = SEP_HASH_SHA1;
+	sctx->current_hash_stage = HASH_INIT;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep sha1 init cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sha1 init cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+}
+
+static int sep_sha1_update(struct ahash_request *req)
+{
+	int error;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha1 update\n");
+	sctx->current_request = SHA1;
+	sctx->current_hash_req = req;
+	sctx->current_cypher_req = NULL;
+	ctx->hash_opmode = SEP_HASH_SHA1;
+	sctx->current_hash_stage = HASH_INIT;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep sha1 update cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sha1 update cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+}
+
+static int sep_sha1_final(struct ahash_request *req)
+{
+	int error;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha1 final\n");
+
+	sctx->current_request = SHA1;
+	sctx->current_hash_req = req;
+	sctx->current_cypher_req = NULL;
+	ctx->hash_opmode = SEP_HASH_SHA1;
+	sctx->current_hash_stage = HASH_FINISH;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep sha1 final cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sha1 final cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+
+}
+
+static int sep_sha1_digest(struct ahash_request *req)
+{
+	int error;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha1 digest\n");
+
+	sctx->current_request = SHA1;
+	sctx->current_hash_req = req;
+	sctx->current_cypher_req = NULL;
+	ctx->hash_opmode = SEP_HASH_SHA1;
+	sctx->current_hash_stage = HASH_DIGEST;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep sha1 digest cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sha1 digest cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+
+}
+
+static int sep_md5_init(struct ahash_request *req)
+{
+	int error;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing md5 init\n");
+
+	sctx->current_request = MD5;
+	sctx->current_hash_req = req;
+	sctx->current_cypher_req = NULL;
+	ctx->hash_opmode = SEP_HASH_MD5;
+	sctx->current_hash_stage = HASH_INIT;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep md5 init cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"md5 init cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+
+}
+
+static int sep_md5_update(struct ahash_request *req)
+{
+	int error;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing md5 update\n");
+
+	sctx->current_request = MD5;
+	sctx->current_hash_req = req;
+	sctx->current_cypher_req = NULL;
+	ctx->hash_opmode = SEP_HASH_MD5;
+	sctx->current_hash_stage = HASH_UPDATE;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"md5 update cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"md5 update cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+}
+
+static int sep_md5_final(struct ahash_request *req)
+{
+	int error;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing md5 final\n");
+
+	sctx->current_request = MD5;
+	sctx->current_hash_req = req;
+	sctx->current_cypher_req = NULL;
+	ctx->hash_opmode = SEP_HASH_MD5;
+	sctx->current_hash_stage = HASH_FINISH;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep md5 final cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"md5 final cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+
+}
+
+static int sep_md5_digest(struct ahash_request *req)
+{
+	int error;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing md5 digest\n");
+	sctx->current_request = MD5;
+	sctx->current_hash_req = req;
+	sctx->current_cypher_req = NULL;
+	ctx->hash_opmode = SEP_HASH_MD5;
+	sctx->current_hash_stage = HASH_DIGEST;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep md5 digest cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"md5 digest cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+}
+
+static int sep_sha224_init(struct ahash_request *req)
+{
+	int error;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha224 init\n");
+
+	sctx->current_request = SHA224;
+	sctx->current_hash_req = req;
+	sctx->current_cypher_req = NULL;
+	ctx->hash_opmode = SEP_HASH_SHA224;
+	sctx->current_hash_stage = HASH_INIT;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep sha224 init cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sha224 init cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+}
+
+static int sep_sha224_update(struct ahash_request *req)
+{
+	int error;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha224 update\n");
+
+	sctx->current_request = SHA224;
+	sctx->current_hash_req = req;
+	sctx->current_cypher_req = NULL;
+	ctx->hash_opmode = SEP_HASH_SHA224;
+	sctx->current_hash_stage = HASH_UPDATE;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep sha224 update cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sha224 update cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+}
+
+static int sep_sha224_final(struct ahash_request *req)
+{
+	int error;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha224 final\n");
+
+	sctx->current_request = SHA224;
+	sctx->current_hash_req = req;
+	sctx->current_cypher_req = NULL;
+	ctx->hash_opmode = SEP_HASH_SHA224;
+	sctx->current_hash_stage = HASH_FINISH;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep sha224 final cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sha224 final cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+}
+
+static int sep_sha224_digest(struct ahash_request *req)
+{
+	int error;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing 224 digest\n");
+	sctx->current_request = SHA224;
+	sctx->current_hash_req = req;
+	sctx->current_cypher_req = NULL;
+	ctx->hash_opmode = SEP_HASH_SHA224;
+	sctx->current_hash_stage = HASH_DIGEST;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep sha224 digest cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sha256 digest cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+}
+
+static int sep_sha256_init(struct ahash_request *req)
+{
+	int error;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha256 init\n");
+
+	sctx->current_request = SHA256;
+	sctx->current_hash_req = req;
+	sctx->current_cypher_req = NULL;
+	ctx->hash_opmode = SEP_HASH_SHA256;
+	sctx->current_hash_stage = HASH_INIT;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep sha256 init cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sha256 init cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+}
+
+static int sep_sha256_update(struct ahash_request *req)
+{
+	int error;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha256 update\n");
+
+	sctx->current_request = SHA256;
+	sctx->current_hash_req = req;
+	sctx->current_cypher_req = NULL;
+	ctx->hash_opmode = SEP_HASH_SHA256;
+	sctx->current_hash_stage = HASH_UPDATE;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep sha256 update cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sha256 update cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+}
+
+static int sep_sha256_final(struct ahash_request *req)
+{
+	int error;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha256 final\n");
+
+	sctx->current_request = SHA256;
+	sctx->current_hash_req = req;
+	sctx->current_cypher_req = NULL;
+	ctx->hash_opmode = SEP_HASH_SHA256;
+	sctx->current_hash_stage = HASH_FINISH;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep sha256 final cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sha256 final cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+}
+
+static int sep_sha256_digest(struct ahash_request *req)
+{
+	int error;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sep_hash_ctx *ctx = ahash_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "doing sha256 digest\n");
+	sctx->current_request = SHA256;
+	sctx->current_hash_req = req;
+	sctx->current_cypher_req = NULL;
+	ctx->hash_opmode = SEP_HASH_SHA256;
+	sctx->current_hash_stage = HASH_DIGEST;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep sha256 digest cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sha256 digest cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
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
+static int sep_aes_ecb_encrypt(struct ablkcipher_request *req)
+{
+	int error;
+	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(req));
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep aes ecb encrypt\n");
+	sctx->current_request = AES_ECB;
+	sctx->current_hash_req = NULL;
+	sctx->current_cypher_req = req;
+	bctx->aes_encmode = SEP_AES_ENCRYPT;
+	bctx->aes_opmode = SEP_AES_ECB;
+	bctx->init_opcode = SEP_AES_INIT_OPCODE;
+	bctx->block_opcode = SEP_AES_BLOCK_OPCODE;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep_aes_ecb_encrypt cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep_aes_ecb_encrypt cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+}
+
+static int sep_aes_ecb_decrypt(struct ablkcipher_request *req)
+{
+	int error;
+	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(req));
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep aes ecb decrypt\n");
+	sctx->current_request = AES_ECB;
+	sctx->current_hash_req = NULL;
+	sctx->current_cypher_req = req;
+	bctx->aes_encmode = SEP_AES_DECRYPT;
+	bctx->aes_opmode = SEP_AES_ECB;
+	bctx->init_opcode = SEP_AES_INIT_OPCODE;
+	bctx->block_opcode = SEP_AES_BLOCK_OPCODE;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep_aes_ecb_decrypt cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep_aes_ecb_decrypt cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+}
+
+static int sep_aes_cbc_encrypt(struct ablkcipher_request *req)
+{
+	int error;
+	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(req));
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep aes cbc encrypt\n");
+	sctx->current_request = AES_CBC;
+	sctx->current_hash_req = NULL;
+	sctx->current_cypher_req = req;
+	bctx->aes_encmode = SEP_AES_ENCRYPT;
+	bctx->aes_opmode = SEP_AES_CBC;
+	bctx->init_opcode = SEP_AES_INIT_OPCODE;
+	bctx->block_opcode = SEP_AES_BLOCK_OPCODE;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep_aes_cbc_encrypt cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep_aes_cbc_encrypt cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+}
+
+static int sep_aes_cbc_decrypt(struct ablkcipher_request *req)
+{
+	int error;
+	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(req));
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep aes cbc decrypt\n");
+	sctx->current_request = AES_CBC;
+	sctx->current_hash_req = NULL;
+	sctx->current_cypher_req = req;
+	bctx->aes_encmode = SEP_AES_DECRYPT;
+	bctx->aes_opmode = SEP_AES_CBC;
+	bctx->init_opcode = SEP_AES_INIT_OPCODE;
+	bctx->block_opcode = SEP_AES_BLOCK_OPCODE;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep_aes_cbc_decrypt cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep_aes_cbc_decrypt cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
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
+	default:
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
+static int sep_des_ebc_encrypt(struct ablkcipher_request *req)
+{
+	int error;
+	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(req));
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep des ecb encrypt\n");
+	sctx->current_request = DES_ECB;
+	sctx->current_hash_req = NULL;
+	sctx->current_cypher_req = req;
+	bctx->des_encmode = SEP_DES_ENCRYPT;
+	bctx->des_opmode = SEP_DES_ECB;
+	bctx->init_opcode = SEP_DES_INIT_OPCODE;
+	bctx->block_opcode = SEP_DES_BLOCK_OPCODE;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep_des_ecb_encrypt cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep_des_ecb_encrypt cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+}
+
+static int sep_des_ebc_decrypt(struct ablkcipher_request *req)
+{
+	int error;
+	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(req));
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep des ecb decrypt\n");
+	sctx->current_request = DES_ECB;
+	sctx->current_hash_req = NULL;
+	sctx->current_cypher_req = req;
+	bctx->des_encmode = SEP_DES_DECRYPT;
+	bctx->des_opmode = SEP_DES_ECB;
+	bctx->init_opcode = SEP_DES_INIT_OPCODE;
+	bctx->block_opcode = SEP_DES_BLOCK_OPCODE;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep_des_ecb_decrypt cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep_des_ecb_decrypt cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+}
+
+static int sep_des_cbc_encrypt(struct ablkcipher_request *req)
+{
+	int error;
+	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(req));
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep des cbc encrypt\n");
+	sctx->current_request = DES_CBC;
+	sctx->current_hash_req = NULL;
+	sctx->current_cypher_req = req;
+	bctx->des_encmode = SEP_DES_ENCRYPT;
+	bctx->des_opmode = SEP_DES_CBC;
+	bctx->init_opcode = SEP_DES_INIT_OPCODE;
+	bctx->block_opcode = SEP_DES_BLOCK_OPCODE;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep_des_cbc_encrypt cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep_des_cbc_encrypt cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+}
+
+static int sep_des_cbc_decrypt(struct ablkcipher_request *req)
+{
+	int error;
+	struct sep_block_ctx *bctx = ablkcipher_request_ctx(req);
+	struct sep_system_ctx *sctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(req));
+
+	dev_dbg(&sctx->sep_used->pdev->dev, "sep des cbc decrypt\n");
+	sctx->current_request = DES_CBC;
+	sctx->current_hash_req = NULL;
+	sctx->current_cypher_req = req;
+	bctx->des_encmode = SEP_DES_DECRYPT;
+	bctx->des_opmode = SEP_DES_CBC;
+	bctx->init_opcode = SEP_DES_INIT_OPCODE;
+	bctx->block_opcode = SEP_DES_BLOCK_OPCODE;
+
+	spin_lock_irq(&queue_lock);
+	error = crypto_enqueue_request(&sep_queue, &req->base);
+	spin_unlock_irq(&queue_lock);
+
+	if ((error != 0) && (error != -EINPROGRESS)) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep_des_cbc_decrypt cant enqueue\n");
+		sep_crypto_release(sctx, error);
+		return error;
+	}
+
+	error = sep_submit_work(sctx->sep_used->workqueue, sep_dequeuer,
+		(void *)&sep_queue);
+	if (error) {
+		dev_warn(&sctx->sep_used->pdev->dev,
+			"sep_des_cbc_decrypt cannot submit queue\n");
+		sep_crypto_release(sctx, -EINVAL);
+		return -EINVAL;
+	}
+	return -EINPROGRESS;
+}
+
+static struct ahash_alg hash_algs[] = {
+{
+	.init		= sep_sha1_init,
+	.update		= sep_sha1_update,
+	.final		= sep_sha1_final,
+	.digest		= sep_sha1_digest,
+	.halg		= {
+		.digestsize	= SHA1_DIGEST_SIZE,
+		.base	= {
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
+		}
+	}
+},
+{
+	.init		= sep_md5_init,
+	.update		= sep_md5_update,
+	.final		= sep_md5_final,
+	.digest		= sep_md5_digest,
+	.halg		= {
+		.digestsize	= MD5_DIGEST_SIZE,
+		.base	= {
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
+		}
+	}
+},
+{
+	.init		= sep_sha224_init,
+	.update		= sep_sha224_update,
+	.final		= sep_sha224_final,
+	.digest		= sep_sha224_digest,
+	.halg		= {
+		.digestsize	= SHA224_DIGEST_SIZE,
+		.base	= {
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
+		}
+	}
+},
+{
+	.init		= sep_sha256_init,
+	.update		= sep_sha256_update,
+	.final		= sep_sha256_final,
+	.digest		= sep_sha256_digest,
+	.halg		= {
+		.digestsize	= SHA256_DIGEST_SIZE,
+		.base	= {
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
+		}
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
+
+int sep_crypto_setup(void)
+{
+	int err, i, j, k;
+	tasklet_init(&sep_dev->finish_tasklet, sep_finish,
+		(unsigned long)sep_dev);
+
+	crypto_init_queue(&sep_queue, SEP_QUEUE_LENGTH);
+
+	sep_dev->workqueue = create_workqueue("sep_crypto_workqueue");
+	if (!sep_dev->workqueue) {
+		dev_warn(&sep_dev->pdev->dev, "cant create workqueue\n");
+		return -ENOMEM;
+	}
+
+	i = 0;
+	j = 0;
+
+	spin_lock_init(&sep_dev->busy_lock);
+	spin_lock_init(&queue_lock);
+
+	err = 0;
+
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
+			goto err_crypto_algs;
+	}
+
+	return err;
+
+err_algs:
+	for (k = 0; k < i; k++)
+		crypto_unregister_ahash(&hash_algs[k]);
+	return err;
+
+err_crypto_algs:
+	for (k = 0; k < j; k++)
+		crypto_unregister_alg(&crypto_algs[k]);
+	goto err_algs;
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
diff --git a/drivers/staging/sep/sep_crypto.h b/drivers/staging/sep/sep_crypto.h
new file mode 100644
index 0000000..52c58c4
--- /dev/null
+++ b/drivers/staging/sep/sep_crypto.h
@@ -0,0 +1,348 @@
+/*
+ *
+ *  sep_crypto.h - Crypto interface structures
+ *
+ *  Copyright(c) 2009-2011 Intel Corporation. All rights reserved.
+ *  Contributions(c) 2009-2010 Discretix. All rights reserved.
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
+ *  2011.02.22  Enable Kernel Crypto
+ *
+ */
+
+/* Constants for SEP (from vendor) */
+#define SEP_START_MSG_TOKEN	0x02558808
+
+#define SEP_DES_IV_SIZE_WORDS	2
+#define SEP_DES_IV_SIZE_BYTES	(SEP_DES_IV_SIZE_WORDS * \
+	sizeof(u32))
+#define SEP_DES_KEY_SIZE_WORDS	2
+#define SEP_DES_KEY_SIZE_BYTES	(SEP_DES_KEY_SIZE_WORDS * \
+	sizeof(u32))
+#define SEP_DES_BLOCK_SIZE	8
+#define SEP_DES_DUMMY_SIZE	16
+
+#define SEP_DES_INIT_OPCODE	0x10
+#define SEP_DES_BLOCK_OPCODE	0x11
+
+#define SEP_AES_BLOCK_SIZE_WORDS 4
+#define SEP_AES_BLOCK_SIZE_BYTES \
+	(SEP_AES_BLOCK_SIZE_WORDS * sizeof(u32))
+
+#define SEP_AES_DUMMY_BLOCK_SIZE 16
+#define SEP_AES_IV_SIZE_WORDS	SEP_AES_BLOCK_SIZE_WORDS
+#define SEP_AES_IV_SIZE_BYTES \
+	(SEP_AES_IV_SIZE_WORDS * sizeof(u32))
+
+#define SEP_AES_KEY_128_SIZE	16
+#define SEP_AES_KEY_192_SIZE	24
+#define SEP_AES_KEY_256_SIZE	32
+#define SEP_AES_KEY_512_SIZE	64
+#define SEP_AES_MAX_KEY_SIZE_WORDS	16
+#define SEP_AES_MAX_KEY_SIZE_BYTES \
+	(SEP_AES_MAX_KEY_SIZE_WORDS * sizeof(u32))
+
+#define SEP_AES_WRAP_MIN_SIZE	8
+#define SEP_AES_WRAP_MAX_SIZE	0x10000000
+
+#define SEP_AES_WRAP_BLOCK_SIZE_WORDS	2
+#define SEP_AES_WRAP_BLOCK_SIZE_BYTES \
+	(SEP_AES_WRAP_BLOCK_SIZE_WORDS * sizeof(u32))
+
+#define SEP_AES_SECRET_RKEK1		0x1
+#define SEP_AES_SECRET_RKEK2		0x2
+
+#define SEP_AES_INIT_OPCODE		0x2
+#define SEP_AES_BLOCK_OPCODE		0x3
+#define SEP_AES_FINISH_OPCODE		0x4
+#define SEP_AES_WRAP_OPCODE		0x6
+#define SEP_AES_UNWRAP_OPCODE		0x7
+#define SEP_AES_XTS_FINISH_OPCODE	0x8
+
+#define SEP_HASH_RESULT_SIZE_WORDS	16
+#define SEP_MD5_DIGEST_SIZE_WORDS	4
+#define SEP_MD5_DIGEST_SIZE_BYTES \
+	(SEP_MD5_DIGEST_SIZE_WORDS * sizeof(u32))
+#define SEP_SHA1_DIGEST_SIZE_WORDS	5
+#define SEP_SHA1_DIGEST_SIZE_BYTES \
+	(SEP_SHA1_DIGEST_SIZE_WORDS * sizeof(u32))
+#define SEP_SHA224_DIGEST_SIZE_WORDS	7
+#define SEP_SHA224_DIGEST_SIZE_BYTES \
+	(SEP_SHA224_DIGEST_SIZE_WORDS * sizeof(u32))
+#define SEP_SHA256_DIGEST_SIZE_WORDS	8
+#define SEP_SHA256_DIGEST_SIZE_BYTES \
+	(SEP_SHA256_DIGEST_SIZE_WORDS * sizeof(u32))
+#define SEP_SHA384_DIGEST_SIZE_WORDS	12
+#define SEP_SHA384_DIGEST_SIZE_BYTES \
+	(SEP_SHA384_DIGEST_SIZE_WORDS * sizeof(u32))
+#define SEP_SHA512_DIGEST_SIZE_WORDS	16
+#define SEP_SHA512_DIGEST_SIZE_BYTES \
+	(SEP_SHA512_DIGEST_SIZE_WORDS * sizeof(u32))
+#define SEP_HASH_BLOCK_SIZE_WORDS	16
+#define SEP_HASH_BLOCK_SIZE_BYTES \
+	(SEP_HASH_BLOCK_SIZE_WORDS * sizeof(u32))
+#define SEP_SHA2_BLOCK_SIZE_WORDS	32
+#define SEP_SHA2_BLOCK_SIZE_BYTES \
+	(SEP_SHA2_BLOCK_SIZE_WORDS * sizeof(u32))
+
+#define SEP_HASH_INIT_OPCODE		0x20
+#define SEP_HASH_UPDATE_OPCODE		0x21
+#define SEP_HASH_FINISH_OPCODE		0x22
+#define SEP_HASH_SINGLE_OPCODE		0x23
+
+#define SEP_HOST_ERROR		0x0b000000
+#define SEP_OK			0x0
+#define SEP_INVALID_START	(SEP_HOST_ERROR + 0x3)
+#define SEP_WRONG_OPCODE	(SEP_HOST_ERROR + 0x1)
+
+#define SEP_TRANSACTION_WAIT_TIME 5
+
+#define SEP_QUEUE_LENGTH	10
+/* Macros */
+#ifndef __LITTLE_ENDIAN
+#define CHG_ENDIAN(val) \
+	(((val) >> 24) | \
+	(((val) & 0x00FF0000) >> 8) | \
+	(((val) & 0x0000FF00) << 8) | \
+	(((val) & 0x000000FF) << 24))
+#else
+#define CHG_ENDIAN(val) val
+#endif
+/* Enums for SEP (from vendor) */
+enum des_numkey {
+	DES_KEY_1 = 1,
+	DES_KEY_2 = 2,
+	DES_KEY_3 = 3,
+	SEP_NUMKEY_OPTIONS,
+	SEP_NUMKEY_LAST = 0x7fffffff,
+};
+
+enum des_enc_mode {
+	SEP_DES_ENCRYPT = 0,
+	SEP_DES_DECRYPT = 1,
+	SEP_DES_ENC_OPTIONS,
+	SEP_DES_ENC_LAST = 0x7fffffff,
+};
+
+enum des_op_mode {
+	SEP_DES_ECB = 0,
+	SEP_DES_CBC = 1,
+	SEP_OP_OPTIONS,
+	SEP_OP_LAST = 0x7fffffff,
+};
+
+enum aes_keysize {
+	AES_128 = 0,
+	AES_192 = 1,
+	AES_256 = 2,
+	AES_512 = 3,
+	AES_SIZE_OPTIONS,
+	AEA_SIZE_LAST = 0x7FFFFFFF,
+};
+
+enum aes_enc_mode {
+	SEP_AES_ENCRYPT = 0,
+	SEP_AES_DECRYPT = 1,
+	SEP_AES_ENC_OPTIONS,
+	SEP_AES_ENC_LAST = 0x7FFFFFFF,
+};
+
+enum aes_op_mode {
+	SEP_AES_ECB = 0,
+	SEP_AES_CBC = 1,
+	SEP_AES_MAC = 2,
+	SEP_AES_CTR = 3,
+	SEP_AES_XCBC = 4,
+	SEP_AES_CMAC = 5,
+	SEP_AES_XTS = 6,
+	SEP_AES_OP_OPTIONS,
+	SEP_AES_OP_LAST = 0x7FFFFFFF,
+};
+
+enum hash_op_mode {
+	SEP_HASH_SHA1 = 0,
+	SEP_HASH_SHA224 = 1,
+	SEP_HASH_SHA256 = 2,
+	SEP_HASH_SHA384 = 3,
+	SEP_HASH_SHA512 = 4,
+	SEP_HASH_MD5 = 5,
+	SEP_HASH_OPTIONS,
+	SEP_HASH_LAST_MODE = 0x7FFFFFFF,
+};
+
+/* Structures for SEP (from vendor) */
+struct sep_des_internal_key {
+	u32 key1[SEP_DES_KEY_SIZE_WORDS];
+	u32 key2[SEP_DES_KEY_SIZE_WORDS];
+	u32 key3[SEP_DES_KEY_SIZE_WORDS];
+};
+
+struct sep_des_internal_context {
+	u32 iv_context[SEP_DES_IV_SIZE_WORDS];
+	struct sep_des_internal_key context_key;
+	enum des_numkey nbr_keys;
+	enum des_enc_mode encryption;
+	enum des_op_mode operation;
+	u8 dummy_block[SEP_DES_DUMMY_SIZE];
+};
+
+struct sep_des_private_context {
+	u32 valid_tag;
+	u32 iv;
+	u8 ctx_buf[sizeof(struct sep_des_internal_context)];
+};
+
+/* This is the structure passed to SEP via msg area */
+struct sep_des_key {
+	u32 key1[SEP_DES_KEY_SIZE_WORDS];
+	u32 key2[SEP_DES_KEY_SIZE_WORDS];
+	u32 key3[SEP_DES_KEY_SIZE_WORDS];
+	u32 pad[SEP_DES_KEY_SIZE_WORDS];
+};
+
+struct sep_aes_internal_context {
+	u32 aes_ctx_iv[SEP_AES_IV_SIZE_WORDS];
+	u32 aes_ctx_key[SEP_AES_MAX_KEY_SIZE_WORDS / 2];
+	enum aes_keysize keysize;
+	enum aes_enc_mode encmode;
+	enum aes_op_mode opmode;
+	u8 secret_key;
+	u32 no_add_blocks;
+	u32 last_block_size;
+	u32 last_block[SEP_AES_BLOCK_SIZE_WORDS];
+	u32 prev_iv[SEP_AES_BLOCK_SIZE_WORDS];
+	u32 remaining_size;
+	union {
+		struct {
+			u32 dkey1[SEP_AES_BLOCK_SIZE_WORDS];
+			u32 dkey2[SEP_AES_BLOCK_SIZE_WORDS];
+			u32 dkey3[SEP_AES_BLOCK_SIZE_WORDS];
+		} cmac_data;
+		struct {
+			u32 xts_key[SEP_AES_MAX_KEY_SIZE_WORDS / 2];
+			u32 temp1[SEP_AES_BLOCK_SIZE_WORDS];
+			u32 temp2[SEP_AES_BLOCK_SIZE_WORDS];
+		} xtx_data;
+	} s_data;
+	u8 dummy_block[SEP_AES_DUMMY_BLOCK_SIZE];
+};
+
+struct sep_aes_private_context {
+	u32 valid_tag;
+	u32 aes_iv;
+	u32 op_mode;
+	u8 cbuff[sizeof(struct sep_aes_internal_context)];
+};
+
+struct sep_hash_internal_context {
+	u32 hash_result[SEP_HASH_RESULT_SIZE_WORDS];
+	enum hash_op_mode hash_opmode;
+	u32 previous_data[SEP_SHA2_BLOCK_SIZE_WORDS];
+	u16 prev_update_bytes;
+	u32 total_proc_128bit[4];
+	u16 op_mode_block_size;
+	u8 dummy_aes_block[SEP_AES_DUMMY_BLOCK_SIZE];
+};
+
+struct sep_hash_private_context {
+	u32 valid_tag;
+	u32 iv;
+	u8 internal_context[sizeof(struct sep_hash_internal_context)];
+};
+
+/* Context structures for crypto API */
+struct sep_block_ctx {
+	struct sep_device *sep;
+	u32 done;
+	unsigned char iv[100];
+	enum des_enc_mode des_encmode;
+	enum des_op_mode des_opmode;
+	enum aes_enc_mode aes_encmode;
+	enum aes_op_mode aes_opmode;
+	u32 init_opcode;
+	u32 block_opcode;
+	size_t data_length;
+	size_t ivlen;
+	struct ablkcipher_walk walk;
+	struct sep_des_private_context des_private_ctx;
+	struct sep_aes_private_context aes_private_ctx;
+	};
+
+struct sep_hash_ctx {
+	u32 done;
+	unsigned char *buf;
+	size_t buflen;
+	unsigned char *dgst;
+	int digest_size_words;
+	int digest_size_bytes;
+	int block_size_words;
+	int block_size_bytes;
+	struct scatterlist *sg;
+	enum hash_op_mode hash_opmode;
+	struct sep_hash_private_context hash_private_ctx;
+	};
+
+struct sep_system_ctx {
+	struct sep_device *sep_used;
+	union key_t {
+		struct sep_des_key des;
+		u32 aes[SEP_AES_MAX_KEY_SIZE_WORDS];
+	} key;
+	int i_own_sep; /* Do I have custody of the sep? */
+	size_t keylen;
+	enum des_numkey des_nbr_keys;
+	enum aes_keysize aes_key_size;
+	u32 key_sent; /* Indicate if key is sent to sep */
+	u32 last_block; /* Indicate that this is the final block */
+	struct sep_call_status call_status;
+	struct build_dcb_struct_kernel dcb_input_data;
+	struct sep_dma_context *dma_ctx;
+	void *dmatables_region;
+	size_t nbytes;
+	struct sep_dcblock *dcb_region;
+	struct sep_queue_info *queue_elem;
+	int msg_len_words;
+	unsigned char msg[SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES];
+	void *msgptr;
+	struct scatterlist *src_sg;
+	struct scatterlist *dst_sg;
+	struct scatterlist *src_sg_hold;
+	struct scatterlist *dst_sg_hold;
+	struct ahash_request *current_hash_req;
+	struct ablkcipher_request *current_cypher_req;
+	enum type_of_request current_request;
+	enum hash_stage current_hash_stage;
+	int done_with_transaction;
+	unsigned long end_time;
+	};
+
+/* work queue structures */
+struct sep_work_struct {
+	struct work_struct work;
+	void (*callback)(void *);
+	void *data;
+	};
+
+/* Functions */
+int sep_crypto_setup(void);
+void sep_crypto_takedown(void);
diff --git a/drivers/staging/sep/sep_dev.h b/drivers/staging/sep/sep_dev.h
index 696ab0d..66d8e95 100644
--- a/drivers/staging/sep/sep_dev.h
+++ b/drivers/staging/sep/sep_dev.h
@@ -5,8 +5,8 @@
  *
  *  sep_dev.h - Security Processor Device Structures
  *
- *  Copyright(c) 2009,2010 Intel Corporation. All rights reserved.
- *  Contributions(c) 2009,2010 Discretix. All rights reserved.
+ *  Copyright(c) 2009-2011 Intel Corporation. All rights reserved.
+ *  Contributions(c) 2009-2011 Discretix. All rights reserved.
  *
  *  This program is free software; you can redistribute it and/or modify it
  *  under the terms of the GNU General Public License as published by the Free
@@ -28,6 +28,7 @@
  *
  *  CHANGES
  *  2010.09.14  upgrade to Medfield
+ *  2011.02.22  enable kernel crypto
  */
 
 struct sep_device {
@@ -36,33 +37,21 @@ struct sep_device {
 
 	/* character device file */
 	struct cdev sep_cdev;
-	struct cdev sep_daemon_cdev;
-	struct cdev sep_singleton_cdev;
 
 	/* devices (using misc dev) */
 	struct miscdevice miscdev_sep;
-	struct miscdevice miscdev_singleton;
-	struct miscdevice miscdev_daemon;
 
 	/* major / minor numbers of device */
 	dev_t sep_devno;
-	dev_t sep_daemon_devno;
-	dev_t sep_singleton_devno;
-
-	struct mutex sep_mutex;
-	struct mutex ioctl_mutex;
+	/* guards command sent counter */
 	spinlock_t snd_rply_lck;
+	/* guards driver memory usage in fastcall if */
+	struct semaphore sep_doublebuf;
 
 	/* flags to indicate use and lock status of sep */
 	u32 pid_doing_transaction;
 	unsigned long in_use_flags;
 
-	/* request daemon alread open */
-	unsigned long request_daemon_open;
-
-	/* 1 = Moorestown; 0 = Medfield */
-	int mrst;
-
 	/* address of the shared memory allocated during init for SEP driver
 	   (coherent alloc) */
 	dma_addr_t shared_bus;
@@ -74,36 +63,78 @@ struct sep_device {
 	dma_addr_t reg_physical_end;
 	void __iomem *reg_addr;
 
-	/* wait queue head (event) of the driver */
-	wait_queue_head_t event;
-	wait_queue_head_t event_request_daemon;
-	wait_queue_head_t event_mmap;
+	/* wait queue heads of the driver */
+	wait_queue_head_t event_interrupt;
+	wait_queue_head_t event_transactions;
 
-	struct sep_caller_id_entry
-		caller_id_table[SEP_CALLER_ID_TABLE_NUM_ENTRIES];
+	struct list_head sep_queue_status;
+	u32 sep_queue_num;
+	spinlock_t sep_queue_lock;
 
-	/* access flag for singleton device */
-	unsigned long singleton_access_flag;
+	/* Is this in use? */
+	u32 in_use;
+
+	/* indicates whether power save is set up */
+	u32 power_save_setup;
+
+	/* Power state */
+	u32 power_state;
 
 	/* transaction counter that coordinates the
 	   transactions between SEP and HOST */
 	unsigned long send_ct;
 	/* counter for the messages from sep */
 	unsigned long reply_ct;
-	/* counter for the number of bytes allocated in the pool for the
-	   current transaction */
-	long data_pool_bytes_allocated;
 
-	u32 num_of_data_allocations;
+	/* The following are used for kernel crypto client requests */
+	u32 in_kernel; /* Set for kernel client request */
+	struct tasklet_struct	finish_tasklet;
+	enum type_of_request current_request;
+	enum hash_stage	current_hash_stage;
+	struct ahash_request	*current_hash_req;
+	struct ablkcipher_request *current_cypher_req;
+	struct sep_system_ctx *sctx;
+	spinlock_t		busy_lock;
+	struct workqueue_struct	*workqueue;
+};
 
-	/* number of the lli tables created in the current transaction */
-	u32     num_lli_tables_created;
+extern struct sep_device *sep_dev;
 
-	/* number of data control blocks */
-	u32 nr_dcb_creat;
+/**
+ * SEP message header for a transaction
+ * @reserved: reserved memory (two words)
+ * @token: SEP message token
+ * @msg_len: message length
+ * @opcpde: message opcode
+ */
+struct sep_msgarea_hdr {
+	u32 reserved[2];
+	u32 token;
+	u32 msg_len;
+	u32 opcode;
+};
 
-	struct sep_dma_resource dma_res_arr[SEP_MAX_NUM_SYNC_DMA_OPS];
+/**
+ * sep_queue_data - data to be maintained in status queue for a transaction
+ * @opcode : transaction opcode
+ * @size : message size
+ * @pid: owner process
+ * @name: owner process name
+ */
+struct sep_queue_data {
+	u32 opcode;
+	u32 size;
+	s32 pid;
+	u8 name[TASK_COMM_LEN];
+};
 
+/** sep_queue_info - maintains status info of all transactions
+ * @list: head of list
+ * @sep_queue_data : data for transaction
+ */
+struct sep_queue_info {
+	struct list_head list;
+	struct sep_queue_data data;
 };
 
 static inline void sep_write_reg(struct sep_device *dev, int reg, u32 value)
diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
deleted file mode 100644
index 6b3d156..0000000
--- a/drivers/staging/sep/sep_driver.c
+++ /dev/null
@@ -1,2932 +0,0 @@
-/*
- *
- *  sep_driver.c - Security Processor Driver main group of functions
- *
- *  Copyright(c) 2009,2010 Intel Corporation. All rights reserved.
- *  Contributions(c) 2009,2010 Discretix. All rights reserved.
- *
- *  This program is free software; you can redistribute it and/or modify it
- *  under the terms of the GNU General Public License as published by the Free
- *  Software Foundation; version 2 of the License.
- *
- *  This program is distributed in the hope that it will be useful, but WITHOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- *  more details.
- *
- *  You should have received a copy of the GNU General Public License along with
- *  this program; if not, write to the Free Software Foundation, Inc., 59
- *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
- *
- *  CONTACTS:
- *
- *  Mark Allyn		mark.a.allyn@intel.com
- *  Jayant Mangalampalli jayant.mangalampalli@intel.com
- *
- *  CHANGES:
- *
- *  2009.06.26	Initial publish
- *  2010.09.14  Upgrade to Medfield
- *
- */
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/miscdevice.h>
-#include <linux/fs.h>
-#include <linux/cdev.h>
-#include <linux/kdev_t.h>
-#include <linux/mutex.h>
-#include <linux/sched.h>
-#include <linux/mm.h>
-#include <linux/poll.h>
-#include <linux/wait.h>
-#include <linux/pci.h>
-#include <linux/firmware.h>
-#include <linux/slab.h>
-#include <linux/ioctl.h>
-#include <asm/current.h>
-#include <linux/ioport.h>
-#include <linux/io.h>
-#include <linux/interrupt.h>
-#include <linux/pagemap.h>
-#include <asm/cacheflush.h>
-#include <linux/delay.h>
-#include <linux/jiffies.h>
-#include <linux/rar_register.h>
-
-#include "sep_driver_hw_defs.h"
-#include "sep_driver_config.h"
-#include "sep_driver_api.h"
-#include "sep_dev.h"
-
-/*----------------------------------------
-	DEFINES
------------------------------------------*/
-
-#define SEP_RAR_IO_MEM_REGION_SIZE 0x40000
-
-/*--------------------------------------------
-	GLOBAL variables
---------------------------------------------*/
-
-/* Keep this a single static object for now to keep the conversion easy */
-
-static struct sep_device *sep_dev;
-
-/**
- *	sep_dump_message - dump the message that is pending
- *	@sep: SEP device
- */
-static void sep_dump_message(struct sep_device *sep)
-{
-	int count;
-	u32 *p = sep->shared_addr;
-	for (count = 0; count < 12 * 4; count += 4)
-		dev_dbg(&sep->pdev->dev, "Word %d of the message is %x\n",
-								count, *p++);
-}
-
-/**
- *	sep_map_and_alloc_shared_area -	allocate shared block
- *	@sep: security processor
- *	@size: size of shared area
- */
-static int sep_map_and_alloc_shared_area(struct sep_device *sep)
-{
-	sep->shared_addr = dma_alloc_coherent(&sep->pdev->dev,
-		sep->shared_size,
-		&sep->shared_bus, GFP_KERNEL);
-
-	if (!sep->shared_addr) {
-		dev_warn(&sep->pdev->dev,
-			"shared memory dma_alloc_coherent failed\n");
-		return -ENOMEM;
-	}
-	dev_dbg(&sep->pdev->dev,
-		"shared_addr %zx bytes @%p (bus %llx)\n",
-				sep->shared_size, sep->shared_addr,
-				(unsigned long long)sep->shared_bus);
-	return 0;
-}
-
-/**
- *	sep_unmap_and_free_shared_area - free shared block
- *	@sep: security processor
- */
-static void sep_unmap_and_free_shared_area(struct sep_device *sep)
-{
-	dma_free_coherent(&sep->pdev->dev, sep->shared_size,
-				sep->shared_addr, sep->shared_bus);
-}
-
-/**
- *	sep_shared_bus_to_virt - convert bus/virt addresses
- *	@sep: pointer to struct sep_device
- *	@bus_address: address to convert
- *
- *	Returns virtual address inside the shared area according
- *	to the bus address.
- */
-static void *sep_shared_bus_to_virt(struct sep_device *sep,
-						dma_addr_t bus_address)
-{
-	return sep->shared_addr + (bus_address - sep->shared_bus);
-}
-
-/**
- *	open function for the singleton driver
- *	@inode_ptr struct inode *
- *	@file_ptr struct file *
- *
- *	Called when the user opens the singleton device interface
- */
-static int sep_singleton_open(struct inode *inode_ptr, struct file *file_ptr)
-{
-	struct sep_device *sep;
-
-	/*
-	 * Get the SEP device structure and use it for the
-	 * private_data field in filp for other methods
-	 */
-	sep = sep_dev;
-
-	file_ptr->private_data = sep;
-
-	if (test_and_set_bit(0, &sep->singleton_access_flag))
-		return -EBUSY;
-	return 0;
-}
-
-/**
- *	sep_open - device open method
- *	@inode: inode of SEP device
- *	@filp: file handle to SEP device
- *
- *	Open method for the SEP device. Called when userspace opens
- *	the SEP device node.
- *
- *	Returns zero on success otherwise an error code.
- */
-static int sep_open(struct inode *inode, struct file *filp)
-{
-	struct sep_device *sep;
-
-	/*
-	 * Get the SEP device structure and use it for the
-	 * private_data field in filp for other methods
-	 */
-	sep = sep_dev;
-	filp->private_data = sep;
-
-	/* Anyone can open; locking takes place at transaction level */
-	return 0;
-}
-
-/**
- *	sep_singleton_release - close a SEP singleton device
- *	@inode: inode of SEP device
- *	@filp: file handle being closed
- *
- *	Called on the final close of a SEP device. As the open protects against
- *	multiple simultaenous opens that means this method is called when the
- *	final reference to the open handle is dropped.
- */
-static int sep_singleton_release(struct inode *inode, struct file *filp)
-{
-	struct sep_device *sep = filp->private_data;
-
-	clear_bit(0, &sep->singleton_access_flag);
-	return 0;
-}
-
-/**
- *	sep_request_daemon_open - request daemon open method
- *	@inode: inode of SEP device
- *	@filp: file handle to SEP device
- *
- *	Open method for the SEP request daemon. Called when
- *	request daemon in userspace opens the SEP device node.
- *
- *	Returns zero on success otherwise an error code.
- */
-static int sep_request_daemon_open(struct inode *inode, struct file *filp)
-{
-	struct sep_device *sep = sep_dev;
-	int error = 0;
-
-	filp->private_data = sep;
-
-	/* There is supposed to be only one request daemon */
-	if (test_and_set_bit(0, &sep->request_daemon_open))
-		error = -EBUSY;
-	return error;
-}
-
-/**
- *	sep_request_daemon_release - close a SEP daemon
- *	@inode: inode of SEP device
- *	@filp: file handle being closed
- *
- *	Called on the final close of a SEP daemon.
- */
-static int sep_request_daemon_release(struct inode *inode, struct file *filp)
-{
-	struct sep_device *sep = filp->private_data;
-
-	dev_dbg(&sep->pdev->dev, "Request daemon release for pid %d\n",
-		current->pid);
-
-	/* Clear the request_daemon_open flag */
-	clear_bit(0, &sep->request_daemon_open);
-	return 0;
-}
-
-/**
- *	sep_req_daemon_send_reply_command_handler - poke the SEP
- *	@sep: struct sep_device *
- *
- *	This function raises interrupt to SEPm that signals that is has a
- *	new command from HOST
- */
-static int sep_req_daemon_send_reply_command_handler(struct sep_device *sep)
-{
-	unsigned long lck_flags;
-
-	sep_dump_message(sep);
-
-	/* Counters are lockable region */
-	spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
-	sep->send_ct++;
-	sep->reply_ct++;
-
-	/* Send the interrupt to SEP */
-	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR2_REG_ADDR, sep->send_ct);
-	sep->send_ct++;
-
-	spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
-
-	dev_dbg(&sep->pdev->dev,
-		"sep_req_daemon_send_reply send_ct %lx reply_ct %lx\n",
-		sep->send_ct, sep->reply_ct);
-
-	return 0;
-}
-
-
-/**
- *	sep_free_dma_table_data_handler - free DMA table
- *	@sep: pointere to struct sep_device
- *
- *	Handles the request to  free DMA table for synchronic actions
- */
-static int sep_free_dma_table_data_handler(struct sep_device *sep)
-{
-	int count;
-	int dcb_counter;
-	/* Pointer to the current dma_resource struct */
-	struct sep_dma_resource *dma;
-
-	for (dcb_counter = 0; dcb_counter < sep->nr_dcb_creat; dcb_counter++) {
-		dma = &sep->dma_res_arr[dcb_counter];
-
-		/* Unmap and free input map array */
-		if (dma->in_map_array) {
-			for (count = 0; count < dma->in_num_pages; count++) {
-				dma_unmap_page(&sep->pdev->dev,
-					dma->in_map_array[count].dma_addr,
-					dma->in_map_array[count].size,
-					DMA_TO_DEVICE);
-			}
-			kfree(dma->in_map_array);
-		}
-
-		/* Unmap output map array, DON'T free it yet */
-		if (dma->out_map_array) {
-			for (count = 0; count < dma->out_num_pages; count++) {
-				dma_unmap_page(&sep->pdev->dev,
-					dma->out_map_array[count].dma_addr,
-					dma->out_map_array[count].size,
-					DMA_FROM_DEVICE);
-			}
-			kfree(dma->out_map_array);
-		}
-
-		/* Free page cache for output */
-		if (dma->in_page_array) {
-			for (count = 0; count < dma->in_num_pages; count++) {
-				flush_dcache_page(dma->in_page_array[count]);
-				page_cache_release(dma->in_page_array[count]);
-			}
-			kfree(dma->in_page_array);
-		}
-
-		if (dma->out_page_array) {
-			for (count = 0; count < dma->out_num_pages; count++) {
-				if (!PageReserved(dma->out_page_array[count]))
-					SetPageDirty(dma->out_page_array[count]);
-				flush_dcache_page(dma->out_page_array[count]);
-				page_cache_release(dma->out_page_array[count]);
-			}
-			kfree(dma->out_page_array);
-		}
-
-		/* Reset all the values */
-		dma->in_page_array = NULL;
-		dma->out_page_array = NULL;
-		dma->in_num_pages = 0;
-		dma->out_num_pages = 0;
-		dma->in_map_array = NULL;
-		dma->out_map_array = NULL;
-		dma->in_map_num_entries = 0;
-		dma->out_map_num_entries = 0;
-	}
-
-	sep->nr_dcb_creat = 0;
-	sep->num_lli_tables_created = 0;
-
-	return 0;
-}
-
-/**
- *	sep_request_daemon_mmap - maps the shared area to user space
- *	@filp: pointer to struct file
- *	@vma: pointer to vm_area_struct
- *
- *	Called by the kernel when the daemon attempts an mmap() syscall
- *	using our handle.
- */
-static int sep_request_daemon_mmap(struct file  *filp,
-	struct vm_area_struct  *vma)
-{
-	struct sep_device *sep = filp->private_data;
-	dma_addr_t bus_address;
-	int error = 0;
-
-	if ((vma->vm_end - vma->vm_start) > SEP_DRIVER_MMMAP_AREA_SIZE) {
-		error = -EINVAL;
-		goto end_function;
-	}
-
-	/* Get physical address */
-	bus_address = sep->shared_bus;
-
-	if (remap_pfn_range(vma, vma->vm_start, bus_address >> PAGE_SHIFT,
-		vma->vm_end - vma->vm_start, vma->vm_page_prot)) {
-
-		dev_warn(&sep->pdev->dev, "remap_page_range failed\n");
-		error = -EAGAIN;
-		goto end_function;
-	}
-
-end_function:
-	return error;
-}
-
-/**
- *	sep_request_daemon_poll - poll implementation
- *	@sep: struct sep_device * for current SEP device
- *	@filp: struct file * for open file
- *	@wait: poll_table * for poll
- *
- *	Called when our device is part of a poll() or select() syscall
- */
-static unsigned int sep_request_daemon_poll(struct file *filp,
-	poll_table  *wait)
-{
-	u32	mask = 0;
-	/* GPR2 register */
-	u32	retval2;
-	unsigned long lck_flags;
-	struct sep_device *sep = filp->private_data;
-
-	poll_wait(filp, &sep->event_request_daemon, wait);
-
-	dev_dbg(&sep->pdev->dev, "daemon poll: send_ct is %lx reply ct is %lx\n",
-						sep->send_ct, sep->reply_ct);
-
-	spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
-	/* Check if the data is ready */
-	if (sep->send_ct == sep->reply_ct) {
-		spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
-
-		retval2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
-		dev_dbg(&sep->pdev->dev,
-			"daemon poll: data check (GPR2) is %x\n", retval2);
-
-		/* Check if PRINT request */
-		if ((retval2 >> 30) & 0x1) {
-			dev_dbg(&sep->pdev->dev, "daemon poll: PRINTF request in\n");
-			mask |= POLLIN;
-			goto end_function;
-		}
-		/* Check if NVS request */
-		if (retval2 >> 31) {
-			dev_dbg(&sep->pdev->dev, "daemon poll: NVS request in\n");
-			mask |= POLLPRI | POLLWRNORM;
-		}
-	} else {
-		spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
-		dev_dbg(&sep->pdev->dev,
-			"daemon poll: no reply received; returning 0\n");
-		mask = 0;
-	}
-end_function:
-	return mask;
-}
-
-/**
- *	sep_release - close a SEP device
- *	@inode: inode of SEP device
- *	@filp: file handle being closed
- *
- *	Called on the final close of a SEP device.
- */
-static int sep_release(struct inode *inode, struct file *filp)
-{
-	struct sep_device *sep = filp->private_data;
-
-	dev_dbg(&sep->pdev->dev, "Release for pid %d\n", current->pid);
-
-	mutex_lock(&sep->sep_mutex);
-	/* Is this the process that has a transaction open?
-	 * If so, lets reset pid_doing_transaction to 0 and
-	 * clear the in use flags, and then wake up sep_event
-	 * so that other processes can do transactions
-	 */
-	if (sep->pid_doing_transaction == current->pid) {
-		clear_bit(SEP_MMAP_LOCK_BIT, &sep->in_use_flags);
-		clear_bit(SEP_SEND_MSG_LOCK_BIT, &sep->in_use_flags);
-		sep_free_dma_table_data_handler(sep);
-		wake_up(&sep->event);
-		sep->pid_doing_transaction = 0;
-	}
-
-	mutex_unlock(&sep->sep_mutex);
-	return 0;
-}
-
-/**
- *	sep_mmap -  maps the shared area to user space
- *	@filp: pointer to struct file
- *	@vma: pointer to vm_area_struct
- *
- *	Called on an mmap of our space via the normal SEP device
- */
-static int sep_mmap(struct file *filp, struct vm_area_struct *vma)
-{
-	dma_addr_t bus_addr;
-	struct sep_device *sep = filp->private_data;
-	unsigned long error = 0;
-
-	/* Set the transaction busy (own the device) */
-	wait_event_interruptible(sep->event,
-		test_and_set_bit(SEP_MMAP_LOCK_BIT,
-		&sep->in_use_flags) == 0);
-
-	if (signal_pending(current)) {
-		error = -EINTR;
-		goto end_function_with_error;
-	}
-	/*
-	 * The pid_doing_transaction indicates that this process
-	 * now owns the facilities to performa a transaction with
-	 * the SEP. While this process is performing a transaction,
-	 * no other process who has the SEP device open can perform
-	 * any transactions. This method allows more than one process
-	 * to have the device open at any given time, which provides
-	 * finer granularity for device utilization by multiple
-	 * processes.
-	 */
-	mutex_lock(&sep->sep_mutex);
-	sep->pid_doing_transaction = current->pid;
-	mutex_unlock(&sep->sep_mutex);
-
-	/* Zero the pools and the number of data pool alocation pointers */
-	sep->data_pool_bytes_allocated = 0;
-	sep->num_of_data_allocations = 0;
-
-	/*
-	 * Check that the size of the mapped range is as the size of the message
-	 * shared area
-	 */
-	if ((vma->vm_end - vma->vm_start) > SEP_DRIVER_MMMAP_AREA_SIZE) {
-		error = -EINVAL;
-		goto end_function_with_error;
-	}
-
-	dev_dbg(&sep->pdev->dev, "shared_addr is %p\n", sep->shared_addr);
-
-	/* Get bus address */
-	bus_addr = sep->shared_bus;
-
-	if (remap_pfn_range(vma, vma->vm_start, bus_addr >> PAGE_SHIFT,
-		vma->vm_end - vma->vm_start, vma->vm_page_prot)) {
-		dev_warn(&sep->pdev->dev, "remap_page_range failed\n");
-		error = -EAGAIN;
-		goto end_function_with_error;
-	}
-	goto end_function;
-
-end_function_with_error:
-	/* Clear the bit */
-	clear_bit(SEP_MMAP_LOCK_BIT, &sep->in_use_flags);
-	mutex_lock(&sep->sep_mutex);
-	sep->pid_doing_transaction = 0;
-	mutex_unlock(&sep->sep_mutex);
-
-	/* Raise event for stuck contextes */
-
-	wake_up(&sep->event);
-
-end_function:
-	return error;
-}
-
-/**
- *	sep_poll - poll handler
- *	@filp: pointer to struct file
- *	@wait: pointer to poll_table
- *
- *	Called by the OS when the kernel is asked to do a poll on
- *	a SEP file handle.
- */
-static unsigned int sep_poll(struct file *filp, poll_table *wait)
-{
-	u32 mask = 0;
-	u32 retval = 0;
-	u32 retval2 = 0;
-	unsigned long lck_flags;
-
-	struct sep_device *sep = filp->private_data;
-
-	/* Am I the process that owns the transaction? */
-	mutex_lock(&sep->sep_mutex);
-	if (current->pid != sep->pid_doing_transaction) {
-		dev_dbg(&sep->pdev->dev, "poll; wrong pid\n");
-		mask = POLLERR;
-		mutex_unlock(&sep->sep_mutex);
-		goto end_function;
-	}
-	mutex_unlock(&sep->sep_mutex);
-
-	/* Check if send command or send_reply were activated previously */
-	if (!test_bit(SEP_SEND_MSG_LOCK_BIT, &sep->in_use_flags)) {
-		mask = POLLERR;
-		goto end_function;
-	}
-
-	/* Add the event to the polling wait table */
-	dev_dbg(&sep->pdev->dev, "poll: calling wait sep_event\n");
-
-	poll_wait(filp, &sep->event, wait);
-
-	dev_dbg(&sep->pdev->dev, "poll: send_ct is %lx reply ct is %lx\n",
-		sep->send_ct, sep->reply_ct);
-
-	/* Check if error occurred during poll */
-	retval2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
-	if (retval2 != 0x0) {
-		dev_warn(&sep->pdev->dev, "poll; poll error %x\n", retval2);
-		mask |= POLLERR;
-		goto end_function;
-	}
-
-	spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
-
-	if (sep->send_ct == sep->reply_ct) {
-		spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
-		retval = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
-		dev_dbg(&sep->pdev->dev, "poll: data ready check (GPR2)  %x\n",
-			retval);
-
-		/* Check if printf request  */
-		if ((retval >> 30) & 0x1) {
-			dev_dbg(&sep->pdev->dev, "poll: SEP printf request\n");
-			wake_up(&sep->event_request_daemon);
-			goto end_function;
-		}
-
-		/* Check if the this is SEP reply or request */
-		if (retval >> 31) {
-			dev_dbg(&sep->pdev->dev, "poll: SEP request\n");
-			wake_up(&sep->event_request_daemon);
-		} else {
-			dev_dbg(&sep->pdev->dev, "poll: normal return\n");
-			/* In case it is again by send_reply_comand */
-			clear_bit(SEP_SEND_MSG_LOCK_BIT, &sep->in_use_flags);
-			sep_dump_message(sep);
-			dev_dbg(&sep->pdev->dev,
-				"poll; SEP reply POLLIN | POLLRDNORM\n");
-			mask |= POLLIN | POLLRDNORM;
-		}
-	} else {
-		spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
-		dev_dbg(&sep->pdev->dev,
-			"poll; no reply received; returning mask of 0\n");
-		mask = 0;
-	}
-
-end_function:
-	return mask;
-}
-
-/**
- *	sep_time_address - address in SEP memory of time
- *	@sep: SEP device we want the address from
- *
- *	Return the address of the two dwords in memory used for time
- *	setting.
- */
-static u32 *sep_time_address(struct sep_device *sep)
-{
-	return sep->shared_addr + SEP_DRIVER_SYSTEM_TIME_MEMORY_OFFSET_IN_BYTES;
-}
-
-/**
- *	sep_set_time - set the SEP time
- *	@sep: the SEP we are setting the time for
- *
- *	Calculates time and sets it at the predefined address.
- *	Called with the SEP mutex held.
- */
-static unsigned long sep_set_time(struct sep_device *sep)
-{
-	struct timeval time;
-	u32 *time_addr;	/* Address of time as seen by the kernel */
-
-
-	do_gettimeofday(&time);
-
-	/* Set value in the SYSTEM MEMORY offset */
-	time_addr = sep_time_address(sep);
-
-	time_addr[0] = SEP_TIME_VAL_TOKEN;
-	time_addr[1] = time.tv_sec;
-
-	dev_dbg(&sep->pdev->dev, "time.tv_sec is %lu\n", time.tv_sec);
-	dev_dbg(&sep->pdev->dev, "time_addr is %p\n", time_addr);
-	dev_dbg(&sep->pdev->dev, "sep->shared_addr is %p\n", sep->shared_addr);
-
-	return time.tv_sec;
-}
-
-/**
- *	sep_set_caller_id_handler - insert caller id entry
- *	@sep: SEP device
- *	@arg: pointer to struct caller_id_struct
- *
- *	Inserts the data into the caller id table. Note that this function
- *	falls under the ioctl lock
- */
-static int sep_set_caller_id_handler(struct sep_device *sep, unsigned long arg)
-{
-	void __user *hash;
-	int   error = 0;
-	int   i;
-	struct caller_id_struct command_args;
-
-	for (i = 0; i < SEP_CALLER_ID_TABLE_NUM_ENTRIES; i++) {
-		if (sep->caller_id_table[i].pid == 0)
-			break;
-	}
-
-	if (i == SEP_CALLER_ID_TABLE_NUM_ENTRIES) {
-		dev_dbg(&sep->pdev->dev, "no more caller id entries left\n");
-		dev_dbg(&sep->pdev->dev, "maximum number is %d\n",
-					SEP_CALLER_ID_TABLE_NUM_ENTRIES);
-		error = -EUSERS;
-		goto end_function;
-	}
-
-	/* Copy the data */
-	if (copy_from_user(&command_args, (void __user *)arg,
-		sizeof(command_args))) {
-		error = -EFAULT;
-		goto end_function;
-	}
-
-	hash = (void __user *)(unsigned long)command_args.callerIdAddress;
-
-	if (!command_args.pid || !command_args.callerIdSizeInBytes) {
-		error = -EINVAL;
-		goto end_function;
-	}
-
-	dev_dbg(&sep->pdev->dev, "pid is %x\n", command_args.pid);
-	dev_dbg(&sep->pdev->dev, "callerIdSizeInBytes is %x\n",
-		command_args.callerIdSizeInBytes);
-
-	if (command_args.callerIdSizeInBytes >
-					SEP_CALLER_ID_HASH_SIZE_IN_BYTES) {
-		error = -EMSGSIZE;
-		goto end_function;
-	}
-
-	sep->caller_id_table[i].pid = command_args.pid;
-
-	if (copy_from_user(sep->caller_id_table[i].callerIdHash,
-		hash, command_args.callerIdSizeInBytes))
-		error = -EFAULT;
-end_function:
-	return error;
-}
-
-/**
- *	sep_set_current_caller_id - set the caller id
- *	@sep: pointer to struct_sep_device
- *
- *	Set the caller ID (if it exists) to the SEP. Note that this
- *	function falls under the ioctl lock
- */
-static int sep_set_current_caller_id(struct sep_device *sep)
-{
-	int i;
-	u32 *hash_buf_ptr;
-
-	/* Zero the previous value */
-	memset(sep->shared_addr + SEP_CALLER_ID_OFFSET_BYTES,
-					0, SEP_CALLER_ID_HASH_SIZE_IN_BYTES);
-
-	for (i = 0; i < SEP_CALLER_ID_TABLE_NUM_ENTRIES; i++) {
-		if (sep->caller_id_table[i].pid == current->pid) {
-			dev_dbg(&sep->pdev->dev, "Caller Id found\n");
-
-			memcpy(sep->shared_addr + SEP_CALLER_ID_OFFSET_BYTES,
-				(void *)(sep->caller_id_table[i].callerIdHash),
-				SEP_CALLER_ID_HASH_SIZE_IN_BYTES);
-			break;
-		}
-	}
-	/* Ensure data is in little endian */
-	hash_buf_ptr = (u32 *)sep->shared_addr +
-		SEP_CALLER_ID_OFFSET_BYTES;
-
-	for (i = 0; i < SEP_CALLER_ID_HASH_SIZE_IN_WORDS; i++)
-		hash_buf_ptr[i] = cpu_to_le32(hash_buf_ptr[i]);
-
-	return 0;
-}
-
-/**
- *	sep_send_command_handler - kick off a command
- *	@sep: SEP being signalled
- *
- *	This function raises interrupt to SEP that signals that is has a new
- *	command from the host
- *
- *      Note that this function does fall under the ioctl lock
- */
-static int sep_send_command_handler(struct sep_device *sep)
-{
-	unsigned long lck_flags;
-	int error = 0;
-
-	if (test_and_set_bit(SEP_SEND_MSG_LOCK_BIT, &sep->in_use_flags)) {
-		error = -EPROTO;
-		goto end_function;
-	}
-	sep_set_time(sep);
-
-	sep_set_current_caller_id(sep);
-
-	sep_dump_message(sep);
-
-	/* Update counter */
-	spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
-	sep->send_ct++;
-	spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
-
-	dev_dbg(&sep->pdev->dev,
-		"sep_send_command_handler send_ct %lx reply_ct %lx\n",
-						sep->send_ct, sep->reply_ct);
-
-	/* Send interrupt to SEP */
-	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x2);
-
-end_function:
-	return error;
-}
-
-/**
- *	sep_allocate_data_pool_memory_handler -allocate pool memory
- *	@sep: pointer to struct sep_device
- *	@arg: pointer to struct alloc_struct
- *
- *	This function handles the allocate data pool memory request
- *	This function returns calculates the bus address of the
- *	allocated memory, and the offset of this area from the mapped address.
- *	Therefore, the FVOs in user space can calculate the exact virtual
- *	address of this allocated memory
- */
-static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
-	unsigned long arg)
-{
-	int error = 0;
-	struct alloc_struct command_args;
-
-	/* Holds the allocated buffer address in the system memory pool */
-	u32 *token_addr;
-
-	if (copy_from_user(&command_args, (void __user *)arg,
-					sizeof(struct alloc_struct))) {
-		error = -EFAULT;
-		goto end_function;
-	}
-
-	/* Allocate memory */
-	if ((sep->data_pool_bytes_allocated + command_args.num_bytes) >
-		SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES) {
-		error = -ENOMEM;
-		goto end_function;
-	}
-
-	dev_dbg(&sep->pdev->dev,
-		"data pool bytes_allocated: %x\n", (int)sep->data_pool_bytes_allocated);
-	dev_dbg(&sep->pdev->dev,
-		"offset: %x\n", SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES);
-	/* Set the virtual and bus address */
-	command_args.offset = SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES +
-		sep->data_pool_bytes_allocated;
-
-	/* Place in the shared area that is known by the SEP */
-	token_addr = (u32 *)(sep->shared_addr +
-		SEP_DRIVER_DATA_POOL_ALLOCATION_OFFSET_IN_BYTES +
-		(sep->num_of_data_allocations)*2*sizeof(u32));
-
-	token_addr[0] = SEP_DATA_POOL_POINTERS_VAL_TOKEN;
-	token_addr[1] = (u32)sep->shared_bus +
-		SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES +
-		sep->data_pool_bytes_allocated;
-
-	/* Write the memory back to the user space */
-	error = copy_to_user((void *)arg, (void *)&command_args,
-		sizeof(struct alloc_struct));
-	if (error) {
-		error = -EFAULT;
-		goto end_function;
-	}
-
-	/* Update the allocation */
-	sep->data_pool_bytes_allocated += command_args.num_bytes;
-	sep->num_of_data_allocations += 1;
-
-end_function:
-	return error;
-}
-
-/**
- *	sep_lock_kernel_pages - map kernel pages for DMA
- *	@sep: pointer to struct sep_device
- *	@kernel_virt_addr: address of data buffer in kernel
- *	@data_size: size of data
- *	@lli_array_ptr: lli array
- *	@in_out_flag: input into device or output from device
- *
- *	This function locks all the physical pages of the kernel virtual buffer
- *	and construct a basic lli  array, where each entry holds the physical
- *	page address and the size that application data holds in this page
- *	This function is used only during kernel crypto mod calls from within
- *	the kernel (when ioctl is not used)
- */
-static int sep_lock_kernel_pages(struct sep_device *sep,
-	unsigned long kernel_virt_addr,
-	u32 data_size,
-	struct sep_lli_entry **lli_array_ptr,
-	int in_out_flag)
-
-{
-	int error = 0;
-	/* Array of lli */
-	struct sep_lli_entry *lli_array;
-	/* Map array */
-	struct sep_dma_map *map_array;
-
-	dev_dbg(&sep->pdev->dev, "lock kernel pages kernel_virt_addr is %08lx\n",
-				(unsigned long)kernel_virt_addr);
-	dev_dbg(&sep->pdev->dev, "data_size is %x\n", data_size);
-
-	lli_array = kmalloc(sizeof(struct sep_lli_entry), GFP_ATOMIC);
-	if (!lli_array) {
-		error = -ENOMEM;
-		goto end_function;
-	}
-	map_array = kmalloc(sizeof(struct sep_dma_map), GFP_ATOMIC);
-	if (!map_array) {
-		error = -ENOMEM;
-		goto end_function_with_error;
-	}
-
-	map_array[0].dma_addr =
-		dma_map_single(&sep->pdev->dev, (void *)kernel_virt_addr,
-		data_size, DMA_BIDIRECTIONAL);
-	map_array[0].size = data_size;
-
-
-	/*
-	 * Set the start address of the first page - app data may start not at
-	 * the beginning of the page
-	 */
-	lli_array[0].bus_address = (u32)map_array[0].dma_addr;
-	lli_array[0].block_size = map_array[0].size;
-
-	dev_dbg(&sep->pdev->dev,
-	"lli_array[0].bus_address is %08lx, lli_array[0].block_size is %x\n",
-		(unsigned long)lli_array[0].bus_address,
-		lli_array[0].block_size);
-
-	/* Set the output parameters */
-	if (in_out_flag == SEP_DRIVER_IN_FLAG) {
-		*lli_array_ptr = lli_array;
-		sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages = 1;
-		sep->dma_res_arr[sep->nr_dcb_creat].in_page_array = NULL;
-		sep->dma_res_arr[sep->nr_dcb_creat].in_map_array = map_array;
-		sep->dma_res_arr[sep->nr_dcb_creat].in_map_num_entries = 1;
-	} else {
-		*lli_array_ptr = lli_array;
-		sep->dma_res_arr[sep->nr_dcb_creat].out_num_pages = 1;
-		sep->dma_res_arr[sep->nr_dcb_creat].out_page_array = NULL;
-		sep->dma_res_arr[sep->nr_dcb_creat].out_map_array = map_array;
-		sep->dma_res_arr[sep->nr_dcb_creat].out_map_num_entries = 1;
-	}
-	goto end_function;
-
-end_function_with_error:
-	kfree(lli_array);
-
-end_function:
-	return error;
-}
-
-/**
- *	sep_lock_user_pages - lock and map user pages for DMA
- *	@sep: pointer to struct sep_device
- *	@app_virt_addr: user memory data buffer
- *	@data_size: size of data buffer
- *	@lli_array_ptr: lli array
- *	@in_out_flag: input or output to device
- *
- *	This function locks all the physical pages of the application
- *	virtual buffer and construct a basic lli  array, where each entry
- *	holds the physical page address and the size that application
- *	data holds in this physical pages
- */
-static int sep_lock_user_pages(struct sep_device *sep,
-	u32 app_virt_addr,
-	u32 data_size,
-	struct sep_lli_entry **lli_array_ptr,
-	int in_out_flag)
-
-{
-	int error = 0;
-	u32 count;
-	int result;
-	/* The the page of the end address of the user space buffer */
-	u32 end_page;
-	/* The page of the start address of the user space buffer */
-	u32 start_page;
-	/* The range in pages */
-	u32 num_pages;
-	/* Array of pointers to page */
-	struct page **page_array;
-	/* Array of lli */
-	struct sep_lli_entry *lli_array;
-	/* Map array */
-	struct sep_dma_map *map_array;
-	/* Direction of the DMA mapping for locked pages */
-	enum dma_data_direction	dir;
-
-	/* Set start and end pages  and num pages */
-	end_page = (app_virt_addr + data_size - 1) >> PAGE_SHIFT;
-	start_page = app_virt_addr >> PAGE_SHIFT;
-	num_pages = end_page - start_page + 1;
-
-	dev_dbg(&sep->pdev->dev, "lock user pages app_virt_addr is %x\n", app_virt_addr);
-	dev_dbg(&sep->pdev->dev, "data_size is %x\n", data_size);
-	dev_dbg(&sep->pdev->dev, "start_page is %x\n", start_page);
-	dev_dbg(&sep->pdev->dev, "end_page is %x\n", end_page);
-	dev_dbg(&sep->pdev->dev, "num_pages is %x\n", num_pages);
-
-	/* Allocate array of pages structure pointers */
-	page_array = kmalloc(sizeof(struct page *) * num_pages, GFP_ATOMIC);
-	if (!page_array) {
-		error = -ENOMEM;
-		goto end_function;
-	}
-	map_array = kmalloc(sizeof(struct sep_dma_map) * num_pages, GFP_ATOMIC);
-	if (!map_array) {
-		dev_warn(&sep->pdev->dev, "kmalloc for map_array failed\n");
-		error = -ENOMEM;
-		goto end_function_with_error1;
-	}
-
-	lli_array = kmalloc(sizeof(struct sep_lli_entry) * num_pages,
-		GFP_ATOMIC);
-
-	if (!lli_array) {
-		dev_warn(&sep->pdev->dev, "kmalloc for lli_array failed\n");
-		error = -ENOMEM;
-		goto end_function_with_error2;
-	}
-
-	/* Convert the application virtual address into a set of physical */
-	down_read(&current->mm->mmap_sem);
-	result = get_user_pages(current, current->mm, app_virt_addr,
-		num_pages,
-		((in_out_flag == SEP_DRIVER_IN_FLAG) ? 0 : 1),
-		0, page_array, NULL);
-
-	up_read(&current->mm->mmap_sem);
-
-	/* Check the number of pages locked - if not all then exit with error */
-	if (result != num_pages) {
-		dev_warn(&sep->pdev->dev,
-			"not all pages locked by get_user_pages\n");
-		error = -ENOMEM;
-		goto end_function_with_error3;
-	}
-
-	dev_dbg(&sep->pdev->dev, "get_user_pages succeeded\n");
-
-	/* Set direction */
-	if (in_out_flag == SEP_DRIVER_IN_FLAG)
-		dir = DMA_TO_DEVICE;
-	else
-		dir = DMA_FROM_DEVICE;
-
-	/*
-	 * Fill the array using page array data and
-	 * map the pages - this action will also flush the cache as needed
-	 */
-	for (count = 0; count < num_pages; count++) {
-		/* Fill the map array */
-		map_array[count].dma_addr =
-			dma_map_page(&sep->pdev->dev, page_array[count],
-			0, PAGE_SIZE, /*dir*/DMA_BIDIRECTIONAL);
-
-		map_array[count].size = PAGE_SIZE;
-
-		/* Fill the lli array entry */
-		lli_array[count].bus_address = (u32)map_array[count].dma_addr;
-		lli_array[count].block_size = PAGE_SIZE;
-
-		dev_warn(&sep->pdev->dev, "lli_array[%x].bus_address is %08lx, lli_array[%x].block_size is %x\n",
-			count, (unsigned long)lli_array[count].bus_address,
-			count, lli_array[count].block_size);
-	}
-
-	/* Check the offset for the first page */
-	lli_array[0].bus_address =
-		lli_array[0].bus_address + (app_virt_addr & (~PAGE_MASK));
-
-	/* Check that not all the data is in the first page only */
-	if ((PAGE_SIZE - (app_virt_addr & (~PAGE_MASK))) >= data_size)
-		lli_array[0].block_size = data_size;
-	else
-		lli_array[0].block_size =
-			PAGE_SIZE - (app_virt_addr & (~PAGE_MASK));
-
-	dev_dbg(&sep->pdev->dev,
-		"lli_array[0].bus_address is %08lx, lli_array[0].block_size is %x\n",
-		(unsigned long)lli_array[count].bus_address,
-		lli_array[count].block_size);
-
-	/* Check the size of the last page */
-	if (num_pages > 1) {
-		lli_array[num_pages - 1].block_size =
-			(app_virt_addr + data_size) & (~PAGE_MASK);
-		if (lli_array[num_pages - 1].block_size == 0)
-			lli_array[num_pages - 1].block_size = PAGE_SIZE;
-
-		dev_warn(&sep->pdev->dev,
-			"lli_array[%x].bus_address is "
-			"%08lx, lli_array[%x].block_size is %x\n",
-			num_pages - 1,
-			(unsigned long)lli_array[num_pages - 1].bus_address,
-			num_pages - 1,
-			lli_array[num_pages - 1].block_size);
-	}
-
-	/* Set output params according to the in_out flag */
-	if (in_out_flag == SEP_DRIVER_IN_FLAG) {
-		*lli_array_ptr = lli_array;
-		sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages = num_pages;
-		sep->dma_res_arr[sep->nr_dcb_creat].in_page_array = page_array;
-		sep->dma_res_arr[sep->nr_dcb_creat].in_map_array = map_array;
-		sep->dma_res_arr[sep->nr_dcb_creat].in_map_num_entries =
-								num_pages;
-	} else {
-		*lli_array_ptr = lli_array;
-		sep->dma_res_arr[sep->nr_dcb_creat].out_num_pages = num_pages;
-		sep->dma_res_arr[sep->nr_dcb_creat].out_page_array =
-								page_array;
-		sep->dma_res_arr[sep->nr_dcb_creat].out_map_array = map_array;
-		sep->dma_res_arr[sep->nr_dcb_creat].out_map_num_entries =
-								num_pages;
-	}
-	goto end_function;
-
-end_function_with_error3:
-	/* Free lli array */
-	kfree(lli_array);
-
-end_function_with_error2:
-	kfree(map_array);
-
-end_function_with_error1:
-	/* Free page array */
-	kfree(page_array);
-
-end_function:
-	return error;
-}
-
-/**
- *	u32 sep_calculate_lli_table_max_size - size the LLI table
- *	@sep: pointer to struct sep_device
- *	@lli_in_array_ptr
- *	@num_array_entries
- *	@last_table_flag
- *
- *	This function calculates the size of data that can be inserted into
- *	the lli table from this array, such that either the table is full
- *	(all entries are entered), or there are no more entries in the
- *	lli array
- */
-static u32 sep_calculate_lli_table_max_size(struct sep_device *sep,
-	struct sep_lli_entry *lli_in_array_ptr,
-	u32 num_array_entries,
-	u32 *last_table_flag)
-{
-	u32 counter;
-	/* Table data size */
-	u32 table_data_size = 0;
-	/* Data size for the next table */
-	u32 next_table_data_size;
-
-	*last_table_flag = 0;
-
-	/*
-	 * Calculate the data in the out lli table till we fill the whole
-	 * table or till the data has ended
-	 */
-	for (counter = 0;
-		(counter < (SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP - 1)) &&
-			(counter < num_array_entries); counter++)
-		table_data_size += lli_in_array_ptr[counter].block_size;
-
-	/*
-	 * Check if we reached the last entry,
-	 * meaning this ia the last table to build,
-	 * and no need to check the block alignment
-	 */
-	if (counter == num_array_entries) {
-		/* Set the last table flag */
-		*last_table_flag = 1;
-		goto end_function;
-	}
-
-	/*
-	 * Calculate the data size of the next table.
-	 * Stop if no entries left or if data size is more the DMA restriction
-	 */
-	next_table_data_size = 0;
-	for (; counter < num_array_entries; counter++) {
-		next_table_data_size += lli_in_array_ptr[counter].block_size;
-		if (next_table_data_size >= SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE)
-			break;
-	}
-
-	/*
-	 * Check if the next table data size is less then DMA rstriction.
-	 * if it is - recalculate the current table size, so that the next
-	 * table data size will be adaquete for DMA
-	 */
-	if (next_table_data_size &&
-		next_table_data_size < SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE)
-
-		table_data_size -= (SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE -
-			next_table_data_size);
-
-end_function:
-	return table_data_size;
-}
-
-/**
- *	sep_build_lli_table - build an lli array for the given table
- *	@sep: pointer to struct sep_device
- *	@lli_array_ptr: pointer to lli array
- *	@lli_table_ptr: pointer to lli table
- *	@num_processed_entries_ptr: pointer to number of entries
- *	@num_table_entries_ptr: pointer to number of tables
- *	@table_data_size: total data size
- *
- *	Builds ant lli table from the lli_array according to
- *	the given size of data
- */
-static void sep_build_lli_table(struct sep_device *sep,
-	struct sep_lli_entry	*lli_array_ptr,
-	struct sep_lli_entry	*lli_table_ptr,
-	u32 *num_processed_entries_ptr,
-	u32 *num_table_entries_ptr,
-	u32 table_data_size)
-{
-	/* Current table data size */
-	u32 curr_table_data_size;
-	/* Counter of lli array entry */
-	u32 array_counter;
-
-	/* Init current table data size and lli array entry counter */
-	curr_table_data_size = 0;
-	array_counter = 0;
-	*num_table_entries_ptr = 1;
-
-	dev_dbg(&sep->pdev->dev, "build lli table table_data_size is %x\n", table_data_size);
-
-	/* Fill the table till table size reaches the needed amount */
-	while (curr_table_data_size < table_data_size) {
-		/* Update the number of entries in table */
-		(*num_table_entries_ptr)++;
-
-		lli_table_ptr->bus_address =
-			cpu_to_le32(lli_array_ptr[array_counter].bus_address);
-
-		lli_table_ptr->block_size =
-			cpu_to_le32(lli_array_ptr[array_counter].block_size);
-
-		curr_table_data_size += lli_array_ptr[array_counter].block_size;
-
-		dev_dbg(&sep->pdev->dev, "lli_table_ptr is %p\n",
-								lli_table_ptr);
-		dev_dbg(&sep->pdev->dev, "lli_table_ptr->bus_address is %08lx\n",
-				(unsigned long)lli_table_ptr->bus_address);
-		dev_dbg(&sep->pdev->dev, "lli_table_ptr->block_size is %x\n",
-			lli_table_ptr->block_size);
-
-		/* Check for overflow of the table data */
-		if (curr_table_data_size > table_data_size) {
-			dev_dbg(&sep->pdev->dev,
-				"curr_table_data_size too large\n");
-
-			/* Update the size of block in the table */
-			lli_table_ptr->block_size -=
-			cpu_to_le32((curr_table_data_size - table_data_size));
-
-			/* Update the physical address in the lli array */
-			lli_array_ptr[array_counter].bus_address +=
-			cpu_to_le32(lli_table_ptr->block_size);
-
-			/* Update the block size left in the lli array */
-			lli_array_ptr[array_counter].block_size =
-				(curr_table_data_size - table_data_size);
-		} else
-			/* Advance to the next entry in the lli_array */
-			array_counter++;
-
-		dev_dbg(&sep->pdev->dev,
-			"lli_table_ptr->bus_address is %08lx\n",
-				(unsigned long)lli_table_ptr->bus_address);
-		dev_dbg(&sep->pdev->dev,
-			"lli_table_ptr->block_size is %x\n",
-			lli_table_ptr->block_size);
-
-		/* Move to the next entry in table */
-		lli_table_ptr++;
-	}
-
-	/* Set the info entry to default */
-	lli_table_ptr->bus_address = 0xffffffff;
-	lli_table_ptr->block_size = 0;
-
-	/* Set the output parameter */
-	*num_processed_entries_ptr += array_counter;
-
-}
-
-/**
- *	sep_shared_area_virt_to_bus - map shared area to bus address
- *	@sep: pointer to struct sep_device
- *	@virt_address: virtual address to convert
- *
- *	This functions returns the physical address inside shared area according
- *	to the virtual address. It can be either on the externa RAM device
- *	(ioremapped), or on the system RAM
- *	This implementation is for the external RAM
- */
-static dma_addr_t sep_shared_area_virt_to_bus(struct sep_device *sep,
-	void *virt_address)
-{
-	dev_dbg(&sep->pdev->dev, "sh virt to phys v %p\n", virt_address);
-	dev_dbg(&sep->pdev->dev, "sh virt to phys p %08lx\n",
-		(unsigned long)
-		sep->shared_bus + (virt_address - sep->shared_addr));
-
-	return sep->shared_bus + (size_t)(virt_address - sep->shared_addr);
-}
-
-/**
- *	sep_shared_area_bus_to_virt - map shared area bus address to kernel
- *	@sep: pointer to struct sep_device
- *	@bus_address: bus address to convert
- *
- *	This functions returns the virtual address inside shared area
- *	according to the physical address. It can be either on the
- *	externa RAM device (ioremapped), or on the system RAM
- *	This implementation is for the external RAM
- */
-static void *sep_shared_area_bus_to_virt(struct sep_device *sep,
-	dma_addr_t bus_address)
-{
-	dev_dbg(&sep->pdev->dev, "shared bus to virt b=%lx v=%lx\n",
-		(unsigned long)bus_address, (unsigned long)(sep->shared_addr +
-			(size_t)(bus_address - sep->shared_bus)));
-
-	return sep->shared_addr	+ (size_t)(bus_address - sep->shared_bus);
-}
-
-/**
- *	sep_debug_print_lli_tables - dump LLI table
- *	@sep: pointer to struct sep_device
- *	@lli_table_ptr: pointer to sep_lli_entry
- *	@num_table_entries: number of entries
- *	@table_data_size: total data size
- *
- *	Walk the the list of the print created tables and print all the data
- */
-static void sep_debug_print_lli_tables(struct sep_device *sep,
-	struct sep_lli_entry *lli_table_ptr,
-	unsigned long num_table_entries,
-	unsigned long table_data_size)
-{
-	unsigned long table_count = 1;
-	unsigned long entries_count = 0;
-
-	dev_dbg(&sep->pdev->dev, "sep_debug_print_lli_tables start\n");
-
-	while ((unsigned long) lli_table_ptr->bus_address != 0xffffffff) {
-		dev_dbg(&sep->pdev->dev,
-			"lli table %08lx, table_data_size is %lu\n",
-			table_count, table_data_size);
-		dev_dbg(&sep->pdev->dev, "num_table_entries is %lu\n",
-							num_table_entries);
-
-		/* Print entries of the table (without info entry) */
-		for (entries_count = 0; entries_count < num_table_entries;
-			entries_count++, lli_table_ptr++) {
-
-			dev_dbg(&sep->pdev->dev,
-				"lli_table_ptr address is %08lx\n",
-				(unsigned long) lli_table_ptr);
-
-			dev_dbg(&sep->pdev->dev,
-				"phys address is %08lx block size is %x\n",
-				(unsigned long)lli_table_ptr->bus_address,
-				lli_table_ptr->block_size);
-		}
-		/* Point to the info entry */
-		lli_table_ptr--;
-
-		dev_dbg(&sep->pdev->dev,
-			"phys lli_table_ptr->block_size is %x\n",
-			lli_table_ptr->block_size);
-
-		dev_dbg(&sep->pdev->dev,
-			"phys lli_table_ptr->physical_address is %08lu\n",
-			(unsigned long)lli_table_ptr->bus_address);
-
-
-		table_data_size = lli_table_ptr->block_size & 0xffffff;
-		num_table_entries = (lli_table_ptr->block_size >> 24) & 0xff;
-
-		dev_dbg(&sep->pdev->dev,
-			"phys table_data_size is %lu num_table_entries is"
-			" %lu bus_address is%lu\n", table_data_size,
-			num_table_entries, (unsigned long)lli_table_ptr->bus_address);
-
-		if ((unsigned long)lli_table_ptr->bus_address != 0xffffffff)
-			lli_table_ptr = (struct sep_lli_entry *)
-				sep_shared_bus_to_virt(sep,
-				(unsigned long)lli_table_ptr->bus_address);
-
-		table_count++;
-	}
-	dev_dbg(&sep->pdev->dev, "sep_debug_print_lli_tables end\n");
-}
-
-
-/**
- *	sep_prepare_empty_lli_table - create a blank LLI table
- *	@sep: pointer to struct sep_device
- *	@lli_table_addr_ptr: pointer to lli table
- *	@num_entries_ptr: pointer to number of entries
- *	@table_data_size_ptr: point to table data size
- *
- *	This function creates empty lli tables when there is no data
- */
-static void sep_prepare_empty_lli_table(struct sep_device *sep,
-		dma_addr_t *lli_table_addr_ptr,
-		u32 *num_entries_ptr,
-		u32 *table_data_size_ptr)
-{
-	struct sep_lli_entry *lli_table_ptr;
-
-	/* Find the area for new table */
-	lli_table_ptr =
-		(struct sep_lli_entry *)(sep->shared_addr +
-		SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
-		sep->num_lli_tables_created * sizeof(struct sep_lli_entry) *
-			SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
-
-	lli_table_ptr->bus_address = 0;
-	lli_table_ptr->block_size = 0;
-
-	lli_table_ptr++;
-	lli_table_ptr->bus_address = 0xFFFFFFFF;
-	lli_table_ptr->block_size = 0;
-
-	/* Set the output parameter value */
-	*lli_table_addr_ptr = sep->shared_bus +
-		SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
-		sep->num_lli_tables_created *
-		sizeof(struct sep_lli_entry) *
-		SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
-
-	/* Set the num of entries and table data size for empty table */
-	*num_entries_ptr = 2;
-	*table_data_size_ptr = 0;
-
-	/* Update the number of created tables */
-	sep->num_lli_tables_created++;
-}
-
-/**
- *	sep_prepare_input_dma_table - prepare input DMA mappings
- *	@sep: pointer to struct sep_device
- *	@data_size:
- *	@block_size:
- *	@lli_table_ptr:
- *	@num_entries_ptr:
- *	@table_data_size_ptr:
- *	@is_kva: set for kernel data (kernel cryptio call)
- *
- *	This function prepares only input DMA table for synhronic symmetric
- *	operations (HASH)
- *	Note that all bus addresses that are passed to the SEP
- *	are in 32 bit format; the SEP is a 32 bit device
- */
-static int sep_prepare_input_dma_table(struct sep_device *sep,
-	unsigned long app_virt_addr,
-	u32 data_size,
-	u32 block_size,
-	dma_addr_t *lli_table_ptr,
-	u32 *num_entries_ptr,
-	u32 *table_data_size_ptr,
-	bool is_kva)
-{
-	int error = 0;
-	/* Pointer to the info entry of the table - the last entry */
-	struct sep_lli_entry *info_entry_ptr;
-	/* Array of pointers to page */
-	struct sep_lli_entry *lli_array_ptr;
-	/* Points to the first entry to be processed in the lli_in_array */
-	u32 current_entry = 0;
-	/* Num entries in the virtual buffer */
-	u32 sep_lli_entries = 0;
-	/* Lli table pointer */
-	struct sep_lli_entry *in_lli_table_ptr;
-	/* The total data in one table */
-	u32 table_data_size = 0;
-	/* Flag for last table */
-	u32 last_table_flag = 0;
-	/* Number of entries in lli table */
-	u32 num_entries_in_table = 0;
-	/* Next table address */
-	void *lli_table_alloc_addr = 0;
-
-	dev_dbg(&sep->pdev->dev, "prepare intput dma table data_size is %x\n", data_size);
-	dev_dbg(&sep->pdev->dev, "block_size is %x\n", block_size);
-
-	/* Initialize the pages pointers */
-	sep->dma_res_arr[sep->nr_dcb_creat].in_page_array = NULL;
-	sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages = 0;
-
-	/* Set the kernel address for first table to be allocated */
-	lli_table_alloc_addr = (void *)(sep->shared_addr +
-		SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
-		sep->num_lli_tables_created * sizeof(struct sep_lli_entry) *
-		SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
-
-	if (data_size == 0) {
-		/* Special case  - create meptu table - 2 entries, zero data */
-		sep_prepare_empty_lli_table(sep, lli_table_ptr,
-				num_entries_ptr, table_data_size_ptr);
-		goto update_dcb_counter;
-	}
-
-	/* Check if the pages are in Kernel Virtual Address layout */
-	if (is_kva == true)
-		/* Lock the pages in the kernel */
-		error = sep_lock_kernel_pages(sep, app_virt_addr,
-			data_size, &lli_array_ptr, SEP_DRIVER_IN_FLAG);
-	else
-		/*
-		 * Lock the pages of the user buffer
-		 * and translate them to pages
-		 */
-		error = sep_lock_user_pages(sep, app_virt_addr,
-			data_size, &lli_array_ptr, SEP_DRIVER_IN_FLAG);
-
-	if (error)
-		goto end_function;
-
-	dev_dbg(&sep->pdev->dev, "output sep_in_num_pages is %x\n",
-		sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages);
-
-	current_entry = 0;
-	info_entry_ptr = NULL;
-
-	sep_lli_entries = sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages;
-
-	/* Loop till all the entries in in array are not processed */
-	while (current_entry < sep_lli_entries) {
-
-		/* Set the new input and output tables */
-		in_lli_table_ptr =
-			(struct sep_lli_entry *)lli_table_alloc_addr;
-
-		lli_table_alloc_addr += sizeof(struct sep_lli_entry) *
-			SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
-
-		if (lli_table_alloc_addr >
-			((void *)sep->shared_addr +
-			SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
-			SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES)) {
-
-			error = -ENOMEM;
-			goto end_function_error;
-
-		}
-
-		/* Update the number of created tables */
-		sep->num_lli_tables_created++;
-
-		/* Calculate the maximum size of data for input table */
-		table_data_size = sep_calculate_lli_table_max_size(sep,
-			&lli_array_ptr[current_entry],
-			(sep_lli_entries - current_entry),
-			&last_table_flag);
-
-		/*
-		 * If this is not the last table -
-		 * then align it to the block size
-		 */
-		if (!last_table_flag)
-			table_data_size =
-				(table_data_size / block_size) * block_size;
-
-		dev_dbg(&sep->pdev->dev, "output table_data_size is %x\n",
-							table_data_size);
-
-		/* Construct input lli table */
-		sep_build_lli_table(sep, &lli_array_ptr[current_entry],
-			in_lli_table_ptr,
-			&current_entry, &num_entries_in_table, table_data_size);
-
-		if (info_entry_ptr == NULL) {
-
-			/* Set the output parameters to physical addresses */
-			*lli_table_ptr = sep_shared_area_virt_to_bus(sep,
-				in_lli_table_ptr);
-			*num_entries_ptr = num_entries_in_table;
-			*table_data_size_ptr = table_data_size;
-
-			dev_dbg(&sep->pdev->dev,
-				"output lli_table_in_ptr is %08lx\n",
-				(unsigned long)*lli_table_ptr);
-
-		} else {
-			/* Update the info entry of the previous in table */
-			info_entry_ptr->bus_address =
-				sep_shared_area_virt_to_bus(sep,
-							in_lli_table_ptr);
-			info_entry_ptr->block_size =
-				((num_entries_in_table) << 24) |
-				(table_data_size);
-		}
-		/* Save the pointer to the info entry of the current tables */
-		info_entry_ptr = in_lli_table_ptr + num_entries_in_table - 1;
-	}
-	/* Print input tables */
-	sep_debug_print_lli_tables(sep, (struct sep_lli_entry *)
-		sep_shared_area_bus_to_virt(sep, *lli_table_ptr),
-		*num_entries_ptr, *table_data_size_ptr);
-	/* The array of the pages */
-	kfree(lli_array_ptr);
-
-update_dcb_counter:
-	/* Update DCB counter */
-	sep->nr_dcb_creat++;
-	goto end_function;
-
-end_function_error:
-	/* Free all the allocated resources */
-	kfree(sep->dma_res_arr[sep->nr_dcb_creat].in_map_array);
-	kfree(lli_array_ptr);
-	kfree(sep->dma_res_arr[sep->nr_dcb_creat].in_page_array);
-
-end_function:
-	return error;
-
-}
-/**
- *	sep_construct_dma_tables_from_lli - prepare AES/DES mappings
- *	@sep: pointer to struct sep_device
- *	@lli_in_array:
- *	@sep_in_lli_entries:
- *	@lli_out_array:
- *	@sep_out_lli_entries
- *	@block_size
- *	@lli_table_in_ptr
- *	@lli_table_out_ptr
- *	@in_num_entries_ptr
- *	@out_num_entries_ptr
- *	@table_data_size_ptr
- *
- *	This function creates the input and output DMA tables for
- *	symmetric operations (AES/DES) according to the block
- *	size from LLI arays
- *	Note that all bus addresses that are passed to the SEP
- *	are in 32 bit format; the SEP is a 32 bit device
- */
-static int sep_construct_dma_tables_from_lli(
-	struct sep_device *sep,
-	struct sep_lli_entry *lli_in_array,
-	u32	sep_in_lli_entries,
-	struct sep_lli_entry *lli_out_array,
-	u32	sep_out_lli_entries,
-	u32	block_size,
-	dma_addr_t *lli_table_in_ptr,
-	dma_addr_t *lli_table_out_ptr,
-	u32	*in_num_entries_ptr,
-	u32	*out_num_entries_ptr,
-	u32	*table_data_size_ptr)
-{
-	/* Points to the area where next lli table can be allocated */
-	void *lli_table_alloc_addr = 0;
-	/* Input lli table */
-	struct sep_lli_entry *in_lli_table_ptr = NULL;
-	/* Output lli table */
-	struct sep_lli_entry *out_lli_table_ptr = NULL;
-	/* Pointer to the info entry of the table - the last entry */
-	struct sep_lli_entry *info_in_entry_ptr = NULL;
-	/* Pointer to the info entry of the table - the last entry */
-	struct sep_lli_entry *info_out_entry_ptr = NULL;
-	/* Points to the first entry to be processed in the lli_in_array */
-	u32 current_in_entry = 0;
-	/* Points to the first entry to be processed in the lli_out_array */
-	u32 current_out_entry = 0;
-	/* Max size of the input table */
-	u32 in_table_data_size = 0;
-	/* Max size of the output table */
-	u32 out_table_data_size = 0;
-	/* Flag te signifies if this is the last tables build */
-	u32 last_table_flag = 0;
-	/* The data size that should be in table */
-	u32 table_data_size = 0;
-	/* Number of etnries in the input table */
-	u32 num_entries_in_table = 0;
-	/* Number of etnries in the output table */
-	u32 num_entries_out_table = 0;
-
-	/* Initiate to point after the message area */
-	lli_table_alloc_addr = (void *)(sep->shared_addr +
-		SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
-		(sep->num_lli_tables_created *
-		(sizeof(struct sep_lli_entry) *
-		SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP)));
-
-	/* Loop till all the entries in in array are not processed */
-	while (current_in_entry < sep_in_lli_entries) {
-		/* Set the new input and output tables */
-		in_lli_table_ptr =
-			(struct sep_lli_entry *)lli_table_alloc_addr;
-
-		lli_table_alloc_addr += sizeof(struct sep_lli_entry) *
-			SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
-
-		/* Set the first output tables */
-		out_lli_table_ptr =
-			(struct sep_lli_entry *)lli_table_alloc_addr;
-
-		/* Check if the DMA table area limit was overrun */
-		if ((lli_table_alloc_addr + sizeof(struct sep_lli_entry) *
-			SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP) >
-			((void *)sep->shared_addr +
-			SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
-			SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES)) {
-
-			dev_warn(&sep->pdev->dev, "dma table limit overrun\n");
-			return -ENOMEM;
-		}
-
-		/* Update the number of the lli tables created */
-		sep->num_lli_tables_created += 2;
-
-		lli_table_alloc_addr += sizeof(struct sep_lli_entry) *
-			SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
-
-		/* Calculate the maximum size of data for input table */
-		in_table_data_size =
-			sep_calculate_lli_table_max_size(sep,
-			&lli_in_array[current_in_entry],
-			(sep_in_lli_entries - current_in_entry),
-			&last_table_flag);
-
-		/* Calculate the maximum size of data for output table */
-		out_table_data_size =
-			sep_calculate_lli_table_max_size(sep,
-			&lli_out_array[current_out_entry],
-			(sep_out_lli_entries - current_out_entry),
-			&last_table_flag);
-
-		dev_dbg(&sep->pdev->dev,
-			"construct tables from lli in_table_data_size is %x\n",
-			in_table_data_size);
-
-		dev_dbg(&sep->pdev->dev,
-			"construct tables from lli out_table_data_size is %x\n",
-			out_table_data_size);
-
-		table_data_size = in_table_data_size;
-
-		if (!last_table_flag) {
-			/*
-			 * If this is not the last table,
-			 * then must check where the data is smallest
-			 * and then align it to the block size
-			 */
-			if (table_data_size > out_table_data_size)
-				table_data_size = out_table_data_size;
-
-			/*
-			 * Now calculate the table size so that
-			 * it will be module block size
-			 */
-			table_data_size = (table_data_size / block_size) *
-				block_size;
-		}
-
-		/* Construct input lli table */
-		sep_build_lli_table(sep, &lli_in_array[current_in_entry],
-			in_lli_table_ptr,
-			&current_in_entry,
-			&num_entries_in_table,
-			table_data_size);
-
-		/* Construct output lli table */
-		sep_build_lli_table(sep, &lli_out_array[current_out_entry],
-			out_lli_table_ptr,
-			&current_out_entry,
-			&num_entries_out_table,
-			table_data_size);
-
-		/* If info entry is null - this is the first table built */
-		if (info_in_entry_ptr == NULL) {
-			/* Set the output parameters to physical addresses */
-			*lli_table_in_ptr =
-			sep_shared_area_virt_to_bus(sep, in_lli_table_ptr);
-
-			*in_num_entries_ptr = num_entries_in_table;
-
-			*lli_table_out_ptr =
-				sep_shared_area_virt_to_bus(sep,
-				out_lli_table_ptr);
-
-			*out_num_entries_ptr = num_entries_out_table;
-			*table_data_size_ptr = table_data_size;
-
-			dev_dbg(&sep->pdev->dev,
-			"output lli_table_in_ptr is %08lx\n",
-				(unsigned long)*lli_table_in_ptr);
-			dev_dbg(&sep->pdev->dev,
-			"output lli_table_out_ptr is %08lx\n",
-				(unsigned long)*lli_table_out_ptr);
-		} else {
-			/* Update the info entry of the previous in table */
-			info_in_entry_ptr->bus_address =
-				sep_shared_area_virt_to_bus(sep,
-				in_lli_table_ptr);
-
-			info_in_entry_ptr->block_size =
-				((num_entries_in_table) << 24) |
-				(table_data_size);
-
-			/* Update the info entry of the previous in table */
-			info_out_entry_ptr->bus_address =
-				sep_shared_area_virt_to_bus(sep,
-				out_lli_table_ptr);
-
-			info_out_entry_ptr->block_size =
-				((num_entries_out_table) << 24) |
-				(table_data_size);
-
-			dev_dbg(&sep->pdev->dev,
-				"output lli_table_in_ptr:%08lx %08x\n",
-				(unsigned long)info_in_entry_ptr->bus_address,
-				info_in_entry_ptr->block_size);
-
-			dev_dbg(&sep->pdev->dev,
-				"output lli_table_out_ptr:%08lx  %08x\n",
-				(unsigned long)info_out_entry_ptr->bus_address,
-				info_out_entry_ptr->block_size);
-		}
-
-		/* Save the pointer to the info entry of the current tables */
-		info_in_entry_ptr = in_lli_table_ptr +
-			num_entries_in_table - 1;
-		info_out_entry_ptr = out_lli_table_ptr +
-			num_entries_out_table - 1;
-
-		dev_dbg(&sep->pdev->dev,
-			"output num_entries_out_table is %x\n",
-			(u32)num_entries_out_table);
-		dev_dbg(&sep->pdev->dev,
-			"output info_in_entry_ptr is %lx\n",
-			(unsigned long)info_in_entry_ptr);
-		dev_dbg(&sep->pdev->dev,
-			"output info_out_entry_ptr is %lx\n",
-			(unsigned long)info_out_entry_ptr);
-	}
-
-	/* Print input tables */
-	sep_debug_print_lli_tables(sep,
-	(struct sep_lli_entry *)
-	sep_shared_area_bus_to_virt(sep, *lli_table_in_ptr),
-	*in_num_entries_ptr,
-	*table_data_size_ptr);
-
-	/* Print output tables */
-	sep_debug_print_lli_tables(sep,
-	(struct sep_lli_entry *)
-	sep_shared_area_bus_to_virt(sep, *lli_table_out_ptr),
-	*out_num_entries_ptr,
-	*table_data_size_ptr);
-
-	return 0;
-}
-
-/**
- *	sep_prepare_input_output_dma_table - prepare DMA I/O table
- *	@app_virt_in_addr:
- *	@app_virt_out_addr:
- *	@data_size:
- *	@block_size:
- *	@lli_table_in_ptr:
- *	@lli_table_out_ptr:
- *	@in_num_entries_ptr:
- *	@out_num_entries_ptr:
- *	@table_data_size_ptr:
- *	@is_kva: set for kernel data; used only for kernel crypto module
- *
- *	This function builds input and output DMA tables for synhronic
- *	symmetric operations (AES, DES, HASH). It also checks that each table
- *	is of the modular block size
- *	Note that all bus addresses that are passed to the SEP
- *	are in 32 bit format; the SEP is a 32 bit device
- */
-static int sep_prepare_input_output_dma_table(struct sep_device *sep,
-	unsigned long app_virt_in_addr,
-	unsigned long app_virt_out_addr,
-	u32 data_size,
-	u32 block_size,
-	dma_addr_t *lli_table_in_ptr,
-	dma_addr_t *lli_table_out_ptr,
-	u32 *in_num_entries_ptr,
-	u32 *out_num_entries_ptr,
-	u32 *table_data_size_ptr,
-	bool is_kva)
-
-{
-	int error = 0;
-	/* Array of pointers of page */
-	struct sep_lli_entry *lli_in_array;
-	/* Array of pointers of page */
-	struct sep_lli_entry *lli_out_array;
-
-	if (data_size == 0) {
-		/* Prepare empty table for input and output */
-		sep_prepare_empty_lli_table(sep, lli_table_in_ptr,
-			in_num_entries_ptr, table_data_size_ptr);
-
-		sep_prepare_empty_lli_table(sep, lli_table_out_ptr,
-			out_num_entries_ptr, table_data_size_ptr);
-
-		goto update_dcb_counter;
-	}
-
-	/* Initialize the pages pointers */
-	sep->dma_res_arr[sep->nr_dcb_creat].in_page_array = NULL;
-	sep->dma_res_arr[sep->nr_dcb_creat].out_page_array = NULL;
-
-	/* Lock the pages of the buffer and translate them to pages */
-	if (is_kva == true) {
-		error = sep_lock_kernel_pages(sep, app_virt_in_addr,
-			data_size, &lli_in_array, SEP_DRIVER_IN_FLAG);
-
-		if (error) {
-			dev_warn(&sep->pdev->dev,
-				"lock kernel for in failed\n");
-			goto end_function;
-		}
-
-		error = sep_lock_kernel_pages(sep, app_virt_out_addr,
-			data_size, &lli_out_array, SEP_DRIVER_OUT_FLAG);
-
-		if (error) {
-			dev_warn(&sep->pdev->dev,
-				"lock kernel for out failed\n");
-			goto end_function;
-		}
-	}
-
-	else {
-		error = sep_lock_user_pages(sep, app_virt_in_addr,
-				data_size, &lli_in_array, SEP_DRIVER_IN_FLAG);
-		if (error) {
-			dev_warn(&sep->pdev->dev,
-				"sep_lock_user_pages for input virtual buffer failed\n");
-			goto end_function;
-		}
-
-		error = sep_lock_user_pages(sep, app_virt_out_addr,
-			data_size, &lli_out_array, SEP_DRIVER_OUT_FLAG);
-
-		if (error) {
-			dev_warn(&sep->pdev->dev,
-				"sep_lock_user_pages for output virtual buffer failed\n");
-			goto end_function_free_lli_in;
-		}
-	}
-
-	dev_dbg(&sep->pdev->dev, "prep input output dma table sep_in_num_pages is %x\n",
-		sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages);
-	dev_dbg(&sep->pdev->dev, "sep_out_num_pages is %x\n",
-		sep->dma_res_arr[sep->nr_dcb_creat].out_num_pages);
-	dev_dbg(&sep->pdev->dev, "SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP is %x\n",
-		SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
-
-	/* Call the function that creates table from the lli arrays */
-	error = sep_construct_dma_tables_from_lli(sep, lli_in_array,
-		sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages,
-		lli_out_array,
-		sep->dma_res_arr[sep->nr_dcb_creat].out_num_pages,
-		block_size, lli_table_in_ptr, lli_table_out_ptr,
-		in_num_entries_ptr, out_num_entries_ptr, table_data_size_ptr);
-
-	if (error) {
-		dev_warn(&sep->pdev->dev,
-			"sep_construct_dma_tables_from_lli failed\n");
-		goto end_function_with_error;
-	}
-
-	kfree(lli_out_array);
-	kfree(lli_in_array);
-
-update_dcb_counter:
-	/* Update DCB counter */
-	sep->nr_dcb_creat++;
-
-	goto end_function;
-
-end_function_with_error:
-	kfree(sep->dma_res_arr[sep->nr_dcb_creat].out_map_array);
-	kfree(sep->dma_res_arr[sep->nr_dcb_creat].out_page_array);
-	kfree(lli_out_array);
-
-
-end_function_free_lli_in:
-	kfree(sep->dma_res_arr[sep->nr_dcb_creat].in_map_array);
-	kfree(sep->dma_res_arr[sep->nr_dcb_creat].in_page_array);
-	kfree(lli_in_array);
-
-end_function:
-
-	return error;
-
-}
-
-/**
- *	sep_prepare_input_output_dma_table_in_dcb - prepare control blocks
- *	@app_in_address: unsigned long; for data buffer in (user space)
- *	@app_out_address: unsigned long; for data buffer out (user space)
- *	@data_in_size: u32; for size of data
- *	@block_size: u32; for block size
- *	@tail_block_size: u32; for size of tail block
- *	@isapplet: bool; to indicate external app
- *	@is_kva: bool; kernel buffer; only used for kernel crypto module
- *
- *	This function prepares the linked DMA tables and puts the
- *	address for the linked list of tables inta a DCB (data control
- *	block) the address of which is known by the SEP hardware
- *	Note that all bus addresses that are passed to the SEP
- *	are in 32 bit format; the SEP is a 32 bit device
- */
-static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
-	unsigned long  app_in_address,
-	unsigned long  app_out_address,
-	u32  data_in_size,
-	u32  block_size,
-	u32  tail_block_size,
-	bool isapplet,
-	bool	is_kva)
-{
-	int error = 0;
-	/* Size of tail */
-	u32 tail_size = 0;
-	/* Address of the created DCB table */
-	struct sep_dcblock *dcb_table_ptr = NULL;
-	/* The physical address of the first input DMA table */
-	dma_addr_t in_first_mlli_address = 0;
-	/* Number of entries in the first input DMA table */
-	u32  in_first_num_entries = 0;
-	/* The physical address of the first output DMA table */
-	dma_addr_t  out_first_mlli_address = 0;
-	/* Number of entries in the first output DMA table */
-	u32  out_first_num_entries = 0;
-	/* Data in the first input/output table */
-	u32  first_data_size = 0;
-
-	if (sep->nr_dcb_creat == SEP_MAX_NUM_SYNC_DMA_OPS) {
-		/* No more DCBs to allocate */
-		dev_warn(&sep->pdev->dev, "no more DCBs available\n");
-		error = -ENOSPC;
-		goto end_function;
-	}
-
-	/* Allocate new DCB */
-	dcb_table_ptr = (struct sep_dcblock *)(sep->shared_addr +
-		SEP_DRIVER_SYSTEM_DCB_MEMORY_OFFSET_IN_BYTES +
-		(sep->nr_dcb_creat * sizeof(struct sep_dcblock)));
-
-	/* Set the default values in the DCB */
-	dcb_table_ptr->input_mlli_address = 0;
-	dcb_table_ptr->input_mlli_num_entries = 0;
-	dcb_table_ptr->input_mlli_data_size = 0;
-	dcb_table_ptr->output_mlli_address = 0;
-	dcb_table_ptr->output_mlli_num_entries = 0;
-	dcb_table_ptr->output_mlli_data_size = 0;
-	dcb_table_ptr->tail_data_size = 0;
-	dcb_table_ptr->out_vr_tail_pt = 0;
-
-	if (isapplet == true) {
-
-		/* Check if there is enough data for DMA operation */
-		if (data_in_size < SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE) {
-			if (is_kva == true) {
-				memcpy(dcb_table_ptr->tail_data,
-					(void *)app_in_address, data_in_size);
-			} else {
-				if (copy_from_user(dcb_table_ptr->tail_data,
-					(void __user *)app_in_address,
-					data_in_size)) {
-					error = -EFAULT;
-					goto end_function;
-				}
-			}
-
-			dcb_table_ptr->tail_data_size = data_in_size;
-
-			/* Set the output user-space address for mem2mem op */
-			if (app_out_address)
-				dcb_table_ptr->out_vr_tail_pt =
-							(aligned_u64)app_out_address;
-
-			/*
-			 * Update both data length parameters in order to avoid
-			 * second data copy and allow building of empty mlli
-			 * tables
-			 */
-			tail_size = 0x0;
-			data_in_size = 0x0;
-
-		} else {
-			if (!app_out_address) {
-				tail_size = data_in_size % block_size;
-				if (!tail_size) {
-					if (tail_block_size == block_size)
-						tail_size = block_size;
-				}
-			} else {
-				tail_size = 0;
-			}
-		}
-		if (tail_size) {
-			if (tail_size > sizeof(dcb_table_ptr->tail_data))
-				return -EINVAL;
-			if (is_kva == true) {
-				memcpy(dcb_table_ptr->tail_data,
-					(void *)(app_in_address + data_in_size -
-					tail_size), tail_size);
-			} else {
-				/* We have tail data - copy it to DCB */
-				if (copy_from_user(dcb_table_ptr->tail_data,
-					(void *)(app_in_address +
-					data_in_size - tail_size), tail_size)) {
-					error = -EFAULT;
-					goto end_function;
-				}
-			}
-			if (app_out_address)
-				/*
-				 * Calculate the output address
-				 * according to tail data size
-				 */
-				dcb_table_ptr->out_vr_tail_pt =
-					(aligned_u64)app_out_address + data_in_size
-					- tail_size;
-
-			/* Save the real tail data size */
-			dcb_table_ptr->tail_data_size = tail_size;
-			/*
-			 * Update the data size without the tail
-			 * data size AKA data for the dma
-			 */
-			data_in_size = (data_in_size - tail_size);
-		}
-	}
-	/* Check if we need to build only input table or input/output */
-	if (app_out_address) {
-		/* Prepare input/output tables */
-		error = sep_prepare_input_output_dma_table(sep,
-			app_in_address,
-			app_out_address,
-			data_in_size,
-			block_size,
-			&in_first_mlli_address,
-			&out_first_mlli_address,
-			&in_first_num_entries,
-			&out_first_num_entries,
-			&first_data_size,
-			is_kva);
-	} else {
-		/* Prepare input tables */
-		error = sep_prepare_input_dma_table(sep,
-			app_in_address,
-			data_in_size,
-			block_size,
-			&in_first_mlli_address,
-			&in_first_num_entries,
-			&first_data_size,
-			is_kva);
-	}
-
-	if (error) {
-		dev_warn(&sep->pdev->dev, "prepare DMA table call failed from prepare DCB call\n");
-		goto end_function;
-	}
-
-	/* Set the DCB values */
-	dcb_table_ptr->input_mlli_address = in_first_mlli_address;
-	dcb_table_ptr->input_mlli_num_entries = in_first_num_entries;
-	dcb_table_ptr->input_mlli_data_size = first_data_size;
-	dcb_table_ptr->output_mlli_address = out_first_mlli_address;
-	dcb_table_ptr->output_mlli_num_entries = out_first_num_entries;
-	dcb_table_ptr->output_mlli_data_size = first_data_size;
-
-end_function:
-	return error;
-
-}
-
-/**
- *	sep_free_dma_tables_and_dcb - free DMA tables and DCBs
- *	@sep: pointer to struct sep_device
- *	@isapplet: indicates external application (used for kernel access)
- *	@is_kva: indicates kernel addresses (only used for kernel crypto)
- *
- *	This function frees the DMA tables and DCB
- */
-static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
-	bool is_kva)
-{
-	int i = 0;
-	int error = 0;
-	int error_temp = 0;
-	struct sep_dcblock *dcb_table_ptr;
-	unsigned long pt_hold;
-	void *tail_pt;
-
-	if (isapplet == true) {
-		/* Set pointer to first DCB table */
-		dcb_table_ptr = (struct sep_dcblock *)
-			(sep->shared_addr +
-			SEP_DRIVER_SYSTEM_DCB_MEMORY_OFFSET_IN_BYTES);
-
-		/* Go over each DCB and see if tail pointer must be updated */
-		for (i = 0; i < sep->nr_dcb_creat; i++, dcb_table_ptr++) {
-			if (dcb_table_ptr->out_vr_tail_pt) {
-				pt_hold = (unsigned long)dcb_table_ptr->out_vr_tail_pt;
-				tail_pt = (void *)pt_hold;
-				if (is_kva == true) {
-					memcpy(tail_pt,
-						dcb_table_ptr->tail_data,
-						dcb_table_ptr->tail_data_size);
-				} else {
-					error_temp = copy_to_user(
-						tail_pt,
-						dcb_table_ptr->tail_data,
-						dcb_table_ptr->tail_data_size);
-				}
-				if (error_temp) {
-					/* Release the DMA resource */
-					error = -EFAULT;
-					break;
-				}
-			}
-		}
-	}
-	/* Free the output pages, if any */
-	sep_free_dma_table_data_handler(sep);
-
-	return error;
-}
-
-/**
- *	sep_get_static_pool_addr_handler - get static pool address
- *	@sep: pointer to struct sep_device
- *
- *	This function sets the bus and virtual addresses of the static pool
- */
-static int sep_get_static_pool_addr_handler(struct sep_device *sep)
-{
-	u32 *static_pool_addr = NULL;
-
-	static_pool_addr = (u32 *)(sep->shared_addr +
-		SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES);
-
-	static_pool_addr[0] = SEP_STATIC_POOL_VAL_TOKEN;
-	static_pool_addr[1] = (u32)sep->shared_bus +
-		SEP_DRIVER_STATIC_AREA_OFFSET_IN_BYTES;
-
-	dev_dbg(&sep->pdev->dev, "static pool segment: physical %x\n",
-		(u32)static_pool_addr[1]);
-
-	return 0;
-}
-
-/**
- *	sep_end_transaction_handler - end transaction
- *	@sep: pointer to struct sep_device
- *
- *	This API handles the end transaction request
- */
-static int sep_end_transaction_handler(struct sep_device *sep)
-{
-	/* Clear the data pool pointers Token */
-	memset((void *)(sep->shared_addr +
-		SEP_DRIVER_DATA_POOL_ALLOCATION_OFFSET_IN_BYTES),
-		0, sep->num_of_data_allocations*2*sizeof(u32));
-
-	/* Check that all the DMA resources were freed */
-	sep_free_dma_table_data_handler(sep);
-
-	clear_bit(SEP_MMAP_LOCK_BIT, &sep->in_use_flags);
-
-	/*
-	 * We are now through with the transaction. Let's
-	 * allow other processes who have the device open
-	 * to perform transactions
-	 */
-	mutex_lock(&sep->sep_mutex);
-	sep->pid_doing_transaction = 0;
-	mutex_unlock(&sep->sep_mutex);
-	/* Raise event for stuck contextes */
-	wake_up(&sep->event);
-
-	return 0;
-}
-
-/**
- *	sep_prepare_dcb_handler - prepare a control block
- *	@sep: pointer to struct sep_device
- *	@arg: pointer to user parameters
- *
- *	This function will retrieve the RAR buffer physical addresses, type
- *	& size corresponding to the RAR handles provided in the buffers vector.
- */
-static int sep_prepare_dcb_handler(struct sep_device *sep, unsigned long arg)
-{
-	int error;
-	/* Command arguments */
-	struct build_dcb_struct command_args;
-
-	/* Get the command arguments */
-	if (copy_from_user(&command_args, (void __user *)arg,
-					sizeof(struct build_dcb_struct))) {
-		error = -EFAULT;
-		goto end_function;
-	}
-
-	dev_dbg(&sep->pdev->dev, "prep dcb handler app_in_address is %08llx\n",
-						command_args.app_in_address);
-	dev_dbg(&sep->pdev->dev, "app_out_address is %08llx\n",
-						command_args.app_out_address);
-	dev_dbg(&sep->pdev->dev, "data_size is %x\n",
-						command_args.data_in_size);
-	dev_dbg(&sep->pdev->dev, "block_size is %x\n",
-						command_args.block_size);
-	dev_dbg(&sep->pdev->dev, "tail block_size is %x\n",
-						command_args.tail_block_size);
-
-	error = sep_prepare_input_output_dma_table_in_dcb(sep,
-		(unsigned long)command_args.app_in_address,
-		(unsigned long)command_args.app_out_address,
-		command_args.data_in_size, command_args.block_size,
-		command_args.tail_block_size, true, false);
-
-end_function:
-	return error;
-
-}
-
-/**
- *	sep_free_dcb_handler - free control block resources
- *	@sep: pointer to struct sep_device
- *
- *	This function frees the DCB resources and updates the needed
- *	user-space buffers.
- */
-static int sep_free_dcb_handler(struct sep_device *sep)
-{
-	return sep_free_dma_tables_and_dcb(sep, false, false);
-}
-
-/**
- *	sep_rar_prepare_output_msg_handler - prepare an output message
- *	@sep: pointer to struct sep_device
- *	@arg: pointer to user parameters
- *
- *	This function will retrieve the RAR buffer physical addresses, type
- *	& size corresponding to the RAR handles provided in the buffers vector.
- */
-static int sep_rar_prepare_output_msg_handler(struct sep_device *sep,
-	unsigned long arg)
-{
-	int error = 0;
-	/* Command args */
-	struct rar_hndl_to_bus_struct command_args;
-	/* Bus address */
-	dma_addr_t  rar_bus = 0;
-	/* Holds the RAR address in the system memory offset */
-	u32 *rar_addr;
-
-	/* Copy the data */
-	if (copy_from_user(&command_args, (void __user *)arg,
-						sizeof(command_args))) {
-		error = -EFAULT;
-		goto end_function;
-	}
-
-	/* Call to translation function only if user handle is not NULL */
-	if (command_args.rar_handle)
-		return -EOPNOTSUPP;
-	dev_dbg(&sep->pdev->dev, "rar msg; rar_addr_bus = %x\n", (u32)rar_bus);
-
-	/* Set value in the SYSTEM MEMORY offset */
-	rar_addr = (u32 *)(sep->shared_addr +
-		SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES);
-
-	/* Copy the physical address to the System Area for the SEP */
-	rar_addr[0] = SEP_RAR_VAL_TOKEN;
-	rar_addr[1] = rar_bus;
-
-end_function:
-	return error;
-}
-
-/**
- *	sep_ioctl - ioctl api
- *	@filp: pointer to struct file
- *	@cmd: command
- *	@arg: pointer to argument structure
- *
- *	Implement the ioctl methods available on the SEP device.
- */
-static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
-{
-	int error = 0;
-	struct sep_device *sep = filp->private_data;
-
-	/* Make sure we own this device */
-	mutex_lock(&sep->sep_mutex);
-	if ((current->pid != sep->pid_doing_transaction) &&
-				(sep->pid_doing_transaction != 0)) {
-		dev_dbg(&sep->pdev->dev, "ioctl pid is not owner\n");
-		error = -EACCES;
-	}
-	mutex_unlock(&sep->sep_mutex);
-
-	if (error)
-		return error;
-
-	if (_IOC_TYPE(cmd) != SEP_IOC_MAGIC_NUMBER)
-		return -ENOTTY;
-
-	/* Lock to prevent the daemon to interfere with operation */
-	mutex_lock(&sep->ioctl_mutex);
-
-	switch (cmd) {
-	case SEP_IOCSENDSEPCOMMAND:
-		/* Send command to SEP */
-		error = sep_send_command_handler(sep);
-		break;
-	case SEP_IOCALLOCDATAPOLL:
-		/* Allocate data pool */
-		error = sep_allocate_data_pool_memory_handler(sep, arg);
-		break;
-	case SEP_IOCGETSTATICPOOLADDR:
-		/* Inform the SEP the bus address of the static pool */
-		error = sep_get_static_pool_addr_handler(sep);
-		break;
-	case SEP_IOCENDTRANSACTION:
-		error = sep_end_transaction_handler(sep);
-		break;
-	case SEP_IOCRARPREPAREMESSAGE:
-		error = sep_rar_prepare_output_msg_handler(sep, arg);
-		break;
-	case SEP_IOCPREPAREDCB:
-		error = sep_prepare_dcb_handler(sep, arg);
-		break;
-	case SEP_IOCFREEDCB:
-		error = sep_free_dcb_handler(sep);
-		break;
-	default:
-		error = -ENOTTY;
-		break;
-	}
-
-	mutex_unlock(&sep->ioctl_mutex);
-	return error;
-}
-
-/**
- *	sep_singleton_ioctl - ioctl api for singleton interface
- *	@filp: pointer to struct file
- *	@cmd: command
- *	@arg: pointer to argument structure
- *
- *	Implement the additional ioctls for the singleton device
- */
-static long sep_singleton_ioctl(struct file  *filp, u32 cmd, unsigned long arg)
-{
-	long error = 0;
-	struct sep_device *sep = filp->private_data;
-
-	/* Check that the command is for the SEP device */
-	if (_IOC_TYPE(cmd) != SEP_IOC_MAGIC_NUMBER)
-		return -ENOTTY;
-
-	/* Make sure we own this device */
-	mutex_lock(&sep->sep_mutex);
-	if ((current->pid != sep->pid_doing_transaction) &&
-				(sep->pid_doing_transaction != 0)) {
-		dev_dbg(&sep->pdev->dev, "singleton ioctl pid is not owner\n");
-		mutex_unlock(&sep->sep_mutex);
-		return -EACCES;
-	}
-
-	mutex_unlock(&sep->sep_mutex);
-
-	switch (cmd) {
-	case SEP_IOCTLSETCALLERID:
-		mutex_lock(&sep->ioctl_mutex);
-		error = sep_set_caller_id_handler(sep, arg);
-		mutex_unlock(&sep->ioctl_mutex);
-		break;
-	default:
-		error = sep_ioctl(filp, cmd, arg);
-		break;
-	}
-	return error;
-}
-
-/**
- *	sep_request_daemon_ioctl - ioctl for daemon
- *	@filp: pointer to struct file
- *	@cmd: command
- *	@arg: pointer to argument structure
- *
- *	Called by the request daemon to perform ioctls on the daemon device
- */
-static long sep_request_daemon_ioctl(struct file *filp, u32 cmd,
-	unsigned long arg)
-{
-
-	long error;
-	struct sep_device *sep = filp->private_data;
-
-	/* Check that the command is for SEP device */
-	if (_IOC_TYPE(cmd) != SEP_IOC_MAGIC_NUMBER)
-		return -ENOTTY;
-
-	/* Only one process can access ioctl at any given time */
-	mutex_lock(&sep->ioctl_mutex);
-
-	switch (cmd) {
-	case SEP_IOCSENDSEPRPLYCOMMAND:
-		/* Send reply command to SEP */
-		error = sep_req_daemon_send_reply_command_handler(sep);
-		break;
-	case SEP_IOCENDTRANSACTION:
-		/*
-		 * End req daemon transaction, do nothing
-		 * will be removed upon update in middleware
-		 * API library
-		 */
-		error = 0;
-		break;
-	default:
-		error = -ENOTTY;
-	}
-	mutex_unlock(&sep->ioctl_mutex);
-	return error;
-}
-
-/**
- *	sep_inthandler - interrupt handler
- *	@irq: interrupt
- *	@dev_id: device id
- */
-static irqreturn_t sep_inthandler(int irq, void *dev_id)
-{
-	irqreturn_t int_error = IRQ_HANDLED;
-	unsigned long lck_flags;
-	u32 reg_val, reg_val2 = 0;
-	struct sep_device *sep = dev_id;
-
-	/* Read the IRR register to check if this is SEP interrupt */
-	reg_val = sep_read_reg(sep, HW_HOST_IRR_REG_ADDR);
-
-	if (reg_val & (0x1 << 13)) {
-		/* Lock and update the counter of reply messages */
-		spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
-		sep->reply_ct++;
-		spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
-
-		dev_dbg(&sep->pdev->dev, "sep int: send_ct %lx reply_ct %lx\n",
-					sep->send_ct, sep->reply_ct);
-
-		/* Is this printf or daemon request? */
-		reg_val2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
-		dev_dbg(&sep->pdev->dev,
-			"SEP Interrupt - reg2 is %08x\n", reg_val2);
-
-		if ((reg_val2 >> 30) & 0x1) {
-			dev_dbg(&sep->pdev->dev, "int: printf request\n");
-			wake_up(&sep->event_request_daemon);
-		} else if (reg_val2 >> 31) {
-			dev_dbg(&sep->pdev->dev, "int: daemon request\n");
-			wake_up(&sep->event_request_daemon);
-		} else {
-			dev_dbg(&sep->pdev->dev, "int: SEP reply\n");
-			wake_up(&sep->event);
-		}
-	} else {
-		dev_dbg(&sep->pdev->dev, "int: not SEP interrupt\n");
-		int_error = IRQ_NONE;
-	}
-	if (int_error == IRQ_HANDLED)
-		sep_write_reg(sep, HW_HOST_ICR_REG_ADDR, reg_val);
-
-	return int_error;
-}
-
-/**
- *	sep_reconfig_shared_area - reconfigure shared area
- *	@sep: pointer to struct sep_device
- *
- *	Reconfig the shared area between HOST and SEP - needed in case
- *	the DX_CC_Init function was called before OS loading.
- */
-static int sep_reconfig_shared_area(struct sep_device *sep)
-{
-	int ret_val;
-
-	/* use to limit waiting for SEP */
-	unsigned long end_time;
-
-	/* Send the new SHARED MESSAGE AREA to the SEP */
-	dev_dbg(&sep->pdev->dev, "reconfig shared; sending %08llx to sep\n",
-				(unsigned long long)sep->shared_bus);
-
-	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR1_REG_ADDR, sep->shared_bus);
-
-	/* Poll for SEP response */
-	ret_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR1_REG_ADDR);
-
-	end_time = jiffies + (WAIT_TIME * HZ);
-
-	while ((time_before(jiffies, end_time)) && (ret_val != 0xffffffff) &&
-		(ret_val != sep->shared_bus))
-		ret_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR1_REG_ADDR);
-
-	/* Check the return value (register) */
-	if (ret_val != sep->shared_bus) {
-		dev_warn(&sep->pdev->dev, "could not reconfig shared area\n");
-		dev_warn(&sep->pdev->dev, "result was %x\n", ret_val);
-		ret_val = -ENOMEM;
-	} else
-		ret_val = 0;
-
-	dev_dbg(&sep->pdev->dev, "reconfig shared area end\n");
-	return ret_val;
-}
-
-/* File operation for singleton SEP operations */
-static const struct file_operations singleton_file_operations = {
-	.owner = THIS_MODULE,
-	.unlocked_ioctl = sep_singleton_ioctl,
-	.poll = sep_poll,
-	.open = sep_singleton_open,
-	.release = sep_singleton_release,
-	.mmap = sep_mmap,
-};
-
-/* File operation for daemon operations */
-static const struct file_operations daemon_file_operations = {
-	.owner = THIS_MODULE,
-	.unlocked_ioctl = sep_request_daemon_ioctl,
-	.poll = sep_request_daemon_poll,
-	.open = sep_request_daemon_open,
-	.release = sep_request_daemon_release,
-	.mmap = sep_request_daemon_mmap,
-};
-
-/* The files operations structure of the driver */
-static const struct file_operations sep_file_operations = {
-	.owner = THIS_MODULE,
-	.unlocked_ioctl = sep_ioctl,
-	.poll = sep_poll,
-	.open = sep_open,
-	.release = sep_release,
-	.mmap = sep_mmap,
-};
-
-/**
- *	sep_register_driver_with_fs - register misc devices
- *	@sep: pointer to struct sep_device
- *
- *	This function registers the driver with the file system
- */
-static int sep_register_driver_with_fs(struct sep_device *sep)
-{
-	int ret_val;
-
-	sep->miscdev_sep.minor = MISC_DYNAMIC_MINOR;
-	sep->miscdev_sep.name = SEP_DEV_NAME;
-	sep->miscdev_sep.fops = &sep_file_operations;
-
-	sep->miscdev_singleton.minor = MISC_DYNAMIC_MINOR;
-	sep->miscdev_singleton.name = SEP_DEV_SINGLETON;
-	sep->miscdev_singleton.fops = &singleton_file_operations;
-
-	sep->miscdev_daemon.minor = MISC_DYNAMIC_MINOR;
-	sep->miscdev_daemon.name = SEP_DEV_DAEMON;
-	sep->miscdev_daemon.fops = &daemon_file_operations;
-
-	ret_val = misc_register(&sep->miscdev_sep);
-	if (ret_val) {
-		dev_warn(&sep->pdev->dev, "misc reg fails for SEP %x\n",
-			ret_val);
-		return ret_val;
-	}
-
-	ret_val = misc_register(&sep->miscdev_singleton);
-	if (ret_val) {
-		dev_warn(&sep->pdev->dev, "misc reg fails for sing %x\n",
-			ret_val);
-		misc_deregister(&sep->miscdev_sep);
-		return ret_val;
-	}
-
-	ret_val = misc_register(&sep->miscdev_daemon);
-	if (ret_val) {
-		dev_warn(&sep->pdev->dev, "misc reg fails for dmn %x\n",
-			ret_val);
-		misc_deregister(&sep->miscdev_sep);
-		misc_deregister(&sep->miscdev_singleton);
-
-		return ret_val;
-	}
-	return ret_val;
-}
-
-
-/**
- *	sep_probe - probe a matching PCI device
- *	@pdev: pci_device
- *	@end: pci_device_id
- *
- *	Attempt to set up and configure a SEP device that has been
- *	discovered by the PCI layer.
- */
-static int __devinit sep_probe(struct pci_dev *pdev,
-	const struct pci_device_id *ent)
-{
-	int error = 0;
-	struct sep_device *sep;
-
-	if (sep_dev != NULL) {
-		dev_warn(&pdev->dev, "only one SEP supported.\n");
-		return -EBUSY;
-	}
-
-	/* Enable the device */
-	error = pci_enable_device(pdev);
-	if (error) {
-		dev_warn(&pdev->dev, "error enabling pci device\n");
-		goto end_function;
-	}
-
-	/* Allocate the sep_device structure for this device */
-	sep_dev = kzalloc(sizeof(struct sep_device), GFP_ATOMIC);
-	if (sep_dev == NULL) {
-		dev_warn(&pdev->dev,
-			"can't kmalloc the sep_device structure\n");
-		error = -ENOMEM;
-		goto end_function_disable_device;
-	}
-
-	/*
-	 * We're going to use another variable for actually
-	 * working with the device; this way, if we have
-	 * multiple devices in the future, it would be easier
-	 * to make appropriate changes
-	 */
-	sep = sep_dev;
-
-	sep->pdev = pci_dev_get(pdev);
-
-	init_waitqueue_head(&sep->event);
-	init_waitqueue_head(&sep->event_request_daemon);
-	spin_lock_init(&sep->snd_rply_lck);
-	mutex_init(&sep->sep_mutex);
-	mutex_init(&sep->ioctl_mutex);
-
-	dev_dbg(&sep->pdev->dev, "sep probe: PCI obtained, device being prepared\n");
-	dev_dbg(&sep->pdev->dev, "revision is %d\n", sep->pdev->revision);
-
-	/* Set up our register area */
-	sep->reg_physical_addr = pci_resource_start(sep->pdev, 0);
-	if (!sep->reg_physical_addr) {
-		dev_warn(&sep->pdev->dev, "Error getting register start\n");
-		error = -ENODEV;
-		goto end_function_free_sep_dev;
-	}
-
-	sep->reg_physical_end = pci_resource_end(sep->pdev, 0);
-	if (!sep->reg_physical_end) {
-		dev_warn(&sep->pdev->dev, "Error getting register end\n");
-		error = -ENODEV;
-		goto end_function_free_sep_dev;
-	}
-
-	sep->reg_addr = ioremap_nocache(sep->reg_physical_addr,
-		(size_t)(sep->reg_physical_end - sep->reg_physical_addr + 1));
-	if (!sep->reg_addr) {
-		dev_warn(&sep->pdev->dev, "Error getting register virtual\n");
-		error = -ENODEV;
-		goto end_function_free_sep_dev;
-	}
-
-	dev_dbg(&sep->pdev->dev,
-		"Register area start %llx end %llx virtual %p\n",
-		(unsigned long long)sep->reg_physical_addr,
-		(unsigned long long)sep->reg_physical_end,
-		sep->reg_addr);
-
-	/* Allocate the shared area */
-	sep->shared_size = SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES +
-		SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES +
-		SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES +
-		SEP_DRIVER_STATIC_AREA_SIZE_IN_BYTES +
-		SEP_DRIVER_SYSTEM_DATA_MEMORY_SIZE_IN_BYTES;
-
-	if (sep_map_and_alloc_shared_area(sep)) {
-		error = -ENOMEM;
-		/* Allocation failed */
-		goto end_function_error;
-	}
-
-	/* Clear ICR register */
-	sep_write_reg(sep, HW_HOST_ICR_REG_ADDR, 0xFFFFFFFF);
-
-	/* Set the IMR register - open only GPR 2 */
-	sep_write_reg(sep, HW_HOST_IMR_REG_ADDR, (~(0x1 << 13)));
-
-	/* Read send/receive counters from SEP */
-	sep->reply_ct = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
-	sep->reply_ct &= 0x3FFFFFFF;
-	sep->send_ct = sep->reply_ct;
-
-	/* Get the interrupt line */
-	error = request_irq(pdev->irq, sep_inthandler, IRQF_SHARED,
-		"sep_driver", sep);
-
-	if (error)
-		goto end_function_deallocate_sep_shared_area;
-
-	/* The new chip requires a shared area reconfigure */
-	if (sep->pdev->revision == 4) { /* Only for new chip */
-		error = sep_reconfig_shared_area(sep);
-		if (error)
-			goto end_function_free_irq;
-	}
-	/* Finally magic up the device nodes */
-	/* Register driver with the fs */
-	error = sep_register_driver_with_fs(sep);
-	if (error == 0)
-		/* Success */
-		return 0;
-
-end_function_free_irq:
-	free_irq(pdev->irq, sep);
-
-end_function_deallocate_sep_shared_area:
-	/* De-allocate shared area */
-	sep_unmap_and_free_shared_area(sep);
-
-end_function_error:
-	iounmap(sep->reg_addr);
-
-end_function_free_sep_dev:
-	pci_dev_put(sep_dev->pdev);
-	kfree(sep_dev);
-	sep_dev = NULL;
-
-end_function_disable_device:
-	pci_disable_device(pdev);
-
-end_function:
-	return error;
-}
-
-static void sep_remove(struct pci_dev *pdev)
-{
-	struct sep_device *sep = sep_dev;
-
-	/* Unregister from fs */
-	misc_deregister(&sep->miscdev_sep);
-	misc_deregister(&sep->miscdev_singleton);
-	misc_deregister(&sep->miscdev_daemon);
-
-	/* Free the irq */
-	free_irq(sep->pdev->irq, sep);
-
-	/* Free the shared area  */
-	sep_unmap_and_free_shared_area(sep_dev);
-	iounmap((void *) sep_dev->reg_addr);
-}
-
-static DEFINE_PCI_DEVICE_TABLE(sep_pci_id_tbl) = {
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MFLD_PCI_DEVICE_ID)},
-	{0}
-};
-
-MODULE_DEVICE_TABLE(pci, sep_pci_id_tbl);
-
-/* Field for registering driver to PCI device */
-static struct pci_driver sep_pci_driver = {
-	.name = "sep_sec_driver",
-	.id_table = sep_pci_id_tbl,
-	.probe = sep_probe,
-	.remove = sep_remove
-};
-
-
-/**
- *	sep_init - init function
- *
- *	Module load time. Register the PCI device driver.
- */
-static int __init sep_init(void)
-{
-	return pci_register_driver(&sep_pci_driver);
-}
-
-
-/**
- *	sep_exit - called to unload driver
- *
- *	Drop the misc devices then remove and unmap the various resources
- *	that are not released by the driver remove method.
- */
-static void __exit sep_exit(void)
-{
-	pci_unregister_driver(&sep_pci_driver);
-}
-
-
-module_init(sep_init);
-module_exit(sep_exit);
-
-MODULE_LICENSE("GPL");
diff --git a/drivers/staging/sep/sep_driver_api.h b/drivers/staging/sep/sep_driver_api.h
index c3aacfc..78a4b69 100644
--- a/drivers/staging/sep/sep_driver_api.h
+++ b/drivers/staging/sep/sep_driver_api.h
@@ -2,8 +2,8 @@
  *
  *  sep_driver_api.h - Security Processor Driver api definitions
  *
- *  Copyright(c) 2009,2010 Intel Corporation. All rights reserved.
- *  Contributions(c) 2009,2010 Discretix. All rights reserved.
+ *  Copyright(c) 2009-2011 Intel Corporation. All rights reserved.
+ *  Contributions(c) 2009-2011 Discretix. All rights reserved.
  *
  *  This program is free software; you can redistribute it and/or modify it
  *  under the terms of the GNU General Public License as published by the Free
@@ -26,6 +26,7 @@
  *  CHANGES:
  *
  *  2010.09.14  Upgrade to Medfield
+ *  2011.02.22  Enable kernel crypto
  *
  */
 
@@ -37,26 +38,30 @@
 #define SEP_DRIVER_SRC_REQ		2
 #define SEP_DRIVER_SRC_PRINTF		3
 
-
-/*-------------------------------------------
-    TYPEDEFS
-----------------------------------------------*/
-
-struct alloc_struct {
-	/* offset from start of shared pool area */
-	u32  offset;
-	/* number of bytes to allocate */
-	u32  num_bytes;
-};
-
-/* command struct for getting caller id value and address */
-struct caller_id_struct {
-	/* pid of the process */
-	u32 pid;
-	/* virtual address of the caller id hash */
-	aligned_u64 callerIdAddress;
-	/* caller id hash size in bytes */
-	u32 callerIdSizeInBytes;
+/* Power state */
+#define SEP_DRIVER_POWERON		1
+#define SEP_DRIVER_POWEROFF		2
+
+/* Following enums are used only for kernel crypto api */
+enum type_of_request {
+	NO_REQUEST,
+	AES_CBC,
+	AES_ECB,
+	DES_CBC,
+	DES_ECB,
+	DES3_ECB,
+	DES3_CBC,
+	SHA1,
+	MD5,
+	SHA224,
+	SHA256
+	};
+
+enum hash_stage {
+	HASH_INIT,
+	HASH_UPDATE,
+	HASH_FINISH,
+	HASH_DIGEST
 };
 
 /*
@@ -83,11 +88,6 @@ struct sep_dcblock {
 	u8	tail_data[68];
 };
 
-struct sep_caller_id_entry {
-	int pid;
-	unsigned char callerIdHash[SEP_CALLER_ID_HASH_SIZE_IN_BYTES];
-};
-
 /*
 	command structure for building dcb block (currently for ext app only
 */
@@ -104,6 +104,33 @@ struct build_dcb_struct {
 	/* the size of the block of the operation - if needed,
 	every table will be modulo this parameter */
 	u32  tail_block_size;
+
+	/* which application calls the driver DX or applet */
+	u32  is_applet;
+};
+
+/*
+	command structure for building dcb block for kernel crypto
+*/
+struct build_dcb_struct_kernel {
+	/* address value of the data in */
+	void *app_in_address;
+	/* size of data in */
+	ssize_t  data_in_size;
+	/* address of the data out */
+	void *app_out_address;
+	/* the size of the block of the operation - if needed,
+	every table will be modulo this parameter */
+	u32  block_size;
+	/* the size of the block of the operation - if needed,
+	every table will be modulo this parameter */
+	u32  tail_block_size;
+
+	/* which application calls the driver DX or applet */
+	u32  is_applet;
+
+	struct scatterlist *src_sg;
+	struct scatterlist *dst_sg;
 };
 
 /**
@@ -147,6 +174,10 @@ struct sep_dma_resource {
 
 	/* number of entries of the output mapp array */
 	u32 out_map_num_entries;
+
+	/* Scatter list for kernel operations */
+	struct scatterlist *src_sg;
+	struct scatterlist *dst_sg;
 };
 
 
@@ -169,47 +200,190 @@ struct sep_lli_entry {
 	u32 block_size;
 };
 
-/*----------------------------------------------------------------
-	IOCTL command defines
-	-----------------------------------------------------------------*/
+/*
+ * header format for each fastcall write operation
+ */
+struct sep_fastcall_hdr {
+	u32 magic;
+	u32 msg_len;
+	u32 num_dcbs;
+};
 
-/* magic number 1 of the sep IOCTL command */
-#define SEP_IOC_MAGIC_NUMBER	                     's'
+/*
+ * structure used in file pointer's private data field
+ * to track the status of the calls to the various
+ * driver interface
+ */
+struct sep_call_status {
+	unsigned long status;
+};
 
-/* sends interrupt to sep that message is ready */
-#define SEP_IOCSENDSEPCOMMAND	 \
-	_IO(SEP_IOC_MAGIC_NUMBER, 0)
+/*
+ * format of dma context buffer used to store all DMA-related
+ * context information of a particular transaction
+ */
+struct sep_dma_context {
+	/* number of data control blocks */
+	u32 nr_dcb_creat;
+	/* number of the lli tables created in the current transaction */
+	u32 num_lli_tables_created;
+	/* size of currently allocated dma tables region */
+	u32 dmatables_len;
+	/* size of input data */
+	u32 input_data_len;
+	struct sep_dma_resource dma_res_arr[SEP_MAX_NUM_SYNC_DMA_OPS];
+	/* Scatter gather for kernel crypto */
+	struct scatterlist *src_sg;
+	struct scatterlist *dst_sg;
+};
 
-/* sends interrupt to sep that message is ready */
-#define SEP_IOCSENDSEPRPLYCOMMAND	 \
-	_IO(SEP_IOC_MAGIC_NUMBER, 1)
+/*
+ * format for file pointer's private_data field
+ */
+struct sep_private_data {
+	struct sep_queue_info *my_queue_elem;
+	struct sep_device *device;
+	struct sep_call_status call_status;
+	struct sep_dma_context *dma_ctx;
+};
+
+
+/* Functions used by sep_crypto */
+
+/**
+ * sep_queue_status_remove - Removes transaction from status queue
+ * @sep: SEP device
+ * @sep_queue_info: pointer to status queue
+ *
+ * This function will removes information about transaction from the queue.
+ */
+void sep_queue_status_remove(struct sep_device *sep,
+				      struct sep_queue_info **queue_elem);
+/**
+ * sep_queue_status_add - Adds transaction to status queue
+ * @sep: SEP device
+ * @opcode: transaction opcode
+ * @size: input data size
+ * @pid: pid of current process
+ * @name: current process name
+ * @name_len: length of name (current process)
+ *
+ * This function adds information about about transaction started to the status
+ * queue.
+ */
+struct sep_queue_info *sep_queue_status_add(
+						struct sep_device *sep,
+						u32 opcode,
+						u32 size,
+						u32 pid,
+						u8 *name, size_t name_len);
 
-/* allocate memory in data pool */
-#define SEP_IOCALLOCDATAPOLL	\
-	_IOW(SEP_IOC_MAGIC_NUMBER, 2, struct alloc_struct)
+/**
+ *	sep_create_dcb_dmatables_context_kernel - Creates DCB & MLLI/DMA table context
+ *      for kernel crypto
+ *	@sep: SEP device
+ *	@dcb_region: DCB region buf to create for current transaction
+ *	@dmatables_region: MLLI/DMA tables buf to create for current transaction
+ *	@dma_ctx: DMA context buf to create for current transaction
+ *	@user_dcb_args: User arguments for DCB/MLLI creation
+ *	@num_dcbs: Number of DCBs to create
+ */
+int sep_create_dcb_dmatables_context_kernel(struct sep_device *sep,
+			struct sep_dcblock **dcb_region,
+			void **dmatables_region,
+			struct sep_dma_context **dma_ctx,
+			const struct build_dcb_struct_kernel *dcb_data,
+			const u32 num_dcbs);
 
-/* free dynamic data aalocated during table creation */
-#define SEP_IOCFREEDMATABLEDATA	 \
-	_IO(SEP_IOC_MAGIC_NUMBER, 7)
+/**
+ *	sep_activate_dcb_dmatables_context - Takes DCB & DMA tables
+ *						contexts into use
+ *	@sep: SEP device
+ *	@dcb_region: DCB region copy
+ *	@dmatables_region: MLLI/DMA tables copy
+ *	@dma_ctx: DMA context for current transaction
+ */
+ssize_t sep_activate_dcb_dmatables_context(struct sep_device *sep,
+					struct sep_dcblock **dcb_region,
+					void **dmatables_region,
+					struct sep_dma_context *dma_ctx);
 
-/* get the static pool area addersses (physical and virtual) */
-#define SEP_IOCGETSTATICPOOLADDR	\
-	_IO(SEP_IOC_MAGIC_NUMBER, 8)
+/**
+ * sep_prepare_input_output_dma_table_in_dcb - prepare control blocks
+ * @app_in_address: unsigned long; for data buffer in (user space)
+ * @app_out_address: unsigned long; for data buffer out (user space)
+ * @data_in_size: u32; for size of data
+ * @block_size: u32; for block size
+ * @tail_block_size: u32; for size of tail block
+ * @isapplet: bool; to indicate external app
+ * @is_kva: bool; kernel buffer; only used for kernel crypto module
+ *
+ * This function prepares the linked DMA tables and puts the
+ * address for the linked list of tables inta a DCB (data control
+ * block) the address of which is known by the SEP hardware
+ * Note that all bus addresses that are passed to the SEP
+ * are in 32 bit format; the SEP is a 32 bit device
+ */
+int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
+	unsigned long  app_in_address,
+	unsigned long  app_out_address,
+	u32  data_in_size,
+	u32  block_size,
+	u32  tail_block_size,
+	bool isapplet,
+	bool	is_kva,
+	struct sep_dcblock *dcb_region,
+	void **dmatables_region,
+	struct sep_dma_context **dma_ctx,
+	struct scatterlist *src_sg,
+	struct scatterlist *dst_sg);
+
+/**
+ * sep_free_dma_table_data_handler - free DMA table
+ * @sep: pointere to struct sep_device
+ * @dma_ctx: dma context
+ *
+ * Handles the request to  free DMA table for synchronic actions
+ */
+int sep_free_dma_table_data_handler(struct sep_device *sep,
+					   struct sep_dma_context **dma_ctx);
+/**
+ * sep_send_command_handler - kick off a command
+ * @sep: SEP being signalled
+ *
+ * This function raises interrupt to SEP that signals that is has a new
+ * command from the host
+ *
+ * Note that this function does fall under the ioctl lock
+ */
+int sep_send_command_handler(struct sep_device *sep);
+
+/**
+ *	sep_wait_transaction - Used for synchronizing transactions
+ *	@sep: SEP device
+ */
+int sep_wait_transaction(struct sep_device *sep);
+
+/**
+ * IOCTL command defines
+ */
+/* magic number 1 of the sep IOCTL command */
+#define SEP_IOC_MAGIC_NUMBER	's'
+
+/* sends interrupt to sep that message is ready */
+#define SEP_IOCSENDSEPCOMMAND	 \
+	_IO(SEP_IOC_MAGIC_NUMBER, 0)
 
 /* end transaction command */
 #define SEP_IOCENDTRANSACTION	 \
 	_IO(SEP_IOC_MAGIC_NUMBER, 15)
 
-#define SEP_IOCRARPREPAREMESSAGE	\
-	_IOW(SEP_IOC_MAGIC_NUMBER, 20, struct rar_hndl_to_bus_struct)
-
-#define SEP_IOCTLSETCALLERID	\
-	_IOW(SEP_IOC_MAGIC_NUMBER, 34, struct caller_id_struct)
-
 #define SEP_IOCPREPAREDCB					\
 	_IOW(SEP_IOC_MAGIC_NUMBER, 35, struct build_dcb_struct)
 
 #define SEP_IOCFREEDCB					\
 	_IO(SEP_IOC_MAGIC_NUMBER, 36)
 
+struct sep_device;
+
 #endif
diff --git a/drivers/staging/sep/sep_driver_config.h b/drivers/staging/sep/sep_driver_config.h
index d6bfd24..fa7c0d0 100644
--- a/drivers/staging/sep/sep_driver_config.h
+++ b/drivers/staging/sep/sep_driver_config.h
@@ -2,8 +2,8 @@
  *
  *  sep_driver_config.h - Security Processor Driver configuration
  *
- *  Copyright(c) 2009,2010 Intel Corporation. All rights reserved.
- *  Contributions(c) 2009,2010 Discretix. All rights reserved.
+ *  Copyright(c) 2009-2011 Intel Corporation. All rights reserved.
+ *  Contributions(c) 2009-2011 Discretix. All rights reserved.
  *
  *  This program is free software; you can redistribute it and/or modify it
  *  under the terms of the GNU General Public License as published by the Free
@@ -26,6 +26,7 @@
  *  CHANGES:
  *
  *  2010.06.26	Upgrade to Medfield
+ *  2011.02.22  Enable kernel crypto
  *
  */
 
@@ -48,6 +49,8 @@
 /* the mode for running on the ARM1172 Evaluation platform (flag is 1) */
 #define SEP_DRIVER_ARM_DEBUG_MODE                       0
 
+/* Critical message area contents for sanity checking */
+#define SEP_START_MSG_TOKEN				0x02558808
 /*-------------------------------------------
 	INTERNAL DATA CONFIGURATION
 	-------------------------------------------*/
@@ -65,21 +68,17 @@
 #define SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE		16
 
 /* flag that signifies tah the lock is
-currently held by the process (struct file) */
+currently held by the proccess (struct file) */
 #define SEP_DRIVER_OWN_LOCK_FLAG                        1
 
 /* flag that signifies tah the lock is currently NOT
-held by the process (struct file) */
+held by the proccess (struct file) */
 #define SEP_DRIVER_DISOWN_LOCK_FLAG                     0
 
 /* indicates whether driver has mapped/unmapped shared area */
 #define SEP_REQUEST_DAEMON_MAPPED 1
 #define SEP_REQUEST_DAEMON_UNMAPPED 0
 
-#define SEP_DEV_NAME "sep_sec_driver"
-#define SEP_DEV_SINGLETON "sep_sec_singleton_driver"
-#define SEP_DEV_DAEMON "sep_req_daemon_driver"
-
 /*--------------------------------------------------------
 	SHARED AREA  memory total size is 36K
 	it is divided is following:
@@ -90,7 +89,7 @@ held by the process (struct file) */
 									}
 	DATA_POOL_AREA                          12K        }
 
-	SYNCHRONIC_DMA_TABLES_AREA              5K
+	SYNCHRONIC_DMA_TABLES_AREA              29K
 
 	placeholder until drver changes
 	FLOW_DMA_TABLES_AREA                    4K
@@ -109,6 +108,12 @@ held by the process (struct file) */
 
 
 /*
+	the minimum length of the message - includes 2 reserved fields
+	at the start, then token, message size and opcode fields. all dwords
+*/
+#define SEP_DRIVER_MIN_MESSAGE_SIZE_IN_BYTES			(5*sizeof(u32))
+
+/*
 	the maximum length of the message - the rest of the message shared
 	area will be dedicated to the dma lli tables
 */
@@ -124,7 +129,7 @@ held by the process (struct file) */
 #define SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES		(16 * 1024)
 
 /* the size of the message shared area in pages */
-#define SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES	(1024 * 5)
+#define SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES	(1024 * 29)
 
 /* Placeholder until driver changes */
 #define SEP_DRIVER_FLOW_DMA_TABLES_AREA_SIZE_IN_BYTES		(1024 * 4)
@@ -132,6 +137,9 @@ held by the process (struct file) */
 /* system data (time, caller id etc') pool */
 #define SEP_DRIVER_SYSTEM_DATA_MEMORY_SIZE_IN_BYTES		(1024 * 3)
 
+/* Offset of the sep printf buffer in the message area */
+#define SEP_DRIVER_PRINTF_OFFSET_IN_BYTES			(5888)
+
 /* the size in bytes of the time memory */
 #define SEP_DRIVER_TIME_MEMORY_SIZE_IN_BYTES			8
 
@@ -223,10 +231,10 @@ held by the process (struct file) */
 #define SEP_ALREADY_INITIALIZED_ERR                           12
 
 /* bit that locks access to the shared area */
-#define SEP_MMAP_LOCK_BIT                                     0
+#define SEP_TRANSACTION_STARTED_LOCK_BIT                      0
 
 /* bit that lock access to the poll  - after send_command */
-#define SEP_SEND_MSG_LOCK_BIT                                 1
+#define SEP_WORKING_LOCK_BIT                                  1
 
 /* the token that defines the static pool address address */
 #define SEP_STATIC_POOL_VAL_TOKEN                             0xABBAABBA
@@ -240,4 +248,51 @@ held by the process (struct file) */
 /* Time limit for SEP to finish */
 #define WAIT_TIME 10
 
+/* Delay for pm runtime suspend (reduces pm thrashing with bursty traffic */
+#define SUSPEND_DELAY 10
+
+/* Number of delays to wait until scu boots after runtime resume */
+#define SCU_DELAY_MAX 50
+
+/* Delay for each iteration (usec) wait for scu boots after runtime resume */
+#define SCU_DELAY_ITERATION 10
+
+
+/*
+ * Bits used in struct sep_call_status to check that
+ * driver's APIs are called in valid order
+ */
+
+/* Bit offset which indicates status of sep_write() */
+#define SEP_FASTCALL_WRITE_DONE_OFFSET		0
+
+/* Bit offset which indicates status of sep_mmap() */
+#define SEP_LEGACY_MMAP_DONE_OFFSET		1
+
+/* Bit offset which indicates status of the SEP_IOCSENDSEPCOMMAND ioctl */
+#define SEP_LEGACY_SENDMSG_DONE_OFFSET		2
+
+/* Bit offset which indicates status of sep_poll() */
+#define SEP_LEGACY_POLL_DONE_OFFSET		3
+
+/* Bit offset which indicates status of the SEP_IOCENDTRANSACTION ioctl */
+#define SEP_LEGACY_ENDTRANSACTION_DONE_OFFSET	4
+
+/*
+ * Used to limit number of concurrent processes
+ * allowed to allocte dynamic buffers in fastcall
+ * interface.
+ */
+#define SEP_DOUBLEBUF_USERS_LIMIT		3
+
+/* Identifier for valid fastcall header */
+#define SEP_FC_MAGIC				0xFFAACCAA
+
+/*
+ * Used for enabling driver runtime power management.
+ * Useful for enabling/disabling it during performance
+ * testing
+ */
+#define SEP_ENABLE_RUNTIME_PM
+
 #endif /* SEP DRIVER CONFIG */
diff --git a/drivers/staging/sep/sep_driver_hw_defs.h b/drivers/staging/sep/sep_driver_hw_defs.h
index 300f909..c48e49a 100644
--- a/drivers/staging/sep/sep_driver_hw_defs.h
+++ b/drivers/staging/sep/sep_driver_hw_defs.h
@@ -2,8 +2,8 @@
  *
  *  sep_driver_hw_defs.h - Security Processor Driver hardware definitions
  *
- *  Copyright(c) 2009,2010 Intel Corporation. All rights reserved.
- *  Contributions(c) 2009,2010 Discretix. All rights reserved.
+ *  Copyright(c) 2009-2011 Intel Corporation. All rights reserved.
+ *  Contributions(c) 2009-2011 Discretix. All rights reserved.
  *
  *  This program is free software; you can redistribute it and/or modify it
  *  under the terms of the GNU General Public License as published by the Free
@@ -26,6 +26,7 @@
  *  CHANGES:
  *
  *  2010.09.20	Upgrade to Medfield
+ *  2011.02.22  Enable kernel crypto
  *
  */
 
@@ -42,181 +43,9 @@
 
 
 /* cf registers */
-#define		HW_R0B_ADDR_0_REG_ADDR			0x0000UL
-#define		HW_R0B_ADDR_1_REG_ADDR			0x0004UL
-#define		HW_R0B_ADDR_2_REG_ADDR			0x0008UL
-#define		HW_R0B_ADDR_3_REG_ADDR			0x000cUL
-#define		HW_R0B_ADDR_4_REG_ADDR			0x0010UL
-#define		HW_R0B_ADDR_5_REG_ADDR			0x0014UL
-#define		HW_R0B_ADDR_6_REG_ADDR			0x0018UL
-#define		HW_R0B_ADDR_7_REG_ADDR			0x001cUL
-#define		HW_R0B_ADDR_8_REG_ADDR			0x0020UL
-#define		HW_R2B_ADDR_0_REG_ADDR			0x0080UL
-#define		HW_R2B_ADDR_1_REG_ADDR			0x0084UL
-#define		HW_R2B_ADDR_2_REG_ADDR			0x0088UL
-#define		HW_R2B_ADDR_3_REG_ADDR			0x008cUL
-#define		HW_R2B_ADDR_4_REG_ADDR			0x0090UL
-#define		HW_R2B_ADDR_5_REG_ADDR			0x0094UL
-#define		HW_R2B_ADDR_6_REG_ADDR			0x0098UL
-#define		HW_R2B_ADDR_7_REG_ADDR			0x009cUL
-#define		HW_R2B_ADDR_8_REG_ADDR			0x00a0UL
-#define		HW_R3B_REG_ADDR				0x00C0UL
-#define		HW_R4B_REG_ADDR				0x0100UL
-#define		HW_CSA_ADDR_0_REG_ADDR			0x0140UL
-#define		HW_CSA_ADDR_1_REG_ADDR			0x0144UL
-#define		HW_CSA_ADDR_2_REG_ADDR			0x0148UL
-#define		HW_CSA_ADDR_3_REG_ADDR			0x014cUL
-#define		HW_CSA_ADDR_4_REG_ADDR			0x0150UL
-#define		HW_CSA_ADDR_5_REG_ADDR			0x0154UL
-#define		HW_CSA_ADDR_6_REG_ADDR			0x0158UL
-#define		HW_CSA_ADDR_7_REG_ADDR			0x015cUL
-#define		HW_CSA_ADDR_8_REG_ADDR			0x0160UL
-#define		HW_CSA_REG_ADDR				0x0140UL
-#define		HW_SINB_REG_ADDR			0x0180UL
-#define		HW_SOUTB_REG_ADDR			0x0184UL
-#define		HW_PKI_CONTROL_REG_ADDR			0x01C0UL
-#define		HW_PKI_STATUS_REG_ADDR			0x01C4UL
-#define		HW_PKI_BUSY_REG_ADDR			0x01C8UL
-#define		HW_PKI_A_1025_REG_ADDR			0x01CCUL
-#define		HW_PKI_SDMA_CTL_REG_ADDR		0x01D0UL
-#define		HW_PKI_SDMA_OFFSET_REG_ADDR		0x01D4UL
-#define		HW_PKI_SDMA_POINTERS_REG_ADDR		0x01D8UL
-#define		HW_PKI_SDMA_DLENG_REG_ADDR		0x01DCUL
-#define		HW_PKI_SDMA_EXP_POINTERS_REG_ADDR	0x01E0UL
-#define		HW_PKI_SDMA_RES_POINTERS_REG_ADDR	0x01E4UL
-#define		HW_PKI_CLR_REG_ADDR			0x01E8UL
-#define		HW_PKI_SDMA_BUSY_REG_ADDR		0x01E8UL
-#define		HW_PKI_SDMA_FIRST_EXP_N_REG_ADDR	0x01ECUL
-#define		HW_PKI_SDMA_MUL_BY1_REG_ADDR		0x01F0UL
-#define		HW_PKI_SDMA_RMUL_SEL_REG_ADDR		0x01F4UL
-#define		HW_DES_KEY_0_REG_ADDR			0x0208UL
-#define		HW_DES_KEY_1_REG_ADDR			0x020CUL
-#define		HW_DES_KEY_2_REG_ADDR			0x0210UL
-#define		HW_DES_KEY_3_REG_ADDR			0x0214UL
-#define		HW_DES_KEY_4_REG_ADDR			0x0218UL
-#define		HW_DES_KEY_5_REG_ADDR			0x021CUL
-#define		HW_DES_CONTROL_0_REG_ADDR		0x0220UL
-#define		HW_DES_CONTROL_1_REG_ADDR		0x0224UL
-#define		HW_DES_IV_0_REG_ADDR			0x0228UL
-#define		HW_DES_IV_1_REG_ADDR			0x022CUL
-#define		HW_AES_KEY_0_ADDR_0_REG_ADDR		0x0400UL
-#define		HW_AES_KEY_0_ADDR_1_REG_ADDR		0x0404UL
-#define		HW_AES_KEY_0_ADDR_2_REG_ADDR		0x0408UL
-#define		HW_AES_KEY_0_ADDR_3_REG_ADDR		0x040cUL
-#define		HW_AES_KEY_0_ADDR_4_REG_ADDR		0x0410UL
-#define		HW_AES_KEY_0_ADDR_5_REG_ADDR		0x0414UL
-#define		HW_AES_KEY_0_ADDR_6_REG_ADDR		0x0418UL
-#define		HW_AES_KEY_0_ADDR_7_REG_ADDR		0x041cUL
-#define		HW_AES_KEY_0_REG_ADDR			0x0400UL
-#define		HW_AES_IV_0_ADDR_0_REG_ADDR		0x0440UL
-#define		HW_AES_IV_0_ADDR_1_REG_ADDR		0x0444UL
-#define		HW_AES_IV_0_ADDR_2_REG_ADDR		0x0448UL
-#define		HW_AES_IV_0_ADDR_3_REG_ADDR		0x044cUL
-#define		HW_AES_IV_0_REG_ADDR			0x0440UL
-#define		HW_AES_CTR1_ADDR_0_REG_ADDR		0x0460UL
-#define		HW_AES_CTR1_ADDR_1_REG_ADDR		0x0464UL
-#define		HW_AES_CTR1_ADDR_2_REG_ADDR		0x0468UL
-#define		HW_AES_CTR1_ADDR_3_REG_ADDR		0x046cUL
-#define		HW_AES_CTR1_REG_ADDR			0x0460UL
-#define		HW_AES_SK_REG_ADDR			0x0478UL
-#define		HW_AES_MAC_OK_REG_ADDR			0x0480UL
-#define		HW_AES_PREV_IV_0_ADDR_0_REG_ADDR	0x0490UL
-#define		HW_AES_PREV_IV_0_ADDR_1_REG_ADDR	0x0494UL
-#define		HW_AES_PREV_IV_0_ADDR_2_REG_ADDR	0x0498UL
-#define		HW_AES_PREV_IV_0_ADDR_3_REG_ADDR	0x049cUL
-#define		HW_AES_PREV_IV_0_REG_ADDR		0x0490UL
-#define		HW_AES_CONTROL_REG_ADDR			0x04C0UL
-#define		HW_HASH_H0_REG_ADDR			0x0640UL
-#define		HW_HASH_H1_REG_ADDR			0x0644UL
-#define		HW_HASH_H2_REG_ADDR			0x0648UL
-#define		HW_HASH_H3_REG_ADDR			0x064CUL
-#define		HW_HASH_H4_REG_ADDR			0x0650UL
-#define		HW_HASH_H5_REG_ADDR			0x0654UL
-#define		HW_HASH_H6_REG_ADDR			0x0658UL
-#define		HW_HASH_H7_REG_ADDR			0x065CUL
-#define		HW_HASH_H8_REG_ADDR			0x0660UL
-#define		HW_HASH_H9_REG_ADDR			0x0664UL
-#define		HW_HASH_H10_REG_ADDR			0x0668UL
-#define		HW_HASH_H11_REG_ADDR			0x066CUL
-#define		HW_HASH_H12_REG_ADDR			0x0670UL
-#define		HW_HASH_H13_REG_ADDR			0x0674UL
-#define		HW_HASH_H14_REG_ADDR			0x0678UL
-#define		HW_HASH_H15_REG_ADDR			0x067CUL
-#define		HW_HASH_CONTROL_REG_ADDR		0x07C0UL
-#define		HW_HASH_PAD_EN_REG_ADDR			0x07C4UL
-#define		HW_HASH_PAD_CFG_REG_ADDR		0x07C8UL
-#define		HW_HASH_CUR_LEN_0_REG_ADDR		0x07CCUL
-#define		HW_HASH_CUR_LEN_1_REG_ADDR		0x07D0UL
-#define		HW_HASH_CUR_LEN_2_REG_ADDR		0x07D4UL
-#define		HW_HASH_CUR_LEN_3_REG_ADDR		0x07D8UL
-#define		HW_HASH_PARAM_REG_ADDR			0x07DCUL
-#define		HW_HASH_INT_BUSY_REG_ADDR		0x07E0UL
-#define		HW_HASH_SW_RESET_REG_ADDR		0x07E4UL
-#define		HW_HASH_ENDIANESS_REG_ADDR		0x07E8UL
-#define		HW_HASH_DATA_REG_ADDR			0x07ECUL
-#define		HW_DRNG_CONTROL_REG_ADDR		0x0800UL
-#define		HW_DRNG_VALID_REG_ADDR			0x0804UL
-#define		HW_DRNG_DATA_REG_ADDR			0x0808UL
-#define		HW_RND_SRC_EN_REG_ADDR			0x080CUL
-#define		HW_AES_CLK_ENABLE_REG_ADDR		0x0810UL
-#define		HW_DES_CLK_ENABLE_REG_ADDR		0x0814UL
-#define		HW_HASH_CLK_ENABLE_REG_ADDR		0x0818UL
-#define		HW_PKI_CLK_ENABLE_REG_ADDR		0x081CUL
-#define		HW_CLK_STATUS_REG_ADDR			0x0824UL
-#define		HW_CLK_ENABLE_REG_ADDR			0x0828UL
-#define		HW_DRNG_SAMPLE_REG_ADDR			0x0850UL
-#define		HW_RND_SRC_CTL_REG_ADDR			0x0858UL
-#define		HW_CRYPTO_CTL_REG_ADDR			0x0900UL
-#define		HW_CRYPTO_STATUS_REG_ADDR		0x090CUL
-#define		HW_CRYPTO_BUSY_REG_ADDR			0x0910UL
-#define		HW_AES_BUSY_REG_ADDR			0x0914UL
-#define		HW_DES_BUSY_REG_ADDR			0x0918UL
-#define		HW_HASH_BUSY_REG_ADDR			0x091CUL
-#define		HW_CONTENT_REG_ADDR			0x0924UL
-#define		HW_VERSION_REG_ADDR			0x0928UL
-#define		HW_CONTEXT_ID_REG_ADDR			0x0930UL
-#define		HW_DIN_BUFFER_REG_ADDR			0x0C00UL
-#define		HW_DIN_MEM_DMA_BUSY_REG_ADDR		0x0c20UL
-#define		HW_SRC_LLI_MEM_ADDR_REG_ADDR		0x0c24UL
-#define		HW_SRC_LLI_WORD0_REG_ADDR		0x0C28UL
-#define		HW_SRC_LLI_WORD1_REG_ADDR		0x0C2CUL
-#define		HW_SRAM_SRC_ADDR_REG_ADDR		0x0c30UL
-#define		HW_DIN_SRAM_BYTES_LEN_REG_ADDR		0x0c34UL
-#define		HW_DIN_SRAM_DMA_BUSY_REG_ADDR		0x0C38UL
-#define		HW_WRITE_ALIGN_REG_ADDR			0x0C3CUL
-#define		HW_OLD_DATA_REG_ADDR			0x0C48UL
-#define		HW_WRITE_ALIGN_LAST_REG_ADDR		0x0C4CUL
-#define		HW_DOUT_BUFFER_REG_ADDR			0x0C00UL
-#define		HW_DST_LLI_WORD0_REG_ADDR		0x0D28UL
-#define		HW_DST_LLI_WORD1_REG_ADDR		0x0D2CUL
-#define		HW_DST_LLI_MEM_ADDR_REG_ADDR		0x0D24UL
-#define		HW_DOUT_MEM_DMA_BUSY_REG_ADDR		0x0D20UL
-#define		HW_SRAM_DEST_ADDR_REG_ADDR		0x0D30UL
-#define		HW_DOUT_SRAM_BYTES_LEN_REG_ADDR		0x0D34UL
-#define		HW_DOUT_SRAM_DMA_BUSY_REG_ADDR		0x0D38UL
-#define		HW_READ_ALIGN_REG_ADDR			0x0D3CUL
-#define		HW_READ_LAST_DATA_REG_ADDR		0x0D44UL
-#define		HW_RC4_THRU_CPU_REG_ADDR		0x0D4CUL
-#define		HW_AHB_SINGLE_REG_ADDR			0x0E00UL
-#define		HW_SRAM_DATA_REG_ADDR			0x0F00UL
-#define		HW_SRAM_ADDR_REG_ADDR			0x0F04UL
-#define		HW_SRAM_DATA_READY_REG_ADDR		0x0F08UL
 #define		HW_HOST_IRR_REG_ADDR			0x0A00UL
 #define		HW_HOST_IMR_REG_ADDR			0x0A04UL
 #define		HW_HOST_ICR_REG_ADDR			0x0A08UL
-#define		HW_HOST_SEP_SRAM_THRESHOLD_REG_ADDR	0x0A10UL
-#define		HW_HOST_SEP_BUSY_REG_ADDR		0x0A14UL
-#define		HW_HOST_SEP_LCS_REG_ADDR		0x0A18UL
-#define		HW_HOST_CC_SW_RST_REG_ADDR		0x0A40UL
-#define		HW_HOST_SEP_SW_RST_REG_ADDR		0x0A44UL
-#define		HW_HOST_FLOW_DMA_SW_INT0_REG_ADDR	0x0A80UL
-#define		HW_HOST_FLOW_DMA_SW_INT1_REG_ADDR	0x0A84UL
-#define		HW_HOST_FLOW_DMA_SW_INT2_REG_ADDR	0x0A88UL
-#define		HW_HOST_FLOW_DMA_SW_INT3_REG_ADDR	0x0A8cUL
-#define		HW_HOST_FLOW_DMA_SW_INT4_REG_ADDR	0x0A90UL
-#define		HW_HOST_FLOW_DMA_SW_INT5_REG_ADDR	0x0A94UL
-#define		HW_HOST_FLOW_DMA_SW_INT6_REG_ADDR	0x0A98UL
-#define		HW_HOST_FLOW_DMA_SW_INT7_REG_ADDR	0x0A9cUL
 #define		HW_HOST_SEP_HOST_GPR0_REG_ADDR		0x0B00UL
 #define		HW_HOST_SEP_HOST_GPR1_REG_ADDR		0x0B04UL
 #define		HW_HOST_SEP_HOST_GPR2_REG_ADDR		0x0B08UL
@@ -225,9 +54,6 @@
 #define		HW_HOST_HOST_SEP_GPR1_REG_ADDR		0x0B84UL
 #define		HW_HOST_HOST_SEP_GPR2_REG_ADDR		0x0B88UL
 #define		HW_HOST_HOST_SEP_GPR3_REG_ADDR		0x0B8CUL
-#define		HW_HOST_HOST_ENDIAN_REG_ADDR		0x0B90UL
-#define		HW_HOST_HOST_COMM_CLK_EN_REG_ADDR	0x0B94UL
-#define		HW_CLR_SRAM_BUSY_REG_REG_ADDR		0x0F0CUL
-#define		HW_CC_SRAM_BASE_ADDRESS			0x5800UL
+#define		HW_SRAM_DATA_READY_REG_ADDR		0x0F08UL
 
 #endif		/* ifndef HW_DEFS */
diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
new file mode 100644
index 0000000..0defb0a
--- /dev/null
+++ b/drivers/staging/sep/sep_main.c
@@ -0,0 +1,4286 @@
+/*
+ *
+ *  sep_main.c - Security Processor Driver main group of functions
+ *
+ *  Copyright(c) 2009-2011 Intel Corporation. All rights reserved.
+ *  Contributions(c) 2009-2011 Discretix. All rights reserved.
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
+ *  2011.01.21  Move to sep_main.c to allow for sep_crypto.c
+ *  2011.02.22  Enable kernel crypto operation
+ *
+ *  Please note that this driver is based on information in the Discretix
+ *  CryptoCell 5.2 Driver Implementation Guide; the Discretix CryptoCell 5.2
+ *  Integration Intel Medfield appendix; the Discretix CryptoCell 5.2
+ *  Linux Driver Integration Guide; and the Discretix CryptoCell 5.2 System
+ *  Overview and Integration Guide.
+ */
+/* #define DEBUG */
+/* #define SEP_PERF_DEBUG */
+
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
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/ioctl.h>
+#include <asm/current.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/pagemap.h>
+#include <asm/cacheflush.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <linux/jiffies.h>
+#include <linux/async.h>
+#include <linux/crypto.h>
+#include <crypto/internal/hash.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/sha.h>
+#include <crypto/md5.h>
+#include <crypto/aes.h>
+#include <crypto/des.h>
+#include <crypto/hash.h>
+
+#include "sep_driver_hw_defs.h"
+#include "sep_driver_config.h"
+#include "sep_driver_api.h"
+#include "sep_dev.h"
+#include "sep_crypto.h"
+
+#define CREATE_TRACE_POINTS
+#include "sep_trace_events.h"
+
+/*
+ * Let's not spend cycles iterating over message
+ * area contents if debugging not enabled
+ */
+#ifdef DEBUG
+#define sep_dump_message(sep)	_sep_dump_message(sep)
+#else
+#define sep_dump_message(sep)
+#endif
+
+/**
+ * Currenlty, there is only one SEP device per platform;
+ * In event platforms in the future have more than one SEP
+ * device, this will be a linked list
+ */
+
+struct sep_device *sep_dev;
+
+/**
+ * sep_queue_status_remove - Removes transaction from status queue
+ * @sep: SEP device
+ * @sep_queue_info: pointer to status queue
+ *
+ * This function will removes information about transaction from the queue.
+ */
+void sep_queue_status_remove(struct sep_device *sep,
+				      struct sep_queue_info **queue_elem)
+{
+	unsigned long lck_flags;
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] sep_queue_status_remove\n",
+		current->pid);
+
+	if (!queue_elem || !(*queue_elem)) {
+		dev_dbg(&sep->pdev->dev, "PID%d %s null\n",
+					current->pid, __func__);
+		return;
+	}
+
+	spin_lock_irqsave(&sep->sep_queue_lock, lck_flags);
+	list_del(&(*queue_elem)->list);
+	sep->sep_queue_num--;
+	spin_unlock_irqrestore(&sep->sep_queue_lock, lck_flags);
+
+	kfree(*queue_elem);
+	*queue_elem = NULL;
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] sep_queue_status_remove return\n",
+		current->pid);
+	return;
+}
+
+/**
+ * sep_queue_status_add - Adds transaction to status queue
+ * @sep: SEP device
+ * @opcode: transaction opcode
+ * @size: input data size
+ * @pid: pid of current process
+ * @name: current process name
+ * @name_len: length of name (current process)
+ *
+ * This function adds information about about transaction started to the status
+ * queue.
+ */
+struct sep_queue_info *sep_queue_status_add(
+						struct sep_device *sep,
+						u32 opcode,
+						u32 size,
+						u32 pid,
+						u8 *name, size_t name_len)
+{
+	unsigned long lck_flags;
+	struct sep_queue_info *my_elem = NULL;
+
+	my_elem = kzalloc(sizeof(struct sep_queue_info), GFP_KERNEL);
+
+	if (!my_elem)
+		return NULL;
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] kzalloc ok\n", current->pid);
+
+	my_elem->data.opcode = opcode;
+	my_elem->data.size = size;
+	my_elem->data.pid = pid;
+
+	if (name_len > TASK_COMM_LEN)
+		name_len = TASK_COMM_LEN;
+
+	memcpy(&my_elem->data.name, name, name_len);
+
+	spin_lock_irqsave(&sep->sep_queue_lock, lck_flags);
+
+	list_add_tail(&my_elem->list, &sep->sep_queue_status);
+	sep->sep_queue_num++;
+
+	spin_unlock_irqrestore(&sep->sep_queue_lock, lck_flags);
+
+	return my_elem;
+}
+
+/**
+ *	sep_allocate_dmatables_region - Allocates buf for the MLLI/DMA tables
+ *	@sep: SEP device
+ *	@dmatables_region: Destination pointer for the buffer
+ *	@dma_ctx: DMA context for the transaction
+ *	@table_count: Number of MLLI/DMA tables to create
+ *	The buffer created will not work as-is for DMA operations,
+ *	it needs to be copied over to the appropriate place in the
+ *	shared area.
+ */
+static int sep_allocate_dmatables_region(struct sep_device *sep,
+					 void **dmatables_region,
+					 struct sep_dma_context *dma_ctx,
+					 const u32 table_count)
+{
+	const size_t new_len =  table_count *
+				sizeof(struct sep_lli_entry) *
+				SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
+	void *tmp_region = NULL;
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] dma_ctx = 0x%p\n",
+				current->pid, dma_ctx);
+	dev_dbg(&sep->pdev->dev, "[PID%d] dmatables_region = 0x%p\n",
+				current->pid, dmatables_region);
+
+	if (!dma_ctx || !dmatables_region) {
+		dev_warn(&sep->pdev->dev,
+			"[PID%d] dma context/region uninitialized\n",
+			current->pid);
+		return -EINVAL;
+	}
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] newlen = 0x%08X\n",
+				current->pid, new_len);
+	dev_dbg(&sep->pdev->dev, "[PID%d] oldlen = 0x%08X\n", current->pid,
+				dma_ctx->dmatables_len);
+	tmp_region = kzalloc(new_len + dma_ctx->dmatables_len, GFP_KERNEL);
+	if (!tmp_region) {
+		dev_warn(&sep->pdev->dev,
+			 "[PID%d] no mem for dma tables region\n",
+				current->pid);
+		return -ENOMEM;
+	}
+
+	/* Were there any previous tables that need to be preserved ? */
+	if (*dmatables_region) {
+		memcpy(tmp_region, *dmatables_region, dma_ctx->dmatables_len);
+		kfree(*dmatables_region);
+	}
+
+	*dmatables_region = tmp_region;
+
+	dma_ctx->dmatables_len += new_len;
+
+	return 0;
+}
+
+/**
+ *	sep_wait_transaction - Used for synchronizing transactions
+ *	@sep: SEP device
+ */
+int sep_wait_transaction(struct sep_device *sep)
+{
+	int error = 0;
+	DEFINE_WAIT(wait);
+
+	if (0 == test_and_set_bit(SEP_TRANSACTION_STARTED_LOCK_BIT,
+				&sep->in_use_flags)) {
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] no transactions, returning\n",
+				current->pid);
+		goto end_function_setpid;
+	}
+
+	/*
+	 * Looping needed even for exclusive waitq entries
+	 * due to process wakeup latencies, previous process
+	 * might have already created another transaction.
+	 */
+	for (;;) {
+		/*
+		 * Exclusive waitq entry, so that only one process is
+		 * woken up from the queue at a time.
+		 */
+		prepare_to_wait_exclusive(&sep->event_transactions,
+					  &wait,
+					  TASK_INTERRUPTIBLE);
+		if (0 == test_and_set_bit(SEP_TRANSACTION_STARTED_LOCK_BIT,
+					  &sep->in_use_flags)) {
+			dev_dbg(&sep->pdev->dev,
+				"[PID%d] no transactions, breaking\n",
+					current->pid);
+			break;
+		}
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] transactions ongoing, sleeping\n",
+				current->pid);
+		schedule();
+		dev_dbg(&sep->pdev->dev, "[PID%d] woken up\n", current->pid);
+
+		if (signal_pending(current)) {
+			dev_dbg(&sep->pdev->dev, "[PID%d] received signal\n",
+							current->pid);
+			error = -EINTR;
+			goto end_function;
+		}
+	}
+end_function_setpid:
+	/*
+	 * The pid_doing_transaction indicates that this process
+	 * now owns the facilities to performa a transaction with
+	 * the SEP. While this process is performing a transaction,
+	 * no other process who has the SEP device open can perform
+	 * any transactions. This method allows more than one process
+	 * to have the device open at any given time, which provides
+	 * finer granularity for device utilization by multiple
+	 * processes.
+	 */
+	/* Only one process is able to progress here at a time */
+	sep->pid_doing_transaction = current->pid;
+
+end_function:
+	finish_wait(&sep->event_transactions, &wait);
+
+	return error;
+}
+
+/**
+ * sep_check_transaction_owner - Checks if current process owns transaction
+ * @sep: SEP device
+ */
+static inline int sep_check_transaction_owner(struct sep_device *sep)
+{
+	dev_dbg(&sep->pdev->dev, "[PID%d] transaction pid = %d\n",
+		current->pid,
+		sep->pid_doing_transaction);
+
+	if ((sep->pid_doing_transaction == 0) ||
+		(current->pid != sep->pid_doing_transaction)) {
+		return -EACCES;
+	}
+
+	/* We own the transaction */
+	return 0;
+}
+
+#ifdef DEBUG
+
+/**
+ * sep_dump_message - dump the message that is pending
+ * @sep: SEP device
+ * This will only print dump if DEBUG is set; it does
+ * follow kernel debug print enabling
+ */
+static void _sep_dump_message(struct sep_device *sep)
+{
+	int count;
+
+	u32 *p = sep->shared_addr;
+
+	for (count = 0; count < 40 * 4; count += 4)
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] Word %d of the message is %x\n",
+				current->pid, count/4, *p++);
+}
+#endif
+
+/**
+ * sep_map_and_alloc_shared_area -allocate shared block
+ * @sep: security processor
+ * @size: size of shared area
+ */
+static int sep_map_and_alloc_shared_area(struct sep_device *sep)
+{
+	sep->shared_addr = dma_alloc_coherent(&sep->pdev->dev,
+		sep->shared_size,
+		&sep->shared_bus, GFP_KERNEL);
+
+	if (!sep->shared_addr) {
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] shared memory dma_alloc_coherent failed\n",
+				current->pid);
+		return -ENOMEM;
+	}
+	dev_dbg(&sep->pdev->dev,
+		"[PID%d] shared_addr %zx bytes @%p (bus %llx)\n",
+				current->pid,
+				sep->shared_size, sep->shared_addr,
+				(unsigned long long)sep->shared_bus);
+	return 0;
+}
+
+/**
+ * sep_unmap_and_free_shared_area - free shared block
+ * @sep: security processor
+ */
+static void sep_unmap_and_free_shared_area(struct sep_device *sep)
+{
+	dma_free_coherent(&sep->pdev->dev, sep->shared_size,
+				sep->shared_addr, sep->shared_bus);
+}
+
+/**
+ * sep_shared_bus_to_virt - convert bus/virt addresses
+ * @sep: pointer to struct sep_device
+ * @bus_address: address to convert
+ *
+ * Returns virtual address inside the shared area according
+ * to the bus address.
+ */
+static void *sep_shared_bus_to_virt(struct sep_device *sep,
+						dma_addr_t bus_address)
+{
+	return sep->shared_addr + (bus_address - sep->shared_bus);
+}
+
+/**
+ * sep_open - device open method
+ * @inode: inode of SEP device
+ * @filp: file handle to SEP device
+ *
+ * Open method for the SEP device. Called when userspace opens
+ * the SEP device node.
+ *
+ * Returns zero on success otherwise an error code.
+ */
+static int sep_open(struct inode *inode, struct file *filp)
+{
+	struct sep_device *sep;
+	struct sep_private_data *priv;
+
+	dev_dbg(&sep_dev->pdev->dev, "[PID%d] open\n", current->pid);
+
+	if (filp->f_flags & O_NONBLOCK)
+		return -ENOTSUPP;
+
+	/*
+	 * Get the SEP device structure and use it for the
+	 * private_data field in filp for other methods
+	 */
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	sep = sep_dev;
+	priv->device = sep;
+	filp->private_data = priv;
+
+	dev_dbg(&sep_dev->pdev->dev, "[PID%d] priv is 0x%p\n",
+					current->pid, priv);
+
+	/* Anyone can open; locking takes place at transaction level */
+	return 0;
+}
+
+/**
+ * sep_free_dma_table_data_handler - free DMA table
+ * @sep: pointere to struct sep_device
+ * @dma_ctx: dma context
+ *
+ * Handles the request to  free DMA table for synchronic actions
+ */
+int sep_free_dma_table_data_handler(struct sep_device *sep,
+					   struct sep_dma_context **dma_ctx)
+{
+	int count;
+	int dcb_counter;
+	/* Pointer to the current dma_resource struct */
+	struct sep_dma_resource *dma;
+
+	dev_dbg(&sep->pdev->dev,
+		"[PID%d] sep_free_dma_table_data_handler\n",
+			current->pid);
+
+	if (!dma_ctx || !(*dma_ctx)) {
+		/* No context or context already freed */
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] no DMA context or context already freed\n",
+				current->pid);
+
+		return 0;
+	}
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] (*dma_ctx)->nr_dcb_creat 0x%x\n",
+					current->pid,
+					(*dma_ctx)->nr_dcb_creat);
+
+	for (dcb_counter = 0;
+	     dcb_counter < (*dma_ctx)->nr_dcb_creat; dcb_counter++) {
+		dma = &(*dma_ctx)->dma_res_arr[dcb_counter];
+
+		/* Unmap and free input map array */
+		if (dma->in_map_array) {
+			for (count = 0; count < dma->in_num_pages; count++) {
+				dma_unmap_page(&sep->pdev->dev,
+					dma->in_map_array[count].dma_addr,
+					dma->in_map_array[count].size,
+					DMA_TO_DEVICE);
+			}
+			kfree(dma->in_map_array);
+		}
+
+		/* Unmap output map array, DON'T free it yet */
+		if (dma->out_map_array) {
+			for (count = 0; count < dma->out_num_pages; count++) {
+				dma_unmap_page(&sep->pdev->dev,
+					dma->out_map_array[count].dma_addr,
+					dma->out_map_array[count].size,
+					DMA_FROM_DEVICE);
+			}
+			kfree(dma->out_map_array);
+		}
+
+		/* Free page cache for output */
+		if (dma->in_page_array) {
+			for (count = 0; count < dma->in_num_pages; count++) {
+				flush_dcache_page(dma->in_page_array[count]);
+				page_cache_release(dma->in_page_array[count]);
+			}
+			kfree(dma->in_page_array);
+		}
+
+		if (dma->out_page_array) {
+			for (count = 0; count < dma->out_num_pages; count++) {
+				if (!PageReserved(dma->out_page_array[count]))
+
+					SetPageDirty(dma->
+					out_page_array[count]);
+
+				flush_dcache_page(dma->out_page_array[count]);
+				page_cache_release(dma->out_page_array[count]);
+			}
+			kfree(dma->out_page_array);
+		}
+
+		/**
+		 * Note that here we use in_map_num_entries because we
+		 * don't have a page array; the page array is generated
+		 * only in the lock_user_pages, which is not called
+		 * for kernel crypto, which is what the sg (scatter gather
+		 * is used for exclusively
+		 */
+		if (dma->src_sg) {
+			dma_unmap_sg(&sep->pdev->dev, dma->src_sg,
+				dma->in_map_num_entries, DMA_TO_DEVICE);
+			dma->src_sg = NULL;
+		}
+
+		if (dma->dst_sg) {
+			dma_unmap_sg(&sep->pdev->dev, dma->dst_sg,
+				dma->in_map_num_entries, DMA_FROM_DEVICE);
+			dma->dst_sg = NULL;
+		}
+
+		/* Reset all the values */
+		dma->in_page_array = NULL;
+		dma->out_page_array = NULL;
+		dma->in_num_pages = 0;
+		dma->out_num_pages = 0;
+		dma->in_map_array = NULL;
+		dma->out_map_array = NULL;
+		dma->in_map_num_entries = 0;
+		dma->out_map_num_entries = 0;
+	}
+
+	(*dma_ctx)->nr_dcb_creat = 0;
+	(*dma_ctx)->num_lli_tables_created = 0;
+
+	kfree(*dma_ctx);
+	*dma_ctx = NULL;
+
+	dev_dbg(&sep->pdev->dev,
+		"[PID%d] sep_free_dma_table_data_handler end\n",
+			current->pid);
+
+	return 0;
+}
+
+/**
+ * sep_end_transaction_handler - end transaction
+ * @sep: pointer to struct sep_device
+ * @dma_ctx: DMA context
+ * @call_status: Call status
+ *
+ * This API handles the end transaction request.
+ */
+static int sep_end_transaction_handler(struct sep_device *sep,
+				       struct sep_dma_context **dma_ctx,
+				       struct sep_call_status *call_status,
+				       struct sep_queue_info **my_queue_elem)
+{
+	dev_dbg(&sep->pdev->dev, "[PID%d] ending transaction\n", current->pid);
+
+	/*
+	 * Extraneous transaction clearing would mess up PM
+	 * device usage counters and SEP would get suspended
+	 * just before we send a command to SEP in the next
+	 * transaction
+	 * */
+	if (sep_check_transaction_owner(sep)) {
+		dev_dbg(&sep->pdev->dev, "[PID%d] not transaction owner\n",
+						current->pid);
+		return 0;
+	}
+
+	/* Update queue status */
+	sep_queue_status_remove(sep, my_queue_elem);
+
+	/* Check that all the DMA resources were freed */
+	if (dma_ctx)
+		sep_free_dma_table_data_handler(sep, dma_ctx);
+
+	/* Reset call status for next transaction */
+	if (call_status)
+		call_status->status = 0;
+
+	/* Clear the message area to avoid next transaction reading
+	 * sensitive results from previous transaction */
+	memset(sep->shared_addr, 0,
+	       SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES);
+
+	/* start suspend delay */
+#ifdef SEP_ENABLE_RUNTIME_PM
+	if (sep->in_use) {
+		sep->in_use = 0;
+		pm_runtime_mark_last_busy(&sep->pdev->dev);
+		pm_runtime_put_autosuspend(&sep->pdev->dev);
+	}
+#endif
+
+	clear_bit(SEP_WORKING_LOCK_BIT, &sep->in_use_flags);
+	sep->pid_doing_transaction = 0;
+
+	/* Now it's safe for next process to proceed */
+	dev_dbg(&sep->pdev->dev, "[PID%d] waking up next transaction\n",
+					current->pid);
+	clear_bit(SEP_TRANSACTION_STARTED_LOCK_BIT, &sep->in_use_flags);
+	wake_up(&sep->event_transactions);
+
+	return 0;
+}
+
+
+/**
+ * sep_release - close a SEP device
+ * @inode: inode of SEP device
+ * @filp: file handle being closed
+ *
+ * Called on the final close of a SEP device.
+ */
+static int sep_release(struct inode *inode, struct file *filp)
+{
+	struct sep_private_data * const private_data = filp->private_data;
+	struct sep_call_status *call_status = &private_data->call_status;
+	struct sep_device *sep = private_data->device;
+	struct sep_dma_context **dma_ctx = &private_data->dma_ctx;
+	struct sep_queue_info **my_queue_elem = &private_data->my_queue_elem;
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] release\n", current->pid);
+
+	sep_end_transaction_handler(sep, dma_ctx, call_status,
+		my_queue_elem);
+
+	kfree(filp->private_data);
+
+	return 0;
+}
+
+/**
+ * sep_mmap -  maps the shared area to user space
+ * @filp: pointer to struct file
+ * @vma: pointer to vm_area_struct
+ *
+ * Called on an mmap of our space via the normal SEP device
+ */
+static int sep_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct sep_private_data * const private_data = filp->private_data;
+	struct sep_call_status *call_status = &private_data->call_status;
+	struct sep_device *sep = private_data->device;
+	struct sep_queue_info **my_queue_elem = &private_data->my_queue_elem;
+	dma_addr_t bus_addr;
+	unsigned long error = 0;
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] sep_mmap\n", current->pid);
+
+	/* Set the transaction busy (own the device) */
+	/*
+	 * Problem for multithreaded applications is that here we're
+	 * possibly going to sleep while holding a write lock on
+	 * current->mm->mmap_sem, which will cause deadlock for ongoing
+	 * transaction trying to create DMA tables
+	 */
+	error = sep_wait_transaction(sep);
+	if (error)
+		/* Interrupted by signal, don't clear transaction */
+		goto end_function;
+
+	/* Clear the message area to avoid next transaction reading
+	 * sensitive results from previous transaction */
+	memset(sep->shared_addr, 0,
+	       SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES);
+
+	/*
+	 * Check that the size of the mapped range is as the size of the message
+	 * shared area
+	 */
+	if ((vma->vm_end - vma->vm_start) > SEP_DRIVER_MMMAP_AREA_SIZE) {
+		error = -EINVAL;
+		goto end_function_with_error;
+	}
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] shared_addr is %p\n",
+					current->pid, sep->shared_addr);
+
+	/* Get bus address */
+	bus_addr = sep->shared_bus;
+
+	if (remap_pfn_range(vma, vma->vm_start, bus_addr >> PAGE_SHIFT,
+		vma->vm_end - vma->vm_start, vma->vm_page_prot)) {
+		dev_dbg(&sep->pdev->dev, "[PID%d] remap_page_range failed\n",
+						current->pid);
+		error = -EAGAIN;
+		goto end_function_with_error;
+	}
+
+	/* Update call status */
+	set_bit(SEP_LEGACY_MMAP_DONE_OFFSET, &call_status->status);
+
+	goto end_function;
+
+end_function_with_error:
+	/* Clear our transaction */
+	sep_end_transaction_handler(sep, NULL, call_status,
+		my_queue_elem);
+
+end_function:
+	return error;
+}
+
+/**
+ * sep_poll - poll handler
+ * @filp:	pointer to struct file
+ * @wait:	pointer to poll_table
+ *
+ * Called by the OS when the kernel is asked to do a poll on
+ * a SEP file handle.
+ */
+static unsigned int sep_poll(struct file *filp, poll_table *wait)
+{
+	struct sep_private_data * const private_data = filp->private_data;
+	struct sep_call_status *call_status = &private_data->call_status;
+	struct sep_device *sep = private_data->device;
+	u32 mask = 0;
+	u32 retval = 0;
+	u32 retval2 = 0;
+	unsigned long lock_irq_flag;
+
+	/* Am I the process that owns the transaction? */
+	if (sep_check_transaction_owner(sep)) {
+		dev_dbg(&sep->pdev->dev, "[PID%d] poll pid not owner\n",
+						current->pid);
+		mask = POLLERR;
+		goto end_function;
+	}
+
+	/* Check if send command or send_reply were activated previously */
+	if (0 == test_bit(SEP_LEGACY_SENDMSG_DONE_OFFSET,
+			  &call_status->status)) {
+		dev_warn(&sep->pdev->dev, "[PID%d] sendmsg not called\n",
+						current->pid);
+		mask = POLLERR;
+		goto end_function;
+	}
+
+
+	/* Add the event to the polling wait table */
+	dev_dbg(&sep->pdev->dev, "[PID%d] poll: calling wait sep_event\n",
+					current->pid);
+
+	poll_wait(filp, &sep->event_interrupt, wait);
+
+	dev_dbg(&sep->pdev->dev,
+		"[PID%d] poll: send_ct is %lx reply ct is %lx\n",
+			current->pid, sep->send_ct, sep->reply_ct);
+
+	/* Check if error occured during poll */
+	retval2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
+	if ((retval2 != 0x0) && (retval2 != 0x8)) {
+		dev_dbg(&sep->pdev->dev, "[PID%d] poll; poll error %x\n",
+						current->pid, retval2);
+		mask |= POLLERR;
+		goto end_function;
+	}
+
+	spin_lock_irqsave(&sep->snd_rply_lck, lock_irq_flag);
+
+	if (sep->send_ct == sep->reply_ct) {
+		spin_unlock_irqrestore(&sep->snd_rply_lck, lock_irq_flag);
+		retval = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] poll: data ready check (GPR2)  %x\n",
+				current->pid, retval);
+
+		/* Check if printf request  */
+		if ((retval >> 30) & 0x1) {
+			dev_dbg(&sep->pdev->dev,
+				"[PID%d] poll: SEP printf request\n",
+					current->pid);
+			goto end_function;
+		}
+
+		/* Check if the this is SEP reply or request */
+		if (retval >> 31) {
+			dev_dbg(&sep->pdev->dev,
+				"[PID%d] poll: SEP request\n",
+					current->pid);
+		} else {
+			dev_dbg(&sep->pdev->dev,
+				"[PID%d] poll: normal return\n",
+					current->pid);
+			sep_dump_message(sep);
+			dev_dbg(&sep->pdev->dev,
+				"[PID%d] poll; SEP reply POLLIN|POLLRDNORM\n",
+					current->pid);
+			mask |= POLLIN | POLLRDNORM;
+		}
+		set_bit(SEP_LEGACY_POLL_DONE_OFFSET, &call_status->status);
+	} else {
+		spin_unlock_irqrestore(&sep->snd_rply_lck, lock_irq_flag);
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] poll; no reply; returning mask of 0\n",
+				current->pid);
+		mask = 0;
+	}
+
+end_function:
+	return mask;
+}
+
+/**
+ * sep_time_address - address in SEP memory of time
+ * @sep: SEP device we want the address from
+ *
+ * Return the address of the two dwords in memory used for time
+ * setting.
+ */
+static u32 *sep_time_address(struct sep_device *sep)
+{
+	return sep->shared_addr +
+		SEP_DRIVER_SYSTEM_TIME_MEMORY_OFFSET_IN_BYTES;
+}
+
+/**
+ * sep_set_time - set the SEP time
+ * @sep: the SEP we are setting the time for
+ *
+ * Calculates time and sets it at the predefined address.
+ * Called with the SEP mutex held.
+ */
+static unsigned long sep_set_time(struct sep_device *sep)
+{
+	struct timeval time;
+	u32 *time_addr;	/* Address of time as seen by the kernel */
+
+
+	do_gettimeofday(&time);
+
+	/* Set value in the SYSTEM MEMORY offset */
+	time_addr = sep_time_address(sep);
+
+	time_addr[0] = SEP_TIME_VAL_TOKEN;
+	time_addr[1] = time.tv_sec;
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] time.tv_sec is %lu\n",
+					current->pid, time.tv_sec);
+	dev_dbg(&sep->pdev->dev, "[PID%d] time_addr is %p\n",
+					current->pid, time_addr);
+	dev_dbg(&sep->pdev->dev, "[PID%d] sep->shared_addr is %p\n",
+					current->pid, sep->shared_addr);
+
+	return time.tv_sec;
+}
+
+/**
+ * sep_send_command_handler - kick off a command
+ * @sep: SEP being signalled
+ *
+ * This function raises interrupt to SEP that signals that is has a new
+ * command from the host
+ *
+ * Note that this function does fall under the ioctl lock
+ */
+int sep_send_command_handler(struct sep_device *sep)
+{
+	unsigned long lock_irq_flag;
+	u32 *msg_pool;
+	int error = 0;
+
+	/* Basic sanity check; set msg pool to start of shared area */
+	msg_pool = (u32 *)sep->shared_addr;
+	msg_pool += 2;
+
+	/* Look for start msg token */
+	if (*msg_pool != SEP_START_MSG_TOKEN) {
+		dev_warn(&sep->pdev->dev, "start message token not present\n");
+		error = -EPROTO;
+		goto end_function;
+	}
+
+	/* Do we have a reasonable size? */
+	msg_pool += 1;
+	if ((*msg_pool < 2) ||
+		(*msg_pool > SEP_DRIVER_MAX_MESSAGE_SIZE_IN_BYTES)) {
+
+		dev_warn(&sep->pdev->dev, "invalid message size\n");
+		error = -EPROTO;
+		goto end_function;
+	}
+
+	/* Does the command look reasonable? */
+	msg_pool += 1;
+	if (*msg_pool < 2) {
+		dev_warn(&sep->pdev->dev, "invalid message opcode\n");
+		error = -EPROTO;
+		goto end_function;
+	}
+
+#if defined(CONFIG_PM_RUNTIME) && defined(SEP_ENABLE_RUNTIME_PM)
+	dev_dbg(&sep->pdev->dev, "[PID%d] before pm sync status 0x%X\n",
+					current->pid,
+					sep->pdev->dev.power.runtime_status);
+	sep->in_use = 1; /* device is about to be used */
+	pm_runtime_get_sync(&sep->pdev->dev);
+#endif
+
+	if (test_and_set_bit(SEP_WORKING_LOCK_BIT, &sep->in_use_flags)) {
+		error = -EPROTO;
+		goto end_function;
+	}
+	sep->in_use = 1; /* device is about to be used */
+	sep_set_time(sep);
+
+	sep_dump_message(sep);
+
+	/* Update counter */
+	spin_lock_irqsave(&sep->snd_rply_lck, lock_irq_flag);
+	sep->send_ct++;
+	spin_unlock_irqrestore(&sep->snd_rply_lck, lock_irq_flag);
+
+	dev_dbg(&sep->pdev->dev,
+		"[PID%d] sep_send_command_handler send_ct %lx reply_ct %lx\n",
+			current->pid, sep->send_ct, sep->reply_ct);
+
+	/* Send interrupt to SEP */
+	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x2);
+
+end_function:
+	return error;
+}
+
+/**
+ *	sep_crypto_dma -
+ *	@sep: pointer to struct sep_device
+ *	@sg: pointer to struct scatterlist
+ *	@direction:
+ *	@dma_maps: pointer to place a pointer to array of dma maps
+ *	 This is filled in; anything previous there will be lost
+ *	 The structure for dma maps is sep_dma_map
+ *	@returns number of dma maps on success; negative on error
+ *
+ *	This creates the dma table from the scatterlist
+ *	It is used only for kernel crypto as it works with scatterlists
+ *	representation of data buffers
+ *
+ */
+static int sep_crypto_dma(
+	struct sep_device *sep,
+	struct scatterlist *sg,
+	struct sep_dma_map **dma_maps,
+	enum dma_data_direction direction)
+{
+	struct scatterlist *temp_sg;
+
+	u32 count_segment;
+	u32 count_mapped;
+	struct sep_dma_map *sep_dma;
+	int ct1;
+
+	if (sg->length == 0)
+		return 0;
+
+	/* Count the segments */
+	temp_sg = sg;
+	count_segment = 0;
+	while (temp_sg) {
+		count_segment += 1;
+		temp_sg = scatterwalk_sg_next(temp_sg);
+	}
+	dev_dbg(&sep->pdev->dev,
+		"There are (hex) %x segments in sg\n", count_segment);
+
+	/* DMA map segments */
+	count_mapped = dma_map_sg(&sep->pdev->dev, sg,
+		count_segment, direction);
+
+	dev_dbg(&sep->pdev->dev,
+		"There are (hex) %x maps in sg\n", count_mapped);
+
+	if (count_mapped == 0) {
+		dev_dbg(&sep->pdev->dev, "Cannot dma_map_sg\n");
+		return -ENOMEM;
+	}
+
+	sep_dma = kmalloc(sizeof(struct sep_dma_map) *
+		count_mapped, GFP_ATOMIC);
+
+	if (sep_dma == NULL) {
+		dev_dbg(&sep->pdev->dev, "Cannot allocate dma_maps\n");
+		return -ENOMEM;
+	}
+
+	for_each_sg(sg, temp_sg, count_mapped, ct1) {
+		sep_dma[ct1].dma_addr = sg_dma_address(temp_sg);
+		sep_dma[ct1].size = sg_dma_len(temp_sg);
+		dev_dbg(&sep->pdev->dev, "(all hex) map %x dma %lx len %lx\n",
+			ct1, (unsigned long)sep_dma[ct1].dma_addr,
+			(unsigned long)sep_dma[ct1].size);
+		}
+
+	*dma_maps = sep_dma;
+	return count_mapped;
+
+}
+
+/**
+ *	sep_crypto_lli -
+ *	@sep: pointer to struct sep_device
+ *	@sg: pointer to struct scatterlist
+ *	@data_size: total data size
+ *	@direction:
+ *	@dma_maps: pointer to place a pointer to array of dma maps
+ *	 This is filled in; anything previous there will be lost
+ *	 The structure for dma maps is sep_dma_map
+ *	@lli_maps: pointer to place a pointer to array of lli maps
+ *	 This is filled in; anything previous there will be lost
+ *	 The structure for dma maps is sep_dma_map
+ *	@returns number of dma maps on success; negative on error
+ *
+ *	This creates the LLI table from the scatterlist
+ *	It is only used for kernel crypto as it works exclusively
+ *	with scatterlists (struct scatterlist) representation of
+ *	data buffers
+ */
+static int sep_crypto_lli(
+	struct sep_device *sep,
+	struct scatterlist *sg,
+	struct sep_dma_map **maps,
+	struct sep_lli_entry **llis,
+	u32 data_size,
+	enum dma_data_direction direction)
+{
+
+	int ct1;
+	struct sep_lli_entry *sep_lli;
+	struct sep_dma_map *sep_map;
+
+	int nbr_ents;
+
+	nbr_ents = sep_crypto_dma(sep, sg, maps, direction);
+	if (nbr_ents <= 0) {
+		dev_dbg(&sep->pdev->dev, "crypto_dma failed %x\n",
+			nbr_ents);
+		return nbr_ents;
+	}
+
+	sep_map = *maps;
+
+	sep_lli = kmalloc(sizeof(struct sep_lli_entry) * nbr_ents, GFP_ATOMIC);
+
+	if (sep_lli == NULL) {
+		dev_dbg(&sep->pdev->dev, "Cannot allocate lli_maps\n");
+
+		kfree(*maps);
+		*maps = NULL;
+		return -ENOMEM;
+	}
+
+	for (ct1 = 0; ct1 < nbr_ents; ct1 += 1) {
+		sep_lli[ct1].bus_address = (u32)sep_map[ct1].dma_addr;
+
+		/* Maximum for page is total data size */
+		if (sep_map[ct1].size > data_size)
+			sep_map[ct1].size = data_size;
+
+		sep_lli[ct1].block_size = (u32)sep_map[ct1].size;
+	}
+
+	*llis = sep_lli;
+	return nbr_ents;
+}
+
+/**
+ *	sep_lock_kernel_pages - map kernel pages for DMA
+ *	@sep: pointer to struct sep_device
+ *	@kernel_virt_addr: address of data buffer in kernel
+ *	@data_size: size of data
+ *	@lli_array_ptr: lli array
+ *	@in_out_flag: input into device or output from device
+ *
+ *	This function locks all the physical pages of the kernel virtual buffer
+ *	and construct a basic lli  array, where each entry holds the physical
+ *	page address and the size that application data holds in this page
+ *	This function is used only during kernel crypto mod calls from within
+ *	the kernel (when ioctl is not used)
+ *
+ *	This is used only for kernel crypto. Kernel pages
+ *	are handled differently as they are done via
+ *	scatter gather lists (struct scatterlist)
+ */
+static int sep_lock_kernel_pages(struct sep_device *sep,
+	unsigned long kernel_virt_addr,
+	u32 data_size,
+	struct sep_lli_entry **lli_array_ptr,
+	int in_out_flag,
+	struct sep_dma_context *dma_ctx)
+
+{
+	u32 num_pages;
+	struct scatterlist *sg;
+
+	/* Array of lli */
+	struct sep_lli_entry *lli_array;
+	/* Map array */
+	struct sep_dma_map *map_array;
+
+	enum dma_data_direction direction;
+
+	lli_array = NULL;
+	map_array = NULL;
+
+	if (in_out_flag == SEP_DRIVER_IN_FLAG) {
+		direction = DMA_TO_DEVICE;
+		sg = dma_ctx->src_sg;
+	} else {
+		direction = DMA_FROM_DEVICE;
+		sg = dma_ctx->dst_sg;
+	}
+
+	num_pages = sep_crypto_lli(sep, sg, &map_array, &lli_array,
+		data_size, direction);
+
+	if (num_pages <= 0) {
+		dev_dbg(&sep->pdev->dev, "sep_crypto_lli returned error %x\n",
+			num_pages);
+		return -ENOMEM;
+	}
+
+	/* Put mapped kernel sg into kernel resource array */
+
+	/* Set output params acording to the in_out flag */
+	if (in_out_flag == SEP_DRIVER_IN_FLAG) {
+		*lli_array_ptr = lli_array;
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_num_pages =
+								num_pages;
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_page_array =
+								NULL;
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_map_array =
+								map_array;
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_map_num_entries =
+								num_pages;
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].src_sg =
+			dma_ctx->src_sg;
+	} else {
+		*lli_array_ptr = lli_array;
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].out_num_pages =
+								num_pages;
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].out_page_array =
+								NULL;
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].out_map_array =
+								map_array;
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].
+					out_map_num_entries = num_pages;
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].dst_sg =
+			dma_ctx->dst_sg;
+	}
+
+	return 0;
+}
+
+/**
+ * sep_lock_user_pages - lock and map user pages for DMA
+ * @sep: pointer to struct sep_device
+ * @app_virt_addr: user memory data buffer
+ * @data_size: size of data buffer
+ * @lli_array_ptr: lli array
+ * @in_out_flag: input or output to device
+ *
+ * This function locks all the physical pages of the application
+ * virtual buffer and construct a basic lli  array, where each entry
+ * holds the physical page address and the size that application
+ * data holds in this physical pages
+ */
+static int sep_lock_user_pages(struct sep_device *sep,
+	u32 app_virt_addr,
+	u32 data_size,
+	struct sep_lli_entry **lli_array_ptr,
+	int in_out_flag,
+	struct sep_dma_context *dma_ctx)
+
+{
+	int error = 0;
+	u32 count;
+	int result;
+	/* The the page of the end address of the user space buffer */
+	u32 end_page;
+	/* The page of the start address of the user space buffer */
+	u32 start_page;
+	/* The range in pages */
+	u32 num_pages;
+	/* Array of pointers to page */
+	struct page **page_array;
+	/* Array of lli */
+	struct sep_lli_entry *lli_array;
+	/* Map array */
+	struct sep_dma_map *map_array;
+
+	/* Set start and end pages  and num pages */
+	end_page = (app_virt_addr + data_size - 1) >> PAGE_SHIFT;
+	start_page = app_virt_addr >> PAGE_SHIFT;
+	num_pages = end_page - start_page + 1;
+
+	dev_dbg(&sep->pdev->dev,
+		"[PID%d] lock user pages app_virt_addr is %x\n",
+			current->pid, app_virt_addr);
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] data_size is (hex) %x\n",
+					current->pid, data_size);
+	dev_dbg(&sep->pdev->dev, "[PID%d] start_page is (hex) %x\n",
+					current->pid, start_page);
+	dev_dbg(&sep->pdev->dev, "[PID%d] end_page is (hex) %x\n",
+					current->pid, end_page);
+	dev_dbg(&sep->pdev->dev, "[PID%d] num_pages is (hex) %x\n",
+					current->pid, num_pages);
+
+	/* Allocate array of pages structure pointers */
+	page_array = kmalloc(sizeof(struct page *) * num_pages, GFP_ATOMIC);
+	if (!page_array) {
+		error = -ENOMEM;
+		goto end_function;
+	}
+	map_array = kmalloc(sizeof(struct sep_dma_map) * num_pages, GFP_ATOMIC);
+	if (!map_array) {
+		dev_warn(&sep->pdev->dev,
+			 "[PID%d] kmalloc for map_array failed\n",
+				current->pid);
+		error = -ENOMEM;
+		goto end_function_with_error1;
+	}
+
+	lli_array = kmalloc(sizeof(struct sep_lli_entry) * num_pages,
+		GFP_ATOMIC);
+
+	if (!lli_array) {
+		dev_warn(&sep->pdev->dev,
+			 "[PID%d] kmalloc for lli_array failed\n",
+				current->pid);
+		error = -ENOMEM;
+		goto end_function_with_error2;
+	}
+
+	/* Convert the application virtual address into a set of physical */
+	down_read(&current->mm->mmap_sem);
+	result = get_user_pages(current, current->mm, app_virt_addr,
+		num_pages,
+		((in_out_flag == SEP_DRIVER_IN_FLAG) ? 0 : 1),
+		0, page_array, NULL);
+
+	up_read(&current->mm->mmap_sem);
+
+	/* Check the number of pages locked - if not all then exit with error */
+	if (result != num_pages) {
+		dev_warn(&sep->pdev->dev,
+			"[PID%d] not all pages locked by get_user_pages, "
+			"result 0x%X, num_pages 0x%X\n",
+				current->pid, result, num_pages);
+		error = -ENOMEM;
+		goto end_function_with_error3;
+	}
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] get_user_pages succeeded\n",
+					current->pid);
+
+	/*
+	 * Fill the array using page array data and
+	 * map the pages - this action will also flush the cache as needed
+	 */
+	for (count = 0; count < num_pages; count++) {
+		/* Fill the map array */
+		map_array[count].dma_addr =
+			dma_map_page(&sep->pdev->dev, page_array[count],
+			0, PAGE_SIZE, DMA_BIDIRECTIONAL);
+
+		map_array[count].size = PAGE_SIZE;
+
+		/* Fill the lli array entry */
+		lli_array[count].bus_address = (u32)map_array[count].dma_addr;
+		lli_array[count].block_size = PAGE_SIZE;
+
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] lli_array[%x].bus_address is %08lx, "
+			"lli_array[%x].block_size is (hex) %x\n", current->pid,
+			count, (unsigned long)lli_array[count].bus_address,
+			count, lli_array[count].block_size);
+	}
+
+	/* Check the offset for the first page */
+	lli_array[0].bus_address =
+		lli_array[0].bus_address + (app_virt_addr & (~PAGE_MASK));
+
+	/* Check that not all the data is in the first page only */
+	if ((PAGE_SIZE - (app_virt_addr & (~PAGE_MASK))) >= data_size)
+		lli_array[0].block_size = data_size;
+	else
+		lli_array[0].block_size =
+			PAGE_SIZE - (app_virt_addr & (~PAGE_MASK));
+
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] After check if page 0 has all data\n",
+			current->pid);
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] lli_array[0].bus_address is (hex) %08lx, "
+			"lli_array[0].block_size is (hex) %x\n",
+			current->pid,
+			(unsigned long)lli_array[0].bus_address,
+			lli_array[0].block_size);
+
+
+	/* Check the size of the last page */
+	if (num_pages > 1) {
+		lli_array[num_pages - 1].block_size =
+			(app_virt_addr + data_size) & (~PAGE_MASK);
+		if (lli_array[num_pages - 1].block_size == 0)
+			lli_array[num_pages - 1].block_size = PAGE_SIZE;
+
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] After last page size adjustment\n",
+			current->pid);
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] lli_array[%x].bus_address is (hex) %08lx, "
+			"lli_array[%x].block_size is (hex) %x\n",
+			current->pid,
+			num_pages - 1,
+			(unsigned long)lli_array[num_pages - 1].bus_address,
+			num_pages - 1,
+			lli_array[num_pages - 1].block_size);
+	}
+
+	/* Set output params acording to the in_out flag */
+	if (in_out_flag == SEP_DRIVER_IN_FLAG) {
+		*lli_array_ptr = lli_array;
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_num_pages =
+								num_pages;
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_page_array =
+								page_array;
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_map_array =
+								map_array;
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_map_num_entries =
+								num_pages;
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].src_sg = NULL;
+	} else {
+		*lli_array_ptr = lli_array;
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].out_num_pages =
+								num_pages;
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].out_page_array =
+								page_array;
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].out_map_array =
+								map_array;
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].
+					out_map_num_entries = num_pages;
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].dst_sg = NULL;
+	}
+	goto end_function;
+
+end_function_with_error3:
+	/* Free lli array */
+	kfree(lli_array);
+
+end_function_with_error2:
+	kfree(map_array);
+
+end_function_with_error1:
+	/* Free page array */
+	kfree(page_array);
+
+end_function:
+	return error;
+}
+
+/**
+ * sep_calculate_lli_table_max_size - size the LLI table
+ * @sep: pointer to struct sep_device
+ * @lli_in_array_ptr
+ * @num_array_entries
+ * @last_table_flag
+ *
+ * This function calculates the size of data that can be inserted into
+ * the lli table from this array, such that either the table is full
+ * (all entries are entered), or there are no more entries in the
+ * lli array
+ */
+static u32 sep_calculate_lli_table_max_size(struct sep_device *sep,
+	struct sep_lli_entry *lli_in_array_ptr,
+	u32 num_array_entries,
+	u32 *last_table_flag)
+{
+	u32 counter;
+	/* Table data size */
+	u32 table_data_size = 0;
+	/* Data size for the next table */
+	u32 next_table_data_size;
+
+	*last_table_flag = 0;
+
+	/*
+	 * Calculate the data in the out lli table till we fill the whole
+	 * table or till the data has ended
+	 */
+	for (counter = 0;
+		(counter < (SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP - 1)) &&
+			(counter < num_array_entries); counter++)
+		table_data_size += lli_in_array_ptr[counter].block_size;
+
+	/*
+	 * Check if we reached the last entry,
+	 * meaning this ia the last table to build,
+	 * and no need to check the block alignment
+	 */
+	if (counter == num_array_entries) {
+		/* Set the last table flag */
+		*last_table_flag = 1;
+		goto end_function;
+	}
+
+	/*
+	 * Calculate the data size of the next table.
+	 * Stop if no entries left or if data size is more the DMA restriction
+	 */
+	next_table_data_size = 0;
+	for (; counter < num_array_entries; counter++) {
+		next_table_data_size += lli_in_array_ptr[counter].block_size;
+		if (next_table_data_size >= SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE)
+			break;
+	}
+
+	/*
+	 * Check if the next table data size is less then DMA rstriction.
+	 * if it is - recalculate the current table size, so that the next
+	 * table data size will be adaquete for DMA
+	 */
+	if (next_table_data_size &&
+		next_table_data_size < SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE)
+
+		table_data_size -= (SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE -
+			next_table_data_size);
+
+end_function:
+	return table_data_size;
+}
+
+/**
+ * sep_build_lli_table - build an lli array for the given table
+ * @sep: pointer to struct sep_device
+ * @lli_array_ptr: pointer to lli array
+ * @lli_table_ptr: pointer to lli table
+ * @num_processed_entries_ptr: pointer to number of entries
+ * @num_table_entries_ptr: pointer to number of tables
+ * @table_data_size: total data size
+ *
+ * Builds ant lli table from the lli_array according to
+ * the given size of data
+ */
+static void sep_build_lli_table(struct sep_device *sep,
+	struct sep_lli_entry	*lli_array_ptr,
+	struct sep_lli_entry	*lli_table_ptr,
+	u32 *num_processed_entries_ptr,
+	u32 *num_table_entries_ptr,
+	u32 table_data_size)
+{
+	/* Current table data size */
+	u32 curr_table_data_size;
+	/* Counter of lli array entry */
+	u32 array_counter;
+
+	/* Init current table data size and lli array entry counter */
+	curr_table_data_size = 0;
+	array_counter = 0;
+	*num_table_entries_ptr = 1;
+
+	dev_dbg(&sep->pdev->dev,
+		"[PID%d] build lli table table_data_size: (hex) %x\n",
+			current->pid, table_data_size);
+
+	/* Fill the table till table size reaches the needed amount */
+	while (curr_table_data_size < table_data_size) {
+		/* Update the number of entries in table */
+		(*num_table_entries_ptr)++;
+
+		lli_table_ptr->bus_address =
+			cpu_to_le32(lli_array_ptr[array_counter].bus_address);
+
+		lli_table_ptr->block_size =
+			cpu_to_le32(lli_array_ptr[array_counter].block_size);
+
+		curr_table_data_size += lli_array_ptr[array_counter].block_size;
+
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] lli_table_ptr is %p\n",
+				current->pid, lli_table_ptr);
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] lli_table_ptr->bus_address: %08lx\n",
+				current->pid,
+				(unsigned long)lli_table_ptr->bus_address);
+
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] lli_table_ptr->block_size is (hex) %x\n",
+				current->pid, lli_table_ptr->block_size);
+
+		/* Check for overflow of the table data */
+		if (curr_table_data_size > table_data_size) {
+			dev_dbg(&sep->pdev->dev,
+				"[PID%d] curr_table_data_size too large\n",
+					current->pid);
+
+			/* Update the size of block in the table */
+			lli_table_ptr->block_size =
+				cpu_to_le32(lli_table_ptr->block_size) -
+				(curr_table_data_size - table_data_size);
+
+			/* Update the physical address in the lli array */
+			lli_array_ptr[array_counter].bus_address +=
+			cpu_to_le32(lli_table_ptr->block_size);
+
+			/* Update the block size left in the lli array */
+			lli_array_ptr[array_counter].block_size =
+				(curr_table_data_size - table_data_size);
+		} else
+			/* Advance to the next entry in the lli_array */
+			array_counter++;
+
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] lli_table_ptr->bus_address is %08lx\n",
+				current->pid,
+				(unsigned long)lli_table_ptr->bus_address);
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] lli_table_ptr->block_size is (hex) %x\n",
+				current->pid,
+				lli_table_ptr->block_size);
+
+		/* Move to the next entry in table */
+		lli_table_ptr++;
+	}
+
+	/* Set the info entry to default */
+	lli_table_ptr->bus_address = 0xffffffff;
+	lli_table_ptr->block_size = 0;
+
+	/* Set the output parameter */
+	*num_processed_entries_ptr += array_counter;
+
+}
+
+/**
+ * sep_shared_area_virt_to_bus - map shared area to bus address
+ * @sep: pointer to struct sep_device
+ * @virt_address: virtual address to convert
+ *
+ * This functions returns the physical address inside shared area according
+ * to the virtual address. It can be either on the externa RAM device
+ * (ioremapped), or on the system RAM
+ * This implementation is for the external RAM
+ */
+static dma_addr_t sep_shared_area_virt_to_bus(struct sep_device *sep,
+	void *virt_address)
+{
+	dev_dbg(&sep->pdev->dev, "[PID%d] sh virt to phys v %p\n",
+					current->pid, virt_address);
+	dev_dbg(&sep->pdev->dev, "[PID%d] sh virt to phys p %08lx\n",
+		current->pid,
+		(unsigned long)
+		sep->shared_bus + (virt_address - sep->shared_addr));
+
+	return sep->shared_bus + (size_t)(virt_address - sep->shared_addr);
+}
+
+/**
+ * sep_shared_area_bus_to_virt - map shared area bus address to kernel
+ * @sep: pointer to struct sep_device
+ * @bus_address: bus address to convert
+ *
+ * This functions returns the virtual address inside shared area
+ * according to the physical address. It can be either on the
+ * externa RAM device (ioremapped), or on the system RAM
+ * This implementation is for the external RAM
+ */
+static void *sep_shared_area_bus_to_virt(struct sep_device *sep,
+	dma_addr_t bus_address)
+{
+	dev_dbg(&sep->pdev->dev, "[PID%d] shared bus to virt b=%lx v=%lx\n",
+		current->pid,
+		(unsigned long)bus_address, (unsigned long)(sep->shared_addr +
+			(size_t)(bus_address - sep->shared_bus)));
+
+	return sep->shared_addr	+ (size_t)(bus_address - sep->shared_bus);
+}
+
+/**
+ * sep_debug_print_lli_tables - dump LLI table
+ * @sep: pointer to struct sep_device
+ * @lli_table_ptr: pointer to sep_lli_entry
+ * @num_table_entries: number of entries
+ * @table_data_size: total data size
+ *
+ * Walk the the list of the print created tables and print all the data
+ */
+static void sep_debug_print_lli_tables(struct sep_device *sep,
+	struct sep_lli_entry *lli_table_ptr,
+	unsigned long num_table_entries,
+	unsigned long table_data_size)
+{
+	unsigned long table_count = 1;
+	unsigned long entries_count = 0;
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] sep_debug_print_lli_tables start\n",
+					current->pid);
+	if (num_table_entries == 0) {
+		dev_dbg(&sep->pdev->dev, "[PID%d] no table to print\n",
+			current->pid);
+		return;
+	}
+
+	while ((unsigned long) lli_table_ptr->bus_address != 0xffffffff) {
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] lli table %08lx, "
+			"table_data_size is (hex) %lx\n",
+				current->pid, table_count, table_data_size);
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] num_table_entries is (hex) %lx\n",
+				current->pid, num_table_entries);
+
+		/* Print entries of the table (without info entry) */
+		for (entries_count = 0; entries_count < num_table_entries;
+			entries_count++, lli_table_ptr++) {
+
+			dev_dbg(&sep->pdev->dev,
+				"[PID%d] lli_table_ptr address is %08lx\n",
+				current->pid,
+				(unsigned long) lli_table_ptr);
+
+			dev_dbg(&sep->pdev->dev,
+				"[PID%d] phys address is %08lx "
+				"block size is (hex) %x\n", current->pid,
+				(unsigned long)lli_table_ptr->bus_address,
+				lli_table_ptr->block_size);
+		}
+
+		/* Point to the info entry */
+		lli_table_ptr--;
+
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] phys lli_table_ptr->block_size "
+			"is (hex) %x\n",
+			current->pid,
+			lli_table_ptr->block_size);
+
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] phys lli_table_ptr->physical_address "
+			"is %08lx\n",
+			current->pid,
+			(unsigned long)lli_table_ptr->bus_address);
+
+
+		table_data_size = lli_table_ptr->block_size & 0xffffff;
+		num_table_entries = (lli_table_ptr->block_size >> 24) & 0xff;
+
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] phys table_data_size is "
+			"(hex) %lx num_table_entries is"
+			" %lx bus_address is%lx\n",
+				current->pid,
+				table_data_size,
+				num_table_entries,
+				(unsigned long)lli_table_ptr->bus_address);
+
+		if ((unsigned long)lli_table_ptr->bus_address != 0xffffffff)
+			lli_table_ptr = (struct sep_lli_entry *)
+				sep_shared_bus_to_virt(sep,
+				(unsigned long)lli_table_ptr->bus_address);
+
+		table_count++;
+	}
+	dev_dbg(&sep->pdev->dev, "[PID%d] sep_debug_print_lli_tables end\n",
+					current->pid);
+}
+
+
+/**
+ * sep_prepare_empty_lli_table - create a blank LLI table
+ * @sep: pointer to struct sep_device
+ * @lli_table_addr_ptr: pointer to lli table
+ * @num_entries_ptr: pointer to number of entries
+ * @table_data_size_ptr: point to table data size
+ * @dmatables_region: Optional buffer for DMA tables
+ * @dma_ctx: DMA context
+ *
+ * This function creates empty lli tables when there is no data
+ */
+static void sep_prepare_empty_lli_table(struct sep_device *sep,
+		dma_addr_t *lli_table_addr_ptr,
+		u32 *num_entries_ptr,
+		u32 *table_data_size_ptr,
+		void **dmatables_region,
+		struct sep_dma_context *dma_ctx)
+{
+	struct sep_lli_entry *lli_table_ptr;
+
+	/* Find the area for new table */
+	lli_table_ptr =
+		(struct sep_lli_entry *)(sep->shared_addr +
+		SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
+		dma_ctx->num_lli_tables_created * sizeof(struct sep_lli_entry) *
+			SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
+
+	if (dmatables_region && *dmatables_region)
+		lli_table_ptr = *dmatables_region;
+
+	lli_table_ptr->bus_address = 0;
+	lli_table_ptr->block_size = 0;
+
+	lli_table_ptr++;
+	lli_table_ptr->bus_address = 0xFFFFFFFF;
+	lli_table_ptr->block_size = 0;
+
+	/* Set the output parameter value */
+	*lli_table_addr_ptr = sep->shared_bus +
+		SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
+		dma_ctx->num_lli_tables_created *
+		sizeof(struct sep_lli_entry) *
+		SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
+
+	/* Set the num of entries and table data size for empty table */
+	*num_entries_ptr = 2;
+	*table_data_size_ptr = 0;
+
+	/* Update the number of created tables */
+	dma_ctx->num_lli_tables_created++;
+}
+
+/**
+ * sep_prepare_input_dma_table - prepare input DMA mappings
+ * @sep: pointer to struct sep_device
+ * @data_size:
+ * @block_size:
+ * @lli_table_ptr:
+ * @num_entries_ptr:
+ * @table_data_size_ptr:
+ * @is_kva: set for kernel data (kernel cryptio call)
+ *
+ * This function prepares only input DMA table for synhronic symmetric
+ * operations (HASH)
+ * Note that all bus addresses that are passed to the SEP
+ * are in 32 bit format; the SEP is a 32 bit device
+ */
+static int sep_prepare_input_dma_table(struct sep_device *sep,
+	unsigned long app_virt_addr,
+	u32 data_size,
+	u32 block_size,
+	dma_addr_t *lli_table_ptr,
+	u32 *num_entries_ptr,
+	u32 *table_data_size_ptr,
+	bool is_kva,
+	void **dmatables_region,
+	struct sep_dma_context *dma_ctx
+)
+{
+	int error = 0;
+	/* Pointer to the info entry of the table - the last entry */
+	struct sep_lli_entry *info_entry_ptr;
+	/* Array of pointers to page */
+	struct sep_lli_entry *lli_array_ptr;
+	/* Points to the first entry to be processed in the lli_in_array */
+	u32 current_entry = 0;
+	/* Num entries in the virtual buffer */
+	u32 sep_lli_entries = 0;
+	/* Lli table pointer */
+	struct sep_lli_entry *in_lli_table_ptr;
+	/* The total data in one table */
+	u32 table_data_size = 0;
+	/* Flag for last table */
+	u32 last_table_flag = 0;
+	/* Number of entries in lli table */
+	u32 num_entries_in_table = 0;
+	/* Next table address */
+	void *lli_table_alloc_addr = NULL;
+	void *dma_lli_table_alloc_addr = NULL;
+	void *dma_in_lli_table_ptr = NULL;
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] prepare intput dma "
+				 "tbl data size: (hex) %x\n",
+					current->pid, data_size);
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] block_size is (hex) %x\n",
+					current->pid, block_size);
+
+	/* Initialize the pages pointers */
+	dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_page_array = NULL;
+	dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_num_pages = 0;
+
+	/* Set the kernel address for first table to be allocated */
+	lli_table_alloc_addr = (void *)(sep->shared_addr +
+		SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
+		dma_ctx->num_lli_tables_created * sizeof(struct sep_lli_entry) *
+		SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
+
+	if (data_size == 0) {
+		if (dmatables_region) {
+			error = sep_allocate_dmatables_region(sep,
+						dmatables_region,
+						dma_ctx,
+						1);
+			if (error)
+				return error;
+		}
+		/* Special case  - create meptu table - 2 entries, zero data */
+		sep_prepare_empty_lli_table(sep, lli_table_ptr,
+				num_entries_ptr, table_data_size_ptr,
+				dmatables_region, dma_ctx);
+		goto update_dcb_counter;
+	}
+
+	/* Check if the pages are in Kernel Virtual Address layout */
+	if (is_kva == true)
+		error = sep_lock_kernel_pages(sep, app_virt_addr,
+			data_size, &lli_array_ptr, SEP_DRIVER_IN_FLAG,
+			dma_ctx);
+	else
+		/*
+		 * Lock the pages of the user buffer
+		 * and translate them to pages
+		 */
+		error = sep_lock_user_pages(sep, app_virt_addr,
+			data_size, &lli_array_ptr, SEP_DRIVER_IN_FLAG,
+			dma_ctx);
+
+	if (error)
+		goto end_function;
+
+	dev_dbg(&sep->pdev->dev,
+		"[PID%d] output sep_in_num_pages is (hex) %x\n",
+		current->pid,
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_num_pages);
+
+	current_entry = 0;
+	info_entry_ptr = NULL;
+
+	sep_lli_entries =
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_num_pages;
+
+	dma_lli_table_alloc_addr = lli_table_alloc_addr;
+	if (dmatables_region) {
+		error = sep_allocate_dmatables_region(sep,
+					dmatables_region,
+					dma_ctx,
+					sep_lli_entries);
+		if (error)
+			return error;
+		lli_table_alloc_addr = *dmatables_region;
+	}
+
+	/* Loop till all the entries in in array are processed */
+	while (current_entry < sep_lli_entries) {
+
+		/* Set the new input and output tables */
+		in_lli_table_ptr =
+			(struct sep_lli_entry *)lli_table_alloc_addr;
+		dma_in_lli_table_ptr =
+			(struct sep_lli_entry *)dma_lli_table_alloc_addr;
+
+		lli_table_alloc_addr += sizeof(struct sep_lli_entry) *
+			SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
+		dma_lli_table_alloc_addr += sizeof(struct sep_lli_entry) *
+			SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
+
+		if (dma_lli_table_alloc_addr >
+			((void *)sep->shared_addr +
+			SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
+			SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES)) {
+
+			error = -ENOMEM;
+			goto end_function_error;
+
+		}
+
+		/* Update the number of created tables */
+		dma_ctx->num_lli_tables_created++;
+
+		/* Calculate the maximum size of data for input table */
+		table_data_size = sep_calculate_lli_table_max_size(sep,
+			&lli_array_ptr[current_entry],
+			(sep_lli_entries - current_entry),
+			&last_table_flag);
+
+		/*
+		 * If this is not the last table -
+		 * then allign it to the block size
+		 */
+		if (!last_table_flag)
+			table_data_size =
+				(table_data_size / block_size) * block_size;
+
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] output table_data_size is (hex) %x\n",
+				current->pid,
+				table_data_size);
+
+		/* Construct input lli table */
+		sep_build_lli_table(sep, &lli_array_ptr[current_entry],
+			in_lli_table_ptr,
+			&current_entry, &num_entries_in_table, table_data_size);
+
+		if (info_entry_ptr == NULL) {
+
+			/* Set the output parameters to physical addresses */
+			*lli_table_ptr = sep_shared_area_virt_to_bus(sep,
+				dma_in_lli_table_ptr);
+			*num_entries_ptr = num_entries_in_table;
+			*table_data_size_ptr = table_data_size;
+
+			dev_dbg(&sep->pdev->dev,
+				"[PID%d] output lli_table_in_ptr is %08lx\n",
+				current->pid,
+				(unsigned long)*lli_table_ptr);
+
+		} else {
+			/* Update the info entry of the previous in table */
+			info_entry_ptr->bus_address =
+				sep_shared_area_virt_to_bus(sep,
+							dma_in_lli_table_ptr);
+			info_entry_ptr->block_size =
+				((num_entries_in_table) << 24) |
+				(table_data_size);
+		}
+		/* Save the pointer to the info entry of the current tables */
+		info_entry_ptr = in_lli_table_ptr + num_entries_in_table - 1;
+	}
+	/* Print input tables */
+	if (!dmatables_region) {
+		sep_debug_print_lli_tables(sep, (struct sep_lli_entry *)
+			sep_shared_area_bus_to_virt(sep, *lli_table_ptr),
+			*num_entries_ptr, *table_data_size_ptr);
+	}
+
+	/* The array of the pages */
+	kfree(lli_array_ptr);
+
+update_dcb_counter:
+	/* Update DCB counter */
+	dma_ctx->nr_dcb_creat++;
+	goto end_function;
+
+end_function_error:
+	/* Free all the allocated resources */
+	kfree(dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_map_array);
+	kfree(lli_array_ptr);
+	kfree(dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_page_array);
+
+end_function:
+	return error;
+
+}
+
+/**
+ * sep_construct_dma_tables_from_lli - prepare AES/DES mappings
+ * @sep: pointer to struct sep_device
+ * @lli_in_array:
+ * @sep_in_lli_entries:
+ * @lli_out_array:
+ * @sep_out_lli_entries
+ * @block_size
+ * @lli_table_in_ptr
+ * @lli_table_out_ptr
+ * @in_num_entries_ptr
+ * @out_num_entries_ptr
+ * @table_data_size_ptr
+ *
+ * This function creates the input and output DMA tables for
+ * symmetric operations (AES/DES) according to the block
+ * size from LLI arays
+ * Note that all bus addresses that are passed to the SEP
+ * are in 32 bit format; the SEP is a 32 bit device
+ */
+static int sep_construct_dma_tables_from_lli(
+	struct sep_device *sep,
+	struct sep_lli_entry *lli_in_array,
+	u32	sep_in_lli_entries,
+	struct sep_lli_entry *lli_out_array,
+	u32	sep_out_lli_entries,
+	u32	block_size,
+	dma_addr_t *lli_table_in_ptr,
+	dma_addr_t *lli_table_out_ptr,
+	u32	*in_num_entries_ptr,
+	u32	*out_num_entries_ptr,
+	u32	*table_data_size_ptr,
+	void	**dmatables_region,
+	struct sep_dma_context *dma_ctx)
+{
+	/* Points to the area where next lli table can be allocated */
+	void *lli_table_alloc_addr = NULL;
+	/*
+	 * Points to the area in shared region where next lli table
+	 * can be allocated
+	 */
+	void *dma_lli_table_alloc_addr = NULL;
+	/* Input lli table in dmatables_region or shared region */
+	struct sep_lli_entry *in_lli_table_ptr = NULL;
+	/* Input lli table location in the shared region */
+	struct sep_lli_entry *dma_in_lli_table_ptr = NULL;
+	/* Output lli table in dmatables_region or shared region */
+	struct sep_lli_entry *out_lli_table_ptr = NULL;
+	/* Output lli table location in the shared region */
+	struct sep_lli_entry *dma_out_lli_table_ptr = NULL;
+	/* Pointer to the info entry of the table - the last entry */
+	struct sep_lli_entry *info_in_entry_ptr = NULL;
+	/* Pointer to the info entry of the table - the last entry */
+	struct sep_lli_entry *info_out_entry_ptr = NULL;
+	/* Points to the first entry to be processed in the lli_in_array */
+	u32 current_in_entry = 0;
+	/* Points to the first entry to be processed in the lli_out_array */
+	u32 current_out_entry = 0;
+	/* Max size of the input table */
+	u32 in_table_data_size = 0;
+	/* Max size of the output table */
+	u32 out_table_data_size = 0;
+	/* Flag te signifies if this is the last tables build */
+	u32 last_table_flag = 0;
+	/* The data size that should be in table */
+	u32 table_data_size = 0;
+	/* Number of etnries in the input table */
+	u32 num_entries_in_table = 0;
+	/* Number of etnries in the output table */
+	u32 num_entries_out_table = 0;
+
+	if (!dma_ctx) {
+		dev_warn(&sep->pdev->dev, "DMA context uninitialized\n");
+		return -EINVAL;
+	}
+
+	/* Initiate to point after the message area */
+	lli_table_alloc_addr = (void *)(sep->shared_addr +
+		SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
+		(dma_ctx->num_lli_tables_created *
+		(sizeof(struct sep_lli_entry) *
+		SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP)));
+	dma_lli_table_alloc_addr = lli_table_alloc_addr;
+
+	if (dmatables_region) {
+		/* 2 for both in+out table */
+		if (sep_allocate_dmatables_region(sep,
+					dmatables_region,
+					dma_ctx,
+					2*sep_in_lli_entries))
+			return -ENOMEM;
+		lli_table_alloc_addr = *dmatables_region;
+	}
+
+	/* Loop till all the entries in in array are not processed */
+	while (current_in_entry < sep_in_lli_entries) {
+		/* Set the new input and output tables */
+		in_lli_table_ptr =
+			(struct sep_lli_entry *)lli_table_alloc_addr;
+		dma_in_lli_table_ptr =
+			(struct sep_lli_entry *)dma_lli_table_alloc_addr;
+
+		lli_table_alloc_addr += sizeof(struct sep_lli_entry) *
+			SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
+		dma_lli_table_alloc_addr += sizeof(struct sep_lli_entry) *
+			SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
+
+		/* Set the first output tables */
+		out_lli_table_ptr =
+			(struct sep_lli_entry *)lli_table_alloc_addr;
+		dma_out_lli_table_ptr =
+			(struct sep_lli_entry *)dma_lli_table_alloc_addr;
+
+		/* Check if the DMA table area limit was overrun */
+		if ((dma_lli_table_alloc_addr + sizeof(struct sep_lli_entry) *
+			SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP) >
+			((void *)sep->shared_addr +
+			SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
+			SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES)) {
+
+			dev_warn(&sep->pdev->dev, "dma table limit overrun\n");
+			return -ENOMEM;
+		}
+
+		/* Update the number of the lli tables created */
+		dma_ctx->num_lli_tables_created += 2;
+
+		lli_table_alloc_addr += sizeof(struct sep_lli_entry) *
+			SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
+		dma_lli_table_alloc_addr += sizeof(struct sep_lli_entry) *
+			SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
+
+		/* Calculate the maximum size of data for input table */
+		in_table_data_size =
+			sep_calculate_lli_table_max_size(sep,
+			&lli_in_array[current_in_entry],
+			(sep_in_lli_entries - current_in_entry),
+			&last_table_flag);
+
+		/* Calculate the maximum size of data for output table */
+		out_table_data_size =
+			sep_calculate_lli_table_max_size(sep,
+			&lli_out_array[current_out_entry],
+			(sep_out_lli_entries - current_out_entry),
+			&last_table_flag);
+
+		if (!last_table_flag) {
+			in_table_data_size = (in_table_data_size /
+				block_size) * block_size;
+			out_table_data_size = (out_table_data_size /
+				block_size) * block_size;
+		}
+
+		table_data_size = in_table_data_size;
+		if (table_data_size > out_table_data_size)
+			table_data_size = out_table_data_size;
+
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] construct tables from lli"
+			" in_table_data_size is (hex) %x\n", current->pid,
+			in_table_data_size);
+
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] construct tables from lli"
+			"out_table_data_size is (hex) %x\n", current->pid,
+			out_table_data_size);
+
+		/* Construct input lli table */
+		sep_build_lli_table(sep, &lli_in_array[current_in_entry],
+			in_lli_table_ptr,
+			&current_in_entry,
+			&num_entries_in_table,
+			table_data_size);
+
+		/* Construct output lli table */
+		sep_build_lli_table(sep, &lli_out_array[current_out_entry],
+			out_lli_table_ptr,
+			&current_out_entry,
+			&num_entries_out_table,
+			table_data_size);
+
+		/* If info entry is null - this is the first table built */
+		if (info_in_entry_ptr == NULL) {
+			/* Set the output parameters to physical addresses */
+			*lli_table_in_ptr =
+			sep_shared_area_virt_to_bus(sep, dma_in_lli_table_ptr);
+
+			*in_num_entries_ptr = num_entries_in_table;
+
+			*lli_table_out_ptr =
+				sep_shared_area_virt_to_bus(sep,
+				dma_out_lli_table_ptr);
+
+			*out_num_entries_ptr = num_entries_out_table;
+			*table_data_size_ptr = table_data_size;
+
+			dev_dbg(&sep->pdev->dev,
+				"[PID%d] output lli_table_in_ptr is %08lx\n",
+				current->pid,
+				(unsigned long)*lli_table_in_ptr);
+			dev_dbg(&sep->pdev->dev,
+				"[PID%d] output lli_table_out_ptr is %08lx\n",
+				current->pid,
+				(unsigned long)*lli_table_out_ptr);
+		} else {
+			/* Update the info entry of the previous in table */
+			info_in_entry_ptr->bus_address =
+				sep_shared_area_virt_to_bus(sep,
+				dma_in_lli_table_ptr);
+
+			info_in_entry_ptr->block_size =
+				((num_entries_in_table) << 24) |
+				(table_data_size);
+
+			/* Update the info entry of the previous in table */
+			info_out_entry_ptr->bus_address =
+				sep_shared_area_virt_to_bus(sep,
+				dma_out_lli_table_ptr);
+
+			info_out_entry_ptr->block_size =
+				((num_entries_out_table) << 24) |
+				(table_data_size);
+
+			dev_dbg(&sep->pdev->dev,
+				"[PID%d] output lli_table_in_ptr:%08lx %08x\n",
+				current->pid,
+				(unsigned long)info_in_entry_ptr->bus_address,
+				info_in_entry_ptr->block_size);
+
+			dev_dbg(&sep->pdev->dev,
+				"[PID%d] output lli_table_out_ptr:"
+				"%08lx  %08x\n",
+				current->pid,
+				(unsigned long)info_out_entry_ptr->bus_address,
+				info_out_entry_ptr->block_size);
+		}
+
+		/* Save the pointer to the info entry of the current tables */
+		info_in_entry_ptr = in_lli_table_ptr +
+			num_entries_in_table - 1;
+		info_out_entry_ptr = out_lli_table_ptr +
+			num_entries_out_table - 1;
+
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] output num_entries_out_table is %x\n",
+			current->pid,
+			(u32)num_entries_out_table);
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] output info_in_entry_ptr is %lx\n",
+			current->pid,
+			(unsigned long)info_in_entry_ptr);
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] output info_out_entry_ptr is %lx\n",
+			current->pid,
+			(unsigned long)info_out_entry_ptr);
+	}
+
+	/* Print input tables */
+	if (!dmatables_region) {
+		sep_debug_print_lli_tables(
+			sep,
+			(struct sep_lli_entry *)
+			sep_shared_area_bus_to_virt(sep, *lli_table_in_ptr),
+			*in_num_entries_ptr,
+			*table_data_size_ptr);
+	}
+
+	/* Print output tables */
+	if (!dmatables_region) {
+		sep_debug_print_lli_tables(
+			sep,
+			(struct sep_lli_entry *)
+			sep_shared_area_bus_to_virt(sep, *lli_table_out_ptr),
+			*out_num_entries_ptr,
+			*table_data_size_ptr);
+	}
+
+	return 0;
+}
+
+/**
+ * sep_prepare_input_output_dma_table - prepare DMA I/O table
+ * @app_virt_in_addr:
+ * @app_virt_out_addr:
+ * @data_size:
+ * @block_size:
+ * @lli_table_in_ptr:
+ * @lli_table_out_ptr:
+ * @in_num_entries_ptr:
+ * @out_num_entries_ptr:
+ * @table_data_size_ptr:
+ * @is_kva: set for kernel data; used only for kernel crypto module
+ *
+ * This function builds input and output DMA tables for synhronic
+ * symmetric operations (AES, DES, HASH). It also checks that each table
+ * is of the modular block size
+ * Note that all bus addresses that are passed to the SEP
+ * are in 32 bit format; the SEP is a 32 bit device
+ */
+static int sep_prepare_input_output_dma_table(struct sep_device *sep,
+	unsigned long app_virt_in_addr,
+	unsigned long app_virt_out_addr,
+	u32 data_size,
+	u32 block_size,
+	dma_addr_t *lli_table_in_ptr,
+	dma_addr_t *lli_table_out_ptr,
+	u32 *in_num_entries_ptr,
+	u32 *out_num_entries_ptr,
+	u32 *table_data_size_ptr,
+	bool is_kva,
+	void **dmatables_region,
+	struct sep_dma_context *dma_ctx)
+
+{
+	int error = 0;
+	/* Array of pointers of page */
+	struct sep_lli_entry *lli_in_array;
+	/* Array of pointers of page */
+	struct sep_lli_entry *lli_out_array;
+
+	if (!dma_ctx) {
+		error = -EINVAL;
+		goto end_function;
+	}
+
+	if (data_size == 0) {
+		/* Prepare empty table for input and output */
+		if (dmatables_region) {
+			error = sep_allocate_dmatables_region(
+					sep,
+					dmatables_region,
+					dma_ctx,
+					2);
+		  if (error)
+			goto end_function;
+		}
+		sep_prepare_empty_lli_table(sep, lli_table_in_ptr,
+			in_num_entries_ptr, table_data_size_ptr,
+			dmatables_region, dma_ctx);
+
+		sep_prepare_empty_lli_table(sep, lli_table_out_ptr,
+			out_num_entries_ptr, table_data_size_ptr,
+			dmatables_region, dma_ctx);
+
+		goto update_dcb_counter;
+	}
+
+	/* Initialize the pages pointers */
+	dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_page_array = NULL;
+	dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].out_page_array = NULL;
+
+	/* Lock the pages of the buffer and translate them to pages */
+	if (is_kva == true) {
+		dev_dbg(&sep->pdev->dev, "[PID%d] Locking kernel input pages\n",
+						current->pid);
+		error = sep_lock_kernel_pages(sep, app_virt_in_addr,
+				data_size, &lli_in_array, SEP_DRIVER_IN_FLAG,
+				dma_ctx);
+		if (error) {
+			dev_warn(&sep->pdev->dev,
+				"[PID%d] sep_lock_kernel_pages for input "
+				"virtual buffer failed\n", current->pid);
+
+			goto end_function;
+		}
+
+		dev_dbg(&sep->pdev->dev, "[PID%d] Locking kernel output pages\n",
+						current->pid);
+		error = sep_lock_kernel_pages(sep, app_virt_out_addr,
+				data_size, &lli_out_array, SEP_DRIVER_OUT_FLAG,
+				dma_ctx);
+
+		if (error) {
+			dev_warn(&sep->pdev->dev,
+				"[PID%d] sep_lock_kernel_pages for output "
+				"virtual buffer failed\n", current->pid);
+
+			goto end_function_free_lli_in;
+		}
+
+	}
+
+	else {
+		dev_dbg(&sep->pdev->dev, "[PID%d] Locking user input pages\n",
+						current->pid);
+		error = sep_lock_user_pages(sep, app_virt_in_addr,
+				data_size, &lli_in_array, SEP_DRIVER_IN_FLAG,
+				dma_ctx);
+		if (error) {
+			dev_warn(&sep->pdev->dev,
+				"[PID%d] sep_lock_user_pages for input "
+				"virtual buffer failed\n", current->pid);
+
+			goto end_function;
+		}
+
+		dev_dbg(&sep->pdev->dev, "[PID%d] Locking user output pages\n",
+				current->pid);
+
+		error = sep_lock_user_pages(sep, app_virt_out_addr,
+				data_size, &lli_out_array, SEP_DRIVER_OUT_FLAG,
+				dma_ctx);
+
+		if (error) {
+			dev_warn(&sep->pdev->dev,
+					"[PID%d] sep_lock_user_pages"
+					" for output virtual buffer failed\n",
+					current->pid);
+
+			goto end_function_free_lli_in;
+		}
+	}
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] After lock; prep input output dma "
+		"table sep_in_num_pages is (hex) %x\n", current->pid,
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_num_pages);
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] sep_out_num_pages is (hex) %x\n",
+		current->pid,
+		dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].out_num_pages);
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP"
+		" is (hex) %x\n", current->pid,
+		SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
+
+	/* Call the fucntion that creates table from the lli arrays */
+	dev_dbg(&sep->pdev->dev, "[PID%d] calling create table from lli\n",
+					current->pid);
+	error = sep_construct_dma_tables_from_lli(
+			sep, lli_in_array,
+			dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].
+								in_num_pages,
+			lli_out_array,
+			dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].
+								out_num_pages,
+			block_size, lli_table_in_ptr, lli_table_out_ptr,
+			in_num_entries_ptr, out_num_entries_ptr,
+			table_data_size_ptr, dmatables_region, dma_ctx);
+
+	if (error) {
+		dev_warn(&sep->pdev->dev,
+			"[PID%d] sep_construct_dma_tables_from_lli failed\n",
+			current->pid);
+		goto end_function_with_error;
+	}
+
+	kfree(lli_out_array);
+	kfree(lli_in_array);
+
+update_dcb_counter:
+	/* Update DCB counter */
+	dma_ctx->nr_dcb_creat++;
+
+	goto end_function;
+
+end_function_with_error:
+	kfree(dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].out_map_array);
+	kfree(dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].out_page_array);
+	kfree(lli_out_array);
+
+
+end_function_free_lli_in:
+	kfree(dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_map_array);
+	kfree(dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_page_array);
+	kfree(lli_in_array);
+
+end_function:
+
+	return error;
+
+}
+
+/**
+ * sep_prepare_input_output_dma_table_in_dcb - prepare control blocks
+ * @app_in_address: unsigned long; for data buffer in (user space)
+ * @app_out_address: unsigned long; for data buffer out (user space)
+ * @data_in_size: u32; for size of data
+ * @block_size: u32; for block size
+ * @tail_block_size: u32; for size of tail block
+ * @isapplet: bool; to indicate external app
+ * @is_kva: bool; kernel buffer; only used for kernel crypto module
+ *
+ * This function prepares the linked DMA tables and puts the
+ * address for the linked list of tables inta a DCB (data control
+ * block) the address of which is known by the SEP hardware
+ * Note that all bus addresses that are passed to the SEP
+ * are in 32 bit format; the SEP is a 32 bit device
+ */
+int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
+	unsigned long  app_in_address,
+	unsigned long  app_out_address,
+	u32  data_in_size,
+	u32  block_size,
+	u32  tail_block_size,
+	bool isapplet,
+	bool	is_kva,
+	struct sep_dcblock *dcb_region,
+	void **dmatables_region,
+	struct sep_dma_context **dma_ctx,
+	struct scatterlist *src_sg,
+	struct scatterlist *dst_sg)
+{
+	int error = 0;
+	/* Size of tail */
+	u32 tail_size = 0;
+	/* Address of the created DCB table */
+	struct sep_dcblock *dcb_table_ptr = NULL;
+	/* The physical address of the first input DMA table */
+	dma_addr_t in_first_mlli_address = 0;
+	/* Number of entries in the first input DMA table */
+	u32  in_first_num_entries = 0;
+	/* The physical address of the first output DMA table */
+	dma_addr_t  out_first_mlli_address = 0;
+	/* Number of entries in the first output DMA table */
+	u32  out_first_num_entries = 0;
+	/* Data in the first input/output table */
+	u32  first_data_size = 0;
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] app_in_address %lx\n",
+		current->pid, app_in_address);
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] app_out_address %lx\n",
+		current->pid, app_out_address);
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] data_in_size %x\n",
+		current->pid, data_in_size);
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] block_size %x\n",
+		current->pid, block_size);
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] tail_block_size %x\n",
+		current->pid, tail_block_size);
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] isapplet %x\n",
+		current->pid, isapplet);
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] is_kva %x\n",
+		current->pid, is_kva);
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] src_sg %p\n",
+		current->pid, src_sg);
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] dst_sg %p\n",
+		current->pid, dst_sg);
+
+	if (!dma_ctx) {
+		dev_warn(&sep->pdev->dev, "[PID%d] no DMA context pointer\n",
+						current->pid);
+		error = -EINVAL;
+		goto end_function;
+	}
+
+	if (*dma_ctx) {
+		/* In case there are multiple DCBs for this transaction */
+		dev_dbg(&sep->pdev->dev, "[PID%d] DMA context already set\n",
+						current->pid);
+	} else {
+		*dma_ctx = kzalloc(sizeof(**dma_ctx), GFP_KERNEL);
+		if (!(*dma_ctx)) {
+			dev_dbg(&sep->pdev->dev,
+				"[PID%d] Not enough memory for DMA context\n",
+				current->pid);
+		  error = -ENOMEM;
+		  goto end_function;
+		}
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] Created DMA context addr at 0x%p\n",
+			current->pid, *dma_ctx);
+	}
+
+	/* these are for kernel crypto only */
+	(*dma_ctx)->src_sg = src_sg;
+	(*dma_ctx)->dst_sg = dst_sg;
+
+	if ((*dma_ctx)->nr_dcb_creat == SEP_MAX_NUM_SYNC_DMA_OPS) {
+		/* No more DCBs to allocate */
+		dev_dbg(&sep->pdev->dev, "[PID%d] no more DCBs available\n",
+						current->pid);
+		error = -ENOSPC;
+		goto end_function_error;
+	}
+
+	/* Allocate new DCB */
+	if (dcb_region) {
+		dcb_table_ptr = dcb_region;
+	} else {
+		dcb_table_ptr = (struct sep_dcblock *)(sep->shared_addr +
+			SEP_DRIVER_SYSTEM_DCB_MEMORY_OFFSET_IN_BYTES +
+			((*dma_ctx)->nr_dcb_creat *
+						sizeof(struct sep_dcblock)));
+	}
+
+	/* Set the default values in the DCB */
+	dcb_table_ptr->input_mlli_address = 0;
+	dcb_table_ptr->input_mlli_num_entries = 0;
+	dcb_table_ptr->input_mlli_data_size = 0;
+	dcb_table_ptr->output_mlli_address = 0;
+	dcb_table_ptr->output_mlli_num_entries = 0;
+	dcb_table_ptr->output_mlli_data_size = 0;
+	dcb_table_ptr->tail_data_size = 0;
+	dcb_table_ptr->out_vr_tail_pt = 0;
+
+	if (isapplet == true) {
+
+		/* Check if there is enough data for DMA operation */
+		if (data_in_size < SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE) {
+			if (is_kva == true) {
+				error = -ENODEV;
+				goto end_function_error;
+			} else {
+				if (copy_from_user(dcb_table_ptr->tail_data,
+					(void __user *)app_in_address,
+					data_in_size)) {
+					error = -EFAULT;
+					goto end_function_error;
+				}
+			}
+
+			dcb_table_ptr->tail_data_size = data_in_size;
+
+			/* Set the output user-space address for mem2mem op */
+			if (app_out_address)
+				dcb_table_ptr->out_vr_tail_pt =
+				(aligned_u64)app_out_address;
+
+			/*
+			 * Update both data length parameters in order to avoid
+			 * second data copy and allow building of empty mlli
+			 * tables
+			 */
+			tail_size = 0x0;
+			data_in_size = 0x0;
+
+		} else {
+			if (!app_out_address) {
+				tail_size = data_in_size % block_size;
+				if (!tail_size) {
+					if (tail_block_size == block_size)
+						tail_size = block_size;
+				}
+			} else {
+				tail_size = 0;
+			}
+		}
+		if (tail_size) {
+			if (tail_size > sizeof(dcb_table_ptr->tail_data))
+				return -EINVAL;
+			if (is_kva == true) {
+				error = -ENODEV;
+				goto end_function_error;
+			} else {
+				/* We have tail data - copy it to DCB */
+				if (copy_from_user(dcb_table_ptr->tail_data,
+					(void __user *)(app_in_address +
+					data_in_size - tail_size), tail_size)) {
+					error = -EFAULT;
+					goto end_function_error;
+				}
+			}
+			if (app_out_address)
+				/*
+				 * Calculate the output address
+				 * according to tail data size
+				 */
+				dcb_table_ptr->out_vr_tail_pt =
+					(aligned_u64)app_out_address +
+					data_in_size - tail_size;
+
+			/* Save the real tail data size */
+			dcb_table_ptr->tail_data_size = tail_size;
+			/*
+			 * Update the data size without the tail
+			 * data size AKA data for the dma
+			 */
+			data_in_size = (data_in_size - tail_size);
+		}
+	}
+	/* Check if we need to build only input table or input/output */
+	if (app_out_address) {
+		/* Prepare input/output tables */
+		error = sep_prepare_input_output_dma_table(sep,
+				app_in_address,
+				app_out_address,
+				data_in_size,
+				block_size,
+				&in_first_mlli_address,
+				&out_first_mlli_address,
+				&in_first_num_entries,
+				&out_first_num_entries,
+				&first_data_size,
+				is_kva,
+				dmatables_region,
+				*dma_ctx);
+	} else {
+		/* Prepare input tables */
+		error = sep_prepare_input_dma_table(sep,
+				app_in_address,
+				data_in_size,
+				block_size,
+				&in_first_mlli_address,
+				&in_first_num_entries,
+				&first_data_size,
+				is_kva,
+				dmatables_region,
+				*dma_ctx);
+	}
+
+	if (error) {
+		dev_warn(&sep->pdev->dev,
+			"prepare DMA table call failed "
+			"from prepare DCB call\n");
+		goto end_function_error;
+	}
+
+	/* Set the DCB values */
+	dcb_table_ptr->input_mlli_address = in_first_mlli_address;
+	dcb_table_ptr->input_mlli_num_entries = in_first_num_entries;
+	dcb_table_ptr->input_mlli_data_size = first_data_size;
+	dcb_table_ptr->output_mlli_address = out_first_mlli_address;
+	dcb_table_ptr->output_mlli_num_entries = out_first_num_entries;
+	dcb_table_ptr->output_mlli_data_size = first_data_size;
+
+	goto end_function;
+
+end_function_error:
+	kfree(*dma_ctx);
+
+end_function:
+	return error;
+
+}
+
+
+/**
+ * sep_free_dma_tables_and_dcb - free DMA tables and DCBs
+ * @sep: pointer to struct sep_device
+ * @isapplet: indicates external application (used for kernel access)
+ * @is_kva: indicates kernel addresses (only used for kernel crypto)
+ *
+ * This function frees the DMA tables and DCB
+ */
+static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
+	bool is_kva, struct sep_dma_context **dma_ctx)
+{
+	struct sep_dcblock *dcb_table_ptr;
+	unsigned long pt_hold;
+	void *tail_pt;
+
+	int i = 0;
+	int error = 0;
+	int error_temp = 0;
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] sep_free_dma_tables_and_dcb\n",
+					current->pid);
+
+	if (isapplet == true) {
+		/* Set pointer to first DCB table */
+		dcb_table_ptr = (struct sep_dcblock *)
+			(sep->shared_addr +
+			SEP_DRIVER_SYSTEM_DCB_MEMORY_OFFSET_IN_BYTES);
+
+		/* Go over each DCB and see if tail pointer must be updated */
+		for (i = 0;
+		     i < (*dma_ctx)->nr_dcb_creat; i++, dcb_table_ptr++) {
+			if (dcb_table_ptr->out_vr_tail_pt) {
+				pt_hold = (unsigned long)dcb_table_ptr->
+					out_vr_tail_pt;
+				tail_pt = (void *)pt_hold;
+				if (is_kva == true) {
+					error = -ENODEV;
+					break;
+				} else {
+					error_temp = copy_to_user(
+						(void __user *)tail_pt,
+						dcb_table_ptr->tail_data,
+						dcb_table_ptr->tail_data_size);
+				}
+				if (error_temp) {
+					/* Release the DMA resource */
+					error = -EFAULT;
+					break;
+				}
+			}
+		}
+	}
+	/* Free the output pages, if any */
+	sep_free_dma_table_data_handler(sep, dma_ctx);
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] sep_free_dma_tables_and_dcb end\n",
+					current->pid);
+
+	return error;
+}
+
+/**
+ * sep_prepare_dcb_handler - prepare a control block
+ * @sep: pointer to struct sep_device
+ * @arg: pointer to user parameters
+ *
+ * This function will retrieve the RAR buffer physical addresses, type
+ * & size corresponding to the RAR handles provided in the buffers vector.
+ */
+static int sep_prepare_dcb_handler(struct sep_device *sep, unsigned long arg,
+				   struct sep_dma_context **dma_ctx)
+{
+	int error;
+	/* Command arguments */
+	static struct build_dcb_struct command_args;
+
+	/* Get the command arguments */
+	if (copy_from_user(&command_args, (void __user *)arg,
+					sizeof(struct build_dcb_struct))) {
+		error = -EFAULT;
+		goto end_function;
+	}
+
+	dev_dbg(&sep->pdev->dev,
+		"[PID%d] prep dcb handler app_in_address is %08llx\n",
+			current->pid, command_args.app_in_address);
+	dev_dbg(&sep->pdev->dev,
+		"[PID%d] app_out_address is %08llx\n",
+			current->pid, command_args.app_out_address);
+	dev_dbg(&sep->pdev->dev,
+		"[PID%d] data_size is %x\n",
+			current->pid, command_args.data_in_size);
+	dev_dbg(&sep->pdev->dev,
+		"[PID%d] block_size is %x\n",
+			current->pid, command_args.block_size);
+	dev_dbg(&sep->pdev->dev,
+		"[PID%d] tail block_size is %x\n",
+			current->pid, command_args.tail_block_size);
+	dev_dbg(&sep->pdev->dev,
+		"[PID%d] is_applet is %x\n",
+			current->pid, command_args.is_applet);
+
+	if (!command_args.app_in_address) {
+		dev_warn(&sep->pdev->dev,
+			"[PID%d] null app_in_address\n", current->pid);
+		error = -EINVAL;
+		goto end_function;
+	}
+
+	error = sep_prepare_input_output_dma_table_in_dcb(sep,
+			(unsigned long)command_args.app_in_address,
+			(unsigned long)command_args.app_out_address,
+			command_args.data_in_size, command_args.block_size,
+			command_args.tail_block_size,
+			command_args.is_applet, false,
+			NULL, NULL, dma_ctx, NULL, NULL);
+
+end_function:
+	return error;
+
+}
+
+/**
+ * sep_free_dcb_handler - free control block resources
+ * @sep: pointer to struct sep_device
+ *
+ * This function frees the DCB resources and updates the needed
+ * user-space buffers.
+ */
+static int sep_free_dcb_handler(struct sep_device *sep,
+				struct sep_dma_context **dma_ctx)
+{
+	int error = 0;
+
+	if (!dma_ctx || !(*dma_ctx)) {
+		dev_dbg(&sep->pdev->dev, "[PID%d] no dma context defined, nothing to free\n",
+			current->pid);
+		return error;
+	}
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] free dcbs num of DCBs %x\n",
+		current->pid,
+		(*dma_ctx)->nr_dcb_creat);
+
+	error = sep_free_dma_tables_and_dcb(sep, false, false, dma_ctx);
+
+	return error;
+}
+
+/**
+ * sep_ioctl - ioctl handler for sep device
+ * @filp: pointer to struct file
+ * @cmd: command
+ * @arg: pointer to argument structure
+ *
+ * Implement the ioctl methods availble on the SEP device.
+ */
+static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct sep_private_data * const private_data = filp->private_data;
+	struct sep_call_status *call_status = &private_data->call_status;
+	struct sep_device *sep = private_data->device;
+	struct sep_dma_context **dma_ctx = &private_data->dma_ctx;
+	struct sep_queue_info **my_queue_elem = &private_data->my_queue_elem;
+	int error = 0;
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] ioctl cmd 0x%x\n",
+		current->pid, cmd);
+	dev_dbg(&sep->pdev->dev, "[PID%d] dma context addr 0x%p\n",
+		current->pid, *dma_ctx);
+
+	/* Make sure we own this device */
+	error = sep_check_transaction_owner(sep);
+	if (error) {
+		dev_dbg(&sep->pdev->dev, "[PID%d] ioctl pid is not owner\n",
+			current->pid);
+		goto end_function;
+	}
+
+	/* Check that sep_mmap has been called before */
+	if (0 == test_bit(SEP_LEGACY_MMAP_DONE_OFFSET,
+				&call_status->status)) {
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] mmap not called\n", current->pid);
+		error = -EPROTO;
+		goto end_function;
+	}
+
+	/* Check that the command is for SEP device */
+	if (_IOC_TYPE(cmd) != SEP_IOC_MAGIC_NUMBER) {
+		error = -ENOTTY;
+		goto end_function;
+	}
+
+	switch (cmd) {
+	case SEP_IOCSENDSEPCOMMAND:
+		if (1 == test_bit(SEP_LEGACY_SENDMSG_DONE_OFFSET,
+				  &call_status->status)) {
+			dev_dbg(&sep->pdev->dev, "[PID%d] send msg already done\n",
+				current->pid);
+			error = -EPROTO;
+			goto end_function;
+		}
+		/* Send command to SEP */
+		error = sep_send_command_handler(sep);
+		if (!error)
+			set_bit(SEP_LEGACY_SENDMSG_DONE_OFFSET,
+				&call_status->status);
+		dev_dbg(&sep->pdev->dev, "[PID%d] SEP_IOCSENDSEPCOMMAND end\n",
+			current->pid);
+		break;
+	case SEP_IOCENDTRANSACTION:
+		error = sep_end_transaction_handler(sep, dma_ctx, call_status,
+			my_queue_elem);
+		dev_dbg(&sep->pdev->dev, "[PID%d] SEP_IOCENDTRANSACTION end\n",
+			current->pid);
+		break;
+	case SEP_IOCPREPAREDCB:
+		if (1 == test_bit(SEP_LEGACY_SENDMSG_DONE_OFFSET,
+				  &call_status->status)) {
+			dev_dbg(&sep->pdev->dev,
+				"[PID%d] dcb preparation needed before send msg\n",
+				current->pid);
+			error = -EPROTO;
+			goto end_function;
+		}
+
+		if (!arg) {
+			dev_dbg(&sep->pdev->dev,
+				"[PID%d] dcb prep null arg\n", current->pid);
+			error = -EINVAL;
+			goto end_function;
+		}
+
+		error = sep_prepare_dcb_handler(sep, arg, dma_ctx);
+		dev_dbg(&sep->pdev->dev, "[PID%d] SEP_IOCPREPAREDCB end\n",
+			current->pid);
+		break;
+	case SEP_IOCFREEDCB:
+		error = sep_free_dcb_handler(sep, dma_ctx);
+		dev_dbg(&sep->pdev->dev, "[PID%d] SEP_IOCFREEDCB end\n",
+			current->pid);
+		break;
+	default:
+		error = -ENOTTY;
+		dev_dbg(&sep->pdev->dev, "[PID%d] default end\n",
+			current->pid);
+		break;
+	}
+
+end_function:
+	dev_dbg(&sep->pdev->dev, "[PID%d] ioctl end\n", current->pid);
+
+	return error;
+}
+
+/**
+ * sep_inthandler - interrupt handler for sep device
+ * @irq: interrupt
+ * @dev_id: device id
+ */
+static irqreturn_t sep_inthandler(int irq, void *dev_id)
+{
+	unsigned long lock_irq_flag;
+	u32 reg_val, reg_val2 = 0;
+	struct sep_device *sep = dev_id;
+	irqreturn_t int_error = IRQ_HANDLED;
+
+	/* Are we in power save? */
+#if defined(CONFIG_PM_RUNTIME) && defined(SEP_ENABLE_RUNTIME_PM)
+	if (sep->pdev->dev.power.runtime_status != RPM_ACTIVE) {
+		dev_dbg(&sep->pdev->dev, "interrupt during pwr save\n");
+		return IRQ_NONE;
+	}
+#endif
+
+	if (test_bit(SEP_WORKING_LOCK_BIT, &sep->in_use_flags) == 0) {
+		dev_dbg(&sep->pdev->dev, "interrupt while nobody using sep\n");
+		return IRQ_NONE;
+	}
+
+	/* Read the IRR register to check if this is SEP interrupt */
+	reg_val = sep_read_reg(sep, HW_HOST_IRR_REG_ADDR);
+
+	dev_dbg(&sep->pdev->dev, "sep int: IRR REG val: %x\n", reg_val);
+
+	if (reg_val & (0x1 << 13)) {
+
+		/* Lock and update the counter of reply messages */
+		spin_lock_irqsave(&sep->snd_rply_lck, lock_irq_flag);
+		sep->reply_ct++;
+		spin_unlock_irqrestore(&sep->snd_rply_lck, lock_irq_flag);
+
+		dev_dbg(&sep->pdev->dev, "sep int: send_ct %lx reply_ct %lx\n",
+					sep->send_ct, sep->reply_ct);
+
+		/* Is this a kernel client request */
+		if (sep->in_kernel) {
+			tasklet_schedule(&sep->finish_tasklet);
+			goto finished_interrupt;
+		}
+
+		/* Is this printf or daemon request? */
+		reg_val2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
+		dev_dbg(&sep->pdev->dev,
+			"SEP Interrupt - GPR2 is %08x\n", reg_val2);
+
+		clear_bit(SEP_WORKING_LOCK_BIT, &sep->in_use_flags);
+
+		if ((reg_val2 >> 30) & 0x1) {
+			dev_dbg(&sep->pdev->dev, "int: printf request\n");
+		} else if (reg_val2 >> 31) {
+			dev_dbg(&sep->pdev->dev, "int: daemon request\n");
+		} else {
+			dev_dbg(&sep->pdev->dev, "int: SEP reply\n");
+			wake_up(&sep->event_interrupt);
+		}
+	} else {
+		dev_dbg(&sep->pdev->dev, "int: not SEP interrupt\n");
+		int_error = IRQ_NONE;
+	}
+
+finished_interrupt:
+
+	if (int_error == IRQ_HANDLED)
+		sep_write_reg(sep, HW_HOST_ICR_REG_ADDR, reg_val);
+
+	return int_error;
+}
+
+/**
+ * sep_reconfig_shared_area - reconfigure shared area
+ * @sep: pointer to struct sep_device
+ *
+ * Reconfig the shared area between HOST and SEP - needed in case
+ * the DX_CC_Init function was called before OS loading.
+ */
+static int sep_reconfig_shared_area(struct sep_device *sep)
+{
+	int ret_val;
+
+	/* use to limit waiting for SEP */
+	unsigned long end_time;
+
+	/* Send the new SHARED MESSAGE AREA to the SEP */
+	dev_dbg(&sep->pdev->dev, "reconfig shared; sending %08llx to sep\n",
+				(unsigned long long)sep->shared_bus);
+
+	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR1_REG_ADDR, sep->shared_bus);
+
+	/* Poll for SEP response */
+	ret_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR1_REG_ADDR);
+
+	end_time = jiffies + (WAIT_TIME * HZ);
+
+	while ((time_before(jiffies, end_time)) && (ret_val != 0xffffffff) &&
+		(ret_val != sep->shared_bus))
+		ret_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR1_REG_ADDR);
+
+	/* Check the return value (register) */
+	if (ret_val != sep->shared_bus) {
+		dev_warn(&sep->pdev->dev, "could not reconfig shared area\n");
+		dev_warn(&sep->pdev->dev, "result was %x\n", ret_val);
+		ret_val = -ENOMEM;
+	} else
+		ret_val = 0;
+
+	dev_dbg(&sep->pdev->dev, "reconfig shared area end\n");
+
+	return ret_val;
+}
+
+/**
+ *	sep_activate_dcb_dmatables_context - Takes DCB & DMA tables
+ *						contexts into use
+ *	@sep: SEP device
+ *	@dcb_region: DCB region copy
+ *	@dmatables_region: MLLI/DMA tables copy
+ *	@dma_ctx: DMA context for current transaction
+ */
+ssize_t sep_activate_dcb_dmatables_context(struct sep_device *sep,
+					struct sep_dcblock **dcb_region,
+					void **dmatables_region,
+					struct sep_dma_context *dma_ctx)
+{
+	void *dmaregion_free_start = NULL;
+	void *dmaregion_free_end = NULL;
+	void *dcbregion_free_start = NULL;
+	void *dcbregion_free_end = NULL;
+	ssize_t error = 0;
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] activating dcb/dma region\n",
+		current->pid);
+
+	if (1 > dma_ctx->nr_dcb_creat) {
+		dev_warn(&sep->pdev->dev,
+			 "[PID%d] invalid number of dcbs to activate 0x%08X\n",
+			 current->pid, dma_ctx->nr_dcb_creat);
+		error = -EINVAL;
+		goto end_function;
+	}
+
+	dmaregion_free_start = sep->shared_addr
+				+ SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES;
+	dmaregion_free_end = dmaregion_free_start
+				+ SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES - 1;
+
+	if (dmaregion_free_start
+	     + dma_ctx->dmatables_len > dmaregion_free_end) {
+		error = -ENOMEM;
+		goto end_function;
+	}
+	memcpy(dmaregion_free_start,
+	       *dmatables_region,
+	       dma_ctx->dmatables_len);
+	/* Free MLLI table copy */
+	kfree(*dmatables_region);
+	*dmatables_region = NULL;
+
+	/* Copy thread's DCB  table copy to DCB table region */
+	dcbregion_free_start = sep->shared_addr +
+				SEP_DRIVER_SYSTEM_DCB_MEMORY_OFFSET_IN_BYTES;
+	dcbregion_free_end = dcbregion_free_start +
+				(SEP_MAX_NUM_SYNC_DMA_OPS *
+					sizeof(struct sep_dcblock)) - 1;
+
+	if (dcbregion_free_start
+	     + (dma_ctx->nr_dcb_creat * sizeof(struct sep_dcblock))
+	     > dcbregion_free_end) {
+		error = -ENOMEM;
+		goto end_function;
+	}
+
+	memcpy(dcbregion_free_start,
+	       *dcb_region,
+	       dma_ctx->nr_dcb_creat * sizeof(struct sep_dcblock));
+
+	/* Print the tables */
+	dev_dbg(&sep->pdev->dev, "activate: input table\n");
+	sep_debug_print_lli_tables(sep,
+		(struct sep_lli_entry *)sep_shared_area_bus_to_virt(sep,
+		(*dcb_region)->input_mlli_address),
+		(*dcb_region)->input_mlli_num_entries,
+		(*dcb_region)->input_mlli_data_size);
+
+	dev_dbg(&sep->pdev->dev, "activate: output table\n");
+	sep_debug_print_lli_tables(sep,
+		(struct sep_lli_entry *)sep_shared_area_bus_to_virt(sep,
+		(*dcb_region)->output_mlli_address),
+		(*dcb_region)->output_mlli_num_entries,
+		(*dcb_region)->output_mlli_data_size);
+
+	dev_dbg(&sep->pdev->dev,
+		 "[PID%d] printing activated tables\n", current->pid);
+
+end_function:
+	kfree(*dmatables_region);
+	*dmatables_region = NULL;
+
+	kfree(*dcb_region);
+	*dcb_region = NULL;
+
+	return error;
+}
+
+/**
+ *	sep_create_dcb_dmatables_context - Creates DCB & MLLI/DMA table context
+ *	@sep: SEP device
+ *	@dcb_region: DCB region buf to create for current transaction
+ *	@dmatables_region: MLLI/DMA tables buf to create for current transaction
+ *	@dma_ctx: DMA context buf to create for current transaction
+ *	@user_dcb_args: User arguments for DCB/MLLI creation
+ *	@num_dcbs: Number of DCBs to create
+ */
+static ssize_t sep_create_dcb_dmatables_context(struct sep_device *sep,
+			struct sep_dcblock **dcb_region,
+			void **dmatables_region,
+			struct sep_dma_context **dma_ctx,
+			const struct build_dcb_struct __user *user_dcb_args,
+			const u32 num_dcbs)
+{
+	int error = 0;
+	int i = 0;
+	struct build_dcb_struct *dcb_args = NULL;
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] creating dcb/dma region\n",
+		current->pid);
+
+	if (!dcb_region || !dma_ctx || !dmatables_region || !user_dcb_args) {
+		error = -EINVAL;
+		goto end_function;
+	}
+
+	if (SEP_MAX_NUM_SYNC_DMA_OPS < num_dcbs) {
+		dev_warn(&sep->pdev->dev,
+			 "[PID%d] invalid number of dcbs 0x%08X\n",
+			 current->pid, num_dcbs);
+		error = -EINVAL;
+		goto end_function;
+	}
+
+	dcb_args = kzalloc(num_dcbs * sizeof(struct build_dcb_struct),
+			   GFP_KERNEL);
+	if (!dcb_args) {
+		dev_warn(&sep->pdev->dev, "[PID%d] no memory for dcb args\n",
+			 current->pid);
+		error = -ENOMEM;
+		goto end_function;
+	}
+
+	if (copy_from_user(dcb_args,
+			user_dcb_args,
+			num_dcbs * sizeof(struct build_dcb_struct))) {
+		error = -EINVAL;
+		goto end_function;
+	}
+
+	/* Allocate thread-specific memory for DCB */
+	*dcb_region = kzalloc(num_dcbs * sizeof(struct sep_dcblock),
+			      GFP_KERNEL);
+	if (!(*dcb_region)) {
+		error = -ENOMEM;
+		goto end_function;
+	}
+
+	/* Prepare DCB and MLLI table into the allocated regions */
+	for (i = 0; i < num_dcbs; i++) {
+		error = sep_prepare_input_output_dma_table_in_dcb(sep,
+				(unsigned long)dcb_args[i].app_in_address,
+				(unsigned long)dcb_args[i].app_out_address,
+				dcb_args[i].data_in_size,
+				dcb_args[i].block_size,
+				dcb_args[i].tail_block_size,
+				dcb_args[i].is_applet,
+				false,
+				*dcb_region, dmatables_region,
+				dma_ctx,
+				NULL,
+				NULL);
+		if (error) {
+			dev_warn(&sep->pdev->dev,
+				 "[PID%d] dma table creation failed\n",
+				 current->pid);
+			goto end_function;
+		}
+	}
+
+end_function:
+	kfree(dcb_args);
+	return error;
+
+}
+
+/**
+ *	sep_create_dcb_dmatables_context_kernel - Creates DCB & MLLI/DMA table context
+ *      for kernel crypto
+ *	@sep: SEP device
+ *	@dcb_region: DCB region buf to create for current transaction
+ *	@dmatables_region: MLLI/DMA tables buf to create for current transaction
+ *	@dma_ctx: DMA context buf to create for current transaction
+ *	@user_dcb_args: User arguments for DCB/MLLI creation
+ *	@num_dcbs: Number of DCBs to create
+ *	This does that same thing as sep_create_dcb_dmatables_context
+ *	except that it is used only for the kernel crypto operation. It is
+ *	separate because there is no user data involved; the dcb data structure
+ *	is specific for kernel crypto (build_dcb_struct_kernel)
+ */
+int sep_create_dcb_dmatables_context_kernel(struct sep_device *sep,
+			struct sep_dcblock **dcb_region,
+			void **dmatables_region,
+			struct sep_dma_context **dma_ctx,
+			const struct build_dcb_struct_kernel *dcb_data,
+			const u32 num_dcbs)
+{
+	int error = 0;
+	int i = 0;
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] creating dcb/dma region\n",
+		current->pid);
+
+	if (!dcb_region || !dma_ctx || !dmatables_region || !dcb_data) {
+		error = -EINVAL;
+		goto end_function;
+	}
+
+	if (SEP_MAX_NUM_SYNC_DMA_OPS < num_dcbs) {
+		dev_warn(&sep->pdev->dev,
+			 "[PID%d] invalid number of dcbs 0x%08X\n",
+			 current->pid, num_dcbs);
+		error = -EINVAL;
+		goto end_function;
+	}
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] num_dcbs is %d\n",
+		current->pid, num_dcbs);
+
+	/* Allocate thread-specific memory for DCB */
+	*dcb_region = kzalloc(num_dcbs * sizeof(struct sep_dcblock),
+			      GFP_KERNEL);
+	if (!(*dcb_region)) {
+		error = -ENOMEM;
+		goto end_function;
+	}
+
+	/* Prepare DCB and MLLI table into the allocated regions */
+	for (i = 0; i < num_dcbs; i++) {
+		error = sep_prepare_input_output_dma_table_in_dcb(sep,
+				(unsigned long)dcb_data->app_in_address,
+				(unsigned long)dcb_data->app_out_address,
+				dcb_data->data_in_size,
+				dcb_data->block_size,
+				dcb_data->tail_block_size,
+				dcb_data->is_applet,
+				true,
+				*dcb_region, dmatables_region,
+				dma_ctx,
+				dcb_data->src_sg,
+				dcb_data->dst_sg);
+		if (error) {
+			dev_warn(&sep->pdev->dev,
+				 "[PID%d] dma table creation failed\n",
+				 current->pid);
+			goto end_function;
+		}
+	}
+
+end_function:
+	return error;
+
+}
+
+/**
+ *	sep_activate_msgarea_context - Takes the message area context into use
+ *	@sep: SEP device
+ *	@msg_region: Message area context buf
+ *	@msg_len: Message area context buffer size
+ */
+static ssize_t sep_activate_msgarea_context(struct sep_device *sep,
+					    void **msg_region,
+					    const size_t msg_len)
+{
+	dev_dbg(&sep->pdev->dev, "[PID%d] activating msg region\n",
+		current->pid);
+
+	if (!msg_region || !(*msg_region) ||
+	    SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES < msg_len) {
+		dev_warn(&sep->pdev->dev,
+			 "[PID%d] invalid act msgarea len 0x%08X\n",
+			 current->pid, msg_len);
+		return -EINVAL;
+	}
+
+	memcpy(sep->shared_addr, *msg_region, msg_len);
+
+	return 0;
+}
+
+/**
+ *	sep_create_msgarea_context - Creates message area context
+ *	@sep: SEP device
+ *	@msg_region: Msg area region buf to create for current transaction
+ *	@msg_user: Content for msg area region from user
+ *	@msg_len: Message area size
+ */
+static ssize_t sep_create_msgarea_context(struct sep_device *sep,
+					  void **msg_region,
+					  const void __user *msg_user,
+					  const size_t msg_len)
+{
+	int error = 0;
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] creating msg region\n",
+		current->pid);
+
+	if (!msg_region ||
+	    !msg_user ||
+	    SEP_DRIVER_MAX_MESSAGE_SIZE_IN_BYTES < msg_len ||
+	    SEP_DRIVER_MIN_MESSAGE_SIZE_IN_BYTES > msg_len) {
+		dev_warn(&sep->pdev->dev,
+			 "[PID%d] invalid creat msgarea len 0x%08X\n",
+			 current->pid, msg_len);
+		error = -EINVAL;
+		goto end_function;
+	}
+
+	/* Allocate thread-specific memory for message buffer */
+	*msg_region = kzalloc(msg_len, GFP_KERNEL);
+	if (!(*msg_region)) {
+		dev_warn(&sep->pdev->dev,
+			 "[PID%d] no mem for msgarea context\n",
+			 current->pid);
+		error = -ENOMEM;
+		goto end_function;
+	}
+
+	/* Copy input data to write() to allocated message buffer */
+	if (copy_from_user(*msg_region, msg_user, msg_len)) {
+		error = -EINVAL;
+		goto end_function;
+	}
+
+end_function:
+	if (error && msg_region) {
+		kfree(*msg_region);
+		*msg_region = NULL;
+	}
+
+	return error;
+}
+
+
+/**
+ *	sep_read - Returns results of an operation for fastcall interface
+ *	@filp: File pointer
+ *	@buf_user: User buffer for storing results
+ *	@count_user: User buffer size
+ *	@offset: File offset, not supported
+ *
+ *	The implementation does not support reading in chunks, all data must be
+ *	consumed during a single read system call.
+ */
+static ssize_t sep_read(struct file *filp,
+			char __user *buf_user, size_t count_user,
+			loff_t *offset)
+{
+	struct sep_private_data * const private_data = filp->private_data;
+	struct sep_call_status *call_status = &private_data->call_status;
+	struct sep_device *sep = private_data->device;
+	struct sep_dma_context **dma_ctx = &private_data->dma_ctx;
+	struct sep_queue_info **my_queue_elem = &private_data->my_queue_elem;
+	ssize_t error = 0, error_tmp = 0;
+
+	/* Am I the process that owns the transaction? */
+	error = sep_check_transaction_owner(sep);
+	if (error) {
+		dev_dbg(&sep->pdev->dev, "[PID%d] read pid is not owner\n",
+			current->pid);
+		goto end_function;
+	}
+
+	/* Checks that user has called necessarry apis */
+	if (0 == test_bit(SEP_FASTCALL_WRITE_DONE_OFFSET,
+			&call_status->status)) {
+		dev_warn(&sep->pdev->dev,
+			 "[PID%d] fastcall write not called\n",
+			 current->pid);
+		error = -EPROTO;
+		goto end_function_error;
+	}
+
+	if (!buf_user) {
+		dev_warn(&sep->pdev->dev,
+			 "[PID%d] null user buffer\n",
+			 current->pid);
+		error = -EINVAL;
+		goto end_function_error;
+	}
+
+
+	/* Wait for SEP to finish */
+	wait_event(sep->event_interrupt,
+		   test_bit(SEP_WORKING_LOCK_BIT,
+			    &sep->in_use_flags) == 0);
+
+	sep_dump_message(sep);
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] count_user = 0x%08X\n",
+		current->pid, count_user);
+
+	/* In case user has allocated bigger buffer */
+	if (count_user > SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES)
+		count_user = SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES;
+
+	if (copy_to_user(buf_user, sep->shared_addr, count_user)) {
+		error = -EFAULT;
+		goto end_function_error;
+	}
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] read succeeded\n", current->pid);
+	error = count_user;
+
+end_function_error:
+	/* Copy possible tail data to user and free DCB and MLLIs */
+	error_tmp = sep_free_dcb_handler(sep, dma_ctx);
+	if (error_tmp)
+		dev_warn(&sep->pdev->dev, "[PID%d] dcb free failed\n",
+			current->pid);
+
+	/* End the transaction, wakeup pending ones */
+	error_tmp = sep_end_transaction_handler(sep, dma_ctx, call_status,
+		my_queue_elem);
+	if (error_tmp)
+		dev_warn(&sep->pdev->dev,
+			 "[PID%d] ending transaction failed\n",
+			 current->pid);
+
+end_function:
+	return error;
+}
+
+/**
+ *	sep_fastcall_args_get - Gets fastcall params from user
+ *	sep: SEP device
+ *	@args: Parameters buffer
+ *	@buf_user: User buffer for operation parameters
+ *	@count_user: User buffer size
+ */
+static inline ssize_t sep_fastcall_args_get(struct sep_device *sep,
+					    struct sep_fastcall_hdr *args,
+					    const char __user *buf_user,
+					    const size_t count_user)
+{
+	ssize_t error = 0;
+	size_t actual_count = 0;
+
+	if (!buf_user) {
+		dev_warn(&sep->pdev->dev,
+			 "[PID%d] null user buffer\n",
+			 current->pid);
+		error = -EINVAL;
+		goto end_function;
+	}
+
+	if (count_user < sizeof(struct sep_fastcall_hdr)) {
+		dev_warn(&sep->pdev->dev,
+			 "[PID%d] too small message size 0x%08X\n",
+			 current->pid, count_user);
+		error = -EINVAL;
+		goto end_function;
+	}
+
+
+	if (copy_from_user(args, buf_user, sizeof(struct sep_fastcall_hdr))) {
+		error = -EFAULT;
+		goto end_function;
+	}
+
+	if (SEP_FC_MAGIC != args->magic) {
+		dev_warn(&sep->pdev->dev,
+			 "[PID%d] invalid fastcall magic 0x%08X\n",
+			 current->pid, args->magic);
+		error = -EINVAL;
+		goto end_function;
+	}
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] fastcall hdr num of DCBs 0x%08X\n",
+		current->pid, args->num_dcbs);
+	dev_dbg(&sep->pdev->dev, "[PID%d] fastcall hdr msg len 0x%08X\n",
+		current->pid, args->msg_len);
+
+	if (SEP_DRIVER_MAX_MESSAGE_SIZE_IN_BYTES < args->msg_len ||
+	    SEP_DRIVER_MIN_MESSAGE_SIZE_IN_BYTES > args->msg_len) {
+		dev_warn(&sep->pdev->dev,
+			 "[PID%d] invalid message length\n",
+			 current->pid);
+		error = -EINVAL;
+		goto end_function;
+	}
+
+	actual_count = sizeof(struct sep_fastcall_hdr)
+			+ args->msg_len
+			+ (args->num_dcbs * sizeof(struct build_dcb_struct));
+
+	if (actual_count != count_user) {
+		dev_warn(&sep->pdev->dev,
+			 "[PID%d] inconsistent message "
+			 "sizes 0x%08X vs 0x%08X\n",
+			 current->pid, actual_count, count_user);
+		error = -EMSGSIZE;
+		goto end_function;
+	}
+
+end_function:
+	return error;
+}
+
+/**
+ *	sep_write - Starts an operation for fastcall interface
+ *	@filp: File pointer
+ *	@buf_user: User buffer for operation parameters
+ *	@count_user: User buffer size
+ *	@offset: File offset, not supported
+ *
+ *	The implementation does not support writing in chunks,
+ *	all data must be given during a single write system call.
+ */
+static ssize_t sep_write(struct file *filp,
+			 const char __user *buf_user, size_t count_user,
+			 loff_t *offset)
+{
+	struct sep_private_data * const private_data = filp->private_data;
+	struct sep_call_status *call_status = &private_data->call_status;
+	struct sep_device *sep = private_data->device;
+	struct sep_dma_context *dma_ctx = NULL;
+	struct sep_fastcall_hdr call_hdr = {0};
+	void *msg_region = NULL;
+	void *dmatables_region = NULL;
+	struct sep_dcblock *dcb_region = NULL;
+	ssize_t error = 0;
+	struct sep_queue_info *my_queue_elem = NULL;
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] sep dev is 0x%p\n",
+		current->pid, sep);
+	dev_dbg(&sep->pdev->dev, "[PID%d] private_data is 0x%p\n",
+		current->pid, private_data);
+
+	error = sep_fastcall_args_get(sep, &call_hdr, buf_user, count_user);
+	if (error)
+		goto end_function;
+
+	buf_user += sizeof(struct sep_fastcall_hdr);
+
+	/*
+	 * Controlling driver memory usage by limiting amount of
+	 * buffers created. Only SEP_DOUBLEBUF_USERS_LIMIT number
+	 * of threads can progress further at a time
+	 */
+	dev_dbg(&sep->pdev->dev, "[PID%d] waiting for double buffering "
+				 "region access\n", current->pid);
+	error = down_interruptible(&sep->sep_doublebuf);
+	dev_dbg(&sep->pdev->dev, "[PID%d] double buffering region start\n",
+					current->pid);
+	if (error) {
+		/* Signal received */
+		goto end_function_error;
+	}
+
+
+	/*
+	 * Prepare contents of the shared area regions for
+	 * the operation into temporary buffers
+	 */
+	if (0 < call_hdr.num_dcbs) {
+		error = sep_create_dcb_dmatables_context(sep,
+				&dcb_region,
+				&dmatables_region,
+				&dma_ctx,
+				(const struct build_dcb_struct __user *)
+					buf_user,
+				call_hdr.num_dcbs);
+		if (error)
+			goto end_function_error_doublebuf;
+
+		buf_user += call_hdr.num_dcbs * sizeof(struct build_dcb_struct);
+	}
+
+	error = sep_create_msgarea_context(sep,
+					   &msg_region,
+					   buf_user,
+					   call_hdr.msg_len);
+	if (error)
+		goto end_function_error_doublebuf;
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] updating queue status\n",
+							current->pid);
+	my_queue_elem = sep_queue_status_add(sep,
+				((struct sep_msgarea_hdr *)msg_region)->opcode,
+				(dma_ctx) ? dma_ctx->input_data_len : 0,
+				     current->pid,
+				     current->comm, sizeof(current->comm));
+
+	if (!my_queue_elem) {
+		dev_dbg(&sep->pdev->dev, "[PID%d] updating queue"
+					"status error\n", current->pid);
+		error = -ENOMEM;
+		goto end_function_error_doublebuf;
+	}
+
+	/* Wait until current process gets the transaction */
+	error = sep_wait_transaction(sep);
+
+	if (error) {
+		/* Interrupted by signal, don't clear transaction */
+		dev_dbg(&sep->pdev->dev, "[PID%d] interrupted by signal\n",
+			current->pid);
+		sep_queue_status_remove(sep, &my_queue_elem);
+		goto end_function_error_doublebuf;
+	}
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] saving queue element\n",
+		current->pid);
+	private_data->my_queue_elem = my_queue_elem;
+
+	/* Activate shared area regions for the transaction */
+	error = sep_activate_msgarea_context(sep, &msg_region,
+					     call_hdr.msg_len);
+	if (error)
+		goto end_function_error_clear_transact;
+
+	sep_dump_message(sep);
+
+	if (0 < call_hdr.num_dcbs) {
+		error = sep_activate_dcb_dmatables_context(sep,
+				&dcb_region,
+				&dmatables_region,
+				dma_ctx);
+		if (error)
+			goto end_function_error_clear_transact;
+	}
+
+	/* Send command to SEP */
+	error = sep_send_command_handler(sep);
+	if (error)
+		goto end_function_error_clear_transact;
+
+	/* Store DMA context for the transaction */
+	private_data->dma_ctx = dma_ctx;
+	/* Update call status */
+	set_bit(SEP_FASTCALL_WRITE_DONE_OFFSET, &call_status->status);
+	error = count_user;
+
+	up(&sep->sep_doublebuf);
+	dev_dbg(&sep->pdev->dev, "[PID%d] double buffering region end\n",
+		current->pid);
+
+	goto end_function;
+
+end_function_error_clear_transact:
+	sep_end_transaction_handler(sep, &dma_ctx, call_status,
+						&private_data->my_queue_elem);
+
+end_function_error_doublebuf:
+	up(&sep->sep_doublebuf);
+	dev_dbg(&sep->pdev->dev, "[PID%d] double buffering region end\n",
+		current->pid);
+
+end_function_error:
+	if (dma_ctx)
+		sep_free_dma_table_data_handler(sep, &dma_ctx);
+
+end_function:
+	kfree(dcb_region);
+	kfree(dmatables_region);
+	kfree(msg_region);
+
+	return error;
+}
+/**
+ *	sep_seek - Handler for seek system call
+ *	@filp: File pointer
+ *	@offset: File offset
+ *	@origin: Options for offset
+ *
+ *	Fastcall interface does not support seeking, all reads
+ *	and writes are from/to offset zero
+ */
+static loff_t sep_seek(struct file *filp, loff_t offset, int origin)
+{
+	return -ENOSYS;
+}
+
+
+
+/**
+ * sep_file_operations - file operation on sep device
+ * @sep_ioctl:	ioctl handler from user space call
+ * @sep_poll:	poll handler
+ * @sep_open:	handles sep device open request
+ * @sep_release:handles sep device release request
+ * @sep_mmap:	handles memory mapping requests
+ * @sep_read:	handles read request on sep device
+ * @sep_write:	handles write request on sep device
+ * @sep_seek:	handles seek request on sep device
+ */
+static const struct file_operations sep_file_operations = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = sep_ioctl,
+	.poll = sep_poll,
+	.open = sep_open,
+	.release = sep_release,
+	.mmap = sep_mmap,
+	.read = sep_read,
+	.write = sep_write,
+	.llseek = sep_seek,
+};
+
+/**
+ * sep_sysfs_read - read sysfs entry per gives arguments
+ * @filp: file pointer
+ * @kobj: kobject pointer
+ * @attr: binary file attributes
+ * @buf: read to this buffer
+ * @pos: offset to read
+ * @count: amount of data to read
+ *
+ * This function is to read sysfs entries for sep driver per given arguments.
+ */
+static ssize_t
+sep_sysfs_read(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *attr,
+		char *buf, loff_t pos, size_t count)
+{
+	unsigned long lck_flags;
+	size_t nleft = count;
+	struct sep_device *sep = sep_dev;
+	struct sep_queue_info *queue_elem = NULL;
+	u32 queue_num = 0;
+	u32 i = 1;
+
+	spin_lock_irqsave(&sep->sep_queue_lock, lck_flags);
+
+	queue_num = sep->sep_queue_num;
+	if (queue_num > SEP_DOUBLEBUF_USERS_LIMIT)
+		queue_num = SEP_DOUBLEBUF_USERS_LIMIT;
+
+
+	if (count < sizeof(queue_num)
+			+ (queue_num * sizeof(struct sep_queue_data))) {
+		spin_unlock_irqrestore(&sep->sep_queue_lock, lck_flags);
+		return -EINVAL;
+	}
+
+	memcpy(buf, &queue_num, sizeof(queue_num));
+	buf += sizeof(queue_num);
+	nleft -= sizeof(queue_num);
+
+	list_for_each_entry(queue_elem, &sep->sep_queue_status, list) {
+		if (i++ > queue_num)
+			break;
+
+		memcpy(buf, &queue_elem->data, sizeof(queue_elem->data));
+		nleft -= sizeof(queue_elem->data);
+		buf += sizeof(queue_elem->data);
+	}
+	spin_unlock_irqrestore(&sep->sep_queue_lock, lck_flags);
+
+	return count - nleft;
+}
+
+/**
+ * bin_attributes - defines attributes for queue_status
+ * @attr: attributes (name & permissions)
+ * @read: function pointer to read this file
+ * @size: maxinum size of binary attribute
+ */
+static const struct bin_attribute queue_status = {
+	.attr = {.name = "queue_status", .mode = 0444},
+	.read = sep_sysfs_read,
+	.size = sizeof(u32)
+		+ (SEP_DOUBLEBUF_USERS_LIMIT * sizeof(struct sep_queue_data)),
+};
+
+/**
+ * sep_register_driver_with_fs - register misc devices
+ * @sep: pointer to struct sep_device
+ *
+ * This function registers the driver with the file system
+ */
+static int sep_register_driver_with_fs(struct sep_device *sep)
+{
+	int ret_val;
+
+	sep->miscdev_sep.minor = MISC_DYNAMIC_MINOR;
+	sep->miscdev_sep.name = SEP_DEV_NAME;
+	sep->miscdev_sep.fops = &sep_file_operations;
+
+	ret_val = misc_register(&sep->miscdev_sep);
+	if (ret_val) {
+		dev_warn(&sep->pdev->dev, "misc reg fails for SEP %x\n",
+			ret_val);
+		return ret_val;
+	}
+
+	ret_val = device_create_bin_file(sep->miscdev_sep.this_device,
+								&queue_status);
+	if (ret_val) {
+		dev_warn(&sep->pdev->dev, "sysfs attribute1 fails for SEP %x\n",
+			ret_val);
+		return ret_val;
+	}
+
+	return ret_val;
+}
+
+
+/**
+ *sep_probe - probe a matching PCI device
+ *@pdev:	pci_device
+ *@ent:	pci_device_id
+ *
+ *Attempt to set up and configure a SEP device that has been
+ *discovered by the PCI layer. Allocates all required resources.
+ */
+static int __devinit sep_probe(struct pci_dev *pdev,
+	const struct pci_device_id *ent)
+{
+	int error = 0;
+	struct sep_device *sep = NULL;
+
+	if (sep_dev != NULL) {
+		dev_dbg(&pdev->dev, "only one SEP supported.\n");
+		return -EBUSY;
+	}
+
+	/* Enable the device */
+	error = pci_enable_device(pdev);
+	if (error) {
+		dev_warn(&pdev->dev, "error enabling pci device\n");
+		goto end_function;
+	}
+
+	/* Allocate the sep_device structure for this device */
+	sep_dev = kzalloc(sizeof(struct sep_device), GFP_ATOMIC);
+	if (sep_dev == NULL) {
+		dev_warn(&pdev->dev,
+			"can't kmalloc the sep_device structure\n");
+		error = -ENOMEM;
+		goto end_function_disable_device;
+	}
+
+	/*
+	 * We're going to use another variable for actually
+	 * working with the device; this way, if we have
+	 * multiple devices in the future, it would be easier
+	 * to make appropriate changes
+	 */
+	sep = sep_dev;
+
+	sep->pdev = pci_dev_get(pdev);
+
+	init_waitqueue_head(&sep->event_transactions);
+	init_waitqueue_head(&sep->event_interrupt);
+	spin_lock_init(&sep->snd_rply_lck);
+	spin_lock_init(&sep->sep_queue_lock);
+	sema_init(&sep->sep_doublebuf, SEP_DOUBLEBUF_USERS_LIMIT);
+
+	INIT_LIST_HEAD(&sep->sep_queue_status);
+
+	dev_dbg(&sep->pdev->dev, "sep probe: PCI obtained, "
+		"device being prepared\n");
+	dev_dbg(&sep->pdev->dev, "revision is %d\n", sep->pdev->revision);
+
+	/* Set up our register area */
+	sep->reg_physical_addr = pci_resource_start(sep->pdev, 0);
+	if (!sep->reg_physical_addr) {
+		dev_warn(&sep->pdev->dev, "Error getting register start\n");
+		error = -ENODEV;
+		goto end_function_free_sep_dev;
+	}
+
+	sep->reg_physical_end = pci_resource_end(sep->pdev, 0);
+	if (!sep->reg_physical_end) {
+		dev_warn(&sep->pdev->dev, "Error getting register end\n");
+		error = -ENODEV;
+		goto end_function_free_sep_dev;
+	}
+
+	sep->reg_addr = ioremap_nocache(sep->reg_physical_addr,
+		(size_t)(sep->reg_physical_end - sep->reg_physical_addr + 1));
+	if (!sep->reg_addr) {
+		dev_warn(&sep->pdev->dev, "Error getting register virtual\n");
+		error = -ENODEV;
+		goto end_function_free_sep_dev;
+	}
+
+	dev_dbg(&sep->pdev->dev,
+		"Register area start %llx end %llx virtual %p\n",
+		(unsigned long long)sep->reg_physical_addr,
+		(unsigned long long)sep->reg_physical_end,
+		sep->reg_addr);
+
+	/* Allocate the shared area */
+	sep->shared_size = SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES +
+		SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES +
+		SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES +
+		SEP_DRIVER_STATIC_AREA_SIZE_IN_BYTES +
+		SEP_DRIVER_SYSTEM_DATA_MEMORY_SIZE_IN_BYTES;
+
+	if (sep_map_and_alloc_shared_area(sep)) {
+		error = -ENOMEM;
+		/* Allocation failed */
+		goto end_function_error;
+	}
+
+	/* Clear ICR register */
+	sep_write_reg(sep, HW_HOST_ICR_REG_ADDR, 0xFFFFFFFF);
+
+	/* Set the IMR register - open only GPR 2 */
+	sep_write_reg(sep, HW_HOST_IMR_REG_ADDR, (~(0x1 << 13)));
+
+	/* Read send/receive counters from SEP */
+	sep->reply_ct = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
+	sep->reply_ct &= 0x3FFFFFFF;
+	sep->send_ct = sep->reply_ct;
+
+	/* Get the interrupt line */
+	error = request_irq(pdev->irq, sep_inthandler, IRQF_SHARED,
+		"sep_driver", sep);
+
+	if (error)
+		goto end_function_deallocate_sep_shared_area;
+
+	/* The new chip requires a shared area reconfigure */
+	if (sep->pdev->revision != 0) { /* Only for new chip */
+		error = sep_reconfig_shared_area(sep);
+		if (error)
+			goto end_function_free_irq;
+	}
+
+	sep->in_use = 1;
+
+	/* Finally magic up the device nodes */
+	/* Register driver with the fs */
+	error = sep_register_driver_with_fs(sep);
+	if (error)
+		goto end_function_free_irq;
+
+#ifdef SEP_ENABLE_RUNTIME_PM
+	pm_runtime_put_noidle(&sep->pdev->dev);
+	pm_runtime_allow(&sep->pdev->dev);
+	pm_runtime_set_autosuspend_delay(&sep->pdev->dev,
+		SUSPEND_DELAY);
+	pm_runtime_use_autosuspend(&sep->pdev->dev);
+	sep->power_save_setup = 1;
+#endif
+
+	sep->in_use = 0;
+
+	/* register kernel crypto driver */
+	error = sep_crypto_setup();
+	if (error) {
+		dev_dbg(&sep->pdev->dev, "crypto setup fail\n");
+		goto end_function_free_irq;
+	}
+
+	goto end_function;
+
+end_function_free_irq:
+	free_irq(pdev->irq, sep);
+
+end_function_deallocate_sep_shared_area:
+	/* De-allocate shared area */
+	sep_unmap_and_free_shared_area(sep);
+
+end_function_error:
+	iounmap(sep->reg_addr);
+
+end_function_free_sep_dev:
+	pci_dev_put(sep_dev->pdev);
+	kfree(sep_dev);
+	sep_dev = NULL;
+
+end_function_disable_device:
+	pci_disable_device(pdev);
+
+end_function:
+	return error;
+}
+
+/**
+ * sep_remove -	handles removing device from pci subsystem
+ * @pdev:	pointer to pci device
+ *
+ * This function will handle removing our sep device from pci subsystem on exit
+ * or unloading this module. It should free up all used resources, and unmap if
+ * any memory regions mapped.
+ */
+static void sep_remove(struct pci_dev *pdev)
+{
+	struct sep_device *sep = sep_dev;
+
+	/* Unregister from fs */
+	misc_deregister(&sep->miscdev_sep);
+
+	/* Unregister from kernel crypto */
+	sep_crypto_takedown();
+
+	/* Free the irq */
+	free_irq(sep->pdev->irq, sep);
+
+	/* Free the shared area  */
+	sep_unmap_and_free_shared_area(sep_dev);
+	iounmap((void __iomem *)sep_dev->reg_addr);
+
+#ifdef SEP_ENABLE_RUNTIME_PM
+	if (sep->in_use) {
+		sep->in_use = 0;
+		pm_runtime_forbid(&sep->pdev->dev);
+		pm_runtime_get_noresume(&sep->pdev->dev);
+	}
+#endif
+	pci_dev_put(sep_dev->pdev);
+	kfree(sep_dev);
+	sep_dev = NULL;
+}
+
+/* Initialize struct pci_device_id for our driver */
+static DEFINE_PCI_DEVICE_TABLE(sep_pci_id_tbl) = {
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MFLD_PCI_DEVICE_ID)},
+	{0}
+};
+
+/* Export our pci_device_id structure to user space */
+MODULE_DEVICE_TABLE(pci, sep_pci_id_tbl);
+
+#ifdef SEP_ENABLE_RUNTIME_PM
+
+/**
+ * sep_pm_resume - rsume routine while waking up from S3 state
+ * @dev:	pointer to sep device
+ *
+ * This function is to be used to wake up sep driver while system awakes from S3
+ * state i.e. suspend to ram. The RAM in intact.
+ * Notes - revisit with more understanding of pm, ICR/IMR & counters.
+ */
+static int sep_pci_resume(struct device *dev)
+{
+	struct sep_device *sep = sep_dev;
+
+	dev_dbg(&sep->pdev->dev, "pci resume called\n");
+
+	if (sep->power_state == SEP_DRIVER_POWERON)
+		return 0;
+
+	/* Clear ICR register */
+	sep_write_reg(sep, HW_HOST_ICR_REG_ADDR, 0xFFFFFFFF);
+
+	/* Set the IMR register - open only GPR 2 */
+	sep_write_reg(sep, HW_HOST_IMR_REG_ADDR, (~(0x1 << 13)));
+
+	/* Read send/receive counters from SEP */
+	sep->reply_ct = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
+	sep->reply_ct &= 0x3FFFFFFF;
+	sep->send_ct = sep->reply_ct;
+
+	sep->power_state = SEP_DRIVER_POWERON;
+
+	return 0;
+}
+
+/**
+ * sep_pm_suspend - suspend routine while going to S3 state
+ * @dev:	pointer to sep device
+ *
+ * This function is to be used to suspend sep driver while system goes to S3
+ * state i.e. suspend to ram. The RAM in intact and ON during this suspend.
+ * Notes - revisit with more understanding of pm, ICR/IMR
+ */
+static int sep_pci_suspend(struct device *dev)
+{
+	struct sep_device *sep = sep_dev;
+
+	dev_dbg(&sep->pdev->dev, "pci suspend called\n");
+	if (sep->in_use == 1)
+		return -EAGAIN;
+
+	sep->power_state = SEP_DRIVER_POWEROFF;
+
+	/* Clear ICR register */
+	sep_write_reg(sep, HW_HOST_ICR_REG_ADDR, 0xFFFFFFFF);
+
+	/* Set the IMR to block all */
+	sep_write_reg(sep, HW_HOST_IMR_REG_ADDR, 0xFFFFFFFF);
+
+	return 0;
+}
+
+/**
+ * sep_pm_runtime_resume - runtime resume routine
+ * @dev:	pointer to sep device
+ *
+ * Notes - revisit with more understanding of pm, ICR/IMR & counters
+ */
+static int sep_pm_runtime_resume(struct device *dev)
+{
+
+	u32 retval2;
+	u32 delay_count;
+	struct sep_device *sep = sep_dev;
+
+	dev_dbg(&sep->pdev->dev, "pm runtime resume called\n");
+
+	/**
+	 * Wait until the SCU boot is ready
+	 * This is done by iterating SCU_DELAY_ITERATION (10
+	 * microseconds each) up to SCU_DELAY_MAX (50) times.
+	 * This bit can be set in a random time that is less
+	 * than 500 microseconds after each power resume
+	 */
+	retval2 = 0;
+	delay_count = 0;
+	while ((!retval2) && (delay_count < SCU_DELAY_MAX)) {
+		retval2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
+		retval2 &= 0x00000008;
+		if (!retval2) {
+			udelay(SCU_DELAY_ITERATION);
+			delay_count += 1;
+		}
+	}
+
+	if (!retval2) {
+		dev_warn(&sep->pdev->dev, "scu boot bit not set at resume\n");
+		return -EINVAL;
+	}
+
+	/* Clear ICR register */
+	sep_write_reg(sep, HW_HOST_ICR_REG_ADDR, 0xFFFFFFFF);
+
+	/* Set the IMR register - open only GPR 2 */
+	sep_write_reg(sep, HW_HOST_IMR_REG_ADDR, (~(0x1 << 13)));
+
+	/* Read send/receive counters from SEP */
+	sep->reply_ct = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
+	sep->reply_ct &= 0x3FFFFFFF;
+	sep->send_ct = sep->reply_ct;
+
+	return 0;
+}
+
+/**
+ * sep_pm_runtime_suspend - runtime suspend routine
+ * @dev:	pointer to sep device
+ *
+ * Notes - revisit with more understanding of pm
+ */
+static int sep_pm_runtime_suspend(struct device *dev)
+{
+	struct sep_device *sep = sep_dev;
+
+	dev_dbg(&sep->pdev->dev, "pm runtime suspend called\n");
+
+	/* Clear ICR register */
+	sep_write_reg(sep, HW_HOST_ICR_REG_ADDR, 0xFFFFFFFF);
+	return 0;
+}
+
+/**
+ * sep_pm - power management for sep driver
+ * @sep_pm_runtime_resume:	resume- no communication with cpu & main memory
+ * @sep_pm_runtime_suspend:	suspend- no communication with cpu & main memory
+ * @sep_pci_suspend:		suspend - main memory is still ON
+ * @sep_pci_resume:		resume - main meory is still ON
+ */
+static const struct dev_pm_ops sep_pm = {
+	.runtime_resume = sep_pm_runtime_resume,
+	.runtime_suspend = sep_pm_runtime_suspend,
+	.resume = sep_pci_resume,
+	.suspend = sep_pci_suspend,
+};
+#endif /* SEP_ENABLE_RUNTIME_PM */
+
+/**
+ * sep_pci_driver - registers this device with pci subsystem
+ * @name:	name identifier for this driver
+ * @sep_pci_id_tbl:	pointer to struct pci_device_id table
+ * @sep_probe:	pointer to probe function in PCI driver
+ * @sep_remove:	pointer to remove function in PCI driver
+ */
+static struct pci_driver sep_pci_driver = {
+#ifdef SEP_ENABLE_RUNTIME_PM
+	.driver = {
+		.pm = &sep_pm,
+	},
+#endif
+	.name = "sep_sec_driver",
+	.id_table = sep_pci_id_tbl,
+	.probe = sep_probe,
+	.remove = sep_remove
+};
+
+/**
+ * sep_init - init function
+ *
+ * Module load time. Register the PCI device driver.
+ */
+
+static int __init sep_init(void)
+{
+	return pci_register_driver(&sep_pci_driver);
+}
+
+
+/**
+ * sep_exit - called to unload driver
+ *
+ * Unregister the driver The device will perform all the cleanup required.
+ */
+static void __exit sep_exit(void)
+{
+	pci_unregister_driver(&sep_pci_driver);
+}
+
+
+module_init(sep_init);
+module_exit(sep_exit);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/sep/sep_trace_events.h b/drivers/staging/sep/sep_trace_events.h
new file mode 100644
index 0000000..2b053a9
--- /dev/null
+++ b/drivers/staging/sep/sep_trace_events.h
@@ -0,0 +1,188 @@
+/*
+ * If TRACE_SYSTEM is defined, that will be the directory created
+ * in the ftrace directory under /sys/kernel/debug/tracing/events/<system>
+ *
+ * The define_trace.h below will also look for a file name of
+ * TRACE_SYSTEM.h where TRACE_SYSTEM is what is defined here.
+ * In this case, it would look for sample.h
+ *
+ * If the header name will be different than the system name
+ * (as in this case), then you can override the header name that
+ * define_trace.h will look up by defining TRACE_INCLUDE_FILE
+ *
+ * This file is called trace-events-sample.h but we want the system
+ * to be called "sample". Therefore we must define the name of this
+ * file:
+ *
+ * #define TRACE_INCLUDE_FILE trace-events-sample
+ *
+ * As we do an the bottom of this file.
+ *
+ * Notice that TRACE_SYSTEM should be defined outside of #if
+ * protection, just like TRACE_INCLUDE_FILE.
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM sep
+
+/*
+ * Notice that this file is not protected like a normal header.
+ * We also must allow for rereading of this file. The
+ *
+ *  || defined(TRACE_HEADER_MULTI_READ)
+ *
+ * serves this purpose.
+ */
+#if !defined(_TRACE_SEP_EVENTS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_SEP_EVENTS_H
+
+#ifdef SEP_PERF_DEBUG
+#define SEP_TRACE_FUNC_IN() trace_sep_func_start(__func__, 0)
+#define SEP_TRACE_FUNC_OUT(branch) trace_sep_func_end(__func__, branch)
+#define SEP_TRACE_EVENT(branch) trace_sep_misc_event(__func__, branch)
+#else
+#define SEP_TRACE_FUNC_IN()
+#define SEP_TRACE_FUNC_OUT(branch)
+#define SEP_TRACE_EVENT(branch)
+#endif
+
+
+/*
+ * All trace headers should include tracepoint.h, until we finally
+ * make it into a standard header.
+ */
+#include <linux/tracepoint.h>
+
+/*
+ * The TRACE_EVENT macro is broken up into 5 parts.
+ *
+ * name: name of the trace point. This is also how to enable the tracepoint.
+ *   A function called trace_foo_bar() will be created.
+ *
+ * proto: the prototype of the function trace_foo_bar()
+ *   Here it is trace_foo_bar(char *foo, int bar).
+ *
+ * args:  must match the arguments in the prototype.
+ *    Here it is simply "foo, bar".
+ *
+ * struct:  This defines the way the data will be stored in the ring buffer.
+ *    There are currently two types of elements. __field and __array.
+ *    a __field is broken up into (type, name). Where type can be any
+ *    type but an array.
+ *    For an array. there are three fields. (type, name, size). The
+ *    type of elements in the array, the name of the field and the size
+ *    of the array.
+ *
+ *    __array( char, foo, 10) is the same as saying   char foo[10].
+ *
+ * fast_assign: This is a C like function that is used to store the items
+ *    into the ring buffer.
+ *
+ * printk: This is a way to print out the data in pretty print. This is
+ *    useful if the system crashes and you are logging via a serial line,
+ *    the data can be printed to the console using this "printk" method.
+ *
+ * Note, that for both the assign and the printk, __entry is the handler
+ * to the data structure in the ring buffer, and is defined by the
+ * TP_STRUCT__entry.
+ */
+TRACE_EVENT(sep_func_start,
+
+	TP_PROTO(const char *name, int branch),
+
+	TP_ARGS(name, branch),
+
+	TP_STRUCT__entry(
+		__array(char,	name,    20)
+		__field(int,	branch)
+	),
+
+	TP_fast_assign(
+		strncpy(__entry->name, name, 20);
+		__entry->branch	= branch;
+	),
+
+	TP_printk("func_start %s %d", __entry->name, __entry->branch)
+);
+
+TRACE_EVENT(sep_func_end,
+
+	TP_PROTO(const char *name, int branch),
+
+	TP_ARGS(name, branch),
+
+	TP_STRUCT__entry(
+		__array(char,	name,    20)
+		__field(int,	branch)
+	),
+
+	TP_fast_assign(
+		strncpy(__entry->name, name, 20);
+		__entry->branch	= branch;
+	),
+
+	TP_printk("func_end %s %d", __entry->name, __entry->branch)
+);
+
+TRACE_EVENT(sep_misc_event,
+
+	TP_PROTO(const char *name, int branch),
+
+	TP_ARGS(name, branch),
+
+	TP_STRUCT__entry(
+		__array(char,	name,    20)
+		__field(int,	branch)
+	),
+
+	TP_fast_assign(
+		strncpy(__entry->name, name, 20);
+		__entry->branch	= branch;
+	),
+
+	TP_printk("misc_event %s %d", __entry->name, __entry->branch)
+);
+
+
+#endif
+
+/***** NOTICE! The #if protection ends here. *****/
+
+
+/*
+ * There are several ways I could have done this. If I left out the
+ * TRACE_INCLUDE_PATH, then it would default to the kernel source
+ * include/trace/events directory.
+ *
+ * I could specify a path from the define_trace.h file back to this
+ * file.
+ *
+ * #define TRACE_INCLUDE_PATH ../../samples/trace_events
+ *
+ * But the safest and easiest way to simply make it use the directory
+ * that the file is in is to add in the Makefile:
+ *
+ * CFLAGS_trace-events-sample.o := -I$(src)
+ *
+ * This will make sure the current path is part of the include
+ * structure for our file so that define_trace.h can find it.
+ *
+ * I could have made only the top level directory the include:
+ *
+ * CFLAGS_trace-events-sample.o := -I$(PWD)
+ *
+ * And then let the path to this directory be the TRACE_INCLUDE_PATH:
+ *
+ * #define TRACE_INCLUDE_PATH samples/trace_events
+ *
+ * But then if something defines "samples" or "trace_events" as a macro
+ * then we could risk that being converted too, and give us an unexpected
+ * result.
+ */
+#undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_PATH .
+/*
+ * TRACE_INCLUDE_FILE is not needed if the filename and TRACE_SYSTEM are equal
+ */
+#define TRACE_INCLUDE_FILE sep_trace_events
+#include <trace/define_trace.h>

