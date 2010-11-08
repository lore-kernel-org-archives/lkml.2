Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab0KHVsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:48:50 -0500
Received: from www.tglx.de ([62.245.132.106]:37029 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681Ab0KHVss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:48:48 -0500
Date: Mon, 8 Nov 2010 22:48:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhart@linux.intel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH V3] futex: add futex_q static initializer
In-Reply-To: <1289252428-18383-1-git-send-email-dvhart@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1011082247160.2900@localhost6.localdomain6>
References: <1289250770-16533-1-git-send-email-dvhart@linux.intel.com> <1289252428-18383-1-git-send-email-dvhart@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Nov 2010, Darren Hart wrote:

> The futex_q struct has grown considerably over the last couple years. I
> believe it now merits a static initializer to avoid uninitialized data
> errors (having spent more time than I care to admit debugging an uninitialized
> q.bitset in an experimental new op code).
> 
> With the key initializer built in, several of the FUTEX_KEY_INIT calls can
> be removed.
> 
> V2: use a static variable instead of an init macro.
>     use a C99 initializer and don't rely on variable ordering in the struct.
> V3: make futex_q_init const
> 
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> CC: John Kacur <jkacur@redhat.com>
> ---
>  kernel/futex.c |   25 ++++++++++---------------
>  1 files changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index fd3fbe1..e6df2de 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -131,6 +131,12 @@ struct futex_q {
>  	u32 bitset;
>  };
>  
> +static const struct futex_q futex_q_init = {
> +	/* list gets initialized in queue_me()*/ 
> +	.key = FUTEX_KEY_INIT,
> +	.bitset = FUTEX_BITSET_MATCH_ANY
> +};
> +
>  /*
>   * Hash buckets are shared by all the futex_keys that hash to the same
>   * location.  Each key may have multiple futex_q structures, one for each task
> @@ -1751,7 +1757,6 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, unsigned int flags,
>  	 * rare, but normal.
>  	 */
>  retry:
> -	q->key = FUTEX_KEY_INIT;

You sure about that one in the retry path ?

> @@ -1906,11 +1907,7 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned int flags, int detect,
>  		hrtimer_set_expires(&to->timer, *time);
>  	}
>  
> -	q.pi_state = NULL;
> -	q.rt_waiter = NULL;
> -	q.requeue_pi_key = NULL;
>  retry:
> -	q.key = FUTEX_KEY_INIT;

Ditto

Thanks,

	tglx
