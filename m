Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761817Ab2EQMsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:48:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761752Ab2EQMsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:38 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/24] GFS2: Use variable rather than qa to determine if unstuff necessary
Date: Thu, 17 May 2012 13:23:16 +0100
Message-Id: <1337257411-3173-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

In the future, the qadata structure will be eliminated and merged
back in with the block reservation structure, after we extend the
lifespan of that. This patch is a step forward in eliminating the
qadata structure. It adds a variable to the do_grow function to
determine when unstuffing is necessary, and has been done.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 03c04fe..420bbeb 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1169,6 +1169,7 @@ static int do_grow(struct inode *inode, u64 size)
 	struct buffer_head *dibh;
 	struct gfs2_qadata *qa = NULL;
 	int error;
+	int unstuff = 0;
 
 	if (gfs2_is_stuffed(ip) &&
 	    (size > (sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode)))) {
@@ -1183,13 +1184,14 @@ static int do_grow(struct inode *inode, u64 size)
 		error = gfs2_inplace_reserve(ip, 1);
 		if (error)
 			goto do_grow_qunlock;
+		unstuff = 1;
 	}
 
 	error = gfs2_trans_begin(sdp, RES_DINODE + RES_STATFS + RES_RG_BIT, 0);
 	if (error)
 		goto do_grow_release;
 
-	if (qa) {
+	if (unstuff) {
 		error = gfs2_unstuff_dinode(ip, NULL);
 		if (error)
 			goto do_end_trans;
@@ -1208,7 +1210,7 @@ static int do_grow(struct inode *inode, u64 size)
 do_end_trans:
 	gfs2_trans_end(sdp);
 do_grow_release:
-	if (qa) {
+	if (unstuff) {
 		gfs2_inplace_release(ip);
 do_grow_qunlock:
 		gfs2_quota_unlock(ip);
-- 
1.7.4

