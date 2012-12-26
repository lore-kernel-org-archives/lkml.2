Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab2LZMpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 07:45:15 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:39203 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab2LZMpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 07:45:13 -0500
Subject: [PATCH 2/3] fuse: skip blocking on allocations of synchronous requests
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org
Date: Wed, 26 Dec 2012 16:44:55 +0400
Message-ID: <20121226124450.24502.28562.stgit@maximpc.sw.ru>
In-Reply-To: <20121226124319.24502.41536.stgit@maximpc.sw.ru>
References: <20121226124319.24502.41536.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos wrote:

> A task may have at most one synchronous request allocated. So these
> requests need not be otherwise limited.

The patch re-works fuse_get_req() to follow this idea.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/dev.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 0b6b9d1..c7bef93 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -103,17 +103,22 @@ struct fuse_req *fuse_get_req_internal(struct fuse_conn *fc,
 				       bool for_background)
 {
 	struct fuse_req *req;
-	sigset_t oldset;
-	int intr;
 	int err;
 
 	atomic_inc(&fc->num_waiting);
-	block_sigs(&oldset);
-	intr = wait_event_interruptible(fc->blocked_waitq, !fc->blocked);
-	restore_sigs(&oldset);
-	err = -EINTR;
-	if (intr)
-		goto out;
+
+	if (for_background) {
+		sigset_t oldset;
+		int intr;
+
+		block_sigs(&oldset);
+		intr = wait_event_interruptible(fc->blocked_waitq,
+						!fc->blocked);
+		restore_sigs(&oldset);
+		err = -EINTR;
+		if (intr)
+			goto out;
+	}
 
 	err = -ENOTCONN;
 	if (!fc->connected)

