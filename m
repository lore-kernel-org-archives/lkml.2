Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab0GZDzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 23:55:15 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:56131 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753353Ab0GZDzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 23:55:12 -0400
Date: Mon, 26 Jul 2010 13:54:42 +1000
From: Dave Chinner <david@fromorbit.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: xfs-masters@oss.sgi.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-next: build failure after merge of the xfs tree
Message-ID: <20100726035442.GD7362@dastard>
References: <20100726115107.3c3b7303.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726115107.3c3b7303.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 11:51:07AM +1000, Stephen Rothwell wrote:
> Hi David,
> 
> After merging the xfs tree, today's linux-next build (powerpc ppc64_defconfig)
> failed like this:
> 
> fs/xfs/xfs_inode_item.c: In function 'xfs_inode_item_format':
> fs/xfs/xfs_inode_item.c:319: error: 'nrecs' undeclared (first use in this function)
> 
> Caused by commit 0fd7275cc42ab734eaa1a2c747e65479bd1e42af ("xfs: fix gcc
> 4.6 set but not read and unused statement warnings").

Can you check the following patch fixes the problem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: fix big endian build

From: Dave Chinner <dchinner@redhat.com>

Commit 0fd7275cc42ab734eaa1a2c747e65479bd1e42af ("xfs: fix gcc 4.6
set but not read and unused statement warnings") failed to convert
some code inside XFS_NATIVE_HOST (big endian host code only) and
hence fails to build on such machines. Fix it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode_item.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 2d6fcfd..016b60d 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -316,7 +316,8 @@ xfs_inode_item_format(
 			ASSERT((ip->i_df.if_bytes /
 				(uint)sizeof(xfs_bmbt_rec_t)) > 0);
 #ifdef XFS_NATIVE_HOST
-			if (nrecs == ip->i_d.di_nextents) {
+			if (ip->i_d.di_nextents == ip->i_df.if_bytes /
+						(uint)sizeof(xfs_bmbt_rec_t)) {
 				/*
 				 * There are no delayed allocation
 				 * extents, so just point to the

