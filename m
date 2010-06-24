Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab0FXSMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 14:12:22 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45091 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756097Ab0FXSMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 14:12:08 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 13/15] ima: inode post_setattr
Date: Thu, 24 Jun 2010 14:10:29 -0400
Message-Id: <1277403031-3080-14-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1277403031-3080-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1277403031-3080-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing an inode's metadata may result in our not needing to
appraise the file.  In such cases, we must remove 'security.ima'.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 fs/attr.c           |    2 ++
 include/linux/ima.h |    6 ++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 9293710..f410bde 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -14,6 +14,7 @@
 #include <linux/fcntl.h>
 #include <linux/security.h>
 #include <linux/evm.h>
+#include <linux/ima.h>
 
 /* Taken over from the old code... */
 
@@ -251,6 +252,7 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 
 	if (!error) {
 		fsnotify_change(dentry, ia_valid);
+		ima_inode_post_setattr(dentry);
 		evm_inode_post_setattr(dentry, ia_valid);
 	}
 
diff --git a/include/linux/ima.h b/include/linux/ima.h
index 4dce900..ce82e29 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -19,6 +19,7 @@ extern int ima_file_check(struct file *file, int mask);
 extern void ima_file_free(struct file *file);
 extern int ima_file_mmap(struct file *file, unsigned long prot);
 extern void ima_counts_get(struct file *file);
+extern void ima_inode_post_setattr(struct dentry *dentry);
 
 #else
 static inline int ima_bprm_check(struct linux_binprm *bprm)
@@ -46,5 +47,10 @@ static inline void ima_counts_get(struct file *file)
 	return;
 }
 
+static inline void ima_inode_post_setattr(struct dentry *dentry)
+{
+	return;
+}
+
 #endif /* CONFIG_IMA_H */
 #endif /* _LINUX_IMA_H */
-- 
1.6.6.1

