Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0GVXRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 19:17:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166Ab0GVXRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 19:17:43 -0400
Date: Thu, 22 Jul 2010 16:16:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, akinobu.mita@gmail.com,
        sboyd@codeaurora.org
Subject: Re: [PATCH] timer: Added usleep[_range] timer
Message-Id: <20100722161654.1b27b8ee.akpm@linux-foundation.org>
In-Reply-To: <4C44CDD2.1070708@codeaurora.org>
References: <4C44BB69.8050300@codeaurora.org>
	<4C44CC2E.405@linux.intel.com>
	<4C44CDD2.1070708@codeaurora.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jul 2010 15:12:34 -0700
Patrick Pannuto <ppannuto@codeaurora.org> wrote:

> Respun without interruptible...
> 

And without all the nice changelog info.  Oh well.

> usleep[_range] are finer precision implementations of msleep
> and are designed to be drop-in replacements for udelay where
> a precise sleep / busy-wait is unnecessary. They also allow
> an easy interface to specify slack when a precise (ish)
> wakeup is unnecessary to help minimize wakeups
> 
> Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
> ---
>  include/linux/delay.h |    6 ++++++
>  kernel/timer.c        |   22 ++++++++++++++++++++++
>  2 files changed, 28 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/delay.h b/include/linux/delay.h
> index fd832c6..0e303d1 100644
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
> +	usleep_range(usecs, usecs);
> +}
>  
>  static inline void ssleep(unsigned int seconds)
>  {
> diff --git a/kernel/timer.c b/kernel/timer.c
> index ee305c8..4e6746f 100644
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
> +	delta = max - min;
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

Fair enough, I guess.  People can go over and look at the
schedule_hrtimeout_range() documentation to work out why on earth they
should specify a "range".  

Of course, nobody will actually think to _use_ this thing.  Someone
owes me a "usleep_range is preferred over usleep" checkpatch rule!

