Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab2GHSew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 14:34:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab2GHSev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 14:34:51 -0400
Message-ID: <4FF9D29D.8030903@redhat.com>
Date: Sun, 08 Jul 2012 14:34:05 -0400
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
Subject: Re: [RFC][PATCH 25/26] sched, numa: Only migrate long-running entities
References: <20120316144028.036474157@chello.nl> <20120316144241.749359061@chello.nl>
In-Reply-To: <20120316144241.749359061@chello.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 10:40 AM, Peter Zijlstra wrote:

> +static u64 process_cpu_runtime(struct numa_entity *ne)
> +{
> +	struct task_struct *p, *t;
> +	u64 runtime = 0;
> +
> +	rcu_read_lock();
> +	t = p = ne_owner(ne);
> +	if (p) do {
> +		runtime += t->se.sum_exec_runtime; // @#$#@ 32bit
> +	} while ((t = next_thread(t)) != p);
> +	rcu_read_unlock();
> +
> +	return runtime;
> +}

> +	/*
> +	 * Don't bother migrating memory if there's less than 1 second
> +	 * of runtime on the tasks.
> +	 */
> +	if (ne->nops->cpu_runtime(ne) < NSEC_PER_SEC)
> +		return false;

Do we really want to calculate the amount of CPU time used
by a process, and start migrating after just one second?

Or would it be ok to start migrating once a process has
been scanned once or twice by the NUMA code?

-- 
All rights reversed
