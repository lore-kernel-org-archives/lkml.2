Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab2CATPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:15:12 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:47930 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab2CATOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:14:48 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v2 07/11] ima: add inode_post_setattr call
Date: Thu,  1 Mar 2012 14:10:44 -0500
Message-Id: <1330629048-5933-8-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1330629048-5933-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1330629048-5933-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030119-4242-0000-0000-000000EEF0A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing an inode's metadata may result in our not needing to appraise
the file.  In such cases, we must remove 'security.ima'.

Changelog v1:
- use ima_inode_post_setattr() stub function, if IMA_APPRAISE not configured

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>
---
 fs/attr.c           |    2 ++
 include/linux/ima.h |   10 ++++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index d9bd7fc..f496bac 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -14,6 +14,7 @@
 #include <linux/fcntl.h>
 #include <linux/security.h>
 #include <linux/evm.h>
+#include <linux/ima.h>
 
 /**
  * inode_change_ok - check if attribute changes to an inode are allowed
@@ -245,6 +246,7 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 
 	if (!error) {
 		fsnotify_change(dentry, ia_valid);
+		ima_inode_post_setattr(dentry);
 		evm_inode_post_setattr(dentry, ia_valid);
 	}
 
diff --git a/include/linux/ima.h b/include/linux/ima.h
index 6ac8e50..e2bfbb1 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -39,5 +39,15 @@ static inline int ima_file_mmap(struct file *file, unsigned long prot)
 {
 	return 0;
 }
+
 #endif /* CONFIG_IMA_H */
+
+#ifdef CONFIG_IMA_APPRAISE
+extern void ima_inode_post_setattr(struct dentry *dentry);
+#else
+static inline void ima_inode_post_setattr(struct dentry *dentry)
+{
+	return;
+}
+#endif /* CONFIG_IMA_APPRAISE_H */
 #endif /* _LINUX_IMA_H */
-- 
1.7.6.5

