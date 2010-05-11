Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab0EKWkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 18:40:19 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44332 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab0EKWkR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 18:40:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=yDr0sU/RtmnBeYYeoeGxKqguYUo4CL5jxWcHRuUaHaPzaNkjk02y6CCT0EDBVs/kYR
         UR7bvFDfaQ2MiqO9+4jB/X0Two5OQ1qwG/a4V+ZknXAt301v0O6dnvq2SdhmHoFxlEgu
         ZwhHp1gvORiqILSp86wVyQX3/JNbNrAGbzdxc=
MIME-Version: 1.0
In-Reply-To: <20100511215359.GF7396@core.coreip.homeip.net>
References: <20100511063309.GC9644@core.coreip.homeip.net> 
	<AANLkTinV79HZqS1cktHDsTsHDel-0Nti_Uk4i7mGaRiK@mail.gmail.com> 
	<1273608441.15067.1002.camel@calx> <AANLkTimt-eRCt_HTq7OUwzG1dgRuzJHk1tlgOcq4ocL7@mail.gmail.com> 
	<alpine.DEB.2.00.1005111520260.1500@router.home> <AANLkTilEfZLWYxPmCQ1KHIvUGIF_8Qchali66wHNf2gB@mail.gmail.com> 
	<alpine.DEB.2.00.1005111544330.8388@router.home> <AANLkTimzxrZyQAfocTwIt5zCVyXP7bReKOvP4K7m8epO@mail.gmail.com> 
	<20100511214836.GH1726@emlix.com> <20100511215359.GF7396@core.coreip.homeip.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 11 May 2010 18:39:54 -0400
Message-ID: <AANLkTimm7bOmIz2sdODgHwtCk26kdHgZt7PvceM6gjS3@mail.gmail.com>
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Johannes Weiner <jw@emlix.com>, Christoph Lameter <cl@linux.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?UTF-8?Q?Daniel_Gl=C3=B6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Nick Piggin <npiggin@suse.de>,
       David Rientjes <rientjes@google.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 17:53, Dmitry Torokhov wrote:
> On Tue, May 11, 2010 at 11:48:36PM +0200, Johannes Weiner wrote:
>> On Tue, May 11, 2010 at 04:54:41PM -0400, Mike Frysinger wrote:
>> > does the phrase "DMA safe buffer" imply cache alignment ?
>>
>> I guess that depends on the architectural requirements.  On x86,
>> apparently, not so much.  On ARM, probably yes, as it's the
>> requirement to properly maintain coherency.
>
> It looks liek ARM (and a few others) do this:
>
> [dtor@hammer work]$ grep -r ARCH_KMALLOC_MINALIGN arch/
> arch/sh/include/asm/page.h:#define ARCH_KMALLOC_MINALIGN        L1_CACHE_BYTES
> arch/frv/include/asm/mem-layout.h:#define       ARCH_KMALLOC_MINALIGN           8
> arch/powerpc/include/asm/page_32.h:#define ARCH_KMALLOC_MINALIGN        L1_CACHE_BYTES
> arch/arm/include/asm/cache.h:#define ARCH_KMALLOC_MINALIGN      L1_CACHE_BYTES
> arch/microblaze/include/asm/page.h:#define ARCH_KMALLOC_MINALIGN        L1_CACHE_BYTES
> arch/mips/include/asm/mach-tx49xx/kmalloc.h: * All happy, no need to define ARCH_KMALLOC_MINALIGN
> arch/mips/include/asm/mach-ip27/kmalloc.h: * All happy, no need to define ARCH_KMALLOC_MINALIGN
> arch/mips/include/asm/mach-ip32/kmalloc.h:#define ARCH_KMALLOC_MINALIGN 32
> arch/mips/include/asm/mach-ip32/kmalloc.h:#define ARCH_KMALLOC_MINALIGN 128
> arch/mips/include/asm/mach-generic/kmalloc.h:#define ARCH_KMALLOC_MINALIGN      128
> arch/avr32/include/asm/cache.h:#define ARCH_KMALLOC_MINALIGN    L1_CACHE_BYTES

if ARCH_KMALLOC_MINALIGN is not defined, the current allocators default to:
 slub - alignof(unsigned long long)
 slab - alignof(unsigned long long)
 slob - alignof(unsigned long)
which for many arches can mean an alignment of merely 4 or 8

lets look at the cacheline sizes for arches that dont set
ARCH_KMALLOC_MINALIGN to L1_CACHE_BYTES:
 - alplha - 32 or 64
 - frv - 32 or 64
 - blackfin - 32
 - parisc - 32 or 64
 - mn10300 - 16
 - s390 - 256
 - score - 16
 - sparc - 32
 - xtensa - 16 or 32

assuming alpha and s390 handle cache coherency in hardware, it looks
to me like the proposed assumption (kmalloc returns cachealigned
pointers when cache management is in software) does not hold true.

so should these other arches also be setting ARCH_KMALLOC_MINALIGN to
L1_CACHE_BYTES ?
-mike
