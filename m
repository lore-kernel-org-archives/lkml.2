Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705Ab2K1RoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:44:08 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34458 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab2K1RoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:44:01 -0500
From: Rafal Krypa <r.krypa@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rafal Krypa <r.krypa@samsung.com>
Subject: [PATCH] Smack: add support for modification of existing rules
Date: Wed, 28 Nov 2012 18:43:29 +0100
Message-id: <1354124609-16829-2-git-send-email-r.krypa@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1354124609-16829-1-git-send-email-r.krypa@samsung.com>
References: <1354124609-16829-1-git-send-email-r.krypa@samsung.com>
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
 security/smack/smackfs.c         |  249 ++++++++++++++++++++++++++------------
 2 files changed, 181 insertions(+), 79 deletions(-)

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
index 76a5dca..486c6d8 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -50,12 +50,12 @@ enum smk_inos {
 	SMK_ACCESS2	= 16,	/* make an access check with long labels */
 	SMK_CIPSO2	= 17,	/* load long label -> CIPSO mapping */
 	SMK_REVOKE_SUBJ	= 18,	/* set rules with subject label to '-' */
+	SMK_CHANGE_RULE	= 19,	/* change or add rules (long labels) */
 };
 
 /*
  * List locks
  */
-static DEFINE_MUTEX(smack_list_lock);
 static DEFINE_MUTEX(smack_cipso_lock);
 static DEFINE_MUTEX(smack_ambient_lock);
 static DEFINE_MUTEX(smk_netlbladdr_lock);
@@ -110,6 +110,13 @@ struct smack_master_list {
 
 LIST_HEAD(smack_rule_list);
 
+struct smack_parsed_rule {
+	char			*smk_subject;
+	char			*smk_object;
+	int			smk_access1;
+	int			smk_access2;
+};
+
 static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
 
 const char *smack_cipso_option = SMACK_CIPSO_OPTION;
@@ -167,25 +174,28 @@ static void smk_netlabel_audit_set(struct netlbl_audit *nap)
 #define SMK_NETLBLADDRMIN	9
 
 /**
- * smk_set_access - add a rule to the rule list
- * @srp: the new rule to add
+ * smk_set_access - add a rule to the rule list or replace an old rule
+ * @srp: the rule to add or replace
  * @rule_list: the list of rules
  * @rule_lock: the rule list lock
+ * @global: if non-zero, indicates a global rule
  *
  * Looks through the current subject/object/access list for
  * the subject/object pair and replaces the access that was
  * there. If the pair isn't found add it with the specified
  * access.
  *
- * Returns 1 if a rule was found to exist already, 0 if it is new
  * Returns 0 if nothing goes wrong or -ENOMEM if it fails
  * during the allocation of the new pair to add.
  */
-static int smk_set_access(struct smack_rule *srp, struct list_head *rule_list,
-				struct mutex *rule_lock)
+static int smk_set_access(struct smack_parsed_rule *srp,
+				struct list_head *rule_list,
+				struct mutex *rule_lock, int global)
 {
 	struct smack_rule *sp;
+	struct smack_master_list *smlp;
 	int found = 0;
+	int rc = 0;
 
 	mutex_lock(rule_lock);
 
@@ -197,23 +207,89 @@ static int smk_set_access(struct smack_rule *srp, struct list_head *rule_list,
 		if (sp->smk_object == srp->smk_object &&
 		    sp->smk_subject == srp->smk_subject) {
 			found = 1;
-			sp->smk_access = srp->smk_access;
+			sp->smk_access |= srp->smk_access1;
+			sp->smk_access &= ~srp->smk_access2;
 			break;
 		}
 	}
-	if (found == 0)
-		list_add_rcu(&srp->list, rule_list);
 
+	if (found == 0) {
+		sp = kzalloc(sizeof(*sp), GFP_KERNEL);
+		if (sp == NULL) {
+			rc = -ENOMEM;
+			goto out;
+		}
+
+		sp->smk_subject = srp->smk_subject;
+		sp->smk_object = srp->smk_object;
+		sp->smk_access = srp->smk_access1 & ~srp->smk_access2;
+
+		list_add_rcu(&sp->list, rule_list);
+		/*
+		 * If this is a global as opposed to self and a new rule
+		 * it needs to get added for reporting.
+		 */
+		if (global) {
+			smlp = kzalloc(sizeof(*smlp), GFP_KERNEL);
+			if (smlp != NULL) {
+				smlp->smk_rule = sp;
+				list_add_rcu(&smlp->list, &smack_rule_list);
+			} else
+				rc = -ENOMEM;
+		}
+	}
+
+out:
 	mutex_unlock(rule_lock);
+	return rc;
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
 
-	return found;
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
@@ -221,8 +297,9 @@ static int smk_set_access(struct smack_rule *srp, struct list_head *rule_list,
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
@@ -255,36 +332,11 @@ static int smk_fill_rule(const char *subject, const char *object,
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
+	rule->smk_access1 = smk_perm_from_str(access1);
+	if (access2)
+		rule->smk_access2 = smk_perm_from_str(access2);
+	else
+		rule->smk_access2 = ~rule->smk_access1;
 
 	return 0;
 }
@@ -297,30 +349,33 @@ static int smk_fill_rule(const char *subject, const char *object,
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
+ * @change: if non-zero, data is from /smack/change-rule
  *
  * Returns 0 on success, -1 on failure
  */
-static int smk_parse_long_rule(const char *data, struct smack_rule *rule,
-				int import)
+static int smk_parse_long_rule(const char *data, struct smack_parsed_rule *rule,
+				int import, int change)
 {
 	char *subject;
 	char *object;
-	char *access;
+	char *access1;
+	char *access2;
 	int datalen;
 	int rc = -1;
 
@@ -334,14 +389,27 @@ static int smk_parse_long_rule(const char *data, struct smack_rule *rule,
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
+	if (change) {
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
@@ -351,6 +419,7 @@ free_out_s:
 
 #define SMK_FIXED24_FMT	0	/* Fixed 24byte label format */
 #define SMK_LONG_FMT	1	/* Variable long label format */
+#define SMK_CHANGE_FMT	2	/* Rule modification format */
 /**
  * smk_write_rules_list - write() for any /smack rule file
  * @file: file pointer, not actually used
@@ -359,22 +428,24 @@ free_out_s:
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
 					struct list_head *rule_list,
 					struct mutex *rule_lock, int format)
 {
-	struct smack_master_list *smlp;
 	struct smack_known *skp;
-	struct smack_rule *rule;
+	struct smack_parsed_rule *rule;
 	char *data;
 	int datalen;
 	int rc = -EINVAL;
@@ -417,7 +488,11 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
 		 * Be sure the data string is terminated.
 		 */
 		data[count] = '\0';
-		if (smk_parse_long_rule(data, rule, 1))
+		if (smk_parse_long_rule(data, rule, 1, 0))
+			goto out_free_rule;
+	} else if (format == SMK_CHANGE_FMT) {
+		data[count] = '\0';
+		if (smk_parse_long_rule(data, rule, 1, 1))
 			goto out_free_rule;
 	} else {
 		/*
@@ -437,22 +512,9 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
 		rule_lock = &skp->smk_rules_lock;
 	}
 
-	rc = count;
-	/*
-	 * If this is a global as opposed to self and a new rule
-	 * it needs to get added for reporting.
-	 * smk_set_access returns true if there was already a rule
-	 * for the subject/object pair, and false if it was new.
-	 */
-	if (!smk_set_access(rule, rule_list, rule_lock)) {
-		if (load) {
-			smlp = kzalloc(sizeof(*smlp), GFP_KERNEL);
-			if (smlp != NULL) {
-				smlp->smk_rule = rule;
-				list_add_rcu(&smlp->list, &smack_rule_list);
-			} else
-				rc = -ENOMEM;
-		}
+	rc = smk_set_access(rule, rule_list, rule_lock, load);
+	if (rc == 0) {
+		rc = count;
 		goto out;
 	}
 
@@ -1774,7 +1836,7 @@ static const struct file_operations smk_load_self_ops = {
 static ssize_t smk_user_access(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos, int format)
 {
-	struct smack_rule rule;
+	struct smack_parsed_rule rule;
 	char *data;
 	char *cod;
 	int res;
@@ -1796,14 +1858,14 @@ static ssize_t smk_user_access(struct file *file, const char __user *buf,
 			return -ENOMEM;
 		memcpy(cod, data, count);
 		cod[count] = '\0';
-		res = smk_parse_long_rule(cod, &rule, 0);
+		res = smk_parse_long_rule(cod, &rule, 0, 0);
 		kfree(cod);
 	}
 
 	if (res)
 		return -EINVAL;
 
-	res = smk_access(rule.smk_subject, rule.smk_object, rule.smk_access,
+	res = smk_access(rule.smk_subject, rule.smk_object, rule.smk_access1,
 			  NULL);
 	data[0] = res == 0 ? '1' : '0';
 	data[1] = '\0';
@@ -2077,6 +2139,33 @@ static int smk_init_sysfs(void)
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
@@ -2125,6 +2214,8 @@ static int smk_fill_super(struct super_block *sb, void *data, int silent)
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

