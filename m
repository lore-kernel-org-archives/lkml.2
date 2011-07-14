Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab1GNIok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 04:44:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab1GNIoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 04:44:38 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/3] GFS2: force a log flush when invalidating the rindex glock
Date: Thu, 14 Jul 2011 09:21:54 +0100
Message-Id: <1310631716-18700-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1310631716-18700-1-git-send-email-swhiteho@redhat.com>
References: <1310631716-18700-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

Right now, there is nothing that forces the log to get flushed when a node
drops its rindex glock so that another node can grow the filesystem. If the
log doesn't get flushed, GFS2 can corrupt the sd_log_le_rg list in the
following way.

A node puts an rgd on the list in rg_lo_add(), and then the rindex glock is
dropped so the other node can grow the filesystem. When the node reacquires the
rindex glock, that rgd gets deleted in clear_rgrpdi() before ever being
removed from the list by gfs2_log_flush().

This code simply forces a log flush when the rindex glock is invalidated,
solving the problem.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 8ef70f4..712b722 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -221,8 +221,10 @@ static void inode_go_inval(struct gfs2_glock *gl, int flags)
 		}
 	}
 
-	if (ip == GFS2_I(gl->gl_sbd->sd_rindex))
+	if (ip == GFS2_I(gl->gl_sbd->sd_rindex)) {
+		gfs2_log_flush(gl->gl_sbd, NULL);
 		gl->gl_sbd->sd_rindex_uptodate = 0;
+	}
 	if (ip && S_ISREG(ip->i_inode.i_mode))
 		truncate_inode_pages(ip->i_inode.i_mapping, 0);
 }
-- 
1.7.4

