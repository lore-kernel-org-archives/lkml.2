Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab1GNQO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 12:14:28 -0400
Received: from smtp-out.google.com ([74.125.121.67]:47514 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab1GNQO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 12:14:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=rdulsfoMyMPTejOpIsrCmoxhCw6Gd5H2JrN4geAmAKKAbDvztd72HsUYillhjR4sf
	ED65DKbJBTemWePrhwxXA==
Date: Thu, 14 Jul 2011 09:14:07 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next/mmotm] slub: partly fix freeze in __slab_free
In-Reply-To: <alpine.DEB.2.00.1107131054270.29034@router.home>
Message-ID: <alpine.LSU.2.00.1107140905030.4077@sister.anvils>
References: <alpine.LSU.2.00.1107111156310.13035@sister.anvils> <1310413167.2860.3.camel@edumazet-laptop> <4E1BE5F9.10401@kernel.org> <alpine.DEB.2.00.1107121010060.1672@router.home> <alpine.DEB.2.00.1107121046000.2530@router.home>
 <alpine.LSU.2.00.1107130357560.4184@sister.anvils> <alpine.DEB.2.00.1107131041170.29034@router.home> <alpine.DEB.2.00.1107131054270.29034@router.home>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011, Christoph Lameter wrote:
> 
> Subject: slub: disable interrupts in cmpxchg_double_slab when falling back to pagelock.
> 
> Disable interrupts when falling back to the use of the page lock in
> cmpxchg_double_slab().
> 
> Becomes necessary since __slab_free will call cmpxchg_double_slab without disabling
> interrupts.
> 
> A bit bad because the invocations from the allocation path of cmpxchg_double_slab
> occur with interrupts already disabled (but there are plans to enable
> interrupts there as well in the future).
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Success, thank you: I ran my load for 22 hours on the ppc64,
no problem this time, where before it froze in 2.5 hours.

I was running rc6-mm1 plus this patch, plus (my transcription of) your
mm_types.h struct page patch, plus Fengguang's redirty_tail patch;
leaving out my "*new = page" patch which kicked this thread off.

Feel free to add
Tested-by: Hugh Dickins <hughd@google.com>

> 
> 
> ---
>  mm/slub.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2011-07-13 10:51:07.867138834 -0500
> +++ linux-2.6/mm/slub.c	2011-07-13 10:51:20.957138752 -0500
> @@ -368,14 +368,19 @@ static inline bool cmpxchg_double_slab(s
>  	} else
>  #endif
>  	{
> +		unsigned long flags;
> +
> +		local_irq_save(flags);
>  		slab_lock(page);
>  		if (page->freelist == freelist_old && page->counters == counters_old) {
>  			page->freelist = freelist_new;
>  			page->counters = counters_new;
>  			slab_unlock(page);
> +			local_irq_restore(flags);
>  			return 1;
>  		}
>  		slab_unlock(page);
> +		local_irq_restore(flags);
>  	}
> 
>  	cpu_relax();
> 
