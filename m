Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab2EGONJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:13:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51638 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab2EGOMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:12:33 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
        michael.brantley@deshaw.com
Subject: [PATCH v1 RESEND 11/12] vfs: fix linkat to retry on ESTALE errors
Date: Mon,  7 May 2012 10:12:10 -0400
Message-Id: <1336399931-20234-12-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336399931-20234-1-git-send-email-jlayton@redhat.com>
References: <1336399931-20234-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index b5d28fe..a40dcbb 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3054,6 +3054,7 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 	struct path old_path, new_path;
 	int how = 0;
 	int error;
+	unsigned int try = 0;
 
 	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH)) != 0)
 		return -EINVAL;
@@ -3071,11 +3072,12 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 	if (flags & AT_SYMLINK_FOLLOW)
 		how |= LOOKUP_FOLLOW;
 
+retry:
 	error = user_path_at(olddfd, oldname, how, &old_path);
 	if (error)
 		return error;
 
-	new_dentry = user_path_create(newdfd, newname, &new_path, false, false);
+	new_dentry = user_path_create(newdfd, newname, &new_path, false, try);
 	error = PTR_ERR(new_dentry);
 	if (IS_ERR(new_dentry))
 		goto out;
@@ -3098,7 +3100,10 @@ out_dput:
 	path_put(&new_path);
 out:
 	path_put(&old_path);
-
+	if (retry_estale(error, try++)) {
+		how |= LOOKUP_REVAL;
+		goto retry;
+	}
 	return error;
 }
 
-- 
1.7.7.6

