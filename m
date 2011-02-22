Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab1BVTfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:35:25 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52250 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab1BVTfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:35:23 -0500
Subject: Re: [rtc-linux] [PATCH 04/10] RTC: Cleanup
 rtc_class_ops->read_alarm()
From: john stultz <johnstul@us.ibm.com>
To: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
In-Reply-To: <AANLkTinMPnJj+ca+=ujU=5rhK3Nh0qrFGe955zZWjYaf@mail.gmail.com>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
	 <1298332538-31216-5-git-send-email-john.stultz@linaro.org>
	 <20110222023452.GB18299@sirena.org.uk> <1298343333.4222.36.camel@work-vm>
	 <1298362178.4222.57.camel@work-vm>
	 <AANLkTinMPnJj+ca+=ujU=5rhK3Nh0qrFGe955zZWjYaf@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Feb 2011 11:35:10 -0800
Message-ID: <1298403310.9215.26.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 09:51 -0300, Marcelo Roberto Jimenez wrote:
> Hi Folks,
> 
> On Tue, Feb 22, 2011 at 05:09, john stultz <johnstul@us.ibm.com> wrote:
> > On Mon, 2011-02-21 at 18:55 -0800, John Stultz wrote:
> >> On Tue, 2011-02-22 at 02:34 +0000, Mark Brown wrote:
> >> > Can you go into more detail on the rationale behind this virtualised
> >> > functionality and how it works?  I'd really expect the RTC alarm to be
> >> > preserved over system reboots (on some systems it can be used to
> >> > initiate a boot) and that would mean that we need to go to the hardware
> >> > for at least the initial configuration.
> > [snip]
> >> Now, to your point about persistence across reboots:
> >>
> >> It is an interesting point to consider.
> >>
> >> So currently, if the hardware supports it, then the behavior should
> >> remain the same: As long as no application sets a new alarm, the
> >> previous alarm should persist in the RTC hardware.
> >>
> >> However, an application's ability to notice that such an alarm is set,
> >> is currently limited.  So your point about reading the hardware to
> >> initialize the state is quite valid, and shows a good reason to preserve
> >> the read_alarm() method.
> 
> Does it matter to application 1 that application 2 has set an alarm
> before or after the time it has previously set it? With multiplexed
> events, what is the semantic of read_alarm()? Should it return only
> the closest alarm to trigger of the application that calls it or
> should it return the closest alarm of the system?

So the semantics of read_alarm (well, to be clear: RTC_ALM_READ) should
be to return the time that the aie timer will fire. In the past, that
was the raw value the hardware was set to.  Now that timer is now
virtualized, we return the expiration value of the rtc-device's
aie_timer.

This preserves the previous behavior.  If there are other rtc timers set
to fire before the aie_timer, the RTC_ALM_READ should still return the
time that was programmed in with RTC_ALM_SET. 

The problem being in the case of a system reboot, we lose our event
queue, and only the last value set is remembered. We don't know the
source of the last value (weather it was from an RTC_ALM_SET ioctl, or
maybe from a posix-alarm-timer). So the question of what is the proper
behavior is a little open here.


> > So I've been working on a fix for the issue described here, but have run
> > into a few complications:
> >
> > 1) Prior to my rework landing, on the rtc-cmos driver, after a reboot,
> > calls to rtc_read_alarm() do return the alarm time from hardware.
> > However, the AIE mode bit is off (even if it was left on). So the alarm
> > does not seem like it would persist across reboots, and the value
> > returned form rtc_read_alarm is technically invalid as the code to fill
> > in the -1 fields doesn't run.
> >
> > I realize that the cmos is fairly simplistic, but do you have examples
> > of hardware where the AIE mode does persist on bootup?
> 
> Seems like cmos can't handle it. I don't know if strongarm will wake
> up with the timer sane after a hardware reset, there used to be an
> issue with the timer AIE and UIE interrupt bits waking up with a
> random value.

Yea. The way I thought about it originally was that you can set an alarm
and that alarm will fire if the machine is on, suspended or even in some
cases off.  Then, when the machine is booted (system reset), the state
of the RTC's alarm should not be trusted.

Your description of the AIE/UIE having random values aligns with that
intuition.

However, if the expectation is that once set, the alarm should persist
across any number of reboots, this makes it a bit more complicated.


> > 2) One larger complication I see coming down the road with this is how
> > do we handle persistence with multiplexed events? If we have two
> > rtc_timers set to fire, one at 1pm and the other at 3pm. If we reboot
> > the box at noon, only the 1pm timer will persist.
> >
> > This could cause some additional confusion if the first timer was a
> > posix-alarm-timer and the second was the classic wake alarm set
> > by /dev/rtc0. In that case, after a reboot at noon, the system will show
> > a 1pm wake alarm via /dev/rtc0.
> >
> > I need to think more about #2. I suspect we could claim that soonest
> > alarm should be preserved regardless of what its source was.
> 
> Upon a reboot, I believe its a valid assumption that the system has
> been completely reinitialized, as opposed to a suspend. In this case,
> none of the original applications that have set alarms will be running
> on the system. Setting the alarm to do anything more than waking up
> the system seems odd in this scenario. An application that will keep
> information across reboots must have other means to persist its
> information, most likely keeping it in a file so that it can decide
> what to do upon initialization. Then it could check what alarms it
> would need to set.

Yes. To me this seems like the better design. The alarm can be set to
fire while the system is off, but upon a system reset any applications
managing such alarms should check data saved in a more trusted
persistent store (like a file, instead of in the RTC hardware) and
possibly re-initialize the alarm.

However, pulling the hardware state and if possible (since apparently
much hardware doesn't preserve a valid state through reset) setting the
RTC's aie_timer to that state probably isn't a bad idea either. Since
its possible that a timer was set prior to reboot, we should atleast
keep the kernel's understanding of the hardware state consistent (there
may very well be a alarm ticking down, so we should represent that).

In other-words, if we can, we might as well save what we can back, but
this wouldn't change the fact that upon reset you can't trust hardware
to preserve that state. 

thanks
-john


