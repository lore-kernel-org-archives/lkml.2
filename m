Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab2DHFRk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:17:40 -0400
Received: from out07.mta.xmission.com ([166.70.13.237]:44092 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753175Ab2DHFM1 (ORCPT
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
Date: Sat,  7 Apr 2012 22:15:19 -0700
Message-Id: <1333862139-31737-23-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+LlLlHALNRAmXKWIL/cmxuMNa9eaYWn/k=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4648]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *******;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: **
Subject: [PATCH 23/43] userns: Convert setting and getting uid and gid system calls to use kuid and kgid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Convert setregid, setgid, setreuid, setuid,
setresuid, getresuid, setresgid, getresgid, setfsuid, setfsgid,
getuid, geteuid, getgid, getegid,
waitpid, waitid, wait4.

Convert userspace uids and gids into kuids and kgids before
being placed on struct cred.  Convert struct cred kuids and
kgids into userspace uids and gids when returning them.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/exit.c  |    6 +-
 kernel/sys.c   |  216 ++++++++++++++++++++++++++++++++++++++-----------------
 kernel/timer.c |    8 +-
 kernel/uid16.c |   34 ++++++---
 4 files changed, 178 insertions(+), 86 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index d8bd3b42..789e3c5 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1214,7 +1214,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 	unsigned long state;
 	int retval, status, traced;
 	pid_t pid = task_pid_vnr(p);
-	uid_t uid = __task_cred(p)->uid;
+	uid_t uid = from_kuid_munged(current_user_ns(), __task_cred(p)->uid);
 	struct siginfo __user *infop;
 
 	if (!likely(wo->wo_flags & WEXITED))
@@ -1427,7 +1427,7 @@ static int wait_task_stopped(struct wait_opts *wo,
 	if (!unlikely(wo->wo_flags & WNOWAIT))
 		*p_code = 0;
 
-	uid = task_uid(p);
+	uid = from_kuid_munged(current_user_ns(), __task_cred(p)->uid);
 unlock_sig:
 	spin_unlock_irq(&p->sighand->siglock);
 	if (!exit_code)
@@ -1500,7 +1500,7 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 	}
 	if (!unlikely(wo->wo_flags & WNOWAIT))
 		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
-	uid = task_uid(p);
+	uid = from_kuid_munged(current_user_ns(), __task_cred(p)->uid);
 	spin_unlock_irq(&p->sighand->siglock);
 
 	pid = task_pid_vnr(p);
diff --git a/kernel/sys.c b/kernel/sys.c
index 3996281..aff09f2 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -555,9 +555,19 @@ void ctrl_alt_del(void)
  */
 SYSCALL_DEFINE2(setregid, gid_t, rgid, gid_t, egid)
 {
+	struct user_namespace *ns = current_user_ns();
 	const struct cred *old;
 	struct cred *new;
 	int retval;
+	kgid_t krgid, kegid;
+
+	krgid = make_kgid(ns, rgid);
+	kegid = make_kgid(ns, egid);
+
+	if ((rgid != (gid_t) -1) && !gid_valid(krgid))
+		return -EINVAL;
+	if ((egid != (gid_t) -1) && !gid_valid(kegid))
+		return -EINVAL;
 
 	new = prepare_creds();
 	if (!new)
@@ -566,25 +576,25 @@ SYSCALL_DEFINE2(setregid, gid_t, rgid, gid_t, egid)
 
 	retval = -EPERM;
 	if (rgid != (gid_t) -1) {
-		if (old->gid == rgid ||
-		    old->egid == rgid ||
+		if (gid_eq(old->gid, krgid) ||
+		    gid_eq(old->egid, krgid) ||
 		    nsown_capable(CAP_SETGID))
-			new->gid = rgid;
+			new->gid = krgid;
 		else
 			goto error;
 	}
 	if (egid != (gid_t) -1) {
-		if (old->gid == egid ||
-		    old->egid == egid ||
-		    old->sgid == egid ||
+		if (gid_eq(old->gid, kegid) ||
+		    gid_eq(old->egid, kegid) ||
+		    gid_eq(old->sgid, kegid) ||
 		    nsown_capable(CAP_SETGID))
-			new->egid = egid;
+			new->egid = kegid;
 		else
 			goto error;
 	}
 
 	if (rgid != (gid_t) -1 ||
-	    (egid != (gid_t) -1 && egid != old->gid))
+	    (egid != (gid_t) -1 && !gid_eq(kegid, old->gid)))
 		new->sgid = new->egid;
 	new->fsgid = new->egid;
 
@@ -602,9 +612,15 @@ error:
  */
 SYSCALL_DEFINE1(setgid, gid_t, gid)
 {
+	struct user_namespace *ns = current_user_ns();
 	const struct cred *old;
 	struct cred *new;
 	int retval;
+	kgid_t kgid;
+
+	kgid = make_kgid(ns, gid);
+	if (!gid_valid(kgid))
+		return -EINVAL;
 
 	new = prepare_creds();
 	if (!new)
@@ -613,9 +629,9 @@ SYSCALL_DEFINE1(setgid, gid_t, gid)
 
 	retval = -EPERM;
 	if (nsown_capable(CAP_SETGID))
-		new->gid = new->egid = new->sgid = new->fsgid = gid;
-	else if (gid == old->gid || gid == old->sgid)
-		new->egid = new->fsgid = gid;
+		new->gid = new->egid = new->sgid = new->fsgid = kgid;
+	else if (gid_eq(kgid, old->gid) || gid_eq(kgid, old->sgid))
+		new->egid = new->fsgid = kgid;
 	else
 		goto error;
 
@@ -672,9 +688,19 @@ static int set_user(struct cred *new)
  */
 SYSCALL_DEFINE2(setreuid, uid_t, ruid, uid_t, euid)
 {
+	struct user_namespace *ns = current_user_ns();
 	const struct cred *old;
 	struct cred *new;
 	int retval;
+	kuid_t kruid, keuid;
+
+	kruid = make_kuid(ns, ruid);
+	keuid = make_kuid(ns, euid);
+
+	if ((ruid != (uid_t) -1) && !uid_valid(kruid))
+		return -EINVAL;
+	if ((euid != (uid_t) -1) && !uid_valid(keuid))
+		return -EINVAL;
 
 	new = prepare_creds();
 	if (!new)
@@ -683,29 +709,29 @@ SYSCALL_DEFINE2(setreuid, uid_t, ruid, uid_t, euid)
 
 	retval = -EPERM;
 	if (ruid != (uid_t) -1) {
-		new->uid = ruid;
-		if (old->uid != ruid &&
-		    old->euid != ruid &&
+		new->uid = kruid;
+		if (!uid_eq(old->uid, kruid) &&
+		    !uid_eq(old->euid, kruid) &&
 		    !nsown_capable(CAP_SETUID))
 			goto error;
 	}
 
 	if (euid != (uid_t) -1) {
-		new->euid = euid;
-		if (old->uid != euid &&
-		    old->euid != euid &&
-		    old->suid != euid &&
+		new->euid = keuid;
+		if (!uid_eq(old->uid, keuid) &&
+		    !uid_eq(old->euid, keuid) &&
+		    !uid_eq(old->suid, keuid) &&
 		    !nsown_capable(CAP_SETUID))
 			goto error;
 	}
 
-	if (new->uid != old->uid) {
+	if (!uid_eq(new->uid, old->uid)) {
 		retval = set_user(new);
 		if (retval < 0)
 			goto error;
 	}
 	if (ruid != (uid_t) -1 ||
-	    (euid != (uid_t) -1 && euid != old->uid))
+	    (euid != (uid_t) -1 && !uid_eq(keuid, old->uid)))
 		new->suid = new->euid;
 	new->fsuid = new->euid;
 
@@ -733,9 +759,15 @@ error:
  */
 SYSCALL_DEFINE1(setuid, uid_t, uid)
 {
+	struct user_namespace *ns = current_user_ns();
 	const struct cred *old;
 	struct cred *new;
 	int retval;
+	kuid_t kuid;
+
+	kuid = make_kuid(ns, uid);
+	if (!uid_valid(kuid))
+		return -EINVAL;
 
 	new = prepare_creds();
 	if (!new)
@@ -744,17 +776,17 @@ SYSCALL_DEFINE1(setuid, uid_t, uid)
 
 	retval = -EPERM;
 	if (nsown_capable(CAP_SETUID)) {
-		new->suid = new->uid = uid;
-		if (uid != old->uid) {
+		new->suid = new->uid = kuid;
+		if (!uid_eq(kuid, old->uid)) {
 			retval = set_user(new);
 			if (retval < 0)
 				goto error;
 		}
-	} else if (uid != old->uid && uid != new->suid) {
+	} else if (!uid_eq(kuid, old->uid) && !uid_eq(kuid, new->suid)) {
 		goto error;
 	}
 
-	new->fsuid = new->euid = uid;
+	new->fsuid = new->euid = kuid;
 
 	retval = security_task_fix_setuid(new, old, LSM_SETID_ID);
 	if (retval < 0)
@@ -774,9 +806,24 @@ error:
  */
 SYSCALL_DEFINE3(setresuid, uid_t, ruid, uid_t, euid, uid_t, suid)
 {
+	struct user_namespace *ns = current_user_ns();
 	const struct cred *old;
 	struct cred *new;
 	int retval;
+	kuid_t kruid, keuid, ksuid;
+
+	kruid = make_kuid(ns, ruid);
+	keuid = make_kuid(ns, euid);
+	ksuid = make_kuid(ns, suid);
+
+	if ((ruid != (uid_t) -1) && !uid_valid(kruid))
+		return -EINVAL;
+
+	if ((euid != (uid_t) -1) && !uid_valid(keuid))
+		return -EINVAL;
+
+	if ((suid != (uid_t) -1) && !uid_valid(ksuid))
+		return -EINVAL;
 
 	new = prepare_creds();
 	if (!new)
@@ -786,29 +833,29 @@ SYSCALL_DEFINE3(setresuid, uid_t, ruid, uid_t, euid, uid_t, suid)
 
 	retval = -EPERM;
 	if (!nsown_capable(CAP_SETUID)) {
-		if (ruid != (uid_t) -1 && ruid != old->uid &&
-		    ruid != old->euid  && ruid != old->suid)
+		if (ruid != (uid_t) -1        && !uid_eq(kruid, old->uid) &&
+		    !uid_eq(kruid, old->euid) && !uid_eq(kruid, old->suid))
 			goto error;
-		if (euid != (uid_t) -1 && euid != old->uid &&
-		    euid != old->euid  && euid != old->suid)
+		if (euid != (uid_t) -1        && !uid_eq(keuid, old->uid) &&
+		    !uid_eq(keuid, old->euid) && !uid_eq(keuid, old->suid))
 			goto error;
-		if (suid != (uid_t) -1 && suid != old->uid &&
-		    suid != old->euid  && suid != old->suid)
+		if (suid != (uid_t) -1        && !uid_eq(ksuid, old->uid) &&
+		    !uid_eq(ksuid, old->euid) && !uid_eq(ksuid, old->suid))
 			goto error;
 	}
 
 	if (ruid != (uid_t) -1) {
-		new->uid = ruid;
-		if (ruid != old->uid) {
+		new->uid = kruid;
+		if (!uid_eq(kruid, old->uid)) {
 			retval = set_user(new);
 			if (retval < 0)
 				goto error;
 		}
 	}
 	if (euid != (uid_t) -1)
-		new->euid = euid;
+		new->euid = keuid;
 	if (suid != (uid_t) -1)
-		new->suid = suid;
+		new->suid = ksuid;
 	new->fsuid = new->euid;
 
 	retval = security_task_fix_setuid(new, old, LSM_SETID_RES);
@@ -822,14 +869,19 @@ error:
 	return retval;
 }
 
-SYSCALL_DEFINE3(getresuid, uid_t __user *, ruid, uid_t __user *, euid, uid_t __user *, suid)
+SYSCALL_DEFINE3(getresuid, uid_t __user *, ruidp, uid_t __user *, euidp, uid_t __user *, suidp)
 {
 	const struct cred *cred = current_cred();
 	int retval;
+	uid_t ruid, euid, suid;
+
+	ruid = from_kuid_munged(cred->user_ns, cred->uid);
+	euid = from_kuid_munged(cred->user_ns, cred->euid);
+	suid = from_kuid_munged(cred->user_ns, cred->suid);
 
-	if (!(retval   = put_user(cred->uid,  ruid)) &&
-	    !(retval   = put_user(cred->euid, euid)))
-		retval = put_user(cred->suid, suid);
+	if (!(retval   = put_user(ruid, ruidp)) &&
+	    !(retval   = put_user(euid, euidp)))
+		retval = put_user(suid, suidp);
 
 	return retval;
 }
@@ -839,9 +891,22 @@ SYSCALL_DEFINE3(getresuid, uid_t __user *, ruid, uid_t __user *, euid, uid_t __u
  */
 SYSCALL_DEFINE3(setresgid, gid_t, rgid, gid_t, egid, gid_t, sgid)
 {
+	struct user_namespace *ns = current_user_ns();
 	const struct cred *old;
 	struct cred *new;
 	int retval;
+	kgid_t krgid, kegid, ksgid;
+
+	krgid = make_kgid(ns, rgid);
+	kegid = make_kgid(ns, egid);
+	ksgid = make_kgid(ns, sgid);
+
+	if ((rgid != (gid_t) -1) && !gid_valid(krgid))
+		return -EINVAL;
+	if ((egid != (gid_t) -1) && !gid_valid(kegid))
+		return -EINVAL;
+	if ((sgid != (gid_t) -1) && !gid_valid(ksgid))
+		return -EINVAL;
 
 	new = prepare_creds();
 	if (!new)
@@ -850,23 +915,23 @@ SYSCALL_DEFINE3(setresgid, gid_t, rgid, gid_t, egid, gid_t, sgid)
 
 	retval = -EPERM;
 	if (!nsown_capable(CAP_SETGID)) {
-		if (rgid != (gid_t) -1 && rgid != old->gid &&
-		    rgid != old->egid  && rgid != old->sgid)
+		if (rgid != (gid_t) -1        && !gid_eq(krgid, old->gid) &&
+		    !gid_eq(krgid, old->egid) && !gid_eq(krgid, old->sgid))
 			goto error;
-		if (egid != (gid_t) -1 && egid != old->gid &&
-		    egid != old->egid  && egid != old->sgid)
+		if (egid != (gid_t) -1        && !gid_eq(kegid, old->gid) &&
+		    !gid_eq(kegid, old->egid) && !gid_eq(kegid, old->sgid))
 			goto error;
-		if (sgid != (gid_t) -1 && sgid != old->gid &&
-		    sgid != old->egid  && sgid != old->sgid)
+		if (sgid != (gid_t) -1        && !gid_eq(ksgid, old->gid) &&
+		    !gid_eq(ksgid, old->egid) && !gid_eq(ksgid, old->sgid))
 			goto error;
 	}
 
 	if (rgid != (gid_t) -1)
-		new->gid = rgid;
+		new->gid = krgid;
 	if (egid != (gid_t) -1)
-		new->egid = egid;
+		new->egid = kegid;
 	if (sgid != (gid_t) -1)
-		new->sgid = sgid;
+		new->sgid = ksgid;
 	new->fsgid = new->egid;
 
 	return commit_creds(new);
@@ -876,14 +941,19 @@ error:
 	return retval;
 }
 
-SYSCALL_DEFINE3(getresgid, gid_t __user *, rgid, gid_t __user *, egid, gid_t __user *, sgid)
+SYSCALL_DEFINE3(getresgid, gid_t __user *, rgidp, gid_t __user *, egidp, gid_t __user *, sgidp)
 {
 	const struct cred *cred = current_cred();
 	int retval;
+	gid_t rgid, egid, sgid;
+
+	rgid = from_kgid_munged(cred->user_ns, cred->gid);
+	egid = from_kgid_munged(cred->user_ns, cred->egid);
+	sgid = from_kgid_munged(cred->user_ns, cred->sgid);
 
-	if (!(retval   = put_user(cred->gid,  rgid)) &&
-	    !(retval   = put_user(cred->egid, egid)))
-		retval = put_user(cred->sgid, sgid);
+	if (!(retval   = put_user(rgid, rgidp)) &&
+	    !(retval   = put_user(egid, egidp)))
+		retval = put_user(sgid, sgidp);
 
 	return retval;
 }
@@ -900,18 +970,24 @@ SYSCALL_DEFINE1(setfsuid, uid_t, uid)
 	const struct cred *old;
 	struct cred *new;
 	uid_t old_fsuid;
+	kuid_t kuid;
+
+	old = current_cred();
+	old_fsuid = from_kuid_munged(old->user_ns, old->fsuid);
+
+	kuid = make_kuid(old->user_ns, uid);
+	if (!uid_valid(kuid))
+		return old_fsuid;
 
 	new = prepare_creds();
 	if (!new)
-		return current_fsuid();
-	old = current_cred();
-	old_fsuid = old->fsuid;
+		return old_fsuid;
 
-	if (uid == old->uid  || uid == old->euid  ||
-	    uid == old->suid || uid == old->fsuid ||
+	if (uid_eq(kuid, old->uid)  || uid_eq(kuid, old->euid)  ||
+	    uid_eq(kuid, old->suid) || uid_eq(kuid, old->fsuid) ||
 	    nsown_capable(CAP_SETUID)) {
-		if (uid != old_fsuid) {
-			new->fsuid = uid;
+		if (!uid_eq(kuid, old->fsuid)) {
+			new->fsuid = kuid;
 			if (security_task_fix_setuid(new, old, LSM_SETID_FS) == 0)
 				goto change_okay;
 		}
@@ -933,18 +1009,24 @@ SYSCALL_DEFINE1(setfsgid, gid_t, gid)
 	const struct cred *old;
 	struct cred *new;
 	gid_t old_fsgid;
+	kgid_t kgid;
+
+	old = current_cred();
+	old_fsgid = from_kgid_munged(old->user_ns, old->fsgid);
+
+	kgid = make_kgid(old->user_ns, gid);
+	if (!gid_valid(kgid))
+		return old_fsgid;
 
 	new = prepare_creds();
 	if (!new)
-		return current_fsgid();
-	old = current_cred();
-	old_fsgid = old->fsgid;
+		return old_fsgid;
 
-	if (gid == old->gid  || gid == old->egid  ||
-	    gid == old->sgid || gid == old->fsgid ||
+	if (gid_eq(kgid, old->gid)  || gid_eq(kgid, old->egid)  ||
+	    gid_eq(kgid, old->sgid) || gid_eq(kgid, old->fsgid) ||
 	    nsown_capable(CAP_SETGID)) {
-		if (gid != old_fsgid) {
-			new->fsgid = gid;
+		if (!gid_eq(kgid, old->fsgid)) {
+			new->fsgid = kgid;
 			goto change_okay;
 		}
 	}
@@ -1503,10 +1585,10 @@ static int check_prlimit_permission(struct task_struct *task)
 	if (cred->user_ns == tcred->user_ns &&
 	    (cred->uid == tcred->euid &&
 	     cred->uid == tcred->suid &&
-	     cred->uid == tcred->uid  &&
+	     cred->uid == tcred->uid &&
 	     cred->gid == tcred->egid &&
 	     cred->gid == tcred->sgid &&
-	     cred->gid == tcred->gid))
+		    cred->gid == tcred->gid))
 		return 0;
 	if (ns_capable(tcred->user_ns, CAP_SYS_RESOURCE))
 		return 0;
diff --git a/kernel/timer.c b/kernel/timer.c
index a297ffc..67316cb 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1427,25 +1427,25 @@ SYSCALL_DEFINE0(getppid)
 SYSCALL_DEFINE0(getuid)
 {
 	/* Only we change this so SMP safe */
-	return current_uid();
+	return from_kuid_munged(current_user_ns(), current_uid());
 }
 
 SYSCALL_DEFINE0(geteuid)
 {
 	/* Only we change this so SMP safe */
-	return current_euid();
+	return from_kuid_munged(current_user_ns(), current_euid());
 }
 
 SYSCALL_DEFINE0(getgid)
 {
 	/* Only we change this so SMP safe */
-	return current_gid();
+	return from_kgid_munged(current_user_ns(), current_gid());
 }
 
 SYSCALL_DEFINE0(getegid)
 {
 	/* Only we change this so SMP safe */
-	return  current_egid();
+	return from_kgid_munged(current_user_ns(), current_egid());
 }
 
 #endif
diff --git a/kernel/uid16.c b/kernel/uid16.c
index e530bc3..d7948eb 100644
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -81,14 +81,19 @@ SYSCALL_DEFINE3(setresuid16, old_uid_t, ruid, old_uid_t, euid, old_uid_t, suid)
 	return ret;
 }
 
-SYSCALL_DEFINE3(getresuid16, old_uid_t __user *, ruid, old_uid_t __user *, euid, old_uid_t __user *, suid)
+SYSCALL_DEFINE3(getresuid16, old_uid_t __user *, ruidp, old_uid_t __user *, euidp, old_uid_t __user *, suidp)
 {
 	const struct cred *cred = current_cred();
 	int retval;
+	old_uid_t ruid, euid, suid;
 
-	if (!(retval   = put_user(high2lowuid(cred->uid),  ruid)) &&
-	    !(retval   = put_user(high2lowuid(cred->euid), euid)))
-		retval = put_user(high2lowuid(cred->suid), suid);
+	ruid = high2lowuid(from_kuid_munged(cred->user_ns, cred->uid));
+	euid = high2lowuid(from_kuid_munged(cred->user_ns, cred->euid));
+	suid = high2lowuid(from_kuid_munged(cred->user_ns, cred->suid));
+
+	if (!(retval   = put_user(ruid, ruidp)) &&
+	    !(retval   = put_user(euid, euidp)))
+		retval = put_user(suid, suidp);
 
 	return retval;
 }
@@ -103,14 +108,19 @@ SYSCALL_DEFINE3(setresgid16, old_gid_t, rgid, old_gid_t, egid, old_gid_t, sgid)
 }
 
 
-SYSCALL_DEFINE3(getresgid16, old_gid_t __user *, rgid, old_gid_t __user *, egid, old_gid_t __user *, sgid)
+SYSCALL_DEFINE3(getresgid16, old_gid_t __user *, rgidp, old_gid_t __user *, egidp, old_gid_t __user *, sgidp)
 {
 	const struct cred *cred = current_cred();
 	int retval;
+	old_gid_t rgid, egid, sgid;
+
+	rgid = high2lowgid(from_kgid_munged(cred->user_ns, cred->gid));
+	egid = high2lowgid(from_kgid_munged(cred->user_ns, cred->egid));
+	sgid = high2lowgid(from_kgid_munged(cred->user_ns, cred->sgid));
 
-	if (!(retval   = put_user(high2lowgid(cred->gid),  rgid)) &&
-	    !(retval   = put_user(high2lowgid(cred->egid), egid)))
-		retval = put_user(high2lowgid(cred->sgid), sgid);
+	if (!(retval   = put_user(rgid, rgidp)) &&
+	    !(retval   = put_user(egid, egidp)))
+		retval = put_user(sgid, sgidp);
 
 	return retval;
 }
@@ -221,20 +231,20 @@ SYSCALL_DEFINE2(setgroups16, int, gidsetsize, old_gid_t __user *, grouplist)
 
 SYSCALL_DEFINE0(getuid16)
 {
-	return high2lowuid(current_uid());
+	return high2lowuid(from_kuid_munged(current_user_ns(), current_uid()));
 }
 
 SYSCALL_DEFINE0(geteuid16)
 {
-	return high2lowuid(current_euid());
+	return high2lowuid(from_kuid_munged(current_user_ns(), current_euid()));
 }
 
 SYSCALL_DEFINE0(getgid16)
 {
-	return high2lowgid(current_gid());
+	return high2lowgid(from_kgid_munged(current_user_ns(), current_gid()));
 }
 
 SYSCALL_DEFINE0(getegid16)
 {
-	return high2lowgid(current_egid());
+	return high2lowgid(from_kgid_munged(current_user_ns(), current_egid()));
 }
-- 
1.7.2.5

