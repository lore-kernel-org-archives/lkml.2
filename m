Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab0FOSpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:45:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758472Ab0FOSmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:42:23 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 23/38] union-mount: Call do_whiteout() on unlink and rmdir in unions
Date: Tue, 15 Jun 2010 11:39:53 -0700
Message-Id: <1276627208-17242-24-git-send-email-vaurora@redhat.com>
In-Reply-To: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

Call do_whiteout() when removing files and directories from a union
mounted file system.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 45be5e5..1e6adf7 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2592,6 +2592,10 @@ static long do_rmdir(int dfd, const char __user *pathname)
 	error = security_path_rmdir(&nd.path, path.dentry);
 	if (error)
 		goto exit4;
+	if (IS_DIR_UNIONED(nd.path.dentry)) {
+		error = do_whiteout(&nd, &path, 1);
+		goto exit4;
+	}
 	error = vfs_rmdir(nd.path.dentry->d_inode, path.dentry);
 exit4:
 	mnt_drop_write(nd.path.mnt);
@@ -2681,6 +2685,10 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 		error = security_path_unlink(&nd.path, path.dentry);
 		if (error)
 			goto exit3;
+		if (IS_DIR_UNIONED(nd.path.dentry)) {
+			error = do_whiteout(&nd, &path, 0);
+			goto exit3;
+		}
 		error = vfs_unlink(nd.path.dentry->d_inode, path.dentry);
 exit3:
 		mnt_drop_write(nd.path.mnt);
-- 
1.6.3.3

