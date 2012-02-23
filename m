Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab2BWSph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 13:45:37 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:46726 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752588Ab2BWSpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 13:45:36 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: JPsXRPcVM1kqEF_sEam_QsdwN3LELsCnjLg6FabH7kB1zcB
 cYUwRXr5ZZ_m0tJn28mZFyu0WSn7e2xdvNTu0YuM3sUTCK5X0pwBpSTDa.cI
 Uh1u0eUIYQd2O0jcLdrKKEX8MYmYnoCw87k5Z1j1D9cIjblFu7dBy260lN7e
 cpa8Se5_ZF7OQ8uaf0K4CVU_.80dFp1_mQ4rc6U0fsyLWKRYHvQWS8lLZGmt
 6zNsPio3q.z9vFKtG4KbfEdNmj08OTCJJdBXRU9Wva8f6JNFHH5toMuNx3tc
 hmb_OukC6m4cim.frblUXCohz8q0wFBmlYMOcTXz0JhPLTFgMXzLr3fGGEhL
 DPG_r.W3P3U4aV4WXvjdwqRNCYs1oYmka6XWcEK2UNMpu.cAwvwlshQtCRVc
 H
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 23 Feb 2012 12:45:33 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] fix move/migrate_pages() race on task struct
In-Reply-To: <20120223180740.C4EC4156@kernel>
Message-ID: <alpine.DEB.2.00.1202231240590.9878@router.home>
References: <20120223180740.C4EC4156@kernel>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012, Dave Hansen wrote:

> I think I got lucky that my task_struct was bogus in the oops
> below.  It's probably quite feasible that a task_struct could get
> freed back in to the slab, reallocated as another task_struct,
> and then we do these cred checks against a valid, but basically
> random task.

Ok I buy that.

> This patch takes the pid-to-task code along with the credential
> and security checks in sys_move_pages() and sys_migrate_pages()
> and consolidates them.  It now takes a task reference in
> the new function and requires the caller to drop it.  I
> believe this resolves the race.

And this way its safer?

> diff -puN include/linux/migrate.h~movememory-helper include/linux/migrate.h
> --- linux-2.6.git/include/linux/migrate.h~movememory-helper	2012-02-16 09:59:17.270207242 -0800
> +++ linux-2.6.git-dave/include/linux/migrate.h	2012-02-16 09:59:17.286207438 -0800
> @@ -31,6 +31,7 @@ extern int migrate_vmas(struct mm_struct
>  extern void migrate_page_copy(struct page *newpage, struct page *page);
>  extern int migrate_huge_page_move_mapping(struct address_space *mapping,
>  				  struct page *newpage, struct page *page);
> +struct task_struct *can_migrate_get_task(pid_t pid);

Could we use something easier to understand? try_get_task()?


> +++ linux-2.6.git-dave/mm/mempolicy.c	2012-02-16 09:59:17.286207438 -0800
> diff -puN mm/migrate.c~movememory-helper mm/migrate.c
> --- linux-2.6.git/mm/migrate.c~movememory-helper	2012-02-16 09:59:17.278207340 -0800
> +++ linux-2.6.git-dave/mm/migrate.c	2012-02-16 09:59:17.286207438 -0800
> @@ -1339,38 +1339,22 @@ static int do_pages_stat(struct mm_struc
>  }
>
>  /*
> - * Move a list of pages in the address space of the currently executing
> - * process.
> + * If successful, takes a task_struct reference that
> + * the caller is responsible for releasing.
>   */
> -SYSCALL_DEFINE6(move_pages, pid_t, pid, unsigned long, nr_pages,
> -		const void __user * __user *, pages,
> -		const int __user *, nodes,
> -		int __user *, status, int, flags)
> +struct task_struct *can_migrate_get_task(pid_t pid)
>  {
> -	const struct cred *cred = current_cred(), *tcred;
>  	struct task_struct *task;
> -	struct mm_struct *mm;
> -	int err;
> -
> -	/* Check flags */
> -	if (flags & ~(MPOL_MF_MOVE|MPOL_MF_MOVE_ALL))
> -		return -EINVAL;
> -
> -	if ((flags & MPOL_MF_MOVE_ALL) && !capable(CAP_SYS_NICE))
> -		return -EPERM;
> +	const struct cred *cred = current_cred(), *tcred;
> +	int err = 0;
>
> -	/* Find the mm_struct */
>  	rcu_read_lock();
>  	task = pid ? find_task_by_vpid(pid) : current;
>  	if (!task) {
>  		rcu_read_unlock();
> -		return -ESRCH;
> +		return ERR_PTR(-ESRCH);
>  	}
> -	mm = get_task_mm(task);
> -	rcu_read_unlock();
> -
> -	if (!mm)
> -		return -EINVAL;
> +	get_task_struct(task);

Hmmm isnt the race still there between the determination of the task and
the get_task_struct()? You would have to verify after the get_task_struct
that this is really the task we wanted to avoid the race.
