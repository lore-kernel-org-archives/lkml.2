Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab1DRQ2C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:28:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50057 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab1DRQ1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:27:55 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=JTjb3um6TXYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VnNF1IyMAAAA:8 a=_ArtiPBdsW__01qsHgsA:9 a=vYTaQh-nYXv_urse150A:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 3/7] lockdep: Annotate read/write states
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110417095507.026186002@chello.nl>
References: <20110417094505.865828233@chello.nl>
	 <20110417095507.026186002@chello.nl>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 18 Apr 2011 12:27:53 -0400
Message-ID: <1303144073.7181.39.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-17 at 11:45 +0200, Peter Zijlstra wrote:
> plain text document attachment
> (gautham_r_shenoy-lockdep-annotate_read_write_states.patch)
> From: Gautham R Shenoy <ego@in.ibm.com>
> 
> Currently we do not save the recursive read dependencies in the dependency
> chain. As a result, a deadlock caused by the following chains are not spotted,
> since we never have the chain 1 in our dependency list:
> 
>  1: Rlock(A) --> lock(B)
>  2: lock(B)  --> Wlock(A), where A is a recursive read lock.
> 
> Before adding the Recursive Read locks to the dependency chains, we need to
> distinguish them from the normal read locks since the conflicting states for
> these two are quite different.
> 
> Currently the read/write status of a lock while it's acquired is denoted by a
> monotonically increasing variable where:
> 
>  0 - WRITE
>  1 - READ
>  2 - RECURSIVE READ
> 
> In this patch, we propose to modify this distinction from a monotonically
> increasing variable to a bit mask where:
> 
>  0x1 - WRITE
>  0x2 - READ
>  0x4 - RECURSIVE READ
> 
> This helps us to define the conflicting states for each lock with ease:
> Thereby, the conflicting states for a given states are defined as follows:
> 
>  Conflicting_states(WRITE):             RECURSIVE_READ | READ | WRITE
>  Conflicting_states(READ):                               READ | WRITE
>  Conflicting_states(RECURSIVE_READ):                            WRITE
> 
> Also, we use one more bit in the bitmask to distinguish the first recursive
> read in the current chain from the others, since it is sufficient to add only
> this dependency to the dependency list.
> 
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/lockdep.h |  107 ++++++++++++++++++++++++++++++++++++------------
>  kernel/lockdep.c        |   46 ++++++++++----------
>  2 files changed, 105 insertions(+), 48 deletions(-)
> 
> Index: tip/include/linux/lockdep.h
> ===================================================================
> --- tip.orig/include/linux/lockdep.h
> +++ tip/include/linux/lockdep.h
> @@ -233,10 +233,11 @@ struct held_lock {
>  	unsigned int irq_context:2; /* bit 0 - soft, bit 1 - hard */
>  	unsigned int trylock:1;						/* 16 bits */
>  
> -	unsigned int read:2;        /* see lock_acquire() comment */
> +	unsigned int rw_state:4;        /* see lock states comment */
>  	unsigned int check:2;       /* see lock_acquire() comment */
>  	unsigned int hardirqs_off:1;
> -	unsigned int references:11;					/* 32 bits */
> +
> +	unsigned short references;
>  };
>  
>  /*
> @@ -286,6 +287,15 @@ extern void lockdep_init_map(struct lock
>  
>  #define lockdep_set_novalidate_class(lock) \
>  	lockdep_set_class(lock, &__lockdep_no_validate__)
> +
> +/* lock_state bits */
> +#define _W_		0
> +#define _R_		(_W_ + 1)
> +#define _RR_		(_W_ + 2)
> +#define _FIRST_RR_	(_W_ + 3)
> +
> +#define get_lock_state(lock_bit)	(1 << lock_bit)
> +
>  /*
>   * Compare locking classes
>   */
> @@ -298,13 +308,40 @@ static inline int lockdep_match_key(stru
>  }
>  
>  /*
> - * Acquire a lock.
> + * lock states:
> + *
> + * A given lock can have one of the following states:
> + * - STATE_WRITE: Exclusive Write.
> + * - STATE_READ: Non-recursive read.
> + * - STATE_RECURSIVE_READ: Recursive Read.
>   *

Heh, you did comment them. But please move this up, or duplicate them.

;)

-- Steve


