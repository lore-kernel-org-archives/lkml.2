Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab0L3I07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 03:26:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61918 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab0L3I06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 03:26:58 -0500
Date: Thu, 30 Dec 2010 01:26:54 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sodaville@linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] x86: Add device tree support
Message-ID: <20101230082654.GB11721@angua.secretlab.ca>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
 <1290706801-7323-3-git-send-email-bigeasy@linutronix.de>
 <1290807736.32570.143.camel@pasglop>
 <20101128134907.GA30784@www.tglx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101128134907.GA30784@www.tglx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 28, 2010 at 02:49:07PM +0100, Sebastian Andrzej Siewior wrote:
> * Benjamin Herrenschmidt | 2010-11-27 08:42:16 [+1100]:
> 
> >On Thu, 2010-11-25 at 18:39 +0100, Sebastian Andrzej Siewior wrote:
> >> Dirk is working on some patches which provide generic infrastructure for
> >> linking the dtb into the kernel. Once this is it its final shape, we
> >> will relocate the device tree unconditionally. This will remove the
> >> requirement for the boot loader to locate the device tree within lowmem.
> >
> >Linking the dtb into the kernel is something we prefer not doing on
> >powerpc and I'm curious why you think that applies better on x86...
> This is only for the case where we do not get a dtb from the bootloader
> Microblaze also links dtb into the kernel in that case.
> 
> >We -do- have ways to include it in the zImage wrapper. However, this is
> >different in subtle ways because of the way our zImage wrapper building
> >works. Basically, we always build all the per-platform .o's of the
> >wrapper that apply to supported platforms by the kernel. The
> >binding/linking together of the final wrapper with a kernel image, an
> >optional dtb and optional initrd is performed by a shell script that can
> >be used outside of the normal build context.
> 
> The reason why you have multiple .o wrapper files is because the specific
> platform code is not simply passing the device tree but also adding /
> updating nodes like MAC address, bus clocks, ... which are coming from
> the (different) bd_t struct or something else. The simpleboot target is
> covering the case where you just pass the embedded dtb to kernel without
> changing it.
> 
> On x86 we want to have the bootloader passing us the final dtb. The
> in-kernel dtb is more like a generic simpleboot target.

/me gets ready to dodge tomatoes thrown at him.

Hmmm, back up a minute...

Since Linux on x86 has pretty much always depended on a two stage boot
(firmware boots a bootloader like grub which in turn boots the
kernel), then what is the use case for pursuing an in-kernel dtb
linkage?  simpleimage was used on powerpc for the use-case where there
is no 2nd stage bootloader, but instead only the kernel which is
booted from some firmware that is non-upgradeable (or at least too
risky to upgrade).  Same with the cuImages.  The wrapper is
effectively a 2nd stage bootloader to adapt from what older u-boot
provides and what the kernel needs.

What is the boot sequence for the embedded x86 platforms?  Is there
still a bootloader?  If so, what prevents always depending on the
bootloader to pass in the device tree blob?  If the bootloader is
software (not firmware) then it should be something we have control
over when shipping a distribution.

BTW, don't take microblaze as the example to be emulated.  Some of
the things it does for device tree support is not scalable, like
linking the .dtbs directly into the kernel.

John Bonesio has also prototyped doing a similar zImage bootwrapper on
arm which allows a dtb to be concatenated to the kernel image and
updated before passing it to the kernel.  As it stands, there are no
plans to use in-kernel .dtb linking on ARM.

I know it's not very fair to bring up these issues again right before
the merge window opens.  I got myself overcommitted and dropped the
ball over the last 1.5 months and I beg forgiveness.  However, I do
want to make sure that the right decision is made and I'd be happier
if a consistent scheme is used for passing the .dtb on all
architectures.

> 
> >That means that it's possible for a distro for example to install a
> >kernel image, all the wrapper .o files and that script, and at runtime
> >rebuild zImage wrappers with the appropriate dtb without having the
> >whole built kernel tree at hand.
> For the distro reason the in-kernel dtb supports multiple dtbs. So a
> distro kernel can include all of them into .init.data section and the
> user can specify on the command line which device tree he wants. x86 gets
> its command line via the bootpage so it is available before we have a
> device tree. Microblaze should also be able to use this
> mechanism.

Should equally be able to support this as a boot wrapper with the
added advantage that additional .dtbs could be added to the kernel
image at install time without rebuilding the kernel.

g.
