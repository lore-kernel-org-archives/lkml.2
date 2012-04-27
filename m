Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab2D0WuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:50:04 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47087 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab2D0WuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:50:00 -0400
Message-ID: <4F9B228F.90903@linaro.org>
Date: Fri, 27 Apr 2012 15:49:51 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V1 0/5] Rationalize time keeping
References: <cover.1335510125.git.richardcochran@gmail.com>
In-Reply-To: <cover.1335510125.git.richardcochran@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042722-5518-0000-0000-000003FAD93A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 01:12 AM, Richard Cochran wrote:
> Just in time for this year's leap second, this patch series presents a
> solution for the UTC leap second mess.
>
> Of course, the POSIX UTC system is broken by design, and the Linux
> kernel cannot fix that. However, what we can do is correctly execute
> leap seconds and always report the time variables (UTC time, TAI
> offset, and leap second status) with consistency.
>
> The basic idea is to keep the internal time using a continuous
> timescale and to convert to UTC by testing the time value against the
> current threshold and adding the appropriate offset. Since the UTC
> time and the leap second status is provided on demand, this eliminates
> the need to set a timer or to constantly monitor for leap seconds, as
> was done up until now.
>
> Patches 2 and 3 are just trivial stuff I saw along the way.
The trivial cleanups I went ahead and took, but I think the rest still 
needs some work.

> * Benefits
>    - Fixes the buggy, inconsistent time reporting surrounding a leap
>      second event.
Just to clarify this, so we've got the right scope on the problem, 
you're trying to address the fact that the leap second is not actually 
applied until the tick after the leap second, correct?

Where basically you can see small offsets like:

23:59:59.999999999
00:00:00.000500000
00:00:00.000800000
[tick]
23:59:59.000900000 (+TIME_OOP)
...
23:59:59.999999999 (+TIME_OOP)
00:00:00.000800000 (+TIME_OOP)
[tick]
00:00:00.000900000
00:00:00.006000000

And you're proposing we fix this by changing the leap-second processing 
from only being done at tick-time  (which isn't exactly on the second 
boundary)to being calculated for each getnstimeofday, correct?

>    - Opens the possibility of offering a rational time source to user
>      space. [ Trivial to offer clock_gettime(CLOCK_TAI) for example. ]

CLOCK_TAI is something I'd like to have.  My only concern is how we 
manage it along with possible smeared-leap-seconds ala:
http://googleblog.blogspot.com/2011/09/time-technology-and-leaping-seconds.html

( I shudder at the idea of managing two separate frequency corrections 
for different time domains).

> * Performance Impacts
> ** con
>     - Small extra cost when reading the time (one integer addition plus
>       one integer test).
This may not be so small when it comes to folks who are very concerned 
about the clock_gettime hotpath.
Further, the correction will be needed to be made in the vsyscall paths, 
which isn't done with your current patchset (causing userland to see 
different time values then what kernel space calculates).

One possible thing to consider? Since the TIME_OOP flag is only visible 
via the adjtimex() interface, maybe it alone should have the extra 
overhead of the conditional? I'm not excited about the gettimeofday 
field returned by adjtimex not matching what gettimeofday actually 
provides for that single-tick interval, but maybe its a reasonable 
middle ground?

> ** pro
>     - Removes repetitive, periodic division (secs % 86400 == 0) the whole
>       day long preceding a leap second.
>     - Cost of maintaining leap second status goes to the user of the
>       NTP adjtimex() interface, if any.
Not sure I follow this last point. How are we pushing this maintenance 
to adjtimex() users?


> * Todo
>    - The function __current_kernel_time accesses the time variables
>      without taking the lock. I can't figure that out.
>
There's a few cases where we want the current second value when we 
already hold the xtime_lock, or we might possibly hold the xtime_lock. 
Its an special internal interface for special users (update_vsyscall, 
for example).

thanks
-john

