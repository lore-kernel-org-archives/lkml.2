Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab2IMKII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:08:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544Ab2IMKIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:08:07 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/3] GFS2: Fix missing allocation data for set/remove xattr
Date: Thu, 13 Sep 2012 10:42:28 +0100
Message-Id: <1347529349-6704-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1347529349-6704-1-git-send-email-swhiteho@redhat.com>
References: <1347529349-6704-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These entry points were missed in the original patch to allocate
this data structure.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 4ce22e5..753af3d 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1722,7 +1722,9 @@ static int gfs2_setxattr(struct dentry *dentry, const char *name,
 	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
 	ret = gfs2_glock_nq(&gh);
 	if (ret == 0) {
-		ret = generic_setxattr(dentry, name, data, size, flags);
+		ret = gfs2_rs_alloc(ip);
+		if (ret == 0)
+			ret = generic_setxattr(dentry, name, data, size, flags);
 		gfs2_glock_dq(&gh);
 	}
 	gfs2_holder_uninit(&gh);
@@ -1757,7 +1759,9 @@ static int gfs2_removexattr(struct dentry *dentry, const char *name)
 	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
 	ret = gfs2_glock_nq(&gh);
 	if (ret == 0) {
-		ret = generic_removexattr(dentry, name);
+		ret = gfs2_rs_alloc(ip);
+		if (ret == 0)
+			ret = generic_removexattr(dentry, name);
 		gfs2_glock_dq(&gh);
 	}
 	gfs2_holder_uninit(&gh);
-- 
1.7.4

