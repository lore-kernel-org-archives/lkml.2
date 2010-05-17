Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab0EQGNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 02:13:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:44884 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab0EQGNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 02:13:39 -0400
Message-ID: <4BF0DE5E.4010904@petalogix.com>
Date: Mon, 17 May 2010 08:12:46 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Johannes Weiner <jw@emlix.com>, Christoph Lameter <cl@linux.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?UTF-8?B?RGFuaWVsIEdsw7Zja25lcg==?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Nick Piggin <npiggin@suse.de>,
       David Rientjes <rientjes@google.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
References: <20100511063309.GC9644@core.coreip.homeip.net> 	<AANLkTinV79HZqS1cktHDsTsHDel-0Nti_Uk4i7mGaRiK@mail.gmail.com> 	<1273608441.15067.1002.camel@calx> <AANLkTimt-eRCt_HTq7OUwzG1dgRuzJHk1tlgOcq4ocL7@mail.gmail.com> 	<alpine.DEB.2.00.1005111520260.1500@router.home> <AANLkTilEfZLWYxPmCQ1KHIvUGIF_8Qchali66wHNf2gB@mail.gmail.com> 	<alpine.DEB.2.00.1005111544330.8388@router.home> <AANLkTimzxrZyQAfocTwIt5zCVyXP7bReKOvP4K7m8epO@mail.gmail.com> 	<20100511214836.GH1726@emlix.com> <20100511215359.GF7396@core.coreip.homeip.net> <AANLkTimm7bOmIz2sdODgHwtCk26kdHgZt7PvceM6gjS3@mail.gmail.com>
In-Reply-To: <AANLkTimm7bOmIz2sdODgHwtCk26kdHgZt7PvceM6gjS3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Tue, May 11, 2010 at 17:53, Dmitry Torokhov wrote:
>> On Tue, May 11, 2010 at 11:48:36PM +0200, Johannes Weiner wrote:
>>> On Tue, May 11, 2010 at 04:54:41PM -0400, Mike Frysinger wrote:
>>>> does the phrase "DMA safe buffer" imply cache alignment ?
>>> I guess that depends on the architectural requirements.  On x86,
>>> apparently, not so much.  On ARM, probably yes, as it's the
>>> requirement to properly maintain coherency.
>> It looks liek ARM (and a few others) do this:
>>
>> [dtor@hammer work]$ grep -r ARCH_KMALLOC_MINALIGN arch/
>> arch/sh/include/asm/page.h:#define ARCH_KMALLOC_MINALIGN        L1_CACHE_BYTES
>> arch/frv/include/asm/mem-layout.h:#define       ARCH_KMALLOC_MINALIGN           8
>> arch/powerpc/include/asm/page_32.h:#define ARCH_KMALLOC_MINALIGN        L1_CACHE_BYTES
>> arch/arm/include/asm/cache.h:#define ARCH_KMALLOC_MINALIGN      L1_CACHE_BYTES
>> arch/microblaze/include/asm/page.h:#define ARCH_KMALLOC_MINALIGN        L1_CACHE_BYTES
>> arch/mips/include/asm/mach-tx49xx/kmalloc.h: * All happy, no need to define ARCH_KMALLOC_MINALIGN
>> arch/mips/include/asm/mach-ip27/kmalloc.h: * All happy, no need to define ARCH_KMALLOC_MINALIGN
>> arch/mips/include/asm/mach-ip32/kmalloc.h:#define ARCH_KMALLOC_MINALIGN 32
>> arch/mips/include/asm/mach-ip32/kmalloc.h:#define ARCH_KMALLOC_MINALIGN 128
>> arch/mips/include/asm/mach-generic/kmalloc.h:#define ARCH_KMALLOC_MINALIGN      128
>> arch/avr32/include/asm/cache.h:#define ARCH_KMALLOC_MINALIGN    L1_CACHE_BYTES
> 
> if ARCH_KMALLOC_MINALIGN is not defined, the current allocators default to:
>  slub - alignof(unsigned long long)
>  slab - alignof(unsigned long long)
>  slob - alignof(unsigned long)
> which for many arches can mean an alignment of merely 4 or 8
> 
> lets look at the cacheline sizes for arches that dont set
> ARCH_KMALLOC_MINALIGN to L1_CACHE_BYTES:
>  - alplha - 32 or 64
>  - frv - 32 or 64
>  - blackfin - 32
>  - parisc - 32 or 64
>  - mn10300 - 16
>  - s390 - 256
>  - score - 16
>  - sparc - 32
>  - xtensa - 16 or 32

Just for completion.

microblaze - 16 or 32.

Michal

-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
