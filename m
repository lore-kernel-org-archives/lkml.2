Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab1DDSIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 14:08:43 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44651 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab1DDSIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 14:08:42 -0400
Subject: Re: [PATCH] posix-timers: RCU conversion
From: john stultz <johnstul@us.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>, ben@iagu.net,
        Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <1301849660.2837.211.camel@edumazet-laptop>
References: <AANLkTikZZ4MXZjx_+6u-vKVSgxULQo2BkQKRO6K_vzFy@mail.gmail.com>
	 <20110318123031.GB6066@8bytes.org>
	 <AANLkTin2k1ZSLa0NG6pKBvHYnKEV21t8pEqzeJWNn_rR@mail.gmail.com>
	 <4D871F6C.40207@redhat.com>
	 <AANLkTintxnKRQ4rD4Wo8_MHU4yJVzYaRhR=GjnDMGwNj@mail.gmail.com>
	 <AANLkTin8ZoUAVR2ajoV6cBFiUSe_Dof0_k60dcAGW3r-@mail.gmail.com>
	 <4D875842.9050308@redhat.com>
	 <AANLkTikWQS281kTtJ32-qo5U+w_BAak7qUwVhUQgOxxv@mail.gmail.com>
	 <4D8773AA.8030408@redhat.com>
	 <AANLkTin3Si1EAa=Va6f45vW-tYQ1Yk8dETXpHJHHHkxe@mail.gmail.com>
	 <1300726498.2884.493.camel@edumazet-laptop> <4D8784A9.8040303@redhat.com>
	 <1300727545.2884.513.camel@edumazet-laptop>
	 <AANLkTinn7OKKKvBYe7KWsrReuYDdma5+8gHJHXdCacDY@mail.gmail.com>
	 <1300746429.2837.20.camel@edumazet-laptop>
	 <1300777760.2837.38.camel@edumazet-laptop>
	 <1301849660.2837.211.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 11:08:21 -0700
Message-ID: <1301940501.2319.25.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-03 at 18:54 +0200, Eric Dumazet wrote:
> Andrew, I submitted this patch some time ago and got no feedback from
> Thomas, John, Richard or Paul.

Sorry about that. Its been on my list.

It looks ok to me, but I not very familiar with idr locking rules
(though looking at the code the comments state that idr_find can be
safely called the way you do here).

CC'ing Oleg as I think he knows the code and is always good at catching
things.


thanks
-john


> [PATCH] posix-timers: RCU conversion
> 
> Ben Nagy reported a scalability problem with KVM/QEMU that hit very hard
> a single spinlock (idr_lock) in posix-timers code, on its 48 core
> machine.
> 
> Even on a 16 cpu machine (2x4x2), a single test can show 98% of cpu time
> used in ticket_spin_lock, from lock_timer
> 
> Ref: http://www.spinics.net/lists/kvm/msg51526.html
> 
> Switching to RCU is quite easy, IDR being already RCU ready.
> 
> idr_lock should be locked only for an insert/delete, not a lookup.
> 
> Benchmark on a 2x4x2 machine, 16 processes calling timer_gettime().
> 
> Before :
> 
> real    1m18.669s
> user    0m1.346s
> sys     1m17.180s
> 
> After :
> 
> real    0m3.296s
> user    0m1.366s
> sys     0m1.926s
> 
> Reported-by: Ben Nagy <ben@iagu.net>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Tested-by: Ben Nagy <ben@iagu.net>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <johnstul@us.ibm.com>
> Cc: Richard Cochran <richard.cochran@omicron.at>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  include/linux/posix-timers.h |    1 +
>  kernel/posix-timers.c        |   25 ++++++++++++++-----------
>  2 files changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
> index d51243a..5dc27ca 100644
> --- a/include/linux/posix-timers.h
> +++ b/include/linux/posix-timers.h
> @@ -81,6 +81,7 @@ struct k_itimer {
>  			unsigned long expires;
>  		} mmtimer;
>  	} it;
> +	struct rcu_head rcu;
>  };
> 
>  struct k_clock {
> diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
> index 4c01249..acb9be9 100644
> --- a/kernel/posix-timers.c
> +++ b/kernel/posix-timers.c
> @@ -491,6 +491,13 @@ static struct k_itimer * alloc_posix_timer(void)
>  	return tmr;
>  }
> 
> +static void k_itimer_rcu_free(struct rcu_head *head)
> +{
> +	struct k_itimer *tmr = container_of(head, struct k_itimer, rcu);
> +
> +	kmem_cache_free(posix_timers_cache, tmr);
> +}
> +
>  #define IT_ID_SET	1
>  #define IT_ID_NOT_SET	0
>  static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
> @@ -503,7 +510,7 @@ static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
>  	}
>  	put_pid(tmr->it_pid);
>  	sigqueue_free(tmr->sigq);
> -	kmem_cache_free(posix_timers_cache, tmr);
> +	call_rcu(&tmr->rcu, k_itimer_rcu_free);
>  }
> 
>  static struct k_clock *clockid_to_kclock(const clockid_t id)
> @@ -631,22 +638,18 @@ out:
>  static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags)
>  {
>  	struct k_itimer *timr;
> -	/*
> -	 * Watch out here.  We do a irqsave on the idr_lock and pass the
> -	 * flags part over to the timer lock.  Must not let interrupts in
> -	 * while we are moving the lock.
> -	 */
> -	spin_lock_irqsave(&idr_lock, *flags);
> +
> +	rcu_read_lock();
>  	timr = idr_find(&posix_timers_id, (int)timer_id);
>  	if (timr) {
> -		spin_lock(&timr->it_lock);
> +		spin_lock_irqsave(&timr->it_lock, *flags);
>  		if (timr->it_signal == current->signal) {
> -			spin_unlock(&idr_lock);
> +			rcu_read_unlock();
>  			return timr;
>  		}
> -		spin_unlock(&timr->it_lock);
> +		spin_unlock_irqrestore(&timr->it_lock, *flags);
>  	}
> -	spin_unlock_irqrestore(&idr_lock, *flags);
> +	rcu_read_unlock();
> 
>  	return NULL;
>  }
> 
> 


