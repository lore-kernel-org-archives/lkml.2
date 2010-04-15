Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab0DOXFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:05:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757871Ab0DOXFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:05:01 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 00/35] Union mounts - everything but the xattrs
Date: Thu, 15 Apr 2010 16:04:07 -0700
Message-Id: <1271372682-21225-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements union mounts for every system call
except:

- xattr-related calls
- fchmod()/fchown()/futimensat() on an fd

The copyup portion is a proof of concept based around union_path_nd(),
which looks up both the target <mnt,dentry> pair and its parent's.  If
the parent is on a union mount, and the target is on a lower layer, we
copy up the target.

This patch set is very raw and could use even the most superficial
review.  Just take a look at Erez's review from December to see how
low-hanging the fruit is on this one.

-VAL

Felix Fietkau (2):
  whiteout: jffs2 whiteout support
  fallthru: jffs2 fallthru support

Jan Blunck (13):
  VFS: Make lookup_hash() return a struct path
  XXX autofs4: Save autofs trigger's vfsmount in super block info
  whiteout/NFSD: Don't return information about whiteouts to userspace
  whiteout: Add vfs_whiteout() and whiteout inode operation
  whiteout: Set S_OPAQUE inode flag when creating directories
  whiteout: Allow removal of a directory with whiteouts
  whiteout: tmpfs whiteout support
  whiteout: Split of ext2_append_link() from ext2_add_link()
  whiteout: ext2 whiteout support
  union-mount: Introduce MNT_UNION and MS_UNION flags
  union-mount: Introduce union_mount structure and basic operations
  union-mount: Drive the union cache via dcache
  union-mount: Call do_whiteout() on unlink and rmdir in unions

Valerie Aurora (20):
  VFS: Add read-only users count to superblock
  fallthru: Basic fallthru definitions
  fallthru: ext2 fallthru support
  fallthru: tmpfs fallthru support
  union-mount: Writable overlays/union mounts documentation
  union-mount: Implement union lookup
  union-mount: Support for mounting union mount file systems
  union-mount: Copy up directory entries on first readdir()
  VFS: Split inode_permission() and create path_permission()
  VFS: Create user_path_nd() to lookup both parent and target
  union-mount: In-kernel copyup routines
  union-mount: Implement union-aware access()/faccessat()
  union-mount: Implement union-aware link()
  union-mount: Implement union-aware rename()
  union-mount: Implement union-aware writable open()
  union-mount: Implement union-aware chown()
  union-mount: Implement union-aware truncate()
  union-mount: Implement union-aware chmod()/fchmodat()
  union-mount: Implement union-aware lchown()
  union-mount: Implement union-aware utimensat()

 Documentation/filesystems/union-mounts.txt |  708 ++++++++++++++++++++++
 Documentation/filesystems/vfs.txt          |   16 +-
 fs/Kconfig                                 |   13 +
 fs/Makefile                                |    1 +
 fs/autofs4/autofs_i.h                      |    1 +
 fs/autofs4/init.c                          |   11 +-
 fs/autofs4/root.c                          |    6 +
 fs/compat.c                                |    9 +
 fs/dcache.c                                |   35 +-
 fs/ext2/dir.c                              |  248 +++++++-
 fs/ext2/ext2.h                             |    4 +
 fs/ext2/inode.c                            |   11 +-
 fs/ext2/namei.c                            |   89 +++-
 fs/ext2/super.c                            |    6 +
 fs/jffs2/dir.c                             |  104 ++++-
 fs/jffs2/fs.c                              |    4 +
 fs/jffs2/super.c                           |    2 +-
 fs/libfs.c                                 |   21 +-
 fs/namei.c                                 |  793 ++++++++++++++++++++++---
 fs/namespace.c                             |  146 +++++-
 fs/nfsd/nfs3xdr.c                          |    5 +
 fs/nfsd/nfs4xdr.c                          |    5 +
 fs/nfsd/nfsxdr.c                           |    4 +
 fs/open.c                                  |  116 +++-
 fs/readdir.c                               |   18 +
 fs/super.c                                 |   23 +
 fs/union.c                                 |  881 ++++++++++++++++++++++++++++
 fs/utimes.c                                |   13 +-
 include/linux/dcache.h                     |   40 ++
 include/linux/ext2_fs.h                    |    5 +
 include/linux/fs.h                         |   16 +
 include/linux/jffs2.h                      |    8 +
 include/linux/mount.h                      |    7 +-
 include/linux/namei.h                      |    2 +
 include/linux/union.h                      |   77 +++
 mm/shmem.c                                 |  195 ++++++-
 36 files changed, 3483 insertions(+), 160 deletions(-)
 create mode 100644 Documentation/filesystems/union-mounts.txt
 create mode 100644 fs/union.c
 create mode 100644 include/linux/union.h

