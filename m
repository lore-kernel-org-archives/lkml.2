Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab2LCVDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 16:03:05 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52766 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab2LCU7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:59:35 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 15/26] aio: Use flush_dcache_page()
Date: Mon,  3 Dec 2012 12:58:31 -0800
Message-Id: <1354568322-29029-16-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354568322-29029-1-git-send-email-koverstreet@google.com>
References: <1354568322-29029-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c | 45 +++++++++++++++++----------------------------
 1 file changed, 17 insertions(+), 28 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 5eca2a4..e3ca2c0 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -208,33 +208,15 @@ static int aio_setup_ring(struct kioctx *ctx)
 	ring->incompat_features = AIO_RING_INCOMPAT_FEATURES;
 	ring->header_length = sizeof(struct aio_ring);
 	kunmap_atomic(ring);
+	flush_dcache_page(info->ring_pages[0]);
 
 	return 0;
 }
 
-
-/* aio_ring_event: returns a pointer to the event at the given index from
- * kmap_atomic().  Release the pointer with put_aio_ring_event();
- */
 #define AIO_EVENTS_PER_PAGE	(PAGE_SIZE / sizeof(struct io_event))
 #define AIO_EVENTS_FIRST_PAGE	((PAGE_SIZE - sizeof(struct aio_ring)) / sizeof(struct io_event))
 #define AIO_EVENTS_OFFSET	(AIO_EVENTS_PER_PAGE - AIO_EVENTS_FIRST_PAGE)
 
-#define aio_ring_event(info, nr) ({					\
-	unsigned pos = (nr) + AIO_EVENTS_OFFSET;			\
-	struct io_event *__event;					\
-	__event = kmap_atomic(						\
-			(info)->ring_pages[pos / AIO_EVENTS_PER_PAGE]); \
-	__event += pos % AIO_EVENTS_PER_PAGE;				\
-	__event;							\
-})
-
-#define put_aio_ring_event(event) do {		\
-	struct io_event *__event = (event);	\
-	(void)__event;				\
-	kunmap_atomic((void *)((unsigned long)__event & PAGE_MASK)); \
-} while(0)
-
 static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
 			struct io_event *res)
 {
@@ -647,9 +629,9 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	struct kioctx	*ctx = iocb->ki_ctx;
 	struct aio_ring_info	*info;
 	struct aio_ring	*ring;
-	struct io_event	*event;
+	struct io_event	*ev_page, *event;
 	unsigned long	flags;
-	unsigned long	tail;
+	unsigned tail, pos;
 
 	/*
 	 * Special case handling for sync iocbs:
@@ -688,19 +670,24 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	if (kiocbIsCancelled(iocb))
 		goto put_rq;
 
-	ring = kmap_atomic(info->ring_pages[0]);
-
 	tail = info->tail;
-	event = aio_ring_event(info, tail);
+	pos = tail + AIO_EVENTS_OFFSET;
+
 	if (++tail >= info->nr)
 		tail = 0;
 
+	ev_page = kmap_atomic(info->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
+	event = ev_page + pos % AIO_EVENTS_PER_PAGE;
+
 	event->obj = (u64)(unsigned long)iocb->ki_obj.user;
 	event->data = iocb->ki_user_data;
 	event->res = res;
 	event->res2 = res2;
 
-	pr_debug("%p[%lu]: %p: %p %Lx %lx %lx\n",
+	kunmap_atomic(ev_page);
+	flush_dcache_page(info->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
+
+	pr_debug("%p[%u]: %p: %p %Lx %lx %lx\n",
 		 ctx, tail, iocb, iocb->ki_obj.user, iocb->ki_user_data,
 		 res, res2);
 
@@ -710,12 +697,13 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	smp_wmb();	/* make event visible before updating tail */
 
 	info->tail = tail;
-	ring->tail = tail;
 
-	put_aio_ring_event(event);
+	ring = kmap_atomic(info->ring_pages[0]);
+	ring->tail = tail;
 	kunmap_atomic(ring);
+	flush_dcache_page(info->ring_pages[0]);
 
-	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
+	pr_debug("added to ring %p at [%u]\n", iocb, tail);
 
 	/*
 	 * Check if the user asked us to deliver the result through an
@@ -793,6 +781,7 @@ static int aio_read_events(struct kioctx *ctx, struct io_event __user *event,
 	ring = kmap_atomic(info->ring_pages[0]);
 	ring->head = *head;
 	kunmap_atomic(ring);
+	flush_dcache_page(info->ring_pages[0]);
 
 	pr_debug("%d  h%u t%u\n", ret, *head, info->tail);
 
-- 
1.7.12

