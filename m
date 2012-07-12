Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449Ab2GLN0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 09:26:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:27661 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757416Ab2GLN03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 09:26:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="170963742"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Evgeniy Dushistov <dushistov@mail.ru>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] fs/ufs: stop using write_supers and s_dirt
Date: Thu, 12 Jul 2012 16:28:05 +0300
Message-Id: <1342099688-14894-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set makes UFS file-system stop using the VFS '->write_supers()'
call-back and the '->s_dirt' superblock field because I plan to remove them
once all users are gone.

Like some other similar patch-sets (affs, hfs, hfsplus, reiserfs), we switch to
a delayed job for writing out the superblock instead of using the 's_dirt'
flag. Additionally, this patch-set includes several clean-ups.

Note, checkpatch.pl complains about these patches, but the complaints are about
the code which is already in UFS, not my code. We really need to fix
checkpatch.pl to be smarter.

Tested using the fsstress test from the LTP project.

 fs/ufs/balloc.c |    8 ++--
 fs/ufs/ialloc.c |    4 +-
 fs/ufs/super.c  |  148 ++++++++++++++++++++++++++++++------------------------
 fs/ufs/ufs.h    |    5 ++
 fs/ufs/ufs_fs.h |    1 +
 5 files changed, 94 insertions(+), 72 deletions(-)

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

1.  ext4: patches submitted,
    https://lkml.org/lkml/2012/7/10/195
2.  ufs: these patches
3.  exofs: patch submitted,
    https://lkml.org/lkml/2012/6/4/211
4.  sysv: patches submitted,
    http://lkml.org/lkml/2012/7/3/250
5.  udf: patch submitted, sits in Jan Kara's tree:
    https://lkml.org/lkml/2012/6/4/233
    git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs for_testing
6.  affs: patches submitted, sit in Al Viro's tree:
    https://lkml.org/lkml/2012/6/6/400
    git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs for-next
7.  hfs: patches submitted, sit Andrew Morton's tree
    http://lkml.org/lkml/2012/6/12/82
8.  hfsplus: patches submitted, sit in Andrew Morton's tree:
    https://lkml.org/lkml/2012/6/13/195
9.  ext2:     done, see commit f72cf5e223a28d3b3ea7dc9e40464fd534e359e8
10. vfat:     done, see commit 78491189ddb6d84d4a4abae992ed891a236d0263
11. jffs2:    done, see commit 208b14e507c00ff7f108e1a388dd3d8cc805a443
12. reiserfs: done, see commit 033369d1af1264abc23bea2e174aa47cdd212f6f

Thanks,
Artem.
