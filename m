Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab2HOPrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:47:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49173 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab2HOPrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:47:05 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com, dhowells@redhat.com,
        hpj@urpla.net, sedat.dilek@googlemail.com, penberg@kernel.org,
        goran.cetusic@gmail.com, romain@orebokech.com, mszeredi@suse.cz
Subject: [PATCH 00/13] overlay filesystem: request for inclusion (v14)
Date: Wed, 15 Aug 2012 17:48:07 +0200
Message-Id: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the latest version of the overlayfs series.

Git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v14

Please consider for 3.7.

Thanks,
Miklos


---
Andy Whitcroft (3):
      overlayfs: add statfs support
      ovl: switch to __inode_permission()
      overlayfs: copy up i_uid/i_gid from the underlying inode

Erez Zadok (1):
      overlayfs: implement show_options

Miklos Szeredi (6):
      vfs: add i_op->open()
      vfs: export do_splice_direct() to modules
      vfs: introduce clone_private_mount()
      overlay filesystem
      fs: limit filesystem stacking depth
      vfs: export __inode_permission() to modules

Neil Brown (1):
      overlay: overlay filesystem documentation

Robin Dong (2):
      overlayfs: fix possible leak in ovl_new_inode
      overlayfs: create new inode in ovl_link

---
 Documentation/filesystems/Locking       |    2 +
 Documentation/filesystems/overlayfs.txt |  199 +++++++++
 Documentation/filesystems/vfs.txt       |    7 +
 MAINTAINERS                             |    7 +
 fs/Kconfig                              |    1 +
 fs/Makefile                             |    1 +
 fs/ecryptfs/main.c                      |    7 +
 fs/internal.h                           |    5 -
 fs/namei.c                              |   10 +-
 fs/namespace.c                          |   18 +
 fs/open.c                               |   23 +-
 fs/overlayfs/Kconfig                    |    4 +
 fs/overlayfs/Makefile                   |    7 +
 fs/overlayfs/copy_up.c                  |  385 ++++++++++++++++++
 fs/overlayfs/dir.c                      |  604 ++++++++++++++++++++++++++++
 fs/overlayfs/inode.c                    |  372 +++++++++++++++++
 fs/overlayfs/overlayfs.h                |   70 ++++
 fs/overlayfs/readdir.c                  |  566 ++++++++++++++++++++++++++
 fs/overlayfs/super.c                    |  665 +++++++++++++++++++++++++++++++
 fs/splice.c                             |    1 +
 include/linux/fs.h                      |   14 +
 include/linux/mount.h                   |    3 +
 22 files changed, 2961 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/filesystems/overlayfs.txt
 create mode 100644 fs/overlayfs/Kconfig
 create mode 100644 fs/overlayfs/Makefile
 create mode 100644 fs/overlayfs/copy_up.c
 create mode 100644 fs/overlayfs/dir.c
 create mode 100644 fs/overlayfs/inode.c
 create mode 100644 fs/overlayfs/overlayfs.h
 create mode 100644 fs/overlayfs/readdir.c
 create mode 100644 fs/overlayfs/super.c

------------------------------------------------------------------------------
Changes from v13 to v14

- update to 3.6

- copy i_uid/i_gid from the underlying inode (patch by Andy Whitcroft)

------------------------------------------------------------------------------
Changes from v12 to v13

- create new inode in ovl_link (patch by Robin Dong)

- switch to __inode_permission() (patch by Andy Whitcroft)

------------------------------------------------------------------------------
Changes from v11 to v12

- update to for-next of vfs tree

- split __dentry_open argument cleanup patch from vfs-add-i_op-open.patch

- change i_op->open and vfs_open so that they take "struct file *"

------------------------------------------------------------------------------
Changes from v10 to v11

- fix overlayfs over overlayfs

- improve stack use of lookup and readdir

- add limitations to documentation

- make lower mount read-only

- update permission and fsync to new API

------------------------------------------------------------------------------
Changes from v9 to v10

- prevent d_delete() from turning upperdentry negative (reported by
  Erez Zadok)

- show mount options in /proc/mounts and friends (patch by Erez Zadok)

- fix off-by-one error in readdir (reported by Jordi Pujol)

------------------------------------------------------------------------------
Changes from v8 to v9

- support xattr on tmpfs

- fix build after split-up

- fix remove after rename (reported by Jordi Pujol)

- fix rename failure case

------------------------------------------------------------------------------
Changes from v7 to v8:

- split overlayfs.c into smaller files

- fix locking for copy up (reported by Al Viro)

- locking analysis of copy up vs. directory rename added as a comment

- tested with lockdep, fixed one lock annotation

- other bug fixes

------------------------------------------------------------------------------
Changes from v6 to v7

- added patches from Felix Fietkau to fix deadlocks on jffs2

- optimized directory removal

- properly clean up after copy-up and other failures

------------------------------------------------------------------------------
Changes from v5 to v6

- optimize directory merging

  o use rbtree for weeding out duplicates

  o use a cursor for current position within the stream

- instead of f_op->open_other(), implement i_op->open()

- don't share inodes for non-directory dentries - for now.  I hope
  this can come back once RCU lookup code has settled.

- misc bug fixes

------------------------------------------------------------------------------
Changes from v4 to v5

- fix copying up if fs doesn't support xattrs (Andy Whitcroft)

- clone mounts to be used internally to access the underlying
  filesystems

------------------------------------------------------------------------------
Changes from v3 to v4

- export security_inode_permission to allow overlayfs to be modular
  (Andy Whitcroft)

- add statfs support (Andy Whitcroft)

- change BUG_ON to WARN_ON

- Revert "vfs: add flag to allow rename to same inode", instead
  introduce s_op->is_same_inode()

- overlayfs: fix rename to self

- fix whiteout after rename

------------------------------------------------------------------------------
Changes from v2 to v3

 - Minimal remount support.  As overlayfs reflects the 'readonly'
   mount status in write-access to the upper filesystem, we must
   handle remount and either drop or take write access when the ro
   status changes. (NeilBrown)

 - Use correct seek function for directories.  It is incorrect to call
   generic_llseek_file on a file from a different filesystem.  For
   that we must use the seek function that the filesystem defines,
   which is called by vfs_llseek.  Also, we only want to seek the
   realfile when is_real is true.  Otherwise we just want to update
   our own f_pos pointer, so use generic_llseek_file for
   that. (NeilBrown)

 - Initialise is_real before use.  The previous patch can use
   od->is_real before it is properly initialised is llseek is called
   before readdir.  So factor out the initialisation of is_real and
   call it from both readdir and llseek when f_pos is 0. (NeilBrown)

 - Rename ovl_fill_cache to ovl_dir_read (NeilBrown)

 - Tiny optimisation in open_other handling (NeilBrown)

 - Assorted updates to Documentation/filesystems/overlayfs.txt (NeilBrown)

 - Make copy-up work for >=4G files, make it killable during copy-up.
   Need to fix recovery after a failed/interrupted copy-up.

 - Store and reference upper/lower dentries in overlay dentries.
   Store and reference upper/lower vfsmounts in overlay superblock.

 - Add necessary barriers for setting upper dentry in copyup and for
   retrieving upper dentry locklessly.

 - Make sure the right file is used for directory fsync() after
   copy-up.

 - Add locking to ovl_dir_llseek() to prevent concurrent call of
   ovl_dir_reset() with ovl_dir_read().

 - Get rid of ovl_dentry_iput().  The VFS doesn't provide enough
   locking for this function that the contents of ->d_fsdata could be
   safely updated.

 - After copying up a non-directory unhash the dentry.  This way the
   lower dentry ref, which is no longer necessary, can go away.  This
   revealed a use-after-free bug in truncate handling in
   fs/namei.c:finish_open().

 - Fix if a copy-up happens between the follow_linka the put_link
   calls.

 - Replace some WARN_ONs with BUG_ON.  Some things just _really_
   shouldn't happen.

 - Extract common code from ovl_unlink and ovl_rmdir to a helper
   function.

 - After unlink and rmdir unhash the dentry.  This will get rid of the
   lower and upper dentry references after there are no more users of
   the deleted dentry.  This is a safe replacement for the removed
   ->d_iput() functionality.

 - Added checks to unlink, rmdir and rename to verify that the
   parent-child relationship in the upper filesystem matches that of
   the overlay.  This is necessary to prevent crash and/or corruption
   if the upper filesystem topology is being modified while part of
   the overlay.

 - Optimize checking whiteout and opaque attributes.

 - Optimize copy-up on truncate: don't copy up whole file before
   truncating

 - Misc bug fixes

------------------------------------------------------------------------------
Changes from v1 to v2

 - rename "hybrid union filesystem" to "overlay filesystem" or overlayfs

 - added documentation written by Neil

 - correct st_dev for directories (reported by Neil)

 - use getattr() to get attributes from the underlying filesystems,
   this means that now an overlay filesystem itself can be the lower,
   read-only layer of another overlay

 - listxattr filters out private extended attributes

 - get write ref on the upper layer on mount unless the overlay
   itself is mounted read-only

 - raise capabilities for copy up, dealing with whiteouts and opaque
   directories.  Now the overlay works for non-root users as well

 - "rm -rf" didn't work correctly in all cases if the directory was
   copied up between opendir and the first readdir, this is now fixed
   (and the directory operations consolidated)

 - simplified copy up, this broke optimization for truncate and
   open(O_TRUNC) (now file is copied up to be immediately truncated,
   will fix)

 - st_nlink for merged directories set to 1, this is an "illegal"
   value that normal filesystems never have but some use it to
   indicate that the number of subdirectories is unknown.  Utilities
   (find, ...) seem to tolerate this well.

 - misc fixes I forgot about


