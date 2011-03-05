Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab1CERvA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:51:00 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:48082 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab1CERul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:50:41 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/4] fs/9p: Attach writeback_fid on first open with WR flag
Date: Sat,  5 Mar 2011 23:20:24 +0530
Message-Id: <1299347425-16810-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299347425-16810-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1299347425-16810-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need writeback fid if we are only doing O_RDONLY open

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_file.c       |    3 ++-
 fs/9p/vfs_inode.c      |    3 ++-
 fs/9p/vfs_inode_dotl.c |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 3337d58..6997eb6 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -91,7 +91,8 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 
 	file->private_data = fid;
 	mutex_lock(&v9inode->v_mutex);
-	if (v9ses->cache && !v9inode->writeback_fid) {
+	if (v9ses->cache && !v9inode->writeback_fid &&
+	    ((file->f_flags & O_ACCMODE) != O_RDONLY)) {
 		/*
 		 * clone a fid and add it to writeback_fid
 		 * we do it during open time instead of
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 0afbbb4..774a20a 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -652,7 +652,8 @@ v9fs_vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 	if (nd && nd->flags & LOOKUP_OPEN) {
 		v9inode = V9FS_I(dentry->d_inode);
 		mutex_lock(&v9inode->v_mutex);
-		if (v9ses->cache && !v9inode->writeback_fid) {
+		if (v9ses->cache && !v9inode->writeback_fid &&
+		    ((flags & O_ACCMODE) != O_RDONLY)) {
 			/*
 			 * clone a fid and add it to writeback_fid
 			 * we do it during open time instead of
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 0a0ac30..8b616dc 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -246,7 +246,8 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 
 	v9inode = V9FS_I(inode);
 	mutex_lock(&v9inode->v_mutex);
-	if (v9ses->cache && !v9inode->writeback_fid) {
+	if (v9ses->cache && !v9inode->writeback_fid &&
+	    ((flags & O_ACCMODE) != O_RDONLY)) {
 		/*
 		 * clone a fid and add it to writeback_fid
 		 * we do it during open time instead of
-- 
1.7.1

