Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab2ADOr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 09:47:58 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:56871 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2ADOr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 09:47:56 -0500
Date: Wed, 4 Jan 2012 09:46:00 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: NeilBrown <neilb@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Sander Eikelenboom <linux@eikelenboom.it>, stefan.bader@canonical.com,
        rjw@sisk.pl, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Regression: ONE CPU fails bootup at Re: [3.2.0-RC7] BUG: unable
 to handle kernel NULL pointer dereference at 0000000000000598 [ 1.478005]
 IP: [<ffffffff8107a6c4>] queue_work_on+0x4/0x30
Message-ID: <20120104144600.GB3322@phenom.dumpdata.com>
References: <1599287628.20120103171351@eikelenboom.it>
 <20120103190754.GA27651@phenom.dumpdata.com>
 <1325632188.3037.59.camel@work-vm>
 <20120104113155.27bf6e46@notabene.brown>
 <1325638380.3037.69.camel@work-vm>
 <20120104122040.5a0fa6a3@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104122040.5a0fa6a3@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4F046688.003E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 12:20:40PM +1100, NeilBrown wrote:
> On Tue, 03 Jan 2012 16:53:00 -0800 John Stultz <john.stultz@linaro.org> wrote:
> 
> > On Wed, 2012-01-04 at 11:31 +1100, NeilBrown wrote:
> > > On Tue, 03 Jan 2012 15:09:48 -0800 John Stultz <john.stultz@linaro.org> wrote:
> > > > >From the stack trace, we've kicked off a rtc_timer_do_work, probably
> > > > from the rtc_initialize_alarm() schedule_work call added in Neil's
> > > > patch.  From there, we call __rtc_set_alarm -> cmos_set_alarm ->
> > > > cmos_rq_disable -> cmos_checkintr -> rtc_update_irq -> schedule_work.
> > > > 
> > > > So, what it looks to me is that in cmos_checkintr, we grab the cmos->rtc
> > > > and pass that along. Unfortunately, since the cmos->rtc value isn't set
> > > > until after rtc_device_register() returns its null at that point. So
> > > > your patch isn't really fixing the issue, but just reducing the race
> > > > window for the second cpu to schedule the work.
> > > > 
> > > > Sigh. I'd guess dropping the schedule_work call from
> > > > rtc_initialize_alarm() is the right approach (see below). When reviewing
> > > > Neil's patch it seemed like a good idea there, but it seems off to me
> > > > now.
> > > > 
> > > > Neil, any thoughts on the following? Can you expand on the condition you
> > > > were worried about in around that call?
> > > 
> > > If you set an alarm in the future, then shutdown and boot again after that
> > > time, then you will end up with a timer_queue node which is in the past.
> > 
> > Thanks for explaining this again.
> > 
> > Hrm. It seems the easy answer is to simply not add alarms that are in
> > the past.  Further, I'm a bit perplexed, as if they are in the past, the
> > enabled flag shouldn't be set.   __rtc_read_alarm() does check the
> > current time, so maybe we can make sure we don't return old values? I
> > guess I assumed __rtc_read_alarm() avoided returning stale values, but
> > apparently not.
> 
> That would probably be a more robust approach.  Also it might make sense to
> clean out old alarms whenever we are about to add a new one.
> 
> > 
> > > When this happens the queue gets stuck.  That entry-in-the-past won't get
> > > removed until and interrupt happens and an interrupt won't happen because the
> > > RTC only triggers an interrupt when the alarm is "now".
> > > 
> > > So you'll find that e.g. "hwclock" will always tell you that 'select' timed
> > > out.
> > > 
> > > So we force the interrupt work to happen at the start just in case.
> > 
> > Unfortunately its too early. 
> > 
> > > Did you see my proposed patch which converted those calls to do the work
> > > in-process rather than passing it to a worker-thread?  I think that is a
> > > clean fix.
> > 
> > I don't think I saw it today. Was it from before the holidays?
> 
> About 4 hours ago:
>   Subject: Re: Patch Upstream: rtc: Expire alarms after the time is set.
> 
> > 
> > Even so, at this point, I don't know if we have enough time for testing,
> > so I'm thinking we either just drop the problematic sched_work call or
> > revert the whole thing and try again for 3.3
> 
> I wouldn't object to that.  The bug only triggers in unusual circumstances
> and is quite easy to work around so it is safer  to wait until we have a
> really good fix.

Linus,

Sorry for getting you in this loop so late-ish. Would it be possible to revert
93b2ec0128c431148b216b8f7337c1a52131ef03 before 3.2 is released? If there are a
couple of days to work this out we can probably come up with a proper patch but
we don't know when 3.2 is going out (presumarily today?).
