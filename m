Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab1DNXdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 19:33:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab1DNXdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 19:33:51 -0400
Date: Fri, 15 Apr 2011 01:32:26 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: raz ben yehuda <raziebe@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        riel@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org
Subject: Re: 2.6.38 page_test regression
Message-ID: <20110414233226.GI15707@random.random>
References: <1302692638.15225.14.camel@raz.scalemp.com>
 <20110413125146.GR29444@random.random>
 <1302703579.17536.1.camel@raz.scalemp.com>
 <20110413172127.GB5734@random.random>
 <1302781754.5098.13.camel@raz.scalemp.com>
 <20110414150925.GD15707@random.random>
 <1302811643.10051.8.camel@raz.scalemp.com>
 <20110414215327.GI11871@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414215327.GI11871@csn.ul.ie>
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

This was fast...

This definitely fixes a regression: the previous pte_alloc_map would
have checked pte_none (pte_none not safe anymore but pte_present is
safe) before taking the PT lock in __pte_alloc_map.

It's also obviously safe, the only chance a huge pmd can materialize
from under us is it wasn't present and it's correct conversion of the
old pte_alloc_one exactly. So we need it.

I'm quite optimistic it'll solve the problem.

Thanks a lot,
Andrea
