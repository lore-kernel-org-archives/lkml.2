Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab0G1UYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 16:24:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645Ab0G1UYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 16:24:11 -0400
Date: Wed, 28 Jul 2010 13:23:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, apw@canonical.com, corbet@lwn.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/4] timer: Added usleep[_range] timer
Message-Id: <20100728132314.29cd68c5.akpm@linux-foundation.org>
In-Reply-To: <1280345587-19725-2-git-send-email-ppannuto@codeaurora.org>
References: <1280345587-19725-1-git-send-email-ppannuto@codeaurora.org>
	<1280345587-19725-2-git-send-email-ppannuto@codeaurora.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010 12:33:04 -0700
Patrick Pannuto <ppannuto@codeaurora.org> wrote:

> diff --git a/include/linux/delay.h b/include/linux/delay.h
> index fd832c6..2538c95 100644
> --- a/include/linux/delay.h
> +++ b/include/linux/delay.h
> @@ -45,6 +45,12 @@ extern unsigned long lpj_fine;
>  void calibrate_delay(void);
>  void msleep(unsigned int msecs);
>  unsigned long msleep_interruptible(unsigned int msecs);
> +void usleep_range(unsigned long min, unsigned long max);
> +
> +static inline void usleep(unsigned long usecs)
> +{
> +	usleep_range(usecs, usecs * 2);
> +}
>  
>  static inline void ssleep(unsigned int seconds)
>  {
> diff --git a/kernel/timer.c b/kernel/timer.c
> index ee305c8..c2253dd 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1750,3 +1750,25 @@ unsigned long msleep_interruptible(unsigned int msecs)
>  }
>  
>  EXPORT_SYMBOL(msleep_interruptible);
> +
> +static int __sched do_usleep_range(unsigned long min, unsigned long max)
> +{
> +	ktime_t kmin;
> +	unsigned long delta;
> +
> +	kmin = ktime_set(0, min * NSEC_PER_USEC);
> +	delta = (max - min) * NSEC_PER_USEC;
> +	return schedule_hrtimeout_range(&kmin, delta, HRTIMER_MODE_REL);
> +}
> +
> +/**
> + * usleep_range - Drop in replacement for udelay where wakeup is flexible
> + * @min: Minimum time in usecs to sleep
> + * @max: Maximum time in usecs to sleep
> + */
> +void usleep_range(unsigned long min, unsigned long max)
> +{
> +	__set_current_state(TASK_UNINTERRUPTIBLE);
> +	do_usleep_range(min, max);
> +}
> +EXPORT_SYMBOL(usleep_range);

This is different from the patch I merged and I'm not seeing any
explanation for the change.

The implementation of usleep() looks odd.  The longer we sleep, the
greater the possible inaccuracy.  A code comment which explains the
thinking and which warns people about the implications is needed.
