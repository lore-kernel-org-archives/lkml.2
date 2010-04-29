Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab0D3Qs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:48:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57481 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932442Ab0D3Qre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:47:34 -0400
Date: Thu, 29 Apr 2010 13:52:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Monakhov <dmonakhov@openvz.org>, Jiro SEKIBA <jir@unicus.jp>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20100429135211.3ef89aa3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

After merging the block tree, today's linux-next build (powerpc ppc64_defconfig)
failed like this:

fs/nilfs2/the_nilfs.c: In function 'nilfs_discard_segments':
fs/nilfs2/the_nilfs.c:673: error: 'DISCARD_FL_BARRIER' undeclared (first use in this function)

Caused by commit fbd9b09a177a481eda256447c881f014f29034fe ("blkdev:
generalize flags for blkdev_issue_fn functions") interacting with commit
e902ec9906e844f4613fa6190c6fa65f162dc86e ("nilfs2: issue discard request
after cleaning segments") (which netered Linus' tree on about March 4 -
before v2.6.34-rc1).

I applied the following patch for today (but have no way to test it).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 29 Apr 2010 13:35:14 +1000
Subject: [PATCH] nilfs: fix for block layer API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/nilfs2/the_nilfs.c |    4 +-
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 33871f7..7081588 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -670,7 +670,7 @@ int nilfs_discard_segments(struct the_nilfs *nilfs, __u64 *segnump,
 						   start * sects_per_block,
 						   nblocks * sects_per_block,
 						   GFP_NOFS,
-						   DISCARD_FL_BARRIER);
+						   BLKDEV_IFL_BARRIER);
 			if (ret < 0)
 				return ret;
 			nblocks = 0;
@@ -680,7 +680,7 @@ int nilfs_discard_segments(struct the_nilfs *nilfs, __u64 *segnump,
 		ret = blkdev_issue_discard(nilfs->ns_bdev,
 					   start * sects_per_block,
 					   nblocks * sects_per_block,
-					   GFP_NOFS, DISCARD_FL_BARRIER);
+					   GFP_NOFS, BLKDEV_IFL_BARRIER);
 	return ret;
 }
 
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
