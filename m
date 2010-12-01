Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab0LALwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 06:52:49 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56859 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab0LALwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 06:52:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=pCMkS5Rne8yto8YM/hAf59VS1q0eI7BQXrENtazyOpS7BCo+i4kQOfUwrc9bTyUF2i
         x994pcSUvkTuVxC+iC6UqrI7ooDSCIBvrtZemVF/6dBHCrfUVhds7TdcXNAOeTMNINxz
         FFVPucguNAX8Gh5NS/8Xu2KPe5MTXJMk9p7ZY=
Date: Wed, 1 Dec 2010 12:52:28 +0100 (CET)
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
X-X-Sender: elektroman@localhost.localdomain
To: Paulius Zaleckas <paulius.zaleckas@gmail.com>
cc: Hans Ulli Kroll <ulli.kroll@googlemail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI BUS
In-Reply-To: <AANLkTinABzeM9Q+5PvvLX7HKYtDrig=nRHY7KMapJD5k@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1012011244120.8521@localhost.localdomain>
References: <1290860675-15453-1-git-send-email-ulli.kroll@googlemail.com> <201011291745.22566.arnd@arndb.de> <4CF3F687.6040801@gmail.com> <201011292102.41155.arnd@arndb.de> <4CF40AEF.7070200@gmail.com> <alpine.LNX.2.00.1011300910260.7489@localhost.localdomain>
 <AANLkTinABzeM9Q+5PvvLX7HKYtDrig=nRHY7KMapJD5k@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-572839355-1291204354=:8521"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-572839355-1291204354=:8521
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT



On Tue, 30 Nov 2010, Paulius Zaleckas wrote:

> On Tue, Nov 30, 2010 at 10:15 AM, Hans Ulli Kroll
> <ulli.kroll@googlemail.com> wrote:
> >
> >
> > On Mon, 29 Nov 2010, Paulius Zaleckas wrote:
> >
> >> On 11/29/2010 10:02 PM, Arnd Bergmann wrote:
> >> > On Monday 29 November 2010 19:52:55 Paulius Zaleckas wrote:
> >> > > On 11/29/2010 06:45 PM, Arnd Bergmann wrote:
> >> > > > There are many differences between readl and __raw_readl, including
> >> > > >
> >> > > > * __raw_readl does not have barriers and does not serialize with
> >> > > >     spinlocks, so it breaks on out-of-order CPUs.
> >> > > > * __raw_readl does not have a specific endianess, while readl is
> >> > > >     fixed little-endian, just as the hardware is in this case.
> >> > > >     The endian-conversion is a NOP on little-endian ARM, but required
> >> > > >     if you actually run on a big-endian ARM (you don't).
> >> > > > * __raw_readl may not be atomic, gcc is free to split the access
> >> > > >     into byte wise reads (it normally does not, unless you mark
> >> > > >     the pointer __attribute__((packed))).
> >> > > >
> >> > > > In essence, it is almost never a good idea to use __raw_readl, and
> >> > > > the double underscores should tell you so.
> >> > >
> >> > > You are wrong:
> >> > >
> >> > > Since CONFIG_ARM_DMA_MEM_BUFFERABLE is NOT defined for FA526 core,
> >> > > no barriers are in use when using readl. It just translates into
> >> > > le32_to_cpu(__raw_readl(x)). Now this CPU has physical pin for endianess
> >> > > configuration and if you will chose big-endian you will fail to read
> >> > > internal registers, because they ALSO change endianess and le32_to_cpu()
> >> > > will screw it. However it is different when accessing registers through
> >> > > PCI bus, then you need to use readl().
> >> >
> >> > Ok, I only checked that the platform does not support big-endian Linux
> >> > kernel, not if the HW designers screwed up their registers, sorry about
> >> > that.
> >> >
> >> > The other points are of course still valid: If the code ever gets
> >> > used on an out of order CPU, it is broken. More importantly, if someone
> >> > looks at the code as an example for writing another PCI support code,
> >> > it may end up getting copied to some place where it ends up causing
> >> > trouble.
> >> >
> >> > The typical way to deal with mixed-endian hardware reliably is to have
> >> > a header file containing code like
> >> >
> >> > #ifdef CONFIG_GEMINI_BIG_ENDIAN_IO
> >> > #define gemini_readl(x) __swab32(readl(x))
> >> > #define ...
> >> > #else
> >> > #define gemini_readl(x) readl(x))
> >> > #endif
> >> >
> >> > This also takes care of the (not as unlikely as you'd hope) case that
> >> > the next person reusing the PCI hardware wires its endianess different
> >> > from the CPU endianess.
> >>
> >> Actually I am not very sure how CPU works in big endian mode :)
> >> I have never tried it and I think only some guys who made it did that.
> >> So readl will work for 99.99% of cases. In datasheet they say that:
> >> "All registers in Gemini use Little Endian and must be accessed by aligned
> >> 32-bit word operations. The bus connection interface logic provides an Endian
> >> Conversion function."
> >> For me it looks like it can mean whatever you want :)
> >>
> >
> > I think the endianes pin switched only the cpu, not the hardware
> > registers.
> 
> Yes, but original driver used readl/writel and it does le32_to_cpu,
> so that structure definition is just reversing it.
> If you will use __raw_readl/__raw_writel than there will be no need
> for this redefinition.
> 
> > Here is some sample code from the ethernet devive on Gemini
> > typedef union
> > {
> >        unsigned int bits32;
> >        struct bit
> >        {
> > #if (BIG_ENDIAN==1)
> >                unsigned int reserved           : 15;   // bit 31:17
> >                unsigned int v_bit_mode         : 1;    // bit 16
> >                unsigned int device_id          : 12;   // bit 15:4
> >                unsigned int revision_id        : 4;    // bit  3:0
> > #else
> >                unsigned int revision_id        : 4;    // bit  3:0
> >                unsigned int device_id          : 12;   // bit 15:4
> >                unsigned int v_bit_mode         : 1;    // bit 16
> >                unsigned int reserved           : 15;   // bit 31:17
> > #endif
> 
> The other thing is that this endianess redefinition is very starnge since
> it should swap bytes and not bits inside this struct. So I assume that
> big endian was never tested on this driver and it will not work.
> But ofcouse I can be wrong here :)
> 

At this momment my brain restarts in very slow motion mode ;-)
This can't work. The definition Storlinksemi uses for swapping bits and 
bytes are totaly wrong. 
They never _even_ testet this, or understand little endian or big endian.
Take this simple sample

typedef union {
	unsigned int bits32;
	struct bit {
#if (BIG_ENDIAN==0) 
		unsigned int a	: 1;		
		unsigned int b  : 31;
#else
		unsigned int b  : 31;
		unsigned int a  : 1;
#endif
	};
} TEST;

They swaped the bits inside one byte

> >        } bits;
> > } TOE_VERSION_T;
> >
> >
> >
> 
--8323328-572839355-1291204354=:8521--
