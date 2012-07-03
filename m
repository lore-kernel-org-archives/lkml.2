Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab2GCL6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 07:58:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:20967 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab2GCL6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 07:58:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="166276650"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Ext4 Mailing List <linux-ext4@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>
Subject: [PATCHv3 0/4] ext4: stop using write_supers and s_dirt
Date: Tue,  3 Jul 2012 15:00:06 +0300
Message-Id: <1341316810-22598-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set makes ext4 file-system stop using the VFS '->write_supers()'
call-back and the '->s_dirt' superblock field because I plan to remove them
once all users are gone.

Like the other similar patch-sets, we switch to a delayed job for writing out
the superblock instead of using the 's_dirt' flag. Additionally, this patch-set
includes several clean-ups.

Tested with xfstests. And thanks to Jan Kara for the help!

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

======
Overall status:

1.  ext4: patches submitted,
    https://lkml.org/lkml/2012/4/2/111
2.  exofs: patch submitted,
    https://lkml.org/lkml/2012/6/4/211
3.  udf: patch submitted, sits in Jan Kara's tree:
    https://lkml.org/lkml/2012/6/4/233
    git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs for_testing
4.  affs: patches submitted, sit in Al Viro's tree:
    https://lkml.org/lkml/2012/6/6/400
    git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs for-next
5.  hfs: patches submitted, sit Andrew Morton's tree
    http://lkml.org/lkml/2012/6/12/82
6.  hfsplus: patches submitted, sit in Andre Morton's tree:
    https://lkml.org/lkml/2012/6/13/195
7.  ext2:     done, see commit f72cf5e223a28d3b3ea7dc9e40464fd534e359e8
8.  vfat:     done, see commit 78491189ddb6d84d4a4abae992ed891a236d0263
9.  jffs2:    done, see commit 208b14e507c00ff7f108e1a388dd3d8cc805a443
10. reiserfs: done, see commit 033369d1af1264abc23bea2e174aa47cdd212f6f

TODO: sysv, ufs
======

 fs/ext4/ext4.h      |   10 +---------
 fs/ext4/ext4_jbd2.c |    2 +-
 fs/ext4/file.c      |   14 +++++++++++++-
 fs/ext4/ialloc.c    |    2 --
 fs/ext4/mballoc.c   |    2 --
 fs/ext4/super.c     |   15 ++-------------
 6 files changed, 17 insertions(+), 28 deletions(-)

Thanks,
Artem.
