Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab2GZFT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 01:19:57 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44044 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab2GZFTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 01:19:55 -0400
Date: Thu, 26 Jul 2012 10:48:39 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] uprobes: __replace_page() needs munlock_vma_page()
Message-ID: <20120726051839.GE3810@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120712170934.GA25455@redhat.com>
 <20120712171025.GA25510@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120712171025.GA25510@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072605-5806-0000-0000-000017AC8ECF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-07-12 19:10:25]:

> Like do_wp_page(), __replace_page() should do munlock_vma_page()
> for the case when the old page still has other !VM_LOCKED mappings.
> Unfortunately this needs mm/internal.h.
> 
> Also, move put_page() outside of ptl lock. This doesn't really
> matter but looks a bit better.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

One thing I wanted to check is, should we mlock the new page, i.e the
replacing page. It may not a good idea to mlock the new page
because then we can end up adding too many pages to the unevictable
list.

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index fc1df43..aeea41b 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -32,6 +32,7 @@
>  #include <linux/swap.h>		/* try_to_free_swap */
>  #include <linux/ptrace.h>	/* user_enable_single_step */
>  #include <linux/kdebug.h>	/* notifier mechanism */
> +#include "../../mm/internal.h"	/* munlock_vma_page */
> 
>  #include <linux/uprobes.h>
> 
> @@ -141,7 +142,7 @@ static int __replace_page(struct vm_area_struct *vma, unsigned long addr,
>  	pte_t *ptep;
>  	int err;
> 
> -	/* freeze PageSwapCache() for try_to_free_swap() below */
> +	/* For try_to_free_swap() and munlock_vma_page() below */
>  	lock_page(page);
> 
>  	err = -EAGAIN;
> @@ -164,9 +165,12 @@ static int __replace_page(struct vm_area_struct *vma, unsigned long addr,
>  	page_remove_rmap(page);
>  	if (!page_mapped(page))
>  		try_to_free_swap(page);
> -	put_page(page);
>  	pte_unmap_unlock(ptep, ptl);
> 
> +	if (vma->vm_flags & VM_LOCKED)
> +		munlock_vma_page(page);
> +	put_page(page);
> +
>  	err = 0;
>   unlock:
>  	unlock_page(page);
> -- 
> 1.5.5.1
> 

