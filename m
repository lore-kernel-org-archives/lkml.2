Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab0K0K0t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:26:49 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34785 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753136Ab0K0K0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:40 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3KILLVKgnSCUwSFFIVN
Message-Id: <259d0d687f94146cf83f61667ccdb4a9715856dd.1290852959.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:45:03 +1100
Subject: [PATCH 33/46] fs: rcu-walk for path lookup
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perform common cases of path lookups without any stores or locking in the
ancestor dentry elements. This is called rcu-walk, as opposed to the
current algorithm which is a refcount based walk, or ref-walk.

This results in far fewer atomic operations on every path element,
significantly improving path lookup performance. It also avoids cacheline
bouncing on common dentries, significantly improving scalability.

The overall design is like this:
* Take the RCU lock for the entire path walk, starting with the acquiring
  of the starting path (eg. root/cwd/fd-path). So now dentry refcounts are
  not required for dentry persistence.
* synchronize_rcu is called when unregistering a filesystem, so we can
  access d_ops and i_ops during rcu-walk.
* Similarly take the vfsmount lock for the entire path walk. So now mnt
  refcounts are not required for persistence. Also we are free to perform mount
  lookups, and to assume dentry mount points and mount roots are stable up and
  down the path.
* Have a per-dentry seqlock to protect the dentry name, parent, and inode,
  so we can load this tuple atomically, and also check whether any of its
  members have changed.
* Dentry lookups (based on parent, candidate string tuple) recheck the parent
  sequence after the child is found in case anything changed in the parent
  during the path walk.
* inode is also RCU protected so we can load d_inode and use the inode for
  limited things.
* i_mode, i_uid, i_gid can be tested for exec permissions during path walk.
* i_op can be loaded.

When we reach the destination dentry, we lock it, recheck lookup sequence,
and increment its refcount and mountpoint refcount. RCU and vfsmount locks
are dropped. This is termed "dropping rcu-walk". If the dentry refcount does
not match, we can't drop rcu-walk gracefully and instead return -ECHILD (for
want of a better errno). This signals the path walking code to do the lookup
again with a ref-walk.

Aside from the final dentry, there are other situations that may be encounted
where we cannot continue rcu-walk. In that case, we drop rcu-walk (ie. take
a reference on the last good dentry) and continue with a ref-walk. Again, if
we can drop rcu-walk gracefully, we return -ECHILD and do the whole lookup
using ref-walk. But it is very important that we can continue with ref-walk
for most cases, particularly to avoid the overhead of double lookups, and to
gain the scalability advantages on common path elements (like cwd and root).

The cases where rcu-walk cannot continue are:
* NULL dentry (ie. creat or negative lookup)
* parent with ->d_op->d_hash
* parent with d_inode->i_op->permission or ACLs
* Following links
* Dentry with ->d_op->d_revalidate

Apart from the first, it may be possible to make most of these cases RCU
walked. Though that would require a bit more poking into filesystems, so it
would be better to wait until the base infrastructure is converted.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 Documentation/filesystems/dentry-locking.txt |  172 -------
 Documentation/filesystems/path-lookup.txt    |  247 +++++++++
 fs/dcache.c                                  |  167 ++++++-
 fs/filesystems.c                             |    3 +
 fs/namei.c                                   |  685 ++++++++++++++++++++-----
 include/linux/dcache.h                       |   13 +-
 include/linux/namei.h                        |   15 +-
 7 files changed, 962 insertions(+), 340 deletions(-)
 delete mode 100644 Documentation/filesystems/dentry-locking.txt
 create mode 100644 Documentation/filesystems/path-lookup.txt

diff --git a/Documentation/filesystems/dentry-locking.txt b/Documentation/filesystems/dentry-locking.txt
deleted file mode 100644
index 30b6a40..0000000
--- a/Documentation/filesystems/dentry-locking.txt
+++ /dev/null
@@ -1,172 +0,0 @@
-RCU-based dcache locking model
-==============================
-
-On many workloads, the most common operation on dcache is to look up a
-dentry, given a parent dentry and the name of the child. Typically,
-for every open(), stat() etc., the dentry corresponding to the
-pathname will be looked up by walking the tree starting with the first
-component of the pathname and using that dentry along with the next
-component to look up the next level and so on. Since it is a frequent
-operation for workloads like multiuser environments and web servers,
-it is important to optimize this path.
-
-Prior to 2.5.10, dcache_lock was acquired in d_lookup and thus in
-every component during path look-up. Since 2.5.10 onwards, fast-walk
-algorithm changed this by holding the dcache_lock at the beginning and
-walking as many cached path component dentries as possible. This
-significantly decreases the number of acquisition of
-dcache_lock. However it also increases the lock hold time
-significantly and affects performance in large SMP machines. Since
-2.5.62 kernel, dcache has been using a new locking model that uses RCU
-to make dcache look-up lock-free.
-
-The current dcache locking model is not very different from the
-existing dcache locking model. Prior to 2.5.62 kernel, dcache_lock
-protected the hash chain, d_child, d_alias, d_lru lists as well as
-d_inode and several other things like mount look-up. RCU-based changes
-affect only the way the hash chain is protected. For everything else
-the dcache_lock must be taken for both traversing as well as
-updating. The hash chain updates too take the dcache_lock.  The
-significant change is the way d_lookup traverses the hash chain, it
-doesn't acquire the dcache_lock for this and rely on RCU to ensure
-that the dentry has not been *freed*.
-
-dcache_lock no longer exists, dentry locking is explained in fs/dcache.c
-
-Dcache locking details
-======================
-
-For many multi-user workloads, open() and stat() on files are very
-frequently occurring operations. Both involve walking of path names to
-find the dentry corresponding to the concerned file. In 2.4 kernel,
-dcache_lock was held during look-up of each path component. Contention
-and cache-line bouncing of this global lock caused significant
-scalability problems. With the introduction of RCU in Linux kernel,
-this was worked around by making the look-up of path components during
-path walking lock-free.
-
-
-Safe lock-free look-up of dcache hash table
-===========================================
-
-Dcache is a complex data structure with the hash table entries also
-linked together in other lists. In 2.4 kernel, dcache_lock protected
-all the lists. RCU dentry hash walking works like this:
-
-1. The deletion from hash chain is done using hlist_del_rcu() macro
-   which doesn't initialize next pointer of the deleted dentry and
-   this allows us to walk safely lock-free while a deletion is
-   happening. This is a standard hlist_rcu iteration.
-
-2. Insertion of a dentry into the hash table is done using
-   hlist_add_head_rcu() which take care of ordering the writes - the
-   writes to the dentry must be visible before the dentry is
-   inserted. This works in conjunction with hlist_for_each_rcu(),
-   which has since been replaced by hlist_for_each_entry_rcu(), while
-   walking the hash chain. The only requirement is that all
-   initialization to the dentry must be done before
-   hlist_add_head_rcu() since we don't have lock protection
-   while traversing the hash chain.
-
-3. The dentry looked up without holding locks cannot be returned for
-   walking if it is unhashed. It then may have a NULL d_inode or other
-   bogosity since RCU doesn't protect the other fields in the dentry. We
-   therefore use a flag DCACHE_UNHASHED to indicate unhashed dentries
-   and use this in conjunction with a per-dentry lock (d_lock). Once
-   looked up without locks, we acquire the per-dentry lock (d_lock) and
-   check if the dentry is unhashed. If so, the look-up is failed. If not,
-   the reference count of the dentry is increased and the dentry is
-   returned.
-
-4. Once a dentry is looked up, it must be ensured during the path walk
-   for that component it doesn't go away. In pre-2.5.10 code, this was
-   done holding a reference to the dentry. dcache_rcu does the same.
-   In some sense, dcache_rcu path walking looks like the pre-2.5.10
-   version.
-
-5. All dentry hash chain updates must take the per-dentry lock (see
-   fs/dcache.c). This excludes dput() to ensure that a dentry that has
-   been looked up concurrently does not get deleted before dget() can
-   take a ref.
-
-6. There are several ways to do reference counting of RCU protected
-   objects. One such example is in ipv4 route cache where deferred
-   freeing (using call_rcu()) is done as soon as the reference count
-   goes to zero. This cannot be done in the case of dentries because
-   tearing down of dentries require blocking (dentry_iput()) which
-   isn't supported from RCU callbacks. Instead, tearing down of
-   dentries happen synchronously in dput(), but actual freeing happens
-   later when RCU grace period is over. This allows safe lock-free
-   walking of the hash chains, but a matched dentry may have been
-   partially torn down. The checking of DCACHE_UNHASHED flag with
-   d_lock held detects such dentries and prevents them from being
-   returned from look-up.
-
-
-Maintaining POSIX rename semantics
-==================================
-
-Since look-up of dentries is lock-free, it can race against a
-concurrent rename operation. For example, during rename of file A to
-B, look-up of either A or B must succeed.  So, if look-up of B happens
-after A has been removed from the hash chain but not added to the new
-hash chain, it may fail.  Also, a comparison while the name is being
-written concurrently by a rename may result in false positive matches
-violating rename semantics.  Issues related to race with rename are
-handled as described below :
-
-1. Look-up can be done in two ways - d_lookup() which is safe from
-   simultaneous renames and __d_lookup() which is not.  If
-   __d_lookup() fails, it must be followed up by a d_lookup() to
-   correctly determine whether a dentry is in the hash table or
-   not. d_lookup() protects look-ups using a sequence lock
-   (rename_lock).
-
-2. The name associated with a dentry (d_name) may be changed if a
-   rename is allowed to happen simultaneously. To avoid memcmp() in
-   __d_lookup() go out of bounds due to a rename and false positive
-   comparison, the name comparison is done while holding the
-   per-dentry lock. This prevents concurrent renames during this
-   operation.
-
-3. Hash table walking during look-up may move to a different bucket as
-   the current dentry is moved to a different bucket due to rename.
-   But we use hlists in dcache hash table and they are
-   null-terminated.  So, even if a dentry moves to a different bucket,
-   hash chain walk will terminate. [with a list_head list, it may not
-   since termination is when the list_head in the original bucket is
-   reached].  Since we redo the d_parent check and compare name while
-   holding d_lock, lock-free look-up will not race against d_move().
-
-4. There can be a theoretical race when a dentry keeps coming back to
-   original bucket due to double moves. Due to this look-up may
-   consider that it has never moved and can end up in a infinite loop.
-   But this is not any worse that theoretical livelocks we already
-   have in the kernel.
-
-
-Important guidelines for filesystem developers related to dcache_rcu
-====================================================================
-
-1. Existing dcache interfaces (pre-2.5.62) exported to filesystem
-   don't change. Only dcache internal implementation changes. However
-   filesystems *must not* delete from the dentry hash chains directly
-   using the list macros like allowed earlier. They must use dcache
-   APIs like d_drop() or __d_drop() depending on the situation.
-
-2. d_flags is now protected by a per-dentry lock (d_lock). All access
-   to d_flags must be protected by it.
-
-3. For a hashed dentry, checking of d_count needs to be protected by
-   d_lock.
-
-
-Papers and other documentation on dcache locking
-================================================
-
-1. Scaling dcache with RCU (http://linuxjournal.com/article.php?sid=7124).
-
-2. http://lse.sourceforge.net/locking/dcache/dcache.html
-
-
-
diff --git a/Documentation/filesystems/path-lookup.txt b/Documentation/filesystems/path-lookup.txt
new file mode 100644
index 0000000..5435c13
--- /dev/null
+++ b/Documentation/filesystems/path-lookup.txt
@@ -0,0 +1,247 @@
+Path walking and name lookup locking
+====================================
+
+On many workloads, the most common operation on dcache is to look up a dentry,
+given a parent dentry and the name of the child. Typically, for every open(),
+stat() etc., the dentry corresponding to the pathname will be looked up by
+walking the tree starting with the first component of the pathname and using
+that dentry along with the next component to look up the next level and so on.
+Since it is a frequent operation for workloads like multiuser environments and
+web servers, it is important to optimize this path.
+
+Prior to 2.5.10, dcache_lock was acquired in d_lookup and thus in every
+component during path look-up. Since 2.5.10 onwards, fast-walk algorithm
+changed this by holding the dcache_lock at the beginning and walking as many
+cached path component dentries as possible. This significantly decreases the
+number of acquisition of dcache_lock. However it also increases the lock hold
+time significantly and affects performance in large SMP machines. Since 2.5.62
+kernel, dcache has been using a new locking model that uses RCU to make dcache
+look-up lock-free. Since 2.6.XXX, RCU is used to make dcache look-up and a
+significant part of the path walk completely "store-free" (so no atomics or
+cacheline bouncing on common dentries).
+
+Path walking overview
+=====================
+
+A name string specifies a start (root directory, cwd, fd-relative) and a
+sequence of elements (directory entry names), which together refer to a path in
+the namespace. The elements are strings seperated by '/'.
+
+Name lookups will want to find a particular path that a name string refers to
+(usually the path of the final element, or parent of final element). This is
+done by taking the path given by the name's starting point (which we know in
+advance -- eg.  current->fs->cwd) as the first parent of the lookup. Then
+iteratively for each name element, look up the child of the current parent with
+the given name and if it is not the final entry, make it the parent for the
+next lookup.
+
+The parent must of course be a directory, and we must have appropriate
+permissions on the parent inode to be able to walk into it.
+
+Making the child a parent for the next lookup requires more checks and
+procedures. Symlinks essentially substitute the symlink name for the target
+name in the name string, and require some recursive path walking.  Mount points
+must be followed into, switching from the mount point path to the root of the
+particular mounted vfsmount.
+
+Safe store-free look-up of dcache hash table
+============================================
+
+Path walking then must, broadly, do several particular things:
+- perform directory entry name lookups on (parent, name element) tuples;
+- find the start point of the walk;
+- perform permissions and validity checks on inodes;
+- traverse mount points;
+- traverse symlinks;
+- lookup and create missing parts of the path on demand.
+
+Dcache name lookup
+------------------
+In order to lookup a dcache (parent, name) tuple, we take a hash on the tuple
+use that to select a bucket in the dcache-hash table, and then compare entries
+on the hash list with our tuple.
+
+The hash lists are RCU protected, so list walking is not serialised with
+concurrent updates (insertion, deletion from the hash). This is a standard RCU
+list application with the exception of renames which will be covered below.
+
+Parent and name members of a dentry, as well as its membership in the dcache
+hash, are protected by the per-dentry d_lock spinlock. Parent, name, and inode
+members are also protected by d_seq seqlock, although this offers read-only
+protection and no durability of results so care must be taken when using d_seq
+for synchronisation.
+
+So when walking the dcache hash list, we can lock each dentry in turn, which
+then stabilises the entry, and then we can compare the parent and full name
+string without races. If there is a match, the refcount is incremented and the
+dentry can be unlocked and returned.
+
+All other operations on the dentry such as removal from the hash table must be
+performed under d_lock, so they are excluded until we have completed the
+comparison and have a valid refcount.
+
+Renames
+
+Back to the rename case. In usual RCU protected lists, the only operations that
+will happen to an object is insertion then removal from the list.  The object
+will not be reused until an RCU grace period is complete. This ensures the RCU
+list traversal primitives can run over the object without problems (see RCU
+documentation for how this works).
+
+However when a dentry is renamed, its hash value can change, requiring it to be
+moved to a new hash list. Latency would be far to high to wait for a grace
+period after removing the dentry and before inserting it in the new hash
+bucket, so the dentry is inserted on the new list right away. When the dentry's
+list pointers are updated to point to objects in the new list, this can result
+in a concurrent RCU lookup of the old list veering off into the new (incorrect)
+list and missing the remaining dentries on the list.
+
+It is no problem to walk the wrong list, because the dentry comparisons will
+not match. However it is fatal to miss a matching dentry. So a seqlock is used
+to detect when a rename has occurred, and so the lookup can be retried.
+
+         1      2      3
+        +---+  +---+  +---+
+hlist-->| N-+->| N-+->| N-+->
+head <--+-P |<-+-P |<-+-P |
+        +---+  +---+  +---+
+
+Rename of dentry 2 may require it deleted from the above list, and inserted
+into a new list. Deleting 2 gives the following list.
+
+         1             3
+        +---+         +---+     (don't worry, the longer pointers do not
+hlist-->| N-+-------->| N-+->    impose a measurable performance overhead
+head <--+-P |<--------+-P |      on modern CPUs)
+        +---+         +---+
+          ^      2      ^
+          |    +---+    |
+          |    | N-+----+
+          +----+-P |
+               +---+
+
+This is a standard RCU-list deletion, which leaves the deleted object's
+pointers intact, so a concurrent list walker that is currently looking at
+object 2 will correctly continue to object 3 when it is time to traverse the
+next object.
+
+However, when inserting object 2 onto a new list, we end up with this:
+
+         1             3
+        +---+         +---+
+hlist-->| N-+-------->| N-+->
+head <--+-P |<--------+-P |
+        +---+         +---+
+                 2
+               +---+
+               | N-+---->
+          <----+-P |
+               +---+
+
+Because we didn't wait for a grace period, there may be a concurrent lookup
+still at 2. Now when it follows 2's 'next' pointer, it will walk off into
+another list without ever having checked object 3.
+
+A related, but distinctly different, issue is that of rename atomicity versus
+lookup operations. If a file is renamed from 'A' to 'B', a lookup must only
+find either 'A' or 'B'. So if a lookup of 'A' returns NULL, a subsequent lookup
+of 'B' must succeed (note the reverse is not true).
+
+Between deleting the dentry from the old hash list, and inserting it on the new
+hash list, a lookup may find neither 'A' nor 'B' matching the dentry. The same
+rename seqlock is also used to cover this race in much the same way, by
+retrying a negative lookup result if a rename was in progress.
+
+Seqcount based lookups
+
+Instead of using d_lock to serialise concurrent access to the dentry while
+performing the lookup, it is possible to use d_seq. d_seq protects all the
+dentry members of interest, however they may be changed concurrently. Care must
+be taken to load the members up-front, and not perform any destructive
+operations (pretty much: no non-atomic stores to shared data), and to recheck
+the seqcount when we are "done" with the operation. Retry or abort if the
+seqcount does not match.
+
+What this means is that a caller, provided they are holding RCU lock to
+protect the dentry object from disappearing, can perform a seqcount based
+lookup which does not increment the refcount on the dentry or write to
+it in any way. This returned dentry can be used for subsequent operations
+provided that d_seq is rechecked.
+
+This is useful to perform dentry lookups of intermediate path elements without
+any cacheline bouncing or lock contention. The returned dentries can be used
+to perform subsequent dcache lookups, or we can take a refcount on them by
+taking their d_lock, rechecking d_seq, and then incrementing their refcount.
+
+RCU-walk path walking design
+============================
+
+Path walking code has two distinct modes, ref-walk and rcu-walk. ref-walk
+is the traditional[*] way of performing dcache lookups using d_lock to
+serialise concurrent modifications to the dentry and take a reference count
+on it. ref-walk is simple and obvious, and may sleep, take locks, etc while
+path walking is operating on each dentry. rcu-walk uses seqcount based
+dentry lookups and can perform lookup of intermediate elements without
+performing any stores to shared data in the dentry or inode. rcu-walk can
+not be applied to all cases, eg. if the filesystem must sleep or perform
+non trivial operations, rcu-walk must be switched to ref-walk.
+
+[*] RCU is still used for the dentry hash lookup, but not the full path walk.
+
+The overall design is like this:
+* LOOKUP_RCU is set in nd->flags, which distinguishes rcu-walk from ref-walk.
+* Take the RCU lock for the entire path walk, starting with the acquiring
+  of the starting path (eg. root/cwd/fd-path). So now dentry refcounts are
+  not required for dentry persistence.
+* synchronize_rcu is called when unregistering a filesystem, so we can
+  access d_ops and i_ops during rcu-walk.
+* Similarly take the vfsmount lock for the entire path walk. So now mnt
+  refcounts are not required for persistence. Also we are free to perform mount
+  lookups, and to assume dentry mount points and mount roots are stable up and
+  down the path.
+* Have a per-dentry seqlock to protect the dentry name, parent, and inode,
+  so we can load this tuple atomically, and also check whether any of its
+  members have changed.
+* Dentry lookups (based on parent, candidate string tuple) recheck the parent
+  sequence after the child is found in case anything changed in the parent
+  during the path walk.
+* inode is also RCU protected so we can load d_inode and use the inode for
+  limited things.
+* i_mode, i_uid, i_gid can be tested for exec permissions during path walk.
+* i_op can be loaded.
+
+When we reach the destination dentry, we lock it, recheck lookup sequence,
+and increment its refcount and mountpoint refcount. RCU and vfsmount locks
+are dropped. This is termed "dropping rcu-walk". If the dentry seqcount does
+not match, we can not drop rcu-walk gracefully at the current point in the
+lokup, so instead return -ECHILD (for want of a better errno). This signals the
+path walking code to re-do the entire lookup with a ref-walk.
+
+Aside from the final dentry, there are other situations that may be encounted
+where we cannot continue rcu-walk. In that case, we drop rcu-walk (ie. take
+a reference on the last good dentry) and continue with a ref-walk. Again, if
+we can drop rcu-walk gracefully, we return -ECHILD and do the whole lookup
+using ref-walk. But it is very important that we can continue with ref-walk
+for most cases, particularly to avoid the overhead of double lookups, and to
+gain the scalability advantages on common path elements (like cwd and root).
+
+The cases where rcu-walk cannot continue are:
+* NULL dentry (ie. creat or negative lookup)
+* parent with ->d_op->d_hash
+* parent with d_inode->i_op->permission or ACLs
+* Following links
+* Dentry with ->d_op->d_revalidate
+
+Apart from the first, it may be possible to make most of these cases RCU
+walked. Though that would require a bit more poking into filesystems, so it
+would be better to wait until the base infrastructure is converted.
+
+Papers and other documentation on dcache locking
+================================================
+
+1. Scaling dcache with RCU (http://linuxjournal.com/article.php?sid=7124).
+
+2. http://lse.sourceforge.net/locking/dcache/dcache.html
+
+
+
diff --git a/fs/dcache.c b/fs/dcache.c
index 5abb8f2..5b59807 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -156,7 +156,9 @@ static void dentry_iput(struct dentry * dentry)
 {
 	struct inode *inode = dentry->d_inode;
 	if (inode) {
+		write_seqcount_begin(&dentry->d_seq);
 		dentry->d_inode = NULL;
+		write_seqcount_end(&dentry->d_seq);
 		list_del_init(&dentry->d_alias);
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_inode_lock);
@@ -842,7 +844,9 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 
 			inode = dentry->d_inode;
 			if (inode) {
+				write_seqcount_begin(&dentry->d_seq);
 				dentry->d_inode = NULL;
+				write_seqcount_end(&dentry->d_seq);
 				list_del_init(&dentry->d_alias);
 				if (dentry->d_op && dentry->d_op->d_iput)
 					dentry->d_op->d_iput(dentry, inode);
@@ -1188,6 +1192,7 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 	dentry->d_count = 1;
 	dentry->d_flags = DCACHE_UNHASHED;
 	spin_lock_init(&dentry->d_lock);
+	seqcount_init(&dentry->d_seq);
 	dentry->d_inode = NULL;
 	dentry->d_parent = NULL;
 	dentry->d_sb = NULL;
@@ -1577,6 +1582,114 @@ err_out:
 EXPORT_SYMBOL(d_add_ci);
 
 /**
+ * __d_lookup_rcu - search for a dentry (racy, store-free)
+ * @parent: parent dentry
+ * @name: qstr of name we wish to find
+ * @seq: returns d_seq value at the point where the dentry was found
+ * @inode: returns dentry->d_inode when the inode was found valid.
+ * Returns: dentry, or NULL
+ *
+ * __d_lookup_rcu is the dcache lookup function for rcu-walk name
+ * resolution (store-free path walking) design described in
+ * Documentation/filesystems/path-lookup.txt.
+ *
+ * This is not to be used outside core vfs.
+ */
+struct dentry *__d_lookup_rcu(struct dentry *parent, struct qstr *name,
+				unsigned *seq, struct inode **inode)
+{
+	unsigned int len = name->len;
+	unsigned int hash = name->hash;
+	const unsigned char *str = name->name;
+	struct hlist_head *head = d_hash(parent,hash);
+	struct hlist_node *node;
+	struct dentry *dentry;
+
+ 	/*
+	 * Note: There is significant duplication with __d_lookup_rcu which is
+	 * required to prevent single threaded performance regressions
+	 * especially on architectures where smp_rmb (in seqcounts) are costly.
+	 * Keep the two functions in sync.
+	 */
+
+	/*
+	 * The hash list is protected using RCU.
+	 *
+	 * Carefully use d_seq when comparing a candidate dentry, to avoid
+	 * races with d_move().
+	 *
+	 * It is possible that concurrent renames can mess up our list
+	 * walk here and result in missing our dentry, resulting in the
+	 * false-negative result. d_lookup() protects against concurrent
+	 * renames using rename_lock seqlock.
+	 *
+	 * See Documentation/vfs/dcache-locking.txt for more details.
+	 */
+	hlist_for_each_entry_rcu(dentry, node, head, d_hash) {
+		struct inode *i;
+		const char *tname;
+		int tlen;
+
+		if (dentry->d_name.hash != hash)
+			continue;
+
+seqretry:
+		/* XXX: ensure all d_parent, d_name, d_inode manipulations
+		 * happen under d_seq */
+		*seq = read_seqcount_begin(&dentry->d_seq);
+		if (dentry->d_parent != parent)
+			continue;
+		if (d_unhashed(dentry))
+			continue;
+		tlen = dentry->d_name.len;
+		tname = dentry->d_name.name;
+		i = dentry->d_inode;
+		/*
+		 * This seqcount check is required to ensure name and
+		 * len are loaded atomically, so as not to walk off the
+		 * edge of memory when walking. If we could load this
+		 * atomically some other way, we could drop this check.
+		 */
+		if (read_seqcount_retry(&dentry->d_seq, *seq))
+			goto seqretry;
+		if (parent->d_op && parent->d_op->d_compare) {
+			if (parent->d_op->d_compare(parent,
+						dentry, i,
+						tlen, tname, name))
+				continue;
+		} else {
+			if (tlen != len)
+				continue;
+			if (memcmp(tname, str, tlen))
+				continue;
+		}
+		/*
+		 * No extra seqcount check is required after the name
+		 * compare. The caller must perform a seqcount check in
+		 * order to do anything useful with the returned dentry
+		 * anyway.
+		 */
+		*inode = i;
+		return dentry;
+ 	}
+ 	return NULL;
+}
+
+int __d_rcu_to_refcount(struct dentry *dentry, unsigned seq)
+{
+	int ret = 0;
+
+	if (!read_seqcount_retry(&dentry->d_seq, seq)) {
+		if (IS_ROOT(dentry) || !d_unhashed(dentry)) {
+			ret = 1;
+			dentry->d_count++;
+		}
+	}
+
+	return ret;
+}
+
+/**
  * d_lookup - search for a dentry
  * @parent: parent dentry
  * @name: qstr of name we wish to find
@@ -1587,9 +1700,9 @@ EXPORT_SYMBOL(d_add_ci);
  * dentry is returned. The caller must use dput to free the entry when it has
  * finished using it. %NULL is returned if the dentry does not exist.
  */
-struct dentry * d_lookup(struct dentry * parent, struct qstr * name)
+struct dentry *d_lookup(struct dentry *parent, struct qstr *name)
 {
-	struct dentry * dentry = NULL;
+	struct dentry *dentry;
 	unsigned seq;
 
         do {
@@ -1602,7 +1715,7 @@ struct dentry * d_lookup(struct dentry * parent, struct qstr * name)
 }
 EXPORT_SYMBOL(d_lookup);
 
-/*
+/**
  * __d_lookup - search for a dentry (racy)
  * @parent: parent dentry
  * @name: qstr of name we wish to find
@@ -1617,16 +1730,23 @@ EXPORT_SYMBOL(d_lookup);
  *
  * __d_lookup callers must be commented.
  */
-struct dentry * __d_lookup(struct dentry * parent, struct qstr * name)
+struct dentry *__d_lookup(struct dentry *parent, struct qstr *name)
 {
 	unsigned int len = name->len;
 	unsigned int hash = name->hash;
 	const unsigned char *str = name->name;
 	struct hlist_head *head = d_hash(parent,hash);
-	struct dentry *found = NULL;
 	struct hlist_node *node;
+	struct dentry *found = NULL;
 	struct dentry *dentry;
 
+ 	/*
+	 * Note: There is significant duplication with __d_lookup_rcu which is
+	 * required to prevent single threaded performance regressions
+	 * especially on architectures where smp_rmb (in seqcounts) are costly.
+	 * Keep the two functions in sync.
+	 */
+
 	/*
 	 * The hash list is protected using RCU.
 	 *
@@ -1643,24 +1763,15 @@ struct dentry * __d_lookup(struct dentry * parent, struct qstr * name)
 	rcu_read_lock();
 	
 	hlist_for_each_entry_rcu(dentry, node, head, d_hash) {
-		struct qstr *qstr;
+		const char *tname;
+		int tlen;
 
 		if (dentry->d_name.hash != hash)
 			continue;
-		if (dentry->d_parent != parent)
-			continue;
 
 		spin_lock(&dentry->d_lock);
-
-		/*
-		 * Recheck the dentry after taking the lock - d_move may have
-		 * changed things. Don't bother checking the hash because
-		 * we're about to compare the whole name anyway.
-		 */
 		if (dentry->d_parent != parent)
 			goto next;
-
-		/* non-existing due to RCU? */
 		if (d_unhashed(dentry))
 			goto next;
 
@@ -1668,16 +1779,17 @@ struct dentry * __d_lookup(struct dentry * parent, struct qstr * name)
 		 * It is safe to compare names since d_move() cannot
 		 * change the qstr (protected by d_lock).
 		 */
-		qstr = &dentry->d_name;
+		tlen = dentry->d_name.len;
+		tname = dentry->d_name.name;
 		if (parent->d_op && parent->d_op->d_compare) {
 			if (parent->d_op->d_compare(parent,
 						dentry, dentry->d_inode,
-						qstr->len, qstr->name, name))
+						tlen, tname, name))
 				goto next;
 		} else {
-			if (qstr->len != len)
+			if (tlen != len)
 				goto next;
-			if (memcmp(qstr->name, str, len))
+			if (memcmp(tname, str, tlen))
 				goto next;
 		}
 
@@ -1947,6 +2059,8 @@ void d_move(struct dentry * dentry, struct dentry * target)
 	list_del(&target->d_u.d_child);
 
 	/* Switch the names.. */
+	write_seqcount_begin(&dentry->d_seq);
+	write_seqcount_begin(&target->d_seq);
 	switch_names(dentry, target);
 	swap(dentry->d_name.hash, target->d_name.hash);
 
@@ -1961,6 +2075,8 @@ void d_move(struct dentry * dentry, struct dentry * target)
 		/* And add them back to the (new) parent lists */
 		list_add(&target->d_u.d_child, &target->d_parent->d_subdirs);
 	}
+	write_seqcount_end(&target->d_seq);
+	write_seqcount_end(&dentry->d_seq);
 
 	list_add(&dentry->d_u.d_child, &dentry->d_parent->d_subdirs);
 	if (target->d_parent != dentry->d_parent)
@@ -2045,11 +2161,15 @@ static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
 {
 	struct dentry *dparent, *aparent;
 
+	dparent = dentry->d_parent;
+	aparent = anon->d_parent;
+
+	write_seqcount_begin(&dentry->d_seq);
+	write_seqcount_begin(&anon->d_seq);
+
 	switch_names(dentry, anon);
 	swap(dentry->d_name.hash, anon->d_name.hash);
 
-	dparent = dentry->d_parent;
-	aparent = anon->d_parent;
 
 	/* XXX: hack */
 	/* returns with anon->d_lock held! */
@@ -2072,6 +2192,9 @@ static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
 	else
 		INIT_LIST_HEAD(&anon->d_u.d_child);
 
+	write_seqcount_end(&dentry->d_seq);
+	write_seqcount_end(&anon->d_seq);
+
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dparent->d_lock);
 	spin_unlock(&aparent->d_lock);
diff --git a/fs/filesystems.c b/fs/filesystems.c
index 68ba492..751d6b2 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -115,6 +115,9 @@ int unregister_filesystem(struct file_system_type * fs)
 		tmp = &(*tmp)->next;
 	}
 	write_unlock(&file_systems_lock);
+
+	synchronize_rcu();
+
 	return -EINVAL;
 }
 
diff --git a/fs/namei.c b/fs/namei.c
index 39fda05..5185752 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -169,8 +169,8 @@ EXPORT_SYMBOL(putname);
 /*
  * This does basic POSIX ACL permission checking
  */
-static int acl_permission_check(struct inode *inode, int mask,
-		int (*check_acl)(struct inode *inode, int mask))
+static inline int __acl_permission_check(struct inode *inode, int mask,
+		int (*check_acl)(struct inode *inode, int mask), int rcu)
 {
 	umode_t			mode = inode->i_mode;
 
@@ -180,9 +180,13 @@ static int acl_permission_check(struct inode *inode, int mask,
 		mode >>= 6;
 	else {
 		if (IS_POSIXACL(inode) && (mode & S_IRWXG) && check_acl) {
-			int error = check_acl(inode, mask);
-			if (error != -EAGAIN)
-				return error;
+			if (rcu) {
+				return -ECHILD;
+			} else {
+				int error = check_acl(inode, mask);
+				if (error != -EAGAIN)
+					return error;
+			}
 		}
 
 		if (in_group_p(inode->i_gid))
@@ -197,6 +201,12 @@ static int acl_permission_check(struct inode *inode, int mask,
 	return -EACCES;
 }
 
+static inline int acl_permission_check(struct inode *inode, int mask,
+		int (*check_acl)(struct inode *inode, int mask))
+{
+	return __acl_permission_check(inode, mask, check_acl, 0);
+}
+
 /**
  * generic_permission  -  check for access rights on a Posix-like filesystem
  * @inode:	inode to check access rights for
@@ -374,6 +384,129 @@ void path_put(struct path *path)
 }
 EXPORT_SYMBOL(path_put);
 
+static int nameidata_dentry_drop_rcu(struct nameidata *nd, struct dentry *dentry)
+{
+	struct fs_struct *fs = current->fs;
+	struct dentry *parent = nd->path.dentry;
+
+	BUG_ON(!(nd->flags & LOOKUP_RCU));
+	if (nd->root.mnt) {
+		spin_lock(&fs->lock);
+		if (nd->root.mnt != fs->root.mnt ||
+				nd->root.dentry != fs->root.dentry)
+			goto err_root;
+	}
+	spin_lock(&parent->d_lock);
+	spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+	if (!__d_rcu_to_refcount(dentry, nd->seq))
+		goto err;
+	BUG_ON(dentry->d_parent != parent);
+	BUG_ON(!parent->d_count);
+	parent->d_count++;
+	spin_unlock(&dentry->d_lock);
+	spin_unlock(&parent->d_lock);
+	if (nd->root.mnt) {
+		path_get(&nd->root);
+		spin_unlock(&fs->lock);
+	}
+	mntget(nd->path.mnt);
+
+	rcu_read_unlock();
+	br_read_unlock(vfsmount_lock);
+	nd->flags &= ~LOOKUP_RCU;
+	return 0;
+err:
+	spin_unlock(&dentry->d_lock);
+	spin_unlock(&parent->d_lock);
+err_root:
+	if (nd->root.mnt)
+		spin_unlock(&fs->lock);
+	return -ECHILD;
+}
+
+static int nameidata_drop_rcu(struct nameidata *nd)
+{
+	struct fs_struct *fs = current->fs;
+	struct dentry *dentry = nd->path.dentry;
+
+	BUG_ON(!(nd->flags & LOOKUP_RCU));
+	if (nd->root.mnt) {
+		spin_lock(&fs->lock);
+		if (nd->root.mnt != fs->root.mnt ||
+				nd->root.dentry != fs->root.dentry)
+			goto err_root;
+	}
+	spin_lock(&dentry->d_lock);
+	if (!__d_rcu_to_refcount(dentry, nd->seq))
+		goto err;
+	BUG_ON(nd->inode != dentry->d_inode);
+	spin_unlock(&dentry->d_lock);
+	if (nd->root.mnt) {
+		path_get(&nd->root);
+		spin_unlock(&fs->lock);
+	}
+	mntget(nd->path.mnt);
+
+	rcu_read_unlock();
+	br_read_unlock(vfsmount_lock);
+	nd->flags &= ~LOOKUP_RCU;
+	return 0;
+err:
+	spin_unlock(&dentry->d_lock);
+err_root:
+	if (nd->root.mnt)
+		spin_unlock(&fs->lock);
+	return -ECHILD;
+}
+
+static int nameidata_drop_rcu_last(struct nameidata *nd)
+{
+	struct dentry *dentry = nd->path.dentry;
+
+	BUG_ON(!(nd->flags & LOOKUP_RCU));
+	nd->flags &= ~LOOKUP_RCU;
+	nd->root.mnt = NULL;
+	spin_lock(&dentry->d_lock);
+	if (!__d_rcu_to_refcount(dentry, nd->seq))
+		goto err_unlock;
+	BUG_ON(nd->inode != dentry->d_inode);
+	spin_unlock(&dentry->d_lock);
+
+	mntget(nd->path.mnt);
+
+	rcu_read_unlock();
+	br_read_unlock(vfsmount_lock);
+
+	return 0;
+
+err_unlock:
+	spin_unlock(&dentry->d_lock);
+	rcu_read_unlock();
+	br_read_unlock(vfsmount_lock);
+	return -ECHILD;
+}
+
+static inline int try_nameidata_dentry_drop_rcu(struct nameidata *nd, struct dentry *dentry)
+{
+	if (nd->flags & LOOKUP_RCU)
+		return nameidata_dentry_drop_rcu(nd, dentry);
+	return 0;
+}
+
+static inline int try_nameidata_drop_rcu(struct nameidata *nd)
+{
+	if (nd->flags & LOOKUP_RCU)
+		return nameidata_drop_rcu(nd);
+	return 0;
+}
+
+static inline int try_nameidata_drop_rcu_last(struct nameidata *nd)
+{
+	if (likely(nd->flags & LOOKUP_RCU))
+		return nameidata_drop_rcu_last(nd);
+	return 0;
+}
+
 /**
  * release_open_intent - free up open intent resources
  * @nd: pointer to nameidata
@@ -459,26 +592,40 @@ force_reval_path(struct path *path, struct nameidata *nd)
  * short-cut DAC fails, then call ->permission() to do more
  * complete permission check.
  */
-static int exec_permission(struct inode *inode)
+static inline int __exec_permission(struct inode *inode, int rcu)
 {
 	int ret;
 
 	if (inode->i_op->permission) {
+		if (rcu)
+			return -ECHILD;
 		ret = inode->i_op->permission(inode, MAY_EXEC);
 		if (!ret)
 			goto ok;
 		return ret;
 	}
-	ret = acl_permission_check(inode, MAY_EXEC, inode->i_op->check_acl);
+	ret = __acl_permission_check(inode, MAY_EXEC, inode->i_op->check_acl, rcu);
 	if (!ret)
 		goto ok;
+	if (rcu && ret == -ECHILD)
+		return ret;
 
 	if (capable(CAP_DAC_OVERRIDE) || capable(CAP_DAC_READ_SEARCH))
 		goto ok;
 
 	return ret;
 ok:
-	return security_inode_permission(inode, MAY_EXEC);
+	return security_inode_permission(inode, MAY_EXEC); /* XXX: ok for RCU? */
+}
+
+static int exec_permission(struct inode *inode)
+{
+	return __exec_permission(inode, 0);
+}
+
+static int exec_permission_rcu(struct inode *inode)
+{
+	return __exec_permission(inode, 1);
 }
 
 static __always_inline void set_root(struct nameidata *nd)
@@ -489,8 +636,20 @@ static __always_inline void set_root(struct nameidata *nd)
 
 static int link_path_walk(const char *, struct nameidata *);
 
+static __always_inline void set_root_rcu(struct nameidata *nd)
+{
+	if (!nd->root.mnt) {
+		struct fs_struct *fs = current->fs;
+		spin_lock(&fs->lock);
+		nd->root = fs->root;
+		spin_unlock(&fs->lock);
+	}
+}
+
 static __always_inline int __vfs_follow_link(struct nameidata *nd, const char *link)
 {
+	int ret;
+
 	if (IS_ERR(link))
 		goto fail;
 
@@ -500,8 +659,10 @@ static __always_inline int __vfs_follow_link(struct nameidata *nd, const char *l
 		nd->path = nd->root;
 		path_get(&nd->root);
 	}
+	nd->inode = nd->path.dentry->d_inode;
 
-	return link_path_walk(link, nd);
+	ret = link_path_walk(link, nd);
+	return ret;
 fail:
 	path_put(&nd->path);
 	return PTR_ERR(link);
@@ -516,11 +677,12 @@ static void path_put_conditional(struct path *path, struct nameidata *nd)
 
 static inline void path_to_nameidata(struct path *path, struct nameidata *nd)
 {
-	dput(nd->path.dentry);
-	if (nd->path.mnt != path->mnt) {
-		mntput(nd->path.mnt);
-		nd->path.mnt = path->mnt;
+	if (!(nd->flags & LOOKUP_RCU)) {
+		dput(nd->path.dentry);
+		if (nd->path.mnt != path->mnt)
+			mntput(nd->path.mnt);
 	}
+	nd->path.mnt = path->mnt;
 	nd->path.dentry = path->dentry;
 }
 
@@ -535,9 +697,11 @@ __do_follow_link(struct path *path, struct nameidata *nd, void **p)
 
 	if (path->mnt != nd->path.mnt) {
 		path_to_nameidata(path, nd);
+		nd->inode = nd->path.dentry->d_inode;
 		dget(dentry);
 	}
 	mntget(path->mnt);
+
 	nd->last_type = LAST_BIND;
 	*p = dentry->d_inode->i_op->follow_link(dentry, nd);
 	error = PTR_ERR(*p);
@@ -591,6 +755,20 @@ loop:
 	return err;
 }
 
+static int follow_up_rcu(struct path *path)
+{
+	struct vfsmount *parent;
+	struct dentry *mountpoint;
+
+	parent = path->mnt->mnt_parent;
+	if (parent == path->mnt)
+		return 0;
+	mountpoint = path->mnt->mnt_mountpoint;
+	path->dentry = mountpoint;
+	path->mnt = parent;
+	return 1;
+}
+
 int follow_up(struct path *path)
 {
 	struct vfsmount *parent;
@@ -615,6 +793,21 @@ int follow_up(struct path *path)
 /*
  * serialization is taken care of in namespace.c
  */
+static void __follow_mount_rcu(struct nameidata *nd, struct path *path,
+				struct inode **inode)
+{
+	while (d_mountpoint(path->dentry)) {
+		struct vfsmount *mounted;
+		mounted = __lookup_mnt(path->mnt, path->dentry, 1);
+		if (!mounted)
+			return;
+		path->mnt = mounted;
+		path->dentry = mounted->mnt_root;
+		nd->seq = read_seqcount_begin(&path->dentry->d_seq);
+		*inode = path->dentry->d_inode;
+	}
+}
+
 static int __follow_mount(struct path *path)
 {
 	int res = 0;
@@ -660,7 +853,42 @@ int follow_down(struct path *path)
 	return 0;
 }
 
-static __always_inline void follow_dotdot(struct nameidata *nd)
+static int follow_dotdot_rcu(struct nameidata *nd)
+{
+	struct inode *inode = nd->inode;
+
+	set_root_rcu(nd);
+
+	while(1) {
+		if (nd->path.dentry == nd->root.dentry &&
+		    nd->path.mnt == nd->root.mnt) {
+			break;
+		}
+		if (nd->path.dentry != nd->path.mnt->mnt_root) {
+			struct dentry *old = nd->path.dentry;
+			struct dentry *parent = old->d_parent;
+			unsigned seq;
+
+			seq = read_seqcount_begin(&parent->d_seq);
+			if (read_seqcount_retry(&old->d_seq, nd->seq))
+				return -ECHILD;
+			inode = parent->d_inode;
+			nd->path.dentry = parent;
+			nd->seq = seq;
+			break;
+		}
+		if (!follow_up_rcu(&nd->path))
+			break;
+		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
+		inode = nd->path.dentry->d_inode;
+	}
+	__follow_mount_rcu(nd, &nd->path, &inode);
+	nd->inode = inode;
+
+	return 0;
+}
+
+static void follow_dotdot(struct nameidata *nd)
 {
 	set_root(nd);
 
@@ -681,6 +909,7 @@ static __always_inline void follow_dotdot(struct nameidata *nd)
 			break;
 	}
 	follow_mount(&nd->path);
+	nd->inode = nd->path.dentry->d_inode;
 }
 
 /*
@@ -718,18 +947,17 @@ static struct dentry *d_alloc_and_lookup(struct dentry *parent,
  *  It _is_ time-critical.
  */
 static int do_lookup(struct nameidata *nd, struct qstr *name,
-		     struct path *path)
+			struct path *path, struct inode **inode)
 {
 	struct vfsmount *mnt = nd->path.mnt;
-	struct dentry *dentry, *parent;
+	struct dentry *dentry, *parent = nd->path.dentry;
 	struct inode *dir;
 	/*
 	 * See if the low-level filesystem might want
 	 * to use its own hash..
 	 */
-	if (nd->path.dentry->d_op && nd->path.dentry->d_op->d_hash) {
-		int err = nd->path.dentry->d_op->d_hash(nd->path.dentry,
-				nd->path.dentry->d_inode, name);
+	if (parent->d_op && parent->d_op->d_hash) {
+		int err = parent->d_op->d_hash(parent, nd->inode, name);
 		if (err < 0)
 			return err;
 	}
@@ -739,21 +967,47 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 	 * of a false negative due to a concurrent rename, we're going to
 	 * do the non-racy lookup, below.
 	 */
-	dentry = __d_lookup(nd->path.dentry, name);
-	if (!dentry)
-		goto need_lookup;
+	if (nd->flags & LOOKUP_RCU) {
+		unsigned seq;
+
+		dentry = __d_lookup_rcu(parent, name, &seq, inode);
+		if (!dentry) {
+			if (nameidata_drop_rcu(nd))
+				return -ECHILD;
+			goto need_lookup;
+		}
+		/* Memory barrier in read_seqcount_begin of child is enough */
+		if (__read_seqcount_retry(&parent->d_seq, nd->seq))
+			return -ECHILD;
+
+		nd->seq = seq;
+		if (dentry->d_op && dentry->d_op->d_revalidate) {
+			/* XXX: RCU chokes here */
+			if (nameidata_dentry_drop_rcu(nd, dentry))
+				return -ECHILD;
+			goto need_revalidate;
+		}
+		path->mnt = mnt;
+		path->dentry = dentry;
+		__follow_mount_rcu(nd, path, inode);
+	} else {
+		dentry = __d_lookup(parent, name);
+		if (!dentry)
+			goto need_lookup;
 found:
-	if (dentry->d_op && dentry->d_op->d_revalidate)
-		goto need_revalidate;
+		if (dentry->d_op && dentry->d_op->d_revalidate)
+			goto need_revalidate;
 done:
-	path->mnt = mnt;
-	path->dentry = dentry;
-	__follow_mount(path);
+		path->mnt = mnt;
+		path->dentry = dentry;
+		__follow_mount(path);
+		*inode = path->dentry->d_inode;
+	}
 	return 0;
 
 need_lookup:
-	parent = nd->path.dentry;
 	dir = parent->d_inode;
+	BUG_ON(nd->inode != dir);
 
 	mutex_lock(&dir->i_mutex);
 	/*
@@ -815,7 +1069,6 @@ static inline int follow_on_final(struct inode *inode, unsigned lookup_flags)
 static int link_path_walk(const char *name, struct nameidata *nd)
 {
 	struct path next;
-	struct inode *inode;
 	int err;
 	unsigned int lookup_flags = nd->flags;
 	
@@ -824,18 +1077,28 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 	if (!*name)
 		goto return_reval;
 
-	inode = nd->path.dentry->d_inode;
 	if (nd->depth)
 		lookup_flags = LOOKUP_FOLLOW | (nd->flags & LOOKUP_CONTINUE);
 
 	/* At this point we know we have a real path component. */
 	for(;;) {
+		struct inode *inode;
 		unsigned long hash;
 		struct qstr this;
 		unsigned int c;
 
 		nd->flags |= LOOKUP_CONTINUE;
-		err = exec_permission(inode);
+		if (nd->flags & LOOKUP_RCU) {
+			err = exec_permission_rcu(nd->inode);
+			if (err == -ECHILD) {
+				if (nameidata_drop_rcu(nd))
+					return -ECHILD;
+				goto exec_again;
+			}
+		} else {
+exec_again:
+			err = exec_permission(nd->inode);
+		}
  		if (err)
 			break;
 
@@ -866,37 +1129,44 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 		if (this.name[0] == '.') switch (this.len) {
 			default:
 				break;
-			case 2:	
+			case 2:
 				if (this.name[1] != '.')
 					break;
-				follow_dotdot(nd);
-				inode = nd->path.dentry->d_inode;
+				if (nd->flags & LOOKUP_RCU) {
+					if (follow_dotdot_rcu(nd))
+						return -ECHILD;
+				} else
+					follow_dotdot(nd);
 				/* fallthrough */
 			case 1:
 				continue;
 		}
 		/* This does the actual lookups.. */
-		err = do_lookup(nd, &this, &next);
+		err = do_lookup(nd, &this, &next, &inode);
 		if (err)
 			break;
-
 		err = -ENOENT;
-		inode = next.dentry->d_inode;
 		if (!inode)
 			goto out_dput;
 
 		if (inode->i_op->follow_link) {
+			/* XXX: RCU chokes here */
+			if (try_nameidata_dentry_drop_rcu(nd, next.dentry))
+				return -ECHILD;
+			BUG_ON(inode != next.dentry->d_inode);
 			err = do_follow_link(&next, nd);
 			if (err)
 				goto return_err;
+			nd->inode = nd->path.dentry->d_inode;
 			err = -ENOENT;
-			inode = nd->path.dentry->d_inode;
-			if (!inode)
+			if (!nd->inode)
 				break;
-		} else
+		} else {
 			path_to_nameidata(&next, nd);
+			nd->inode = inode;
+		}
 		err = -ENOTDIR; 
-		if (!inode->i_op->lookup)
+		if (!nd->inode->i_op->lookup)
 			break;
 		continue;
 		/* here ends the main loop */
@@ -911,32 +1181,39 @@ last_component:
 		if (this.name[0] == '.') switch (this.len) {
 			default:
 				break;
-			case 2:	
+			case 2:
 				if (this.name[1] != '.')
 					break;
-				follow_dotdot(nd);
-				inode = nd->path.dentry->d_inode;
+				if (nd->flags & LOOKUP_RCU) {
+					if (follow_dotdot_rcu(nd))
+						return -ECHILD;
+				} else
+					follow_dotdot(nd);
 				/* fallthrough */
 			case 1:
 				goto return_reval;
 		}
-		err = do_lookup(nd, &this, &next);
+		err = do_lookup(nd, &this, &next, &inode);
 		if (err)
 			break;
-		inode = next.dentry->d_inode;
 		if (follow_on_final(inode, lookup_flags)) {
+			if (try_nameidata_dentry_drop_rcu(nd, next.dentry))
+				return -ECHILD;
+			BUG_ON(inode != next.dentry->d_inode);
 			err = do_follow_link(&next, nd);
 			if (err)
 				goto return_err;
-			inode = nd->path.dentry->d_inode;
-		} else
+			nd->inode = nd->path.dentry->d_inode;
+		} else {
 			path_to_nameidata(&next, nd);
+			nd->inode = inode;
+		}
 		err = -ENOENT;
-		if (!inode)
+		if (!nd->inode)
 			break;
 		if (lookup_flags & LOOKUP_DIRECTORY) {
 			err = -ENOTDIR; 
-			if (!inode->i_op->lookup)
+			if (!nd->inode->i_op->lookup)
 				break;
 		}
 		goto return_base;
@@ -958,6 +1235,8 @@ return_reval:
 		 */
 		if (nd->path.dentry && nd->path.dentry->d_sb &&
 		    (nd->path.dentry->d_sb->s_type->fs_flags & FS_REVAL_DOT)) {
+			if (try_nameidata_drop_rcu(nd))
+				return -ECHILD;
 			err = -ESTALE;
 			/* Note: we do not d_invalidate() */
 			if (!nd->path.dentry->d_op->d_revalidate(
@@ -965,16 +1244,34 @@ return_reval:
 				break;
 		}
 return_base:
+		if (try_nameidata_drop_rcu_last(nd))
+			return -ECHILD;
 		return 0;
 out_dput:
-		path_put_conditional(&next, nd);
+		if (!(nd->flags & LOOKUP_RCU))
+			path_put_conditional(&next, nd);
 		break;
 	}
-	path_put(&nd->path);
+	if (!(nd->flags & LOOKUP_RCU))
+		path_put(&nd->path);
 return_err:
 	return err;
 }
 
+static inline int path_walk_rcu(const char *name, struct nameidata *nd)
+{
+	current->total_link_count = 0;
+
+	return link_path_walk(name, nd);
+}
+
+static inline int path_walk_simple(const char *name, struct nameidata *nd)
+{
+	current->total_link_count = 0;
+
+	return link_path_walk(name, nd);
+}
+
 static int path_walk(const char *name, struct nameidata *nd)
 {
 	struct path save = nd->path;
@@ -1000,6 +1297,88 @@ static int path_walk(const char *name, struct nameidata *nd)
 	return result;
 }
 
+static void path_finish_rcu(struct nameidata *nd)
+{
+	if (nd->flags & LOOKUP_RCU) {
+		/* RCU dangling. Cancel it. */
+		nd->flags &= ~LOOKUP_RCU;
+		nd->root.mnt = NULL;
+		rcu_read_unlock();
+		br_read_unlock(vfsmount_lock);
+	}
+	if (nd->file)
+		fput(nd->file);
+}
+
+static int path_init_rcu(int dfd, const char *name, unsigned int flags, struct nameidata *nd)
+{
+	int retval = 0;
+	int fput_needed;
+	struct file *file;
+
+	nd->last_type = LAST_ROOT; /* if there are only slashes... */
+	nd->flags = flags | LOOKUP_RCU;
+	nd->depth = 0;
+	nd->root.mnt = NULL;
+	nd->file = NULL;
+
+	if (*name=='/') {
+		struct fs_struct *fs = current->fs;
+
+		br_read_lock(vfsmount_lock);
+		rcu_read_lock();
+
+		spin_lock(&fs->lock);
+		nd->root = fs->root;
+		nd->path = nd->root;
+		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
+		spin_unlock(&fs->lock);
+
+	} else if (dfd == AT_FDCWD) {
+		struct fs_struct *fs = current->fs;
+
+		br_read_lock(vfsmount_lock);
+		rcu_read_lock();
+
+		spin_lock(&fs->lock);
+		nd->path = fs->pwd;
+		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
+		spin_unlock(&fs->lock);
+	} else {
+		struct dentry *dentry;
+
+		file = fget_light(dfd, &fput_needed);
+		retval = -EBADF;
+		if (!file)
+			goto out_fail;
+
+		dentry = file->f_path.dentry;
+
+		retval = -ENOTDIR;
+		if (!S_ISDIR(dentry->d_inode->i_mode))
+			goto fput_fail;
+
+		retval = file_permission(file, MAY_EXEC);
+		if (retval)
+			goto fput_fail;
+
+		nd->path = file->f_path;
+		if (fput_needed)
+			nd->file = file;
+
+		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
+		br_read_lock(vfsmount_lock);
+		rcu_read_lock();
+	}
+	nd->inode = nd->path.dentry->d_inode;
+	return 0;
+
+fput_fail:
+	fput_light(file, fput_needed);
+out_fail:
+	return retval;
+}
+
 static int path_init(int dfd, const char *name, unsigned int flags, struct nameidata *nd)
 {
 	int retval = 0;
@@ -1040,6 +1419,7 @@ static int path_init(int dfd, const char *name, unsigned int flags, struct namei
 
 		fput_light(file, fput_needed);
 	}
+	nd->inode = nd->path.dentry->d_inode;
 	return 0;
 
 fput_fail:
@@ -1052,16 +1432,39 @@ out_fail:
 static int do_path_lookup(int dfd, const char *name,
 				unsigned int flags, struct nameidata *nd)
 {
-	int retval = path_init(dfd, name, flags, nd);
-	if (!retval)
-		retval = path_walk(name, nd);
-	if (unlikely(!retval && !audit_dummy_context() && nd->path.dentry &&
-				nd->path.dentry->d_inode))
-		audit_inode(name, nd->path.dentry);
+	int retval;
+
+	retval = path_init_rcu(dfd, name, flags, nd);
+	if (unlikely(retval))
+		return retval;
+	retval = path_walk_rcu(name, nd);
+	path_finish_rcu(nd);
 	if (nd->root.mnt) {
 		path_put(&nd->root);
 		nd->root.mnt = NULL;
 	}
+
+	if (unlikely(retval == -ECHILD || retval == -ESTALE)) {
+		/* slower, locked walk */
+		if (retval == -ESTALE)
+			flags |= LOOKUP_REVAL;
+		retval = path_init(dfd, name, flags, nd);
+		if (unlikely(retval))
+			return retval;
+		retval = path_walk(name, nd);
+		if (nd->root.mnt) {
+			path_put(&nd->root);
+			nd->root.mnt = NULL;
+		}
+	}
+
+	if (likely(!retval)) {
+		if (unlikely(!audit_dummy_context())) {
+			if (nd->path.dentry && nd->inode)
+				audit_inode(name, nd->path.dentry);
+		}
+	}
+
 	return retval;
 }
 
@@ -1104,10 +1507,11 @@ int vfs_path_lookup(struct dentry *dentry, struct vfsmount *mnt,
 	path_get(&nd->path);
 	nd->root = nd->path;
 	path_get(&nd->root);
+	nd->inode = nd->path.dentry->d_inode;
 
 	retval = path_walk(name, nd);
 	if (unlikely(!retval && !audit_dummy_context() && nd->path.dentry &&
-				nd->path.dentry->d_inode))
+				nd->inode))
 		audit_inode(name, nd->path.dentry);
 
 	path_put(&nd->root);
@@ -1488,6 +1892,7 @@ out_unlock:
 	mutex_unlock(&dir->d_inode->i_mutex);
 	dput(nd->path.dentry);
 	nd->path.dentry = path->dentry;
+
 	if (error)
 		return error;
 	/* Don't check for write permission, don't truncate */
@@ -1582,6 +1987,9 @@ exit:
 	return ERR_PTR(error);
 }
 
+/*
+ * Handle O_CREAT case for do_filp_open
+ */
 static struct file *do_last(struct nameidata *nd, struct path *path,
 			    int open_flag, int acc_mode,
 			    int mode, const char *pathname)
@@ -1603,42 +2011,17 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 		}
 		/* fallthrough */
 	case LAST_ROOT:
-		if (open_flag & O_CREAT)
-			goto exit;
-		/* fallthrough */
+		goto exit;
 	case LAST_BIND:
 		audit_inode(pathname, dir);
 		goto ok;
 	}
 
 	/* trailing slashes? */
-	if (nd->last.name[nd->last.len]) {
-		if (open_flag & O_CREAT)
-			goto exit;
-		nd->flags |= LOOKUP_DIRECTORY | LOOKUP_FOLLOW;
-	}
-
-	/* just plain open? */
-	if (!(open_flag & O_CREAT)) {
-		error = do_lookup(nd, &nd->last, path);
-		if (error)
-			goto exit;
-		error = -ENOENT;
-		if (!path->dentry->d_inode)
-			goto exit_dput;
-		if (path->dentry->d_inode->i_op->follow_link)
-			return NULL;
-		error = -ENOTDIR;
-		if (nd->flags & LOOKUP_DIRECTORY) {
-			if (!path->dentry->d_inode->i_op->lookup)
-				goto exit_dput;
-		}
-		path_to_nameidata(path, nd);
-		audit_inode(pathname, nd->path.dentry);
-		goto ok;
-	}
+	/* XXX: need to make !O_CREAT case do this properly */
+	if (nd->last.name[nd->last.len])
+		goto exit;
 
-	/* OK, it's O_CREAT */
 	mutex_lock(&dir->d_inode->i_mutex);
 
 	path->dentry = lookup_hash(nd);
@@ -1709,8 +2092,9 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 		return NULL;
 
 	path_to_nameidata(path, nd);
+	nd->inode = path->dentry->d_inode;
 	error = -EISDIR;
-	if (S_ISDIR(path->dentry->d_inode->i_mode))
+	if (S_ISDIR(nd->inode->i_mode))
 		goto exit;
 ok:
 	filp = finish_open(nd, open_flag, acc_mode);
@@ -1741,7 +2125,7 @@ struct file *do_filp_open(int dfd, const char *pathname,
 	struct path path;
 	int count = 0;
 	int flag = open_to_namei_flags(open_flag);
-	int force_reval = 0;
+	int flags;
 
 	if (!(open_flag & O_CREAT))
 		mode = 0;
@@ -1767,54 +2151,84 @@ struct file *do_filp_open(int dfd, const char *pathname,
 	if (open_flag & O_APPEND)
 		acc_mode |= MAY_APPEND;
 
-	/* find the parent */
-reval:
-	error = path_init(dfd, pathname, LOOKUP_PARENT, &nd);
+	flags = LOOKUP_OPEN;
+	if (open_flag & O_CREAT) {
+		flags |= LOOKUP_CREATE;
+		if (open_flag & O_EXCL)
+			flags |= LOOKUP_EXCL;
+	}
+	if (open_flag & O_DIRECTORY)
+		flags |= LOOKUP_DIRECTORY;
+	if (!(open_flag & O_NOFOLLOW))
+		flags |= LOOKUP_FOLLOW;
+
+	filp = get_empty_filp();
+	if (!filp)
+		return ERR_PTR(-ENFILE);
+
+	filp->f_flags = open_flag;
+	nd.intent.open.file = filp;
+	nd.intent.open.flags = flag;
+	nd.intent.open.create_mode = mode;
+
+	if (open_flag & O_CREAT)
+		goto creat;
+
+	/* !O_CREAT, simple open */
+	error = do_path_lookup(dfd, pathname, flags, &nd);
+	if (unlikely(error))
+		goto out_filp;
+	error = -ELOOP;
+	if (!(nd.flags & LOOKUP_FOLLOW)) {
+		if (nd.inode->i_op->follow_link)
+			goto out_path;
+	}
+	error = -ENOTDIR;
+	if (nd.flags & LOOKUP_DIRECTORY) {
+		if (!nd.inode->i_op->lookup)
+			goto out_path;
+	}
+	audit_inode(pathname, nd.path.dentry);
+	filp = finish_open(&nd, open_flag, acc_mode);
+	return filp;
+
+creat:
+	/* OK, have to create the file. Find the parent. */
+	error = path_init_rcu(dfd, pathname,
+			LOOKUP_PARENT | (flags & LOOKUP_REVAL), &nd);
 	if (error)
-		return ERR_PTR(error);
-	if (force_reval)
-		nd.flags |= LOOKUP_REVAL;
+		goto out_filp;
+	error = path_walk_rcu(pathname, &nd);
+	path_finish_rcu(&nd);
+	if (unlikely(error == -ECHILD || error == -ESTALE)) {
+		/* slower, locked walk */
+		if (error == -ESTALE) {
+reval:
+			flags |= LOOKUP_REVAL;
+		}
+		error = path_init(dfd, pathname,
+				LOOKUP_PARENT | (flags & LOOKUP_REVAL), &nd);
+		if (error)
+			goto out_filp;
 
-	current->total_link_count = 0;
-	error = link_path_walk(pathname, &nd);
-	if (error) {
-		filp = ERR_PTR(error);
-		goto out;
+		error = path_walk_simple(pathname, &nd);
 	}
-	if (unlikely(!audit_dummy_context()) && (open_flag & O_CREAT))
+	if (unlikely(error))
+		goto out_filp;
+	if (unlikely(!audit_dummy_context()))
 		audit_inode(pathname, nd.path.dentry);
 
 	/*
 	 * We have the parent and last component.
 	 */
-
-	error = -ENFILE;
-	filp = get_empty_filp();
-	if (filp == NULL)
-		goto exit_parent;
-	nd.intent.open.file = filp;
-	filp->f_flags = open_flag;
-	nd.intent.open.flags = flag;
-	nd.intent.open.create_mode = mode;
-	nd.flags &= ~LOOKUP_PARENT;
-	nd.flags |= LOOKUP_OPEN;
-	if (open_flag & O_CREAT) {
-		nd.flags |= LOOKUP_CREATE;
-		if (open_flag & O_EXCL)
-			nd.flags |= LOOKUP_EXCL;
-	}
-	if (open_flag & O_DIRECTORY)
-		nd.flags |= LOOKUP_DIRECTORY;
-	if (!(open_flag & O_NOFOLLOW))
-		nd.flags |= LOOKUP_FOLLOW;
+	nd.flags = flags;
 	filp = do_last(&nd, &path, open_flag, acc_mode, mode, pathname);
 	while (unlikely(!filp)) { /* trailing symlink */
 		struct path holder;
-		struct inode *inode = path.dentry->d_inode;
 		void *cookie;
 		error = -ELOOP;
 		/* S_ISDIR part is a temporary automount kludge */
-		if (!(nd.flags & LOOKUP_FOLLOW) && !S_ISDIR(inode->i_mode))
+		if (!(nd.flags & LOOKUP_FOLLOW) && !S_ISDIR(nd.inode->i_mode))
 			goto exit_dput;
 		if (count++ == 32)
 			goto exit_dput;
@@ -1835,36 +2249,33 @@ reval:
 			goto exit_dput;
 		error = __do_follow_link(&path, &nd, &cookie);
 		if (unlikely(error)) {
+			if (!IS_ERR(cookie) && nd.inode->i_op->put_link)
+				nd.inode->i_op->put_link(path.dentry, &nd, cookie);
 			/* nd.path had been dropped */
-			if (!IS_ERR(cookie) && inode->i_op->put_link)
-				inode->i_op->put_link(path.dentry, &nd, cookie);
-			path_put(&path);
-			release_open_intent(&nd);
-			filp = ERR_PTR(error);
-			goto out;
+			nd.path = path;
+			goto out_path;
 		}
 		holder = path;
 		nd.flags &= ~LOOKUP_PARENT;
 		filp = do_last(&nd, &path, open_flag, acc_mode, mode, pathname);
-		if (inode->i_op->put_link)
-			inode->i_op->put_link(holder.dentry, &nd, cookie);
+		if (nd.inode->i_op->put_link)
+			nd.inode->i_op->put_link(holder.dentry, &nd, cookie);
 		path_put(&holder);
 	}
 out:
 	if (nd.root.mnt)
 		path_put(&nd.root);
-	if (filp == ERR_PTR(-ESTALE) && !force_reval) {
-		force_reval = 1;
+	if (filp == ERR_PTR(-ESTALE) && !(flags & LOOKUP_REVAL))
 		goto reval;
-	}
 	return filp;
 
 exit_dput:
 	path_put_conditional(&path, &nd);
+out_path:
+	path_put(&nd.path);
+out_filp:
 	if (!IS_ERR(nd.intent.open.file))
 		release_open_intent(&nd);
-exit_parent:
-	path_put(&nd.path);
 	filp = ERR_PTR(error);
 	goto out;
 }
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index e31fc9a..5dfb6f7 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -5,6 +5,7 @@
 #include <linux/list.h>
 #include <linux/rculist.h>
 #include <linux/spinlock.h>
+#include <linux/seqlock.h>
 #include <linux/cache.h>
 #include <linux/rcupdate.h>
 
@@ -80,7 +81,7 @@ full_name_hash(const unsigned char *name, unsigned int len)
  * give reasonable cacheline footprint with larger lines without the
  * large memory footprint increase).
  */
-#ifdef CONFIG_64BIT
+#ifdef CONFIG_64BIT /* XXX update */
 #define DNAME_INLINE_LEN_MIN 32 /* 192 bytes */
 #else
 #define DNAME_INLINE_LEN_MIN 40 /* 128 bytes */
@@ -90,6 +91,7 @@ struct dentry {
 	unsigned int d_count;		/* protected by d_lock */
 	unsigned int d_flags;		/* protected by d_lock */
 	spinlock_t d_lock;		/* per dentry lock */
+	seqcount_t d_seq;		/* per dentry seqlock */
 	int d_mounted;
 	struct inode *d_inode;		/* Where the name belongs to - NULL is
 					 * negative */
@@ -296,9 +298,12 @@ extern void d_move(struct dentry *, struct dentry *);
 extern struct dentry *d_ancestor(struct dentry *, struct dentry *);
 
 /* appendix may either be NULL or be used for transname suffixes */
-extern struct dentry * d_lookup(struct dentry *, struct qstr *);
-extern struct dentry * __d_lookup(struct dentry *, struct qstr *);
-extern struct dentry * d_hash_and_lookup(struct dentry *, struct qstr *);
+extern struct dentry *d_lookup(struct dentry *, struct qstr *);
+extern struct dentry *__d_lookup(struct dentry *, struct qstr *);
+extern struct dentry *__d_lookup_rcu(struct dentry *parent, struct qstr *name,
+				unsigned *seq, struct inode **inode);
+extern int __d_rcu_to_refcount(struct dentry *dentry, unsigned seq);
+extern struct dentry *d_hash_and_lookup(struct dentry *, struct qstr *);
 
 /* validate "insecure" dentry pointer */
 extern int d_validate(struct dentry *, struct dentry *);
diff --git a/include/linux/namei.h b/include/linux/namei.h
index aec730b..18d06ad 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -19,7 +19,10 @@ struct nameidata {
 	struct path	path;
 	struct qstr	last;
 	struct path	root;
+	struct file	*file;
+	struct inode	*inode; /* path.dentry.d_inode */
 	unsigned int	flags;
+	unsigned	seq;
 	int		last_type;
 	unsigned	depth;
 	char *saved_names[MAX_NESTED_LINKS + 1];
@@ -43,11 +46,13 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
  *  - internal "there are more path components" flag
  *  - dentry cache is untrusted; force a real lookup
  */
-#define LOOKUP_FOLLOW		 1
-#define LOOKUP_DIRECTORY	 2
-#define LOOKUP_CONTINUE		 4
-#define LOOKUP_PARENT		16
-#define LOOKUP_REVAL		64
+#define LOOKUP_FOLLOW		0x0001
+#define LOOKUP_DIRECTORY	0x0002
+#define LOOKUP_CONTINUE		0x0004
+
+#define LOOKUP_PARENT		0x0010
+#define LOOKUP_REVAL		0x0020
+#define LOOKUP_RCU		0x0040
 /*
  * Intent data
  */
-- 
1.7.1

