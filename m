Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab1HZFwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 01:52:38 -0400
Received: from mga06.intel.com ([134.134.136.21]:61597 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752307Ab1HZFwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 01:52:36 -0400
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH] Smack: SMACK_IOCLOADACCESS
Date: Fri, 26 Aug 2011 08:52:07 +0300
Message-Id: <1314337927-17210-1-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.4.1
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281, 00181 Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOCTL call for /smack/load that takes access rule in
the same format as they are written into /smack/load.
Sets errno to zero if access is allowed and to EACCES
if not.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
---
 include/linux/smack.h    |   29 ++++++++
 security/smack/smack.h   |    1 +
 security/smack/smackfs.c |  173 +++++++++++++++++++++++++++++-----------------
 3 files changed, 140 insertions(+), 63 deletions(-)
 create mode 100644 include/linux/smack.h

diff --git a/include/linux/smack.h b/include/linux/smack.h
new file mode 100644
index 0000000..c574713
--- /dev/null
+++ b/include/linux/smack.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright (c) 2011, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public License
+ * as published by the Free Software Foundation; either version 2.1
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ *
+ * Author:
+ *      Jarkko Sakkinen <jarkko.sakkinen@intel.com>
+ *
+ */
+
+#ifndef _SMACK_H
+#define _SMACK_H
+
+#define SMACK_IOC_BASE 'S'
+#define SMACK_IOC_LOAD_ACCESS _IOR(SMACK_IOC_BASE, 0, const char *)
+
+#endif /* _SMACK_H */
diff --git a/security/smack/smack.h b/security/smack/smack.h
index 2b6c6a5..82c5a30 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -189,6 +189,7 @@ struct smk_audit_info {
 	struct common_audit_data a;
 #endif
 };
+
 /*
  * These functions are in smack_lsm.c
  */
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index f934601..68168d0 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -27,6 +27,7 @@
 #include <linux/seq_file.h>
 #include <linux/ctype.h>
 #include <linux/audit.h>
+#include <linux/smack.h>
 #include "smack.h"
 
 /*
@@ -176,71 +177,19 @@ static int smk_set_access(struct smack_rule *srp, struct list_head *rule_list,
 }
 
 /**
- * smk_write_load_list - write() for any /smack/load
- * @file: file pointer, not actually used
- * @buf: where to get the data from
- * @count: bytes sent
- * @ppos: where to start - must be 0
- * @rule_list: the list of rules to write to
- * @rule_lock: lock for the rule list
- *
- * Get one smack access rule from above.
- * The format is exactly:
- *     char subject[SMK_LABELLEN]
- *     char object[SMK_LABELLEN]
- *     char access[SMK_ACCESSLEN]
- *
- * writes must be SMK_LABELLEN+SMK_LABELLEN+SMK_ACCESSLEN bytes.
+ * smk_parse_rule - parse subject, object and access type
+ * @data: string to be parsed whose size is SMK_LOADLEN
+ * @rule: parsed entities are stored in here
  */
-static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
-				size_t count, loff_t *ppos,
-				struct list_head *rule_list,
-				struct mutex *rule_lock)
+static int smk_parse_rule(const char *data, struct smack_rule *rule)
 {
-	struct smack_rule *rule;
-	char *data;
-	int rc = -EINVAL;
-
-	/*
-	 * No partial writes.
-	 * Enough data must be present.
-	 */
-	if (*ppos != 0)
-		return -EINVAL;
-	/*
-	 * Minor hack for backward compatibility
-	 */
-	if (count < (SMK_OLOADLEN) || count > SMK_LOADLEN)
-		return -EINVAL;
-
-	data = kzalloc(SMK_LOADLEN, GFP_KERNEL);
-	if (data == NULL)
-		return -ENOMEM;
-
-	if (copy_from_user(data, buf, count) != 0) {
-		rc = -EFAULT;
-		goto out;
-	}
-
-	/*
-	 * More on the minor hack for backward compatibility
-	 */
-	if (count == (SMK_OLOADLEN))
-		data[SMK_OLOADLEN] = '-';
-
-	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
-	if (rule == NULL) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
 	rule->smk_subject = smk_import(data, 0);
 	if (rule->smk_subject == NULL)
-		goto out_free_rule;
+		return -1;
 
 	rule->smk_object = smk_import(data + SMK_LABELLEN, 0);
 	if (rule->smk_object == NULL)
-		goto out_free_rule;
+		return -1;
 
 	rule->smk_access = 0;
 
@@ -252,7 +201,7 @@ static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
 		rule->smk_access |= MAY_READ;
 		break;
 	default:
-		goto out_free_rule;
+		return -1;
 	}
 
 	switch (data[SMK_LABELLEN + SMK_LABELLEN + 1]) {
@@ -263,7 +212,7 @@ static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
 		rule->smk_access |= MAY_WRITE;
 		break;
 	default:
-		goto out_free_rule;
+		return -1;
 	}
 
 	switch (data[SMK_LABELLEN + SMK_LABELLEN + 2]) {
@@ -274,7 +223,7 @@ static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
 		rule->smk_access |= MAY_EXEC;
 		break;
 	default:
-		goto out_free_rule;
+		return -1;
 	}
 
 	switch (data[SMK_LABELLEN + SMK_LABELLEN + 3]) {
@@ -285,7 +234,7 @@ static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
 		rule->smk_access |= MAY_APPEND;
 		break;
 	default:
-		goto out_free_rule;
+		return -1;
 	}
 
 	switch (data[SMK_LABELLEN + SMK_LABELLEN + 4]) {
@@ -296,9 +245,74 @@ static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
 		rule->smk_access |= MAY_TRANSMUTE;
 		break;
 	default:
-		goto out_free_rule;
+		return -1;
+	}
+
+	return 0;
+}
+
+/**
+ * smk_write_load_list - write() for any /smack/load
+ * @file: file pointer, not actually used
+ * @buf: where to get the data from
+ * @count: bytes sent
+ * @ppos: where to start - must be 0
+ * @rule_list: the list of rules to write to
+ * @rule_lock: lock for the rule list
+ *
+ * Get one smack access rule from above.
+ * The format is exactly:
+ *     char subject[SMK_LABELLEN]
+ *     char object[SMK_LABELLEN]
+ *     char access[SMK_ACCESSLEN]
+ *
+ * writes must be SMK_LABELLEN+SMK_LABELLEN+SMK_ACCESSLEN bytes.
+ */
+static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos,
+				struct list_head *rule_list,
+				struct mutex *rule_lock)
+{
+	struct smack_rule *rule;
+	char *data;
+	int rc = -EINVAL;
+
+	/*
+	 * No partial writes.
+	 * Enough data must be present.
+	 */
+	if (*ppos != 0)
+		return -EINVAL;
+	/*
+	 * Minor hack for backward compatibility
+	 */
+	if (count < (SMK_OLOADLEN) || count > SMK_LOADLEN)
+		return -EINVAL;
+
+	data = kzalloc(SMK_LOADLEN, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	if (copy_from_user(data, buf, count) != 0) {
+		rc = -EFAULT;
+		goto out;
+	}
+
+	/*
+	 * More on the minor hack for backward compatibility
+	 */
+	if (count == (SMK_OLOADLEN))
+		data[SMK_OLOADLEN] = '-';
+
+	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
+	if (rule == NULL) {
+		rc = -ENOMEM;
+		goto out;
 	}
 
+	if (smk_parse_rule(data, rule))
+		goto out_free_rule;
+
 	rc = count;
 	/*
 	 * smk_set_access returns true if there was already a rule
@@ -416,12 +430,45 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
 					&smack_list_lock);
 }
 
+/**
+ * smk_ioctl_load - ioctl() for /smack/load
+ * @file: file pointer, not actually used
+ * @cmd: IOCTL command
+ * @arg: IOCTL command argument
+ */
+static long smk_ioctl_load(struct file *file, unsigned int cmd,
+			   unsigned long arg)
+{
+	char data[SMK_LOADLEN];
+	struct smack_rule rule;
+
+	/* Currently we have only single IOCTL command supported */
+	if (cmd != SMACK_IOC_LOAD_ACCESS)
+		return -ENOTTY;
+
+	if (!capable(CAP_MAC_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(data, (const char __user *)arg, SMK_LOADLEN))
+		return -EFAULT;
+
+	if (smk_parse_rule(data, &rule))
+		return -EINVAL;
+
+	if (smk_access(rule.smk_subject, rule.smk_object,
+		       rule.smk_access, NULL) != 0)
+		return -EACCES;
+
+	return 0;
+}
+
 static const struct file_operations smk_load_ops = {
 	.open           = smk_open_load,
 	.read		= seq_read,
 	.llseek         = seq_lseek,
 	.write		= smk_write_load,
 	.release        = seq_release,
+	.unlocked_ioctl = smk_ioctl_load,
 };
 
 /**
-- 
1.7.4.1

