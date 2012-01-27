Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab2A0SPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:15:07 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:58084 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab2A0SPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:15:06 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] uml/hostfs: Propagate dirent.d_type to filldir()
Date: Fri, 27 Jan 2012 19:14:58 +0100
Message-Id: <1327688098-10159-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the (optional) d_type member in struct dirent is always
DT_UNKNOWN on hostfs, which may confuse buggy software using readdir().
Make sure to propagate its value from the underlying filesystem if it's
available there.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/hostfs/hostfs.h      |    3 ++-
 fs/hostfs/hostfs_kern.c |    5 +++--
 fs/hostfs/hostfs_user.c |    4 +++-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/hostfs/hostfs.h b/fs/hostfs/hostfs.h
index 3cbfa93..1fe7313 100644
--- a/fs/hostfs/hostfs.h
+++ b/fs/hostfs/hostfs.h
@@ -67,7 +67,8 @@ extern int access_file(char *path, int r, int w, int x);
 extern int open_file(char *path, int r, int w, int append);
 extern void *open_dir(char *path, int *err_out);
 extern char *read_dir(void *stream, unsigned long long *pos,
-		      unsigned long long *ino_out, int *len_out);
+		      unsigned long long *ino_out, int *len_out,
+		      unsigned int *type_out);
 extern void close_file(void *stream);
 extern int replace_file(int oldfd, int fd);
 extern void close_dir(void *stream);
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index e130bd4..dc4222b 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -283,6 +283,7 @@ int hostfs_readdir(struct file *file, void *ent, filldir_t filldir)
 	char *name;
 	unsigned long long next, ino;
 	int error, len;
+	unsigned int type;
 
 	name = dentry_name(file->f_path.dentry);
 	if (name == NULL)
@@ -292,9 +293,9 @@ int hostfs_readdir(struct file *file, void *ent, filldir_t filldir)
 	if (dir == NULL)
 		return -error;
 	next = file->f_pos;
-	while ((name = read_dir(dir, &next, &ino, &len)) != NULL) {
+	while ((name = read_dir(dir, &next, &ino, &len, &type)) != NULL) {
 		error = (*filldir)(ent, name, len, file->f_pos,
-				   ino, DT_UNKNOWN);
+				   ino, type);
 		if (error) break;
 		file->f_pos = next;
 	}
diff --git a/fs/hostfs/hostfs_user.c b/fs/hostfs/hostfs_user.c
index dd7bc38..a74ad0d 100644
--- a/fs/hostfs/hostfs_user.c
+++ b/fs/hostfs/hostfs_user.c
@@ -98,7 +98,8 @@ void *open_dir(char *path, int *err_out)
 }
 
 char *read_dir(void *stream, unsigned long long *pos,
-	       unsigned long long *ino_out, int *len_out)
+	       unsigned long long *ino_out, int *len_out,
+	       unsigned int *type_out)
 {
 	DIR *dir = stream;
 	struct dirent *ent;
@@ -109,6 +110,7 @@ char *read_dir(void *stream, unsigned long long *pos,
 		return NULL;
 	*len_out = strlen(ent->d_name);
 	*ino_out = ent->d_ino;
+	*type_out = ent->d_type;
 	*pos = telldir(dir);
 	return ent->d_name;
 }
-- 
1.7.0.4

