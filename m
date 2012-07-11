Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab2GKKyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 06:54:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41468 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753152Ab2GKKyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 06:54:16 -0400
Date: Wed, 11 Jul 2012 11:53:35 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rusty Russell <rusty@ozlabs.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ingo Molnar <mingo@kernel.org>, Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120711105335.GD22437@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <20120710101018.GE15120@arm.com>
 <20120710163358.6ae4a576@pyramind.ukuu.org.uk>
 <201207101652.18401.arnd@arndb.de>
 <877guarhpi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877guarhpi.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Wed, Jul 11, 2012 at 06:26:49AM +0100, Rusty Russell wrote:
> On Tue, 10 Jul 2012 16:52:18 +0000, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 10 July 2012, Alan Cox wrote:
> > > > In the AArch32 kernel port many implementation decisions newer
> > > > architectures were made in a way that preserves backwards compatibility
> > > > to over 15 years ago (and for good reasons, ARMv4 hardware is still in
> > > > use). But keeping the same decisions in AArch64 is wrong.
> > > 
> > > Same argument as x86-32 v x86-64. Same issues about compatibility.
> > 
> > Similar but not the same. In case of x86-64 the hardware was actually
> > meant to run old 32 bit kernel binaries and still can. I don't
> 
> I know it's a crazy idea, but why don't we try some actual analysis?

This kind of analysis is not relevant. It's not like you can use a tool
to just mix the lines from one file with another and get a merged port.
It's useful if you want to prove plagiarism but I already admitted
openly that AArch64 is derived from the ARM port :).

Just to give an example on this hashmatch tool (with the 3.5-rc5
kernel):

$ ./blockhash -p '*.[chS]' arch/arm/ > arm.hash

$ find arch/unicore32/ -name '*.[chS]' -exec cat {} \; | wc -l
16384
$ /work/cmarinas/hashmatch/hashmatch -p '*.[chS]' arm.hash arch/unicore32/ | grep -e "|" | wc -l
9302

The tool claims unicore32 shares 57% with arch/arm. It gets confused in
the same way because unicore32 started with the ARM port as the code
base. Do we want it merged with arch/arm based on hashmatch?

According to this tool, AArch64 also shared 23% with x86, relatively
large given that it started from the arch/arm port (which in turn
started from arch/i386 long time ago).

I can go on and compare architectures with each-other but I really think
it's a waste of time.

> In 2.5.5, when arch/x86_64 was introduced it was 35412 lines of code.
> hashmatch (http://www.samba.org/~tridge/hashmatch) says that about 24642
> are identical with arch/i386 in the same kernel.  That's 70%.  Some of
> that's boilerplate: 9610 lines are in common with arch/sparc64 (27%),
> so let's say that 43% of x86-64 was specifically sharable with i386.
> 
> arch/aarch64/ is 22016 line of code.  Hashmatch says 12509 (57%) is in
> common with arch/arm.  But only 3232 lines (15%) are in common with
> sparc.  So let's say that 42% of aarch64 is specifically sharable with
> arm.

This tool also shows that pretty much most of the atomic.h file in
AArch64 is the same with AArch32. That's completely wrong as the
assembly syntax is different for the two architectures (even the asm
comment has changed from @ to //). That's a file that can never be
shared.

So ignoring the misleading tool, I did an analysis of the code
similarities with AArch32 a couple of months ago. It's about 5% files
that are close and could shared relatively easily but a significant part
of those are simple (header) files without algorithmic value and with
the copyright note being sometimes being longer than the code. There is
another 5-7% code that looks similar but merging them with AArch32
require more #ifdef's around the code (have a look at
arch/{arm,aarch64}/mm/mmu.c as an example).

The above is just on the current small AArch64 code base. I already said
a few times, there is still significant development to be done.

-- 
Catalin
