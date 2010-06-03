Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab0FCQK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:10:59 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:34225 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab0FCQI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:08:56 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de, hooanon05@yahoo.co.jp,
       bfields@fieldses.org
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 04/11] vfs: Allow handle based open on symlinks
Date: Thu,  3 Jun 2010 21:38:34 +0530
Message-Id: <1275581321-5861-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.236.g81fa0
In-Reply-To: <1275581321-5861-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1275581321-5861-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch update may_open to allow handle based open on symlinks.
The file handle based API use file descritor returned from open_by_handle_at
to do different file system operations. To find the link target name we
need to get a file descriptor on symlinks.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c2d19c7..417bf53 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1422,7 +1422,7 @@ int vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 	return error;
 }
 
-int may_open(struct path *path, int acc_mode, int flag)
+static int __may_open(struct path *path, int acc_mode, int flag, int handle)
 {
 	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
@@ -1433,7 +1433,13 @@ int may_open(struct path *path, int acc_mode, int flag)
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFLNK:
-		return -ELOOP;
+		/*
+		 * For file handle based open we should allow
+		 * open of symlink.
+		 */
+		if (!handle)
+			return -ELOOP;
+		break;
 	case S_IFDIR:
 		if (acc_mode & MAY_WRITE)
 			return -EISDIR;
@@ -1473,6 +1479,11 @@ int may_open(struct path *path, int acc_mode, int flag)
 	return break_lease(inode, flag);
 }
 
+int may_open(struct path *path, int acc_mode, int flag)
+{
+	return __may_open(path, acc_mode, flag, 0);
+}
+
 static int handle_truncate(struct path *path)
 {
 	struct inode *inode = path->dentry->d_inode;
@@ -1570,7 +1581,7 @@ struct file *finish_open_handle(struct path *path,
 		if (error)
 			goto exit;
 	}
-	error = may_open(path, acc_mode, open_flag);
+	error = __may_open(path, acc_mode, open_flag, 1);
 	if (error) {
 		if (will_truncate)
 			mnt_drop_write(path->mnt);
-- 
1.7.1.236.g81fa0

