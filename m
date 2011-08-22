Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab1HVAnk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 20:43:40 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51288 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab1HVAng convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 20:43:36 -0400
MIME-Version: 1.0
In-Reply-To: <20110821090736.GG12028@n2100.arm.linux.org.uk>
References: <1313529267-4428-1-git-send-email-wad@chromium.org>
	<CABqD9hYavCxA38GbBhbCmBT+PEQQsvhbF4U7xY8P8ygbFy+=Ag@mail.gmail.com>
	<20043.28045.613130.691498@pilspetsen.it.uu.se>
	<201108171122.49009.arnd@arndb.de>
	<20110821090736.GG12028@n2100.arm.linux.org.uk>
Date: Sun, 21 Aug 2011 19:43:33 -0500
Message-ID: <CABqD9hY99PYU+GONgw2EqT0oR2x-GFt-nWyz7yhy2J28r5y9Og@mail.gmail.com>
Subject: Re: [RFC,PATCH] arch/arm: compute and export NR_syscalls
From: Will Drewry <wad@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Mikael Pettersson <mikpe@it.uu.se>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mike Frysinger <vapier@gentoo.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 4:07 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Aug 17, 2011 at 11:22:48AM +0200, Arnd Bergmann wrote:
>> On Wednesday 17 August 2011, Mikael Pettersson wrote:
>> >  > I proposed this approach based solely on prior threads I've seen. E.g.,
>> >  > - https://lkml.org/lkml/2007/6/1/427
>> >  >   (don't just #define)
>> >  > - https://lkml.org/lkml/2009/8/27/280
>> >  >   (todo: x86-32 to move to x86-64)
>> >  >
>> >  > If a single line #define is good enough, then it certainly works for me.
>> >
>> > Yes, the one-line #define NR_syscalls in unistd.h is a perfectly adequate,
>> > if not entirely elegant, solution.  Adding asm-export.c just for this is
>> > waaay overkill.
>>
>> Right. While the main problem with having the constant in asm/unistd.h
>> (needs to be kept in sync when adding new syscalls) is an annoyance,
>> the suggested approach is adding more complexity than necessary.
>>
>> If you want to have the value automatically computed, I'd suggest
>> moving the format of unistd.h over to a method like the one used
>> by x86-64 and asm-generic, which is to combine the syscall number
>> definitions with the list of syscall pointers that currently reside
>> in arch/arm/kernel/calls.S, for the added benefit that it's easier to
>> keep the two in sync as well.
>
> You obviously haven't looked at calls.S - the table has multiple
> options depending on whether its being used for EABI or OABI.  It's
> not purely a 1:1 mapping between syscall number name and function
> name.
>
> Adding an additional parameter to the CALL() macro to get around that
> for the syscall number name starts making the file unweidly, especially
> if we obey the 80 column limit.
>
> Finally, the assembly 'number of syscalls' is different from the real
> number of syscalls to ensure that we don't overflow the 8-bit constant
> limit for the compare instruction.  Whether that needs to be included
> in the C __NR_syscalls or not depends on how its used.
>
> I personally would prefer C code not to rely on the (unprovided)
> NR_syscalls due to these kinds of issues.

Upon continued inspection, I largely agree.I have some out-of-tree
code (hopefully not forever) which uses ftrace.  It followed its
coding approach which statically allocates arrays based on
NR_syscalls.  While it makes lookups simple, it creates more
infrastructure headaches for arches that have a non-zero syscall base
and/or differenting numberings based on the active ABI.  I've since
changed my approach to one that works for all architectures and
doesn't require knowing NR_syscalls at compiled-time.

> Finally, if its just for ftrace, well I don't have a high regard for that
> code.  It's something I hardly ever use and when I have tried to use it
> it has been soo dire in terms of overheads that it's just not worth
> bothering with.  When I want timings out of the kernel, I have always
> (and continue to do so) implement my own gathering mechanisms rather
> than using the ftrace crap.

My personal interest is in reusing the shared filter engine along with
its awareness of system call metadata.  That aside, I have a sneaking
suspicion ftrace_syscalls will move away from the current
NR_syscalls-based approach in order to support more architecture
flavors, but I have no idea for sure.  (I'll be sending patches at
some point.)

thanks for your thoughts and consideration!
will
