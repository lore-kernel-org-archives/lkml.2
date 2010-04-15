Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab0DOXHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:07:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241Ab0DOXGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:06:36 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 16/35] union-mount: Writable overlays/union mounts documentation
Date: Thu, 15 Apr 2010 16:04:23 -0700
Message-Id: <1271372682-21225-17-git-send-email-vaurora@redhat.com>
In-Reply-To: <1271372682-21225-16-git-send-email-vaurora@redhat.com>
References: <1271372682-21225-1-git-send-email-vaurora@redhat.com>
 <1271372682-21225-2-git-send-email-vaurora@redhat.com>
 <1271372682-21225-3-git-send-email-vaurora@redhat.com>
 <1271372682-21225-4-git-send-email-vaurora@redhat.com>
 <1271372682-21225-5-git-send-email-vaurora@redhat.com>
 <1271372682-21225-6-git-send-email-vaurora@redhat.com>
 <1271372682-21225-7-git-send-email-vaurora@redhat.com>
 <1271372682-21225-8-git-send-email-vaurora@redhat.com>
 <1271372682-21225-9-git-send-email-vaurora@redhat.com>
 <1271372682-21225-10-git-send-email-vaurora@redhat.com>
 <1271372682-21225-11-git-send-email-vaurora@redhat.com>
 <1271372682-21225-12-git-send-email-vaurora@redhat.com>
 <1271372682-21225-13-git-send-email-vaurora@redhat.com>
 <1271372682-21225-14-git-send-email-vaurora@redhat.com>
 <1271372682-21225-15-git-send-email-vaurora@redhat.com>
 <1271372682-21225-16-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document design and implementation of writable overlays (a.k.a. union
mounts).

XXX - out of date

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 Documentation/filesystems/union-mounts.txt |  708 ++++++++++++++++++++++++++++
 1 files changed, 708 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/union-mounts.txt

diff --git a/Documentation/filesystems/union-mounts.txt b/Documentation/filesystems/union-mounts.txt
new file mode 100644
index 0000000..5f47296
--- /dev/null
+++ b/Documentation/filesystems/union-mounts.txt
@@ -0,0 +1,708 @@
+State of writable overlays (formerly union mounts)
+==================================================
+
+This version of union mounts is renamed "writable overlays."  The goal
+of this patch set is to support a single read-write file system
+overlaid on a single read-only file system.  "Union mounts" suggests
+that we support unions of arbitrary numbers and types of file systems,
+which is not the goal of this patch set.
+
+The most recent version of writable overlays can boot to multi-user
+mode with a writable overlay root file system.  open(), truncate(),
+creat(), unlink(), mkdir(), rmdir(), and rename() work.  link(),
+chmod(), chown(), and chattr() don't work yet.
+
+This document describes the architecture and current status of
+writable overlays, including an item-by-item todo list.
+
+Writable overlays (formerly union mounts)
+=========================================
+
+In this document:
+ - Overview of writable overlays
+ - Terminology
+ - VFS implementation
+ - Locking strategy
+ - VFS/file system interface
+ - Userland interface
+ - NFS interaction
+ - Status
+ - Contributing to writable overlays
+
+Overview
+========
+
+Writable overlays (formerly known as union mounts) are used to layer a
+single writable file system over a single read-only file system, with
+all writes going to the writable file system.  The namespace of both
+file systems appears as a combined whole to userland, with those on
+the writable file system covering up any matching pathnames on the
+read-only file system.  A few use cases:
+
+- Root file system on CD with writes saved to hard drive (LiveCD)
+- Multiple virtual machines with the same starting root file system
+- Cluster with NFS mounted root on clients
+
+Most if not all of these problems could be solved with a COW block
+device; however, sharing at the file system level has higher
+performance and uses less disk space.
+
+What writable overlays are not
+------------------------------
+
+Writable overlays are not a general-purpose unioning file system.
+They do not provide a generic "union of namespaces" operation for an
+arbitrary number of file systems.  Many interesting features can be
+implemented with a generic unioning facility: unioning of more than
+two file systems, dynamic insertion and removal of branches, online
+upgrade, etc.  Some unioning file systems that do this are UnionFS and
+AUFS.  Unfortunately, the complexity of these feature sets lead to
+difficult corner cases which so far have been unsolvable in the
+context of the Linux VFS.
+
+Writable overlays avoid these corner cases by reducing the feature set
+to the bare minimum most requested features: one writable file system
+layered over one read-only file system.  Despite the limitations of
+writable overlays, the VFS infrastructure it uses are generic enough
+to be reused by more full-featured unioning file systems.
+
+Terminology
+===========
+
+The main analogy for writable overlays is that a writable file system
+is mounted "on top" of a read-only file system.  Lookups start at the
+"top" read-write file system and travel "down" to the "bottom"
+read-only file system only if no blocking entry exists on the top
+layer.
+
+Top layer: The read-write file system.  Lookups begin here.
+
+Bottom layer: The read-only file system.  Lookups end here.
+
+Path: Combination of the vfsmount and dentry structure.
+
+Follow down: Given a path from the top layer, find the corresponding
+path on the bottom layer.
+
+Follow up: Given a path from the bottom layer, find the corresponding
+path on the top layer.
+
+Whiteout: A directory entry in the top layer that prevents lookups
+from travelling down to the bottom layer.  Created on unlink()/rmdir()
+if a corresponding directory entry exists in the bottom layer.
+
+Opaque: A flag on a directory in the top layer that prevents lookups
+of entries in this directory from travelling down to the bottom
+layer (unless there is an explicit fallthru entry allowing that for a
+particular entry).  Set on creation of a directory that replaces a
+whiteout, and after a directory copyup.
+
+Fallthru: A directory entry which allows lookups to "fall through" to
+the bottom layer for that exact directory entry.  This serves as a
+placeholder for directory entries from the bottom layer during
+readdir().  Fallthrus override opaque flags.
+
+File copyup: Create a file on the top layer that has the same properties
+and contents as the file with the same pathname on the bottom layer.
+
+Directory copyup: Copy up the visible directory entries from the
+bottom layer as fallthrus in the matching top layer directory.  Mark
+the directory opaque to avoid unnecessary negative lookups on the
+bottom layer.
+
+Examples
+========
+
+What happens when I...
+
+- creat() /newfile -> creates on top layer
+- unlink() /oldfile -> creates a whiteout on top layer
+- Edit /existingfile -> copies up to top layer at open(O_WR) time
+- truncate /existingfile -> copies up to top layer + N bytes if specified
+- touch()/chmod()/chown()/etc. -> copies up to top layer
+- mkdir() /newdir -> creates on top layer
+- rmdir() /olddir -> creates a whiteout on top layer
+- mkdir() /olddir after above -> creates on top layer w/ opaque flag
+- readdir() /shareddir -> copies up entries from bottom layer as fallthrus
+- link() /oldfile /newlink -> copies up /oldfile, creates /newlink on top layer
+- symlink() /oldfile /symlink -> nothing special
+- rename() /oldfile /newfile -> copies up /oldfile to /newfile on top layer
+- rename() dir -> EXDEV
+
+Getting to a root file system with a writable overlay:
+
+- Mount the base read-only file system as the root file system
+- Mount the read-only file system again on /newroot
+- Mount the writable overlay on /newroot:
+   # mount -o union /dev/sda /newroot
+- pivot_root to /newroot
+- Start init
+
+See scripts/pivot.sh in the UML devkit linked to from:
+
+http://valerieaurora.org/union/
+
+VFS implementation
+==================
+
+Writable overlays are implemented as an integral part of the VFS,
+rather than as a VFS client file system (i.e., a stacked file system
+like unionfs or ecryptfs).  Implementing writable overlays inside the
+VFS eliminates the need for duplicate copies of VFS data structures,
+unnecessary indirection, and code duplication, but requires very
+maintainable, low-to-zero overhead code.  Writable overlays require no
+change to file systems serving as the read-only layer, and requires
+some minor support from file systems serving as the read-write layer.
+File systems that want to be the writable layer must implement the new
+->whiteout() and ->fallthru() inode operations, which create special
+dummy directory entries.
+
+union_mount structure
+---------------------
+
+The primary data structure for writable overlays is the union_mount
+structure, which connects overlapping directory dentries into a "union
+stack":
+
+struct union_mount {
+	atomic_t u_count;		/* reference count */
+	struct mutex u_mutex;
+	struct list_head u_unions;	/* list head for d_unions */
+	struct list_head u_list;	/* list head for mnt_unions */
+	struct hlist_node u_hash;	/* list head for searching */
+	struct hlist_node u_rhash;	/* list head for reverse searching */
+
+	struct path u_this;		/* this is me */
+	struct path u_next;		/* this is what I overlay */
+};
+
+The union_mount is referenced from the corresponding directory's
+dentry:
+
+struct dentry {
+[...]
+#ifdef CONFIG_UNION_MOUNT
+	/*
+	 * The following fields are used by the VFS based union mount
+	 * implementation. Both are protected by union_lock!
+	 */
+	struct list_head d_unions;	/* list of union_mounts */
+	unsigned int d_unionized;	/* unions referencing this dentry */
+#endif
+[...]
+};
+
+Each top layer directory with the potential for a lookup to fall
+through to the bottom layer has a union_mount structure stored in a
+union_mount hash table.  The union_mount's can be looked up both by the
+top layer's path (via union_lookup()) and the bottom layer's path (via
+union_rlookup()).  Once you have the path (vfsmount and dentry pair)
+of a file, the union stack can be followed down, layer by layer, with
+follow_union_down(), and up with follow_union_mount().
+
+All union_mount's are allocated from a kmem cache when the
+corresponding dentries are created.  union_mount's are allocated when
+the first referencing dentry is allocated and freed when all of the
+referencing dentries are freed - that is, the dcache drives the union
+cache.  While writable overlays only use two layers, the union stack
+infrastructure is capable of supporting an arbitrary number of file
+system layers (leaving aside locking issues).
+
+Todo:
+
+- Rename union_mount structure - it's per directory, not per mount
+
+Code paths
+----------
+
+Writable overlays modify the following key code paths in the VFS:
+
+- mount()/umount()
+- Path lookup
+- Any path that modifies an existing file
+
+Mount
+-----
+
+Writable overlays are created in two steps:
+
+1. Mount the bottom layer file system read-only in the usual manner.
+2. Mount the top layer with the "-o union" option at the same mountpoint.
+
+The bottom layer must be read-only and the top layer must be
+read-write and support whiteouts and fallthrus (indicated by setting
+the MS_WHITEOUT flag).  Currently, the top layer is forced to
+"noatime" to avoid a copyup on every access of a file.  Supporting
+atime with the current infrastructure would require a copyup on every
+open().
+
+Currently, the top layer covers all submounts on the read-only file
+system.  This can be inconvenient; e.g., mounting a writable overlay
+on the root file system after procfs has been mounted.  It's not clear
+what the right behavior is.  Also, it may be smarter to mount both
+read-only and read-write layers in one step, but the mount options get
+pretty ugly.
+
+pivot_root() is supported and is the recommended way to get to a root
+file system with a writable overlay.
+
+Todo:
+
+- Rename "-o union" mount option - "overlay"?
+- Don't permit mounting over read-write submounts
+- Choose submount covering behavior
+- Allow atime?
+
+Really really read-only file systems: In Linux, any individual file
+system may be mounted at multiple places in the namespace.  The file
+system may change from read-only to read-write while still mounted.
+Thus, simply checking that the bottom layer is read-only at the time
+the writable overlay is mounted over it is pointless, since at any
+time the bottom layer may become read-write.
+
+We need to guarantee that a file system will be read-only for as long
+as it is the bottom layer of a writable overlay.  To do this, we track
+the number of "read-only users" of a file system in its VFS superblock
+structure.  When we mount a writable overlay over a file system, we
+increment its read-only user count.  The file system can only be
+mounted read-write if its read-only users count is zero.
+
+Todo:
+
+- Support really really read-only NFS mounts.  See discussion here:
+
+  http://markmail.org/message/3mkgnvo4pswxd7lp
+
+Path lookup
+-----------
+
+Much of the action in writable overlasy happens during lookup().
+First, if we lookup a directory on the bottom layer that doesn't yet
+exist on the top layer, __link_path_walk() always create a matching
+directory on the top layer.  This way, we never have to walk back up a
+path, creating directories as we go, before we can copyup a file.
+Second, if we need to copy up a file, we first (re)look it up with the
+LOOKUP_TOPMOST flag, which instructs __link_path_walk() to create it
+on the top layer.  Neither directory entries nor file data are copied
+up in __link_path_walk() - that happens after the lookup, in the
+caller.
+
+The main cut-out to writable overlay code is in do_lookup():
+
+static int do_lookup(struct nameidata *nd, struct qstr *name,
+		     struct path *path)
+{
+	int err;
+
+	if (IS_MNT_UNION(nd->path.mnt))
+		goto need_union_lookup;
+[...]
+need_union_lookup:
+	err = cache_lookup_union(nd, name, path);
+	if (!err && path->dentry)
+		goto done;
+
+	err = real_lookup_union(nd, name, path);
+	if (err)
+		goto fail;
+	goto done;
+
+cache_lookup_union() looks for the dentry in the dcache, starting at
+the top layer and following down.  If it finds nothing, it returns a
+negative dentry from the top layer.  If it finds a directory, it looks
+for the same directory in the bottom layer; if that exists, it
+allocates a union_mount struct and hangs the bottom layer dentry off
+of it.  real_lookup_union() does the same for uncached entries.
+
+Todo:
+
+- Reorganize cache/hash/real lookup code - lots of code duplication
+- Turn create-on-topmost test into #ifdef'able function
+- Rewrite with assumption that topmost directory always exists
+- Remove duplicated tests and other duplicated code
+
+File copyup
+-----------
+
+Any system call that alters an existing file on the bottom layer
+(including creating or moving a hard link to it) will trigger a copyup
+of the target file to the top layer (via union_copyup() or
+__union_copyup()).  This includes:
+
+ - open(O_WRITE | O_RDWR | O_APPEND | O_DIRECT)
+ - truncate()/ftruncate()/open(O_TRUNC)
+ - link()
+ - rename()
+ - chmod()
+ - chattr()
+
+Copyup of a file DOES NOT occur on:
+
+ - open(O_RDONLY) if noatime
+ - stat() if no atime
+ - creat()/mkdir()/mknod()
+ - symlink()
+ - unlink()/rmdir()
+
+From an application's point of view, the result of an in-kernel file
+copyup is the logical equivalent of another application updating the
+file via the rename() pattern: creat() a new file, copy the data over,
+make changes the copy, and rename() over the old version.  Any
+existing open file descriptors for that file (including those in the
+same application) refer to a now invisible and unreferenced object
+that used to have the same pathname.  Only opens that occur after the
+copyup will see updates to the file.
+
+Todo:
+
+- copyup on chown()/chmod()/chattr()
+- copyup if atime is enabled?
+
+Permission checks
+-----------------
+
+We want to be sure we have the correct permissions to actually succeed
+in a system call before copying a file up to avoid unnecessary IO.  At
+present, the permission check for a single system call may be spread
+out over many hundreds of lines of code (e.g., open()).  In order to
+check permissions, we occasionally need to determine if there is a
+writable overlay on top of this inode.  This requires a full path, but
+often we only have the inode at this point.  In particular,
+inode_permission() returns EROFS if the inode is on a read-only file
+system, which is the wrong answer if there is a writable overlay
+mounted on top of it.
+
+Another trouble-maker is may_open(), which both checks permissions for
+open AND truncates the file if O_TRUNC is specified.  It doesn't make
+any sense to copy up the file and then let may_open() truncate it, but
+we can't copy it after may_open() truncates it either.  The current
+ugly hack is to pass the full nameidata to may_open() and copyup
+inside may_open().
+
+Some solutions:
+
+- Create __inode_permission() and pass it a flag telling it whether or
+  not to check for a read-only fs.  Create union_permission() which
+  takes a path, checks for a union mount, and sets the rofs flag.
+  Place the file copyup call after all the permission checks are
+  completed.  Push down the full path into the functions that need it
+  and currently only take the dentry or inode.
+
+- For each instance in which we might want to copyup, move permission
+  checks into a new function and call it from a level at which we
+  still have the full path.  Pass it an "ignore read-only fs" flag if
+  the file is on a union mount.  Pass around the ignore-rofs flag
+  inside the function doing permission checks.  If all the permission
+  checks complete successfully, copyup the file.  Would require moving
+  truncate out of may_open().
+
+Todo:
+ - On truncate, only copy up the N bytes of file data requested
+ - Make sure above handles truncate beyond EOF correctly
+ - File copyup on chown()/chmod()/chattr() etc.
+ - File copyup on open(O_APPEND)
+ - File copyup on open(O_DIRECT)
+
+Impact on non-union kernels and mounts
+--------------------------------------
+
+Union-related data structures, extra fields, and function calls are
+#ifdef'd out at the function/macro level with CONFIG_UNION_MOUNT in
+nearly all cases (see include/linux/union.h).  The union-specific code
+in the cache lookup path is out of line.
+
+Currently, is_unionized() is pretty heavy-weight: it walks up the
+mount hierarchy, grabbing the vfsmount lock at each level.  It may be
+possible to simplify this greatly if a writable layer can only cover
+exactly one mount, rather than a tree of mounts.
+
+Todo:
+
+ - Turn copyup in __link_path_walk() into #ifdef'd function
+ - Do performance tests
+ - Optimize is_unionized()
+ - Properly #ifdef out mount path code
+
+Locking strategy
+================
+
+The current writable overlay locking strategy is based on the
+following rules:
+
+* Exactly two file systems are unioned
+* The bottom file system is always read-only
+* The top file system is always read-write
+  => A file system can never a top and a bottom layer at the same time
+
+Additionally, the top layer (the writable overlay) may only be mounted
+exactly once.  Don't think of the writable overlay as a separate
+independent file system; when it is mounted as a writable overlay, it
+is only a file system in conjunction with the read-only bottom layer.
+The read-only bottom layer is an independent file system in and of
+itself and can be mounted elsewhere, including as the bottom layer for
+another writable overlay.
+
+Thus, we may define a stable locking order in terms of top layer and
+bottom layer locks, since a top layer is never a bottom layer and a
+bottom layer is never a top layer.  Objects from the bottom layer are
+never changed (so don't need write locks) and only require atomic
+operations to manage kernel data structures (ref counts, etc.).
+
+Another simplifying assumption is that all directories in a pathname
+exist on the top layer, as they are created step-by-step during
+lookup.  This prevents us from ever having to walk backwards up the
+path creating directory entries, which can get complicated especially
+when you consider the need to prevent topology changes.  By
+implication, parent directories during any operation (rename(),
+unlink(),etc.) are from the top layer.  Dentries for directories from
+the bottom layer are only ever used by lookup code.
+
+The two major problems we avoid with the above rules are:
+
+Lock ordering: Imagine two union stacks with the same two file
+systems: A mounted over B, and B mounted over A.  Sometimes locks on
+objects in both A and B will have to be held simultanously.  What
+order should they be acquired in?  Simply acquiring them from top to
+bottom will create a lock-ordering problem - one thread acquires lock
+on object from A and then tries for a lock on object from B, while
+another thread grabs the lock on object from B and then waits for the
+lock on object from A.  Some other lock ordering must be defined.
+
+Movement/change/disappearance of objects on multiple layers: A variety
+of nasty corner cases arise when more than one layer is changing at
+the same time.  Changes in the directory topology and their effect on
+inheritance are of special concern.  Al Viro's canonical email on the
+subject:
+
+http://lkml.indiana.edu/hypermail/linux/kernel/0802.0/0839.html
+
+We don't try to solve any of these cases, just avoid them in the first
+place.
+
+Todo: Prevent top layer from being mounted more than once.
+
+Cross-layer interactions
+------------------------
+
+The VFS code simultaneously holds references to and/or modifies
+objects from both the top and bottom layers in the following cases:
+
+Path lookup:
+
+Holds i_mutex on top layer directory inode while doing lookups on
+bottom layer.  Grabs i_mutex on bottom layer off and on.
+
+Todo:
+ - Is i_mutex on lower directory necessary?
+
+File copyup in general:
+
+File copyup occurs while holding i_mutex on the parent directory of
+the top layer.  As noted before, an in-kernel file copyup is the
+logical equivalent of a userspace rename() of an identical file on to
+this pathname.
+
+link():
+
+File copyup of target while holding i_mutex on parent directory on top
+layer.  Followed by a normal link() operation.
+
+rename():
+
+First, renaming of directories returns EXDEV.  It's not at all
+reasonable to recursively copy directory trees and userspace has to
+handle this case anyway.
+
+Rename involves two operations on a writable overlay: (1) creation of
+a whiteout covering the source of the rename, (2) a copyup of the file
+from the bottom layer.  The file copyup does not need to happen
+atomically, only the whiteout and the new link to the file.
+
+I propose that we copyup the source file to the "old" name (rather
+than directly to the "new" name), and then perform the normal file
+system rename operation.  The only addition is creation of whiteout
+for the old name.
+
+The current rename() implementation is just a hack to get things
+working and doesn't work at all as described above.
+
+Lock order: The file copyup happens before the rename() lock.  When we
+create the whiteout, we will already have the directory i_mutex.
+Otherwise, locking as usual.
+
+Directory copyup:
+
+Directory entries are copied up on the first readdir().  We hold the
+top layer directory i_mutex throughout.  A fallthru is created for
+each entry that appears only on the lower layer.
+
+Current patch takes the i_mutex on the bottom layer directory, which
+doesn't seem to be necessary.
+
+VFS-fs interface
+================
+
+Read-only layer: No support necessary other than enforcement of really
+really read-only semantics (done by VFS for local file systems).
+
+Writable layer: Must implement two new inode operations:
+
+int (*whiteout) (struct inode *, struct dentry *, struct dentry *);
+int (*fallthru) (struct inode *, struct dentry *);
+
+And set the MS_WHITEOUT flag.
+
+Whiteouts and fallthrus are most similar to symlinks, since they
+redirect to an object possibly located in another file system without
+keeping a reference on it.
+
+Todo:
+
+- Return correct inode number in d_ino member of struct dirent by one of:
+  - Save inode number of target in fallthru entry itself
+  - Lookup inode number during readdir()
+- Try re-implementing ext2 as special symlinks - may be much simpler
+- Implement ext3 (also as symlinks?)
+- Implement btrfs
+
+Supported file systems
+----------------------
+
+Any file system can be a read-only layer.  File systems must
+explicitly support whiteouts and fallthrus in order to be a read-write
+layer.  This patch set implements whiteouts for ext2, tmpfs, and
+jffs2.  We have tested ext2, tmpfs, and iso9660 as the read-only
+layer.
+
+Todo:
+ - Test corner cases of case-insensitive/oversensitive file systems
+
+NFS interaction
+===============
+
+NFS is currently not supported as either type of layer.  NFS as
+read-only layer requires support from the server to honor the
+read-only guarantee needed for the bottom layer.  To do this, the
+server needs to revoke access to clients requesting read-only file
+systems if the exported file system is remounted read-write or
+unmounted (during which arbitrary changes can occur).  Some recent
+discussion:
+
+http://markmail.org/message/3mkgnvo4pswxd7lp
+
+NFS as the read-write layer would require implementation of the
+->whiteout() and ->fallthru() methods.  DT_WHT directory entries are
+theoretically already supported.
+
+Also, technically the requirement for a readdir() cookie that is
+stable across reboots comes only from file systems exported via NFSv2:
+
+http://oss.oracle.com/pipermail/btrfs-devel/2008-January/000463.html
+
+Todo:
+
+- Implement whiteout()/fallthru() for NFS
+- Guarantee really really read-only on NFS exports
+
+Userland support
+================
+
+The mount command must support the "-o union" mount option and pass
+the corresponding MS_UNION flag to the kerel.  A util-linux git
+tree with writable overlay support is here:
+
+git://git.kernel.org/pub/scm/utils/util-linux-ng/val/util-linux-ng.git
+
+File system utilities must support whiteouts and fallthrus.  An
+e2fsprogs git tree with writable overlay support is here:
+
+git://git.kernel.org/pub/scm/fs/ext2/val/e2fsprogs.git
+
+Currently, whiteout directory entries are not returned to userland.
+While the directory type for whiteouts, DT_WHT, has been defined for
+many years, very little userland code handles them.  Userland will
+never see fallthru directory entries.
+
+Known non-POSIX behaviors
+-------------------------
+
+- Any writing system call (unlink()/chmod()/etc.) can return ENOSPC or EIO
+- Link count may be wrong for files on bottom layer with > 1 link count
+- Link count on directories will be wrong before readdir() (fixable)
+- File copyup is the logical equivalent of an update via copy +
+  rename().  Any existing open file descriptors will continue to refer
+  to the read-only copy on the bottom layer and will not see any
+  changes that occur after the copy-up.
+- rename() of directory fails with EXDEV
+
+Status
+======
+
+The current writable overlays patch set varies between RFC/prototype
+and pretty stable, depending on the particular patch.  The current
+patch set boots to multi-user mode with a writable overlay root file
+system (albeit with some complaints).  Some parts of the code were
+written years ago and have been reviewed, rewritten and tested many
+times.  Other parts were written last month and need review,
+rewriting, and testing.  The commit messages note the state of each
+patch.
+
+The current patch set is against 2.6.31.  You can find it here, in the
+branch "overlay":
+
+git://git.kernel.org/pub/scm/linux/kernel/git/val/linux-2.6.git
+
+Non-features
+------------
+
+Features we do not currently plan to support as part of writable
+overlays:
+
+Online upgrade: E.g., installing software on a file system NFS
+exported to clients while the clients are still up and running.
+Allowing the read-only bottom layer to change while the writable
+overlay file system is mounted invalidates our locking strategy.
+
+Recursive copying of directories: E.g., implementing rename() across
+layers for directories.  Doing an in-kernel copy of a single file is
+bad enough.  Recursively copying a directory is a big no-no.
+
+Read-only top layer: The readdir() strategy fundamentally requires the
+ability to create persistent directory entries on the top layer file
+system (which may be tmpfs).  Numerous alternatives (including
+in-kernel or in-application caching) exist and are compatible with
+writable overlays with its writing-readdir() implementation disabled.
+Creating a readdir() cookie that is stable across multiple readdir()s
+requires one of:
+
+- Write to stable storage (e.g., fallthru dentries)
+- Non-evictable kernel memory cache (doesn't handle NFS server reboot)
+- Per-application caching by glibc readdir()
+
+Aggregation of multiple read-only file systems: While perfectly
+reasonable from a user perspective, we just aren't smart enough to
+figure out the locking problems from a kernel perspective.  Sorry!
+
+Often these features are supported by other unioning file systems or
+by other versions of union mounts.
+
+Contributing to writable overlays
+=================================
+
+The writable overlays web page is here:
+
+http://valerieaurora.org/union/
+
+It links to:
+
+ - All git repositories
+ - Documentation
+ - An entire self-contained UML-based dev kit with README, etc.
+
+The mailing list for discussing writable overlays is:
+
+linux-fsdevel@vger.kernel.org
+
+http://vger.kernel.org/vger-lists.html#linux-fsdevel
+
+Thank you for reading!
-- 
1.6.3.3

