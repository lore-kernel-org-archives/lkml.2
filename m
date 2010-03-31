Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484Ab0CaXjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 19:39:19 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13442 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab0CaXjS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 19:39:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Wed, 31 Mar 2010 16:39:11 -0700
From: Gary King <GKing@nvidia.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 31 Mar 2010 16:39:12 -0700
Subject: Re: Bug in hrtimer_get_next_event?
Thread-Topic: Bug in hrtimer_get_next_event?
Thread-Index: AcrRK10TqTky6y0sR3CjODInIf2tew==
Message-ID: <4BB3DD20.8070605@nvidia.com>
References: <A0A1E7539300DF49AA383E614C7827BC04930A0DBB@HQMAIL01.nvidia.com>
 <alpine.LFD.2.00.1003311231090.32352@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003311231090.32352@localhost.localdomain>
Reply-To: Gary King <GKing@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8)
 Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Thank-you for the explanation, the code is clear to me now. As you 
suggested, tick_nohz_get_sleep_length returns exactly what I want.

- Gary

On 03/31/2010 03:43 AM, Thomas Gleixner wrote:
> Gary,
>
> please configure your mail client to do proper line breaks around 78
> chars.
>
> On Tue, 30 Mar 2010, Gary King wrote:
>
>  > I am implementing idle state controls (CPU_IDLE) for Tegra SoCs, and
>  > one of the idle states is not awakened by the hrtimer
>  > interrupt. There is a system-wide high-resolution timer which can be
>  > used as a wakeup source, but I need the high-resolution sleep time
>  > to configure the alarm.
>  >
>  > To fix this, I want to use hrtimer_get_next_event; however, the code
>  > that is in the tree only walks the hrtimer bases when hres mode is
>  > not active; when hres mode is active, hrtimer_get_next_event always
>  > returns KTIME_MAX. Is there any reason for the negative comparison,
>  > or is this a bug?
>  >
>  > After changing this locally, I encountered one other problem on
>  > dynamic-tick systems: get_next_timer_interrupt is called to
>  > determine whether or not it is safe to enter nohz mode; however,
>  > hrtimer_get_next_event (which is used by get_next_timer_interrupt)
>  > will always return <=1 jiffy, since the emulated tick scheduler
>  > event will be armed when tick_nohz_stop_sched_tick queries the sleep
>  > time. As a result, tick_nohz_stop_sched_tick will never enter nohz
>  > mode. I can think of a couple ways to address this (cancel the tick
>  > timer before querying the event and rearm if necessary from either
>  > the arch cpu_idle code or nohz_stop_sched_tick; ignore the tick
>  > timer in hrtimer_get_next_event); does anyone have a recommendation
>  > for a preferred approach?
>
> get_next_timer_interrupt() and hrtimer_get_next_event() are working
> perfectly fine.
>
> In the !HIGHRES case we get the next pending timer from both the timer
> wheel and the hrtimer queue. Note that there is no tick timer in the
> hrtimer queue, because the tick is generated periodically from the
> NOHZ code.
>
> In the HIGHRES case we replace the periodic tick by a hrtimer. We do
> return KTIME_MAX in that case because we know from the clock event
> when the next hrtimer is due. So the check works that way:
>
> query next timer wheel timer
> if that timer is due in the next jiffy, keep going
>
> if not, cancel the tick timer and rearm it to the next timer
> wheel interrupt. If there is any hrtimer pending _BEFORE_ the
> next timer wheel timer then the clock event is armed to that
> event anyway and not overridden by the modified tick timer.
>
> Simply, do not use the hrtimer_get_next_event() and
> get_next_timer_interrupt() for your purpose. They work only with the
> tick management layer and are not designed for general purpose use.
>
> If you want to know how far away the next timer event is, then use:
>
> tick_nohz_get_sleep_length()
>
> That's going to tell you when the next timer interrupt will happen
> when the system is idle. That works for high res off and on case.
>
> Thanks,
>
> tglx
>
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
