Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab1KCFBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 01:01:50 -0400
Received: from mfb02-md.ns.itscom.net ([175.177.155.110]:57584 "EHLO
	mfb02-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab1KCFBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 01:01:48 -0400
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Nov 2011 01:01:48 EDT
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: hooanon05@yahoo.co.jp, viro@zeniv.linux.org.uk, hch@infradead.org,
        jwboyer@gmail.com, wli@holomorphy.com
Subject: [RFC 1/2] introduce f_op->{pre,post}_mmap()
Date: Thu,  3 Nov 2011 13:53:54 +0900
Message-Id: <1320296035-8744-2-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1320296035-8744-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1320296035-8744-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The locking order between mm->mmap_sem and inode->i_mutex (or other FS
internal lock) has a problem. The right order is i_mutex first and then
mmap_sem. But sometimes this is hard for FS which has complicated
->mmap() since it prohibits acquire i_mutex (or other FS internal lock)
otherwise it will case an AB-BA deadlock problem.
In order to allow FS to implemente complicated ->mmpa(), introduce
f_op->{pre,post}_mmap(). ->pre_mmap() is called just before acquiring
mmap_sem for ->mmap(), and ->post_mmap() is called just after releasing
mmap_sem.

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 Documentation/filesystems/Locking |    8 ++++++++
 Documentation/filesystems/vfs.txt |    7 +++++++
 include/linux/fs.h                |    2 ++
 include/linux/mm.h                |    4 ++++
 mm/mmap.c                         |   27 ++++++++++++++++++++++++---
 5 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 57d827d..1815e20 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -408,7 +408,9 @@ prototypes:
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
+	int (*pre_mmap) (struct file *, unsigned long, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
+	void (*post_mmap) (struct file *, unsigned long, unsigned long);
 	int (*open) (struct inode *, struct file *);
 	int (*flush) (struct file *);
 	int (*release) (struct inode *, struct file *);
@@ -466,6 +468,12 @@ components. And there are other reasons why the current interface is a mess...
 ->read on directories probably must go away - we should just enforce -EISDIR
 in sys_read() and friends.
 
+->mmap has mm->mmap_sem for write. If your FS needs i_mutex for mmap(2),
+  then never acquire it in ->mmap. Instead acquire it in ->pre_mmap(),
+  and release it in ->post_mmap() since they don't have mm->mmap_sem.
+  When ->pre_mmap() returns other than zero, both of ->mmap() and
+  ->post_mmap() will not be called.
+
 --------------------------- dquot_operations -------------------------------
 prototypes:
 	int (*write_dquot) (struct dquot *);
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 88b9f55..e2a579e 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -751,7 +751,9 @@ struct file_operations {
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
+	int (*pre_mmap) (struct file *, unsigned long, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
+	void (*post_mmap) (struct file *, unsigned long, unsigned long);
 	int (*open) (struct inode *, struct file *);
 	int (*flush) (struct file *);
 	int (*release) (struct inode *, struct file *);
@@ -794,8 +796,13 @@ otherwise noted.
   compat_ioctl: called by the ioctl(2) system call when 32 bit system calls
  	 are used on 64 bit kernels.
 
+  pre_mmap: called by the mmap(2) system call
+
   mmap: called by the mmap(2) system call
 
+  post_mmap: called by the mmap(2) system call
+	For pre_mmap, mmap, post_mmap, read Locking.txt too.
+
   open: called by the VFS when an inode should be opened. When the VFS
 	opens a file, it creates a new "struct file". It then calls the
 	open method for the newly allocated file structure. You might
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b5b9792..bce9d44 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1554,7 +1554,9 @@ struct file_operations {
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
+	int (*pre_mmap) (struct file *, unsigned long, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
+	void (*post_mmap) (struct file *, unsigned long, unsigned long);
 	int (*open) (struct inode *, struct file *);
 	int (*flush) (struct file *, fl_owner_t id);
 	int (*release) (struct inode *, struct file *);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9670f71..e22230c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1428,6 +1428,10 @@ extern unsigned long mmap_region(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long flags,
 	vm_flags_t vm_flags, unsigned long pgoff);
 
+extern int pre_mmap(struct file *file, unsigned long prot, unsigned long flag);
+extern void post_mmap(struct file *file, unsigned long prot,
+		      unsigned long flag);
+
 static inline unsigned long do_mmap(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot,
 	unsigned long flag, unsigned long offset)
diff --git a/mm/mmap.c b/mm/mmap.c
index 0290c8e..0dd2acb 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1089,6 +1089,25 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 }
 EXPORT_SYMBOL(do_mmap_pgoff);
 
+int pre_mmap(struct file *file, unsigned long prot, unsigned long flag)
+{
+	int err;
+
+	err = 0;
+	if (file && file->f_op && file->f_op->pre_mmap)
+		err = file->f_op->pre_mmap(file, prot, flag);
+	if (!err)
+		down_write(&current->mm->mmap_sem);
+	return err;
+}
+
+void post_mmap(struct file *file, unsigned long prot, unsigned long flag)
+{
+	up_write(&current->mm->mmap_sem);
+	if (file && file->f_op && file->f_op->post_mmap)
+		file->f_op->post_mmap(file, prot, flag);
+}
+
 SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
 		unsigned long, prot, unsigned long, flags,
 		unsigned long, fd, unsigned long, pgoff)
@@ -1120,9 +1139,11 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
 
 	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
 
-	down_write(&current->mm->mmap_sem);
-	retval = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
+	retval = pre_mmap(file, prot, flags);
+	if (!retval) {
+		retval = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
+		post_mmap(file, prot, flags);
+	}
 
 	if (file)
 		fput(file);
-- 
1.7.2.5

