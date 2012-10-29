Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637Ab2J2UI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:08:57 -0400
Received: from mail.kernel.org ([198.145.19.201]:42608 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760585Ab2J2UIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:08:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [ 10/34] sysfs: sysfs_pathname/sysfs_add_one: Use strlcat() instead of strcat()
Date: Mon, 29 Oct 2012 13:07:41 -0700
Message-Id: <20121029200421.719233417@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029200420.550338074@linuxfoundation.org>
References: <20121029200420.550338074@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 fs/sysfs/dir.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -404,20 +404,18 @@ int __sysfs_add_one(struct sysfs_addrm_c
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
 
@@ -450,9 +448,11 @@ int sysfs_add_one(struct sysfs_addrm_cxt
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
 


