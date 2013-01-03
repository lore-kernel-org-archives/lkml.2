Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab3ACMQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:16:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab3ACMQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:16:37 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Abhijith Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/4] GFS2: Fix race in gfs2_rs_alloc
Date: Thu,  3 Jan 2013 11:50:08 +0000
Message-Id: <1357213810-3739-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1357213810-3739-1-git-send-email-swhiteho@redhat.com>
References: <1357213810-3739-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

QE aio tests uncovered a race condition in gfs2_rs_alloc where it's possible
to come out of the function with a valid ip->i_res allocation but it gets
freed before use resulting in a NULL ptr dereference.

This patch envelopes the initial short-circuit check for non-NULL ip->i_res
into the mutex lock. With this patch, I was able to successfully run the
reproducer test multiple times.

Resolves: rhbz#878476
Signed-off-by: Abhi Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 37ee061..738b388 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -557,22 +557,20 @@ void gfs2_free_clones(struct gfs2_rgrpd *rgd)
  */
 int gfs2_rs_alloc(struct gfs2_inode *ip)
 {
-	struct gfs2_blkreserv *res;
+	int error = 0;
 
+	down_write(&ip->i_rw_mutex);
 	if (ip->i_res)
-		return 0;
-
-	res = kmem_cache_zalloc(gfs2_rsrv_cachep, GFP_NOFS);
-	if (!res)
-		return -ENOMEM;
+		goto out;
 
-	RB_CLEAR_NODE(&res->rs_node);
+	ip->i_res = kmem_cache_zalloc(gfs2_rsrv_cachep, GFP_NOFS);
+	if (!ip->i_res) {
+		error = -ENOMEM;
+		goto out;
+	}
 
-	down_write(&ip->i_rw_mutex);
-	if (ip->i_res)
-		kmem_cache_free(gfs2_rsrv_cachep, res);
-	else
-		ip->i_res = res;
+	RB_CLEAR_NODE(&ip->i_res->rs_node);
+out:
 	up_write(&ip->i_rw_mutex);
 	return 0;
 }
-- 
1.7.4

