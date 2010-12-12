Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab0LLXr7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:47:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36582 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab0LLXr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:56 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: ksumrall@android.com, anfei.zhou@gmail.com, avati@gluster.com,
        miklos@szeredi.hu, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [170/223] fuse: fix attributes after open(O_TRUNC)
Message-Id: <20101212234754.B72C0B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:54 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Ken Sumrall <ksumrall@android.com>

commit a0822c55779d9319939eac69f00bb729ea9d23da upstream.

The attribute cache for a file was not being cleared when a file is opened
with O_TRUNC.

If the filesystem's open operation truncates the file ("atomic_o_trunc"
feature flag is set) then the kernel should invalidate the cached st_mtime
and st_ctime attributes.

Also i_size should be explicitly be set to zero as it is used sometimes
without refreshing the cache.

Signed-off-by: Ken Sumrall <ksumrall@android.com>
Cc: Anfei <anfei.zhou@gmail.com>
Cc: "Anand V. Avati" <avati@gluster.com>
Signed-off-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/fuse/file.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c
+++ linux/fs/fuse/file.c
@@ -134,6 +134,7 @@ EXPORT_SYMBOL_GPL(fuse_do_open);
 void fuse_finish_open(struct inode *inode, struct file *file)
 {
 	struct fuse_file *ff = file->private_data;
+	struct fuse_conn *fc = get_fuse_conn(inode);
 
 	if (ff->open_flags & FOPEN_DIRECT_IO)
 		file->f_op = &fuse_direct_io_file_operations;
@@ -141,6 +142,15 @@ void fuse_finish_open(struct inode *inod
 		invalidate_inode_pages2(inode->i_mapping);
 	if (ff->open_flags & FOPEN_NONSEEKABLE)
 		nonseekable_open(inode, file);
+	if (fc->atomic_o_trunc && (file->f_flags & O_TRUNC)) {
+		struct fuse_inode *fi = get_fuse_inode(inode);
+
+		spin_lock(&fc->lock);
+		fi->attr_version = ++fc->attr_version;
+		i_size_write(inode, 0);
+		spin_unlock(&fc->lock);
+		fuse_invalidate_attr(inode);
+	}
 }
 
 int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
