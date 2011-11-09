Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab1KISHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 13:07:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069Ab1KISHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 13:07:12 -0500
Date: Wed, 9 Nov 2011 19:06:46 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
        Johannes Weiner <jweiner@redhat.com>
Subject: Re: long sleep_on_page delays writing to slow storage
Message-ID: <20111109180646.GM5075@redhat.com>
References: <20111107045928.GK8927@hexapodia.org>
 <20111109170027.GB7495@quack.suse.cz>
 <20111109175201.GB3083@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109175201.GB3083@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 05:52:01PM +0000, Mel Gorman wrote:
> -#define alloc_pages_vma(gfp_mask, order, vma, addr, node)	\
> -	alloc_pages(gfp_mask, order)
> +#define alloc_pages_vma(gfp_mask, order, vma, addr, node, drop_mmapsem)	\
> +	({ 								\
> +		if (drop_mmapsem)					\
> +			up_read(&vma->vm_mm->mmap_sem);			\
> +		alloc_pages(gfp_mask, order);				\
> +	})

I wouldn't change alloc_pages_vma. I think it's better to add and have
that called only by khugepaged:

alloc_pages_vma_up_read(gfp_mask, order, vma, addr, node)
{
	__alloc_pages_vma(gfp_mask, order, vma, addr, node, true);
}

alloc_pages_vma(gfp_mask, order, vma, addr, node)
{
	__alloc_pages_vma(gfp_mask, order, vma, addr, node, false);
}

I wonder if a change like this would be enough?

       sync_migration = !(gfp_mask & __GFP_NO_KSWAPD);

But even if hidden in a new function, the main downside overall is the
fact we'll pass one more var through the stack of fast paths.

Johannes I recall you reported this too and Mel suggested the above
change, did it help in the end?

Your change in khugepaged context makes perfect sense anyway, just we
should be sure it's really needed before adding more variables in fast
path I think.
