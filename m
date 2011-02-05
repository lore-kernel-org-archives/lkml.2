Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab1BEObF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:31:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57576 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab1BEOVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:21:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sbocGrMXP/tNQq0Ow7gItZsxg9HNPZjHmd6GtmSvhmb2R/GgyS8JiQRsqTOl+ux518
         7sTLIoBYgUVic8x4hvGPGwVzJzBqgPveFhIjS9rT4cTcfxWphycTbs38/q1kSaoIiiYl
         scrSgSlX0uUEyh47FbAfGQFFJeMtnp3NYx/cU=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 06/52] kstrtox: convert security/
Date: Sat,  5 Feb 2011 16:20:09 +0200
Message-Id: <1296915654-7458-6-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 security/apparmor/lsm.c             |    2 +-
 security/integrity/ima/ima_audit.c  |    2 +-
 security/integrity/ima/ima_policy.c |   15 ++++-----------
 security/keys/encrypted.c           |    8 +++++---
 security/keys/trusted.c             |   23 +++++++++++------------
 security/selinux/hooks.c            |    4 ++--
 security/selinux/selinuxfs.c        |    2 +-
 security/tomoyo/common.c            |    8 +++++---
 8 files changed, 30 insertions(+), 34 deletions(-)

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
index d661afb..3d5c491 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -278,7 +278,6 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
 	while ((p = strsep(&rule, " \t")) != NULL) {
 		substring_t args[MAX_OPT_ARGS];
 		int token;
-		unsigned long lnum;
 
 		if (result < 0)
 			break;
@@ -349,8 +348,7 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
 				break;
 			}
 
-			result = strict_strtoul(args[0].from, 16,
-						&entry->fsmagic);
+			result = kstrtoul(args[0].from, 16, &entry->fsmagic);
 			if (!result)
 				entry->flags |= IMA_FSMAGIC;
 			break;
@@ -362,14 +360,9 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
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
diff --git a/security/keys/encrypted.c b/security/keys/encrypted.c
index 9e7e4ce..859e1e8 100644
--- a/security/keys/encrypted.c
+++ b/security/keys/encrypted.c
@@ -521,11 +521,13 @@ static struct encrypted_key_payload *encrypted_key_alloc(struct key *key,
 	unsigned short datablob_len;
 	unsigned short decrypted_datalen;
 	unsigned int encrypted_datalen;
-	long dlen;
+	unsigned int dlen;
 	int ret;
 
-	ret = strict_strtol(datalen, 10, &dlen);
-	if (ret < 0 || dlen < MIN_DATA_SIZE || dlen > MAX_DATA_SIZE)
+	ret = kstrtouint(datalen, 10, &dlen);
+	if (ret < 0)
+		return ERR_PTR(ret);
+	if (dlen < MIN_DATA_SIZE || dlen > MAX_DATA_SIZE)
 		return ERR_PTR(-EINVAL);
 
 	decrypted_datalen = dlen;
diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index 83fc92e..ac59eb9 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -766,8 +766,6 @@ static int getoptions(char *c, struct trusted_key_payload *pay,
 	char *p = c;
 	int token;
 	int res;
-	unsigned long handle;
-	unsigned long lock;
 
 	while ((p = strsep(&c, " \t"))) {
 		if (*p == '\0' || *p == ' ' || *p == '\t')
@@ -782,11 +780,10 @@ static int getoptions(char *c, struct trusted_key_payload *pay,
 			hex2bin(opt->pcrinfo, args[0].from, opt->pcrinfo_len);
 			break;
 		case Opt_keyhandle:
-			res = strict_strtoul(args[0].from, 16, &handle);
-			if (res < 0)
-				return -EINVAL;
 			opt->keytype = SEAL_keytype;
-			opt->keyhandle = handle;
+			res = kstrtou32(args[0].from, 16, &opt->keyhandle);
+			if (res < 0)
+				return res;
 			break;
 		case Opt_keyauth:
 			if (strlen(args[0].from) != 2 * SHA1_DIGEST_SIZE)
@@ -805,10 +802,9 @@ static int getoptions(char *c, struct trusted_key_payload *pay,
 				return -EINVAL;
 			break;
 		case Opt_pcrlock:
-			res = strict_strtoul(args[0].from, 10, &lock);
+			res = kstrtoint(args[0].from, 10, &opt->pcrlock);
 			if (res < 0)
-				return -EINVAL;
-			opt->pcrlock = lock;
+				return res;
 			break;
 		default:
 			return -EINVAL;
@@ -827,7 +823,6 @@ static int datablob_parse(char *datablob, struct trusted_key_payload *p,
 			  struct trusted_key_options *o)
 {
 	substring_t args[MAX_OPT_ARGS];
-	long keylen;
 	int ret = -EINVAL;
 	int key_cmd;
 	char *c;
@@ -838,13 +833,17 @@ static int datablob_parse(char *datablob, struct trusted_key_payload *p,
 		return -EINVAL;
 	key_cmd = match_token(c, key_tokens, args);
 	switch (key_cmd) {
+		unsigned int keylen;
+
 	case Opt_new:
 		/* first argument is key size */
 		c = strsep(&datablob, " \t");
 		if (!c)
 			return -EINVAL;
-		ret = strict_strtol(c, 10, &keylen);
-		if (ret < 0 || keylen < MIN_KEY_SIZE || keylen > MAX_KEY_SIZE)
+		ret = kstrtouint(c, 10, &keylen);
+		if (ret < 0)
+			return ret;
+		if (keylen < MIN_KEY_SIZE || keylen > MAX_KEY_SIZE)
 			return -EINVAL;
 		p->key_len = keylen;
 		ret = getoptions(datablob, p, o);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e276eb4..521b2b9 100644
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
index ea39cb7..31c63f5 100644
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
1.7.3.4

