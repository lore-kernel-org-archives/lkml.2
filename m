Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab2CSKvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:51:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030389Ab2CSKtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:49:53 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/12] GFS2: make sure rgrps are up to date in func gfs2_blk2rgrpd
Date: Mon, 19 Mar 2012 10:25:24 +0000
Message-Id: <1332152728-4027-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
References: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch adds a call to gfs2_rindex_update from function gfs2_blk2rgrpd
and removes calls to it that are made redundant by it. The problem is
that a gfs2_grow can add rgrps to the rindex, then put those rgrps into
use, thus rendering the rindex we read in at mount time incomplete.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 6ff9f17..19bde40 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -332,6 +332,9 @@ struct gfs2_rgrpd *gfs2_blk2rgrpd(struct gfs2_sbd *sdp, u64 blk, bool exact)
 	struct rb_node *n, *next;
 	struct gfs2_rgrpd *cur;
 
+	if (gfs2_rindex_update(sdp))
+		return NULL;
+
 	spin_lock(&sdp->sd_rindex_spin);
 	n = sdp->sd_rindex_tree.rb_node;
 	while (n) {
@@ -917,10 +920,6 @@ int gfs2_fitrim(struct file *filp, void __user *argp)
 	if (!blk_queue_discard(q))
 		return -EOPNOTSUPP;
 
-	ret = gfs2_rindex_update(sdp);
-	if (ret)
-		return ret;
-
 	if (argp == NULL) {
 		r.start = 0;
 		r.len = ULLONG_MAX;
@@ -1671,13 +1670,8 @@ int gfs2_check_blk_type(struct gfs2_sbd *sdp, u64 no_addr, unsigned int type)
 {
 	struct gfs2_rgrpd *rgd;
 	struct gfs2_holder rgd_gh;
-	int error;
-
-	error = gfs2_rindex_update(sdp);
-	if (error)
-		return error;
+	int error = -EINVAL;
 
-	error = -EINVAL;
 	rgd = gfs2_blk2rgrpd(sdp, no_addr, 1);
 	if (!rgd)
 		goto fail;
-- 
1.7.4

