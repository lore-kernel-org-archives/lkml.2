Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab1COJeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:34:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297Ab1COJeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:34:14 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/15] GFS2: Remove potential race in flock code
Date: Tue, 15 Mar 2011 09:11:39 +0000
Message-Id: <1300180305-5993-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
References: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch ensures that we always wait for glock demotion when
dropping flocks on a file in order to prevent any race
conditions associated with further flock calls or closing
the file.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 216ad27..2878481 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -981,8 +981,10 @@ static void do_unflock(struct file *file, struct file_lock *fl)
 
 	mutex_lock(&fp->f_fl_mutex);
 	flock_lock_file_wait(file, fl);
-	if (fl_gh->gh_gl)
-		gfs2_glock_dq_uninit(fl_gh);
+	if (fl_gh->gh_gl) {
+		gfs2_glock_dq_wait(fl_gh);
+		gfs2_holder_uninit(fl_gh);
+	}
 	mutex_unlock(&fp->f_fl_mutex);
 }
 
-- 
1.7.4

