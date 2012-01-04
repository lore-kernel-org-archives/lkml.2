Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab2ADAxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 19:53:33 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57558 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063Ab2ADAxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 19:53:30 -0500
Message-ID: <1325638380.3037.69.camel@work-vm>
Subject: Re: Regression: ONE CPU fails bootup at Re: [3.2.0-RC7] BUG: unable
 to handle kernel NULL pointer dereference at 0000000000000598 [   
 1.478005] IP: [<ffffffff8107a6c4>] queue_work_on+0x4/0x30
From: John Stultz <john.stultz@linaro.org>
To: NeilBrown <neilb@suse.de>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sander Eikelenboom <linux@eikelenboom.it>, stefan.bader@canonical.com,
        rjw@sisk.pl, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Date: Tue, 03 Jan 2012 16:53:00 -0800
In-Reply-To: <20120104113155.27bf6e46@notabene.brown>
References: <1599287628.20120103171351@eikelenboom.it>
	 <20120103190754.GA27651@phenom.dumpdata.com>
	 <1325632188.3037.59.camel@work-vm> <20120104113155.27bf6e46@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12010400-3534-0000-0000-00000431E201
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-04 at 11:31 +1100, NeilBrown wrote:
> On Tue, 03 Jan 2012 15:09:48 -0800 John Stultz <john.stultz@linaro.org> wrote:
> > >From the stack trace, we've kicked off a rtc_timer_do_work, probably
> > from the rtc_initialize_alarm() schedule_work call added in Neil's
> > patch.  From there, we call __rtc_set_alarm -> cmos_set_alarm ->
> > cmos_rq_disable -> cmos_checkintr -> rtc_update_irq -> schedule_work.
> > 
> > So, what it looks to me is that in cmos_checkintr, we grab the cmos->rtc
> > and pass that along. Unfortunately, since the cmos->rtc value isn't set
> > until after rtc_device_register() returns its null at that point. So
> > your patch isn't really fixing the issue, but just reducing the race
> > window for the second cpu to schedule the work.
> > 
> > Sigh. I'd guess dropping the schedule_work call from
> > rtc_initialize_alarm() is the right approach (see below). When reviewing
> > Neil's patch it seemed like a good idea there, but it seems off to me
> > now.
> > 
> > Neil, any thoughts on the following? Can you expand on the condition you
> > were worried about in around that call?
> 
> If you set an alarm in the future, then shutdown and boot again after that
> time, then you will end up with a timer_queue node which is in the past.

Thanks for explaining this again.

Hrm. It seems the easy answer is to simply not add alarms that are in
the past.  Further, I'm a bit perplexed, as if they are in the past, the
enabled flag shouldn't be set.   __rtc_read_alarm() does check the
current time, so maybe we can make sure we don't return old values? I
guess I assumed __rtc_read_alarm() avoided returning stale values, but
apparently not.

> When this happens the queue gets stuck.  That entry-in-the-past won't get
> removed until and interrupt happens and an interrupt won't happen because the
> RTC only triggers an interrupt when the alarm is "now".
> 
> So you'll find that e.g. "hwclock" will always tell you that 'select' timed
> out.
> 
> So we force the interrupt work to happen at the start just in case.

Unfortunately its too early. 

> Did you see my proposed patch which converted those calls to do the work
> in-process rather than passing it to a worker-thread?  I think that is a
> clean fix.

I don't think I saw it today. Was it from before the holidays?

Even so, at this point, I don't know if we have enough time for testing,
so I'm thinking we either just drop the problematic sched_work call or
revert the whole thing and try again for 3.3

thanks
-john


