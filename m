Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab2CGVW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:22:57 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52137 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab2CGVWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:22:53 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 00/25] vfs: atomic open RFC
Date: Wed,  7 Mar 2012 22:22:17 +0100
Message-Id: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series allows clean implementation of atomic lookup+(create)+open and
create+open operations that previously were done via ->lookup and ->create using
open intents.

Testing and review is welcome, but at this stage mainly I'd like to hear
opinions on the overall design of the new interfaces.

This is based on the vfs fixes patchset posted previously on -fsdevel.

git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git atomic-open

Thanks,
Miklos

---
Miklos Szeredi (25):
      vfs: split do_lookup()
      vfs: reorganize do_last()
      vfs: split __dentry_open()
      vfs: add i_op->atomic_open()
      vfs: add filesystem flags for atomic_open
      vfs: add i_op->atomic_create()
      nfs: implement i_op->atomic_open()
      nfs: clean up ->create in nfs_rpc_ops
      nfs: remove nfs4 specific create function
      nfs: don't use nd->intent.open.flags
      nfs: don't use intents for checking atomic open
      fuse: implement i_op->atomic_create()
      cifs: implement i_op->atomic_open() and i_op->atomic_create()
      ceph: remove unused arg from ceph_lookup_open()
      ceph: implement i_op->atomic_open() and i_op->atomic_create()
      9p: implement i_op->atomic_create()
      vfs: remove open intents from nameidata
      vfs: only retry last component if opening stale dentry
      vfs: remove nameidata argument from vfs_create
      vfs: move O_DIRECT check to common code
      gfs2: use i_op->atomic_create()
      nfs: use i_op->atomic_create()
      vfs: remove nameidata argument from i_op->create()
      vfs: optionally skip lookup on exclusive create
      vfs: remove nameidata from lookup

---
 Documentation/filesystems/Locking |    3 +-
 Documentation/filesystems/vfs.txt |    2 +-
 fs/9p/v9fs.h                      |    3 +-
 fs/9p/vfs_inode.c                 |   36 +--
 fs/9p/vfs_inode_dotl.c            |   36 +-
 fs/adfs/dir.c                     |    2 +-
 fs/affs/affs.h                    |    5 +-
 fs/affs/namei.c                   |    4 +-
 fs/afs/dir.c                      |   12 +-
 fs/afs/mntpt.c                    |    7 +-
 fs/autofs4/root.c                 |    4 +-
 fs/bad_inode.c                    |    7 +-
 fs/befs/linuxvfs.c                |    4 +-
 fs/bfs/dir.c                      |    6 +-
 fs/btrfs/inode.c                  |    6 +-
 fs/cachefiles/namei.c             |    2 +-
 fs/ceph/dir.c                     |   38 +--
 fs/ceph/file.c                    |   23 +-
 fs/ceph/super.c                   |    2 +-
 fs/ceph/super.h                   |    6 +-
 fs/cifs/cifsfs.c                  |   24 ++-
 fs/cifs/cifsfs.h                  |    8 +-
 fs/cifs/dir.c                     |  175 +++++------
 fs/coda/dir.c                     |    8 +-
 fs/configfs/dir.c                 |    4 +-
 fs/cramfs/inode.c                 |    2 +-
 fs/ecryptfs/inode.c               |    9 +-
 fs/efs/efs.h                      |    2 +-
 fs/efs/namei.c                    |    3 +-
 fs/exofs/namei.c                  |    6 +-
 fs/ext2/namei.c                   |    4 +-
 fs/ext3/namei.c                   |    5 +-
 fs/ext4/namei.c                   |    5 +-
 fs/fat/namei_msdos.c              |    6 +-
 fs/fat/namei_vfat.c               |    6 +-
 fs/freevxfs/vxfs_lookup.c         |    5 +-
 fs/fuse/dir.c                     |   60 ++--
 fs/gfs2/inode.c                   |   24 +-
 fs/hfs/dir.c                      |    6 +-
 fs/hfs/inode.c                    |    3 +-
 fs/hfsplus/dir.c                  |    7 +-
 fs/hfsplus/inode.c                |    2 +-
 fs/hostfs/hostfs_kern.c           |    6 +-
 fs/hpfs/dir.c                     |    2 +-
 fs/hpfs/hpfs_fn.h                 |    2 +-
 fs/hpfs/namei.c                   |    2 +-
 fs/hppfs/hppfs.c                  |    3 +-
 fs/hugetlbfs/inode.c              |    3 +-
 fs/internal.h                     |    9 +-
 fs/isofs/isofs.h                  |    2 +-
 fs/isofs/namei.c                  |    2 +-
 fs/jffs2/dir.c                    |   11 +-
 fs/jfs/namei.c                    |    6 +-
 fs/libfs.c                        |    2 +-
 fs/logfs/dir.c                    |    6 +-
 fs/minix/namei.c                  |    5 +-
 fs/namei.c                        |  636 ++++++++++++++++++++++++++++---------
 fs/ncpfs/dir.c                    |    9 +-
 fs/nfs/dir.c                      |  278 +++++++----------
 fs/nfs/file.c                     |    2 +-
 fs/nfs/nfs3proc.c                 |    2 +-
 fs/nfs/nfs4proc.c                 |   48 ---
 fs/nfs/proc.c                     |    2 +-
 fs/nfs/super.c                    |    9 +-
 fs/nfsd/vfs.c                     |    4 +-
 fs/nilfs2/namei.c                 |    6 +-
 fs/ntfs/namei.c                   |    4 +-
 fs/ocfs2/dlmfs/dlmfs.c            |    3 +-
 fs/ocfs2/namei.c                  |    6 +-
 fs/omfs/dir.c                     |    6 +-
 fs/open.c                         |  113 +++----
 fs/openpromfs/inode.c             |    5 +-
 fs/proc/base.c                    |   22 +-
 fs/proc/generic.c                 |    3 +-
 fs/proc/internal.h                |    4 +-
 fs/proc/namespaces.c              |    2 +-
 fs/proc/proc_net.c                |    2 +-
 fs/proc/proc_sysctl.c             |    3 +-
 fs/proc/root.c                    |    9 +-
 fs/qnx4/namei.c                   |    2 +-
 fs/qnx4/qnx4.h                    |    2 +-
 fs/ramfs/inode.c                  |    2 +-
 fs/reiserfs/namei.c               |    7 +-
 fs/romfs/super.c                  |    3 +-
 fs/squashfs/namei.c               |    3 +-
 fs/sysfs/dir.c                    |    3 +-
 fs/sysv/namei.c                   |    4 +-
 fs/ubifs/dir.c                    |    6 +-
 fs/udf/namei.c                    |    6 +-
 fs/ufs/namei.c                    |    5 +-
 fs/xfs/xfs_iops.c                 |    9 +-
 include/linux/errno.h             |    1 +
 include/linux/fs.h                |   21 +-
 include/linux/namei.h             |   11 -
 include/linux/nfs_xdr.h           |    2 +-
 ipc/mqueue.c                      |    5 +-
 kernel/cgroup.c                   |    4 +-
 mm/shmem.c                        |    3 +-
 98 files changed, 1031 insertions(+), 889 deletions(-)


