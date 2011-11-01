Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab1KAM0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 08:26:09 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:38913 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab1KAM0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 08:26:08 -0400
Subject: Re: [PATCH][mm:] adjust the logic of checking THP
From: Paul Bolle <pebolle@tiscali.nl>
To: Guanjun He <heguanbo@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1320147705-15117-1-git-send-email-heguanbo@gmail.com>
References: <shaohua.li@intel.com;linux-mm@kvack.org;linux-kernel@vger.kernel.org>
	 <1320147705-15117-1-git-send-email-heguanbo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Nov 2011 13:26:05 +0100
Message-ID: <1320150365.14409.160.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps a summary would help the people actually knowledgeable about mm
understand why this adjustment is needed.

I'll just mention a few obvious things.

On Tue, 2011-11-01 at 19:41 +0800, Guanjun He wrote:
> Signed-off-by: Guanjun He <heguanbo@gmail.com>
> ---
>  mm/memory.c |   32 ++++++++++++++++++--------------
>  1 files changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index a56e3ba..d6dd6b3 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3465,20 +3465,24 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
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
> -			return 0;
> +	if (transparent_hugepage_enabled(vma)) {
> +		if(pmd_none(*pmd)){

codingstyle (scripts/checkpatch.pl would have caught that one).

> +			if (!vma->vm_ops)
> +				return do_huge_pmd_anonymous_page(mm, vma, address,
> +						pmd, flags);
> +		}
> +		else
> +		{

codingstyle (ditto). There's probably more.

> +			pmd_t orig_pmd = *pmd;
> +			barrier();
> +			if (pmd_trans_huge(orig_pmd)) {
> +				if (flags & FAULT_FLAG_WRITE &&
> +						!pmd_write(orig_pmd) &&
> +						!pmd_trans_splitting(orig_pmd))
> +					return do_huge_pmd_wp_page(mm, vma, address,
> +							pmd, orig_pmd);
> +				return 0;
> +			}
>  		}
>  	}
>  


Paul Bolle

