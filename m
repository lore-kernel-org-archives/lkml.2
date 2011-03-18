Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab1CRHaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 03:30:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38968 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab1CRH37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 03:29:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=QUbuGUoq/eee1rbIMLWLyM//yPGvK8ed1ym7d/qnbsgrQdfozhyAVt6B1rWmBX3u61
         xl5bfWnmuMvFmmZSE4TeEEMgohDGgwVO/7akyngrlqgymnxvOWM/610JsnBn23TEGeaj
         yMhf14FdbZ7QhDJm/x+0hhyzEQXnrpL3eoBSc=
From: Nai Xia <nai.xia@gmail.com>
Reply-To: nai.xia@gmail.com
Organization: Nanjing University
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ksm: add vm_stat and meminfo entry to reflect pte mapping to ksm pages
Date: Fri, 18 Mar 2011 15:29:43 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.36.4; KDE/4.6.1; i686; ; )
Cc: Izik Eidus <ieidus@redhat.com>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Chris Wright <chrisw@sous-sol.org>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kernel-janitors@vger.kernel.org
References: <201102262256.31565.nai.xia@gmail.com> <20110302143142.a3c0002b.akpm@linux-foundation.org>
In-Reply-To: <20110302143142.a3c0002b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103181529.43659.nai.xia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>On Thursday 03 March 2011, at 06:31:42, <Andrew Morton <akpm@linux-foundation.org>> wrote
> This patch obviously wasn't tested with CONFIG_KSM=n, which was a
> pretty basic patch-testing failure :(

Oops, I will be careful to avoid similar mistakes next time.

> 
> I fixed up my tree with the below, but really the amount of ifdeffing
> is unacceptable - please find a cleaner way to fix up this patch.

Ok, I will have a try in my next patch submit. 

Thanks,
-Nai
> 
> --- a/mm/ksm.c~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix
> +++ a/mm/ksm.c
> @@ -883,7 +883,6 @@ static int try_to_merge_one_page(struct 
>  	 */
>  	if (write_protect_page(vma, page, &orig_pte) == 0) {
>  		if (!kpage) {
> -			long mapcount = page_mapcount(page);
>  			/*
>  			 * While we hold page lock, upgrade page from
>  			 * PageAnon+anon_vma to PageKsm+NULL stable_node:
> @@ -891,10 +890,12 @@ static int try_to_merge_one_page(struct 
>  			 */
>  			set_page_stable_node(page, NULL);
>  			mark_page_accessed(page);
> -			if (mapcount)
> +#ifdef CONFIG_KSM
> +			if (page_mapcount(page))
>  				add_zone_page_state(page_zone(page),
>  						    NR_KSM_PAGES_SHARING,
>  						    mapcount);
> +#endif
>  			err = 0;
>  		} else if (pages_identical(page, kpage))
>  			err = replace_page(vma, page, kpage, orig_pte);
> --- a/mm/memory.c~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix
> +++ a/mm/memory.c
> @@ -719,8 +719,10 @@ copy_one_pte(struct mm_struct *dst_mm, s
>  			rss[MM_ANONPAGES]++;
>  		else
>  			rss[MM_FILEPAGES]++;
> +#ifdef CONFIG_KSM
>  		if (PageKsm(page)) /* follows page_dup_rmap() */
>  			inc_zone_page_state(page, NR_KSM_PAGES_SHARING);
> +#endif
>  	}
>  
>  out_set_pte:
> --- a/mm/rmap.c~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix
> +++ a/mm/rmap.c
> @@ -893,11 +893,12 @@ void do_page_add_anon_rmap(struct page *
>  			__inc_zone_page_state(page,
>  					      NR_ANON_TRANSPARENT_HUGEPAGES);
>  	}
> +#ifdef CONFIG_KSM
>  	if (unlikely(PageKsm(page))) {
>  		__inc_zone_page_state(page, NR_KSM_PAGES_SHARING);
>  		return;
>  	}
> -
> +#endif
>  	VM_BUG_ON(!PageLocked(page));
>  	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
>  	if (first)
> @@ -955,9 +956,10 @@ void page_add_file_rmap(struct page *pag
>   */
>  void page_remove_rmap(struct page *page)
>  {
> +#ifdef CONFIG_KSM
>  	if (PageKsm(page))
>  		__dec_zone_page_state(page, NR_KSM_PAGES_SHARING);
> -
> +#endif
>  	/* page still mapped by someone else? */
>  	if (!atomic_add_negative(-1, &page->_mapcount))
>  		return;
> _
> 
> 
