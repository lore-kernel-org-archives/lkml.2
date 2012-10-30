Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab2J3H0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 03:26:07 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40282 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab2J3H0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 03:26:03 -0400
Date: Tue, 30 Oct 2012 08:25:58 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] s390: Add pmd_mknotpresent()
Message-ID: <20121030072558.GB4537@gmail.com>
References: <20121018172201.b81dcc8fe40868256f532364@canb.auug.org.au>
 <20121018182642.2a541275@thinkpad>
 <20121028131014.GA10754@gmail.com>
 <20121029150048.21c062cf@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029150048.21c062cf@thinkpad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gerald Schaefer <gerald.schaefer@de.ibm.com> wrote:

> On Sun, 28 Oct 2012 14:10:14 +0100
> Ingo Molnar <mingo@kernel.org> wrote:
> 
> > 
> > There's a related problem on s390: other THP implementations 
> > have pmd_mknotpresent() while s390 not, resulting in:
> > 
> >   mm/huge_memory.c:1543:2: error: implicit declaration of function 'pmd_mknotpresent'
> > 
> > The (untested!) patch below adds the s390 version of this 
> > method.
> > 
> > Gerald, Martin, did I get the S390 details right?
> 
> The upstream thp patches for s390 fixed that by adding pmdp_invalidate() and
> replacing the pmd_mknotpresent() in mm/huge_memory.c, see git commit 46dcde73.
> The pmdp_invalidate() is already included linux-next, so it should be ok to
> just change mm/huge_memory.c similar to upstream:
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index f1c2679..842b6df 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1537,8 +1537,7 @@ static int __split_huge_page_map(struct page *page,
>  	 * complete. The ptl also protects against concurrent faults due to
>  	 * making the pmd not-present.
>  	 */
> -	set_pmd_at(mm, address, pmd, pmd_mknotpresent(*pmd));
> -	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
> +	pmdp_invalidate(vma, address, pmd);
>  	pmd_populate(mm, pmd, pgtable);
>  	ret = 1;
> 
> With this, s390 does not need a pmd_mknotpresent(), and using 
> set_pmd_at(..., pmd_mknotpresent()) would be wrong on s390 
> anyway because we need a flushing operation to change a valid 
> pmd.

Ok, great - so to me it seems that once the two trees are merged 
there's no extra change needed for s390 - so I dropped the 
patch.

Thanks,

	Ingo
