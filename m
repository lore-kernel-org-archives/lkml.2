Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab2K3KWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:22:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932347Ab2K3KSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:18:33 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/16] GFS2: Fix one RG corner case
Date: Fri, 30 Nov 2012 09:52:15 +0000
Message-Id: <1354269141-3311-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
References: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For filesystems with only a single resource group, we need to be careful
that the allocation loop will not land up with a NULL resource group. This
fixes a bug in a previous patch where the gfs2_rgrpd_get_next() function
was being used instead of gfs2_rgrpd_get_first()

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 99a6197..5625e93 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1776,10 +1776,11 @@ static u32 gfs2_orlov_skip(const struct gfs2_inode *ip)
 static bool gfs2_select_rgrp(struct gfs2_rgrpd **pos, const struct gfs2_rgrpd *begin)
 {
 	struct gfs2_rgrpd *rgd = *pos;
+	struct gfs2_sbd *sdp = rgd->rd_sbd;
 
 	rgd = gfs2_rgrpd_get_next(rgd);
 	if (rgd == NULL)
-		rgd = gfs2_rgrpd_get_next(NULL);
+		rgd = gfs2_rgrpd_get_first(sdp);
 	*pos = rgd;
 	if (rgd != begin) /* If we didn't wrap */
 		return true;
-- 
1.7.4

