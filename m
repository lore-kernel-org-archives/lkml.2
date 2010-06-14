Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab0FNUW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:22:26 -0400
Received: from www.tglx.de ([62.245.132.106]:44510 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055Ab0FNUWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:22:25 -0400
Date: Mon, 14 Jun 2010 22:21:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Suresh Rajashekara <suresh.raj+linuxomap@gmail.com>,
       linux-omap@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org
Subject: Re: Timekeeping issue on aggressive suspend/resume
In-Reply-To: <1276543557.3076.30.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1006142204340.4290@localhost.localdomain>
References: <AANLkTinIO5a1EeK6Ej2ljkuyL9zv06OMfbyiZBaxTQTd@mail.gmail.com>  <alpine.LFD.2.00.1006092206020.2933@localhost.localdomain>  <AANLkTin-6XsW49ECufTLcdzaD1eK9bAxe0j7RXvPqN7p@mail.gmail.com>  <1276199568.16089.35.camel@work-vm> 
 <AANLkTikPwOWHUdqZH1S9QVh-sgjlzptAB27_hK_otQ4Y@mail.gmail.com> <1276543557.3076.30.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010, john stultz wrote:

> On Mon, 2010-06-14 at 00:46 -0700, Suresh Rajashekara wrote:
> > On Thu, Jun 10, 2010 at 12:52 PM, john stultz <johnstul@us.ibm.com> wrote:
> > > I think Thomas was suggesting that you consider creating a option for
> > > where CLOCK_MONOTONIC included total_sleep_time.
> > >
> > > In that case the *hack* (and this is a hack, we'll need some more
> > > thoughtful discussion before anything like it could make it upstream)
> > > would be in timekeeping_resume() to comment out the lines that update
> > > wall_to_monotonic and total_sleep_time.
> > >
> > > It would be interesting to hear if that hack works for you, and we can
> > > try to come up with a better way to think about how to accommodate both
> > > views of how to account time over suspend.
> > 
> > Thanks.
> > 
> > I tried this fix. It seemed to help, however the accuracy of sleep
> > time for the process was not quite right. A process thread which was
> > supposed to wake up every (X) seconds, seemed to wake up every (X -
> > delta X) seconds.
> 
> Ah, the sleep time is probably too coarse (seconds). We probably need to
> increase the granularity from read_persistent_clock() and see if that
> helps (although most persistent clocks aren't very fine grained).
> 
> > Also another side effect of this change was that the system time was
> > no longer in sync with the wall time.
> 
> ? This doesn't make much sense to me, as you shouldn't be manipulating
> xtime differently.
> 
> Just to be clear, you mean the value from "date" doesn't match your
> watch after resume? 
> 
> > These problems were more pronounced when the suspend/wakeup cycle time
> > was brought down to 0.5 seconds from 4 seconds. The periodicity of
> > most of the process threads were disturbed.
> > 
> > I decided to NOT suspend/resume the timekeeping subsystem in the
> > kernel and try. It seemed to work. Every application seems to work
> > fine.
> > 
> > Now my question is; Is it safe to disable suspend/resume of the
> > timekeeping subsystem? Will it have an effect (on
> > functionality/performance) which may not surface in my short
> > experiments?
> 
> Well, the difficultly here is what folks actually mean by suspend. On
> some hardware it means everything is powered off, and so on resume we
> have to re-init hardware values.
> 
> It seems in your case that the hardware isn't completely powered off,
> since the clocksource you're using seemed to continue counting while the
> system was suspended. 
> 
> So in this case you might be ok. Your suspend seems closer to an deep
> idle state on x86. So suspending timekeeping might not be necessary.
> 
> However, you're right that there may be lurking issues:
> 
> 1) The suspend time would have to be limited to the clocksource's
> max_idle_ns value, since after that amount of cycles have past, we might
> overflow the accumulation function, or the clocksource may have wrapped.
> 
> 2) If the hardware does reset the clocksource at some point during the
> suspend, you'll have odd time issues.
> 
> 3) You could run into some difficulty keeping close sync with an NTP
> server, as the long delays between accumulation will probably cause an
> oscillating over-shoot and over-correction.
> 
> I suspect these different definitions of "suspend" on all of the
> different hardware types out there is going to be a growing problem in
> the near term. Especially as deep idle states start to power off more
> hardware and becomes closer to suspend in behavior.

I don't think it's really an issue. Such hardware uses a 32.768kHz
driven (RTC alike) clocksource/event which is never powered off and
not affected by suspend/resume unless you run out of battery. That
hardware provides sub second resolution (~30us) contrary to the PC
style RTC which gives you seconds only. That's really good enough for
timekeeping, NOHZ and even HIGHRES.

The NTP sync might become an issue for real long sleep times, but
that's an NTP problem and needs to be addressed seperately.

Thanks,

	tglx
