Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab0LWVmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 16:42:46 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:47094 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab0LWVmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 16:42:44 -0500
Date: Thu, 23 Dec 2010 14:42:41 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/4] of: Add support for linking device tree blobs into
 vmlinux
Message-ID: <20101223214241.GF20384@angua.secretlab.ca>
References: <1293047849-26078-1-git-send-email-dirk.brandewie@gmail.com>
 <1293047849-26078-2-git-send-email-dirk.brandewie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293047849-26078-2-git-send-email-dirk.brandewie@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 11:57:26AM -0800, dirk.brandewie@gmail.com wrote:
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

merged, thanks.

g.

> ---
>  Documentation/kbuild/makefiles.txt |   15 +++++++++++++++
>  include/asm-generic/vmlinux.lds.h  |   13 +++++++++++--
>  scripts/Makefile.lib               |   23 +++++++++++++++++++++++
>  3 files changed, 49 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
> index 0ef00bd..86e3cd0 100644
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
> +			$(call cmd,dtc)
>  
>  --- 6.7 Custom kbuild commands
>  
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index bd69d79..05cbad0 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
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
> index 4c72c11..7df8eb5 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -200,6 +200,29 @@ quiet_cmd_gzip = GZIP    $@
>  cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9 > $@) || \
>  	(rm -f $@ ; false)
>  
> +# DTC
> +#  ---------------------------------------------------------------------------
> +
> +# Generate an assembly file to wrap the output of the device tree compiler
> +quiet_cmd_dt_S_dtb= DTB    $@
> +cmd_dt_S_dtb=						\
> +(							\
> +	echo '\#include <asm-generic/vmlinux.lds.h>'; 	\
> +	echo '.section .dtb.init.rodata,"a"';		\
> +	echo '.balign STRUCT_ALIGNMENT';                \
> +	echo '.global __dtb_$(*F)_begin';               \
> +	echo '__dtb_$(*F)_begin:';                      \
> +	echo '.incbin "$<" ';                           \
> +	echo '__dtb_$(*F)_end:';                        \
> +	echo '.global __dtb_$(*F)_end';                 \
> +	echo '.balign STRUCT_ALIGNMENT'; 		\
> +) > $@
> +
> +$(obj)/%.dtb.S: $(obj)/%.dtb 
> +	$(call cmd,dt_S_dtb)
> +
> +quiet_cmd_dtc = DTC     $@
> +      cmd_dtc = $(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) $<
>  
>  # Bzip2
>  # ---------------------------------------------------------------------------
> -- 
> 1.7.2.3
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
