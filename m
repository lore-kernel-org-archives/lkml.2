Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab2FVOYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 10:24:38 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43656 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab2FVOYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 10:24:36 -0400
Message-ID: <1340375022.2464.29.camel@falcor>
Subject: [PATCH] ima: use full pathnames in measurement list
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module <linux-security-module@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 22 Jun 2012 10:23:42 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062214-7182-0000-0000-000001D27D05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IMA measurement list contains filename hints, which can be
ambigious without the full pathname.  This patch replaces the
filename hint with the full pathname, simplifying for userspace
the correlating of file hash measurements with files.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_main.c |   40 +++++++++++++++++++++++++++++++-----
 1 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index b17be79..91fa323 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -54,6 +54,7 @@ static void ima_rdwr_violation_check(struct file *file)
 	fmode_t mode = file->f_mode;
 	int rc;
 	bool send_tomtou = false, send_writers = false;
+	unsigned char *pathname = NULL, *pathbuf = NULL;
 
 	if (!S_ISREG(inode->i_mode) || !ima_initialized)
 		return;
@@ -75,12 +76,25 @@ static void ima_rdwr_violation_check(struct file *file)
 out:
 	mutex_unlock(&inode->i_mutex);
 
+	if (!send_tomtou && !send_writers)
+		return;
+
+	/* We will allow 11 spaces for ' (deleted)' to be appended */
+	pathbuf = kmalloc(PATH_MAX + 11, GFP_KERNEL);
+	if (pathbuf) {
+		pathname = d_path(&file->f_path, pathbuf, PATH_MAX + 11);
+		if (IS_ERR(pathname))
+			pathname = NULL;
+	}
 	if (send_tomtou)
-		ima_add_violation(inode, dentry->d_name.name, "invalid_pcr",
-				  "ToMToU");
+		ima_add_violation(inode,
+				  !pathname ? dentry->d_name.name : pathname,
+				  "invalid_pcr", "ToMToU");
 	if (send_writers)
-		ima_add_violation(inode, dentry->d_name.name, "invalid_pcr",
-				  "open_writers");
+		ima_add_violation(inode,
+				  !pathname ? dentry->d_name.name : pathname,
+				  "invalid_pcr", "open_writers");
+	kfree(pathbuf);
 }
 
 static void ima_check_last_writer(struct integrity_iint_cache *iint,
@@ -123,6 +137,7 @@ static int process_measurement(struct file *file, const unsigned char *filename,
 {
 	struct inode *inode = file->f_dentry->d_inode;
 	struct integrity_iint_cache *iint;
+	unsigned char *pathname = NULL, *pathbuf = NULL;
 	int rc = 0;
 
 	if (!ima_initialized || !S_ISREG(inode->i_mode))
@@ -147,8 +162,21 @@ retry:
 		goto out;
 
 	rc = ima_collect_measurement(iint, file);
-	if (!rc)
-		ima_store_measurement(iint, file, filename);
+	if (rc != 0)
+		goto out;
+
+	if (function != BPRM_CHECK) {
+		/* We will allow 11 spaces for ' (deleted)' to be appended */
+		pathbuf = kmalloc(PATH_MAX + 11, GFP_KERNEL);
+		if (pathbuf) {
+			pathname =
+			    d_path(&file->f_path, pathbuf, PATH_MAX + 11);
+			if (IS_ERR(pathname))
+				pathname = NULL;
+		}
+	}
+	ima_store_measurement(iint, file, !pathname ? filename : pathname);
+	kfree(pathbuf);
 out:
 	mutex_unlock(&iint->mutex);
 	return rc;
-- 
1.7.7.6



