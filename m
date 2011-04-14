Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab1DNXVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 19:21:46 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50463 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482Ab1DNXVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 19:21:45 -0400
Date: Fri, 15 Apr 2011 00:16:48 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: raz ben yehuda <raziebe@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>, riel@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org
Subject: Re: 2.6.38 page_test regression
Message-ID: <20110414231648.GA30898@csn.ul.ie>
References: <1302692638.15225.14.camel@raz.scalemp.com>
 <20110413125146.GR29444@random.random>
 <1302703579.17536.1.camel@raz.scalemp.com>
 <20110413172127.GB5734@random.random>
 <1302781754.5098.13.camel@raz.scalemp.com>
 <20110414150925.GD15707@random.random>
 <1302811643.10051.8.camel@raz.scalemp.com>
 <20110414215327.GI11871@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110414215327.GI11871@csn.ul.ie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 10:53:27PM +0100, Mel Gorman wrote:
> On Thu, Apr 14, 2011 at 11:07:23PM +0300, raz ben yehuda wrote:
> > bah. Mel is correct. I did mean page_test  ( in my defense it is in the
> > msg ).
> > Here some more information:
> > 1. I manage to lower the regression to 2 sha1's:
> >     	32dba98e085f8b2b4345887df9abf5e0e93bfc12 to
> > 71e3aac0724ffe8918992d76acfe3aad7d8724a5. 
> > 	though I had to remark wait_split_huge_page for the sake of
> > compilation. up to 32dba98e085f8b2b4345887df9abf5e0e93bfc12 there is no
> > regression.
> > 
> > 2. I booted 2.6.37-rc5 you gave me. same regression is there. 
> 
> Extremely long shot - try this patch.
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index c50a195..a39baaf 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3317,7 +3317,7 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  	 * run pte_offset_map on the pmd, if an huge pmd could
>  	 * materialize from under us from a different thread.
>  	 */
> -	if (unlikely(__pte_alloc(mm, vma, pmd, address)))
> +	if (unlikely(!pmd_present(*(pmd))) && __pte_alloc(mm, vma, pmd, address))
>  		return VM_FAULT_OOM;
>  	/* if an huge pmd materialized from under us just retry later */
>  	if (unlikely(pmd_trans_huge(*pmd)))

The results for this patch on my own tests at least are

AIM9
                      vmr-aim9          vmr-aim9          vmr-aim9          vmr-aim9          vmr-aim9       aim9-2.6.39       aim9-2.6.39
                2.6.32-vanilla    2.6.36-vanilla    2.6.37-vanilla    2.6.38-vanilla      2.6.38-noway       rc3-vanilla         rc3-noway
creat-clo      365.47 ( 0.00%)   385.25 ( 5.13%)   411.82 (11.25%)   446.10 (18.07%)   427.78 (14.57%)   383.50 ( 4.70%)   377.63 ( 3.22%)
page_test       43.21 ( 0.00%)    41.44 (-4.26%)    43.71 ( 1.15%)    38.10 (-13.40%)    41.87 (-3.20%)    36.08 (-19.75%)    44.25 ( 2.36%)
brk_test        45.19 ( 0.00%)    46.38 ( 2.57%)    51.17 (11.68%)    52.45 (13.84%)    51.61 (12.43%)    51.52 (12.29%)    54.24 (16.68%)
exec_test      387.20 ( 0.00%)   458.92 (15.63%)   450.60 (14.07%)   382.00 (-1.36%)   457.64 (15.39%)   378.82 (-2.21%)   458.70 (15.59%)
fork_test       61.59 ( 0.00%)    67.87 ( 9.26%)    66.65 ( 7.59%)    60.11 (-2.47%)    67.44 ( 8.67%)    59.14 (-4.14%)    66.24 ( 7.03%)
MMTests Statistics: duration
Total Elapsed Time (seconds)                613.03    611.99    611.85    611.90    612.36    612.62    612.26

The "noway" kernel is with the patch applied which might summarise how I
feel about it.

The change is minor but emulates what pte_alloc_map() was doing
with the pmd_present check. I don't know why it makes such a big
difference. The disassembly is very similar except that registers are
used differently but it's a minor enough difference that I wouldn't
expect this big a performance difference. However, profiles indicate
that we go from spending 10.6382% of the time in clear_page_c to 9.54%
but I admit the profiles are noisy because they are over all tests,
not just page_test.

Theories better than slightly-different-register-use are welcome.

-- 
Mel Gorman
SUSE Labs
