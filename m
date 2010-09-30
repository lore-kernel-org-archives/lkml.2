Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab0I3MFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 08:05:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50789 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab0I3MFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 08:05:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: ioremap definition in generic io.h
Date: Thu, 30 Sep 2010 14:04:36 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
References: <1285747145.12259.3.camel@needafix> <201009301345.16817.arnd@arndb.de> <1285847579.2639.3.camel@needafix>
In-Reply-To: <1285847579.2639.3.camel@needafix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009301404.36551.arnd@arndb.de>
X-Provags-ID: V02:K0:n0sWdofLvuKqRT6HI6VRaKMBdIe/GuPYdfGmsCjz2a3
 PGLo1Q9vlo57W6YGqGMJBaw7pUeOyuJlDI78IyomvuLdPXgdJM
 f0+bIsgRwkLhtExOfkBBu7UUDTjAP47etAf3vPCD6wnuJ0BQ6D
 42mgvZkCO8wND+MZ2kkTezjXkLFvnJKHXgt9oOc9FVkZJU5kAh
 1ArM2iC/ApzUzFFF+FT4g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 September 2010, Jonas Bonn wrote:
> On Thu, 2010-09-30 at 13:45 +0200, Arnd Bergmann wrote:
> > On Wednesday 29 September 2010, Jonas Bonn wrote:
> > > On another note, looking at the definitions of ioread32/iowrite32, they
> > > imply a little-endian bus.  Some architectures (e.g. Microblaze) define
> > > these to use host-native byte ordering instead.  Is there a correct
> > > way these functions should be defined?
> > 
> > ioread32/iowrite32 are accessor functions for PCI byte order which is
> > little endian. If microblaze does this differently, that is a microblaze
> > bug. Any code that needs big-endian I/O should use ioread32be/iowrite32be.
> > 
> 
> So what's the correct way to do host-native access?  For example, big
> endian access on a big endian processor.  I think I'm missing something
> fundamental here...

The I/O accessors in Linux are written under the assumption that the I/O
device is fixed endian and may be used on both kinds of CPUs.

I assume that microblaze is a special case here because you synthesize
the I/O devices together with the CPU core and choose a common endianess
for both, right?

We have the __raw_readl()/__raw_writel() functions which are defined as
host-endian, but I would not recommend using them in general because they
also mean slightly different things depending on the architecture.

It's probably best to define your own functions for microblaze. Obviously
the drivers are not portable to other architectures anyway because those
might be cross-endian.

It's probably best to name the accessors by the bus that the devices
are attached to, and then define them in a a per-bus header file, like

#ifdef CONFIG_PLB_BIG_ENDIAN
#define plb_ioread32(p) ioread32be(p)
#define plb_iowrite32(p) iowrite32be(p)
#else
#define plb_ioread32(p) ioread32(p)
#define plb_iowrite32(p) iowrite32(p)
#endif

	Arnd
