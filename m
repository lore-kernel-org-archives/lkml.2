Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab1BQSEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:04:55 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:53036 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477Ab1BQSC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:02:26 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 05/14] fs/9p: Update link count correctly during rename
Date: Thu, 17 Feb 2011 23:31:56 +0530
Message-Id: <1297965725-25603-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index ae4fd90..8a895bb 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -829,6 +829,7 @@ v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		struct inode *new_dir, struct dentry *new_dentry)
 {
 	struct inode *old_inode;
+	struct inode *new_inode;
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *oldfid;
 	struct p9_fid *olddirfid;
@@ -839,6 +840,7 @@ v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	P9_DPRINTK(P9_DEBUG_VFS, "\n");
 	retval = 0;
 	old_inode = old_dentry->d_inode;
+	new_inode = new_dentry->d_inode;
 	v9ses = v9fs_inode2v9ses(old_inode);
 	oldfid = v9fs_fid_lookup(old_dentry);
 	if (IS_ERR(oldfid))
@@ -879,9 +881,21 @@ v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	retval = p9_client_wstat(oldfid, &wstat);
 
 clunk_newdir:
-	if (!retval)
+	if (!retval) {
+		if (new_inode) {
+			if (S_ISDIR(new_inode->i_mode))
+				clear_nlink(new_inode);
+			else
+				drop_nlink(new_inode);
+		}
+		if (S_ISDIR(old_inode->i_mode)) {
+			if (!new_inode)
+				inc_nlink(new_dir);
+			drop_nlink(old_dir);
+		}
 		/* successful rename */
 		d_move(old_dentry, new_dentry);
+	}
 	up_write(&v9ses->rename_sem);
 	p9_client_clunk(newdirfid);
 
-- 
1.7.1

