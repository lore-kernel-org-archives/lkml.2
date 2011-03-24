Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab1CXVSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:18:32 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:40707 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab1CXVS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:18:29 -0400
Subject: Re: [PATCH v2] RTC: Selectively enable PIE-Hrtimer emulation.
From: John Stultz <john.stultz@linaro.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, kyungmin.park@samsung.com,
        MyungJoo Ham <myungjoo.ham@gmail.com>
In-Reply-To: <AANLkTinuwuosJ27BRjREEq8m2_Z+0=U0x6ujGMS-5rKm@mail.gmail.com>
References: <1300781334-30308-1-git-send-email-myungjoo.ham@samsung.com>
	 <1300823076.2731.123.camel@work-vm>
	 <AANLkTinuwuosJ27BRjREEq8m2_Z+0=U0x6ujGMS-5rKm@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 14:18:18 -0700
Message-ID: <1301001498.848.160.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 14:28 +0900, MyungJoo Ham wrote:
> On Wed, Mar 23, 2011 at 4:44 AM, John Stultz <john.stultz@linaro.org> wrote:
> > On Tue, 2011-03-22 at 17:08 +0900, MyungJoo Ham wrote:
> >> The patch of John Stultz, "RTC: Rework RTC code to use timerqueue for
> >> events", has enabled PIE interrupt emulation with hrtimer unconditionally.
> >> However, we do have RTC devices that support PIE and such devices are
> >> not meant to be emulated by hrtimer.
> >
> > I guess the question I want to ask here, is what is the value of getting
> > PIE interrupts over the hrtimer? For most cases it is yet another
> > interrupt. Could you expand a bit more on why you need real PIE irqs?
> 
> I have been implementing charger driver (and then, moving on to
> charger "framework") that requires periodic monitoring on the
> thermistors and properties of battery chargers that do not have
> interrupts. Because the chargers keep charging during suspend, I need
> to keep monitoring them during suspend. I have been doing this by
> periodically waking up the system during suspend with usually 30 secs.
> Although the PIE frequency is over 1Hz, the RTC device in the CPUs we
> use (S3Cxxxx, S5Pxxxx) have TICCNT entry, which allows to have PIE
> interrupt every TICCNT-th PIE-Tick; e.g., with TICCNT=30 and
> PIE-frequency=1Hz, we have an interrupt every 30 seconds. (This TICCNT
> feature is not included in mainline rtc-s3c, yet.)
> 
> For now, I use an additional EXPORTed functions for setting TICCNT
> provided with rtc-s3c.c.

Ok, so this is a special feautre of the s3c hardware and its being
exposed via adding new functionality to the PIE mode in an out of tree
patch.

So, just to further understand what you're doing, is the periodic
monitoring done in userland, or is this all via in-kernel drivers?


> >> Besides, we sometimes need RTC-PIE
> >> to function while hrtimer does not; e.g., CPU's RTC PIE as a
> >> suspend-to-RAM wakeup source.
> >
> > So this indeed is a limitation. hrtimer emulated PIE's won't wake the
> > system up.  So is this a "Besides...sometimes" sort of case, or is PIE
> > wakeups really the only issue here?
> 
> So far, this is the only issue affecting us with the PIE emulation.
> 
> Some potential issues that I'm not concerned for now are;
> a. we are blocking a hardware's function with an emulated feature.

Well, the current rtc interface is poor, as it has limited granularity
and exposes too much hardware detail directly to userland.  We need to
preserve the existing behavior, but before we extend it to enable new
hardware functionality, I think we should consider if the functionality
should be just tacked on, or added in a better way.

> b. there could be multiple rtc devices in a system and we may need to
> setup them anyway without any s/w interrupt handlers. (RTC PIEs
> directly signalling some other H/W pieces?)

Maybe I'm misunderstanding, but this sounds like an abuse of the RTC
interface. If you're using the RTC interface to enable some sort of
inter-hardware signaling, where the kernel itself wouldn't be handling
the irq, you probably really want to use a different driver
all-together. But again, I might just not understand what you're
meaning.


> I think providing hrtimer-based emulation for RTC PIE interrupts is
> fine; however, for RTC devices that want to use their own PIE
> features, I think the framework needs not to block them.

Well, lets take just a small step back. Instead of thinking in specific
hardware features, we need a somewhat generalized abstraction so we can
enable the functionality in a common way across a wide array of
hardware.

For instance, with the current code in 2.6.38, we can easily provide the
behavior you're looking for (ie: 30-second interval RTC triggered
events) in the kernel:

Just create a struct rtc_timer, use rtc_timer_init() to initialize it
with a call back function and ptr, then call rtc_timer_start() with the
expiration time and the 30 second period. The callback will then be
called every 30 seconds, triggered by the RTC alarm.

The benefit here is that since the kernel manages all of this, it will
then work on any RTC hardware that supports alarms, and doesn't need
some hardware-specific PIE mode support. Even better, since the kernel
can allow for multiplexing of events, userland can still set AIE mode
alarms using the legacy interface without affecting your periodic
rtc_timer.

Now, currently this is kernel-internal functionality, and hasn't yet
been exposed to userland, but I'm looking to change that via the posix
alarm timers work. Where one could simply set a standard timer against
CLOCK_REALTIME_ALARM, and that timer will fire regardless of if the
system is in suspend or not.

In the meantime, you might even be able to convert your currently
out-of-tree TICCNT patch to make use of the rtc_timer to provide
equivalent behavior (Having not seen it, I'm not quite sure how the
TICCNT mode is enabled from userland in your code, but I'd be happy to
look at it and make suggestions on how to change it).

thanks
-john


