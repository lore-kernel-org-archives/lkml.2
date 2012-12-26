Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab2LZMp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 07:45:26 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:3279 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406Ab2LZMpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 07:45:23 -0500
Subject: [PATCH 3/3] fuse: implement exclusive wakeup for blocked_waitq
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org
Date: Wed, 26 Dec 2012 16:45:09 +0400
Message-ID: <20121226124500.24502.77774.stgit@maximpc.sw.ru>
In-Reply-To: <20121226124319.24502.41536.stgit@maximpc.sw.ru>
References: <20121226124319.24502.41536.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch solves thundering herd problem. So far as previous patches ensured
that only allocations for background may block, it's safe to wake up one
waiter. Whoever it is, it will wake up another one in request_end() afterwards.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/dev.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index c7bef93..7ed2096 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -112,8 +112,8 @@ struct fuse_req *fuse_get_req_internal(struct fuse_conn *fc,
 		int intr;
 
 		block_sigs(&oldset);
-		intr = wait_event_interruptible(fc->blocked_waitq,
-						!fc->blocked);
+		intr = wait_event_interruptible_exclusive(fc->blocked_waitq,
+							  !fc->blocked);
 		restore_sigs(&oldset);
 		err = -EINTR;
 		if (intr)
@@ -224,6 +224,13 @@ struct fuse_req *fuse_get_req_nofail(struct fuse_conn *fc, struct file *file)
 void fuse_put_request(struct fuse_conn *fc, struct fuse_req *req)
 {
 	if (atomic_dec_and_test(&req->count)) {
+		if (unlikely(req->background)) {
+			spin_lock(&fc->lock);
+			if (!fc->blocked)
+				wake_up(&fc->blocked_waitq);
+			spin_unlock(&fc->lock);
+		}
+
 		if (req->waiting)
 			atomic_dec(&fc->num_waiting);
 
@@ -321,10 +328,14 @@ __releases(fc->lock)
 	list_del(&req->intr_entry);
 	req->state = FUSE_REQ_FINISHED;
 	if (req->background) {
-		if (fc->num_background == fc->max_background) {
+		req->background = 0;
+
+		if (fc->num_background == fc->max_background)
 			fc->blocked = 0;
-			wake_up_all(&fc->blocked_waitq);
-		}
+
+		if (!fc->blocked)
+			wake_up(&fc->blocked_waitq);
+
 		if (fc->num_background == fc->congestion_threshold &&
 		    fc->connected && fc->bdi_initialized) {
 			clear_bdi_congested(&fc->bdi, BLK_RW_SYNC);

