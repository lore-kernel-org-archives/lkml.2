Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab0EAOel (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:34:41 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:63794 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab0EAOea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:34:30 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Oren Laadan <orenl@cs.columbia.edu>,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH v21 049/100] c/r: checkpoint and restore FIFOs
Date: Sat,  1 May 2010 10:15:31 -0400
Message-Id: <1272723382-19470-50-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FIFOs are almost like pipes.

Checkpoints adds the FIFO pathname. The first time the FIFO is found
it also assigns an @objref and dumps the contents in the buffers.

To restore, use the @objref only to determine whether a particular
FIFO has already been restored earlier. Note that it ignores the file
pointer that matches that @objref (unlike with pipes, where that file
corresponds to the other end of the pipe). Instead, it creates a new
FIFO using the saved pathname.

Changelog [v21]:
  - Put file_ops->checkpoint under CONFIG_CHECKPOINT
Changelog [v19-rc3]:
  - Rebase to kernel 2.6.33
Changelog [v19-rc1]:
  - Switch to ckpt_obj_try_fetch()
  - [Matt Helsley] Add cpp definitions for enums

Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>
---
 fs/checkpoint.c                |    6 +++
 fs/pipe.c                      |   80 +++++++++++++++++++++++++++++++++++++++-
 include/linux/checkpoint_hdr.h |    2 +
 include/linux/pipe_fs_i.h      |    2 +
 4 files changed, 89 insertions(+), 1 deletions(-)

diff --git a/fs/checkpoint.c b/fs/checkpoint.c
index e840d8a..06f1130 100644
--- a/fs/checkpoint.c
+++ b/fs/checkpoint.c
@@ -593,6 +593,12 @@ static struct restore_file_ops restore_file_ops[] = {
 		.file_type = CKPT_FILE_PIPE,
 		.restore = pipe_file_restore,
 	},
+	/* fifo */
+	{
+		.file_name = "FIFO",
+		.file_type = CKPT_FILE_FIFO,
+		.restore = fifo_file_restore,
+	},
 };
 
 static void *restore_file(struct ckpt_ctx *ctx)
diff --git a/fs/pipe.c b/fs/pipe.c
index 801aad9..7f00e58 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -830,6 +830,8 @@ pipe_rdwr_open(struct inode *inode, struct file *filp)
 	return ret;
 }
 
+static struct vfsmount *pipe_mnt __read_mostly;
+
 #ifdef CONFIG_CHECKPOINT
 static int checkpoint_pipe(struct ckpt_ctx *ctx, struct inode *inode)
 {
@@ -877,7 +879,11 @@ static int pipe_file_checkpoint(struct ckpt_ctx *ctx, struct file *file)
 	if (!h)
 		return -ENOMEM;
 
-	h->common.f_type = CKPT_FILE_PIPE;
+	/* fifo and pipe are similar at checkpoint, differ on restore */
+	if (inode->i_sb == pipe_mnt->mnt_sb)
+		h->common.f_type = CKPT_FILE_PIPE;
+	else
+		h->common.f_type = CKPT_FILE_FIFO;
 	h->pipe_objref = objref;
 
 	ret = checkpoint_file_common(ctx, file, &h->common);
@@ -887,6 +893,13 @@ static int pipe_file_checkpoint(struct ckpt_ctx *ctx, struct file *file)
 	if (ret < 0)
 		goto out;
 
+	/* FIFO also needs a file name */
+	if (h->common.f_type == CKPT_FILE_FIFO) {
+		ret = checkpoint_fname(ctx, &file->f_path, &ctx->root_fs_path);
+		if (ret < 0)
+			goto out;
+	}
+
 	if (first)
 		ret = checkpoint_pipe(ctx, inode);
  out:
@@ -978,6 +991,71 @@ struct file *pipe_file_restore(struct ckpt_ctx *ctx, struct ckpt_hdr_file *ptr)
 
 	return file;
 }
+
+struct file *fifo_file_restore(struct ckpt_ctx *ctx, struct ckpt_hdr_file *ptr)
+{
+	struct ckpt_hdr_file_pipe *h = (struct ckpt_hdr_file_pipe *) ptr;
+	struct file *file;
+	int first, ret;
+
+	if (ptr->h.type != CKPT_HDR_FILE  ||
+	    ptr->h.len != sizeof(*h) || ptr->f_type != CKPT_FILE_FIFO)
+		return ERR_PTR(-EINVAL);
+
+	if (h->pipe_objref <= 0)
+		return ERR_PTR(-EINVAL);
+
+	/*
+	 * If ckpt_obj_try_fetch() returned ERR_PTR(-EINVAL), this is the
+	 * first time for this fifo.
+	 */
+	file = ckpt_obj_try_fetch(ctx, h->pipe_objref, CKPT_OBJ_FILE);
+	if (!IS_ERR(file))
+		first = 0;
+	else if (PTR_ERR(file) == -EINVAL)
+		first = 1;
+	else
+		return file;
+
+	/*
+	 * To avoid blocking, always open the fifo with O_RDWR;
+	 * then fix flags below.
+	 */
+	file = restore_open_fname(ctx, (ptr->f_flags & ~O_ACCMODE) | O_RDWR);
+	if (IS_ERR(file))
+		return file;
+
+	if ((ptr->f_flags & O_ACCMODE) == O_RDONLY) {
+		file->f_flags = (file->f_flags & ~O_ACCMODE) | O_RDONLY;
+		file->f_mode &= ~FMODE_WRITE;
+	} else if ((ptr->f_flags & O_ACCMODE) == O_WRONLY) {
+		file->f_flags = (file->f_flags & ~O_ACCMODE) | O_WRONLY;
+		file->f_mode &= ~FMODE_READ;
+	} else if ((ptr->f_flags & O_ACCMODE) != O_RDWR) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* first time: add to objhash and restore fifo's contents */
+	if (first) {
+		ret = ckpt_obj_insert(ctx, file, h->pipe_objref, CKPT_OBJ_FILE);
+		if (ret < 0)
+			goto out;
+
+		ret = restore_pipe(ctx, file);
+		if (ret < 0)
+			goto out;
+	}
+
+	ret = restore_file_common(ctx, file, ptr);
+ out:
+	if (ret < 0) {
+		fput(file);
+		file = ERR_PTR(ret);
+	}
+
+	return file;
+}
 #endif /* CONFIG_CHECKPOINT */
 
 /*
diff --git a/include/linux/checkpoint_hdr.h b/include/linux/checkpoint_hdr.h
index 50ef2b6..fbcbee7 100644
--- a/include/linux/checkpoint_hdr.h
+++ b/include/linux/checkpoint_hdr.h
@@ -286,6 +286,8 @@ enum file_type {
 #define CKPT_FILE_GENERIC CKPT_FILE_GENERIC
 	CKPT_FILE_PIPE,
 #define CKPT_FILE_PIPE CKPT_FILE_PIPE
+	CKPT_FILE_FIFO,
+#define CKPT_FILE_FIFO CKPT_FILE_FIFO
 	CKPT_FILE_MAX
 #define CKPT_FILE_MAX CKPT_FILE_MAX
 };
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index e526a12..596403e 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -160,6 +160,8 @@ struct ckpt_ctx;
 struct ckpt_hdr_file;
 extern struct file *pipe_file_restore(struct ckpt_ctx *ctx,
 				      struct ckpt_hdr_file *ptr);
+extern struct file *fifo_file_restore(struct ckpt_ctx *ctx,
+				      struct ckpt_hdr_file *ptr);
 #endif
 
 #endif
-- 
1.6.3.3

