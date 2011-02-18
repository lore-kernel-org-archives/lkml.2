Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab1BRQRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 11:17:48 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43947 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268Ab1BRQRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 11:17:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=aJlRftSMFYarlommx97MiCFMYDyHhsU7EeFzFKfn94ZIF7Thv11wAI0ActfDPnZizb
         Q1Jaj6sJ4mexeAdMyYjvI+caVeH5/c0N3OZJsONXacDA42lps/T5fU1G60J9JQb7tdv4
         st4k3yPA7GOe4+6EBn5u0u/VFRhn82DsliJGY=
MIME-Version: 1.0
Date: Sat, 19 Feb 2011 00:17:44 +0800
Message-ID: <AANLkTinY6VHGGokQ1e0YzO-jpvyjR1QrS6nwLm3TG=D5@mail.gmail.com>
Subject: [PATCH 1/2] add ->mount function introduction into Documentation/filesystems/porting
From: Steven Liu <lingjiujianke@gmail.com>
To: viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, liuqi <liuqi@thunderst.com>,
        LiDongyang <jerry87905@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander Viro,

     I have add the fstype->mount introduction into
Documentation/filesystems/porting

     Can this patch fixed in?


     add ->mount function introduction into Documentation/filesystems/porting
     and note that the vfs will replace ->get_sb to ->mount


Signed-off-by: LiuQi <lingjiujianke@gmail.com>
---
 Documentation/filesystems/vfs.txt |   91 +++++++++++++++++++++++++++++++------
 1 files changed, 76 insertions(+), 15 deletions(-)

diff --git a/Documentation/filesystems/vfs.txt
b/Documentation/filesystems/vfs.txt
index 94cf97b..ba850e3 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -96,9 +96,9 @@ functions:

 The passed struct file_system_type describes your filesystem. When a
 request is made to mount a device onto a directory in your filespace,
-the VFS will call the appropriate get_sb() method for the specific
-filesystem. The dentry for the mount point will then be updated to
-point to the root inode for the new filesystem.
+the VFS will call the appropriate get_sb() or mount() method for
+the specific filesystem. The dentry for the mount point will then
+be updated to point to the root inode for the new filesystem.

 You can see all filesystems that are registered to the kernel in the
 file /proc/filesystems.
@@ -107,20 +107,30 @@ file /proc/filesystems.
 struct file_system_type
 -----------------------

-This describes the filesystem. As of kernel 2.6.22, the following
+This describes the filesystem. As of kernel 2.6.38, the following
 members are defined:

+
 struct file_system_type {
-	const char *name;
-	int fs_flags;
-        int (*get_sb) (struct file_system_type *, int,
-                       const char *, void *, struct vfsmount *);
-        void (*kill_sb) (struct super_block *);
-        struct module *owner;
-        struct file_system_type * next;
-        struct list_head fs_supers;
-	struct lock_class_key s_lock_key;
-	struct lock_class_key s_umount_key;
+	    const char *name;
+	    int fs_flags;
+	    int (*get_sb) (struct file_system_type *, int,
+			               const char *, void *, struct vfsmount *);
+	    struct dentry *(*mount) (struct file_system_type *, int,
+			               const char *, void *);
+	    void (*kill_sb) (struct super_block *);
+	    struct module *owner;
+	    struct file_system_type * next;
+	    struct list_head fs_supers;
+
+		struct lock_class_key s_lock_key;
+	    struct lock_class_key s_umount_key;
+	    struct lock_class_key s_vfs_rename_key;
+
+		struct lock_class_key i_lock_key;
+	    struct lock_class_key i_mutex_key;
+	    struct lock_class_key i_mutex_dir_key;
+	    struct lock_class_key i_alloc_sem_key;
 };

   name: the name of the filesystem type, such as "ext2", "iso9660",
@@ -131,6 +141,9 @@ struct file_system_type {
   get_sb: the method to call when a new instance of this
 	filesystem should be mounted

+  mount: the method to call when a new instance of this
+  	filesystem should be mounted(*NOTE* linux will remove get_sb soon)
+
   kill_sb: the method to call when an instance of this filesystem
 	should be unmounted

@@ -139,7 +152,8 @@ struct file_system_type {

   next: for internal VFS use: you should initialize this to NULL

-  s_lock_key, s_umount_key: lockdep-specific
+  s_lock_key, s_umount_key, s_vfs_rename_key, i_lock_key, i_mutex_key,
+  i_mutex_dir_key, i_alloc_sem_key: lockdep-specific

 The get_sb() method has the following arguments:

@@ -187,6 +201,53 @@ A fill_super() method implementation has the
following arguments:
   int silent: whether or not to be silent on error


+
+The mount() method has the following arguments:
+
+  struct file_system_type *fs_type: describes the filesystem, partly
initialized
+  	by the specific filesystem code
+
+  int flags: mount flags
+
+  const char *dev_name: the device name we are mounting.
+
+  void *data: arbitrary mount options, usually comes as an ASCII
+	string (see "Mount Options" section)
+
+
+The mount() method must determine if the block device specified
+in the dev_name and fs_type contains a filesystem of the type the method
+supports. If it succeeds in opening the named block device, it initializes a
+struct super_block descriptor for the filesystem contained by the block device.
+On failure it returns an error.
+
+The most interesting member of the superblock structure that the
+mount() method fills in is the "s_op" field. This is a pointer to
+a "struct super_operations" which describes the next level of the
+filesystem implementation.
+
+Usually, a filesystem uses one of the generic mount() implementations
+and provides a fill_super() method instead. The generic methods are:
+
+  mount_bdev: mount a filesystem residing on a block device
+
+  mount_nodev: mount a filesystem that is not backed by a device
+
+  mount_single: mount a filesystem which shares the instance between
+  	all mounts
+
+A fill_super() method implementation has the following arguments:
+
+  struct super_block *sb: the superblock structure. The method fill_super()
+  	must initialize this properly.
+
+  void *data: arbitrary mount options, usually comes as an ASCII
+	string (see "Mount Options" section)
+
+  int silent: whether or not to be silent on error
+
+
+
 The Superblock Object
 =====================

-- 
1.7.2



Best Regards


Steven Liu
