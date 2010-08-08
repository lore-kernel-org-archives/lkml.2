Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab0HHPzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 11:55:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926Ab0HHPzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 11:55:40 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 30/39] union-mount: Implement union-aware link()
Date: Sun,  8 Aug 2010 11:52:47 -0400
Message-Id: <1281282776-5447-31-git-send-email-vaurora@redhat.com>
In-Reply-To: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index e7b02fa..5b22cc5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2942,16 +2942,18 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 {
 	struct dentry *new_dentry;
 	struct nameidata nd;
+	struct nameidata old_nd;
 	struct path old_path;
 	int error;
 	char *to;
+	char *from;
 
 	if ((flags & ~AT_SYMLINK_FOLLOW) != 0)
 		return -EINVAL;
 
-	error = user_path_at(olddfd, oldname,
+	error = user_path_nd(olddfd, oldname,
 			     flags & AT_SYMLINK_FOLLOW ? LOOKUP_FOLLOW : 0,
-			     &old_path);
+			     &old_nd, &old_path, &from);
 	if (error)
 		return error;
 
@@ -2959,8 +2961,20 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 	if (error)
 		goto out;
 	error = -EXDEV;
-	if (old_path.mnt != nd.path.mnt)
-		goto out_release;
+	if (old_path.mnt != nd.path.mnt) {
+		if (IS_DIR_UNIONED(old_nd.path.dentry) &&
+		    (old_nd.path.mnt == nd.path.mnt)) {
+			error = mnt_want_write(old_nd.path.mnt);
+			if (error)
+				goto out_release;
+			error = union_copyup(&old_nd, &old_path);
+			mnt_drop_write(old_nd.path.mnt);
+			if (error)
+				goto out_release;
+		} else {
+			goto out_release;
+		}
+	}
 	new_dentry = lookup_create(&nd, 0);
 	error = PTR_ERR(new_dentry);
 	if (IS_ERR(new_dentry))
@@ -2983,6 +2997,8 @@ out_release:
 	putname(to);
 out:
 	path_put(&old_path);
+	path_put(&old_nd.path);
+	putname(from);
 
 	return error;
 }
-- 
1.6.3.3

