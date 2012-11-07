Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab2KGKmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:42:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab2KGKl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:41:59 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Andrew Price <anprice@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/7] GFS2: Fix possible null pointer deref in gfs2_rs_alloc
Date: Wed,  7 Nov 2012 10:15:54 +0000
Message-Id: <1352283359-3314-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1352283359-3314-1-git-send-email-swhiteho@redhat.com>
References: <1352283359-3314-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Price <anprice@redhat.com>

Despite the return value from kmem_cache_zalloc() being checked, the
error wasn't being returned until after a possible null pointer
dereference. This patch returns the error immediately, allowing the
removal of the error variable.

Signed-off-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 3cc402c..43d1a20 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -553,7 +553,6 @@ void gfs2_free_clones(struct gfs2_rgrpd *rgd)
  */
 int gfs2_rs_alloc(struct gfs2_inode *ip)
 {
-	int error = 0;
 	struct gfs2_blkreserv *res;
 
 	if (ip->i_res)
@@ -561,7 +560,7 @@ int gfs2_rs_alloc(struct gfs2_inode *ip)
 
 	res = kmem_cache_zalloc(gfs2_rsrv_cachep, GFP_NOFS);
 	if (!res)
-		error = -ENOMEM;
+		return -ENOMEM;
 
 	RB_CLEAR_NODE(&res->rs_node);
 
@@ -571,7 +570,7 @@ int gfs2_rs_alloc(struct gfs2_inode *ip)
 	else
 		ip->i_res = res;
 	up_write(&ip->i_rw_mutex);
-	return error;
+	return 0;
 }
 
 static void dump_rs(struct seq_file *seq, const struct gfs2_blkreserv *rs)
-- 
1.7.4

