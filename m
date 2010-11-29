Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab0K2UDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 15:03:05 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52329 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab0K2UDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 15:03:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI BUS
Date: Mon, 29 Nov 2010 21:02:40 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1+; KDE/4.5.1; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
References: <1290860675-15453-1-git-send-email-ulli.kroll@googlemail.com> <201011291745.22566.arnd@arndb.de> <4CF3F687.6040801@gmail.com>
In-Reply-To: <4CF3F687.6040801@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011292102.41155.arnd@arndb.de>
X-Provags-ID: V02:K0:/tqkfqii9qpz3UTNYxWJkq0eY+EaGc/l22L/GQDvhgJ
 yIMMVZaE9Djl/rmSr2fDw6NJ7GWWgdxY2yUPMSs20EvT8j/1x1
 y9M7PdrVJqEdo84D0NqaTxMFnasxFO1pR+9pPoMuRSq0tllI79
 ZdcY6+DQ3fYPxaT+hQ/OmApNOHdXftigugowwsFJPpPzqTCki5
 hOiJbWJsDd3FgA+fKpbwA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 November 2010 19:52:55 Paulius Zaleckas wrote:
> On 11/29/2010 06:45 PM, Arnd Bergmann wrote:
> > There are many differences between readl and __raw_readl, including
> >
> > * __raw_readl does not have barriers and does not serialize with
> >    spinlocks, so it breaks on out-of-order CPUs.
> > * __raw_readl does not have a specific endianess, while readl is
> >    fixed little-endian, just as the hardware is in this case.
> >    The endian-conversion is a NOP on little-endian ARM, but required
> >    if you actually run on a big-endian ARM (you don't).
> > * __raw_readl may not be atomic, gcc is free to split the access
> >    into byte wise reads (it normally does not, unless you mark
> >    the pointer __attribute__((packed))).
> >
> > In essence, it is almost never a good idea to use __raw_readl, and
> > the double underscores should tell you so.
> 
> You are wrong:
> 
> Since CONFIG_ARM_DMA_MEM_BUFFERABLE is NOT defined for FA526 core,
> no barriers are in use when using readl. It just translates into
> le32_to_cpu(__raw_readl(x)). Now this CPU has physical pin for endianess
> configuration and if you will chose big-endian you will fail to read
> internal registers, because they ALSO change endianess and le32_to_cpu()
> will screw it. However it is different when accessing registers through
> PCI bus, then you need to use readl().

Ok, I only checked that the platform does not support big-endian Linux
kernel, not if the HW designers screwed up their registers, sorry about
that.

The other points are of course still valid: If the code ever gets
used on an out of order CPU, it is broken. More importantly, if someone
looks at the code as an example for writing another PCI support code,
it may end up getting copied to some place where it ends up causing
trouble.

The typical way to deal with mixed-endian hardware reliably is to have
a header file containing code like

#ifdef CONFIG_GEMINI_BIG_ENDIAN_IO
#define gemini_readl(x) __swab32(readl(x))
#define ...
#else
#define gemini_readl(x) readl(x))
#endif

This also takes care of the (not as unlikely as you'd hope) case that
the next person reusing the PCI hardware wires its endianess different
from the CPU endianess.

	Arnd
