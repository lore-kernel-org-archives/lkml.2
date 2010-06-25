Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab0FYTJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:09:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932477Ab0FYTHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:07:25 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 32/38] union-mount: Implement union-aware chown()
Date: Fri, 25 Jun 2010 12:05:22 -0700
Message-Id: <1277492728-11446-33-git-send-email-vaurora@redhat.com>
In-Reply-To: <1277492728-11446-1-git-send-email-vaurora@redhat.com>
References: <1277492728-11446-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/open.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 7f7958e..68c97dd 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -718,18 +718,35 @@ static int chown_common(struct path *path, uid_t user, gid_t group)
 SYSCALL_DEFINE3(chown, const char __user *, filename, uid_t, user, gid_t, group)
 {
 	struct path path;
+	struct nameidata nd;
+	struct vfsmount *mnt;
+	char *tmp;
 	int error;
 
-	error = user_path(filename, &path);
+	error = user_path_nd(AT_FDCWD, filename, LOOKUP_FOLLOW,
+				     &nd, &path, &tmp);
 	if (error)
 		goto out;
-	error = mnt_want_write(path.mnt);
+
+	if (IS_DIR_UNIONED(nd.path.dentry))
+		mnt = nd.path.mnt;
+	else
+		mnt = path.mnt;
+
+	error = mnt_want_write(mnt);
 	if (error)
 		goto out_release;
+
+	error = union_copyup(&nd, &path);
+	if (error)
+		goto out_drop_write;
 	error = chown_common(&path, user, group);
-	mnt_drop_write(path.mnt);
+out_drop_write:
+	mnt_drop_write(mnt);
 out_release:
 	path_put(&path);
+	path_put(&nd.path);
+	putname(tmp);
 out:
 	return error;
 }
-- 
1.6.3.3

