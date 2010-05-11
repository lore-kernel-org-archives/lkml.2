Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab0EKPwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:52:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253Ab0EKPwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:52:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CacheFiles: Fix occasional EIO on call to vfs_unlink()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, gregm@servu.net.au, moseleymark@gmail.com,
       romain.degez@smartjog.com, linux-cachefs@redhat.com,
       linux-kernel@vger.kernel.org
Date: Tue, 11 May 2010 16:51:39 +0100
Message-ID: <20100511155139.28216.74663.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an occasional EIO returned by a call to vfs_unlink():

	[ 4868.465413] CacheFiles: I/O Error: Unlink failed
	[ 4868.465444] FS-Cache: Cache cachefiles stopped due to I/O error
	[ 4947.320011] CacheFiles: File cache on md3 unregistering
	[ 4947.320041] FS-Cache: Withdrawing cache "mycache"
	[ 5127.348683] FS-Cache: Cache "mycache" added (type cachefiles)
	[ 5127.348716] CacheFiles: File cache on md3 registered
	[ 7076.871081] CacheFiles: I/O Error: Unlink failed
	[ 7076.871130] FS-Cache: Cache cachefiles stopped due to I/O error
	[ 7116.780891] CacheFiles: File cache on md3 unregistering
	[ 7116.780937] FS-Cache: Withdrawing cache "mycache"
	[ 7296.813394] FS-Cache: Cache "mycache" added (type cachefiles)
	[ 7296.813432] CacheFiles: File cache on md3 registered

What happens is this:

 (1) A cached NFS file is seen to have become out of date, so NFS retires the
     object and immediately acquires a new object with the same key.

 (2) Retirement of the old object is done asynchronously - so the lookup/create
     to generate the new object may be done first.

     This can be a problem as the old object and the new object must exist at
     the same point in the backing filesystem (i.e. they must have the same
     pathname).

 (3) The lookup for the new object sees that a backing file already exists,
     checks to see whether it is valid and sees that it isn't.  It then deletes
     that file and creates a new one on disk.

 (4) The retirement phase for the old file is then performed.  It tries to
     delete the dentry it has, but ext4_unlink() returns -EIO because the inode
     attached to that dentry no longer matches the inode number associated with
     the filename in the parent directory.

The trace below shows this quite well.

	[md5sum] ==> __fscache_relinquish_cookie(ffff88002d12fb58{NFS.fh,ffff88002ce62100},1)
	[md5sum] ==> __fscache_acquire_cookie({NFS.server},{NFS.fh},ffff88002ce62100)

NFS has retired the old cookie and asked for a new one.

	[kslowd] ==> fscache_object_state_machine({OBJ52,OBJECT_ACTIVE,24})
	[kslowd] <== fscache_object_state_machine() [->OBJECT_DYING]
	[kslowd] ==> fscache_object_state_machine({OBJ53,OBJECT_INIT,0})
	[kslowd] <== fscache_object_state_machine() [->OBJECT_LOOKING_UP]
	[kslowd] ==> fscache_object_state_machine({OBJ52,OBJECT_DYING,24})
	[kslowd] <== fscache_object_state_machine() [->OBJECT_RECYCLING]

The old object (OBJ52) is going through the terminal states to get rid of it,
whilst the new object - (OBJ53) - is coming into being.

	[kslowd] ==> fscache_object_state_machine({OBJ53,OBJECT_LOOKING_UP,0})
	[kslowd] ==> cachefiles_walk_to_object({ffff88003029d8b8},OBJ53,@68,)
	[kslowd] lookup '@68'
	[kslowd] next -> ffff88002ce41bd0 positive
	[kslowd] advance
	[kslowd] lookup 'Es0g00og0_Nd_XCYe3BOzvXrsBLMlN6aw16M1htaA'
	[kslowd] next -> ffff8800369faac8 positive

The new object has looked up the subdir in which the file would be in (getting
dentry ffff88002ce41bd0) and then looked up the file itself (getting dentry
ffff8800369faac8).

	[kslowd] validate 'Es0g00og0_Nd_XCYe3BOzvXrsBLMlN6aw16M1htaA'
	[kslowd] ==> cachefiles_bury_object(,'@68','Es0g00og0_Nd_XCYe3BOzvXrsBLMlN6aw16M1htaA')
	[kslowd] remove ffff8800369faac8 from ffff88002ce41bd0
	[kslowd] unlink stale object
	[kslowd] <== cachefiles_bury_object() = 0

It then checks the file's xattrs to see if it's valid.  NFS says that the
auxiliary data indicate the file is out of date (obvious to us - that's why NFS
ditched the old version and got a new one).  CacheFiles then deletes the old
file (dentry ffff8800369faac8).

	[kslowd] redo lookup
	[kslowd] lookup 'Es0g00og0_Nd_XCYe3BOzvXrsBLMlN6aw16M1htaA'
	[kslowd] next -> ffff88002cd94288 negative
	[kslowd] create -> ffff88002cd94288{ffff88002cdaf238{ino=148247}}

CacheFiles then redoes the lookup and gets a negative result in a new dentry
(ffff88002cd94288) which it then creates a file for.

	[kslowd] ==> cachefiles_mark_object_active(,OBJ53)
	[kslowd] <== cachefiles_mark_object_active() = 0
	[kslowd] === OBTAINED_OBJECT ===
	[kslowd] <== cachefiles_walk_to_object() = 0 [148247]
	[kslowd] <== fscache_object_state_machine() [->OBJECT_AVAILABLE]

The new object is then marked active and the state machine moves to the
available state - at which point NFS can start filling the object.

	[kslowd] ==> fscache_object_state_machine({OBJ52,OBJECT_RECYCLING,20})
	[kslowd] ==> fscache_release_object()
	[kslowd] ==> cachefiles_drop_object({OBJ52,2})
	[kslowd] ==> cachefiles_delete_object(,OBJ52{ffff8800369faac8})

The old object, meanwhile, goes on with being retired.  If allocation occurs
first, cachefiles_delete_object() has to wait for dir->d_inode->i_mutex to
become available before it can continue.

	[kslowd] ==> cachefiles_bury_object(,'@68','Es0g00og0_Nd_XCYe3BOzvXrsBLMlN6aw16M1htaA')
	[kslowd] remove ffff8800369faac8 from ffff88002ce41bd0
	[kslowd] unlink stale object
	EXT4-fs warning (device sda6): ext4_unlink: Inode number mismatch in unlink (148247!=148193)
	CacheFiles: I/O Error: Unlink failed
	FS-Cache: Cache cachefiles stopped due to I/O error

CacheFiles then tries to delete the file for the old object, but the dentry it
has (ffff8800369faac8) no longer points to a valid inode for that directory
entry, and so ext4_unlink() returns -EIO when de->inode does not match i_ino.

	[kslowd] <== cachefiles_bury_object() = -5
	[kslowd] <== cachefiles_delete_object() = -5
	[kslowd] <== fscache_object_state_machine() [->OBJECT_DEAD]
	[kslowd] ==> fscache_object_state_machine({OBJ53,OBJECT_AVAILABLE,0})
	[kslowd] <== fscache_object_state_machine() [->OBJECT_ACTIVE]

(Note that the above trace includes extra information beyond that produced by
the upstream code).


The fix is to note when an object that is being retired has had its object
deleted preemptively by a replacement object that is being created, and to
skip the second removal attempt in such a case.

Reported-by: Greg M <gregm@servu.net.au>
Reported-by: Mark Moseley <moseleymark@gmail.com>
Reported-by: Romain DEGEZ <romain.degez@smartjog.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cachefiles/internal.h |    1 
 fs/cachefiles/namei.c    |   98 ++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 87 insertions(+), 12 deletions(-)

diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index f7c255f..a8cd821 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -34,6 +34,7 @@ struct cachefiles_object {
 	loff_t				i_size;		/* object size */
 	unsigned long			flags;
 #define CACHEFILES_OBJECT_ACTIVE	0		/* T if marked active */
+#define CACHEFILES_OBJECT_BURIED	1		/* T if preemptively buried */
 	atomic_t			usage;		/* object usage count */
 	uint8_t				type;		/* object type */
 	uint8_t				new;		/* T if object new */
diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index d5db84a..f4a7840 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -93,6 +93,59 @@ static noinline void cachefiles_printk_object(struct cachefiles_object *object,
 }
 
 /*
+ * mark the owner of a dentry, if there is one, to indicate that that dentry
+ * has been preemptively deleted
+ * - the caller must hold the i_mutex on the dentry's parent as required to
+ *   call vfs_unlink(), vfs_rmdir() or vfs_rename()
+ */
+static void cachefiles_mark_object_buried(struct cachefiles_cache *cache,
+					  struct dentry *dentry)
+{
+	struct cachefiles_object *object;
+	struct rb_node *p;
+
+	_enter(",'%*.*s'",
+	       dentry->d_name.len, dentry->d_name.len, dentry->d_name.name);
+
+	write_lock(&cache->active_lock);
+
+	p = cache->active_nodes.rb_node;
+	while (p) {
+		object = rb_entry(p, struct cachefiles_object, active_node);
+		if (object->dentry > dentry)
+			p = p->rb_left;
+		else if (object->dentry < dentry)
+			p = p->rb_right;
+		else
+			goto found_dentry;
+	}
+
+	write_unlock(&cache->active_lock);
+	_leave(" [no owner]");
+	return;
+
+	/* found the dentry for  */
+found_dentry:
+	kdebug("preemptive burial: OBJ%x [%s] %p",
+	       object->fscache.debug_id,
+	       fscache_object_states[object->fscache.state],
+	       dentry);
+
+	if (object->fscache.state < FSCACHE_OBJECT_DYING) {
+		printk(KERN_ERR "\n");
+		printk(KERN_ERR "CacheFiles: Error:"
+		       " Can't preemptively bury live object\n");
+		cachefiles_printk_object(object, NULL);
+	} else if (test_and_set_bit(CACHEFILES_OBJECT_BURIED, &object->flags)) {
+		printk(KERN_ERR "CacheFiles: Error:"
+		       " Object already preemptively buried\n");
+	}
+
+	write_unlock(&cache->active_lock);
+	_leave(" [owner marked]");
+}
+
+/*
  * record the fact that an object is now active
  */
 static int cachefiles_mark_object_active(struct cachefiles_cache *cache,
@@ -219,7 +272,8 @@ requeue:
  */
 static int cachefiles_bury_object(struct cachefiles_cache *cache,
 				  struct dentry *dir,
-				  struct dentry *rep)
+				  struct dentry *rep,
+				  bool preemptive)
 {
 	struct dentry *grave, *trap;
 	char nbuffer[8 + 8 + 1];
@@ -229,11 +283,16 @@ static int cachefiles_bury_object(struct cachefiles_cache *cache,
 	       dir->d_name.len, dir->d_name.len, dir->d_name.name,
 	       rep->d_name.len, rep->d_name.len, rep->d_name.name);
 
+	_debug("remove %p from %p", rep, dir);
+
 	/* non-directories can just be unlinked */
 	if (!S_ISDIR(rep->d_inode->i_mode)) {
 		_debug("unlink stale object");
 		ret = vfs_unlink(dir->d_inode, rep);
 
+		if (preemptive)
+			cachefiles_mark_object_buried(cache, rep);
+
 		mutex_unlock(&dir->d_inode->i_mutex);
 
 		if (ret == -EIO)
@@ -325,6 +384,9 @@ try_again:
 	if (ret != 0 && ret != -ENOMEM)
 		cachefiles_io_error(cache, "Rename failed with error %d", ret);
 
+	if (preemptive)
+		cachefiles_mark_object_buried(cache, rep);
+
 	unlock_rename(cache->graveyard, dir);
 	dput(grave);
 	_leave(" = 0");
@@ -340,7 +402,7 @@ int cachefiles_delete_object(struct cachefiles_cache *cache,
 	struct dentry *dir;
 	int ret;
 
-	_enter(",{%p}", object->dentry);
+	_enter(",OBJ%x{%p}", object->fscache.debug_id, object->dentry);
 
 	ASSERT(object->dentry);
 	ASSERT(object->dentry->d_inode);
@@ -350,15 +412,25 @@ int cachefiles_delete_object(struct cachefiles_cache *cache,
 
 	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
 
-	/* we need to check that our parent is _still_ our parent - it may have
-	 * been renamed */
-	if (dir == object->dentry->d_parent) {
-		ret = cachefiles_bury_object(cache, dir, object->dentry);
-	} else {
-		/* it got moved, presumably by cachefilesd culling it, so it's
-		 * no longer in the key path and we can ignore it */
+	if (test_bit(CACHEFILES_OBJECT_BURIED, &object->flags)) {
+		/* object allocation for the same key preemptively deleted this
+		 * object's file so that it could create its own file */
+		_debug("object preemptively buried");
 		mutex_unlock(&dir->d_inode->i_mutex);
 		ret = 0;
+	} else {
+		/* we need to check that our parent is _still_ our parent - it
+		 * may have been renamed */
+		if (dir == object->dentry->d_parent) {
+			ret = cachefiles_bury_object(cache, dir,
+						     object->dentry, false);
+		} else {
+			/* it got moved, presumably by cachefilesd culling it,
+			 * so it's no longer in the key path and we can ignore
+			 * it */
+			mutex_unlock(&dir->d_inode->i_mutex);
+			ret = 0;
+		}
 	}
 
 	dput(dir);
@@ -381,7 +453,9 @@ int cachefiles_walk_to_object(struct cachefiles_object *parent,
 	const char *name;
 	int ret, nlen;
 
-	_enter("{%p},,%s,", parent->dentry, key);
+	_enter("OBJ%x{%p},OBJ%x,%s,",
+	       parent->fscache.debug_id, parent->dentry,
+	       object->fscache.debug_id, key);
 
 	cache = container_of(parent->fscache.cache,
 			     struct cachefiles_cache, cache);
@@ -509,7 +583,7 @@ lookup_again:
 			 * mutex) */
 			object->dentry = NULL;
 
-			ret = cachefiles_bury_object(cache, dir, next);
+			ret = cachefiles_bury_object(cache, dir, next, true);
 			dput(next);
 			next = NULL;
 
@@ -828,7 +902,7 @@ int cachefiles_cull(struct cachefiles_cache *cache, struct dentry *dir,
 	/*  actually remove the victim (drops the dir mutex) */
 	_debug("bury");
 
-	ret = cachefiles_bury_object(cache, dir, victim);
+	ret = cachefiles_bury_object(cache, dir, victim, false);
 	if (ret < 0)
 		goto error;
 

