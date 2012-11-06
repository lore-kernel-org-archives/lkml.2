Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab2KFTxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:53:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab2KFTx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:53:29 -0500
Message-ID: <50996B49.7070407@redhat.com>
Date: Tue, 06 Nov 2012 14:55:53 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 18/19] mm: sched: numa: Implement constant, per task Working
 Set Sampling (WSS) rate
References: <1352193295-26815-1-git-send-email-mgorman@suse.de> <1352193295-26815-19-git-send-email-mgorman@suse.de>
In-Reply-To: <1352193295-26815-19-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 04:14 AM, Mel Gorman wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> Note: The scan period is much larger than it was in the original patch.
> 	The reason was because the system CPU usage went through the roof
> 	with a sample period of 100ms but it was unsuitable to have a
> 	situation where a large process could stall for excessively long
> 	updating pte_numa. This may need to be tuned again if a placement
> 	policy converges too slowly.
>
> Previously, to probe the working set of a task, we'd use
> a very simple and crude method: mark all of its address
> space PROT_NONE.
>
> That method has various (obvious) disadvantages:
>
>   - it samples the working set at dissimilar rates,
>     giving some tasks a sampling quality advantage
>     over others.
>
>   - creates performance problems for tasks with very
>     large working sets
>
>   - over-samples processes with large address spaces but
>     which only very rarely execute
>
> Improve that method by keeping a rotating offset into the
> address space that marks the current position of the scan,
> and advance it by a constant rate (in a CPU cycles execution
> proportional manner). If the offset reaches the last mapped
> address of the mm then it then it starts over at the first
> address.
>
> The per-task nature of the working set sampling functionality in this tree
> allows such constant rate, per task, execution-weight proportional sampling
> of the working set, with an adaptive sampling interval/frequency that
> goes from once per 2 seconds up to just once per 32 seconds.  The current
> sampling volume is 256 MB per interval.
>
> As tasks mature and converge their working set, so does the
> sampling rate slow down to just a trickle, 256 MB per 8
> seconds of CPU time executed.
>
> This, beyond being adaptive, also rate-limits rarely
> executing systems and does not over-sample on overloaded
> systems.
>
> [ In AutoNUMA speak, this patch deals with the effective sampling
>    rate of the 'hinting page fault'. AutoNUMA's scanning is
>    currently rate-limited, but it is also fundamentally
>    single-threaded, executing in the knuma_scand kernel thread,
>    so the limit in AutoNUMA is global and does not scale up with
>    the number of CPUs, nor does it scan tasks in an execution
>    proportional manner.
>
>    So the idea of rate-limiting the scanning was first implemented
>    in the AutoNUMA tree via a global rate limit. This patch goes
>    beyond that by implementing an execution rate proportional
>    working set sampling rate that is not implemented via a single
>    global scanning daemon. ]
>
> [ Dan Carpenter pointed out a possible NULL pointer dereference in the
>    first version of this patch. ]
>
> Based-on-idea-by: Andrea Arcangeli <aarcange@redhat.com>
> Bug-Found-By: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Rik van Riel <riel@redhat.com>
> [ Wrote changelog and fixed bug. ]
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

