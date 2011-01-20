Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab1ATACN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 19:02:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab1ATACL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 19:02:11 -0500
Date: Thu, 20 Jan 2011 01:01:47 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: werner <w.landgraf@ru.ru>, Borislav Petkov <bp@amd64.org>,
        Ilya Dryomov <idryomov@gmail.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.38-rc1 problems with khugepaged
Message-ID: <20110120000147.GR9506@random.random>
References: <web-442414153@zbackend1.aha.ru>
 <20110119155954.GA2272@kryptos.osrc.amd.com>
 <20110119214523.GF2232@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119214523.GF2232@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 10:45:23PM +0100, Johannes Weiner wrote:
> Hi,
> 
> On Wed, Jan 19, 2011 at 04:59:54PM +0100, Borislav Petkov wrote:
> > Adding some more parties to CC.
> > 
> > On Wed, Jan 19, 2011 at 09:45:25AM -0400, werner wrote:
> > > **  Help   Help Help ***
> > > 
> > > My computer crashs on booting  ...   :( :(
> 
> That sucks!
> 
> I cross-compiled for 32-bit and was able to match up the disassembly
> against the code line from your oops report.  Apparently the pte was
> an invalid pointer, and it makes perfect sense: we unmap the highpte
> _before_ we access the pointer again for __collapse_huge_page_copy().
> 
> Can you test with this fix applied?  It is only compile-tested, I too
> have no 32-bit installations anymore.

Thanks Johannes, I already sent the same fix a few minutes ago, it is
also confirmed to work from Ilya in Message-ID:
<20110119224950.GA3429@kwango.lan.net>

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1be1034..e187454 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1839,9 +1839,9 @@ static void collapse_huge_page(struct mm_struct *mm,
>  	spin_lock(ptl);
>  	isolated = __collapse_huge_page_isolate(vma, address, pte);
>  	spin_unlock(ptl);
> -	pte_unmap(pte);
>  
>  	if (unlikely(!isolated)) {
> +		pte_unmap(pte);
>  		spin_lock(&mm->page_table_lock);
>  		BUG_ON(!pmd_none(*pmd));
>  		set_pmd_at(mm, address, pmd, _pmd);
> @@ -1858,6 +1858,7 @@ static void collapse_huge_page(struct mm_struct *mm,
>  	anon_vma_unlock(vma->anon_vma);
>  
>  	__collapse_huge_page_copy(pte, new_page, vma, address, ptl);
> +	pte_unmap(pte);
>  	__SetPageUptodate(new_page);
>  	pgtable = pmd_pgtable(_pmd);
>  	VM_BUG_ON(page_count(pgtable) != 1);

Good thing your fix is identical to mine ;).
