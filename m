Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab1LNQtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:49:17 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59785 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757368Ab1LNQtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:49:15 -0500
Message-ID: <1323881310.6805.41.camel@work-vm>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
From: john stultz <johnstul@us.ibm.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 14 Dec 2011 08:48:30 -0800
In-Reply-To: <20111214074640.GB2180@netboy.at.omicron.at>
References: <cover.1323739287.git.luto@amacapital.net>
	 <20111213032406.GA9604@netboy.at.omicron.at>
	 <1323747782.4078.144.camel@work-vm>
	 <CALCETrV8MWwv5ei=4FirhEMyKR5A6hkq4sGSmFqo=mCgopdgXg@mail.gmail.com>
	 <20111214074640.GB2180@netboy.at.omicron.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11121416-9360-0000-0000-000001830F00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 08:46 +0100, Richard Cochran wrote:
> On Mon, Dec 12, 2011 at 11:09:29PM -0800, Andy Lutomirski wrote:
> > On Mon, Dec 12, 2011 at 7:43 PM, john stultz <johnstul@us.ibm.com> wrote:
> > >> - New name, to distance ourselves from POSIX (clock_ns_get?)
> > 
> > I will defer to the bikeshedding consensus :)
> > 
> > >> - Family of calls, with set/get
> > 
> > Setting the time is a big can of worms.  adjtimex is rather
> > incomprehensible (without reading lots of source and/or the rfc) and
> > IMO puts a lot of NTP magic into the kernel, where it doesn't belong.

Honestly, I don't really see how we jumped to adjtimex from setting the
time, nor the complexity hinted at. First, the rational for getting
clock_gettime_ns is to avoid the overhead of userland translating from
timespec to ns.   I doubt there are similar performance needs for
settimeofday().  Even if it was needed, it shouldn't be more complex
then the unit conversion done in this abi patch. Am I missing something?

> > That being said, it might be nice to do something about leap seconds.
> > I always thought that the nanosecond count should include every
> > possible leap second so that every time that actually happens
> > corresponds to a unique count, but maybe that's just me.
> 
> The advantage of working with TAI is that you can use simple addition
> and substraction (converting the result to UTC or whatever), and the
> answer is always correct.

But again, the hard part with in-kernel TAI (possibly as the base of
time)is that initialization of the TAI/UTC offset needs to be able to be
phased in slowly, as we also have to preserve legacy interfaces and
behavior. 

> > >> - Sub nanosecond field
> > 
> > Me.  A nanosecond is approximately a light-second.  Other than things
> > local to a single computer, not much of interest happens on a
> > sub-nanosecond time scale.  Also, a single 64-bit count is nice, and
> > 2^64 picoseconds isn't very long.
> 
> Believe it or not, people (from the Test and Measurement field) have
> already been asking me about having subnanosecond time values from the
> kernel.
> 
> What about this sort of time value?
> 
> struct sys_timeval {
> 	__s64 nanoseconds;
> 	__u32 fractional_ns;
> };
> 
> The second field can just be zero, for now.

I'm mixed on this. 

We could do this, as the kernel keeps track of sub-ns granularity.
However, its not stored in a decimal format. So I worry the extra math
needed to convert it to something usable might add extra overhead,
removing the gain of the proposed clock_gettime_ns() interface.


> > >> - TAI time base (or according to parameter?)
> > >
> > > Having a CLOCK_TAI would be interesting across the board. We already
> > > keep a TAI offset in the ntp code. However, I'm not sure if ntp actually
> > > sets it these days.
> > 
> > A friend of mine would probably appreciate various barycentric time
> > scales as well.  This would also be a different (and unrelated) patch.
> 
> What about this: a new, non-POSIX, rational time interface providing
> TAI time values, and a user space library for time scale conversion?

Why do we need a new interface for TAI? clock_gettime(CLOCK_TAI,...)
should be achievable. I do think it would be interesting, but I also
think its separate from the goal of this proposal.

thanks
-john


