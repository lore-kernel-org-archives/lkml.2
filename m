Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab2DKJVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:21:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756019Ab2DKJVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:21:32 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/4] GFS2: Allow caching of rindex glock
Date: Wed, 11 Apr 2012 09:56:54 +0100
Message-Id: <1334134614-19805-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1334134614-19805-1-git-send-email-swhiteho@redhat.com>
References: <1334134614-19805-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch allows caching of the rindex glock. We were previously
setting the GL_NOCACHE bit when the glock was released. That forced
the rindex inode to be invalidated, which caused us to re-read
rindex at the next access. However, it caused the glock to be
unnecessarily bounced around the cluster. This patch allows
the glock to remain cached, but it still causes the rindex to be
re-read once it has been written to by gfs2_grow.

Ben and I have tested single-node gfs2_grow cases and I've tested
clustered gfs2_grow cases on my four-node cluster.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 38b7a74..9b2ff0e 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -807,7 +807,7 @@ static int gfs2_stuffed_write_end(struct inode *inode, struct buffer_head *dibh,
 
 	if (inode == sdp->sd_rindex) {
 		adjust_fs_space(inode);
-		ip->i_gh.gh_flags |= GL_NOCACHE;
+		sdp->sd_rindex_uptodate = 0;
 	}
 
 	brelse(dibh);
@@ -873,7 +873,7 @@ static int gfs2_write_end(struct file *file, struct address_space *mapping,
 
 	if (inode == sdp->sd_rindex) {
 		adjust_fs_space(inode);
-		ip->i_gh.gh_flags |= GL_NOCACHE;
+		sdp->sd_rindex_uptodate = 0;
 	}
 
 	brelse(dibh);
-- 
1.7.4

