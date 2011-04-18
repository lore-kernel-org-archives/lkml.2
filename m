Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab1DRQBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:01:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40780 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab1DRQBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:01:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dODkhKCYiCqIaJaJl81C7ZxJ8Qwu7ihtf/gxKTATwnONyq71YxOA4YAe3EWKSE9KQz
         lVO6VIa9s56OnYVgmX8/FgfHG0JF80IIIBdNr2U8CanWlY1tLISoY0LWbs3qG0CU0/V2
         fju6dPvDkc0VAdLgN/Uy7csLDSBGNbTR2iS4w=
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz
Subject: [PATCH 0/6] overlay filesystem
Date: Mon, 18 Apr 2011 18:00:34 +0200
Message-Id: <1303142440-26328-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's an updated version of the overlay filesystem.

Git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v8

Changes from v7 to v8:

- split overlayfs.c into smaller files

- fix locking for copy up (reported by Al Viro)

- locking analysis of copy up vs. directory rename added as a comment

- tested with lockdep, fixed one lock annotation

- other bug fixes

To be done:

- redo i_op->open, waiting for status of atomic_open() from Al

- look into xattr support for tmpfs

Thanks,
Miklos

---
Andy Whitcroft (1):
      overlayfs: add statfs support

Miklos Szeredi (4):
      vfs: add i_op->open()
      vfs: export do_splice_direct() to modules
      vfs: introduce clone_private_mount()
      overlay filesystem

Neil Brown (1):
      overlay: overlay filesystem documentation

---
 Documentation/filesystems/overlayfs.txt |  167 +++++++++
 MAINTAINERS                             |    7 +
 fs/Kconfig                              |    1 +
 fs/Makefile                             |    1 +
 fs/namespace.c                          |   17 +
 fs/open.c                               |   76 +++--
 fs/overlayfs/Kconfig                    |    4 +
 fs/overlayfs/Makefile                   |    5 +
 fs/overlayfs/copy_up.c                  |  382 ++++++++++++++++++++
 fs/overlayfs/dir.c                      |  592 ++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c                    |  374 +++++++++++++++++++
 fs/overlayfs/overlayfs.c                |  596 +++++++++++++++++++++++++++++++
 fs/overlayfs/overlayfs.h                |   63 ++++
 fs/overlayfs/readdir.c                  |  560 +++++++++++++++++++++++++++++
 fs/splice.c                             |    1 +
 include/linux/fs.h                      |    2 +
 include/linux/mount.h                   |    3 +
 17 files changed, 2825 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/filesystems/overlayfs.txt
 create mode 100644 fs/overlayfs/Kconfig
 create mode 100644 fs/overlayfs/Makefile
 create mode 100644 fs/overlayfs/copy_up.c
 create mode 100644 fs/overlayfs/dir.c
 create mode 100644 fs/overlayfs/inode.c
 create mode 100644 fs/overlayfs/overlayfs.c
 create mode 100644 fs/overlayfs/overlayfs.h
 create mode 100644 fs/overlayfs/readdir.c
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
