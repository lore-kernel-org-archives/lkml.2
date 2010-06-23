Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab0FWUVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 16:21:33 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27903 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab0FWUVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 16:21:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6022"; a="45320168"
Message-ID: <4C226CCA.20601@codeaurora.org>
Date: Wed, 23 Jun 2010 13:21:30 -0700
From: Patrick Pannuto <ppannuto@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: linux-kernel@vger.kernel.org, sboyd@codeaurora.org, tglx@linutronix.de,
       mingo@elte.hu, heiko.carstens@de.ibm.com, eranian@google.com,
       schwidefsky@de.ibm.com, linux-arm-msm@vger.kernel.org
Subject: Re: [RFC] [PATCH] timer: Added usleep[_range][_interruptable] timer
References: <4C225EED.5040600@codeaurora.org> <1277323537.15159.30.camel@c-dwalke-linux.qualcomm.com>
In-Reply-To: <1277323537.15159.30.camel@c-dwalke-linux.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> On Wed, 2010-06-23 at 12:22 -0700, Patrick Pannuto wrote:
>> *** INTRO ***
>>
>> As discussed here ( http://lkml.org/lkml/2007/8/3/250 ), msleep(1) is not
>> precise enough for many drivers (yes, sleep precision is an unfair notion,
>> but consistently sleeping for ~an order of magnitude greater than requested
>> is worth fixing). This patch adds a usleep API so that udelay does not have
>> to be used. Obviously not every udelay can be replaced (those in atomic
>> contexts or being used for simple bitbanging come to mind), but there are
>> many, many examples of
>>
>> mydriver_write(...)
>> /* Wait for hardware to latch */
>> udelay(100)
>>
>> in various drivers where a busy-wait loop is neither beneficial nor
>> necessary, but msleep simply does not provide enough precision and people
>> are using a busy-wait loop instead.
> 
> I think one thing for you to answer would be, why do you think udelay is
> a problem? I don't honestly see that many udelay()'s around, and
> especially not in important code paths .. Instead of adding a new API
> like this you might just rework the problem areas.
> 
> Are you approaching this from performance? or battery life? or what?

First and foremost: power. If switching from udelay to usleep lets the processor
go to a lower C-state once in awhile, then I would consider this a win.

> 
>> *** SOME QUANTIFIABLE (?) NUMBERS ***
>>
> 
>> then averaged the results to see if there was any benefit:
>>
>> === ORIGINAL (99 samples) ========================================= ORIGINAL ===
>>     Avg: 188.760000 wakeups in 9.911010 secs (19.045486 wkups/sec) [18876 total]
>> Wakeups: Min - 179, Max - 208, Mean - 190.666667, Stdev - 6.601194
>>
>> === USLEEP (99 samples) ============================================= USLEEP ===
>>     Avg: 188.200000 wakeups in 9.911230 secs (18.988561 wkups/sec) [18820 total]
>> Wakeups: Min - 181, Max - 213, Mean - 190.101010, Stdev - 6.950757
>>
>> While not particularly rigorous, the results seem to indicate that there may be
>> some benefit from pursuing this.
> 
> This is sort of ambiguous .. I don't think you replaced enough of these
> for it to have much of an impact. It's actually counter intuitive
> because your changes add more timers, yet they reduced average wakeups
> by a tiny amount .. Why do you think that is ?
> 

Yes, this test was leftover from a different project that involved refactoring
timers, so it was available and easy.  My guess for the reduction in number of
wakeups is that the processor is able to do other work during the 100us it was
previously busy-waiting, and thus had to wake up less often.

I don't know a good way to test this, if you do, please advise and I will
happily pursue it.

>> *** HOW MUCH BENEFIT? ***
>>
>> Somewhat arbitrarily choosing 100 as a cut-off for udelay VS usleep:
>>
>> 	git grep 'udelay([[:digit:]]\+)' | 
>> 		perl -F"[\(\)]" -anl -e 'print if $F[1] >= 100' | wc -l
>>
>> yeilds 1093 on Linus's tree. There are 313 instances of >= 1000 and still
>> another 53 >= 10000us of busy wait! (If AVOID_POPS is configured in, the
>> es18xx driver will udelay(100000) or *0.1 seconds of busy wait*)
> 
> I'd say a better question is how often do they run?

The i2c guys will get hit any time there is contention / heavy traffic on the
i2c bus (they're in the i2c_poll_notbusy path, also the i2c_poll_writeready),
so any time there is a lot of peripheral traffic (e.g. the phone is probably
doing a lot of stuff), then there are long (ish) busy-wait loops that are
unnecessary.

I haven't researched extensively, but I imagine there are a fair number of
other code paths like this; udelays polling until devices aren't busy - and
devices are generally only busy under some degree of load, not a good time
to busy wait if you don't have to IMHO

> 
> Another thing is that your usleep() can't replace udelay() in critical
> sections. However, if your doing udelay() in non-critical areas, I don't
> think there is anything stopping preemption during the udelay() .. So
> udelay() doesn't really cut off the whole system when it runs unless it
> _is_ in a critical section.
> 

I mentioned elsewhere that this can't replace all udelays; as for those that
can be pre-empted, it seems like only a win to give up your time slice to
something that will do real work (or sleep at a lower c-state and use less
power) than to sit and loop. Yes, you *could* be pre-empted from doing
absolutely nothing, but I don't think you should *have* to be for the
system to make a more productive use of those cycles.

> Although it looks like you've spent a good deal of time on this write
> up, the reasoning for these changes is still illusive (at least to me)..
> 
> Daniel

