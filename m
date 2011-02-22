Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab1BVMwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 07:52:36 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43484 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab1BVMwf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 07:52:35 -0500
MIME-Version: 1.0
In-Reply-To: <1298362178.4222.57.camel@work-vm>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
 <1298332538-31216-5-git-send-email-john.stultz@linaro.org>
 <20110222023452.GB18299@sirena.org.uk> <1298343333.4222.36.camel@work-vm> <1298362178.4222.57.camel@work-vm>
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Date: Tue, 22 Feb 2011 09:51:44 -0300
Message-ID: <AANLkTinMPnJj+ca+=ujU=5rhK3Nh0qrFGe955zZWjYaf@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH 04/10] RTC: Cleanup rtc_class_ops->read_alarm()
To: john stultz <johnstul@us.ibm.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

On Tue, Feb 22, 2011 at 05:09, john stultz <johnstul@us.ibm.com> wrote:
> On Mon, 2011-02-21 at 18:55 -0800, John Stultz wrote:
>> On Tue, 2011-02-22 at 02:34 +0000, Mark Brown wrote:
>> > Can you go into more detail on the rationale behind this virtualised
>> > functionality and how it works?  I'd really expect the RTC alarm to be
>> > preserved over system reboots (on some systems it can be used to
>> > initiate a boot) and that would mean that we need to go to the hardware
>> > for at least the initial configuration.
> [snip]
>> Now, to your point about persistence across reboots:
>>
>> It is an interesting point to consider.
>>
>> So currently, if the hardware supports it, then the behavior should
>> remain the same: As long as no application sets a new alarm, the
>> previous alarm should persist in the RTC hardware.
>>
>> However, an application's ability to notice that such an alarm is set,
>> is currently limited.  So your point about reading the hardware to
>> initialize the state is quite valid, and shows a good reason to preserve
>> the read_alarm() method.

Does it matter to application 1 that application 2 has set an alarm
before or after the time it has previously set it? With multiplexed
events, what is the semantic of read_alarm()? Should it return only
the closest alarm to trigger of the application that calls it or
should it return the closest alarm of the system?

> So I've been working on a fix for the issue described here, but have run
> into a few complications:
>
> 1) Prior to my rework landing, on the rtc-cmos driver, after a reboot,
> calls to rtc_read_alarm() do return the alarm time from hardware.
> However, the AIE mode bit is off (even if it was left on). So the alarm
> does not seem like it would persist across reboots, and the value
> returned form rtc_read_alarm is technically invalid as the code to fill
> in the -1 fields doesn't run.
>
> I realize that the cmos is fairly simplistic, but do you have examples
> of hardware where the AIE mode does persist on bootup?

Seems like cmos can't handle it. I don't know if strongarm will wake
up with the timer sane after a hardware reset, there used to be an
issue with the timer AIE and UIE interrupt bits waking up with a
random value.

> 2) One larger complication I see coming down the road with this is how
> do we handle persistence with multiplexed events? If we have two
> rtc_timers set to fire, one at 1pm and the other at 3pm. If we reboot
> the box at noon, only the 1pm timer will persist.
>
> This could cause some additional confusion if the first timer was a
> posix-alarm-timer and the second was the classic wake alarm set
> by /dev/rtc0. In that case, after a reboot at noon, the system will show
> a 1pm wake alarm via /dev/rtc0.
>
> I need to think more about #2. I suspect we could claim that soonest
> alarm should be preserved regardless of what its source was.

Upon a reboot, I believe its a valid assumption that the system has
been completely reinitialized, as opposed to a suspend. In this case,
none of the original applications that have set alarms will be running
on the system. Setting the alarm to do anything more than waking up
the system seems odd in this scenario. An application that will keep
information across reboots must have other means to persist its
information, most likely keeping it in a file so that it can decide
what to do upon initialization. Then it could check what alarms it
would need to set.

> Just so I can better get a grip of the cases your considering, could you
> maybe give me some more detailed examples of where you'd like to see the
> alarm timer be set and then persist across multiple power cycles before
> firing? And how is that persistent value managed by the application
> setting it?

I am curious about this too.

> thanks
> -john

Regards,
Marcelo.
