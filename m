Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab2ACRrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 12:47:53 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43193 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382Ab2ACRru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 12:47:50 -0500
Message-ID: <4F033F44.6020403@gmail.com>
Date: Tue, 03 Jan 2012 12:47:48 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Gilad Ben-Yossef <gilad@benyossef.com>
CC: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH v5 8/8] mm: add vmstat counters for tracking PCP drains
References: <1325499859-2262-1-git-send-email-gilad@benyossef.com> <1325499859-2262-9-git-send-email-gilad@benyossef.com>
In-Reply-To: <1325499859-2262-9-git-send-email-gilad@benyossef.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(1/2/12 5:24 AM), Gilad Ben-Yossef wrote:
> This patch introduces two new vmstat counters: pcp_global_drain
> that counts the number of times a per-cpu pages global drain was
> requested and pcp_global_ipi_saved that counts the number of times
> the number of CPUs with per-cpu pages in any zone were less then
> 1/2 of the number of online CPUs.
> 
> The patch purpose is to show the usefulness of only sending an IPI
> asking to drain per-cpu pages to CPUs that actually have them
> instead of a blind global IPI. It is probably not useful by itself.
> 
> Signed-off-by: Gilad Ben-Yossef<gilad@benyossef.com>
> CC: Christoph Lameter<cl@linux.com>
> CC: Chris Metcalf<cmetcalf@tilera.com>
> CC: Peter Zijlstra<a.p.zijlstra@chello.nl>
> CC: Frederic Weisbecker<fweisbec@gmail.com>
> CC: linux-mm@kvack.org
> CC: Pekka Enberg<penberg@kernel.org>
> CC: Matt Mackall<mpm@selenic.com>
> CC: Sasha Levin<levinsasha928@gmail.com>
> CC: Rik van Riel<riel@redhat.com>
> CC: Andi Kleen<andi@firstfloor.org>
> CC: Mel Gorman<mel@csn.ul.ie>
> CC: Andrew Morton<akpm@linux-foundation.org>
> CC: Alexander Viro<viro@zeniv.linux.org.uk>
> CC: Avi Kivity<avi@redhat.com>
> ---
>   include/linux/vm_event_item.h |    1 +
>   mm/page_alloc.c               |    4 ++++
>   mm/vmstat.c                   |    2 ++
>   3 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
> index 03b90cd..3657f6f 100644
> --- a/include/linux/vm_event_item.h
> +++ b/include/linux/vm_event_item.h
> @@ -58,6 +58,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>   		THP_COLLAPSE_ALLOC_FAILED,
>   		THP_SPLIT,
>   #endif
> +		PCP_GLOBAL_DRAIN, PCP_GLOBAL_IPI_SAVED,
>   		NR_VM_EVENT_ITEMS
>   };
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 092c331..4ca6bfa 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1140,6 +1140,10 @@ void drain_all_pages(void)
>   				cpumask_clear_cpu(cpu, cpus_with_pcps);
>   		}
>   	on_each_cpu_mask(cpus_with_pcps, drain_local_pages, NULL, 1);
> +
> +	count_vm_event(PCP_GLOBAL_DRAIN);
> +	if (cpumask_weight(cpus_with_pcps)<  (cpumask_weight(cpu_online_mask) / 2))
> +		count_vm_event(PCP_GLOBAL_IPI_SAVED);

NAK.

PCP_GLOBAL_IPI_SAVED is only useful at development phase. I can't
imagine normal admins use it.



