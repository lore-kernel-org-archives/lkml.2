Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab1ETVt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 17:49:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751785Ab1ETVtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 17:49:49 -0400
Date: Fri, 20 May 2011 14:49:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, hannes@cmpxchg.org,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 6/8] memcg asynchronous memory reclaim interface
Message-Id: <20110520144935.3bfdb2e2.akpm@linux-foundation.org>
In-Reply-To: <20110520124636.45c26cfa.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110520123749.d54b32fa.kamezawa.hiroyu@jp.fujitsu.com>
	<20110520124636.45c26cfa.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011 12:46:36 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> This patch adds a logic to keep usage margin to the limit in asynchronous way.
> When the usage over some threshould (determined automatically), asynchronous
> memory reclaim runs and shrink memory to limit - MEMCG_ASYNC_STOP_MARGIN.
> 
> By this, there will be no difference in total amount of usage of cpu to
> scan the LRU

This is not true if "don't writepage at all (revisit this when
dirty_ratio comes.)" is true.  Skipping over dirty pages can cause
larger amounts of CPU consumption.

> but we'll have a chance to make use of wait time of applications
> for freeing memory. For example, when an application read a file or socket,
> to fill the newly alloated memory, it needs wait. Async reclaim can make use
> of that time and give a chance to reduce latency by background works.
> 
> This patch only includes required hooks to trigger async reclaim and user interfaces.
> Core logics will be in the following patches.
> 
>
> ...
>
>  /*
> + * For example, with transparent hugepages, memory reclaim scan at hitting
> + * limit can very long as to reclaim HPAGE_SIZE of memory. This increases
> + * latency of page fault and may cause fallback. At usual page allocation,
> + * we'll see some (shorter) latency, too. To reduce latency, it's appreciated
> + * to free memory in background to make margin to the limit. This consumes
> + * cpu but we'll have a chance to make use of wait time of applications
> + * (read disk etc..) by asynchronous reclaim.
> + *
> + * This async reclaim tries to reclaim HPAGE_SIZE * 2 of pages when margin
> + * to the limit is smaller than HPAGE_SIZE * 2. This will be enabled
> + * automatically when the limit is set and it's greater than the threshold.
> + */
> +#if HPAGE_SIZE != PAGE_SIZE
> +#define MEMCG_ASYNC_LIMIT_THRESH      (HPAGE_SIZE * 64)
> +#define MEMCG_ASYNC_MARGIN	      (HPAGE_SIZE * 4)
> +#else /* make the margin as 4M bytes */
> +#define MEMCG_ASYNC_LIMIT_THRESH      (128 * 1024 * 1024)
> +#define MEMCG_ASYNC_MARGIN            (8 * 1024 * 1024)
> +#endif

Document them, please.  How are they used, what are their units.

> +static void mem_cgroup_may_async_reclaim(struct mem_cgroup *mem);
> +
> +/*
>   * The memory controller data structure. The memory controller controls both
>   * page cache and RSS per cgroup. We would eventually like to provide
>   * statistics based on the statistics developed by Rik Van Riel for clock-pro,
> @@ -278,6 +303,12 @@ struct mem_cgroup {
>  	 */
>  	unsigned long 	move_charge_at_immigrate;
>  	/*
> + 	 * Checks for async reclaim.
> + 	 */
> +	unsigned long	async_flags;
> +#define AUTO_ASYNC_ENABLED	(0)
> +#define USE_AUTO_ASYNC		(1)

These are really confusing.  I looked at the implementation and at the
documentation file and I'm still scratching my head.  I can't work out
why they exist.  With the amount of effort I put into it ;)

Also, AUTO_ASYNC_ENABLED and USE_AUTO_ASYNC have practically the same
meaning, which doesn't help things.

Some careful description at this place in the code might help clear
things up.

Perhaps s/USE_AUTO_ASYNC/AUTO_ASYNC_IN_USE/ is what you meant.

>
> ...
>
> +static void mem_cgroup_may_async_reclaim(struct mem_cgroup *mem)
> +{
> +	if (!test_bit(USE_AUTO_ASYNC, &mem->async_flags))
> +		return;
> +	if (res_counter_margin(&mem->res) <= MEMCG_ASYNC_MARGIN) {
> +		/* Fill here */
> +	}
> +}

I'd expect a function called foo_may_bar() to return a bool.

But given the lack of documentation and no-op implementation, I have o
idea what's happening here!

>
> ...
>
