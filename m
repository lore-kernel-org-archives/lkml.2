Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933866Ab2GLNzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 09:55:40 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:38632 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab2GLNzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 09:55:38 -0400
Date: Thu, 12 Jul 2012 09:47:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen pv-on-hvm: add pfn_is_ram helper for
 kdump
Message-ID: <20120712134703.GD5204@phenom.dumpdata.com>
References: <1342083605-15371-1-git-send-email-olaf@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342083605-15371-1-git-send-email-olaf@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 11:00:05AM +0200, Olaf Hering wrote:
> Register pfn_is_ram helper speed up reading /proc/vmcore in the kdump
> kernel. See commit message of 997c136f518c ("fs/proc/vmcore.c: add hook
> to read_from_oldmem() to check for non-ram pages") for details.

What about the 'unregister_oldmem_pfn_is_ram' call? Should this
be implemented here as well?

Comments below.

> 
> The new function is currently only enabled for reading /proc/vmcore.
> Later it will be used also for the kexec kernel. Since that requires
> more changes in the generic kernel make it static.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> ---
>  arch/x86/xen/mmu.c |   39 +++++++++++++++++++++++++++++++++++++++
>  1 files changed, 39 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 3a73785..ac876c2 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -47,6 +47,7 @@
>  #include <linux/gfp.h>
>  #include <linux/memblock.h>
>  #include <linux/seq_file.h>
> +#include <linux/crash_dump.h>

Should this also have an #idef CONFIG_PROC_VMCORE?
Or is it going to compile OK without CONFIG_PROC_VMCORE defined?

>  
>  #include <trace/events/xen.h>
>  
> @@ -2245,6 +2246,41 @@ void xen_destroy_contiguous_region(unsigned long vstart, unsigned int order)
>  EXPORT_SYMBOL_GPL(xen_destroy_contiguous_region);
>  
>  #ifdef CONFIG_XEN_PVHVM
> +#ifdef CONFIG_PROC_VMCORE
> +/*
> + * This function is used in two contexts:
> + * - the kdump kernel has to check wether a pfn of the crashed kernel

s/wether/whether

> + *   was a ballooned page. vmcore is using this function to decide
> + *   wether to access a pfn of the crashed kernel.

s/wether/wheter

> + * - the kexec kernel has to check wether a pfn was ballooned by the

Ditto.

> + *   previous kernel. If the pfn is ballooned, handle it properly.

. and by handle it properly you mean return -ENXIO?

> + * Returns 0 if the pfn is not backed by a RAM page.
> + */
> +static int xen_oldmem_pfn_is_ram(unsigned long pfn)
> +{
> +	struct xen_hvm_get_mem_type a;

Can you make this have already initialized values, like:

	struct xen_hvm_get_mem_type a = {
		.domid = DOMID_SELF;
		.pfn = pfn
	};

Also is this hypercall new? Or has it been in existence for some time?

> +	int ram;
> +
> +	a.domid = DOMID_SELF;
> +	a.pfn = pfn;
> +	if (HYPERVISOR_hvm_op(HVMOP_get_mem_type, &a))
> +		return -ENXIO;
> +
> +	switch (a.mem_type) {
> +		case HVMMEM_mmio_dm:
> +			ram = 0;
> +			break;
> +		case HVMMEM_ram_rw:
> +		case HVMMEM_ram_ro:
> +		default:
> +			ram = 1;
> +			break;
> +	}
> +
> +	return ram;
> +}
> +#endif
> +
>  static void xen_hvm_exit_mmap(struct mm_struct *mm)
>  {
>  	struct xen_hvm_pagetable_dying a;
> @@ -2275,6 +2311,9 @@ void __init xen_hvm_init_mmu_ops(void)
>  {
>  	if (is_pagetable_dying_supported())
>  		pv_mmu_ops.exit_mmap = xen_hvm_exit_mmap;
> +#ifdef CONFIG_PROC_VMCORE
> +	register_oldmem_pfn_is_ram(&xen_oldmem_pfn_is_ram);
> +#endif
>  }
>  #endif
>  
> -- 
> 1.7.3.4
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
