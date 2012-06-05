Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761898Ab2FEL1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:27:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:1606 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab2FEL1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:27:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="151777536"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] affs: stop using write_supers and s_dirt
Date: Tue,  5 Jun 2012 14:28:08 +0300
Message-Id: <1338895695-10362-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set makes AFFS file-system stop using the VFS '->write_supers()'
call-back and the '->s_dirt' superblock field because I plan to remove them
once all users are gone.

Like the other similar patch-sets, we switch to a delayed job for writing out
the superblock instead of using the 's_dirt' flag. Additionally, this patch-set
includes many clean-ups.

Reminder:

The goal is to get rid of the 'sync_supers()' kernel thread. This kernel thread
wakes up every 5 seconds (by default) and calls '->write_super()' for all
mounted file-systems. And the bad thing is that this is done even if all the
superblocks are clean. Moreover, many file-systems do not even need this end
they do not register the '->write_super()' method at all (e.g., btrfs).

So 'sync_supers()' most often just generates useless wake-ups and wastes power.
I am trying to make all file-systems independent of '->write_super()' and plan
to remove 'sync_supers()' and '->write_super()' completely once there are no
more users.

Al, in the past I was trying to upstream patches which optimized 'sync_super()',
but you wanted me to kill it completely instead, which I am trying to do
now, see http://lkml.org/lkml/2010/7/22/96

Tested using the fsstress test from the LTP project. AFFS has some issues
without my patches - I see it reporting about corrupted inodes. These patch-set
does not introduce new regressions. I did not try to resolve the AFFS problems
which are already there.

======
Overall status:

1. ext4: patches submitted, waiting for review from Ted Ts'o:
   https://lkml.org/lkml/2012/4/2/111
2. udf: patch submitted, should be in Jan Kara's tree:
   https://lkml.org/lkml/2012/6/4/233
3  exofs: patch submitted,
   https://lkml.org/lkml/2012/6/4/211
4. ext2:     done, see commit f72cf5e223a28d3b3ea7dc9e40464fd534e359e8
5. vfat:     done, see commit 78491189ddb6d84d4a4abae992ed891a236d0263
6. jffs2:    done, see commit 208b14e507c00ff7f108e1a388dd3d8cc805a443
7. reiserfs: done, see commit 033369d1af1264abc23bea2e174aa47cdd212f6f

TODO: hfs, hfsplus, sysv, ufs
======

 fs/affs/affs.h   |    8 ++++++
 fs/affs/bitmap.c |    4 +-
 fs/affs/super.c  |   69 +++++++++++++++++++++++++++++++++++------------------
 3 files changed, 55 insertions(+), 26 deletions(-)

Thanks,
Artem.
