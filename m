Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab0ITSEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:04:47 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34541 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab0ITSEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:04:46 -0400
Message-Id: <20100920180404.939991832@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Mon, 20 Sep 2010 20:04:04 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk
Subject: [PATCH 0/7 v3] overlay filesystem prototype
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's an updated patch series.

For now I reverted Neil's revalidation patch.  Not requiring strict
read-only would make sense for just trying it out and experimenting.
But for real uses, I'm not sure...

Git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v3

Thanks,
Miklos

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
