Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab2BUT7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:59:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017Ab2BUTxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:53:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 57/73] VFS: Create user_path_nd() to lookup both parent and
 target [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:04:38 +0000
Message-ID: <20120221180437.25235.70261.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora <vaurora@redhat.com>

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

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namei.c            |   31 +++++++++++++++++++++++++++++++
 include/linux/namei.h |    2 ++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index d52377d..be505cd 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2239,6 +2239,37 @@ static int user_path_parent(int dfd, const char __user *path,
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
index ffc0213..e273639 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -68,6 +68,8 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 
 extern int user_path_at(int, const char __user *, unsigned, struct path *);
 extern int user_path_at_empty(int, const char __user *, unsigned, struct path *, int *empty);
+extern int user_path_nd(int, const char __user *, unsigned,
+			struct nameidata *, struct path *, char **);
 
 #define user_path(name, path) user_path_at(AT_FDCWD, name, LOOKUP_FOLLOW, path)
 #define user_lpath(name, path) user_path_at(AT_FDCWD, name, 0, path)

