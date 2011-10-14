Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab1JNUpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 16:45:25 -0400
Received: from relais.videotron.ca ([24.201.245.36]:33468 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab1JNUpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 16:45:23 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Fri, 14 Oct 2011 16:45:22 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Stephen Warren <swarren@nvidia.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>,
        Erik Gilling <konkers@android.com>
Subject: RE: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
In-reply-to: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A362@HQMAIL01.nvidia.com>
Message-id: <alpine.LFD.2.02.1110141631530.17040@xanadu.home>
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com>
 <201110141729.41515.arnd@arndb.de>
 <74CDBE0F657A3D45AFBB94109FB122FF173BE1A283@HQMAIL01.nvidia.com>
 <201110141827.53906.arnd@arndb.de>
 <CAOesGMgDwMeVmwo1WJ3tU+ZdjCSJ6F8mY42e_KwTmzAkGQsqmg@mail.gmail.com>
 <20111014192011.GS21648@n2100.arm.linux.org.uk>
 <alpine.LFD.2.02.1110141549160.17040@xanadu.home>
 <74CDBE0F657A3D45AFBB94109FB122FF173BE1A362@HQMAIL01.nvidia.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Stephen Warren wrote:

> Nicolas Pitre wrote at Friday, October 14, 2011 2:06 PM:
> > Currently, U-Boot insists on having a uImage with a fixed absolute load
> > address.  This is currently provided by the zreladdr value, whether or
> > not AUTO_ZRELADDR is set.  I consider this as a persisting uImage
> > limitation.
> 
> Well, that value only comes from zreladdr when running U-Boot's mkimage from
> the kernel makefile rather than some other packaging script:-)

So what?  The whole idea of a kernel that can be loaded anywhere is to 
_not_ have its load address packaged into it.  The fact that you need a 
separate packaging step just for the specification of that address is 
rather silly.

> > Either u-Boot gets fixed so it can work with plain zImage (and this
> > certainly will happen once the pressure from people wanting a single
> > kernel to work on targets with different load addresses increase.
> > Tegra is one such example.
> 
> I proposed to solve it by adding a new image format within the uImage;
> "kernel-rel" rather than "kernel", where the load/entry address encoded
> into the uImage is specified relative to "start of SDRAM" rather than
> as an absolute address. This way, Tegra20 and Tegra30 will have the
> same layout of U-Boot location, uImage load address, kernel execute
> address etc. within SDRAM, but all those addresses might end up being
> based at physical address 0, or physical address 2G.
> 
> Here's the patch I proposed:
> 
> http://patchwork.ozlabs.org/patch/119017/

By all means, please push your patch upstream and free us from this 
u-Boot misery!

> What are your thoughts on this? I hope it will work for multi-SoC image
> across vendors, although I suppose finding a common load address across
> a bunch of different SoC's memory layouts might be tough?

No it is not.  We know where the decompressed kernel will end up 
relative to the start of RAM, so it is always safe to simply load the 
uImage 
there.  Better yet is to load it with an additional offset corresponding 
to the decompressed kernel size (plus some small gap) in order to allow 
the decompressor skip the relocation step.  This is all trivial to 
determine.

> I did originally briefly look into getting U-Boot to boot a zImage, but
> that looked like a far more invasive patch. There were rumours of some
> chip's custom U-Boot already having such support, but I couldn't find
> it, nor any evidence of such support in mainline U-Boot.

FRom my clone of the u-Boot repo:

$ git grep -l zImage
README
arch/arm/cpu/ixp/npe/include/IxTimeSyncAcc.h
arch/sh/lib/zimageboot.c
arch/x86/include/asm/zimage.h
arch/x86/lib/zimage.c
doc/README.mx35pdk
include/configs/apollon.h
include/configs/mpc7448hpc2.h
include/configs/mpr2.h
include/configs/ms7720se.h
include/configs/pxa255_idp.h
include/configs/trizepsiv.h

Even the name of some of those files clearly hints zImage support.

In any case, loading zImage should be even simpler than loading uImage.  
It is the same as loading uImage except that you just have to skip the 
checking and relocating steps.


Nicolas
