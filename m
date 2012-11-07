Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab2KGKl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:41:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab2KGKl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:41:57 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Andrew Price <anprice@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/7] GFS2: Fix an unchecked error from gfs2_rs_alloc
Date: Wed,  7 Nov 2012 10:15:53 +0000
Message-Id: <1352283359-3314-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1352283359-3314-1-git-send-email-swhiteho@redhat.com>
References: <1352283359-3314-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Price <anprice@redhat.com>

Check the return value of gfs2_rs_alloc(ip) and avoid a possible null
pointer dereference.

Signed-off-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 40c4b0d..c5af8e1 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -497,8 +497,11 @@ int gfs2_quota_hold(struct gfs2_inode *ip, u32 uid, u32 gid)
 	struct gfs2_quota_data **qd;
 	int error;
 
-	if (ip->i_res == NULL)
-		gfs2_rs_alloc(ip);
+	if (ip->i_res == NULL) {
+		error = gfs2_rs_alloc(ip);
+		if (error)
+			return error;
+	}
 
 	qd = ip->i_res->rs_qa_qd;
 
-- 
1.7.4

