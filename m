Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab2ANRAn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 12:00:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362Ab2ANRAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 12:00:42 -0500
Date: Sat, 14 Jan 2012 18:00:26 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] pagemap: avoid splitting thp when reading
 /proc/pid/pagemap
Message-ID: <20120114170026.GF3236@redhat.com>
References: <1326396898-5579-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1326396898-5579-2-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326396898-5579-2-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 02:34:53PM -0500, Naoya Horiguchi wrote:
> +		if (pmd_trans_splitting(*pmd)) {
> +			spin_unlock(&walk->mm->page_table_lock);
> +			wait_split_huge_page(vma->anon_vma, pmd);
> +		} else {
> +			for (; addr != end; addr += PAGE_SIZE) {
> +				unsigned long offset = (addr & ~PAGEMAP_WALK_MASK)
> +					>> PAGE_SHIFT;
> +				pfn = thp_pte_to_pagemap_entry(*(pte_t *)pmd,
> +							       offset);

What is this that then morphs into a pme (which still has a cast
inside its creation)? thp_pte_to_pagemap_entry don't seem to be passed
ptes too. The only case where it is valid to do a cast like that is
when a function is used by both ptes sand pmds and the code tends to
work for both with minimal modification to differentiate the two
cases. Considering the function that gets the cast is called thp_ this
is hardly the case here.

Why don't you pass the pmd and then do "if (pmd_present(pmd))
page_to_pfn(pmd_page(pmd)) ? What's the argument for the cast. I'm
just reviewing this series and maybe it was covered in previous
versions.

I don't get this pme thing for something as trivial as above that
shouldn't require any cast at all.
