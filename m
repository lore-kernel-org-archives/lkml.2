Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab0DMXwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 19:52:23 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:59388 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab0DMXwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 19:52:19 -0400
X-Greylist: delayed 1403 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Apr 2010 19:52:19 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=from:to
	:cc:subject:date:message-id:in-reply-to:references:in-reply-to
	:references; q=dns; s=drama; b=TrsngCthUhiSMNF5RZy6f8OBnWyA6Eo+/
	vzmCB5DfTSCMj7VK0liN6TbnrcyHn4+UauFwfVF6KHbTS8PWBAIkLVnFzn9J4HRX
	Cm2j+u91AzUGsFlze/qUWHLb9NavX+FXVvQkzdGDdOu3BJOujIRsP/xaWq4Z/NeI
	sr+gBHRpzE=
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, yehudasa@gmail.com, sage@newdream.net,
       axboe@kernel.dk, Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [PATCH 6/6] ceph: rados block device
Date: Tue, 13 Apr 2010 16:29:15 -0700
Message-Id: <40328263a9dcb3203db338ec1cf89075ce4e1f27.1271198630.git.yehuda@hq.newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1271201355-9346-1-git-send-email-yehuda@hq.newdream.net>
References: <1271201355-9346-1-git-send-email-yehuda@hq.newdream.net>
In-Reply-To: <6b8320ea22e059baaac6e4cdd3a0a687646de168.1271198630.git.yehuda@hq.newdream.net>
References: <6b8320ea22e059baaac6e4cdd3a0a687646de168.1271198630.git.yehuda@hq.newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the rbd under fs/ceph. The rados block device is
based on the drivers/block/osdblk.c. It allows mapping of
rados (ther ceph block layer) objects over a block device.
Each device has a metadata object, and data is being striped
across different objects.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 fs/ceph/Makefile |    3 +-
 fs/ceph/rbd.c    | 1224 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/rbd.h    |    8 +
 fs/ceph/super.c  |    8 +
 4 files changed, 1242 insertions(+), 1 deletions(-)

diff --git a/fs/ceph/Makefile b/fs/ceph/Makefile
index 6a660e6..f06ff40 100644
--- a/fs/ceph/Makefile
+++ b/fs/ceph/Makefile
@@ -16,7 +16,8 @@ ceph-objs := super.o inode.o dir.o file.o addr.o ioctl.o \
 	auth.o auth_none.o \
 	crypto.o armor.o \
 	auth_x.o \
-	ceph_fs.o ceph_strings.o ceph_hash.o ceph_frag.o
+	ceph_fs.o ceph_strings.o ceph_hash.o ceph_frag.o \
+	rbd.o
 
 else
 #Otherwise we were called directly from the command
diff --git a/fs/ceph/rbd.c b/fs/ceph/rbd.c
new file mode 100644
index 0000000..3f7a7bd
--- /dev/null
+++ b/fs/ceph/rbd.c
@@ -0,0 +1,1224 @@
+/*
+   rbd.c -- Export ceph rados objects as a Linux block device
+
+
+   based on drivers/block/osdblk.c:
+
+   Copyright 2009 Red Hat, Inc.
+
+   This program is free software; you can redistribute it and/or modify
+   it under the terms of the GNU General Public License as published by
+   the Free Software Foundation.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with this program; see the file COPYING.  If not, write to
+   the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+
+
+
+   Instructions for use
+   --------------------
+
+   1) Map a Linux block device to an existing rbd image.
+
+      Usage: <mon ip addr> <options> <pool id> <rbd image name>
+
+      $ echo "192.168.0.1 name=admin 0 foo" > /sys/class/rbd/add
+
+
+   2) List all active blkdev<->object mappings.
+
+      In this example, we have performed step #1 twice, creating two blkdevs,
+      mapped to two separate rados objects in rados pool 0.
+
+      $ cat /sys/class/rbd/list
+      0 254 0 foo
+      1 253 0 bar
+
+      The columns, in order, are:
+      - blkdev unique id
+      - blkdev assigned major
+      - rados pool id
+      - rados block device name
+
+
+   3) Remove an active blkdev<->rbd image mapping.
+
+      In this example, we remove the mapping with blkdev unique id 1.
+
+      $ echo 1 > /sys/class/rbd/remove
+
+
+   NOTE:  The actual creation and deletion of rados objects is outside the scope
+   of this driver.
+
+ */
+
+#include "super.h"
+#include "osd_client.h"
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/blkdev.h>
+
+#define DRV_NAME "rbd"
+#define DRV_NAME_LONG "rbd (rados block device)"
+
+
+enum {
+	RBD_MINORS_PER_MAJOR	= 256,		/* max minors per blkdev */
+};
+
+static const char rbd_text[] = "<<< Rados Block Device Image >>>\n";
+static const char rbd_signature[] = "RBD";
+static const char rbd_version[] = "001.000";
+
+#define RBD_COMP_NONE		0
+#define RBD_CRYPT_NONE		0
+
+#define RBD_DEFAULT_OBJ_ORDER	22   /* 4MB */
+
+#define RBD_SUFFIX	 	".rbd"
+
+#define RBD_MAX_OBJ_NAME_SIZE	96
+#define RBD_MAX_SEG_NAME_SIZE	128
+
+#define RBD_STRIPE_UNIT (1 << 22)
+
+#define RBD_MAX_OPT_LEN		1024
+
+
+struct rbd_obj_header_ondisk {
+	char text[64];
+	char signature[4];
+	char version[8];
+	__le64 image_size;
+	__u8 obj_order;
+	__u8 crypt_type;
+	__u8 comp_type;
+	__le64 snap_seq;
+	__le16 snap_count;
+	__le64 snap_id[0];
+} __attribute__((packed));
+
+struct rbd_obj_header {
+	u64 image_size;
+	__u8 obj_order;
+	__u8 crypt_type;
+	__u8 comp_type;
+	u64 snap_seq;
+	u16 snap_count;
+	u64 snap_id[0];
+};
+
+struct rbd_request {
+	struct request		*rq;		/* blk layer request */
+	struct bio		*bio;		/* cloned bio */
+	struct page		**pages;	/* list of used pages */
+	u64			len;
+};
+
+struct rbd_client_node {
+	struct ceph_client	*client;
+	const char		*opt;
+	struct kref		kref;
+	struct list_head	node;
+};
+
+#define DEV_NAME_LEN		32
+
+struct rbd_device {
+	int			id;		/* blkdev unique id */
+
+	int			major;		/* blkdev assigned major */
+	struct gendisk		*disk;		/* blkdev's gendisk and rq */
+	struct request_queue	*q;
+
+	struct ceph_client	*client;	/* associated OSD */
+
+	char			name[DEV_NAME_LEN]; /* blkdev name, e.g. rbd34 */
+
+	spinlock_t		lock;		/* queue lock */
+
+	struct rbd_obj_header	*header;
+	char              	obj[RBD_MAX_OBJ_NAME_SIZE]; /* rbd image name */
+	int               	obj_len;
+	int               	poolid;
+
+	struct list_head	node;
+	struct rbd_client_node	*client_node;
+};
+
+static spinlock_t node_lock; /* protects client get/put */
+
+static struct class *class_rbd;		/* /sys/class/rbd */
+static DEFINE_MUTEX(ctl_mutex);	/* Serialize open/close/setup/teardown */
+static LIST_HEAD(rbddev_list);
+static LIST_HEAD(node_list);
+
+static const struct block_device_operations rbd_bd_ops = {
+	.owner		= THIS_MODULE,
+};
+
+/*
+ * Initialize ceph client for a specific device.
+ */
+static int rbd_init_client(struct rbd_device *rbd_dev,
+			   struct ceph_mount_args *args)
+{
+	dout("rbd_init_device\n");
+	rbd_dev->client = ceph_create_client(args, 0);
+	if (IS_ERR(rbd_dev->client))
+		return PTR_ERR(rbd_dev->client);
+
+	return ceph_open_session(rbd_dev->client);
+}
+
+/*
+ * Find a ceph client with specific addr and configuration.
+ */
+static struct rbd_client_node *__get_client_node(struct ceph_mount_args *args)
+{
+	struct rbd_client_node *client_node;
+
+	if (args->flags & CEPH_OPT_NOSHARE)
+		return NULL;
+
+	list_for_each_entry(client_node, &node_list, node)
+		if (ceph_compare_mount_args(args, client_node->client) == 0)
+			return client_node;
+	return NULL;
+}
+
+/*
+ * Get a ceph client with specific addr and configuration, if one does
+ * not exist create it.
+ */
+static int rbd_get_client(struct rbd_device *rbd_dev, const char *mon_addr,
+			  char *opt)
+{
+	struct rbd_client_node *client_node;
+	struct ceph_mount_args *args;
+	int ret;
+
+	spin_lock(&node_lock);
+
+	args = parse_mount_args(0, opt, mon_addr, NULL);
+	if (IS_ERR(args))
+		return PTR_ERR(args);
+
+	client_node = __get_client_node(args);
+	if (client_node) {
+		kfree(args);
+
+		kref_get(&client_node->kref);
+		rbd_dev->client_node = client_node;
+		rbd_dev->client = client_node->client;
+		spin_unlock(&node_lock);
+		return 0;
+	}
+
+	spin_unlock(&node_lock);
+
+	ret = -ENOMEM;
+	client_node = kmalloc(sizeof(struct rbd_client_node), GFP_KERNEL);
+	if (!client_node)
+		goto out;
+
+	ret = rbd_init_client(rbd_dev, args);
+	if (ret < 0)
+		goto out_free;
+
+	client_node->client = rbd_dev->client;
+	client_node->opt = kstrdup(opt, GFP_KERNEL);
+	kref_init(&client_node->kref);
+	INIT_LIST_HEAD(&client_node->node);
+
+	rbd_dev->client_node = client_node;
+
+	spin_lock(&node_lock);
+	list_add_tail(&client_node->node, &node_list);
+	spin_unlock(&node_lock);
+
+	return 0;
+
+out_free:
+	kfree(client_node);
+out:
+	return ret;
+}
+
+/*
+ * Destroy ceph client
+ */
+static void rbd_release_client(struct kref *kref)
+{
+	struct rbd_client_node *node =
+			container_of(kref, struct rbd_client_node, kref);
+
+	dout("rbd_release_client\n");
+
+	spin_lock(&node_lock);
+	list_del(&node->node);
+	spin_unlock(&node_lock);
+
+	ceph_destroy_client(node->client);
+	kfree(node->opt);
+	kfree(node);
+}
+
+/*
+ * Drop reference to ceph client node. If it's not referenced anymore, release
+ * it.
+ */
+static void rbd_put_client(struct rbd_device *rbd_dev)
+{
+	if (!rbd_dev->client_node)
+		return;
+
+	kref_put(&rbd_dev->client_node->kref, rbd_release_client);
+	rbd_dev->client_node = NULL;
+}
+
+
+/*
+ * Create a new header structure, translate header format from the on-disk
+ * header.
+ */
+static int rbd_header_from_disk(struct rbd_obj_header **header,
+				 struct rbd_obj_header_ondisk *ondisk,
+				 gfp_t gfp_flags)
+{
+	int i;
+	u16 snap_count = le16_to_cpu(ondisk->snap_count);
+
+	*header = kmalloc(sizeof(struct rbd_obj_header) +
+			  snap_count * sizeof(u32), gfp_flags);
+	if (!*header)
+		return -ENOMEM;
+
+	(*header)->image_size = le64_to_cpu(ondisk->image_size);
+	(*header)->obj_order = ondisk->obj_order;
+	(*header)->crypt_type = ondisk->crypt_type;
+	(*header)->comp_type = ondisk->comp_type;
+	(*header)->snap_seq = le64_to_cpu(ondisk->snap_seq);
+	(*header)->snap_count = snap_count;
+
+	for (i = 0; i < snap_count; i++)
+		(*header)->snap_id[i] = le64_to_cpu(ondisk->snap_id[i]);
+
+	return 0;
+}
+
+/*
+ * get the actual striped segment name, offset and length
+ */
+static u64 rbd_get_segment(struct rbd_obj_header *header,
+			   const char *obj_name,
+			   u64 ofs, u64 len,
+			   char *seg_name, u64 *segofs)
+{
+	u64 seg = ofs >> header->obj_order;
+
+	if (seg_name)
+		snprintf(seg_name, RBD_MAX_SEG_NAME_SIZE,
+		         "%s.%012llx", obj_name, seg);
+
+	ofs = ofs & ((1 << header->obj_order) - 1);
+	len = min_t(u64, len, (1 << header->obj_order) - ofs);
+
+	if (segofs)
+		*segofs = ofs;
+
+	return len;
+}
+
+static void bio_chain_put(struct bio *chain)
+{
+	struct bio *tmp;
+
+	while (chain) {
+		tmp = chain;
+		chain = chain->bi_next;
+
+		bio_put(tmp);
+	}
+}
+
+/*
+ * zeros a bio chain, starting at specific offset
+ */
+static void zero_bio_chain(struct bio *chain, int start_ofs)
+{
+	struct bio_vec *bv;
+	unsigned long flags;
+	void *buf;
+	int i;
+	int pos = 0;
+
+	while (chain) {
+		bio_for_each_segment(bv, chain, i) {
+			if (pos + bv->bv_len > start_ofs) {
+				int remainder = max(start_ofs - pos, 0);
+				buf = bvec_kmap_irq(bv, &flags);
+				memset(buf + remainder, 0,
+				       bv->bv_len - remainder);
+				bvec_kunmap_irq(bv, &flags);
+			}
+			pos += bv->bv_len;
+		}
+
+		chain = chain->bi_next;
+	}
+}
+
+/*
+ * bio_chain_clone - clone a chain of bios up to a certain length.
+ * might return a bio_pair that will need to be released.
+ */
+static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
+				   struct bio_pair **bp,
+				   int len, gfp_t gfpmask)
+{
+	struct bio *tmp, *old_chain = *old, *new_chain = NULL, *tail = NULL;
+	int total = 0;
+
+	if (*bp) {
+		bio_pair_release(*bp);
+		*bp = NULL;
+	}
+
+	while (old_chain && (total < len)) {
+		tmp = bio_kmalloc(gfpmask, old_chain->bi_max_vecs);
+		if (!tmp)
+			goto err_out;
+
+		if (total + old_chain->bi_size > len) {
+			struct bio_pair *bp;
+
+			/*
+			 * this split can only happen with a single paged bio,
+			 * split_bio will BUG_ON if this is not the case
+			 */
+			dout("bio_chain_clone split! total=%d remaining=%d bi_size=%d\n",
+			     (int)total, (int)len-total, (int)old_chain->bi_size);
+
+			/* split the bio. We'll release it either in the next
+			   call, or it will have to be released outside */
+			bp = bio_split(old_chain, (len - total) / 512ULL);
+			if (!bp)
+				goto err_out;
+
+			__bio_clone(tmp, &bp->bio1);
+
+			*next = &bp->bio2;
+		} else {
+			__bio_clone(tmp, old_chain);
+			*next = old_chain->bi_next;
+		}
+
+		tmp->bi_bdev = NULL;
+		gfpmask &= ~__GFP_WAIT;
+		tmp->bi_next = NULL;
+
+		if (!new_chain) {
+			new_chain = tail = tmp;
+		} else {
+			tail->bi_next = tmp;
+			tail = tmp;
+		}
+		old_chain = old_chain->bi_next;
+
+		total += tmp->bi_size;
+	}
+
+	BUG_ON(total < len);
+
+	if (tail)
+		tail->bi_next = NULL;
+
+	*old = old_chain;
+
+	return new_chain;
+
+err_out:
+	dout("bio_chain_clone with err\n");
+	bio_chain_put(new_chain);
+	return NULL;
+}
+
+static void rbd_req_flush_object(struct request *rq,
+				 const char *obj,
+				 u64 offset, u64 len)
+{
+	/* not really flushing anything currently */
+	blk_end_request_all(rq, 0);
+}
+
+/*
+ * Send ceph osd request
+ */
+static int rbd_do_request(struct request *rq,
+			  struct rbd_device *dev,
+			  const char *obj, u64 ofs, u64 len,
+			  struct bio *bio,
+			  struct page **pages,
+			  int num_pages,
+			  int opcode, int flags,
+			  int num_reply,
+			  void (*rbd_cb)(struct ceph_osd_request *req,
+					 struct ceph_msg *msg))
+{
+	struct ceph_osd_request *req;
+	struct ceph_file_layout *layout;
+	int ret;
+	u64 bno;
+	struct timespec mtime = CURRENT_TIME;
+	struct rbd_request *req_data;
+	struct ceph_osd_request_head *reqhead;
+
+	ret = -ENOMEM;
+	req_data = kzalloc(sizeof(*req_data), GFP_NOFS);
+	if (!req_data)
+		goto done;
+
+	dout("rbd_do_request len=%lld ofs=%lld\n", len, ofs);
+
+	req = ceph_osdc_alloc_request(&dev->client->osdc, flags,
+				      NULL, 0,
+				      false,
+				      GFP_NOFS, pages, bio);
+	if (IS_ERR(req)) {
+		ret = PTR_ERR(req);
+		goto done_pages;
+	}
+
+	req->r_callback = rbd_cb;
+
+	req_data->rq = rq;
+	req_data->bio = bio;
+	req_data->pages = pages;
+	req_data->len = len;
+
+	req->r_priv = req_data;
+
+	reqhead = req->r_request->front.iov_base;
+	reqhead->snapid = cpu_to_le64(CEPH_NOSNAP);
+
+	strncpy(req->r_oid, obj, sizeof(req->r_oid));
+	req->r_oid_len = strlen(req->r_oid);
+
+	layout = &req->r_file_layout;
+	memset(layout, 0, sizeof(*layout));
+	layout->fl_stripe_unit = RBD_STRIPE_UNIT;
+	layout->fl_stripe_count = 1;
+	layout->fl_object_size = RBD_STRIPE_UNIT;
+	layout->fl_pg_preferred = -1;
+	layout->fl_pg_pool = dev->poolid;
+	ceph_calc_raw_layout(&dev->client->osdc, layout, ofs, len, &bno, req);
+
+	ceph_osdc_build_request(req, ofs, &len, opcode,
+				NULL, 0,
+				0, 0,
+				&mtime,
+				req->r_oid, req->r_oid_len);
+
+	ret = ceph_osdc_start_request(&dev->client->osdc, req, false);
+	if (ret < 0)
+		goto done_err;
+
+	if (!rbd_cb) {
+		ret = ceph_osdc_wait_request(&dev->client->osdc, req);
+		ceph_osdc_put_request(req);
+	}
+	return ret;
+
+done_err:
+	bio_chain_put(req_data->bio);
+	ceph_osdc_put_request(req);
+done_pages:
+	kfree(req_data);
+done:
+	if (rq)
+		blk_end_request(rq, ret, len);
+	return ret;
+}
+
+/*
+ * Ceph osd op callback
+ */
+static void rbd_req_cb(struct ceph_osd_request *req, struct ceph_msg *msg)
+{
+	struct rbd_request *req_data = req->r_priv;
+	struct ceph_osd_reply_head *replyhead;
+	struct ceph_osd_op *op;
+	__s32 rc;
+	u64 bytes;
+	int read_op;
+
+	/* parse reply */
+	replyhead = msg->front.iov_base;
+	WARN_ON(le32_to_cpu(replyhead->num_ops) == 0);
+	op = (void *)(replyhead + 1);
+	rc = le32_to_cpu(replyhead->result);
+	bytes = le64_to_cpu(op->extent.length);
+
+	dout("rbd_req_cb bytes=%lld rc=%d\n", bytes, rc);
+
+	read_op = (le32_to_cpu(op->op) == CEPH_OSD_OP_READ);
+
+	if (rc == -ENOENT && read_op) {
+		zero_bio_chain(req_data->bio, 0);
+		rc = 0;
+	} else if (rc == 0 && read_op && bytes < req_data->len) {
+		zero_bio_chain(req_data->bio, bytes);
+		bytes = req_data->len;
+	}
+
+	blk_end_request(req_data->rq, rc, bytes);
+
+	if (req_data->bio)
+		bio_chain_put(req_data->bio);
+
+	ceph_osdc_put_request(req);
+	kfree(req_data);
+}
+
+/*
+ * Do a synchronous ceph osd operation
+ */
+static int rbd_req_sync_op(struct rbd_device *dev,
+			   int opcode, int flags,
+			   int num_reply,
+		           const char *obj,
+			   u64 ofs, u64 len,
+			   char *buf)
+{
+	int ret;
+	struct page **pages;
+	int num_pages;
+
+	num_pages = calc_pages_for(ofs , len);
+	pages = ceph_alloc_page_vector(num_pages, GFP_KERNEL);
+	if (!pages)
+		return -ENOMEM;
+
+	if (flags & CEPH_OSD_FLAG_WRITE) {
+		ret = ceph_copy_to_page_vector(pages, buf, ofs, len);
+		if (ret < 0)
+			goto done;
+	}
+
+	ret = rbd_do_request(NULL, dev, obj, ofs, len, NULL,
+			  pages, num_pages,
+			  opcode,
+			  flags,
+			  2,
+			  NULL);
+	if (ret < 0)
+		goto done;
+
+	if (flags & CEPH_OSD_FLAG_READ)
+		ret = ceph_copy_from_page_vector(pages, buf, ofs, len);
+
+done:
+	ceph_release_page_vector(pages, num_pages);
+	return ret;
+}
+
+/*
+ * Do an asynchronous ceph osd operation
+ */
+static int rbd_do_op(struct request *rq,
+		     struct rbd_device *rbd_dev ,
+		     int opcode, int flags, int num_reply,
+		     u64 ofs, u64 len,
+		     struct bio *bio)
+{
+	char *seg_name;
+	u64 seg_ofs;
+	u64 seg_len;
+	int ret;
+
+	seg_name = kmalloc(RBD_MAX_SEG_NAME_SIZE + 1, GFP_NOIO);
+	if (!seg_name)
+		return -ENOMEM;
+
+	seg_len = rbd_get_segment(rbd_dev->header,
+				  rbd_dev->obj,
+				  ofs, len,
+				  seg_name, &seg_ofs);
+	if (seg_len < 0)
+		return seg_len;
+
+	/* we've taken care of segment sizes earlier when we
+	   cloned the bios. We should never have a segment
+	   truncated at this point */
+	BUG_ON(seg_len < len);
+
+	ret = rbd_do_request(rq, rbd_dev,
+			     seg_name, seg_ofs, seg_len,
+			     bio,
+			     NULL, 0,
+			     opcode,
+			     flags,
+			     num_reply,
+			     rbd_req_cb);
+	kfree(seg_name);
+	return ret;
+}
+
+/*
+ * Request async osd write
+ */
+static int rbd_req_write(struct request *rq,
+			 struct rbd_device *rbd_dev,
+			 u64 ofs, u64 len,
+			 struct bio *bio)
+{
+	return rbd_do_op(rq, rbd_dev,
+			 CEPH_OSD_OP_WRITE,
+			 CEPH_OSD_FLAG_WRITE | CEPH_OSD_FLAG_ONDISK,
+			 2,
+			 ofs, len, bio);
+}
+
+/*
+ * Request sync osd write
+ */
+static int __attribute__ ((unused))
+rbd_req_sync_write(struct rbd_device *dev,
+		          const char *obj,
+			  u64 ofs, u64 len,
+			  char *buf)
+{
+	return rbd_req_sync_op(dev,
+			       CEPH_OSD_OP_WRITE,
+			       CEPH_OSD_FLAG_WRITE | CEPH_OSD_FLAG_ONDISK,
+			       2, obj, ofs, len, buf);
+}
+
+/*
+ * Request async osd read
+ */
+static int rbd_req_read(struct request *rq,
+			 struct rbd_device *rbd_dev,
+			 u64 ofs, u64 len,
+			 struct bio *bio)
+{
+	return rbd_do_op(rq, rbd_dev,
+			 CEPH_OSD_OP_READ,
+			 CEPH_OSD_FLAG_READ,
+			 2,
+			 ofs, len, bio);
+}
+
+/*
+ * Request sync osd read
+ */
+static int rbd_req_sync_read(struct rbd_device *dev,
+		          const char *obj,
+			  u64 ofs, u64 len,
+			  char *buf)
+{
+	return rbd_req_sync_op(dev,
+			       CEPH_OSD_OP_READ,
+			       CEPH_OSD_FLAG_READ,
+			       1, obj, ofs, len, buf);
+}
+
+/*
+ * block device queue callback
+ */
+static void rbd_rq_fn(struct request_queue *q)
+{
+	struct rbd_device *rbd_dev = q->queuedata;
+	struct request *rq;
+	struct bio_pair *bp = NULL;
+
+	rq = blk_fetch_request(q);
+
+	while (1) {
+		struct bio *bio;
+		struct bio *rq_bio, *next_bio = NULL;
+		bool do_write, do_flush;
+		int size, op_size = 0;
+		u64 ofs;
+
+		/* peek at request from block layer */
+		if (!rq)
+			break;
+
+		dout("fetched request\n");
+
+		/* filter out block requests we don't understand */
+		if (!blk_fs_request(rq) && !blk_barrier_rq(rq)) {
+			blk_end_request_all(rq, 0);
+			continue;
+		}
+
+		/* deduce our operation (read, write, flush) */
+		/* I wish the block layer simplified cmd_type/cmd_flags/cmd[]
+		 * into a clearly defined set of RPC commands:
+		 * read, write, flush, scsi command, power mgmt req,
+		 * driver-specific, etc.
+		 */
+		do_flush = (rq->special == (void *) 0xdeadbeefUL);
+		do_write = (rq_data_dir(rq) == WRITE);
+
+		size = blk_rq_bytes(rq);
+		ofs = blk_rq_pos(rq) * 512ULL;
+		rq_bio = rq->bio;
+
+		spin_unlock_irq(q->queue_lock);
+
+		dout("%s 0x%x bytes at 0x%llx\n",
+		     do_flush ? "flush" : (do_write ? "write" : "read"),
+		     size, blk_rq_pos(rq) * 512ULL);
+
+		do {
+			if (!do_flush) { /* osd_flush does not use a bio */
+				/* a bio clone to be passed down to OSD req */
+				dout("rq->bio->bi_vcnt=%d\n", rq->bio->bi_vcnt);
+				op_size = rbd_get_segment(rbd_dev->header,
+							  rbd_dev->obj,
+							  ofs, size,
+							  NULL, NULL);
+				bio = bio_chain_clone(&rq_bio, &next_bio, &bp,
+						      op_size, GFP_ATOMIC);
+				if (!bio)
+					break;
+			} else {
+				bio = NULL;
+			}
+
+			/* init OSD command: flush, write or read */
+			if (do_flush)
+				rbd_req_flush_object(rq, rbd_dev->obj,
+					     0, 0);
+			else if (do_write)
+				rbd_req_write(rq, rbd_dev,
+					      ofs,
+					      op_size, bio);
+			else
+				rbd_req_read(rq, rbd_dev,
+					     ofs,
+					     op_size, bio);
+
+			size -= op_size;
+			ofs += op_size;
+
+			rq_bio = next_bio;
+		} while (size > 0);
+
+		if (bp)
+			bio_pair_release(bp);
+
+		spin_lock_irq(q->queue_lock);
+
+		/* remove the special 'flush' marker, now that the command
+		 * is executing */
+		rq->special = NULL;
+
+		rq = blk_fetch_request(q);
+	}
+}
+
+/*
+ * a queue callback. Makes sure that we don't create a bio that spans across
+ * multiple osd objects. One exception would be with a single page bios,
+ * which we handle later at bio_chain_clone
+ */
+static int rbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bmd,
+			  struct bio_vec *bvec)
+{
+	sector_t sector = bmd->bi_sector + get_start_sect(bmd->bi_bdev);
+	unsigned int chunk_sectors = (RBD_STRIPE_UNIT >> 9);
+	unsigned int bio_sectors = bmd->bi_size >> 9;
+	int max;
+
+	max =  (chunk_sectors - ((sector & (chunk_sectors - 1))
+				 + bio_sectors)) << 9;
+	if (max < 0)
+		max = 0; /* bio_add cannot handle a negative return */
+	if (max <= bvec->bv_len && bio_sectors == 0)
+		return bvec->bv_len;
+	return max;
+}
+
+static void rbd_prepare_flush(struct request_queue *q, struct request *rq)
+{
+	/*
+	 * add driver-specific marker, to indicate that this request
+	 * is a flush command
+	 */
+	rq->special = (void *) 0xdeadbeefUL;
+}
+
+static void rbd_free_disk(struct rbd_device *rbd_dev)
+{
+	struct gendisk *disk = rbd_dev->disk;
+
+	if (!disk)
+		return;
+
+	if (disk->flags & GENHD_FL_UP)
+		del_gendisk(disk);
+	if (disk->queue)
+		blk_cleanup_queue(disk->queue);
+	put_disk(disk);
+}
+
+static int rbd_read_header(struct rbd_device *rbd_dev,
+			   struct rbd_obj_header **header)
+{
+	ssize_t rc;
+	char *obj_md_name;
+	struct rbd_obj_header_ondisk *dh;
+	int snap_count = 0;
+
+	obj_md_name = kmalloc(strlen(rbd_dev->obj) + sizeof(RBD_SUFFIX),
+			      GFP_KERNEL);
+	if (!obj_md_name)
+		return -ENOMEM;
+	sprintf(obj_md_name, "%s%s", rbd_dev->obj, RBD_SUFFIX);
+
+	while (1) {
+		dh = kmalloc(sizeof(*dh) + snap_count * sizeof(u32),
+			     GFP_KERNEL);
+		if (!dh)
+			goto out_obj_md;
+
+		rc = rbd_req_sync_read(rbd_dev,
+				       obj_md_name,
+				       0, sizeof(*dh),
+				       (char *)dh);
+		if (rc < 0)
+			goto out_dh;
+
+		rc = rbd_header_from_disk(header, dh, GFP_KERNEL);
+		if (rc < 0)
+			goto out_dh;
+
+		if (snap_count != (*header)->snap_count) {
+			snap_count = (*header)->snap_count;
+			kfree(*header);
+			kfree(dh);
+			continue;
+		}
+		break;
+	}
+
+out_dh:
+	kfree(dh);
+out_obj_md:
+	kfree(obj_md_name);
+	return rc;
+}
+
+static int rbd_init_disk(struct rbd_device *rbd_dev)
+{
+	struct gendisk *disk;
+	struct request_queue *q;
+	int rc;
+	u64 total_size;
+
+	/* contact OSD, request size info about the object being mapped */
+	rc = rbd_read_header(rbd_dev, &rbd_dev->header);
+	if (rc)
+		return rc;
+
+	total_size = rbd_dev->header->image_size;
+
+	/* create gendisk info */
+	rc = -ENOMEM;
+	disk = alloc_disk(RBD_MINORS_PER_MAJOR);
+	if (!disk)
+		goto out;
+
+	sprintf(disk->disk_name, DRV_NAME "%d", rbd_dev->id);
+	disk->major = rbd_dev->major;
+	disk->first_minor = 0;
+	disk->fops = &rbd_bd_ops;
+	disk->private_data = rbd_dev;
+
+	/* init rq */
+	rc = -ENOMEM;
+	q = blk_init_queue(rbd_rq_fn, &rbd_dev->lock);
+	if (!q)
+		goto out_disk;
+	blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH, rbd_prepare_flush);
+	blk_queue_merge_bvec(q, rbd_merge_bvec);
+	disk->queue = q;
+
+	q->queuedata = rbd_dev;
+
+	rbd_dev->disk = disk;
+	rbd_dev->q = q;
+
+	/* finally, announce the disk to the world */
+	set_capacity(disk, total_size / 512ULL);
+	add_disk(disk);
+
+	pr_info("%s: added with size 0x%llx\n",
+		disk->disk_name, (unsigned long long)total_size);
+	return 0;
+
+out_disk:
+	put_disk(disk);
+out:
+	return rc;
+}
+
+/********************************************************************
+ * /sys/class/rbd/
+ *                   add	map rados objects to blkdev
+ *                   remove	unmap rados objects
+ *                   list	show mappings
+ *******************************************************************/
+
+static void class_rbd_release(struct class *cls)
+{
+	kfree(cls);
+}
+
+static ssize_t class_rbd_list(struct class *c,
+			      struct class_attribute *attr,
+			      char *data)
+{
+	int n = 0;
+	struct list_head *tmp;
+
+	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
+
+	list_for_each(tmp, &rbddev_list) {
+		struct rbd_device *rbd_dev;
+
+		rbd_dev = list_entry(tmp, struct rbd_device, node);
+		n += sprintf(data+n, "%d %d %d %s\n",
+			     rbd_dev->id,
+			     rbd_dev->major,
+			     rbd_dev->poolid,
+			     rbd_dev->obj);
+	}
+
+	mutex_unlock(&ctl_mutex);
+	return n;
+}
+
+static ssize_t class_rbd_add(struct class *c,
+			     struct class_attribute *attr,
+			     const char *buf, size_t count)
+{
+	struct rbd_device *rbd_dev;
+	ssize_t rc = -ENOMEM;
+	int irc, new_id = 0;
+	struct list_head *tmp;
+	char *mon_dev_name;
+	char *opt;
+
+	if (!try_module_get(THIS_MODULE))
+		return -ENODEV;
+
+	mon_dev_name = kmalloc(RBD_MAX_OPT_LEN, GFP_KERNEL);
+	if (!mon_dev_name)
+		goto err_out_mod;
+
+	opt = kmalloc(RBD_MAX_OPT_LEN, GFP_KERNEL);
+	if (!opt)
+		goto err_mon_dev;
+
+	/* new rbd_device object */
+	rbd_dev = kzalloc(sizeof(*rbd_dev), GFP_KERNEL);
+	if (!rbd_dev)
+		goto err_out_opt;
+
+	/* static rbd_device initialization */
+	spin_lock_init(&rbd_dev->lock);
+	INIT_LIST_HEAD(&rbd_dev->node);
+
+	/* generate unique id: find highest unique id, add one */
+	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
+
+	list_for_each(tmp, &rbddev_list) {
+		struct rbd_device *rbd_dev;
+
+		rbd_dev = list_entry(tmp, struct rbd_device, node);
+		if (rbd_dev->id >= new_id)
+			new_id = rbd_dev->id + 1;
+	}
+
+	rbd_dev->id = new_id;
+
+	/* add to global list */
+	list_add_tail(&rbd_dev->node, &rbddev_list);
+
+	/* parse add command */
+	if (sscanf(buf, "%" __stringify(RBD_MAX_OPT_LEN) "s "
+		   "%" __stringify(RBD_MAX_OPT_LEN) "s "
+		   "%d %" __stringify(RBD_MAX_OBJ_NAME_SIZE) "s",
+		   mon_dev_name, opt, &rbd_dev->poolid,
+		   rbd_dev->obj) != 4) {
+		rc = -EINVAL;
+		goto err_out_slot;
+	}
+
+	rbd_dev->obj_len = strlen(rbd_dev->obj);
+
+	/* initialize rest of new object */
+	snprintf(rbd_dev->name, DEV_NAME_LEN, "%d", rbd_dev->id);
+	rc = rbd_get_client(rbd_dev, mon_dev_name, opt);
+	if (rc < 0)
+		goto err_out_slot;
+
+	mutex_unlock(&ctl_mutex);
+
+	/* register our block device */
+	irc = register_blkdev(0, rbd_dev->name);
+	if (irc < 0) {
+		rc = irc;
+		goto err_out_slot;
+	}
+	rbd_dev->major = irc;
+
+	/* set up and announce blkdev mapping */
+	rc = rbd_init_disk(rbd_dev);
+	if (rc)
+		goto err_out_blkdev;
+
+	return count;
+
+err_out_blkdev:
+	unregister_blkdev(rbd_dev->major, rbd_dev->name);
+err_out_slot:
+	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
+	list_del_init(&rbd_dev->node);
+	mutex_unlock(&ctl_mutex);
+
+	kfree(rbd_dev);
+err_out_opt:
+	kfree(opt);
+err_mon_dev:
+	kfree(mon_dev_name);
+err_out_mod:
+	dout("Error adding device %s\n", buf);
+	module_put(THIS_MODULE);
+	return rc;
+}
+
+static ssize_t class_rbd_remove(struct class *c,
+				struct class_attribute *attr,
+				const char *buf,
+				size_t count)
+{
+	struct rbd_device *rbd_dev = NULL;
+	int target_id, rc;
+	unsigned long ul;
+	struct list_head *tmp;
+
+	rc = strict_strtoul(buf, 10, &ul);
+	if (rc)
+		return rc;
+
+	/* convert to int; abort if we lost anything in the conversion */
+	target_id = (int) ul;
+	if (target_id != ul)
+		return -EINVAL;
+
+	/* remove object from list immediately */
+	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
+
+	list_for_each(tmp, &rbddev_list) {
+		rbd_dev = list_entry(tmp, struct rbd_device, node);
+		if (rbd_dev->id == target_id) {
+			list_del_init(&rbd_dev->node);
+			break;
+		}
+		rbd_dev = NULL;
+	}
+
+	mutex_unlock(&ctl_mutex);
+
+	if (!rbd_dev)
+		return -ENOENT;
+
+	rbd_put_client(rbd_dev);
+
+	/* clean up and free blkdev and associated OSD connection */
+	rbd_free_disk(rbd_dev);
+	unregister_blkdev(rbd_dev->major, rbd_dev->name);
+	kfree(rbd_dev);
+
+	/* release module ref */
+	module_put(THIS_MODULE);
+
+	return count;
+}
+
+static struct class_attribute class_rbd_attrs[] = {
+	__ATTR(add,	0200, NULL, class_rbd_add),
+	__ATTR(remove,	0200, NULL, class_rbd_remove),
+	__ATTR(list,	0444, class_rbd_list, NULL),
+	__ATTR_NULL
+};
+
+/*
+ * create control files in sysfs
+ * /sys/class/rbd/...
+ */
+static int rbd_sysfs_init(void)
+{
+	int ret = -ENOMEM;
+
+	class_rbd = kzalloc(sizeof(*class_rbd), GFP_KERNEL);
+	if (!class_rbd)
+		goto out;
+
+	class_rbd->name = DRV_NAME;
+	class_rbd->owner = THIS_MODULE;
+	class_rbd->class_release = class_rbd_release;
+	class_rbd->class_attrs = class_rbd_attrs;
+
+	ret = class_register(class_rbd);
+	if (ret)
+		goto out_class;
+	return 0;
+
+out_class:
+	kfree(class_rbd);
+	class_rbd = NULL;
+	pr_err(DRV_NAME ": failed to create class rbd\n");
+out:
+	return ret;
+}
+
+static void rbd_sysfs_cleanup(void)
+{
+	if (class_rbd)
+		class_destroy(class_rbd);
+	class_rbd = NULL;
+}
+
+int __init rbd_init(void)
+{
+	int rc;
+
+	rc = rbd_sysfs_init();
+	if (rc)
+		return rc;
+	spin_lock_init(&node_lock);
+	pr_info("loaded " DRV_NAME_LONG);
+	return 0;
+}
+
+void __exit rbd_exit(void)
+{
+	rbd_sysfs_cleanup();
+}
diff --git a/fs/ceph/rbd.h b/fs/ceph/rbd.h
new file mode 100644
index 0000000..68e0a5c
--- /dev/null
+++ b/fs/ceph/rbd.h
@@ -0,0 +1,8 @@
+#ifndef _FS_CEPH_RBD
+#define _FS_CEPH_RBD
+
+extern void rbd_set_osdc(struct ceph_osd_client *o);
+extern int __init rbd_init(void);
+extern void __exit rbd_exit(void);
+
+#endif
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 52e9e86..9a73b25 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -17,6 +17,7 @@
 #include "super.h"
 #include "mon_client.h"
 #include "auth.h"
+#include "rbd.h"
 
 /*
  * Ceph superblock operations
@@ -1079,8 +1080,14 @@ static int __init init_ceph(void)
 	pr_info("loaded %d.%d.%d (mon/mds/osd proto %d/%d/%d)\n",
 		CEPH_VERSION_MAJOR, CEPH_VERSION_MINOR, CEPH_VERSION_PATCH,
 		CEPH_MONC_PROTOCOL, CEPH_MDSC_PROTOCOL, CEPH_OSDC_PROTOCOL);
+
+	ret = rbd_init();
+	if (ret)
+		goto out_fs;
 	return 0;
 
+out_fs:
+	unregister_filesystem(&ceph_fs_type);
 out_icache:
 	destroy_caches();
 out_msgr:
@@ -1094,6 +1101,7 @@ out:
 static void __exit exit_ceph(void)
 {
 	dout("exit_ceph\n");
+	rbd_exit();
 	unregister_filesystem(&ceph_fs_type);
 	ceph_caps_finalize();
 	destroy_caches();
-- 
1.5.6.5

