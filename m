Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab2DMOTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 10:19:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:60837 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab2DMOTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 10:19:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="88726484"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v2 v2 0/4] do not use s_dirt in FAT FS
Date: Fri, 13 Apr 2012 17:19:51 +0300
Message-Id: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 2 of the patch-set which makes FAT file-system stop using
the VFS '->write_super()' method for writing out the FSINFO block. The fist
version can be found here: http://lkml.org/lkml/2012/4/11/147

Comparing to v1, this patch takes a completely different approach. Instead of
using a delayed job, we introduce a special inode for the FSINFO block, mark
it as dirty when needed, and use generic inode write-back mechanisms to write
the FSINFO block via '->write_inode()'. I think this is much cleaner.

Let me recap why I am doing this, and the current status of this exercises.

The final goal is to get rid of the 'sync_supers()' kernel thread. This kernel
thread wakes up every 5 seconds (by default) and calls '->write_super()' for
all mounted file-systems. And the bad thing is that this is done even if all
the superblocks are clean. Moreover, some file-systems do not even need this
end they do not register the '->write_super()' method at all (e.g., btrfs).

So 'sync_supers()' most often just generates useless wake-ups and wastes power.
I am trying to make all file-systems independent of '->write_super()' and plan
to remove 'sync_supers()' and '->write_super' completely once there are no more
users.

The '->write_supers()' method is mostly used by baroque file-systems like hfs,
udf, etc. Modern file-systems like btrfs and xfs do not use it. This justifies
removing this stuff from VFS completely and make every FS self-manage own
superblock.

Tested with xfstests.

Note: in the past I was trying to upstream patches which optimized 'sync_super()',
but Al Viro wanted me to kill it completely instead, which I am trying to do
now, see http://lkml.org/lkml/2010/7/22/96

======
Overall status:

1. ext4: patches submitted, waiting for reply from Ted Ts'o:
   https://lkml.org/lkml/2012/4/2/111
2. ext2: patches are in the ext2 tree maintained by Jan Kara:
   git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_next
   However, one patch is still not there:
   http://www.spinics.net/lists/linux-ext4/msg31492.html

TODO: affs, exofs, hfs, hfsplus, jffs2, reiserfs, sysv, udf, ufs
======

 fs/fat/fat.h             |    1 +
 fs/fat/fatent.c          |   22 +++++++++++++-----
 fs/fat/inode.c           |   54 ++++++++++++++++++++-------------------------
 include/linux/msdos_fs.h |    3 +-
 4 files changed, 43 insertions(+), 37 deletions(-)

Thanks,
Artem.
