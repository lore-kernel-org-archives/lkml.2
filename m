Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab1AFEH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 23:07:57 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37245 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab1AFEH5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 23:07:57 -0500
MIME-Version: 1.0
In-Reply-To: <1294280159-2513-13-git-send-email-john.stultz@linaro.org>
References: <1294280159-2513-1-git-send-email-john.stultz@linaro.org>
	<1294280159-2513-13-git-send-email-john.stultz@linaro.org>
Date: Wed, 5 Jan 2011 20:07:54 -0800
Message-ID: <AANLkTi=i9bnAz9FoB_Q1u4pTOwpBCTHK4S21iukZWBpF@mail.gmail.com>
Subject: Re: [PATCH 12/12] [RFC] Introduce Alarm (hybrid) timers
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Brian Swetland <swetland@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 5, 2011 at 6:15 PM, John Stultz <john.stultz@linaro.org> wrote:
> This patch introduces a new type of hybrid timer, called
> alarm-timers.
>
> Alarm-timers are similar to hrtimers, but when a system
> is suspended, the RTC device is set to fire when the soonest
> alarm timer expires.
>
> Alarm-timers are exposed to userland via the posix clock and timers
> interface, using two new clockids: CLOCK_REALTIME_ALARM and
> CLOCK_BOOTTIME_ALARM. Both clockids behave identically to
> CLOCK_REALTIME and CLOCK_BOOTTIME, respectively, but timers
> set against the _ALARM suffixed clockids will wake the system if
> it is suspended.
>
> The concept for Alarm-timers was inspired by the Android Alarm
> driver (by Arve Hjønnevåg) found in the Android kernel tree.
>
> See: http://android.git.kernel.org/?p=kernel/common.git;a=blob;f=drivers/rtc/alarm.c;h=1250edfbdf3302f5e4ea6194847c6ef4bb7beb1c;hb=android-2.6.36
>
> The android alarm driver was built on top of direct RTC
> manipulation, and also implemented its own rbtree timer
> code, so instead of trying to porting it over to my
> timerlist and RTC timer code, I just re-implemented the
> basic functionality roughly following the android in-kernel
> interface.
>
> Another distinction is that while the in-kernel interface
> is pretty similar, the user-space interface for android alarm
> timers is via ioctls. As mentioned above, I've instead chosen
> to export this functionality via the posix interface, as it
> seemed a little simpler and avoids creating duplicate interfaces
> to things like CLOCK_REALTIME and CLOCK_MONOTONIC under alternate
> names (ie:ANDROID_ALARM_RTC and ANDROID_ALARM_SYSTEMTIME).
>
> Its possible that I've missed some subtleties of the Android
> alarm driver interface, and that some of the interface decisions
> I've made may not allow Android to use this interface directly,
> I'd be very interested if those details could be pointed out,
> and hopefully we can find a good solution to get this useful
> functionality upstream.
>

I don't know how suited the posix interface is for this, but I think
it is critical to prevent suspend while an alarm is pending. If an
alarm is important enough to wake the system up from suspend, it is
probably not safe to suspend right after it triggered. The android
alarm driver holds a wakelock until user-space calls back in to wait
for the next alarm, while in-kernel alarms are called from interrupt
context. The apis provided in include/linux/pm_wakeup.h should provide
the functionality you need to prevent suspend until the alarms have
been fully processed, but I have not tried this api yet.

It would also be useful to still allow in-kernel alarms to be
activated from atomic context (we currently do this in a couple of
drivers to avoid using a second wakelock).

-- 
Arve Hjønnevåg
