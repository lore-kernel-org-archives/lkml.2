Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab1JYRpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 13:45:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab1JYRpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 13:45:38 -0400
Date: Tue, 25 Oct 2011 13:45:27 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alasdair G Kergon <agk@redhat.com>, Michael Leun <ml@newton.leun.net>,
        LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
Subject: [PATCH] check for mempool memory leaks
In-Reply-To: <CA+55aFzfFpnEc+Eerdi9SfMw4o17ONfYCHksJkD1O6AS5U2DoQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1110251342370.16038@hs20-bc2-1.build.redhat.com>
References: <20111023112140.37fd8b3d@xenia.leun.net>
 <CA+55aFzfFpnEc+Eerdi9SfMw4o17ONfYCHksJkD1O6AS5U2DoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 23 Oct 2011, Linus Torvalds wrote:

> Making sure that Alasdair sees this too (hopefully he picked up on it
> from dm-devel, but best send things directly too)
> 
> Mikulas, Alasdair? I see the mempool_free() for the "master job", what
> about everything else? Does the dm_kcopyd_prepare_callback() perhaps
> need to do a
> 
>     job->master_job = job;
> 
> or similar?
> 
>                    Linus
> 
> On Sun, Oct 23, 2011 at 12:21 PM, Michael Leun <ml@newton.leun.net> wrote:
> > Hi,
> >
> > How to reproduce:
> >
> > lvcreate -L30G -n testsnap vg1 # of course substitute VG as appropriate
> > dd if=/dev/zero of=/dev/vg1/testsnap bs=2M # to make things clear
> > lvcreate -L15G -s /dev/vg1/test -n testsnap
> > dd if=/dev/zero of=/dev/vg1/testsnap bs=2M &
> > watch free
> >
> > I noticed roughly 1GB memory vanishing from free / -/+ buffers/cache
> > per 2GB copied.
> >
> > Bisecting yielded a6e50b409d3f9e0833e69c3c9cca822e8fa4adbb, reverting
> > that from git master cures the memory leak
> >
> > --
> > MfG,
> >
> > Michael Leun
> >
> >
> 

BTW. would you like to accept this patch that enables tracking the number 
of objects allocated in a mempool and reporting a warning? So that such 
bugs could be automatically detected in the future?

---

Introduce an option DEBUG_MEMPOOL. It will check that a mempool is empty
when destroying the mempool.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 include/linux/mempool.h |    6 ++++++
 lib/Kconfig.debug       |    8 ++++++++
 mm/mempool.c            |   25 +++++++++++++++++++++++--
 3 files changed, 37 insertions(+), 2 deletions(-)

Index: linux-3.1-fast/lib/Kconfig.debug
===================================================================
--- linux-3.1-fast.orig/lib/Kconfig.debug	2011-10-25 00:31:56.000000000 +0200
+++ linux-3.1-fast/lib/Kconfig.debug	2011-10-25 01:18:27.000000000 +0200
@@ -411,6 +411,14 @@ config SLUB_STATS
 	  out which slabs are relevant to a particular load.
 	  Try running: slabinfo -DA
 
+config DEBUG_MEMPOOL
+	bool "Check memory leaks in mempools"
+	depends on DEBUG_KERNEL
+	help
+	  Enable debugging memory leaks in mempools. This options makes
+	  the kernel count the number of objects allocated in a mempool
+	  and check if this number is zero when the mempool is destroyed.
+
 config DEBUG_KMEMLEAK
 	bool "Kernel memory leak detector"
 	depends on DEBUG_KERNEL && EXPERIMENTAL && !MEMORY_HOTPLUG && \
Index: linux-3.1-fast/mm/mempool.c
===================================================================
--- linux-3.1-fast.orig/mm/mempool.c	2011-10-25 00:39:34.000000000 +0200
+++ linux-3.1-fast/mm/mempool.c	2011-10-25 01:24:03.000000000 +0200
@@ -71,6 +71,9 @@ mempool_t *mempool_create_node(int min_n
 		kfree(pool);
 		return NULL;
 	}
+#ifdef CONFIG_DEBUG_MEMPOOL
+	atomic_long_set(&pool->nr_allocated, 0);
+#endif
 	spin_lock_init(&pool->lock);
 	pool->min_nr = min_nr;
 	pool->pool_data = pool_data;
@@ -183,7 +186,13 @@ EXPORT_SYMBOL(mempool_resize);
 void mempool_destroy(mempool_t *pool)
 {
 	/* Check for outstanding elements */
-	BUG_ON(pool->curr_nr != pool->min_nr);
+#ifdef CONFIG_DEBUG_MEMPOOL
+	WARN(atomic_long_read(&pool->nr_allocated),
+	     "%ld objects leaked in mempool",
+	     atomic_long_read(&pool->nr_allocated));
+#else
+	WARN_ON(pool->curr_nr != pool->min_nr);
+#endif
 	free_pool(pool);
 }
 EXPORT_SYMBOL(mempool_destroy);
@@ -217,13 +226,20 @@ void * mempool_alloc(mempool_t *pool, gf
 repeat_alloc:
 
 	element = pool->alloc(gfp_temp, pool->pool_data);
-	if (likely(element != NULL))
+	if (likely(element != NULL)) {
+#ifdef CONFIG_DEBUG_MEMPOOL
+		atomic_long_inc(&pool->nr_allocated);
+#endif
 		return element;
+	}
 
 	spin_lock_irqsave(&pool->lock, flags);
 	if (likely(pool->curr_nr)) {
 		element = remove_element(pool);
 		spin_unlock_irqrestore(&pool->lock, flags);
+#ifdef CONFIG_DEBUG_MEMPOOL
+		atomic_long_inc(&pool->nr_allocated);
+#endif
 		return element;
 	}
 	spin_unlock_irqrestore(&pool->lock, flags);
@@ -265,6 +281,11 @@ void mempool_free(void *element, mempool
 	if (unlikely(element == NULL))
 		return;
 
+#ifdef CONFIG_DEBUG_MEMPOOL
+	BUG_ON(!atomic_long_read(&pool->nr_allocated));
+	atomic_long_dec(&pool->nr_allocated);
+#endif
+
 	smp_mb();
 	if (pool->curr_nr < pool->min_nr) {
 		spin_lock_irqsave(&pool->lock, flags);
Index: linux-3.1-fast/include/linux/mempool.h
===================================================================
--- linux-3.1-fast.orig/include/linux/mempool.h	2011-10-25 01:12:13.000000000 +0200
+++ linux-3.1-fast/include/linux/mempool.h	2011-10-25 01:18:51.000000000 +0200
@@ -5,6 +5,9 @@
 #define _LINUX_MEMPOOL_H
 
 #include <linux/wait.h>
+#ifdef CONFIG_DEBUG_MEMPOOLS
+#include <linux/atomic.h>
+#endif
 
 struct kmem_cache;
 
@@ -12,6 +15,9 @@ typedef void * (mempool_alloc_t)(gfp_t g
 typedef void (mempool_free_t)(void *element, void *pool_data);
 
 typedef struct mempool_s {
+#ifdef CONFIG_DEBUG_MEMPOOL
+	atomic_long_t nr_allocated;
+#endif
 	spinlock_t lock;
 	int min_nr;		/* nr of elements at *elements */
 	int curr_nr;		/* Current nr of elements at *elements */
