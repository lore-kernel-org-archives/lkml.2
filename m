Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab2JAWXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:23:48 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63584 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab2JAWXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:23:45 -0400
Date: Mon, 1 Oct 2012 15:23:41 -0700
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: tytso@google.com, tj@kernel.org, Dave Kleikamp <dave.kleikamp@oracle.com>,
        Zach Brown <zab@zabbo.net>, Dmitry Monakhov <dmonakhov@openvz.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        michael.mesnier@intel.com, jeffrey.d.skirvin@intel.com
Subject: [RFC, PATCH] Extensible AIO interface
Message-ID: <20121001222341.GF26488@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, I and other people keep running into things where we really need to
add an interface to pass some auxiliary... stuff along with a pread() or
pwrite().

A few examples:

* IO scheduler hints. Some userspace program wants to, per IO, specify
either priorities or a cgroup - by specifying a cgroup you can have a
fileserver in userspace that makes use of cfq's per cgroup bandwidth
quotas.

* Cache hints. For bcache and other things, userspace may want to specify
"this data should be cached", "this data should bypass the cache", etc.

* Passing checksums out to userspace. We've got bio integrity, which is
a (somewhat) generic interface for passing data checksums between the
filesystem and the hardware. There are various circumstances under which
you may want to pass these checksums out to userspace, and if so we
ought to have a generic way of doing it.

Hence, AIO attributes.

The way it works is I stole the reserved2 field in struct iocb. This
becomes a pointer to struct iocb_attr_list.

An iocb_attr_list is some number of iocb_attrs appended together, along
with the total number of bytes of attributes.

An iocb_attr has an id field, and a size field - and some amount of data
specific to that attribute.

The size fields mean we can iterate through the attributes and find one
with a specific id with generic code - we don't have to know anything
about the attributes we don't care about.

I also added a pointer to struct iocb_attr_list to struct bio. Now, we
can define new attributes, and then anywhere in the block layer (say
cfq, or some driver code) we can lookup any attributes that were
specified for this io.

cfq can then schedule as userspace wants, or bcache can get its cache
hints...

That's pretty much it, for the moment. It's intended to be simple and
extensible.

* FUTURE STUFF:

Return values:

Some attributes are probably going to want to return something to
userspace.

If nothing else, we want this so that userspace can tell if anything
handled the attributes it specified - as dynamic as the io stack can be,
with something extensible like this there really isn't any generic way
of knowing ahead of time if something is going to interpret any
attribute - we want to return at least an error code.

One could imagine sticking the return in the attribute itself, but I
don't want to do this. For some things (checksums), the attribute will
contain a pointer to a buffer - that's fine. But I don't want the
attributes themselves to be writeable.

The reason for this is that struct iocb point to the attributes isn't
completely ideal, and is IMO a stopgap solution. It would be better if
the attributes were inline with the iocbs. But for this we may (?) want
new aio syscalls to replace io_submit()/io_getevents(), but that isn't
something I want to rush into.

If the attributes are inline with the iocbs, the good and natural thing
to do for return values is stick them inline with the io_event
completions.

But I'm not quite sure what I want to do in the meantime, if we end up
needing return values in the short term.


commit 34232e6f28112f049d633f4ecd2d34e536f8c7cf
Author: Kent Overstreet <koverstreet@google.com>
Date:   Mon Oct 1 13:17:56 2012 -0700

    Extensible AIO interface

diff --git a/fs/aio.c b/fs/aio.c
index 71f613c..54acc17 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -424,6 +424,7 @@ static struct kiocb *__aio_get_req(struct kioctx *ctx)
 	req->private = NULL;
 	req->ki_iovec = NULL;
 	INIT_LIST_HEAD(&req->ki_run_list);
+	req->ki_attrs = NULL;
 	req->ki_eventfd = NULL;
 
 	return req;
@@ -538,6 +539,7 @@ static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
 		req->ki_dtor(req);
 	if (req->ki_iovec != &req->ki_inline_vec)
 		kfree(req->ki_iovec);
+	kfree(req->ki_attrs);
 	kmem_cache_free(kiocb_cachep, req);
 	ctx->reqs_active--;
 
@@ -1504,6 +1506,33 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
 	return 0;
 }
 
+static int aio_setup_attrs(struct iocb *iocb, struct kiocb *req)
+{
+	u64 size;
+
+	if (!iocb->aio_attrs)
+		return 0;
+
+	if (unlikely(get_user(size, (u64 *) iocb->aio_attrs)))
+		return -EFAULT;
+
+	if (unlikely(size > PAGE_SIZE))
+		return -EFAULT;
+
+	req->ki_attrs = kmalloc(size, GFP_KERNEL);
+	if (unlikely(!req->ki_attrs))
+		return  -ENOMEM;
+
+	if (unlikely(copy_from_user(req->ki_attrs,
+				    (void *) iocb->aio_attrs, size))) {
+		kfree(req->ki_attrs);
+		req->ki_attrs = NULL;
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 			 struct iocb *iocb, struct kiocb_batch *batch,
 			 bool compat)
@@ -1513,7 +1542,9 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	ssize_t ret;
 
 	/* enforce forwards compatibility on users */
-	if (unlikely(iocb->aio_reserved1 || iocb->aio_reserved2)) {
+	if (unlikely(iocb->aio_reserved1 ||
+		     (iocb->aio_attrs &&
+		      !(iocb->aio_flags & IOCB_FLAG_ATTR)))) {
 		pr_debug("EINVAL: io_submit: reserve field set\n");
 		return -EINVAL;
 	}
@@ -1538,6 +1569,11 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		return -EAGAIN;
 	}
 	req->ki_filp = file;
+
+	ret = aio_setup_attrs(iocb, req);
+	if (ret)
+		goto out_put_req;
+
 	if (iocb->aio_flags & IOCB_FLAG_RESFD) {
 		/*
 		 * If the IOCB_FLAG_RESFD flag of aio_flags is set, get an
diff --git a/fs/direct-io.c b/fs/direct-io.c
index f86c720..f58f44f 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -371,6 +371,7 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 	unsigned long flags;
 
 	bio->bi_private = dio;
+	bio->bi_attrs = dio->iocb->ki_attrs;
 
 	spin_lock_irqsave(&dio->bio_lock, flags);
 	dio->refcount++;
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 31ff6db..60dd6bc 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -119,6 +119,8 @@ struct kiocb {
 						 * for cancellation */
 	struct list_head	ki_batch;	/* batch allocation */
 
+	struct iocb_attr_list	*ki_attrs;
+
 	/*
 	 * If the aio_resfd field of the userspace iocb is not zero,
 	 * this is the underlying eventfd context to deliver events to.
@@ -235,6 +237,55 @@ static inline struct kiocb *list_kiocb(struct list_head *h)
 	return list_entry(h, struct kiocb, ki_list);
 }
 
+static inline struct iocb_attr *iocb_attr_next(struct iocb_attr_list *attrs,
+					       struct iocb_attr *attr)
+{
+	void *end = ((void *) attrs) + attrs->size;
+
+	if (attr)
+		attr = ((void *) attr) + attr->size;
+	else
+		attr = attrs->attrs;
+
+	if ((void *) &attr->data > end)
+		return NULL;
+
+	if (((void *) attr) + attr->size > end)
+		return NULL;
+
+	return attr;
+}
+
+static inline void *__iocb_attr_lookup(struct iocb_attr_list *attrs, unsigned id)
+{
+	struct iocb_attr *attr = NULL;
+
+	if (!attrs)
+		return NULL;
+
+	while (1) {
+		attr = iocb_attr_next(attrs, attr);
+		if (!attr)
+			return NULL;
+
+		if (attr->id == id)
+			return attr;
+	}
+
+	return NULL;
+}
+
+#define iocb_attr_lookup(attrs, id)					\
+({									\
+	struct iocb_attr *_attr;					\
+									\
+	_attr = __iocb_attr_lookup((attrs), IOCB_ATTR_ ## id);		\
+	if (_attr->size != sizeof(struct iocb_attr_ ## id))		\
+		_attr = NULL;						\
+									\
+	(struct iocb_attr_ ## id *) _attr;				\
+})
+
 /* for sysctl: */
 extern unsigned long aio_nr;
 extern unsigned long aio_max_nr;
diff --git a/include/linux/aio_abi.h b/include/linux/aio_abi.h
index 86fa7a7..1f46460 100644
--- a/include/linux/aio_abi.h
+++ b/include/linux/aio_abi.h
@@ -53,6 +53,7 @@ enum {
  *                   is valid.
  */
 #define IOCB_FLAG_RESFD		(1 << 0)
+#define IOCB_FLAG_ATTR		(1 << 1)
 
 /* read() from /dev/aio returns these structures. */
 struct io_event {
@@ -92,7 +93,7 @@ struct iocb {
 	__s64	aio_offset;
 
 	/* extra parameters */
-	__u64	aio_reserved2;	/* TODO: use this for a (struct sigevent *) */
+	__u64	aio_attrs;
 
 	/* flags for the "struct iocb" */
 	__u32	aio_flags;
@@ -104,6 +105,26 @@ struct iocb {
 	__u32	aio_resfd;
 }; /* 64 bytes */
 
+struct iocb_attr {
+	__u32			size;
+	__u32			id;
+	__u8			data[0];
+};
+
+struct iocb_attr_list {
+	__u64			size;
+	struct iocb_attr	attrs[];
+};
+
+enum {
+	IOCB_ATTR_proxy_pid,
+};
+
+struct iocb_attr_proxy_pid {
+	struct iocb_attr	attr;
+	__u64			pid;
+};
+
 #undef IFBIG
 #undef IFLITTLE
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 7b7ac9c..e2e37f7 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -68,6 +68,9 @@ struct bio {
 	bio_end_io_t		*bi_end_io;
 
 	void			*bi_private;
+
+	struct iocb_attr_list	*bi_attrs;
+
 #ifdef CONFIG_BLK_CGROUP
 	/*
 	 * Optional ioc and css associated with this bio.  Put on bio
