Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab2HXLwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 07:52:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45063 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab2HXLvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 07:51:54 -0400
From: yan <clouds.yan@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] fs/namei.c: only check mountpoint on non-negative dentry
Date: Fri, 24 Aug 2012 19:51:37 +0800
Message-Id: <1345809097-854-2-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345809097-854-1-git-send-email-clouds.yan@gmail.com>
References: <n>
 <1345809097-854-1-git-send-email-clouds.yan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: yan <clouds.yan@gmail.com>
---
 fs/namei.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index dd1ed1b..028f5c8 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3628,11 +3628,15 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
 		return error;
 
 	dget(new_dentry);
-	if (target)
-		mutex_lock(&target->i_mutex);
 
 	error = -EBUSY;
-	if (d_mountpoint(old_dentry) || d_mountpoint(new_dentry))
+	if (target){
+		mutex_lock(&target->i_mutex);
+		if (d_mountpoint(new_dentry))
+			goto out;
+	}
+
+	if (d_mountpoint(old_dentry))
 		goto out;
 
 	error = -EMLINK;
@@ -3671,11 +3675,15 @@ static int vfs_rename_other(struct inode *old_dir, struct dentry *old_dentry,
 		return error;
 
 	dget(new_dentry);
-	if (target)
-		mutex_lock(&target->i_mutex);
 
 	error = -EBUSY;
-	if (d_mountpoint(old_dentry)||d_mountpoint(new_dentry))
+	if (target){
+		mutex_lock(&target->i_mutex);
+		if (d_mountpoint(new_dentry))
+			goto out;
+	}
+
+	if (d_mountpoint(old_dentry))
 		goto out;
 
 	error = old_dir->i_op->rename(old_dir, old_dentry, new_dir, new_dentry);
-- 
1.7.9.5

