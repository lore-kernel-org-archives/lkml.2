Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933515Ab1FBMKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 08:10:22 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:45883 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755434Ab1FBMKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 08:10:21 -0400
Message-ID: <4DE77D9A.6090301@stericsson.com>
Date: Thu, 2 Jun 2011 14:10:02 +0200
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCHv2 0/3] clocksource: add db8500 PRCMU timer
References: <1307007271-1004-1-git-send-email-mattias.wallin@stericsson.com> <20110602094622.GS3660@n2100.arm.linux.org.uk> <4DE7637B.3060901@stericsson.com> <20110602110137.GU3660@n2100.arm.linux.org.uk>
In-Reply-To: <20110602110137.GU3660@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2011 01:01 PM, Russell King - ARM Linux wrote:
> On Thu, Jun 02, 2011 at 12:18:35PM +0200, Mattias Wallin wrote:
>> On 06/02/2011 11:46 AM, Russell King - ARM Linux wrote:
>>> Why don't we just find a way of fixing sched_clock so that the value
>>> doesn't reset over a suspend/resume cycle?
>> Even if the value isn't reset during suspend/resume we want the
>> clocksource to keep counting. Or is it ok to have the clocksource stop
>> or freeze during suspend?
>
> kernel/time/timekeeping.c:timekeeping_suspend():
>
>          timekeeping_forward_now();
>
> which does:
>          cycle_now = clock->read(clock);
>          cycle_delta = (cycle_now - clock->cycle_last)&  clock->mask;
>          clock->cycle_last = cycle_now;
>
> So that updates the time with the current offset between cycle_last and
> the current value.
>
> kernel/time/timekeeping.c:timekeeping_resume():
>          /* re-base the last cycle value */
>          timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
>
> So this re-sets cycle_last to the current value of the clocksource.  This
> means that on resume, the clocksource can start counting from any value it
> likes.
>
> So, without any additional external inputs, time resumes incrementing at
> the point where the suspend occurred without any jump backwards or forwards.
>
> The code accounts for the sleep time by using read_persistent_clock() read
> a timer which continues running during sleep to calculate the delta between
> suspend and resume, and injects the delta between them to wind the time
> forward.
>
>> Then we have cpuidle. Is it ok to stop/freeze the timer during cpuidle
>> sleep states?
>
> During _idle_ (iow, no task running) sched_clock and the clocksource
> should both continue to run - the scheduler needs to know how long the
> system has been idle for, and the clocksource can't stop because we'll
> lose track of time.
>
> Remember that the clockevent stuff is used as a trigger to the timekeeping
> code to read the clocksource, and update the current time.  Time is moved
> forward by the delta between a previous clocksource read and the current
> clocksource read.  So stopping or resetting the clocksource in unexpected
> ways (other than over suspend/resume as mentioned above) will result in
> time going weird.

Hmm, I have missed the existence of the read_persistent_clock(). It 
sounds like I should keep the MTU as my clocksource / sched_clock and 
have the PRCMU Timer as a persistent_clock instead.

Then one problem remains. The MTU will be powered during cstates: 
running, wfi, ApIdle (arm retenetion). The MTU will loose power during 
cstates ApSleep and ApDeepSleep. So I need to do a similar sync as 
suspend does against the persistent_clock but when leaving and enter the 
deeper cstates.

Should I solve it in the clocksource framework with a flag telling which 
cstates the timer will stop/freeze and then inject time from the 
persistent_clock for those cstates? (I am thinking something like the 
CLOCK_EVT_FEAT_C3STOP flag)

Am I on the wrong track here or how should I solve it?
