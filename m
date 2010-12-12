Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab0LLVX4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 16:23:56 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:60422 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510Ab0LLVXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 16:23:55 -0500
Message-Id: <17eaa416d82b1c57f70443e56ad22feb3c3a3a6f.1292184347.git.mirq-linux@rere.qmqm.pl>
From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
        Neil Brown <neilb@suse.de>, Jens Axboe <jaxboe@fusionio.com>
Subject: [PATCH] fs/splice: Pull buf->ops->confirm() from splice_from_pipe actors
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun, 12 Dec 2010 22:23:50 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch pulls calls to buf->ops->confirm() from all actors passed
(also indirectly) to splice_from_pipe_feed().

Is avoiding the call to buf->ops->confirm() while splice()ing to
/dev/null is an intentional optimization? No other user does that
and this will remove this special case.

Against current linux.git 6313e3c21743cc88bb5bd8aa72948ee1e83937b6.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 drivers/block/loop.c |    4 ----
 fs/nfsd/vfs.c        |    4 ----
 fs/splice.c          |   43 ++++++++++++++-----------------------------
 3 files changed, 14 insertions(+), 37 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 7ea0bea..c87b084 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -397,10 +397,6 @@ lo_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	sector_t IV;
 	int size, ret;
 
-	ret = buf->ops->confirm(pipe, buf);
-	if (unlikely(ret))
-		return ret;
-
 	IV = ((sector_t) page->index << (PAGE_CACHE_SHIFT - 9)) +
 							(buf->offset >> 9);
 	size = sd->len;
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 184938f..c6e0866 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -847,10 +847,6 @@ nfsd_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	size_t size;
 	int ret;
 
-	ret = buf->ops->confirm(pipe, buf);
-	if (unlikely(ret))
-		return ret;
-
 	size = sd->len;
 
 	if (rqstp->rq_res.page_len == 0) {
diff --git a/fs/splice.c b/fs/splice.c
index ce2f025..50a5d978 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -682,19 +682,14 @@ static int pipe_to_sendpage(struct pipe_inode_info *pipe,
 {
 	struct file *file = sd->u.file;
 	loff_t pos = sd->pos;
-	int ret, more;
-
-	ret = buf->ops->confirm(pipe, buf);
-	if (!ret) {
-		more = (sd->flags & SPLICE_F_MORE) || sd->len < sd->total_len;
-		if (file->f_op && file->f_op->sendpage)
-			ret = file->f_op->sendpage(file, buf->page, buf->offset,
-						   sd->len, &pos, more);
-		else
-			ret = -EINVAL;
-	}
+	int more;
 
-	return ret;
+	if (!likely(file->f_op && file->f_op->sendpage))
+		return -EINVAL;
+
+	more = (sd->flags & SPLICE_F_MORE) || sd->len < sd->total_len;
+	return file->f_op->sendpage(file, buf->page, buf->offset,
+				    sd->len, &pos, more);
 }
 
 /*
@@ -727,13 +722,6 @@ int pipe_to_file(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	void *fsdata;
 	int ret;
 
-	/*
-	 * make sure the data in this buffer is uptodate
-	 */
-	ret = buf->ops->confirm(pipe, buf);
-	if (unlikely(ret))
-		return ret;
-
 	offset = sd->pos & ~PAGE_CACHE_MASK;
 
 	this_len = sd->len;
@@ -805,12 +793,17 @@ int splice_from_pipe_feed(struct pipe_inode_info *pipe, struct splice_desc *sd,
 		if (sd->len > sd->total_len)
 			sd->len = sd->total_len;
 
-		ret = actor(pipe, buf, sd);
-		if (ret <= 0) {
+		ret = buf->ops->confirm(pipe, buf);
+		if (unlikely(ret)) {
 			if (ret == -ENODATA)
 				ret = 0;
 			return ret;
 		}
+
+		ret = actor(pipe, buf, sd);
+		if (ret <= 0)
+			return ret;
+
 		buf->offset += ret;
 		buf->len -= ret;
 
@@ -1044,10 +1037,6 @@ static int write_pipe_buf(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	int ret;
 	void *data;
 
-	ret = buf->ops->confirm(pipe, buf);
-	if (ret)
-		return ret;
-
 	data = buf->ops->map(pipe, buf, 0);
 	ret = kernel_write(sd->u.file, data + buf->offset, sd->len, sd->pos);
 	buf->ops->unmap(pipe, buf, data);
@@ -1495,10 +1484,6 @@ static int pipe_to_user(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	char *src;
 	int ret;
 
-	ret = buf->ops->confirm(pipe, buf);
-	if (unlikely(ret))
-		return ret;
-
 	/*
 	 * See if we can use the atomic maps, by prefaulting in the
 	 * pages and doing an atomic copy
-- 
1.7.2.3

