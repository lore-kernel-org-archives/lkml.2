Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab0FOSoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:44:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758481Ab0FOSmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:42:36 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 26/38] VFS: Create user_path_nd() to lookup both parent and target
Date: Tue, 15 Jun 2010 11:39:56 -0700
Message-Id: <1276627208-17242-27-git-send-email-vaurora@redhat.com>
In-Reply-To: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Proof-of-concept implementation of user_path_nd().  Lookup both the
parent and the target of a user-supplied filename, to supply later to
union copyup routines.

XXX - Inefficient, racy, gets the parent of the symlink instead of the
parent of the target.  Al Viro would like to see something more like
this:

user_path_mumble() looks up and returns:

parent nameidata
positive topmost dentry of target
negative dentry of target from the topmost layer (if it doesn't exist on top)

Both the positive lower dentry and negative topmost dentry are passed
to the following code, like do_chown().  The tests for permissions and
such-like are performed on the positive lower dentry.  When it comes
time to actually modify the target, we call union_copyup() with both
positive and negative dentries (and the parent nameidata).
---
 fs/namei.c            |   31 +++++++++++++++++++++++++++++++
 include/linux/namei.h |    2 ++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 4fd431e..505b51d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1542,6 +1542,37 @@ static int user_path_parent(int dfd, const char __user *path,
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

