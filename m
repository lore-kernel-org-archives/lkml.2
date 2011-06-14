Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab1FNWWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 18:22:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752529Ab1FNWV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 18:21:59 -0400
Date: Tue, 14 Jun 2011 15:24:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Max Asbock <masbock@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>,
        kay.sievers@vrfy.org, virtuoso@slind.org,
        johnstul <johnstul@linux.vnet.ibm.com>
Subject: Re: [PATCH] timerfd: really wake up processes when timer is
 cancelled on clock change
Message-Id: <20110614152408.0f4069b9.akpm@linux-foundation.org>
In-Reply-To: <1307134425.16492.104.camel@w-amax.beaverton.ibm.com>
References: <1307134425.16492.104.camel@w-amax.beaverton.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Jun 2011 13:53:45 -0700 Max Asbock <masbock@linux.vnet.ibm.com> wrote:

> When the system time is set the clock_was_set() function calls
> timerfd_clock_was_set() to cancel and wake up processes waiting on
> potential cancelable timerfd timers. However the wake up currently has
> no effect because in the case of timerfd_read it is dependent on
> ctx->ticks not being 0. timerfd_poll also requires ctx->ticks being non
> zero. As a consequence processes waiting on cancelable timers only get
> woken up when the timers expire. This patch fixes this by incrementing
> ctx->ticks before calling wake_up.
> 
> Signed-off-by: Max Asbock <masbock@linux.vnet.ibm.com>
> ---
> 
> --- linux-3.0-rc1/fs/timerfd.c
> +++ linux-3.0-rc1.timerfd/fs/timerfd.c
> @@ -61,7 +61,9 @@ static enum hrtimer_restart timerfd_tmrp
>  
>  /*
>   * Called when the clock was set to cancel the timers in the cancel
> - * list.
> + * list. This will wake up processes waiting on these timers. The
> + * wake-up requires ctx->ticks to be non zero, therefore we increment
> + * it before calling wake_up_locked().
>   */
>  void timerfd_clock_was_set(void)
>  {
> @@ -76,6 +78,7 @@ void timerfd_clock_was_set(void)
>  		spin_lock_irqsave(&ctx->wqh.lock, flags);
>  		if (ctx->moffs.tv64 != moffs.tv64) {
>  			ctx->moffs.tv64 = KTIME_MAX;
> +			ctx->ticks++;
>  			wake_up_locked(&ctx->wqh);
>  		}
>  		spin_unlock_irqrestore(&ctx->wqh.lock, flags);

Do you think this fix should be backported into -stable kernels?  If so
(or if not), why?

It sounds like it _should_ be backported.  I wonder if that will break
any apps which depend on (or work around) the current behaviour.
