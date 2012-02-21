Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab2BUR5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:57:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab2BUR52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:57:28 -0500
From: David Howells <dhowells@redhat.com>
Subject: [RFC][PATCH 00/73] Union Mount [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 21 Feb 2012 17:57:22 +0000
Message-ID: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Here's the current state of the unionmount patches.

Significant changes made include:

 (1) Brought up to date with the current changes in the VFS (eg. RCU pathwalk,
     mount/vfsmount struct split).

 (2) Moved the copy-up for namei metadata syscalls that modify an inode
     (eg. link(), utimes(), setxattr()) into pathwalk.  These syscalls now
     merely need to provide LOOKUP_COPY_UP to pathwalk and the copy up is done
     there.

     One thing I'm not certain of is that this (and the original patches)
     would do the copy up, even if the caller didn't have permission to alter
     the inode and the system call failed the permission check after the copy
     up had taken place.

     Truncate and open-write don't suffer that issue.

 (3) Merged the in-development ext2 patches in and completed them - at least I
     think I did, one of them didn't say what it did.

 (4) Added some code to override the credentials around upper inode creation
     to make sure the inode gets the right UID/GID.  This doesn't help if the
     lower inode has some sort of foreign user identifier.

     Also, I'm not sure whether the LSM xattrs should be blindly copied up.
     Should the LSM policies applicable to the lower fs's apply to the upper
     fs too?

 (5) Added a marker flag for mounts on the lower fs.  There is the possibility
     of having a file mounted over a file on the upperfs.  I suspect some of
     the logic will malfunction in such a case as the previous component will
     be seen to be on the upperfs and the current component not on a unioned
     fs - and may trigger a copyup attempt.

 (6) Added a patch to pass the mount flags to sget() and thence to the compare
     routine.  sget() installs them in the superblock before returning it.

 (7) Added a patch to combine the multiple chown syscalls.

 (8) Moved the xattr copyup code earlier so that it can be used for directories
     too (it is called there, but isn't introduced till a later patch).

 (9) Added a patch to have a second lock class for use by unionmounts for
     i_mutex and i_dir_mutex to stop complaints when a union is made of two
     filesystems of the same type.

     Unionmount over a unionmount will need special handling, and possibly
     rejecting.  It should just work, however if the two upper filesystems are
     the same type, lockdep will incorrectly moan a lot.

Some issues:

 (1) Need to handle automount points and managed directories.  Probably simply
     ignoring them is best.

 (2) Need to better handle mountpoints.  Currently it just calls
     follow_mount(), which is probably wrong.

 (3) do_lookup() needs to come up with the correct inode after
     needs_lookup_union() is called.  I think I have this right, but it could
     do with checking.

 (4) Should d_revalidate() be called on the lower fs objects under some
     circumstances.  I assume not, since we don't want to see the lower fs
     changing.

David
---
David Howells (21):
      fallthru: ext2 support for lookup of d_type/d_ino in fallthrus
      ext2: Add whiteout and opaque directory support
      ext2: Remove target inode pointer from ext2_add_entry()
      union-mount: Implement union-aware truncate()
      union-mount: Implement union-aware rename()
      union-mount: Make various syscalls aware (link, chmod, chown, utimes & setxattr)
      unionmount: Override creds when copying up a file to correctly set ownership
      unionmount: Add LOOKUP_COPY_UP
      union-mount: In-kernel file copyup routines
      union-mount: Add wrapper for lookup_union_locked() and RCU hook
      union-mount: Implement union mount
      union-mount: Duplicate the i_{,dir_}mutex lock classes and use for upper layer
      unionmount: Mark lower layers in union
      union-mount: Add union_create_topmost_dir()
      whiteout: Add vfs_whiteout() and whiteout inode operation
      VFS: Split inode_permission()
      VFS: Pass mount flags to sget()
      VFS: Make lookup_hash() return a struct path
      VFS: Comment mount following code
      VFS: Make clone_mnt()/copy_tree()/collect_mounts() return errors
      VFS: Make chown() and lchown() call fchownat()

Felix Fietkau (2):
      jffs2: Add fallthru support
      jffs2: Add whiteout support

Jan Blunck (6):
      union-mount: Create IS_MNT_UNION()
      union-mount: Free union stack on removal of topmost dentry from dcache
      union-mount: Introduce MNT_UNION and MS_UNION flags
      tmpfs: Add whiteout support
      whiteout: Allow removal of a directory with whiteouts
      whiteout/NFSD: Don't return information about whiteouts to userspace

Valerie Aurora (44):
      fallthru: jffs2 support for lookup of d_type/d_ino in fallthrus
      ext2: Add fallthru support
      ext2: Split ext2_add_entry() from ext2_add_link()
      ext2: Add ext2_dirent_in_use()
      union-mount: Implement union-aware writable open()
      union-mount: Implement union-aware access()/faccessat()
      VFS: Create user_path_nd() to lookup both parent and target
      fallthru: tmpfs support for lookup of d_type/d_ino in fallthrus
      union-mount: Add generic_readdir_fallthru() helper
      union-mount: Copy up directory entries on first readdir()
      union-mount: Set opaque flag on new directories in unioned file systems
      union-mount: Create whiteout on rmdir()
      union-mount: Create whiteout on unlink()
      union-mount: Call union lookup functions in lookup path
      union-mount: Add lookup_union_locked()
      union-mount: Follow mount in __lookup_union()
      union-mount: Build union stack in __lookup_union()
      union-mount: Return files found in lower layers in __lookup_union()
      union-mount: Process negative dentries in __lookup_union()
      union-mount: Basic infrastructure of __lookup_union()
      union-mount: Temporarily disable some syscalls
      union-mount: Prevent bind mounts of union mounts
      union-mount: Prevent topmost file system from being mounted elsewhere
      union-mount: Prevent improper union-related remounts
      union-mount: Create prepare_mnt_union() and cleanup_mnt_union()
      union-mount: Create build_root_union()
      union-mount: Add clone_union_tree() and put_union_sb()
      union-mount: Create check_topmost_union_mnt()
      union-mount: Create needs_lookup_union()
      union-mount: Create union_add_dir()
      union-mount: Create d_free_unions()
      union-mount: Add union_find_dir()
      union-mount: Add union_alloc()
      union-mount: Add two superblock fields for union mounts
      union-mount: Create union_stack structure
      union-mount: Add CONFIG_UNION_MOUNT option
      union-mount: Union mounts documentation
      tmpfs: Add fallthru support
      VFS: Basic fallthru definitions
      whiteout: Define flags and operations for opaque inodes
      VFS: Add CL_MAKE_HARD_READONLY flag to clone_mnt()/copy_tree()
      VFS: Add CL_NO_SLAVE flag to clone_mnt()/copy_tree()
      VFS: Add CL_NO_SHARED flag to clone_mnt()/copy_tree()
      VFS: Add hard read-only users count to superblock


 Documentation/filesystems/union-mounts.txt |  712 ++++++++++++++++++++++
 Documentation/filesystems/vfs.txt          |   16 
 drivers/mtd/mtdsuper.c                     |    4 
 fs/9p/vfs_super.c                          |    4 
 fs/Kconfig                                 |   12 
 fs/Makefile                                |    1 
 fs/afs/super.c                             |    3 
 fs/btrfs/super.c                           |    4 
 fs/ceph/super.c                            |    2 
 fs/cifs/cifsfs.c                           |    9 
 fs/compat.c                                |    9 
 fs/dcache.c                                |   28 +
 fs/devpts/inode.c                          |    6 
 fs/ecryptfs/main.c                         |    3 
 fs/ext2/dir.c                              |  181 +++++-
 fs/ext2/ext2.h                             |    3 
 fs/ext2/inode.c                            |   11 
 fs/ext2/namei.c                            |   73 ++
 fs/ext2/super.c                            |    6 
 fs/gfs2/ops_fstype.c                       |    5 
 fs/inode.c                                 |   48 +
 fs/internal.h                              |    5 
 fs/jffs2/dir.c                             |  117 +++-
 fs/jffs2/fs.c                              |    4 
 fs/jffs2/super.c                           |    2 
 fs/libfs.c                                 |   25 +
 fs/logfs/super.c                           |    3 
 fs/namei.c                                 |  906 +++++++++++++++++++++++++---
 fs/namespace.c                             |  391 ++++++++++--
 fs/nfs/super.c                             |   10 
 fs/nfsd/nfs3xdr.c                          |    5 
 fs/nfsd/nfs4xdr.c                          |    5 
 fs/nfsd/nfsxdr.c                           |    4 
 fs/nilfs2/super.c                          |    4 
 fs/open.c                                  |  131 +++-
 fs/pnode.c                                 |    5 
 fs/pnode.h                                 |    4 
 fs/proc/root.c                             |    3 
 fs/proc_namespace.c                        |    1 
 fs/readdir.c                               |   18 +
 fs/reiserfs/procfs.c                       |    2 
 fs/super.c                                 |   42 +
 fs/sysfs/mount.c                           |    3 
 fs/ubifs/super.c                           |    3 
 fs/union.c                                 |  721 ++++++++++++++++++++++
 fs/union.h                                 |  189 ++++++
 fs/utimes.c                                |    2 
 fs/xattr.c                                 |   10 
 include/linux/dcache.h                     |   40 +
 include/linux/ext2_fs.h                    |    8 
 include/linux/fs.h                         |   47 +
 include/linux/jffs2.h                      |    8 
 include/linux/mount.h                      |    5 
 include/linux/namei.h                      |    3 
 kernel/audit_tree.c                        |   10 
 kernel/cgroup.c                            |    2 
 mm/shmem.c                                 |  192 ++++++
 57 files changed, 3750 insertions(+), 320 deletions(-)
 create mode 100644 Documentation/filesystems/union-mounts.txt
 create mode 100644 fs/union.c
 create mode 100644 fs/union.h

