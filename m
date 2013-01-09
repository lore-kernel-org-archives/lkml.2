Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab3AIKTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 05:19:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756210Ab3AIKS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 05:18:59 -0500
Date: Wed, 9 Jan 2013 11:16:54 +0100
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frank Eigler <fche@redhat.com>, Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] uprobes: Fold xol_alloc_area() into get_xol_area()
Message-ID: <20130109101654.GA21781@bandura.brq.redhat.com>
References: <20121231175150.GA32066@redhat.com>
 <20121231175216.GA32091@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121231175216.GA32091@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2012 at 06:52:16PM +0100, Oleg Nesterov wrote:
> Currently only xol_get_insn_slot() does get_xol_area() + xol_alloc_area(),
> but this will have more users and we do not want to copy-and-paste this
> code. This patch simply moves xol_alloc_area() into get_xol_area() to
> simplify the current and future code.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/events/uprobes.c |   38 ++++++++++++++++----------------------
>  1 files changed, 16 insertions(+), 22 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 1456f7d..ef81162 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1070,27 +1070,21 @@ static int xol_add_vma(struct xol_area *area)
>  	return ret;
>  }
>  
> -static struct xol_area *get_xol_area(struct mm_struct *mm)
> -{
> -	struct xol_area *area;
> -
> -	area = mm->uprobes_state.xol_area;
> -	smp_read_barrier_depends();	/* pairs with wmb in xol_add_vma() */
> -
> -	return area;
> -}
> -
>  /*
> - * xol_alloc_area - Allocate process's xol_area.
> - * This area will be used for storing instructions for execution out of
> - * line.
> + * get_alloc_area - Allocate process's xol_area if necessary.
> + * This area will be used for storing instructions for execution out of line.
>   *
>   * Returns the allocated area or NULL.
>   */

+ * get_xol_area ....

Anton.

> -static struct xol_area *xol_alloc_area(void)
> +static struct xol_area *get_xol_area(void)
>  {
> +	struct mm_struct *mm = current->mm;
>  	struct xol_area *area;
>  
> +	area = mm->uprobes_state.xol_area;
> +	if (area)
> +		goto ret;
> +
>  	area = kzalloc(sizeof(*area), GFP_KERNEL);
>  	if (unlikely(!area))
>  		goto out;
> @@ -1113,7 +1107,10 @@ static struct xol_area *xol_alloc_area(void)
>   free_area:
>  	kfree(area);
>   out:
> -	return get_xol_area(current->mm);
> +	area = mm->uprobes_state.xol_area;
> + ret:
> +	smp_read_barrier_depends();     /* pairs with wmb in xol_add_vma() */
> +	return area;
>  }
>  
>  /*
> @@ -1189,14 +1186,11 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe, unsigned long slot
>  	unsigned long offset;
>  	void *vaddr;
>  
> -	area = get_xol_area(current->mm);
> -	if (!area) {
> -		area = xol_alloc_area();
> -		if (!area)
> -			return 0;
> -	}
> -	current->utask->xol_vaddr = xol_take_insn_slot(area);
> +	area = get_xol_area();
> +	if (!area)
> +		return 0;
>  
> +	current->utask->xol_vaddr = xol_take_insn_slot(area);
>  	/*
>  	 * Initialize the slot if xol_vaddr points to valid
>  	 * instruction slot.
> -- 
> 1.5.5.1
> 
