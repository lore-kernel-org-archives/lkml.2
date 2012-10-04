Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab2JDLgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 07:36:54 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37728 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab2JDLgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 07:36:53 -0400
Date: Thu, 4 Oct 2012 12:36:37 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [ARM] Use AT() in the linker script to create correct
 program headers
Message-ID: <20121004113637.GA2117@linaro.org>
References: <20120930232116.GC30637@obsidianresearch.com>
 <20121001153952.GB2100@linaro.org>
 <20121001160639.GA31620@obsidianresearch.com>
 <20121001175647.GD2100@linaro.org>
 <20121001183543.GC22342@obsidianresearch.com>
 <20121002102346.GB2108@linaro.org>
 <20121002174759.GC23733@obsidianresearch.com>
 <20121003104335.GA2254@linaro.org>
 <20121003184437.GB12231@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003184437.GB12231@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 12:44:38PM -0600, Jason Gunthorpe wrote:
> On Wed, Oct 03, 2012 at 11:43:35AM +0100, Dave Martin wrote:
> 
> > I'm not sure exactly what you mean by linking the DTB into vmlinux.
> > I don't think this is supported upstream, at least for ARM.  It could
> > be done externally by post-processing vmlinux to add extra sections
> > and some boot shim code which initialises the registers appropriately
> > for kernel entry ... but you're really inventing a bootloader if you
> > start to do that.
> 
> We use the existing build infrastructure (see cmd_dt_S_dtb) and add a
> 4 line patch to head.S to put the dtb address into the right
> register. I think it would be great to have a CONFIG_ARM_BUILT_IN_DTB
> for applications like mine, but it is really no problem to carry the
> head.S patch. The normal build process produces a vmlinux that is self
> contained, no post processing required.

OK, so it is supported, but not for ARM, yet.  I'm not sure that such
a patch would be rejected, since building in a DTB is not really that
different from building in a command-line.

The post-processing that would otherwise be needed is likely to be
pretty trivial, though (see example below).

> > Making a simple bootloader DT-aware is not actually that hard: libfdt
> > is intentionally pretty straightforward to integrate.
> 
> Sure, but we have several major issues with that entire idea:
>  1) Our bootloader (on PPC and ARM) is in redundant NOR flash and
>     is limited to 16K. That is just enough to do gzip, elf, cramfs
>     and tftpv6 - there is no space left for dtb or fdt code.
>  2) Experience using DT with PPC has shown that the vmlinux is very
>     sensitive to the DTB. Every DTB/vmlinux combination must be tested
>     to ensure it works. By far the best way to manage this *for us* is
>     to guarentee that the vmlinux sees only the DTB it was designed
>     for by including it in vmlinux.
>  3) The DTB *changes*. We change it because we've changed things in the
>     programmable part of our environment and we change it because the
>     kernel has shifted. Planning for this inevitable change is
>     necessary.
>  4) On our ARM platforms updating the boot loader in the field is more
>     challenging than updating the vmlinux, not impossible, but not
>     something we want to do every day. Our PPC boot loader has
>     survived without change since 2007, and has booted kernels from
>     2.6.12 to 3.6 with and without DT. This is a time tested,
>     field proven approach.
> 
> Fundamentally we treat the DTB like the .config - an integral,
> internal, part of vmlinux.
> 
> As far as I can see, the *only* argument to put the DT in the boot
> loader is to support standard, distribution kernels.

DT-aware does not have to mean that the DTB is part of the bootloader.
Generally, that's considered to be a bad idea for the reasons you
describe (among others).

The other solution to this problem is to distribute the dtb alongside the
kernel as a supplementary image (similar to initramfs), with the
bootloader doing the bare minimum of modifications to it.

Naturally, if zero modifications are needed then the bootloader does not
need libfdt (or equivalent code) at all.

> > It's more than 100 lines, but not _that_ much more, and contains
> > some implementation features you probably don't need.
> 
> But that is not enough, variations of our platforms use bit bang I2C,
> SPI and NOR FLASH to store things like the MAC address and other
> DT-relevant information. So, swaths of that code would need to go into
> the boot loader/zImage as well.
> 
> At that point we may as well take our chances with uBoot. :)
> 
> > From my side, I think that the fact this takes arch/arm/vmlinux.lds.S
> > closer to some other common arches means that this is low risk and should
> > be mostly harmless, but I will take another look at the patch first.
> 
> This matches my opinion..
> 
> > > > You store vmlinux.gz in a cramfs?  Is that a typo, or have you already
> > > > compressed the kernel twice?
> > > 
> > > The compression can either be intrisic to cramfs or a raw elf that has
> > > been gzip'd.
> > 
> > If you can have files with intrinsic compression such that they don't
> > get double-compressed, why can you not do this for zImage?
> > 
> > Am I still misunderstanding something?
> 
> We have two boot modes, one boots ELF.gz (for development), the other
> boots ELF in CRAMFS (for deployment). Both are compressed, one is
> compressed using gzip and one is compressed using zlib in CRAMFS. It
> is hard to see how to store a zImage in CRAMFS and avoid double
> de-compression. We never store an ELF.gz in CRAMFS.

OK, now I understand.
 
> Since the entire point of zImage is to introduce compression it is
> hard to see *why* we'd want to store a zImage in a CRAMFS.

Because zImage has grown one or two extra features (which in fact have
nothing to do with compression).  But I can see why you're not keen
on the idea.  In principle we could have an uncompressed zImage, but
for now this doesn't exist.


One other option open to you would be to provide an ELF image loadable
by your bootloader via a simple wrapper.  This would probably be a more
robust approach than carrying patches against head.S, since it removes
any intimate dependency on the kernel code itself.

---8<--- boot.lds.S ---

OUTPUT_FORMAT(elf32-littlearm)

TARGET(binary)
INPUT(Image)
INPUT(dtb)

TARGET(elf32-littlearm)

ENTRY(__entry)

SECTIONS {
	.text PHYS_OFFSET : {
		boot.o(.text)
	}

	kernel PHYS_OFFSET + TEXT_OFFSET : {
		__kernel_entry = .;
		Image(*)

	payload PHYS_OFFSET + PAYLOAD_OFFSET : {
		__dtb_start = .;
		dtb(*)
	}

	/DISCARD/ : {
		*(*)
	}
}

--- boot.S ---

.globl __entry
.type __entry, %function
__entry:
	mov	r0, #0
	mov	r1, #0xFFFFFFFF
	ldr	r2, =__dtb_start
	b	__kernel_entry

--->8---

Where PHYS_OFFSET and TEXT_OFFSET are the appropriate definitions
for your platform, and PAYLOAD_OFFSET is an appropriate safe
location for the dtb.

The resulting image can be a bit smaller than vmlinux, too (but only
slightly).


---Dave
