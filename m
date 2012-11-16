Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab2KPRKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:10:51 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:25247 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab2KPRKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:10:47 -0500
Subject: [PATCH 13/14] fuse: Turn writeback cache on
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        xemul@openvz.org
Date: Fri, 16 Nov 2012 21:10:34 +0400
Message-ID: <20121116171025.3196.32988.stgit@maximpc.sw.ru>
In-Reply-To: <20121116170123.3196.93431.stgit@maximpc.sw.ru>
References: <20121116170123.3196.93431.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a bit kernel and userspace exchange between each-other on
the init stage and turn writeback on if the userspace want this and
mount option 'allow_wbcache' is present (controlled by fusermount).

Also add each writable file into per-inode write list and call the
generic_file_aio_write to make use of the Linux page cache engine.

Original patch by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c            |   15 +++++++++++++++
 fs/fuse/fuse_i.h          |    4 ++++
 fs/fuse/inode.c           |   13 +++++++++++++
 include/uapi/linux/fuse.h |    1 +
 4 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 741e9b4..f62463b 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -210,6 +210,8 @@ void fuse_finish_open(struct inode *inode, struct file *file)
 		spin_unlock(&fc->lock);
 		fuse_invalidate_attr(inode);
 	}
+	if ((file->f_mode & FMODE_WRITE) && fc->writeback_cache)
+		fuse_link_write_file(file);
 }
 
 int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
@@ -1069,6 +1071,19 @@ static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	struct iov_iter i;
 	loff_t endbyte = 0;
 
+	if (get_fuse_conn(inode)->writeback_cache) {
+		if (!(file->f_flags & O_DIRECT)) {
+			struct fuse_conn *fc = get_fuse_conn(inode);
+			struct fuse_inode *fi = get_fuse_inode(inode);
+
+			spin_lock(&fc->lock);
+			inode->i_mtime = current_fs_time(inode->i_sb);
+			set_bit(FUSE_I_MTIME_UPDATED, &fi->state);
+			spin_unlock(&fc->lock);
+		}
+		return generic_file_aio_write(iocb, iov, nr_segs, pos);
+	}
+
 	WARN_ON(iocb->ki_pos != pos);
 
 	ocount = 0;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 72645e8..3b9a2fe 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -44,6 +44,10 @@
     doing the mount will be allowed to access the filesystem */
 #define FUSE_ALLOW_OTHER         (1 << 1)
 
+/** If the FUSE_ALLOW_WBCACHE flag is given, the filesystem
+    module will enable support of writback cache */
+#define FUSE_ALLOW_WBCACHE       (1 << 2)
+
 /** List of active connections */
 extern struct list_head fuse_conn_list;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 92afee5..85b716f 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -521,6 +521,7 @@ enum {
 	OPT_ALLOW_OTHER,
 	OPT_MAX_READ,
 	OPT_BLKSIZE,
+	OPT_ALLOW_WBCACHE,
 	OPT_ERR
 };
 
@@ -533,6 +534,7 @@ static const match_table_t tokens = {
 	{OPT_ALLOW_OTHER,		"allow_other"},
 	{OPT_MAX_READ,			"max_read=%u"},
 	{OPT_BLKSIZE,			"blksize=%u"},
+	{OPT_ALLOW_WBCACHE,		"allow_wbcache"},
 	{OPT_ERR,			NULL}
 };
 
@@ -602,6 +604,10 @@ static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev)
 			d->blksize = value;
 			break;
 
+		case OPT_ALLOW_WBCACHE:
+			d->flags |= FUSE_ALLOW_WBCACHE;
+			break;
+
 		default:
 			return 0;
 		}
@@ -629,6 +635,8 @@ static int fuse_show_options(struct seq_file *m, struct dentry *root)
 		seq_printf(m, ",max_read=%u", fc->max_read);
 	if (sb->s_bdev && sb->s_blocksize != FUSE_DEFAULT_BLKSIZE)
 		seq_printf(m, ",blksize=%lu", sb->s_blocksize);
+	if (fc->flags & FUSE_ALLOW_WBCACHE)
+		seq_puts(m, ",allow_wbcache");
 	return 0;
 }
 
@@ -938,6 +946,9 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 				fc->dont_mask = 1;
 			if (arg->flags & FUSE_AUTO_INVAL_DATA)
 				fc->auto_inval_data = 1;
+			if (arg->flags & FUSE_WRITEBACK_CACHE &&
+			    fc->flags & FUSE_ALLOW_WBCACHE)
+				fc->writeback_cache = 1;
 		} else {
 			ra_pages = fc->max_read / PAGE_CACHE_SIZE;
 			fc->no_lock = 1;
@@ -965,6 +976,8 @@ static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 		FUSE_EXPORT_SUPPORT | FUSE_BIG_WRITES | FUSE_DONT_MASK |
 		FUSE_SPLICE_WRITE | FUSE_SPLICE_MOVE | FUSE_SPLICE_READ |
 		FUSE_FLOCK_LOCKS | FUSE_IOCTL_DIR | FUSE_AUTO_INVAL_DATA;
+	if (fc->flags & FUSE_ALLOW_WBCACHE)
+		arg->flags |= FUSE_WRITEBACK_CACHE;
 	req->in.h.opcode = FUSE_INIT;
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(*arg);
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index d8c713e..96cd120 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -193,6 +193,7 @@ struct fuse_file_lock {
 #define FUSE_FLOCK_LOCKS	(1 << 10)
 #define FUSE_HAS_IOCTL_DIR	(1 << 11)
 #define FUSE_AUTO_INVAL_DATA	(1 << 12)
+#define FUSE_WRITEBACK_CACHE	(1 << 13)
 
 /**
  * CUSE INIT request/reply flags

