Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965392Ab2B1Lft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 06:35:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965132Ab2B1Lf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 06:35:28 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/4] GFS2: Ensure rindex is uptodate for fallocate
Date: Tue, 28 Feb 2012 11:11:04 +0000
Message-Id: <1330427465-5417-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1330427465-5417-1-git-send-email-swhiteho@redhat.com>
References: <1330427465-5417-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch fixes a problem whereby gfs2_grow was failing and causing GFS2
to assert. The problem was that when GFS2's fallocate operation tried to
acquire an "allocation" it made sure the rindex was up to date, and if not,
it called gfs2_rindex_update. However, if the file being fallocated was
the rindex itself, it was already locked at that point. By calling
gfs2_rindex_update at an earlier point in time, we bring rindex up to date
and thereby avoid trying to lock it when the "allocation" is acquired.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index c5fb359..7f906c8 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -772,6 +772,11 @@ static long gfs2_fallocate(struct file *file, int mode, loff_t offset,
 	if (bytes == 0)
 		bytes = sdp->sd_sb.sb_bsize;
 
+	error = gfs2_rindex_update(sdp);
+	if (error) {
+		fs_warn(sdp, "rindex update returns %d\n", error);
+		return error;
+	}
 	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &ip->i_gh);
 	error = gfs2_glock_nq(&ip->i_gh);
 	if (unlikely(error))
-- 
1.7.4

