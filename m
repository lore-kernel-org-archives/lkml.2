Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab0D2BV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 21:21:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37938 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab0D2BVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 21:21:55 -0400
Date: Thu, 29 Apr 2010 11:21:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sripathi Kodi <sripathik@in.ibm.com>, Tejun Heo <tj@kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: linux-next: manual merge of the v9fs tree with Linus' tree
Message-Id: <20100429112153.6fe79961.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Today's linux-next merge of the v9fs tree got a conflict in
fs/9p/vfs_super.c between commits 5a0e3ad6af8660be21ca98a971cd00f331318c05
("include cleanup: Update gfp.h and slab.h includes to prepare for
breaking implicit slab.h inclusion from percpu.h") and
0ed07ddb56d1348e5ce33f3b8de20d730351983a ("9p: add bdi backing to mount
session") from Linus' tree and commits
0b2d973241f9bdbc8ed62caec42543e00ae6bd1e ("9p: VFS switches for 9p2000.L:
VFS switches") and a61a60e387303575629706279b3b0018e96a758a ("9p: add
9P2000.L statfs operation") from the v9fs tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/9p/vfs_super.c
index 806da5d,af2a620..0000000
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@@ -37,7 -37,7 +37,8 @@@
  #include <linux/mount.h>
  #include <linux/idr.h>
  #include <linux/sched.h>
 +#include <linux/slab.h>
+ #include <linux/statfs.h>
  #include <net/9p/9p.h>
  #include <net/9p/client.h>
  
@@@ -76,8 -76,10 +77,11 @@@ v9fs_fill_super(struct super_block *sb
  	sb->s_blocksize_bits = fls(v9ses->maxdata - 1);
  	sb->s_blocksize = 1 << sb->s_blocksize_bits;
  	sb->s_magic = V9FS_MAGIC;
- 	sb->s_op = &v9fs_super_ops;
+ 	if (v9fs_proto_dotl(v9ses))
+ 		sb->s_op = &v9fs_super_ops_dotl;
+ 	else
+ 		sb->s_op = &v9fs_super_ops;
 +	sb->s_bdi = &v9ses->bdi;
  
  	sb->s_flags = flags | MS_ACTIVE | MS_SYNCHRONOUS | MS_DIRSYNC |
  	    MS_NOATIME;
