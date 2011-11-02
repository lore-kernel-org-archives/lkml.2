Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab1KBDAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 23:00:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:18960 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab1KBDAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 23:00:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,441,1315206000"; 
   d="scan'208";a="69540003"
Date: Wed, 2 Nov 2011 11:00:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: FS <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] writeback changes for 3.2-rc1
Message-ID: <20111102030016.GA23054@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 9b13776977d45505469edc6decc93e9e3799afe2:

  Merge branch 'for-linus' of git://git.infradead.org/users/sameo/mfd-2.6 (2011-10-02 19:23:44 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git writeback-for-linus

There are two patch series:

1) IO-less dirty throttling

By not submitting writeback IO from the dirtier tasks' context,
IO seeks _and_ CPU contentions could be greatly reduced.

Users may also notice much smoothed pause times in balance_dirty_pages()
and hence in the write() syscall, especially in cases NFS, JBOD and 2+
concurrent dd's.  This will in general reduce stalls in the "pipeline"
type workloads that have the write() syscall inside its loop, such as

        loop {
                read() from network
                write() to disk
        }

The change will inevitably trigger regressions in some FS and/or
unknown workloads. However I've managed to address the known issues
and built the tracing/visualization scripts for debugging new ones
in the easy way :-)

2) report writeback reason in tracing events

I apologize for rebasing the writeback reason patches, which would
otherwise cost a merge commit. Either way is not good and I'll take
care next time to make the multiple topic branches either
fast-forwardable or base one series on top of the other.

Curt Wohlgemuth (2):
      writeback: send work item to queue_io, move_expired_inodes
      writeback: Add a 'reason' to wb_writeback_work

Wu Fengguang (14):
      writeback: account per-bdi accumulated dirtied pages
      writeback: dirty position control
      writeback: add bg_threshold parameter to __bdi_update_bandwidth()
      writeback: dirty rate control
      writeback: stabilize bdi->dirty_ratelimit
      writeback: per task dirty rate limit
      writeback: IO-less balance_dirty_pages()
      writeback: limit max dirty pause time
      writeback: control dirty pause time
      writeback: dirty position control - bdi reserve area
      writeback: per-bdi background threshold
      writeback: fix ppc compile warnings on do_div(long long, unsigned long)
      writeback: trace event bdi_dirty_ratelimit
      writeback: trace event balance_dirty_pages

 fs/btrfs/extent-tree.c           |    3 +-
 fs/buffer.c                      |    2 +-
 fs/ext4/inode.c                  |    2 +-
 fs/fs-writeback.c                |   84 +++--
 fs/quota/quota.c                 |    2 +-
 fs/sync.c                        |    4 +-
 fs/ubifs/budget.c                |    2 +-
 include/linux/backing-dev.h      |   14 +-
 include/linux/sched.h            |    7 +
 include/linux/writeback.h        |   33 ++-
 include/trace/events/writeback.h |  161 +++++++--
 kernel/fork.c                    |    3 +
 mm/backing-dev.c                 |    7 +-
 mm/page-writeback.c              |  704 ++++++++++++++++++++++++++++++--------
 mm/vmscan.c                      |    3 +-
 15 files changed, 806 insertions(+), 225 deletions(-)

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Commit 0e175a1835ffc979e55787774e58ec79e41957d7
from git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJOr4+qAAoJECvKgwp+S8JafoYP/39roT/zsKkrm1wi0wb22x/P
8EcRZAzZLCk/sxu0Hdzqvs2rcf5kqHrWOXX4r+9KI5IvrI1NiTdhvNdn68ui5RT8
iRXC3F+3pIBDIjToEfYlgDuzjucD86mHowIIKIylc7KzC6hJS9EUy39+xFET5moY
gfvKsSVWtkVb61sci9rvKl/n416PLnKTBzdMZSiQEKf6mh3/kXrSxv/mUvdzeo2n
pHA+P3h7pSvXRDsrVo+SA+8e0jwuZc+UoHVCgYaVrRVffP8TNvw4WEyRQHBo0fu7
S3dUtXqMNGAyYvtZ2wIPTJ6TOLaDIm+AcsllywozjGK+mFMUTeXH5XbFvYiMnnJj
N8YHTTZwlpjUfEdVihgSEFMTYBRt4QfaShHiJ+oFo/98uU4INzJyQZ5hqWsvDmcy
cuZrXZoyJY5dG+HHUspS93jFjD5XuArcbDDckKnwkWcejSgHd/vX8fFoTm5C/xyy
NQjPSZrRui/za/2CWkmkHu1OA+WWhSqoRWm5LxXA00IWSmFaMaUL8+XHnPGb2vQq
aCpH42zm7bVvWD9NqXIfmlNysuhgKTparFFald1MwmE20wCIEvZ5wqm1NcGI9LbI
1S6Mus6s/lBEtrzLh1YRbW2PzA57wlVfRjRz3+v0R1hlrT64r8Jr4fV+3Vbi4b+W
WVxc0Qpw9HVuOJ+uFjhs
=W8+G
-----END PGP SIGNATURE-----
