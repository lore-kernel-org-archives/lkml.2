Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1JNIwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 04:52:24 -0400
Received: from smail2.alcatel.fr ([64.208.49.57]:46394 "EHLO smail2.alcatel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab1JNIwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 04:52:22 -0400
Message-ID: <4E97F83F.6050501@alcatel-lucent.com>
Date: Fri, 14 Oct 2011 10:52:15 +0200
From: Thanh-Lam NGUYEN <thanh-lam.nguyen@alcatel-lucent.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] binfmt_elf.c: core file shrinking
References: <4E946279.8090800@alcatel-lucent.com>
In-Reply-To: <4E946279.8090800@alcatel-lucent.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for upping the patch,
as it is my first contribution I would like to know if there is any
problem with it.

Best regard
Thanh lam NGUYEN

On 11/10/2011 17:36, Thanh-Lam NGUYEN wrote:

> The vma_shrink function looks for the 1st allocated and the last
> allocated page. Only this part is dumped to the disk (the virual
> start address and the size are dupdated to reflect the new dumped
> information).
> 
> Signed-off-by: Thanh Lam NGUYEN <thanh-lam.nguyen@alcatel-lucent.com>
> Signed-off-by: Benjamin ZORES <Benjamin.Zores@alcatel-lucent.com>
> ---
>  linux/fs/binfmt_elf.c |   54
> ++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 55 insertions(+), 4 deletions(-)
> 
> --- linux/fs/binfmt_elf.c
> +++ linux/fs/binfmt_elf.c
> @@ -1085,6 +1085,48 @@
>   * Jeremy Fitzhardinge <jeremy@sw.oz.au>
>   */
> 
> +/*
> + * Search for 1st and last allocated page from vma_start to vma_end.
> + * Update vma_start and vma_end to reflect the result.
> + */
> +void vma_shrink(struct vm_area_struct *vma, unsigned long *vma_start,
> +		unsigned long *vma_end)
> +{
> +	int allocated;
> +	unsigned long start, addr, end;
> +
> +	allocated = 0;
> +	start = end = *vma_start;
> +	for (addr = *vma_start; _addr < *vma_end; addr += PAGE_SIZE) {
> +		struct page *page;
> +		if (get_user_pages(current, current->mm, addr, 1, 0, 1,
> +				   &page, NULL) <= 0) {
> +			/* NO PAGE */
> +			if (!allocated)
> +				start = addr;
> +		} else {
> +			if (page == ZERO_PAGE(0)) {
> +				/* ZERO PAGE */
> +				if (!allocated)
> +					start = addr;
> +			} else {
> +				/* ALLOCATED PAGE */
> +				if (!allocated)
> +					start = addr;
> +				end = addr;
> +				allocated = 1;
> +			}
> +			page_cache_release(page);
> +		}
> +	}
> +	if (end < start)
> +		end = start;
> +	if (allocated)
> +		end += PAGE_SIZE;
> +	*vma_start = start;
> +	*vma_end = end;
> +}
> +
>  /*
>   * Decide what to dump of a segment, part, all or none.
>   */
> @@ -1980,13 +2022,19 @@ static int elf_core_dump(struct coredump_params
> *cprm)
>  	for (vma = first_vma(current, gate_vma); vma != NULL;
>  			vma = next_vma(vma, gate_vma)) {
>  		struct elf_phdr phdr;
> +		unsigned long start = vma->vm_start;
> +		unsigned long end = vma->vm_end;
>   		phdr.p_type = PT_LOAD;
>  		phdr.p_offset = offset;
> -		phdr.p_vaddr = vma->vm_start;
>  		phdr.p_paddr = 0;
>  		phdr.p_filesz = vma_dump_size(vma, cprm->mm_flags);
> -		phdr.p_memsz = vma->vm_end - vma->vm_start;
> +		if (phdr.p_filesz) {
> +			vma_shrink(vma, &start, &end);
> +			phdr.p_filesz = end-start;
> +		}
> +		phdr.p_vaddr = start;
> +		phdr.p_memsz = vma->vm_end - phdr.p_vaddr;
>  		offset += phdr.p_filesz;
>  		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;
>  		if (vma->vm_flags & VM_WRITE)
> @@ -2018,11 +2066,15 @@ static int elf_core_dump(struct coredump_params
> *cprm)
>  	for (vma = first_vma(current, gate_vma); vma != NULL;
>  			vma = next_vma(vma, gate_vma)) {
>  		unsigned long addr;
> +		unsigned long start;
>  		unsigned long end;
>  -		end = vma->vm_start + vma_dump_size(vma, cprm->mm_flags);
> +		start = vma->vm_start;
> +		end = start + vma_dump_size(vma, cprm->mm_flags);
> +		if (start < end)
> +			vma_shrink(vma, &start, &end);
>  -		for (addr = vma->vm_start; addr < end; addr += PAGE_SIZE) {
> +		for (addr = start; addr < end; addr += PAGE_SIZE) {
>  			struct page *page;
>  			int stop;
> 
> ---
> =~=~=~=~=~=~=~=~=~=~=~=~==~=~=~=~=~=~=~=~=~=~=~=~=~=~=
> Thanh lam NGUYEN
> Prestataire externe ALTEN        | ALTEN Subcontractor
> pour ALCATEL-LUCENT              | in ALCATEL-LUCENT
> 
> email: tlnguyen@webmail.alten.fr
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 



-- 
=~=~=~=~=~=~=~=~=~=~=~=~==~=~=~=~=~=~=~=~=~=~=~=~=~=~=
Thanh lam NGUYEN
Prestataire externe ALTEN        | ALTEN Subcontractor
pour ALCATEL-LUCENT              | in ALCATEL-LUCENT

Tel: +333906 77095

Equipe/Team: SWINT
email: tlnguyen@webmail.alten.fr
