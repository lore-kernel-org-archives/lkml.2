Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab2DKLoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:44:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:58363 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab2DKLob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:44:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="87782465"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v1 0/3] do not use s_dirt in FAT FS
Date: Wed, 11 Apr 2012 14:45:04 +0300
Message-Id: <1334144707-9729-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FAT file-system uses the VFS '->write_super()' method for writing out
the FSINFO block, which contains useful but not critical information like
the amount of free clusters.

This patch-set makes FAT FS use its own mechanisms for writing-out the FSINFO
block and stop using the '->write_super()' VFS method. Namely, the FAT FS now
submits a delayed work for writing out the FSINFO block once it becomes dirty.

The reason of this exercises is to get rid of the 'sync_supers()' kernel thread.
This kernel thread wakes up every 5 (by default) and calls '->write_super()'
for all mounted file-systems. And the bad thing is that this is done even if
all the superblocks are clean. Moreover, some file-systems do not even need this
end they do not register the '->write_super()' method at all (e.g., btrfs).

So 'sync_supers()' most often just generates useless wake-ups and wastes
power. I am trying to make all file-systems independent of '->write_super()'
and plan to remove 'sync_supers()' and '->write_super' completely once there
are no more users.

Tested with xfstests.

Note: in the past I was trying to upstream patches which optimized 'sync_super()',
but Al Viro wanted me to kill it completely instead, which I am trying to do now.

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

Thanks,
Artem.
