Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab1GKOuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:50:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757769Ab1GKOuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:50:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] union-mount: Duplicate the i_{,
 dir_}mutex lock classes and use for upper layer
To: peterz@infradead.org
Cc: dhowells@redhat.com, aviro@redhat.com, hch@infradead.org,
        hramrach@centrum.cz, ikent@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmoyer@redhat.com, miklos@szeredi.hu
Date: Mon, 11 Jul 2011 15:50:21 +0100
Message-ID: <20110711145021.18050.76571.stgit@warthog.procyon.org.uk>
In-Reply-To: <1310392930.18678.63.camel@twins>
References: <1310392930.18678.63.camel@twins>
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
---

 fs/inode.c         |   48 ++++++++++++++++++++++++++++++++++++------------
 fs/namespace.c     |    2 +-
 fs/super.c         |    8 ++++++++
 include/linux/fs.h |    5 +++--
 4 files changed, 48 insertions(+), 15 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 43566d1..95d076d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -173,8 +173,14 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
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
 
 	init_rwsem(&inode->i_alloc_sem);
 	lockdep_set_class(&inode->i_alloc_sem, &sb->s_type->i_alloc_sem_key);
@@ -882,18 +888,36 @@ void unlock_new_inode(struct inode *inode)
 {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
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
 #endif
diff --git a/fs/namespace.c b/fs/namespace.c
index 18958fd..59f0942 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2611,7 +2611,7 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE | MS_BORN |
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
-		   MS_STRICTATIME | MS_UNION);
+		   MS_STRICTATIME);
 
 	if (flags & MS_REMOUNT)
 		retval = do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,
diff --git a/fs/super.c b/fs/super.c
index 95a2ebc..cd60a34 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -74,6 +74,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 		INIT_LIST_HEAD(&s->s_files);
 #endif
 		s->s_flags = flags;
+		s->s_lock_class = (flags & MS_UNION) ? 1 : 0;
 		s->s_bdi = &default_backing_dev_info;
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_BL_HEAD(&s->s_anon);
@@ -346,6 +347,13 @@ retry:
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
index 4bf3903..2fd73a9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1373,6 +1373,7 @@ struct super_block {
 	dev_t			s_dev;		/* search index; _not_ kdev_t */
 	unsigned char		s_dirt;
 	unsigned char		s_blocksize_bits;
+	u8			s_lock_class;	/* Set of lock classes to use */
 	unsigned long		s_blocksize;
 	loff_t			s_maxbytes;	/* Max file size */
 	struct file_system_type	*s_type;
@@ -1842,8 +1843,8 @@ struct file_system_type {
 	struct lock_class_key s_vfs_rename_key;
 
 	struct lock_class_key i_lock_key;
-	struct lock_class_key i_mutex_key;
-	struct lock_class_key i_mutex_dir_key;
+	struct lock_class_key i_mutex_key[2];
+	struct lock_class_key i_mutex_dir_key[2];
 	struct lock_class_key i_alloc_sem_key;
 };
 

