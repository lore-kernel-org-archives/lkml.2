Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab2J1XnG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:43:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41975 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756537Ab2J1X1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:35 -0400
Message-Id: <20121028231601.191944870@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:54 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 078/105] sysfs: sysfs_pathname/sysfs_add_one: Use strlcat() instead of
 strcat()
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/sysfs/dir.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 6b0bb00..2fbdff6 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -485,20 +485,18 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
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
 
@@ -531,9 +529,11 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
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
 


