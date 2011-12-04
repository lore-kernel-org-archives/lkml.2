Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab1LDV1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 16:27:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56279 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab1LDV1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 16:27:17 -0500
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: [PATCH] Remove use of mnt_ns->root and fix a couple of bugs in d_namespace_path
Date: Sun,  4 Dec 2011 13:27:00 -0800
Message-Id: <1323034020-28780-1-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the unnecassary use of mnt_ns->root from path lookups, and replace
it with passing stuct path { NULL, NULL } to __d_path.  As part of this
remove the disconnect case CHROOT_NSCONNECT which is ununsed.

Fix the sysctl check to use path.dentry, instead of the unsafe tmp.dentry

Adjust the return code for disconnected from -ESTALE to -EACCES as AppArmor
is denying access.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/file.c |    2 +-
 security/apparmor/path.c |   57 +++++++++++++++++++--------------------------
 2 files changed, 25 insertions(+), 34 deletions(-)

diff --git a/security/apparmor/file.c b/security/apparmor/file.c
index 7312db7..8d7806e 100644
--- a/security/apparmor/file.c
+++ b/security/apparmor/file.c
@@ -289,7 +289,7 @@ int aa_path_perm(int op, struct aa_profile *profile, struct path *path,
 			perms.allow = request;
 		} else if (error == -ENOENT)
 			info = "Failed name lookup - deleted entry";
-		else if (error == -ESTALE)
+		else if (error == -EACCES)
 			info = "Failed name lookup - disconnected path";
 		else if (error == -ENAMETOOLONG)
 			info = "Failed name lookup - name too long";
diff --git a/security/apparmor/path.c b/security/apparmor/path.c
index 36cc0cc..670d40d 100644
--- a/security/apparmor/path.c
+++ b/security/apparmor/path.c
@@ -57,22 +57,17 @@ static int prepend(char **buffer, int buflen, const char *str, int namelen)
 static int d_namespace_path(struct path *path, char *buf, int buflen,
 			    char **name, int flags)
 {
-	struct path root, tmp;
+	struct path root, tmp = { };
 	char *res;
-	int connected, error = 0;
+	int error = 0;
+
+	get_fs_root(current->fs, &root);
 
 	/* Get the root we want to resolve too, released below */
-	if (flags & PATH_CHROOT_REL) {
+	if (flags & PATH_CHROOT_REL)
 		/* resolve paths relative to chroot */
-		get_fs_root(current->fs, &root);
-	} else {
-		/* resolve paths relative to namespace */
-		root.mnt = current->nsproxy->mnt_ns->root;
-		root.dentry = root.mnt->mnt_root;
-		path_get(&root);
-	}
+		tmp = root;
 
-	tmp = root;
 	res = __d_path(path, &tmp, buf, buflen);
 
 	*name = res;
@@ -97,10 +92,17 @@ static int d_namespace_path(struct path *path, char *buf, int buflen,
 			goto out;
 	}
 
-	/* Determine if the path is connected to the expected root */
-	connected = tmp.dentry == root.dentry && tmp.mnt == root.mnt;
+	/* is the path a sysctl? */
+	if (path->dentry->d_sb->s_magic == PROC_SUPER_MAGIC &&
+	    strncmp(*name, "/sys/", 5) == 0) {
+		/* TODO: convert over to using a per namespace
+		 * control instead of hard coded /proc
+		 */
+		error = prepend(name, *name - buf, "/proc", 5);
+	}
 
-	/* If the path is not connected,
+	/* Determine if the path is connected to the expected root
+	 * If the path is not connected,
 	 * check if it is a sysctl and handle specially else remove any
 	 * leading / that __d_path may have returned.
 	 * Unless
@@ -111,25 +113,14 @@ static int d_namespace_path(struct path *path, char *buf, int buflen,
 	 *     of chroot) and specifically directed to connect paths to
 	 *     namespace root.
 	 */
-	if (!connected) {
-		/* is the disconnect path a sysctl? */
-		if (tmp.dentry->d_sb->s_magic == PROC_SUPER_MAGIC &&
-		    strncmp(*name, "/sys/", 5) == 0) {
-			/* TODO: convert over to using a per namespace
-			 * control instead of hard coded /proc
-			 */
-			error = prepend(name, *name - buf, "/proc", 5);
-		} else if (!(flags & PATH_CONNECT_PATH) &&
-			   !(((flags & CHROOT_NSCONNECT) == CHROOT_NSCONNECT) &&
-			     (tmp.mnt == current->nsproxy->mnt_ns->root &&
-			      tmp.dentry == tmp.mnt->mnt_root))) {
-			/* disconnected path, don't return pathname starting
-			 * with '/'
-			 */
-			error = -ESTALE;
-			if (*res == '/')
-				*name = res + 1;
-		}
+	if ((tmp.dentry == root.dentry && tmp.mnt == root.mnt) &&
+	    !(flags & PATH_CONNECT_PATH)) {
+		/* disconnected path, don't return pathname starting
+		 * with '/'
+		 */
+		error = -EACCES;
+		if (*res == '/')
+			*name = res + 1;
 	}
 
 out:
-- 
1.7.5.4

