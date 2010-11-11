Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab0KKRiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:38:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64646 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab0KKRiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:38:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan" <guanxuetao@mprc.pku.edu.cn>
Subject: Re: [PATCH] a new UniCore32 arch-dependent patch for linux-2.6.37-rc1
Date: Thu, 11 Nov 2010 18:38:34 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: "'Greg KH'" <greg@kroah.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <002001cb816d$9632a170$c297e450$@mprc.pku.edu.cn>
In-Reply-To: <002001cb816d$9632a170$c297e450$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011111838.34867.arnd@arndb.de>
X-Provags-ID: V02:K0:z/0o5GVxkwIJk6TTQ8+Caw5RL1cG33W/tCF8UVorRBu
 vidbiXXRjti1bj7jV751StO4CVnOZ8zLUrxfObUsVNwvm+3cc6
 19hM7geDUjcv+68vCRL8uiFxzeLYpIFUdpprdt1p5B/C9toLKc
 Bxf9/JiCZrBx9IjuJfMw2dBd3LUeONKMrhZq30uimMuASjaSQJ
 QY15akqarXczaxS/r25+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 November 2010, Guan wrote:
> A new unicore patch for 2.6.37-rc1 has been uploaded into my homepage:
>  
> http://mprc.pku.edu.cn/~guanxuetao/linux/patch-2.6.37-rc1-uc32-gxt1.bz2
> 
> Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> 
> What about the next step?

I've started a review of your code with lots of comments for roughly
the first third of the patch. I'm taking this to the relevant mailing lists
linux-kernel and linux-arch now, who have more people that might want
to participate in the discussion.

Please go through my comments and questions one by one and reply in-line
to any questions in order to clarify what the code does. For any suggestions
that you agree with and that are simple enough, just change the code
for the next review. If you think I misunderstood your code or you disagree
with me for another reason, explain the intention of the code or suggest
an alternative solution.

It would be good if you could make a tool chain available, ideally both
a patch against gcc and pre-built binaries for an x86-unicore cross
compiler. This is not strictly required, but it helps to get people
to do build tests on your code.

Further, you should find a way to publish git trees with your code, since
a patch on a web site is less than ideal for transporting code changes,
especially once the code gets merged into linux-next and mainline afterwards.
If your university or company has problems setting up an official git
server, you can ask for an account on kernel.org, see
http://www.kernel.org/faq/#account

Once all the main concerns have been addressed in your architecture tree,
you can ask Stephen Rothwell to include the tree in linux-next, which is the
place for integration testing. If you have toolchain binaries available,
you will be able to integrate with automated build testing at that point.

Now for the review: There are many things right with your code, so there
is generally no need to comment on them. The main source of problems
is the fact that it copies from existing architecture trees, which
creates both duplication of code and unnecessary abstractions like the
multi-cpu support from the ARM tree.

In some cases, you had no choice but to copy files because we are missing
a generic way of doing something simple. For those cases, the best solution
is to generalize the code so we have one version that can be used by all
architectures that do not require anything special.

Detailed comments below.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/boot/compressed/decompress.c linux-2.6.37.y/arch/unicore32/boot/compressed/decompress.c
> --- linux-2.6.37-rc1/arch/unicore32/boot/compressed/decompress.c	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/boot/compressed/decompress.c	2010-11-09 18:19:31.255625529 +0800
> @@ -0,0 +1,62 @@
> +/*
> + * linux/arch/unicore32/boot/compressed/decompress.c
> + *
> ...
> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/boot/compressed/misc.c linux-2.6.37.y/arch/unicore32/boot/compressed/misc.c
> --- linux-2.6.37-rc1/arch/unicore32/boot/compressed/misc.c	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/boot/compressed/misc.c	2010-11-09 18:16:27.708135274 +0800
> @@ -0,0 +1,134 @@
> +/*
> + * linux/arch/unicore32/boot/compressed/misc.c

These two files look very generic. It may be a good time to now move
them into the global lib/ directory and make them usable by all
architectures that do not require special fixups in the decompress
code.

> +
> +extern void do_decompress(u8 *input, int len, u8 *output, void (*error)(char *x));
> +

In general, you should put extern declarations into header files, not in
the middle of source code, in order to ensure that the declaration
matches the definitions.

> +unsigned long
> +decompress_kernel(unsigned long output_start, unsigned long free_mem_ptr_p,
> +		unsigned long free_mem_ptr_end_p,
> +		int arch_id)

I would recommend not passing an arch_id here. Instead, you can ideally
pass a pointer to a flattened device tree similar to how powerpc and
microblaze use it.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/boot/compressed/vmlinux.lds.in linux-2.6.37.y/arch/unicore32/boot/compressed/vmlinux.lds.in
> --- linux-2.6.37-rc1/arch/unicore32/boot/compressed/vmlinux.lds.in	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/boot/compressed/vmlinux.lds.in	2010-11-09 18:23:55.530780747 +0800
> +  . = TEXT_START;
> +  _text = .;
> +
> +  .text : {
> +    _start = .;
> +    *(.start)
> +    *(.text)
> +    *(.text.*)
> +    *(.fixup)
> +    *(.gnu.warning)
> +    *(.rodata)
> +    *(.rodata.*)
> +    *(.glue_7)
> +    *(.glue_7t)
> +    *(.piggydata)
> +    . = ALIGN(4);
> +  }

Some of these sections appear to be arm specific, like the glue_7 stuff.
It would be good to check which sections are actually required.

> +  .stab 0		: { *(.stab) }
> +  .stabstr 0		: { *(.stabstr) }
> +  .stab.excl 0		: { *(.stab.excl) }
> +  .stab.exclstr 0	: { *(.stab.exclstr) }
> +  .stab.index 0		: { *(.stab.index) }
> +  .stab.indexstr 0	: { *(.stab.indexstr) }
> +  .comment 0		: { *(.comment) }

Do you actually use stab in your tool chain? This is not a tool chain
review, but you might want to consider using DWARF-2 instead of stabs.

> +MKIMAGE         := $(srctree)/scripts/mkuboot.sh

Do you have u-boot support as well?

> +# Note: the following conditions must always be true:
> +#   ZRELADDR == virt_to_phys(PAGE_OFFSET + TEXT_OFFSET)
> +#   PARAMS_PHYS must be within 4MB of ZRELADDR
> +#   INITRD_PHYS must be in RAM
> +ZRELADDR    := $(zreladdr-y)
> +PARAMS_PHYS := $(params_phys-y)
> +INITRD_PHYS := $(initrd_phys-y)
> +
> +export ZRELADDR INITRD_PHYS PARAMS_PHYS

It would be better not to make these compile-time configurable,
because that means you can not boot the same kernel on machines
that have different requirements.

I would recommend either using a fixed position that you know
is valid on all machines, or making it completely dynamic
with a relocatable kernel.

> +CONFIG_CMDLINE_FROM_U_BOOT=y
> +CONFIG_CMDLINE="mem=512M ignore_loglevel video=unifb:1024x600-16@75 root=/dev/nfs rw nfsroot=/home/nfs/uc3,rsize=1024,wsize=1024 ip=192.168.10.83:192.168.10.82:192.168.10.1:255.255.255.0::eth0:off"

You should never need to pass the memory size in the command line.
Please ensure that the boot loader always passes the memory size
using your boot protocol (ideally in a device tree).

Similarly, the frame buffer size should ideally be autodetected
using hardware or the boot protocol, though that can be harder.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/configs/nb0916_defconfig linux-2.6.37.y/arch/unicore32/configs/nb0916_defconfig
> --- linux-2.6.37-rc1/arch/unicore32/configs/nb0916_defconfig	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/configs/nb0916_defconfig	2010-11-08 10:14:07.110692045 +0800

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/configs/smw0919_defconfig linux-2.6.37.y/arch/unicore32/configs/smw0919_defconfig
> --- linux-2.6.37-rc1/arch/unicore32/configs/smw0919_defconfig	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/configs/smw0919_defconfig	2010-11-08 10:14:07.110692045 +0800

The files look mostly identical. If there is no fundamental difference
between them, I would recommend providing only a single defconfig file
that works on all the machines.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/a.out-core.h linux-2.6.37.y/arch/unicore32/include/asm/a.out-core.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/a.out-core.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/a.out-core.h	2010-11-08 10:14:07.111692102 +0800
> @@ -0,0 +1,52 @@
> +/*
> + * linux/arch/unicore32/include/asm/a.out-core.h

I would be surprised if you actually require a.out support, you can
probably just drop this file.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/a.out.h linux-2.6.37.y/arch/unicore32/include/asm/a.out.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/a.out.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/a.out.h	2010-11-08 10:14:07.111692102 +0800

And this.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/atomic.h linux-2.6.37.y/arch/unicore32/include/asm/atomic.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/atomic.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/atomic.h	2010-11-08 10:14:07.112692160 +0800
> @@ -0,0 +1,117 @@
> +/*
> + * linux/arch/unicore32/include/asm/atomic.h

This seems to be almost identical to the asm-generic/atomic.h file, so
you should use that instead of providing your own.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/bitops.h linux-2.6.37.y/arch/unicore32/include/asm/bitops.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/bitops.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/bitops.h	2010-11-08 10:14:07.112692160 +0800
> @@ -0,0 +1,270 @@
> +/*
> + * linux/arch/unicore32/include/asm/bitops.h

Same for this one.

> +/*
> + * Ext2 is defined to use little-endian byte ordering.
> + * These do not need to be atomic.
> + */
> +#define ext2_set_bit(nr, p)			\
> +	__test_and_set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
> +#define ext2_set_bit_atomic(lock, nr, p)        \
> +	test_and_set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
> +#define ext2_clear_bit(nr, p)			\
> +	__test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
> +#define ext2_clear_bit_atomic(lock, nr, p)      \
> +	test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
> +#define ext2_test_bit(nr, p)			\
> +	test_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
> +#define ext2_find_first_zero_bit(p, sz)		\
> +	_find_first_zero_bit_le(p, sz)
> +#define ext2_find_next_zero_bit(p, sz, off)	\
> +	_find_next_zero_bit_le(p, sz, off)
> +#define ext2_find_next_bit(p, sz, off) \
> +	_find_next_bit_le(p, sz, off)

These are currently getting moved around. Using the generic version
would save you the trouble of porting the change.

> +#ifdef CONFIG_BUG
> +#ifdef CONFIG_DEBUG_BUGVERBOSE
> +extern void __bug(const char *file, int line) __attribute__((noreturn));
> +
> +/* give file/line information */
> +#define BUG()		__bug(__FILE__, __LINE__)
> +
> +#else
> +
> +/* this just causes an oops */
> +#define BUG()		do { *(int *)0 = 0; } while (1)

Actually, accessing NULL pointers may not cause an oops if the use is
able to map a file to address zero. I would recommend not setting
HAVE_ARCH_BUG here and just using the asm-generic version.

It would be even better if you had a conditional trap instruction
that you could use to implement BUG_ON as a single assembly statement.

> +/*
> + *	Cache Model
> + *	===========
> + */
> +#undef _CACHE
> +
> +#if defined(CONFIG_CPU_UCV1)
> +#  define _CACHE ucv1
> +#endif
> +
> +#if defined(CONFIG_CPU_UCV2)
> +#  define _CACHE ucv2
> +#endif
> +
> +#if !defined(_CACHE)
> +#error Unknown cache maintainence model
> +#endif

You don't seem to support the ucv1 cache model any more, so I would
recommend also removing the logic to multiplex between multiple variants
of the cache.

The method of multiplexing between CPU versions both at compile time
and at run time was obviously inspired by how ARM manages to support
a multitude of CPUs with varying requirements, but you do not seem
to have that.

> +struct cpu_cache_fns {
> +	void (*flush_icache_all)(void);
> +	void (*flush_kern_all)(void);
> +	void (*flush_user_all)(void);
> +	void (*flush_user_range)(unsigned long, unsigned long, unsigned int);
> +
> +	void (*coherent_kern_range)(unsigned long, unsigned long);
> +	void (*coherent_user_range)(unsigned long, unsigned long);
> +	void (*flush_kern_dcache_area)(void *, size_t);
> +
> +	void (*dma_map_area)(const void *, size_t, int);
> +	void (*dma_unmap_area)(const void *, size_t, int);
> +
> +	void (*dma_flush_range)(const void *, const void *);
> +};

This was apparently used at some point but is no more, so you can remove
it, too.

> +#define L1_CACHE_SHIFT		CONFIG_CPU_L1_CACHE_SHIFT
> +#define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)

There is only one possible value for this option, so you can remove
the option and just define L1_CACHE_SHIFT to 5 here.

> +struct cpuinfo_unicore {
> +	struct cpu	cpu;
> +};
> +
> +DECLARE_PER_CPU(struct cpuinfo_unicore, cpu_data);
> +

It looks like you only ever use this in topology_init(), so you
might as well make it a static declaration. Also, as long as you
have no SMP support, you can simply collapse the registration
to a single struct cpu.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/cpu-single.h linux-2.6.37.y/arch/unicore32/include/asm/cpu-single.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/cpu-single.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/cpu-single.h	2010-11-08 11:22:19.104268871 +0800
> +
> +/*
> + * If we are supporting multiple CPUs, then we must use a table of
> + * function pointers for this lot.  Otherwise, we can optimise the
> + * table away.
> + */
> +#define cpu_proc_init			__cpu_fn(CPU_NAME, _proc_init)
> +#define cpu_proc_fin			__cpu_fn(CPU_NAME, _proc_fin)
> +#define cpu_reset			__cpu_fn(CPU_NAME, _reset)
> +#define cpu_do_idle			__cpu_fn(CPU_NAME, _do_idle)
> +#define cpu_dcache_clean_area		__cpu_fn(CPU_NAME, _dcache_clean_area)
> +#define cpu_do_switch_mm		__cpu_fn(CPU_NAME, _switch_mm)
> +#define cpu_set_pte			__cpu_fn(CPU_NAME, _set_pte)

Like with the cache, you don't support multiple CPU types in a single
kernel, so I would recommend removing all this multiplexing.

> +/*
> + * The CPU ID never changes at run time, so we might as well tell the
> + * compiler that it's constant.  Use this function to read the CPU ID
> + * rather than directly reading processor_id or read_cpuid() directly.
> + */
> +static inline unsigned int __attribute_const__ read_cpuid_id(void)
> +{
> +	return read_cpuid(CPUID_ID);
> +}

As far as I know, gcc ignores __attribute_const__ with inline functions,
so the comment is wrong.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/dma.h linux-2.6.37.y/arch/unicore32/include/asm/dma.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/dma.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/dma.h	2010-11-11 09:55:29.517572760 +0800
> @@ -0,0 +1,34 @@
> +/*
> + * linux/arch/unicore32/include/asm/dma.h

Just use the asm-generic file.

> +/*
> + * page_to_dma/dma_to_virt/virt_to_dma are architecture private functions
> + * used internally by the DMA-mapping API to provide DMA addresses. They
> + * must not be used by drivers.
> + */
> +static inline dma_addr_t page_to_dma(struct device *dev, struct page *page)
> +{
> +	return (dma_addr_t)(is_pcibus_device(dev)
> +		? __virt_to_pcibus((unsigned long)page_address(page))
> +		: __virt_to_bus((unsigned long)page_address(page)));
> +}
> +
> +static inline struct page *dma_to_page(struct device *dev, dma_addr_t addr)
> +{
> +	return virt_to_page(is_pcibus_device(dev)
> +		? __pcibus_to_virt(addr)
> +		: __bus_to_virt(addr));
> +}
> +
> +static inline void *dma_to_virt(struct device *dev, dma_addr_t addr)
> +{
> +	return (void *)(is_pcibus_device(dev)
> +		? __pcibus_to_virt(addr)
> +		: __bus_to_virt(addr));
> +}
> +
> +static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
> +{
> +	return (dma_addr_t)(is_pcibus_device(dev)
> +		? __virt_to_pcibus((unsigned long)(addr))
> +		: __virt_to_bus((unsigned long)(addr)));
> +}

These remind me of the problems of the pre-dma-mapping
virt_to_bus/bus_to_virt interface. Maybe you can just open-code
these inlines in their callers to avoid exposing the interface
to potential users.

> +static inline void __dma_single_cpu_to_dev(const void *kaddr, size_t size,
> +	enum dma_data_direction dir)
> +{
> +	extern void ___dma_single_cpu_to_dev(const void *, size_t,
> +		enum dma_data_direction);
> +
> +	if (!arch_is_coherent())
> +		___dma_single_cpu_to_dev(kaddr, size, dir);
> +}
> +
> +static inline void __dma_single_dev_to_cpu(const void *kaddr, size_t size,
> +	enum dma_data_direction dir)
> +{
> +	extern void ___dma_single_dev_to_cpu(const void *, size_t,
> +		enum dma_data_direction);
> +
> +	if (!arch_is_coherent())
> +		___dma_single_dev_to_cpu(kaddr, size, dir);
> +}

You seem to have multiple levels of indirection here:

  1. dma_map_single()
  2. __dma_single_cpu_to_dev
  3. ___dma_single_cpu_to_dev
  4. dmac_map_area
  5. cpu->dma_map_area
  6. ucv2_dma_map_area
  7. ucv2_dma_{flush,inv,clean}_range

I would recommend removing most or all of them and just calling
the ucv2_dma_{flush,inv,clean}_range functions directly from
dma_map_single/dma_sync_single_range_for_device.

The same can be done for most of the other dma mapping functions here.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/fixmap.h linux-2.6.37.y/arch/unicore32/include/asm/fixmap.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/fixmap.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/fixmap.h	2010-11-08 15:36:42.574862020 +0800
> @@ -0,0 +1,51 @@
> +/*
> + * Nothing too fancy for now.
> + *
> + * On UniCore we already have well known fixed virtual addresses imposed by
> + * the architecture such as the vector page which is located at 0xffff0000,

The comment is copied from ARM, but is it really true on unicore?

> + * therefore a second level page table is already allocated covering
> + * 0xfff00000 upwards.
> + */
> +
> +#define FIXADDR_START		0xff800000UL
> +#define FIXADDR_TOP		0xffc00000UL
> +#define FIXADDR_SIZE		(FIXADDR_TOP - FIXADDR_START)
> +
> +#define FIX_KMAP_BEGIN		0
> +#define FIX_KMAP_END		(FIXADDR_SIZE >> PAGE_SHIFT)
> +
> +#define __fix_to_virt(x)	(FIXADDR_START + ((x) << PAGE_SHIFT))
> +#define __virt_to_fix(x)	(((x) - FIXADDR_START) >> PAGE_SHIFT)
> +
> +extern void __this_fixmap_does_not_exist(void);
> +
> +static inline unsigned long fix_to_virt(const unsigned int idx)
> +{
> +	if (idx >= FIX_KMAP_END)
> +		__this_fixmap_does_not_exist();
> +	return __fix_to_virt(idx);
> +}
> +
> +static inline unsigned int virt_to_fix(const unsigned long vaddr)
> +{
> +	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
> +	return __virt_to_fix(vaddr);
> +}
> +

It would be nice if you could move the parts of this file that are
not unicore specific into asm-generic/fixmap.h so we can share them
across architectures.

> +struct fp_hard_struct {
> +	unsigned int save[FP_HARD_SIZE];	/* as yet undefined */
> +};
> +
> +#define FP_SOFT_SIZE 33
> +
> +struct fp_soft_struct {
> +	unsigned int save[FP_SOFT_SIZE];	/* undefined information */
> +};
> +
> +union fp_state {
> +	struct fp_hard_struct	hard;
> +	struct fp_soft_struct	soft;
> +};
> +
> +#define FP_SIZE (sizeof(union fp_state) / sizeof(int))

You use the fp_state with an alignment of eight bytes, but the contents
are just four byte aligned, which does not seem to make much sense.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/ftrace.h linux-2.6.37.y/arch/unicore32/include/asm/ftrace.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/ftrace.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/ftrace.h	2010-11-09 13:47:34.212235029 +0800
> @@ -0,0 +1,74 @@
> +/*
> + * linux/arch/unicore32/include/asm/ftrace.h
> + *

It appears that you do not have ftrace support, so you should remove
this header file and everything under CONFIG_FUNCTION_TRACER in other
files.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/glue.h linux-2.6.37.y/arch/unicore32/include/asm/glue.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/glue.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/glue.h	2010-11-08 17:28:19.513813313 +0800
> @@ -0,0 +1,64 @@
> +/*
> + * linux/arch/unicore32/include/asm/glue.h

I think if you remove the abstractions for multiple CPU types, you can
also remove this file.

> +#ifndef __UNICORE_GPIO_H__
> +#define __UNICORE_GPIO_H__
> +
> +#include <mach/gpio.h>
> +
> +#endif /* __UNICORE_GPIO_H__ */

I don't think it's good to have a separate mach/ directory next to asm/.
If you get multiple machines, it's better to distinguish them at
run-time.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/highmem.h linux-2.6.37.y/arch/unicore32/include/asm/highmem.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/highmem.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/highmem.h	2010-11-08 15:53:09.077836027 +0800
> @@ -0,0 +1,53 @@
> +/*
> + * linux/arch/unicore32/include/asm/highmem.h

What is the maximum amount of memory you support on the 32 bit machines?
We're removing all the optimizations for highmem from the kernel now, so
I would recommend not to support this in new architectures if you can
avoid it.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/io.h linux-2.6.37.y/arch/unicore32/include/asm/io.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/io.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/io.h	2010-11-11 10:23:14.258566201 +0800
> @@ -0,0 +1,275 @@
> +/*
> + * linux/arch/unicore32/include/asm/io.h

This also looks similar to the asm-generic version. Can you use that, or
possibly change it enough so you can?

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/irq.h linux-2.6.37.y/arch/unicore32/include/asm/irq.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/irq.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/irq.h	2010-11-08 17:25:42.768638981 +0800
> +
> +#ifndef irq_canonicalize
> +#define irq_canonicalize(i)	(i)
> +#endif

This can come from asm-generic/irq.h

> +/*
> + * Use this value to indicate lack of interrupt
> + * capability
> + */
> +#ifndef NO_IRQ
> +#define NO_IRQ	((unsigned int)(-1))
> +#endif

This should not be required at all any more.

> +extern void asm_do_IRQ(unsigned int, struct pt_regs *);


> +void init_IRQ(void);

Could you add this declaration to linux/irq.h and remove it from
init/main.c instead? It's good to have it in a header, but the
declaration is not architecture dependent, so it should be in
a common place.

> +#####
> +# Auto Generate the files that only include the corresponding asm-generic file
> +#   6 files in 27-uc: errno.h fcntl.h ioctl.h poll.h resource.h siginfo.h
> +
> +define cmd_asmgeneric
> +	(set -e; \
> +	 echo '#include <asm-generic/$(notdir $@)>' )	> $@
> +endef

Nice trick. I'd love to have something like this in the common code so
we can do the same for all architectures.

Does this work with external object directories, i.e. building with
make O=objdir, and with make headers_install?

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/limits.h linux-2.6.37.y/arch/unicore32/include/asm/limits.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/limits.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/limits.h	2010-11-08 17:35:26.310566514 +0800
> @@ -0,0 +1,22 @@
> +/*
> + * linux/arch/unicore32/include/asm/limits.h

Does not appear to be used anywhere.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/locks.h linux-2.6.37.y/arch/unicore32/include/asm/locks.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/locks.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/locks.h	2010-11-08 17:36:32.483205236 +0800
> @@ -0,0 +1,160 @@
> +/*
> + * linux/arch/unicore32/include/asm/locks.h

Same here.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/mach/arch.h linux-2.6.37.y/arch/unicore32/include/asm/mach/arch.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/mach/arch.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/mach/arch.h	2010-11-08 17:41:27.521694602 +0800
> +struct machine_desc {
> +	/*
> +	 * Note! The first two elements are used
> +	 * by assembler code in head.S, head-common.S
> +	 */
> +	unsigned int		nr;		/* architecture number	*/
> +	const char		*name;		/* architecture name	*/
> +	unsigned long		boot_params;	/* tagged list		*/
> +
> +	unsigned int		nr_irqs;	/* number of IRQs */
> +
> +	unsigned int		video_start;	/* start of video RAM	*/
> +	unsigned int		video_end;	/* end of video RAM	*/
> +
> +	unsigned int		reserve_lp0:1;	/* never has lp0 */
> +	unsigned int		reserve_lp1:1;	/* never has lp1 */
> +	unsigned int		reserve_lp2:1;	/* never has lp2 */
> +	unsigned int		soft_reboot:1;	/* soft reboot	 */
> +	void			(*fixup)(struct machine_desc *,
> +					 struct tag *, char **,
> +					 struct meminfo *);
> +	void			(*reserve)(void);/* reserve mem blocks	*/
> +	void			(*map_io)(void);/* IO mapping function	*/
> +	void			(*init_irq)(void);
> +	struct sys_timer	*timer;		/* system tick timer	*/
> +	void			(*init_machine)(void);
> +};

I don't think you need the machine_desc abstraction, especially when you
move to using a device tree. Right now, you only define one instance of
it, and even if you eventually get more of them that can be in the same
kernel, the abstraction is likely not the right one for you case.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/mach/irq.h linux-2.6.37.y/arch/unicore32/include/asm/mach/irq.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/mach/irq.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/mach/irq.h	2010-11-08 17:42:46.795752627 +0800
> @@ -0,0 +1,38 @@
> +/*
> + * linux/arch/unicore32/include/asm/mach/irq.h

Mostly unused:

> +extern unsigned int arch_nr_irqs;
> +extern void (*init_arch_irq)(void);

These are only required for the machine_desc abstraction mentioned
above, so you can remove this file together with arch.h

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/mach/map.h linux-2.6.37.y/arch/unicore32/include/asm/mach/map.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/mach/map.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/mach/map.h	2010-11-08 17:43:07.163075993 +0800
> @@ -0,0 +1,41 @@
> +/*
> + * linux/arch/unicore32/include/asm/mach/map.h
> + *
> + * Code specific to PKUnity SoC and UniCore ISA
> + * Fragments that appear the same as the files in arm or x86
> + *
> + * Copyright (C) 2001-2008 GUAN Xue-tao
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + *  Page table mapping constructs and function prototypes
> + */
> +#include <asm/io.h>
> +
> +struct map_desc {
> +	unsigned long virtual;
> +	unsigned long pfn;
> +	unsigned long length;
> +	unsigned int type;
> +};
> +
> +/* types 0-3 are defined in asm/io.h */
> +#define MT_UNCACHED		4
> +#define MT_CACHECLEAN		5
> +#define MT_MINICLEAN		6
> +#define MT_KUSER		7
> +#define MT_HIGH_VECTORS		8
> +#define MT_MEMORY		9
> +#define MT_ROM			10
> +
> +extern void iotable_init(struct map_desc *, int);

You don't use iotable_init, so the rest of this file is rather
pointless, too. The code using map_desc can probably be simplified
significantly by making it less general and directly manipulating
the page tables.

You only have three users of create_mapping() anyway, and they
are all special cases:

* the interrupt vectors are a single page, which you can
directly put in the page table

* the unigfx might not need a fixmap, just use ioremap

* the linar mapping probably wants to use large pages
if you have those.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/mach/pci.h linux-2.6.37.y/arch/unicore32/include/asm/mach/pci.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/mach/pci.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/mach/pci.h	2010-11-08 17:46:49.475569661 +0800
> @@ -0,0 +1,65 @@
> +/*
> + * linux/arch/unicore32/include/asm/mach/pci.h
> +
> +struct hw_pci {
> +#ifdef CONFIG_PCI_DOMAINS
> +	int		domain;
> +#endif
> +	struct list_head buses;
> +	int		nr_controllers;
> +	int		(*setup)(int nr, struct pci_sys_data *);
> +	struct pci_bus *(*scan)(int nr, struct pci_sys_data *);
> +	void		(*preinit)(void);
> +	void		(*postinit)(void);
> +	u8		(*swizzle)(struct pci_dev *dev, u8 *pin);
> +	int		(*map_irq)(struct pci_dev *dev, u8 slot, u8 pin);
> +};
> +
> +/*
> + * Per-controller structure
> + */
> +struct pci_sys_data {
> +#ifdef CONFIG_PCI_DOMAINS
> +	int		domain;
> +#endif
> +	struct list_head node;
> +	int		busnr;		/* primary bus number		  */
> +	u64		mem_offset;	/* bus->cpu memory mapping offset */
> +	unsigned long	io_offset;	/* bus->cpu IO mapping offset	  */
> +	struct pci_bus	*bus;		/* PCI bus			  */
> +	struct resource *resource[3];	/* Primary PCI bus resources	  */
> +					/* Bridge swizzling		  */
> +	u8		(*swizzle)(struct pci_dev *, u8 *);
> +					/* IRQ mapping			  */
> +	int		(*map_irq)(struct pci_dev *, u8, u8);
> +	struct hw_pci	*hw;
> +	void		*private_data;	/* platform controller private data	*/
> +};

These are two separate abstractions for multiple PCI controllers,
but your code does not even contain one implementation.

I can only assume that you actually have a PCI implementation, but
if you do not have more than one, you are better off implementing just
the one you have instead of extra wrappers.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/mach/time.h linux-2.6.37.y/arch/unicore32/include/asm/mach/time.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/mach/time.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/mach/time.h	2010-11-08 17:48:06.111456784 +0800
> @@ -0,0 +1,52 @@
> +/*
> + * linux/arch/unicore32/include/asm/mach/time.h

Can be removed when you get rid of the machine_desc abstraction.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/memblock.h linux-2.6.37.y/arch/unicore32/include/asm/memblock.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/memblock.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/memblock.h	2010-11-10 18:59:14.326006751 +0800
> @@ -0,0 +1,22 @@
> +/*
> + * linux/arch/unicore32/include/asm/memblock.h

This too.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/memory.h linux-2.6.37.y/arch/unicore32/include/asm/memory.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/memory.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/memory.h	2010-11-10 12:22:26.367182228 +0800
> @@ -0,0 +1,201 @@
> +/*
> + * Allow for constants defined here to be used from assembly code
> + * by prepending the UL suffix only with actual C code compilation.
> + */
> +#define UL(x) _AC(x, UL)
> +
> +/*
> + * PAGE_OFFSET - the virtual address of the start of the kernel image
> + * TASK_SIZE - the maximum size of a user space task.
> + * TASK_UNMAPPED_BASE - the lower boundary of the mmap VM area
> + */
> +#define PAGE_OFFSET		UL(CONFIG_PAGE_OFFSET)
> +#define TASK_SIZE		(UL(CONFIG_PAGE_OFFSET) - UL(0x41000000))
> +#define TASK_UNMAPPED_BASE	(UL(CONFIG_PAGE_OFFSET) / 3)

Does this need to be configurable?

> +/*
> + * The DMA mask corresponding to the maximum bus address allocatable
> + * using GFP_DMA.  The default here places no restriction on DMA
> + * allocations.  This must be the smallest DMA mask in the system,
> + * so a successful GFP_DMA allocation will always satisfy this.
> + */
> +#ifndef ISA_DMA_THRESHOLD
> +#define ISA_DMA_THRESHOLD	(0xffffffffULL)
> +#endif

Not needed any more

> +/*
> + * Virtual <-> DMA view memory address translations
> + * Again, these are *only* valid on the kernel direct mapped RAM
> + * memory.  Use of these is *deprecated* (and that doesn't mean
> + * use the __ prefixed forms instead.)  See dma-mapping.h.
> + */
> +#ifndef __virt_to_bus
> +#define __virt_to_bus	__virt_to_phys
> +#define __bus_to_virt	__phys_to_virt
> +#define __pfn_to_bus(x)	__pfn_to_phys(x)
> +#define __bus_to_pfn(x)	__phys_to_pfn(x)
> +#endif
> +
> +static inline __deprecated unsigned long virt_to_bus(void *x)
> +{
> +	return __virt_to_bus((unsigned long)x);
> +}
> +
> +static inline __deprecated void *bus_to_virt(unsigned long x)
> +{
> +	return (void *)__bus_to_virt(x);
> +}

I would recommend not defining these at all, since drivers that
use them are broken on many platforms.

> +/*
> + * Optional coherency support.  Currently used only by selected
> + * Intel XSC3-based systems.
> + */
> +#ifndef arch_is_coherent
> +#define arch_is_coherent()		0
> +#endif

The comment refers to a specific ARM implementation. Do you have
both coherent and non-coherent DMA platforms? If not, you can
probably remove this macro and change all callers to just
assume the architecture is not coherent.

If you plan to do coherent IO in the future, you can of course
leave it in.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/mman.h linux-2.6.37.y/arch/unicore32/include/asm/mman.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/mman.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/mman.h	2010-11-08 18:22:07.352566553 +0800
> @@ -0,0 +1,15 @@
> +
> +#define arch_mmap_check(addr, len, flags) \
> +	(((flags) & MAP_FIXED && (addr) < FIRST_USER_ADDRESS) ? -EINVAL : 0)

Why is this needed? It should probably have a comment with explanation
why you are different from other architectures here.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/mmu_context.h linux-2.6.37.y/arch/unicore32/include/asm/mmu_context.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/mmu_context.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/mmu_context.h	2010-11-08 18:24:38.124691608 +0800
> +void __check_kvm_seq(struct mm_struct *mm);
> +
> +static inline void check_context(struct mm_struct *mm)
> +{
> +#ifdef CONFIG_MMU
> +	if (unlikely(mm->context.kvm_seq != init_mm.context.kvm_seq))
> +		__check_kvm_seq(mm);
> +#endif
> +}

Same here.

Also, do you actually support both MMU and NOMMU modes?

> +/*
> + * We are inserting a "fake" vma for the user-accessible vector page so
> + * gdb and friends can get to it through ptrace and /proc/<pid>/mem.
> + * But we also want to remove it before the generic code gets to see it
> + * during process exit or the unmapping of it would  cause total havoc.
> + * (the macro is used as remove_vma() is static to mm/mmap.c)
> + */
> +#define arch_exit_mmap(mm) \
> +do { \
> +	struct vm_area_struct *high_vma = find_vma(mm, 0xffff0000); \
> +	if (high_vma) { \
> +		BUG_ON(high_vma->vm_next);  /* it should be last */ \
> +		if (high_vma->vm_prev) \
> +			high_vma->vm_prev->vm_next = NULL; \
> +		else \
> +			mm->mmap = NULL; \
> +		rb_erase(&high_vma->vm_rb, &mm->mm_rb); \
> +		mm->mmap_cache = NULL; \
> +		mm->map_count--; \
> +		remove_vma(high_vma); \
> +	} \
> +} while (0)

Have you considered making the vector page part of the vDSO area so
you can actually debug through it? That would probably also help
avoid hacks like this one.

> +typedef struct {
> +	unsigned int kvm_seq;
> +} mm_context_t;
> +
> +#define ASID(mm)	(0)

What is a kvm_seq?

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/posix_types.h linux-2.6.37.y/arch/unicore32/include/asm/posix_types.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/posix_types.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/posix_types.h	2010-11-08 19:11:38.160109064 +0800
> @@ -0,0 +1,77 @@
> +/*
> + * linux/arch/unicore32/include/asm/posix_types.h

As mentioned in a previous mail, I think you shuold drop support for
your own ABI and use the one defined in the asm-generic headers.

> +/*
> + *	User Space Model
> + *	================
> + *
> + *	This section selects the correct set of functions for dealing with
> + *	page-based copying and clearing for user space for the particular
> + *	processor(s) we're building for.
> + *
> + *	We have the following to choose from:
> + *	  ucv1		- UNICOREv1
> + *	  ucv2		- UNICOREv2
> + */
> +#undef _USER
> +
> +#ifdef CONFIG_CPU_UCV1
> +#  error UniCore v1 is not supported
> +#  define _USER ucv1
> +#endif
> +
> +#ifdef CONFIG_CPU_UCV2
> +#  define _USER ucv2
> +#endif
> +
> +#ifndef _USER
> +#error Unknown user operations model
> +#endif

Same comment as with the other abstractions: this is proably not worth
it, especially since you only support ucv2 now.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/proc-fns.h linux-2.6.37.y/arch/unicore32/include/asm/proc-fns.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/proc-fns.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/proc-fns.h	2010-11-08 19:14:23.416566783 +0800
> @@ -0,0 +1,49 @@
> +/*
> + * linux/arch/unicore32/include/asm/proc-fns.h
> +#undef CPU_NAME
> +
> +/*
> + * CPU_NAME - the prefix for CPU related functions
> + */
> +
> +#ifdef CONFIG_CPU_UCV1
> +#   define CPU_NAME cpu_ucv1
> +#endif
> +#ifdef CONFIG_CPU_UCV2
> +#   define CPU_NAME cpu_ucv2
> +#endif

Same here.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/procinfo.h linux-2.6.37.y/arch/unicore32/include/asm/procinfo.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/procinfo.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/procinfo.h	2010-11-08 19:14:40.741030515 +0800
> +/*
> + * Note!  struct processor is always defined if we're
> + * using MULTI_CPU, otherwise this entry is unused,
> + * but still exists.
> + *
> + * NOTE! The following structure is defined by assembly
> + * language, NOT C code.
> + */
> +struct proc_info_list {
> +	unsigned int		cpu_val;
> +	unsigned int		cpu_mask;
> +	unsigned long		__cpu_mm_mmu_flags;	/* used by head.S */
> +	unsigned long		__cpu_io_mmu_flags;	/* used by head.S */
> +	unsigned long		__cpu_flush;		/* used by head.S */
> +	const char		*arch_name;
> +	const char		*elf_name;
> +	unsigned int		elf_hwcap;
> +	const char		*cpu_name;
> +	struct processor	*proc;
> +	struct cpu_tlb_fns	*tlb;
> +	struct cpu_user_fns	*user;
> +	struct cpu_cache_fns	*cache;
> +};

I can't find the code where this is defined, can you be more specific in
the comment? Also, you probably don't need this if you support only one
CPU.

> +#else	/* __KERNEL__ */
> +#include <asm/elf.h>
> +#warning "Please include asm/elf.h instead"
> +#endif	/* __KERNEL__ */
> +#endif

This section seems to be misplaced.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/ptrace.h linux-2.6.37.y/arch/unicore32/include/asm/ptrace.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/ptrace.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/ptrace.h	2010-11-11 11:18:26.289251310 +0800
> +
> +#define PTRACE_GETREGS		12
> +#define PTRACE_SETREGS		13
> +#define PTRACE_GETFPREGS	14
> +#define PTRACE_SETFPREGS	15

I believe these can and should be replaced with the common
PTRACE_GETREGSET, which will also simplify your ptrace code.

> +#define PTRACE_OLDSETOPTIONS	21

unused, just remove

> +#define PTRACE_SET_SYSCALL	23

This appears to be ARM specific. Can you remove it?


> +/*
> + * These are 'magic' values for PTRACE_PEEKUSR that return info about where a
> + * process is located in memory.
> + */
> +#define PT_TEXT_ADDR		0x10000
> +#define PT_DATA_ADDR		0x10004
> +#define PT_TEXT_END_ADDR	0x10008

Are these just for NOMMU?

> --- linux-2.6.37-rc1/arch/unicore32/include/asm/rtc.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/rtc.h	2010-11-08 19:33:18.578442392 +0800
> @@ -0,0 +1,40 @@
> +/*
> + * linux/arch/unicore32/include/asm/rtc.h

Unused?

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/setup.h linux-2.6.37.y/arch/unicore32/include/asm/setup.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/setup.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/setup.h	2010-11-09 09:03:14.051168672 +0800
> @@ -0,0 +1,203 @@
> +/*
> + * linux/arch/unicore32/include/asm/setup.h

> +
> +/* The list ends with an ATAG_NONE node. */
> +#define ATAG_NONE	0x00000000
> +
> +struct tag_header {
> +	__u32 size;
> +	__u32 tag;
> +};

The ATAG facility is currently used only on ARM, and there is a tendency
to no longer it from new platforms there, so you'd be better off not
using it for UniCore.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/signal.h linux-2.6.37.y/arch/unicore32/include/asm/signal.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/signal.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/signal.h	2010-11-09 09:13:32.152989524 +0800
> @@ -0,0 +1,178 @@
> +/*
> + * linux/arch/unicore32/include/asm/signal.h

> +/* Here we must cater to libcs that poke about in kernel headers.  */
> +
> +#define NSIG		32
> +typedef unsigned long sigset_t;
> +

Don't bother if you do not have legacy libc support.

> +#endif /* __KERNEL__ */
> +
> +#define SIGHUP		 1
> +#define SIGINT		 2
> +#define SIGQUIT		 3
> +#define SIGILL		 4
> +#define SIGTRAP		 5
> +#define SIGABRT		 6
> +#define SIGIOT		 6
> +#define SIGBUS		 7

The signal numbers are defined in asm-generic/signal.h, just use those.

> +struct old_sigaction {
> +	__sighandler_t sa_handler;
> +	old_sigset_t sa_mask;
> +	unsigned long sa_flags;
> +	__sigrestore_t sa_restorer;
> +};

No need for old_sigaction if you have no legacy user space.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/sizes.h linux-2.6.37.y/arch/unicore32/include/asm/sizes.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/sizes.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/sizes.h	2010-11-09 09:13:54.174932033 +0800
> @@ -0,0 +1,48 @@
> +/*
> + * linux/arch/unicore32/include/asm/sizes.h

I guess we can move this file to asm-generic and remove the existing
three copies. No need to another one.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/statfs.h linux-2.6.37.y/arch/unicore32/include/asm/statfs.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/statfs.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/statfs.h	2010-11-09 09:21:14.365611423 +0800
>
> +#define ARCH_PACK_STATFS64 __attribute__((packed, aligned(4)))

I don't think you need this.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/stat.h linux-2.6.37.y/arch/unicore32/include/asm/stat.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/stat.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/stat.h	2010-11-09 09:25:07.153147609 +0800
> @@ -0,0 +1,88 @@
> +/*
> + * linux/arch/unicore32/include/asm/stat.h

This should use the asm-generic version.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/string.h linux-2.6.37.y/arch/unicore32/include/asm/string.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/string.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/string.h	2010-11-09 09:25:56.489582672 +0800
> +/*
> + * We don't do inline string functions, since the
> + * optimised inline asm versions are not small.
> + */
> +
> +#define __HAVE_ARCH_STRRCHR
> +extern char *strrchr(const char *s, int c);
> +
> +#define __HAVE_ARCH_STRCHR
> +extern char *strchr(const char *s, int c);
> +
> +#define __HAVE_ARCH_MEMCPY
> +extern void *memcpy(void *, const void *, __kernel_size_t);
> +
> +#define __HAVE_ARCH_MEMMOVE
> +extern void *memmove(void *, const void *, __kernel_size_t);
> +
> +#define __HAVE_ARCH_MEMCHR
> +extern void *memchr(const void *, int, __kernel_size_t);
> +
> +#define __HAVE_ARCH_MEMSET
> +extern void *memset(void *, int, __kernel_size_t);
> +
> +extern void __memzero(void *ptr, __kernel_size_t n);

Is it really worth implementing these in assembly? Did you have
a problem with the C versions of these?

> +#define memset(p, v, n)							\
> +	({								\
> +		void *__p = (p); size_t __n = n;			\
> +		if ((__n) != 0) {					\
> +			if (__builtin_constant_p((v)) && (v) == 0)	\
> +				__memzero((__p), (__n));		\
> +			else						\
> +				memset((__p), (v), (__n));		\
> +		}							\
> +		(__p);							\
> +	})

This might be a candidate for adding to asm-generic/string.h

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/swab.h linux-2.6.37.y/arch/unicore32/include/asm/swab.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/swab.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/swab.h	2010-11-09 09:28:21.005577540 +0800
> @@ -0,0 +1,51 @@
> +/*
> + * linux/arch/unicore32/include/asm/swab.h
> + *
> + * Code specific to PKUnity SoC and UniCore ISA
> + *
> + * Copyright (C) 2001-2008 GUAN Xue-tao
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * In little endian mode, the data bus is connected such
> + * that byte accesses appear as:
> + *  0 = d0...d7, 1 = d8...d15, 2 = d16...d23, 3 = d24...d31
> + * and word accesses (data or instruction) appear as:
> + *  d0...d31
> + */
> +#ifndef __UNICORE_SWAB_H__
> +#define __UNICORE_SWAB_H__
> +
> +#include <linux/compiler.h>
> +#include <linux/types.h>
> +
> +#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
> +#  define __SWAB_64_THRU_32__
> +#endif
> +
> +static inline __attribute_const__ __u32 __arch_swab32(__u32 x)

Can't you use the __builtin_bswap32/__builtin_bswap64 provided by gcc?

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/system.h linux-2.6.37.y/arch/unicore32/include/asm/system.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/system.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/system.h	2010-11-11 10:47:21.099797151 +0800
> +#define CPU_ARCH_UNKNOWN		0
> +#define CPU_ARCH_UCV1			1
> +#define CPU_ARCH_UCV2			2

Seems pointless now.

> +/*
> + * This is used to ensure the compiler did actually allocate the register we
> + * asked it for some inline assembly sequences.  Apparently we can't trust
> + * the compiler from one version to another so a bit of paranoia won't hurt.
> + * This string is meant to be concatenated with the inline asm string and
> + * will cause compilation to stop on mismatch.
> + * (for details, see gcc PR 15089)
> + */
> +#define __asmeq(x, y)  ".ifnc " x "," y " ; .err ; .endif\n\t"

This was a really old arm specific bug, I think you don't need to work
around it any more.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/thread_info.h linux-2.6.37.y/arch/unicore32/include/asm/thread_info.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/thread_info.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/thread_info.h	2010-11-09 11:08:48.035585213 +0800

> +extern void ucf64_sync_hwstate(struct thread_info *);
> +extern void ucf64_flush_hwstate(struct thread_info *);

Not used anywhere.

> +/*
> + * thread information flags:
> + *  TIF_SYSCALL_TRACE	- syscall trace active
> + *  TIF_SIGPENDING	- signal pending
> + *  TIF_NEED_RESCHED	- rescheduling necessary
> + *  TIF_NOTIFY_RESUME	- callback before returning to user
> + *  TIF_USEDFPU		- FPU was used by this task this quantum (SMP)
> + *  TIF_POLLING_NRFLAG	- true if poll_idle() is polling TIF_NEED_RESCHED
> + */
> +#define TIF_SIGPENDING		0
> +#define TIF_NEED_RESCHED	1
> +#define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
> +#define TIF_SYSCALL_TRACE	8
> +#define TIF_POLLING_NRFLAG	16
> +#define TIF_USING_IWMMXT	17
> +#define TIF_MEMDIE		18	/* is terminating due to OOM killer */
> +#define TIF_FREEZE		19
> +#define TIF_RESTORE_SIGMASK	20
> +#define TIF_SECCOMP		21
> +
> +#define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
> +#define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
> +#define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
> +#define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
> +#define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
> +#define _TIF_USING_IWMMXT	(1 << TIF_USING_IWMMXT)
> +#define _TIF_FREEZE		(1 << TIF_FREEZE)
> +#define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
> +#define _TIF_SECCOMP		(1 << TIF_SECCOMP)

At lease USING_IWMMXT seems wrong here, best go through the list and
see which ones are really getting used.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/thread_notify.h linux-2.6.37.y/arch/unicore32/include/asm/thread_notify.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/thread_notify.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/thread_notify.h	2010-11-09 11:09:21.479664929 +0800
> @@ -0,0 +1,51 @@
> +/*
> + * linux/arch/unicore32/include/asm/thread_notify.h

Seems to be unused.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/tlbflush.h linux-2.6.37.y/arch/unicore32/include/asm/tlbflush.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/tlbflush.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/tlbflush.h	2010-11-09 11:17:07.315731209 +0800
> +/*
> + *	MMU TLB Model
> + *	=============
> + *
> + *	We have the following to choose from:
> + *	  ucv1    - UNICOREv1
> + *	  ucv2    - UNICOREv2
> + */
> +#undef _TLB
> +
> +#ifdef CONFIG_CPU_UCV1
> +#  define ucv1_tlb_flags	0
> +#  define _TLB ucv1
> +#endif
> +
> +#ifdef CONFIG_CPU_UCV2
> +#  define ucv2_tlb_flags	0
> +#  define _TLB ucv2
> +#endif

Similar to others before, just remove.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/traps.h linux-2.6.37.y/arch/unicore32/include/asm/traps.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/traps.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/traps.h	2010-11-09 11:23:45.956860114 +0800
> @@ -0,0 +1,43 @@
> +/*
> + * linux/arch/unicore32/include/asm/traps.h
> + *
> +struct undef_hook {
> +	struct list_head node;
> +	u32 instr_mask;
> +	u32 instr_val;
> +	u32 csr_mask;
> +	u32 csr_val;
> +	int (*fn)(struct pt_regs *regs, unsigned int instr);
> +};

This seems to be a lot of infrastructure for trapping a single
instruction. You can probably call ptrace_break directly from
do_undefinstr.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/uaccess.h linux-2.6.37.y/arch/unicore32/include/asm/uaccess.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/uaccess.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/uaccess.h	2010-11-09 11:33:30.209566466 +0800
> @@ -0,0 +1,408 @@
> +/*
> + * linux/arch/unicore32/include/asm/uaccess.h

Please have another look at the asm-generic version of this file.
With the current version it may be useful to base on that.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/unistd.h linux-2.6.37.y/arch/unicore32/include/asm/unistd.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/unistd.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/unistd.h	2010-11-11 10:47:36.743710466 +0800

Please use the cleaned-up asm-generic version as arch/tile does now.
You add a lot of overhead otherwise.

> +/*
> + * The following SWIs are UNICORE private.
> + */
> +#define __UNICORE_NR_BASE		(__NR_SYSCALL_BASE+0x0f0000)
> +#define __UNICORE_NR_breakpoint		(__UNICORE_NR_BASE+1)
> +#define __UNICORE_NR_cacheflush		(__UNICORE_NR_BASE+2)
> +/* reserved 3 */
> +/* reserved 4 */
> +
> +/*
> + * *NOTE*: This is a ghost syscall private to the kernel.
> + * Don't ever use this from user code.
> + */
> +#ifdef __KERNEL__
> +#define __UNICORE_NR_cmpxchg		(__UNICORE_NR_BASE+0x00fff0)
> +#endif

These can be defined in terms of __NR_arch_specific_syscall.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/include/asm/xor.h linux-2.6.37.y/arch/unicore32/include/asm/xor.h
> --- linux-2.6.37-rc1/arch/unicore32/include/asm/xor.h	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/include/asm/xor.h	2010-11-09 12:00:34.366831812 +0800
> @@ -0,0 +1,143 @@
> +/*
> + * linux/arch/unicore32/include/asm/xor.h

Have you tried if your code is faster than the asm-generic version?
If now, just use the generic one.

> diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff linux-2.6.37-rc1/arch/unicore32/Kconfig linux-2.6.37.y/arch/unicore32/Kconfig
> --- linux-2.6.37-rc1/arch/unicore32/Kconfig	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/Kconfig	2010-11-11 10:40:02.001225028 +0800
> @@ -0,0 +1,337 @@
> +config UNICORE
> +	bool
> +	default y
> +	select HAVE_MEMBLOCK
> +	select GENERIC_ATOMIC64 if !64BIT
> +	select HAVE_OPROFILE if (HAVE_PERF_EVENTS)
> +	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
> +	select HAVE_FTRACE_MCOUNT_RECORD if (!XIP_KERNEL)
> +	select HAVE_DYNAMIC_FTRACE if (!XIP_KERNEL)
> +	select HAVE_GENERIC_DMA_COHERENT
> +	select HAVE_KERNEL_GZIP
> +	select HAVE_KERNEL_LZO
> +	select HAVE_KERNEL_LZMA

It seems you don't actually have FTRACE, so that should not be in there.
I would recommend dropping oprofile support entirely, and add perf
support later, after the main code has gone in.

> +config GENERIC_GPIO
> +	bool

Why is this disabled?

> +config MMU
> +	bool "MMU-based Paged Memory Management Support"
> +	default y
> +	help
> +	  Select if you want MMU-based virtualised addressing space
> +	  support by paged memory management. If unsure, say 'Y'.

It does not seem like disabling this is really supported.
It would be good to do some "make randconfig" builds in order to
find unsupported configuration options and make sure that they
either become supported or no longer are selectable.

> +
> +config ARCH_FPGA
> +	bool
> +
> +if ARCH_FPGA
> +
> +config FPGA_DLX200
> +	bool
> +	default ARCH_FPGA
> +
> +endif

The if/endif seems redundant here.

> +choice
> +	prompt "PKUnity system type"
> +	default ARCH_PUV3
> +
> +	config ARCH_PUV3
> +	bool "PKUnity v3 (SuperK)"
> +	select CPU_UCV2
> +	select PKUNITY_AMBA
> +	select ZONE_DMA
> +	select EMBEDDED
> +	select GENERIC_CLOCKEVENTS
> +	select HAVE_CLK
> +	select ARCH_USES_GETTIMEOFFSET
> +	select ARCH_REQUIRE_GPIOLIB
> +	select ARCH_HAS_CPUFREQ
> +
> +endchoice

You should never need to select CONFIG_EMBEDDED, that is only for
very rare configurations.

You might not want to select ZONE_DMA and ARCH_USES_GETTIMEOFFSET,
since you are generally better off without them.

> +config HIGHMEM
> +	bool "High Memory Support (EXPERIMENTAL)"
> +	depends on MMU && EXPERIMENTAL
> +	help
> +	  The address space of UniCore processors is only 4 Gigabytes large
> +	  and it has to accommodate user address space, kernel address
> +	  space as well as some memory mapped IO. That means that, if you
> +	  have a large amount of physical memory and/or IO, not all of the
> +	  memory can be "permanently mapped" by the kernel. The physical
> +	  memory that is not permanently mapped is called "high memory".
> +
> +	  Depending on the selected kernel/user memory split, minimum
> +	  vmalloc space and actual amount of RAM, you may not need this
> +	  option which should result in a slightly faster kernel.
> +
> +	  If unsure, say n.
> +
> +config HIGHPTE
> +	bool "Allocate 2nd-level pagetables from highmem"
> +	depends on HIGHMEM

As mentioned before, I would not bother having HIGHMEM support unless
you really need it for many machines.

> +config PCI
> +	bool "PCI Support"
> +	help
> +	  Find out whether you have a PCI motherboard. PCI is the name of a
> +	  bus system, i.e. the way the CPU talks to the other stuff inside
> +	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
> +	  VESA. If you have PCI, say Y, otherwise N.
> +
> +config PCI_DOMAINS
> +	bool
> +	depends on PCI
> +
> +config PCI_SYSCALL
> +	def_bool PCI

PCI_SYSCALL should not be needed for new architectures. PCI_DOMAINS
is silently disabled here, I would just remove it entirely unless you
already have plans to support machines with more than one PCI domain.

> +config NR_CPUS
> +	int "Maximum number of CPUs" if SMP
> +	range 2 512 if SMP
> +	default "1" if !SMP

No SMP support as far as I can tell, so this gets pointless for now.

> +config VECTORS_TRACE
> +	bool "Enable vectors trace"
> +	depends on DEBUG_LL
> +	help
> +	  This allows the trace of the entry and exit of some exceptions.
> +
> +config VECTORS_TRACE_INTR
> +	bool "Enable INTR mode vectors trace"
> +	depends on VECTORS_TRACE
> +	default	n
> +	help
> +	  This allows the trace of the entry and exit of INTR exceptions.
> +
> +config VECTORS_TRACE_ABRT
> +	bool "Enable ABRT mode vectors trace"
> +	depends on VECTORS_TRACE
> +	default	n
> +	help
> +	  This Enables the trace of the entry and exit of ABRT exceptions.
> +
> +config VECTORS_TRACE_EXTN
> +	bool "Enable EXTN mode vectors trace"
> +	depends on VECTORS_TRACE
> +	default	n
> +	help
> +	  This enables the trace of the entry and exit of EXTN exceptions.
> +
> +endmenu

What are you using these for? My feeling is that they should eventually
become regular trace points, but for now you might just want to leave
them out.

That's all for now, let's discuss my comments first and then I'll
start commenting on the next parts.

	Arnd
