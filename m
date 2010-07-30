Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab0G3Prk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 11:47:40 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47729 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab0G3Prf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 11:47:35 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v3 15/15] ima: extend policy language to support owner
Date: Fri, 30 Jul 2010 11:45:46 -0400
Message-Id: <1280504746-20256-16-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1280504746-20256-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1280504746-20256-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default appraisal policy measures all files owned by root.
This patch extends the policy language with 'owner'.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 Documentation/ABI/testing/ima_policy |   22 ++++++++++++++++++----
 security/integrity/ima/ima_policy.c  |   23 +++++++++++++++++++++--
 2 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index 6cd6dae..c0ddeef 100644
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
+			base:	[[func=] [mask=] [fsmagic=] [uid=] [owner]]
 			lsm:	[[subj_user=] [subj_role=] [subj_type=]
 				 [obj_user=] [obj_role=] [obj_type=]]
 
@@ -24,36 +27,47 @@ Description:
 			mask:= [MAY_READ] [MAY_WRITE] [MAY_APPEND] [MAY_EXEC]
 			fsmagic:= hex value
 			uid:= decimal value
+			owner:=decimal value
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
 			# SECURITYFS_MAGIC
 			dont_measure fsmagic=0x73636673
+			dont_appraise fsmagic=0x73636673
 
 			measure func=BPRM_CHECK
 			measure func=FILE_MMAP mask=MAY_EXEC
 			measure func=FILE_CHECK mask=MAY_READ uid=0
+			appraise owner=0
 
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
 
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 96d5b45..4a7faa8 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -261,7 +261,7 @@ enum {
 	Opt_appraise, Opt_dont_appraise,
 	Opt_obj_user, Opt_obj_role, Opt_obj_type,
 	Opt_subj_user, Opt_subj_role, Opt_subj_type,
-	Opt_func, Opt_mask, Opt_fsmagic, Opt_uid
+	Opt_func, Opt_mask, Opt_fsmagic, Opt_uid, Opt_owner
 };
 
 static match_table_t policy_tokens = {
@@ -279,6 +279,7 @@ static match_table_t policy_tokens = {
 	{Opt_mask, "mask=%s"},
 	{Opt_fsmagic, "fsmagic=%s"},
 	{Opt_uid, "uid=%s"},
+	{Opt_owner, "owner=%s"},
 	{Opt_err, NULL}
 };
 
@@ -313,6 +314,7 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_INTEGRITY_RULE);
 
 	entry->uid = -1;
+	entry->owner = -1;
 	entry->action = UNKNOWN;
 	while ((p = strsep(&rule, " \t")) != NULL) {
 		substring_t args[MAX_OPT_ARGS];
@@ -361,7 +363,7 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
 			ima_log_string(ab, "func", args[0].from);
 
 			if (entry->func)
-				result  = -EINVAL;
+				result = -EINVAL;
 
 			if (strcmp(args[0].from, "FILE_CHECK") == 0)
 				entry->func = FILE_CHECK;
@@ -426,6 +428,23 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
 					entry->flags |= IMA_UID;
 			}
 			break;
+		case Opt_owner:
+			ima_log_string(ab, "owner", args[0].from);
+
+			if (entry->owner != -1) {
+				result = -EINVAL;
+				break;
+			}
+
+			result = strict_strtoul(args[0].from, 10, &lnum);
+			if (!result) {
+				entry->owner = (uid_t) lnum;
+				if (entry->owner != lnum)
+					result = -EINVAL;
+				else
+					entry->flags |= IMA_OWNER;
+			}
+			break;
 		case Opt_obj_user:
 			ima_log_string(ab, "obj_user", args[0].from);
 			result = ima_lsm_rule_init(entry, args[0].from,
-- 
1.7.1.1

