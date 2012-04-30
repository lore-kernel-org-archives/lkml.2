Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab2D3U5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:57:10 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:54365 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582Ab2D3U5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:57:07 -0400
Message-ID: <4F9EFC70.50405@linaro.org>
Date: Mon, 30 Apr 2012 13:56:16 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V1 0/5] Rationalize time keeping
References: <cover.1335510125.git.richardcochran@gmail.com> <4F9B228F.90903@linaro.org> <20120428080443.GA2241@netboy.at.omicron.at>
In-Reply-To: <20120428080443.GA2241@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12043020-7408-0000-0000-0000049E97FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2012 01:04 AM, Richard Cochran wrote:
> On Fri, Apr 27, 2012 at 03:49:51PM -0700, John Stultz wrote:
>> On 04/27/2012 01:12 AM, Richard Cochran wrote:
>>> * Benefits
>>>    - Fixes the buggy, inconsistent time reporting surrounding a leap
>>>      second event.
>> Just to clarify this, so we've got the right scope on the problem,
>> you're trying to address the fact that the leap second is not
>> actually applied until the tick after the leap second, correct?
> That is one problem, yes.
>
>> Where basically you can see small offsets like:
> I can synchronize over the network to under 100 nanoseconds, so to me,
> one second is a large offset.

Well, the leap-offset is a second, but when it arrives is only 
tick-accurate. :)


>> My only concern is how we
>> manage it along with possible smeared-leap-seconds ala:
>> http://googleblog.blogspot.com/2011/09/time-technology-and-leaping-seconds.html
>>
>> ( I shudder at the idea of managing two separate frequency
>> corrections for different time domains).
> Are you planning to implement that? This approach is by no means
> universally accepted.

No no.  I have no plans there.

> In my view, what Google is doing is hack (albeit a sensible for
> business applications). For test and measurement or scientific
> applications, it does not make sense to introduce artifical frequency
> errors in this way.

True, although even if it is a hack, google *is* using it.  My concern 
is that if CLOCK_REALTIME  is smeared to avoid a leap second jump, in 
that environment we cannot also accurate provide a correct CLOCK_TAI.  
So far that's not been a problem, because CLOCK_TAI isn't a clockid we 
yet support.  But the expectations bar always rises, so I suspect once 
we have a CLOCK_TAI, someone will want us to handle smeared-leap seconds 
without affecting CLOCK_TAI's correctness.


> Another variant of this idea: http://www.cl.cam.ac.uk/~mgk25/time/utc-sls/
>
> Here is a nice quote from that page:
>
>     All other objections to UTC-SLS that I heard were not directed
>     against its specific design choices, but against the (very well
>     established) practice of using UTC at all in the applications that
>     this proposal targets:
>
>     * Some people argue that operating system interfaces, such as the
>       POSIX "seconds since the epoch" scale used in time_t APIs, should
>       be changed from being an encoding of UTC to being an encoding of
>       the leap-second free TAI timescale.
>
>     * Some people want to go even further and abandon UTC and leap
>       seconds entirely, detach all civilian time zones from the
>       rotation of Earth, and redefine them purely based on atomic time.
>
>     While these people are usually happy to agree that UTC-SLS is a
>     sensible engineering solution as long as UTC remains the main time
>     basis of distributed computing, they argue that this is just a
>     workaround that will be obsolete once their grand vision of giving
>     up UTC entirely has become true, and that it is therefore just an
>     unwelcome distraction from their ultimate goal.
I think this last point is very telling. Neither of the above options 
are really viable in my mind, as I don't see any real consensus to 
giving up UTC.  What is in-practice is actually way more important then 
where folks wish things would go.

> Until the whole world agrees to this "work around" I think we should
> stick to current standards. If and when this practice becomes
> standardized (I'm not holding my breath), then we could simply drop
> the internal difference between the kernel time scale and UTC, and
> steer out the leap second synchronously with the rest of the world.
Well, I think that Google shows some folks are starting to use 
workarounds like smeared-leap-seconds/UTC-SLS. So its something we 
should watch carefully and expect more folks to follow.  Its true that 
you don't want to mix UTC-SLS and standard UTC time domains, but its 
likely this will be a site-specific configuration.

So its a concern when a correct CLOCK_TAI would be incompatible on 
systems using these hacks/workarounds.


>>> * Performance Impacts
>>> ** con
>>>     - Small extra cost when reading the time (one integer addition plus
>>>       one integer test).
>> This may not be so small when it comes to folks who are very
>> concerned about the clock_gettime hotpath.
> If you would support the option to only insert leap seconds, then the
> cost is one integer addition and one integer test.

*Any* extra work is a big deal to folks who are sensitive to 
clock_gettime performance.
That said, I don't see why its more complicated to also handle leap removal?

> Also, once we have a rational time interface (like CLOCK_TAI), then
> time sensitive will want to use that instead anyhow.
Well, performance sensitive and correctness sensitive are two different 
things. :) I think CLOCK_TAI is much cleaner for things, but at the same 
time, the world "thinks" in UTC, and converting between them isn't 
always trivial (very similar to the timezone presentation layer, which 
isn't fun). So I'd temper any hopes of mass conversion. :)

>> Further, the correction will be needed to be made in the vsyscall
>> paths, which isn't done with your current patchset (causing userland
>> to see different time values then what kernel space calculates).
> Do you mean __current_kernel_time? What did I miss?
No. So, on architectures that support vsyscalls/vdso (x86_64, powerpc, 
ia64, and maybe a few others) getnstimeofday() is really only an 
internal interface for in-kernel access. Userland uses the vsyscall/vdso 
interface to be able to read the time completely from userland context 
(with no syscall overhead). Since this is done in different ways for 
each architecture, you need to export the proper information out via 
update_vsyscall() and also update the arch-specific vsyscall 
gettimeofday paths (which is non-trivial, as some arches are implemented 
in asm, etc - my sympathies here, its a pain).


>> One possible thing to consider? Since the TIME_OOP flag is only
>> visible via the adjtimex() interface, maybe it alone should have the
>> extra overhead of the conditional?
> This would mean that you would have to do the conditional somehow
> backwards in order to provide TAI time values. To me, the logical way
> is to keep a continuous time scale, and then compute UTC from it.

? Not sure I'm following you here.

What I'm recommending, is even if you rework the kernel so that it 
constructs time as follows:

CLOCK_TAI = CLOCK_MONOTONIC + monotonic_to_tai
CLOCK_REALTIME = CLOCK_TAI + tai_to_utc

The  adjustment made to tai_to_utc by the leap second would still be 
changed at tick time, but the logic to avoid the sub-tick inconsistency 
at the second edge would be only made to the adjtimex() interface. Thus 
for folks who really care about leap seconds, who already need to use 
adjtimex in order to detect the TIME_OOP flag would get the very correct 
time value, but the performance sensitive users of clock_gettime 
wouldn't be affected.

>> I'm not excited about the
>> gettimeofday field returned by adjtimex not matching what
>> gettimeofday actually provides for that single-tick interval, but
>> maybe its a reasonable middle ground?
> Not sure what you mean, but to me it is not acceptable to deliver
> inconsistent time values to userspace!
For users of clock_gettime/gettimeofday, a leapsecond is an 
inconsistency. Neither interfaces provide a way to detect that the 
TIME_OOP flag is set and its not 23:59:59 again, but 23:59:60 (which 
can't be represented by a time_t).  Thus even if the behavior was 
perfect, and the leapsecond landed at exactly the second edge, it is 
still a time hiccup to most applications anyway.

Thus, most of userland doesn't really care if the hiccup happens up to a 
tick after the second's edge. They don't expect it anyway.  So they 
really don't want a constant performance drop in order for the hiccup to 
be more "correct" when it happens.  :)

That's why I'm suggesting that you consider starting by modifying the 
adjtimex() interface. Any application that actually cares about 
leapseconds should be using adjtimex() since its the only interface that 
allows you to realize that's whats happening. Its not a performance 
optimized path, and so its a fine candidate for being slow-but-correct.

My only concern there is that it would cause problems when mixing 
adjtimex() calls with clock_gettime() calls, because you could have a 
tick-length of time when they report different time values. But this may 
be acceptable.


>>> ** pro
>>>     - Removes repetitive, periodic division (secs % 86400 == 0) the whole
>>>       day long preceding a leap second.
>>>     - Cost of maintaining leap second status goes to the user of the
>>>       NTP adjtimex() interface, if any.
>> Not sure I follow this last point. How are we pushing this
>> maintenance to adjtimex() users?
> Only adjtimex calls timekeeper_gettod_status, where the leap second is
> calculated, outside of timekeeper.lock, on the NTP user space's kernel
> time.
So its not really a cost-of-maintaining, but a cost-of-calculation.  We 
only calculate the next leap second when its provided via adjtimex 
rather then doing the check periodically in the kernel.

> In current Linux, the modulus is done in update_wall_time and
> logarithmic_accumulation, on kernel time.
>
>>> * Todo
>>>    - The function __current_kernel_time accesses the time variables
>>>      without taking the lock. I can't figure that out.
>>>
>> There's a few cases where we want the current second value when we
>> already hold the xtime_lock, or we might possibly hold the
>> xtime_lock. Its an special internal interface for special users
>> (update_vsyscall, for example).
> What about kdb_summary?
I don't know the kdb patch especially well, but I suspect kdb_summary 
might be triggered at unexpected times if you're trying to debug a 
remote kernel. Thus we want to be able to get the time_t value (which 
can be read safely without a lock on most systems)  without trying to 
grab a lock that might be held. This avoids deadlock  should kdb be 
blocking the lock-holder from running.

thanks
-john

