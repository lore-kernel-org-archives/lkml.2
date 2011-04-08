Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab1DHS2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 14:28:09 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39547 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757516Ab1DHS2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 14:28:07 -0400
Date: Fri, 8 Apr 2011 11:28:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
        Richard Cochran <richard.cochran@omicron.at>, ben@iagu.net
Subject: Re: [PATCH] posix-timers: RCU conversion
Message-ID: <20110408182802.GH2277@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTikWQS281kTtJ32-qo5U+w_BAak7qUwVhUQgOxxv@mail.gmail.com>
 <4D8773AA.8030408@redhat.com>
 <AANLkTin3Si1EAa=Va6f45vW-tYQ1Yk8dETXpHJHHHkxe@mail.gmail.com>
 <1300726498.2884.493.camel@edumazet-laptop>
 <4D8784A9.8040303@redhat.com>
 <1300727545.2884.513.camel@edumazet-laptop>
 <AANLkTinn7OKKKvBYe7KWsrReuYDdma5+8gHJHXdCacDY@mail.gmail.com>
 <1300746429.2837.20.camel@edumazet-laptop>
 <1300777760.2837.38.camel@edumazet-laptop>
 <1301849660.2837.211.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301849660.2837.211.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 03, 2011 at 06:54:20PM +0200, Eric Dumazet wrote:
> Andrew, I submitted this patch some time ago and got no feedback from
> Thomas, John, Richard or Paul.
> 
> https://lkml.org/lkml/2011/3/22/29
> 
> Could you please take it in mm ?
> 
> Thanks
> 
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

Good stuff!

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
