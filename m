Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965815Ab0HFWk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 18:40:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935110Ab0HFWgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 18:36:47 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 23/38] union-mount: Call do_whiteout() on unlink and rmdir in unions
Date: Fri,  6 Aug 2010 15:35:09 -0700
Message-Id: <1281134124-17041-24-git-send-email-vaurora@redhat.com>
In-Reply-To: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
References: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
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
index 0821544..2d30a5b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2596,6 +2596,10 @@ static long do_rmdir(int dfd, const char __user *pathname)
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
@@ -2685,6 +2689,10 @@ static long do_unlinkat(int dfd, const char __user *pathname)
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

