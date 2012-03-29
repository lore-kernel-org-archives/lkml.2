Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388Ab2C2Onq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 10:43:46 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:39250 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933261Ab2C2On0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 10:43:26 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v4 05/12] ima: add appraise action keywords and default rules
Date: Thu, 29 Mar 2012 10:41:33 -0400
Message-Id: <1333032100-4159-6-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1333032100-4159-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1333032100-4159-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032914-5518-0000-0000-0000034CAE39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike the IMA measurement policy, the appraise policy can not be dependent
on runtime process information, such as the task uid, as the 'security.ima'
xattr is written on file close and must be updated each time the file changes,
regardless of the current task uid.

This patch extends the policy language with 'fowner', defines an appraise
policy, which appraises all files owned by root, and defines 'ima_appraise_tcb',
a new boot command line option, to enable the appraise policy.

Changelog v3:
- separate the measure from the appraise rules in order to support measuring
  without appraising and appraising without measuring.
- change appraisal default for filesystems without xattr support to fail
- update default appraise policy for cgroups

Changelog v1:
- don't appraise RAMFS (Dmitry Kasatkin)
- merged rest of "ima: ima_must_appraise_or_measure API change" commit
  (Dmtiry Kasatkin)

  ima_must_appraise_or_measure() called ima_match_policy twice, which
  searched the policy for a matching rule.  Once for a matching measurement
  rule and subsequently for an appraisal rule. Searching the policy twice
  is unnecessary overhead, which could be noticeable with a large policy.

  The new version of ima_must_appraise_or_measure() does everything in a
  single iteration using a new version of ima_match_policy().  It returns
  IMA_MEASURE, IMA_APPRAISE mask.

  With the use of action mask only one efficient matching function
  is enough.  Removed other specific versions of matching functions.

Changelog:
- change 'owner' to 'fowner' to conform to the new LSM conditions posted by
  Roberto Sassu.
- fix calls to ima_log_string()

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 Documentation/ABI/testing/ima_policy  |   25 +++++-
 Documentation/kernel-parameters.txt   |    4 +
 security/integrity/ima/ima_appraise.c |    5 +-
 security/integrity/ima/ima_policy.c   |  149 ++++++++++++++++++++++++---------
 4 files changed, 139 insertions(+), 44 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index 6cd6dae..dcff822 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -12,11 +12,14 @@ Description:
 		then closing the file.  The new policy takes effect after
 		the file ima/policy is closed.
 
+		IMA appraisal, if configured, uses these file measurements
+		for local measurement appraisal.
+
 		rule format: action [condition ...]
 
-		action: measure | dont_measure
+		action: measure | dont_measure | appraise | dont_appraise
 		condition:= base | lsm
-			base:	[[func=] [mask=] [fsmagic=] [uid=]]
+			base:	[[func=] [mask=] [fsmagic=] [uid=] [fowner]]
 			lsm:	[[subj_user=] [subj_role=] [subj_type=]
 				 [obj_user=] [obj_role=] [obj_type=]]
 
@@ -24,36 +27,50 @@ Description:
 			mask:= [MAY_READ] [MAY_WRITE] [MAY_APPEND] [MAY_EXEC]
 			fsmagic:= hex value
 			uid:= decimal value
+			fowner:=decimal value
 		lsm:  	are LSM specific
 
 		default policy:
 			# PROC_SUPER_MAGIC
 			dont_measure fsmagic=0x9fa0
+			dont_appraise fsmagic=0x9fa0
 			# SYSFS_MAGIC
 			dont_measure fsmagic=0x62656572
+			dont_appraise fsmagic=0x62656572
 			# DEBUGFS_MAGIC
 			dont_measure fsmagic=0x64626720
+			dont_appraise fsmagic=0x64626720
 			# TMPFS_MAGIC
 			dont_measure fsmagic=0x01021994
+			dont_appraise fsmagic=0x01021994
+			# RAMFS_MAGIC
+			dont_measure fsmagic=0x858458f6
+			dont_appraise fsmagic=0x858458f6
 			# SECURITYFS_MAGIC
 			dont_measure fsmagic=0x73636673
+			dont_appraise fsmagic=0x73636673
 
 			measure func=BPRM_CHECK
 			measure func=FILE_MMAP mask=MAY_EXEC
 			measure func=FILE_CHECK mask=MAY_READ uid=0
+			appraise fowner=0
 
 		The default policy measures all executables in bprm_check,
 		all files mmapped executable in file_mmap, and all files
-		open for read by root in do_filp_open.
+		open for read by root in do_filp_open.  The default appraisal
+		policy appraises all files owned by root.
 
 		Examples of LSM specific definitions:
 
 		SELinux:
 			# SELINUX_MAGIC
-			dont_measure fsmagic=0xF97CFF8C
+			dont_measure fsmagic=0xf97cff8c
+			dont_appraise fsmagic=0xf97cff8c
 
 			dont_measure obj_type=var_log_t
+			dont_appraise obj_type=var_log_t
 			dont_measure obj_type=auditd_log_t
+			dont_appraise obj_type=auditd_log_t
 			measure subj_user=system_u func=FILE_CHECK mask=MAY_READ
 			measure subj_role=system_r func=FILE_CHECK mask=MAY_READ
 
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a86765d..6c00491 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1008,6 +1008,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Format: { "off" | "enforce" | "fix" }
 			default: "enforce"
 
+	ima_appraise_tcb [IMA]
+			The builtin appraise policy appraises all files
+			owned by uid=0.
+
 	ima_audit=	[IMA]
 			Format: { "0" | "1" }
 			0 -- integrity auditing messages. (Default)
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 4865f61..681cb6e 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -36,7 +36,10 @@ __setup("ima_appraise=", default_appraise_setup);
  */
 int ima_must_appraise(struct inode *inode, enum ima_hooks func, int mask)
 {
-	return 0;
+	if (!ima_appraise)
+		return 0;
+
+	return ima_match_policy(inode, func, mask, IMA_APPRAISE);
 }
 
 static void ima_fix_xattr(struct dentry *dentry,
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 8ee301c..238aa2b 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -24,6 +24,7 @@
 #define IMA_MASK 	0x0002
 #define IMA_FSMAGIC	0x0004
 #define IMA_UID		0x0008
+#define IMA_FOWNER	0x0010
 
 #define UNKNOWN			0
 #define MEASURE			1	/* same as IMA_MEASURE */
@@ -38,7 +39,7 @@ enum lsm_rule_types { LSM_OBJ_USER, LSM_OBJ_ROLE, LSM_OBJ_TYPE,
 	LSM_SUBJ_USER, LSM_SUBJ_ROLE, LSM_SUBJ_TYPE
 };
 
-struct ima_measure_rule_entry {
+struct ima_rule_entry {
 	struct list_head list;
 	int action;
 	unsigned int flags;
@@ -46,6 +47,7 @@ struct ima_measure_rule_entry {
 	int mask;
 	unsigned long fsmagic;
 	uid_t uid;
+	uid_t fowner;
 	struct {
 		void *rule;	/* LSM file metadata specific */
 		int type;	/* audit type */
@@ -54,7 +56,7 @@ struct ima_measure_rule_entry {
 
 /*
  * Without LSM specific knowledge, the default policy can only be
- * written in terms of .action, .func, .mask, .fsmagic, and .uid
+ * written in terms of .action, .func, .mask, .fsmagic, .uid, and .fowner
  */
 
 /*
@@ -63,7 +65,7 @@ struct ima_measure_rule_entry {
  * normal users can easily run the machine out of memory simply building
  * and running executables.
  */
-static struct ima_measure_rule_entry default_rules[] = {
+static struct ima_rule_entry default_rules[] = {
 	{.action = DONT_MEASURE,.fsmagic = PROC_SUPER_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = SYSFS_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = DEBUGFS_MAGIC,.flags = IMA_FSMAGIC},
@@ -79,19 +81,39 @@ static struct ima_measure_rule_entry default_rules[] = {
 	 .flags = IMA_FUNC | IMA_MASK | IMA_UID},
 };
 
-static LIST_HEAD(measure_default_rules);
-static LIST_HEAD(measure_policy_rules);
-static struct list_head *ima_measure;
+static struct ima_rule_entry default_appraise_rules[] = {
+	{.action = DONT_APPRAISE,.fsmagic = PROC_SUPER_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE,.fsmagic = SYSFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE,.fsmagic = DEBUGFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE,.fsmagic = TMPFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE,.fsmagic = RAMFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE,.fsmagic = SECURITYFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE,.fsmagic = SELINUX_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE,.fsmagic = CGROUP_SUPER_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = APPRAISE,.fowner = 0,.flags = IMA_FOWNER},
+};
+
+static LIST_HEAD(ima_default_rules);
+static LIST_HEAD(ima_policy_rules);
+static struct list_head *ima_rules;
 
-static DEFINE_MUTEX(ima_measure_mutex);
+static DEFINE_MUTEX(ima_rules_mutex);
 
 static bool ima_use_tcb __initdata;
-static int __init default_policy_setup(char *str)
+static int __init default_measure_policy_setup(char *str)
 {
 	ima_use_tcb = 1;
 	return 1;
 }
-__setup("ima_tcb", default_policy_setup);
+__setup("ima_tcb", default_measure_policy_setup);
+
+static bool ima_use_appraise_tcb __initdata;
+static int __init default_appraise_policy_setup(char *str)
+{
+	ima_use_appraise_tcb = 1;
+	return 1;
+}
+__setup("ima_appraise_tcb", default_appraise_policy_setup);
 
 /**
  * ima_match_rules - determine whether an inode matches the measure rule.
@@ -102,7 +124,7 @@ __setup("ima_tcb", default_policy_setup);
  *
  * Returns true on rule match, false on failure.
  */
-static bool ima_match_rules(struct ima_measure_rule_entry *rule,
+static bool ima_match_rules(struct ima_rule_entry *rule,
 			    struct inode *inode, enum ima_hooks func, int mask)
 {
 	struct task_struct *tsk = current;
@@ -118,6 +140,8 @@ static bool ima_match_rules(struct ima_measure_rule_entry *rule,
 		return false;
 	if ((rule->flags & IMA_UID) && rule->uid != cred->uid)
 		return false;
+	if ((rule->flags & IMA_FOWNER) && rule->fowner != inode->i_uid)
+		return false;
 	for (i = 0; i < MAX_LSM_RULES; i++) {
 		int rc = 0;
 		u32 osid, sid;
@@ -170,10 +194,10 @@ static bool ima_match_rules(struct ima_measure_rule_entry *rule,
 int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask,
 		     int flags)
 {
-	struct ima_measure_rule_entry *entry;
+	struct ima_rule_entry *entry;
 	int action = 0, actmask = flags | (flags << 1);
 
-	list_for_each_entry(entry, ima_measure, list) {
+	list_for_each_entry(entry, ima_rules, list) {
 
 		if (!(entry->action & actmask))
 			continue;
@@ -194,22 +218,31 @@ int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask,
 /**
  * ima_init_policy - initialize the default measure rules.
  *
- * ima_measure points to either the measure_default_rules or the
- * the new measure_policy_rules.
+ * ima_rules points to either the ima_default_rules or the
+ * the new ima_policy_rules.
  */
 void __init ima_init_policy(void)
 {
-	int i, entries;
+	int i, measure_entries, appraise_entries;
 
 	/* if !ima_use_tcb set entries = 0 so we load NO default rules */
-	if (ima_use_tcb)
-		entries = ARRAY_SIZE(default_rules);
-	else
-		entries = 0;
-
-	for (i = 0; i < entries; i++)
-		list_add_tail(&default_rules[i].list, &measure_default_rules);
-	ima_measure = &measure_default_rules;
+	measure_entries = ima_use_tcb ? ARRAY_SIZE(default_rules) : 0;
+	appraise_entries = ima_use_appraise_tcb ?
+			 ARRAY_SIZE(default_appraise_rules) : 0;
+	
+	for (i = 0; i < measure_entries + appraise_entries; i++) {
+		if (i < measure_entries)
+			list_add_tail(&default_rules[i].list,
+				      &ima_default_rules);
+		else {
+			int j = i - measure_entries;
+
+			list_add_tail(&default_appraise_rules[j].list,
+				      &ima_default_rules);
+		}
+	}
+
+	ima_rules = &ima_default_rules;
 }
 
 /**
@@ -226,8 +259,8 @@ void ima_update_policy(void)
 	int result = 1;
 	int audit_info = 0;
 
-	if (ima_measure == &measure_default_rules) {
-		ima_measure = &measure_policy_rules;
+	if (ima_rules == &ima_default_rules) {
+		ima_rules = &ima_policy_rules;
 		cause = "complete";
 		result = 0;
 	}
@@ -238,14 +271,17 @@ void ima_update_policy(void)
 enum {
 	Opt_err = -1,
 	Opt_measure = 1, Opt_dont_measure,
+	Opt_appraise, Opt_dont_appraise,
 	Opt_obj_user, Opt_obj_role, Opt_obj_type,
 	Opt_subj_user, Opt_subj_role, Opt_subj_type,
-	Opt_func, Opt_mask, Opt_fsmagic, Opt_uid
+	Opt_func, Opt_mask, Opt_fsmagic, Opt_uid, Opt_fowner
 };
 
 static match_table_t policy_tokens = {
 	{Opt_measure, "measure"},
 	{Opt_dont_measure, "dont_measure"},
+	{Opt_appraise, "appraise"},
+	{Opt_dont_appraise, "dont_appraise"},
 	{Opt_obj_user, "obj_user=%s"},
 	{Opt_obj_role, "obj_role=%s"},
 	{Opt_obj_type, "obj_type=%s"},
@@ -256,10 +292,11 @@ static match_table_t policy_tokens = {
 	{Opt_mask, "mask=%s"},
 	{Opt_fsmagic, "fsmagic=%s"},
 	{Opt_uid, "uid=%s"},
+	{Opt_fowner, "fowner=%s"},
 	{Opt_err, NULL}
 };
 
-static int ima_lsm_rule_init(struct ima_measure_rule_entry *entry,
+static int ima_lsm_rule_init(struct ima_rule_entry *entry,
 			     char *args, int lsm_rule, int audit_type)
 {
 	int result;
@@ -283,7 +320,7 @@ static void ima_log_string(struct audit_buffer *ab, char *key, char *value)
 	audit_log_format(ab, " ");
 }
 
-static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
+static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 {
 	struct audit_buffer *ab;
 	char *p;
@@ -292,6 +329,7 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_INTEGRITY_RULE);
 
 	entry->uid = -1;
+	entry->fowner = -1;
 	entry->action = UNKNOWN;
 	while ((p = strsep(&rule, " \t")) != NULL) {
 		substring_t args[MAX_OPT_ARGS];
@@ -320,11 +358,27 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
 
 			entry->action = DONT_MEASURE;
 			break;
+		case Opt_appraise:
+			ima_log_string(ab, "action", "appraise");
+
+			if (entry->action != UNKNOWN)
+				result = -EINVAL;
+
+			entry->action = APPRAISE;
+			break;
+		case Opt_dont_appraise:
+			ima_log_string(ab, "action", "dont_appraise");
+
+			if (entry->action != UNKNOWN)
+				result = -EINVAL;
+
+			entry->action = DONT_APPRAISE;
+			break;
 		case Opt_func:
 			ima_log_string(ab, "func", args[0].from);
 
 			if (entry->func)
-				result  = -EINVAL;
+				result = -EINVAL;
 
 			if (strcmp(args[0].from, "FILE_CHECK") == 0)
 				entry->func = FILE_CHECK;
@@ -389,6 +443,23 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
 					entry->flags |= IMA_UID;
 			}
 			break;
+		case Opt_fowner:
+			ima_log_string(ab, "fowner", args[0].from);
+
+			if (entry->fowner != -1) {
+				result = -EINVAL;
+				break;
+			}
+
+			result = strict_strtoul(args[0].from, 10, &lnum);
+			if (!result) {
+				entry->fowner = (uid_t) lnum;
+				if (entry->fowner != lnum)
+					result = -EINVAL;
+				else
+					entry->flags |= IMA_FOWNER;
+			}
+			break;
 		case Opt_obj_user:
 			ima_log_string(ab, "obj_user", args[0].from);
 			result = ima_lsm_rule_init(entry, args[0].from,
@@ -440,7 +511,7 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
 }
 
 /**
- * ima_parse_add_rule - add a rule to measure_policy_rules
+ * ima_parse_add_rule - add a rule to ima_policy_rules
  * @rule - ima measurement policy rule
  *
  * Uses a mutex to protect the policy list from multiple concurrent writers.
@@ -450,12 +521,12 @@ ssize_t ima_parse_add_rule(char *rule)
 {
 	const char *op = "update_policy";
 	char *p;
-	struct ima_measure_rule_entry *entry;
+	struct ima_rule_entry *entry;
 	ssize_t result, len;
 	int audit_info = 0;
 
 	/* Prevent installed policy from changing */
-	if (ima_measure != &measure_default_rules) {
+	if (ima_rules != &ima_default_rules) {
 		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
 				    NULL, op, "already exists",
 				    -EACCES, audit_info);
@@ -488,9 +559,9 @@ ssize_t ima_parse_add_rule(char *rule)
 		return result;
 	}
 
-	mutex_lock(&ima_measure_mutex);
-	list_add_tail(&entry->list, &measure_policy_rules);
-	mutex_unlock(&ima_measure_mutex);
+	mutex_lock(&ima_rules_mutex);
+	list_add_tail(&entry->list, &ima_policy_rules);
+	mutex_unlock(&ima_rules_mutex);
 
 	return len;
 }
@@ -498,12 +569,12 @@ ssize_t ima_parse_add_rule(char *rule)
 /* ima_delete_rules called to cleanup invalid policy */
 void ima_delete_rules(void)
 {
-	struct ima_measure_rule_entry *entry, *tmp;
+	struct ima_rule_entry *entry, *tmp;
 
-	mutex_lock(&ima_measure_mutex);
-	list_for_each_entry_safe(entry, tmp, &measure_policy_rules, list) {
+	mutex_lock(&ima_rules_mutex);
+	list_for_each_entry_safe(entry, tmp, &ima_policy_rules, list) {
 		list_del(&entry->list);
 		kfree(entry);
 	}
-	mutex_unlock(&ima_measure_mutex);
+	mutex_unlock(&ima_rules_mutex);
 }
-- 
1.7.6.5

