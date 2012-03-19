Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030537Ab2CSKtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:49:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030291Ab2CSKtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:49:50 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/12] GFS2: Unlock rindex mutex on glock error
Date: Mon, 19 Mar 2012 10:25:22 +0000
Message-Id: <1332152728-4027-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
References: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch fixes an error path in function gfs2_rindex_update
that leaves the rindex mutex held.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 1446b4e..e09370e 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -699,13 +699,14 @@ int gfs2_rindex_update(struct gfs2_sbd *sdp)
 		if (!gfs2_glock_is_locked_by_me(gl)) {
 			error = gfs2_glock_nq_init(gl, LM_ST_SHARED, 0, &ri_gh);
 			if (error)
-				return error;
+				goto out_unlock;
 			unlock_required = 1;
 		}
 		if (!sdp->sd_rindex_uptodate)
 			error = gfs2_ri_update(ip);
 		if (unlock_required)
 			gfs2_glock_dq_uninit(&ri_gh);
+out_unlock:
 		mutex_unlock(&sdp->sd_rindex_mutex);
 	}
 
-- 
1.7.4

