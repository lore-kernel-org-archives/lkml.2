Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab0FYTHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:07:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932330Ab0FYTG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:06:57 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 23/38] union-mount: Call do_whiteout() on unlink and rmdir in unions
Date: Fri, 25 Jun 2010 12:05:13 -0700
Message-Id: <1277492728-11446-24-git-send-email-vaurora@redhat.com>
In-Reply-To: <1277492728-11446-1-git-send-email-vaurora@redhat.com>
References: <1277492728-11446-1-git-send-email-vaurora@redhat.com>
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
index 3f969af..c17693f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2595,6 +2595,10 @@ static long do_rmdir(int dfd, const char __user *pathname)
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
@@ -2684,6 +2688,10 @@ static long do_unlinkat(int dfd, const char __user *pathname)
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

