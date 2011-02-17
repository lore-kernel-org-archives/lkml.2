Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab1BQSFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:05:15 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:48333 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757456Ab1BQSCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:02:23 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 03/14] fs/9p: Add drop_inode 9p callback
Date: Thu, 17 Feb 2011 23:31:54 +0530
Message-Id: <1297965725-25603-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to immediately drop the inode in non cached mode

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_super.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index cfb8e97..0dc9e4b 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -293,6 +293,20 @@ static int v9fs_sync_fs(struct super_block *sb, int wait)
 	return p9_client_sync_fs(v9ses->root_fid);
 }
 
+int v9fs_drop_inode(struct inode *inode)
+{
+	struct v9fs_session_info *v9ses;
+	v9ses = v9fs_inode2v9ses(inode);
+	if (v9ses->cache)
+		return !inode->i_nlink || inode_unhashed(inode);
+	/*
+	 * in case of non cached mode always drop the
+	 * the inode because we want the inode attribute
+	 * to always match that on the server.
+	 */
+	return 1;
+}
+
 static const struct super_operations v9fs_super_ops = {
 	.alloc_inode = v9fs_alloc_inode,
 	.destroy_inode = v9fs_destroy_inode,
@@ -307,6 +321,7 @@ static const struct super_operations v9fs_super_ops_dotl = {
 	.destroy_inode = v9fs_destroy_inode,
 	.sync_fs = v9fs_sync_fs,
 	.statfs = v9fs_statfs,
+	.drop_inode = v9fs_drop_inode,
 	.evict_inode = v9fs_evict_inode,
 	.show_options = generic_show_options,
 	.umount_begin = v9fs_umount_begin,
-- 
1.7.1

