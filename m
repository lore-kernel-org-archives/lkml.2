Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab1LNRPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:15:53 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51308 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab1LNRPu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:15:50 -0500
MIME-Version: 1.0
In-Reply-To: <1323881310.6805.41.camel@work-vm>
References: <cover.1323739287.git.luto@amacapital.net> <20111213032406.GA9604@netboy.at.omicron.at>
 <1323747782.4078.144.camel@work-vm> <CALCETrV8MWwv5ei=4FirhEMyKR5A6hkq4sGSmFqo=mCgopdgXg@mail.gmail.com>
 <20111214074640.GB2180@netboy.at.omicron.at> <1323881310.6805.41.camel@work-vm>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 14 Dec 2011 09:15:29 -0800
Message-ID: <CALCETrW+g6_VSUJJz4NSVwjKhMo+U_3uQDe9W6uEXdjTuaXVhA@mail.gmail.com>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
To: john stultz <johnstul@us.ibm.com>
Cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 8:48 AM, john stultz <johnstul@us.ibm.com> wrote:
> On Wed, 2011-12-14 at 08:46 +0100, Richard Cochran wrote:
>> On Mon, Dec 12, 2011 at 11:09:29PM -0800, Andy Lutomirski wrote:
>> > On Mon, Dec 12, 2011 at 7:43 PM, john stultz <johnstul@us.ibm.com> wrote:
>> > >> - New name, to distance ourselves from POSIX (clock_ns_get?)
>> >
>> > I will defer to the bikeshedding consensus :)
>> >
>> > >> - Family of calls, with set/get
>> >
>> > Setting the time is a big can of worms.  adjtimex is rather
>> > incomprehensible (without reading lots of source and/or the rfc) and
>> > IMO puts a lot of NTP magic into the kernel, where it doesn't belong.
>
> Honestly, I don't really see how we jumped to adjtimex from setting the
> time, nor the complexity hinted at. First, the rational for getting
> clock_gettime_ns is to avoid the overhead of userland translating from
> timespec to ns.   I doubt there are similar performance needs for
> settimeofday().  Even if it was needed, it shouldn't be more complex
> then the unit conversion done in this abi patch. Am I missing something?
>
>> > That being said, it might be nice to do something about leap seconds.
>> > I always thought that the nanosecond count should include every
>> > possible leap second so that every time that actually happens
>> > corresponds to a unique count, but maybe that's just me.
>>
>> The advantage of working with TAI is that you can use simple addition
>> and substraction (converting the result to UTC or whatever), and the
>> answer is always correct.
>
> But again, the hard part with in-kernel TAI (possibly as the base of
> time)is that initialization of the TAI/UTC offset needs to be able to be
> phased in slowly, as we also have to preserve legacy interfaces and
> behavior.

I have a computer that ticks at the wrong rate, and trying to correct
it via the existing APIs is possible but seemed far more complicated
than it should have been.  That being said, I have almost no interest
in messing with this stuff.  I'll leave it to the NTP experts :)

It certainly has nothing to do with my patch.

>
>> > >> - Sub nanosecond field
>> >
>> > Me.  A nanosecond is approximately a light-second.  Other than things
>> > local to a single computer, not much of interest happens on a
>> > sub-nanosecond time scale.  Also, a single 64-bit count is nice, and
>> > 2^64 picoseconds isn't very long.
>>
>> Believe it or not, people (from the Test and Measurement field) have
>> already been asking me about having subnanosecond time values from the
>> kernel.

I'm curious how that works.  My personal record is synchronizing time
across a bunch of computers to within maybe half a nanosecond, but it
wasn't the *system* clock that I synchronized -- I just calibrated a
bunch of oscillator phase differences on ADC clocks that I was using.
I only relied on the system clock being correct to a few tens of
microseconds, which is easily done with PTP.

>>
>> What about this sort of time value?
>>
>> struct sys_timeval {
>>       __s64 nanoseconds;
>>       __u32 fractional_ns;
>> };
>>
>> The second field can just be zero, for now.
>
> I'm mixed on this.
>
> We could do this, as the kernel keeps track of sub-ns granularity.
> However, its not stored in a decimal format. So I worry the extra math
> needed to convert it to something usable might add extra overhead,
> removing the gain of the proposed clock_gettime_ns() interface.
>

I would actually prefer units of 2^-32 ns over .  I have no attachment
to SI picoseconds so long as the units are constant.

Windows sidesteps this issue by returning arbitrary units and telling
the user what those units are.  This adds a lot of unpleasantness (try
relating the timestamps to actual wall time) and we need to rescale
the time anyway for NTP.

What about:

struct sys_timeval {
    u64 nanoseconds;  /* unsigned.  the current time will always be
after 1970, and those extra 290 years might be nice. */
    u64 padding;  /* for later.  currently always zero. */

That way, once there's both an implementation and a use case, we can
implement it.  In the mean time, the overhead is probably immeasurably
low -- it's a single assignment.

Note that rdtsc isn't good to a nanosecond, let alone sub-nanosecond
intervals, on any hardware I've ever seen.

--Andy
