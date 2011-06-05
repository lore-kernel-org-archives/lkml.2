Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab1FETUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 15:20:53 -0400
Received: from smtp-out.google.com ([74.125.121.67]:24933 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab1FETUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 15:20:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=obDe4Id43R9iDOi9CeuePQRio/E6vOtTXAIPkR0NRlcJXAUAbVvHO/dKm7WTm025Rw
         /C1YtJzME2dXj5cTTuEw==
Date: Sun, 5 Jun 2011 12:20:50 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] mm: Fix wrong kunmap_atomic() pointer
In-Reply-To: <1307158665.3667.86.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LSU.2.00.1106051216450.5792@sister.anvils>
References: <1307158665.3667.86.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jun 2011, Steven Rostedt wrote:
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Thanks, Steve: I'm afraid I left a number of those "pte - 1"
landmines around, and this isn't the first one to blow up.

Acked-by: Hugh Dickins <hughd@google.com>

> diff --git a/mm/memory.c b/mm/memory.c
> index 6953d39..922dcd6 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1112,11 +1112,13 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>  	int force_flush = 0;
>  	int rss[NR_MM_COUNTERS];
>  	spinlock_t *ptl;
> +	pte_t *start_pte;
>  	pte_t *pte;
>  
>  again:
>  	init_rss_vec(rss);
> -	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
> +	start_pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
> +	pte = start_pte;
>  	arch_enter_lazy_mmu_mode();
>  	do {
>  		pte_t ptent = *pte;
> @@ -1196,7 +1198,7 @@ again:
>  
>  	add_mm_rss_vec(mm, rss);
>  	arch_leave_lazy_mmu_mode();
> -	pte_unmap_unlock(pte - 1, ptl);
> +	pte_unmap_unlock(start_pte, ptl);
>  
>  	/*
>  	 * mmu_gather ran out of room to batch pages, we break out of
