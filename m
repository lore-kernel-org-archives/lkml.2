Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914Ab2JKQoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 12:44:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758266Ab2JKQoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 12:44:02 -0400
Date: Thu, 11 Oct 2012 18:43:00 +0200
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
Subject: Re: [PATCH 04/33] autonuma: define _PAGE_NUMA
Message-ID: <20121011164300.GN1818@redhat.com>
References: <1349308275-2174-1-git-send-email-aarcange@redhat.com>
 <1349308275-2174-5-git-send-email-aarcange@redhat.com>
 <20121011110137.GQ3317@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011110137.GQ3317@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 12:01:37PM +0100, Mel Gorman wrote:
> On Thu, Oct 04, 2012 at 01:50:46AM +0200, Andrea Arcangeli wrote:
> > The objective of _PAGE_NUMA is to be able to trigger NUMA hinting page
> > faults to identify the per NUMA node working set of the thread at
> > runtime.
> > 
> > Arming the NUMA hinting page fault mechanism works similarly to
> > setting up a mprotect(PROT_NONE) virtual range: the present bit is
> > cleared at the same time that _PAGE_NUMA is set, so when the fault
> > triggers we can identify it as a NUMA hinting page fault.
> > 
> 
> That implies that there is an atomic update requirement or at least
> an ordering requirement -- present bit must be cleared before setting
> NUMA bit. No doubt it'll be clear later in the series how this is
> accomplished. What you propose seems ok but it all depends how it's
> implemented so I'm leaving my ack off this particular patch for now.

Correct. The switch is done atomically (clear _PAGE_PRESENT at the
same time _PAGE_NUMA is set). The tlb flush is deferred (it's batched
to avoid firing an IPI for every pte/pmd_numa we establish).

It's still similar to setting a range PROT_NONE (except the way
_PAGE_PROTNONE and _PAGE_NUMA works is the opposite, and they are
mutually exclusive, so they can easily share the same pte/pmd
bitflag). Except PROT_NONE must be synchronous, _PAGE_NUMA is set lazily.

The NUMA hinting page fault also won't require any TLB flush ever.

So the whole process (establish/teardown) has an incredibly low TLB
flushing cost.

The only fixed cost is in knuma_scand and the enter/exit kernel for
every not-shared page every 10 sec (or whatever you set the duration
of a knuma_scand pass in sysfs).

Furthermore, if the pmd_scan mode is activated, I guarantee there's at
max 1 NUMA hinting page fault every 2m virtual region (even if some
accuracy is lost). You can try to set scan_pmd = 0 in sysfs and also
to disable THP (echo never >enabled) to measure the exact cost per 4k
page. It's hardly measurable here. With THP the fault is also 1 every
2m virtual region but no accuracy is lost in that case (or more
precisely, there's no way to get more accuracy than that as we deal
with a pmd).
