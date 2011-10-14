Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab1JNV3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 17:29:09 -0400
Received: from relais.videotron.ca ([24.201.245.36]:21893 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab1JNV3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 17:29:07 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Fri, 14 Oct 2011 17:28:55 -0400 (EDT)
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
In-reply-to: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A3A6@HQMAIL01.nvidia.com>
Message-id: <alpine.LFD.2.02.1110141718160.17040@xanadu.home>
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com>
 <201110141729.41515.arnd@arndb.de>
 <74CDBE0F657A3D45AFBB94109FB122FF173BE1A283@HQMAIL01.nvidia.com>
 <201110141827.53906.arnd@arndb.de>
 <CAOesGMgDwMeVmwo1WJ3tU+ZdjCSJ6F8mY42e_KwTmzAkGQsqmg@mail.gmail.com>
 <20111014192011.GS21648@n2100.arm.linux.org.uk>
 <alpine.LFD.2.02.1110141549160.17040@xanadu.home>
 <74CDBE0F657A3D45AFBB94109FB122FF173BE1A362@HQMAIL01.nvidia.com>
 <alpine.LFD.2.02.1110141631530.17040@xanadu.home>
 <74CDBE0F657A3D45AFBB94109FB122FF173BE1A3A6@HQMAIL01.nvidia.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Stephen Warren wrote:

> Nicolas Pitre wrote at Friday, October 14, 2011 2:45 PM:
> > On Fri, 14 Oct 2011, Stephen Warren wrote:
> ...
> > > I did originally briefly look into getting U-Boot to boot a zImage, but
> > > that looked like a far more invasive patch. There were rumours of some
> > > chip's custom U-Boot already having such support, but I couldn't find
> > > it, nor any evidence of such support in mainline U-Boot.
> > 
> > FRom my clone of the u-Boot repo:
> > 
> > $ git grep -l zImage
> > README
> > arch/sh/lib/zimageboot.c
> > arch/x86/lib/zimage.c
> > ...
> > 
> > Even the name of some of those files clearly hints zImage support.
> > 
> > In any case, loading zImage should be even simpler than loading uImage.
> > It is the same as loading uImage except that you just have to skip the
> > checking and relocating steps.
> 
> Just by way of background in case anyone is wondering why I wrote the
> patch I did:
> 
> Those files both implement custom commands "zimageboot" and "zboot". I
> was looking for integration with the existing "bootm" command.
> 
> The advantage of re-using "bootm" for this is that it already supports
> all the stuff like setting up kernel command-lines, initrds, knowing how
> to pass the FDT to the kernel, and whatever other OS-specific setup might
> be required.

Absolutely.  And that is a must-have.

> The disadvantage of adding zImage support to bootm is that I'd have to
> teach a bunch of U-Boot image handling code about a new image format; it
> already knows about "legacy uImage", "FIT" images, and I'd have to add a
> third "zImage" format. Doing so would at least require adding a lot of
> "case IMAGE_FORMAT_ZIMAGE" everywhere, but it'd probably be best to add
> some kind of vtable for image formats to move all the image-format
> knowledge into format-specific files, leaving the users of the images
> with much smaller code.
> 
> I didn't feel like making such a large change. Hence, I chose to make a
> small change to the existing uImage support.

And that change is certainly valuable.  Some people do want the extra 
feature from the uImage format.  REmoving its absolute address 
limitation is a good thing.

However, also supporting zImage directly on ARM doesn't have to be that 
hard.  Instead of adding "case IMAGE_FORMAT_ZIMAGE" everywhere, all you 
would have to do is to load zImage in memory according to the load 
address provided as an argument to the command, and then fake a uImage 
load by artificially creating the uImage header at run time with the 
data that u-Boot needs later on.


Nicolas
