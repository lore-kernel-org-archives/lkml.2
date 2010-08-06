Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965731Ab0HFWgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 18:36:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935018Ab0HFWgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 18:36:31 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 35/38] union-mount: Implement union-aware lchown()
Date: Fri,  6 Aug 2010 15:35:21 -0700
Message-Id: <1281134124-17041-36-git-send-email-vaurora@redhat.com>
In-Reply-To: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
References: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/open.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 5c9933f..693258f 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -646,18 +646,35 @@ out:
 SYSCALL_DEFINE3(lchown, const char __user *, filename, uid_t, user, gid_t, group)
 {
 	struct path path;
+	struct nameidata nd;
+	struct vfsmount *mnt;
+	char *tmp;
 	int error;
 
-	error = user_lpath(filename, &path);
+	error = user_path_nd(AT_FDCWD, filename, 0, &nd, &path, &tmp);
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
+
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

