Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab0CaAkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:40:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755585Ab0CaAj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 20:39:56 -0400
Date: Tue, 30 Mar 2010 17:37:21 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, cl@linux-foundation.org,
       lee.schermerhorn@hp.com, rientjes@google.com,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "David S. Miller" <davem@davemloft.net>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Troels Liebe Bentsen <tlb@rapanden.dk>,
       linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH] exit: fix oops in sync_mm_rss
Message-Id: <20100330173721.cbd442cb.akpm@linux-foundation.org>
In-Reply-To: <20100331092815.c8b9d89c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100316170808.GA29400@redhat.com>
	<20100330135634.09e6b045.akpm@linux-foundation.org>
	<20100331092815.c8b9d89c.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010 09:28:15 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Tue, 30 Mar 2010 13:56:34 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > That new BUG_ON() is triggering in Troels's machine when a bluetooth
> > keyboard is enabled or disabled.  See
> > (https://bugzilla.kernel.org/show_bug.cgi?id=15648.
> > 
> > I guess the question is: how did a kernel thread get a non-zero
> > task->rss_stat.count[i]?  If that's expected and OK then we will need
> > to take some kernel-thread-avoidance action there.
> > 
> It seems my fault that it's not initialized to be 0 at do_fork(), copy_process.
> 
> About do_exit, do_exit() does this check. So, tsk->mm can be NULL.
> 
>  949         if (group_dead) {
>  950                 hrtimer_cancel(&tsk->signal->real_timer);
>  951                 exit_itimers(tsk->signal);
>  952                 if (tsk->mm)
>  953                         setmax_mm_hiwater_rss(&tsk->signal->maxrss, tsk->mm);
>  954         }
> 
> > Could whoever fixes this please also make __sync_task_rss_stat()
> > static.
> > 
> Ah, yes. I should do so.
> 
> > I'll toss this over to Rafael/Maciej for tracking as a post-2.6.33
> > regression.
> > 
> > Thanks.
> > 
> 
> 
> ==
> 
> task->rss_stat wasn't initialized to 0 at copy_process().
> at exit, tsk->mm may be NULL.
> And __sync_task_rss_stat() should be static.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  kernel/exit.c |    3 ++-
>  kernel/fork.c |    3 +++
>  mm/memory.c   |    2 +-
>  3 files changed, 6 insertions(+), 2 deletions(-)
> 
> Index: mmotm-2.6.34-Mar24/kernel/exit.c
> ===================================================================
> --- mmotm-2.6.34-Mar24.orig/kernel/exit.c
> +++ mmotm-2.6.34-Mar24/kernel/exit.c
> @@ -950,7 +950,8 @@ NORET_TYPE void do_exit(long code)
>  
>  	acct_update_integrals(tsk);
>  	/* sync mm's RSS info before statistics gathering */
> -	sync_mm_rss(tsk, tsk->mm);
> +	if (tsk->mm)
> +		sync_mm_rss(tsk, tsk->mm);
>  	group_dead = atomic_dec_and_test(&tsk->signal->live);
>  	if (group_dead) {
>  		hrtimer_cancel(&tsk->signal->real_timer);
> Index: mmotm-2.6.34-Mar24/mm/memory.c
> ===================================================================
> --- mmotm-2.6.34-Mar24.orig/mm/memory.c
> +++ mmotm-2.6.34-Mar24/mm/memory.c
> @@ -124,7 +124,7 @@ core_initcall(init_zero_pfn);
>  
>  #if defined(SPLIT_RSS_COUNTING)
>  
> -void __sync_task_rss_stat(struct task_struct *task, struct mm_struct *mm)
> +static void __sync_task_rss_stat(struct task_struct *task, struct mm_struct *mm)
>  {
>  	int i;
>  
> Index: mmotm-2.6.34-Mar24/kernel/fork.c
> ===================================================================
> --- mmotm-2.6.34-Mar24.orig/kernel/fork.c
> +++ mmotm-2.6.34-Mar24/kernel/fork.c
> @@ -1060,6 +1060,9 @@ static struct task_struct *copy_process(
>  	p->prev_utime = cputime_zero;
>  	p->prev_stime = cputime_zero;
>  #endif
> +#if defined(SPLIT_RSS_COUNTING)
> +	memset(&p->rss_stat, 0, sizeof(p->rss_stat));
> +#endif
>  
>  	p->default_timer_slack_ns = current->timer_slack_ns;

OK, so the kenrel thread inherited a non-zero rss_stat from a userspace
parent?

With this fixed, the test for non-zero tsk->mm is't really needed in
do_exit(), is it?  I guess it makes sense though - sync_mm_rss() only
really works for kernel threads by luck..
