Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab2LJLO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:14:57 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46079 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106Ab2LJLOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:14:55 -0500
Date: Mon, 10 Dec 2012 11:13:46 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the akpm tree with the tip tree
Message-ID: <20121210111346.GB6988@mudshark.cambridge.arm.com>
References: <20121210190139.4ae77c7b70fa24daacf2c9cb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121210190139.4ae77c7b70fa24daacf2c9cb@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

On Mon, Dec 10, 2012 at 08:01:39AM +0000, Stephen Rothwell wrote:
> Today's linux-next merge of the akpm tree got a conflict in mm/memory.c
> between changes in commits from the tip tree and commit "mm: thp: set the
> accessed flag for old pages on access fault" from the akpm tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary
> (no action is required).

[...]

> diff --cc mm/memory.c
> index 8022526,60201d5..0000000
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@@ -3812,15 -3620,18 +3812,17 @@@ retry
>   							  pmd, flags);
>   	} else {
>   		pmd_t orig_pmd = *pmd;
>  -		int ret = 0;
>  +		int ret;
>   
>   		barrier();
>  -		if (pmd_trans_huge(orig_pmd) && !pmd_trans_splitting(orig_pmd)) {
>  +		if (pmd_trans_huge(orig_pmd)) {

This change worries me a bit wrt the huge_pmd_set_accessed function I
introduce below. Unfortunately, current -next doesn't seem to include it, so
I can't see whether do_huge_pmd_numa_page / do_huge_pmd_wp_page have been
changed to deal with the splitting or whether the check has been moved
earlier.

Will

> + 			unsigned int dirty = flags & FAULT_FLAG_WRITE;
> + 
>  -			if (pmd_numa(vma, orig_pmd)) {
>  -				do_huge_pmd_numa_page(mm, vma, address, pmd,
>  -						      flags, orig_pmd);
>  -			}
>  +			if (pmd_numa(*pmd))
>  +				return do_huge_pmd_numa_page(mm, vma, address,
>  +							     orig_pmd, pmd);
>   
> - 			if ((flags & FAULT_FLAG_WRITE) && !pmd_write(orig_pmd)) {
> + 			if (dirty && !pmd_write(orig_pmd)) {
>   				ret = do_huge_pmd_wp_page(mm, vma, address, pmd,
>   							  orig_pmd);
>   				/*
> @@@ -3830,10 -3641,12 +3832,13 @@@
>   				 */
>   				if (unlikely(ret & VM_FAULT_OOM))
>   					goto retry;
>  +				return ret;
> + 			} else {
> + 				huge_pmd_set_accessed(mm, vma, address, pmd,
> + 						      orig_pmd, dirty);
>   			}
>   
>  -			return ret;
>  +			return 0;
>   		}
>   	}
>   


