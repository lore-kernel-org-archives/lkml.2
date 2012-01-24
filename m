Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab2AXDFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 22:05:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50262 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288Ab2AXCpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:45:19 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:29 2012
Message-Id: <20120124023929.370755245@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Gleb Natapov <gleb@redhat.com>
Subject: [062/129] Unused iocbs in a batch should not be accounted as active.
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1954
Lines: 64

From: Gleb Natapov <gleb@redhat.com>

commit 69e4747ee9727d660b88d7e1efe0f4afcb35db1b upstream.

Since commit 080d676de095 ("aio: allocate kiocbs in batches") iocbs are
allocated in a batch during processing of first iocbs.  All iocbs in a
batch are automatically added to ctx->active_reqs list and accounted in
ctx->reqs_active.

If one (not the last one) of iocbs submitted by an user fails, further
iocbs are not processed, but they are still present in ctx->active_reqs
and accounted in ctx->reqs_active.  This causes process to stuck in a D
state in wait_for_all_aios() on exit since ctx->reqs_active will never
go down to zero.  Furthermore since kiocb_batch_free() frees iocb
without removing it from active_reqs list the list become corrupted
which may cause oops.

Fix this by removing iocb from ctx->active_reqs and updating
ctx->reqs_active in kiocb_batch_free().

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/aio.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -476,14 +476,21 @@ static void kiocb_batch_init(struct kioc
 	batch->count = total;
 }
 
-static void kiocb_batch_free(struct kiocb_batch *batch)
+static void kiocb_batch_free(struct kioctx *ctx, struct kiocb_batch *batch)
 {
 	struct kiocb *req, *n;
 
+	if (list_empty(&batch->head))
+		return;
+
+	spin_lock_irq(&ctx->ctx_lock);
 	list_for_each_entry_safe(req, n, &batch->head, ki_batch) {
 		list_del(&req->ki_batch);
+		list_del(&req->ki_list);
 		kmem_cache_free(kiocb_cachep, req);
+		ctx->reqs_active--;
 	}
+	spin_unlock_irq(&ctx->ctx_lock);
 }
 
 /*
@@ -1742,7 +1749,7 @@ long do_io_submit(aio_context_t ctx_id,
 	}
 	blk_finish_plug(&plug);
 
-	kiocb_batch_free(&batch);
+	kiocb_batch_free(ctx, &batch);
 	put_ioctx(ctx);
 	return i ? i : ret;
 }


