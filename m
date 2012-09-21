Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab2IUAbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:31:08 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41745 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab2IUA3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:29:36 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-security-module@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mimi Zohar <zohar@us.ibm.com>
Date: Thu, 20 Sep 2012 17:28:43 -0700
Message-Id: <1348187330-6616-7-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
References: <87k3vote43.fsf@xmission.com>
 <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19N3v4JcxaxFSJ89S5jb3S7RN3qv3HTEVs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0890]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-security-module@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 07/14] userns: Add user namespace support to IMA
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Use kuid's in the IMA rules.

When reporting the current uid in audit logs use from_kuid
to get a usable value.

Cc: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 init/Kconfig                        |    4 ----
 security/integrity/ima/ima_audit.c  |    5 +++--
 security/integrity/ima/ima_policy.c |   14 +++++++-------
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 96ee3f3..570cd33 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -923,10 +923,6 @@ config UIDGID_CONVERTED
 	bool
 	default y
 
-	# List of kernel pieces that need user namespace work
-	# Features
-	depends on IMA = n
-
 	# Networking
 	depends on NET_9P = n
 
diff --git a/security/integrity/ima/ima_audit.c b/security/integrity/ima/ima_audit.c
index 7a57f67..c586faa 100644
--- a/security/integrity/ima/ima_audit.c
+++ b/security/integrity/ima/ima_audit.c
@@ -39,8 +39,9 @@ void integrity_audit_msg(int audit_msgno, struct inode *inode,
 
 	ab = audit_log_start(current->audit_context, GFP_KERNEL, audit_msgno);
 	audit_log_format(ab, "pid=%d uid=%u auid=%u ses=%u",
-			 current->pid, current_cred()->uid,
-			 audit_get_loginuid(current),
+			 current->pid,
+			 from_kuid(&init_user_ns, current_cred()->uid),
+			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
 			 audit_get_sessionid(current));
 	audit_log_task_context(ab);
 	audit_log_format(ab, " op=");
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 1a95830..c84df05 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -39,7 +39,7 @@ struct ima_measure_rule_entry {
 	enum ima_hooks func;
 	int mask;
 	unsigned long fsmagic;
-	uid_t uid;
+	kuid_t uid;
 	struct {
 		void *rule;	/* LSM file metadata specific */
 		int type;	/* audit type */
@@ -71,7 +71,7 @@ static struct ima_measure_rule_entry default_rules[] = {
 	 .flags = IMA_FUNC | IMA_MASK},
 	{.action = MEASURE,.func = BPRM_CHECK,.mask = MAY_EXEC,
 	 .flags = IMA_FUNC | IMA_MASK},
-	{.action = MEASURE,.func = FILE_CHECK,.mask = MAY_READ,.uid = 0,
+	{.action = MEASURE,.func = FILE_CHECK,.mask = MAY_READ,.uid = GLOBAL_ROOT_UID,
 	 .flags = IMA_FUNC | IMA_MASK | IMA_UID},
 };
 
@@ -112,7 +112,7 @@ static bool ima_match_rules(struct ima_measure_rule_entry *rule,
 	if ((rule->flags & IMA_FSMAGIC)
 	    && rule->fsmagic != inode->i_sb->s_magic)
 		return false;
-	if ((rule->flags & IMA_UID) && rule->uid != cred->uid)
+	if ((rule->flags & IMA_UID) && !uid_eq(rule->uid, cred->uid))
 		return false;
 	for (i = 0; i < MAX_LSM_RULES; i++) {
 		int rc = 0;
@@ -277,7 +277,7 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
 
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_INTEGRITY_RULE);
 
-	entry->uid = -1;
+	entry->uid = INVALID_UID;
 	entry->action = UNKNOWN;
 	while ((p = strsep(&rule, " \t")) != NULL) {
 		substring_t args[MAX_OPT_ARGS];
@@ -361,15 +361,15 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
 		case Opt_uid:
 			ima_log_string(ab, "uid", args[0].from);
 
-			if (entry->uid != -1) {
+			if (uid_valid(entry->uid)) {
 				result = -EINVAL;
 				break;
 			}
 
 			result = strict_strtoul(args[0].from, 10, &lnum);
 			if (!result) {
-				entry->uid = (uid_t) lnum;
-				if (entry->uid != lnum)
+				entry->uid = make_kuid(current_user_ns(), (uid_t)lnum);
+				if (!uid_valid(entry->uid) || (((uid_t)lnum) != lnum))
 					result = -EINVAL;
 				else
 					entry->flags |= IMA_UID;
-- 
1.7.5.4

