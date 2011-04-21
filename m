Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab1DUG7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 02:59:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55795 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab1DUG7s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 02:59:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aE7E/poulcFDfhwvtwJU3FAGhiZgwzGBehNHqitEMaGeW+J7uMlUde7RSVPLvHTG4X
         mvl8Ay6ZGvDAXWRKmRZmBIrvF5A1DSK24yFa1yM8piF5m+wQSYccXhQf0jnF4kiTJNK6
         K9SV6ABkHGYTyx2Q56FsZz7LNBHJYq1pOIAh4=
MIME-Version: 1.0
In-Reply-To: <20110415101248.GB22688@suse.de>
References: <20110415101248.GB22688@suse.de>
Date: Thu, 21 Apr 2011 15:59:47 +0900
Message-ID: <BANLkTik7H+cmA8iToV4j1ncbQqeraCaeTg@mail.gmail.com>
Subject: Re: [PATCH] mm: Check if PTE is already allocated during page fault
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: akpm@linux-foundation.org, Andrea Arcangeli <aarcange@redhat.com>,
        raz ben yehuda <raziebe@gmail.com>, riel@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, lkml <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Fri, Apr 15, 2011 at 7:12 PM, Mel Gorman <mgorman@suse.de> wrote:
> With transparent hugepage support, handle_mm_fault() has to be careful
> that a normal PMD has been established before handling a PTE fault. To
> achieve this, it used __pte_alloc() directly instead of pte_alloc_map
> as pte_alloc_map is unsafe to run against a huge PMD. pte_offset_map()
> is called once it is known the PMD is safe.
>
> pte_alloc_map() is smart enough to check if a PTE is already present
> before calling __pte_alloc but this check was lost. As a consequence,
> PTEs may be allocated unnecessarily and the page table lock taken.
> Thi useless PTE does get cleaned up but it's a performance hit which
> is visible in page_test from aim9.
>
> This patch simply re-adds the check normally done by pte_alloc_map to
> check if the PTE needs to be allocated before taking the page table
> lock. The effect is noticable in page_test from aim9.
>
> AIM9
>                2.6.38-vanilla 2.6.38-checkptenone
> creat-clo      446.10 ( 0.00%)   424.47 (-5.10%)
> page_test       38.10 ( 0.00%)    42.04 ( 9.37%)
> brk_test        52.45 ( 0.00%)    51.57 (-1.71%)
> exec_test      382.00 ( 0.00%)   456.90 (16.39%)
> fork_test       60.11 ( 0.00%)    67.79 (11.34%)
> MMTests Statistics: duration
> Total Elapsed Time (seconds)                611.90    612.22
>
> (While this affects 2.6.38, it is a performance rather than a
> functional bug and normally outside the rules -stable. While the big
> performance differences are to a microbench, the difference in fork
> and exec performance may be significant enough that -stable wants to
> consider the patch)
>
> Reported-by: Raz Ben Yehuda <raziebe@gmail.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> --
>  mm/memory.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 5823698..1659574 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3322,7 +3322,7 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>         * run pte_offset_map on the pmd, if an huge pmd could
>         * materialize from under us from a different thread.
>         */
> -       if (unlikely(__pte_alloc(mm, vma, pmd, address)))
> +       if (unlikely(pmd_none(*pmd)) && __pte_alloc(mm, vma, pmd, address))
>                return VM_FAULT_OOM;
>        /* if an huge pmd materialized from under us just retry later */
>        if (unlikely(pmd_trans_huge(*pmd)))
>

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Sorry for jumping in too late. I have a just nitpick.

We have another place, do_huge_pmd_anonymous_page.
Although it isn't workload of page_test, is it valuable to expand your
patch to cover it?
If there is workload there are many thread and share one shared anon
vma in ALWAYS THP mode, same problem would happen.


-- 
Kind regards,
Minchan Kim
