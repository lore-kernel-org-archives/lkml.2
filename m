Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab2IZIz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:55:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997Ab2IZIvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:48 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 13/27] GFS2: Combine functions gfs2_glock_dq_wait and wait_on_demote
Date: Wed, 26 Sep 2012 09:25:34 +0100
Message-Id: <1348647948-3219-14-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Function gfs2_glock_dq_wait called two-line function wait_on_demote,
so they were combined.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 5c87909..fca6a87 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -890,12 +890,6 @@ int gfs2_glock_wait(struct gfs2_holder *gh)
 	return gh->gh_error;
 }
 
-static void wait_on_demote(struct gfs2_glock *gl)
-{
-	might_sleep();
-	wait_on_bit(&gl->gl_flags, GLF_DEMOTE, gfs2_glock_demote_wait, TASK_UNINTERRUPTIBLE);
-}
-
 /**
  * handle_callback - process a demote request
  * @gl: the glock
@@ -1123,7 +1117,8 @@ void gfs2_glock_dq_wait(struct gfs2_holder *gh)
 {
 	struct gfs2_glock *gl = gh->gh_gl;
 	gfs2_glock_dq(gh);
-	wait_on_demote(gl);
+	might_sleep();
+	wait_on_bit(&gl->gl_flags, GLF_DEMOTE, gfs2_glock_demote_wait, TASK_UNINTERRUPTIBLE);
 }
 
 /**
-- 
1.7.4

