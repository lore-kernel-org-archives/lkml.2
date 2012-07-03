Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab2GCNmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 09:42:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:39618 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756114Ab2GCNmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:42:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="166324209"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 0/3] fs/sysv: stop using write_supers and s_dirt
Date: Tue,  3 Jul 2012 16:43:25 +0300
Message-Id: <1341323008-29414-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set makes sysv file-system stop using the VFS '->write_supers()'
call-back and the '->s_dirt' superblock field because I plan to remove them
once all users are gone.

Compile-tested only. If someone can give me a sysv image I could loop-mount
and test my changes - I'd appreciate. I could not find any tool to create this
ancient file-system. But I think my changes should not break it.

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
    https://lkml.org/lkml/2012/7/3/210
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

TODO: ufs
======

 fs/sysv/inode.c |   18 +-----------------
 fs/sysv/sysv.h  |    1 -
 2 files changed, 1 insertions(+), 18 deletions(-)

Thanks,
Artem.
