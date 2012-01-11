Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab2AKNWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 08:22:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757513Ab2AKNV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 08:21:29 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 5/5] GFS2: Fix nlink setting on inode creation
Date: Wed, 11 Jan 2012 12:57:28 +0000
Message-Id: <1326286648-5515-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1326286648-5515-1-git-send-email-swhiteho@redhat.com>
References: <1326286648-5515-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the nlink count will be 0, we need to use set_nlink rather
than inc_nlink in order to avoid triggering the inc_nlink warning
which was added recently.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 017960c..a7d611b 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -599,9 +599,7 @@ static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
 	error = gfs2_meta_inode_buffer(ip, &dibh);
 	if (error)
 		goto fail_end_trans;
-	inc_nlink(&ip->i_inode);
-	if (S_ISDIR(ip->i_inode.i_mode))
-		inc_nlink(&ip->i_inode);
+	set_nlink(&ip->i_inode, S_ISDIR(ip->i_inode.i_mode) ? 2 : 1);
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 	gfs2_dinode_out(ip, dibh->b_data);
 	brelse(dibh);
-- 
1.7.4

