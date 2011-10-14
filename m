Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423Ab1JNUOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 16:14:33 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18507 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933225Ab1JNUOb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 16:14:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 14 Oct 2011 13:14:20 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Nicolas Pitre <nico@fluxnic.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>,
        Erik Gilling <konkers@android.com>
Date: Fri, 14 Oct 2011 13:14:19 -0700
Subject: RE: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
Thread-Topic: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
Thread-Index: AcyKrL8TSc5OiwSGQzK5PlRaxY4+ZgAAEfcg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A362@HQMAIL01.nvidia.com>
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com>
 <201110141729.41515.arnd@arndb.de>
 <74CDBE0F657A3D45AFBB94109FB122FF173BE1A283@HQMAIL01.nvidia.com>
 <201110141827.53906.arnd@arndb.de>
 <CAOesGMgDwMeVmwo1WJ3tU+ZdjCSJ6F8mY42e_KwTmzAkGQsqmg@mail.gmail.com>
 <20111014192011.GS21648@n2100.arm.linux.org.uk>
 <alpine.LFD.2.02.1110141549160.17040@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1110141549160.17040@xanadu.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre wrote at Friday, October 14, 2011 2:06 PM:
> On Fri, 14 Oct 2011, Russell King - ARM Linux wrote:
> 
> > But... one thing to note is that it _is_ common to load the decompressor
> > at a _different_ address to that where the kernel ultimately ends up
> > residing to avoid the additional copy in the decompressor.  My experience
> > shows that this is quite common on the platforms I had supplied.  This
> > means that if we default to AUTO_ZRELADDR for !ZBOOT_ROM, we end up
> > having to have developers change their uboot setups to avoid unexpected
> > results.
> 
> Currently, U-Boot insists on having a uImage with a fixed absolute load
> address.  This is currently provided by the zreladdr value, whether or
> not AUTO_ZRELADDR is set.  I consider this as a persisting uImage
> limitation.

Well, that value only comes from zreladdr when running U-Boot's mkimage from
the kernel makefile rather than some other packaging script:-)

> Either u-Boot gets fixed so it can work with plain zImage (and this
> certainly will happen once the pressure from people wanting a single
> kernel to work on targets with different load addresses increase.
> Tegra is one such example.

I proposed to solve it by adding a new image format within the uImage;
"kernel-rel" rather than "kernel", where the load/entry address encoded
into the uImage is specified relative to "start of SDRAM" rather than
as an absolute address. This way, Tegra20 and Tegra30 will have the
same layout of U-Boot location, uImage load address, kernel execute
address etc. within SDRAM, but all those addresses might end up being
based at physical address 0, or physical address 2G.

Here's the patch I proposed:

http://patchwork.ozlabs.org/patch/119017/

What are your thoughts on this? I hope it will work for multi-SoC image
across vendors, although I suppose finding a common load address across
a bunch of different SoC's memory layouts might be tough?

I did originally briefly look into getting U-Boot to boot a zImage, but
that looked like a far more invasive patch. There were rumours of some
chip's custom U-Boot already having such support, but I couldn't find
it, nor any evidence of such support in mainline U-Boot.

> Or we create a u-Boot specific Kconfig menu for uImage options that
> would be common to all architectures and kick it out from the ARM
> specific makefile.  This is not solving the u-Boot limitation though.
> 
> In either cases this is a u-Boot problem that needs fixing on the u-Boot
> side in the end.

-- 
nvpublic

