Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab0LQMrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:47:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab0LQMq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:46:26 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 15/15] GFS2: Don't flush delete workqueue when releasing the transaction lock
Date: Fri, 17 Dec 2010 12:24:21 +0000
Message-Id: <1292588661-14350-16-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
References: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no requirement to flush the delete workqueue before a
gfs2 filesystem is suspended. The workqueue's work will just
be suspended along with the rest of the tasks on the filesystem.

The resolves a deadlock situation where the transaction lock's
demotion code was trying to flush the delete workqueue while at
the same time, the workqueue was waiting for the transaction
lock.

The delete workqueue is flushed by gfs2_make_fs_ro() already, so
that umount/remount are correctly protected anyway.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 0d149dc..263561b 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -325,7 +325,6 @@ static void trans_go_sync(struct gfs2_glock *gl)
 
 	if (gl->gl_state != LM_ST_UNLOCKED &&
 	    test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags)) {
-		flush_workqueue(gfs2_delete_workqueue);
 		gfs2_meta_syncfs(sdp);
 		gfs2_log_shutdown(sdp);
 	}
-- 
1.7.3.3

