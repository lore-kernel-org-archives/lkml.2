Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab1KWAEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:04:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab1KWAET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:04:19 -0500
Date: Wed, 23 Nov 2011 01:04:17 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Guanjun He <heguanbo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][mm] adjust the logic of checking THP
Message-ID: <20111123000417.GE8397@redhat.com>
References: <1320215670-10157-1-git-send-email-heguanbo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320215670-10157-1-git-send-email-heguanbo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 02:34:30PM +0800, Guanjun He wrote:
> 
> Acturally, pmd_trans_huge(orig_pmd) only checks the _PAGE_PSE bits,
> it's a pmd entry bits, only mark a size, not a flag;As one can easily 
> create the same pmd entry bits for some special use,then the check 
> will get confused.And this patch is to adjust the logic to use the flag, 
> it can perfectly avoid this potential issuse,and basically no impact 
> to the current code.

You can't use _PAGE_PSE for special use for the pmd. Besides this is
common code, archs without such bit can define pmd_trans_huge to
return 0 like it happens with TRANSPARENT_HUGEPAGE=n.

> diff --git a/mm/memory.c b/mm/memory.c
> index a56e3ba..a76b17f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3465,20 +3465,22 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  	pmd = pmd_alloc(mm, pud, address);
>  	if (!pmd)
>  		return VM_FAULT_OOM;
> -	if (pmd_none(*pmd) && transparent_hugepage_enabled(vma)) {
> -		if (!vma->vm_ops)
> -			return do_huge_pmd_anonymous_page(mm, vma, address,
> -							  pmd, flags);
> -	} else {
> -		pmd_t orig_pmd = *pmd;
> -		barrier();
> -		if (pmd_trans_huge(orig_pmd)) {
> -			if (flags & FAULT_FLAG_WRITE &&
> -			    !pmd_write(orig_pmd) &&
> -			    !pmd_trans_splitting(orig_pmd))
> -				return do_huge_pmd_wp_page(mm, vma, address,
> -							   pmd, orig_pmd);
> +	if (transparent_hugepage_enabled(vma)) {
> +		if (pmd_none(*pmd)) {
> +			if (!vma->vm_ops)
> +				return do_huge_pmd_anonymous_page(mm, vma, address,
> +								  pmd, flags);
> +		} else {
> +			pmd_t orig_pmd = *pmd;
> +			barrier();
> +			if (pmd_trans_huge(orig_pmd)) {
> +				if (flags & FAULT_FLAG_WRITE &&
> +				    !pmd_write(orig_pmd) &&
> +				    !pmd_trans_splitting(orig_pmd))
> +					return do_huge_pmd_wp_page(mm, vma, address,
> +								   pmd, orig_pmd);
>  			return 0;
> +			}

This will infinite loop if you disable THP at runtime while some
mapping needing cow is established.
