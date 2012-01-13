Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab2AMWza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 17:55:30 -0500
Received: from relais.videotron.ca ([24.201.245.36]:24937 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab2AMWz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 17:55:28 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Fri, 13 Jan 2012 17:55:27 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, moussaba@micron.com,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] proc: clear_refs: do not clear reserved pages
In-reply-to: <1326467587-22218-1-git-send-email-will.deacon@arm.com>
Message-id: <alpine.LFD.2.02.1201131748380.2722@xanadu.home>
References: <1326467587-22218-1-git-send-email-will.deacon@arm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jan 2012, Will Deacon wrote:

> /proc/pid/clear_refs is used to clear the Referenced and YOUNG bits for
> pages and corresponding page table entries of the task with PID pid,
> which includes any special mappings inserted into the page tables in
> order to provide things like vDSOs and user helper functions.
> 
> On ARM this causes a problem because the vectors page is mapped as a
> global mapping and since ec706dab ("ARM: add a vma entry for the user
> accessible vector page"), a VMA is also inserted into each task for this
> page to aid unwinding through signals and syscall restarts. Since the
> vectors page is required for handling faults, clearing the YOUNG bit
> (and subsequently writing a faulting pte) means that we lose the vectors
> page *globally* and cannot fault it back in. This results in a system
> deadlock on the next exception.
> 
> This patch avoids clearing the aforementioned bits for reserved pages,
> therefore leaving the vectors page intact on ARM. Since reserved pages
> are not candidates for swap, this change should not have any impact on
> the usefulness of clear_refs.
> 
> Cc: David Rientjes <rientjes@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Nicolas Pitre <nico@fluxnic.net>
> Reported-by: Moussa Ba <moussaba@micron.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>

Given Andrew's answer, this should be fine wrt Russell's concern.

Acked-by: Nicolas Pitre <nico@linaro.org>

> An aside: if you want to see this problem in action, just run:
> 
> $ echo 1 > /proc/self/clear_refs
> 
> on an ARM platform (as any user) and watch your system hang. I think this
> has been the case since 2.6.37, so I'll CC stable once people are happy
> with the fix.
> 
>  fs/proc/task_mmu.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e418c5a..7dcd2a2 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -518,6 +518,9 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
>  		if (!page)
>  			continue;
>  
> +		if (PageReserved(page))
> +			continue;
> +
>  		/* Clear accessed and referenced bits. */
>  		ptep_test_and_clear_young(vma, addr, pte);
>  		ClearPageReferenced(page);
> -- 
> 1.7.4.1
> 
