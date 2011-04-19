Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab1DSJCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 05:02:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab1DSJCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 05:02:35 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/4] GFS2: write_end error path fails to unlock transaction lock
Date: Tue, 19 Apr 2011 09:40:06 +0100
Message-Id: <1303202409-3317-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1303202409-3317-1-git-send-email-swhiteho@redhat.com>
References: <1303202409-3317-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

I did an audit of gfs2's transaction glock for bugzilla bug
658619 and ran across this:

In function gfs2_write_end, in the unlikely event that
gfs2_meta_inode_buffer returns an error, the code may forget
to unlock the transaction lock because the "failed" label
appears after the call to function gfs2_trans_end.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index c71995b..0f5c4f9 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -884,8 +884,8 @@ static int gfs2_write_end(struct file *file, struct address_space *mapping,
 	}
 
 	brelse(dibh);
-	gfs2_trans_end(sdp);
 failed:
+	gfs2_trans_end(sdp);
 	if (al) {
 		gfs2_inplace_release(ip);
 		gfs2_quota_unlock(ip);
-- 
1.7.4

