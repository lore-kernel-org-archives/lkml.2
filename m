Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab2CATSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:18:01 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:53240 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab2CATR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:17:57 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v2 04/11] ima: add appraise action keywords and default rules
Date: Thu,  1 Mar 2012 14:10:41 -0500
Message-Id: <1330629048-5933-5-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1330629048-5933-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1330629048-5933-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030119-7282-0000-0000-00000701BFF0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike the IMA measurement policy, the appraise policy can not be dependent
on runtime process information, such as the task uid, as the 'security.ima'
xattr is written on file close and must be updated each time the file changes,
regardless of the current task uid.

This patch extends the policy language with 'fowner'.  The appraise default
policy appraises all files owned by root.

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
---
 Documentation/ABI/testing/ima_policy  |   25 ++++++++++++--
 security/integrity/ima/ima_appraise.c |    5 ++-
 security/integrity/ima/ima_policy.c   |   56 +++++++++++++++++++++++++++++++--
 3 files changed, 78 insertions(+), 8 deletions(-)

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
 
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 17dc55c..0fd7ec3 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -36,7 +36,10 @@ __setup("ima_appraise=", default_appraise_setup);
  */
 int ima_must_appraise(struct inode *inode, enum ima_hooks func, int mask)
 {
-	return 0;
+	if (!ima_appraise || !inode->i_op->getxattr)
+		return 0;
+
+	return ima_match_policy(inode, func, mask, IMA_APPRAISE);
 }
 
 static void ima_fix_xattr(struct dentry *dentry,
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 8ee301c..a22da63 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -24,6 +24,7 @@
 #define IMA_MASK 	0x0002
 #define IMA_FSMAGIC	0x0004
 #define IMA_UID		0x0008
+#define IMA_FOWNER	0x0010
 
 #define UNKNOWN			0
 #define MEASURE			1	/* same as IMA_MEASURE */
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
@@ -77,6 +79,14 @@ static struct ima_measure_rule_entry default_rules[] = {
 	 .flags = IMA_FUNC | IMA_MASK},
 	{.action = MEASURE,.func = FILE_CHECK,.mask = MAY_READ,.uid = 0,
 	 .flags = IMA_FUNC | IMA_MASK | IMA_UID},
+	{.action = DONT_APPRAISE,.fsmagic = PROC_SUPER_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE,.fsmagic = SYSFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE,.fsmagic = DEBUGFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE,.fsmagic = TMPFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE,.fsmagic = RAMFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE,.fsmagic = SECURITYFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE,.fsmagic = SELINUX_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = APPRAISE,.fowner = 0,.flags = IMA_FOWNER},
 };
 
 static LIST_HEAD(measure_default_rules);
@@ -118,6 +128,8 @@ static bool ima_match_rules(struct ima_measure_rule_entry *rule,
 		return false;
 	if ((rule->flags & IMA_UID) && rule->uid != cred->uid)
 		return false;
+	if ((rule->flags & IMA_FOWNER) && rule->fowner != inode->i_uid)
+		return false;
 	for (i = 0; i < MAX_LSM_RULES; i++) {
 		int rc = 0;
 		u32 osid, sid;
@@ -238,14 +250,17 @@ void ima_update_policy(void)
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
@@ -256,6 +271,7 @@ static match_table_t policy_tokens = {
 	{Opt_mask, "mask=%s"},
 	{Opt_fsmagic, "fsmagic=%s"},
 	{Opt_uid, "uid=%s"},
+	{Opt_fowner, "fowner=%s"},
 	{Opt_err, NULL}
 };
 
@@ -292,6 +308,7 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_INTEGRITY_RULE);
 
 	entry->uid = -1;
+	entry->fowner = -1;
 	entry->action = UNKNOWN;
 	while ((p = strsep(&rule, " \t")) != NULL) {
 		substring_t args[MAX_OPT_ARGS];
@@ -320,11 +337,27 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
 
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
@@ -389,6 +422,23 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
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
-- 
1.7.6.5

