Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab0HYSOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 14:14:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab0HYSN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 14:13:59 -0400
Date: Wed, 25 Aug 2010 20:10:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, mingo@elte.hu, peterz@infradead.org
Subject: Re: [RFC V2 PATCH 1/3] timer: make try_to_del_timer_sync() safe on
	both hardirq context and UP
Message-ID: <20100825181007.GA22671@redhat.com>
References: <1282743959-5427-1-git-send-email-yong.zhang0@gmail.com> <1282743959-5427-2-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282743959-5427-2-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25, Yong Zhang wrote:
>
> From: Yong Zhang <yong.zhang@windriver.com>
>
> In commit fd450b7318b75343fd76b3d95416853e34e72c95, it was saying
> try_to_del_timer_sync() can be used in interrupt context.
>
> But because base->running_timer is SMP special, this lead to
> unsymmetry try_to_del_timer_sync() on UP and SMP.
>
> We can make running_timer live on everywhere, then try_to_del_timer_sync()
> is also UP safe and can be used in hardirq context.


Acked-by: Oleg Nesterov <oleg@redhat.com>


> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Oleg Nesterov <oleg@redhat.com>
> ---
> Hi Oleg,
> 
> How do you think about this one?
> 
> Yong
> 
>  include/linux/timer.h |    4 ++--
>  kernel/timer.c        |    6 +-----
>  2 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/timer.h b/include/linux/timer.h
> index 38cf093..225c4ce 100644
> --- a/include/linux/timer.h
> +++ b/include/linux/timer.h
> @@ -248,11 +248,11 @@ static inline void timer_stats_timer_clear_start_info(struct timer_list *timer)
>  
>  extern void add_timer(struct timer_list *timer);
>  
> +extern int try_to_del_timer_sync(struct timer_list *timer);
> +
>  #ifdef CONFIG_SMP
> -  extern int try_to_del_timer_sync(struct timer_list *timer);
>    extern int del_timer_sync(struct timer_list *timer);
>  #else
> -# define try_to_del_timer_sync(t)	del_timer(t)
>  # define del_timer_sync(t)		del_timer(t)
>  #endif
>  
> diff --git a/kernel/timer.c b/kernel/timer.c
> index 97bf05b..e031eb4 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -347,9 +347,7 @@ EXPORT_SYMBOL_GPL(set_timer_slack);
>  static inline void set_running_timer(struct tvec_base *base,
>  					struct timer_list *timer)
>  {
> -#ifdef CONFIG_SMP
>  	base->running_timer = timer;
> -#endif
>  }
>  
>  static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
> @@ -936,15 +934,12 @@ int del_timer(struct timer_list *timer)
>  }
>  EXPORT_SYMBOL(del_timer);
>  
> -#ifdef CONFIG_SMP
>  /**
>   * try_to_del_timer_sync - Try to deactivate a timer
>   * @timer: timer do del
>   *
>   * This function tries to deactivate a timer. Upon successful (ret >= 0)
>   * exit the timer is not queued and the handler is not running on any CPU.
> - *
> - * It must not be called from interrupt contexts.
>   */
>  int try_to_del_timer_sync(struct timer_list *timer)
>  {
> @@ -973,6 +968,7 @@ out:
>  }
>  EXPORT_SYMBOL(try_to_del_timer_sync);
>  
> +#ifdef CONFIG_SMP
>  /**
>   * del_timer_sync - deactivate a timer and wait for the handler to finish.
>   * @timer: the timer to be deactivated
> -- 
> 1.7.0.4
> 

