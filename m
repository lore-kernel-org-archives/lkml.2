Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab0LLXsv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:48:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36954 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab0LLXst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:49 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: torvalds@linux-foundation.org, jaxboe@fusionio.com,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk, davej@redhat.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [220/223] Export 'get_pipe_info()' to other users
Message-Id: <20101212234848.35DBAB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Linus Torvalds <torvalds@linux-foundation.org>

commit c66fb347946ebdd5b10908866ecc9fa05ee2cf3d upstream.

And in particular, use it in 'pipe_fcntl()'.

The other pipe functions do not need to use the 'careful' version, since
they are only ever called for things that are already known to be pipes.

The normal read/write/ioctl functions are called through the file
operations structures, so if a file isn't a pipe, they'd never get
called.  But pipe_fcntl() is special, and called directly from the
generic fcntl code, and needs to use the same careful function that the
splice code is using.

Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/pipe.c                 |    2 +-
 fs/splice.c               |   11 -----------
 include/linux/pipe_fs_i.h |   12 ++++++++++++
 3 files changed, 13 insertions(+), 12 deletions(-)

Index: linux/fs/pipe.c
===================================================================
--- linux.orig/fs/pipe.c
+++ linux/fs/pipe.c
@@ -1202,7 +1202,7 @@ long pipe_fcntl(struct file *file, unsig
 	struct pipe_inode_info *pipe;
 	long ret;
 
-	pipe = file->f_path.dentry->d_inode->i_pipe;
+	pipe = get_pipe_info(file);
 	if (!pipe)
 		return -EBADF;
 
Index: linux/fs/splice.c
===================================================================
--- linux.orig/fs/splice.c
+++ linux/fs/splice.c
@@ -1323,17 +1323,6 @@ long do_splice_direct(struct file *in, l
 static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 			       struct pipe_inode_info *opipe,
 			       size_t len, unsigned int flags);
-/*
- * After the inode slimming patch, i_pipe/i_bdev/i_cdev share the same
- * location, so checking ->i_pipe is not enough to verify that this is a
- * pipe.
- */
-static inline struct pipe_inode_info *get_pipe_info(struct file *file)
-{
-	struct inode *i = file->f_path.dentry->d_inode;
-
-	return S_ISFIFO(i->i_mode) ? i->i_pipe : NULL;
-}
 
 /*
  * Determine where to splice to/from.
Index: linux/include/linux/pipe_fs_i.h
===================================================================
--- linux.orig/include/linux/pipe_fs_i.h
+++ linux/include/linux/pipe_fs_i.h
@@ -161,4 +161,16 @@ void generic_pipe_buf_release(struct pip
 /* for F_SETPIPE_SZ and F_GETPIPE_SZ */
 long pipe_fcntl(struct file *, unsigned int, unsigned long arg);
 
+/*
+ * After the inode slimming patch, i_pipe/i_bdev/i_cdev share the same
+ * location, so checking ->i_pipe is not enough to verify that this is a
+ * pipe.
+ */
+static inline struct pipe_inode_info *get_pipe_info(struct file *file)
+{
+	struct inode *i = file->f_path.dentry->d_inode;
+
+	return S_ISFIFO(i->i_mode) ? i->i_pipe : NULL;
+}
+
 #endif
