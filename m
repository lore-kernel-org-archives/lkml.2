Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab1LLXll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:41:41 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40628 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab1LLXlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:41:40 -0500
MIME-Version: 1.0
In-Reply-To: <1323732772.4078.113.camel@work-vm>
References: <1323718578-1157-1-git-send-email-asharma@fb.com>
 <1323718578-1157-3-git-send-email-asharma@fb.com> <1323731361.4078.102.camel@work-vm>
 <4EE68C31.1030207@fb.com> <1323732772.4078.113.camel@work-vm>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 12 Dec 2011 15:41:18 -0800
X-Google-Sender-Auth: _Fk0R42vMDN9eJiw6LmRshknrY4
Message-ID: <CAObL_7H_2H3f=+UwJ_DEGAVYbQY_ekj+a+BQf6qyFrtU4mqnAw@mail.gmail.com>
Subject: Re: [PATCH 2/2] Add a thread cpu time implementation to vDSO
To: john stultz <johnstul@us.ibm.com>
Cc: Arun Sharma <asharma@fb.com>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 3:32 PM, john stultz <johnstul@us.ibm.com> wrote:
> On Mon, 2011-12-12 at 15:20 -0800, Arun Sharma wrote:
>> On 12/12/11 3:09 PM, john stultz wrote:
>> > On Mon, 2011-12-12 at 11:36 -0800, Arun Sharma wrote:
>> >> From: Kumar Sundararajan<kumar@fb.com>
>> >>
>> >> This primarily speeds up clock_gettime(CLOCK_THREAD_CPUTIME_ID, ..)
>> >> via a new vsyscall. We also add a direct vsyscall that returns
>> >> time in ns (RFC: the direct vsyscall doesn't have a corresponding
>> >> regular syscall, although clock_gettime() is pretty close).
>> >
>> > I'm still not super psyched about providing a vdso-only API.
>> >
>> > If a nanosecond interface like thread_cpu_time() is actually a big win
>> > over clock_gettime(CLOCK_THREAD_CPUTIME,...) it seems it should have its
>> > own syscall as well, no?
>>
>> The win is relatively small when we're dealing with syscalls. But with
>> vsyscalls, it starts showing up in micro benchmarks.
>>
>> Happy to post patches for regular syscalls (assuming I can get them
>> allocated :).
>>
>> >
>> > Possibly something like clock_gettime_ns(), which would return the same
>> > values as clock_gettime() but in nanoseconds rather then a timespec?
>> >
>>
>> If we're doing non-POSIXy things there, how about allocating one syscall
>> per clock instead of multiplexing them through a single syscall?
>>
>> This would be a nice to have (clock_gettime_ns() should get us most of
>> the perf benefit).
>
> Well, it makes it a little easier to extend if we get a new clockid,
> rather then having to add a whole new syscall. Keeps parity between the
> timespec and ns interfaces.
>
> Is it just that you're concerned about the clockid switch costs being
> too high?

>From my (old, from memory) measurements, the switch cost is very very
low if it's predicted correctly, and the main case where it's likely
to be mispredicted is when it hasn't been called in awhile, in which
case either probably no one cares or the cache misses will dominate.

How worried are you about introducing a year 2554 bug?  Python says:

>>> dateutil.parser.parse('1/1/1970') + datetime.timedelta(seconds = 2**64 // 1000000000)
datetime.datetime(2554, 7, 21, 23, 34, 33)

--Andy
