Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab1CWNhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:37:19 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:53155 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab1CWNhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:37:17 -0400
Message-ID: <4D89F602.5060000@snapgear.com>
Date: Wed, 23 Mar 2011 23:30:42 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: <uclinux-dev@uclinux.org>, David Howells <dhowells@redhat.com>,
        Paul Mundt <lethal@linux-sh.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NOMMU: support SMP dynamic percpu_alloc
References: <1300826506-23192-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1300826506-23192-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/03/11 06:41, Mike Frysinger wrote:
> From: Graf Yang<graf.yang@analog.com>
>
> The percpu code requires more functions to be implemented in the mm core
> which nommu currently does not provide.  So add inline implementations
> since these are largely meaningless on nommu systems.
>
> Signed-off-by: Graf Yang<graf.yang@analog.com>
> Signed-off-by: Mike Frysinger<vapier@gentoo.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>


> ---
>   include/linux/vmalloc.h |   32 ++++++++++++++++++++++++++++++++
>   1 files changed, 32 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index 81f8622..01bbeb4 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -98,10 +98,27 @@ extern struct vm_struct *remove_vm_area(const void *addr);
>
>   extern int map_vm_area(struct vm_struct *area, pgprot_t prot,
>   			struct page ***pages);
> +#ifdef CONFIG_MMU
>   extern int map_kernel_range_noflush(unsigned long start, unsigned long size,
>   				    pgprot_t prot, struct page **pages);
>   extern void unmap_kernel_range_noflush(unsigned long addr, unsigned long size);
>   extern void unmap_kernel_range(unsigned long addr, unsigned long size);
> +#else
> +static inline int
> +map_kernel_range_noflush(unsigned long start, unsigned long size,
> +			pgprot_t prot, struct page **pages)
> +{
> +	return size>>  PAGE_SHIFT;
> +}
> +static inline void
> +unmap_kernel_range_noflush(unsigned long addr, unsigned long size)
> +{
> +}
> +static inline void
> +unmap_kernel_range(unsigned long addr, unsigned long size)
> +{
> +}
> +#endif
>
>   /* Allocate/destroy a 'vmalloc' VM area. */
>   extern struct vm_struct *alloc_vm_area(size_t size);
> @@ -119,11 +136,26 @@ extern struct vm_struct *vmlist;
>   extern __init void vm_area_register_early(struct vm_struct *vm, size_t align);
>
>   #ifdef CONFIG_SMP
> +# ifdef CONFIG_MMU
>   struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
>   				     const size_t *sizes, int nr_vms,
>   				     size_t align);
>
>   void pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms);
> +# else
> +static inline struct vm_struct **
> +pcpu_get_vm_areas(const unsigned long *offsets,
> +		const size_t *sizes, int nr_vms,
> +		size_t align)
> +{
> +	return NULL;
> +}
> +
> +static inline void
> +pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms)
> +{
> +}
> +# endif
>   #endif
>
>   #endif /* _LINUX_VMALLOC_H */


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
