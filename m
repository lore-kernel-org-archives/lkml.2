Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab0HBJtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:49:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab0HBJtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:49:15 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: David Rientjes <rientjes@google.com>, Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/8] GFS2: remove dependency on __GFP_NOFAIL
Date: Mon,  2 Aug 2010 10:27:55 +0100
Message-Id: <1280741279-6782-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1280741279-6782-1-git-send-email-swhiteho@redhat.com>
References: <1280741279-6782-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

The k[mc]allocs in dr_split_leaf() and dir_double_exhash() are failable,
so remove __GFP_NOFAIL from their masks.

Cc: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 6b48d7c..b9dd88a 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -955,7 +955,12 @@ static int dir_split_leaf(struct inode *inode, const struct qstr *name)
 	/* Change the pointers.
 	   Don't bother distinguishing stuffed from non-stuffed.
 	   This code is complicated enough already. */
-	lp = kmalloc(half_len * sizeof(__be64), GFP_NOFS | __GFP_NOFAIL);
+	lp = kmalloc(half_len * sizeof(__be64), GFP_NOFS);
+	if (!lp) {
+		error = -ENOMEM;
+		goto fail_brelse;
+	}
+
 	/*  Change the pointers  */
 	for (x = 0; x < half_len; x++)
 		lp[x] = cpu_to_be64(bn);
@@ -1063,7 +1068,9 @@ static int dir_double_exhash(struct gfs2_inode *dip)
 
 	/*  Allocate both the "from" and "to" buffers in one big chunk  */
 
-	buf = kcalloc(3, sdp->sd_hash_bsize, GFP_NOFS | __GFP_NOFAIL);
+	buf = kcalloc(3, sdp->sd_hash_bsize, GFP_NOFS);
+	if (!buf)
+		return -ENOMEM;
 
 	for (block = dip->i_disksize >> sdp->sd_hash_bsize_shift; block--;) {
 		error = gfs2_dir_read_data(dip, (char *)buf,
-- 
1.7.1.1

