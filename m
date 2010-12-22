Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab0LVWgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 17:36:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55900 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab0LVWgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 17:36:36 -0500
Message-ID: <4D127D72.8050303@suse.cz>
Date: Wed, 22 Dec 2010 23:36:34 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au,
        linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/4] of: Add support for linking device tree blobs into
 vmlinux
References: <1293047849-26078-1-git-send-email-dirk.brandewie@gmail.com> <1293047849-26078-2-git-send-email-dirk.brandewie@gmail.com>
In-Reply-To: <1293047849-26078-2-git-send-email-dirk.brandewie@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.12.2010 20:57, dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie<dirk.brandewie@gmail.com>
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
>     obj-y += foo.dtb.o
>
> Signed-off-by: Dirk Brandewie<dirk.brandewie@gmail.com>

Hi,

you can add
Acked-by: Michal Marek <mmarek@suse.cz>
but I thing this series should go through the tip tree, as your primary 
target seems to be x86 and patch 2/4 depends on the ce4100 code that is 
only in tip.

Michal

> ---
>   Documentation/kbuild/makefiles.txt |   15 +++++++++++++++
>   include/asm-generic/vmlinux.lds.h  |   13 +++++++++++--
>   scripts/Makefile.lib               |   23 +++++++++++++++++++++++
>   3 files changed, 49 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
> index 0ef00bd..86e3cd0 100644
> --- a/Documentation/kbuild/makefiles.txt
> +++ b/Documentation/kbuild/makefiles.txt
> @@ -1136,6 +1136,21 @@ When kbuild executes, the following steps are followed (roughly):
>   	      resulting in the target file being recompiled for no
>   	      obvious reason.
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
>   --- 6.7 Custom kbuild commands
>
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index bd69d79..05cbad0 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -67,7 +67,8 @@
>    * Align to a 32 byte boundary equal to the
>    * alignment gcc 4.5 uses for a struct
>    */
> -#define STRUCT_ALIGN() . = ALIGN(32)
> +#define STRUCT_ALIGNMENT 32
> +#define STRUCT_ALIGN() . = ALIGN(STRUCT_ALIGNMENT)
>
>   /* The actual configuration determine if the init/exit sections
>    * are handled as text/data or they can be discarded (which
> @@ -146,6 +147,13 @@
>   #define TRACE_SYSCALLS()
>   #endif
>
> +
> +#define KERNEL_DTB()							\
> +	STRUCT_ALIGN();							\
> +	VMLINUX_SYMBOL(__dtb_start) = .;				\
> +	*(.dtb.init.rodata)						\
> +	VMLINUX_SYMBOL(__dtb_end) = .;
> +
>   /* .data section */
>   #define DATA_DATA							\
>   	*(.data)							\
> @@ -468,7 +476,8 @@
>   	MCOUNT_REC()							\
>   	DEV_DISCARD(init.rodata)					\
>   	CPU_DISCARD(init.rodata)					\
> -	MEM_DISCARD(init.rodata)
> +	MEM_DISCARD(init.rodata)					\
> +	KERNEL_DTB()
>
>   #define INIT_TEXT							\
>   	*(.init.text)							\
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index 4c72c11..7df8eb5 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -200,6 +200,29 @@ quiet_cmd_gzip = GZIP    $@
>   cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9>  $@) || \
>   	(rm -f $@ ; false)
>
> +# DTC
> +#  ---------------------------------------------------------------------------
> +
> +# Generate an assembly file to wrap the output of the device tree compiler
> +quiet_cmd_dt_S_dtb= DTB    $@
> +cmd_dt_S_dtb=						\
> +(							\
> +	echo '\#include<asm-generic/vmlinux.lds.h>'; 	\
> +	echo '.section .dtb.init.rodata,"a"';		\
> +	echo '.balign STRUCT_ALIGNMENT';                \
> +	echo '.global __dtb_$(*F)_begin';               \
> +	echo '__dtb_$(*F)_begin:';                      \
> +	echo '.incbin "$<" ';                           \
> +	echo '__dtb_$(*F)_end:';                        \
> +	echo '.global __dtb_$(*F)_end';                 \
> +	echo '.balign STRUCT_ALIGNMENT'; 		\
> +)>  $@
> +
> +$(obj)/%.dtb.S: $(obj)/%.dtb
> +	$(call cmd,dt_S_dtb)
> +
> +quiet_cmd_dtc = DTC     $@
> +      cmd_dtc = $(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) $<
>
>   # Bzip2
>   # ---------------------------------------------------------------------------

