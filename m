Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348Ab0GOOTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 10:19:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933326Ab0GOOTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 10:19:04 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>, Steve Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/5] GFS2: recovery stuck on transaction lock
Date: Thu, 15 Jul 2010 14:57:51 +0100
Message-Id: <1279202274-4418-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1279202274-4418-1-git-send-email-swhiteho@redhat.com>
References: <1279202274-4418-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch fixes bugzilla bug #590878: GFS2: recovery stuck on
transaction lock.  We set the frozen flag on the glock when we receive
a completion that cannot be delivered due to blocked locks. At that
point we check to see whether the first waiting holder has the noexp
flag set. If the noexp lock is queued later, then we need to unfreeze
the glock at that point in time, namely, in the glock work function.

This patch was originally written by Steve Whitehouse, but since
he's on holiday, I'm submitting it.  It's been well tested with a
complex recovery test called revolver.

Signed-off-by: Steve Whitehouse <swhiteho@redhat.com>
Signed-off-by: Bob Peterson <rpeterso@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index ddcdbf4..dbab3fd 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -706,8 +706,18 @@ static void glock_work_func(struct work_struct *work)
 {
 	unsigned long delay = 0;
 	struct gfs2_glock *gl = container_of(work, struct gfs2_glock, gl_work.work);
+	struct gfs2_holder *gh;
 	int drop_ref = 0;
 
+	if (unlikely(test_bit(GLF_FROZEN, &gl->gl_flags))) {
+		spin_lock(&gl->gl_spin);
+		gh = find_first_waiter(gl);
+		if (gh && (gh->gh_flags & LM_FLAG_NOEXP) &&
+		    test_and_clear_bit(GLF_FROZEN, &gl->gl_flags))
+			set_bit(GLF_REPLY_PENDING, &gl->gl_flags);
+		spin_unlock(&gl->gl_spin);
+	}
+
 	if (test_and_clear_bit(GLF_REPLY_PENDING, &gl->gl_flags)) {
 		finish_xmote(gl, gl->gl_reply);
 		drop_ref = 1;
-- 
1.7.1.1

