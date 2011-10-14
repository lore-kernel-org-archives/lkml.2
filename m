Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab1JNTUg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:20:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38013 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab1JNTUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:20:34 -0400
Date: Fri, 14 Oct 2011 20:20:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>,
        Erik Gilling <konkers@android.com>
Subject: Re: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
Message-ID: <20111014192011.GS21648@n2100.arm.linux.org.uk>
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com> <201110141729.41515.arnd@arndb.de> <74CDBE0F657A3D45AFBB94109FB122FF173BE1A283@HQMAIL01.nvidia.com> <201110141827.53906.arnd@arndb.de> <CAOesGMgDwMeVmwo1WJ3tU+ZdjCSJ6F8mY42e_KwTmzAkGQsqmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMgDwMeVmwo1WJ3tU+ZdjCSJ6F8mY42e_KwTmzAkGQsqmg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 09:44:34AM -0700, Olof Johansson wrote:
> That is likely to get messy.
> 
> Seems like there could be some use for a (silent) option for a
> platform to indicate that it can do XIP kernel (or zImage), and thus
> not able to use AUTO_ZRELADDR (or other options that require rewriting
> text segment of zImage or kernel).

It's not that.

The options are:

AUTO_ZRELADDR=n ZBOOT_ROM=n => fixed address for decompressed kernel
	image to be decompressed to from zreladdr make variable,
	decompressor can be loaded to any RAM address.

AUTO_ZRELADDR=y ZBOOT_ROM=n => address for decompressed kernel calculated
	from location of zImage in RAM, decompressor must be loaded to
	the correct place in RAM and must always copy itself out of
	the way prior to decompressing.

AUTO_ZRELADDR=n ZBOOT_ROM=y => fixed address for decompressed kernel
	image to be decompressed to from zreladdr make variable,
	decompressor can be loaded to any RAM address which doesn't
	overlap its BSS segment, or decompressor programmed into
	read-only memory at the address to which it was compiled.

AUTO_ZRELADDR=y ZBOOT_ROM=y => invalid (think about it - this results
	in a zImage which is built to be run from read-only memory,
	and try to write the decompressed image into that read-only
	memory.)

This has nothing to do with XIP or not - XIP is a completely separate story,
and if you're building an XIP kernel you're not using the decompressor (so
AUTO_ZRELADDR and ZBOOT_ROM don't even feature.)  Neither does the dynamic
code patching stuff like ARM_PATCH_PHYS_VIRT.

ARM_PATCH_PHYS_VIRT has no bearing on AUTO_ZRELADDR or ZBOOT_ROM; that is
a property of the decompressed kernel image itself, and while your
decompressor may restrict where it can decompress the kernel image to,
the decompressed image itself remains free of those dependencies (and
eg, can be turned into a uImage with the appropriate load address
for other platforms.)

As I've said in the past, what I'd _like_ to see is that ARM_PATCH_PHYS_VIRT
be enabled for everything irrespective of any other configuration, and
we're just left with AUTO_ZRELADDR / ZBOOT_ROM to worry about.  The
overhead from the P:V patching is soo small that it's not really worth
even having the option in the general case - the only time when P:V
patching doesn't work is with non-linear translations found on some
sparsemem platforms.

But... one thing to note is that it _is_ common to load the decompressor
at a _different_ address to that where the kernel ultimately ends up
residing to avoid the additional copy in the decompressor.  My experience
shows that this is quite common on the platforms I had supplied.  This
means that if we default to AUTO_ZRELADDR for !ZBOOT_ROM, we end up
having to have developers change their uboot setups to avoid unexpected
results.
