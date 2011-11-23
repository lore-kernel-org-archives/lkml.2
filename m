Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab1KWAKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:10:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935Ab1KWAKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:10:12 -0500
Date: Wed, 23 Nov 2011 01:10:08 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: GuanJun He <heguanbo@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][mm/memory.c]: transparent hugepage check condition missed
Message-ID: <20111123001008.GF8397@redhat.com>
References: <CAGW+__+9jOaSdmqGcdCTi+EnRyyNcZ3hFqdqpf3Nxjqb8ZQPbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGW+__+9jOaSdmqGcdCTi+EnRyyNcZ3hFqdqpf3Nxjqb8ZQPbw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Oct 31, 2011 at 06:56:57PM +0800, GuanJun He wrote:
> For the transparent hugepage module still does not support
> tmpfs and cache,the check condition should always be checked
> to make sure that it only affect the anonymous maps, the
> original check condition missed this, this patch is to fix this.
> Otherwise,the hugepage may affect the file-backed maps,
> then the cache for the small-size pages will be unuseful,
> and till now there is still no implementation for hugepage's cache.
> 
> Signed-off-by: Guanjun He <gjhe@suse.com>
> ---
>  mm/memory.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index a56e3ba..79b85fe 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3475,7 +3475,8 @@ int handle_mm_fault(struct mm_struct *mm, struct
> vm_area_struct *vma,
>  		if (pmd_trans_huge(orig_pmd)) {
>  			if (flags & FAULT_FLAG_WRITE &&
>  			    !pmd_write(orig_pmd) &&
> -			    !pmd_trans_splitting(orig_pmd))
> +			    !pmd_trans_splitting(orig_pmd) &&
> +			    !vma->vm_ops)
>  				return do_huge_pmd_wp_page(mm, vma, address,
>  							   pmd, orig_pmd);
>  			return 0;

Not needed, this is the cow case and pmd_trans_huge can't be true if
vm_ops is not null. That's already checked a few lines before the
above code and in collapse_huge_page for khugepaged.

Thanks.
