Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab0HHPzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 11:55:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987Ab0HHPzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 11:55:50 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 33/39] union-mount: Implement union-aware chown()
Date: Sun,  8 Aug 2010 11:52:50 -0400
Message-Id: <1281282776-5447-34-git-send-email-vaurora@redhat.com>
In-Reply-To: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/open.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index fc56da0..8588b31 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -552,18 +552,35 @@ static int chown_common(struct path *path, uid_t user, gid_t group)
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

