Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab0LLXt1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:49:27 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36960 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab0LLXsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:50 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: torvalds@linux-foundation.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [221/223] Un-inline get_pipe_info() helper function
Message-Id: <20101212234849.4610AB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:49 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Linus Torvalds <torvalds@linux-foundation.org>

commit 72083646528d4887b920deb71b37e09bc7d227bb upstream.

This avoids some include-file hell, and the function isn't really
important enough to be inlined anyway.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/pipe.c                 |   12 ++++++++++++
 include/linux/pipe_fs_i.h |   13 +------------
 2 files changed, 13 insertions(+), 12 deletions(-)

Index: linux/fs/pipe.c
===================================================================
--- linux.orig/fs/pipe.c
+++ linux/fs/pipe.c
@@ -1197,6 +1197,18 @@ int pipe_proc_fn(struct ctl_table *table
 	return ret;
 }
 
+/*
+ * After the inode slimming patch, i_pipe/i_bdev/i_cdev share the same
+ * location, so checking ->i_pipe is not enough to verify that this is a
+ * pipe.
+ */
+struct pipe_inode_info *get_pipe_info(struct file *file)
+{
+	struct inode *i = file->f_path.dentry->d_inode;
+
+	return S_ISFIFO(i->i_mode) ? i->i_pipe : NULL;
+}
+
 long pipe_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct pipe_inode_info *pipe;
Index: linux/include/linux/pipe_fs_i.h
===================================================================
--- linux.orig/include/linux/pipe_fs_i.h
+++ linux/include/linux/pipe_fs_i.h
@@ -160,17 +160,6 @@ void generic_pipe_buf_release(struct pip
 
 /* for F_SETPIPE_SZ and F_GETPIPE_SZ */
 long pipe_fcntl(struct file *, unsigned int, unsigned long arg);
-
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
+struct pipe_inode_info *get_pipe_info(struct file *file);
 
 #endif
