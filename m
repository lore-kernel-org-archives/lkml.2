Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab0DOXL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:11:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299Ab0DOXHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:07:13 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 25/35] VFS: Create user_path_nd() to lookup both parent and target
Date: Thu, 15 Apr 2010 16:04:32 -0700
Message-Id: <1271372682-21225-26-git-send-email-vaurora@redhat.com>
In-Reply-To: <1271372682-21225-25-git-send-email-vaurora@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Proof-of-concept implementation of user_path_nd().  Lookup both the
parent and the target of a user-supplied filename, to supply later to
union copyup routines.
---
 fs/namei.c            |   31 +++++++++++++++++++++++++++++++
 include/linux/namei.h |    2 ++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 24e0cb2..68aa8ab 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1563,6 +1563,37 @@ static int user_path_parent(int dfd, const char __user *path,
 	return error;
 }
 
+int user_path_nd(int dfd, const char __user *filename,
+			 unsigned flags, struct nameidata *parent_nd,
+			 struct path *child, char **tmp)
+{
+	struct nameidata child_nd;
+	char *s = getname(filename);
+	int error;
+
+	if (IS_ERR(s))
+		return PTR_ERR(s);
+
+	/* Lookup parent */
+	error = do_path_lookup(dfd, s, LOOKUP_PARENT, parent_nd);
+	if (error)
+		goto out_putname;
+
+	/* Lookup child - XXX optimize, racy */
+	error = do_path_lookup(dfd, s, flags, &child_nd);
+	if (error)
+		goto out_path_put;
+	*child = child_nd.path;
+	*tmp = s;
+	return 0;
+
+out_path_put:
+	path_put(&parent_nd->path);
+out_putname:
+	putname(s);
+	return error;
+}
+
 /*
  * It's inline, so penalty for filesystems that don't use sticky bit is
  * minimal.
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 05b441d..83dc8b5 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -58,6 +58,8 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 #define LOOKUP_RENAME_TARGET	0x0800
 
 extern int user_path_at(int, const char __user *, unsigned, struct path *);
+extern int user_path_nd(int, const char __user *, unsigned,
+			struct nameidata *, struct path *, char **);
 
 #define user_path(name, path) user_path_at(AT_FDCWD, name, LOOKUP_FOLLOW, path)
 #define user_lpath(name, path) user_path_at(AT_FDCWD, name, 0, path)
-- 
1.6.3.3

