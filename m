Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab2JBA07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:26:59 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:54218 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab2JBAR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:28 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 16/49] vfs: turn do_path_lookup into wrapper around getname_info variant
Date: Mon,  1 Oct 2012 20:16:25 -0400
Message-Id: <1349137018-21948-17-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...and make the user_path callers use that variant instead.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 01a2dd18..5e31fbb 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1993,20 +1993,30 @@ static int path_lookupat(int dfd, const char *name,
 	return err;
 }
 
-static int do_path_lookup(int dfd, const char *name,
+static int ginfo_lookup(int dfd, struct getname_info *ginfo,
 				unsigned int flags, struct nameidata *nd)
 {
-	int retval = path_lookupat(dfd, name, flags | LOOKUP_RCU, nd);
+	int retval = path_lookupat(dfd, ginfo->name, flags | LOOKUP_RCU, nd);
 	if (unlikely(retval == -ECHILD))
-		retval = path_lookupat(dfd, name, flags, nd);
+		retval = path_lookupat(dfd, ginfo->name, flags, nd);
 	if (unlikely(retval == -ESTALE))
-		retval = path_lookupat(dfd, name, flags | LOOKUP_REVAL, nd);
+		retval = path_lookupat(dfd, ginfo->name,
+						flags | LOOKUP_REVAL, nd);
 
 	if (likely(!retval))
-		audit_inode(name, nd->path.dentry, flags & LOOKUP_PARENT);
+		audit_inode(ginfo->name, nd->path.dentry,
+						flags & LOOKUP_PARENT);
 	return retval;
 }
 
+static int do_path_lookup(int dfd, const char *name,
+				unsigned int flags, struct nameidata *nd)
+{
+	struct getname_info ginfo = { .name = name };
+
+	return ginfo_lookup(dfd, &ginfo, flags, nd);
+}
+
 /* does lookup, returns the object with parent locked */
 struct dentry *kern_path_locked(const char *name, struct path *path)
 {
@@ -2130,7 +2140,7 @@ int user_path_at_empty(int dfd, const char __user *name, unsigned flags,
 
 		BUG_ON(flags & LOOKUP_PARENT);
 
-		err = do_path_lookup(dfd, tmp->name, flags, &nd);
+		err = ginfo_lookup(dfd, tmp, flags, &nd);
 		putname(tmp);
 		if (!err)
 			*path = nd.path;
@@ -2144,6 +2154,12 @@ int user_path_at(int dfd, const char __user *name, unsigned flags,
 	return user_path_at_empty(dfd, name, flags, path, NULL);
 }
 
+/*
+ * NB: most callers don't do anything directly with the reference to the
+ *     to ginfo, but the nd->last pointer points into the name string
+ *     allocated by getname. So we must hold the reference to it until all
+ *     path-walking is complete.
+ */
 static struct getname_info *
 user_path_parent(int dfd, const char __user *path, struct nameidata *nd)
 {
@@ -2153,7 +2169,7 @@ user_path_parent(int dfd, const char __user *path, struct nameidata *nd)
 	if (IS_ERR(s))
 		return s;
 
-	error = do_path_lookup(dfd, s->name, LOOKUP_PARENT, nd);
+	error = ginfo_lookup(dfd, s, LOOKUP_PARENT, nd);
 	if (error) {
 		putname(s);
 		return ERR_PTR(error);
-- 
1.7.11.4

