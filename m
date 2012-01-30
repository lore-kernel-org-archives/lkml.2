Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab2A3GXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 01:23:48 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35252 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2A3GXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 01:23:47 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 30 Jan 2012 15:22:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] thp: optimize away unnecessary page table locking
Message-Id: <20120130152212.3a6a2039.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1327705373-29395-3-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1327705373-29395-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1327705373-29395-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jan 2012 18:02:49 -0500
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Currently when we check if we can handle thp as it is or we need to
> split it into regular sized pages, we hold page table lock prior to
> check whether a given pmd is mapping thp or not. Because of this,
> when it's not "huge pmd" we suffer from unnecessary lock/unlock overhead.
> To remove it, this patch introduces a optimized check function and
> replace several similar logics with it.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: David Rientjes <rientjes@google.com>
> 
> Changes since v3:
>   - Fix likely/unlikely pattern in pmd_trans_huge_stable()
>   - Change suffix from _stable to _lock
>   - Introduce __pmd_trans_huge_lock() to avoid micro-regression
>   - Return 1 when wait_split_huge_page path is taken
> 
> Changes since v2:
>   - Fix missing "return 0" in "thp under splitting" path
>   - Remove unneeded comment
>   - Change the name of check function to describe what it does
>   - Add VM_BUG_ON(mmap_sem)



> +/*
> + * Returns 1 if a given pmd maps a stable (not under splitting) thp,
> + * -1 if the pmd maps thp under splitting, 0 if the pmd does not map thp.
> + *
> + * Note that if it returns 1, this routine returns without unlocking page
> + * table locks. So callers must unlock them.
> + */


Seems nice clean up but... why you need to return (-1, 0, 1) ?

It seems the caller can't see the difference between -1 and 0.

Why not just return 0 (not locked) or 1 (thp found and locked) ?

Thanks,
-Kame

> +int __pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma)
> +{
> +	spin_lock(&vma->vm_mm->page_table_lock);
>  	if (likely(pmd_trans_huge(*pmd))) {
>  		if (unlikely(pmd_trans_splitting(*pmd))) {
> -			spin_unlock(&mm->page_table_lock);
> +			spin_unlock(&vma->vm_mm->page_table_lock);
>  			wait_split_huge_page(vma->anon_vma, pmd);
> +			return -1;
>  		} else {
> -			pmd_t entry;
> -
> -			entry = pmdp_get_and_clear(mm, addr, pmd);
> -			entry = pmd_modify(entry, newprot);
> -			set_pmd_at(mm, addr, pmd, entry);
> -			spin_unlock(&vma->vm_mm->page_table_lock);
> -			ret = 1;
> +			/* Thp mapped by 'pmd' is stable, so we can
> +			 * handle it as it is. */
> +			return 1;
>  		}
> -	} else
> -		spin_unlock(&vma->vm_mm->page_table_lock);
> -
> -	return ret;
> +	}
> +	spin_unlock(&vma->vm_mm->page_table_lock);
> +	return 0;
>  }
>  
>  pmd_t *page_check_address_pmd(struct page *page,
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

