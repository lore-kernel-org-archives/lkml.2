Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab0DUVvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:51:44 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:55063 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624Ab0DUVvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:51:40 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 12/14] ima: appraise default rules
Date: Wed, 21 Apr 2010 17:49:52 -0400
Message-Id: <1271886594-3719-13-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike the IMA measurement policy, the appraise policy can not be
dependent on runtime process information, such as the task uid,
as the 'security.ima' xattr is written on file close and must
be updated each time the file changes, regardless of the current
task uid. The appraise default policy appraises all files owned
by root.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index aabd615..7cc028d 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -122,6 +122,8 @@ void iint_rcu_free(struct rcu_head *rcu);
 enum ima_hooks { FILE_CHECK = 1, FILE_MMAP, BPRM_CHECK, POST_SETATTR };
 
 int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask);
+int ima_match_appraise_policy(struct inode *inode, enum ima_hooks func,
+			      int mask);
 void ima_init_policy(void);
 void ima_update_policy(void);
 ssize_t ima_parse_add_rule(char *);
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 0afb1b4..ad8e0ac 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -28,7 +28,19 @@ __setup("ima_appraise=", default_appraise_setup);
 int ima_must_appraise(struct integrity_iint_cache *iint, struct inode *inode,
 		      enum ima_hooks func, int mask)
 {
-	return 0;
+	int must_appraise, rc = 0;
+
+	if (!ima_appraise || !inode->i_op->getxattr)
+		return 0;
+	else if (iint->flags & IMA_APPRAISED)
+		return 0;
+
+	must_appraise = ima_match_appraise_policy(inode, func, mask);
+	if (must_appraise) {
+		iint->flags |= IMA_APPRAISE;
+		rc = 1;
+	}
+	return rc;
 }
 
 static void ima_fix_xattr(struct dentry *dentry,
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 778a735..7c9f15a 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -23,8 +23,11 @@
 #define IMA_MASK 	0x0002
 #define IMA_FSMAGIC	0x0004
 #define IMA_UID		0x0008
+#define IMA_OWNER	0x0010
 
-enum ima_action { UNKNOWN = -1, DONT_MEASURE = 0, MEASURE };
+enum ima_action { UNKNOWN = -1,
+		  DONT_MEASURE = 0, MEASURE,
+		  DONT_APPRAISE, APPRAISE};
 
 #define MAX_LSM_RULES 6
 enum lsm_rule_types { LSM_OBJ_USER, LSM_OBJ_ROLE, LSM_OBJ_TYPE,
@@ -39,6 +42,7 @@ struct ima_measure_rule_entry {
 	int mask;
 	unsigned long fsmagic;
 	uid_t uid;
+	uid_t owner;
 	struct {
 		void *rule;	/* LSM file metadata specific */
 		int type;	/* audit type */
@@ -47,7 +51,7 @@ struct ima_measure_rule_entry {
 
 /*
  * Without LSM specific knowledge, the default policy can only be
- * written in terms of .action, .func, .mask, .fsmagic, and .uid
+ * written in terms of .action, .func, .mask, .fsmagic, .uid, and .owner
  */
 
 /*
@@ -69,6 +73,13 @@ static struct ima_measure_rule_entry default_rules[] = {
 	 .flags = IMA_FUNC | IMA_MASK},
 	{.action = MEASURE,.func = FILE_CHECK,.mask = MAY_READ,.uid = 0,
 	 .flags = IMA_FUNC | IMA_MASK | IMA_UID},
+	{.action = DONT_APPRAISE,.fsmagic = PROC_SUPER_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE,.fsmagic = SYSFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE,.fsmagic = DEBUGFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE,.fsmagic = TMPFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE,.fsmagic = SECURITYFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE,.fsmagic = SELINUX_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = APPRAISE,.owner = 0,.flags = IMA_OWNER},
 };
 
 static LIST_HEAD(measure_default_rules);
@@ -109,6 +120,8 @@ static bool ima_match_rules(struct ima_measure_rule_entry *rule,
 		return false;
 	if ((rule->flags & IMA_UID) && rule->uid != tsk->cred->uid)
 		return false;
+	if ((rule->flags & IMA_OWNER) && rule->owner != inode->i_uid)
+		return false;
 	for (i = 0; i < MAX_LSM_RULES; i++) {
 		int rc = 0;
 		u32 osid, sid;
@@ -165,6 +178,9 @@ int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask)
 	list_for_each_entry(entry, ima_measure, list) {
 		bool rc;
 
+		if ((entry->action == APPRAISE) ||
+		    (entry->action == DONT_APPRAISE))
+			continue;
 		rc = ima_match_rules(entry, inode, func, mask);
 		if (rc)
 			return entry->action;
@@ -172,6 +188,28 @@ int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask)
 	return 0;
 }
 
+int ima_match_appraise_policy(struct inode *inode, enum ima_hooks func,
+			      int mask)
+{
+	struct ima_measure_rule_entry *entry;
+
+	list_for_each_entry(entry, ima_measure, list) {
+		bool rc;
+
+		if ((entry->action == MEASURE) ||
+		    (entry->action == DONT_MEASURE))
+			continue;
+		rc = ima_match_rules(entry, inode, func, mask);
+		if (rc) {
+			if (entry->action == DONT_APPRAISE)
+				return 0;
+			if (entry->action == APPRAISE)
+				return 1;
+		}
+	}
+	return 0;
+}
+
 /**
  * ima_init_policy - initialize the default measure rules.
  *
@@ -219,6 +257,7 @@ void ima_update_policy(void)
 enum {
 	Opt_err = -1,
 	Opt_measure = 1, Opt_dont_measure,
+	Opt_appraise, Opt_dont_appraise,
 	Opt_obj_user, Opt_obj_role, Opt_obj_type,
 	Opt_subj_user, Opt_subj_role, Opt_subj_type,
 	Opt_func, Opt_mask, Opt_fsmagic, Opt_uid
@@ -227,6 +266,8 @@ enum {
 static match_table_t policy_tokens = {
 	{Opt_measure, "measure"},
 	{Opt_dont_measure, "dont_measure"},
+	{Opt_appraise, "appraise"},
+	{Opt_dont_appraise, "dont_appraise"},
 	{Opt_obj_user, "obj_user=%s"},
 	{Opt_obj_role, "obj_role=%s"},
 	{Opt_obj_type, "obj_type=%s"},
@@ -299,6 +340,22 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
 
 			entry->action = DONT_MEASURE;
 			break;
+		case Opt_appraise:
+			ima_log_string(ab, "%s ", "appraise");
+
+			if (entry->action != UNKNOWN)
+				result = -EINVAL;
+
+			entry->action = APPRAISE;
+			break;
+		case Opt_dont_appraise:
+			ima_log_string(ab, "%s ", "dont_appraise");
+
+			if (entry->action != UNKNOWN)
+				result = -EINVAL;
+
+			entry->action = DONT_APPRAISE;
+			break;
 		case Opt_func:
 			ima_log_string(ab, "func", args[0].from);
 
-- 
1.6.6.1

