Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab2BXXMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 18:12:30 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:45130 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab2BXXMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 18:12:09 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christoph Lameter <cl@linux.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
References: <20120223180740.C4EC4156@kernel>
	<alpine.DEB.2.00.1202231240590.9878@router.home>
	<4F468F09.5050200@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1202231334290.10914@router.home>
	<4F469BC7.50705@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1202231536240.13554@router.home>
	<m1ehtkapn9.fsf@fess.ebiederm.org>
	<alpine.DEB.2.00.1202240859340.2621@router.home>
	<4F47BF56.6010602@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1202241053220.3726@router.home>
	<alpine.DEB.2.00.1202241105280.3726@router.home>
	<4F47C800.4090903@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1202241131400.3726@router.home>
Date: Fri, 24 Feb 2012 15:12:01 -0800
In-Reply-To: <alpine.DEB.2.00.1202241131400.3726@router.home> (Christoph
	Lameter's message of "Fri, 24 Feb 2012 11:32:59 -0600 (CST)")
Message-ID: <87zkc7eshq.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/7pJlALWAYhGubwVO14aKXiR0inGhZMOw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Christoph Lameter <cl@linux.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH] fix move/migrate_pages() race on task struct
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux.com> writes:

> On Fri, 24 Feb 2012, Dave Hansen wrote:
>
>> > Is that all safe? If not then we need to take a refcount on the task
>> > struct after all.
>>
>> Urg, no we can't sleep under an rcu_read_lock().
>
> Ok so take a count and drop it before entering the main migration
> function?

As an alternative way at looking at things.

Taking a quick look it does appear that in cpuset_mems_allowed and it's
cousins we never sleep under "callback_mutex" so that lock looks like it
could become a spinlock.

But I have to say something just bothers me about the permissions for
modifying an mm living in the task.  We can have different rules
for modifying an mm depending on the path to tme mm?

Especially in things like which numa nodes we can put pages in?

So by specifying a different pid to access them mm through the call can
either work or succeed?  Are these checks really sane?

Eric

> ---
>  mm/mempolicy.c |   12 +++++++-----
>  mm/migrate.c   |   20 +++++++++++---------
>  2 files changed, 18 insertions(+), 14 deletions(-)
>
> Index: linux-2.6/mm/mempolicy.c
> ===================================================================
> --- linux-2.6.orig/mm/mempolicy.c	2012-02-24 04:10:01.621614996 -0600
> +++ linux-2.6/mm/mempolicy.c	2012-02-24 05:01:43.621530156 -0600
> @@ -1293,7 +1293,7 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
>  {
>
>  	const struct cred *cred = current_cred(), *tcred;
>  	struct mm_struct *mm = NULL;
> -	struct task_struct *task;
> +	struct task_struct *task = NULL;
>  	nodemask_t task_nodes;
>  	int err;
>  	nodemask_t *old;
> @@ -1318,10 +1318,10 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
>  	rcu_read_lock();
>  	task = pid ? find_task_by_vpid(pid) : current;
>  	if (!task) {
> -		rcu_read_unlock();
>  		err = -ESRCH;
>  		goto out;
>  	}
> +	get_task_struct(task);
>  	mm = get_task_mm(task);
>  	rcu_read_unlock();
>
> @@ -1335,16 +1335,13 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
>  	 * capabilities, superuser privileges or the same
>  	 * userid as the target process.
>  	 */
> -	rcu_read_lock();
>  	tcred = __task_cred(task);
>  	if (cred->euid != tcred->suid && cred->euid != tcred->uid &&
>  	    cred->uid  != tcred->suid && cred->uid  != tcred->uid &&
>  	    !capable(CAP_SYS_NICE)) {
> -		rcu_read_unlock();
>  		err = -EPERM;
>  		goto out;
>  	}
> -	rcu_read_unlock();
>
>  	task_nodes = cpuset_mems_allowed(task);
>  	/* Is the user allowed to access the target nodes? */
> @@ -1362,9 +1359,14 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
>  	if (err)
>  		goto out;
>
> +	put_task_struct(task);
> +	task = NULL;
>  	err = do_migrate_pages(mm, old, new,
>  		capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);
>  out:
> +	if (task)
> +		put_task_struct(task);
> +
>  	if (mm)
>  		mmput(mm);
>  	NODEMASK_SCRATCH_FREE(scratch);
> Index: linux-2.6/mm/migrate.c
> ===================================================================
> --- linux-2.6.orig/mm/migrate.c	2012-02-24 04:10:01.609614993 -0600
> +++ linux-2.6/mm/migrate.c	2012-02-24 05:07:39.493520424 -0600
> @@ -1176,20 +1176,17 @@ set_status:
>   * Migrate an array of page address onto an array of nodes and fill
>   * the corresponding array of status.
>   */
> -static int do_pages_move(struct mm_struct *mm, struct task_struct *task,
> +static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>  			 unsigned long nr_pages,
>  			 const void __user * __user *pages,
>  			 const int __user *nodes,
>  			 int __user *status, int flags)
>  {
>  	struct page_to_node *pm;
> -	nodemask_t task_nodes;
>  	unsigned long chunk_nr_pages;
>  	unsigned long chunk_start;
>  	int err;
>
> -	task_nodes = cpuset_mems_allowed(task);
> -
>  	err = -ENOMEM;
>  	pm = (struct page_to_node *)__get_free_page(GFP_KERNEL);
>  	if (!pm)
> @@ -1351,6 +1348,7 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid,
>  	struct task_struct *task;
>  	struct mm_struct *mm;
>  	int err;
> +	nodemask_t task_nodes;
>
>  	/* Check flags */
>  	if (flags & ~(MPOL_MF_MOVE|MPOL_MF_MOVE_ALL))
> @@ -1366,6 +1364,7 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid,
>  		rcu_read_unlock();
>  		return -ESRCH;
>  	}
> +	get_task_struct(task);
>  	mm = get_task_mm(task);
>  	rcu_read_unlock();
>
> @@ -1378,30 +1377,33 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid,
>  	 * capabilities, superuser privileges or the same
>  	 * userid as the target process.
>  	 */
> -	rcu_read_lock();
>  	tcred = __task_cred(task);
>  	if (cred->euid != tcred->suid && cred->euid != tcred->uid &&
>  	    cred->uid  != tcred->suid && cred->uid  != tcred->uid &&
>  	    !capable(CAP_SYS_NICE)) {
> -		rcu_read_unlock();
>  		err = -EPERM;
>  		goto out;
>  	}
> -	rcu_read_unlock();
>
>   	err = security_task_movememory(task);
>   	if (err)
>  		goto out;
>
> +	task_nodes = cpuset_mems_allowed(task);
> +	put_task_struct(task);
> +	task = NULL;
> +
>  	if (nodes) {
> -		err = do_pages_move(mm, task, nr_pages, pages, nodes, status,
> -				    flags);
> +		err = do_pages_move(mm, task_nodes, nr_pages, pages, nodes,
> +				status, flags);
>  	} else {
>  		err = do_pages_stat(mm, nr_pages, pages, status);
>  	}
>
>  out:
>  	mmput(mm);
> +	if (task)
> +		put_task_struct(task);
>  	return err;
>  }
