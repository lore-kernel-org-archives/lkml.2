Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778Ab2F0VFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 17:05:08 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:42567 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab2F0VFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 17:05:06 -0400
Message-ID: <1340831017.2267.4.camel@falcor>
Subject: [PATCH v1] ima: use full pathnames in measurement list
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module <linux-security-module@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Date: Wed, 27 Jun 2012 17:03:37 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062721-6148-0000-0000-0000071F52F4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IMA measurement list contains filename hints, which can be
ambigious without the full pathname.  This patch replaces the
filename hint with the full pathname, simplifying for userspace
the correlating of file hash measurements with files.

Change log v1:
- Revert to short filenames, when full pathname is longer than IMA
  measurement buffer size. (Based on Dmitry's review)

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_api.c  |    4 ++-
 security/integrity/ima/ima_main.c |   42 +++++++++++++++++++++++++++++++-----
 2 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 88a2788..032ff03 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -175,7 +175,9 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
 	}
 	memset(&entry->template, 0, sizeof(entry->template));
 	memcpy(entry->template.digest, iint->digest, IMA_DIGEST_SIZE);
-	strncpy(entry->template.file_name, filename, IMA_EVENT_NAME_LEN_MAX);
+	strcpy(entry->template.file_name,
+	       (strlen(filename) > IMA_EVENT_NAME_LEN_MAX) ?
+	       file->f_dentry->d_name.name : filename);
 
 	result = ima_store_template(entry, violation, inode);
 	if (!result || result == -EEXIST)
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index b17be79..a0e631a 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -54,6 +54,7 @@ static void ima_rdwr_violation_check(struct file *file)
 	fmode_t mode = file->f_mode;
 	int rc;
 	bool send_tomtou = false, send_writers = false;
+	unsigned char *pathname = NULL, *pathbuf = NULL;
 
 	if (!S_ISREG(inode->i_mode) || !ima_initialized)
 		return;
@@ -75,12 +76,27 @@ static void ima_rdwr_violation_check(struct file *file)
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
+		else if (strlen(pathname) > IMA_EVENT_NAME_LEN_MAX)
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
@@ -123,6 +139,7 @@ static int process_measurement(struct file *file, const unsigned char *filename,
 {
 	struct inode *inode = file->f_dentry->d_inode;
 	struct integrity_iint_cache *iint;
+	unsigned char *pathname = NULL, *pathbuf = NULL;
 	int rc = 0;
 
 	if (!ima_initialized || !S_ISREG(inode->i_mode))
@@ -147,8 +164,21 @@ retry:
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

