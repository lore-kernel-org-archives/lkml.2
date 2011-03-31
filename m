Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab1CaKuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 06:50:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52248 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab1CaKuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 06:50:37 -0400
Date: Thu, 31 Mar 2011 11:50:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Nicolas Pitre <nico@fluxnic.net>, Dave Airlie <airlied@gmail.com>,
        david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110331105000.GC14323@n2100.arm.linux.org.uk>
References: <201103301906.42429.arnd@arndb.de> <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com> <alpine.LFD.2.00.1103301531420.28032@xanadu.home> <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com> <alpine.LFD.2.00.1103301814250.28032@xanadu.home> <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm> <alpine.LFD.2.00.1103302255280.28032@xanadu.home> <AANLkTikV5OMifKjWRVdtJLEcxcZ56jrjWLYJBX89pHQ0@mail.gmail.com> <alpine.LFD.2.00.1103310012500.28032@xanadu.home> <20110331105440.42692165@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331105440.42692165@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 10:54:40AM +0100, Alan Cox wrote:
> If I boot it on a current PC I'm booting on a multiprocessor system with
> different timers, totally different IRQ controllers, different keyboard
> controllers (USB), PCI Express, an IOMMU, NCQ SATA, ACPI, graphics
> running in shared host memory able to give/take pages from the host,
> extra instructions, etc etc
> 
> And the same kernel boots just fine on both just fine.

We've been there for a long time with ARM.  Right from the start I had
a single kernel image which booted over a range of ARM CPUs and
platforms.

As far as ARM CPU architectures go, today we can have a single kernel
image which covers ARMv3 to ARMv5, and a separate kernel image which
covers ARMv6 to ARMv7 including SMP and UP variants.  The thing which
currently stops ARMv3 to ARMv7 all together is the different page table
layouts, the ASID tagging, the exclusive load/store support for cmpxchg
and other atomic operations, etc.

I wouldn't want to try to patch out the exclusive load/store operations
with some kind of function call to one of the generic implementations in
asm-generic as that gets you into ABI problems with GCC - it'd mean having
to tell GCC that various registers are clobbered all over the place.

With page tables, we can use the old format for ARMv5 with ARMv6 and
later, but that means we lose stuff like NX support to prevent instruction
prefetches hitting devices, which is of course a problem if you have
read-sensitive registers such as FIFOs there.

Can an x86 kernel with PAE support run on an x86 without PAE support?
The differences between ARMv5 and ARMv6 are much like PAE.


Outside of the CPU architecture, things become a lot more complicated.
The biggest one up until this merge window was that there is no fixed
address for system RAM, which makes stuff like virt_to_phys() rather
horrible to deal with - which in turn makes setting up and walking page
tables a nightmare.  We've just solved that issue with run-time patching
of the kernel code to replace the add/sub instructions with ones with
the appropriate offset, so we're a step closer to unifying everything
into one single kernel image.  This work alone produced this diffstat:

 87 files changed, 450 insertions(+), 190 deletions(-)

so it actually resulted in a net increase in the amount of code to be
maintained rather than reducing it.  That's hardly surprising as what
that replaced was just a bunch of #define's for PHYS_OFFSET with some
complex assembly code to do run-time patching of instructions.

The barriers against a single kernel image are being worked on, and it's
actually one of the things which Linaro is actively tasked to achieve.

One thing which I've been working on over the last six months is to
unify some of the ARM platforms which I use for testing the kernel on,
and I'd like to see one kernel image booting on all of those.

 65 files changed, 1168 insertions(+), 1752 deletions(-)

Given this thread, I've lost the motivation to continue with it because
it's just going to cause more 'pointless churn' and end up annoying
Linus even more.

And I'm not going to be merging anything into my tree for the time being.
I know there's no way for me to continue without being moaned at by someone.
So I'm just going to take the easy option at the moment and do precisely
nothing in terms of queueing patches until something gets resolved one way
or the other.  I'm not even going to review any patches because I currently
see it as a total waste of time - I've no idea whether they'll stand any
chance what so ever of making it into mainline.

What's the way out of this?  I've no idea.  Can ARM continue being part
of the mainline kernel?  I've no idea.  Will we be ripping out all the
ARM platform code from the mainline kernel?  I've no idea.

I am now completely demotivated.
