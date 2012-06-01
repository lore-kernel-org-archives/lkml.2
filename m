Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262Ab2FAOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:16:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:39264 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932595Ab2FAOQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:16:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="147036859"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        reiserfs-devel@vger.kernel.org
Subject: [PATCH 0/5] reiserfs: stop using write_supers and s_dirt
Date: Fri,  1 Jun 2012 17:18:03 +0300
Message-Id: <1338560288-10727-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set makes reiserfs file-system stop using the VFS '->write_supers()'
call-back and the '->s_dirt' superblock field because I plan to remove them
once all users are gone.

This patch-set makes reiserfs submit a delayed job for writing out old commits
instead of using 's_dirt'.

The goal is to get rid of the 'sync_supers()' kernel thread. This kernel thread
wakes up every 5 seconds (by default) and calls '->write_super()' for all
mounted file-systems. And the bad thing is that this is done even if all the
superblocks are clean. Moreover, many file-systems do not even need this end
they do not register the '->write_super()' method at all (e.g., btrfs).

So 'sync_supers()' most often just generates useless wake-ups and wastes power.
I am trying to make all file-systems independent of '->write_super()' and plan
to remove 'sync_supers()' and '->write_super()' completely once there are no
more users.

The '->write_supers()' method is mostly used by baroque file-systems like hfs,
udf, etc. Modern file-systems like btrfs and xfs do not use it. This justifies
removing this stuff from VFS completely and make every FS self-manage own
superblock.

Al, in the past I was trying to upstream patches which optimized 'sync_super()',
but you wanted me to kill it completely instead, which I am trying to do
now, see http://lkml.org/lkml/2010/7/22/96

Tested using xfstests.

======
Overall status:

1. ext4: patches submitted, waiting for reply from Ted Ts'o:
   https://lkml.org/lkml/2012/4/2/111
   Ted keeps silence so far WRT the fate of this patch-set.
2. ext2:  done, see commit f72cf5e223a28d3b3ea7dc9e40464fd534e359e8
3. vfat:  done, see commit 78491189ddb6d84d4a4abae992ed891a236d0263
4. jffs2: sits the mtd subsystem tree, see commit
          208b14e507c00ff7f108e1a388dd3d8cc805a443 in
	  git://git.infradead.org/linux-mtd.git

TODO: affs, exofs, hfs, hfsplus, sysv, udf, ufs
======

Thanks,
Artem.
