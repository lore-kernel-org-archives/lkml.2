Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab2GaVYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 17:24:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631Ab2GaVYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 17:24:20 -0400
Message-ID: <50184CF3.8040505@redhat.com>
Date: Tue, 31 Jul 2012 17:24:03 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@kernel.org, oleg@redhat.com, pjt@google.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, Lee.Schermerhorn@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/19] mm, mpol: Use special PROT_NONE to migrate pages
References: <20120731191204.540691987@chello.nl> <20120731192808.950441936@chello.nl>
In-Reply-To: <20120731192808.950441936@chello.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 03:12 PM, Peter Zijlstra wrote:

> +	if (unlikely(pmd_trans_splitting(entry))) {
> +		spin_unlock(&mm->page_table_lock);
> +		wait_split_huge_page(vma->anon_vma, pmd);
> +		return;
> +	}
> +
> +#ifdef CONFIG_NUMA
> +	page = pmd_page(entry);
> +	VM_BUG_ON(!PageCompound(page) || !PageHead(page));
> +
> +	get_page(page);
> +	spin_unlock(&mm->page_table_lock);
> +
> +	/*
> +	 * XXX should we serialize against split_huge_page ?
> +	 */

I believe we are already serialized here, because we check
for pmd_trans_splitting while holding the page table lock.

The THP code grabs the page table lock when modifying this
status, so we should be good.

> +	/*
> +	 * Due to lacking code to migrate thp pages, we'll split
> +	 * (which preserves the special PROT_NONE) and re-take the
> +	 * fault on the normal pages.
> +	 */
> +	split_huge_page(page);
> +	put_page(page);
> +	return;

Likewise, the THP code serializes split_huge_page, and has
protection against multiple simultaneous invocations of
split_huge_page.

A second invocation of split_huge_page will see that the
page was already split, and it will bail out.

> +do_fixup:
> +	spin_lock(&mm->page_table_lock);
> +	if (unlikely(!pmd_same(*pmd, entry)))
> +		goto out_unlock;

If the THP was split for another reason than a NUMA
fault, the !pmd_same check here should result in us
doing the right thing automatically.

I believe this code is correct.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
