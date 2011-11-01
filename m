Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab1KAI5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 04:57:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36582 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab1KAI5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 04:57:22 -0400
From: Zhu Yanhai <zhu.yanhai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: bcrl@kvack.org, viro@zeniv.linux.org.uk, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, jaxboe@fusionio.com,
        Zhu Yanhai <gaoyang.zyh@taobao.com>
Subject: [PATCH][RFC] A readahead complete notify approach to implement buffer aio
Date: Tue,  1 Nov 2011 17:00:24 +0800
Message-Id: <1320138024-10837-1-git-send-email-gaoyang.zyh@taobao.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current libaio/aio has to be Direct-IO, otherwise it falls back into sync IO.
However, the aio core has already been asychronous naturally. This patch adds a complete
notify mechanism to implement buffer aio, the main idea is to readahead()-like in
io_submit(), counts the non-uptodated pages assocaiated with each iocb, then put each ref
in the bio complete path just before unlock_page(), and hook them on to the aio ring buffer
finally when the ref drops to zero. In io_getevents(), we call vfs_read() as a safe net
since there is still little possibility that the pages had brought in were reclaimed
between io_submit() and io_getevents().

I have tested this patch for a while, for the small size random io request, its
performance is more or less the same with the traditional aio, for the big io request,
the overhead of one extra memory copy arises.

I think so far it has at least below obvious drawbacks,

* mpage_readpage() is a really narrow interface, I have no way to pass down
the new control struct baiocb, so I just put it into struct task_struct and
refer it by current() as a workaround.

* the do_baio_read() routine is heavily similar with do_generic_file_read(), but
the latter is really hard to modify. I think we may stuff these code down into the
readahead path to reduce code reduplication.

Hopefully the explanations are clear enough and don't muddy the water any worse.
I figure the code does need some better comments, and any suggestion are welcome.

Signed-off-by: Zhu Yanhai <gaoyang.zyh@taobao.com>

---
 fs/aio.c                    |  319 ++++++++++++++++++++++++++++++++++++++++++-
 fs/buffer.c                 |   26 ++++-
 fs/mpage.c                  |   28 ++++-
 include/linux/aio.h         |    9 ++
 include/linux/aio_abi.h     |    1 +
 include/linux/blk_types.h   |    2 +
 include/linux/buffer_head.h |    3 +
 include/linux/page-flags.h  |    2 +
 include/linux/sched.h       |    1 +
 9 files changed, 386 insertions(+), 5 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index e29ec48..19fc95e 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -53,6 +53,7 @@ unsigned long aio_max_nr = 0x10000; /* system wide maximum number of aio request

 static struct kmem_cache	*kiocb_cachep;
 static struct kmem_cache	*kioctx_cachep;
+static struct kmem_cache	*ba_iocb_cachep;

 static struct workqueue_struct *aio_wq;

@@ -75,6 +76,7 @@ static int __init aio_setup(void)
	kiocb_cachep = KMEM_CACHE(kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);

+	ba_iocb_cachep = KMEM_CACHE(ba_iocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
	aio_wq = alloc_workqueue("aio", 0, 1);	/* used to limit concurrency */
	BUG_ON(!aio_wq);

@@ -1074,19 +1076,79 @@ static inline void clear_timeout(struct aio_timeout *to)
	del_singleshot_timer_sync(&to->timer);
 }

+static int baio_vfs_read(unsigned int fd, char __user *buf,
+		size_t count, loff_t pos)
+{
+	struct file *file;
+	ssize_t ret = -EBADF;
+	int fput_needed;
+
+	file = fget_light(fd, &fput_needed);
+	if (file) {
+		ret = vfs_read(file, buf, count, &pos);
+		fput_light(file, fput_needed);
+	}
+
+	return ret;
+}
+static int baio_read_to_user(struct io_event *ent)
+{
+	struct iocb __user *user_iocb;
+	struct iocb tmp;
+	int ret;
+
+	user_iocb = (struct iocb *)(ent->obj);
+	if (unlikely(copy_from_user(&tmp, user_iocb, sizeof(tmp)))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	ret = baio_vfs_read(tmp.aio_fildes, (char *)tmp.aio_buf,
+			tmp.aio_nbytes, tmp.aio_offset);
+
+out:
+	return ret;
+}
+
+/*
+ * return 1 if ent->obj points to a buffer aio's iocb.
+ * 0 if it's not.
+ */
+static int check_baio(struct io_event *ent)
+{
+	struct iocb __user *user_iocb;
+	struct iocb tmp;
+	int ret;
+	user_iocb = (struct iocb *)ent->obj;
+	if (unlikely(copy_from_user(&tmp, user_iocb, sizeof(tmp)))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (tmp.aio_lio_opcode == IOCB_CMD_BAIO_PREAD)
+		ret = 1;
+	else
+		ret = 0;
+out:
+	return ret;
+
+}
 static int read_events(struct kioctx *ctx,
			long min_nr, long nr,
			struct io_event __user *event,
			struct timespec __user *timeout)
+
 {
	long			start_jiffies = jiffies;
	struct task_struct	*tsk = current;
	DECLARE_WAITQUEUE(wait, tsk);
	int			ret;
+	int			ret2;
	int			i = 0;
	struct io_event		ent;
	struct aio_timeout	to;
	int			retry = 0;
+	int			is_baio = 0;

	/* needed to zero any padding within an entry (there shouldn't be
	 * any, but C is fun!
@@ -1101,7 +1163,21 @@ retry:

		dprintk("read event: %Lx %Lx %Lx %Lx\n",
			ent.data, ent.obj, ent.res, ent.res2);
+		is_baio = check_baio(&ent);
+		if (unlikely(is_baio < 0)) {
+			ret = is_baio;
+			break;
+		}

+		if (is_baio) {
+			ret2 = baio_read_to_user(&ent);
+			if (unlikely(ret2 < 0)) {
+				ret = ret2;
+				dprintk("fail in baio_read_to_user: %d\n", ret);
+				break;
+			}
+			ent.res = ret2;
+		}
		/* Could we split the check in two? */
		ret = -EFAULT;
		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
@@ -1167,12 +1243,27 @@ retry:
			/*ret = aio_read_evt(ctx, &ent);*/
		} while (1) ;

+
		set_task_state(tsk, TASK_RUNNING);
		remove_wait_queue(&ctx->wait, &wait);

		if (unlikely(ret <= 0))
			break;

+		is_baio = check_baio(&ent);
+		if (unlikely(is_baio < 0)) {
+			ret = is_baio;
+			break;
+		}
+		if (is_baio) {
+			ret2 = baio_read_to_user(&ent);
+			if (unlikely(ret2 < 0)) {
+				ret = ret2;
+				dprintk("fail in baio_read_to_user: %d\n", ret);
+				break;
+			}
+			ent.res = ret2;
+		}
		ret = -EFAULT;
		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
			dprintk("aio: lost an event due to EFAULT.\n");
@@ -1284,6 +1375,32 @@ SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
	return -EINVAL;
 }

+
+void baio_complete(struct ba_iocb *baiocb)
+{
+	ssize_t ret = 0;
+	if (baiocb->io_error)
+		ret = baiocb->io_error;
+	if (ret == 0)
+		ret = baiocb->result;
+	dprintk("baio_complete: io_error: %d, result: %d\n",
+			baiocb->io_error, baiocb->result);
+
+	aio_complete(baiocb->iocb, ret, 0);
+
+}
+
+void baiocb_put(struct ba_iocb *baiocb)
+{
+	BUG_ON(!baiocb);
+	dprintk("baiocb_put: ref: %d\n", atomic_read(&baiocb->ref));
+	if (atomic_dec_and_test(&baiocb->ref)) {
+		baio_complete(baiocb);
+		kmem_cache_free(ba_iocb_cachep, baiocb);
+	}
+}
+EXPORT_SYMBOL(baiocb_put);
+
 static void aio_advance_iovec(struct kiocb *iocb, ssize_t ret)
 {
	struct iovec *iov = &iocb->ki_iovec[iocb->ki_cur_seg];
@@ -1306,7 +1423,202 @@ static void aio_advance_iovec(struct kiocb *iocb, ssize_t ret)
	 * the remaining iovecs */
	BUG_ON(ret > 0 && iocb->ki_left == 0);
 }
+#define list_to_page(head) (list_entry((head)->prev, struct page, lru))
+
+
+
+static void init_baiocb(struct ba_iocb *baiocb, struct kiocb *iocb)
+{
+	atomic_set(&baiocb->ref, 1);
+	baiocb->iocb = iocb;
+	baiocb->io_error = 0;
+	baiocb->result = 0;
+
+}
+static inline void baiocb_get(struct ba_iocb *baiocb)
+{
+	BUG_ON(!baiocb);
+	atomic_add(1, &baiocb->ref);
+	pr_debug("baiocb_add: ref: %d\n", atomic_read(&baiocb->ref));
+}
+
+
+/*
+ * Return value is in desc->error, return the submitted bytes
+ * to read on success,
+ * In fact the exact value doesn't matter because it will be
+ * ignored in upper level aio_run_iocb() in the async path,
+ * and our code won't be envolved in the sync path
+ * anyway.
+ */
+void do_baio_read(struct file *file, struct kiocb *iocb, loff_t *ppos,
+		read_descriptor_t *desc)
+{
+	loff_t first_page_read_size;
+	size_t count = desc->count;
+	struct ba_iocb *baiocb;
+
+	unsigned long nr_pages_to_read, page_idx;
+	ssize_t ret = 0;
+	struct address_space *mapping;
+	struct inode *inode;
+	pgoff_t start, end, end_index;
+	loff_t isize;
+	LIST_HEAD(page_pool);
+	struct page *page;
+
+
+	start = *ppos >> PAGE_CACHE_SHIFT;
+	end = (*ppos + count - 1) >> PAGE_CACHE_SHIFT;
+	nr_pages_to_read = end - start + 1;
+	desc->error = 0;
+
+	first_page_read_size = PAGE_CACHE_SIZE - (*ppos & ~PAGE_CACHE_MASK);
+
+	mapping = file->f_mapping;
+	if (unlikely(!mapping->a_ops->readpage)) {
+		desc->error = -EINVAL;
+		return;
+	}
+
+	baiocb = kmem_cache_alloc(ba_iocb_cachep, GFP_KERNEL);
+	if (unlikely(!baiocb)) {
+		desc->error = -ENOMEM;
+		return;
+	}
+	 /* allocate ba_iocb with one ref. */
+	init_baiocb(baiocb, iocb);
+	current->current_baiocb = baiocb;
+
+	inode = mapping->host;
+	isize = i_size_read(inode);
+	end_index = ((isize - 1) >> PAGE_CACHE_SHIFT);

+	for (page_idx = 0; page_idx < nr_pages_to_read; page_idx++) {
+		pgoff_t page_offset = start + page_idx;
+		unsigned long nr;
+
+		if (page_offset > end_index)
+			break;
+
+		nr = PAGE_CACHE_SIZE;
+		if (page_idx == 0)
+			nr = first_page_read_size;
+		if (count < nr)
+			nr = count;
+		count -= nr;
+find_page:
+		page = find_get_page(mapping, page_offset);
+
+		pr_debug("To read %d bytes\n", nr);
+		if (page) {
+			ret = lock_page_killable(page);
+			if (unlikely(ret)) {
+				page_cache_release(page);
+				desc->error = ret;
+				goto out;
+			}
+			if(PageUptodate(page)) {
+				/* This won't go for IO. */
+				pr_debug("To baiocb_put as page is uptodated.\n");
+				unlock_page(page);
+				page_cache_release(page);
+				/* Avoid to be reclaimed. This is not good.
+				 * Todo: get_page, then make some page pool, release
+				 * them after all bios are finished.
+				 */
+				/* mark_page_accessed(page); */
+				desc->written += nr;
+				continue;
+			}
+			if (PageError(page))
+				ClearPageError(page);
+		} else {
+			page = page_cache_alloc_cold(mapping);
+			if (!page) {
+				desc->error = -ENOMEM;
+				goto out;
+			}
+
+			ret = add_to_page_cache_lru(page, mapping,
+				page_offset, GFP_KERNEL);
+			if (ret) {
+				page_cache_release(page);
+				if (ret == -EEXIST) {
+					pr_debug("to baiocb_put as it's there\n");
+					ret = 0;
+				} else {
+					pr_debug("error in add_to_page_cache_lru\n");
+					desc->error = ret;
+					goto out;
+				}
+			}
+		}
+		/* We hold an extra ref to the page after above, also the page
+		 * has been locked
+		 */
+		BUG_ON(!page);
+		BUG_ON(!PageLocked(page));
+		SetPageBaio(page);
+		pr_debug("To readpage() %d\n", page_idx);
+		baiocb_get(baiocb);
+		ret = mapping->a_ops->readpage(file, page);
+		if (unlikely(ret)) {
+			baiocb_put(baiocb);
+			if (ret == AOP_TRUNCATED_PAGE) {
+				/* The AOP method that was handed a locked page
+				 * has unlocked it. We just release the refcount
+				 */
+				ClearPageBaio(page);
+				page_cache_release(page);
+				goto find_page;
+			}
+			desc->error = ret;
+			goto out;
+		}
+		page_cache_release(page);
+	}
+out:
+	pr_debug("To the finial baiocb_put()\n");
+	baiocb_put(baiocb);
+	current->current_baiocb = NULL;
+	return;
+
+}
+
+/*
+ * return -EIOCBQUEUED on success. The exact number of bytes are
+ * ignored by the upper level caller. At least we don't have to
+ * make it very precise at ths moment.
+ */
+ssize_t
+baio_read(struct kiocb *iocb, const struct iovec *iov,
+		unsigned long nr_segs, loff_t pos)
+{
+	int seg = 0;
+	ssize_t written = 0;
+	loff_t *ppos;
+
+	BUG_ON(!iocb);
+	ppos = &iocb->ki_pos;
+	for (seg = 0; seg < nr_segs; seg++) {
+		read_descriptor_t desc;
+		desc.written = 0;
+		desc.arg.buf = iov[seg].iov_base;
+		desc.count = iov[seg].iov_len;
+		if (desc.count == 0)
+			continue;
+		desc.error = 0;
+		do_baio_read(iocb->ki_filp, iocb, ppos, &desc);
+		written += desc.written;
+
+		if (desc.error) {
+			written = written ? : desc.error;
+			break;
+		}
+	}
+	return (written < 0) ? written : -EIOCBQUEUED;
+}
 static ssize_t aio_rw_vect_retry(struct kiocb *iocb)
 {
	struct file *file = iocb->ki_filp;
@@ -1321,6 +1633,9 @@ static ssize_t aio_rw_vect_retry(struct kiocb *iocb)
		(iocb->ki_opcode == IOCB_CMD_PREAD)) {
		rw_op = file->f_op->aio_read;
		opcode = IOCB_CMD_PREADV;
+	} else if (iocb->ki_opcode == IOCB_CMD_BAIO_PREAD) {
+		rw_op = baio_read;
+		opcode = IOCB_CMD_BAIO_PREAD;
	} else {
		rw_op = file->f_op->aio_write;
		opcode = IOCB_CMD_PWRITEV;
@@ -1429,6 +1744,7 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
	ssize_t ret = 0;

	switch (kiocb->ki_opcode) {
+	case IOCB_CMD_BAIO_PREAD:
	case IOCB_CMD_PREAD:
		ret = -EBADF;
		if (unlikely(!(file->f_mode & FMODE_READ)))
@@ -1794,6 +2110,7 @@ SYSCALL_DEFINE5(io_getevents, aio_context_t, ctx_id,
		put_ioctx(ioctx);
	}

-	asmlinkage_protect(5, ret, ctx_id, min_nr, nr, events, timeout);
+	asmlinkage_protect(5, ret, ctx_id, min_nr, nr,
+		events, timeout);
	return ret;
 }
diff --git a/fs/buffer.c b/fs/buffer.c
index 1a80b04..26d2bfe 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -52,6 +52,7 @@ init_buffer(struct buffer_head *bh, bh_end_io_t *handler, void *private)
 {
	bh->b_end_io = handler;
	bh->b_private = private;
+	bh->b_private2 = NULL;
 }
 EXPORT_SYMBOL(init_buffer);

@@ -309,7 +310,7 @@ static void end_buffer_async_read(struct buffer_head *bh, int uptodate)
	struct buffer_head *tmp;
	struct page *page;
	int page_uptodate = 1;
-
+	struct ba_iocb *baiocb;
	BUG_ON(!buffer_async_read(bh));

	page = bh->b_page;
@@ -351,6 +352,18 @@ static void end_buffer_async_read(struct buffer_head *bh, int uptodate)
	 */
	if (page_uptodate && !PageError(page))
		SetPageUptodate(page);
+
+	baiocb = (struct ba_iocb *)bh->b_private2;
+	BUG_ON(baiocb && !PageBaio(page));
+	BUG_ON(!baiocb && PageBaio(page));
+
+	if (baiocb && PageBaio(page)) {
+		ClearPageBaio(page);
+		if (!page_uptodate || PageError(page))
+			baiocb->io_error = -EIO;
+		baiocb->result += PAGE_SIZE;
+		baiocb_put(baiocb);
+	}
	unlock_page(page);
	return;

@@ -2159,6 +2172,8 @@ int block_read_full_page(struct page *page, get_block_t *get_block)
		 */
		if (!PageError(page))
			SetPageUptodate(page);
+		if (PageBaio(page))
+			baiocb_put(current->current_baiocb);
		unlock_page(page);
		return 0;
	}
@@ -2902,7 +2917,11 @@ static void end_bio_bh_io_sync(struct bio *bio, int err)
	if (unlikely (test_bit(BIO_QUIET,&bio->bi_flags)))
		set_bit(BH_Quiet, &bh->b_state);

+	if (bio_flagged(bio, BIO_BAIO))
+		bh->b_private2 = (void *)bio->bi_private2;
+
	bh->b_end_io(bh, test_bit(BIO_UPTODATE, &bio->bi_flags));
+	clear_bit(BIO_BAIO, &bio->bi_flags);
	bio_put(bio);
 }

@@ -2942,6 +2961,11 @@ int submit_bh(int rw, struct buffer_head * bh)
	bio->bi_end_io = end_bio_bh_io_sync;
	bio->bi_private = bh;

+	if (PageBaio(bh->b_page)) {
+		set_bit(BIO_BAIO, &bio->bi_flags);
+		bio->bi_private2 = (void *)current->current_baiocb;
+	}
+
	bio_get(bio);
	submit_bio(rw, bio);

diff --git a/fs/mpage.c b/fs/mpage.c
index fdfae9f..6bcfbed 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -58,6 +58,16 @@ static void mpage_end_io(struct bio *bio, int err)
				ClearPageUptodate(page);
				SetPageError(page);
			}
+			if (bio_flagged(bio, BIO_BAIO) && PageBaio(page)) {
+				struct ba_iocb *baiocb =
+					(struct ba_iocb *)bio->bi_private2;
+				clear_bit(BIO_BAIO, &bio->bi_flags);
+				ClearPageBaio(page);
+				if (!uptodate)
+					baiocb->io_error = -EIO;
+				baiocb->result += bvec->bv_len;
+				baiocb_put(baiocb);
+			}
			unlock_page(page);
		} else { /* bio_data_dir(bio) == WRITE */
			if (!uptodate) {
@@ -167,11 +177,12 @@ do_mpage_readpage(struct bio *bio, struct page *page, unsigned nr_pages,
	unsigned page_block;
	unsigned first_hole = blocks_per_page;
	struct block_device *bdev = NULL;
-	int length;
+	int length, bio_length;
	int fully_mapped = 1;
	unsigned nblocks;
	unsigned relative_block;

+
	if (page_has_buffers(page))
		goto confused;

@@ -265,6 +276,8 @@ do_mpage_readpage(struct bio *bio, struct page *page, unsigned nr_pages,
		zero_user_segment(page, first_hole << blkbits, PAGE_CACHE_SIZE);
		if (first_hole == 0) {
			SetPageUptodate(page);
+			if (PageBaio(page))
+				baiocb_put(current->current_baiocb);
			unlock_page(page);
			goto out;
		}
@@ -294,7 +307,13 @@ alloc_new:
	}

	length = first_hole << blkbits;
-	if (bio_add_page(bio, page, length, 0) < length) {
+	bio_length = bio_add_page(bio, page, length, 0);
+	if (PageBaio(page)) {
+		bio->bi_private2 = (void *)current->current_baiocb;
+		set_bit(BIO_BAIO, &bio->bi_flags);
+	}
+
+	if (bio_length < length) {
		bio = mpage_bio_submit(READ, bio);
		goto alloc_new;
	}
@@ -314,8 +333,11 @@ confused:
		bio = mpage_bio_submit(READ, bio);
	if (!PageUptodate(page))
	        block_read_full_page(page, get_block);
-	else
+	else {
+		if (PageBaio(page))
+			baiocb_put(current->current_baiocb);
		unlock_page(page);
+    }
	goto out;
 }

diff --git a/include/linux/aio.h b/include/linux/aio.h
index 2dcb72b..36ce4f2 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -202,6 +202,13 @@ struct kioctx {
	struct rcu_head		rcu_head;
 };

+struct ba_iocb {
+	atomic_t		ref;
+	struct kiocb		*iocb;
+	int			io_error;
+	ssize_t			result;
+};
+
 /* prototypes */
 extern unsigned aio_max_size;

@@ -214,6 +221,7 @@ struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
 extern long do_io_submit(aio_context_t ctx_id, long nr,
			 struct iocb __user *__user *iocbpp, bool compat);
+extern void baiocb_put(struct ba_iocb *baiocb);
 #else
 static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
 static inline int aio_put_req(struct kiocb *iocb) { return 0; }
@@ -224,6 +232,7 @@ static inline void exit_aio(struct mm_struct *mm) { }
 static inline long do_io_submit(aio_context_t ctx_id, long nr,
				struct iocb __user * __user *iocbpp,
				bool compat) { return 0; }
+static void baiocb_put(struct ba_iocb *baiocb) { }
 #endif /* CONFIG_AIO */

 static inline struct kiocb *list_kiocb(struct list_head *h)
diff --git a/include/linux/aio_abi.h b/include/linux/aio_abi.h
index 2c87316..78c0bed 100644
--- a/include/linux/aio_abi.h
+++ b/include/linux/aio_abi.h
@@ -44,6 +44,7 @@ enum {
	IOCB_CMD_NOOP = 6,
	IOCB_CMD_PREADV = 7,
	IOCB_CMD_PWRITEV = 8,
+	IOCB_CMD_BAIO_PREAD = 9,
 };

 /*
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 71fc53b..aba7dd1 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -68,6 +68,7 @@ struct bio {
	bio_end_io_t		*bi_end_io;

	void			*bi_private;
+	void			*bi_private2;
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
	struct bio_integrity_payload *bi_integrity;  /* data integrity */
 #endif
@@ -98,6 +99,7 @@ struct bio {
 #define BIO_FS_INTEGRITY 10	/* fs owns integrity data, not block layer */
 #define BIO_QUIET	11	/* Make BIO Quiet */
 #define BIO_MAPPED_INTEGRITY 12/* integrity metadata has been remapped */
+#define BIO_BAIO	13	/* a buffered aio request */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))

 /*
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 458f497..4ce40db 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -38,6 +38,7 @@ enum bh_state_bits {
	BH_PrivateStart,/* not a state bit, but the first bit available
			 * for private allocation by other entities
			 */
+    BH_Baio,
 };

 #define MAX_BUF_PER_PAGE (PAGE_CACHE_SIZE / 512)
@@ -72,6 +73,7 @@ struct buffer_head {
	struct address_space *b_assoc_map;	/* mapping this buffer is
						   associated with */
	atomic_t b_count;		/* users using this buffer_head */
+	void *b_private2;
 };

 /*
@@ -124,6 +126,7 @@ BUFFER_FNS(Delay, delay)
 BUFFER_FNS(Boundary, boundary)
 BUFFER_FNS(Write_EIO, write_io_error)
 BUFFER_FNS(Unwritten, unwritten)
+BUFFER_FNS(Baio, baio)

 #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
 #define touch_buffer(bh)	mark_page_accessed(bh->b_page)
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index e90a673..fad65bc 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -107,6 +107,7 @@ enum pageflags {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
	PG_compound_lock,
 #endif
+	PG_baio,
	__NR_PAGEFLAGS,

	/* Filesystems */
@@ -208,6 +209,7 @@ PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
 PAGEFLAG(SwapBacked, swapbacked) __CLEARPAGEFLAG(SwapBacked, swapbacked)

 __PAGEFLAG(SlobFree, slob_free)
+PAGEFLAG(Baio, baio)

 /*
  * Private page markings that may be used by the filesystem that owns the page
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e8acce7..aa42509 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1566,6 +1566,7 @@ struct task_struct {
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
	atomic_t ptrace_bp_refcnt;
 #endif
+	struct ba_iocb *current_baiocb;
 };

 /* Future-safe accessor for struct task_struct's cpus_allowed. */
--
1.7.4.4
