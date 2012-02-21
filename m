Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab2BUT6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:58:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222Ab2BUTx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:53:57 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 39/73] union-mount: Duplicate the i_{,
 dir_}mutex lock classes and use for upper layer [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:02:24 +0000
Message-ID: <20120221180224.25235.62191.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Duplicate the i_mutex and i_dir_mutex lock classes and use for unionmount upper
layer superblock instead of the normal lock classes.  This solves some of the
lockdep noise when the VFS tries to hold locks on inodes in both layers at the
same time.  Note these only occur if both layers are of the same filesystem
type.

As far as I can tell, most of the lockdep warnings are false positives since
the inodes being locked are part of different superblocks; however, because
lockdep works on lock *classes*, it can't determine this.

I suspect that giving each superblock its own lock class would overextend
lockdep.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/inode.c         |   48 ++++++++++++++++++++++++++++++++++++------------
 fs/namespace.c     |    2 +-
 fs/super.c         |    8 ++++++++
 include/linux/fs.h |    5 +++--
 4 files changed, 48 insertions(+), 15 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index d3ebdbe..95f926b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -166,8 +166,14 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	spin_lock_init(&inode->i_lock);
 	lockdep_set_class(&inode->i_lock, &sb->s_type->i_lock_key);
 
+	/* Duplicate the code with separate indices so that when lockdep print
+	 * a warning, the numeric index is seen.
+	 */
 	mutex_init(&inode->i_mutex);
-	lockdep_set_class(&inode->i_mutex, &sb->s_type->i_mutex_key);
+	if (sb->s_lock_class == 0)
+		lockdep_set_class(&inode->i_mutex, &sb->s_type->i_mutex_key[0]);
+	else
+		lockdep_set_class(&inode->i_mutex, &sb->s_type->i_mutex_key[1]);
 
 	atomic_set(&inode->i_dio_count, 0);
 
@@ -935,18 +941,36 @@ EXPORT_SYMBOL(new_inode);
 void lockdep_annotate_inode_mutex_key(struct inode *inode)
 {
 	if (S_ISDIR(inode->i_mode)) {
-		struct file_system_type *type = inode->i_sb->s_type;
+		struct super_block *sb = inode->i_sb;
+		struct file_system_type *type = sb->s_type;
 
-		/* Set new key only if filesystem hasn't already changed it */
-		if (!lockdep_match_class(&inode->i_mutex,
-		    &type->i_mutex_key)) {
-			/*
-			 * ensure nobody is actually holding i_mutex
-			 */
-			mutex_destroy(&inode->i_mutex);
-			mutex_init(&inode->i_mutex);
-			lockdep_set_class(&inode->i_mutex,
-					  &type->i_mutex_dir_key);
+		/* Set new key only if filesystem hasn't already changed it
+		 *
+		 * Duplicate the code with separate indices so that when
+		 * lockdep print a warning, the numeric index is seen.
+		 */
+		if (sb->s_lock_class == 0) {
+			if (!lockdep_match_class(&inode->i_mutex,
+						 &type->i_mutex_key[0])) {
+				/*
+				 * ensure nobody is actually holding i_mutex
+				 */
+				mutex_destroy(&inode->i_mutex);
+				mutex_init(&inode->i_mutex);
+				lockdep_set_class(&inode->i_mutex,
+						  &type->i_mutex_dir_key[0]);
+			}
+		} else {
+			if (!lockdep_match_class(&inode->i_mutex,
+						 &type->i_mutex_key[1])) {
+				/*
+				 * ensure nobody is actually holding i_mutex
+				 */
+				mutex_destroy(&inode->i_mutex);
+				mutex_init(&inode->i_mutex);
+				lockdep_set_class(&inode->i_mutex,
+						  &type->i_mutex_dir_key[1]);
+			}
 		}
 	}
 }
diff --git a/fs/namespace.c b/fs/namespace.c
index c990f69..5e8328e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2441,7 +2441,7 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE | MS_BORN |
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
-		   MS_STRICTATIME | MS_UNION);
+		   MS_STRICTATIME);
 
 	if (flags & MS_REMOUNT)
 		retval = do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,
diff --git a/fs/super.c b/fs/super.c
index 732e19b..4d24f05 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -137,6 +137,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 		INIT_LIST_HEAD(&s->s_files);
 #endif
 		s->s_flags = flags;
+		s->s_lock_class = (flags & MS_UNION) ? 1 : 0;
 		s->s_bdi = &default_backing_dev_info;
 		INIT_HLIST_NODE(&s->s_instances);
 		INIT_HLIST_BL_HEAD(&s->s_anon);
@@ -449,6 +450,13 @@ retry:
 				deactivate_locked_super(old);
 				goto retry;
 			}
+#ifdef CONFIG_UNION_MOUNT
+			if (unlikely((old->s_flags | flags) & MS_UNION)) {
+				up_write(&old->s_umount);
+				deactivate_locked_super(old);
+				return ERR_PTR(-EINVAL);
+			}
+#endif
 			return old;
 		}
 	}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f19772c..e130d00 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1417,6 +1417,7 @@ struct super_block {
 	dev_t			s_dev;		/* search index; _not_ kdev_t */
 	unsigned char		s_dirt;
 	unsigned char		s_blocksize_bits;
+	u8			s_lock_class;	/* Set of lock classes to use */
 	unsigned long		s_blocksize;
 	loff_t			s_maxbytes;	/* Max file size */
 	struct file_system_type	*s_type;
@@ -1861,8 +1862,8 @@ struct file_system_type {
 	struct lock_class_key s_vfs_rename_key;
 
 	struct lock_class_key i_lock_key;
-	struct lock_class_key i_mutex_key;
-	struct lock_class_key i_mutex_dir_key;
+	struct lock_class_key i_mutex_key[2];
+	struct lock_class_key i_mutex_dir_key[2];
 };
 
 extern struct dentry *mount_ns(struct file_system_type *fs_type, int flags,

