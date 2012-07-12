Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937Ab2GLO1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:27:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:18972 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933910Ab2GLO1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:27:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="167258289"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 0/6] hfs: stop using write_supers and s_dirt
Date: Thu, 12 Jul 2012 17:28:43 +0300
Message-Id: <1342103329-17526-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, and similarly to hfsplus, here is v2 of the hfs patches with the
same kind of changes:

1. checkpatch.pl warnings fixed
2. removed 'cancel_delayed_work()' from 'hfs_mdb_commit()' because it is not
   enough to just cancel the job, we need to set the work_queued flag to zero
   as well. I could do this, but it is simpler to just remove this tiny
   optimization - we do not gain much with it.

This patch-set makes hfs file-system stop using the VFS '->write_supers()'
call-back and the '->s_dirt' superblock field because I plan to remove them
once all users are gone.

Like some other similar patch-sets (affs, hfsplus, ufs, reiserfs), we switch to
a delayed job for writing out the superblock instead of using the 's_dirt'
flag. Additionally, this patch-set includes several clean-ups.

Tested using the fsstress test from the LTP project.

 fs/hfs/extent.c |    2 +-
 fs/hfs/hfs_fs.h |   15 +++++++----
 fs/hfs/inode.c  |   14 +++-------
 fs/hfs/mdb.c    |   13 ++++++++++
 fs/hfs/super.c  |   73 +++++++++++++++++++++++++++----------------------------
 5 files changed, 63 insertions(+), 54 deletions(-)

Reminder
========

The goal is to get rid of the 'sync_supers()' kernel thread. This kernel thread
wakes up every 5 seconds (by default) and calls '->write_super()' for all
mounted file-systems. And the bad thing is that this is done even if all the
superblocks are clean. Moreover, many file-systems do not even need this and
they do not even register the '->write_super()' method at all (e.g., btrfs).

So 'sync_supers()' mostly just generates useless wake-ups and wastes power.
I am trying to make all file-systems independent of '->write_super()' and plan
to remove 'sync_supers()' and '->write_super()' completely once there are no
more users.

Overall status
==============

1.  ext4: patches submitted (v7)
    http://thread.gmane.org/gmane.linux.kernel/1326181/focus=33332
2.  ufs: patches submitted,
    https://lkml.org/lkml/2012/7/12/248
3.  exofs: patch submitted,
    https://lkml.org/lkml/2012/6/4/211
4.  sysv: patches submitted,
    http://lkml.org/lkml/2012/7/3/250
5.  udf: patch sits in Jan Kara's tree:
    https://lkml.org/lkml/2012/6/4/233
    git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs for_testing
6.  affs: patches sit in Al Viro's tree:
    https://lkml.org/lkml/2012/6/6/400
    git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs for-next
7.  hfs: patches sit in Andrew Morton's tree (-mm, visible in linux-next)
8.  hfsplus: patches sit in Andrew Morton's tree (-mm, visible in linux-next)
9.  ext2:     done, see commit f72cf5e223a28d3b3ea7dc9e40464fd534e359e8
10. vfat:     done, see commit 78491189ddb6d84d4a4abae992ed891a236d0263
11. jffs2:    done, see commit 208b14e507c00ff7f108e1a388dd3d8cc805a443
12. reiserfs: done, see commit 033369d1af1264abc23bea2e174aa47cdd212f6f

Thanks,
Artem.
