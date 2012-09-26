Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab2IZIy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:54:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241Ab2IZIvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:49 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 14/27] GFS2: Eliminate redundant calls to may_grant
Date: Wed, 26 Sep 2012 09:25:35 +0100
Message-Id: <1348647948-3219-15-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Function add_to_queue was checking may_grant for the passed-in
holder for every iteration of its gh2 loop. Now it only checks it
once at the beginning to see if a try lock is futile.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index fca6a87..e6c2fd5 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -954,7 +954,7 @@ __acquires(&gl->gl_spin)
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	struct list_head *insert_pt = NULL;
 	struct gfs2_holder *gh2;
-	int try_lock = 0;
+	int try_futile = 0;
 
 	BUG_ON(gh->gh_owner_pid == NULL);
 	if (test_and_set_bit(HIF_WAIT, &gh->gh_iflags))
@@ -962,7 +962,7 @@ __acquires(&gl->gl_spin)
 
 	if (gh->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)) {
 		if (test_bit(GLF_LOCK, &gl->gl_flags))
-			try_lock = 1;
+			try_futile = !may_grant(gl, gh);
 		if (test_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags))
 			goto fail;
 	}
@@ -971,9 +971,8 @@ __acquires(&gl->gl_spin)
 		if (unlikely(gh2->gh_owner_pid == gh->gh_owner_pid &&
 		    (gh->gh_gl->gl_ops->go_type != LM_TYPE_FLOCK)))
 			goto trap_recursive;
-		if (try_lock &&
-		    !(gh2->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)) &&
-		    !may_grant(gl, gh)) {
+		if (try_futile &&
+		    !(gh2->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB))) {
 fail:
 			gh->gh_error = GLR_TRYFAILED;
 			gfs2_holder_wake(gh);
-- 
1.7.4

