Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab0JVJC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 05:02:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53192 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab0JVJC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 05:02:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: vt8500-wm8505-linux-kernel@googlegroups.com
Subject: Re: [PATCH 1/6] ARM: Add basic architecture support for VIA/WonderMedia 85xx SoC's
Date: Fri, 22 Oct 2010 11:02:11 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-next-20101021+; KDE/4.5.1; x86_64; ; )
Cc: Alexey Charkov <alchark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
References: <1287608139-21354-1-git-send-email-alchark@gmail.com> <201010211401.53001.arnd@arndb.de> <AANLkTimkLqrbX+536TD630xFy=y-PxEdksc4sA0gz6fU@mail.gmail.com>
In-Reply-To: <AANLkTimkLqrbX+536TD630xFy=y-PxEdksc4sA0gz6fU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010221102.12329.arnd@arndb.de>
X-Provags-ID: V02:K0:c78VHjSd+uUw+YTEUrAN/JPdb/KX/6qMgKyIRXe+1HU
 /ovy2MnBvFW2w3JQO/E38vMZ4ygynoh4G3Zgf9Cx8vRICruirH
 iKk4P64GUomCf4ZXWuw6IXCSWfTMWRmYOrVAnz6Xt8BHLKFEpC
 QZhHaZbAWfXjou6cyFphWvBBKxzeMdOW3BXGe2Soq3nZDYei0e
 p8Ya2vvljLs2ddWQEqdAQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 October 2010 23:08:39 Alexey Charkov wrote:
> 2010/10/21 Arnd Bergmann <arnd@arndb.de>:
> > On Thursday 21 October 2010, Alexey Charkov wrote:
> > Parsing complex options in general is not ok, but something simpler
> > probably is.
> >
> > Having a Kconfig selected default is probably a good idea. The most
> > simple way to select this at boot time would be to have a list of
> > possible resolutions and pass a table index.
> >
> > Would a __setup() call work for you?
> >
> 
> Should probably be fine. Will it be allowable to accept something like
> "panel=800x480" and strncmp it against a list of recognized values,
> fall back to a Kconfig default on failure and printk the
> possibilities? Just expecting an obscure table index would not be too
> user-friendly, imho.

Sounds reasonable to me.
 
> >> And due to the fact that the framebuffer size calculation is tied to
> >> panel specification, it will boot in any case. The only problem that
> >> one could encounter would be suboptimal display (for example,
> >> offscreen pixmaps to become actually visible on screen if the panel is
> >> taller
> >> than expected, or some corruption in case it is wider).
> >
> > Another option might be to have a submenu with the possible resolutions
> > you want to allow and size the frame buffer for the largest of those,
> > but allow overriding the actual one at boot time.
> >
> 
> In this case display parameters could be parsed in the driver itself,
> but quite some memory will be over-allocated in extreme cases without
> any way to claim it back after boot. Having only 128MB of RAM, is it
> really better?

Well, you could still build a specialized kernel with only support for
one resolution if you care about every byte.

> Cleaned this up in the development repo, thanks. Only left #ifdef's
> for the sections where respective register/interrupt definitions would
> be unavailable due to compiling for a different SoC version, and
> adjusted the conditions accordingly.

Ideally those should also be run-time decisions so you can build a
kernel that works on both. It's all __init code, so it won't eat
up any RAM afterwards.

> >> >> +#ifndef __ASM_ARM_ARCH_IO_H
> >> >> +#define __ASM_ARM_ARCH_IO_H
> >> >> +
> >> >> +#define IO_SPACE_LIMIT 0xffffffff
> >> >> +
> >> >> +#define __io(a)              __typesafe_io(a)
> >> >> +#define __mem_pci(a) (a)
> >> >> +
> >> >> +#endif
> 
> Ok, figuring out better values for the macros would be great!

For the IO_SPACE_LIMIT, just make it 0xffff

For __io, you need to find a place in your virtual address space
and map the real IO space.

According to the VIA source code, the physical I/O window is at
0xd8000000, they also map it to the same address in virtual space
but you can have anywhere convienient.

	Arnd
