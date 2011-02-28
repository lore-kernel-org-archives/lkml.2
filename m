Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab1B1Quz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:50:55 -0500
Received: from kroah.org ([198.145.64.141]:41263 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295Ab1B1QhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:07 2011
Message-Id: <20110228162407.453171636@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Changli Gao <xiaosuo@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
        Przemyslaw Pawelczyk <przemyslaw@pawelczyk.it>
Subject: [18/68] sendfile(): check f_op.splice_write() rather than f_op.sendpage()
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Changli Gao <xiaosuo@gmail.com>

commit cc56f7de7f00d188c7c4da1e9861581853b9e92f upstream.

sendfile(2) was reworked with the splice infrastructure, but it still
checks f_op.sendpage() instead of f_op.splice_write() wrongly.  Although
if f_op.sendpage() exists, f_op.splice_write() always exists at the same
time currently, the assumption will be broken in future silently.  This
patch also brings a side effect: sendfile(2) can work with any output
file.  Some security checks related to f_op are added too.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Przemyslaw Pawelczyk <przemyslaw@pawelczyk.it>

---
 fs/read_write.c |    2 --
 fs/splice.c     |   24 +++++++++++++++---------
 2 files changed, 15 insertions(+), 11 deletions(-)

--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -826,8 +826,6 @@ static ssize_t do_sendfile(int out_fd, i
 	if (!(out_file->f_mode & FMODE_WRITE))
 		goto fput_out;
 	retval = -EINVAL;
-	if (!out_file->f_op || !out_file->f_op->sendpage)
-		goto fput_out;
 	in_inode = in_file->f_path.dentry->d_inode;
 	out_inode = out_file->f_path.dentry->d_inode;
 	retval = rw_verify_area(WRITE, out_file, &out_file->f_pos, count);
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -638,9 +638,11 @@ static int pipe_to_sendpage(struct pipe_
 	ret = buf->ops->confirm(pipe, buf);
 	if (!ret) {
 		more = (sd->flags & SPLICE_F_MORE) || sd->len < sd->total_len;
-
-		ret = file->f_op->sendpage(file, buf->page, buf->offset,
-					   sd->len, &pos, more);
+		if (file->f_op && file->f_op->sendpage)
+			ret = file->f_op->sendpage(file, buf->page, buf->offset,
+						   sd->len, &pos, more);
+		else
+			ret = -EINVAL;
 	}
 
 	return ret;
@@ -1058,8 +1060,9 @@ static long do_splice_from(struct pipe_i
 	if (unlikely(ret < 0))
 		return ret;
 
-	splice_write = out->f_op->splice_write;
-	if (!splice_write)
+	if (out->f_op && out->f_op->splice_write)
+		splice_write = out->f_op->splice_write;
+	else
 		splice_write = default_file_splice_write;
 
 	return splice_write(pipe, out, ppos, len, flags);
@@ -1083,8 +1086,9 @@ static long do_splice_to(struct file *in
 	if (unlikely(ret < 0))
 		return ret;
 
-	splice_read = in->f_op->splice_read;
-	if (!splice_read)
+	if (in->f_op && in->f_op->splice_read)
+		splice_read = in->f_op->splice_read;
+	else
 		splice_read = default_file_splice_read;
 
 	return splice_read(in, ppos, pipe, len, flags);
@@ -1306,7 +1310,8 @@ static long do_splice(struct file *in, l
 		if (off_in)
 			return -ESPIPE;
 		if (off_out) {
-			if (out->f_op->llseek == no_llseek)
+			if (!out->f_op || !out->f_op->llseek ||
+			    out->f_op->llseek == no_llseek)
 				return -EINVAL;
 			if (copy_from_user(&offset, off_out, sizeof(loff_t)))
 				return -EFAULT;
@@ -1326,7 +1331,8 @@ static long do_splice(struct file *in, l
 		if (off_out)
 			return -ESPIPE;
 		if (off_in) {
-			if (in->f_op->llseek == no_llseek)
+			if (!in->f_op || !in->f_op->llseek ||
+			    in->f_op->llseek == no_llseek)
 				return -EINVAL;
 			if (copy_from_user(&offset, off_in, sizeof(loff_t)))
 				return -EFAULT;


