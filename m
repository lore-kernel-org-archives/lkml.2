Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab0KJIv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 03:51:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58039 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab0KJIv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 03:51:28 -0500
Message-ID: <4CDA5E40.3080205@cn.fujitsu.com>
Date: Wed, 10 Nov 2010 16:56:32 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com
Subject: Re: [PATCH RFC tip/core/rcu 11/12] rcu: fix race condition in synchronize_sched_expedited()
References: <20101107020507.GA4974@linux.vnet.ibm.com> <1289095532-5398-11-git-send-email-paulmck@linux.vnet.ibm.com> <4CD94C0D.3030007@kernel.org>
In-Reply-To: <4CD94C0D.3030007@kernel.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-10 16:51:52,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-10 16:51:53,
	Serialize complete at 2010-11-10 16:51:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2010 09:26 PM, Tejun Heo wrote:
> Hello, Paul.
> 
> 
> How about something like the following?  It's slightly bigger but I
> think it's a bit easier to understand.  Thanks.

Hello, Paul, Tejun,

I think this approach is good and much better when several tasks
call synchronize_sched_expedited() at the same time.

Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>

> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index aa14a56..0069be5 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9342,7 +9342,8 @@ EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
> 
>  #else /* #ifndef CONFIG_SMP */
> 
> -static atomic_t synchronize_sched_expedited_count = ATOMIC_INIT(0);
> +static atomic_t sync_sched_expedited_token = ATOMIC_INIT(0);
> +static atomic_t sync_sched_expedited_done = ATOMIC_INIT(0);
> 
>  static int synchronize_sched_expedited_cpu_stop(void *data)
>  {
> @@ -9373,11 +9374,18 @@ static int synchronize_sched_expedited_cpu_stop(void *data)
>   */
>  void synchronize_sched_expedited(void)
>  {
> -	int snap, trycount = 0;
> +	int my_tok, tok, t, trycount = 0;
> +
> +	smp_mb();  /* ensure prior mod happens before getting token. */
> +
> +	/*
> +	 * Get a token.  This is used to coordinate with other
> +	 * concurrent syncers and consolidate multiple syncs.
> +	 */
> +	my_tok = tok = atomic_inc_return(&sync_sched_expedited_token);
> 
> -	smp_mb();  /* ensure prior mod happens before capturing snap. */
> -	snap = atomic_read(&synchronize_sched_expedited_count) + 1;
>  	get_online_cpus();
> +
>  	while (try_stop_cpus(cpu_online_mask,
>  			     synchronize_sched_expedited_cpu_stop,
>  			     NULL) == -EAGAIN) {
> @@ -9388,13 +9396,34 @@ void synchronize_sched_expedited(void)
>  			synchronize_sched();
>  			return;
>  		}
> -		if (atomic_read(&synchronize_sched_expedited_count) - snap > 0) {
> +
> +		/*
> +		 * If the done count reached @my_tok, we know at least
> +		 * one synchronization happened since we entered this
> +		 * function.
> +		 */
> +		if (atomic_read(&sync_sched_expedited_done) - my_tok >= 0) {
>  			smp_mb(); /* ensure test happens before caller kfree */
>  			return;
>  		}
> +
>  		get_online_cpus();
> +
> +		/* about to retry, get the latest token value */
> +		tok = atomic_read(&sync_sched_expedited_token);
>  	}
> -	atomic_inc(&synchronize_sched_expedited_count);
> +
> +	/*
> +	 * We now know that everything upto @tok is synchronized.
> +	 * Update done counter which should always monotonically
> +	 * increase (with wrapping considered).
> +	 */
> +	do {
> +		t = atomic_read(&sync_sched_expedited_done);
> +		if (t - tok >= 0)
> +			break;
> +	} while (atomic_cmpxchg(&sync_sched_expedited_done, t, tok) != t);
> +
>  	smp_mb__after_atomic_inc(); /* ensure post-GP actions seen after GP. */
>  	put_online_cpus();
>  }
> 

