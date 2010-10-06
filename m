Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab0JFJZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 05:25:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932408Ab0JFJZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 05:25:58 -0400
Subject: Re: gfs2_glops_list duplicate initialiser
From: Steven Whitehouse <swhiteho@redhat.com>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20101006005947.GA2512@gallifrey>
References: <20101006005947.GA2512@gallifrey>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 06 Oct 2010 10:32:00 +0100
Message-ID: <1286357520.2696.2.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for pointing out this issue. I'm not sure how that got missed,
except that this code is used only for a debugging interface and so far
the focus has been on other glock types. Either way we should fix it,
and the following patch should solve the issue,

Steve.



-----------------------------------------------------------------------------
>From 134669854e3a680d8aad9a4047891c653715f4c0 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 6 Oct 2010 09:58:44 +0100
Subject: [PATCH] GFS2: Fix type mapping for demote_rq interface

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



