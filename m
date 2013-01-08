Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab3AHO5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 09:57:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:18527 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756570Ab3AHO5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 09:57:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,430,1355126400"; 
   d="scan'208";a="188870184"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Stefani Seibold <stefani@seibold.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/5] kfifo: remove kfifo_init
Date: Tue,  8 Jan 2013 22:57:52 +0800
Message-Id: <1357657073-27352-5-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1357657073-27352-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1357657073-27352-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kfifo_init is buggy, we should never use that. Instead, we should use
kfifo_alloc.

Cc: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 include/linux/kfifo.h |   27 ++-------------------------
 kernel/kfifo.c        |   23 -----------------------
 2 files changed, 2 insertions(+), 48 deletions(-)

diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 7a18245..4bf984e 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -27,14 +27,14 @@
  *
  * - Modify the declaration of the "struct kfifo *" object into a
  *   in-place "struct kfifo" object
- * - Init the in-place object with kfifo_alloc() or kfifo_init()
+ * - Init the in-place object with kfifo_alloc()
  *   Note: The address of the in-place "struct kfifo" object must be
  *   passed as the first argument to this functions
  * - Replace the use of __kfifo_put into kfifo_in and __kfifo_get
  *   into kfifo_out
  * - Replace the use of kfifo_put into kfifo_in_spinlocked and kfifo_get
  *   into kfifo_out_spinlocked
- *   Note: the spinlock pointer formerly passed to kfifo_init/kfifo_alloc
+ *   Note: the spinlock pointer formerly passed to kfifo_alloc
  *   must be passed now to the kfifo_in_spinlocked and kfifo_out_spinlocked
  *   as the last parameter
  * - The formerly __kfifo_* functions are renamed into kfifo_*
@@ -350,26 +350,6 @@ __kfifo_int_must_check_helper( \
 })
 
 /**
- * kfifo_init - initialize a fifo using a preallocated buffer
- * @fifo: the fifo to assign the buffer
- * @buffer: the preallocated buffer to be used
- * @size: the size of the internal buffer, this have to be a power of 2
- *
- * This macro initialize a fifo using a preallocated buffer.
- *
- * The numer of elements will be rounded-up to a power of 2.
- * Return 0 if no error, otherwise an error code.
- */
-#define kfifo_init(fifo, buffer, size) \
-({ \
-	typeof((fifo) + 1) __tmp = (fifo); \
-	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	__is_kfifo_ptr(__tmp) ? \
-	__kfifo_init(__kfifo, buffer, size, sizeof(*__tmp->type)) : \
-	-EINVAL; \
-})
-
-/**
  * kfifo_put - put data into the fifo
  * @fifo: address of the fifo to be used
  * @val: the data to be added
@@ -770,9 +750,6 @@ extern int __kfifo_alloc(struct __kfifo *fifo, unsigned int size,
 
 extern void __kfifo_free(struct __kfifo *fifo);
 
-extern int __kfifo_init(struct __kfifo *fifo, void *buffer,
-	unsigned int size, size_t esize);
-
 extern unsigned int __kfifo_in(struct __kfifo *fifo,
 	const void *buf, unsigned int len);
 
diff --git a/kernel/kfifo.c b/kernel/kfifo.c
index 59dcf5b..d07f480 100644
--- a/kernel/kfifo.c
+++ b/kernel/kfifo.c
@@ -78,29 +78,6 @@ void __kfifo_free(struct __kfifo *fifo)
 }
 EXPORT_SYMBOL(__kfifo_free);
 
-int __kfifo_init(struct __kfifo *fifo, void *buffer,
-		unsigned int size, size_t esize)
-{
-	size /= esize;
-
-	if (!is_power_of_2(size))
-		size = rounddown_pow_of_two(size);
-
-	fifo->in = 0;
-	fifo->out = 0;
-	fifo->esize = esize;
-	fifo->data = buffer;
-
-	if (size < 2) {
-		fifo->mask = 0;
-		return -EINVAL;
-	}
-	fifo->mask = size - 1;
-
-	return 0;
-}
-EXPORT_SYMBOL(__kfifo_init);
-
 static void kfifo_copy_in(struct __kfifo *fifo, const void *src,
 		unsigned int len, unsigned int off)
 {
-- 
1.7.7.6

