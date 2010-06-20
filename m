Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab0FTItq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 04:49:46 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:32930 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab0FTIto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 04:49:44 -0400
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org, Daniel Lezcano <dlezcano@fr.ibm.com>
References: <1276706068-18567-1-git-send-email-louis.rilling@kerlabs.com>
	<20100617212003.GA4182@redhat.com>
	<20100618082033.GD16877@hawkmoon.kerlabs.com>
	<20100618111554.GA3252@redhat.com> <20100618160849.GA7404@redhat.com>
	<20100618173320.GG16877@hawkmoon.kerlabs.com>
	<20100618175541.GA13680@redhat.com>
	<20100618212355.GA29478@redhat.com> <20100619190840.GA3424@redhat.com>
	<m1pqzmqema.fsf_-_@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 20 Jun 2010 01:49:37 -0700
In-Reply-To: <m1pqzmqema.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's message of "Sun\, 20 Jun 2010 01\:42\:37 -0700")
Message-ID: <m1wrtuozq6.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: oleg@redhat.com, dlezcano@fr.ibm.com, linux-kernel@vger.kernel.org, containers@lists.osdl.org, xemul@openvz.org, louis.rilling@kerlabs.com, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 6/6] pidns: Support unsharing the pid namespace.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Allow CLONEW_NEWPID into unshare.
- Pass both nsproxy->pid_ns and task_active_pid_ns to copy_pid_ns
  As they can now be different.

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

There there is the pid namespace that will be used for children
that pid namespace is stored in task->nsproxy->pid_ns.

There is one really nasty corner case in all of this.  Which
pid namespace are you in if your parent unshared it's pid
namespace and then on clone you also unshare the pid namespace.
To me there are only two possible answers.  Either the cases
is so bizarre and we deny it completely.  or the new pid
namespace is a descendent of our parent's active pid namespace,
and we ignore the task->nsproxy->pid_ns.

To that end I have modified copy_pid_ns to take both of these
pid namespaces.  The active pid namespace and the default
pid namespace of children.  Allowing me to simply implement
unsharing a pid namespace in clone after already unsharing
a pid namespace with unshare.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/pid_namespace.h |   11 ++++++-----
 kernel/fork.c                 |    3 ++-
 kernel/nsproxy.c              |    5 +++--
 kernel/pid_namespace.c        |    7 ++++---
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index b447d37..95b1d8f 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -43,7 +43,8 @@ static inline struct pid_namespace *get_pid_ns(struct pid_namespace *ns)
 	return ns;
 }
 
-extern struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *ns);
+extern struct pid_namespace *copy_pid_ns(unsigned long flags,
+	struct pid_namespace *default_ns, struct pid_namespace *active_ns);
 extern void free_pid_ns(struct kref *kref);
 extern void zap_pid_ns_processes(struct pid_namespace *pid_ns);
 
@@ -61,12 +62,12 @@ static inline struct pid_namespace *get_pid_ns(struct pid_namespace *ns)
 	return ns;
 }
 
-static inline struct pid_namespace *
-copy_pid_ns(unsigned long flags, struct pid_namespace *ns)
+static inline struct pid_namespace *copy_pid_ns(unsigned long flags,
+	struct pid_namespace *default_ns, struct pid_namespace *active_ns)
 {
 	if (flags & CLONE_NEWPID)
-		ns = ERR_PTR(-EINVAL);
-	return ns;
+		return ERR_PTR(-EINVAL);
+	return default_ns;
 }
 
 static inline void put_pid_ns(struct pid_namespace *ns)
diff --git a/kernel/fork.c b/kernel/fork.c
index 3c2501d..b452825 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1628,7 +1628,8 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_flags)
 	err = -EINVAL;
 	if (unshare_flags & ~(CLONE_THREAD|CLONE_FS|CLONE_NEWNS|CLONE_SIGHAND|
 				CLONE_VM|CLONE_FILES|CLONE_SYSVSEM|
-				CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWNET))
+				CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWNET|
+				CLONE_NEWPID))
 		goto bad_unshare_out;
 
 	/*
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index f74e6c0..6ffa36d 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -81,7 +81,8 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
 		goto out_ipc;
 	}
 
-	new_nsp->pid_ns = copy_pid_ns(flags, task_active_pid_ns(tsk));
+	new_nsp->pid_ns = copy_pid_ns(flags, tsk->nsproxy->pid_ns,
+						task_active_pid_ns(tsk));
 	if (IS_ERR(new_nsp->pid_ns)) {
 		err = PTR_ERR(new_nsp->pid_ns);
 		goto out_pid;
@@ -185,7 +186,7 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
 	int err = 0;
 
 	if (!(unshare_flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
-			       CLONE_NEWNET)))
+			       CLONE_NEWNET | CLONE_NEWPID)))
 		return 0;
 
 	if (!capable(CAP_SYS_ADMIN))
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 34a251d..7225c83 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -120,13 +120,14 @@ static void destroy_pid_namespace(struct pid_namespace *ns)
 	kmem_cache_free(pid_ns_cachep, ns);
 }
 
-struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *old_ns)
+struct pid_namespace *copy_pid_ns(unsigned long flags,
+	struct pid_namespace *default_ns, struct pid_namespace *active_ns)
 {
 	if (!(flags & CLONE_NEWPID))
-		return get_pid_ns(old_ns);
+		return get_pid_ns(default_ns);
 	if (flags & (CLONE_THREAD|CLONE_PARENT))
 		return ERR_PTR(-EINVAL);
-	return create_pid_namespace(old_ns);
+	return create_pid_namespace(active_ns);
 }
 
 void free_pid_ns(struct kref *kref)
-- 
1.6.5.2.143.g8cc62

