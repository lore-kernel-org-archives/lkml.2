Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab2F2SJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 14:09:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab2F2SJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 14:09:07 -0400
Message-ID: <4FEDEE9F.4080103@redhat.com>
Date: Fri, 29 Jun 2012 14:06:23 -0400
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
Subject: Re: [PATCH 14/40] autonuma: add page structure fields
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com> <1340888180-15355-15-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-15-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 08:55 AM, Andrea Arcangeli wrote:
> On 64bit archs, 20 bytes are used for async memory migration (specific
> to the knuma_migrated per-node threads), and 4 bytes are used for the
> thread NUMA false sharing detection logic.
>
> This is a bad implementation due lack of time to do a proper one.

It is not ideal, no.

If you document what everything does, maybe somebody else
will understand the code well enough to help fix it.

> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -136,6 +136,32 @@ struct page {
>   		struct page *first_page;	/* Compound tail pages */
>   	};
>
> +#ifdef CONFIG_AUTONUMA
> +	/*
> +	 * FIXME: move to pgdat section along with the memcg and allocate
> +	 * at runtime only in presence of a numa system.
> +	 */

Once you fix it, could you fold the fix into this patch?

> +	/*
> +	 * To modify autonuma_last_nid lockless the architecture,
> +	 * needs SMP atomic granularity<  sizeof(long), not all archs
> +	 * have that, notably some ancient alpha (but none of those
> +	 * should run in NUMA systems). Archs without that requires
> +	 * autonuma_last_nid to be a long.
> +	 */
> +#if BITS_PER_LONG>  32
> +	int autonuma_migrate_nid;
> +	int autonuma_last_nid;
> +#else
> +#if MAX_NUMNODES>= 32768
> +#error "too many nodes"
> +#endif
> +	/* FIXME: remember to check the updates are atomic */
> +	short autonuma_migrate_nid;
> +	short autonuma_last_nid;
> +#endif
> +	struct list_head autonuma_migrate_node;
> +#endif

Please document what these fields mean.


-- 
All rights reversed
