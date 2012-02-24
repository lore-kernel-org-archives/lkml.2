Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab2BXRdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 12:33:04 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:48952 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755964Ab2BXRdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:33:03 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: HaC5l2AVM1kwHsNHXZNd1xb2bAyYZYqtbLLth7.bOACnrvi
 S4Qkg10hjUv24T3OIa_u0jk3smv7NUAUfWA0a2NgxpnWSxA2GZeZTJO5qST7
 3BOR0UGAkkFAU8aummQVQGm1NkhnnvsikPW41BQ9MLXeIQU_9Zfn1vWFs1B3
 cpNWelr3WGejtNGGpItIgQ4rddqdzSQh3xe.iVthjGbETtGbbLyk7joUTYRg
 kJkD7HedhAF2NTPlcBa6wSiZDBtWv9yhJekOAtAz7UkXVg__BDiWWNz0_x1s
 avJEHi.RZeeObpWx973DFn7nxaCQGqaVZ5VmZaMTgiZJvX7x9weKi1.S.VHg
 f8dIi6Uiz0p1MIbI_nqJEupmpkL5Vh5rveMZ_Y2oXlj8qA6BH5u7fjSQoYLP
 H1XaNR8pXzZsReLzFCdgIH601FAXGt1KXl9Sb
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 24 Feb 2012 11:32:59 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH] fix move/migrate_pages() race on task struct
In-Reply-To: <4F47C800.4090903@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1202241131400.3726@router.home>
References: <20120223180740.C4EC4156@kernel> <alpine.DEB.2.00.1202231240590.9878@router.home> <4F468F09.5050200@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231334290.10914@router.home> <4F469BC7.50705@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231536240.13554@router.home>
 <m1ehtkapn9.fsf@fess.ebiederm.org> <alpine.DEB.2.00.1202240859340.2621@router.home> <4F47BF56.6010602@linux.vnet.ibm.com> <alpine.DEB.2.00.1202241053220.3726@router.home> <alpine.DEB.2.00.1202241105280.3726@router.home>
 <4F47C800.4090903@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012, Dave Hansen wrote:

> > Is that all safe? If not then we need to take a refcount on the task
> > struct after all.
>
> Urg, no we can't sleep under an rcu_read_lock().

Ok so take a count and drop it before entering the main migration
function?


Signed-off-by: Christoph Lameter <cl@linux.com>


---
 mm/mempolicy.c |   12 +++++++-----
 mm/migrate.c   |   20 +++++++++++---------
 2 files changed, 18 insertions(+), 14 deletions(-)

Index: linux-2.6/mm/mempolicy.c
===================================================================
--- linux-2.6.orig/mm/mempolicy.c	2012-02-24 04:10:01.621614996 -0600
+++ linux-2.6/mm/mempolicy.c	2012-02-24 05:01:43.621530156 -0600
@@ -1293,7 +1293,7 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 {

 	const struct cred *cred = current_cred(), *tcred;
 	struct mm_struct *mm = NULL;
-	struct task_struct *task;
+	struct task_struct *task = NULL;
 	nodemask_t task_nodes;
 	int err;
 	nodemask_t *old;
@@ -1318,10 +1318,10 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 	rcu_read_lock();
 	task = pid ? find_task_by_vpid(pid) : current;
 	if (!task) {
-		rcu_read_unlock();
 		err = -ESRCH;
 		goto out;
 	}
+	get_task_struct(task);
 	mm = get_task_mm(task);
 	rcu_read_unlock();

@@ -1335,16 +1335,13 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 	 * capabilities, superuser privileges or the same
 	 * userid as the target process.
 	 */
-	rcu_read_lock();
 	tcred = __task_cred(task);
 	if (cred->euid != tcred->suid && cred->euid != tcred->uid &&
 	    cred->uid  != tcred->suid && cred->uid  != tcred->uid &&
 	    !capable(CAP_SYS_NICE)) {
-		rcu_read_unlock();
 		err = -EPERM;
 		goto out;
 	}
-	rcu_read_unlock();

 	task_nodes = cpuset_mems_allowed(task);
 	/* Is the user allowed to access the target nodes? */
@@ -1362,9 +1359,14 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 	if (err)
 		goto out;

+	put_task_struct(task);
+	task = NULL;
 	err = do_migrate_pages(mm, old, new,
 		capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);
 out:
+	if (task)
+		put_task_struct(task);
+
 	if (mm)
 		mmput(mm);
 	NODEMASK_SCRATCH_FREE(scratch);
Index: linux-2.6/mm/migrate.c
===================================================================
--- linux-2.6.orig/mm/migrate.c	2012-02-24 04:10:01.609614993 -0600
+++ linux-2.6/mm/migrate.c	2012-02-24 05:07:39.493520424 -0600
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
@@ -1366,6 +1364,7 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid,
 		rcu_read_unlock();
 		return -ESRCH;
 	}
+	get_task_struct(task);
 	mm = get_task_mm(task);
 	rcu_read_unlock();

@@ -1378,30 +1377,33 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid,
 	 * capabilities, superuser privileges or the same
 	 * userid as the target process.
 	 */
-	rcu_read_lock();
 	tcred = __task_cred(task);
 	if (cred->euid != tcred->suid && cred->euid != tcred->uid &&
 	    cred->uid  != tcred->suid && cred->uid  != tcred->uid &&
 	    !capable(CAP_SYS_NICE)) {
-		rcu_read_unlock();
 		err = -EPERM;
 		goto out;
 	}
-	rcu_read_unlock();

  	err = security_task_movememory(task);
  	if (err)
 		goto out;

+	task_nodes = cpuset_mems_allowed(task);
+	put_task_struct(task);
+	task = NULL;
+
 	if (nodes) {
-		err = do_pages_move(mm, task, nr_pages, pages, nodes, status,
-				    flags);
+		err = do_pages_move(mm, task_nodes, nr_pages, pages, nodes,
+				status, flags);
 	} else {
 		err = do_pages_stat(mm, nr_pages, pages, status);
 	}

 out:
 	mmput(mm);
+	if (task)
+		put_task_struct(task);
 	return err;
 }

