Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab1CIFTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 00:19:42 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53214 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1CIFTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 00:19:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH 1/6] mm: use mm_struct to resolve gate vma's in __get_user_pages
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Roland McGrath <roland@redhat.com>,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Ingo Molnar <mingo@elte.hu>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1299631343-4499-2-git-send-email-wilsons@start.ca>
References: <1299631343-4499-1-git-send-email-wilsons@start.ca> <1299631343-4499-2-git-send-email-wilsons@start.ca>
Message-Id: <20110309141208.03F7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  9 Mar 2011 14:19:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We now check if a requested user page overlaps a gate vma using the supplied mm
> instead of the supplied task.  The given task is now used solely for accounting
> purposes and may be NULL.
> 
> Signed-off-by: Stephen Wilson <wilsons@start.ca>
> ---
>  mm/memory.c |   18 +++++++++++-------
>  1 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 3863e86..36445e3 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1437,9 +1437,9 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
>  		struct vm_area_struct *vma;
>  
>  		vma = find_extend_vma(mm, start);
> -		if (!vma && in_gate_area(tsk->mm, start)) {
> +		if (!vma && in_gate_area(mm, start)) {
>  			unsigned long pg = start & PAGE_MASK;
> -			struct vm_area_struct *gate_vma = get_gate_vma(tsk->mm);
> +			struct vm_area_struct *gate_vma = get_gate_vma(mm);
>  			pgd_t *pgd;
>  			pud_t *pud;
>  			pmd_t *pmd;

Hmm..
Is this works? In exec() case task has two mm, old and new-borned. tsk has
no enough information to detect gate area if 64bit process exec 32bit process
or oppsite case. On Linux, 32bit and 64bit processes have perfectly different
process vma layout.

Am I missing something?


