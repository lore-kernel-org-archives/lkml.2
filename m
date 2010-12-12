Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab0LLXtt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:49:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36927 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054Ab0LLXss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:48 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: torvalds@linux-foundation.org, jaxboe@fusionio.com,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk, davej@redhat.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [219/223] Rename 'pipe_info()' to 'get_pipe_info()'
Message-Id: <20101212234847.155DFB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:47 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Linus Torvalds <torvalds@linux-foundation.org>

commit 71993e62a47dabddf10302807d6aa260455503f4 upstream.

.. and change it to take the 'file' pointer instead of an inode, since
that's what all users want anyway.

The renaming is preparatory to exporting it to other users.  The old
'pipe_info()' name was too generic and is already used elsewhere, so
before making the function public we need to use a more specific name.

Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/splice.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

Index: linux/fs/splice.c
===================================================================
--- linux.orig/fs/splice.c
+++ linux/fs/splice.c
@@ -1328,12 +1328,11 @@ static int splice_pipe_to_pipe(struct pi
  * location, so checking ->i_pipe is not enough to verify that this is a
  * pipe.
  */
-static inline struct pipe_inode_info *pipe_info(struct inode *inode)
+static inline struct pipe_inode_info *get_pipe_info(struct file *file)
 {
-	if (S_ISFIFO(inode->i_mode))
-		return inode->i_pipe;
+	struct inode *i = file->f_path.dentry->d_inode;
 
-	return NULL;
+	return S_ISFIFO(i->i_mode) ? i->i_pipe : NULL;
 }
 
 /*
@@ -1348,8 +1347,8 @@ static long do_splice(struct file *in, l
 	loff_t offset, *off;
 	long ret;
 
-	ipipe = pipe_info(in->f_path.dentry->d_inode);
-	opipe = pipe_info(out->f_path.dentry->d_inode);
+	ipipe = get_pipe_info(in);
+	opipe = get_pipe_info(out);
 
 	if (ipipe && opipe) {
 		if (off_in || off_out)
@@ -1567,7 +1566,7 @@ static long vmsplice_to_user(struct file
 	int error;
 	long ret;
 
-	pipe = pipe_info(file->f_path.dentry->d_inode);
+	pipe = get_pipe_info(file);
 	if (!pipe)
 		return -EBADF;
 
@@ -1654,7 +1653,7 @@ static long vmsplice_to_pipe(struct file
 	};
 	long ret;
 
-	pipe = pipe_info(file->f_path.dentry->d_inode);
+	pipe = get_pipe_info(file);
 	if (!pipe)
 		return -EBADF;
 
@@ -2034,8 +2033,8 @@ static int link_pipe(struct pipe_inode_i
 static long do_tee(struct file *in, struct file *out, size_t len,
 		   unsigned int flags)
 {
-	struct pipe_inode_info *ipipe = pipe_info(in->f_path.dentry->d_inode);
-	struct pipe_inode_info *opipe = pipe_info(out->f_path.dentry->d_inode);
+	struct pipe_inode_info *ipipe = get_pipe_info(in);
+	struct pipe_inode_info *opipe = get_pipe_info(out);
 	int ret = -EINVAL;
 
 	/*
