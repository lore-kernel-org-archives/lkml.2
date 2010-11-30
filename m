Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab0K3IPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 03:15:19 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38179 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab0K3IPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 03:15:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=luReE2odfuyQ2dl2IALZLdZnDv3xOmLMzyu3A4lrKJqDs3IqxcNDisLGpGARVo9Bv/
         MhCd4anqUDaeXaMmo/bSSVzn7cNQeghrknPJrxrU1ur62K0j3/ugQZt6xYeZCpVuWFRR
         QQ1iAf85cMHHkRW236bi9GqpLE9Yy02XsQi0I=
Date: Tue, 30 Nov 2010 09:15:05 +0100 (CET)
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
X-X-Sender: elektroman@localhost.localdomain
To: Paulius Zaleckas <paulius.zaleckas@gmail.com>
cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI BUS
In-Reply-To: <4CF40AEF.7070200@gmail.com>
Message-ID: <alpine.LNX.2.00.1011300910260.7489@localhost.localdomain>
References: <1290860675-15453-1-git-send-email-ulli.kroll@googlemail.com> <201011291745.22566.arnd@arndb.de> <4CF3F687.6040801@gmail.com> <201011292102.41155.arnd@arndb.de> <4CF40AEF.7070200@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Nov 2010, Paulius Zaleckas wrote:

> On 11/29/2010 10:02 PM, Arnd Bergmann wrote:
> > On Monday 29 November 2010 19:52:55 Paulius Zaleckas wrote:
> > > On 11/29/2010 06:45 PM, Arnd Bergmann wrote:
> > > > There are many differences between readl and __raw_readl, including
> > > >
> > > > * __raw_readl does not have barriers and does not serialize with
> > > >     spinlocks, so it breaks on out-of-order CPUs.
> > > > * __raw_readl does not have a specific endianess, while readl is
> > > >     fixed little-endian, just as the hardware is in this case.
> > > >     The endian-conversion is a NOP on little-endian ARM, but required
> > > >     if you actually run on a big-endian ARM (you don't).
> > > > * __raw_readl may not be atomic, gcc is free to split the access
> > > >     into byte wise reads (it normally does not, unless you mark
> > > >     the pointer __attribute__((packed))).
> > > >
> > > > In essence, it is almost never a good idea to use __raw_readl, and
> > > > the double underscores should tell you so.
> > >
> > > You are wrong:
> > >
> > > Since CONFIG_ARM_DMA_MEM_BUFFERABLE is NOT defined for FA526 core,
> > > no barriers are in use when using readl. It just translates into
> > > le32_to_cpu(__raw_readl(x)). Now this CPU has physical pin for endianess
> > > configuration and if you will chose big-endian you will fail to read
> > > internal registers, because they ALSO change endianess and le32_to_cpu()
> > > will screw it. However it is different when accessing registers through
> > > PCI bus, then you need to use readl().
> >
> > Ok, I only checked that the platform does not support big-endian Linux
> > kernel, not if the HW designers screwed up their registers, sorry about
> > that.
> >
> > The other points are of course still valid: If the code ever gets
> > used on an out of order CPU, it is broken. More importantly, if someone
> > looks at the code as an example for writing another PCI support code,
> > it may end up getting copied to some place where it ends up causing
> > trouble.
> >
> > The typical way to deal with mixed-endian hardware reliably is to have
> > a header file containing code like
> >
> > #ifdef CONFIG_GEMINI_BIG_ENDIAN_IO
> > #define gemini_readl(x) __swab32(readl(x))
> > #define ...
> > #else
> > #define gemini_readl(x) readl(x))
> > #endif
> >
> > This also takes care of the (not as unlikely as you'd hope) case that
> > the next person reusing the PCI hardware wires its endianess different
> > from the CPU endianess.
> 
> Actually I am not very sure how CPU works in big endian mode :)
> I have never tried it and I think only some guys who made it did that.
> So readl will work for 99.99% of cases. In datasheet they say that:
> "All registers in Gemini use Little Endian and must be accessed by aligned
> 32-bit word operations. The bus connection interface logic provides an Endian
> Conversion function."
> For me it looks like it can mean whatever you want :)
> 

I think the endianes pin switched only the cpu, not the hardware 
registers.

Here is some sample code from the ethernet devive on Gemini
typedef union
{
	unsigned int bits32;
	struct bit
	{
#if (BIG_ENDIAN==1)
		unsigned int reserved		: 15;	// bit 31:17
		unsigned int v_bit_mode		: 1;	// bit 16
		unsigned int device_id		: 12;	// bit 15:4
		unsigned int revision_id	: 4;	// bit  3:0
#else
		unsigned int revision_id	: 4;	// bit  3:0
		unsigned int device_id		: 12;	// bit 15:4
		unsigned int v_bit_mode		: 1;	// bit 16
		unsigned int reserved		: 15;	// bit 31:17
#endif
	} bits;
} TOE_VERSION_T;


