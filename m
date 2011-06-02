Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491Ab1FBLBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 07:01:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37390 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933369Ab1FBLBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 07:01:54 -0400
Date: Thu, 2 Jun 2011 12:01:37 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCHv2 0/3] clocksource: add db8500 PRCMU timer
Message-ID: <20110602110137.GU3660@n2100.arm.linux.org.uk>
References: <1307007271-1004-1-git-send-email-mattias.wallin@stericsson.com> <20110602094622.GS3660@n2100.arm.linux.org.uk> <4DE7637B.3060901@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE7637B.3060901@stericsson.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 12:18:35PM +0200, Mattias Wallin wrote:
> On 06/02/2011 11:46 AM, Russell King - ARM Linux wrote:
>> Why don't we just find a way of fixing sched_clock so that the value
>> doesn't reset over a suspend/resume cycle?
> Even if the value isn't reset during suspend/resume we want the  
> clocksource to keep counting. Or is it ok to have the clocksource stop  
> or freeze during suspend?

kernel/time/timekeeping.c:timekeeping_suspend():

        timekeeping_forward_now();

which does:
        cycle_now = clock->read(clock);
        cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
        clock->cycle_last = cycle_now;

So that updates the time with the current offset between cycle_last and
the current value.

kernel/time/timekeeping.c:timekeeping_resume():
        /* re-base the last cycle value */
        timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);

So this re-sets cycle_last to the current value of the clocksource.  This
means that on resume, the clocksource can start counting from any value it
likes.

So, without any additional external inputs, time resumes incrementing at
the point where the suspend occurred without any jump backwards or forwards.

The code accounts for the sleep time by using read_persistent_clock() read
a timer which continues running during sleep to calculate the delta between
suspend and resume, and injects the delta between them to wind the time
forward.

> Then we have cpuidle. Is it ok to stop/freeze the timer during cpuidle  
> sleep states?

During _idle_ (iow, no task running) sched_clock and the clocksource
should both continue to run - the scheduler needs to know how long the
system has been idle for, and the clocksource can't stop because we'll
lose track of time.

Remember that the clockevent stuff is used as a trigger to the timekeeping
code to read the clocksource, and update the current time.  Time is moved
forward by the delta between a previous clocksource read and the current
clocksource read.  So stopping or resetting the clocksource in unexpected
ways (other than over suspend/resume as mentioned above) will result in
time going weird.
