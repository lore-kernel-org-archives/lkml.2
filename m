Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab2IGNjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:39:48 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59218 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760291Ab2IGNiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:38:24 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: eparis@redhat.com, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 06/10] vfs: turn do_path_lookup into wrapper around getname_info variant
Date: Fri,  7 Sep 2012 09:38:01 -0400
Message-Id: <1347025085-20285-7-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347025085-20285-1-git-send-email-jlayton@redhat.com>
References: <1347025085-20285-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...and make the user_path callers use that variant instead.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 60db390..774f942 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1989,20 +1989,30 @@ static int path_lookupat(int dfd, const char *name,
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
@@ -2126,7 +2136,7 @@ int user_path_at_empty(int dfd, const char __user *name, unsigned flags,
 
 		BUG_ON(flags & LOOKUP_PARENT);
 
-		err = do_path_lookup(dfd, tmp->name, flags, &nd);
+		err = ginfo_lookup(dfd, tmp, flags, &nd);
 		putname(tmp);
 		if (!err)
 			*path = nd.path;
@@ -2140,6 +2150,12 @@ int user_path_at(int dfd, const char __user *name, unsigned flags,
 	return user_path_at_empty(dfd, name, flags, path, NULL);
 }
 
+/*
+ * NB: most callers don't do anything directly with the reference to the
+ *     to ginfo, but the nd->last pointer points into the name string
+ *     allocated by getinfo. So we must hold the reference to it until all
+ *     path-walking is complete.
+ */
 static struct getname_info *
 user_path_parent(int dfd, const char __user *path, struct nameidata *nd)
 {
@@ -2149,7 +2165,7 @@ user_path_parent(int dfd, const char __user *path, struct nameidata *nd)
 	if (IS_ERR(s))
 		return s;
 
-	error = do_path_lookup(dfd, s->name, LOOKUP_PARENT, nd);
+	error = ginfo_lookup(dfd, s, LOOKUP_PARENT, nd);
 	if (error) {
 		putname(s);
 		return ERR_PTR(error);
-- 
1.7.11.4

