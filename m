Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946219Ab2CPXju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:39:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38586 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965566Ab2CPXjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:39:43 -0400
Message-Id: <20120316233810.863794674@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:38:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, Jeff Moyer <jmoyer@redhat.com>
Subject: [ 03/41] aio: fix io_setup/io_destroy race
In-Reply-To: <20120316233829.GA14022@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit 86b62a2cb4fc09037bbce2959d2992962396fd7f upstream.

Have ioctx_alloc() return an extra reference, so that caller would drop it
on success and not bother with re-grabbing it on failure exit.  The current
code is obviously broken - io_destroy() from another thread that managed
to guess the address io_setup() would've returned would free ioctx right
under us; gets especially interesting if aio_context_t * we pass to
io_setup() points to PROT_READ mapping, so put_user() fails and we end
up doing io_destroy() on kioctx another thread has just got freed...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Benjamin LaHaise <bcrl@kvack.org>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -273,7 +273,7 @@ static struct kioctx *ioctx_alloc(unsign
 	mm = ctx->mm = current->mm;
 	atomic_inc(&mm->mm_count);
 
-	atomic_set(&ctx->users, 1);
+	atomic_set(&ctx->users, 2);
 	spin_lock_init(&ctx->ctx_lock);
 	spin_lock_init(&ctx->ring_info.ring_lock);
 	init_waitqueue_head(&ctx->wait);
@@ -1338,10 +1338,10 @@ SYSCALL_DEFINE2(io_setup, unsigned, nr_e
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
 


