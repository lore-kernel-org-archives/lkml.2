Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab2GGS10 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 14:27:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab2GGS1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 14:27:25 -0400
Message-ID: <4FF87F5F.30106@redhat.com>
Date: Sat, 07 Jul 2012 14:26:39 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 14/26] sched, numa: Numa balancer
References: <20120316144028.036474157@chello.nl> <20120316144241.012558280@chello.nl>
In-Reply-To: <20120316144241.012558280@chello.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 10:40 AM, Peter Zijlstra wrote:

> +/*
> + * Assumes symmetric NUMA -- that is, each node is of equal size.
> + */
> +static void set_max_mem_load(unsigned long load)
> +{
> +	unsigned long old_load;
> +
> +	spin_lock(&max_mem_load.lock);
> +	old_load = max_mem_load.load;
> +	if (!old_load)
> +		old_load = load;
> +	max_mem_load.load = (old_load + load) >> 1;
> +	spin_unlock(&max_mem_load.lock);
> +}

The above in your patch kind of conflicts with this bit
from patch 6/26:

+	/*
+	 * Migration allocates pages in the highest zone. If we cannot
+	 * do so then migration (at least from node to node) is not
+	 * possible.
+	 */
+	if (vma->vm_file &&
+		gfp_zone(mapping_gfp_mask(vma->vm_file->f_mapping))
+								< policy_zone)
+			return 0;

Looking at how the memory load code is used, I wonder
if it would make sense to count "zone size - free - inactive
file" pages instead?

> +			/*
> +			 * Avoid migrating ne's when we'll know we'll push our
> +			 * node over the memory limit.
> +			 */
> +			if (max_mem_load &&
> +			    imb->mem_load + mem_moved + ne_mem > max_mem_load)
> +				goto next;

> +static void numa_balance(struct node_queue *this_nq)
> +{
> +	struct numa_imbalance imb;
> +	int busiest;
> +
> +	busiest = find_busiest_node(this_nq->node, &imb);
> +	if (busiest == -1)
> +		return;
> +
> +	if (imb.cpu <= 0 && imb.mem <= 0)
> +		return;
> +
> +	move_processes(nq_of(busiest), this_nq, &imb);
> +}

You asked how and why Andrea's algorithm converges.
After looking at both patch sets for a while, and asking
for clarification, I think I can see how his code converges.

It is not yet clear to me how and why your code converges.

I see some dual bin packing (CPU & memory) heuristics, but
it is not at all clear to me how they interact, especially
when workloads are going active and idle on a regular basis.

-- 
All rights reversed
