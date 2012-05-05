Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab2EETZk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:25:40 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:59059 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab2EETZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:25:32 -0400
Message-ID: <4FA57EA4.6050708@linaro.org>
Date: Sat, 05 May 2012 12:25:24 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V1 0/5] Rationalize time keeping
References: <cover.1335510125.git.richardcochran@gmail.com> <4FA2E334.7040601@linaro.org> <20120505073408.GC1967@netboy.at.omicron.at>
In-Reply-To: <20120505073408.GC1967@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050519-7408-0000-0000-000004C99894
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2012 12:34 AM, Richard Cochran wrote:
> On Thu, May 03, 2012 at 12:57:40PM -0700, John Stultz wrote:
>> On 04/27/2012 01:12 AM, Richard Cochran wrote:
>>> The basic idea is to keep the internal time using a continuous
>>> timescale and to convert to UTC by testing the time value against the
>>> current threshold and adding the appropriate offset. Since the UTC
>>> time and the leap second status is provided on demand, this eliminates
>>> the need to set a timer or to constantly monitor for leap seconds, as
>>> was done up until now.
>> So as I mentioned in my earlier review of this patch set, I'm not as
>> excited about the meta-layer you added in utc-tai.h.
> It really isn't a layer. It is just a pair of static inline helper
> functions. The code could just as well be internal to timekeeper.c,
> but I put it in its own file so that I could include it into a unit
> test program.
Sorry, I was imprecise there.  The utc-tai helper functions aren't so 
much of the issue (although isolating them to the timkeeping code would 
be better in my mind), but the new KTS (kernel time scale) stuff, which 
was unintuitive to me.  (I mis-read the utc-tai.h helpers as converting 
from kts -> utc or tai).


>> http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=shortlog;h=refs/heads/dev/clktai
>>
>> The untested patch set there basically pushes TAI time management
>> into the timekeeping core, and then exports a CLOCK_TAI clockid.
>>
>> This patch set *does not* address the tick-granularity delayed
>> leap-second processing issue that your patch also addresses. But I
>> feel like the basic handling of tai is a little simpler.
> So, is this a "won't fix" issue, in your view?
>
> (If so, I'll drop it.)
Not at all!  I just want to split out the two problems:
1) Providing a TAI clock
2) Fixing the tick-latency issue with leap-second processing.

>> Take a look at it and let me know what you think.
> It looks okay to me, as far as it goes.
>
> At least you offer a clock that doesn't jump around. With your patches
> (and the TAI offset fix before), user space programs sensitive to the
> leap second uglies would have a reasonable option. Data collection
> programs can read and store TAI time stamps, and these can always be
> converted into UTC using a table method.
>
> But do you think it will be possible to implement the following in the
> same way?
>
> - clock_settime(CLOCK_TAI)
> - clock_adjtime(CLOCK_TAI)
So I'm not sure if clock_settime(CLOCK_TAI) and clock_adjtime(CLOCK_TAI) 
makes sense or not, as it would then have side effects on 
CLOCK_REALTIME. For now I think keeping the adjtimex interface to the 
tai offset and and freq corrections, along with 
clock_settimeofday(CLOCK_REALTIME) is the best approach, but we can 
revisit it.
> - timer_create(CLOCK_TAI)
This should be easily doable though.

thanks
-john

