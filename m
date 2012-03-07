Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab2CGFQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:16:42 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37045 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab2CGFQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:16:41 -0500
Date: Wed, 7 Mar 2012 05:16:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] aio: fix io_setup/io_destroy race
Message-ID: <20120307051634.GR23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have ioctx_alloc() return an extra reference, so that caller would drop it
on success and not bother with re-grabbing it on failure exit.  The current
code is obviously broken - io_destroy() from another thread that managed
to guess the address io_setup() would've returned would free ioctx right
under us; gets especially interesting if aio_context_t * we pass to
io_setup() points to PROT_READ mapping, so put_user() fails and we end
up doing io_destroy() on kioctx another thread has just got freed...

Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
[there's other pending aio stuff, but this part is really obvious and
self-contained]

diff --git a/fs/aio.c b/fs/aio.c
index 67e4b90..f6578cb 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -273,7 +273,7 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	mm = ctx->mm = current->mm;
 	atomic_inc(&mm->mm_count);
 
-	atomic_set(&ctx->users, 1);
+	atomic_set(&ctx->users, 2);
 	spin_lock_init(&ctx->ctx_lock);
 	spin_lock_init(&ctx->ring_info.ring_lock);
 	init_waitqueue_head(&ctx->wait);
@@ -1338,10 +1338,10 @@ SYSCALL_DEFINE2(io_setup, unsigned, nr_events, aio_context_t __user *, ctxp)
 	ret = PTR_ERR(ioctx);
 	if (!IS_ERR(ioctx)) {
 		ret = put_user(ioctx->user_id, ctxp);
-		if (!ret)
+		if (!ret) {
+			put_ioctx(ioctx);
 			return 0;
-
-		get_ioctx(ioctx); /* io_destroy() expects us to hold a ref */
+		}
 		io_destroy(ioctx);
 	}
 
