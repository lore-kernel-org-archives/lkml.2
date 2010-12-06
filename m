Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab0LFTC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 14:02:59 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:50309 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab0LFTC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 14:02:58 -0500
Date: Mon, 6 Dec 2010 20:02:51 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        sodaville@linutronix.de, linuxppc-dev@lists.ozlabs.org,
        microblaze-uclinux@itee.uq.edu.au, linux-arch@vger.kernel.org,
        mmarek@suse.cz
Subject: Re: [PATCH 1/4] of: Add support for linking device tree blobs into
	vmlinux
Message-ID: <20101206190251.GB20882@merkur.ravnborg.org>
References: <cover.1291656753.git.dirk.brandewie@gmail.com> <76a37fa459aeadce5d11db8a7cc044687a2e0e8c.1291656753.git.dirk.brandewie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76a37fa459aeadce5d11db8a7cc044687a2e0e8c.1291656753.git.dirk.brandewie@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 09:35:59AM -0800, dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> This patch adds support for linking device tree blob(s) into
> vmlinux. Modifies asm-generic/vmlinux.lds.h to add linking
> .dtb sections into vmlinux. To maintain compatiblity with the of/fdt
> driver code platforms MUST copy the blob to a non-init memory location
> before the kernel frees the .init.* sections in the image.
> 
> Modifies scripts/Makefile.lib to add a kbuild command to
> compile DTS files to device tree blobs and a rule to create objects to
> wrap the blobs for linking.
> 
> STRUCT_ALIGNMENT is defined in vmlinux.lds.h for use in the rule to
> create wrapper objects for the dtb in Makefile.lib.  The
> STRUCT_ALIGN() macro in vmlinux.lds.h is modified to use the
> STRUCT_ALIGNMENT definition.
> 
> The DTB's are placed on 32 byte boundries to allow parsing the blob
> with driver/of/fdt.c during early boot without having to copy the blob
> to get the structure alignment GCC expects.
> 
> A DTB is linked in by adding the DTB object to the list of objects to
> be linked into vmlinux in the archtecture specific Makefile using
>    obj-y += foo.dtb.o
> 
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
>  Documentation/kbuild/makefiles.txt |   15 +++++++++++++++
>  include/asm-generic/vmlinux.lds.h  |   15 ++++++++++++---
>  scripts/Makefile.lib               |   21 ++++++++++++++++++++-
>  3 files changed, 47 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
> index 0ef00bd..fc18bb1 100644
> --- a/Documentation/kbuild/makefiles.txt
> +++ b/Documentation/kbuild/makefiles.txt
> @@ -1136,6 +1136,21 @@ When kbuild executes, the following steps are followed (roughly):
>  	      resulting in the target file being recompiled for no
>  	      obvious reason.
>  
> +    dtc
> +	Create flattend device tree blob object suitable for linking
> +	into vmlinux. Device tree blobs linked into vmlinux are placed
> +	in an init section in the image. Platform code *must* copy the
> +	blob to non-init memory prior to calling unflatten_device_tree().
> +
> +	Example:
> +		#arch/x86/platform/ce4100/Makefile
> +		clean-files := *dtb.S
> +
> +		DTC_FLAGS := -p 1024
> +		obj-y += foo.dtb.o
> +
> +		$(obj)/%.dtb: $(src)/%.dts
> +			$(call if_changed,dtc)

When using "if_changed" you need to add your target to targets-y.
And you need to specify FORCE as a prerequisite to force kbuild
to use the if_changed logic.

The purpose of if_changed is to check if the commandlien has changed
and execute the command again also if the commandline has changed.
The simpler variant is $(call cmd,dtc) where you do not check
the command line and do not need FORCE.

> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index bd69d79..024d3b9 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -23,7 +23,7 @@
>   *	_etext = .;
>   *
>   *      _sdata = .;
> - *	RO_DATA_SECTION(PAGE_SIZE)
> +*	RO_DATA_SECTION(PAGE_SIZE)
>   *	RW_DATA_SECTION(...)
>   *	_edata = .;
>   *

Change seems wrong.

> @@ -67,7 +67,8 @@
>   * Align to a 32 byte boundary equal to the
>   * alignment gcc 4.5 uses for a struct
>   */
> -#define STRUCT_ALIGN() . = ALIGN(32)
> +#define STRUCT_ALIGNMENT 32
> +#define STRUCT_ALIGN() . = ALIGN(STRUCT_ALIGNMENT)
>  
>  /* The actual configuration determine if the init/exit sections
>   * are handled as text/data or they can be discarded (which
> @@ -146,6 +147,13 @@
>  #define TRACE_SYSCALLS()
>  #endif
>  
> +
> +#define KERNEL_DTB()							\
> +	STRUCT_ALIGN();							\
> +	VMLINUX_SYMBOL(__dtb_start) = .;				\
> +	*(.dtb.init.rodata)						\
> +	VMLINUX_SYMBOL(__dtb_end) = .;
> +
>  /* .data section */
>  #define DATA_DATA							\
>  	*(.data)							\
> @@ -468,7 +476,8 @@
>  	MCOUNT_REC()							\
>  	DEV_DISCARD(init.rodata)					\
>  	CPU_DISCARD(init.rodata)					\
> -	MEM_DISCARD(init.rodata)
> +	MEM_DISCARD(init.rodata)					\
> +	KERNEL_DTB()
>  
>  #define INIT_TEXT							\
>  	*(.init.text)							\
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index 4c72c11..937eabbb 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -200,7 +200,26 @@ quiet_cmd_gzip = GZIP    $@
>  cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9 > $@) || \
>  	(rm -f $@ ; false)
>  
> -
> +# DTC
> +#  ---------------------------------------------------------------------------
> +
> +# Generate an assembly file to wrap the output of the device tree compiler
> +$(obj)/%.dtb.S: $(obj)/%.dtb
> +	@echo '#include <asm-generic/vmlinux.lds.h>' > $@
> +	@echo '.section .dtb.init.rodata,"a"' >> $@
> +	@echo '.balign STRUCT_ALIGNMENT' >> $@
> +	@echo '.global __dtb_$(*F)_begin' >> $@
> +	@echo '__dtb_$(*F)_begin:' >> $@
> +	@echo '.incbin "$<" ' >> $@
> +	@echo '__dtb_$(*F)_end:' >> $@
> +	@echo '.global __dtb_$(*F)_end' >> $@
> +	@echo '.balign STRUCT_ALIGNMENT' >> $@
> +

If we really want this rule in Makefile.lib then at least make it less verbose,
and more secure.
Something like this:
quiet_dt_S_dtb_cmd = DTB    $@
      dt_S_dtb_cmd =                                      \
(                                                         \
	@echo '#include <asm-generic/vmlinux.lds.h>';     \
	@echo '.section .dtb.init.rodata,"a"';            \
	@echo '.balign STRUCT_ALIGNMENT';                 \
	echo '.global __dtb_$(*F)_begin';                 \
	echo '__dtb_$(*F)_begin:';                        \
	echo '.incbin "$<" ';                             \
	echo '__dtb_$(*F)_end:';                          \
	echo '.global __dtb_$(*F)_end';                   \
	echo '.balign STRUCT_ALIGNMENT';                  \
) > $@

$(obj)/%.dtb.S: $(obj)/%.dtb
	$(call cmd,dt_S_dtb)


> +DTC = $(objtree)/scripts/dtc/dtc

If this is the only spot where we use DTC then drop the variable.

> +
> +quiet_cmd_dtc = DTC $@
> +      cmd_dtc = $(DTC) -O dtb -o $@ -b 0 $(DTC_FLAGS) $<


> +ooo

What is the purpose of these "ooo"? A debugging left-over?


	Sam
