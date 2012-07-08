Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab2GHJSf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 05:18:35 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59790 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031Ab2GHJSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 05:18:33 -0400
Date: Sun, 8 Jul 2012 10:18:19 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH 08/36] AArch64: Kernel booting and initialisation
Message-ID: <20120708091819.GA3845@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <1341608777-12982-9-git-send-email-catalin.marinas@arm.com>
 <4FF75986.8010706@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF75986.8010706@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 10:32:54PM +0100, Stephen Warren wrote:
> On 07/06/2012 03:05 PM, Catalin Marinas wrote:
> > The patch adds the kernel booting and the initial setup code.
> > Documentation/aarch64/booting.txt describes the booting protocol on the
> > AArch64 Linux kernel. This is subject to change following the work on
> > boot standardisation, ACPI.
> 
> > diff --git a/Documentation/aarch64/booting.txt b/Documentation/aarch64/booting.txt
> 
> > +3. Decompress the kernel image
> > +------------------------------
> > +
> > +Requirement: OPTIONAL
> > +
> > +The AArch64 kernel does not provide a decompressor and therefore
> > +requires gzip decompression to be performed by the boot loader if the
> > +default Image.gz target is used.  For bootloaders that do not implement
> > +this requirement, the larger Image target is available instead.
> 
> I'm curious why a decompressor isn't provided.

I don't find a need for it, at least not at this stage. If the kbytes
(or milliseconds?) it saves are really important, I would rather push
this to the boot-loader (well, simple .gz, .bz2 etc., doesn't require
much standardisation).

> The reason I ask is that this change will cause differences in the way
> e.g. a U-Boot script boots the kernel; the filename would be different,
> you'd need to use a uImage in order for U-Boot to decompress the kernel
> instead of a raw zImage, etc. This makes things on AArch64 work just a
> little bit different from existing systems, and differences between
> systems make for more things for everyone to understand and remember;
> more mistakes will be made. U-Boot has recently grown a "bootz" command
> to simplify booting a zImage directly for example, and now it seems that
> won't be useful moving forward.

I'm not sure U-Boot will be at all useful on AArch64. We don't plan any
port and the focus currently is UEFI with possibly a second stage boot
loader like GRUB.

But to your point, AArch64 *will* work differently from existing
systems. I want to break away from the separate platform configuration
and zImage files and start with single Image supporting multiple
platforms by default. Critical hardware initialisation for allowing
Linux to boot will be passed down to the firmware.

> Also, on Tegra at least and perhaps OMAP too, there are a few parts of
> earlyprintk serial port setup (i.e. port selection) which happen as part
> of the decompressor rather than the main kernel image, so we'd have to
> re-jig that too.

Whatever we did on AArch32, if it was useful and we want to follow a
similar model it needs porting given that the code cannot be shared. So
there is nothing to re-jig but rather implement.

As for earlyprintk, you can initialise it in the decompressed kernel
anyway. But even though it's a useful debugging tool, it goes against
the single Image aim (at least the current printascii/addruart
implementation). I don't have a proper implementation yet.

> > +4. Call the kernel image
> > +------------------------
> > +
> > +Requirement: MANDATORY
> > +
> > +The decompressed kernel image contains a 32-byte header as follows:
> > +
> > +  u32 magic	= 0x14000008;	/* branch to stext, little-endian */
> > +  u32 res0	= 0;		/* reserved */
> > +  u64 text_offset;		/* Image load offset */
> > +  u64 res1	= 0;		/* reserved */
> > +  u64 res2	= 0;		/* reserved */
> > +
> > +The image must be placed at the specified offset (currently 0x80000)
> > +from the start of the system RAM (aligned to 2MB) and called there.
> 
> Is "0x80000" meant to have an extra "0"; 0x80000 isn't aligned to 2MB
> unless I'm really missing too much sleep today.
 
The value is correct, it wasn't meant to be aligned to 2MB. Why would
that be? It's just an offset from the start of the RAM, which must
indeed be 2MB aligned (PHYS_OFFSET).

-- 
Catalin
