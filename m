Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab0EAOfd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:35:33 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:63861 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab0EAOfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:35:00 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH v21 050/100] c/r: refuse to checkpoint if monitoring directories with dnotify
Date: Sat,  1 May 2010 10:15:32 -0400
Message-Id: <1272723382-19470-51-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Helsley <matthltc@us.ibm.com>

We do not support restarting fsnotify watches. inotify and fanotify utilize
anon_inodes for pseudofiles which lack the .checkpoint operation. So they
already cleanly prevent checkpoint. dnotify on the other hand registers
its watches using fcntl() which does not require the userspace task to
hold an fd with an empty .checkpoint operation. This means userspace
could use dnotify to set up fsnotify watches which won't be re-created during
restart.

Check for fsnotify watches created with dnotify and reject checkpoint
if there are any.

Changelog [v21]:
  - [Stanislav O. Bezzubtsev] Fix omitted parameter name error

Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Acked-by: Oren Laadan <orenl@cs.columbia.edu>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>
---
 fs/checkpoint.c             |    5 +++++
 fs/notify/dnotify/dnotify.c |   18 ++++++++++++++++++
 include/linux/dnotify.h     |    6 ++++++
 3 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/fs/checkpoint.c b/fs/checkpoint.c
index 06f1130..874be00 100644
--- a/fs/checkpoint.c
+++ b/fs/checkpoint.c
@@ -206,6 +206,11 @@ static int checkpoint_file(struct ckpt_ctx *ctx, void *ptr)
 		return -EBADF;
 	}
 
+	if (is_dnotify_attached(file)) {
+		ckpt_err(ctx, -EBADF, "%(T)%(P)dnotify unsupported\n", file);
+		return -EBADF;
+	}
+
 	ret = file->f_op->checkpoint(ctx, file);
 	if (ret < 0)
 		ckpt_err(ctx, ret, "%(T)%(P)file checkpoint failed\n", file);
diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index 7e54e52..0a63bf6 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -289,6 +289,24 @@ static int attach_dn(struct dnotify_struct *dn, struct dnotify_mark_entry *dnent
 	return 0;
 }
 
+int is_dnotify_attached(struct file *filp)
+{
+	struct fsnotify_mark_entry *entry;
+	struct inode *inode;
+
+	inode = filp->f_path.dentry->d_inode;
+	if (!S_ISDIR(inode->i_mode))
+		return 0;
+
+	spin_lock(&inode->i_lock);
+	entry = fsnotify_find_mark_entry(dnotify_group, inode);
+	spin_unlock(&inode->i_lock);
+	if (!entry)
+		return 0;
+	fsnotify_put_mark(entry);
+	return 1;
+}
+
 /*
  * When a process calls fcntl to attach a dnotify watch to a directory it ends
  * up here.  Allocate both a mark for fsnotify to add and a dnotify_struct to be
diff --git a/include/linux/dnotify.h b/include/linux/dnotify.h
index ecc0628..7093052 100644
--- a/include/linux/dnotify.h
+++ b/include/linux/dnotify.h
@@ -29,6 +29,7 @@ struct dnotify_struct {
 			    FS_MOVED_FROM | FS_MOVED_TO)
 
 extern void dnotify_flush(struct file *, fl_owner_t);
+extern int is_dnotify_attached(struct file *);
 extern int fcntl_dirnotify(int, struct file *, unsigned long);
 
 #else
@@ -37,6 +38,11 @@ static inline void dnotify_flush(struct file *filp, fl_owner_t id)
 {
 }
 
+static inline int is_dnotify_attached(struct file *filp)
+{
+	return 0;
+}
+
 static inline int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 {
 	return -EINVAL;
-- 
1.6.3.3

