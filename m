Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab1BQSCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:02:32 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:45784 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465Ab1BQSCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:02:24 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 04/14] fs/9p: Drop the directory link count correctly
Date: Thu, 17 Feb 2011 23:31:55 +0530
Message-Id: <1297965725-25603-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On unlink we should clear the director link count

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index b36711b..ae4fd90 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -509,8 +509,17 @@ static int v9fs_remove(struct inode *dir, struct dentry *file, int rmdir)
 		return PTR_ERR(v9fid);
 
 	retval = p9_client_remove(v9fid);
-	if (!retval)
-		drop_nlink(file_inode);
+	if (!retval) {
+		/*
+		 * directories on unlink should have zero
+		 * link count
+		 */
+		if (rmdir) {
+			clear_nlink(file_inode);
+			drop_nlink(dir);
+		} else
+			drop_nlink(file_inode);
+	}
 	return retval;
 }
 
-- 
1.7.1

