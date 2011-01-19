Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab1ASJ6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 04:58:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:53958 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab1ASJ6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 04:58:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH] asm-generic/io.h: Fix io{read,write}{16,32}be for big endian systems
Date: Wed, 19 Jan 2011 10:58:29 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8; KDE/4.5.1; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1295374261-19609-1-git-send-email-lars@metafoo.de> <201101182237.53601.arnd@arndb.de> <4D36129F.8000302@metafoo.de>
In-Reply-To: <4D36129F.8000302@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101191058.30096.arnd@arndb.de>
X-Provags-ID: V02:K0:m0uQx9KCaKwDdtAfT5mR8OOc1KqL+0rpfOXJXBTpXgE
 Pwxl0xYVw9LVCOwAsVg3+r0eUHGXg15+oUMQnitGtm+pQcS78J
 oMp0JC5Wwcq29sAnyzb+ZqfUhfRvyOjEIdVr5Lddt8SwtXlPTR
 jQZyE7/MFCwyvYkyD0i3XnmHHsQ0to3KRRJI5LRdVgyYonhS8h
 6FYgN9RMlneIn9wbzUp2g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 January 2011 23:22:23 Lars-Peter Clausen wrote:
> On 01/18/2011 10:37 PM, Arnd Bergmann wrote:
> > ...
> The lm32 architecture is a big-endian softcpu architecture. I'm currently working on
> the MilkyMist SoC which uses it and all the SoC components have native endianess.

ok.

> > Some architectures also define their own I/O accessors for SoC components,
> > since those often have other requirements from PCI MMIO areas.
> > E.g. on powerpc, the in_be32/in_le32 accessor only works on directly
> > mapped MMIO regions and performs no PCI error handling.
> 
> I've seen those and actually the lm32 architecture currently defines (and uses) them
> as well. But I wanted to replace them with something more generic and try to reuse as
> much as possible from asm-generic.

That is a very good idea in general. Unfortunately, the asm-generic
infrastructure is currently missing an interface that is designed for
SoC components. IMHO, it would be very good if we could use this chance
to create one, or make an existing interface from one of the architectures
more generic. I can also understand if you don't want to get caught up
in the discussion between the architecture maintainers trying to find
a common position on this ;-).

> > That is indeed huge. Byte swapping is a relatively common operation
> > in the kernel, so independent of the solution to this particular
> > problem, it will be a good idea to see if you can do a better
> > implementation than this, using inline assembly or gcc internal
> > helpers.
> 
> The reason why it got so huge is that the kernel was compiled without barrel-shifter
> support, so we have basically 4 instructions per shift calling a helper function.
> 
> But thats not the point anyway. The point I'm trying to make is, that accessing
> iomapped memory is exactly a single instruction. And I don't see why - no matter if
> swab takes 4 or 20 instructions - we should add any additional overhead.

Right, and the point that I was trying to make is that an mmio read access
typically takes many hundred cycles, somtimes thousands of cycles, to
complete. Making the accessors out of line would be just fine, and even
a hundred instructions would not be much of an issue then (although a bit
silly if we just end up swapping twice, as you pointed out).

In the abscence of the barrel shifter, would it help to define the
function like this? (independent of the ioread question)

static inline __u32 __arch__swab32(__u32 x)
{
        union { __u32 u; char c[4]; } in, out;
	in.u = x;
	out.c[0] = in.c[3];
	out.c[1] = in.c[2];
	out.c[2] = in.c[1];
	out.c[3] = in.c[0];
        return out.u;
}
#define __arch__swab32 __arch__swab32

If your compiler has a __builtin_bswap32, that would be even better.

> >> So I as someone who implements arch support has two options either redefine
> >> ioread32be in the arch io header, or use __raw_readl everywhere to access iomap memory.
> > 
> > __raw_readl is not a good thing to use, because of a number of reasons.
> > Please choose one of these four:
> > 
> > * change the common ioread*/iowrite* functions to all be based on
> >   the __raw_* I/O versions, not just the big-endian ones. The
> >   space overhead you quoted is enough of a justification for that.
> 
> I would prefer this solution.

Ok, fair enough. When you send a patch to do that, please indicate whether
you prefer me to take it in my tree, or you just want to carry it in your
series with my Ack.

	Arnd
