Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab1LSTRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 14:17:09 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:42325 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1LSTRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 14:17:08 -0500
X-Greylist: delayed 1248 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Dec 2011 14:17:08 EST
Message-ID: <4EEF8D81.4080301@ah.jp.nec.com>
Date: Mon, 19 Dec 2011 14:16:17 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Organization: NEC Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.24) Gecko/20111103 Thunderbird/3.1.16
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/3] pagemap: avoid splitting thp when reading /proc/pid/pagemap
References: <1324319919-31720-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1324319919-31720-2-git-send-email-n-horiguchi@ah.jp.nec.com> <alpine.DEB.2.00.1112191044300.19949@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1112191044300.19949@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 10:48:17AM -0800, David Rientjes wrote:
> On Mon, 19 Dec 2011, Naoya Horiguchi wrote:
...
> > @@ -666,10 +685,33 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> >  	pte_t *pte;
> >  	int err = 0;
> >  
> > -	split_huge_page_pmd(walk->mm, pmd);
> > -
> >  	/* find the first VMA at or above 'addr' */
> >  	vma = find_vma(walk->mm, addr);
> > +
> > +	spin_lock(&walk->mm->page_table_lock);
> 
> pagemap_pte_range() could potentially be called a _lot_, so I'd recommend 
> optimizing this by checking for pmd_trans_huge() prior to taking 
> page_table_lock and then rechecking after grabbing it with likely().

OK, I'll try it.
Similar logic is used on smaps_pte_range() and gather_pte_stats(),
so I think it's better to write a separate patch for this optimization.

> > +	if (pmd_trans_huge(*pmd)) {
> > +		if (pmd_trans_splitting(*pmd)) {
> > +			spin_unlock(&walk->mm->page_table_lock);
> > +			wait_split_huge_page(vma->anon_vma, pmd);
> > +		} else {
> > +			u64 pfn = PM_NOT_PRESENT;
> 
> This doesn't need to be initialized and it would probably be better to 
> declare "pfn" at the top-level of this function since it's later used for 
> the non-thp case.

Agreed.
I unify two declarations of "pfn" at the beginning of the function.

Thank you for nice feedback.
Naoya
