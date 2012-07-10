Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab2GJVUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 17:20:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54256 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab2GJVUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 17:20:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Date: Tue, 10 Jul 2012 21:19:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <201207101652.18401.arnd@arndb.de> <20120710203527.GA16986@gmail.com>
In-Reply-To: <20120710203527.GA16986@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207102119.38495.arnd@arndb.de>
X-Provags-ID: V02:K0:704xy38e/vrcw7MAwofZuLPmdnMKmAXtvEFLSf9SCjL
 CK+A33DKRrXcPd5OHK8BGujiZVWoVYpMaIiULhUxHI+SXdtM4Q
 xuAKsujXMA56WGPHVhKSqAWDx8SsMYZbbO2Qj2TuopoZwi5XG1
 NFHMl6JglJZCUJpdC9LndUoLmht+yF71jQUidwbXp89DKwEvWl
 44NGZUGPoFAJB0sDFgVWoy3XIEoZTWllfaoe204CGXfDxjTHH8
 iiP076Zq4eNWqCqxhcZRplM6HR6XKXsSFh/YKPDVrSvxWEflWF
 vNmqCsa6JfCsa4IybrmPnHAvFlz9nLWIQjqDWUyFKvZT3E9e1m
 OwUQFavZMvLrQH27s8VM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 July 2012, Ingo Molnar wrote:
> So are you really convinced that the colorful ARM SoC world is 
> not going to go 64-bit and will all unify behind a platform, and 
> that we can actually force this process by not accepting 
> non-generic patches? Is such a platform design being enforced by 
> ARM, like Intel does it on the x86 side?

We can almost build a kernel for all modern platforms on 32 bit,
and we know what pieces are missing. There is no technical reason
why we don't have a single kernel for all ARMv6 and ARMv7 platforms
already, it's just a shitload of work to get there starting out
with the existing platform code.

Of course we will have a lot of embedded 64 bit ARM SoCs, but
I'm convinced that we can deal with those. Rejecting crappy
code is easy as long as you can point to what they got wrong
specifically. There will also be out of tree platforms that
might not follow the same standards, but who cares about those?

> > * Unlike on 32 bit, the different platforms cannot be 
> > compile-time exclusive. A platform port that cannot be enabled 
> > without breaking another platform is not getting merged.
> > 
> > * I do not expect board-specific kernel patches, at least no 
> > more than we have them on x86 with the occasional hack to work 
> > around a broken machine.
> 
> If 64-bit hardware is made on existing SoC designs, which looks 
> rather likely, then we are not in a position to reject kernel 
> support for them.
> 
> Saying 'no' is very rarely a valid option for hardware ugliness. 
> We are encouraged to say 'no' for software details that is 
> actionable by the author of the patches, but hardware ugliness 
> is rarely actionable on that level and we are not holding our 
> users hostage in general just to make a point about ugliness.

We're doing it already for 32 bit. All new 32 bit platforms have
to follow the strictest rules for doing things the right way.
With 64 bit, we can raise the entry barrier even higher.

A much bigger problem than getting new contributions to be done
right is fixing the existing ones without regressing on hardware
support.

> > * The differences between SoCs will be confined to device 
> > drivers to a much larger degree than they are on 32 bit, 
> > partly because the SoC companies are trying to be fit into the 
> > single-kernel model, and partly because we have added the 
> > infrastructure to allow it.
> 
> There's 600 KLOC of code in arch/arm/, that's 3 times larger 
> than arch/x86/. Most of it is not in any fashion related to the 
> bitness of the CPU, it's platform IO code that is in principle 
> bitness agnostic.
> 
> I have a really hard time imagining that all 64-bit ARM hardware 
> will be supported from drivers/: IRQ controllers, timer drivers, 
> all the ugly SoC details.
> 
> Do you really think that all of the 32-bit ARM code should 
> essentially be thrown away when going to 64-bit ARM, that 
> patches can only touch arch/arm64/ + drivers/ or the highway?

Yes.

If you're curious, please have a look at arch/arm/mach-spear13xx/.
this is the latest platform that we have added. It's fully
functional (except PCI, which I hope will be added in
drivers/pci/bus, which is another story), A significant portion
of that platform deals with SMP support, which is being standardized
for AArch64, so there will be only one implementation. Another
big portion is DMA-engine support, which is moving out of arch/arm
as soon as we have a proper DT binding. Finally there are some
boilerplate header files that are going away too.

Once we're done with this, we will basically need zero code
in arch/*/ to support a new platform, and that is very easy
to share between two distinct arch/* directories ;-)

> The moment someone adds 64-bit CPU support to arch/arm/ and it's 
> merged we'll have an interesting situation on hand: support for 
> the same CPU in two different architectures in the kernel tree.

What if they add 64-bit ARM support to arch/x86? AFAIK some of the
machines are going to be basically PCs, including legacy I/O, ACPI
and UEFI, so they are much closer to that than they are to anything
in arch/arm. The instruction set of course is different, but you
already said that this doesn't matter.

	Arnd
