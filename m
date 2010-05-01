Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab0EAObg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:31:36 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:63537 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097Ab0EAObZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:31:25 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 May 2010 10:31:24 EDT
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Oren Laadan <orenl@cs.columbia.edu>,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH v21 037/100] c/r: introduce new 'file_operations': ->checkpoint, ->collect()
Date: Sat,  1 May 2010 10:15:19 -0400
Message-Id: <1272723382-19470-38-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While we assume all normal files and directories can be checkpointed,
there are, as usual in the VFS, specialized places that will always
need an ability to override these defaults. Although we could do this
completely in the checkpoint code, that would bitrot quickly.

This adds a new 'file_operations' function for checkpointing a file.
It is assumed that there should be a dirt-simple way to make something
(un)checkpointable that fits in with current code.

As you can see in the ext[234] patches down the road, all that we have
to do to make something simple be supported is add a single "generic"
f_op entry.

Also adds a new 'file_operations' function for 'collecting' a file for
leak-detection during full-container checkpoint. This is useful for
those files that hold references to other "collectable" objects. Two
examples are pty files that point to corresponding tty objects, and
eventpoll files that refer to the files they are monitoring.

Finally, this patch introduces vfs_fcntl() so that it can be called
from restart (see patch adding restart of files).

Changelog[v21]
  - Update Documentation/filesystem/vfs.txt
  - Put file_ops->checkpoint under CONFIG_CHECKPOINT
Changelog[v17]
  - Introduce 'collect' method
Changelog[v17]
  - Forward-declare 'ckpt_ctx' et-al, don't use checkpoint_types.h

Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>
---
 Documentation/filesystems/vfs.txt |   13 ++++++++++++-
 include/linux/fs.h                |    5 +++++
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 3de2f32..a78355d 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -711,7 +711,7 @@ struct file_operations
 ----------------------
 
 This describes how the VFS can manipulate an open file. As of kernel
-2.6.22, the following members are defined:
+2.6.34, the following members are defined:
 
 struct file_operations {
 	struct module *owner;
@@ -742,6 +742,10 @@ struct file_operations {
 	int (*flock) (struct file *, int, struct file_lock *);
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, struct pipe_inode_info *, size_t, unsigned int);
+#ifdef CONFIG_CHECKPOINT
+	int (*checkpoint)(struct ckpt_ctx *, struct file *);
+	int (*collect)(struct ckpt_ctx *, struct file *);
+#endif
 };
 
 Again, all methods are called without any locks being held, unless
@@ -813,6 +817,13 @@ otherwise noted.
   splice_read: called by the VFS to splice data from file to a pipe. This
 	       method is used by the splice(2) system call
 
+  checkpoint: called by checkpoint(2) system call to checkpoint the
+              state of a file descriptor.
+
+  collect: called by the checkpoint(2) system call to track references to
+           file descriptors, to detect leaks in full-container checkpoint
+	   (see Documentation/checkpoint/readme.txt).
+
 Note that the file operations are implemented by the specific
 filesystem in which the inode resides. When opening a device node
 (character or block special) most filesystems will call special
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 65ffe9c..c06c157 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -397,6 +397,7 @@ struct kstatfs;
 struct vm_area_struct;
 struct vfsmount;
 struct cred;
+struct ckpt_ctx;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -1511,6 +1512,10 @@ struct file_operations {
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *, size_t, unsigned int);
 	int (*setlease)(struct file *, long, struct file_lock **);
+#ifdef CONFIG_CHECKPOINT
+	int (*checkpoint)(struct ckpt_ctx *, struct file *);
+	int (*collect)(struct ckpt_ctx *, struct file *);
+#endif
 };
 
 struct inode_operations {
-- 
1.6.3.3

