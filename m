Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab2KMHYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:24:50 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49415 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab2KMHYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:24:48 -0500
Date: Tue, 13 Nov 2012 08:24:41 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/8] Announcement: Enhanced NUMA scheduling with adaptive
 affinity
Message-ID: <20121113072441.GA21386@gmail.com>
References: <20121112160451.189715188@chello.nl>
 <0000013af701ca15-3acab23b-a16d-4e38-9dc0-efef05cbc5f2-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013af701ca15-3acab23b-a16d-4e38-9dc0-efef05cbc5f2-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Mon, 12 Nov 2012, Peter Zijlstra wrote:
> 
> > The biggest conceptual addition, beyond the elimination of 
> > the home node, is that the scheduler is now able to 
> > recognize 'private' versus 'shared' pages, by carefully 
> > analyzing the pattern of how CPUs touch the working set 
> > pages. The scheduler automatically recognizes tasks that 
> > share memory with each other (and make dominant use of that 
> > memory) - versus tasks that allocate and use their working 
> > set privately.
> 
> That is a key distinction to make and if this really works 
> then that is major progress.

I posted updated benchmark results yesterday, and the approach 
is indeed a performance breakthrough:

    http://lkml.org/lkml/2012/11/12/330

It also made the code more generic and more maintainable from a 
scheduler POV.

> > This new scheduler code is then able to group tasks that are 
> > "memory related" via their memory access patterns together: 
> > in the NUMA context moving them on the same node if 
> > possible, and spreading them amongst nodes if they use 
> > private memory.
> 
> What happens if processes memory accesses are related but the 
> common set of data does not fit into the memory provided by a 
> single node?

The other (very common) node-overload case is that there are 
more tasks for a shared piece of memory than fits on a single 
node.

I have measured two such workloads, one is the Java SPEC 
benchmark:

   v3.7-vanilla:     494828 transactions/sec
   v3.7-NUMA:        627228 transactions/sec    [ +26.7% ]

the other is the 'numa01' testcase of autonumabench:

   v3.7-vanilla:      340.3 seconds
   v3.7-NUMA:         216.9 seconds             [ +56% ]

> The correct resolution usually is in that case to interleasve 
> the pages over both nodes in use.

I'd not go as far as to claim that to be a general rule: the 
correct placement depends on the system and workload specifics: 
how much memory is on each node, how many tasks run on each 
node, and whether the access patterns and working set of the 
tasks is symmetric amongst each other - which is not a given at 
all.

Say consider a database server that executes small and large 
queries over a large, memory-shared database, and has worker 
tasks to clients, to serve each query. Depending on the nature 
of the queries, interleaving can easily be the wrong thing to 
do.

Thanks,

	Ingo
