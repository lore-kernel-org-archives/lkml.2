Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab1LMHJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 02:09:51 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:32832 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab1LMHJu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 02:09:50 -0500
MIME-Version: 1.0
In-Reply-To: <1323747782.4078.144.camel@work-vm>
References: <cover.1323739287.git.luto@amacapital.net> <20111213032406.GA9604@netboy.at.omicron.at>
 <1323747782.4078.144.camel@work-vm>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 12 Dec 2011 23:09:29 -0800
Message-ID: <CALCETrV8MWwv5ei=4FirhEMyKR5A6hkq4sGSmFqo=mCgopdgXg@mail.gmail.com>
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

On Mon, Dec 12, 2011 at 7:43 PM, john stultz <johnstul@us.ibm.com> wrote:
> On Tue, 2011-12-13 at 04:24 +0100, Richard Cochran wrote:
>> On Mon, Dec 12, 2011 at 05:26:36PM -0800, Andy Lutomirski wrote:
>> > On x86-64, clock_gettime is so fast that the overhead converting to and
>> > from nanoseconds is non-negligible.  clock_gettime_ns is a different
>> > interface that is potentially faster.  If people like the ABI, I'll
>> > implement an optimized version.
>>
>> I am not so interested in performance optimizations, but do I think
>> offering time in nanoseconds is attractive from an application point
>> of view. The timespec is impractical for everyone.
>>
>> While you are at it with new syscalls, why not make a clean break from
>> POSIX and fix the uglies?
>>
>> - New name, to distance ourselves from POSIX (clock_ns_get?)

I will defer to the bikeshedding consensus :)

>> - Family of calls, with set/get

Setting the time is a big can of worms.  adjtimex is rather
incomprehensible (without reading lots of source and/or the rfc) and
IMO puts a lot of NTP magic into the kernel, where it doesn't belong.
But I don't really want to design, let alone implement, something
better, especially right now.  Maybe a better design would let you
open a file descriptor to control the time and apply offsets and
frequency correction (over a wide range, specified as a HZ-independent
fixed-point number) as needed.  But that's a whole different
discussion.

That being said, it might be nice to do something about leap seconds.
I always thought that the nanosecond count should include every
possible leap second so that every time that actually happens
corresponds to a unique count, but maybe that's just me.

>> - Sub nanosecond field

Me.  A nanosecond is approximately a light-second.  Other than things
local to a single computer, not much of interest happens on a
sub-nanosecond time scale.  Also, a single 64-bit count is nice, and
2^64 picoseconds isn't very long.

>> - TAI time base (or according to parameter?)
>
> Having a CLOCK_TAI would be interesting across the board. We already
> keep a TAI offset in the ntp code. However, I'm not sure if ntp actually
> sets it these days.

A friend of mine would probably appreciate various barycentric time
scales as well.  This would also be a different (and unrelated) patch.

--Andy
