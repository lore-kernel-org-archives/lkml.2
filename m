Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965311Ab2EPTuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:50:22 -0400
Received: from relais.videotron.ca ([24.201.245.36]:38959 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964842Ab2EPTuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:50:20 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_NoyhXjjzgfIRceN7PxW+mw)"
Sun-Java-System-SMTP-Warning: Lines longer than SMTP allows found and truncated.
Date: Wed, 16 May 2012 15:50:16 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] mtd: nandsim: don't open code a do_div helper
In-reply-to: <20120516192145.GB2913@herton-Z68MA-D2H-B3>
Message-id: <alpine.LFD.2.02.1205161542020.1640@xanadu.home>
References: <20120516192145.GB2913@herton-Z68MA-D2H-B3>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_NoyhXjjzgfIRceN7PxW+mw)
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT

On Wed, 16 May 2012, Herton Ronaldo Krzesinski wrote:

> We don't need to open code the divide function, just use div_u64 that
> already exists and do the same job. While this is a straightforward
> clean up, there is more to that, the real motivation for this.
> 
> While building on a cross compiling environment in armel, using gcc
> 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5), I was getting the following build
> error:
> 
> ERROR: "__aeabi_uldivmod" [drivers/mtd/nand/nandsim.ko] undefined!
> 
> After investigating with objdump and hand built assembly version
> generated with the compiler, I narrowed __aeabi_uldivmod as being
> generated from the divide function. When nandsim.c is built with
> -fno-inline-functions-called-once, that happens when
> CONFIG_DEBUG_SECTION_MISMATCH is enabled, the do_div optimization in
> arch/arm/include/asm/div64.h doesn't work as expected with the open
> coded divide function: even if the do_div we are using doesn't have a
> constant divisor, the compiler still includes the else parts of the
> optimized do_div macro, and translates the divisions there to use
> __aeabi_uldivmod, instead of only calling __do_div_asm -> __do_div64 and
> optimizing/removing everything else out.
> 
> So to reproduce, gcc 4.6 plus CONFIG_DEBUG_SECTION_MISMATCH=y and
> CONFIG_MTD_NAND_NANDSIM=m should do it, building on armel.

This is a known gcc bug:
http://old.nabble.com/-Bug-c-48783--New%3A-ARM%3A-kernel-compiled-at--O2-has-a-unused-reference-to-__aeabi_uldivmod-td31483124.html

> After this change, the compiler does the intended thing even with
> -fno-inline-functions-called-once, and optimizes out as expected the
> constant handling in the optimized do_div on arm. As this also avoids a
> build issue, I'm marking for Stable, as I think is applicable for this
> case.
> 
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> Cc: stable@vger.kernel.org

The severity for stable can be debated, OTOH this can't hurt either.

The cleanup is certainly worth it.

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  drivers/mtd/nand/nandsim.c |   12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> For more insight on the build issue, I'm attaching with this also:
> 
> * the pre-processed source with gcc -E
> 
> * the generated asm with gcc -S (nandsim.s-fno-inline-functions-called-once.txt.gz):
> gcc -Wp,-MD,drivers/mtd/nand/.nandsim.o.d  -nostdinc -isystem /usr/lib/gcc/arm-linux-gnueabi/4.6/include -I/home/herton/build/linux-stable/arch/arm/include -Iarch/arm/include/generated -Iinclude  -I/home/herton/build/linux-stable/include -include /home/herton/build/linux-stable/include/linux/kconfig.h  -I/home/herton/build/linux-stable/drivers/mtd/nand -Idrivers/mtd/nand -D__KERNEL__ -mlittle-endian   -I/home/herton/build/linux-stable/arch/arm/mach-omap2/include   -I/home/herton/build/linux-stable/arch/arm/plat-omap/include -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -O2 -marm -fno-dwarf2-cfi-asm -fstack-protector -mabi=aapcs-linux -mno-thumb-interwork -funwind-tables -D__LINUX_ARM_ARCH__=7 -march=armv7-a -msoft-float -Uarm -Wframe-larger-than=1024 -Wno-unused-but-set-variable -fomit-frame-pointer -g -fno-inline-functions-called-once -Wdeclaration-after-s
> 
> * generated asm, same as above but removing -fno-inline-functions-called-once
>   (nandsim.s-without-fno-inline-functions-called-once.txt.gz)
> 
> gcc -v output:
> Using built-in specs.
> COLLECT_GCC=/usr/bin/gcc
> COLLECT_LTO_WRAPPER=/usr/lib/gcc/arm-linux-gnueabi/4.6/lto-wrapper
> Target: arm-linux-gnueabi
> Configured with: ../src/configure -v --with-pkgversion='Ubuntu/Linaro 4.6.3-1ubuntu5' --with-bugurl=file:///usr/share/doc/gcc-4.6/README.Bugs --enable-languages=c,c++,fortran,objc,obj-c++ --prefix=/usr --program-suffix=-4.6 --enable-shared --enable-linker-build-id --with-system-zlib --libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --with-gxx-include-dir=/usr/include/c++/4.6 --libdir=/usr/lib --enable-nls --with-sysroot=/ --enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes --enable-gnu-unique-object --enable-plugin --enable-objc-gc --enable-multilib --disable-sjlj-exceptions --with-arch=armv7-a --with-float=softfp --with-fpu=vfpv3-d16 --with-mode=thumb --disable-werror --enable-checking=release --build=arm-linux-gnueabi --host=arm-linux-gnueabi --target=arm-linux-gnueabi
> Thread model: posix
> gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5)
> 
> Note that with the nandsim.s with -fno-inline-functions-called-once, a
> divide.part.5 function is generated with code matching to the case on
> do_div where the divisor is a constant, but divide.part.5 isn't used
> anywhere as expected, gcc doesn't remove/optimize it out so later
> linking fails.
> 
> Personally I think the optimized do_div on arch/arm/include/asm/div64.h
> for gcc > 4 is too fragile, relying on gcc behaviour... other way I
> could avoid the build issue, keeping the divide function as is (without
> this patch), would be to add another bogus do_div with a constant
> divisor to the divide function).
> 
> diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
> index 261f478..c606b6a 100644
> --- a/drivers/mtd/nand/nandsim.c
> +++ b/drivers/mtd/nand/nandsim.c
> @@ -28,7 +28,7 @@
>  #include <linux/module.h>
>  #include <linux/moduleparam.h>
>  #include <linux/vmalloc.h>
> -#include <asm/div64.h>
> +#include <linux/math64.h>
>  #include <linux/slab.h>
>  #include <linux/errno.h>
>  #include <linux/string.h>
> @@ -547,12 +547,6 @@ static char *get_partition_name(int i)
>  	return kstrdup(buf, GFP_KERNEL);
>  }
>  
> -static uint64_t divide(uint64_t n, uint32_t d)
> -{
> -	do_div(n, d);
> -	return n;
> -}
> -
>  /*
>   * Initialize the nandsim structure.
>   *
> @@ -581,7 +575,7 @@ static int init_nandsim(struct mtd_info *mtd)
>  	ns->geom.oobsz    = mtd->oobsize;
>  	ns->geom.secsz    = mtd->erasesize;
>  	ns->geom.pgszoob  = ns->geom.pgsz + ns->geom.oobsz;
> -	ns->geom.pgnum    = divide(ns->geom.totsz, ns->geom.pgsz);
> +	ns->geom.pgnum    = div_u64(ns->geom.totsz, ns->geom.pgsz);
>  	ns->geom.totszoob = ns->geom.totsz + (uint64_t)ns->geom.pgnum * ns->geom.oobsz;
>  	ns->geom.secshift = ffs(ns->geom.secsz) - 1;
>  	ns->geom.pgshift  = chip->page_shift;
> @@ -924,7 +918,7 @@ static int setup_wear_reporting(struct mtd_info *mtd)
>  
>  	if (!rptwear)
>  		return 0;
> -	wear_eb_count = divide(mtd->size, mtd->erasesize);
> +	wear_eb_count = div_u64(mtd->size, mtd->erasesize);
>  	mem = wear_eb_count * sizeof(unsigned long);
>  	if (mem / sizeof(unsigned long) != wear_eb_count) {
>  		NS_ERR("Too many erase blocks for wear reporting\n");
> -- 
> 1.7.9.5
> 
> 

--Boundary_(ID_NoyhXjjzgfIRceN7PxW+mw)--
