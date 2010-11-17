Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab0KQAjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:39:49 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:10353 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab0KQAjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:39:48 -0500
Message-ID: <4CE32453.2090403@caviumnetworks.com>
Date: Tue, 16 Nov 2010 16:39:47 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: dirk.brandewie@gmail.com
CC: devicetree-discuss@lists.ozlabs.org, sodaville@linutronix.de,
        arjan@linux.intel.com, linuxppc-dev@lists.ozlabs.org,
        microblaze-uclinux@itee.uq.edu.au, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] of: Add support for linking device tree blobs into
 vmlinux
References: <cover.1289943240.git.dirk.brandewie@gmail.com> <9129f0a21ea48fb2dcb89cea290e88f3e8c0d8a2.1289943240.git.dirk.brandewie@gmail.com>
In-Reply-To: <9129f0a21ea48fb2dcb89cea290e88f3e8c0d8a2.1289943240.git.dirk.brandewie@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Nov 2010 00:40:35.0961 (UTC) FILETIME=[0C902690:01CB85F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for doing this.  However I have a few comments...

On 11/16/2010 02:41 PM, dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie<dirk.brandewie@gmail.com>
>
> This patch adds support for linking device tree blobs into
> vmlinux. Modifies asm-generic/vmlinux.lds.h to add linking
> .dtb.init.rodata sections into the .init.data section of the vmlinux
> image. Modifies scripts/Makefile.lib to add a kbuild command to
> compile DTS files to device tree blobs and a rule to create objects to
> wrap the blobs for linking.
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
> ---
>   include/asm-generic/vmlinux.lds.h |   19 +++++++++++++++++--
>   scripts/Makefile.lib              |   20 ++++++++++++++++++++
>   2 files changed, 37 insertions(+), 2 deletions(-)
>
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index bd69d79..ea671e7 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -67,7 +67,14 @@
>    * Align to a 32 byte boundary equal to the
>    * alignment gcc 4.5 uses for a struct
>    */
> -#define STRUCT_ALIGN() . = ALIGN(32)
> +#define STRUCT_ALIGNMENT 32
> +#define STRUCT_ALIGN() . = ALIGN(STRUCT_ALIGNMENT)
> +
> +/* Device tree blobs linked into the kernel need to have proper
> + * structure alignment to be parsed by the flat device tree library
> + * used in early boot
> +*/
> +#define DTB_ALIGNMENT STRUCT_ALIGNMENT
>
>   /* The actual configuration determine if the init/exit sections
>    * are handled as text/data or they can be discarded (which
> @@ -146,6 +153,13 @@
>   #define TRACE_SYSCALLS()
>   #endif
>
> +
> +#define KERNEL_DTB()							\
> +	. = ALIGN(DTB_ALIGNMENT);					\
> +	VMLINUX_SYMBOL(__dtb_start) = .;				\
> +	*(.dtb.init.rodata)						\
> +	VMLINUX_SYMBOL(__dtb_end) = .;
> +
>   /* .data section */
>   #define DATA_DATA							\
>   	*(.data)							\
> @@ -468,7 +482,8 @@
>   	MCOUNT_REC()							\
>   	DEV_DISCARD(init.rodata)					\
>   	CPU_DISCARD(init.rodata)					\
> -	MEM_DISCARD(init.rodata)
> +	MEM_DISCARD(init.rodata)					\
> +	KERNEL_DTB()
>

I thought the init.rodata was only for data used by __init things. 
Although the current linker scripts do not put it in the section that 
gets recycled as usable memory.

IIRC the unflattened version of the device tree has pointers to the 
flattened data.  Since the device tree nodes are live for the entire 
kernel lifecycle, shouldn't the device tree blobs be in non-init memory?


>   #define INIT_TEXT							\
>   	*(.init.text)							\
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index 4c72c11..29db062 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -200,6 +200,26 @@ quiet_cmd_gzip = GZIP    $@
>   cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9>  $@) || \
>   	(rm -f $@ ; false)
>
> +# DTC
> +#  ---------------------------------------------------------------------------
> +$(obj)/%.dtb.S: $(obj)/%.dtb FORCE

Why FORCE?


> +	@echo '#include<asm-generic/vmlinux.lds.h>'>  $@
> +	@echo '.section .dtb.init.rodata,"a"'>>  $@
> +	@echo '.balign DTB_ALIGNMENT'>>  $@
> +	@echo '.global __dtb_$(*F)_begin'>>  $@
> +	@echo '__dtb_$(*F)_begin:'>>  $@
> +	@echo '.incbin "$<" '>>  $@
> +	@echo '__dtb_$(*F)_end:'>>  $@
> +	@echo '.global __dtb_$(*F)_end'>>  $@
> +	@echo '.balign DTB_ALIGNMENT'>>  $@
> +
> +DTC = $(objtree)/scripts/dtc/dtc
> +
> +quiet_cmd_dtc = DTC	$@
> +      cmd_dtc = $(DTC) -O dtb -o $(obj)/$*.dtb -b 0 $(DTS_FLAGS) $(src)/dts/$*.dts
> +
> +$(obj)/%.dtb: $(src)/dts/%.dts
> +	$(call if_changed,dtc)
>

Do all the generated files get cleaned up?

I will try it tomorrow to see for sure.


Thanks,
David Daney
