Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab0HBJuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:50:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab0HBJtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:49:15 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 6/8] Revert "GFS2: recovery stuck on transaction lock"
Date: Mon,  2 Aug 2010 10:27:57 +0100
Message-Id: <1280741279-6782-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1280741279-6782-1-git-send-email-swhiteho@redhat.com>
References: <1280741279-6782-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit b7dc2df5725fe7355fd76000ead7e39728e1b8a9.

The initial patch didn't quite work since it doesn't cover all
the possible routes by which the GLF_FROZEN flag might be set.
A revised fix is coming up in the next patch.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 717531d..2b3d8f8 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -707,18 +707,8 @@ static void glock_work_func(struct work_struct *work)
 {
 	unsigned long delay = 0;
 	struct gfs2_glock *gl = container_of(work, struct gfs2_glock, gl_work.work);
-	struct gfs2_holder *gh;
 	int drop_ref = 0;
 
-	if (unlikely(test_bit(GLF_FROZEN, &gl->gl_flags))) {
-		spin_lock(&gl->gl_spin);
-		gh = find_first_waiter(gl);
-		if (gh && (gh->gh_flags & LM_FLAG_NOEXP) &&
-		    test_and_clear_bit(GLF_FROZEN, &gl->gl_flags))
-			set_bit(GLF_REPLY_PENDING, &gl->gl_flags);
-		spin_unlock(&gl->gl_spin);
-	}
-
 	if (test_and_clear_bit(GLF_REPLY_PENDING, &gl->gl_flags)) {
 		finish_xmote(gl, gl->gl_reply);
 		drop_ref = 1;
-- 
1.7.1.1

