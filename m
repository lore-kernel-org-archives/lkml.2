Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab2KMQJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:09:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab2KMQJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:09:36 -0500
Message-ID: <50A270AB.5040305@redhat.com>
Date: Tue, 13 Nov 2012 11:09:15 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/8] sched, numa, mm: Add last_cpu to page flags
References: <20121112160451.189715188@chello.nl> <20121112161215.685202629@chello.nl>
In-Reply-To: <20121112161215.685202629@chello.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 11:04 AM, Peter Zijlstra wrote:
> @@ -706,6 +669,51 @@ static inline int page_to_nid(const stru
>   }
>   #endif
>
> +#ifdef CONFIG_SCHED_NUMA
> +#ifdef LAST_CPU_NOT_IN_PAGE_FLAGS
> +static inline int page_xchg_last_cpu(struct page *page, int cpu)
> +{
> +	return xchg(&page->_last_cpu, cpu);
> +}
> +
> +static inline int page_last_cpu(struct page *page)
> +{
> +	return page->_last_cpu;
> +}
> +#else
> +static inline int page_xchg_last_cpu(struct page *page, int cpu)
> +{
> +	unsigned long old_flags, flags;
> +	int last_cpu;
> +
> +	do {
> +		old_flags = flags = page->flags;
> +		last_cpu = (flags >> LAST_CPU_PGSHIFT) & LAST_CPU_MASK;
> +
> +		flags &= ~(LAST_CPU_MASK << LAST_CPU_PGSHIFT);
> +		flags |= (cpu & LAST_CPU_MASK) << LAST_CPU_PGSHIFT;
> +	} while (unlikely(cmpxchg(&page->flags, old_flags, flags) != old_flags));
> +
> +	return last_cpu;
> +}

These functions, and the accompanying config option, could
use some comments and documentation, explaining why things
are done this way, why it is safe, and what (if any) constraints
it places on other users of page.flags ...

> +static inline int page_last_cpu(struct page *page)
> +{
> +	return (page->flags >> LAST_CPU_PGSHIFT) & LAST_CPU_MASK;
> +}
> +#endif /* LAST_CPU_NOT_IN_PAGE_FLAGS */
> +#else /* CONFIG_SCHED_NUMA */
> +static inline int page_xchg_last_cpu(struct page *page, int cpu)
> +{
> +	return page_to_nid(page);
> +}
> +
> +static inline int page_last_cpu(struct page *page)
> +{
> +	return page_to_nid(page);
> +}
> +#endif /* CONFIG_SCHED_NUMA */
> +


-- 
All rights reversed
