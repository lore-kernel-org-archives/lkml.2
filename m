Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab2KHND6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:03:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:60814 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755597Ab2KHNDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:03:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,737,1344236400"; 
   d="scan'208";a="244102038"
From: dragos.tatulea@intel.com
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: kirill.shutemov@linux.intel.com, irina.tirdea@intel.com,
        octavian.purdila@intel.com, tony.luck@intel.com, keescook@chromium.org,
        dragos.tatulea@gmail.com, Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 04/26] blkoops: add a block device oops / panic logger
Date: Thu,  8 Nov 2012 15:06:02 +0200
Message-Id: <1352379984-18381-5-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
References: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

blkoops is a pstore back end to write panic / oops logs to a block
device. It is initially intended for use with eMMC as an alternative to
using a crash kernel.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 Documentation/blockdev/00-INDEX    |    2 +
 Documentation/blockdev/blkoops.txt |  104 +++
 drivers/block/Kconfig              |   10 +
 drivers/block/Makefile             |    1 +
 drivers/block/blkoops.c            | 1569 ++++++++++++++++++++++++++++++++++++
 5 files changed, 1686 insertions(+)
 create mode 100644 Documentation/blockdev/blkoops.txt
 create mode 100644 drivers/block/blkoops.c

diff --git a/Documentation/blockdev/00-INDEX b/Documentation/blockdev/00-INDEX
index c08df56..c45cef8 100644
--- a/Documentation/blockdev/00-INDEX
+++ b/Documentation/blockdev/00-INDEX
@@ -2,6 +2,8 @@
 	- this file
 README.DAC960
 	- info on Mylex DAC960/DAC1100 PCI RAID Controller Driver for Linux.
+blkoops.txt
+	- info on block device oops / panic logger
 cciss.txt
 	- info, major/minor #'s for Compaq's SMART Array Controllers.
 cpqarray.txt
diff --git a/Documentation/blockdev/blkoops.txt b/Documentation/blockdev/blkoops.txt
new file mode 100644
index 0000000..fb08664
--- /dev/null
+++ b/Documentation/blockdev/blkoops.txt
@@ -0,0 +1,104 @@
+Block device oops / panic logger
+--------------------------------
+
+Contents:
+
+	1) Overview
+	2) Format
+	3) Parameters
+	4) blkoops and pstore
+	5) debugfs
+
+1) Overview
+-----------
+
+	blkoops is a pstore back end to write panic / oops logs to a block
+	device.	It is initially intended for use with eMMC as an alternative to
+	using a crash kernel.
+
+2) Format
+---------
+
+	Data is written in chunks called nodes which are preceded by a
+	header. The header is always aligned to a block boundary. Nodes are
+	written sequentially starting at the second block. The first block
+	contains a special node that fulfils 2 purposes: 1) the blkoops magic
+	number must be present or blkoops will not attach to the block device,
+	and 2) erase information is recorded there. Nodes can be arbitrarily
+	long.
+
+	Nodes are identified by session number, file number and part number.
+	A session may have up to 2^32 - 1 files each with up to 2^32 - 1  parts.
+
+	A new session begins when blkoops attaches to a block device and ends
+	when it detaches or there is a reboot. A new session overwrites the
+	previous session. Once the media is full no more nodes are written.
+
+3) Parameters
+-------------
+
+devname
+
+	Canonical block device name or number
+
+	devname may be set on the kernel command line e.g.
+
+		blkoops.devname=/dev/mmcblk0p7
+
+	or by writing to sysfs e.g.
+
+		echo /dev/mmcblk0p1 > /sys/module/blkoops/parameters/devname
+
+	devname is NOT the name of a file system object. e.g. /dev/mmcblk0p7
+	does NOT mean the block device special file mmcblk0p7 in the /dev
+	directory. Instead it means partition 7 of the device named mmcblk0.
+	For more information see name_to_dev_t comment in init/do_mounts.c
+
+	When devname is changed, the old devname (if any) is detached from
+	blkoops and the new devname (if any) is attached.
+
+	blkoops will reject a block device that does not have the blkoops magic
+	number written on the 1st sector. For example, to prepare
+	/dev/mmcblk0p7 for blkoops:
+
+		sudo bash -c "echo -e -n '\0034\0327\0130\0350' \
+		| dd count=1 conv=sync \
+		> /dev/mmcblk0p7"
+
+dump_oops
+
+	set to 1 to dump oopses, 0 to dump only panics (default 1)
+
+4) blkoops and pstore
+---------------------
+
+	pstore creates file names from pstore type code, back end name and
+	pstore 64-bit id. blkoops records the pstore type code, uses back end
+	name "blkoops", and creates the pstore 64-bit id from session number and
+	file number (session << 32 | file).  blkoops concatenates all parts
+	together and presents them as one file.
+
+	pstore noramally reads back end data entirely into memory when mounting.
+	However if a blkoops file is too big it will be read from media as
+	needed instead.
+
+	blkoops suppreses pstore heading lines from dumped data.
+
+	blkoops increases pstore default kmsg_bytes to ULONG_MAX.
+
+5) debugfs
+----------
+
+blkoops/type
+
+	pstore type code to use when dumping data via blkoops/data
+
+blkoops/reason
+
+	kmsg dump reason code to use when dumping data via blkoops/data
+
+blkoops/data
+
+	Data written to blkoops/data is dumped to the block device
+	using blkoops/type. blkoops/reason must be the numberical value of
+	KMSG_DUMP_PANIC or (if dump_oops is 1) KMSG_DUMP_OOPS.
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 824e09c..af5b325 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -544,4 +544,14 @@ config BLK_DEV_RBD
 
 	  If unsure, say N.
 
+config BLK_DEV_OOPS
+	bool "Block Oops / Panic Logger"
+	select BLK_DEV_PANIC_WRITE
+	select PSTORE
+	default n
+	help
+	  This enables panic and oops messages to be logged to a block device.
+
+	  See <file:Documentation/blockdev/blkoops.txt> for more information.
+
 endif # BLK_DEV
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 17e82df..db44850 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_MG_DISK)		+= mg_disk.o
 obj-$(CONFIG_SUNVDC)		+= sunvdc.o
 obj-$(CONFIG_BLK_DEV_NVME)	+= nvme.o
 obj-$(CONFIG_BLK_DEV_OSD)	+= osdblk.o
+obj-$(CONFIG_BLK_DEV_OOPS)	+= blkoops.o
 
 obj-$(CONFIG_BLK_DEV_UMEM)	+= umem.o
 obj-$(CONFIG_BLK_DEV_NBD)	+= nbd.o
diff --git a/drivers/block/blkoops.c b/drivers/block/blkoops.c
new file mode 100644
index 0000000..bafe17e
--- /dev/null
+++ b/drivers/block/blkoops.c
@@ -0,0 +1,1569 @@
+/*
+ * Block Oops / Panic Logger
+ *
+ * Copyright (C) 2012 Intel Corporation
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/module.h>
+#include <linux/swap.h>		/* For nr_free_buffer_pages() */
+#include <linux/debugfs.h>
+#include <linux/completion.h>
+#include <linux/blkdev.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/pstore.h>
+
+#undef DEBUG
+
+#ifdef DEBUG
+#define DBG_PRINTK printk
+#else
+#define DBG_PRINTK no_printk
+#endif
+
+#define DBG(fmt, ...) \
+	DBG_PRINTK(KERN_DEBUG "%s: " fmt "\n", __func__, ##__VA_ARGS__)
+
+#define BLKOOPS_BUFSIZE (32 * 1024)
+
+#define BLKOOPS_MAGIC 0xe858d71c
+
+#define BLKOOPS_VERSION 1
+
+#define BLKOOPS_HDR_SZ (sizeof(struct blkoops_header))
+
+#define BLKOOPS_MODE (FMODE_READ | FMODE_WRITE | FMODE_EXCL)
+
+#define BLKOOPS_DEVNAME_SZ 256
+
+static char devname[BLKOOPS_DEVNAME_SZ];
+static int dump_oops;
+static int init_done;
+
+static DEFINE_MUTEX(blkoops_mutex);
+static DEFINE_SPINLOCK(blkoops_lock);
+
+/**
+ * struct blkoops - blkoops private data.
+ * @psi: pstore information
+ * @present: non-zero if blkoops is attached to a block device
+ * @bdev: block device to which that blkoops is attached
+ * @devid: block device (major, minor) number
+ * @blksize: block device block size
+ * @sects_per_blk: block device sectors per block
+ * @nr_sects: block device size in sectors
+ * @size: block device size in bytes
+ * @bdev_name: block device name
+ * @buf: panic write buffer
+ * @bufsize: panic write buffer size
+ * @last_session: last session number on media
+ * @next_session: next session number to write
+ * @next_file: next file number to write
+ * @next_sect: next sector to write
+ * @cache_invalid: page cache is invalid because
+ * @root: rb-tree of all blkoops nodes sorted by session / file / part numbers
+ * @file_cnt: number of (non-erased) files on media
+ * @max_file: maximum file number on media
+ * @used_sects: number of sectors used on media by the last session
+ * @erased_session: session number of a completely or partly erased session
+ * @erased_file: maximum erased file number of @erased_session
+ * @erased_sects: number of sectors used on media by @erased_session
+ * @read_anew: start reading from the first file
+ * @read_file: last file number read
+ * @dbg_root: blkoops debugfs root directory
+ * @dbg_type: pstore type code to use when writing
+ * @dbg_reason: kmsg dump reason code to use when writing
+ * @dbg_part: next part number to use when writing
+ * @dbg_lock: with @dbg_open, prevent debugfs 'data' file from having more than
+	       1 user, and also cause the call to 'blkoops_write()' to be in an
+	       atomic context
+ * @dbg_open: non-zero if debugfs 'data' file is open
+ * @dbg_buf: debug write buffer
+ * @dbg_bufsize: debug write buffer size
+ * @dbg_used: number of bytes used in @dbg_buf
+ */
+struct blkoops {
+	struct pstore_info	psi;
+
+	int			present;
+
+	struct block_device	*bdev;
+	dev_t			devid;
+	unsigned int		blksize;
+	unsigned int		sects_per_blk;
+	sector_t		nr_sects;
+	loff_t			size;
+	char			bdev_name[BDEVNAME_SIZE];
+
+	char			*buf;
+	size_t			bufsize;
+
+	unsigned int		last_session;
+
+	unsigned int		next_session;
+	unsigned int		next_file;
+	sector_t		next_sect;
+
+	int			flush_needed;
+	int			cache_invalid;
+
+	struct rb_root		root;
+	unsigned int		file_cnt;
+	unsigned int		max_file;
+	sector_t		used_sects;
+
+	unsigned int		erased_session;
+	unsigned int		erased_file;
+	sector_t		erased_sects;
+
+	int			read_anew;
+	unsigned int		read_file;
+
+#ifdef CONFIG_DEBUG_FS
+	struct dentry		*dbg_root;
+	u32			dbg_type;
+	u32			dbg_reason;
+	u32			dbg_part;
+	spinlock_t		dbg_lock; /* debug serialization */
+	int			dbg_open;
+	void			*dbg_buf;
+	size_t			dbg_bufsize;
+	size_t			dbg_used;
+#endif
+};
+
+/**
+ * struct blkoops_node - blkoops node.
+ * @node: rb-tree of all blkoops nodes
+ * @session: session number
+ * @file: file number
+ * @part: part number
+ * @len: length in bytes (excluding header)
+ * @nr_sects: length in sectors including header
+ * @type: pstore type code
+ * @timestamp: time the node was written to media
+ * @offs: offset on block device
+ * @file_offs: offset within file
+ * @tot_len: total length of file (only recorded on the first part)
+ */
+struct blkoops_node {
+	struct rb_node		node;
+	unsigned int		session;
+	unsigned int		file;
+	unsigned int		part;
+	loff_t			len;
+	sector_t		nr_sects;
+	enum pstore_type_id	type;
+	struct timespec		timestamp;
+	loff_t			offs;
+	loff_t			file_offs;
+	loff_t			tot_len;
+};
+
+/**
+ * struct blkoops_header - blkoops on-media node header.
+ * @magic: blkoops magic number
+ * @version: blkoops media format version
+ * @session: session number
+ * @file: file number
+ * @part: part number
+ * @type: pstore type code
+ * @timestamp:  time the node was written to media
+ * @len: length in bytes (excluding header)
+ * @nr_sects: length in sectors including header
+ * @padding: reserved for future, zeroes
+ *
+ * Data is written in chunks called nodes which are preceded by this header.
+ * The header is always aligned to a block boundary. Nodes are written
+ * sequentially starting at the second block. The first block contains a
+ * special node that fulfils 2 purposes: 1) the blkoops magic number must be
+ * present or blkoops will not attach to the block device, and 2) erase
+ * information is recorded there. Nodes can be arbitrarily long.
+ *
+ * Nodes are identified by session number, file number and part number.	A
+ * session may have up to 2^32 - 1 files each with up to 2^32 - 1  parts.
+ *
+ * A new session begins when blkoops attaches to a block device and ends when it
+ * detaches or there is a reboot. A new session overwrites the previous session.
+ * Once the media is full no more nodes are written.
+ */
+struct blkoops_header {
+	__le32 magic;
+	__le32 version;
+	__le32 session;
+	__le32 file;
+	__le32 part;
+	__le32 type;
+	__le64 timestamp;
+	__le64 len;
+	__le64 nr_sects;
+	__u8 padding[16];
+} __packed;
+
+static int blkoops_lt(struct blkoops_node *bn1, struct blkoops_node *bn2)
+{
+	if (bn1->session == bn2->session) {
+		if (bn1->file == bn2->file)
+			return bn1->part < bn2->part;
+		return bn1->file < bn2->file;
+	}
+
+	return bn1->session < bn2->session;
+}
+
+static void blkoops_add_node(struct blkoops *c, struct blkoops_node *bn)
+{
+	struct rb_node **p = &c->root.rb_node;
+	struct rb_node *parent = NULL;
+	struct blkoops_node *t;
+
+	while (*p) {
+		parent = *p;
+		t = rb_entry(parent, struct blkoops_node, node);
+
+		if (blkoops_lt(bn, t))
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&bn->node, parent, p);
+	rb_insert_color(&bn->node, &c->root);
+}
+
+static int blkoops_lt_file(unsigned int session, unsigned int file,
+			   struct blkoops_node *bn)
+{
+	if (session == bn->session)
+		return file < bn->file;
+	return session < bn->session;
+}
+
+static struct blkoops_node *blkoops_lookup_next(struct blkoops *c,
+						unsigned int session,
+						unsigned int file)
+{
+	struct rb_node *node = c->root.rb_node;
+	struct blkoops_node *bn, *next = NULL;
+
+	while (node) {
+		bn = rb_entry(node, struct blkoops_node, node);
+
+		if (blkoops_lt_file(session, file, bn)) {
+			node = node->rb_left;
+			next = bn;
+		} else {
+			node = node->rb_right;
+		}
+	}
+	return next;
+}
+
+static int blkoops_cmp_offs(unsigned int session, unsigned int file, loff_t pos,
+			   struct blkoops_node *bn)
+{
+	if (session == bn->session) {
+		if (file == bn->file) {
+			if (pos < bn->file_offs)
+				return -1;
+			else if (pos >= bn->file_offs + bn->len)
+				return 1;
+			return 0;
+		}
+		return file < bn->file ? -1 : 1;
+	}
+	return session < bn->session ? -1 : 1;
+}
+
+static struct blkoops_node *blkoops_lookup_pos(struct blkoops *c,
+					       unsigned int session,
+					       unsigned int file, loff_t pos)
+{
+	struct rb_node *node = c->root.rb_node;
+	struct blkoops_node *bn;
+	int cmp;
+
+	while (node) {
+		bn = rb_entry(node, struct blkoops_node, node);
+		cmp = blkoops_cmp_offs(session, file, pos, bn);
+		if (cmp == -1)
+			node = node->rb_left;
+		else if (cmp == 1)
+			node = node->rb_right;
+		else
+			return bn;
+	}
+	return NULL;
+}
+
+static struct page *blkoops_read_page(struct blkoops *c, loff_t pos)
+{
+	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
+
+	return read_mapping_page(c->bdev->bd_inode->i_mapping, index, NULL);
+}
+
+static int blkoops_validate_node(struct blkoops *c, struct blkoops_node *bn)
+{
+	sector_t nr_sects;
+	loff_t len;
+
+	if (bn->offs + bn->len > c->size) {
+		DBG("bad node size (offs %lld + len %lld > size %lld)",
+		    bn->offs, bn->len, c->size);
+		return -EINVAL;
+	}
+	len = bn->len + BLKOOPS_HDR_SZ;
+	nr_sects = (len >> 9) + (len & 511 ? 1 : 0);
+	if (bn->nr_sects < nr_sects) {
+		DBG("bad node nr sects %llu vs len %lld",
+		    (u64)bn->nr_sects, bn->len);
+		return -EINVAL;
+	}
+	if (bn->offs - BLKOOPS_HDR_SZ + ((loff_t)bn->nr_sects << 9) > c->size) {
+		DBG("bad node nr sects %llu vs size %lld",
+		    (u64)bn->nr_sects, c->size);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static struct blkoops_node *blkoops_alloc_node(struct blkoops *c,
+					       struct blkoops_header *hdr,
+					       loff_t pos)
+{
+	struct blkoops_node *bn;
+
+	if (__le32_to_cpu(hdr->magic) != BLKOOPS_MAGIC) {
+		DBG("bad magic at pos %lld", pos);
+		return ERR_PTR(-EINVAL);
+	}
+
+	bn = kzalloc(sizeof(struct blkoops_node), GFP_KERNEL);
+	if (!bn)
+		return ERR_PTR(-ENOMEM);
+
+	RB_CLEAR_NODE(&bn->node);
+
+	bn->session		= __le32_to_cpu(hdr->session);
+	bn->file		= __le32_to_cpu(hdr->file);
+	bn->part		= __le32_to_cpu(hdr->part);
+	bn->type		= __le32_to_cpu(hdr->type);
+	bn->timestamp.tv_sec	= __le64_to_cpu(hdr->timestamp);
+	bn->len			= __le64_to_cpu(hdr->len);
+	bn->nr_sects		= __le64_to_cpu(hdr->nr_sects);
+	bn->offs		= pos + BLKOOPS_HDR_SZ;
+
+	return bn;
+}
+
+static struct blkoops_node *blkoops_read_node(struct blkoops *c, loff_t pos)
+{
+	struct blkoops_header *hdr;
+	struct blkoops_node *bn;
+	struct page *page;
+
+	if (pos >= c->size || pos & 511) {
+		DBG("bad pos %lld", pos);
+		return ERR_PTR(-EINVAL);
+	}
+
+	page = blkoops_read_page(c, pos);
+	if (IS_ERR(page)) {
+		pr_err("blkoops: bad page at pos %lld", pos);
+		return ERR_CAST(page);
+	}
+	/*
+	 * Whole header must be within page because the header is sector aligned
+	 * and smaller than 1 sector.
+	 */
+	hdr = page_address(page) + (pos & (PAGE_CACHE_SIZE - 1));
+
+	bn = blkoops_alloc_node(c, hdr, pos);
+
+	page_cache_release(page);
+	return bn;
+}
+
+static inline loff_t blkoops_scan_start(struct blkoops *c)
+{
+	return c->blksize;
+}
+
+static loff_t blkoops_do_scan(struct blkoops *c, loff_t pos)
+{
+	struct blkoops_node *bn;
+	int err;
+
+	c->used_sects = pos >> 9;
+
+	if (pos >= c->size) {
+		DBG("end of scan at pos %lld (size %lld)", pos, c->size);
+		return 0;
+	}
+
+	bn = blkoops_read_node(c, pos);
+	if (IS_ERR(bn))
+		return PTR_ERR(bn);
+
+	err = blkoops_validate_node(c, bn);
+	if (err) {
+		DBG("bad node at pos %lld", pos);
+		goto out_free;
+	}
+
+	DBG("node at %lld sess %u file %u part %u len %lld nr sects %llu",
+	    pos, bn->session, bn->file, bn->part, bn->len, (u64)bn->nr_sects);
+
+	/* A new oops may have written an updated session number */
+	if (pos == blkoops_scan_start(c))
+		c->last_session = bn->session;
+
+	/* Only scan the last session */
+	if (bn->session != c->last_session) {
+		DBG("wrong session %u (expected %u) at pos %lld",
+		    bn->session, c->last_session, pos);
+		err = 0;
+		goto out_free;
+	}
+
+	/* Skip erased files */
+	if (c->erased_file && bn->session == c->erased_session &&
+	    bn->file <= c->erased_file) {
+		loff_t next_pos, new_pos;
+
+		/*
+		 * Try to skip to next non-erased node, but only if it makes
+		 * sense.
+		 */
+		next_pos = pos + ((loff_t)bn->nr_sects << 9);
+		new_pos = (loff_t)c->erased_sects << 9;
+		if (new_pos < next_pos || new_pos > c->size)
+			new_pos = next_pos;
+		DBG("skipping erased node at pos %lld continuing from pos %lld",
+		    pos, new_pos);
+		pos = new_pos;
+	} else {
+		blkoops_add_node(c, bn);
+		pos += (loff_t)bn->nr_sects << 9;
+	}
+
+	return pos;
+
+out_free:
+	kfree(bn);
+	return err;
+}
+
+static void blkoops_free_tree(struct blkoops *c)
+{
+	struct rb_node *node, *next;
+	struct blkoops_node *bn;
+
+	node = rb_first(&c->root);
+	while (node) {
+		bn = rb_entry(node, struct blkoops_node, node);
+		next = rb_next(node);
+		rb_erase(node, &c->root);
+		kfree(bn);
+		node = next;
+	}
+
+	c->file_cnt = 0;
+}
+
+static void blkoops_count_files(struct blkoops *c)
+{
+	struct rb_node *node;
+	struct blkoops_node *bn, *last = NULL;
+
+	c->file_cnt = 0;
+	c->max_file = 0;
+
+	for (node = rb_first(&c->root); node; node = rb_next(node)) {
+		bn = rb_entry(node, struct blkoops_node, node);
+		if (last && bn->session == last->session &&
+		    bn->file == last->file) {
+			bn->file_offs = last->tot_len;
+			last->tot_len += bn->len;
+			continue;
+		}
+		last = bn;
+		last->file_offs = 0;
+		last->tot_len = bn->len;
+		c->file_cnt += 1;
+		if (bn->file > c->max_file)
+			c->max_file = bn->file;
+	}
+	DBG("file cnt %u max file %u used sects %llu",
+	    c->file_cnt, c->max_file, (u64)c->used_sects);
+}
+
+static int blkoops_scan(struct blkoops *c)
+{
+	loff_t pos = blkoops_scan_start(c);
+
+	blkoops_free_tree(c);
+
+	if (c->cache_invalid) {
+		DBG("cache_invalid");
+		c->cache_invalid = 0;
+		invalidate_mapping_pages(c->bdev->bd_inode->i_mapping, 0, -1);
+	}
+
+	do {
+		pos = blkoops_do_scan(c, pos);
+	} while (pos > 0);
+
+	blkoops_count_files(c);
+
+	return pos;
+}
+
+static int blkoops_open(struct pstore_info *psi)
+{
+	struct blkoops *c = psi->data;
+
+	mutex_lock(&blkoops_mutex);
+	if (!c->present)
+		goto out;
+	blkoops_scan(c);
+	c->read_anew = 1;
+out:
+	mutex_unlock(&blkoops_mutex);
+	return 0;
+}
+
+static struct blkoops_node *blkoops_next_node(struct blkoops_node *bn)
+{
+	struct rb_node *node;
+	struct blkoops_node *t;
+
+	node = rb_next(&bn->node);
+	if (!node)
+		return NULL;
+	t = rb_entry(node, struct blkoops_node, node);
+	if (t->session == bn->session && t->file == bn->file)
+		return t;
+	return NULL;
+}
+
+static int blkoops_read_to_buf(struct blkoops *c, char *buf, loff_t pos,
+			       loff_t len)
+{
+	struct page *page;
+	loff_t offs;
+	size_t n;
+	int err = 0;
+
+	while (len) {
+		page = blkoops_read_page(c, pos);
+
+		offs = pos & (PAGE_CACHE_SIZE - 1);
+		n = PAGE_CACHE_SIZE - offs;
+		if (n > len)
+			n = len;
+
+		if (IS_ERR(page)) {
+			if (!err)
+				err = PTR_ERR(page);
+			memset(buf, 0, n);
+		} else {
+			memcpy(buf, page_address(page) + offs, n);
+		}
+
+		pos += n;
+		buf += n;
+		len -= n;
+
+		page_cache_release(page);
+	}
+
+	return err;
+}
+
+static int blkoops_fill_buf(struct blkoops *c, char *buf,
+			    struct blkoops_node *bn)
+{
+	loff_t tot_len = bn->tot_len;
+	int err = 0, err1;
+
+	while (bn && tot_len) {
+		err1 = blkoops_read_to_buf(c, buf, bn->offs, bn->len);
+		if (!err)
+			err = err1;
+		tot_len -= bn->len;
+		buf += bn->len;
+		bn = blkoops_next_node(bn);
+	}
+	return err;
+}
+
+static struct blkoops_node *blkoops_read_next(struct blkoops *c)
+{
+	struct blkoops_node *bn = NULL;
+	struct rb_node *node;
+
+	if (c->read_anew) {
+		c->read_anew = 0;
+		node = rb_first(&c->root);
+		if (node)
+			bn = rb_entry(node, struct blkoops_node, node);
+	} else {
+		bn = blkoops_lookup_next(c, c->last_session, c->read_file);
+	}
+	if (bn)
+		c->read_file = bn->file;
+	return bn;
+}
+
+static ssize_t blkoops_read_to_userbuf(struct blkoops *c, char __user *userbuf,
+				       loff_t pos, size_t len)
+{
+	struct page *page;
+	ssize_t ret = 0;
+	loff_t offs;
+	size_t n, rn;
+	int err;
+
+	while (len) {
+		page = blkoops_read_page(c, pos);
+
+		offs = pos & (PAGE_CACHE_SIZE - 1);
+		n = PAGE_CACHE_SIZE - offs;
+		if (n > len)
+			n = len;
+
+		if (IS_ERR(page)) {
+			err = PTR_ERR(page);
+			goto out_err;
+		}
+
+		rn = copy_to_user(userbuf, page_address(page) + offs, n);
+		if (rn) {
+			page_cache_release(page);
+			ret += n - rn;
+			err = -EFAULT;
+			goto out_err;
+		}
+
+		pos += n;
+		userbuf += n;
+		len -= n;
+		ret += n;
+
+		page_cache_release(page);
+	}
+
+	return ret;
+
+out_err:
+	if (!ret)
+		ret = err;
+	return ret;
+}
+
+static inline unsigned int blkoops_session(u64 id)
+{
+	return id >> 32;
+}
+
+static inline unsigned int blkoops_file(u64 id)
+{
+	return id;
+}
+
+static ssize_t blkoops_file_read(u64 id, enum pstore_type_id type,
+				 char __user *userbuf, size_t count,
+				 loff_t *ppos, struct pstore_info *psi)
+{
+	struct blkoops *c = psi->data;
+	struct blkoops_node *bn;
+	unsigned int session, file;
+	ssize_t done, res = 0;
+	loff_t noffs, dpos;
+	size_t len;
+	int err;
+
+	if (*ppos < 0)
+		return -EINVAL;
+
+	session = blkoops_session(id);
+	file = blkoops_file(id);
+
+	mutex_lock(&blkoops_mutex);
+	if (!c->present) {
+		err = -ENODEV;
+		goto out_err;
+	}
+
+	DBG("sess %u file %u pos %lld count %zu", session, file, *ppos, count);
+
+	while (count) {
+		bn = blkoops_lookup_pos(c, session, file, *ppos);
+		if (!bn)
+			break;
+		noffs = *ppos - bn->file_offs;
+		len = min_t(loff_t, count, bn->len - noffs);
+		dpos = bn->offs + noffs;
+		done = blkoops_read_to_userbuf(c, userbuf, dpos, len);
+		if (done < 0) {
+			err = done;
+			goto out_err;
+		}
+		res += done;
+		if (done < len)
+			break;
+		*ppos += len;
+		userbuf += len;
+		count -= len;
+	}
+out:
+	DBG("sess %u file %u pos %lld res %zd", session, file, *ppos, res);
+	mutex_unlock(&blkoops_mutex);
+	return res;
+
+out_err:
+	if (!res)
+		res = err;
+	goto out;
+}
+
+static inline u64 blkoops_id(u32 session, u32 file)
+{
+	return (u64)session << 32 | file;
+}
+
+static int blkoops_read(u64 *id, enum pstore_type_id *type,
+			struct timespec *time, char **buf, loff_t *size,
+			struct pstore_info *psi)
+{
+	struct blkoops *c = psi->data;
+	struct blkoops_node *bn;
+	unsigned long limit;
+	u64 bn_id;
+	int err;
+
+	mutex_lock(&blkoops_mutex);
+	if (!c->present) {
+		err = -ENODEV;
+		goto out;
+	}
+
+	bn = blkoops_read_next(c);
+	if (!bn) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	bn_id = blkoops_id(bn->session, bn->file);
+
+	DBG("node at pos %lld sess %u file %u part %u len %lld nr sects %llu",
+	    bn->offs, bn->session, bn->file, bn->part, bn->len,
+	    (u64)bn->nr_sects);
+
+	*type = bn->type;
+	*id = bn_id;
+	*time = bn->timestamp;
+	*size = bn->tot_len;
+
+	limit = nr_free_buffer_pages() << (PAGE_SHIFT - 3);
+	limit /= c->file_cnt;
+
+	if (bn->tot_len > limit) {
+		DBG("file size %lld over limit %lu", bn->tot_len, limit);
+		err = -EFBIG;
+		goto out;
+	}
+
+	*buf = kmalloc(bn->tot_len, GFP_KERNEL | __GFP_NOWARN);
+	if (!*buf) {
+		DBG("failed to allocate %lld bytes", bn->tot_len);
+		err = -EFBIG;
+		goto out;
+	}
+
+	err = blkoops_fill_buf(c, *buf, bn);
+	if (err) {
+		pr_err("blkoops: read failed, file id %lld, error %d\n",
+		       bn_id, err);
+		err = 0;
+	}
+out:
+	mutex_unlock(&blkoops_mutex);
+	return err;
+}
+
+static int blkoops_write(enum pstore_type_id type, enum kmsg_dump_reason reason,
+			 u64 *id, unsigned int part, size_t size,
+			 struct pstore_info *psi)
+{
+	struct blkoops *c = psi->data;
+	struct blkoops_header *hdr;
+	size_t nr, sz, rsz, len;
+	u32 partno;
+	int err;
+
+	/* If blkoops_lock is locked then there is no back end, so give up */
+	if (!spin_trylock(&blkoops_lock))
+		return -ENODEV;
+
+	if (!c->present) {
+		err = -ENODEV;
+		goto out_unlock;
+	}
+
+	if (reason != KMSG_DUMP_OOPS &&
+	    reason != KMSG_DUMP_PANIC) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (reason == KMSG_DUMP_OOPS && !dump_oops) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (c->next_sect + c->sects_per_blk > c->nr_sects) {
+		err = -ENOSPC;
+		goto out_unlock;
+	}
+
+	if (part == 1)
+		c->next_file += 1;
+
+	/*
+	 * Special case: dmesg is written backwards so reverse the order of the
+	 * part numbers.
+	 */
+	if (type == PSTORE_TYPE_DMESG)
+		partno = -part;
+	else
+		partno = part;
+
+	*id = blkoops_id(c->next_session, c->next_file);
+
+	/* Round up the size to block size and pad with zeroes */
+	sz = size + BLKOOPS_HDR_SZ;
+	rsz = roundup(sz, c->blksize);
+	nr = rsz >> 9;
+	memset(c->psi.buf + size, 0, rsz - sz);
+
+	/*
+	 * Truncate the node to fit the remaining space.  Note, we have
+	 * already checked that there is enough space for at least 1 block.
+	 */
+	len = size;
+	while (c->next_sect + nr > c->nr_sects) {
+		nr -= c->sects_per_blk;
+		len = (nr << 9) - BLKOOPS_HDR_SZ;
+	}
+
+	hdr = (void *)c->buf;
+	memset(hdr, 0, BLKOOPS_HDR_SZ);
+	hdr->magic     = __cpu_to_le32(BLKOOPS_MAGIC);
+	hdr->version   = __cpu_to_le32(BLKOOPS_VERSION);
+	hdr->session   = __cpu_to_le32(c->next_session);
+	hdr->file      = __cpu_to_le32(c->next_file);
+	hdr->part      = __cpu_to_le32(partno);
+	hdr->type      = __cpu_to_le32(type);
+	hdr->timestamp = __cpu_to_le64(get_seconds());
+	hdr->len       = __cpu_to_le64(len);
+	hdr->nr_sects  = __cpu_to_le64(nr);
+
+	c->cache_invalid = 1;
+	c->flush_needed = 1;
+
+	err = blk_panic_write(c->bdev, c->next_sect, c->buf, nr << 9);
+	if (err)
+		goto out_unlock;
+
+	c->next_sect += nr;
+
+out_unlock:
+	spin_unlock(&blkoops_lock);
+	return err;
+}
+
+struct blkoops_bio_batch {
+	atomic_t		done;
+	unsigned long		flags;
+	struct completion	*wait;
+};
+
+static void blkoops_end_io(struct bio *bio, int err)
+{
+	struct blkoops_bio_batch *bb = bio->bi_private;
+
+	if (err)
+		clear_bit(BIO_UPTODATE, &bb->flags);
+	if (atomic_dec_and_test(&bb->done))
+		complete(bb->wait);
+	bio_put(bio);
+}
+
+static int blkoops_direct_io(int type, struct block_device *bdev, sector_t sect,
+			     unsigned long nr, void *buf)
+{
+	DECLARE_COMPLETION_ONSTACK(wait);
+	struct blkoops_bio_batch bb;
+	struct bio *bio;
+	int ret = 0;
+	unsigned long len = nr << 9;
+
+	DBG("type %#x sect %llu nr %lu", type, (u64)sect, nr);
+
+	atomic_set(&bb.done, 1);
+	bb.flags = 1 << BIO_UPTODATE;
+	bb.wait = &wait;
+
+	while (len) {
+		bio = bio_alloc(GFP_KERNEL, 1);
+		if (!bio) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		bio->bi_sector = sect;
+		bio->bi_end_io = blkoops_end_io;
+		bio->bi_bdev = bdev;
+		bio->bi_private = &bb;
+
+		while (len) {
+			unsigned int offs = offset_in_page(buf);
+			unsigned int n = PAGE_SIZE - offs;
+			int bytes;
+
+			if (n > len)
+				n = len;
+			bytes = bio_add_page(bio, virt_to_page(buf), n, offs);
+			if (bytes <= 0)
+				break;
+			len -= bytes;
+			buf += bytes;
+		}
+		sect += bio->bi_size >> 9;
+
+		atomic_inc(&bb.done);
+		submit_bio(type, bio);
+	}
+
+	if (!atomic_dec_and_test(&bb.done))
+		wait_for_completion(&wait);
+
+	if (!test_bit(BIO_UPTODATE, &bb.flags))
+		ret = -EIO;
+
+	if (ret)
+		DBG("I/O error %d", ret);
+	return ret;
+}
+
+static void blkoops_invalidate_range(struct block_device *bdev, sector_t sect,
+				     unsigned int nr)
+{
+	pgoff_t start, end;
+
+	start = sect >> (PAGE_CACHE_SHIFT - 9);
+	end = (sect + nr - 1) >> (PAGE_CACHE_SHIFT - 9);
+
+	invalidate_mapping_pages(bdev->bd_inode->i_mapping, start, end);
+}
+
+static int blkoops_write_meta(struct block_device *bdev, sector_t sect,
+			      unsigned long nr, void *buf)
+{
+	blkoops_invalidate_range(bdev, sect, nr);
+
+	return blkoops_direct_io(REQ_WRITE | REQ_META, bdev, sect, nr, buf);
+}
+
+static int blkoops_mark_erased(struct blkoops *c)
+{
+	struct blkoops_header *hdr;
+	int err;
+
+	DBG("session %u file %u sects %llu",
+	    c->erased_session, c->erased_file, (u64)c->erased_sects);
+
+	hdr = kzalloc(c->blksize, GFP_KERNEL);
+	if (!hdr)
+		return -ENOMEM;
+
+	hdr->magic     = __cpu_to_le32(BLKOOPS_MAGIC);
+	hdr->version   = __cpu_to_le32(BLKOOPS_VERSION);
+	hdr->session   = __cpu_to_le32(c->erased_session);
+	hdr->file      = __cpu_to_le32(c->erased_file);
+	hdr->timestamp = __cpu_to_le64(get_seconds());
+	hdr->nr_sects  = __cpu_to_le64(c->erased_sects);
+
+	err = blkoops_write_meta(c->bdev, 0, c->sects_per_blk, hdr);
+
+	kfree(hdr);
+
+	return err;
+}
+
+static int blkoops_erase(enum pstore_type_id type, u64 id,
+			 struct pstore_info *psi)
+{
+	struct blkoops *c = psi->data;
+	int err = 0;
+
+	mutex_lock(&blkoops_mutex);
+	if (!c->present) {
+		err = -ENODEV;
+		goto out;
+	}
+	DBG("type %d id %lld", type, id);
+	/*
+	 * Do nothing until all files are erased and then mark the range as
+	 * erased.
+	 */
+	if (c->file_cnt && !--c->file_cnt && !c->cache_invalid) {
+		c->erased_session = c->last_session;
+		c->erased_file = c->max_file;
+		c->erased_sects = c->used_sects;
+		err = blkoops_mark_erased(c);
+	}
+out:
+	mutex_unlock(&blkoops_mutex);
+	return err;
+}
+
+static int blkoops_flush(struct pstore_info *psi)
+{
+	struct blkoops *c = psi->data;
+	int err;
+
+	/* If blkoops_lock is locked then there is no back end, so give up */
+	if (!spin_trylock(&blkoops_lock))
+		return -ENODEV;
+
+	if (!c->present) {
+		err = -ENODEV;
+		goto out_unlock;
+	}
+
+	if (!c->flush_needed) {
+		err = 0;
+		goto out_unlock;
+	}
+
+	err = blk_panic_flush(c->bdev);
+
+out_unlock:
+	spin_unlock(&blkoops_lock);
+	return err;
+}
+
+#ifdef CONFIG_DEBUG_FS
+
+static int blkoops_dbg_write_buf(struct blkoops *c, void *buf, size_t len)
+{
+	unsigned long flags;
+	size_t n;
+	int ret;
+	u64 id;
+
+	while (len) {
+		n = min(len, c->psi.bufsize);
+		memcpy(c->psi.buf, buf, n);
+		spin_lock_irqsave(&c->dbg_lock, flags);
+		ret = blkoops_write(c->dbg_type, c->dbg_reason, &id,
+				    c->dbg_part++, n, &c->psi);
+		spin_unlock_irqrestore(&c->dbg_lock, flags);
+		if (ret) {
+			pr_err("blkoops: debug write failed, error %d\n", ret);
+			return ret;
+		}
+		buf += n;
+		len -= n;
+	}
+	return 0;
+}
+
+static int blkoops_dbg_flush_buf(struct blkoops *c)
+{
+	int err;
+
+	err = blkoops_dbg_write_buf(c, c->dbg_buf, c->dbg_used);
+	c->dbg_used = 0;
+	return err;
+}
+
+static int blkoops_dbg_drain_buf(struct blkoops *c)
+{
+	size_t written = 0;
+	int err = 0;
+
+	while (c->dbg_used >= c->psi.bufsize) {
+		err = blkoops_dbg_write_buf(c, c->dbg_buf + written,
+					    c->psi.bufsize);
+		c->dbg_used -= c->psi.bufsize;
+		written += c->psi.bufsize;
+	}
+	memmove(c->dbg_buf, c->dbg_buf + written, c->dbg_used);
+	return err;
+}
+
+static ssize_t blkoops_dbg_fill_buf(struct blkoops *c, const char __user *buf,
+				    size_t len)
+{
+	size_t remains = c->dbg_bufsize - c->dbg_used, n = min(len, remains);
+	void *addr = c->dbg_buf + c->dbg_used;
+
+	if (copy_from_user(addr, buf, n))
+		return -EFAULT;
+	c->dbg_used += n;
+	return n;
+}
+
+static ssize_t blkoops_dbg_write(struct file *file, const char __user *buf,
+				 size_t len, loff_t *ppos)
+{
+	struct blkoops *c = file->private_data;
+	ssize_t n, res = len;
+
+	while (len) {
+		n = blkoops_dbg_fill_buf(c, buf, len);
+		if (n < 0)
+			return n;
+		buf += n;
+		len -= n;
+		if (c->dbg_used == c->dbg_bufsize)
+			blkoops_dbg_drain_buf(c);
+	}
+	return res;
+}
+
+static int blkoops_dbg_file_open(struct inode *inode, struct file *file)
+{
+	struct blkoops *c = inode->i_private;
+	unsigned long flags;
+	int err = 0;
+
+	spin_lock_irqsave(&c->dbg_lock, flags);
+	if (c->dbg_open)
+		err = -EBUSY;
+	else
+		c->dbg_open = 1;
+	spin_unlock_irqrestore(&c->dbg_lock, flags);
+	if (err)
+		return err;
+
+	c->dbg_bufsize = BLKOOPS_BUFSIZE;
+	c->dbg_buf = kmalloc(c->dbg_bufsize, GFP_KERNEL);
+	if (!c->dbg_buf) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+
+	err = nonseekable_open(inode, file);
+	if (err)
+		goto out_err;
+
+	file->private_data = c;
+
+	c->dbg_part = 1;
+	c->dbg_used = 0;
+
+	return 0;
+
+out_err:
+	spin_lock_irqsave(&c->dbg_lock, flags);
+	c->dbg_open = 0;
+	spin_unlock_irqrestore(&c->dbg_lock, flags);
+	return err;
+}
+
+static int blkoops_dbg_file_release(struct inode *inode, struct file *file)
+{
+	struct blkoops *c = inode->i_private;
+	unsigned long flags;
+	int err, err2;
+
+	err = blkoops_dbg_flush_buf(c);
+
+	spin_lock_irqsave(&c->dbg_lock, flags);
+	err2 = blkoops_flush(&c->psi);
+	spin_unlock_irqrestore(&c->dbg_lock, flags);
+	if (err2 && !err)
+		err = err2;
+
+	kfree(c->dbg_buf);
+
+	spin_lock_irqsave(&c->dbg_lock, flags);
+	c->dbg_open = 0;
+	spin_unlock_irqrestore(&c->dbg_lock, flags);
+
+	return err;
+}
+
+static const struct file_operations dbg_data_fops = {
+	.owner		= THIS_MODULE,
+	.open		= blkoops_dbg_file_open,
+	.release	= blkoops_dbg_file_release,
+	.write		= blkoops_dbg_write,
+	.llseek		= no_llseek,
+};
+
+static void blkoops_init_debugfs(struct blkoops *c)
+{
+	umode_t rw = S_IRUSR | S_IWUSR, wo = S_IWUSR;
+
+	c->dbg_root = debugfs_create_dir("blkoops", NULL);
+
+	debugfs_create_u32("type", rw, c->dbg_root, &c->dbg_type);
+	debugfs_create_u32("reason", rw, c->dbg_root, &c->dbg_reason);
+	debugfs_create_file("data", wo, c->dbg_root, c, &dbg_data_fops);
+}
+
+static void blkoops_remove_debugfs(struct blkoops *c)
+{
+	debugfs_remove_recursive(c->dbg_root);
+}
+
+#else
+
+static inline void blkoops_init_debugfs(struct blkoops *c)
+{
+}
+
+static void blkoops_remove_debugfs(struct blkoops *c)
+{
+}
+
+#endif
+
+static void *blkoops_alloc_buf(unsigned int blksize, loff_t max_size,
+			       unsigned int *rsz)
+{
+	unsigned int size;
+	void *addr;
+	gfp_t flgs;
+
+	size = BLKOOPS_BUFSIZE;
+	if (size > max_size)
+		size = max_size;
+
+	while (1) {
+		if (size < blksize)
+			*rsz = blksize;
+		else
+			*rsz = roundup(size, blksize);
+		flgs = *rsz == blksize ? GFP_KERNEL : GFP_KERNEL | __GFP_NOWARN;
+		addr = kzalloc(*rsz, flgs);
+		if (addr || *rsz == blksize)
+			break;
+		size >>= 1;
+	}
+	return addr;
+}
+
+static int blkoops_read_session(struct blkoops *c)
+{
+	struct blkoops_node *bn;
+
+	bn = blkoops_read_node(c, 0);
+	if (IS_ERR(bn)) {
+		if (PTR_ERR(bn) == -EINVAL)
+			pr_err("blkoops: %s: bad magic\n", c->bdev_name);
+		return PTR_ERR(bn);
+	}
+
+	c->last_session = bn->session;
+	c->next_session = c->last_session + 1;
+	c->next_file = 0;
+
+	c->erased_session = bn->session;
+	c->erased_file = bn->file;
+	c->erased_sects = bn->nr_sects;
+
+	kfree(bn);
+
+	bn = blkoops_read_node(c, blkoops_scan_start(c));
+	if (IS_ERR(bn))
+		goto out;
+
+	if (!blkoops_validate_node(c, bn)) {
+		c->last_session = bn->session;
+		c->next_session = c->last_session + 1;
+	}
+
+	kfree(bn);
+out:
+	DBG("sess %u size %lld blksz %u", c->last_session, c->size, c->blksize);
+	if (c->erased_file) {
+		DBG("erased sess %u file %u sects %llu",
+		    c->erased_session, c->erased_file, (u64)c->erased_sects);
+	}
+
+	return 0;
+}
+
+static int blkoops_get_bdev_size(struct blkoops *c, struct block_device *bdev)
+{
+	unsigned int blksize;
+	loff_t size;
+
+	blksize = bdev_logical_block_size(bdev);
+	if (blksize < 512 || blksize & 511)
+		return -EINVAL;
+
+	size = i_size_read(bdev->bd_inode);
+	if (size < 2 * blksize)
+		return -EINVAL;
+
+	c->blksize = blksize;
+	c->sects_per_blk = blksize >> 9;
+	c->size = size;
+	c->nr_sects = size >> 9;
+
+	return 0;
+}
+
+static struct blkoops *blkoops_alloc(void)
+{
+	struct blkoops *c;
+
+	c = kzalloc(sizeof(struct blkoops), GFP_KERNEL);
+	if (!c)
+		return NULL;
+
+	c->psi.owner     = THIS_MODULE,
+	c->psi.name      = "blkoops",
+	c->psi.flags     = PSTORE_NO_HEADINGS | PSTORE_MAX_KMSG_BYTES,
+	c->psi.open      = blkoops_open,
+	c->psi.read      = blkoops_read,
+	c->psi.file_read = blkoops_file_read,
+	c->psi.write     = blkoops_write,
+	c->psi.erase     = blkoops_erase,
+	c->psi.flush     = blkoops_flush,
+	c->psi.data      = c;
+
+	spin_lock_init(&c->psi.buf_lock);
+#ifdef CONFIG_DEBUG_FS
+	spin_lock_init(&c->dbg_lock);
+#endif
+	return c;
+}
+
+static struct blkoops *blkoops;
+
+static int blkoops_do_add(struct blkoops *c)
+{
+	int err;
+
+	if (c->present)
+		return -EINVAL;
+
+	if (!*devname)
+		return -EINVAL;
+
+	*c->bdev_name = '\0';
+
+	c->devid = name_to_dev_t(devname);
+	if (!c->devid) {
+		err = -ENODEV;
+		goto out_err;
+	}
+
+	c->bdev = blkdev_get_by_dev(c->devid, BLKOOPS_MODE, blkoops_do_add);
+	if (IS_ERR(c->bdev)) {
+		err = PTR_ERR(c->bdev);
+		goto out_err;
+	}
+
+	bdevname(c->bdev, c->bdev_name);
+
+	err = blk_panic_init(c->bdev);
+	if (err)
+		goto out_put;
+
+	err = blkoops_get_bdev_size(c, c->bdev);
+	if (err)
+		goto out_cleanup;
+
+	err = blkoops_read_session(c);
+	if (err)
+		goto out_cleanup;
+
+	if (!c->buf) {
+		unsigned int rsz;
+		void *addr;
+
+		addr = blkoops_alloc_buf(c->blksize, c->size, &rsz);
+		if (!addr) {
+			err = -ENOMEM;
+			goto out_cleanup;
+		}
+		c->buf = addr;
+		c->bufsize = rsz;
+		c->root = RB_ROOT;
+	}
+
+	c->next_sect = blkoops_scan_start(c) >> 9;
+
+	spin_lock(&blkoops_lock);
+	c->present = 1;
+	spin_unlock(&blkoops_lock);
+
+	if (!c->psi.buf) {
+		c->psi.buf = c->buf + BLKOOPS_HDR_SZ;
+		c->psi.bufsize = c->bufsize - BLKOOPS_HDR_SZ;
+		err = pstore_register(&c->psi);
+		if (err)
+			goto out_no_pstore;
+	}
+
+	blkoops_init_debugfs(c);
+
+	pr_info("blkoops initialized on %s\n", c->bdev_name);
+
+	return 0;
+
+out_no_pstore:
+	c->psi.buf = NULL;
+	c->present = 0;
+	kfree(c->buf);
+	c->buf = NULL;
+out_cleanup:
+	blk_panic_cleanup(c->bdev);
+out_put:
+	blkdev_put(c->bdev, BLKOOPS_MODE);
+out_err:
+	pr_err("blkoops initialization failed on %s, error %d\n",
+	       *c->bdev_name ? c->bdev_name : devname, err);
+	return err;
+}
+
+static void blkoops_do_remove(struct blkoops *c)
+{
+	if (!c->present)
+		return;
+
+	blkoops_remove_debugfs(c);
+
+	spin_lock(&blkoops_lock);
+	c->present = 0;
+	spin_unlock(&blkoops_lock);
+
+	blkoops_free_tree(c);
+
+	blk_panic_cleanup(c->bdev);
+
+	blkdev_put(c->bdev, BLKOOPS_MODE);
+
+	pr_info("blkoops detached from %s\n", c->bdev_name);
+}
+
+static int blkoops_add(void)
+{
+	int err;
+
+	/*
+	 * Headers are sector aligned and less than 1 sector in size so that
+	 * only whole headers are read.
+	 */
+	BUILD_BUG_ON(BLKOOPS_HDR_SZ > 512);
+
+	if (!blkoops)
+		blkoops = blkoops_alloc();
+	if (!blkoops)
+		return -ENOMEM;
+
+	err = blkoops_do_add(blkoops);
+
+	if (!blkoops->psi.buf) {
+		/*
+		 * 'blkoops' can be freed if the registration with pstore
+		 * failed, otherwise 'blkoops' is never freed.
+		 */
+		kfree(blkoops);
+		blkoops = NULL;
+	}
+
+	return err;
+}
+
+static void blkoops_remove(void)
+{
+	if (blkoops)
+		blkoops_do_remove(blkoops);
+}
+
+static int __init blkoops_init(void)
+{
+	int err = 0;
+	dev_t devid;
+
+	mutex_lock(&blkoops_mutex);
+	init_done = 1;
+	if (!*devname)
+		goto out;
+	devid = name_to_dev_t(devname);
+	if (!devid)
+		wait_for_device_probe();
+	err = blkoops_add();
+out:
+	mutex_unlock(&blkoops_mutex);
+	return err;
+}
+
+late_initcall(blkoops_init);
+
+static int param_set_devname(const char *val, const struct kernel_param *kp)
+{
+	int err = 0;
+
+	if (strlen(val) >= BLKOOPS_DEVNAME_SZ) {
+		pr_err("blkoops: devname parameter too long\n");
+		return -ENOSPC;
+	}
+
+	mutex_lock(&blkoops_mutex);
+	if (init_done)
+		blkoops_remove();
+	if (sscanf(val, "%s", devname) != 1)
+		*devname = '\0';
+	if (init_done && *devname)
+		err = blkoops_add();
+	mutex_unlock(&blkoops_mutex);
+
+	return err;
+}
+
+static int param_get_devname(char *buffer, const struct kernel_param *kp)
+{
+	return snprintf(buffer, BLKOOPS_DEVNAME_SZ, "%s", devname);
+}
+
+static struct kernel_param_ops param_ops_devname = {
+	.set = param_set_devname,
+	.get = param_get_devname,
+};
+
+module_param_cb(devname, &param_ops_devname, &devname, S_IRUSR | S_IWUSR);
+MODULE_PARM_DESC(devname, "Canonical block device name or number");
+
+module_param(dump_oops, int, S_IRUSR | S_IWUSR);
+MODULE_PARM_DESC(dump_oops,
+		 "set to 1 to dump oopses, 0 to dump only panics (default 0)");
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Adrian Hunter");
+MODULE_DESCRIPTION("Block Oops / Panic Logger");
-- 
1.7.9.5

