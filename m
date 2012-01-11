Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab2AKNYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 08:24:34 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33863 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539Ab2AKNYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 08:24:32 -0500
Message-ID: <1326288268.2767.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [BUG] kernel freezes with latest tree
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Ahern <dsahern@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Wed, 11 Jan 2012 14:24:28 +0100
In-Reply-To: <1326284711.2442.138.camel@twins>
References: <1326171444.6638.3.camel@edumazet-laptop>
	 <1326171798.6638.4.camel@edumazet-laptop>
	 <1326183371.6638.6.camel@edumazet-laptop>
	 <1326212033.19095.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CA+55aFwNVutn=Z8N9k3CHLri=EKWX2UcN8skZvMfJ9Tg1LHCpg@mail.gmail.com>
	 <1326213442.19095.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CA+55aFyyZUJHELdbKfk2Gzpx9np7Ov74idttCo6+wi2+MAVG=g@mail.gmail.com>
	 <1326214407.19095.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CA+55aFzUSMVD84acwDGC_mqBUWg-6rdy6n_BfP6up+_V3oGx7A@mail.gmail.com>
	 <1326234230.2614.15.camel@edumazet-laptop>
	 <CA+55aFwYmX7q4MZc-xOStZB2ZQjVt_Jca6qDP+0cPKekz8yL+A@mail.gmail.com>
	 <4F0D2D9B.8030501@gmail.com> <1326272685.2442.120.camel@twins>
	 <1326284711.2442.138.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 11 janvier 2012 à 13:25 +0100, Peter Zijlstra a écrit :
> On Wed, 2012-01-11 at 10:04 +0100, Peter Zijlstra wrote:
> > Maybe adding a few more NEED_BREAK bits
> > and making it a counter and overflowing it into ABORT might be good.
> > 
> > 
> I could reproduce and confirm something like the below makes the hang
> go-away. I haven't managed to fully understand why we're stuck though
> because we do release the runqueue locks and re-enable IRQs on this
> lock-break.
> 
> My stuck machine had several CPUs stuck in a load-balance pass, so it
> could be they're bouncing tasks back and forth without actually making
> any progress what so ever.
> 
> I reproduced with hackbench 500, which results in 20000 tasks, spread
> over 24 cpus that gives some 833 tasks per runqueue on average, easily
> overflowing that lock-break scanning limit.
> 
> ---
> Subject: sched: Limit load-balance retries on lock-break
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Wed Jan 11 13:11:12 CET 2012
> 
> Eric and David reported dead machines and traced it to commit a195f004 ("sched:
> Fix load-balance lock-breaking"), it turns out there's still a
> scenario where we can end up re-trying forever.
> 
> Limit the number of retries and simply abort.
> 
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Reported-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched/fair.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3130,8 +3130,10 @@ task_hot(struct task_struct *p, u64 now,
>  }
>  
>  #define LBF_ALL_PINNED	0x01
> -#define LBF_NEED_BREAK	0x02
> -#define LBF_ABORT	0x04
> +#define LBF_NEED_BREAK	0x02	/* clears into HAD_BREAK */
> +#define LBF_HAD_BREAK	0x04
> +#define LBF_HAD_BREAKS	0x0C	/* count HAD_BREAKs overflows into ABORT */
> +#define LBF_ABORT	0x10
>  
>  /*
>   * can_migrate_task - may task p from runqueue rq be migrated to this_cpu?
> @@ -4509,6 +4511,9 @@ static int load_balance(int this_cpu, st
>  
>  		if (lb_flags & LBF_NEED_BREAK) {
>  			lb_flags &= ~LBF_NEED_BREAK;
> +			lb_flags += LBF_HAD_BREAK;
> +			if (lb_flags & LBF_ABORT)
> +				goto out_balanced;
>  			goto redo;
>  		}
>  
> 

The two lines :
	lb_flags &= ~LBF_NEED_BREAK;
	lb_flags += LBF_HAD_BREAK;

could be combined to :
	lb_flags += LBF_HAD_BREAK - LBF_NEED_BREAK;

Anyway, your patch solved the problem on my machines, thanks a lot.

$ uptime
 14:20:32 up 31 min,  2 users,  load average: 170.18, 183.00, 156.53

Tested-by: Eric Dumazet <eric.dumazet@gmail.com>

One perf top output, on the 32bit kernel, to check scheduler functions
dont use too many cycles ;)

 12.31%        hackbench  [kernel.kallsyms]             [k] __slab_free
  8.98%        hackbench  [kernel.kallsyms]             [k] _raw_spin_lock_irqsave
  6.52%        hackbench  [kernel.kallsyms]             [k] sock_alloc_send_pskb
  6.25%        hackbench  [kernel.kallsyms]             [k] _raw_spin_lock
  5.33%        hackbench  [kernel.kallsyms]             [k] fget_light
  5.04%        hackbench  [kernel.kallsyms]             [k] unix_stream_recvmsg
  4.01%        hackbench  [kernel.kallsyms]             [k] __copy_user_intel
  3.14%        hackbench  [kernel.kallsyms]             [k] __kmalloc_node_track_caller
  2.61%        hackbench  [kernel.kallsyms]             [k] __alloc_skb
  2.55%        hackbench  [kernel.kallsyms]             [k] skb_release_head_state
  2.18%        hackbench  [kernel.kallsyms]             [k] sock_wfree
  2.00%        hackbench  [kernel.kallsyms]             [k] cred_to_ucred
  1.68%        hackbench  [kernel.kallsyms]             [k] kfree
  1.65%        hackbench  [kernel.kallsyms]             [k] unix_stream_sendmsg
  1.62%        hackbench  [kernel.kallsyms]             [k] kmem_cache_alloc_node
  1.55%        hackbench  [kernel.kallsyms]             [k] unix_destruct_scm
  1.43%        hackbench  [kernel.kallsyms]             [k] __schedule
  1.39%        hackbench  [kernel.kallsyms]             [k] sched_clock_cpu
  1.37%        hackbench  [kernel.kallsyms]             [k] kmem_cache_free
  1.30%        hackbench  [kernel.kallsyms]             [k] sock_def_readable
  1.25%        hackbench  [kernel.kallsyms]             [k] __slab_alloc
  1.19%        hackbench  [kernel.kallsyms]             [k] sched_clock_local
  1.16%        hackbench  [kernel.kallsyms]             [k] fput
  1.11%        hackbench  [kernel.kallsyms]             [k] sysenter_past_esp
  0.98%        hackbench  [kernel.kallsyms]             [k] get_partial_node.isra.43
  0.93%        hackbench  [kernel.kallsyms]             [k] select_task_rq_fair
  0.81%        hackbench  [unknown]                     [.] 0xffffe424
  0.80%        hackbench  [kernel.kallsyms]             [k] update_curr
  0.75%        hackbench  [kernel.kallsyms]             [k] skb_release_data
  0.60%        hackbench  [kernel.kallsyms]             [k] try_to_wake_up
  0.56%        hackbench  [kernel.kallsyms]             [k] vfs_write
  0.54%        hackbench  libpthread-2.3.4.so           [.] __pthread_disable_asynccancel
  0.52%        hackbench  [kernel.kallsyms]             [k] update_rq_clock
  0.47%        hackbench  [kernel.kallsyms]             [k] ktime_get
  0.45%        hackbench  libpthread-2.3.4.so           [.] __pthread_enable_asynccancel
  0.45%        hackbench  [kernel.kallsyms]             [k] skb_dequeue


