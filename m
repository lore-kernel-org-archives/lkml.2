Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab1COJfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:35:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756364Ab1COJeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:34:17 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/15] GFS2: Optimize glock multiple-dequeue code
Date: Tue, 15 Mar 2011 09:11:40 +0000
Message-Id: <1300180305-5993-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
References: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This is a small patch that optimizes multiple glock dequeue
operations.  It changes the unlock order to be more efficient
and makes it easier for lock debugging tools to unravel.  It
also eliminates the need for the temp variable x, although
that would likely be optimized out.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 3f45a14..8648409 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1248,10 +1248,8 @@ int gfs2_glock_nq_m(unsigned int num_gh, struct gfs2_holder *ghs)
 
 void gfs2_glock_dq_m(unsigned int num_gh, struct gfs2_holder *ghs)
 {
-	unsigned int x;
-
-	for (x = 0; x < num_gh; x++)
-		gfs2_glock_dq(&ghs[x]);
+	while (num_gh--)
+		gfs2_glock_dq(&ghs[num_gh]);
 }
 
 /**
@@ -1263,10 +1261,8 @@ void gfs2_glock_dq_m(unsigned int num_gh, struct gfs2_holder *ghs)
 
 void gfs2_glock_dq_uninit_m(unsigned int num_gh, struct gfs2_holder *ghs)
 {
-	unsigned int x;
-
-	for (x = 0; x < num_gh; x++)
-		gfs2_glock_dq_uninit(&ghs[x]);
+	while (num_gh--)
+		gfs2_glock_dq_uninit(&ghs[num_gh]);
 }
 
 void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state)
-- 
1.7.4

