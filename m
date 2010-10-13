Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab0JMARj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 20:17:39 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:59968 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752545Ab0JMAQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 20:16:52 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: fs: Inode cache scalability V3
Date: Wed, 13 Oct 2010 11:15:43 +1100
Message-Id: <1286928961-15157-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is derived from Nick Piggin's VFS scalability tree.
there doesn't appear to be any push to get that tree into shape for
.37, so this is an attempt to start the process of finer grained
review of the series for upstream inclusion. I'm hitting VFS lock
contention problems with XFS on 8-16p machines now, so I need to get
this stuff moving.

This patch set is just the basic inode_lock breakup patches plus a
few more simple changes to the inode code. It stops short of
introducing RCU inode freeing because those changes are not
completely baked yet.

As a result, the full inode handling improvements of Nick's patch
set are not realised with this short series. However, my own testing
indicates that the amount of lock traffic and contention is down by
an order of magnitude on an 8-way box for parallel inode create and
unlink workloads, so there is still significant improvements from
just this patch set.

Version 2 of this series is a complete rework of the original patch
series.  Nick's original code nested list locks inside the the
inode->i_lock, resulting in a large mess of trylock operations to
get locks out of order all over the place. In many cases, the reason
fo this lock ordering is removed later on in Nick's series as
cleanups are introduced.

As a result I've pulled in several of the cleanups and re-ordered
the series such that cleanups, factoring and list splitting are done
before any of the locking changes. Instead of converting the inode
state flags first, I've converted them last, ensuring that
manipulations are kept inside other locks rather than outside them.

The series is made up of the following steps:

	- inode counters are made per-cpu
	- inode LRU manipulations are made lazy
	- i_list is split into two lists (grows inode by 2
	  pointers), one for tracking lru status, one for writeback
	  status
	- reference counting is factored, then renamed and locked
	  differently
	- inode hash operations are factored, then locked per bucket
	- superblock inode listis locked per-superblock
	- inode LRU is locked via a global lock
		- unclear what the best way to split this up from
		  here is, so no attempt is made to optimise
		  further.
		- Currently not showing signs of contention under
		  any workload on an 8p machine.
	- inode IO list are locked via a per-BDI lock
		- further analysis needed to determine the next step
		  in optimising this list. It is extremely contended
		  under parallel workloads because foreground
		  throttling (balance_dirty_pages) causes unbound
		  writeback parallelism and contention. Fixing the
		  unbound parallelism, I think, is a more important
		  first optimisation step than making the list
		  per-cpu.
	- lock i_state operations with i_lock
	- convert last_ino allocation to a percpu counter
	- protect iunique counter with it's own lock
	- remove inode_lock
	- factor destroying an inode into dispose_one_inode() which
	  is called from reclaim, dispose_list and iput_final.

None of the patcheѕ are unchanged, and several of them are new or
completely rewritten, so any previous testing is completely
invalidated. I have not tried to optimise locking by using trylock
loops - anywhere that requires out-of-order locking drops locks and
regains the locks needed for the next operation. This approach
simplified the code and lead to several improvments in the patch
series (e.g. moving inode->i_lock inside writeback_single_inode(),
and the dispose_one_inode factoring) that would have gone unnoticed
if I'd gone down the same trylock loop path that Nick used.

I've done some testing so far on ext3, ext4 and XFS (mostly sanity
and lock_stat profile testing), but I have not tested any other
filesystems. IOWs, it is light on testing at this point. I'm sending
out for review now that it passes basic sanity tests so that
comments on the reworked approach can be made.

Version 3:
- whitespace fix in inode_init_early.
- dropped patch that moves inodes around bdi lists as problem is now
  fixed in mainline.
- added comments explaining lazy inode LRU manipulations.
- added inode_lru_list_{add,del} helpers much earlier to avoid
  needing to export then unexport inode counters.
- renamed i_io to i_wb_list.
- removed iref_locked and just open code internal inode reference
  increments.
- added a WARN_ON() condition to detect iref() being called without
  a pre-existing reference count.
- added kerneldoc comment to iref().
- dropped iref_read() wrapper function patch
- killed the inode_hash_bucket wrapper, use hlist_bl_head directly
- moved spin_[un]lock_bucket wrappers to list_bl.h, and renamed them
  hlist_bl_[un]lock()
- added inode_unhashed() helper function.
- documented use of I_FREEING to ensure removal from inode lru and
  writeback lists is kept sane when the inode is being freed.
- added inode_wb_list_del() helper to avoid exporting the
  inode_to_bdi() function.
- added comments to explain why we need to set the i_state field
  before adding new inodes to various lists
- renamed last_ino_get() to get_next_ino().
- kept invalidate_list/dispose_list pairing for invalidate_inodes(),
  but changed the dispose list to use the i_sb_list pointer in the
  inode instead of the i_lru to avoid needing to take the
  inode_lru_lock for every inode on the superblock list.
- added patch from Christoph Hellwig to spilt up inode_add_to_lists.
  Modified the new function names to match the naming convention
  used by all the other list helpers in inode.c, and added a
  matching inode_sb_list_del() function for symmetry.
- added patch from Christoph Hellwig to move inode number assignment
  in get_new_inode() to the callers that don't directly assign an
  inode number.

Version 2:
- complete rework of series

--

The following changes since commit cb655d0f3d57c23db51b981648e452988c0223f9:

  Linux 2.6.36-rc7 (2010-10-06 13:39:52 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git inode-scale

Christoph Hellwig (2):
      fs: split __inode_add_to_list
      fs: do not assign default i_ino in new_inode

Dave Chinner (11):
      fs: Convert nr_inodes and nr_unused to per-cpu counters
      fs: Clean up inode reference counting
      exofs: use iput() for inode reference count decrements
      fs: rework icount to be a locked variable
      fs: Factor inode hash operations into functions
      fs: Introduce per-bucket inode hash locks
      fs: add a per-superblock lock for the inode list
      fs: split locking of inode writeback and LRU lists
      fs: Protect inode->i_state with the inode->i_lock
      fs: icache remove inode_lock
      fs: Reduce inode I_FREEING and factor inode disposal

Eric Dumazet (1):
      fs: introduce a per-cpu last_ino allocator

Nick Piggin (4):
      kernel: add bl_list
      fs: Implement lazy LRU updates for inodes.
      fs: inode split IO and LRU lists
      fs: Make iunique independent of inode_lock

 Documentation/filesystems/Locking      |    2 +-
 Documentation/filesystems/porting      |   10 +-
 Documentation/filesystems/vfs.txt      |    2 +-
 drivers/infiniband/hw/ipath/ipath_fs.c |    1 +
 drivers/infiniband/hw/qib/qib_fs.c     |    1 +
 drivers/misc/ibmasm/ibmasmfs.c         |    1 +
 drivers/oprofile/oprofilefs.c          |    1 +
 drivers/usb/core/inode.c               |    1 +
 drivers/usb/gadget/f_fs.c              |    1 +
 drivers/usb/gadget/inode.c             |    1 +
 fs/9p/vfs_inode.c                      |    5 +-
 fs/affs/inode.c                        |    2 +-
 fs/afs/dir.c                           |    2 +-
 fs/anon_inodes.c                       |    8 +-
 fs/autofs4/inode.c                     |    1 +
 fs/bfs/dir.c                           |    2 +-
 fs/binfmt_misc.c                       |    1 +
 fs/block_dev.c                         |   13 +-
 fs/btrfs/inode.c                       |   18 +-
 fs/buffer.c                            |    2 +-
 fs/ceph/mds_client.c                   |    2 +-
 fs/cifs/inode.c                        |    2 +-
 fs/coda/dir.c                          |    2 +-
 fs/configfs/inode.c                    |    1 +
 fs/debugfs/inode.c                     |    1 +
 fs/drop_caches.c                       |   19 +-
 fs/exofs/inode.c                       |    6 +-
 fs/exofs/namei.c                       |    2 +-
 fs/ext2/namei.c                        |    2 +-
 fs/ext3/ialloc.c                       |    4 +-
 fs/ext3/namei.c                        |    2 +-
 fs/ext4/ialloc.c                       |    4 +-
 fs/ext4/mballoc.c                      |    1 +
 fs/ext4/namei.c                        |    2 +-
 fs/freevxfs/vxfs_inode.c               |    1 +
 fs/fs-writeback.c                      |  192 +++++---
 fs/fuse/control.c                      |    1 +
 fs/gfs2/ops_inode.c                    |    2 +-
 fs/hfs/hfs_fs.h                        |    2 +-
 fs/hfs/inode.c                         |    2 +-
 fs/hfsplus/dir.c                       |    2 +-
 fs/hfsplus/hfsplus_fs.h                |    2 +-
 fs/hfsplus/inode.c                     |    2 +-
 fs/hpfs/inode.c                        |    2 +-
 fs/hugetlbfs/inode.c                   |    1 +
 fs/inode.c                             |  785 +++++++++++++++++++++-----------
 fs/internal.h                          |   11 +
 fs/jffs2/dir.c                         |    4 +-
 fs/jfs/jfs_txnmgr.c                    |    2 +-
 fs/jfs/namei.c                         |    2 +-
 fs/libfs.c                             |    2 +-
 fs/locks.c                             |    2 +-
 fs/logfs/dir.c                         |    2 +-
 fs/logfs/inode.c                       |    2 +-
 fs/logfs/readwrite.c                   |    2 +-
 fs/minix/namei.c                       |    2 +-
 fs/namei.c                             |    2 +-
 fs/nfs/dir.c                           |    2 +-
 fs/nfs/getroot.c                       |    2 +-
 fs/nfs/inode.c                         |    4 +-
 fs/nfs/nfs4state.c                     |    2 +-
 fs/nfs/write.c                         |    2 +-
 fs/nilfs2/gcdat.c                      |    1 +
 fs/nilfs2/gcinode.c                    |   22 +-
 fs/nilfs2/mdt.c                        |    5 +-
 fs/nilfs2/namei.c                      |    2 +-
 fs/nilfs2/segment.c                    |    2 +-
 fs/nilfs2/the_nilfs.h                  |    2 +-
 fs/notify/inode_mark.c                 |   47 ++-
 fs/notify/mark.c                       |    1 -
 fs/notify/vfsmount_mark.c              |    1 -
 fs/ntfs/inode.c                        |   10 +-
 fs/ntfs/super.c                        |    6 +-
 fs/ocfs2/dlmfs/dlmfs.c                 |    2 +
 fs/ocfs2/inode.c                       |    2 +-
 fs/ocfs2/namei.c                       |    2 +-
 fs/pipe.c                              |    2 +
 fs/proc/base.c                         |    2 +
 fs/proc/proc_sysctl.c                  |    2 +
 fs/quota/dquot.c                       |   32 +-
 fs/ramfs/inode.c                       |    1 +
 fs/reiserfs/namei.c                    |    2 +-
 fs/reiserfs/stree.c                    |    2 +-
 fs/reiserfs/xattr.c                    |    2 +-
 fs/smbfs/inode.c                       |    2 +-
 fs/super.c                             |    1 +
 fs/sysv/namei.c                        |    2 +-
 fs/ubifs/dir.c                         |    2 +-
 fs/ubifs/super.c                       |    2 +-
 fs/udf/inode.c                         |    2 +-
 fs/udf/namei.c                         |    2 +-
 fs/ufs/namei.c                         |    2 +-
 fs/xfs/linux-2.6/xfs_buf.c             |    1 +
 fs/xfs/linux-2.6/xfs_iops.c            |    6 +-
 fs/xfs/linux-2.6/xfs_trace.h           |    2 +-
 fs/xfs/xfs_inode.h                     |    3 +-
 include/linux/backing-dev.h            |    1 +
 include/linux/fs.h                     |   41 ++-
 include/linux/list_bl.h                |  145 ++++++
 include/linux/poison.h                 |    2 +
 include/linux/writeback.h              |    4 -
 ipc/mqueue.c                           |    3 +-
 kernel/cgroup.c                        |    1 +
 kernel/futex.c                         |    2 +-
 kernel/sysctl.c                        |    4 +-
 mm/backing-dev.c                       |   28 +-
 mm/filemap.c                           |    6 +-
 mm/rmap.c                              |    6 +-
 mm/shmem.c                             |    7 +-
 net/socket.c                           |    3 +-
 net/sunrpc/rpc_pipe.c                  |    1 +
 security/inode.c                       |    1 +
 security/selinux/selinuxfs.c           |    1 +
 113 files changed, 1059 insertions(+), 538 deletions(-)
 create mode 100644 include/linux/list_bl.h

