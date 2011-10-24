Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab1JXMsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:48:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932386Ab1JXMr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:59 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 23/24] GFS2: Remove two unused variables
Date: Mon, 24 Oct 2011 13:48:37 +0100
Message-Id: <1319460518-9046-24-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two variables being initialised in gfs2_inplace_reserve
to track the file & line number of the caller are never
used, so we might as well remove them.

If something does go wrong, then a stack trace is probably
more useful anyway.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 6429aa4..7389dfd 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -246,7 +246,6 @@ struct gfs2_glock {
 
 struct gfs2_alloc {
 	/* Quota stuff */
-
 	struct gfs2_quota_data *al_qd[2*MAXQUOTAS];
 	struct gfs2_holder al_qd_ghs[2*MAXQUOTAS];
 	unsigned int al_qd_num;
@@ -255,9 +254,6 @@ struct gfs2_alloc {
 	u32 al_alloced; /* Filled in by gfs2_alloc_*() */
 
 	/* Filled in by gfs2_inplace_reserve() */
-
-	unsigned int al_line;
-	char *al_file;
 	struct gfs2_holder al_rgd_gh;
 };
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 1daf8a7..96bd6d7 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1024,14 +1024,13 @@ static int get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 }
 
 /**
- * gfs2_inplace_reserve_i - Reserve space in the filesystem
+ * gfs2_inplace_reserve - Reserve space in the filesystem
  * @ip: the inode to reserve space for
  *
  * Returns: errno
  */
 
-int gfs2_inplace_reserve_i(struct gfs2_inode *ip,
-			   char *file, unsigned int line)
+int gfs2_inplace_reserve(struct gfs2_inode *ip)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_alloc *al = ip->i_alloc;
@@ -1057,14 +1056,7 @@ int gfs2_inplace_reserve_i(struct gfs2_inode *ip,
 		gfs2_log_flush(sdp, NULL);
 	} while (tries++ < 3);
 
-	if (error)
-		return error;
-
-	/* no error, so we have the rgrp set in the inode's allocation. */
-	al->al_file = file;
-	al->al_line = line;
-
-	return 0;
+	return error;
 }
 
 /**
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index 0e886d8..cf5c501 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -36,11 +36,7 @@ static inline void gfs2_alloc_put(struct gfs2_inode *ip)
 	ip->i_alloc = NULL;
 }
 
-extern int gfs2_inplace_reserve_i(struct gfs2_inode *ip,
-				  char *file, unsigned int line);
-#define gfs2_inplace_reserve(ip) \
-	gfs2_inplace_reserve_i((ip),  __FILE__, __LINE__)
-
+extern int gfs2_inplace_reserve(struct gfs2_inode *ip);
 extern void gfs2_inplace_release(struct gfs2_inode *ip);
 
 extern int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n);
-- 
1.7.4.4

