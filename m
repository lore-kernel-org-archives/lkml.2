Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab2ALXiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 18:38:55 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47842 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab2ALXix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 18:38:53 -0500
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        wad@chromium.org, luto@mit.edu, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk
Subject: [PATCH PLACEHOLDER 1/3] fs/exec: "always_unprivileged" patch
Date: Thu, 12 Jan 2012 17:38:24 -0600
Message-Id: <1326411506-16894-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a placeholder until Andy's (luto@mit.edu) patch arrives
implementing Linus's proposal for applying a "this is a process that has
*no* extra privileges at all, and can never get them".

It adds the "always_unprivileged" member to the task_struct and the
ability for a process to set it to 1 via prctl.  Fixup is then done
alongside MNT_NOSUID in fs/exec.c and security/commoncap.c
(as Eric Paris suggested).

selinux/hooks.c have not been touched but need a similar one line
change.  That said, this is just a placeholder and is not meant to
be authoritative: I look forward to Andy's patches!

Signed-off-by: Will Drewry <wad@chromium.org>
---
 fs/exec.c             |    3 ++-
 include/linux/prctl.h |    6 ++++++
 include/linux/sched.h |    1 +
 kernel/sys.c          |    4 +++-
 security/commoncap.c  |    3 ++-
 5 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 3625464..ce0e477 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1281,7 +1281,8 @@ int prepare_binprm(struct linux_binprm *bprm)
 	bprm->cred->euid = current_euid();
 	bprm->cred->egid = current_egid();
 
-	if (!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)) {
+	if (!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID) &&
+	    !current->always_unprivileged) {
 		/* Set-uid? */
 		if (mode & S_ISUID) {
 			bprm->per_clear |= PER_CLEAR_ON_SETID;
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index a3baeb2..d5d6ab6 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -102,4 +102,10 @@
 
 #define PR_MCE_KILL_GET 34
 
+/*
+ * Set this to ensure that a process and any of its descendents may never
+ * escalate privileges (only reduce them).
+ */
+#define PR_SET_ALWAYS_UNPRIVILEGED 35
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1c4f3e9..2d6af15 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1402,6 +1402,7 @@ struct task_struct {
 	unsigned int sessionid;
 #endif
 	seccomp_t seccomp;
+	int always_unprivileged;
 
 /* Thread group tracking */
    	u32 parent_exec_id;
diff --git a/kernel/sys.c b/kernel/sys.c
index 481611f..fbb6248 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1776,7 +1776,6 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		case PR_SET_ENDIAN:
 			error = SET_ENDIAN(me, arg2);
 			break;
-
 		case PR_GET_SECCOMP:
 			error = prctl_get_seccomp();
 			break;
@@ -1841,6 +1840,9 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			else
 				error = PR_MCE_KILL_DEFAULT;
 			break;
+		case PR_SET_ALWAYS_UNPRIVILEGED:
+			current->always_unprivileged = 1;
+			break;
 		default:
 			error = -EINVAL;
 			break;
diff --git a/security/commoncap.c b/security/commoncap.c
index ee4f848..ca94952 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -439,7 +439,8 @@ static int get_file_caps(struct linux_binprm *bprm, bool *effective, bool *has_c
 	if (!file_caps_enabled)
 		return 0;
 
-	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID)
+	if ((bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID) ||
+	    current->always_unprivileged)
 		return 0;
 
 	dentry = dget(bprm->file->f_dentry);
-- 
1.7.5.4

