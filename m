Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab2K1Qog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:44:36 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46820 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393Ab2K1Qob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:44:31 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 23/25] aio: Percpu ioctx refcount
Date: Wed, 28 Nov 2012 08:43:47 -0800
Message-Id: <1354121029-1376-24-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354121029-1376-1-git-send-email-koverstreet@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This just converts the ioctx refcount to the new generic dynamic percpu
refcount code.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 94218b7..0975675 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -36,6 +36,7 @@
 #include <linux/eventfd.h>
 #include <linux/blkdev.h>
 #include <linux/compat.h>
+#include <linux/percpu-refcount.h>
 
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
@@ -65,7 +66,7 @@ struct kioctx_cpu {
 };
 
 struct kioctx {
-	atomic_t		users;
+	struct percpu_ref	users;
 	atomic_t		dead;
 
 	/* This needs improving */
@@ -297,6 +298,8 @@ static void free_ioctx(struct kioctx *ctx)
 	struct io_event res;
 	unsigned cpu, head, avail;
 
+	pr_debug("freeing %p\n", ctx);
+
 	spin_lock_irq(&ctx->ctx_lock);
 
 	while (!list_empty(&ctx->active_reqs)) {
@@ -341,14 +344,14 @@ static void free_ioctx(struct kioctx *ctx)
 
 	synchronize_rcu();
 
-	pr_debug("freeing %p\n", ctx);
+	pr_debug("freed %p\n", ctx);
 	free_percpu(ctx->cpu);
 	kmem_cache_free(kioctx_cachep, ctx);
 }
 
 static void put_ioctx(struct kioctx *ctx)
 {
-	if (unlikely(atomic_dec_and_test(&ctx->users)))
+	if (percpu_ref_put(&ctx->users))
 		free_ioctx(ctx);
 }
 
@@ -377,7 +380,10 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 
 	ctx->max_reqs = nr_events;
 
-	atomic_set(&ctx->users, 2);
+	percpu_ref_init(&ctx->users);
+	rcu_read_lock();
+	percpu_ref_get(&ctx->users);
+	rcu_read_unlock();
 	spin_lock_init(&ctx->ctx_lock);
 	spin_lock_init(&ctx->completion_lock);
 	mutex_init(&ctx->ring_lock);
@@ -433,12 +439,9 @@ out_freectx:
  */
 static void kill_ioctx(struct kioctx *ctx)
 {
-	if (!atomic_xchg(&ctx->dead, 1)) {
+	if (percpu_ref_kill(&ctx->users)) {
 		hlist_del_rcu(&ctx->list);
 		synchronize_rcu();
-
-		wake_up_all(&ctx->wait);
-
 		put_ioctx(ctx);
 	}
 }
@@ -473,12 +476,6 @@ void exit_aio(struct mm_struct *mm)
 	struct hlist_node *p, *n;
 
 	hlist_for_each_entry_safe(ctx, p, n, &mm->ioctx_list, list) {
-		if (1 != atomic_read(&ctx->users))
-			printk(KERN_DEBUG
-				"exit_aio:ioctx still alive: %d %d %d\n",
-				atomic_read(&ctx->users),
-				atomic_read(&ctx->dead),
-				atomic_read(&ctx->reqs_available));
 		/*
 		 * We don't need to bother with munmap() here -
 		 * exit_mmap(mm) is coming and it'll unmap everything.
@@ -597,8 +594,7 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 
 	hlist_for_each_entry_rcu(ctx, n, &mm->ioctx_list, list)
 		if (ctx->user_id == ctx_id){
-			BUG_ON(atomic_read(&ctx->dead));
-			atomic_inc(&ctx->users);
+			percpu_ref_get(&ctx->users);
 			ret = ctx;
 			break;
 		}
@@ -838,7 +834,7 @@ static int read_events(struct kioctx *ctx,
 		i += ret;
 		if (i >= min_nr)
 			break;
-		if (unlikely(atomic_read(&ctx->dead))) {
+		if (unlikely(percpu_ref_dead(&ctx->users))) {
 			ret = -EINVAL;
 			break;
 		}
-- 
1.7.12

