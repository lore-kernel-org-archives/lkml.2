Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab2JCKnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 06:43:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46345 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2JCKns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 06:43:48 -0400
Date: Wed, 3 Oct 2012 11:43:35 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [ARM] Use AT() in the linker script to create correct
 program headers
Message-ID: <20121003104335.GA2254@linaro.org>
References: <20120930232116.GC30637@obsidianresearch.com>
 <20121001153952.GB2100@linaro.org>
 <20121001160639.GA31620@obsidianresearch.com>
 <20121001175647.GD2100@linaro.org>
 <20121001183543.GC22342@obsidianresearch.com>
 <20121002102346.GB2108@linaro.org>
 <20121002174759.GC23733@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002174759.GC23733@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Nicolas, do you have a view on this thread with regard to XIP?]

Hi,

On Tue, Oct 02, 2012 at 11:47:59AM -0600, Jason Gunthorpe wrote:
> On Tue, Oct 02, 2012 at 11:23:46AM +0100, Dave Martin wrote:
> 
> > > Well, no, it boots ELFs, so it can boot anything, with any memory
> > > layout. A 2nd stage loader would be required to boot standard kernels,
> > > that loader would be an ELF with 1 section for the 2nd stage, 1
> > > section for the zImage and 1 section for the initrd, with proper load
> > > headers.
> > 
> > Don't you already have to treat Linux as a special case though?  How
> > do you know where to load ATAGs, DT and/or initramfs, and how to
> > initalise the registers?  None of that is part of any ELF specification,
> > and would be inappropriate if you boot any non-linux images.
> 
> Experience with our PPC systems has been that linking the DTB into
> vmlinux is the way to go - so we have a trivally small,
> non-upstreamble change (for PPC and ARM) to put the DTB(s) in vmlinux
> and capture the CPU registers values (entry call function arguments)
> that are set from the bootloader. 
> 
> Some DTB fixup code (supported by the OF kernel routines) in vmlinux
> edits the DTB chosen node to include the information from the
> bootloader.
> 
> From there any other DTB fixups (eg fetching a MAC address from I2C)
> plus other register initializations are done in Linux (typically by
> the upstream drivers, though not 100%), with the MMU on, with full
> kernel services. This is a much easier development environment :)
> 
> All in all it is basically about 100 lines of code to do what I've
> described in vmlinux. This is dramatically less code than would be
> required if we tried to conform to the standard vmlinux boot protocol.

[1]

I'm not sure exactly what you mean by linking the DTB into vmlinux.
I don't think this is supported upstream, at least for ARM.  It could
be done externally by post-processing vmlinux to add extra sections
and some boot shim code which initialises the registers appropriately
for kernel entry ... but you're really inventing a bootloader if you
start to do that.

For ARM, I believe that bootloaders that do not pass the dtb properly are
considered considered legacy, or broken (in the case of platforms which
are DT-based).  We don't really attempt to support this.

ARM_APPENDED_DTB is the workaround for that, but that is only available
as part of the zImage loader.  This is meant to ease migration, not as
a permanent solution... but it will probably be available for quite
a while yet.


Making a simple bootloader DT-aware is not actually that hard: libfdt
is intentionally pretty straightforward to integrate.

For an example of how this might look in a simple scenario, you could
take a look at the zImage loader implementation, or

git://git.linaro.org/arm/models/boot-wrapper.git

(Particularly update_fdt() and load_kernel() in semi_loader.c)

It's more than 100 lines, but not _that_ much more, and contains
some implementation features you probably don't need.

There may still be an argument against this if your bootloader is
exteremely space-constrained.

> > As you observe, GNU ld behaviour in this area tends to be rather patchily
> > specified, buggy or both.  That does argue in favour of reusing the
> > same techniques already used for other arches, though.
> 
> It is good to know PHDRS seems to be working better now, maybe things
> can migrate someday!

I guess we shouldn't rush to do that unnecessarily.  Old tools hang
around for a long, long time...

> > A question does occur to me: do your changes work with XIP_KERNEL?
> > I'm not very familiar with XIP_KERNEL myself, so I'm currently not
> > clear on whether there's an impact here.
> 
> I looked at the XIP defines and they didn't seem to conflict. Since
> this change only effects the values in the LOAD headers, not the
> actual image I doubt it has any impact.
> 
> > Beyond this, I think the approach doesn't look unreasonable.
> 
> Great, should I do anything further to get this patch into mainline.

I think that someone more familiar with XIP should at least comment on
it.

Since you admit [1] that you are deliberately not following the boot
protocol proper, you may get some pushback about whether the change
is justified.

>From my side, I think that the fact this takes arch/arm/vmlinux.lds.S
closer to some other common arches means that this is low risk and should
be mostly harmless, but I will take another look at the patch first.

> > You store vmlinux.gz in a cramfs?  Is that a typo, or have you already
> > compressed the kernel twice?
> 
> The compression can either be intrisic to cramfs or a raw elf that has
> been gzip'd.

If you can have files with intrinsic compression such that they don't
get double-compressed, why can you not do this for zImage?

Am I still misunderstanding something?

Cheers
---Dave
