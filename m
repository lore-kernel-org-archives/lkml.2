Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab2E2Q2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:28:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:58451 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab2E2Q2W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:28:22 -0400
Message-ID: <1338308875.26856.121.camel@twins>
Subject: Re: [PATCH 23/35] autonuma: core
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
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
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Date: Tue, 29 May 2012 18:27:55 +0200
In-Reply-To: <1337965359-29725-24-git-send-email-aarcange@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
	 <1337965359-29725-24-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 19:02 +0200, Andrea Arcangeli wrote:
> This implements knuma_scand, the numa_hinting faults started by
> knuma_scand, the knuma_migrated that migrates the memory queued by the
> NUMA hinting faults, the statistics gathering code that is done by
> knuma_scand for the mm_autonuma and by the numa hinting page faults
> for the sched_autonuma, and most of the rest of the AutoNUMA core
> logics like the false sharing detection, sysfs and initialization
> routines.
> 
> The AutoNUMA algorithm when knuma_scand is not running is a full
> bypass and it must not alter the runtime of memory management and
> scheduler.
> 
> The whole AutoNUMA logic is a chain reaction as result of the actions
> of the knuma_scand. The various parts of the code can be described
> like different gears (gears as in glxgears).
> 
> knuma_scand is the first gear and it collects the mm_autonuma per-process
> statistics and at the same time it sets the pte/pmd it scans as
> pte_numa and pmd_numa.
> 
> The second gear are the numa hinting page faults. These are triggered
> by the pte_numa/pmd_numa pmd/ptes. They collect the sched_autonuma
> per-thread statistics. They also implement the memory follow CPU logic
> where we track if pages are repeatedly accessed by remote nodes. The
> memory follow CPU logic can decide to migrate pages across different
> NUMA nodes by queuing the pages for migration in the per-node
> knuma_migrated queues.
> 
> The third gear is knuma_migrated. There is one knuma_migrated daemon
> per node. Pages pending for migration are queued in a matrix of
> lists. Each knuma_migrated (in parallel with each other) goes over
> those lists and migrates the pages queued for migration in round robin
> from each incoming node to the node where knuma_migrated is running
> on.
> 
> The fourth gear is the NUMA scheduler balancing code. That computes
> the statistical information collected in mm->mm_autonuma and
> p->sched_autonuma and evaluates the status of all CPUs to decide if
> tasks should be migrated to CPUs in remote nodes. 

IOW:

"knuma_scand 'unmaps' ptes and collects mm stats, this triggers
numa_hinting pagefaults, using these we collect per task stats.

knuma_migrated migrates pages to their destination node. Something
queues pages.

The numa scheduling code uses the gathered stats to place tasks."


That covers just about all you said, now the interesting bits are still
missing:

 - how do you do false sharing;

 - what stats do you gather, and how are they used at each stage;

 - what's your balance goal, and how is that expressed and 
   converged upon.

Also, what I've not seen anywhere are scheduling stats, what if, despite
you giving a hint a particular process should run on a particular node
it doesn't and sticks to where its at (granted with strict this can't
happen -- but it should).


