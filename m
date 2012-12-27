Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab2L0CEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 21:04:04 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33899 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab2L0CA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 21:00:57 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: [PATCH 24/32] aio: Percpu ioctx refcount
Date: Wed, 26 Dec 2012 18:00:03 -0800
Message-Id: <1356573611-18590-27-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1356573611-18590-1-git-send-email-koverstreet@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
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
index e415b33..b26ad5c 100644
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
@@ -340,7 +340,7 @@ static void free_ioctx(struct kioctx *ctx)
 
 static void put_ioctx(struct kioctx *ctx)
 {
-	if (unlikely(atomic_dec_and_test(&ctx->users)))
+	if (percpu_ref_put(&ctx->users))
 		free_ioctx(ctx);
 }
 
@@ -369,8 +369,11 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 
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
@@ -442,7 +445,7 @@ static void kill_ioctx_rcu(struct rcu_head *head)
  */
 static void kill_ioctx(struct kioctx *ctx)
 {
-	if (!atomic_xchg(&ctx->dead, 1)) {
+	if (percpu_ref_kill(&ctx->users)) {
 		hlist_del_rcu(&ctx->list);
 		/* Between hlist_del_rcu() and dropping the initial ref */
 		synchronize_rcu();
@@ -488,12 +491,6 @@ void exit_aio(struct mm_struct *mm)
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
@@ -504,7 +501,7 @@ void exit_aio(struct mm_struct *mm)
 		 */
 		ctx->mmap_size = 0;
 
-		if (!atomic_xchg(&ctx->dead, 1)) {
+		if (percpu_ref_kill(&ctx->users)) {
 			hlist_del_rcu(&ctx->list);
 			call_rcu(&ctx->rcu_head, kill_ioctx_rcu);
 		}
@@ -616,7 +613,7 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 
 	hlist_for_each_entry_rcu(ctx, n, &mm->ioctx_list, list)
 		if (ctx->user_id == ctx_id){
-			atomic_inc(&ctx->users);
+			percpu_ref_get(&ctx->users);
 			ret = ctx;
 			break;
 		}
@@ -830,7 +827,7 @@ static bool aio_read_events(struct kioctx *ctx, long min_nr, long nr,
 	if (ret > 0)
 		*i += ret;
 
-	if (unlikely(atomic_read(&ctx->dead)))
+	if (unlikely(percpu_ref_dead(&ctx->users)))
 		ret = -EINVAL;
 
 	if (!*i)
-- 
1.7.12

