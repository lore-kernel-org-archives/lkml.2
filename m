Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab0J3Lbm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 07:31:42 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55061 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab0J3Lbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 07:31:41 -0400
To: Ken Sumrall <ksumrall@android.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
        jens.axboe@oracle.com, anfei.zhou@gmail.com, avati@gluster.com,
        fuse-devel@lists.sourceforge.net
In-reply-to: <AANLkTimJWX5WnG6oiUfBxiD=BBJ=Q5iRc73iar=gPKCy@mail.gmail.com>
	(message from Ken Sumrall on Fri, 29 Oct 2010 17:31:34 -0700)
Subject: Re: [PATCH] Fix bug in FUSE where the attribute cache for a file was
 not cleared when a file is opened with O_TRUNC.
References: <1288395700-9527-1-git-send-email-ksumrall@android.com>
	<20101029170209.0aced0ca.akpm@linux-foundation.org> <AANLkTimJWX5WnG6oiUfBxiD=BBJ=Q5iRc73iar=gPKCy@mail.gmail.com>
Message-Id: <E1PC9ed-00045m-LA@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 30 Oct 2010 13:31:23 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ken,

Thanks for the patch.

Here's a slightly updated one.  Does this also look OK?

Miklos


----
Subject: fuse: fix attributes after open(O_TRUNC)
From: Ken Sumrall <ksumrall@android.com>

The attribute cache for a file was not being cleared when a file is
opened with O_TRUNC.

If the filesystem's open operation truncates the file
("atomic_o_trunc" feature flag is set) then the kernel should
invalidate the cached st_mtime and st_ctime attributes.

Also i_size should be explicitly be set to zero as it is used
sometimes without refreshing the cache.

Signed-off-by: Ken Sumrall <ksumrall@android.com>
Cc: Anfei <anfei.zhou@gmail.com>
Cc: "Anand V. Avati" <avati@gluster.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Miklos Szeredi <miklos@szeredi.hu>
Cc: stable@kernel.org
---

 fs/fuse/file.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6/fs/fuse/file.c
===================================================================
--- linux-2.6.orig/fs/fuse/file.c	2010-10-27 14:04:02.000000000 +0200
+++ linux-2.6/fs/fuse/file.c	2010-10-30 13:14:07.000000000 +0200
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
