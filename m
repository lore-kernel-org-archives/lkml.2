Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab2B0TB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 14:01:56 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:26551 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754281Ab2B0TBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 14:01:55 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: dnmcxQ4VM1lbZLNSk3Zvz7gE_haRzDXhG8mYM9umOZmMu4v
 dnbCOVEDBW2ouWHo_cq51cpEo74yBsoFCtcFk4FKorAwalW9f3ChWWKtFIRb
 nF.uqV9dEbBpgwuo.UtSEj4sQjJPkp2119bWanSIHfYmD53hn_zNknYADBkB
 6zF4NE2MVvnJkRNxRzmvS__97VRIge5alKBJbrMbKBEJytOxFJwGbzINh9vQ
 xEaYrQx8pi5iMdUg3SXv68cv4yxN5y8vOD8C6lCYFG7FQaVT7bEcdHnlfhWo
 HTtlyriV1LhYZPNccYNaSaXNDsekv1wjluzp7WedidT3Ovph28Z7q8YjjM3i
 uoZySbaWhhqA.jB7WrIOTh7cMoBfa2HTZWiXXB2s48YDex6cjr8NEBUKYplF
 L1APSLI0HfzC9pshOuuA3RSzGeDx67yhMHjD1
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 27 Feb 2012 13:01:52 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH] fix move/migrate_pages() race on task struct
In-Reply-To: <87sjhzun47.fsf@xmission.com>
Message-ID: <alpine.DEB.2.00.1202271238450.32410@router.home>
References: <20120223180740.C4EC4156@kernel> <alpine.DEB.2.00.1202231240590.9878@router.home> <4F468F09.5050200@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231334290.10914@router.home> <4F469BC7.50705@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231536240.13554@router.home>
 <m1ehtkapn9.fsf@fess.ebiederm.org> <alpine.DEB.2.00.1202240859340.2621@router.home> <4F47BF56.6010602@linux.vnet.ibm.com> <alpine.DEB.2.00.1202241053220.3726@router.home> <alpine.DEB.2.00.1202241105280.3726@router.home> <4F47C800.4090903@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1202241131400.3726@router.home> <87sjhzun47.fsf@xmission.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Feb 2012, Eric W. Biederman wrote:

> > Ok so take a count and drop it before entering the main migration
> > function?
>
> For correct operation of kernel code a count sounds fine.
>
> If you are going to allow sleeping how do you ensure that an exec that
> happens between the taking of the reference count and checking the
> permissions does not mess things up.

Ok in that case there is a race between which of the two address space
structures (mm structs) are used. But that is up to the user to resolve if
he wants to.

> At the moment I suspect the permissions checks are not safe unless
> performed under both rcu_read_lock and task_lock to ensure that
> the task<->mm association does not change on us while we are
> working.  Even with that the cred can change under us but at least
> we know the cred will be valid until rcu_read_unlock happens.

The permissions check only refer to the task struct.

> This entire thinhg of modifying another process is a pain.
>
> Perhaps you can play with task->self_exec_id to detect an exec and fail
> the system call if there was an exec in between when we find the task
> and when we drop the task reference.

I am not sure why there would be an issue. We have to operate on one mm
the pid refers to. If it changes then we may either operate on the old
one or the new one.

We can move the determination of the mm to the last point possible to show
that it is not used earlier?


Subject: migration: Fix rcu and task refcounting

Migration functions perform the rcu_read_unlock too early. As a result the
task pointed to may change from under us.

The following patch extend the period of the rcu_read_lock until after the
permissions checks are done. We also take a refcount so that the task
reference is stable when calling security check functions and performing
cpuset node validation (which takes a mutex).

The refcount is dropped before actual page migration occurs so there is no
change to the refcounts held during page migration.

Also move the determination of the mm of the task struct to immediately
before the do_migrate*() calls so that it is clear that we switch from
handling the task during permission checks to the mm for the actual
migration.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/mempolicy.c |   25 +++++++++++++++----------
 mm/migrate.c   |   37 ++++++++++++++++++++-----------------
 2 files changed, 35 insertions(+), 27 deletions(-)

Index: linux-2.6/mm/mempolicy.c
===================================================================
--- linux-2.6.orig/mm/mempolicy.c	2012-02-27 06:27:37.322300127 -0600
+++ linux-2.6/mm/mempolicy.c	2012-02-27 06:57:56.606250374 -0600
@@ -1293,7 +1293,7 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 {
 	const struct cred *cred = current_cred(), *tcred;
 	struct mm_struct *mm = NULL;
-	struct task_struct *task;
+	struct task_struct *task = NULL;
 	nodemask_t task_nodes;
 	int err;
 	nodemask_t *old;
@@ -1322,12 +1322,9 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 		err = -ESRCH;
 		goto out;
 	}
-	mm = get_task_mm(task);
-	rcu_read_unlock();
+	get_task_struct(task);

 	err = -EINVAL;
-	if (!mm)
-		goto out;

 	/*
 	 * Check if this process has the right to modify the specified
@@ -1335,7 +1332,6 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 	 * capabilities, superuser privileges or the same
 	 * userid as the target process.
 	 */
-	rcu_read_lock();
 	tcred = __task_cred(task);
 	if (cred->euid != tcred->suid && cred->euid != tcred->uid &&
 	    cred->uid  != tcred->suid && cred->uid  != tcred->uid &&
@@ -1362,11 +1358,20 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 	if (err)
 		goto out;

-	err = do_migrate_pages(mm, old, new,
-		capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);
-out:
+	mm = get_task_mm(task);
+	put_task_struct(task);
+	task = NULL;
 	if (mm)
-		mmput(mm);
+		err = do_migrate_pages(mm, old, new,
+			capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);
+	else
+		err = -EINVAL;
+
+	mmput(mm);
+out:
+	if (task)
+		put_task_struct(task);
+
 	NODEMASK_SCRATCH_FREE(scratch);

 	return err;
Index: linux-2.6/mm/migrate.c
===================================================================
--- linux-2.6.orig/mm/migrate.c	2012-02-27 06:27:37.314300125 -0600
+++ linux-2.6/mm/migrate.c	2012-02-27 06:56:50.654252173 -0600
@@ -1176,20 +1176,17 @@ set_status:
  * Migrate an array of page address onto an array of nodes and fill
  * the corresponding array of status.
  */
-static int do_pages_move(struct mm_struct *mm, struct task_struct *task,
+static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 			 unsigned long nr_pages,
 			 const void __user * __user *pages,
 			 const int __user *nodes,
 			 int __user *status, int flags)
 {
 	struct page_to_node *pm;
-	nodemask_t task_nodes;
 	unsigned long chunk_nr_pages;
 	unsigned long chunk_start;
 	int err;

-	task_nodes = cpuset_mems_allowed(task);
-
 	err = -ENOMEM;
 	pm = (struct page_to_node *)__get_free_page(GFP_KERNEL);
 	if (!pm)
@@ -1351,6 +1348,7 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid,
 	struct task_struct *task;
 	struct mm_struct *mm;
 	int err;
+	nodemask_t task_nodes;

 	/* Check flags */
 	if (flags & ~(MPOL_MF_MOVE|MPOL_MF_MOVE_ALL))
@@ -1366,11 +1364,7 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid,
 		rcu_read_unlock();
 		return -ESRCH;
 	}
-	mm = get_task_mm(task);
-	rcu_read_unlock();
-
-	if (!mm)
-		return -EINVAL;
+	get_task_struct(task);

 	/*
 	 * Check if this process has the right to modify the specified
@@ -1378,7 +1372,6 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid,
 	 * capabilities, superuser privileges or the same
 	 * userid as the target process.
 	 */
-	rcu_read_lock();
 	tcred = __task_cred(task);
 	if (cred->euid != tcred->suid && cred->euid != tcred->uid &&
 	    cred->uid  != tcred->suid && cred->uid  != tcred->uid &&
@@ -1393,15 +1386,25 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid,
  	if (err)
 		goto out;

-	if (nodes) {
-		err = do_pages_move(mm, task, nr_pages, pages, nodes, status,
-				    flags);
-	} else {
-		err = do_pages_stat(mm, nr_pages, pages, status);
-	}
+	task_nodes = cpuset_mems_allowed(task);
+	mm = get_task_mm(task);
+	put_task_struct(task);
+	task = NULL;
+
+	if (mm) {
+		if (nodes)
+			err = do_pages_move(mm, task_nodes, nr_pages, pages, nodes,
+				status, flags);
+		else
+			err = do_pages_stat(mm, nr_pages, pages, status);
+	} else
+		err = -EINVAL;

-out:
 	mmput(mm);
+
+out:
+	if (task)
+		put_task_struct(task);
 	return err;
 }


