Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab2F2D32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 23:29:28 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:48280 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2F2D30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 23:29:26 -0400
From: Guo Chao <yan@linux.vnet.ibm.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Check node type at the beginning of mknodat
Date: Fri, 29 Jun 2012 11:29:17 +0800
Message-Id: <1340940558-9893-2-git-send-email-yan@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340940558-9893-1-git-send-email-yan@linux.vnet.ibm.com>
References: <n>
 <1340940558-9893-1-git-send-email-yan@linux.vnet.ibm.com>
x-cbid: 12062903-3864-0000-0000-0000038C09F1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We make sure node is not directory at beginning of mknodat, which is in 
effect included in a latter may_mknod check.

Move may_mknod up to replace directory check. We can also avoid cleanup 
if check fails.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/namei.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 8dccfcc..05b9053 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2910,8 +2910,9 @@ SYSCALL_DEFINE4(mknodat, int, dfd, const char __user *, filename, umode_t, mode,
 	struct path path;
 	int error;
 
-	if (S_ISDIR(mode))
-		return -EPERM;
+	error = may_mknod(mode);
+	if (error)
+		return error;
 
 	dentry = user_path_create(dfd, filename, &path, 0);
 	if (IS_ERR(dentry))
@@ -2919,9 +2920,7 @@ SYSCALL_DEFINE4(mknodat, int, dfd, const char __user *, filename, umode_t, mode,
 
 	if (!IS_POSIXACL(path.dentry->d_inode))
 		mode &= ~current_umask();
-	error = may_mknod(mode);
-	if (error)
-		goto out_dput;
+
 	error = mnt_want_write(path.mnt);
 	if (error)
 		goto out_dput;
-- 
1.7.9.5

