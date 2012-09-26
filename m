Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab2IZIzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:55:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755144Ab2IZIvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:45 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/27] GFS2: inline __gfs2_glock_schedule_for_reclaim
Date: Wed, 26 Sep 2012 09:25:32 +0100
Message-Id: <1348647948-3219-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Since function gfs2_glock_schedule_for_reclaim is only two
significant lines, we can eliminate it, simplifying the code
and making it more readable.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 1ed81f4..67f3e42 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -186,20 +186,6 @@ static void gfs2_glock_remove_from_lru(struct gfs2_glock *gl)
 }
 
 /**
- * __gfs2_glock_schedule_for_reclaim - Add a glock to the reclaim list
- * @gl: the glock
- *
- * If the glock is demotable, then we add it (or move it) to the end
- * of the glock LRU list.
- */
-
-static void __gfs2_glock_schedule_for_reclaim(struct gfs2_glock *gl)
-{
-	if (demote_ok(gl))
-		gfs2_glock_add_to_lru(gl);
-}
-
-/**
  * gfs2_glock_put_nolock() - Decrement reference count on glock
  * @gl: The glock to put
  *
@@ -1121,8 +1107,9 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 		    !test_bit(GLF_DEMOTE, &gl->gl_flags))
 			fast_path = 1;
 	}
-	if (!test_bit(GLF_LFLUSH, &gl->gl_flags))
-		__gfs2_glock_schedule_for_reclaim(gl);
+	if (!test_bit(GLF_LFLUSH, &gl->gl_flags) && demote_ok(gl))
+		gfs2_glock_add_to_lru(gl);
+
 	trace_gfs2_glock_queue(gh, 0);
 	spin_unlock(&gl->gl_spin);
 	if (likely(fast_path))
-- 
1.7.4

