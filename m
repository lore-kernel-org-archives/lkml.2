Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab3ABIqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 03:46:16 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:43289 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3ABIqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 03:46:13 -0500
Message-ID: <50E3F3C4.3030706@synopsys.com>
Date: Wed, 2 Jan 2013 14:15:56 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        James Hogan <james.hogan@imgtec.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC PATCH v1 15/31] ARC: Process/scheduling/clock/Timers/Delay
 Management
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-16-git-send-email-vgupta@synopsys.com> <alpine.LFD.2.02.1211122110230.10000@ionos> <50E3DE29.6020403@synopsys.com>
In-Reply-To: <50E3DE29.6020403@synopsys.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 January 2013 12:43 PM, Vineet Gupta wrote:
> On Tuesday 13 November 2012 01:59 AM, Thomas Gleixner wrote:
>> On Wed, 7 Nov 2012, Vineet Gupta wrote:
>>> +static int arc_finished_booting;
>>> +
>>> +/*
>>> + * Scheduler clock - returns current time in nanosec units.
>>> + * It's return value must NOT wrap around.
>>> + *
>>> + * Although the return value is nanosec units based, what's more important
>>> + * is whats the "source" of this value. The orig jiffies based computation
>>> + * was only as granular as jiffies itself (10ms on ARC).
>>> + * We need something that is more granular, so use the same mechanism as
>>> + * gettimeofday(), which uses ARC Timer T1 wrapped as a clocksource.
>>> + * Unfortunately the first call to sched_clock( ) is way before that subsys
>>> + * is initialiased, thus use the jiffies based value in the interim.
>>> + */
>>> +unsigned long long sched_clock(void)
>>> +{
>>> +	if (!arc_finished_booting) {
>>> +		return (unsigned long long)(jiffies - INITIAL_JIFFIES)
>>> +		    * (NSEC_PER_SEC / HZ);
>>> +	} else {
>>> +		struct timespec ts;
>>> +		getrawmonotonic(&ts);
>>
>> This can live lock. sched_clock() is used by the tracer. So assume you
>> are function tracing and you trace a function called from within the
>> timekeeping seqcount write "locked" region. You spin forever in
>> getrawmonotonic(). Not what you want, right ?
> 
> Correct- so that means we need an equivalent of partially open-code
> getrawmonotonic w/o any locks here - read the clocksource directly just as other
> arches.

Spoke too soon. The desired semantics here are monotonically increasing value
using a 32-bit overflowing hardware counter (and not Jiffies based since Android
CTS has a test case which requires that back-back calls to
clock_gettime(CLOCK_THREAD_CPUTIME_ID)  - which simply use sched_clock( ) return
different values.

Since counter is overflowing, we need additional state (last snapshot) provided by
likes of clocksource. But IMHO, opencoding clocksource code w/o xtime seqlock will
be wrong.

I don't see a way out - except to keep using jiffies based versions and use the 64
bit Time-stamp counter available in newer ARC CPUs.

-Vineet


