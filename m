Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab1CVLXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:23:41 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:23824 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754471Ab1CVLXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 07:23:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApUGAK8jiE15LK5JgWdsb2JhbACERZN/jH8VAQEWJiWyVZE/gSeBWIFudwQ
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: vfs: inode lock breakup
Date: Tue, 22 Mar 2011 22:23:35 +1100
Message-Id: <1300793023-3775-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

The following patches are the inode_lock breakup series originally
derived from Nick Piggin's vfs-scale tree. I've kind of been sitting
on them until the dcache_lock breakup and rcu path-walk has had some
time to be shaken out. The patch ѕet is pretty much unchanged from
the last round of review last last year - all I've done to bring it
up to date is forward port it and run it through some testing on XFS
and ext4.

I know it's late in the .39 merge window, but I hope you'll consider
it if the patches are still acceptable(*). Otherwise I'm happy to take
the time to get it right for .40.

Cheers,

Dave.

(*) The series can also be found here:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git inode-scale

Dave Chinner (8):
      fs: protect inode->i_state with inode->i_lock
      fs: factor inode disposal
      fs: Lock the inode LRU list separately
      fs: remove inode_lock from iput_final and prune_icache
      fs: move i_sb_list out from under inode_lock
      fs: move i_wb_list out from under inode_lock
      fs: rename inode_lock to inode_hash_lock
      fs: pull inode->i_lock up out of writeback_single_inode

 Documentation/filesystems/Locking |    2 +-
 Documentation/filesystems/porting |   16 +-
 Documentation/filesystems/vfs.txt |    2 +-
 fs/block_dev.c                    |    6 +-
 fs/buffer.c                       |    2 +-
 fs/drop_caches.c                  |   18 +-
 fs/fs-writeback.c                 |  141 ++++++++-----
 fs/inode.c                        |  416 +++++++++++++++++++++----------------
 fs/internal.h                     |    7 +
 fs/logfs/inode.c                  |    2 +-
 fs/notify/inode_mark.c            |   42 +++--
 fs/notify/mark.c                  |    1 -
 fs/notify/vfsmount_mark.c         |    1 -
 fs/ntfs/inode.c                   |    4 +-
 fs/quota/dquot.c                  |   41 ++--
 include/linux/fs.h                |    2 +-
 include/linux/quotaops.h          |    2 +-
 include/linux/writeback.h         |    2 +-
 mm/backing-dev.c                  |    8 +-
 mm/filemap.c                      |   10 +-
 mm/rmap.c                         |    5 +-
 21 files changed, 434 insertions(+), 296 deletions(-)

