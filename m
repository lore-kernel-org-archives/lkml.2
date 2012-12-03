Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab2LCVBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 16:01:04 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:59435 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab2LCU7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:59:48 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 24/26] aio: Percpu ioctx refcount
Date: Mon,  3 Dec 2012 12:58:40 -0800
Message-Id: <1354568322-29029-25-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354568322-29029-1-git-send-email-koverstreet@google.com>
References: <1354568322-29029-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This just converts the ioctx refcount to the new generic dynamic percpu
refcount code.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index bde360d..931606b 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -36,6 +36,7 @@
 #include <linux/eventfd.h>
 #include <linux/blkdev.h>
 #include <linux/compat.h>
+#include <linux/percpu-refcount.h>
 
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
@@ -65,8 +66,7 @@ struct kioctx_cpu {
 };
 
 struct kioctx {
-	atomic_t		users;
-	atomic_t		dead;
+	struct percpu_ref	users;
 
 	/* This needs improving */
 	unsigned long		user_id;
@@ -343,7 +343,7 @@ static void free_ioctx(struct kioctx *ctx)
 
 static void put_ioctx(struct kioctx *ctx)
 {
-	if (unlikely(atomic_dec_and_test(&ctx->users)))
+	if (percpu_ref_put(&ctx->users))
 		free_ioctx(ctx);
 }
 
@@ -372,8 +372,11 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 
 	ctx->max_reqs = nr_events;
 
-	atomic_set(&ctx->users, 2);
-	atomic_set(&ctx->dead, 0);
+	percpu_ref_init(&ctx->users);
+	rcu_read_lock();
+	percpu_ref_get(&ctx->users);
+	rcu_read_unlock();
+
 	spin_lock_init(&ctx->ctx_lock);
 	spin_lock_init(&ctx->completion_lock);
 	mutex_init(&ctx->ring_lock);
@@ -445,7 +448,7 @@ static void kill_ioctx_rcu(struct rcu_head *head)
  */
 static void kill_ioctx(struct kioctx *ctx)
 {
-	if (!atomic_xchg(&ctx->dead, 1)) {
+	if (percpu_ref_kill(&ctx->users)) {
 		hlist_del_rcu(&ctx->list);
 		/* Between hlist_del_rcu() and dropping the initial ref */
 		synchronize_rcu();
@@ -491,12 +494,6 @@ void exit_aio(struct mm_struct *mm)
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
@@ -507,7 +504,7 @@ void exit_aio(struct mm_struct *mm)
 		 */
 		ctx->mmap_size = 0;
 
-		if (!atomic_xchg(&ctx->dead, 1)) {
+		if (percpu_ref_kill(&ctx->users)) {
 			hlist_del_rcu(&ctx->list);
 			call_rcu(&ctx->rcu_head, kill_ioctx_rcu);
 		}
@@ -619,7 +616,7 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 
 	hlist_for_each_entry_rcu(ctx, n, &mm->ioctx_list, list)
 		if (ctx->user_id == ctx_id){
-			atomic_inc(&ctx->users);
+			percpu_ref_get(&ctx->users);
 			ret = ctx;
 			break;
 		}
@@ -839,7 +836,7 @@ retry:
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

