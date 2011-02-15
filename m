Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab1BOM7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 07:59:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37219 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab1BOM7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 07:59:32 -0500
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@kernel.dk>
Subject: [PATCH 2/2] fs: Fix race between io_destroy() and io_submit() in AIO
Date: Tue, 15 Feb 2011 13:59:24 +0100
Message-Id: <1297774764-32731-3-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297774764-32731-1-git-send-email-jack@suse.cz>
References: <1297774764-32731-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A race can occur when io_submit() races with io_destroy():

 CPU1						CPU2
io_submit()
  do_io_submit()
    ...
    ctx = lookup_ioctx(ctx_id);
						io_destroy()
    Now do_io_submit() holds the last reference to ctx.
    ...
    queue new AIO
    put_ioctx(ctx) - frees ctx with active AIOs

We solve this issue by checking whether ctx is being destroyed
in AIO submission path after adding new AIO to ctx. Then we
are guaranteed that either io_destroy() waits for new AIO or
we see that ctx is being destroyed and bail out.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
CC: Nick Piggin <npiggin@kernel.dk>
---
 fs/aio.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index b4dd668..0244c04 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1642,6 +1642,21 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		goto out_put_req;
 
 	spin_lock_irq(&ctx->ctx_lock);
+	/*
+	 * We could have raced with io_destroy() and are currently holding a
+	 * reference to ctx which should be destroyed. We cannot submit IO
+	 * since ctx gets freed as soon as io_submit() puts its reference.
+	 * The check here is reliable since io_destroy() sets ctx->dead before
+	 * waiting for outstanding IO. Thus if we don't see ctx->dead set here,
+	 * io_destroy() waits for our IO to finish.
+	 * The check is inside ctx->ctx_lock to avoid extra memory barrier
+	 * in this fast path...
+	 */
+	if (ctx->dead) {
+		spin_unlock_irq(&ctx->ctx_lock);
+		ret = -EINVAL;
+		goto out_put_req;
+	}
 	aio_run_iocb(req);
 	if (!list_empty(&ctx->run_list)) {
 		/* drain the run list */
-- 
1.7.1

