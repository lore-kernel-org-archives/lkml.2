Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab2EAIBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 04:01:46 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48107 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab2EAIBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 04:01:45 -0400
Message-ID: <4F9F9862.2010103@linaro.org>
Date: Tue, 01 May 2012 01:01:38 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V1 0/5] Rationalize time keeping
References: <cover.1335510125.git.richardcochran@gmail.com> <4F9B228F.90903@linaro.org> <20120428080443.GA2241@netboy.at.omicron.at> <4F9EFC70.50405@linaro.org> <20120501071749.GD2243@netboy.at.omicron.at>
In-Reply-To: <20120501071749.GD2243@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050108-9360-0000-0000-000005E5F901
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 12:17 AM, Richard Cochran wrote:
> On Mon, Apr 30, 2012 at 01:56:16PM -0700, John Stultz wrote:
>> On 04/28/2012 01:04 AM, Richard Cochran wrote:
>>> I can synchronize over the network to under 100 nanoseconds, so to me,
>>> one second is a large offset.
>> Well, the leap-offset is a second, but when it arrives is only
>> tick-accurate. :)
> It would be fine to change the leap second status on the tick, but
> then you must also change the time then, and only then, as well. I
> know Linux moved away from this long ago, and the new way is better,
> but still what the kernel does today is just plain wrong.
>
> But there is a fix. I just offered it.
Maybe could you clarify a bit more here about how the kernel is plain 
wrong?  Try a clear problem description including examples (before and 
after you changes)? I'm worried we're talking about different problems.


>> True, although even if it is a hack, google *is* using it.  My
>> concern is that if CLOCK_REALTIME  is smeared to avoid a leap second
>> jump, in that environment we cannot also accurate provide a correct
>> CLOCK_TAI.  So far that's not been a problem, because CLOCK_TAI
>> isn't a clockid we yet support.  But the expectations bar always
>> rises, so I suspect once we have a CLOCK_TAI, someone will want us
>> to handle smeared-leap seconds without affecting CLOCK_TAI's
>> correctness.
> It is either/or, but not both simultaneously.
>
> My proposal does not prevent the smear method in any way. People who
> want the smear just never schedule a leap second. People who want the
> frequency constant just use the TAI clock interface for the important
> work.
>
> We really don't have to support both ways at once.
If both are adopted (separately) by enough folks, we will have to 
support both ways at once. That's why I'm trying to suggest we think a 
bit about how that might be possible.


>
>> *Any* extra work is a big deal to folks who are sensitive to
>> clock_gettime performance.
>> That said, I don't see why its more complicated to also handle leap removal?
> It makes your kernel image larger with no added benefit.
Again,  this should be justified with numbers (try size vmlinux or size 
ntp.o to generate these). More config options makes code harder to 
maintain & test, so I'm pushing back a bit here.  I also suspect keeping 
both can be done with very little extra code.


>> For users of clock_gettime/gettimeofday, a leapsecond is an
>> inconsistency. Neither interfaces provide a way to detect that the
>> TIME_OOP flag is set and its not 23:59:59 again, but 23:59:60 (which
>> can't be represented by a time_t).  Thus even if the behavior was
>> perfect, and the leapsecond landed at exactly the second edge, it is
>> still a time hiccup to most applications anyway.
>>
>> Thus, most of userland doesn't really care if the hiccup happens up
>> to a tick after the second's edge. They don't expect it anyway.  So
>> they really don't want a constant performance drop in order for the
>> hiccup to be more "correct" when it happens.  :)
> I don't buy that argument. Repeating a time_t value leads to ambiguous
> UTC times, put it is posixly correct. The values are usable together
> with difftime(3). Having the time_t go forward and then back again is
> certainly worse.
>
> If we leave everything as is, then the user is left with two choices
> for data collection applications.
>
> 1. Turn off your data system on the night of a leap second.
>
> 2. Record data even during a leap second, but post process the files
>     to fix up all the uglies.
>
> Either way, the kernel has failed us.
3. Use adjtimex() and interpret the timespec and time_state return 
together to interpret 23:59:60 properly?

4. Use adjtimex(), and use the timespec  + the time_tai offset value to 
calculate TAI time?

I dunno. Again, I suspect we're thinking about different issues that 
sound very similar. :)


>> That's why I'm suggesting that you consider starting by modifying
>> the adjtimex() interface. Any application that actually cares about
>> leapseconds should be using adjtimex() since its the only interface
>> that allows you to realize that's whats happening. Its not a
>> performance optimized path, and so its a fine candidate for being
>> slow-but-correct.
>>
>> My only concern there is that it would cause problems when mixing
>> adjtimex() calls with clock_gettime() calls, because you could have
>> a tick-length of time when they report different time values. But
>> this may be acceptable.
> (Introduce yet another kernel bug? No, thanks ;)
>
You did just suggest we allow for CLOCK_TAI to be broken for folks want 
to use smeared-leap-seconds.  That sounds like an eventual bug too.  :) 
Regardless, the point of my suggestion is that you're likely going to be 
adding logic to a very hot path, and the resulting benefit has not been 
clearly stated. Expect push back there (not just from me), so have a 
strong argument and show overhead impact with numbers to help your 
case.  Alternatively look for other solutions that don't affect the 
hot-path (like what I suggested w/ adjtimex() above - although that may 
have downsides too).

Do forgive me for prodding you here.  Assuming I understand your goals 
(adding CLOCK_TAI, reworking timekeeping core to keep construct time in 
a more sane way, and improved leapsecond logic), I very much want to see 
them come to be.  I appreciate your focus on solving some of the complex 
and unloved issues here.

I look forward to your next revision!

thanks
-john





