Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab2KPQmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:42:09 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:53136 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab2KPQmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:42:07 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
        Serge Hallyn <serge@hallyn.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Fri, 16 Nov 2012 08:35:50 -0800
Message-Id: <1353083750-3621-11-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353083750-3621-1-git-send-email-ebiederm@xmission.com>
References: <8739097bkk.fsf@xmission.com>
 <1353083750-3621-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/3io46wZkqkUuKVklETgf3jmyp05aSP4Q=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2511]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH 11/11] pidns: Support unsharing the pid namespace.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Unsharing of the pid namespace unlike unsharing of other namespaces
does not take affect immediately.  Instead it affects the children
created with fork and clone.  The first of these children becomes the init
process of the new pid namespace, the rest become oddball children
of pid 0.  From the point of view of the new pid namespace the process
that created it is pid 0, as it's pid does not map.

A couple of different semantics were considered but this one was
settled on because it is easy to implement and it is usable from
pam modules.  The core reasons for the existence of unshare.

I took a survey of the callers of pam modules and the following
appears to be a representative sample of their logic.
{
	setup stuff include pam
	child = fork();
	if (!child) {
		setuid()
                exec /bin/bash
        }
        waitpid(child);

        pam and other cleanup
}

As you can see there is a fork to create the unprivileged user
space process.  Which means that the unprivileged user space
process will appear as pid 1 in the new pid namespace.  Further
most login processes do not cope with extraneous children which
means shifting the duty of reaping extraneous child process to
the creator of those extraneous children makes the system more
comprehensible.

The practical reason for this set of pid namespace semantics is
that it is simple to implement and verify they work correctly.
Whereas an implementation that requres changing the struct
pid on a process comes with a lot more races and pain.  Not
the least of which is that glibc caches getpid().

These semantics are implemented by having two notions
of the pid namespace of a proces.  There is task_active_pid_ns
which is the pid namspace the process was created with
and the pid namespace that all pids are presented to
that process in.  The task_active_pid_ns is stored
in the struct pid of the task.

Then there is the pid namespace that will be used for children
that pid namespace is stored in task->nsproxy->pid_ns.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/fork.c          |   32 +++++++++++++++++++++++++-------
 kernel/nsproxy.c       |    2 +-
 kernel/pid_namespace.c |    2 --
 3 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 0f2bbce..811ffba 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1565,9 +1565,11 @@ long do_fork(unsigned long clone_flags,
 	 * Do some preliminary argument and permissions checking before we
 	 * actually start allocating stuff
 	 */
-	if (clone_flags & CLONE_NEWUSER) {
-		if (clone_flags & CLONE_THREAD)
+	if (clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) {
+		if (clone_flags & (CLONE_THREAD|CLONE_PARENT))
 			return -EINVAL;
+	}
+	if (clone_flags & CLONE_NEWUSER) {
 		/* hopefully this check will go away when userns support is
 		 * complete
 		 */
@@ -1692,7 +1694,8 @@ static int check_unshare_flags(unsigned long unshare_flags)
 {
 	if (unshare_flags & ~(CLONE_THREAD|CLONE_FS|CLONE_NEWNS|CLONE_SIGHAND|
 				CLONE_VM|CLONE_FILES|CLONE_SYSVSEM|
-				CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWNET))
+				CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWNET|
+				CLONE_NEWPID))
 		return -EINVAL;
 	/*
 	 * Not implemented, but pretend it works if there is nothing to
@@ -1763,15 +1766,30 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_flags)
 	int do_sysvsem = 0;
 	int err;
 
-	err = check_unshare_flags(unshare_flags);
-	if (err)
-		goto bad_unshare_out;
-
+	/*
+	 * If unsharing a pid namespace must also unshare the thread.
+	 */
+	if (unshare_flags & CLONE_NEWPID)
+		unshare_flags |= CLONE_THREAD;
+	/*
+	 * If unsharing a thread from a thread group, must also unshare vm.
+	 */
+	if (unshare_flags & CLONE_THREAD)
+		unshare_flags |= CLONE_VM;
+	/*
+	 * If unsharing vm, must also unshare signal handlers.
+	 */
+	if (unshare_flags & CLONE_VM)
+		unshare_flags |= CLONE_SIGHAND;
 	/*
 	 * If unsharing namespace, must also unshare filesystem information.
 	 */
 	if (unshare_flags & CLONE_NEWNS)
 		unshare_flags |= CLONE_FS;
+
+	err = check_unshare_flags(unshare_flags);
+	if (err)
+		goto bad_unshare_out;
 	/*
 	 * CLONE_NEWIPC must also detach from the undolist: after switching
 	 * to a new ipc namespace, the semaphore arrays from the old
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index cf37d52..2a11447 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -188,7 +188,7 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
 	int err = 0;
 
 	if (!(unshare_flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
-			       CLONE_NEWNET)))
+			       CLONE_NEWNET | CLONE_NEWPID)))
 		return 0;
 
 	if (!capable(CAP_SYS_ADMIN))
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index c6514f5..a385b98 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -143,8 +143,6 @@ struct pid_namespace *copy_pid_ns(unsigned long flags,
 {
 	if (!(flags & CLONE_NEWPID))
 		return get_pid_ns(old_ns);
-	if (flags & (CLONE_THREAD|CLONE_PARENT))
-		return ERR_PTR(-EINVAL);
 	if (task_active_pid_ns(current) != old_ns)
 		return ERR_PTR(-EINVAL);
 	return create_pid_namespace(user_ns, old_ns);
-- 
1.7.5.4

