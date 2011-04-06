Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab1DFUKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:10:43 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:59434 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab1DFUKm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:10:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=jzm6DPGybMBEZCQorN+60og12cyJPNSApdXzbfP9Cgzn8UI1FHS5BdFR3jW+PkQ05x
         behRMXm47Krhzh4FgFjXeqm+g6MORw4z0+X2k6N6lGRdxJWjtps/pRugkCqFl1AQEb2d
         ZlC806wU9sUuivVC808xmpWha67Bv5cAoQm8g=
MIME-Version: 1.0
In-Reply-To: <m2mxk35ji7.fsf@firstfloor.org>
References: <cover.1301324270.git.luto@mit.edu> <m2mxk35ji7.fsf@firstfloor.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 6 Apr 2011 16:10:22 -0400
X-Google-Sender-Auth: EbamlFyX3v3o4YGf7QZfQaLm8x8
Message-ID: <BANLkTi=g96=Q_OOBeejcsZ1eWGZ9cZYLYA@mail.gmail.com>
Subject: Re: [PATCH 0/6] x86-64: Micro-optimize vclock_gettime
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 2:20 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Andy Lutomirski <luto@MIT.EDU> writes:
>
>> This series speeds up vclock_gettime(CLOCK_MONOTONIC) on by almost 30%
>> (tested on Sandy Bridge).  They're ordered in roughly decreasing order
>> of improvement.
>>
>> These are meant for 2.6.40, but if anyone wants to take some of them
>> for 2.6.39 I won't object.
>
> I read all the patchkit and it looks good to me.  I felt a bit uneasy
> about the barrier changes though, it may be worth running of the
> paranoid "check monotonicity on lots of cpus" test cases to double check
> on different CPUs.  The interesting cases are: P4-Prescott, Merom
> (C2Duo), AMD K8.

I ran Ingo's time-warp-test w/ 6, 7, and 8 threads on Sandy Bridge and
on a Xeon 5600 series chip.  My C2D laptop thinks that its TSC halts
in idle and my only AMD system has unsynchronized TSCs.

I couldn't even make it fail without the barrier trick after the rdtsc
at all, probably because after the lfence the rdtsc runs pretty much
immediately in practice.

>
> Thanks for doing these optimizations again. Before generic clock source
> these functions used to be somewhat faster, but they regressed
> significantly back then. It may be worth comparing the current
> asm code against these old code and see if there's still something
> obvious missing.
>
> Possible more optimizations if you're still motivated:
>
> - Move all the timer state/seqlock into one cache line and start
> with a prefetch.
> I did a similar attempt recently for the in kernel timers.
> You won't see any difference in a micro benchmark loop, but you may
> in a workload that dirties lots of cache between timer calls.

For CLOCK_REALTIME they're already in one cache line.  I tried the
prefetch and couldn't measure a speedup even after playing with
clflush for a bit.

For CLOCK_MONOTONIC, there's an obvious speedup available, though:
pre-add the offset.

>
> - Replace the indirect call in vread() with a if ( timer == TSC)
> inline() else indirect_call
> (manual devirtualization essentially)
>
> - Replace the sysctl checks with code patching use the new
> static branch frameworks

Agreed.  In fact, I could do both in one fell swoop: have a flag for
the mode and have one option be "just issue the syscall."  Static
branch stuff scares me because this stuff runs in userspace and, in
theory, userspace might have COWed the page with this code in it.

v2 of the patchkit coming in a few days.  It'll be a lot cleaner, I
think, although it'll generate the same code.  I'll play with further
optimizations after this stuff gets merged somewhere if I'm motivated
enough.

The other thing to do down the line is to fix the in-kernel implementation.

--Andy
