Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab2DZRHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 13:07:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43068 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624Ab2DZRHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 13:07:03 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
        michael.brantley@deshaw.com
Subject: [PATCH v1 10/12] vfs: fix symlinkat to retry on ESTALE errors
Date: Thu, 26 Apr 2012 11:57:21 -0400
Message-Id: <1335455843-16089-9-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1335455843-16089-1-git-send-email-jlayton@redhat.com>
References: <1335455843-16089-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 3a8e5e4..b189dc5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2957,12 +2957,14 @@ SYSCALL_DEFINE3(symlinkat, const char __user *, oldname,
 	char *from;
 	struct dentry *dentry;
 	struct path path;
+	unsigned int try = 0;
 
 	from = getname(oldname);
 	if (IS_ERR(from))
 		return PTR_ERR(from);
 
-	dentry = user_path_create(newdfd, newname, &path, false, false);
+retry:
+	dentry = user_path_create(newdfd, newname, &path, false, try);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
 		goto out_putname;
@@ -2980,6 +2982,8 @@ out_dput:
 	dput(dentry);
 	mutex_unlock(&path.dentry->d_inode->i_mutex);
 	path_put(&path);
+	if (retry_estale(error, try++))
+		goto retry;
 out_putname:
 	putname(from);
 	return error;
-- 
1.7.7.6

