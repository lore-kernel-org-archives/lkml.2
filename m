Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab1JOP3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 11:29:21 -0400
Received: from smarthost03.mail.zen.net.uk ([212.23.3.142]:35191 "EHLO
	smarthost03.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752678Ab1JOP3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 11:29:20 -0400
Subject: Re: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
From: Tixy <tixy@yxit.co.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Warren <swarren@nvidia.com>, Erik Gilling <konkers@android.com>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20111014201953.GX21648@n2100.arm.linux.org.uk>
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com>
	 <201110141729.41515.arnd@arndb.de>
	 <74CDBE0F657A3D45AFBB94109FB122FF173BE1A283@HQMAIL01.nvidia.com>
	 <201110141827.53906.arnd@arndb.de>
	 <CAOesGMgDwMeVmwo1WJ3tU+ZdjCSJ6F8mY42e_KwTmzAkGQsqmg@mail.gmail.com>
	 <20111014192011.GS21648@n2100.arm.linux.org.uk>
	 <alpine.LFD.2.02.1110141549160.17040@xanadu.home>
	 <20111014201223.GV21648@n2100.arm.linux.org.uk>
	 <74CDBE0F657A3D45AFBB94109FB122FF173BE1A365@HQMAIL01.nvidia.com>
	 <20111014201953.GX21648@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Oct 2011 16:29:12 +0100
Message-ID: <1318692552.2241.47.camel@computer2>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost03-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 21:19 +0100, Russell King - ARM Linux wrote:
> On Fri, Oct 14, 2011 at 01:16:27PM -0700, Stephen Warren wrote:
> > Russell King wrote at Friday, October 14, 2011 2:12 PM:
> > > I don't think that's so with the various flavours of platform specific
> > > uboot which float around.  For instance, on the OMAP4430 SDP, the
> > > following commands were used as supplied to load a uImage off the SD
> > > card into RAM at a different address to which it was built for, and
> > > execute it at that address:
> > > 
> > > mmcinit 0
> > > fatload mmc 0 0x80300000 uImage
> > > bootm 80300000
> > > 
> > > Whether the 'bootm' command then copied the image and called it there,
> > > or whether it executed it at 0x80300000 I've no idea - but why then
> > > load the image at a different address in the first place?
> > 
> > Yes, U-Boot's image handling looks at the image at 80300000, extracts the
> > "load address" from the image header, memcpy()'s the image to that address,
> > then jumps to the "entry address" in the image header.
> 
> Ah, so specifying that address is just a total waste of space then,
> because you might as well specify an address which results in the
> copy not being necessary.
> 
> However, I'd expect that uboot is dumb enough to still do the copy
> irrespective of whether its already in the right place.

U-Boot doesn't do an unnecessary copy if the body of the image is
already at the load address specified in the image header.

Unfortunately, it also doesn't do a copy if the header of the image is
at the load address, (I guess to support images constructed with an
embedded header). This means that

  fatload mmc 0 0x80300000 uImage
  bootm 0x80300000

will crash as it will attempt to boot Linux by executing the image
header. To successfully boot without requiring a relocation we would
need:

  fatload mmc 0 0x80300000-sizeof(header) uImage
  bootm 0x80300000

-- 
Tixy


