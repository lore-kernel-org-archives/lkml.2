Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab2A3QSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:18:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62700 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2A3QSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:18:33 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 1/4] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve from granting privs
Date: Mon, 30 Jan 2012 08:17:26 -0800
Message-Id: <7102b0e278af50d27b5d61d1be5faaba1b0a091e.1327858005.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1327858005.git.luto@amacapital.net>
References: <cover.1327858005.git.luto@amacapital.net>
In-Reply-To: <cover.1327858005.git.luto@amacapital.net>
References: <cover.1327858005.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this set, a lot of dangerous operations (chroot, unshare, etc)
become a lot less dangerous because there is no possibility of
subverting privileged binaries.

This patch completely breaks apparmor.  Someone who understands (and
uses) apparmor should fix it or at least give me a hint.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 fs/exec.c                  |   10 +++++++++-
 include/linux/prctl.h      |   15 +++++++++++++++
 include/linux/sched.h      |    2 ++
 include/linux/security.h   |    1 +
 kernel/sys.c               |   10 ++++++++++
 security/apparmor/domain.c |    4 ++++
 security/commoncap.c       |    7 +++++--
 security/selinux/hooks.c   |   10 +++++++++-
 8 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index aeb135c..378e1bb 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1242,6 +1242,13 @@ static int check_unsafe_exec(struct linux_binprm *bprm)
 			bprm->unsafe |= LSM_UNSAFE_PTRACE;
 	}
 
+	/*
+	 * This isn't strictly necessary, but it makes it harder for LSMs to
+	 * mess up.
+	 */
+	if (current->no_new_privs)
+		bprm->unsafe |= LSM_UNSAFE_NO_NEW_PRIVS;
+
 	n_fs = 1;
 	spin_lock(&p->fs->lock);
 	rcu_read_lock();
@@ -1285,7 +1292,8 @@ int prepare_binprm(struct linux_binprm *bprm)
 	bprm->cred->euid = current_euid();
 	bprm->cred->egid = current_egid();
 
-	if (!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)) {
+	if (!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID) &&
+	    !current->no_new_privs) {
 		/* Set-uid? */
 		if (mode & S_ISUID) {
 			bprm->per_clear |= PER_CLEAR_ON_SETID;
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index 7ddc7f1..a6b5ac9 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -114,4 +114,19 @@
 # define PR_SET_MM_START_BRK		6
 # define PR_SET_MM_BRK			7
 
+/*
+ * If no_new_privs is set, then operations that grant new privileges (i.e.
+ * execve) will either fail or not grant them.  This affects suid/sgid,
+ * file capabilities, and LSMs.
+ *
+ * Operations that merely manipulate or drop existing privileges (setresuid,
+ * capset, etc.) will still work.  Drop those privileges if you want them gone.
+ *
+ * Changing LSM security domain is considered a new privilege.  So, for example,
+ * asking selinux for a specific new context (e.g. with runcon) will result
+ * in execve returning -EPERM.
+ */
+#define PR_SET_NO_NEW_PRIVS 36
+#define PR_GET_NO_NEW_PRIVS 37
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2234985..01d93b3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1314,6 +1314,8 @@ struct task_struct {
 				 * execve */
 	unsigned in_iowait:1;
 
+	/* task may not gain privileges */
+	unsigned no_new_privs:1;
 
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
diff --git a/include/linux/security.h b/include/linux/security.h
index 83c18e8..8dce830 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -129,6 +129,7 @@ struct request_sock;
 #define LSM_UNSAFE_SHARE	1
 #define LSM_UNSAFE_PTRACE	2
 #define LSM_UNSAFE_PTRACE_CAP	4
+#define LSM_UNSAFE_NO_NEW_PRIVS	8
 
 #ifdef CONFIG_MMU
 /*
diff --git a/kernel/sys.c b/kernel/sys.c
index 4070153..12e862a 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1962,6 +1962,16 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		case PR_SET_MM:
 			error = prctl_set_mm(arg2, arg3, arg4, arg5);
 			break;
+		case PR_SET_NO_NEW_PRIVS:
+			if (arg2 != 1 || arg3 || arg4 || arg5)
+				return -EINVAL;
+
+			current->no_new_privs = 1;
+			break;
+		case PR_GET_NO_NEW_PRIVS:
+			if (arg2 || arg3 || arg4 || arg5)
+				return -EINVAL;
+			return current->no_new_privs ? 1 : 0;
 		default:
 			error = -EINVAL;
 			break;
diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index c1e18ba..fcfb610 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -360,6 +360,10 @@ int apparmor_bprm_set_creds(struct linux_binprm *bprm)
 	if (bprm->cred_prepared)
 		return 0;
 
+	/* XXX: no_new_privs is not usable with AppArmor yet */
+	if (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS)
+		return -EPERM;
+
 	cxt = bprm->cred->security;
 	BUG_ON(!cxt);
 
diff --git a/security/commoncap.c b/security/commoncap.c
index 7ce191e..d700b38 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -505,14 +505,17 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
 skip:
 
 	/* Don't let someone trace a set[ug]id/setpcap binary with the revised
-	 * credentials unless they have the appropriate permit
+	 * credentials unless they have the appropriate permit.
+	 *
+	 * In addition, if NO_NEW_PRIVS, then ensure we get no new privs.
 	 */
 	if ((new->euid != old->uid ||
 	     new->egid != old->gid ||
 	     !cap_issubset(new->cap_permitted, old->cap_permitted)) &&
 	    bprm->unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
 		/* downgrade; they get no more than they had, and maybe less */
-		if (!capable(CAP_SETUID)) {
+		if (!capable(CAP_SETUID) ||
+		    (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS)) {
 			new->euid = new->uid;
 			new->egid = new->gid;
 		}
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6a3683e..18e57cc 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1998,6 +1998,13 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
 		new_tsec->sid = old_tsec->exec_sid;
 		/* Reset exec SID on execve. */
 		new_tsec->exec_sid = 0;
+
+		/*
+		 * Minimize confusion: if no_new_privs and a transition is
+		 * explicitly requested, then fail the exec.
+		 */
+		if (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS)
+			return -EPERM;
 	} else {
 		/* Check for a default transition on this program. */
 		rc = security_transition_sid(old_tsec->sid, isec->sid,
@@ -2010,7 +2017,8 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
 	COMMON_AUDIT_DATA_INIT(&ad, PATH);
 	ad.u.path = bprm->file->f_path;
 
-	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
+	if ((bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID) ||
+	    (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS))
 		new_tsec->sid = old_tsec->sid;
 
 	if (new_tsec->sid == old_tsec->sid) {
-- 
1.7.7.6

