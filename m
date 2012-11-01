Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992507Ab2KAULW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:11:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934360Ab2KAULT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:11:19 -0400
From: Milan Broz <mbroz@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jaxboe@fusionio.com, kzak@redhat.com, Milan Broz <mbroz@redhat.com>
Subject: [RFC PATCH 4/4] Remove transfer module support in loop.
Date: Thu,  1 Nov 2012 21:11:04 +0100
Message-Id: <af49f38f1cc38f2f55a7bc1a25a11798b8e9ff75.1351799190.git.mbroz@redhat.com>
In-Reply-To: <cover.1351799189.git.mbroz@redhat.com>
References: <cover.1351799189.git.mbroz@redhat.com>
In-Reply-To: <cover.1351799189.git.mbroz@redhat.com>
References: <cover.1351799189.git.mbroz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove transfer function support from loop driver.
The only user for it is for years XOR "encryption" and cryptoloop.

If userspace request encryption, EINVAL is returned.
The userspace visible struct is unchanged (just marked deprecated),
so old userspace will just see ioctl failure if encryption is requested.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/block/loop.c |  344 +++++---------------------------------------------
 include/linux/loop.h |   31 -----
 2 files changed, 35 insertions(+), 340 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 54046e5..4025227 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -85,81 +85,6 @@ static DEFINE_MUTEX(loop_index_mutex);
 static int max_part;
 static int part_shift;
 
-/*
- * Transfer functions
- */
-static int transfer_none(struct loop_device *lo, int cmd,
-			 struct page *raw_page, unsigned raw_off,
-			 struct page *loop_page, unsigned loop_off,
-			 int size, sector_t real_block)
-{
-	char *raw_buf = kmap_atomic(raw_page) + raw_off;
-	char *loop_buf = kmap_atomic(loop_page) + loop_off;
-
-	if (cmd == READ)
-		memcpy(loop_buf, raw_buf, size);
-	else
-		memcpy(raw_buf, loop_buf, size);
-
-	kunmap_atomic(loop_buf);
-	kunmap_atomic(raw_buf);
-	cond_resched();
-	return 0;
-}
-
-static int transfer_xor(struct loop_device *lo, int cmd,
-			struct page *raw_page, unsigned raw_off,
-			struct page *loop_page, unsigned loop_off,
-			int size, sector_t real_block)
-{
-	char *raw_buf = kmap_atomic(raw_page) + raw_off;
-	char *loop_buf = kmap_atomic(loop_page) + loop_off;
-	char *in, *out, *key;
-	int i, keysize;
-
-	if (cmd == READ) {
-		in = raw_buf;
-		out = loop_buf;
-	} else {
-		in = loop_buf;
-		out = raw_buf;
-	}
-
-	key = lo->lo_encrypt_key;
-	keysize = lo->lo_encrypt_key_size;
-	for (i = 0; i < size; i++)
-		*out++ = *in++ ^ key[(i & 511) % keysize];
-
-	kunmap_atomic(loop_buf);
-	kunmap_atomic(raw_buf);
-	cond_resched();
-	return 0;
-}
-
-static int xor_init(struct loop_device *lo, const struct loop_info64 *info)
-{
-	if (unlikely(info->lo_encrypt_key_size <= 0))
-		return -EINVAL;
-	return 0;
-}
-
-static struct loop_func_table none_funcs = {
-	.number = LO_CRYPT_NONE,
-	.transfer = transfer_none,
-}; 	
-
-static struct loop_func_table xor_funcs = {
-	.number = LO_CRYPT_XOR,
-	.transfer = transfer_xor,
-	.init = xor_init
-}; 	
-
-/* xfer_funcs[0] is special - its release function is never called */
-static struct loop_func_table *xfer_funcs[MAX_LO_CRYPT] = {
-	&none_funcs,
-	&xor_funcs
-};
-
 static loff_t get_size(loff_t offset, loff_t sizelimit, struct file *file)
 {
 	loff_t size, loopsize;
@@ -205,12 +130,20 @@ static inline int
 lo_do_transfer(struct loop_device *lo, int cmd,
 	       struct page *rpage, unsigned roffs,
 	       struct page *lpage, unsigned loffs,
-	       int size, sector_t rblock)
+	       int size)
 {
-	if (unlikely(!lo->transfer))
-		return 0;
+	char *raw_buf = kmap_atomic(rpage) + roffs;
+	char *loop_buf = kmap_atomic(lpage) + loffs;
 
-	return lo->transfer(lo, cmd, rpage, roffs, lpage, loffs, size, rblock);
+	if (cmd == READ)
+		memcpy(loop_buf, raw_buf, size);
+	else
+		memcpy(raw_buf, loop_buf, size);
+
+	kunmap_atomic(loop_buf);
+	kunmap_atomic(raw_buf);
+	cond_resched();
+	return 0;
 }
 
 /**
@@ -244,7 +177,7 @@ static int __do_lo_send_write(struct file *file,
  * buffering.
  */
 static int do_lo_send_direct_write(struct loop_device *lo,
-		struct bio_vec *bvec, loff_t pos, struct page *page)
+		struct bio_vec *bvec, loff_t pos)
 {
 	ssize_t bw = __do_lo_send_write(lo->lo_backing_file,
 			kmap(bvec->bv_page) + bvec->bv_offset,
@@ -254,63 +187,19 @@ static int do_lo_send_direct_write(struct loop_device *lo,
 	return bw;
 }
 
-/**
- * do_lo_send_write - helper for writing data to a loop device
- *
- * This is the slow, transforming version that needs to double buffer the
- * data as it cannot do the transformations in place without having direct
- * access to the destination pages of the backing file.
- */
-static int do_lo_send_write(struct loop_device *lo, struct bio_vec *bvec,
-		loff_t pos, struct page *page)
-{
-	int ret = lo_do_transfer(lo, WRITE, page, 0, bvec->bv_page,
-			bvec->bv_offset, bvec->bv_len, pos >> 9);
-	if (likely(!ret))
-		return __do_lo_send_write(lo->lo_backing_file,
-				page_address(page), bvec->bv_len,
-				pos);
-	printk(KERN_ERR "loop: Transfer error at byte offset %llu, "
-			"length %i.\n", (unsigned long long)pos, bvec->bv_len);
-	if (ret > 0)
-		ret = -EIO;
-	return ret;
-}
-
 static int lo_send(struct loop_device *lo, struct bio *bio, loff_t pos)
 {
-	int (*do_lo_send)(struct loop_device *, struct bio_vec *, loff_t,
-			struct page *page);
 	struct bio_vec *bvec;
-	struct page *page = NULL;
 	int i, ret = 0;
 
-	if (lo->transfer != transfer_none) {
-		page = alloc_page(GFP_NOIO | __GFP_HIGHMEM);
-		if (unlikely(!page))
-			goto fail;
-		kmap(page);
-		do_lo_send = do_lo_send_write;
-	} else {
-		do_lo_send = do_lo_send_direct_write;
-	}
-
 	bio_for_each_segment(bvec, bio, i) {
-		ret = do_lo_send(lo, bvec, pos, page);
+		ret = do_lo_send_direct_write(lo, bvec, pos);
 		if (ret < 0)
 			break;
 		pos += bvec->bv_len;
 	}
-	if (page) {
-		kunmap(page);
-		__free_page(page);
-	}
-out:
+
 	return ret;
-fail:
-	printk(KERN_ERR "loop: Failed to allocate temporary page for write.\n");
-	ret = -ENOMEM;
-	goto out;
 }
 
 struct lo_read_data {
@@ -327,16 +216,13 @@ lo_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	struct lo_read_data *p = sd->u.data;
 	struct loop_device *lo = p->lo;
 	struct page *page = buf->page;
-	sector_t IV;
 	int size;
 
-	IV = ((sector_t) page->index << (PAGE_CACHE_SHIFT - 9)) +
-							(buf->offset >> 9);
 	size = sd->len;
 	if (size > p->bsize)
 		size = p->bsize;
 
-	if (lo_do_transfer(lo, READ, page, buf->offset, p->page, p->offset, size, IV)) {
+	if (lo_do_transfer(lo, READ, page, buf->offset, p->page, p->offset, size)) {
 		printk(KERN_ERR "loop: transfer error block %ld\n",
 		       page->index);
 		size = -EINVAL;
@@ -423,16 +309,13 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
 
 		/*
 		 * We use punch hole to reclaim the free space used by the
-		 * image a.k.a. discard. However we do not support discard if
-		 * encryption is enabled, because it may give an attacker
-		 * useful information.
+		 * image a.k.a. discard.
 		 */
 		if (bio->bi_rw & REQ_DISCARD) {
 			struct file *file = lo->lo_backing_file;
 			int mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
 
-			if ((!file->f_op->fallocate) ||
-			    lo->lo_encrypt_key_size) {
+			if (!file->f_op->fallocate) {
 				ret = -EOPNOTSUPP;
 				goto out;
 			}
@@ -519,9 +402,7 @@ static inline void loop_handle_bio(struct loop_device *lo, struct bio *bio)
 
 /*
  * worker thread that handles reads/writes to file backed loop devices,
- * to avoid blocking in our make_request_fn. it also does loop decrypting
- * on reads for block backed loop, as that is too heavy to do from
- * b_end_io context where irqs may be disabled.
+ * to avoid blocking in our make_request_fn.
  *
  * Loop explanation:  loop_clr_fd() sets lo_state to Lo_rundown before
  * calling kthread_stop().  Therefore once kthread_should_stop() is
@@ -783,12 +664,9 @@ static void loop_config_discard(struct loop_device *lo)
 
 	/*
 	 * We use punch hole to reclaim the free space used by the
-	 * image a.k.a. discard. However we do support discard if
-	 * encryption is enabled, because it may give an attacker
-	 * useful information.
+	 * image a.k.a. discard.
 	 */
-	if ((!file->f_op->fallocate) ||
-	    lo->lo_encrypt_key_size) {
+	if (!file->f_op->fallocate) {
 		q->limits.discard_granularity = 0;
 		q->limits.discard_alignment = 0;
 		q->limits.max_discard_sectors = 0;
@@ -870,8 +748,6 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	lo->lo_device = bdev;
 	lo->lo_flags = lo_flags;
 	lo->lo_backing_file = file;
-	lo->transfer = transfer_none;
-	lo->ioctl = NULL;
 	lo->lo_sizelimit = 0;
 	lo->old_gfp_mask = mapping_gfp_mask(mapping);
 	mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
@@ -930,43 +806,6 @@ out_clr:
 	return error;
 }
 
-static int
-loop_release_xfer(struct loop_device *lo)
-{
-	int err = 0;
-	struct loop_func_table *xfer = lo->lo_encryption;
-
-	if (xfer) {
-		if (xfer->release)
-			err = xfer->release(lo);
-		lo->transfer = NULL;
-		lo->lo_encryption = NULL;
-		module_put(xfer->owner);
-	}
-	return err;
-}
-
-static int
-loop_init_xfer(struct loop_device *lo, struct loop_func_table *xfer,
-	       const struct loop_info64 *i)
-{
-	int err = 0;
-
-	if (xfer) {
-		struct module *owner = xfer->owner;
-
-		if (!try_module_get(owner))
-			return -EINVAL;
-		if (xfer->init)
-			err = xfer->init(lo, i);
-		if (err)
-			module_put(owner);
-		else
-			lo->lo_encryption = xfer;
-	}
-	return err;
-}
-
 static int loop_clr_fd(struct loop_device *lo)
 {
 	struct file *filp = lo->lo_backing_file;
@@ -1005,17 +844,10 @@ static int loop_clr_fd(struct loop_device *lo)
 	lo->lo_backing_file = NULL;
 	spin_unlock_irq(&lo->lo_lock);
 
-	loop_release_xfer(lo);
-	lo->transfer = NULL;
-	lo->ioctl = NULL;
 	lo->lo_device = NULL;
-	lo->lo_encryption = NULL;
 	lo->lo_offset = 0;
 	lo->lo_sizelimit = 0;
-	lo->lo_encrypt_key_size = 0;
 	lo->lo_thread = NULL;
-	memset(lo->lo_encrypt_key, 0, LO_KEY_SIZE);
-	memset(lo->lo_crypt_name, 0, LO_NAME_SIZE);
 	memset(lo->lo_file_name, 0, LO_NAME_SIZE);
 	if (bdev)
 		invalidate_bdev(bdev);
@@ -1049,38 +881,9 @@ static int loop_clr_fd(struct loop_device *lo)
 static int
 loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 {
-	int err;
-	struct loop_func_table *xfer;
-	kuid_t uid = current_uid();
-
-	if (lo->lo_encrypt_key_size &&
-	    !uid_eq(lo->lo_key_owner, uid) &&
-	    !capable(CAP_SYS_ADMIN))
-		return -EPERM;
-	if (lo->lo_state != Lo_bound)
-		return -ENXIO;
-	if ((unsigned int) info->lo_encrypt_key_size > LO_KEY_SIZE)
+	if (info->lo_encrypt_key_size || info->lo_encrypt_type != LO_CRYPT_NONE)
 		return -EINVAL;
 
-	err = loop_release_xfer(lo);
-	if (err)
-		return err;
-
-	if (info->lo_encrypt_type) {
-		unsigned int type = info->lo_encrypt_type;
-
-		if (type >= MAX_LO_CRYPT)
-			return -EINVAL;
-		xfer = xfer_funcs[type];
-		if (xfer == NULL)
-			return -EINVAL;
-	} else
-		xfer = NULL;
-
-	err = loop_init_xfer(lo, xfer, info);
-	if (err)
-		return err;
-
 	if (lo->lo_offset != info->lo_offset ||
 	    lo->lo_sizelimit != info->lo_sizelimit) {
 		if (figure_loop_size(lo, info->lo_offset, info->lo_sizelimit))
@@ -1089,14 +892,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	loop_config_discard(lo);
 
 	memcpy(lo->lo_file_name, info->lo_file_name, LO_NAME_SIZE);
-	memcpy(lo->lo_crypt_name, info->lo_crypt_name, LO_NAME_SIZE);
 	lo->lo_file_name[LO_NAME_SIZE-1] = 0;
-	lo->lo_crypt_name[LO_NAME_SIZE-1] = 0;
-
-	if (!xfer)
-		xfer = &none_funcs;
-	lo->transfer = xfer->transfer;
-	lo->ioctl = xfer->ioctl;
 
 	if ((lo->lo_flags & LO_FLAGS_AUTOCLEAR) !=
 	     (info->lo_flags & LO_FLAGS_AUTOCLEAR))
@@ -1109,14 +905,8 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 		ioctl_by_bdev(lo->lo_device, BLKRRPART, 0);
 	}
 
-	lo->lo_encrypt_key_size = info->lo_encrypt_key_size;
 	lo->lo_init[0] = info->lo_init[0];
 	lo->lo_init[1] = info->lo_init[1];
-	if (info->lo_encrypt_key_size) {
-		memcpy(lo->lo_encrypt_key, info->lo_encrypt_key,
-		       info->lo_encrypt_key_size);
-		lo->lo_key_owner = uid;
-	}	
 
 	return 0;
 }
@@ -1142,20 +932,15 @@ loop_get_status(struct loop_device *lo, struct loop_info64 *info)
 	info->lo_sizelimit = lo->lo_sizelimit;
 	info->lo_flags = lo->lo_flags;
 	memcpy(info->lo_file_name, lo->lo_file_name, LO_NAME_SIZE);
-	memcpy(info->lo_crypt_name, lo->lo_crypt_name, LO_NAME_SIZE);
-	info->lo_encrypt_type =
-		lo->lo_encryption ? lo->lo_encryption->number : 0;
-	if (lo->lo_encrypt_key_size && capable(CAP_SYS_ADMIN)) {
-		info->lo_encrypt_key_size = lo->lo_encrypt_key_size;
-		memcpy(info->lo_encrypt_key, lo->lo_encrypt_key,
-		       lo->lo_encrypt_key_size);
-	}
 	return 0;
 }
 
-static void
+static int
 loop_info64_from_old(const struct loop_info *info, struct loop_info64 *info64)
 {
+	if (info->lo_encrypt_key_size || info->lo_encrypt_type != LO_CRYPT_NONE)
+		return -EINVAL;
+
 	memset(info64, 0, sizeof(*info64));
 	info64->lo_number = info->lo_number;
 	info64->lo_device = info->lo_device;
@@ -1163,16 +948,10 @@ loop_info64_from_old(const struct loop_info *info, struct loop_info64 *info64)
 	info64->lo_rdevice = info->lo_rdevice;
 	info64->lo_offset = info->lo_offset;
 	info64->lo_sizelimit = 0;
-	info64->lo_encrypt_type = info->lo_encrypt_type;
-	info64->lo_encrypt_key_size = info->lo_encrypt_key_size;
 	info64->lo_flags = info->lo_flags;
 	info64->lo_init[0] = info->lo_init[0];
 	info64->lo_init[1] = info->lo_init[1];
-	if (info->lo_encrypt_type == LO_CRYPT_CRYPTOAPI)
-		memcpy(info64->lo_crypt_name, info->lo_name, LO_NAME_SIZE);
-	else
-		memcpy(info64->lo_file_name, info->lo_name, LO_NAME_SIZE);
-	memcpy(info64->lo_encrypt_key, info->lo_encrypt_key, LO_KEY_SIZE);
+	return 0;
 }
 
 static int
@@ -1184,16 +963,9 @@ loop_info64_to_old(const struct loop_info64 *info64, struct loop_info *info)
 	info->lo_inode = info64->lo_inode;
 	info->lo_rdevice = info64->lo_rdevice;
 	info->lo_offset = info64->lo_offset;
-	info->lo_encrypt_type = info64->lo_encrypt_type;
-	info->lo_encrypt_key_size = info64->lo_encrypt_key_size;
 	info->lo_flags = info64->lo_flags;
 	info->lo_init[0] = info64->lo_init[0];
 	info->lo_init[1] = info64->lo_init[1];
-	if (info->lo_encrypt_type == LO_CRYPT_CRYPTOAPI)
-		memcpy(info->lo_name, info64->lo_crypt_name, LO_NAME_SIZE);
-	else
-		memcpy(info->lo_name, info64->lo_file_name, LO_NAME_SIZE);
-	memcpy(info->lo_encrypt_key, info64->lo_encrypt_key, LO_KEY_SIZE);
 
 	/* error in case values were truncated */
 	if (info->lo_device != info64->lo_device ||
@@ -1210,10 +982,13 @@ loop_set_status_old(struct loop_device *lo, const struct loop_info __user *arg)
 {
 	struct loop_info info;
 	struct loop_info64 info64;
+	int ret;
 
 	if (copy_from_user(&info, arg, sizeof (struct loop_info)))
 		return -EFAULT;
-	loop_info64_from_old(&info, &info64);
+	ret = loop_info64_from_old(&info, &info64);
+	if (ret < 0)
+		return ret;
 	return loop_set_status(lo, &info64);
 }
 
@@ -1330,7 +1105,7 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 			err = loop_set_capacity(lo, bdev);
 		break;
 	default:
-		err = lo->ioctl ? lo->ioctl(lo, cmd, arg) : -EINVAL;
+		err = -EINVAL;
 	}
 	mutex_unlock(&lo->lo_ctl_mutex);
 
@@ -1367,6 +1142,9 @@ loop_info64_from_compat(const struct compat_loop_info __user *arg,
 	if (copy_from_user(&info, arg, sizeof(info)))
 		return -EFAULT;
 
+	if (info.lo_encrypt_key_size || info.lo_encrypt_type != LO_CRYPT_NONE)
+		return -EINVAL;
+
 	memset(info64, 0, sizeof(*info64));
 	info64->lo_number = info.lo_number;
 	info64->lo_device = info.lo_device;
@@ -1374,16 +1152,9 @@ loop_info64_from_compat(const struct compat_loop_info __user *arg,
 	info64->lo_rdevice = info.lo_rdevice;
 	info64->lo_offset = info.lo_offset;
 	info64->lo_sizelimit = 0;
-	info64->lo_encrypt_type = info.lo_encrypt_type;
-	info64->lo_encrypt_key_size = info.lo_encrypt_key_size;
 	info64->lo_flags = info.lo_flags;
 	info64->lo_init[0] = info.lo_init[0];
 	info64->lo_init[1] = info.lo_init[1];
-	if (info.lo_encrypt_type == LO_CRYPT_CRYPTOAPI)
-		memcpy(info64->lo_crypt_name, info.lo_name, LO_NAME_SIZE);
-	else
-		memcpy(info64->lo_file_name, info.lo_name, LO_NAME_SIZE);
-	memcpy(info64->lo_encrypt_key, info.lo_encrypt_key, LO_KEY_SIZE);
 	return 0;
 }
 
@@ -1403,16 +1174,9 @@ loop_info64_to_compat(const struct loop_info64 *info64,
 	info.lo_inode = info64->lo_inode;
 	info.lo_rdevice = info64->lo_rdevice;
 	info.lo_offset = info64->lo_offset;
-	info.lo_encrypt_type = info64->lo_encrypt_type;
-	info.lo_encrypt_key_size = info64->lo_encrypt_key_size;
 	info.lo_flags = info64->lo_flags;
 	info.lo_init[0] = info64->lo_init[0];
 	info.lo_init[1] = info64->lo_init[1];
-	if (info.lo_encrypt_type == LO_CRYPT_CRYPTOAPI)
-		memcpy(info.lo_name, info64->lo_crypt_name, LO_NAME_SIZE);
-	else
-		memcpy(info.lo_name, info64->lo_file_name, LO_NAME_SIZE);
-	memcpy(info.lo_encrypt_key, info64->lo_encrypt_key, LO_KEY_SIZE);
 
 	/* error in case values were truncated */
 	if (info.lo_device != info64->lo_device ||
@@ -1566,44 +1330,6 @@ MODULE_PARM_DESC(max_part, "Maximum number of partitions per loop device");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);
 
-int loop_register_transfer(struct loop_func_table *funcs)
-{
-	unsigned int n = funcs->number;
-
-	if (n >= MAX_LO_CRYPT || xfer_funcs[n])
-		return -EINVAL;
-	xfer_funcs[n] = funcs;
-	return 0;
-}
-
-static int unregister_transfer_cb(int id, void *ptr, void *data)
-{
-	struct loop_device *lo = ptr;
-	struct loop_func_table *xfer = data;
-
-	mutex_lock(&lo->lo_ctl_mutex);
-	if (lo->lo_encryption == xfer)
-		loop_release_xfer(lo);
-	mutex_unlock(&lo->lo_ctl_mutex);
-	return 0;
-}
-
-int loop_unregister_transfer(int number)
-{
-	unsigned int n = number;
-	struct loop_func_table *xfer;
-
-	if (n == 0 || n >= MAX_LO_CRYPT || (xfer = xfer_funcs[n]) == NULL)
-		return -EINVAL;
-
-	xfer_funcs[n] = NULL;
-	idr_for_each(&loop_index_idr, &unregister_transfer_cb, xfer);
-	return 0;
-}
-
-EXPORT_SYMBOL(loop_register_transfer);
-EXPORT_SYMBOL(loop_unregister_transfer);
-
 static int loop_add(struct loop_device **l, int i)
 {
 	struct loop_device *lo;
diff --git a/include/linux/loop.h b/include/linux/loop.h
index 6492181..3b9017d 100644
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -22,32 +22,18 @@ enum {
 	Lo_rundown,
 };
 
-struct loop_func_table;
-
 struct loop_device {
 	int		lo_number;
 	int		lo_refcnt;
 	loff_t		lo_offset;
 	loff_t		lo_sizelimit;
 	int		lo_flags;
-	int		(*transfer)(struct loop_device *, int cmd,
-				    struct page *raw_page, unsigned raw_off,
-				    struct page *loop_page, unsigned loop_off,
-				    int size, sector_t real_block);
 	char		lo_file_name[LO_NAME_SIZE];
-	char		lo_crypt_name[LO_NAME_SIZE];
-	char		lo_encrypt_key[LO_KEY_SIZE];
-	int		lo_encrypt_key_size;
-	struct loop_func_table *lo_encryption;
 	__u32           lo_init[2];
-	kuid_t		lo_key_owner;	/* Who set the key */
-	int		(*ioctl)(struct loop_device *, int cmd, 
-				 unsigned long arg); 
 
 	struct file *	lo_backing_file;
 	struct block_device *lo_device;
 	unsigned	lo_blocksize;
-	void		*key_data; 
 
 	gfp_t		old_gfp_mask;
 
@@ -62,21 +48,4 @@ struct loop_device {
 	struct gendisk		*lo_disk;
 };
 
-/* Support for loadable transfer modules */
-struct loop_func_table {
-	int number;	/* filter type */ 
-	int (*transfer)(struct loop_device *lo, int cmd,
-			struct page *raw_page, unsigned raw_off,
-			struct page *loop_page, unsigned loop_off,
-			int size, sector_t real_block);
-	int (*init)(struct loop_device *, const struct loop_info64 *); 
-	/* release is called from loop_unregister_transfer or clr_fd */
-	int (*release)(struct loop_device *); 
-	int (*ioctl)(struct loop_device *, int cmd, unsigned long arg);
-	struct module *owner;
-}; 
-
-int loop_register_transfer(struct loop_func_table *funcs);
-int loop_unregister_transfer(int number); 
-
 #endif
-- 
1.7.10.4

