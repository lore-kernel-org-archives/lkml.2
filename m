Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab2GTLvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 07:51:10 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:16961 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab2GTLvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 07:51:07 -0400
Subject: [PATCH 3/4] fuse: re-work fuse_direct_io() to operate on iovec[]
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Date: Fri, 20 Jul 2012 15:50:45 +0400
Message-ID: <20120720115039.15517.77771.stgit@maximpc.sw.ru>
In-Reply-To: <20120720114653.15517.74290.stgit@maximpc.sw.ru>
References: <20120720114653.15517.74290.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch transparently passes iovec[] argument from fuse_direct_io()
to fuse_get_user_pages() hoping that the latter would fill req with
some part of iovec[].

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index d84416d..6c8e24f 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1089,8 +1089,9 @@ static int fuse_get_user_pages(struct fuse_req *req,
 	return 0;
 }
 
-ssize_t fuse_direct_io(struct file *file, const char __user *buf,
-		       size_t count, loff_t *ppos, int write)
+static ssize_t __fuse_direct_io(struct file *file, const struct iovec *iov,
+				unsigned long nr_segs, size_t count,
+				loff_t *ppos, int write)
 {
 	struct fuse_file *ff = file->private_data;
 	struct fuse_conn *fc = ff->fc;
@@ -1098,6 +1099,7 @@ ssize_t fuse_direct_io(struct file *file, const char __user *buf,
 	loff_t pos = *ppos;
 	ssize_t res = 0;
 	struct fuse_req *req;
+	size_t iov_offset = 0;
 
 	req = fuse_get_req(fc);
 	if (IS_ERR(req))
@@ -1107,7 +1109,8 @@ ssize_t fuse_direct_io(struct file *file, const char __user *buf,
 		size_t nres;
 		fl_owner_t owner = current->files;
 		size_t nbytes = min(count, nmax);
-		int err = fuse_get_user_pages(req, buf, &nbytes, write);
+		int err = fuse_get_user_pages(req, &iov, &nr_segs, &iov_offset,
+					      &nbytes, write);
 		if (err) {
 			res = err;
 			break;
@@ -1130,7 +1133,6 @@ ssize_t fuse_direct_io(struct file *file, const char __user *buf,
 		count -= nres;
 		res += nres;
 		pos += nres;
-		buf += nres;
 		if (nres != nbytes)
 			break;
 		if (count) {
@@ -1147,6 +1149,13 @@ ssize_t fuse_direct_io(struct file *file, const char __user *buf,
 
 	return res;
 }
+
+ssize_t fuse_direct_io(struct file *file, const char __user *buf,
+		       size_t count, loff_t *ppos, int write)
+{
+	struct iovec iov = { .iov_base = (void *)buf, .iov_len = count };
+	return __fuse_direct_io(file, &iov, 1, count, ppos, write);
+}
 EXPORT_SYMBOL_GPL(fuse_direct_io);
 
 static ssize_t fuse_direct_read(struct file *file, char __user *buf,

