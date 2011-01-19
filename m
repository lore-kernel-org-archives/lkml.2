Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab1ASWuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:50:24 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52290 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab1ASWuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:50:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qrzA6FYe4N/kIU2CCix06bjyqxUZjxoNToVOfujKKCfP4yTdlAgm67B31M3MxGj3cZ
         3oUo6vZd7WGqAaOBubIpEaYPI/FwZNPHxnijVER3FO7x+xvas1hjZVt0Pi4TR5/+h8uE
         7caQ0u47aHIMk42xbQkLuqPB9Sz6nB7XPAtZA=
Date: Thu, 20 Jan 2011 00:49:50 +0200
From: Ilya Dryomov <idryomov@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, idryomov@gmail.com
Subject: Re: [BUG] BUG: unable to handle kernel paging request at fffba000
Message-ID: <20110119224950.GA3429@kwango.lan.net>
References: <20110119124047.GA30274@kwango.lan.net> <20110119221909.GO9506@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119221909.GO9506@random.random>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 11:19:09PM +0100, Andrea Arcangeli wrote:
> Hello Ilya,
> 
> thanks for sending me the gdb info too.
> 
> can you test this fix? Thanks a lot! (it only affected x86 32bit
> builds with highpte enabled)
> 
> ====
> Subject: fix pte_unmap in khugepaged for highpte x86_32
> 
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> __collapse_huge_page_copy is still dereferencing the pte passed as parameter so
> we must pte_unmap after __collapse_huge_page_copy returns, not before.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

It fixes the above problem for me.  Thanks a lot Andrea.

> ---
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 004c9c2..c4f634b 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1837,9 +1837,9 @@ static void collapse_huge_page(struct mm_struct *mm,
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
> @@ -1856,6 +1856,7 @@ static void collapse_huge_page(struct mm_struct *mm,
>  	anon_vma_unlock(vma->anon_vma);
>  
>  	__collapse_huge_page_copy(pte, new_page, vma, address, ptl);
> +	pte_unmap(pte);
>  	__SetPageUptodate(new_page);
>  	pgtable = pmd_pgtable(_pmd);
>  	VM_BUG_ON(page_count(pgtable) != 1);
> 
