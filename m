Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab1KABJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 21:09:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:46282 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab1KABJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 21:09:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,435,1315206000"; 
   d="scan'208";a="31980912"
Subject: Re: [PATCH][mm/memory.c]: transparent hugepage check condition
 missed
From: Shaohua Li <shaohua.li@intel.com>
To: Guanjun He <gjhe@suse.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1320049412-12642-1-git-send-email-gjhe@suse.com>
References: <transparent-hugepage-check-condition-miss>
	 <1320049412-12642-1-git-send-email-gjhe@suse.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Nov 2011 09:18:08 +0800
Message-ID: <1320110288.22361.190.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-31 at 16:23 +0800, Guanjun He wrote:
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
> @@ -3475,7 +3475,8 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  		if (pmd_trans_huge(orig_pmd)) {
>  			if (flags & FAULT_FLAG_WRITE &&
>  			    !pmd_write(orig_pmd) &&
> -			    !pmd_trans_splitting(orig_pmd))
> +			    !pmd_trans_splitting(orig_pmd) &&
> +			    !vma->vm_ops)
>  				return do_huge_pmd_wp_page(mm, vma, address,
>  							   pmd, orig_pmd);
>  			return 0;
so if vma->vm_ops != NULL, how could the pmd_trans_huge(orig_pmd) be
true? We never enable THP if vma->vm_ops != NULL.

