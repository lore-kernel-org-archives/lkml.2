Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab0IQSmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 14:42:50 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33442 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab0IQSmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 14:42:49 -0400
Subject: Re: [PATCH] Posix CLOCK_RTC interface proof of concept
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        David Brownell <david-b@pacbell.net>,
        Richard Cochran <richardcochran@gmail.com>
In-Reply-To: <alpine.LFD.2.00.1009171154430.2416@localhost6.localdomain6>
References: <1284666092-23347-1-git-send-email-john.stultz@linaro.org>
	 <alpine.LFD.2.00.1009171154430.2416@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Sep 2010 11:42:38 -0700
Message-ID: <1284748958.2451.68.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-17 at 12:59 +0200, Thomas Gleixner wrote:
> On Thu, 16 Sep 2010, John Stultz wrote:
> > To resolve this, we could create a somewhat meta CLOCK_RTC, which
> > really sets timers against CLOCK_REALTIME, but upon suspend
> > sets a relative alarm on the RTC for time interval remaining
> > on the next timer. This would probably need to be in addition to
> > the per-RTC interface, as we still need the per-RTC kernel
> > managed timer list to avoid races.
> 
> CLOCK_RTC should really operate in the CLOCK_REALTIME domain. We can
> expose the raw value via sysfs for those who are interested in it.

So you're voting for the meta-CLOCK_RTC?  I agree that its most likely
what userland will want, however there are some extra complications to
consider:

Such as, what happens on clock_settime() ? Since the CLOCK_RTC doesn't
map to specific hardware, do we create a meta-software clock as well?
Would that confuse users who think they're actually setting the RTC (as
would be likely in common single RTC case).

How does the meta-CLOCK_RTC code know which of the possibly multiple
RTCs is the best one to use?

I'm sure there's others too. Not that we can't solve them, but just be
aware it may be quite a bit of infrastructure and code to hide the
complexity from userland. 

> We do not need extra magic on suspend. Relative timers do not care
> about the time domain.

Hrm. Maybe I'm missing what you're thinking, but if we push CLOCK_RTC
timers onto the CLOCK_REALTIME base, we will still need to program the
alarm on suspend to the next CLOCK_RTC timer, right?

Or are you suggesting that we always program the alarm for each
CLOCK_RTC timer, but just use the CLOCK_REALTIME base for expiration?


> > diff --git a/drivers/rtc/posix.c b/drivers/rtc/posix.c
> 
> I'd prefer to move this to kernel/time/

Yea, since its just a proof of concept layer on top of the rtc code, I
kept it with the rest of the rtc code. I'm sure as it gets reworked,
some of the layers (timer list handling, etc) can be pulled out and into
kernel/time/.

> > +/**
> > + * time_to_timespec - Convert time to timespec
> > + * @t: a time_t
> > + *
> > + * Helper function that converts time -> timespec
> > + */
> > +static struct timespec time_to_timespec(time_t t)
> > +{
> > +	struct timespec ts;
> > +	ts.tv_sec = t;
> > +	ts.tv_nsec = 0;
> > +	return ts;
> > +}
> 
> Those should go where the other conversion routines are as
> well. That's kernel/time.c, but we should move all these helper and
> conversion functions into kernel/time/lib.c

Yea. Although I wasn't confident that the subtle rounding (takes the
ceiling when rounding) which is correct for timer expiration is right
for all cases, so it may need some clarification when it moves to common
code.


> > +/**
> > + * rtctimer_add_list - Add a timer to the timerlist
> > + * @t: Pointer to timer to be added.
> > + *
> > + * The rtctimer_lock must be held when calling.
> > + */
> > +static void rtctimer_add_list(struct k_itimer *t)
> > +{
> > +	struct rb_node **p = &timer_head.rb_node;
> > +	struct rb_node *parent = NULL;
> > +	struct k_itimer *ptr;
> > +
> > +	time_t expires = timespec_to_time(t->it.simple.it.it_value);
> > +
> > +	while (*p) {
> > +		time_t time;
> > +		parent = *p;
> > +		ptr = rb_entry(parent, struct k_itimer, it.simple.list);
> > +		time = timespec_to_time(ptr->it.simple.it.it_value);
> > +		if (expires < time)
> > +			p = &(*p)->rb_left;
> > +		else
> > +			p = &(*p)->rb_right;
> > +	}
> > +	rb_link_node(&t->it.simple.list, parent, p);
> > +	rb_insert_color(&t->it.simple.list, &timer_head);
> > +
> > +	if (!next_timer ||
> > +		expires < rb_entry(next_timer, struct k_itimer,
> > +				it.simple.list)->it.simple.it.it_value.tv_sec)
> > +		next_timer = &t->it.simple.list;
> 
> That's basically a copy of enqueue_hrtimer(). Can't we use
> k_itimer.it.real for this and reuse the related functions in
> hrtimer.c? Not sure if it's worth the trouble though.

Yes, there's also a similar duplication in drivers/char/mmtimer.c and
Richard Cochran commented on the same (although I'm not sure if he ended
up using the hrtimer for his similar PTP code).

I was hoping to find something I could re-use in the hrtimer code, but
it seemed a little tightly linked to the fixed CLOCK_MONOTONIC/REALTIME
bases. I suspect the generic rbtree timer list implementation could be
pulled out and made more reusable, but for this proof of concept, that
seemed a bit too intrusive (I don't want to bury the basic point of what
I'm trying to do in a mountain of cleanup code :).


> > +/**
> > + * no_nsleep - posix nsleep dummy interface
> > + * @which_clock: ignored
> > + * @flags: ignored
> > + * @tsave: ignored
> > + * @rmtp: ignored
> > + *
> > + * We don't implement nsleep, so this stub returns an error.
> 
> Why don't we implement that ?

Well, I guess we could. With the RTC granularity being 1 second, I think
the idea that anyone would want to use it for nsleep seems a little
ridiculous to me. But I guess longer sleepers that need to wake the
system from suspend could make sense here. So, I sort of look at this as
a nice-to-have and will see about implementing it in the later
revisions.


> > +static __init int init_rtc_posix_timers(void)
> > +{
> > +	char *str = NULL;
> > +	int ret;
> > +	struct k_clock rtc_clock = {
> > +		.clock_getres = rtc_clock_getres,
> > +		.clock_get = rtc_clock_get,
> > +		.clock_set = rtc_clock_set,
> > +		.timer_create = rtc_timer_create,
> > +		.timer_set = rtc_timer_set,
> > +		.timer_del = rtc_timer_del,
> > +		.timer_get = rtc_timer_get,
> > +		.nsleep = no_nsleep,
> > +	};
> > +
> > +	/* Dig up an RTC device */
> > +	class_find_device(rtc_class, NULL, &str, is_rtc);
> 
> Hmm. How does that work when the rtc is loaded as a module after this?

It probably wouldn't. But this is more an issue with how the interface
is layered ontop of the rtc infrastructure, instead of the rtc
infrastructure registering the posix clock when an rtc is registered.

Thanks for the very detailed review!
-john


