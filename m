Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab2DHFNF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:13:05 -0400
Received: from out08.mta.xmission.com ([166.70.13.238]:56973 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753065Ab2DHFM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 01:12:27 -0400
From: "\"Eric W. Beiderman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat,  7 Apr 2012 22:15:18 -0700
Message-Id: <1333862139-31737-22-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/U7aJ0r4tkQ5UZigVrMsKSDveXvC6pwLE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4965]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: **
Subject: [PATCH 22/43] userns: Convert capabilities related permsion checks
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

- Use uid_eq when comparing kuids
  Use gid_eq when comparing kgids
- Use __make_kuid(user_ns, 0) to talk about the user_namespace root uid
  Use __make_kgid(user_ns, 0) to talk about the user_namespace root gid

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/open.c            |    3 ++-
 security/commoncap.c |   43 ++++++++++++++++++++++++++++---------------
 2 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 5720854..92335f6 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -316,7 +316,8 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 
 	if (!issecure(SECURE_NO_SETUID_FIXUP)) {
 		/* Clear the capabilities if we switch to a non-root user */
-		if (override_cred->uid)
+		kuid_t root_uid = make_kuid(override_cred->user_ns, 0);
+		if (!uid_eq(override_cred->uid, root_uid))
 			cap_clear(override_cred->cap_effective);
 		else
 			override_cred->cap_effective =
diff --git a/security/commoncap.c b/security/commoncap.c
index dbd465a..9bf8df8 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -472,19 +472,24 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
 	struct cred *new = bprm->cred;
 	bool effective, has_cap = false;
 	int ret;
+	kuid_t root_uid;
+	kgid_t root_gid;
 
 	effective = false;
 	ret = get_file_caps(bprm, &effective, &has_cap);
 	if (ret < 0)
 		return ret;
 
+	root_uid = make_kuid(new->user_ns, 0);
+	root_gid = make_kgid(new->user_ns, 0);
+
 	if (!issecure(SECURE_NOROOT)) {
 		/*
 		 * If the legacy file capability is set, then don't set privs
 		 * for a setuid root binary run by a non-root user.  Do set it
 		 * for a root user just to cause least surprise to an admin.
 		 */
-		if (has_cap && new->uid != 0 && new->euid == 0) {
+		if (has_cap && !uid_eq(new->uid, root_uid) && uid_eq(new->euid, root_uid)) {
 			warn_setuid_and_fcaps_mixed(bprm->filename);
 			goto skip;
 		}
@@ -495,12 +500,12 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
 		 *
 		 * If only the real uid is 0, we do not set the effective bit.
 		 */
-		if (new->euid == 0 || new->uid == 0) {
+		if (uid_eq(new->euid, root_uid) || uid_eq(new->uid, root_uid)) {
 			/* pP' = (cap_bset & ~0) | (pI & ~0) */
 			new->cap_permitted = cap_combine(old->cap_bset,
 							 old->cap_inheritable);
 		}
-		if (new->euid == 0)
+		if (uid_eq(new->euid, root_uid))
 			effective = true;
 	}
 skip:
@@ -508,8 +513,8 @@ skip:
 	/* Don't let someone trace a set[ug]id/setpcap binary with the revised
 	 * credentials unless they have the appropriate permit
 	 */
-	if ((new->euid != old->uid ||
-	     new->egid != old->gid ||
+	if ((!uid_eq(new->euid, old->uid) ||
+	     !gid_eq(new->egid, old->gid) ||
 	     !cap_issubset(new->cap_permitted, old->cap_permitted)) &&
 	    bprm->unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
 		/* downgrade; they get no more than they had, and maybe less */
@@ -544,7 +549,7 @@ skip:
 	 */
 	if (!cap_isclear(new->cap_effective)) {
 		if (!cap_issubset(CAP_FULL_SET, new->cap_effective) ||
-		    new->euid != 0 || new->uid != 0 ||
+		    !uid_eq(new->euid, root_uid) || !uid_eq(new->uid, root_uid) ||
 		    issecure(SECURE_NOROOT)) {
 			ret = audit_log_bprm_fcaps(bprm, new, old);
 			if (ret < 0)
@@ -569,16 +574,17 @@ skip:
 int cap_bprm_secureexec(struct linux_binprm *bprm)
 {
 	const struct cred *cred = current_cred();
+	kuid_t root_uid = make_kuid(cred->user_ns, 0);
 
-	if (cred->uid != 0) {
+	if (!uid_eq(cred->uid, root_uid)) {
 		if (bprm->cap_effective)
 			return 1;
 		if (!cap_isclear(cred->cap_permitted))
 			return 1;
 	}
 
-	return (cred->euid != cred->uid ||
-		cred->egid != cred->gid);
+	return (!uid_eq(cred->euid, cred->uid) ||
+		!gid_eq(cred->egid, cred->gid));
 }
 
 /**
@@ -668,15 +674,21 @@ int cap_inode_removexattr(struct dentry *dentry, const char *name)
  */
 static inline void cap_emulate_setxuid(struct cred *new, const struct cred *old)
 {
-	if ((old->uid == 0 || old->euid == 0 || old->suid == 0) &&
-	    (new->uid != 0 && new->euid != 0 && new->suid != 0) &&
+	kuid_t root_uid = make_kuid(old->user_ns, 0);
+
+	if ((uid_eq(old->uid, root_uid) ||
+	     uid_eq(old->euid, root_uid) ||
+	     uid_eq(old->suid, root_uid)) &&
+	    (!uid_eq(new->uid, root_uid) &&
+	     !uid_eq(new->euid, root_uid) &&
+	     !uid_eq(new->suid, root_uid)) &&
 	    !issecure(SECURE_KEEP_CAPS)) {
 		cap_clear(new->cap_permitted);
 		cap_clear(new->cap_effective);
 	}
-	if (old->euid == 0 && new->euid != 0)
+	if (uid_eq(old->euid, root_uid) && !uid_eq(new->euid, root_uid))
 		cap_clear(new->cap_effective);
-	if (old->euid != 0 && new->euid == 0)
+	if (!uid_eq(old->euid, root_uid) && uid_eq(new->euid, root_uid))
 		new->cap_effective = new->cap_permitted;
 }
 
@@ -709,11 +721,12 @@ int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags)
 		 *          if not, we might be a bit too harsh here.
 		 */
 		if (!issecure(SECURE_NO_SETUID_FIXUP)) {
-			if (old->fsuid == 0 && new->fsuid != 0)
+			kuid_t root_uid = make_kuid(old->user_ns, 0);
+			if (uid_eq(old->fsuid, root_uid) && !uid_eq(new->fsuid, root_uid))
 				new->cap_effective =
 					cap_drop_fs_set(new->cap_effective);
 
-			if (old->fsuid != 0 && new->fsuid == 0)
+			if (!uid_eq(old->fsuid, root_uid) && uid_eq(new->fsuid, root_uid))
 				new->cap_effective =
 					cap_raise_fs_set(new->cap_effective,
 							 new->cap_permitted);
-- 
1.7.2.5

