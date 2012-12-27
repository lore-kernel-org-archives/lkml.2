Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab2L0CBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 21:01:46 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:64820 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab2L0CBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 21:01:06 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: [PATCH 32/32] aio: Smoosh struct kiocb
Date: Wed, 26 Dec 2012 18:00:11 -0800
Message-Id: <1356573611-18590-35-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1356573611-18590-1-git-send-email-koverstreet@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch squishes struct kiocb down to 160 bytes, from 208 previously
- mainly, some of the fields aren't needed until after aio_complete() is
called.

Also, reorder the fields to reduce the amount of memory that has to be
zeroed in aio_get_req(), and to keep members next to each other that are
used in the same place.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c            | 22 +++++++++++--------
 include/linux/aio.h | 61 +++++++++++++++++++++++++++++------------------------
 2 files changed, 46 insertions(+), 37 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 0e70b0e..6b05ddb 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -570,12 +570,13 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 	if (!get_reqs_available(ctx))
 		return NULL;
 
-	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
+	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL);
 	if (unlikely(!req))
 		goto out_put;
 
-	atomic_set(&req->ki_users, 1);
+	memset(req, 0, offsetof(struct kiocb, ki_ctx));
 	req->ki_ctx = ctx;
+	atomic_set(&req->ki_users, 1);
 	return req;
 out_put:
 	put_reqs_available(ctx, 1);
@@ -633,8 +634,8 @@ static inline unsigned kioctx_ring_put(struct kioctx *ctx, struct kiocb *req,
 	ev_page = kmap_atomic(ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
 	event = ev_page + pos % AIO_EVENTS_PER_PAGE;
 
-	event->obj	= (u64) req->ki_obj.user;
 	event->data	= req->ki_user_data;
+	event->obj	= (u64) req->ki_obj.user;
 	event->res	= req->ki_res;
 	event->res2	= req->ki_res2;
 
@@ -1245,13 +1246,16 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		goto out_put_req;
 	}
 
-	req->ki_obj.user = user_iocb;
-	req->ki_user_data = iocb->aio_data;
-	req->ki_pos = iocb->aio_offset;
+	req->ki_user_data	= iocb->aio_data;
+	req->ki_obj.user	= user_iocb;
 
-	req->ki_buf = (char __user *)(unsigned long)iocb->aio_buf;
-	req->ki_left = req->ki_nbytes = iocb->aio_nbytes;
-	req->ki_opcode = iocb->aio_lio_opcode;
+	req->ki_opcode		= iocb->aio_lio_opcode;
+	req->ki_pos		= iocb->aio_offset;
+	req->ki_nbytes		= iocb->aio_nbytes;
+	req->ki_left		= iocb->aio_nbytes;
+	req->ki_buf		= (char __user *) iocb->aio_buf;
+	req->ki_nr_segs		= 0;
+	req->ki_cur_seg		= 0;
 
 	ret = aio_run_iocb(req, compat);
 	if (ret)
diff --git a/include/linux/aio.h b/include/linux/aio.h
index db6b856..f9ffee3 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -20,45 +20,50 @@ struct batch_complete;
 typedef int (kiocb_cancel_fn)(struct kiocb *, struct io_event *);
 
 struct kiocb {
-	struct rb_node		ki_node;
+	struct list_head	ki_list;	/* the aio core uses this
+						 * for cancellation */
+	kiocb_cancel_fn		*ki_cancel;
+	void			(*ki_dtor)(struct kiocb *);
+	void			*private;
+	struct iovec		*ki_iovec;
+
+	/*
+	 * If the aio_resfd field of the userspace iocb is not zero,
+	 * this is the underlying eventfd context to deliver events to.
+	 */
+	struct eventfd_ctx	*ki_eventfd;
+	struct kioctx		*ki_ctx;	/* NULL for sync ops */
+	struct file		*ki_filp;
 
 	atomic_t		ki_users;
 
-	struct file		*ki_filp;
-	struct kioctx		*ki_ctx;	/* NULL for sync ops */
-	kiocb_cancel_fn		*ki_cancel;
-	void			(*ki_dtor)(struct kiocb *);
+	/* State that we remember to be able to restart/retry  */
+	unsigned		ki_opcode;
 
+	__u64			ki_user_data;	/* user's data for completion */
 	union {
 		void __user		*user;
 		struct task_struct	*tsk;
 	} ki_obj;
 
-	__u64			ki_user_data;	/* user's data for completion */
-	long			ki_res;
-	long			ki_res2;
-
-	loff_t			ki_pos;
+	union {
+	struct {
+		loff_t		ki_pos;
+		size_t		ki_nbytes;	/* copy of iocb->aio_nbytes */
+		size_t		ki_left;	/* remaining bytes */
+		char __user	*ki_buf;	/* remaining iocb->aio_buf */
+		unsigned long	ki_nr_segs;
+		unsigned long	ki_cur_seg;
+	};
+
+	struct {
+		long		ki_res;
+		long		ki_res2;
+		struct rb_node	ki_node;
+	};
+	};
 
-	void			*private;
-	/* State that we remember to be able to restart/retry  */
-	unsigned short		ki_opcode;
-	size_t			ki_nbytes; 	/* copy of iocb->aio_nbytes */
-	char 			__user *ki_buf;	/* remaining iocb->aio_buf */
-	size_t			ki_left; 	/* remaining bytes */
 	struct iovec		ki_inline_vec;	/* inline vector */
- 	struct iovec		*ki_iovec;
- 	unsigned long		ki_nr_segs;
- 	unsigned long		ki_cur_seg;
-
-	struct list_head	ki_list;	/* the aio core uses this
-						 * for cancellation */
-
-	/*
-	 * If the aio_resfd field of the userspace iocb is not zero,
-	 * this is the underlying eventfd context to deliver events to.
-	 */
-	struct eventfd_ctx	*ki_eventfd;
 };
 
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
-- 
1.7.12

