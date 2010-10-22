Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab0JVOsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 10:48:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59106 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab0JVOsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 10:48:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexey Charkov <alchark@gmail.com>
Subject: Re: [PATCH 1/6] ARM: Add basic architecture support for VIA/WonderMedia 85xx SoC's
Date: Fri, 22 Oct 2010 16:48:24 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-next-20101021+; KDE/4.5.1; x86_64; ; )
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
References: <1287608139-21354-1-git-send-email-alchark@gmail.com> <201010221102.12329.arnd@arndb.de> <AANLkTi=F2VA_3L9-49OQ=Bj1KaD2T58Ske2qvHFqirM9@mail.gmail.com>
In-Reply-To: <AANLkTi=F2VA_3L9-49OQ=Bj1KaD2T58Ske2qvHFqirM9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010221648.25193.arnd@arndb.de>
X-Provags-ID: V02:K0:Bs7zCzrHzK69z+4ZxZIonHeL2em6Per5GaVVXYcdL4Z
 Ujul+G4bhP7L4Lwc9DrSQBSRtxtM6m5s2oKeNEiFUQsGkIsdHh
 ZBO29O/20ZOed267yrvsP/K+RpNmOIjP1qmv8Wmh5GqhJNGQjM
 vDPOtXS5b0wb6JCPWew2Nb7F3ZN8HPRCUaQeoiyXtzvmO4uPgQ
 H7j+RVmAHsG8EYgxmghIQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 October 2010 15:52:26 Alexey Charkov wrote:
> 2010/10/22 Arnd Bergmann <arnd@arndb.de>:
> > On Thursday 21 October 2010 23:08:39 Alexey Charkov wrote:

> > Well, you could still build a specialized kernel with only support for
> > one resolution if you care about every byte.
> >
> 
> If it is fine to accept an option like "panel=<value_from_a_list>" at
> map_io stage, then I'd rather go that way, and calculate the minimum
> required buffer size for the current configuration. Especially if we
> decide to make a unified image for different SoC revisions, as WM8505
> requires 32bpp framebuffer, while VT8500 requires it to be 4MB-aligned
> native-bpp.

sounds ok to me.

> >> Cleaned this up in the development repo, thanks. Only left #ifdef's
> >> for the sections where respective register/interrupt definitions would
> >> be unavailable due to compiling for a different SoC version, and
> >> adjusted the conditions accordingly.
> >
> > Ideally those should also be run-time decisions so you can build a
> > kernel that works on both. It's all __init code, so it won't eat
> > up any RAM afterwards.
> >
> 
> I thought about that, and it should be quite useful. However, register
> and interrupt definitions should then be converted into some indexed
> data structures instead of macros (as they differ between VT8500 and
> WM8505), and the correct index should be selectable at runtime.

Right.

> Is there any way to determine which mach type we are currently running
> at after early head.S initialization completes and before we could
> need to use any registers and/or interrupts? It could probably be done
> in machine-specific fixup functions, but I'm unsure whether this would
> be a correct way to go.

Normally you put the register areas into the resources for platform
devices, which are board specific. The drivers then ioremap the resource
and use offsets into those ranges.

> > For the IO_SPACE_LIMIT, just make it 0xffff
> >
> > For __io, you need to find a place in your virtual address space
> > and map the real IO space.
> >
> > According to the VIA source code, the physical I/O window is at
> > 0xd8000000, they also map it to the same address in virtual space
> > but you can have anywhere convienient.
> >
> 
> Are you sure about that? 0xd8000000 is the MMIO base, as far as I can
> tell (see register definitions in <mach/vt8500.h>). In earlier
> discussions you presumed [1] that IO could be at 0xc0000000, but I'm
> not sure how to verify that. If so, should it then look something like
> this:
> 
> #define __io(a) ((void __iomem *)(((a) + 0xc0000000) +
> SOME_OFFSET_TO_VIRT_SPACE))

You are right, 0xd8000000 is certainly not the PCI I/O space, it is
the SoC MMIO area.

The comment in the original PCI code says

        /*
         * PCI Bridge Memory Map is between 0xC0000:0000 - 0xC3FF:FFFF(64MB)
         * The first 64KB is allocated for the PCI I/O Space, except for the
         * 0xCF8 - 0xCFF(8Bytes) for the PCI Configuration
         * Others are reserved for the MemorySpace.
         */

So this should be mapped somewhere. Best map this in your map_desc
at boot time to a fixed __iomem address.
 
> ?
> By the way, other boards except for footbridge, integrator, ebsa110
> and ixp4xx define IO_SPACE_LIMIT to be 0xffffffff. 0xffff seems more
> plausbile, though...

Yes, I have noticed that before and have thought about fixing them/
If you don't have PCI or PCMCIA, it doesn't really matter. What some
platforms do is to define the I/O port range to be 32 bit addressable
and then have multiple PCI buses with long port numbers, relying on
the bus to crop them to 16 bits again, but that breaks a few assumptions
in other code.

	Arnd
