Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab2JAQGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 12:06:46 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:56030 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab2JAQGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 12:06:44 -0400
Date: Mon, 1 Oct 2012 10:06:39 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Dave Martin <dave.martin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [ARM] Use AT() in the linker script to create correct
 program headers
Message-ID: <20121001160639.GA31620@obsidianresearch.com>
References: <20120930232116.GC30637@obsidianresearch.com>
 <20121001153952.GB2100@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001153952.GB2100@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 04:39:53PM +0100, Dave Martin wrote:

> >   Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
> >   LOAD           0x008000 0xc0008000 0x00008000 0x372244 0x3a4310 RWE 0x8000
> 
> Not related directly to your patch, but I wonder why we don't we see
> separate r-x and rw- segments?

I think this is because the sections are not aligned when the
protections change, and the sections are not sorted by protection
type.

  [ 1] .head.text        PROGBITS        c0008000 008000 0001c0 00  AX  0   0 32
  [ 2] .text             PROGBITS        c00081c0 0081c0 1dc880 00  AX  0   0 32
  [ 3] .rodata           PROGBITS        c01e5000 1e5000 060a80 00   A  0   0 32
  [ 4] __bug_table       PROGBITS        c0245a80 245a80 002a78 00   A  0   0  1
  [ 5] .pci_fixup        PROGBITS        c02484f8 2484f8 000090 00   A  0   0  4
  [ 6] __param           PROGBITS        c0248588 248588 000280 00   A  0   0  4
  [ 7] __modver          PROGBITS        c0248808 248808 0007f8 00   A  0   0  4
  [ 8] .init.text        PROGBITS        c0249000 249000 01af20 00  AX  0   0 32
  [ 9] .exit.text        PROGBITS        c0263f20 263f20 000c0c 00  AX  0   0  4
  [10] .init.proc.info   PROGBITS        c0264b2c 264b2c 00009c 00  AX  0   0  1
  [11] .init.arch.info   PROGBITS        c0264bc8 264bc8 000044 00   A  0   0  4
  [12] .init.tagtable    PROGBITS        c0264c0c 264c0c 000040 00   A  0   0  4
  [13] .init.data        PROGBITS        c0264c60 264c60 0f481c 00  WA  0   0 32
  [14] .data             PROGBITS        c035a000 35a000 020220 00  WA  0   0 32
  [15] .notes            NOTE            c037a220 37a220 000024 00  AX  0   0  4
  [16] .bss              NOBITS          c037a260 37a244 0320b0 00  WA  0   0 32
  [17] .comment          PROGBITS        00000000 37a244 000021 01  MS  0   0  1

 
> > +/* If we have a known, fixed physical load address then set LOAD_OFFSET
> > +   and generate an ELF that has the physical load address in the program
> > +   headers. */
> > +#ifndef CONFIG_ARM_PATCH_PHYS_VIRT
> > +#define LOAD_OFFSET (PAGE_OFFSET - PHYS_OFFSET)
> > +#endif
> > +
> 
> What happens if CONFIG_ARM_PATCH_PHYS_VIRT=y?  This will be used
> increasingly, especially for multiplatform kernels.

Then LOAD_OFFSET is unset and include/asm-generic/vmlinux.lds.h does:

#ifndef LOAD_OFFSET
#define LOAD_OFFSET 0
#endif

Which is exactly the same case we have today. LOAD_OFFSET is not a
name I invented, it is the standard kernel name for the functionality.
 
> If the kernel is intended to be loadable at a physical address which is
> not statically known, no ELF loader that does not ignore the ELF
> phdr

In this case you can't really use a standard ELF loader to load the
kernel so, LOAD_OFFSET = 0 is fine. My case is using an ELF loader,
and I have set options for a static physical load address.

> >  OUTPUT_ARCH(arm)
> > -ENTRY(stext)
> > +ENTRY(phys_start)
> 
> This is debatable.  In fact, stext has the property that its virtual
> (runtime) and load addresses are the same.

This is what other arches using LOAD_OFFSET do (eg see ia64), and is
sensible. ENTRY is *only* used by the ELF loader and specifies where
the loader should jump. It must be a physical address since the loader
only works with physical addresse. I don't understand your comment
that .stext has the same load and virtual address, that is clearly not
true for the ELF images my build is producing:

c0008000 T _text
c0008000 T stext

The physical address of that symbol is 0x8000.

> To represent this correctly in the linker scripts, the
> position-independent head.S code should be split out into a separate
> section to which LOAD_OFFSET is not applied.

I'm not sure, the linker script should use addresses that are correct
during runtime, and if the PIC code does not care about its PC then it
is fine to keep it at the virtual address to minimize confusion once
the MMU is on.

> Setting vaddr and paddr to PAGE_OFFSET (as we do now) and having the
> loader choose the appropriate board-specific place to load the kernel
> image makes this irrelevant, if I've understood the situation correctly.

Yes, if you use more loader stages then the load headers are ignored.
Our boot loaders on our boards boot straight ELF vmlinux.gz so they
need correct load headers.

Jason
