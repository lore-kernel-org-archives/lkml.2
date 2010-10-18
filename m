Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab0JROiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:38:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932530Ab0JROh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:59 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 21/22] GFS2: Fix type mapping for demote_rq interface
Date: Mon, 18 Oct 2010 15:15:45 +0100
Message-Id: <1287411346-17855-22-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly the glock operations follow the type of the glock. The
one exception is the transaction glock, so we need to check for
that directly.

Reported-by: Dr. David Alan Gilbert <linux@treblig.org>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 621d80e..0d149dc 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -452,7 +452,6 @@ const struct gfs2_glock_operations *gfs2_glops_list[] = {
 	[LM_TYPE_META] = &gfs2_meta_glops,
 	[LM_TYPE_INODE] = &gfs2_inode_glops,
 	[LM_TYPE_RGRP] = &gfs2_rgrp_glops,
-	[LM_TYPE_NONDISK] = &gfs2_trans_glops,
 	[LM_TYPE_IOPEN] = &gfs2_iopen_glops,
 	[LM_TYPE_FLOCK] = &gfs2_flock_glops,
 	[LM_TYPE_NONDISK] = &gfs2_nondisk_glops,
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 64082a5..748ccb5 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -230,7 +230,10 @@ static ssize_t demote_rq_store(struct gfs2_sbd *sdp, const char *buf, size_t len
 
 	if (gltype > LM_TYPE_JOURNAL)
 		return -EINVAL;
-	glops = gfs2_glops_list[gltype];
+	if (gltype == LM_TYPE_NONDISK && glnum == GFS2_TRANS_LOCK)
+		glops = &gfs2_trans_glops;
+	else
+		glops = gfs2_glops_list[gltype];
 	if (glops == NULL)
 		return -EINVAL;
 	if (!test_and_set_bit(SDF_DEMOTE, &sdp->sd_flags))
-- 
1.7.1.1

