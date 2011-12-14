Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab1LNWaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 17:30:17 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:23748 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758204Ab1LNWaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 17:30:15 -0500
From: Maxim Uvarov <maxim.uvarov@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Maxim Uvarov <maxim.uvarov@oracle.com>
Subject: [PATCH] NFS/INOTIFY: inotify user when deleting files on nfs
Date: Wed, 14 Dec 2011 14:27:47 -0800
Message-Id: <1323901667-3746-1-git-send-email-maxim.uvarov@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4EE92376.01AA,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue was introduced with LTP inotify02 test.
If file system is not NFS user inotify application
gets IN_DELETE event. But on NFS code avoids d_delete()
which sends this event. This patch makes notification
on NFS the same as non-NFS. I.e. vfs_unlink still avoids
deletion but it sends event for NFS sillyrenamed files.
More details here:
https://lkml.org/lkml/2011/11/29/421

Signed-off-by: Maxim Uvarov <maxim.uvarov@oracle.com>
---
 fs/namei.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a9a7166..44a997e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2737,10 +2737,23 @@ int vfs_unlink(struct inode *dir, struct dentry *dentry)
 	}
 	mutex_unlock(&dentry->d_inode->i_mutex);
 
-	/* We don't d_delete() NFS sillyrenamed files--they still exist. */
-	if (!error && !(dentry->d_flags & DCACHE_NFSFS_RENAMED)) {
+
+	if (!error) {
 		fsnotify_link_count(dentry->d_inode);
-		d_delete(dentry);
+		if (!(dentry->d_flags & DCACHE_NFSFS_RENAMED))
+			d_delete(dentry);
+		else {
+			/* We don't d_delete() NFS sillyrenamed files - they
+			 * still exist. But from user side this file was
+			 * deleted. So that we need to generate notify event
+			 * about it.
+			 */
+			struct inode *inode;
+			int isdir;
+			inode = dentry->d_inode;
+			isdir = S_ISDIR(inode->i_mode);
+			fsnotify_nameremove(dentry, isdir);
+		}
 	}
 
 	return error;
-- 
1.7.4.1

