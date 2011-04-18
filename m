Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab1DRQqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:46:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39962 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab1DRQqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:46:18 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=eB1xKnnnCBQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=WLH_qwVbRxaSaptqrKIA:9 a=ru_DXoRQJfQkP7dxHE4A:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 4/7] lockdep: Seperate lock ids for read/write
 acquires
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110417095507.123045423@chello.nl>
References: <20110417094505.865828233@chello.nl>
	 <20110417095507.123045423@chello.nl>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 18 Apr 2011 12:46:17 -0400
Message-ID: <1303145177.7181.46.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-17 at 11:45 +0200, Peter Zijlstra wrote:
>  
> +/*
> + * A lock's class id is used to calculate the chain-key. Since we need to
> + * differentiate between the chains which contain the read acquire of
> + * a lock from the chains having write acquire of the same lock,
> + * we offset the class_idx by MAX_LOCKDEP_KEYS if it is a read acquire.

Don't we only care to do this if we have a recursive read? I thought
simple reads still work fine with the current algorithm?

> + *
> + * Thus the the lock's key during a chain-key calculation can be in the range
> + * 1 to 2 * MAX_LOCKDEP_KEYS - 1.
> + *
> + * LOCKDEP_CHAIN_KEY_BITS holds the number of bits required to
> + * represent this range.
> + */
> +#define LOCKDEP_CHAIN_KEY_BITS	(MAX_LOCKDEP_KEYS_BITS + 1)
>  struct held_lock {
>  	/*
>  	 * One-way hash of the dependency chain up to this point. We
> Index: linux-2.6/kernel/lockdep.c
> ===================================================================
> --- linux-2.6.orig/kernel/lockdep.c
> +++ linux-2.6/kernel/lockdep.c
> @@ -303,8 +303,8 @@ static struct list_head chainhash_table[
>   * unique.
>   */
>  #define iterate_chain_key(key1, key2) \
> -	(((key1) << MAX_LOCKDEP_KEYS_BITS) ^ \
> -	((key1) >> (64-MAX_LOCKDEP_KEYS_BITS)) ^ \
> +	(((key1) << LOCKDEP_CHAIN_KEY_BITS) ^ \
> +	((key1) >> (64 - LOCKDEP_CHAIN_KEY_BITS)) ^ \
>  	(key2))
>  
>  void lockdep_off(void)
> @@ -1988,6 +1988,9 @@ static void check_chain_key(struct task_
>  		if (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
>  			return;
>  
> +		if (is_read(hlock->rw_state))
> +			id += MAX_LOCKDEP_KEYS;

Again, isn't this about recursive reads? Or am I just confused ;)

-- Steve

> +
>  		if (prev_hlock && (prev_hlock->irq_context !=
>  							hlock->irq_context))
>  			chain_key = 0;
> @@ -2815,6 +2818,18 @@ static int __lock_acquire(struct lockdep
>  	if (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
>  		return 0;
>  
> +	/*
> +	 * Factor in the read/write state in the chain key calculation.
> +	 *
> +	 * Two chains containing lock dependencies in the same order can
> +	 * still differ due to their read/write state
> +	 * eg: lock(A)->Rlock(B) is different from lock(A)->Wlock(B)
> +	 *
> +	 * Hence distinguish between such chains.
> +	 */
> +	if (is_read(rw_state))
> +		id += MAX_LOCKDEP_KEYS;
> +
>  	chain_key = curr->curr_chain_key;
>  	if (!depth) {
>  		if (DEBUG_LOCKS_WARN_ON(chain_key != 0))
> 


