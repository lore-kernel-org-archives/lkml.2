Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab2B0WXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:23:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38802 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab2B0WXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:23:50 -0500
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 4/7] AppArmor: Move path failure information into aa_get_name and rename
Date: Mon, 27 Feb 2012 14:23:14 -0800
Message-Id: <1330381397-5352-5-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330381397-5352-1-git-send-email-john.johansen@canonical.com>
References: <1330381397-5352-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the path name lookup failure messages into the main path name lookup
routine, as the information is useful in more than just aa_path_perm.

Also rename aa_get_name to aa_path_name as it is not getting a reference
counted object with a corresponding put fn.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Acked-by: Kees Cook <kees@ubuntu.com>
---
 security/apparmor/domain.c       |    5 ++---
 security/apparmor/file.c         |   18 +++++++-----------
 security/apparmor/include/path.h |    3 ++-
 security/apparmor/path.c         |   22 ++++++++++++++++++----
 4 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index c1e18ba..7c69599 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -372,13 +372,12 @@ int apparmor_bprm_set_creds(struct linux_binprm *bprm)
 	state = profile->file.start;
 
 	/* buffer freed below, name is pointer into buffer */
-	error = aa_get_name(&bprm->file->f_path, profile->path_flags, &buffer,
-			    &name);
+	error = aa_path_name(&bprm->file->f_path, profile->path_flags, &buffer,
+			     &name, &info);
 	if (error) {
 		if (profile->flags &
 		    (PFLAG_IX_ON_NAME_ERROR | PFLAG_UNCONFINED))
 			error = 0;
-		info = "Exec failed name resolution";
 		name = bprm->filename;
 		goto audit;
 	}
diff --git a/security/apparmor/file.c b/security/apparmor/file.c
index bba875c..3022c0f 100644
--- a/security/apparmor/file.c
+++ b/security/apparmor/file.c
@@ -278,22 +278,16 @@ int aa_path_perm(int op, struct aa_profile *profile, struct path *path,
 	int error;
 
 	flags |= profile->path_flags | (S_ISDIR(cond->mode) ? PATH_IS_DIR : 0);
-	error = aa_get_name(path, flags, &buffer, &name);
+	error = aa_path_name(path, flags, &buffer, &name, &info);
 	if (error) {
 		if (error == -ENOENT && is_deleted(path->dentry)) {
 			/* Access to open files that are deleted are
 			 * give a pass (implicit delegation)
 			 */
 			error = 0;
+			info = NULL;
 			perms.allow = request;
-		} else if (error == -ENOENT)
-			info = "Failed name lookup - deleted entry";
-		else if (error == -ESTALE)
-			info = "Failed name lookup - disconnected path";
-		else if (error == -ENAMETOOLONG)
-			info = "Failed name lookup - name too long";
-		else
-			info = "Failed name lookup";
+		}
 	} else {
 		aa_str_perms(profile->file.dfa, profile->file.start, name, cond,
 			     &perms);
@@ -364,12 +358,14 @@ int aa_path_link(struct aa_profile *profile, struct dentry *old_dentry,
 	lperms = nullperms;
 
 	/* buffer freed below, lname is pointer in buffer */
-	error = aa_get_name(&link, profile->path_flags, &buffer, &lname);
+	error = aa_path_name(&link, profile->path_flags, &buffer, &lname,
+			     &info);
 	if (error)
 		goto audit;
 
 	/* buffer2 freed below, tname is pointer in buffer2 */
-	error = aa_get_name(&target, profile->path_flags, &buffer2, &tname);
+	error = aa_path_name(&target, profile->path_flags, &buffer2, &tname,
+			     &info);
 	if (error)
 		goto audit;
 
diff --git a/security/apparmor/include/path.h b/security/apparmor/include/path.h
index 27b327a..286ac75 100644
--- a/security/apparmor/include/path.h
+++ b/security/apparmor/include/path.h
@@ -26,6 +26,7 @@ enum path_flags {
 	PATH_MEDIATE_DELETED = 0x10000,	/* mediate deleted paths */
 };
 
-int aa_get_name(struct path *path, int flags, char **buffer, const char **name);
+int aa_path_name(struct path *path, int flags, char **buffer,
+		 const char **name, const char **info);
 
 #endif /* __AA_PATH_H */
diff --git a/security/apparmor/path.c b/security/apparmor/path.c
index 95a589e..41e19a1 100644
--- a/security/apparmor/path.c
+++ b/security/apparmor/path.c
@@ -157,7 +157,7 @@ out:
  * Returns: %0 else error on failure
  */
 static int get_name_to_buffer(struct path *path, int flags, char *buffer,
-			      int size, char **name)
+			      int size, char **name, const char **info)
 {
 	int adjust = (flags & PATH_IS_DIR) ? 1 : 0;
 	int error = d_namespace_path(path, buffer, size - adjust, name, flags);
@@ -169,15 +169,27 @@ static int get_name_to_buffer(struct path *path, int flags, char *buffer,
 		 */
 		strcpy(&buffer[size - 2], "/");
 
+	if (info && error) {
+		if (error == -ENOENT)
+			*info = "Failed name lookup - deleted entry";
+		else if (error == -ESTALE)
+			*info = "Failed name lookup - disconnected path";
+		else if (error == -ENAMETOOLONG)
+			*info = "Failed name lookup - name too long";
+		else
+			*info = "Failed name lookup";
+	}
+
 	return error;
 }
 
 /**
- * aa_get_name - compute the pathname of a file
+ * aa_path_name - compute the pathname of a file
  * @path: path the file  (NOT NULL)
  * @flags: flags controlling path name generation
  * @buffer: buffer that aa_get_name() allocated  (NOT NULL)
  * @name: Returns - the generated path name if !error (NOT NULL)
+ * @info: Returns - information on why the path lookup failed (MAYBE NULL)
  *
  * @name is a pointer to the beginning of the pathname (which usually differs
  * from the beginning of the buffer), or NULL.  If there is an error @name
@@ -190,7 +202,8 @@ static int get_name_to_buffer(struct path *path, int flags, char *buffer,
  *
  * Returns: %0 else error code if could retrieve name
  */
-int aa_get_name(struct path *path, int flags, char **buffer, const char **name)
+int aa_path_name(struct path *path, int flags, char **buffer, const char **name,
+		 const char **info)
 {
 	char *buf, *str = NULL;
 	int size = 256;
@@ -204,7 +217,7 @@ int aa_get_name(struct path *path, int flags, char **buffer, const char **name)
 		if (!buf)
 			return -ENOMEM;
 
-		error = get_name_to_buffer(path, flags, buf, size, &str);
+		error = get_name_to_buffer(path, flags, buf, size, &str, info);
 		if (error != -ENAMETOOLONG)
 			break;
 
@@ -212,6 +225,7 @@ int aa_get_name(struct path *path, int flags, char **buffer, const char **name)
 		size <<= 1;
 		if (size > aa_g_path_max)
 			return -ENAMETOOLONG;
+		*info = NULL;
 	}
 	*buffer = buf;
 	*name = str;
-- 
1.7.9

