Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab1BVIJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:09:52 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:57856 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab1BVIJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:09:50 -0500
Subject: Re: [rtc-linux] [PATCH 04/10] RTC: Cleanup
 rtc_class_ops->read_alarm()
From: john stultz <johnstul@us.ibm.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
In-Reply-To: <1298343333.4222.36.camel@work-vm>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
	 <1298332538-31216-5-git-send-email-john.stultz@linaro.org>
	 <20110222023452.GB18299@sirena.org.uk>  <1298343333.4222.36.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Feb 2011 00:09:38 -0800
Message-ID: <1298362178.4222.57.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-21 at 18:55 -0800, John Stultz wrote:
> On Tue, 2011-02-22 at 02:34 +0000, Mark Brown wrote:
> > Can you go into more detail on the rationale behind this virtualised
> > functionality and how it works?  I'd really expect the RTC alarm to be
> > preserved over system reboots (on some systems it can be used to
> > initiate a boot) and that would mean that we need to go to the hardware
> > for at least the initial configuration.
[snip]
> Now, to your point about persistence across reboots:
> 
> It is an interesting point to consider. 
> 
> So currently, if the hardware supports it, then the behavior should
> remain the same: As long as no application sets a new alarm, the
> previous alarm should persist in the RTC hardware.
> 
> However, an application's ability to notice that such an alarm is set,
> is currently limited.  So your point about reading the hardware to
> initialize the state is quite valid, and shows a good reason to preserve
> the read_alarm() method. 

So I've been working on a fix for the issue described here, but have run
into a few complications:

1) Prior to my rework landing, on the rtc-cmos driver, after a reboot,
calls to rtc_read_alarm() do return the alarm time from hardware.
However, the AIE mode bit is off (even if it was left on). So the alarm
does not seem like it would persist across reboots, and the value
returned form rtc_read_alarm is technically invalid as the code to fill
in the -1 fields doesn't run.

I realize that the cmos is fairly simplistic, but do you have examples
of hardware where the AIE mode does persist on bootup?


2) One larger complication I see coming down the road with this is how
do we handle persistence with multiplexed events? If we have two
rtc_timers set to fire, one at 1pm and the other at 3pm. If we reboot
the box at noon, only the 1pm timer will persist. 

This could cause some additional confusion if the first timer was a
posix-alarm-timer and the second was the classic wake alarm set
by /dev/rtc0. In that case, after a reboot at noon, the system will show
a 1pm wake alarm via /dev/rtc0.

I need to think more about #2. I suspect we could claim that soonest
alarm should be preserved regardless of what its source was.

Just so I can better get a grip of the cases your considering, could you
maybe give me some more detailed examples of where you'd like to see the
alarm timer be set and then persist across multiple power cycles before
firing? And how is that persistent value managed by the application
setting it?

thanks
-john


