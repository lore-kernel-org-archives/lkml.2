Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab1JXMr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:47:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932308Ab1JXMry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:54 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 19/24] GFS2: Fix off-by-one in gfs2_blk2rgrpd
Date: Mon, 24 Oct 2011 13:48:33 +0100
Message-Id: <1319460518-9046-20-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob reported:

I found an off-by-one problem with how I coded this section:
It should be:

+ else if (blk >= cur->rd_data0 + cur->rd_data)

In fact, cur->rd_data0 + cur->rd_data is the start of the next
rgrp (the next ri_addr), so without the "=" check it can land on
the wrong rgrp.

In all normal cases, this won't be a problem: you're searching
for a block _within_ the rgrp, which will pass the test properly.
Where it gets into trouble is if you search the rgrps for the
block exactly equal to ri_addr.  I don't think anything in the
kernel does this, but I found a place in gfs2-utils gfs2_edit
where it does.  So I definitely need to fix it in libgfs2.  I'd
like to suggest we fix it in the kernel as well for the sake of
keeping the functions similar.

So this patch fixes the above mentioned off by one error as well
as removing the unused parent pointer.

Reported-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 8ec4174..1daf8a7 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -329,17 +329,16 @@ static inline int rgrp_contains_block(struct gfs2_rgrpd *rgd, u64 block)
 
 struct gfs2_rgrpd *gfs2_blk2rgrpd(struct gfs2_sbd *sdp, u64 blk)
 {
-	struct rb_node **newn, *parent = NULL;
+	struct rb_node **newn;
+	struct gfs2_rgrpd *cur;
 
 	spin_lock(&sdp->sd_rindex_spin);
 	newn = &sdp->sd_rindex_tree.rb_node;
 	while (*newn) {
-		struct gfs2_rgrpd *cur = rb_entry(*newn, struct gfs2_rgrpd,
-						  rd_node);
-		parent = *newn;
+		cur = rb_entry(*newn, struct gfs2_rgrpd, rd_node);
 		if (blk < cur->rd_addr)
 			newn = &((*newn)->rb_left);
-		else if (blk > cur->rd_data0 + cur->rd_data)
+		else if (blk >= cur->rd_data0 + cur->rd_data)
 			newn = &((*newn)->rb_right);
 		else {
 			spin_unlock(&sdp->sd_rindex_spin);
-- 
1.7.4.4

