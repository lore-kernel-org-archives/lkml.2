Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab0LQMrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:47:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349Ab0LQMqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:46:25 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>
Subject: [PATCH 14/15] GFS2: fsck.gfs2 reported statfs error after gfs2_grow
Date: Fri, 17 Dec 2010 12:24:20 +0000
Message-Id: <1292588661-14350-15-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
References: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

When you do gfs2_grow it failed to take the very last
rgrp into account when adding up the new free space due
to an off-by-one error.  It was not reading the last
rgrp from the rindex because of a check for "<=" that
should have been "<".  Therefore, fsck.gfs2 was finding
(and fixing) an error with the system statfs file.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 25dbe5c..7293ea2 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -500,7 +500,7 @@ u64 gfs2_ri_total(struct gfs2_sbd *sdp)
 	for (rgrps = 0;; rgrps++) {
 		loff_t pos = rgrps * sizeof(struct gfs2_rindex);
 
-		if (pos + sizeof(struct gfs2_rindex) >= i_size_read(inode))
+		if (pos + sizeof(struct gfs2_rindex) > i_size_read(inode))
 			break;
 		error = gfs2_internal_read(ip, &ra_state, buf, &pos,
 					   sizeof(struct gfs2_rindex));
-- 
1.7.3.3

