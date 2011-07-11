Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab1GKMBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 08:01:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:43140 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab1GKMBO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 08:01:14 -0400
Subject: Re: Union mount and lockdep design issues
From: Peter Zijlstra <peterz@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Alexander Viro <aviro@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Michal Suchanek <hramrach@centrum.cz>, Ian Kent <ikent@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, miklos@szeredi.hu
In-Reply-To: <1408.1310382069@redhat.com>
References: <1310305703.13309.7.camel@twins> <4E0AF2BA.2040706@gmail.com>
	 <1302756608.2854.10.camel@perseus.themaw.net>
	 <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
	 <4DA4B6A8.7030804@gmail.com>
	 <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
	 <4DA5DCB8.3040101@gmail.com>
	 <BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com>
	 <4DA5F569.9020309@gmail.com>
	 <BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com>
	 <24792.1302808448@redhat.com> <2477.1309342656@redhat.com>
	 <4E1962BE.8010204@redhat.com>   <1408.1310382069@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 11 Jul 2011 14:00:51 +0200
Message-ID: <1310385651.18678.59.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-11 at 12:01 +0100, David Howells wrote:
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > > The main problem I've got is that it causes lockdep to generate warnings
> > > > when the top layer and one of the lower layers are of the same
> > > > filesystem type.  The obvious way round this is to give each superblock
> > > > its own i_mutex lock class rather than putting this in the
> > > > file_system_type struct, but I'm not sure of the consequences (the two
> > > > obvious problems are superblock transience and the fact that there may
> > > > be so many more of them that it may explode lockdep).
> > 
> > Can't, that would involve classes in dynamically allocated memory (as
> > you cannot a-priori determine how many instances there will be of a
> > particular sb). There a number of good (although at times rather
> > frustrating) reasons why lockdep cannot do dynamic memory.
> 
> What does this mean for filesystem modules that get removed and inserted
> again?  That's something I do during development rather than rebooting the
> machine.

At some point lockdep runs out of resources and you'll have to reboot.
This is true for all module muck.

> > Most of those arguments center around things like: allocating memory
> > involves locks, therefore we could end up wanting to allocate memory
> > while in the allocator etc.
> 
> I'm not sure what these arguments are.  Initialising the lock class doesn't
> need to be done with any locks held.

Correct, however we require all class keys to be of static storage,
using dynamic storage for keys would entail having to tear down lock
relations on free.

Furthermore, once a lock class gets used it consumes resources, its
needs to get linked into dependency chains etc.. all that is at lock
usage sites.

> I assumed the problems came from key reuse and the storage of out-of-date
> keys, and an over-abundance of keys, where a lock class's key is simply the
> pointer to its struct.

Right, that too is a problem (partially already exposed by using
modules), compile time static storage isn't actually static in the face
of removable modules, and we leak resources from our static pools on
rmmod.

> > Also, why would you want to have a class per sb-instance? From last
> > talking to David, he said there could only ever be 2 filesystems
> > involved in this, the top and bottom, and it is determined on (union)
> > mount time which is which.
> 
> There can be more than 2 - one upperfs (the actual union) and many lowerfs -
> though I think only one lowerfs is accessed at a time.

Right, however I understood from our earlier discussion that the vfs
would only ever try to lock 2 filesystems at a time, the top and one
lower.

> However, I was wondering that if in the future it could be possible to make it
> possible to union over a union.  I think that conceptually it shouldn't be that
> hard, but definitely lockdep presents a barrier unless the top union goes
> behind the scenes of the lower union and interacts with its lowerfs's directly.

Aside from lockdep, how many fs locks will you nest and how will you
enforce the filesystem relations remain a DAG? But yeah, that'll be a
tad harder to do. One of the ways we could tackle that is create a lock
class per depth, and statically create say 16 of those, allowing for a
DAG with span of 16.

> > I'm also assuming that once a filesystem is part of a union mount, it
> > cannot be accessed from outside of said union (can it? can the botton be
> > itself be the top layer of another union?)
> 
> Not at the moment; the hard read-only requirements on the lowerfs versus the
> writeability requirements of the upperfs (you can't enter a directory that you
> can't mirror up) prevent it.
> 
> However, at some point I'd be interested in trying to make it possible to union
> over a writeable filesystem.  This is pretty much a requirement for unioning
> over NFS (as you can't tell the server to make the volume you're mounting hard
> read-only).

Right, ok, but lets try and make the current situation work first. I
understand the desire to later grow.

> > Therefore, why can't we, on constructing the union layers, reset the lock
> > classes?
> 
> Reset in what sense?

Change lock class, we can change the lock class of a lock (easier if not
held, not impossible when held, although in the latter case you'll
obviously establish a relation between the new class and possibly other
held locks).

> > Also, in what state are the filesystems on construction of the union?  Are
> > they already fully formed and populated (do inodes already exist?)
> 
> The lower filesystems must be fully formed and, at present, may not be modified
> whilst in the union.
> 
> The upper filesystem can be empty or filled by a previous union.  In fact,
> there's nothing stopping the upper fs being an ordinary fs that's then used as
> the upper layer in a union, but I'm not sure you can then access the lower
> echelons as the directories don't contain fallthru entries.

Right, so in both cases they can be fully formed, in that case we'll
need to iterate all inodes and change their lock class as well.

Going from pure vfs-ignorance, something like the below (does the inode
locks only, are the sb locks also required?), where the union-mount will
call reclassify_fs() and provide the correct fs depth (max 1 for now, to
be extended later when you do the full DAG thing).


---
 fs/inode.c         |   43 +++++++++++++++++++++++++++++++++++--------
 fs/super.c         |    7 +++++++
 include/linux/fs.h |   22 ++++++++++++++++++----
 3 files changed, 60 insertions(+), 12 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 43566d1..dfb5b11 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -171,13 +171,13 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	if (security_inode_alloc(inode))
 		goto out;
 	spin_lock_init(&inode->i_lock);
-	lockdep_set_class(&inode->i_lock, &sb->s_type->i_lock_key);
+	lockdep_set_class(&inode->i_lock, sb->i_lock_key);
 
 	mutex_init(&inode->i_mutex);
-	lockdep_set_class(&inode->i_mutex, &sb->s_type->i_mutex_key);
+	lockdep_set_class(&inode->i_mutex, sb->i_mutex_key);
 
 	init_rwsem(&inode->i_alloc_sem);
-	lockdep_set_class(&inode->i_alloc_sem, &sb->s_type->i_alloc_sem_key);
+	lockdep_set_class(&inode->i_alloc_sem, sb->i_alloc_sem_key);
 
 	mapping->a_ops = &empty_aops;
 	mapping->host = inode;
@@ -882,18 +882,16 @@ void unlock_new_inode(struct inode *inode)
 {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	if (S_ISDIR(inode->i_mode)) {
-		struct file_system_type *type = inode->i_sb->s_type;
+		struct super_block *sb = inode->i_sb;
 
 		/* Set new key only if filesystem hasn't already changed it */
-		if (!lockdep_match_class(&inode->i_mutex,
-		    &type->i_mutex_key)) {
+		if (!lockdep_match_class(&inode->i_mutex, sb->i_mutex_key)) {
 			/*
 			 * ensure nobody is actually holding i_mutex
 			 */
 			mutex_destroy(&inode->i_mutex);
 			mutex_init(&inode->i_mutex);
-			lockdep_set_class(&inode->i_mutex,
-					  &type->i_mutex_dir_key);
+			lockdep_set_class(&inode->i_mutex, sb->i_mutex_dir_key);
 		}
 	}
 #endif
@@ -905,6 +903,35 @@ void unlock_new_inode(struct inode *inode)
 }
 EXPORT_SYMBOL(unlock_new_inode);
 
+void reclassify_sb(struct super_block *sb, int level)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct file_system_type *type = sb->s_type;
+	struct inode *inode;
+
+	WARN_ON_ONCE(level >= LOCKDEP_FS_KEYS);
+
+	s->i_lock_key = &type->i_lock_key[level];
+	s->i_mutex_key = &type->i_mutex_key[level];
+	s->i_mutex_dir_key = &type->i_mutex_dir_key[level];
+	s->i_alloc_sem_key = &type->i_alloc_sem_key[level];
+
+	spin_lock(&inode_sb_list_lock);
+	list_for_each_entry(inode, sb->s_inodes, i_sb_list) {
+		// XXX is the inode unused and unlocked ?!
+		
+		lockdep_set_class(&inode->i_lock, sb->i_lock_key);
+		if (S_ISDIR(inode->i_mode))
+			lockdep_set_class(&inode->i_mutex, sb->i_mutex_dir_key);
+		else
+			lockdep_set_class(&inode->i_mutex, sb->i_mutex_key);
+		lockdep_set_class(&inode->i_alloc_sem, sb->i_alloc_sem_key);
+	}
+	spin_unlock(&inode_sb_list_lock);
+#endif
+}
+EXPORT_SYMBOL(reclassify_sb);
+
 /**
  * iget5_locked - obtain an inode from a mounted file system
  * @sb:		super block of file system
diff --git a/fs/super.c b/fs/super.c
index ab3d672..dca208b 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -114,6 +114,13 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		s->s_op = &default_op;
 		s->s_time_gran = 1000000000;
 		s->cleancache_poolid = -1;
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+		s->i_lock_key = &type->i_lock_key[0];
+		s->i_mutex_key = &type->i_mutex_key[0];
+		s->i_mutex_dir_key = &type->i_mutex_dir_key[0];
+		s->i_alloc_sem_key = &type->i_alloc_sem_key[0];
+#endif
 	}
 out:
 	return s;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b5b9792..ef43ac3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1438,6 +1438,13 @@ struct super_block {
 	 * Saved pool identifier for cleancache (-1 means none)
 	 */
 	int cleancache_poolid;
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lock_class_key *i_lock_key;
+	struct lock_class_key *i_mutex_key;
+	struct lock_class_key *i_mutex_dir_key;
+	struct lock_class_key *i_alloc_sem_key;
+#endif
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
@@ -1799,6 +1806,13 @@ static inline void file_accessed(struct file *file)
 int sync_inode(struct inode *inode, struct writeback_control *wbc);
 int sync_inode_metadata(struct inode *inode, int wait);
 
+/*
+ * The number of different inode lock keys, used for union mounts
+ * so that layers of the same file_system_type may still nest without
+ * making lockdep upset.
+ */
+#define LOCKDEP_FS_KEYS	2
+
 struct file_system_type {
 	const char *name;
 	int fs_flags;
@@ -1813,10 +1827,10 @@ struct file_system_type {
 	struct lock_class_key s_umount_key;
 	struct lock_class_key s_vfs_rename_key;
 
-	struct lock_class_key i_lock_key;
-	struct lock_class_key i_mutex_key;
-	struct lock_class_key i_mutex_dir_key;
-	struct lock_class_key i_alloc_sem_key;
+	struct lock_class_key i_lock_key[LOCKDEP_FS_KEYS];
+	struct lock_class_key i_mutex_key[LOCKDEP_FS_KEYS];
+	struct lock_class_key i_mutex_dir_key[LOCKDEP_FS_KEYS];
+	struct lock_class_key i_alloc_sem_key[LOCKDEP_FS_KEYS];
 };
 
 extern struct dentry *mount_ns(struct file_system_type *fs_type, int flags,

