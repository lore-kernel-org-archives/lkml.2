Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab0IQLAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 07:00:16 -0400
Received: from www.tglx.de ([62.245.132.106]:32932 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab0IQLAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 07:00:14 -0400
Date: Fri, 17 Sep 2010 12:59:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        David Brownell <david-b@pacbell.net>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH] Posix CLOCK_RTC interface proof of concept
In-Reply-To: <1284666092-23347-1-git-send-email-john.stultz@linaro.org>
Message-ID: <alpine.LFD.2.00.1009171154430.2416@localhost6.localdomain6>
References: <1284666092-23347-1-git-send-email-john.stultz@linaro.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010, John Stultz wrote:
> This patch is provided as a proof of concept, and is not submitted
> for inclusion. There are still a number of issues I'd like to decide
> upon before submitting any similar change.
> 
> 1) This implementation does not block the direct RTC alarm control via
> sysfs or chardev ioctl. It just creates a parallel interface, which
> means there are race issues if both methods are used at the same time.
> 
> I'd prefer to embed the posix timer list below the sysfs/ioctl
> interfaces, so those interfaces are in effect virtualized. Instead
> of directly accessing the hardware, alarms set via that interface
> would be only one of many possible timers managed in the timer list
> by the kernel. This will provide ABI compatibility, but will cause
> some heavy churn in the generic RTC management code.

Right.
 
> 2) While not commonly seen on PC/server hardware, many architectures
> allow for multiple RTC devices on a system. I'm not completely
> aware of the utility of multiple RTCs (other then allowing
> multiple apps to trigger multiple wake events without a kernel managed
> timer list), but I'm willing to be enlightened.

AFAICT it's mostly due to lousy RTC implementations in SoC devices
where an external RTC is way better in terms of power consuption.
 
> To resolve this, we could create a somewhat meta CLOCK_RTC, which
> really sets timers against CLOCK_REALTIME, but upon suspend
> sets a relative alarm on the RTC for time interval remaining
> on the next timer. This would probably need to be in addition to
> the per-RTC interface, as we still need the per-RTC kernel
> managed timer list to avoid races.

CLOCK_RTC should really operate in the CLOCK_REALTIME domain. We can
expose the raw value via sysfs for those who are interested in it.

We do not need extra magic on suspend. Relative timers do not care
about the time domain.
 
> 3) Adding the posix time interface makes it easier to have finer
> grained capability management to decide what applications can
> set a alarm timer. While this is great for creating applications
> that can wake servers up from suspend mode, and simplifying the
> wakeup infrastructure on cell phones, some systems may not
> want applications being able to set wakeup timers. I can
> imagine the "laptop in well insulated carry-on luggage" case
> that comes up occasional being one of them. So some additional
> thought and policy may be needed to decide when non-user-triggered
> wake events should be masked or not in suspend.

Yeah, we need some central policy control for this.
 
> diff --git a/drivers/rtc/posix.c b/drivers/rtc/posix.c

I'd prefer to move this to kernel/time/

> new file mode 100644
> index 0000000..65e6bfc
> --- /dev/null
> +++ b/drivers/rtc/posix.c
> @@ -0,0 +1,448 @@
> +/*
> + * RTC posix-clock/timer interface
> + *
> + * Copyright (C) 2010 IBM Corperation
> + *
> + * Author: John Stultz <john.stultz@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/spinlock.h>
> +#include <linux/posix-timers.h>
> +#include <linux/rbtree.h>
> +#include <linux/rtc.h>
> +#include <linux/slab.h>
> +
> +struct rtc_device *rtc;
> +
> +/*
> + * Timer list structures.
> + */
> +static DEFINE_SPINLOCK(rtctimer_lock);
> +struct rb_root timer_head;

static

> +struct rb_node *next_timer;

Ditto

> +
> +
> +/**
> + * timespec_to_time - Convert timespec to time.
> + * @ts: a timespec
> + *
> + * Helper function that converts timespec -> time.
> + * Rounds any nanoseconds up to the next second.
> + */
> +static time_t timespec_to_time(struct timespec ts)
> +{
> +	time_t time = ts.tv_sec;
> +	if (ts.tv_nsec)
> +		time++;
> +
> +	return time;
> +}
> +
> +/**
> + * time_to_timespec - Convert time to timespec
> + * @t: a time_t
> + *
> + * Helper function that converts time -> timespec
> + */
> +static struct timespec time_to_timespec(time_t t)
> +{
> +	struct timespec ts;
> +	ts.tv_sec = t;
> +	ts.tv_nsec = 0;
> +	return ts;
> +}

Those should go where the other conversion routines are as
well. That's kernel/time.c, but we should move all these helper and
conversion functions into kernel/time/lib.c

> +/**
> + * rtctimer_add_list - Add a timer to the timerlist
> + * @t: Pointer to timer to be added.
> + *
> + * The rtctimer_lock must be held when calling.
> + */
> +static void rtctimer_add_list(struct k_itimer *t)
> +{
> +	struct rb_node **p = &timer_head.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct k_itimer *ptr;
> +
> +	time_t expires = timespec_to_time(t->it.simple.it.it_value);
> +
> +	while (*p) {
> +		time_t time;
> +		parent = *p;
> +		ptr = rb_entry(parent, struct k_itimer, it.simple.list);
> +		time = timespec_to_time(ptr->it.simple.it.it_value);
> +		if (expires < time)
> +			p = &(*p)->rb_left;
> +		else
> +			p = &(*p)->rb_right;
> +	}
> +	rb_link_node(&t->it.simple.list, parent, p);
> +	rb_insert_color(&t->it.simple.list, &timer_head);
> +
> +	if (!next_timer ||
> +		expires < rb_entry(next_timer, struct k_itimer,
> +				it.simple.list)->it.simple.it.it_value.tv_sec)
> +		next_timer = &t->it.simple.list;

That's basically a copy of enqueue_hrtimer(). Can't we use
k_itimer.it.real for this and reuse the related functions in
hrtimer.c? Not sure if it's worth the trouble though.

> +/**
> + * no_nsleep - posix nsleep dummy interface
> + * @which_clock: ignored
> + * @flags: ignored
> + * @tsave: ignored
> + * @rmtp: ignored
> + *
> + * We don't implement nsleep, so this stub returns an error.

Why don't we implement that ?

> + */
> +static int no_nsleep(const clockid_t which_clock, int flags,
> +		     struct timespec *tsave, struct timespec __user *rmtp)
> +{
> +	return -EOPNOTSUPP;
> +}

do_posix_clock_nonanosleep() already implements the NOTSUP function.

> +
> +struct rtc_task irqhandler;

static 

Please move that to the other local variables

> +/**
> + * rtc_handle_irq - RTC alarm interrupt callback
> + * @data: ignored
> + *
> + * This function is called when the RTC interrupt triggers.
> + * It runs through the timer list, expiring timers,
> + * then programs the alarm to fire on the next event.
> + */
> +void rtc_handle_irq(void *data)

static

> +{
> +	unsigned long flags;
> +	struct rtc_time tm;
> +	unsigned long now;
> +	struct k_itimer *ptr;
> +	struct rtc_wkalrm alrm;

  alrm is only used in the if (ptr) patch below, move it there

> +
> +	spin_lock_irqsave(&rtctimer_lock, flags);
> +
> +	/* read the clock */
> +	rtc_read_time(rtc, &tm);
> +	rtc_tm_to_time(&tm, &now);
> +
> +	/* expire timers */
> +	ptr = rtctimer_get_next();
> +	while (ptr) {
> +		time_t exp = timespec_to_time(ptr->it.simple.it.it_value);
> +		if (now < exp)
> +			break;
> +		if (posix_timer_event(ptr, 0) != 0)
> +			ptr->it_overrun++;
> +
> +		rtctimer_del_list(ptr);
> +		if (ptr->it.simple.it.it_interval.tv_sec ||
> +				ptr->it.simple.it.it_interval.tv_nsec) {
> +			/* Handle interval timers */
> +			ptr->it.simple.it.it_value =
> +				timespec_add(ptr->it.simple.it.it_value,
> +					ptr->it.simple.it.it_interval);
> +			rtctimer_add_list(ptr);
> +		} else
> +			ptr->it.simple.enabled = 0;
> +
> +		ptr = rtctimer_get_next();
> +	}
> +
> +	/* Set the alarm to fire on the next event */
> +	ptr = rtctimer_get_next();
> +	if (ptr) {
> +		time_t exp = timespec_to_time(ptr->it.simple.it.it_value);

  New line before code please.

> +		rtc_time_to_tm(exp, &alrm.time);
> +		alrm.enabled = 1;
> +		rtc_set_alarm(rtc, &alrm);
> +	}
> +
> +	spin_unlock_irqrestore(&rtctimer_lock, flags);
> +}
> +
> +
> +
> +static int __init is_rtc(struct device *dev, void *name_ptr)
> +{
> +	*(const char **)name_ptr = dev_name(dev);
> +	return 1;
> +}
> +
> +
> +/**
> + * init_rtc_posix_timers - Set up the RTC posix interface
> + *
> + * This function sets up and installs the RTC posix interface.
> + * Locates an RTC device that is usable, registers an irq handler,
> + * and installs the rtc k_clock.
> + */
> +static __init int init_rtc_posix_timers(void)
> +{
> +	char *str = NULL;
> +	int ret;
> +	struct k_clock rtc_clock = {
> +		.clock_getres = rtc_clock_getres,
> +		.clock_get = rtc_clock_get,
> +		.clock_set = rtc_clock_set,
> +		.timer_create = rtc_timer_create,
> +		.timer_set = rtc_timer_set,
> +		.timer_del = rtc_timer_del,
> +		.timer_get = rtc_timer_get,
> +		.nsleep = no_nsleep,
> +	};
> +
> +	/* Dig up an RTC device */
> +	class_find_device(rtc_class, NULL, &str, is_rtc);

Hmm. How does that work when the rtc is loaded as a module after this?

Thanks,

	tglx
