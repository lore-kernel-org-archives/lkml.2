Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805Ab2EDPWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 11:22:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:15107 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab2EDPWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 11:22:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="138930561"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v3 0/4] do not use s_dirt in FAT FS
Date: Fri,  4 May 2012 18:23:34 +0300
Message-Id: <1336145018-23319-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 3 of the patch-set which makes FAT file-system stop using
the VFS '->write_super()' method for writing out the FSINFO block.

Fist version:   https://lkml.org/lkml/2012/4/11/147
Second version: https://lkml.org/lkml/2012/4/13/215

Comparing to v2 - not much changes except that I fixed patch 3 and now only
mark the fsinfo inode as dirty when there were some changes, as Hirofumi
requested. I think it is OK to attach FSINFO to an inode, unlike Hirofumi
would say, so this part is unchanged.

Hirofumi, if you insist there is an issue, could you please again provide more
details and we'd start the conversation over? I think my patches do not change
ordering and even if they were, I do not see what would be the problem.

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
   Ted keeps silence so far WRT the fate of this patch
2. ext2: patches are in the ext2 tree maintained by Jan Kara:
   git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_next
3. FAT FS patches discussion is ongoin on lkml and fsdevel

TODO: affs, exofs, hfs, hfsplus, jffs2, reiserfs, sysv, udf, ufs
======

 fs/fat/fat.h             |    1 +
 fs/fat/fatent.c          |   22 +++++++++++++-----
 fs/fat/inode.c           |   54 ++++++++++++++++++++-------------------------
 include/linux/msdos_fs.h |    3 +-
 4 files changed, 43 insertions(+), 37 deletions(-)

Thanks,
Artem.
