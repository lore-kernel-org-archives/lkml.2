Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab1FAWgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 18:36:07 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36461 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab1FAWgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 18:36:04 -0400
Subject: Re: /proc/stat btime accuracy problem
From: john stultz <johnstul@us.ibm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTiniq6GVMJPO_-efKrWHQg9V9Dod9g@mail.gmail.com>
References: <BANLkTiniq6GVMJPO_-efKrWHQg9V9Dod9g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 15:35:33 -0700
Message-ID: <1306967733.11492.11.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 14:50 -0600, Bjorn Helgaas wrote:
> timekeeping_init() basically does the following:
> 
>     xtime = RTC
>     if (arch implements read_boot_clock())
>         wall_to_monotonic = -read_boot_clock()
>     else
>       wall_to_monotonic = -xtime
> 
> So wall_to_monotonic records some approximation of the system boot
> time, which is then used to derive the "btime" reported in /proc/stat.
> 
> The problem I'm seeing is that xtime is updated on timer ticks, so
> uninterruptible code, like kernel serial printk, makes us miss ticks,
> so xtime falls behind the RTC.

Huh. So this sort of issue was common back when we had tick-based
timekeeping (in combination with troubled hardware), but with the
current clocksource based timekeeping, occasional lost ticks shouldn't
really effect time. 

Can you explain a bit more about what kind of hardware this is happening
on, and what clocksource is being used?


>   Then, when userland fixes xtime, in my
> case with "hwclock --hctosys", the delta is applied to both xtime and
> wall_to_monotonic.  The result is that "btime" is no longer accurate.

Yes. If time was actually lost (which I suspect is the actual problem),
then adjustments to fix it do not propagate, and thus btime (which is
approximately calculated  as CLOCK_REALTIME - CLOCK_BOOTTIME) will be
off. This is due to the fact that the adjustment changes CLOCK_REALTIME,
but that CLOCK_BOOTTIME (or CLOCK_MONOTONIC) isn't being increased for
the time lost.

> Here's an example where I artificially exaggerated the problem by
> adding 30 seconds of wait time with interrupts disabled.  Assume the
> RTC is perfectly correct at boot, and note that xtime has fallen
> behind the RTC by 31 seconds by the time userland resets the clock:

Yea, unless I'm somehow misunderstanding you, I don't think this is a
btime accuracy issue, but instead a hardware problem. If interrupts are
being disabled for longer then the clocksource hardware can handle,
there will be problems.

But let me know more about the clocksource being used and we'll see if
we can solve what you're seeing.

thanks
-john


