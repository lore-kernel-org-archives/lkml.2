Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab0LERug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:50:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64682 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab0LERuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:50:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=m5XJAxFBpm+fDXduydmeySybyvPP5eG3ehGrxbe1kMpCrWA4Kzp9AZSbZZadmfM/eP
         RKzEdmgBkymawUe9PUjxVSxrJ2Hmcw+qWmP7r5a8sd1xVTu0ayQoVVt2EVqG4uDwa2V8
         wnZ6Q+7w1M4lzBHGkiY3lqsgNjHzApsidrq9s=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 10/45] kstrtox: convert security/
Date: Sun,  5 Dec 2010 19:49:07 +0200
Message-Id: <1291571382-2719-10-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 security/apparmor/lsm.c             |    2 +-
 security/integrity/ima/ima_audit.c  |    2 +-
 security/integrity/ima/ima_policy.c |   15 ++++-----------
 security/selinux/hooks.c            |    4 ++--
 security/selinux/selinuxfs.c        |    2 +-
 security/tomoyo/common.c            |    8 +++++---
 6 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index b7106f1..990ff86 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -754,7 +754,7 @@ module_param_named(enabled, apparmor_enabled, aabool, S_IRUSR);
 static int __init apparmor_enabled_setup(char *str)
 {
 	unsigned long enabled;
-	int error = strict_strtoul(str, 0, &enabled);
+	int error = kstrtoul(str, 0, &enabled);
 	if (!error)
 		apparmor_enabled = enabled ? 1 : 0;
 	return 1;
diff --git a/security/integrity/ima/ima_audit.c b/security/integrity/ima/ima_audit.c
index c5c5a72..b4a203c 100644
--- a/security/integrity/ima/ima_audit.c
+++ b/security/integrity/ima/ima_audit.c
@@ -24,7 +24,7 @@ static int __init ima_audit_setup(char *str)
 {
 	unsigned long audit;
 
-	if (!strict_strtoul(str, 0, &audit))
+	if (!kstrtoul(str, 0, &audit))
 		ima_audit = audit ? 1 : 0;
 	return 1;
 }
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index aef8c0a..7958938 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -276,7 +276,6 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
 	while ((p = strsep(&rule, " \t")) != NULL) {
 		substring_t args[MAX_OPT_ARGS];
 		int token;
-		unsigned long lnum;
 
 		if (result < 0)
 			break;
@@ -347,8 +346,7 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
 				break;
 			}
 
-			result = strict_strtoul(args[0].from, 16,
-						&entry->fsmagic);
+			result = kstrtoul(args[0].from, 16, &entry->fsmagic);
 			if (!result)
 				entry->flags |= IMA_FSMAGIC;
 			break;
@@ -360,14 +358,9 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
 				break;
 			}
 
-			result = strict_strtoul(args[0].from, 10, &lnum);
-			if (!result) {
-				entry->uid = (uid_t) lnum;
-				if (entry->uid != lnum)
-					result = -EINVAL;
-				else
-					entry->flags |= IMA_UID;
-			}
+			result = kstrtou32(args[0].from, 10, &entry->uid);
+			if (!result)
+				entry->flags |= IMA_UID;
 			break;
 		case Opt_obj_user:
 			ima_log_string(ab, "obj_user", args[0].from);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 65fa8bf..4ee09bd 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -101,7 +101,7 @@ int selinux_enforcing;
 static int __init enforcing_setup(char *str)
 {
 	unsigned long enforcing;
-	if (!strict_strtoul(str, 0, &enforcing))
+	if (!kstrtoul(str, 0, &enforcing))
 		selinux_enforcing = enforcing ? 1 : 0;
 	return 1;
 }
@@ -114,7 +114,7 @@ int selinux_enabled = CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE;
 static int __init selinux_enabled_setup(char *str)
 {
 	unsigned long enabled;
-	if (!strict_strtoul(str, 0, &enabled))
+	if (!kstrtoul(str, 0, &enabled))
 		selinux_enabled = enabled ? 1 : 0;
 	return 1;
 }
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 073fd5b..cdaf958 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -50,7 +50,7 @@ unsigned int selinux_checkreqprot = CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE;
 static int __init checkreqprot_setup(char *str)
 {
 	unsigned long checkreqprot;
-	if (!strict_strtoul(str, 0, &checkreqprot))
+	if (!kstrtoul(str, 0, &checkreqprot))
 		selinux_checkreqprot = checkreqprot ? 1 : 0;
 	return 1;
 }
diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index 7556315..1096c81 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -1091,14 +1091,16 @@ static int tomoyo_write_domain_profile(struct tomoyo_io_buffer *head)
 	char *data = head->write_buf;
 	char *cp = strchr(data, ' ');
 	struct tomoyo_domain_info *domain;
-	unsigned long profile;
+	unsigned int profile;
+	int rv;
 
 	if (!cp)
 		return -EINVAL;
 	*cp = '\0';
 	domain = tomoyo_find_domain(cp + 1);
-	if (strict_strtoul(data, 10, &profile))
-		return -EINVAL;
+	rv = kstrtouint(data, 10, &profile);
+	if (rv < 0)
+		return rv;
 	if (domain && profile < TOMOYO_MAX_PROFILES
 	    && (tomoyo_profile_ptr[profile] || !tomoyo_policy_loaded))
 		domain->profile = (u8) profile;
-- 
1.7.2.2

