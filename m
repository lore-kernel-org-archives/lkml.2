Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab0GLLpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 07:45:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58061 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab0GLLpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 07:45:23 -0400
X-Authority-Analysis: v=1.1 cv=eWk9bc5BAcy1KEyGm/gc5mmqTM7Cp/ADlcqpp9MTMWU= c=1 sm=0 a=iC0lH2aJipMA:10 a=uEzv4HemXiYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=EJzxo7rHj25SfJK1AWMA:9 a=5uhFCARqgGlWeUvRP08A:7 a=-2upkoig3PoIPheuXYjdzhmqsb8A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 4/4] futex: convert hash_bucket locks to raw_spinlock_t
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mike Galbraith <mgalbraith@suse.de>
Cc: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
        linux-rt-users@vger.kernel.org
In-Reply-To: <1278855208.15197.6.camel@marge.simson.net>
References: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com>
	 <1278714780-788-5-git-send-email-dvhltc@us.ibm.com>
	 <1278790882.7352.101.camel@marge.simson.net>
	 <1278855208.15197.6.camel@marge.simson.net>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 12 Jul 2010 07:45:20 -0400
Message-ID: <1278935120.1537.187.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-11 at 15:33 +0200, Mike Galbraith wrote:
> On Sat, 2010-07-10 at 21:41 +0200, Mike Galbraith wrote:

> diff --git a/kernel/futex.c b/kernel/futex.c
> index a6cec32..ef489f3 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -2255,7 +2255,14 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
>  	/* Queue the futex_q, drop the hb lock, wait for wakeup. */
>  	futex_wait_queue_me(hb, &q, to);
>  
> -	spin_lock(&hb->lock);
> +	/*
> +	 * Non-blocking synchronization point with futex_requeue().
> +	 *
> +	 * We dare not block here because this will alter PI state, possibly
> +	 * before our waker finishes modifying same in wakeup_next_waiter().
> +	 */
> +	while(!spin_trylock(&hb->lock))
> +		cpu_relax();

I agree that this would work. But I wonder if this should have an:

#ifdef PREEMPT_RT
[...]
#else
	spin_lock(&hb->lock);
#endif

around it. Or encapsulate this lock in a macro that does the same thing
(just to keep the actual code cleaner)

-- Steve

>  	ret = handle_early_requeue_pi_wakeup(hb, &q, &key2, to);
>  	spin_unlock(&hb->lock);
>  	if (ret)
> 
> 


