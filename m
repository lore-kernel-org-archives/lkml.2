Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab2AEMQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:16:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756717Ab2AEMQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:16:18 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>
Subject: [PATCH 05/16] GFS2: f_ra is always valid in dir readahead function
Date: Thu,  5 Jan 2012 11:51:51 +0000
Message-Id: <1325764322-10807-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
References: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a result, we don't need to test it each time.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 9144117..946b6f8 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1378,12 +1378,14 @@ out:
 	return error;
 }
 
-/* gfs2_dir_readahead - Issue read-ahead requests for leaf blocks.
+/**
+ * gfs2_dir_readahead - Issue read-ahead requests for leaf blocks.
  *
  * Note: we can't calculate each index like dir_e_read can because we don't
  * have the leaf, and therefore we don't have the depth, and therefore we
  * don't have the length. So we have to just read enough ahead to make up
- * for the loss of information. */
+ * for the loss of information.
+ */
 static void gfs2_dir_readahead(struct inode *inode, unsigned hsize, u32 index,
 			       struct file_ra_state *f_ra)
 {
@@ -1394,7 +1396,7 @@ static void gfs2_dir_readahead(struct inode *inode, unsigned hsize, u32 index,
 	unsigned count;
 
 	/* First check if we've already read-ahead for the whole range. */
-	if (!f_ra || index + MAX_RA_BLOCKS < f_ra->start)
+	if (index + MAX_RA_BLOCKS < f_ra->start)
 		return;
 
 	f_ra->start = max((pgoff_t)index, f_ra->start);
@@ -1448,7 +1450,7 @@ static int dir_e_read(struct inode *inode, u64 *offset, void *opaque,
 	hash = gfs2_dir_offset2hash(*offset);
 	index = hash >> (32 - dip->i_depth);
 
-	if (f_ra && dip->i_hash_cache == NULL)
+	if (dip->i_hash_cache == NULL)
 		f_ra->start = 0;
 	lp = gfs2_dir_get_hash_table(dip);
 	if (IS_ERR(lp))
-- 
1.7.4

