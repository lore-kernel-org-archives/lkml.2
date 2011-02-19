Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab1BSRCz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 12:02:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab1BSRCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 12:02:54 -0500
Date: Sat, 19 Feb 2011 17:54:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: +
	userns-add-a-user_namespace-as-creator-owner-of-uts_namespace.patch
	added to -mm tree
Message-ID: <20110219165409.GA2712@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: userns: add a user_namespace as creator/owner of uts_namespace
> From: "Serge E. Hallyn" <serge@hallyn.com>

Minor nit... feel free to ignore, but can't resist.

--- a/kernel/nsproxy.c~userns-add-a-user_namespace-as-creator-owner-of-uts_namespace
+++ a/kernel/nsproxy.c
@@ -74,6 +74,11 @@ static struct nsproxy *create_new_namesp
 		err = PTR_ERR(new_nsp->uts_ns);
 		goto out_uts;
 	}
+	if (new_nsp->uts_ns != tsk->nsproxy->uts_ns) {
+		put_user_ns(new_nsp->uts_ns->user_ns);
+		new_nsp->uts_ns->user_ns = task_cred_xxx(tsk, user)->user_ns;
+		get_user_ns(new_nsp->uts_ns->user_ns);
+	}

Looks correct, but confusing imho.

"new_nsp->uts_ns != tsk->nsproxy->uts_ns" is a bit strange way to
check "flags & CLONE_NEWUTS", no?

And since copy_utsname() already checks CLONE_NEWUTS, can't we move
this code into copy_utsname() or clone_uts_ns() ?

This way we can also avoid the unnecessary put_user_ns(new_nsp->user_ns)
above and get_user_ns(ns->user_ns) in create_uts_ns().

The same for "userns: add a user namespace owner of ipc ns" patch, at
first glance.


Once again, this is minor. But nsproxy repeats this pattern again and
again. For example, why copy_utsname() does get_uts_ns() unconditionally?
Or copy_namespaces()->get_nsproxy() ? Of course, I do not mean the tiny
performance penalty in the unlikely case. But this complicates the
understanding of this code, imho the simple cleanup below makes sense.

Oleg.

 kernel/nsproxy.c |   30 ++++++++++--------------------
 kernel/utsname.c |   13 ++++---------
 2 files changed, 14 insertions(+), 29 deletions(-)

--- x/kernel/nsproxy.c
+++ x/kernel/nsproxy.c
@@ -120,22 +120,19 @@ int copy_namespaces(unsigned long flags,
 {
 	struct nsproxy *old_ns = tsk->nsproxy;
 	struct nsproxy *new_ns;
-	int err = 0;
 
 	if (!old_ns)
 		return 0;
 
-	get_nsproxy(old_ns);
-
 	if (!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
-				CLONE_NEWPID | CLONE_NEWNET)))
+				CLONE_NEWPID | CLONE_NEWNET))) {
+		get_nsproxy(old_ns);
 		return 0;
-
-	if (!capable(CAP_SYS_ADMIN)) {
-		err = -EPERM;
-		goto out;
 	}
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	/*
 	 * CLONE_NEWIPC must detach from the undolist: after switching
 	 * to a new ipc namespace, the semaphore arrays from the old
@@ -143,22 +140,15 @@ int copy_namespaces(unsigned long flags,
 	 * means share undolist with parent, so we must forbid using
 	 * it along with CLONE_NEWIPC.
 	 */
-	if ((flags & CLONE_NEWIPC) && (flags & CLONE_SYSVSEM)) {
-		err = -EINVAL;
-		goto out;
-	}
+	if ((flags & CLONE_NEWIPC) && (flags & CLONE_SYSVSEM))
+		return -EINVAL;
 
 	new_ns = create_new_namespaces(flags, tsk, tsk->fs);
-	if (IS_ERR(new_ns)) {
-		err = PTR_ERR(new_ns);
-		goto out;
-	}
+	if (IS_ERR(new_ns))
+		return PTR_ERR(new_ns);
 
 	tsk->nsproxy = new_ns;
-
-out:
-	put_nsproxy(old_ns);
-	return err;
+	return 0;
 }
 
 void free_nsproxy(struct nsproxy *ns)
--- x/kernel/utsname.c
+++ x/kernel/utsname.c
@@ -52,18 +52,13 @@ static struct uts_namespace *clone_uts_n
  */
 struct uts_namespace *copy_utsname(unsigned long flags, struct uts_namespace *old_ns)
 {
-	struct uts_namespace *new_ns;
-
 	BUG_ON(!old_ns);
-	get_uts_ns(old_ns);
 
-	if (!(flags & CLONE_NEWUTS))
-		return old_ns;
+	if (unlikely(flags & CLONE_NEWUTS))
+		return clone_uts_ns(old_ns);
 
-	new_ns = clone_uts_ns(old_ns);
-
-	put_uts_ns(old_ns);
-	return new_ns;
+	get_uts_ns(old_ns);
+	return old_ns;
 }
 
 void free_uts_ns(struct kref *kref)

