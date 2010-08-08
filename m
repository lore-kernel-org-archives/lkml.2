Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0HHPyt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 11:54:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260Ab0HHPyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 11:54:15 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 00/39] Union mounts - return d_ino from lower fs
Date: Sun,  8 Aug 2010 11:52:17 -0400
Message-Id: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After questioning the value of d_ino, I am now convinced of its
utility.  This version of union mounts fills in d_ino of fallthru
directory entries with the inode number of the target.  You still need
to stat() the entry to get st_dev if you want to do a file uniqueness
comparison using the inode.

See the patch introducing generic_readdir_fallthru() for the
implementation.

-VAL

Felix Fietkau (2):
  whiteout: jffs2 whiteout support
  fallthru: jffs2 fallthru support

Jan Blunck (10):
  VFS: Make lookup_hash() return a struct path
  autofs4: Save autofs trigger's vfsmount in super block info
  whiteout/NFSD: Don't return information about whiteouts to userspace
  whiteout: Add vfs_whiteout() and whiteout inode operation
  whiteout: Set opaque flag if new directory was previously a whiteout
  whiteout: Allow removal of a directory with whiteouts
  whiteout: Split of ext2_append_link() from ext2_add_link()
  whiteout: ext2 whiteout support
  union-mount: Introduce MNT_UNION and MS_UNION flags
  union-mount: Call do_whiteout() on unlink and rmdir in unions

Valerie Aurora (27):
  VFS: Comment follow_mount() and friends
  VFS: Add read-only users count to superblock
  whiteout: tmpfs whiteout support
  fallthru: Basic fallthru definitions
  union-mount: Union mounts documentation
  union-mount: Introduce union_dir structure and basic operations
  union-mount: Free union dirs on removal from dcache
  union-mount: Support for union mounting file systems
  union-mount: Implement union lookup
  union-mount: Copy up directory entries on first readdir()
  union-mount: Add generic_readdir_fallthru() helper
  fallthru: ext2 fallthru support
  fallthru: tmpfs fallthru support
  VFS: Split inode_permission() and create path_permission()
  VFS: Create user_path_nd() to lookup both parent and target
  union-mount: In-kernel file copyup routines
  union-mount: Implement union-aware access()/faccessat()
  union-mount: Implement union-aware link()
  union-mount: Implement union-aware rename()
  union-mount: Implement union-aware writable open()
  union-mount: Implement union-aware chown()
  union-mount: Implement union-aware truncate()
  union-mount: Implement union-aware chmod()/fchmodat()
  union-mount: Implement union-aware lchown()
  union-mount: Implement union-aware utimensat()
  union-mount: Implement union-aware setxattr()
  union-mount: Implement union-aware lsetxattr()

 Documentation/filesystems/union-mounts.txt |  752 +++++++++++++++++++++++++++
 Documentation/filesystems/vfs.txt          |   16 +-
 fs/Kconfig                                 |   13 +
 fs/Makefile                                |    1 +
 fs/autofs4/autofs_i.h                      |    1 +
 fs/autofs4/init.c                          |   11 +-
 fs/autofs4/root.c                          |    6 +
 fs/compat.c                                |    9 +
 fs/dcache.c                                |   32 ++-
 fs/ext2/dir.c                              |  248 +++++++++-
 fs/ext2/ext2.h                             |    4 +
 fs/ext2/inode.c                            |   11 +-
 fs/ext2/namei.c                            |   85 +++-
 fs/ext2/super.c                            |    7 +
 fs/jffs2/dir.c                             |  117 +++++-
 fs/jffs2/fs.c                              |    4 +
 fs/jffs2/super.c                           |    2 +-
 fs/libfs.c                                 |   23 +-
 fs/namei.c                                 |  754 ++++++++++++++++++++++++----
 fs/namespace.c                             |  289 +++++++++++-
 fs/nfsd/nfs3xdr.c                          |    5 +
 fs/nfsd/nfs4xdr.c                          |    5 +
 fs/nfsd/nfsxdr.c                           |    4 +
 fs/open.c                                  |  116 ++++-
 fs/readdir.c                               |   18 +
 fs/super.c                                 |   24 +
 fs/union.c                                 |  752 +++++++++++++++++++++++++++
 fs/union.h                                 |   80 +++
 fs/utimes.c                                |   14 +-
 fs/xattr.c                                 |   65 ++-
 include/linux/dcache.h                     |   19 +-
 include/linux/ext2_fs.h                    |    8 +
 include/linux/fs.h                         |   28 +
 include/linux/jffs2.h                      |    8 +
 include/linux/mount.h                      |    6 +-
 include/linux/namei.h                      |    2 +
 mm/shmem.c                                 |  193 +++++++-
 37 files changed, 3549 insertions(+), 183 deletions(-)
 create mode 100644 Documentation/filesystems/union-mounts.txt
 create mode 100644 fs/union.c
 create mode 100644 fs/union.h

