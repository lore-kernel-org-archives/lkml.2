Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab1G2MSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 08:18:21 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51855 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab1G2MST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 08:18:19 -0400
MIME-Version: 1.0
In-Reply-To: <20110729072426.GF5404@dastard>
References: <20110729013830.GC5404@dastard> <CAObL_7GdxD07-9_aYZBDqutQD6cVz2kYHXAcUwDWr6NkqRdByw@mail.gmail.com>
 <20110729072426.GF5404@dastard>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 29 Jul 2011 08:17:59 -0400
X-Google-Sender-Auth: igwkjqvjnzF5n7rcHzXBIYhCi-A
Message-ID: <CAObL_7HCyS0aE2KKJR0rF48VKVqdeOruNVvsakAjzR5J6GHvPw@mail.gmail.com>
Subject: Re: [3.0-rc0 Regression]: legacy vsyscall emulation increases user
 CPU time by 20%
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 3:24 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jul 28, 2011 at 11:30:49PM -0400, Andrew Lutomirski wrote:

>> > FYI, fs_mark does a lot of gettimeofday() calls - one before and
>> > after every syscall that does filesystem work so it can calculate
>> > the syscall times and the amount of time spent not doing syscalls.
>> > I'm assuming this is the problem based on the commit message.
>> > Issuing hundreds of thousands of getimeofday calls per second spread
>> > across multiple CPUs is not uncommon, especially in benchmark or
>> > performance measuring software. If that is the cause, then these
>> > commits add -significant- overhead to that process.
>>
>> I put some work into speeding up vdso timing in 3.0.  As of Linus' tree now:
>>
>> # test_vsyscall bench
>> Benchmarking  syscall gettimeofday      ...   7068000 loops in
>> 0.50004s =   70.75 nsec / loop
>> Benchmarking     vdso gettimeofday      ...  23868000 loops in
>> 0.50002s =   20.95 nsec / loop
>> Benchmarking vsyscall gettimeofday      ...   2106000 loops in
>> 0.50004s =  237.44 nsec / loop
>
> How does that compare to 3.0 before these changes? No point telling
> me how it performs without something to compare it to and it doesn't
> tell me if gettimeofday actually slowed down or not...

3.0 would have identical syscall performance and very nearly identical
vdso performance (the code is identical but there could be slightly
different icache behavior).  3.0's vsyscall would have taken ~22 ns on
this hardware.

>
>> So clock_gettime(CLOCK_MONOTONIC) is faster, more correct, and more
>> precise than gettimeofday.  IMO you should fix your benchmark :)
>
> So you're going to say that to everyone who currently uses
> gettimeofday() a lot? ;)

Actually, you're the first one to notice.  I'm hopeful that no
non-benchmark workloads will see a significant effect.

>
>> More seriously, though, I think it's a decent tradeoff to slow down
>> some extremely vsyscall-heavy legacy workloads to remove the last bit
>> of nonrandomized executable code.  The only way this should show up to
>> any significant extent is on modern rdtsc-using systems that make a
>> huge number of vsyscalls.  On older machines, even the cost of the
>> trap should be smallish compared to the cost of HPET / acpi_pm access.
>>
>> >
>> > Assuming this is the problem, can this be fixed without requiring
>> > the whole world having to wait for the current glibc dev tree to
>> > filter down into distro repositories?
>>
>> How old is your glibc?  gettimeofday has used the vdso since:
>
> It's 2.11 on the test machine, whatever that translates to. I
> haven't really changed the base userspace for about 12 months
> because if I do I invalidate all my historical benchmark results
> that I use for comparisons.

2.11 is from 2009 and appears to contain that commit.  Does your
workload call time() very frequently?  That's the largest slowdown.
With the old code, time() took 4-5 ns and with the new code time() is
about as slow as gettimeofday().  I suggested having a config option
to allow time() to stay fast until glibc 2.14 became widespread, but a
few other people disagreed.

>
> If I have to upgrade it to something more recent (I note that the
> current libc6 is 2.13 in debian unstable) then I will but there's
> going to be plenty of people that see this if 2.11 is not recent
> enough....

If it's time(), that won't help.

>
>> speeds up the gettimeofday emulated vsyscall from 237 ns to 157 ns.
>
> I've still got nothing to compare that against... :/

~22 ns before the changes.

Note that this is only on Sandy Bridge.  The overhead of syscalls and
traps is much higher on Nehalem hardware, and I haven't done much
testing on other machines.

On Nehalem with HPET on 3.1-ish code, it looks like:

Benchmarking  syscall gettimeofday ...    612000 loops in 0.50076s =
818.23 nsec / loop
Benchmarking     vdso gettimeofday ...    832000 loops in 0.50032s =
601.34 nsec / loop
Benchmarking vsyscall gettimeofday ...    457000 loops in 0.50056s =
1095.32 nsec / loop


With acpi_pm, it's:

Benchmarking  syscall gettimeofday ...    377000 loops in 0.50007s =
1326.44 nsec / loop
Benchmarking     vdso gettimeofday ...    377000 loops in 0.50112s =
1329.24 nsec / loop
Benchmarking vsyscall gettimeofday ...    316000 loops in 0.50036s =
1583.42 nsec / loop

the difference is almost gone because acpi_pm issues a syscall or trap
no matter how you issue the gettimeofday call.

--Andy
