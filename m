Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061Ab2KZR0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:26:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48171 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934011Ab2KZROl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:14:41 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 237/270] sysfs: sysfs_pathname/sysfs_add_one: Use strlcat() instead of strcat()
Date: Mon, 26 Nov 2012 14:58:47 -0200
Message-Id: <1353949160-26803-238-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 66081a72517a131430dcf986775f3268aafcb546 upstream.

The warning check for duplicate sysfs entries can cause a buffer overflow
when printing the warning, as strcat() doesn't check buffer sizes.
Use strlcat() instead.

Since strlcat() doesn't return a pointer to the passed buffer, unlike
strcat(), I had to convert the nested concatenation in sysfs_add_one() to
an admittedly more obscure comma operator construct, to avoid emitting code
for the concatenation if CONFIG_BUG is disabled.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/sysfs/dir.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index e6bb9b2..5a035b5 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -478,20 +478,18 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 /**
  *	sysfs_pathname - return full path to sysfs dirent
  *	@sd: sysfs_dirent whose path we want
- *	@path: caller allocated buffer
+ *	@path: caller allocated buffer of size PATH_MAX
  *
  *	Gives the name "/" to the sysfs_root entry; any path returned
  *	is relative to wherever sysfs is mounted.
- *
- *	XXX: does no error checking on @path size
  */
 static char *sysfs_pathname(struct sysfs_dirent *sd, char *path)
 {
 	if (sd->s_parent) {
 		sysfs_pathname(sd->s_parent, path);
-		strcat(path, "/");
+		strlcat(path, "/", PATH_MAX);
 	}
-	strcat(path, sd->s_name);
+	strlcat(path, sd->s_name, PATH_MAX);
 	return path;
 }
 
@@ -524,9 +522,11 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 		char *path = kzalloc(PATH_MAX, GFP_KERNEL);
 		WARN(1, KERN_WARNING
 		     "sysfs: cannot create duplicate filename '%s'\n",
-		     (path == NULL) ? sd->s_name :
-		     strcat(strcat(sysfs_pathname(acxt->parent_sd, path), "/"),
-		            sd->s_name));
+		     (path == NULL) ? sd->s_name
+				    : (sysfs_pathname(acxt->parent_sd, path),
+				       strlcat(path, "/", PATH_MAX),
+				       strlcat(path, sd->s_name, PATH_MAX),
+				       path));
 		kfree(path);
 	}
 
-- 
1.7.9.5

