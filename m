Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041Ab2JKRRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 13:17:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759027Ab2JKRRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 13:17:12 -0400
Date: Thu, 11 Oct 2012 19:15:20 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <pzijlstr@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hillf Danton <dhillf@gmail.com>,
        Andrew Jones <drjones@redhat.com>, Dan Smith <danms@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Christoph Lameter <cl@linux.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 07/33] autonuma: mm_autonuma and task_autonuma data
 structures
Message-ID: <20121011171519.GQ1818@redhat.com>
References: <1349308275-2174-1-git-send-email-aarcange@redhat.com>
 <1349308275-2174-8-git-send-email-aarcange@redhat.com>
 <20121011122827.GT3317@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011122827.GT3317@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 01:28:27PM +0100, Mel Gorman wrote:
> s/togehter/together/

Fixed.

> 
> > + * knumad_scan structure.
> > + */
> > +struct mm_autonuma {
> 
> Nit but this is very similar in principle to mm_slot for transparent
> huge pages. It might be worth renaming both to mm_thp_slot and
> mm_autonuma_slot to set the expectation they are very similar in nature.
> Could potentially be made generic but probably overkill.

Agreed. A plain rename to mm_autonuma_slot would have the only cons of
making some code spill over 80 col ;).

> > +	/* link for knuma_scand's list of mm structures to scan */
> > +	struct list_head mm_node;
> > +	/* Pointer to associated mm structure */
> > +	struct mm_struct *mm;
> > +
> > +	/*
> > +	 * Zeroed from here during allocation, check
> > +	 * mm_autonuma_reset() if you alter the below.
> > +	 */
> > +
> > +	/*
> > +	 * Pass counter for this mm. This exist only to be able to
> > +	 * tell when it's time to apply the exponential backoff on the
> > +	 * task_autonuma statistics.
> > +	 */
> > +	unsigned long mm_numa_fault_pass;
> > +	/* Total number of pages that will trigger NUMA faults for this mm */
> > +	unsigned long mm_numa_fault_tot;
> > +	/* Number of pages that will trigger NUMA faults for each [nid] */
> > +	unsigned long mm_numa_fault[0];
> > +	/* do not add more variables here, the above array size is dynamic */
> > +};
> 
> How cache hot is this structure? nodes are sharing counters in the same
> cache lines so if updates are frequent this will bounce like a mad yoke.
> Profiles will tell for sure but it's possible that some sort of per-cpu
> hilarity will be necessary here in the future.

On autonuma27 this is only written by knuma_scand so it won't risk to
bounce.

On autonuma28 however it's updated by the numa hinting page fault
locklessy and so your concern is very real, and the cacheline bounces
will materialize. It'll cause more interconnect traffic before the
workload converges too. I thought about that, but I wanted the
mm_autonuma updated in real time as migration happens otherwise it
converges more slowly if we have to wait until the next pass to bring
mm_autonuma statistical data in sync with the migration
activities. Converging more slowly looked worse than paying more
cacheline bounces.

It's a tradeoff. And if it's not a good one, we can go back to
autonuma27 mm_autonuma stat gathering method and converge slower but
without any cacheline bouncing in the NUMA hinting page faults. At
least it's lockless.

> > +	unsigned long task_numa_fault_pass;
> > +	/* Total number of eligible pages that triggered NUMA faults */
> > +	unsigned long task_numa_fault_tot;
> > +	/* Number of pages that triggered NUMA faults for each [nid] */
> > +	unsigned long task_numa_fault[0];
> > +	/* do not add more variables here, the above array size is dynamic */
> > +};
> > +
> 
> Same question about cache hotness.

Here it's per-thread, so there won't be risk of accesses interleaved
by different CPUs.
