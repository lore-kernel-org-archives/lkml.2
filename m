Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab2GBEen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 00:34:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab2GBEem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 00:34:42 -0400
Message-ID: <4FF124A8.60509@redhat.com>
Date: Mon, 02 Jul 2012 00:33:44 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 29/40] autonuma: retain page last_nid information in khugepaged
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com> <1340888180-15355-30-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-30-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 08:56 AM, Andrea Arcangeli wrote:
> When pages are collapsed try to keep the last_nid information from one
> of the original pages.
>
> Signed-off-by: Andrea Arcangeli<aarcange@redhat.com>
> ---
>   mm/huge_memory.c |   11 +++++++++++
>   1 files changed, 11 insertions(+), 0 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 094f82b..ae20409 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1814,7 +1814,18 @@ static bool __collapse_huge_page_copy(pte_t *pte, struct page *page,
>   			clear_user_highpage(page, address);
>   			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
>   		} else {
> +#ifdef CONFIG_AUTONUMA
> +			int autonuma_last_nid;
> +#endif
>   			src_page = pte_page(pteval);
> +#ifdef CONFIG_AUTONUMA
> +			/* pick the last one, better than nothing */
> +			autonuma_last_nid =
> +				ACCESS_ONCE(src_page->autonuma_last_nid);
> +			if (autonuma_last_nid>= 0)
> +				ACCESS_ONCE(page->autonuma_last_nid) =
> +					autonuma_last_nid;
> +#endif
>   			copy_user_highpage(page, src_page, address, vma);
>   			VM_BUG_ON(page_mapcount(src_page) != 1);
>   			VM_BUG_ON(page_count(src_page) != 2);

Can you remember the node ID inside the loop, but do the
assignment just once after the loop has exited?

It seems excessive to make the assignment up to 512 times.

-- 
All rights reversed
