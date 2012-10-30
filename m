Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934340Ab2J3T0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:26:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934292Ab2J3TU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:20:59 -0400
Message-ID: <5090292A.3020605@redhat.com>
Date: Tue, 30 Oct 2012 15:23:22 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 26/31] sched, numa, mm: Add fault driven placement and
 migration policy
References: <20121025121617.617683848@chello.nl> <20121025124834.467791319@chello.nl>
In-Reply-To: <20121025124834.467791319@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 08:16 AM, Peter Zijlstra wrote:
> +/*
> + * Drive the periodic memory faults..
> + */
> +void task_tick_numa(struct rq *rq, struct task_struct *curr)
> +{
> +	struct callback_head *work = &curr->numa_work;
> +	u64 period, now;
> +
> +	/*
> +	 * We don't care about NUMA placement if we don't have memory.
> +	 */
> +	if (!curr->mm || (curr->flags & PF_EXITING) || work->next != work)
> +		return;

We should probably skip the whole unmap-and-refault
business if we are running on a system that is not
NUMA.  Ie. a system with just one node...

> +	/*
> +	 * Using runtime rather than walltime has the dual advantage that
> +	 * we (mostly) drive the selection from busy threads and that the
> +	 * task needs to have done some actual work before we bother with
> +	 * NUMA placement.
> +	 */
> +	now = curr->se.sum_exec_runtime;
> +	period = (u64)curr->numa_scan_period * NSEC_PER_MSEC;
> +


