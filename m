Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab1GWABh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 20:01:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41334 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab1GWABe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 20:01:34 -0400
Date: Sat, 23 Jul 2011 01:01:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs and fs patches for 3.1, part 1
Message-ID: <20110723000131.GE31405@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

	The big ones in that are
* ->permission() API change (death to separate boolean argument, death to
generic_permission() check_acl callback, death to file_permission(), death
to exec_permission())
* nfs4 mknod() fixes (and end to pointless carrying vfsmount pointers in the
guts of nfs)
* further reduction of struct nameidata exposure, including the LOOKUP_...
flags use
* dchinner: per-sb shrinkers
* hch: death to ->i_alloc_sem
* jbacik: SEEK_HOLE/SEEK_DATA, ->fsync() API change.

Also by jbacik: DCACHE_NEED_LOOKUP, which is going to be the basis for
atomic_open-done-right (aside of originally intended uses in btrfs).
Unfortunately, ->d_lock/->d_parent shite had sidetracked me in the last
couple of weeks of last cycle, so atomic_open will have to wait for -rc2
or -rc3; *PLEASE* hold any unionfs or overlayfs merges until then.

Other than that, there's a moderate bunch of assorted patches; I'll push
more of that in the next pull request (i.e. folks who don't see their
patches in the shortlog below, please wait for after the next vfs pull
request before complaining)

Shortlog:
Al Viro (68):
      new helper: iterate_supers_type()
      make exec_permission(dir) really equivalent to inode_permission(dir, MAY_EXEC)
      switch udf_ioctl() to inode_permission()
      switch path_init() to exec_permission()
      consolidate BINPRM_FLAGS_ENFORCE_NONDUMP handling
      kill file_permission() completely
      move exec_permission() up to the rest of permission-related functions
      lockless get_write_access/deny_write_access
      kill check_acl callback of generic_permission()
      ->permission() sanitizing: MAY_NOT_BLOCK
      ->permission() sanitizing: pass MAY_NOT_BLOCK to ->check_acl()
      ->permission() sanitizing: don't pass flags to ->check_acl()
      ->permission() sanitizing: don't pass flags to generic_permission()
      ->permission() sanitizing: don't pass flags to ->permission()
      ->permission() sanitizing: don't pass flags to ->inode_permission()
      selinux: don't transliterate MAY_NOT_BLOCK to IPERM_FLAG_RCU
      ->permission() sanitizing: don't pass flags to exec_permission()
      massage generic_permission() to treat directories on a separate path
      no reason to keep exec_permission() separate now
      merge do_revalidate() into its only caller
      ->permission() sanitizing: document API changes
      kill IPERM_FLAG_RCU
      ecryptfs_inode_permission() doesn't need to bail out on RCU
      cifs: fix the type of cifs_demultiplex_thread()
      nfs4_closedata doesn't need to mess with struct path
      nfs4_opendata doesn't need struct path either
      nfs_open_context doesn't need struct path either
      nameidata_to_nfs_open_context() doesn't need nameidata, actually...
      fix mknod() on nfs4 (hopefully)
      Don't pass nameidata when calling vfs_create() from mknod()
      don't transliterate lower bits of ->intent.open.flags to FMODE_...
      don't pass nameidata to vfs_create() from ecryptfs_create()
      no need to check for LOOKUP_OPEN in ->create() instances
      LOOKUP_CREATE and LOOKUP_RENAME_TARGET can be set only on the last step
      jfs_ci_revalidate() is safe from RCU mode
      ceph: LOOKUP_OPEN is set only when it's the last component
      cifs_lookup(): LOOKUP_OPEN is set only on the last component
      nfs: LOOKUP_{OPEN,CREATE,EXCL} is set only on the last step
      kill LOOKUP_CONTINUE
      new helpers: kern_path_create/user_path_create
      switch do_spufs_create() to user_path_create(), fix double-unlock
      make sure that nsproxy_cache is initialized early enough
      switch devtmpfs object creation/removal to separate kernel thread
      switch devtmpfs to kern_path_create()
      devtmpfs: get rid of bogus mkdir in create_path()
      kill lookup_create()
      switch vfs_path_lookup() to struct path
      unexport kern_path_parent()
      Make ->d_sb assign-once and always non-NULL
      get rid of pointless checks for dentry->sb == NULL
      btrfs: kill magical embedded struct superblock
      kill useless checks for sb->s_op == NULL
      nfsd4_list_rec_dir(): don't bother with reopening rec_file
      deuglify squashfs_lookup()
      make d_splice_alias(ERR_PTR(err), dentry) = ERR_PTR(err)
      switch assorted clock drivers to debugfs_remove_recursive()
      arm: don't create useless copies to pass into debugfs_create_dir()
      coda_venus_readdir(): use offsetof()
      minix_getattr(): don't bother with ->d_parent
      don't open-code parent_ino() in assorted ->readdir()
      get rid of useless dget_parent() in fs/btrfs/ioctl.c
      get rid of useless dget_parent() in btrfs rename() and link()
      jfs_lookup(): don't bother with . or ..
      simplify gfs2_lookup()
      switch d_add_ci() to d_splice_alias() in "found negative" case as well
      Remove dead code in dget_parent()
      fix IN_DELETE_SELF on overwriting rename() on ramfs et.al.
      jffs2: fix IN_DELETE_SELF on overwriting rename() killing a directory

Christoph Hellwig (10):
      fat: remove i_alloc_sem abuse
      fs: simplify handling of zero sized reads in __blockdev_direct_IO
      fs: kill i_alloc_sem
      rw_semaphore: remove up/down_read_non_owner
      fs: move inode_dio_wait calls into ->setattr
      fs: always maintain i_dio_count
      fs: simplify the blockdev_direct_IO prototype
      fs: move inode_dio_done to the end_io handler
      ext3: make ext3 mount default to barrier=1
      reiserfs: make reiserfs default to barrier=flush

Dave Chinner (13):
      vmscan: add shrink_slab tracepoints
      vmscan: shrinker->nr updates race and go wrong
      vmscan: reduce wind up shrinker->nr when shrinker can't do work
      vmscan: add customisable shrinker batch size
      inode: convert inode_stat.nr_unused to per-cpu counters
      inode: Make unused inode LRU per superblock
      inode: move to per-sb LRU locks
      superblock: move pin_sb_for_writeback() to fs/super.c
      superblock: introduce per-sb cache shrinker infrastructure
      inode: remove iprune_sem
      superblock: add filesystem shrinker operations
      vfs: increase shrinker batch size
      xfs: make use of new shrinker callout for the inode cache

David Howells (1):
      AFS: Fix silly characters in a comment

Jan Kara (2):
      ext4: Rewrite ext4_page_mkwrite() to use generic helpers
      isofs: Remove global fs lock

Josef Bacik (7):
      fs: add a DCACHE_NEED_LOOKUP flag for d_flags
      fs: add SEEK_HOLE and SEEK_DATA flags
      Btrfs: implement our own ->llseek
      Ext4: handle SEEK_HOLE/SEEK_DATA generically
      fs: handle SEEK_HOLE/SEEK_DATA properly in all fs's that define their own llseek
      drivers: fix up various ->llseek() implementations
      fs: push i_mutex and filemap_write_and_wait down into ->fsync() handlers

Kay Sievers (1):
      fs: seq_file - add event counter to simplify poll() support

Konstantin Khlebnikov (1):
      vfs: use ERR_CAST for err-ptr tossing in lookup_instantiate_filp

Randy Dunlap (1):
      mm/truncate.c: fix build for CONFIG_BLOCK not enabled

Tobias Klauser (1):
      VFS: Fixup kerneldoc for generic_permission()

Tomasz Stanislawski (1):
      anonfd: fix missing declaration

Wanlong Gao (1):
      fs:update the NOTE of the file_operations structure

Diffstat:
 Documentation/filesystems/Locking            |    8 +-
 Documentation/filesystems/porting            |   27 ++-
 Documentation/filesystems/vfs.txt            |   30 ++-
 arch/arm/mach-tegra/clock.c                  |    7 +-
 arch/arm/mach-ux500/clock.c                  |   31 +--
 arch/arm/plat-omap/clock.c                   |   12 +-
 arch/arm/plat-samsung/clock.c                |    7 +-
 arch/arm/plat-spear/clock.c                  |    7 +-
 arch/powerpc/platforms/cell/spufs/file.c     |   13 +-
 arch/powerpc/platforms/cell/spufs/inode.c    |   29 +-
 arch/powerpc/platforms/cell/spufs/spufs.h    |    2 +-
 arch/powerpc/platforms/cell/spufs/syscalls.c |   22 +-
 drivers/base/devtmpfs.c                      |  337 +++++++++++--------
 drivers/block/pktcdvd.c                      |    2 +-
 drivers/char/generic_nvram.c                 |    4 +
 drivers/char/nvram.c                         |    2 +
 drivers/char/ps3flash.c                      |   13 +-
 drivers/macintosh/nvram.c                    |    4 +
 drivers/md/md.c                              |   26 +-
 drivers/mtd/ubi/cdev.c                       |   10 +-
 drivers/sh/clk/core.c                        |    7 +-
 drivers/staging/pohmelfs/dir.c               |    2 +-
 drivers/staging/pohmelfs/inode.c             |   11 +-
 drivers/usb/gadget/printer.c                 |    5 +-
 drivers/video/fb_defio.c                     |   11 +-
 fs/9p/acl.c                                  |    4 +-
 fs/9p/acl.h                                  |    2 +-
 fs/9p/v9fs_vfs.h                             |    3 +-
 fs/9p/vfs_file.c                             |   22 ++-
 fs/9p/vfs_inode.c                            |    6 +-
 fs/9p/vfs_inode_dotl.c                       |    4 +-
 fs/affs/affs.h                               |    2 +-
 fs/affs/file.c                               |    8 +-
 fs/afs/afs_vl.h                              |    2 +-
 fs/afs/internal.h                            |    4 +-
 fs/afs/security.c                            |    6 +-
 fs/afs/write.c                               |   18 +-
 fs/attr.c                                    |    6 -
 fs/bad_inode.c                               |    5 +-
 fs/binfmt_elf.c                              |    3 +-
 fs/binfmt_elf_fdpic.c                        |    3 +-
 fs/binfmt_misc.c                             |    3 +-
 fs/block_dev.c                               |   17 +-
 fs/btrfs/acl.c                               |    5 +-
 fs/btrfs/ctree.h                             |    9 +-
 fs/btrfs/disk-io.c                           |   15 +-
 fs/btrfs/file.c                              |  169 +++++++++-
 fs/btrfs/inode.c                             |   25 +-
 fs/btrfs/ioctl.c                             |   16 +-
 fs/cachefiles/bind.c                         |    2 -
 fs/ceph/caps.c                               |    6 +-
 fs/ceph/dir.c                                |   21 +-
 fs/ceph/file.c                               |   22 +-
 fs/ceph/inode.c                              |    6 +-
 fs/ceph/super.h                              |    5 +-
 fs/cifs/cifsfs.c                             |   11 +-
 fs/cifs/cifsfs.h                             |    4 +-
 fs/cifs/connect.c                            |    5 +-
 fs/cifs/dir.c                                |   14 +-
 fs/cifs/file.c                               |   18 +-
 fs/cifs/readdir.c                            |    2 +-
 fs/coda/coda_int.h                           |    2 +-
 fs/coda/coda_linux.h                         |    2 +-
 fs/coda/dir.c                                |    9 +-
 fs/coda/file.c                               |    8 +-
 fs/coda/pioctl.c                             |    4 +-
 fs/dcache.c                                  |  262 +++++----------
 fs/direct-io.c                               |   88 ++++--
 fs/ecryptfs/file.c                           |    7 +-
 fs/ecryptfs/inode.c                          |   37 +--
 fs/efs/namei.c                               |    7 +-
 fs/exec.c                                    |   14 +-
 fs/exofs/file.c                              |   10 +-
 fs/exofs/namei.c                             |    7 +-
 fs/ext2/acl.c                                |    4 +-
 fs/ext2/acl.h                                |    2 +-
 fs/ext2/ext2.h                               |    3 +-
 fs/ext2/file.c                               |    4 +-
 fs/ext2/inode.c                              |    6 +-
 fs/ext2/namei.c                              |   14 +-
 fs/ext3/acl.c                                |    4 +-
 fs/ext3/acl.h                                |    2 +-
 fs/ext3/fsync.c                              |   18 +-
 fs/ext3/inode.c                              |    8 +-
 fs/ext3/namei.c                              |   14 +-
 fs/ext3/super.c                              |    2 +
 fs/ext4/acl.c                                |    4 +-
 fs/ext4/acl.h                                |    2 +-
 fs/ext4/ext4.h                               |    2 +-
 fs/ext4/file.c                               |   21 ++
 fs/ext4/fsync.c                              |   38 ++-
 fs/ext4/inode.c                              |  125 ++++----
 fs/ext4/namei.c                              |   14 +-
 fs/fat/fat.h                                 |    4 +-
 fs/fat/file.c                                |    8 +-
 fs/fat/inode.c                               |   10 +-
 fs/fat/namei_msdos.c                         |   29 +-
 fs/fat/namei_vfat.c                          |    6 +-
 fs/fs-writeback.c                            |   28 +--
 fs/fuse/dir.c                                |   28 +-
 fs/fuse/file.c                               |   45 ++-
 fs/fuse/fuse_i.h                             |    3 +-
 fs/generic_acl.c                             |    4 +-
 fs/gfs2/acl.c                                |    4 +-
 fs/gfs2/acl.h                                |    2 +-
 fs/gfs2/bmap.c                               |    2 +
 fs/gfs2/file.c                               |   19 +-
 fs/gfs2/inode.c                              |   35 +--
 fs/gfs2/inode.h                              |    2 +-
 fs/hfs/inode.c                               |   15 +-
 fs/hfsplus/hfsplus_fs.h                      |    3 +-
 fs/hfsplus/inode.c                           |   16 +-
 fs/hostfs/hostfs_kern.c                      |   21 +-
 fs/hpfs/dir.c                                |    4 +
 fs/hpfs/file.c                               |    7 +-
 fs/hpfs/hpfs_fn.h                            |    2 +-
 fs/hpfs/namei.c                              |    2 +-
 fs/hppfs/hppfs.c                             |    5 +-
 fs/inode.c                                   |  129 +++-----
 fs/internal.h                                |    6 +
 fs/isofs/dir.c                               |    3 -
 fs/isofs/inode.c                             |    1 -
 fs/isofs/isofs.h                             |    1 -
 fs/isofs/namei.c                             |   13 +-
 fs/isofs/rock.c                              |    3 -
 fs/jffs2/acl.c                               |    4 +-
 fs/jffs2/acl.h                               |    2 +-
 fs/jffs2/dir.c                               |    9 +-
 fs/jffs2/file.c                              |    9 +-
 fs/jffs2/os-linux.h                          |    2 +-
 fs/jfs/acl.c                                 |    4 +-
 fs/jfs/file.c                                |   11 +-
 fs/jfs/inode.c                               |    4 +-
 fs/jfs/jfs_acl.h                             |    2 +-
 fs/jfs/jfs_inode.h                           |    2 +-
 fs/jfs/namei.c                               |   49 +--
 fs/libfs.c                                   |   26 +-
 fs/logfs/dir.c                               |    4 +-
 fs/logfs/file.c                              |   11 +-
 fs/logfs/logfs.h                             |    2 +-
 fs/minix/inode.c                             |    3 +-
 fs/namei.c                                   |  462 +++++++++++---------------
 fs/namespace.c                               |    4 +-
 fs/ncpfs/file.c                              |    4 +-
 fs/nfs/cache_lib.c                           |    9 +-
 fs/nfs/dir.c                                 |   87 +++---
 fs/nfs/direct.c                              |    4 +-
 fs/nfs/file.c                                |   18 +-
 fs/nfs/inode.c                               |   20 +-
 fs/nfs/nfs4_fs.h                             |   10 +-
 fs/nfs/nfs4proc.c                            |   70 ++--
 fs/nfs/nfs4state.c                           |   12 +-
 fs/nfs/pagelist.c                            |    4 +-
 fs/nfs/read.c                                |    8 +-
 fs/nfs/super.c                               |   16 +-
 fs/nfs/write.c                               |   22 +-
 fs/nfsd/nfs4recover.c                        |   52 ++--
 fs/nilfs2/file.c                             |   12 +-
 fs/nilfs2/inode.c                            |   10 +-
 fs/nilfs2/namei.c                            |    7 +-
 fs/nilfs2/nilfs.h                            |    4 +-
 fs/ntfs/dir.c                                |   10 +-
 fs/ntfs/file.c                               |   13 +-
 fs/ntfs/inode.c                              |   10 +-
 fs/ocfs2/acl.c                               |    4 +-
 fs/ocfs2/acl.h                               |    2 +-
 fs/ocfs2/aops.c                              |   10 +-
 fs/ocfs2/file.c                              |   41 ++-
 fs/ocfs2/file.h                              |    2 +-
 fs/ocfs2/namei.c                             |    1 +
 fs/ocfs2/refcounttree.c                      |   49 +---
 fs/open.c                                    |    2 +-
 fs/proc/base.c                               |    6 +-
 fs/proc/proc_sysctl.c                        |    4 +-
 fs/read_write.c                              |   44 +++-
 fs/reiserfs/dir.c                            |   13 +-
 fs/reiserfs/file.c                           |   10 +-
 fs/reiserfs/inode.c                          |    8 +-
 fs/reiserfs/namei.c                          |    4 +-
 fs/reiserfs/super.c                          |    1 +
 fs/reiserfs/xattr.c                          |   25 +-
 fs/squashfs/namei.c                          |   10 +-
 fs/super.c                                   |  176 +++++++++-
 fs/sync.c                                    |   25 +--
 fs/sysfs/inode.c                             |    6 +-
 fs/sysfs/sysfs.h                             |    2 +-
 fs/ubifs/file.c                              |   21 +-
 fs/ubifs/ubifs.h                             |    2 +-
 fs/udf/file.c                                |    2 +-
 fs/ufs/namei.c                               |    2 -
 fs/xfs/linux-2.6/xfs_acl.c                   |    4 +-
 fs/xfs/linux-2.6/xfs_aops.c                  |    3 +
 fs/xfs/linux-2.6/xfs_file.c                  |   17 +-
 fs/xfs/linux-2.6/xfs_super.c                 |   26 +-
 fs/xfs/linux-2.6/xfs_sync.c                  |   71 ++---
 fs/xfs/linux-2.6/xfs_sync.h                  |    5 +-
 fs/xfs/xfs_acl.h                             |    2 +-
 include/linux/anon_inodes.h                  |    2 +
 include/linux/atomic.h                       |   26 ++
 include/linux/binfmts.h                      |    1 +
 include/linux/dcache.h                       |    8 +-
 include/linux/ext3_fs.h                      |    2 +-
 include/linux/fb.h                           |    3 +-
 include/linux/fs.h                           |  100 ++++--
 include/linux/generic_acl.h                  |    2 +-
 include/linux/mm.h                           |   39 +---
 include/linux/mnt_namespace.h                |    1 -
 include/linux/namei.h                        |    5 +-
 include/linux/nfs_fs.h                       |    6 +-
 include/linux/nsproxy.h                      |    1 +
 include/linux/reiserfs_xattr.h               |    4 +-
 include/linux/rwsem.h                        |   10 -
 include/linux/security.h                     |    9 +-
 include/linux/seq_file.h                     |    1 +
 include/linux/shrinker.h                     |   42 +++
 include/trace/events/vmscan.h                |   77 +++++
 ipc/shm.c                                    |    4 +-
 kernel/cgroup.c                              |    3 +-
 kernel/fork.c                                |    1 +
 kernel/nsproxy.c                             |    4 +-
 kernel/rwsem.c                               |   16 -
 mm/filemap.c                                 |    3 -
 mm/madvise.c                                 |    2 +-
 mm/rmap.c                                    |    1 -
 mm/swapfile.c                                |   29 +--
 mm/truncate.c                                |    3 +-
 mm/vmscan.c                                  |   71 +++-
 net/sunrpc/clnt.c                            |   11 +-
 net/unix/af_unix.c                           |   38 +--
 security/capability.c                        |    2 +-
 security/security.c                          |    9 +-
 security/selinux/avc.c                       |    2 +-
 security/selinux/hooks.c                     |    3 +-
 security/smack/smack_lsm.c                   |    5 +-
 security/tomoyo/realpath.c                   |    2 +-
 235 files changed, 2518 insertions(+), 1948 deletions(-)
