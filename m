Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab0K0KcF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:32:05 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34794 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752926Ab0K0K0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:21 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3K9doVHBIph
Message-Id: <2aca8c8ed8c27d06b02ff16629fc0a8a0bfb6741.1290852960.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:45:07 +1100
Subject: [PATCH 37/46] fs: cache optimise dentry and inode for rcu-walk
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put dentry and inode fields into top of data structure.  This allows RCU path
traversal to perform an RCU dentry lookup in a path walk by touching only the
first 56 bytes of the dentry.

We also fit in 8 bytes of inline name in the first 64 bytes, so for short
names, only 64 bytes needs to be touched to perform the lookup.

inode is also rearranged so that RCU lookup will only touch a single cacheline
in the inode, plus one in the i_ops structure.

This is important for directory component lookups in RCU path walking. In the
kernel source, directory names average is around 6 chars, so this works.

When we reach the last element of the lookup, we need to lock it and take its
refcount which requires another cacheline access.

XXX: verify memory accesses.
XXX: could cacheline align xxx_operations structure
XXX: could juggle things around differently -- ie. lock and count
rather than name in the first 64.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/dcache.c            |    2 --
 include/linux/dcache.h |   32 +++++++++++++++-----------------
 include/linux/fs.h     |   40 ++++++++++++++++++++++------------------
 3 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 879e5b3..58faf37 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -84,8 +84,6 @@ EXPORT_SYMBOL(dcache_hash_lock);
 
 static struct kmem_cache *dentry_cache __read_mostly;
 
-#define DNAME_INLINE_LEN (sizeof(struct dentry)-offsetof(struct dentry,d_iname))
-
 /*
  * This is the single most critical data structure when it comes
  * to the dcache: the hashtable for lookups. Somebody should try
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 79a89af..3c5cafc 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -81,26 +81,30 @@ full_name_hash(const unsigned char *name, unsigned int len)
  * give reasonable cacheline footprint with larger lines without the
  * large memory footprint increase).
  */
-#ifdef CONFIG_64BIT /* XXX update */
-#define DNAME_INLINE_LEN_MIN 32 /* 192 bytes */
+#ifdef CONFIG_64BIT
+#define DNAME_INLINE_LEN 32 /* 192 bytes */
 #else
-#define DNAME_INLINE_LEN_MIN 40 /* 128 bytes */
+#define DNAME_INLINE_LEN 40 /* 128 bytes */
 #endif
 
 struct dentry {
-	unsigned int d_count;		/* protected by d_lock */
+	/* RCU lookup touched fields */
 	unsigned int d_flags;		/* protected by d_lock */
-	spinlock_t d_lock;		/* per dentry lock */
 	seqcount_t d_seq;		/* per dentry seqlock */
-	struct inode *d_inode;		/* Where the name belongs to - NULL is
-					 * negative */
-	/*
-	 * The next three fields are touched by __d_lookup.  Place them here
-	 * so they all fit in a cache line.
-	 */
 	struct hlist_node d_hash;	/* lookup hash list */
 	struct dentry *d_parent;	/* parent directory */
 	struct qstr d_name;
+	struct inode *d_inode;		/* Where the name belongs to - NULL is
+					 * negative */
+	unsigned char d_iname[DNAME_INLINE_LEN];	/* small names */
+
+	/* Ref lookup also touches following */
+	unsigned int d_count;		/* protected by d_lock */
+	spinlock_t d_lock;		/* per dentry lock */
+	const struct dentry_operations *d_op;
+	struct super_block *d_sb;	/* The root of the dentry tree */
+	unsigned long d_time;		/* used by d_revalidate */
+	void *d_fsdata;			/* fs-specific data */
 
 	struct list_head d_lru;		/* LRU list */
 	/*
@@ -112,12 +116,6 @@ struct dentry {
 	} d_u;
 	struct list_head d_subdirs;	/* our children */
 	struct list_head d_alias;	/* inode alias list */
-	unsigned long d_time;		/* used by d_revalidate */
-	const struct dentry_operations *d_op;
-	struct super_block *d_sb;	/* The root of the dentry tree */
-	void *d_fsdata;			/* fs-specific data */
-
-	unsigned char d_iname[DNAME_INLINE_LEN_MIN];	/* small names */
 };
 
 /*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 03937b7..07e8a50 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -732,6 +732,20 @@ struct posix_acl;
 #define ACL_NOT_CACHED ((void *)(-1))
 
 struct inode {
+	/* RCU path lookup touches following: */
+	umode_t			i_mode;
+	uid_t			i_uid;
+	gid_t			i_gid;
+	const struct inode_operations	*i_op;
+	struct super_block	*i_sb;
+
+	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */
+	unsigned int		i_flags;
+	struct mutex		i_mutex;
+
+	unsigned long		i_state;
+	unsigned long		dirtied_when;	/* jiffies of first dirtying */
+
 	struct hlist_node	i_hash;
 	struct list_head	i_wb_list;	/* backing dev IO list */
 	struct list_head	i_lru;		/* inode LRU list */
@@ -743,8 +757,6 @@ struct inode {
 	unsigned long		i_ino;
 	atomic_t		i_count;
 	unsigned int		i_nlink;
-	uid_t			i_uid;
-	gid_t			i_gid;
 	dev_t			i_rdev;
 	unsigned int		i_blkbits;
 	u64			i_version;
@@ -757,13 +769,8 @@ struct inode {
 	struct timespec		i_ctime;
 	blkcnt_t		i_blocks;
 	unsigned short          i_bytes;
-	umode_t			i_mode;
-	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */
-	struct mutex		i_mutex;
 	struct rw_semaphore	i_alloc_sem;
-	const struct inode_operations	*i_op;
 	const struct file_operations	*i_fop;	/* former ->i_op->default_file_ops */
-	struct super_block	*i_sb;
 	struct file_lock	*i_flock;
 	struct address_space	*i_mapping;
 	struct address_space	i_data;
@@ -784,11 +791,6 @@ struct inode {
 	struct hlist_head	i_fsnotify_marks;
 #endif
 
-	unsigned long		i_state;
-	unsigned long		dirtied_when;	/* jiffies of first dirtying */
-
-	unsigned int		i_flags;
-
 #ifdef CONFIG_IMA
 	/* protected by i_lock */
 	unsigned int		i_readcount; /* struct files open RO */
@@ -1548,8 +1550,15 @@ struct file_operations {
 };
 
 struct inode_operations {
-	int (*create) (struct inode *,struct dentry *,int, struct nameidata *);
 	struct dentry * (*lookup) (struct inode *,struct dentry *, struct nameidata *);
+	void * (*follow_link) (struct dentry *, struct nameidata *);
+	int (*permission) (struct inode *, int);
+	int (*check_acl)(struct inode *, int);
+
+	int (*readlink) (struct dentry *, char __user *,int);
+	void (*put_link) (struct dentry *, struct nameidata *, void *);
+
+	int (*create) (struct inode *,struct dentry *,int, struct nameidata *);
 	int (*link) (struct dentry *,struct inode *,struct dentry *);
 	int (*unlink) (struct inode *,struct dentry *);
 	int (*symlink) (struct inode *,struct dentry *,const char *);
@@ -1558,12 +1567,7 @@ struct inode_operations {
 	int (*mknod) (struct inode *,struct dentry *,int,dev_t);
 	int (*rename) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *);
-	int (*readlink) (struct dentry *, char __user *,int);
-	void * (*follow_link) (struct dentry *, struct nameidata *);
-	void (*put_link) (struct dentry *, struct nameidata *, void *);
 	void (*truncate) (struct inode *);
-	int (*permission) (struct inode *, int);
-	int (*check_acl)(struct inode *, int);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
 	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
-- 
1.7.1

