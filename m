Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1DRO2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:28:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40632 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab1DRO2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:28:18 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=Wz8QKhhsiWsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VnNF1IyMAAAA:8 a=CH1qRNy8lB8WkUyBMmAA:9 a=hze7KKNUM9K6OpzEydsA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 2/7] lockdep: Remove redundant read checks
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110417095506.923074742@chello.nl>
References: <20110417094505.865828233@chello.nl>
	 <20110417095506.923074742@chello.nl>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 18 Apr 2011 10:28:15 -0400
Message-ID: <1303136895.7181.35.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-17 at 11:45 +0200, Peter Zijlstra wrote:
> plain text document attachment
> (gautham_r_shenoy-lockdep-remove_redundant_read_checks_.patch)
> From: Gautham R Shenoy <ego@in.ibm.com>
> 
> Do various simplifications:
> 
> 1) In kernel/lockdep.c::validate_chain():
> 
> 	ret = check_deadlock(curr, hlock, lock, hlock->read);
> 
> ret == 2 only if hlock->read == 2.
> 
> Hence:
> 
> 	if (ret == 2)
> 		hlock->read = 2;
> 
> is redundant and can be removed.

Is this really true? From check_deadlock():

		/*
		 * Allow read-after-read recursion of the same
		 * lock class (i.e. read_lock(lock)+read_lock(lock)):
		 */
		if ((read == 2) && prev->read)
			return 2;

		/*
		 * We're holding the nest_lock, which serializes this lock's
		 * nesting behaviour.
		 */
		if (nest)
			return 2;

We return '2' also when we nest.

> 
> 2) In kernel/lockdep.c::check_prevs_add(curr, next):
> 
> 	if (hlock->read != 2)
> 		check_prev_add(curr, hlock, next, distance);
> 
> Thus, check_prev_add is called only when hlock->read != 2.
> 
> >From the conclusions of 2):
> 
> kernel/lockdep.c::check_prev_add(curr, prev, next, distance) gets called
> iff prev->read != 2.
> 
> Hence, in kernel/lockdep.c::check_prev_add(curr, prev, next, distance):
> 
> 	if (prev->read == 2)
> 		return 1;
> 
> is redunant and can be removed.

I agree with this one, but perhaps a comment should be added in its
place.

-- Steve

> 
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/lockdep.c |    9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> Index: tip/kernel/lockdep.c
> ===================================================================
> --- tip.orig/kernel/lockdep.c
> +++ tip/kernel/lockdep.c
> @@ -1676,7 +1676,7 @@ check_prev_add(struct task_struct *curr,
>  	 * write-lock never takes any other locks, then the reads are
>  	 * equivalent to a NOP.
>  	 */
> -	if (next->read == 2 || prev->read == 2)
> +	if (next->read == 2)
>  		return 1;
>  	/*
>  	 * Is the <prev> -> <next> dependency already present?
> @@ -1940,13 +1940,6 @@ static int validate_chain(struct task_st
>  		if (!ret)
>  			return 0;
>  		/*
> -		 * Mark recursive read, as we jump over it when
> -		 * building dependencies (just like we jump over
> -		 * trylock entries):
> -		 */
> -		if (ret == 2)
> -			hlock->read = 2;
> -		/*
>  		 * Add dependency only if this lock is not the head
>  		 * of the chain, and if it's not a secondary read-lock:
>  		 */
> 


