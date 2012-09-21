Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab2IUA3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:29:13 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55481 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab2IUA3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:29:08 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-security-module@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        John Johansen <john.johansen@canonical.com>
Date: Thu, 20 Sep 2012 17:28:38 -0700
Message-Id: <1348187330-6616-2-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
References: <87k3vote43.fsf@xmission.com>
 <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+TcqYYbY+ZkMK/dRMkK8g+lnltDb/SYdQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2987]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;<linux-security-module@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 02/14] userns: Convert apparmor to use kuid and kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: John Johansen <john.johansen@canonical.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 init/Kconfig                      |    1 -
 security/apparmor/domain.c        |    4 ++--
 security/apparmor/file.c          |   12 +++++++-----
 security/apparmor/include/audit.h |    2 +-
 security/apparmor/include/file.h  |    4 ++--
 5 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index f315997..637faf8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -964,7 +964,6 @@ config UIDGID_CONVERTED
 
 	# Security modules
 	depends on SECURITY_TOMOYO = n
-	depends on SECURITY_APPARMOR = n
 
 config UIDGID_STRICT_TYPE_CHECKS
 	bool "Require conversions between uid/gids and their internal representation"
diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index b81ea10..60f0c76 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -721,7 +721,7 @@ audit:
 	if (!permtest)
 		error = aa_audit_file(profile, &perms, GFP_KERNEL,
 				      OP_CHANGE_HAT, AA_MAY_CHANGEHAT, NULL,
-				      target, 0, info, error);
+				      target, GLOBAL_ROOT_UID, info, error);
 
 out:
 	aa_put_profile(hat);
@@ -848,7 +848,7 @@ int aa_change_profile(const char *ns_name, const char *hname, bool onexec,
 audit:
 	if (!permtest)
 		error = aa_audit_file(profile, &perms, GFP_KERNEL, op, request,
-				      name, hname, 0, info, error);
+				      name, hname, GLOBAL_ROOT_UID, info, error);
 
 	aa_put_namespace(ns);
 	aa_put_profile(target);
diff --git a/security/apparmor/file.c b/security/apparmor/file.c
index cf19d40..cd21ec5 100644
--- a/security/apparmor/file.c
+++ b/security/apparmor/file.c
@@ -65,7 +65,7 @@ static void audit_file_mask(struct audit_buffer *ab, u32 mask)
 static void file_audit_cb(struct audit_buffer *ab, void *va)
 {
 	struct common_audit_data *sa = va;
-	uid_t fsuid = current_fsuid();
+	kuid_t fsuid = current_fsuid();
 
 	if (sa->aad->fs.request & AA_AUDIT_FILE_MASK) {
 		audit_log_format(ab, " requested_mask=");
@@ -76,8 +76,10 @@ static void file_audit_cb(struct audit_buffer *ab, void *va)
 		audit_file_mask(ab, sa->aad->fs.denied);
 	}
 	if (sa->aad->fs.request & AA_AUDIT_FILE_MASK) {
-		audit_log_format(ab, " fsuid=%d", fsuid);
-		audit_log_format(ab, " ouid=%d", sa->aad->fs.ouid);
+		audit_log_format(ab, " fsuid=%d",
+				 from_kuid(&init_user_ns, fsuid));
+		audit_log_format(ab, " ouid=%d",
+				 from_kuid(&init_user_ns, sa->aad->fs.ouid));
 	}
 
 	if (sa->aad->fs.target) {
@@ -103,7 +105,7 @@ static void file_audit_cb(struct audit_buffer *ab, void *va)
  */
 int aa_audit_file(struct aa_profile *profile, struct file_perms *perms,
 		  gfp_t gfp, int op, u32 request, const char *name,
-		  const char *target, uid_t ouid, const char *info, int error)
+		  const char *target, kuid_t ouid, const char *info, int error)
 {
 	int type = AUDIT_APPARMOR_AUTO;
 	struct common_audit_data sa;
@@ -201,7 +203,7 @@ static struct file_perms compute_perms(struct aa_dfa *dfa, unsigned int state,
 	 */
 	perms.kill = 0;
 
-	if (current_fsuid() == cond->uid) {
+	if (uid_eq(current_fsuid(), cond->uid)) {
 		perms.allow = map_old_perms(dfa_user_allow(dfa, state));
 		perms.audit = map_old_perms(dfa_user_audit(dfa, state));
 		perms.quiet = map_old_perms(dfa_user_quiet(dfa, state));
diff --git a/security/apparmor/include/audit.h b/security/apparmor/include/audit.h
index 4b7e189..69d8cae 100644
--- a/security/apparmor/include/audit.h
+++ b/security/apparmor/include/audit.h
@@ -125,7 +125,7 @@ struct apparmor_audit_data {
 			const char *target;
 			u32 request;
 			u32 denied;
-			uid_t ouid;
+			kuid_t ouid;
 		} fs;
 	};
 };
diff --git a/security/apparmor/include/file.h b/security/apparmor/include/file.h
index f98fd47..967b2de 100644
--- a/security/apparmor/include/file.h
+++ b/security/apparmor/include/file.h
@@ -71,7 +71,7 @@ struct path;
 
 /* need to make conditional which ones are being set */
 struct path_cond {
-	uid_t uid;
+	kuid_t uid;
 	umode_t mode;
 };
 
@@ -146,7 +146,7 @@ static inline u16 dfa_map_xindex(u16 mask)
 
 int aa_audit_file(struct aa_profile *profile, struct file_perms *perms,
 		  gfp_t gfp, int op, u32 request, const char *name,
-		  const char *target, uid_t ouid, const char *info, int error);
+		  const char *target, kuid_t ouid, const char *info, int error);
 
 /**
  * struct aa_file_rules - components used for file rule permissions
-- 
1.7.5.4

