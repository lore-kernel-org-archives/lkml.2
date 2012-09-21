Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab2IUA3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:29:22 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55510 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab2IUA3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:29:15 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-security-module@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 20 Sep 2012 17:28:39 -0700
Message-Id: <1348187330-6616-3-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
References: <87k3vote43.fsf@xmission.com>
 <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18z/fx28dDfxP/fruFWfpCxhmIdwc2IRHY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2814]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;<linux-security-module@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 03/14] userns: Convert tomoyo to use kuid and kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 init/Kconfig                |    3 ---
 security/tomoyo/audit.c     |   23 ++++++++++++++++-------
 security/tomoyo/common.c    |    4 +++-
 security/tomoyo/common.h    |    4 ++--
 security/tomoyo/condition.c |   20 ++++++++++----------
 5 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 637faf8..381f765 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -962,9 +962,6 @@ config UIDGID_CONVERTED
 	# The rare drivers that won't build
 	depends on ANDROID_BINDER_IPC = n
 
-	# Security modules
-	depends on SECURITY_TOMOYO = n
-
 config UIDGID_STRICT_TYPE_CHECKS
 	bool "Require conversions between uid/gids and their internal representation"
 	depends on UIDGID_CONVERTED
diff --git a/security/tomoyo/audit.c b/security/tomoyo/audit.c
index 7ef9fa3..c1b0037 100644
--- a/security/tomoyo/audit.c
+++ b/security/tomoyo/audit.c
@@ -168,9 +168,14 @@ static char *tomoyo_print_header(struct tomoyo_request_info *r)
 		       stamp.day, stamp.hour, stamp.min, stamp.sec, r->profile,
 		       tomoyo_mode[r->mode], tomoyo_yesno(r->granted), gpid,
 		       tomoyo_sys_getpid(), tomoyo_sys_getppid(),
-		       current_uid(), current_gid(), current_euid(),
-		       current_egid(), current_suid(), current_sgid(),
-		       current_fsuid(), current_fsgid());
+		       from_kuid(&init_user_ns, current_uid()),
+		       from_kgid(&init_user_ns, current_gid()),
+		       from_kuid(&init_user_ns, current_euid()),
+		       from_kgid(&init_user_ns, current_egid()),
+		       from_kuid(&init_user_ns, current_suid()),
+		       from_kgid(&init_user_ns, current_sgid()),
+		       from_kuid(&init_user_ns, current_fsuid()),
+		       from_kgid(&init_user_ns, current_fsgid()));
 	if (!obj)
 		goto no_obj_info;
 	if (!obj->validate_done) {
@@ -191,15 +196,19 @@ static char *tomoyo_print_header(struct tomoyo_request_info *r)
 					tomoyo_buffer_len - 1 - pos,
 					" path%u.parent={ uid=%u gid=%u "
 					"ino=%lu perm=0%o }", (i >> 1) + 1,
-					stat->uid, stat->gid, (unsigned long)
-					stat->ino, stat->mode & S_IALLUGO);
+					from_kuid(&init_user_ns, stat->uid),
+					from_kgid(&init_user_ns, stat->gid),
+					(unsigned long)stat->ino,
+					stat->mode & S_IALLUGO);
 			continue;
 		}
 		pos += snprintf(buffer + pos, tomoyo_buffer_len - 1 - pos,
 				" path%u={ uid=%u gid=%u ino=%lu major=%u"
 				" minor=%u perm=0%o type=%s", (i >> 1) + 1,
-				stat->uid, stat->gid, (unsigned long)
-				stat->ino, MAJOR(dev), MINOR(dev),
+				from_kuid(&init_user_ns, stat->uid),
+				from_kgid(&init_user_ns, stat->gid),
+				(unsigned long)stat->ino,
+				MAJOR(dev), MINOR(dev),
 				mode & S_IALLUGO, tomoyo_filetype(mode));
 		if (S_ISCHR(mode) || S_ISBLK(mode)) {
 			dev = stat->rdev;
diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index 2e0f12c..f89a033 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -925,7 +925,9 @@ static bool tomoyo_manager(void)
 
 	if (!tomoyo_policy_loaded)
 		return true;
-	if (!tomoyo_manage_by_non_root && (task->cred->uid || task->cred->euid))
+	if (!tomoyo_manage_by_non_root &&
+	    (!uid_eq(task->cred->uid,  GLOBAL_ROOT_UID) ||
+	     !uid_eq(task->cred->euid, GLOBAL_ROOT_UID)))
 		return false;
 	exe = tomoyo_get_exe();
 	if (!exe)
diff --git a/security/tomoyo/common.h b/security/tomoyo/common.h
index 75e4dc1..af010b6 100644
--- a/security/tomoyo/common.h
+++ b/security/tomoyo/common.h
@@ -561,8 +561,8 @@ struct tomoyo_address_group {
 
 /* Subset of "struct stat". Used by conditional ACL and audit logs. */
 struct tomoyo_mini_stat {
-	uid_t uid;
-	gid_t gid;
+	kuid_t uid;
+	kgid_t gid;
 	ino_t ino;
 	umode_t mode;
 	dev_t dev;
diff --git a/security/tomoyo/condition.c b/security/tomoyo/condition.c
index 986330b..63681e8 100644
--- a/security/tomoyo/condition.c
+++ b/security/tomoyo/condition.c
@@ -813,28 +813,28 @@ bool tomoyo_condition(struct tomoyo_request_info *r,
 			unsigned long value = 0;
 			switch (index) {
 			case TOMOYO_TASK_UID:
-				value = current_uid();
+				value = from_kuid(&init_user_ns, current_uid());
 				break;
 			case TOMOYO_TASK_EUID:
-				value = current_euid();
+				value = from_kuid(&init_user_ns, current_euid());
 				break;
 			case TOMOYO_TASK_SUID:
-				value = current_suid();
+				value = from_kuid(&init_user_ns, current_suid());
 				break;
 			case TOMOYO_TASK_FSUID:
-				value = current_fsuid();
+				value = from_kuid(&init_user_ns, current_fsuid());
 				break;
 			case TOMOYO_TASK_GID:
-				value = current_gid();
+				value = from_kgid(&init_user_ns, current_gid());
 				break;
 			case TOMOYO_TASK_EGID:
-				value = current_egid();
+				value = from_kgid(&init_user_ns, current_egid());
 				break;
 			case TOMOYO_TASK_SGID:
-				value = current_sgid();
+				value = from_kgid(&init_user_ns, current_sgid());
 				break;
 			case TOMOYO_TASK_FSGID:
-				value = current_fsgid();
+				value = from_kgid(&init_user_ns, current_fsgid());
 				break;
 			case TOMOYO_TASK_PID:
 				value = tomoyo_sys_getpid();
@@ -970,13 +970,13 @@ bool tomoyo_condition(struct tomoyo_request_info *r,
 					case TOMOYO_PATH2_UID:
 					case TOMOYO_PATH1_PARENT_UID:
 					case TOMOYO_PATH2_PARENT_UID:
-						value = stat->uid;
+						value = from_kuid(&init_user_ns, stat->uid);
 						break;
 					case TOMOYO_PATH1_GID:
 					case TOMOYO_PATH2_GID:
 					case TOMOYO_PATH1_PARENT_GID:
 					case TOMOYO_PATH2_PARENT_GID:
-						value = stat->gid;
+						value = from_kgid(&init_user_ns, stat->gid);
 						break;
 					case TOMOYO_PATH1_INO:
 					case TOMOYO_PATH2_INO:
-- 
1.7.5.4

