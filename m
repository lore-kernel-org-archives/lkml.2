Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935737Ab0EVCN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 22:13:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39798 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935705Ab0EVCNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 22:13:25 -0400
Date: Sat, 22 May 2010 03:13:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs queue, part 1
Message-ID: <20100522021322.GK31073@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted VFS and filesystem patches; the most drastic part from the core
VFS POV is the change of superblock refcounting and associated changes
to "do something to all filesystems that..." kind of loops.  S_BIAS is
gone, atomic_inc_not_zero(&sb->s_active) is used by grab_super() instead
of playing these games and as the result we are able to do a massive
simplification of the locking rules.  Additionally, we avoid a lot of
PITA with traversals of superblocks' list by leaving superblock on s_list
until the very end and checking for empty s_instances while iterating
through all superblocks to skip the ones that would've been already removed
by the code currently in tree.

There's a lot of other stuff as well, of course, but it's less serious
surgery.  There *is* other tricky stuff for that cycle, but I'd rather
send a separate pull request or two for that in a couple of days.

Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (30):
      clean DCACHE_CANT_MOUNT in d_delete()
      Simplify devpts_get_sb() failure exits
      fix a couple of ecryptfs leaks
      Clean ecryptfs ->get_sb() up
      ceph: should use deactivate_locked_super() on failure exits
      sb_entry() has been killed a couple of years ago and resurrected on mismerge
      get rid of open-coded grab_super() in get_active_super()
      get rid of S_BIAS
      Saner locking around deactivate_super()
      Leave superblocks on s_list until the end
      get rid of restarts in sync_filesystems()
      Convert simple loops over superblocks to list_for_each_entry_safe
      fix do_emergency_remount()/umount() races
      fix get_active_super()/umount() race
      In get_super() and user_get_super() restarts are unconditional
      fix prune_dcache()/umount() race
      Bury __put_super_and_need_restart()
      new helper: iterate_supers()
      switch selinux delayed superblock handling to iterate_supers()
      Take statfs variants to fs/statfs.c
      Move grabbing s_umount to callers of grab_super()
      Trim includes in fs/super.c
      logfs: replace inode uid,gid,mode initialization with helper function
      Ban ecryptfs over ecryptfs
      AFS: Don't put struct file on the stack
      simplify access to ecryptfs inodes in ->readpage() and friends
      switch ecryptfs_get_locked_page() to struct inode *
      switch ecryptfs_write() to struct inode *, kill on-stack fake files
      get rid of home-grown mutex in cris eeprom.c
      fix handling of offsets in cris eeprom.c, get rid of fake on-stack files

Cesar Eduardo Barros (1):
      fs/partitions: use ADDPART_FLAG_RAID instead of magic number

Christoph Hellwig (3):
      remove incorrect comment in do_emergency_remount
      nfsd: open a file descriptor for fsync in nfs4 recovery
      sanitize vfs_fsync calling conventions

Dmitry Monakhov (19):
      vfs: Add inode uid,gid,mode init helper
      9p: replace inode uid,gid,mode initialization with helper function
      jfs: replace inode uid,gid,mode init with helper
      btrfs: replace inode uid,gid,mode initialization with helper function
      exofs: replace inode uid,gid,mode initialization with helper function
      ext2: replace inode uid,gid,mode init with helper
      ext3: replace inode uid,gid,mode init with helper
      ext4: replace inode uid,gid,mode init with helper
      minix: replace inode uid,gid,mode init with helper
      nilfs2: replace inode uid,gid,mode initialization with helper function
      ocfs2: replace inode uid,gid,mode initialization with helper function
      bfs: replace inode uid,gid,mode initialization with helper function
      omfs: replace inode uid,gid,mode initialization with helper function
      ramfs: replace inode uid,gid,mode initialization with helper function
      reiserfs: replace inode uid,gid,mode initialization with helper function
      sysv: replace inode uid,gid,mode initialization with helper function
      ubifs: replace inode uid,gid,mode initialization with helper function
      udf: replace inode uid,gid,mode init with helper
      ufs: replace inode uid,gid,mode initialization with helper function

Eric Paris (1):
      anon_inode: set S_IFREG on the anon_inode

H Hartley Sweeten (1):
      fs-writeback.c: bitfields should be unsigned

Huang Shijie (1):
      namei.c : update mnt when it needed

Josef Bacik (1):
      Introduce freeze_super and thaw_super for the fsfreeze ioctl

Richard Kennedy (1):
      fs: inode.c use atomic_inc_return in __iget

Roland Dreier (1):
      vfs: add lockdep annotation to s_vfs_rename_key for ecryptfs

Stephen Hemminger (10):
      fs: xattr_handler table should be const
      btrfs: constify xattr_handler
      ext2: constify xattr_handler
      ext3: constify xattr handlers
      ext4: constify xattr_handler
      reiserfs: constify xattr_handler
      xfs: constify xattr_handler
      jffs2: constify xattr_handler
      ocfs: constify xattr_handler
      gfs: constify xattr_handler

Diffstat:
 arch/cris/arch-v10/drivers/eeprom.c |   48 ++----
 drivers/block/loop.c                |    4 +-
 drivers/md/bitmap.c                 |    2 +-
 drivers/usb/gadget/storage_common.c |    2 +-
 fs/9p/vfs_inode.c                   |    4 +-
 fs/Makefile                         |    2 +-
 fs/afs/dir.c                        |    6 +-
 fs/afs/file.c                       |   64 ++++---
 fs/afs/internal.h                   |    1 +
 fs/afs/mntpt.c                      |    6 +-
 fs/anon_inodes.c                    |    2 +-
 fs/bfs/dir.c                        |    4 +-
 fs/block_dev.c                      |   73 ++------
 fs/btrfs/acl.c                      |    4 +-
 fs/btrfs/inode.c                    |   11 +-
 fs/btrfs/xattr.c                    |    2 +-
 fs/btrfs/xattr.h                    |    6 +-
 fs/buffer.c                         |   25 +--
 fs/ceph/file.c                      |    3 +-
 fs/ceph/super.c                     |    3 +-
 fs/coda/file.c                      |    2 +-
 fs/dcache.c                         |   20 +--
 fs/devpts/inode.c                   |    9 +-
 fs/drop_caches.c                    |   24 +---
 fs/ecryptfs/ecryptfs_kernel.h       |    5 +-
 fs/ecryptfs/file.c                  |    4 +-
 fs/ecryptfs/inode.c                 |   48 +-----
 fs/ecryptfs/main.c                  |  166 +++++++++---------
 fs/ecryptfs/mmap.c                  |   19 +--
 fs/ecryptfs/read_write.c            |   13 +-
 fs/ecryptfs/super.c                 |   22 ---
 fs/exofs/inode.c                    |   11 +-
 fs/ext2/acl.c                       |    4 +-
 fs/ext2/ialloc.c                    |   12 +-
 fs/ext2/xattr.c                     |   10 +-
 fs/ext2/xattr.h                     |   12 +-
 fs/ext2/xattr_security.c            |    2 +-
 fs/ext2/xattr_trusted.c             |    2 +-
 fs/ext2/xattr_user.c                |    2 +-
 fs/ext3/acl.c                       |    4 +-
 fs/ext3/ialloc.c                    |   13 +-
 fs/ext3/xattr.c                     |   10 +-
 fs/ext3/xattr.h                     |   12 +-
 fs/ext3/xattr_security.c            |    2 +-
 fs/ext3/xattr_trusted.c             |    2 +-
 fs/ext3/xattr_user.c                |    2 +-
 fs/ext4/acl.c                       |    4 +-
 fs/ext4/ialloc.c                    |   12 +-
 fs/ext4/xattr.c                     |   10 +-
 fs/ext4/xattr.h                     |   12 +-
 fs/ext4/xattr_security.c            |    2 +-
 fs/ext4/xattr_trusted.c             |    2 +-
 fs/ext4/xattr_user.c                |    2 +-
 fs/fs-writeback.c                   |    6 +-
 fs/generic_acl.c                    |    4 +-
 fs/gfs2/acl.c                       |    2 +-
 fs/gfs2/acl.h                       |    2 +-
 fs/gfs2/super.h                     |    2 +-
 fs/gfs2/xattr.c                     |    6 +-
 fs/inode.c                          |   26 +++-
 fs/internal.h                       |    2 +
 fs/ioctl.c                          |   15 +--
 fs/jffs2/acl.c                      |    4 +-
 fs/jffs2/acl.h                      |    4 +-
 fs/jffs2/security.c                 |    2 +-
 fs/jffs2/xattr.c                    |    8 +-
 fs/jffs2/xattr.h                    |    8 +-
 fs/jffs2/xattr_trusted.c            |    2 +-
 fs/jffs2/xattr_user.c               |    2 +-
 fs/jfs/jfs_inode.c                  |   12 +-
 fs/logfs/inode.c                    |    9 +-
 fs/minix/bitmap.c                   |    5 +-
 fs/minix/minix.h                    |    2 +-
 fs/minix/namei.c                    |   11 +-
 fs/namei.c                          |    5 +-
 fs/nfsd/nfs4recover.c               |   87 +++++-----
 fs/nfsd/vfs.c                       |    5 +-
 fs/nilfs2/inode.c                   |   11 +-
 fs/notify/inotify/inotify.c         |   88 ++--------
 fs/ocfs2/acl.c                      |    4 +-
 fs/ocfs2/namei.c                    |    9 +-
 fs/ocfs2/xattr.c                    |   12 +-
 fs/ocfs2/xattr.h                    |   12 +-
 fs/omfs/inode.c                     |    4 +-
 fs/open.c                           |  166 ------------------
 fs/partitions/efi.c                 |    2 +-
 fs/partitions/mac.c                 |    2 +-
 fs/partitions/msdos.c               |    2 +-
 fs/quota/quota.c                    |   32 +---
 fs/ramfs/inode.c                    |   20 +--
 fs/reiserfs/namei.c                 |   18 +--
 fs/reiserfs/xattr.c                 |   16 +-
 fs/reiserfs/xattr_acl.c             |    4 +-
 fs/reiserfs/xattr_security.c        |    2 +-
 fs/reiserfs/xattr_trusted.c         |    2 +-
 fs/reiserfs/xattr_user.c            |    2 +-
 fs/statfs.c                         |  196 +++++++++++++++++++++
 fs/super.c                          |  321 ++++++++++++++++++++---------------
 fs/sync.c                           |   86 ++--------
 fs/sysv/ialloc.c                    |   11 +-
 fs/ubifs/dir.c                      |    9 +-
 fs/udf/ialloc.c                     |   11 +-
 fs/udf/namei.c                      |   10 +-
 fs/ufs/ialloc.c                     |   10 +-
 fs/xattr.c                          |   14 +-
 fs/xfs/linux-2.6/xfs_acl.c          |    4 +-
 fs/xfs/linux-2.6/xfs_super.h        |    2 +-
 fs/xfs/linux-2.6/xfs_xattr.c        |    8 +-
 fs/xfs/xfs_acl.h                    |    4 +-
 include/linux/fs.h                  |   20 +-
 include/linux/generic_acl.h         |    4 +-
 include/linux/ramfs.h               |    3 +-
 include/linux/reiserfs_acl.h        |    4 +-
 include/linux/reiserfs_xattr.h      |    6 +-
 include/linux/xattr.h               |    2 +-
 mm/msync.c                          |    2 +-
 mm/shmem.c                          |   29 +--
 security/selinux/hooks.c            |   55 +-----
 security/selinux/include/objsec.h   |    1 -
 119 files changed, 906 insertions(+), 1293 deletions(-)
