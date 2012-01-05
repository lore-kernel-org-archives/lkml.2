Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab2AEMTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:19:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756650Ab2AEMQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:16:16 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/16] GFS2: Fix very unlikley memory leak in ACL xattr code
Date: Thu,  5 Jan 2012 11:51:50 +0000
Message-Id: <1325764322-10807-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
References: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was spotted by automated code analysis. In case reading
an ACL xattr failed (only likely to happen if there is an I/O
error for example, and even then only with unstuffed xattrs,
so pretty difficult to trigger) a small amount of memory could
potentially be leaked.

This patch adds a kfree to the error path, and also removes a
test which is no longer required (gfs2_ea_get_copy always
returns either a negative error, or a length)

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index 71d7bf8..a201a1d 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -549,9 +549,10 @@ int gfs2_xattr_acl_get(struct gfs2_inode *ip, const char *name, char **ppdata)
 		goto out;
 
 	error = gfs2_ea_get_copy(ip, &el, data, len);
-	if (error == 0)
-		error = len;
-	*ppdata = data;
+	if (error < 0)
+		kfree(data);
+	else
+		*ppdata = data;
 out:
 	brelse(el.el_bh);
 	return error;
-- 
1.7.4

