Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965316Ab0COQFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:05:05 -0400
Received: from relay1.sgi.com ([192.48.179.29]:53081 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965216Ab0COQE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:04:59 -0400
Date: Mon, 15 Mar 2010 11:04:54 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, travis@sgi.com, peterz@infradead.org,
       drepper@redhat.com, rja@sgi.com, sharyath@in.ibm.com,
       akpm@linux-foundation.org, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: sched_getaffinity(): Allow less than
	NR_CPUS length
Message-ID: <20100315160454.GA8211@sgi.com>
References: <20100312161316.9520.A69D9226@jp.fujitsu.com> <tip-cd3d8031eb4311e516329aee03c79a08333141f1@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-cd3d8031eb4311e516329aee03c79a08333141f1@git.kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 07:43:02AM +0000, tip-bot for KOSAKI Motohiro wrote:
> Commit-ID:  cd3d8031eb4311e516329aee03c79a08333141f1
> Gitweb:     http://git.kernel.org/tip/cd3d8031eb4311e516329aee03c79a08333141f1
> Author:     KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> AuthorDate: Fri, 12 Mar 2010 16:15:36 +0900
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 15 Mar 2010 08:28:44 +0100

...
> IOW we hope they are not annoyed by this issue ...

The change looks ok but I can't reproduce the problem.

I'm running on a distro kernel that has NR_CPUS=4096.  Glibc has also has a
definition of __CPU_SETSIZE (I assume this change was made by the distro but
am not certain):

    sched.c
    	...
	#if defined _SCHED_H && !defined __cpu_set_t_defined
	# define __cpu_set_t_defined
	/* Size definition for CPU sets.  */
	# define __CPU_SETSIZE  4096
	# define __NCPUBITS     (8 * sizeof (__cpu_mask))

Your test program runs ok:

	% strace t
	...
	sched_getaffinity(0, 512,  { ffff, 0, 0, 0, 0, 0, 0, 0 }) = 64



Also note that we've run on IA64 systems with NR_CPUS=4096 for several years w/o
hitting any problems.

Bottom line. I don't think the change will affect us.


> 
> sched: sched_getaffinity(): Allow less than NR_CPUS length
> 
> [ Note, this commit changes the syscall ABI for > 1024 CPUs systems. ]
> 
> Recently, some distro decided to use NR_CPUS=4096 for mysterious reasons.
> Unfortunately, glibc sched interface has the following definition:
> 
> 	# define __CPU_SETSIZE  1024
> 	# define __NCPUBITS     (8 * sizeof (__cpu_mask))
> 	typedef unsigned long int __cpu_mask;
> 	typedef struct
> 	{
> 	  __cpu_mask __bits[__CPU_SETSIZE / __NCPUBITS];
> 	} cpu_set_t;
> 
> It mean, if NR_CPUS is bigger than 1024, cpu_set_t makes an
> ABI issue ...
> 
> More recently, Sharyathi Nagesh reported following test program makes
> misterious syscall failure:
> 
>  -----------------------------------------------------------------------
>  #define _GNU_SOURCE
>  #include<stdio.h>
>  #include<errno.h>
>  #include<sched.h>
> 
>  int main()
>  {
>      cpu_set_t set;
>      if (sched_getaffinity(0, sizeof(cpu_set_t), &set) < 0)
>          printf("\n Call is failing with:%d", errno);
>  }
>  -----------------------------------------------------------------------
> 
> Because the kernel assumes len argument of sched_getaffinity() is bigger
> than NR_CPUS. But now it is not correct.
> 
> Now we are faced with the following annoying dilemma, due to
> the limitations of the glibc interface built in years ago:
> 
>  (1) if we change glibc's __CPU_SETSIZE definition, we lost
>      binary compatibility of _all_ application.
> 
>  (2) if we don't change it, we also lost binary compatibility of
>      Sharyathi's use case.
> 
> Then, I would propse to change the rule of the len argument of
> sched_getaffinity().
> 
> Old:
> 	len should be bigger than NR_CPUS
> New:
> 	len should be bigger than maximum possible cpu id
> 
> This creates the following behavior:
> 
>  (A) In the real 4096 cpus machine, the above test program still
>      return -EINVAL.
> 
>  (B) NR_CPUS=4096 but the machine have less than 1024 cpus (almost
>      all machines in the world), the above can run successfully.
> 
> Fortunatelly, BIG SGI machine is mainly used for HPC use case. It means
> they can rebuild their programs.
> 
> IOW we hope they are not annoyed by this issue ...
> 
> Reported-by: Sharyathi Nagesh <sharyath@in.ibm.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Acked-by: Ulrich Drepper <drepper@redhat.com>
> Acked-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jack Steiner <steiner@sgi.com>
> Cc: Russ Anderson <rja@sgi.com>
> Cc: Mike Travis <travis@sgi.com>
> LKML-Reference: <20100312161316.9520.A69D9226@jp.fujitsu.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/sched.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 9ab3cd7..6eaef3d 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4902,7 +4902,9 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
>  	int ret;
>  	cpumask_var_t mask;
>  
> -	if (len < cpumask_size())
> +	if (len < nr_cpu_ids)
> +		return -EINVAL;
> +	if (len & (sizeof(unsigned long)-1))
>  		return -EINVAL;
>  
>  	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
> @@ -4910,10 +4912,12 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
>  
>  	ret = sched_getaffinity(pid, mask);
>  	if (ret == 0) {
> -		if (copy_to_user(user_mask_ptr, mask, cpumask_size()))
> +		int retlen = min(len, cpumask_size());
> +
> +		if (copy_to_user(user_mask_ptr, mask, retlen))
>  			ret = -EFAULT;
>  		else
> -			ret = cpumask_size();
> +			ret = retlen;
>  	}
>  	free_cpumask_var(mask);
>  
