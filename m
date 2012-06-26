Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab2FZL4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 07:56:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432Ab2FZL4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 07:56:44 -0400
Date: Tue, 26 Jun 2012 13:55:14 +0200
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] uprobes: __replace_page() needs munlock_vma_page()
Message-ID: <20120626115514.GA16794@bandura.brq.redhat.com>
References: <20120624145936.GA23269@redhat.com>
 <20120624150111.GE23277@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120624150111.GE23277@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2012 at 05:01:11PM +0200, Oleg Nesterov wrote:
> Like do_wp_page(), __replace_page() should do munlock_vma_page()
> for the case when the old page still has other !VM_LOCKED mappings.
> Unfortunately this needs mm/internal.h.
> 
> Also, move put_page() outside of ptl lock. This doesn't really
> matter but looks better.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/events/uprobes.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 5db150b..889c62b 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -32,6 +32,7 @@
>  #include <linux/swap.h>		/* try_to_free_swap */
>  #include <linux/ptrace.h>	/* user_enable_single_step */
>  #include <linux/kdebug.h>	/* notifier mechanism */
> +#include "../../mm/internal.h"	/* munlock_vma_page */

  We have vma_adress() defined in internal.h, under #ifdef CONFIG_TRANSPARENT_HUGEPAGE .

  NAK. :-)

Anton.

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
> 
