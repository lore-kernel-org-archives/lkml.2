Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab2AKNVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 08:21:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864Ab2AKNVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 08:21:24 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/5] GFS2: Fix a use-after-free that coverity spotted
Date: Wed, 11 Jan 2012 12:57:25 +0000
Message-Id: <1326286648-5515-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1326286648-5515-1-git-send-email-swhiteho@redhat.com>
References: <1326286648-5515-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

In function gfs2_inplace_release it was trying to unlock a gfs2_holder
structure associated with a reservation, after said reservation was
freed. The problem is that the statements have the wrong order.
This patch corrects the order so that the reservation is freed after
the gfs2_holder is unlocked.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 2223462..981bfa3 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1108,9 +1108,9 @@ void gfs2_inplace_release(struct gfs2_inode *ip)
 {
 	struct gfs2_blkreserv *rs = ip->i_res;
 
-	gfs2_blkrsv_put(ip);
 	if (rs->rs_rgd_gh.gh_gl)
 		gfs2_glock_dq_uninit(&rs->rs_rgd_gh);
+	gfs2_blkrsv_put(ip);
 }
 
 /**
-- 
1.7.4

