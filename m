Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1LNHqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 02:46:46 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33254 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab1LNHqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 02:46:45 -0500
Date: Wed, 14 Dec 2011 08:46:40 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
Message-ID: <20111214074640.GB2180@netboy.at.omicron.at>
References: <cover.1323739287.git.luto@amacapital.net>
 <20111213032406.GA9604@netboy.at.omicron.at>
 <1323747782.4078.144.camel@work-vm>
 <CALCETrV8MWwv5ei=4FirhEMyKR5A6hkq4sGSmFqo=mCgopdgXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrV8MWwv5ei=4FirhEMyKR5A6hkq4sGSmFqo=mCgopdgXg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 11:09:29PM -0800, Andy Lutomirski wrote:
> On Mon, Dec 12, 2011 at 7:43 PM, john stultz <johnstul@us.ibm.com> wrote:
> >> - New name, to distance ourselves from POSIX (clock_ns_get?)
> 
> I will defer to the bikeshedding consensus :)
> 
> >> - Family of calls, with set/get
> 
> Setting the time is a big can of worms.  adjtimex is rather
> incomprehensible (without reading lots of source and/or the rfc) and
> IMO puts a lot of NTP magic into the kernel, where it doesn't belong.

I agree with you about that, but when you consider the HW/SW
enviroment at the time when NTP was developed, you can understand why
it had to done like that. Actually even most of today's hardware does
not help us to keep the time.

With the newer PTP devices, with tunable HW clocks, we finally have a
chance to move the "magic" back into user space. We can only hope that
the idea will transfer over to CPU clocks as well.

> But I don't really want to design, let alone implement, something
> better, especially right now.  Maybe a better design would let you
> open a file descriptor to control the time and apply offsets and
> frequency correction (over a wide range, specified as a HZ-independent
> fixed-point number) as needed.  But that's a whole different
> discussion.

I initially proposed PTP clock support as a character device, since
that was the quick and easy way to do it, and it was adequate for the
user land needs. The reaction from the list, however, was, why not do
this way ... (details) ... ?

The end result was much more work (and discussion), but the solution
that emerged was really, truly much nicer than the character device
idea.

So, I understand that all you need is a "quick and easy" performance
fix, but I see an opportunity here for a new, improved time interface.

> That being said, it might be nice to do something about leap seconds.
> I always thought that the nanosecond count should include every
> possible leap second so that every time that actually happens
> corresponds to a unique count, but maybe that's just me.

The advantage of working with TAI is that you can use simple addition
and substraction (converting the result to UTC or whatever), and the
answer is always correct.

> >> - Sub nanosecond field
> 
> Me.  A nanosecond is approximately a light-second.  Other than things
> local to a single computer, not much of interest happens on a
> sub-nanosecond time scale.  Also, a single 64-bit count is nice, and
> 2^64 picoseconds isn't very long.

Believe it or not, people (from the Test and Measurement field) have
already been asking me about having subnanosecond time values from the
kernel.

What about this sort of time value?

struct sys_timeval {
	__s64 nanoseconds;
	__u32 fractional_ns;
};

The second field can just be zero, for now.

> >> - TAI time base (or according to parameter?)
> >
> > Having a CLOCK_TAI would be interesting across the board. We already
> > keep a TAI offset in the ntp code. However, I'm not sure if ntp actually
> > sets it these days.
> 
> A friend of mine would probably appreciate various barycentric time
> scales as well.  This would also be a different (and unrelated) patch.

What about this: a new, non-POSIX, rational time interface providing
TAI time values, and a user space library for time scale conversion?


Thanks,
Richard
