Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab1DPJpC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 05:45:02 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60326 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758553Ab1DPJo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 05:44:59 -0400
Date: Sat, 16 Apr 2011 10:44:56 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH 2/3] track numbers of pagetable pages
Message-ID: <20110416104456.3915b7de@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110415173823.EA7A7473@kernel>
References: <20110415173821.62660715@kernel>
	<20110415173823.EA7A7473@kernel>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Apr 2011 10:38:23 -0700
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> 
> Now that we have the mm in the constructor and destructor, it's
> simple to to bump a counter.  Add the counter to the mm and use
> the existing MM_* counter infrastructure.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> ---
> 
>  linux-2.6.git-dave/include/linux/mm.h       |    2 ++
>  linux-2.6.git-dave/include/linux/mm_types.h |    1 +
>  2 files changed, 3 insertions(+)
> 
> diff -puN include/linux/mm.h~track-pagetable-pages include/linux/mm.h
> --- linux-2.6.git/include/linux/mm.h~track-pagetable-pages	2011-04-15 10:37:10.768832396 -0700
> +++ linux-2.6.git-dave/include/linux/mm.h	2011-04-15 10:37:10.780832393 -0700
> @@ -1245,12 +1245,14 @@ static inline pmd_t *pmd_alloc(struct mm
>  static inline void pgtable_page_ctor(struct mm_struct *mm, struct page *page)
>  {
>  	pte_lock_init(page);
> +	inc_mm_counter(mm, MM_PTEPAGES);
>  	inc_zone_page_state(page, NR_PAGETABLE);
>  }
>  
>  static inline void pgtable_page_dtor(struct mm_struct *mm, struct page *page)
>  {
>  	pte_lock_deinit(page);
> +	dec_mm_counter(mm, MM_PTEPAGES);
>  	dec_zone_page_state(page, NR_PAGETABLE);
>  }

I'm probably missing something really obvious but...

Is this safe in the non-USE_SPLIT_PTLOCKS case? If we're not using
split-ptlocks then inc/dec_mm_counter() are only safe when done under
mm->page_table_lock, right? But it looks to me like we can end up doing,

  __pte_alloc()
      pte_alloc_one()
          pgtable_page_ctor()

before acquiring mm->page_table_lock in __pte_alloc().

-- 
Matt Fleming, Intel Open Source Technology Center
