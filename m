Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab0DOXJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:09:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757984Ab0DOXHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:07:33 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 31/35] union-mount: Implement union-aware chown()
Date: Thu, 15 Apr 2010 16:04:38 -0700
Message-Id: <1271372682-21225-32-git-send-email-vaurora@redhat.com>
In-Reply-To: <1271372682-21225-31-git-send-email-vaurora@redhat.com>
References: <1271372682-21225-1-git-send-email-vaurora@redhat.com>
 <1271372682-21225-2-git-send-email-vaurora@redhat.com>
 <1271372682-21225-3-git-send-email-vaurora@redhat.com>
 <1271372682-21225-4-git-send-email-vaurora@redhat.com>
 <1271372682-21225-5-git-send-email-vaurora@redhat.com>
 <1271372682-21225-6-git-send-email-vaurora@redhat.com>
 <1271372682-21225-7-git-send-email-vaurora@redhat.com>
 <1271372682-21225-8-git-send-email-vaurora@redhat.com>
 <1271372682-21225-9-git-send-email-vaurora@redhat.com>
 <1271372682-21225-10-git-send-email-vaurora@redhat.com>
 <1271372682-21225-11-git-send-email-vaurora@redhat.com>
 <1271372682-21225-12-git-send-email-vaurora@redhat.com>
 <1271372682-21225-13-git-send-email-vaurora@redhat.com>
 <1271372682-21225-14-git-send-email-vaurora@redhat.com>
 <1271372682-21225-15-git-send-email-vaurora@redhat.com>
 <1271372682-21225-16-git-send-email-vaurora@redhat.com>
 <1271372682-21225-17-git-send-email-vaurora@redhat.com>
 <1271372682-21225-18-git-send-email-vaurora@redhat.com>
 <1271372682-21225-19-git-send-email-vaurora@redhat.com>
 <1271372682-21225-20-git-send-email-vaurora@redhat.com>
 <1271372682-21225-21-git-send-email-vaurora@redhat.com>
 <1271372682-21225-22-git-send-email-vaurora@redhat.com>
 <1271372682-21225-23-git-send-email-vaurora@redhat.com>
 <1271372682-21225-24-git-send-email-vaurora@redhat.com>
 <1271372682-21225-25-git-send-email-vaurora@redhat.com>
 <1271372682-21225-26-git-send-email-vaurora@redhat.com>
 <1271372682-21225-27-git-send-email-vaurora@redhat.com>
 <1271372682-21225-28-git-send-email-vaurora@redhat.com>
 <1271372682-21225-29-git-send-email-vaurora@redhat.com>
 <1271372682-21225-30-git-send-email-vaurora@redhat.com>
 <1271372682-21225-31-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Proof-of-concept implementation of chown() for union mounts.
---
 fs/open.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 686fcd2..325852d 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -30,6 +30,7 @@
 #include <linux/falloc.h>
 #include <linux/fs_struct.h>
 #include <linux/ima.h>
+#include <linux/union.h>
 
 #include "internal.h"
 
@@ -717,18 +718,35 @@ static int chown_common(struct path *path, uid_t user, gid_t group)
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
+	if (IS_UNIONED_DIR(&nd.path))
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

