Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab2K0RlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 12:41:13 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59333 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab2K0Rkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 12:40:40 -0500
From: Rafal Krypa <r.krypa@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rafal Krypa <r.krypa@samsung.com>
Subject: [PATCH 3/3] Smack: add support for modification of existing rules
Date: Tue, 27 Nov 2012 18:40:21 +0100
Message-id: <1354038021-28324-4-git-send-email-r.krypa@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1354038021-28324-1-git-send-email-r.krypa@samsung.com>
References: <1354038021-28324-1-git-send-email-r.krypa@samsung.com>
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rule modifications are enabled via /smack/change-rule. Format is as follows:
"Subject Object rwaxt rwaxt"

First two strings are subject and object labels up to 255 characters.
Third string contains permissions to enable.
Fourth string contains permissions to disable.

All unmentioned permissions will be left unchanged.
If no rule previously existed, it will be created.

Targeted for git://git.gitorious.org/smack-next/kernel.git

Signed-off-by: Rafal Krypa <r.krypa@samsung.com>
---
 Documentation/security/Smack.txt |   11 ++
 security/smack/smackfs.c         |  219 +++++++++++++++++++++++++++-----------
 2 files changed, 169 insertions(+), 61 deletions(-)

diff --git a/Documentation/security/Smack.txt b/Documentation/security/Smack.txt
index 8a177e4..7a2d30c 100644
--- a/Documentation/security/Smack.txt
+++ b/Documentation/security/Smack.txt
@@ -117,6 +117,17 @@ access2
 ambient
 	This contains the Smack label applied to unlabeled network
 	packets.
+change-rule
+	This interface allows modification of existing access control rules.
+	The format accepted on write is:
+		"%s %s %s %s"
+	where the first string is the subject label, the second the
+	object label, the third the access to allow and the fourth the
+	access to deny. The access strings may contain only the characters
+	"rwxat-". If a rule for a given subject and object exists it will be
+	modified by enabling the permissions in the third string and disabling
+	those in the fourth string. If there is no such rule it will be
+	created using the access specified in the third and the fourth strings.
 cipso
 	This interface allows a specific CIPSO header to be assigned
 	to a Smack label. The format accepted on write is:
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 5337270..1cc659d 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -50,6 +50,7 @@ enum smk_inos {
 	SMK_ACCESS2	= 16,	/* make an access check with long labels */
 	SMK_CIPSO2	= 17,	/* load long label -> CIPSO mapping */
 	SMK_REVOKE_SUBJ	= 18,	/* set rules with subject label to '-' */
+	SMK_CHANGE_RULE	= 19,	/* change or add rules (long labels) */
 };
 
 /*
@@ -105,6 +106,14 @@ struct smack_seq_iter {
 	struct smack_rule *srp;
 };
 
+struct smack_parsed_rule {
+	char			*smk_subject;
+	char			*smk_object;
+	int			smk_access1;
+	int			smk_access2;
+	int			is_modify;
+};
+
 static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
 
 const char *smack_cipso_option = SMACK_CIPSO_OPTION;
@@ -162,8 +171,8 @@ static void smk_netlabel_audit_set(struct netlbl_audit *nap)
 #define SMK_NETLBLADDRMIN	9
 
 /**
- * smk_set_access - add a rule to the rule list
- * @srp: the new rule to add
+ * smk_set_access - add a rule to the rule list or replace an old rule
+ * @srp: the rule to add or replace
  * @rule_list: the list of rules
  * @rule_lock: the rule list lock
  *
@@ -172,16 +181,24 @@ static void smk_netlabel_audit_set(struct netlbl_audit *nap)
  * there. If the pair isn't found add it with the specified
  * access.
  *
- * Returns 1 if a rule was found to exist already, 0 if it is new
  * Returns 0 if nothing goes wrong or -ENOMEM if it fails
  * during the allocation of the new pair to add.
  */
-static int smk_set_access(struct smack_rule *srp, struct list_head *rule_list,
+static int smk_set_access(struct smack_parsed_rule *srp,
+				struct list_head *rule_list,
 				struct mutex *rule_lock)
 {
 	struct smack_rule *sp;
+	struct smack_rule *snp;
 	int found = 0;
 
+	snp = kzalloc(sizeof(*snp), GFP_KERNEL);
+	if (snp == NULL)
+		return -ENOMEM;
+
+	snp->smk_subject = srp->smk_subject;
+	snp->smk_object = srp->smk_object;
+
 	mutex_lock(rule_lock);
 
 	/*
@@ -192,23 +209,78 @@ static int smk_set_access(struct smack_rule *srp, struct list_head *rule_list,
 		if (sp->smk_object == srp->smk_object &&
 		    sp->smk_subject == srp->smk_subject) {
 			found = 1;
-			sp->smk_access = srp->smk_access;
+			snp->smk_access = sp->smk_access;
 			break;
 		}
 	}
+
+	if (srp->is_modify) {
+		snp->smk_access |= srp->smk_access1;
+		snp->smk_access &= ~srp->smk_access2;
+	} else {
+		snp->smk_access = srp->smk_access1;
+	}
+
 	if (found == 0)
-		list_add_rcu(&srp->list, rule_list);
+		list_add_rcu(&snp->list, rule_list);
+	else
+		list_replace_rcu(&sp->list, &snp->list);
+
+	synchronize_rcu();
+	if (found == 1)
+		kfree(sp);
 
 	mutex_unlock(rule_lock);
 
-	return found;
+	return 0;
+}
+
+/**
+ * smk_perm_from_str - parse smack accesses from a text string
+ * @string: a text string that contains a Smack accesses code
+ *
+ * Returns an integer with respective bits set for specified accesses.
+ */
+static int smk_perm_from_str(const char *string)
+{
+	int perm = 0;
+	const char *cp;
+
+	for (cp = string; ; cp++)
+		switch (*cp) {
+		case '-':
+			break;
+		case 'r':
+		case 'R':
+			perm |= MAY_READ;
+			break;
+		case 'w':
+		case 'W':
+			perm |= MAY_WRITE;
+			break;
+		case 'x':
+		case 'X':
+			perm |= MAY_EXEC;
+			break;
+		case 'a':
+		case 'A':
+			perm |= MAY_APPEND;
+			break;
+		case 't':
+		case 'T':
+			perm |= MAY_TRANSMUTE;
+			break;
+		default:
+			return perm;
+		}
 }
 
 /**
  * smk_fill_rule - Fill Smack rule from strings
  * @subject: subject label string
  * @object: object label string
- * @access: access string
+ * @access1: access string
+ * @access2: string with permissions to be removed
  * @rule: Smack rule
  * @import: if non-zero, import labels
  * @len: label length limit
@@ -216,8 +288,9 @@ static int smk_set_access(struct smack_rule *srp, struct list_head *rule_list,
  * Returns 0 on success, -1 on failure
  */
 static int smk_fill_rule(const char *subject, const char *object,
-				const char *access, struct smack_rule *rule,
-				int import, int len)
+				const char *access1, const char *access2,
+				struct smack_parsed_rule *rule, int import,
+				int len)
 {
 	const char *cp;
 	struct smack_known *skp;
@@ -250,36 +323,11 @@ static int smk_fill_rule(const char *subject, const char *object,
 		rule->smk_object = skp->smk_known;
 	}
 
-	rule->smk_access = 0;
-
-	for (cp = access; *cp != '\0'; cp++) {
-		switch (*cp) {
-		case '-':
-			break;
-		case 'r':
-		case 'R':
-			rule->smk_access |= MAY_READ;
-			break;
-		case 'w':
-		case 'W':
-			rule->smk_access |= MAY_WRITE;
-			break;
-		case 'x':
-		case 'X':
-			rule->smk_access |= MAY_EXEC;
-			break;
-		case 'a':
-		case 'A':
-			rule->smk_access |= MAY_APPEND;
-			break;
-		case 't':
-		case 'T':
-			rule->smk_access |= MAY_TRANSMUTE;
-			break;
-		default:
-			return 0;
-		}
-	}
+	if (rule->is_modify) {
+		rule->smk_access1 = smk_perm_from_str(access1);
+		rule->smk_access2 = smk_perm_from_str(access2);
+	} else
+		rule->smk_access1 = smk_perm_from_str(access1);
 
 	return 0;
 }
@@ -292,30 +340,32 @@ static int smk_fill_rule(const char *subject, const char *object,
  *
  * Returns 0 on success, -1 on errors.
  */
-static int smk_parse_rule(const char *data, struct smack_rule *rule, int import)
+static int smk_parse_rule(const char *data, struct smack_parsed_rule *rule,
+				int import)
 {
 	int rc;
 
 	rc = smk_fill_rule(data, data + SMK_LABELLEN,
-			   data + SMK_LABELLEN + SMK_LABELLEN, rule, import,
-			   SMK_LABELLEN);
+			   data + SMK_LABELLEN + SMK_LABELLEN, NULL, rule,
+			   import, SMK_LABELLEN);
 	return rc;
 }
 
 /**
  * smk_parse_long_rule - parse Smack rule from rule string
  * @data: string to be parsed, null terminated
- * @rule: Smack rule
+ * @rule: Will be filled with Smack parsed rule
  * @import: if non-zero, import labels
  *
  * Returns 0 on success, -1 on failure
  */
-static int smk_parse_long_rule(const char *data, struct smack_rule *rule,
+static int smk_parse_long_rule(const char *data, struct smack_parsed_rule *rule,
 				int import)
 {
 	char *subject;
 	char *object;
-	char *access;
+	char *access1;
+	char *access2;
 	int datalen;
 	int rc = -1;
 
@@ -329,14 +379,27 @@ static int smk_parse_long_rule(const char *data, struct smack_rule *rule,
 	object = kzalloc(datalen, GFP_KERNEL);
 	if (object == NULL)
 		goto free_out_s;
-	access = kzalloc(datalen, GFP_KERNEL);
-	if (access == NULL)
+	access1 = kzalloc(datalen, GFP_KERNEL);
+	if (access1 == NULL)
 		goto free_out_o;
+	access2 = kzalloc(datalen, GFP_KERNEL);
+	if (access2 == NULL)
+		goto free_out_a;
+
+	if (rule->is_modify) {
+		if (sscanf(data, "%s %s %s %s",
+			subject, object, access1, access2) == 4)
+			rc = smk_fill_rule(subject, object, access1, access2,
+				rule, import, 0);
+	} else {
+		if (sscanf(data, "%s %s %s", subject, object, access1) == 3)
+			rc = smk_fill_rule(subject, object, access1, NULL,
+				rule, import, 0);
+	}
 
-	if (sscanf(data, "%s %s %s", subject, object, access) == 3)
-		rc = smk_fill_rule(subject, object, access, rule, import, 0);
-
-	kfree(access);
+	kfree(access2);
+free_out_a:
+	kfree(access1);
 free_out_o:
 	kfree(object);
 free_out_s:
@@ -346,6 +409,7 @@ free_out_s:
 
 #define SMK_FIXED24_FMT	0	/* Fixed 24byte label format */
 #define SMK_LONG_FMT	1	/* Variable long label format */
+#define SMK_CHANGE_FMT	2	/* Rule modification format */
 /**
  * smk_write_rules_list - write() for any /smack rule file
  * @file: file pointer, not actually used
@@ -354,13 +418,16 @@ free_out_s:
  * @ppos: where to start - must be 0
  * @rule_list: the list of rules to write to
  * @rule_lock: lock for the rule list
- * @format: /smack/load or /smack/load2 format.
+ * @format: /smack/load or /smack/load2 or /smack/change-rule format.
  *
  * Get one smack access rule from above.
  * The format for SMK_LONG_FMT is:
  *	"subject<whitespace>object<whitespace>access[<whitespace>...]"
  * The format for SMK_FIXED24_FMT is exactly:
  *	"subject                 object                  rwxat"
+ * The format for SMK_CHANGE_FMT is:
+ *	"subject<whitespace>object<whitespace>
+ *	 acc_enable<whitespace>acc_disable[<whitespace>...]"
  */
 static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
 					size_t count, loff_t *ppos,
@@ -368,7 +435,7 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
 					struct mutex *rule_lock, int format)
 {
 	struct smack_known *skp;
-	struct smack_rule *rule;
+	struct smack_parsed_rule *rule;
 	char *data;
 	int datalen;
 	int rc = -EINVAL;
@@ -405,7 +472,9 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
 		goto out;
 	}
 
-	if (format == SMK_LONG_FMT) {
+	if (format != SMK_FIXED24_FMT) {
+		if (format == SMK_CHANGE_FMT)
+			rule->is_modify = 1;
 		/*
 		 * Be sure the data string is terminated.
 		 */
@@ -422,16 +491,15 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
 			goto out_free_rule;
 	}
 
-
 	if (rule_list == NULL) {
 		skp = smk_find_entry(rule->smk_subject);
 		rule_list = &skp->smk_rules;
 		rule_lock = &skp->smk_rules_lock;
 	}
 
-	rc = count;
-	if (!smk_set_access(rule, rule_list, rule_lock))
-		goto out;
+	rc = smk_set_access(rule, rule_list, rule_lock);
+	if (rc == 0)
+		rc = count;
 
 out_free_rule:
 	kfree(rule);
@@ -1773,7 +1841,7 @@ static const struct file_operations smk_load_self_ops = {
 static ssize_t smk_user_access(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos, int format)
 {
-	struct smack_rule rule;
+	struct smack_parsed_rule rule;
 	char *data;
 	char *cod;
 	int res;
@@ -1802,7 +1870,7 @@ static ssize_t smk_user_access(struct file *file, const char __user *buf,
 	if (res)
 		return -EINVAL;
 
-	res = smk_access(rule.smk_subject, rule.smk_object, rule.smk_access,
+	res = smk_access(rule.smk_subject, rule.smk_object, rule.smk_access1,
 			  NULL);
 	data[0] = res == 0 ? '1' : '0';
 	data[1] = '\0';
@@ -2074,6 +2142,33 @@ static int smk_init_sysfs(void)
 }
 
 /**
+ * smk_write_change_rule - write() for /smack/change-rule
+ * @file: file pointer
+ * @buf: data from user space
+ * @count: bytes sent
+ * @ppos: where to start - must be 0
+ */
+static ssize_t smk_write_change_rule(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	/*
+	 * Must have privilege.
+	 */
+	if (!capable(CAP_MAC_ADMIN))
+		return -EPERM;
+
+	return smk_write_rules_list(file, buf, count, ppos, NULL, NULL,
+				    SMK_CHANGE_FMT);
+}
+
+static const struct file_operations smk_change_rule_ops = {
+	.write		= smk_write_change_rule,
+	.read		= simple_transaction_read,
+	.release	= simple_transaction_release,
+	.llseek		= generic_file_llseek,
+};
+
+/**
  * smk_fill_super - fill the /smackfs superblock
  * @sb: the empty superblock
  * @data: unused
@@ -2122,6 +2217,8 @@ static int smk_fill_super(struct super_block *sb, void *data, int silent)
 		[SMK_REVOKE_SUBJ] = {
 			"revoke-subject", &smk_revoke_subj_ops,
 			S_IRUGO|S_IWUSR},
+		[SMK_CHANGE_RULE] = {
+			"change-rule", &smk_change_rule_ops, S_IRUGO|S_IWUSR},
 		/* last one */
 			{""}
 	};
-- 
1.7.10.4

