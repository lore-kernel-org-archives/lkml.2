Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab1BOM7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 07:59:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab1BOM7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 07:59:33 -0500
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@gmail.com>, Nick Piggin <npiggin@kernel.dk>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] fs: Fix aio rcu ioctx lookup
Date: Tue, 15 Feb 2011 13:59:23 +0100
Message-Id: <1297774764-32731-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297774764-32731-1-git-send-email-jack@suse.cz>
References: <1297774764-32731-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@gmail.com>

aio-dio-invalidate-failure GPFs in aio_put_req from io_submit.

lookup_ioctx doesn't implement the rcu lookup pattern properly.  rcu_read_lock
does not prevent refcount going to zero, so we might take a refcount on a zero
count ioctx.

Fix the bug by atomically testing for zero refcount before incrementing.

[JK: Added comment into the code]

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Nick Piggin <npiggin@kernel.dk>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/aio.c |   35 ++++++++++++++++++++++++-----------
 1 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index fc557a3..b4dd668 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -239,15 +239,23 @@ static void __put_ioctx(struct kioctx *ctx)
 	call_rcu(&ctx->rcu_head, ctx_rcu_free);
 }
 
-#define get_ioctx(kioctx) do {						\
-	BUG_ON(atomic_read(&(kioctx)->users) <= 0);			\
-	atomic_inc(&(kioctx)->users);					\
-} while (0)
-#define put_ioctx(kioctx) do {						\
-	BUG_ON(atomic_read(&(kioctx)->users) <= 0);			\
-	if (unlikely(atomic_dec_and_test(&(kioctx)->users))) 		\
-		__put_ioctx(kioctx);					\
-} while (0)
+static inline void get_ioctx(struct kioctx *kioctx)
+{
+	BUG_ON(atomic_read(&kioctx->users) <= 0);
+	atomic_inc(&kioctx->users);
+}
+
+static inline int try_get_ioctx(struct kioctx *kioctx)
+{
+	return atomic_inc_not_zero(&kioctx->users);
+}
+
+static inline void put_ioctx(struct kioctx *kioctx)
+{
+	BUG_ON(atomic_read(&kioctx->users) <= 0);
+	if (unlikely(atomic_dec_and_test(&kioctx->users)))
+		__put_ioctx(kioctx);
+}
 
 /* ioctx_alloc
  *	Allocates and initializes an ioctx.  Returns an ERR_PTR if it failed.
@@ -601,8 +609,13 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 	rcu_read_lock();
 
 	hlist_for_each_entry_rcu(ctx, n, &mm->ioctx_list, list) {
-		if (ctx->user_id == ctx_id && !ctx->dead) {
-			get_ioctx(ctx);
+		/*
+		 * RCU protects us against accessing freed memory but
+		 * we have to be careful not to get a reference when the
+		 * reference count already dropped to 0 (ctx->dead test
+		 * is unreliable because of races).
+		 */
+		if (ctx->user_id == ctx_id && !ctx->dead && try_get_ioctx(ctx)){
 			ret = ctx;
 			break;
 		}
-- 
1.7.1

