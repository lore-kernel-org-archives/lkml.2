Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab1IHHMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 03:12:32 -0400
Received: from mga12.intel.com ([143.182.124.36]:21278 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755856Ab1IHHMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 03:12:30 -0400
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH] Smack: check permissions from user space (v2)
Date: Thu,  8 Sep 2011 10:12:01 +0300
Message-Id: <1315465921-23136-1-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.4.1
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281, 00181 Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a new file into SmackFS called 'access'. Wanted
Smack permission is written into /smack/access.
After that result can be read from the opened file.
If access applies result contains 1 and otherwise
0. File access is protected from race conditions
by using simple_transaction_get()/set() API.

Fixes from the previous version:
- Removed smack.h changes, refactoring left-over
from previous version.
- Removed #include <linux/smack.h>, refactoring
left-over from previous version.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
---
 security/smack/smackfs.c |  180 ++++++++++++++++++++++++++++++----------------
 1 files changed, 117 insertions(+), 63 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index f934601..f4c28ee 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -44,6 +44,7 @@ enum smk_inos {
 	SMK_ONLYCAP	= 9,	/* the only "capable" label */
 	SMK_LOGGING	= 10,	/* logging */
 	SMK_LOAD_SELF	= 11,	/* task specific rules */
+	SMK_ACCESSES	= 12,	/* access policy */
 };
 
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
 	}
 
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
+	}
+
+	if (smk_parse_rule(data, rule))
+		goto out_free_rule;
+
 	rc = count;
 	/*
 	 * smk_set_access returns true if there was already a rule
@@ -1425,6 +1439,44 @@ static const struct file_operations smk_load_self_ops = {
 	.write		= smk_write_load_self,
 	.release        = seq_release,
 };
+
+/**
+ * smk_write_access - handle access check transaction
+ * @file: file pointer
+ * @buf: data from user space
+ * @count: bytes sent
+ * @ppos: where to start - must be 0
+ */
+static ssize_t smk_write_access(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct smack_rule rule;
+	char *data;
+
+	if (!capable(CAP_MAC_ADMIN))
+		return -EPERM;
+
+	data = simple_transaction_get(file, buf, count);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	if (count < SMK_LOADLEN || smk_parse_rule(data, &rule))
+		return -EINVAL;
+
+	data[0] = smk_access(rule.smk_subject, rule.smk_object,
+			     rule.smk_access, NULL) == 0;
+
+	simple_transaction_set(file, 1);
+	return SMK_LOADLEN;
+}
+
+static const struct file_operations smk_access_ops = {
+	.write		= smk_write_access,
+	.read		= simple_transaction_read,
+	.release	= simple_transaction_release,
+	.llseek		= generic_file_llseek,
+};
+
 /**
  * smk_fill_super - fill the /smackfs superblock
  * @sb: the empty superblock
@@ -1459,6 +1511,8 @@ static int smk_fill_super(struct super_block *sb, void *data, int silent)
 			"logging", &smk_logging_ops, S_IRUGO|S_IWUSR},
 		[SMK_LOAD_SELF] = {
 			"load-self", &smk_load_self_ops, S_IRUGO|S_IWUGO},
+		[SMK_ACCESSES] = {
+			"access", &smk_access_ops, S_IRUGO|S_IWUSR},
 		/* last one */
 			{""}
 	};
-- 
1.7.4.1

