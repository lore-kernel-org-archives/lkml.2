Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab2F2SgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 14:36:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226Ab2F2SgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 14:36:04 -0400
Message-ID: <4FEDF562.1080003@redhat.com>
Date: Fri, 29 Jun 2012 14:35:14 -0400
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
Subject: Re: [PATCH 16/40] autonuma: init knuma_migrated queues
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com> <1340888180-15355-17-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-17-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 08:55 AM, Andrea Arcangeli wrote:
> Initialize the knuma_migrated queues at boot time.
>
> Signed-off-by: Andrea Arcangeli<aarcange@redhat.com>
> ---
>   mm/page_alloc.c |   11 +++++++++++
>   1 files changed, 11 insertions(+), 0 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a9710a4..48eabe9 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -59,6 +59,7 @@
>   #include<linux/prefetch.h>
>   #include<linux/migrate.h>
>   #include<linux/page-debug-flags.h>
> +#include<linux/autonuma.h>
>
>   #include<asm/tlbflush.h>
>   #include<asm/div64.h>
> @@ -4348,8 +4349,18 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
>   	int nid = pgdat->node_id;
>   	unsigned long zone_start_pfn = pgdat->node_start_pfn;
>   	int ret;
> +#ifdef CONFIG_AUTONUMA
> +	int node_iter;
> +#endif
>
>   	pgdat_resize_init(pgdat);
> +#ifdef CONFIG_AUTONUMA
> +	spin_lock_init(&pgdat->autonuma_lock);
> +	init_waitqueue_head(&pgdat->autonuma_knuma_migrated_wait);
> +	pgdat->autonuma_nr_migrate_pages = 0;
> +	for_each_node(node_iter)
> +		INIT_LIST_HEAD(&pgdat->autonuma_migrate_head[node_iter]);
> +#endif

Should this be a __paginginit function inside one of the
autonuma files, so we can avoid the ifdefs here?

-- 
All rights reversed
