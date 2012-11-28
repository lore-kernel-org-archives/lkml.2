Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab2K1QoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:44:15 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48400 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab2K1QoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:44:10 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 08/25] aio: Move private stuff out of aio.h
Date: Wed, 28 Nov 2012 08:43:32 -0800
Message-Id: <1354121029-1376-9-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354121029-1376-1-git-send-email-koverstreet@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/usb/gadget/inode.c |  1 +
 fs/aio.c                   | 61 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/aio.h        | 61 ----------------------------------------------
 3 files changed, 62 insertions(+), 61 deletions(-)

diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index 2a3f001..7640e01 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/mmu_context.h>
+#include <linux/aio.h>
 
 #include <linux/device.h>
 #include <linux/moduleparam.h>
diff --git a/fs/aio.c b/fs/aio.c
index a993234..4dcc02f 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -45,6 +45,67 @@
 #define dprintk(x...)	do { ; } while (0)
 #endif
 
+#define AIO_RING_MAGIC			0xa10a10a1
+#define AIO_RING_COMPAT_FEATURES	1
+#define AIO_RING_INCOMPAT_FEATURES	0
+struct aio_ring {
+	unsigned	id;	/* kernel internal index number */
+	unsigned	nr;	/* number of io_events */
+	unsigned	head;
+	unsigned	tail;
+
+	unsigned	magic;
+	unsigned	compat_features;
+	unsigned	incompat_features;
+	unsigned	header_length;	/* size of aio_ring */
+
+
+	struct io_event		io_events[0];
+}; /* 128 bytes + ring size */
+
+#define AIO_RING_PAGES	8
+struct aio_ring_info {
+	unsigned long		mmap_base;
+	unsigned long		mmap_size;
+
+	struct page		**ring_pages;
+	spinlock_t		ring_lock;
+	long			nr_pages;
+
+	unsigned		nr, tail;
+
+	struct page		*internal_pages[AIO_RING_PAGES];
+};
+
+static inline unsigned aio_ring_avail(struct aio_ring_info *info,
+					struct aio_ring *ring)
+{
+	return (ring->head + info->nr - 1 - ring->tail) % info->nr;
+}
+
+struct kioctx {
+	atomic_t		users;
+	int			dead;
+
+	/* This needs improving */
+	unsigned long		user_id;
+	struct hlist_node	list;
+
+	wait_queue_head_t	wait;
+
+	spinlock_t		ctx_lock;
+
+	int			reqs_active;
+	struct list_head	active_reqs;	/* used for cancellation */
+
+	/* sys_io_setup currently limits this to an unsigned int */
+	unsigned		max_reqs;
+
+	struct aio_ring_info	ring_info;
+
+	struct rcu_head		rcu_head;
+};
+
 /*------ sysctl variables----*/
 static DEFINE_SPINLOCK(aio_nr_lock);
 unsigned long aio_nr;		/* current system wide number of aio requests */
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 0ce99e8..f29de1f 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -104,67 +104,6 @@ static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
 		};
 }
 
-#define AIO_RING_MAGIC			0xa10a10a1
-#define AIO_RING_COMPAT_FEATURES	1
-#define AIO_RING_INCOMPAT_FEATURES	0
-struct aio_ring {
-	unsigned	id;	/* kernel internal index number */
-	unsigned	nr;	/* number of io_events */
-	unsigned	head;
-	unsigned	tail;
-
-	unsigned	magic;
-	unsigned	compat_features;
-	unsigned	incompat_features;
-	unsigned	header_length;	/* size of aio_ring */
-
-
-	struct io_event		io_events[0];
-}; /* 128 bytes + ring size */
-
-#define AIO_RING_PAGES	8
-struct aio_ring_info {
-	unsigned long		mmap_base;
-	unsigned long		mmap_size;
-
-	struct page		**ring_pages;
-	spinlock_t		ring_lock;
-	long			nr_pages;
-
-	unsigned		nr, tail;
-
-	struct page		*internal_pages[AIO_RING_PAGES];
-};
-
-static inline unsigned aio_ring_avail(struct aio_ring_info *info,
-					struct aio_ring *ring)
-{
-	return (ring->head + info->nr - 1 - ring->tail) % info->nr;
-}
-
-struct kioctx {
-	atomic_t		users;
-	int			dead;
-
-	/* This needs improving */
-	unsigned long		user_id;
-	struct hlist_node	list;
-
-	wait_queue_head_t	wait;
-
-	spinlock_t		ctx_lock;
-
-	int			reqs_active;
-	struct list_head	active_reqs;	/* used for cancellation */
-
-	/* sys_io_setup currently limits this to an unsigned int */
-	unsigned		max_reqs;
-
-	struct aio_ring_info	ring_info;
-
-	struct rcu_head		rcu_head;
-};
-
 /* prototypes */
 #ifdef CONFIG_AIO
 extern ssize_t wait_on_sync_kiocb(struct kiocb *iocb);
-- 
1.7.12

