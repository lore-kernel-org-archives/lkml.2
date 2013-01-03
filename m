Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab3ACMQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:16:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab3ACMQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:16:40 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/4] GFS2: Reset rd_last_alloc when it reaches the end of the rgrp
Date: Thu,  3 Jan 2013 11:50:10 +0000
Message-Id: <1357213810-3739-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1357213810-3739-1-git-send-email-swhiteho@redhat.com>
References: <1357213810-3739-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

In function rg_mblk_search, it's searching for multiple blocks in
a given state (e.g. "free"). If there's an active block reservation
its goal is the next free block of that. If the resource group
contains the dinode's goal block, that's used for the search. But
if neither is the case, it uses the rgrp's last allocated block.
That way, consecutive allocations appear after one another on media.
The problem comes in when you hit the end of the rgrp; it would never
start over and search from the beginning. This became a problem,
since if you deleted all the files and data from the rgrp, it would
never start over and find free blocks. So it had to keep searching
further out on the media to allocate blocks. This patch resets the
rd_last_alloc after it does an unsuccessful search at the end of
the rgrp.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 712dd4f..b7eff07 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1426,6 +1426,9 @@ static void rg_mblk_search(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip,
 		rs->rs_free = extlen;
 		rs->rs_inum = ip->i_no_addr;
 		rs_insert(ip);
+	} else {
+		if (goal == rgd->rd_last_alloc + rgd->rd_data0)
+			rgd->rd_last_alloc = 0;
 	}
 }
 
-- 
1.7.4

