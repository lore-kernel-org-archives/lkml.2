Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab0FYTHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:07:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756636Ab0FYTHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:07:21 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 29/38] union-mount: Implement union-aware link()
Date: Fri, 25 Jun 2010 12:05:19 -0700
Message-Id: <1277492728-11446-30-git-send-email-vaurora@redhat.com>
In-Reply-To: <1277492728-11446-1-git-send-email-vaurora@redhat.com>
References: <1277492728-11446-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/namei.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 0a4abc7..399cb65 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2941,16 +2941,18 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
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
 
@@ -2958,8 +2960,20 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
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
@@ -2982,6 +2996,8 @@ out_release:
 	putname(to);
 out:
 	path_put(&old_path);
+	path_put(&old_nd.path);
+	putname(from);
 
 	return error;
 }
-- 
1.6.3.3

