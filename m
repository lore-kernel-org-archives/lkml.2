Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab1FVPEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 11:04:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758020Ab1FVPEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 11:04:31 -0400
Date: Wed, 22 Jun 2011 17:03:50 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Nai Xia <nai.xia@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Hugh Dickins <hughd@google.com>, Chris Wright <chrisw@sous-sol.org>,
        Rik van Riel <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] mmu_notifier, kvm: Introduce dirty bit tracking in spte
 and mmu notifier to help KSM dirty bit tracking
Message-ID: <20110622150350.GX20843@redhat.com>
References: <201106212055.25400.nai.xia@gmail.com>
 <201106212132.39311.nai.xia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106212132.39311.nai.xia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 09:32:39PM +0800, Nai Xia wrote:
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index d48ec60..b407a69 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -4674,6 +4674,7 @@ static int __init vmx_init(void)
>  		kvm_mmu_set_mask_ptes(0ull, 0ull, 0ull, 0ull,
>  				VMX_EPT_EXECUTABLE_MASK);
>  		kvm_enable_tdp();
> +		kvm_dirty_update = 0;
>  	} else
>  		kvm_disable_tdp();
>  

Why not return !shadow_dirty_mask instead of adding a new var?

>  struct mmu_notifier_ops {
> +	int (*dirty_update)(struct mmu_notifier *mn,
> +			     struct mm_struct *mm);
> +

Needs some docu.

I think dirty_update isn't self explanatory name. I think
"has_test_and_clear_dirty" would be better.

If we don't flush the smp tlb don't we risk that we'll insert pages in
the unstable tree that are volatile just because the dirty bit didn't
get set again on the spte?

The first patch I guess it's a sign of hugetlbfs going a little over
the edge in trying to mix with the core VM... Passing that parameter
&need_pte_unmap all over the place not so nice, maybe it'd be possible
to fix within hugetlbfs to use a different method to walk the hugetlb
vmas. I'd prefer that if possible.

Thanks,
Andrea
