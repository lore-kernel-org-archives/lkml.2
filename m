Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193Ab1ESJPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:15:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933032Ab1ESJKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:23 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 15/32] GFS2: make sure fallocate bytes is a multiple of blksize
Date: Thu, 19 May 2011 09:47:10 +0100
Message-Id: <1305794847-3291-16-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

The GFS2 fallocate code chooses a target size to for allocating chunks of
space.  Whenever it can't find any resource groups with enough space free, it
halves its target. Since this target is in bytes, eventually it will no longer
be a multiple of blksize.  As long as there is more space available in the
resource group than the target, this isn't a problem, since gfs2 will use the
actual space available, which is always a multiple of blksize.  However,
when gfs couldn't fallocate a bigger chunk than the target, it was using the
non-blksize aligned number. This caused a BUG in later code that required
blksize aligned offsets.  GFS2 now ensures that bytes is always a multiple of
blksize

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 23eab47..a9f5cbe 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -816,6 +816,7 @@ static long gfs2_fallocate(struct file *file, int mode, loff_t offset,
 	loff_t bytes, max_bytes;
 	struct gfs2_alloc *al;
 	int error;
+	loff_t bsize_mask = ~((loff_t)sdp->sd_sb.sb_bsize - 1);
 	loff_t next = (offset + len - 1) >> sdp->sd_sb.sb_bsize_shift;
 	next = (next + 1) << sdp->sd_sb.sb_bsize_shift;
 
@@ -823,13 +824,15 @@ static long gfs2_fallocate(struct file *file, int mode, loff_t offset,
 	if (mode & ~FALLOC_FL_KEEP_SIZE)
 		return -EOPNOTSUPP;
 
-	offset = (offset >> sdp->sd_sb.sb_bsize_shift) <<
-		 sdp->sd_sb.sb_bsize_shift;
+	offset &= bsize_mask;
 
 	len = next - offset;
 	bytes = sdp->sd_max_rg_data * sdp->sd_sb.sb_bsize / 2;
 	if (!bytes)
 		bytes = UINT_MAX;
+	bytes &= bsize_mask;
+	if (bytes == 0)
+		bytes = sdp->sd_sb.sb_bsize;
 
 	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &ip->i_gh);
 	error = gfs2_glock_nq(&ip->i_gh);
@@ -860,6 +863,9 @@ retry:
 		if (error) {
 			if (error == -ENOSPC && bytes > sdp->sd_sb.sb_bsize) {
 				bytes >>= 1;
+				bytes &= bsize_mask;
+				if (bytes == 0)
+					bytes = sdp->sd_sb.sb_bsize;
 				goto retry;
 			}
 			goto out_qunlock;
-- 
1.7.4

