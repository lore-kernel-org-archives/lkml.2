Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183Ab1ESJNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:13:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933089Ab1ESJK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:29 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 19/32] GFS2: Don't use a try lock when promoting to a higher mode
Date: Thu, 19 May 2011 09:47:14 +0100
Message-Id: <1305794847-3291-20-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we marked all locks being promoted to a higher mode
with the try flag to avoid any potential deadlocks issues. The
DLM is able to detect these and report them in way that GFS2 can
deal with them correctly. So we can just request the required mode
and wait for a response without needing to perform this check.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index eed4b68..ee2178d 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -543,11 +543,6 @@ __acquires(&gl->gl_spin)
 	clear_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags);
 
 	gfs2_glock_hold(gl);
-	if (target != LM_ST_UNLOCKED && (gl->gl_state == LM_ST_SHARED ||
-	    gl->gl_state == LM_ST_DEFERRED) &&
-	    !(lck_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)))
-		lck_flags |= LM_FLAG_TRY_1CB;
-
 	if (sdp->sd_lockstruct.ls_ops->lm_lock)	{
 		/* lock_dlm */
 		ret = sdp->sd_lockstruct.ls_ops->lm_lock(gl, target, lck_flags);
-- 
1.7.4

