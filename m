Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab0GHAQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 20:16:38 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49643 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab0GHAQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 20:16:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michel Lespinasse <walken@google.com>
Subject: Re: FYI: mmap_sem OOM patch
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, Divyesh Shah <dpshah@google.com>
In-Reply-To: <20100707231134.GA26555@google.com>
References: <20100707231134.GA26555@google.com>
Message-Id: <20100708084005.CD0F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  8 Jul 2010 09:16:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> As I mentioned this in my MM discussion proposal, I am sending the following
> patch for discussion.
> 
> This helps some workloads we use, that are normally run with little memory
> headroom and get occasionally pushed over the edge to OOM. In some cases,
> the OOMing thread can't exit because it needs to acquire the mmap_sem,
> while the thread holding mmap_sem can't progress because it needs to
> allocate memory.
> 
> IIRC we first encountered this against our 2.6.18 kernel; this has been
> reproduced with 2.6.33 (sorry, we'll have to clean up that test case a bit
> before I can send it); and following patch is against 2.6.34 plus
> down_read_unfair changes (which have been discussed here before, not
> resending them at this point unless someone asks).
> 
> Note that while this patch modifies some performance critical MM functions,
> it does make sure to stay out of the fast paths.
> 
> 
> Use down_read_unfair() in OOM-killed tasks
> 
> When tasks are being targeted by OOM killer, we want to use
> down_read_unfair to ensure a fast exit.

Yup.
If admins want to kill memory hogging process manually when the system
is under heavy swap thrashing, we will face the same problem, need 
unfairness and fast exit. So, unfair exiting design looks very good.

If you will updated the description, I'm glad :)


> 
> - The down_read_unfair() call in fast_get_user_pages() is to cover the
>   futex calls in mm_release() (including exit_robust_list(),
>   compat_exit_robust_list(), exit_pi_state_list() and sys_futex())
> 
> - The down_read_unfair() call in do_page_fault() is to cover the
>   put_user() call in mm_release() and exiting the robust futex lists.

I have opposite question. Which case do we avoid to use down_read_unfair()?
You already change the fast path, I guess the reason is not for performance.
but I'm not sure exactly reason.


In other word, can we makes following or something like macro and
convert all caller?


static inline void down_read_mmap_sem(void) {
	if (unlikely(test_thread_flag(TIF_MEMDIE)))
		down_read_unfair(&mm->mmap_sem);
	else
		down_read(&mm->mmap_sem);
}




> 
> This is a rework of a previous change in 2.6.18:
> 
> Change the down_read()s in the exit path to be unfair so that we do
> not result in a potentially 3-to-4-way deadlock during the ooms.
> 
> What happens is we end up with a single thread in the oom loop (T1)
> that ends up killing a sibling thread (T2).  That sibling thread will
> need to acquire the read side of the mmap_sem in the exit path.  It's
> possible however that yet a different thread (T3) is in the middle of
> a virtual address space operation (mmap, munmap) and is enqueue to
> grab the write side of the mmap_sem behind yet another thread (T4)
> that is stuck in the OOM loop (behind T1) with mmap_sem held for read
> (like allocating a page for pagecache as part of a fault.
> 
>       T1              T2              T3              T4
>       .               .               .               .
>    oom:               .               .               .
>    oomkill            .               .               .
>       ^    \          .               .               .
>      /|\    ---->  do_exit:           .               .
>       |            sleep in           .               .
>       |            read(mmap_sem)     .               .
>       |                     \         .               .
>       |                      ----> mmap               .
>       |                            sleep in           .
>       |                            write(mmap_sem)    .
>       |                                     \         .
>       |                                      ----> fault
>       |                                            holding read(mmap_sem)
>       |                                            oom
>       |                                               |
>       |                                               /
>       \----------------------------------------------/
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index f627779..4b3a1c7 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1062,7 +1062,10 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  			bad_area_nosemaphore(regs, error_code, address);
>  			return;
>  		}
> -		down_read(&mm->mmap_sem);
> +		if (test_thread_flag(TIF_MEMDIE))
> +			down_read_unfair(&mm->mmap_sem);
> +		else
> +			down_read(&mm->mmap_sem);
>  	} else {
>  		/*
>  		 * The above down_read_trylock() might have succeeded in
> diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
> index 738e659..578d1a7 100644
> --- a/arch/x86/mm/gup.c
> +++ b/arch/x86/mm/gup.c
> @@ -357,7 +357,10 @@ slow_irqon:
>  		start += nr << PAGE_SHIFT;
>  		pages += nr;
>  
> -		down_read(&mm->mmap_sem);
> +		if (unlikely(test_thread_flag(TIF_MEMDIE)))
> +			down_read_unfair(&mm->mmap_sem);
> +		else
> +			down_read(&mm->mmap_sem);
>  		ret = get_user_pages(current, mm, start,
>  			(end - start) >> PAGE_SHIFT, write, 0, pages, NULL);
>  		up_read(&mm->mmap_sem);
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 7f2683a..2318d3a 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -664,7 +664,7 @@ static void exit_mm(struct task_struct * tsk)
>  	 * will increment ->nr_threads for each thread in the
>  	 * group with ->mm != NULL.
>  	 */
> -	down_read(&mm->mmap_sem);
> +	down_read_unfair(&mm->mmap_sem);
>  	core_state = mm->core_state;
>  	if (core_state) {
>  		struct core_thread self;

Agreed. exit_mm() should use down_read_unfair() always.
But, I think it need the explicit comment. please.



btw, MM developers only want to review mm part. can you please get ack
about down_read_unfair() itself from another developers (perhaps, 
David Howells or shomeone else).


