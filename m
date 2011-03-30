Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382Ab1C3WCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:02:01 -0400
Received: from cobra.newdream.net ([66.33.216.30]:43161 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291Ab1C3WB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:01:57 -0400
From: Sage Weil <sage@newdream.net>
To: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mszeredi@suse.cz,
        Sage Weil <sage@newdream.net>
Subject: [PATCH 0/7] Do not dentry_unhash() in VFS
Date: Wed, 30 Mar 2011 15:09:21 -0700
Message-Id: <1301522968-4382-1-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al, everyone,

For the most part the VFS does not hash or unhash dentries outside of 
dcache pruning.  This is left to the file system namespace methods.  The 
only exception is on rmdir and directory rename, where we call 
dentry_unhash() for the benefit of a few file systems that can't handle 
lingering references to the empty and unlinked directory.

This patchset aims to clean this up by pushing the dentry_unhash calls 
into each fs where they can be safely removed on a per-fs basis.  We 
also take this opportunity to finally fix a longstanding bug in 
vfs_rename_dir() which rehashes new_dentry (Miklos' patch, see
        http://marc.info/?l=linux-fsdevel&m=121666695328987&w=2
        http://marc.info/?t=121580579500004&r=1&w=2
).

On a per-fs basis, the dentry_unhash calls can be replaced with 
shrink_dcache_parent (or dropped entirely) if it is safe to do so.  I 
expect that this is safe for most of them.

My hope is that this will move us closer to being able to introduce a 
->d_prune d_op.  Independent of that, however, I think this is a 
worthwhile dcache cleanup.

Thanks!
sage



Miklos Szeredi (1):
  vfs: fix vfs_rename_dir for FS_RENAME_DOES_D_MOVE filesystems

Sage Weil (6):
  vfs: dentry_unhash immediately prior to rmdir
  vfs: remove dget() from dentry_unhash()
  vfs: push dentry_unhash on rmdir into file systems
  vfs: push dentry_unhash on rename_dir into file systems
  vfs: update dentry_unhash() comment
  libfs: drop unneeded dentry_unhash

 fs/9p/vfs_inode.c       |    4 ++++
 fs/affs/namei.c         |    5 +++++
 fs/afs/dir.c            |    5 +++++
 fs/autofs4/root.c       |    2 ++
 fs/bfs/dir.c            |    3 +++
 fs/btrfs/inode.c        |    5 +++++
 fs/ceph/dir.c           |    6 ++++++
 fs/cifs/inode.c         |    5 +++++
 fs/coda/dir.c           |    5 +++++
 fs/configfs/dir.c       |    2 ++
 fs/ecryptfs/inode.c     |    5 +++++
 fs/exofs/namei.c        |    5 +++++
 fs/ext2/namei.c         |    5 +++++
 fs/ext3/namei.c         |    5 +++++
 fs/ext4/namei.c         |    5 +++++
 fs/fat/namei_msdos.c    |    5 +++++
 fs/fat/namei_vfat.c     |    5 +++++
 fs/fuse/dir.c           |    6 ++++++
 fs/gfs2/ops_inode.c     |    5 +++++
 fs/hfs/dir.c            |    6 ++++++
 fs/hfsplus/dir.c        |    2 ++
 fs/hostfs/hostfs_kern.c |    5 +++++
 fs/hpfs/namei.c         |    9 ++++++---
 fs/jffs2/dir.c          |    5 +++++
 fs/jfs/namei.c          |    5 +++++
 fs/libfs.c              |    4 ++++
 fs/logfs/dir.c          |    5 +++++
 fs/minix/namei.c        |    5 +++++
 fs/namei.c              |   21 ++++++---------------
 fs/ncpfs/dir.c          |    5 +++++
 fs/nfs/dir.c            |    5 +++++
 fs/nilfs2/namei.c       |    5 +++++
 fs/ocfs2/namei.c        |    6 ++++++
 fs/omfs/dir.c           |    5 +++++
 fs/reiserfs/namei.c     |    5 +++++
 fs/reiserfs/xattr.c     |    1 -
 fs/sysv/namei.c         |    5 +++++
 fs/ubifs/dir.c          |    5 +++++
 fs/udf/namei.c          |    5 +++++
 fs/ufs/namei.c          |    5 +++++
 40 files changed, 188 insertions(+), 19 deletions(-)

