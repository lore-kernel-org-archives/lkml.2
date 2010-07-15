Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332Ab0GOOTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 10:19:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933317Ab0GOOTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 10:19:00 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/5] GFS2: O_TRUNC not working on stuffed files across cluster
Date: Thu, 15 Jul 2010 14:57:50 +0100
Message-Id: <1279202274-4418-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1279202274-4418-1-git-send-email-swhiteho@redhat.com>
References: <1279202274-4418-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch replaces a statement that got dropped out by accident.
Without the patch, truncates on stuffed (very small) files cause
those files to have an unpredictable size.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 4a48c0f..84da64b 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1041,6 +1041,7 @@ static int trunc_start(struct gfs2_inode *ip, u64 size)
 
 	if (gfs2_is_stuffed(ip)) {
 		u64 dsize = size + sizeof(struct gfs2_inode);
+		ip->i_disksize = size;
 		ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
 		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 		gfs2_dinode_out(ip, dibh->b_data);
-- 
1.7.1.1

