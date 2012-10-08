Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab2JHUfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 16:35:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab2JHUfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 16:35:33 -0400
Date: Mon, 8 Oct 2012 16:34:24 -0400
From: Rik van Riel <riel@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <pzijlstr@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hillf Danton <dhillf@gmail.com>,
        Andrew Jones <drjones@redhat.com>, Dan Smith <danms@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Christoph Lameter <cl@linux.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad@linux.intel.com, dshaks@redhat.com
Subject: Re: [PATCH 00/33] AutoNUMA27
Message-ID: <20121008163424.335ea7ec@annuminas.surriel.com>
In-Reply-To: <m24nm8wly3.fsf@firstfloor.org>
References: <1349308275-2174-1-git-send-email-aarcange@redhat.com>
	<20121004113943.be7f92a0.akpm@linux-foundation.org>
	<m24nm8wly3.fsf@firstfloor.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Oct 2012 16:14:44 -0700
Andi Kleen <andi@firstfloor.org> wrote:

> IMHO needs a performance shot-out. Run both on the same 10 workloads
> and see who wins. Just a lot of of work. Any volunteers?

Here are some preliminary results from simple benchmarks on a
4-node, 32 CPU core (4x8 core) Dell PowerEdge R910 system.

For the simple linpack streams benchmark, both sched/numa and
autonuma are within the margin of error compared to manual
tuning of task affinity.  This is a big win, since the current
upstream scheduler has regressions of 10-20% when the system
runs 4 through 16 streams processes.

For specjbb, the story is more complicated. After fixing the
obvious bugs in sched/numa, and getting some basic cpu-follows-memory
code (not yet in -tip AFAIK), Larry, Peter and I, averaged results
look like this:

baseline: 	246019
manual pinning: 285481 (+16%)
autonuma:	266626 (+8%)
sched/numa:	226540 (-8%)

This is with newer sched/numa code than what is in -tip right now.
Once Peter pushes the fixes by Larry and me into -tip, as well as
his cpu-follows-memory code, others should be able to run tests
like this as well.

Now for some other workloads, and tests on 8 node systems, etc...


Full results for the specjbb run below:

BASELINE - disabling auto numa (matches RHEL6 within 1%)

[root@perf74 SPECjbb]# cat r7_36_auto27_specjbb4_noauto.txt
spec1.txt:           throughput =     243639.70 SPECjbb2005 bops
spec2.txt:           throughput =     249186.20 SPECjbb2005 bops
spec3.txt:           throughput =     247216.72 SPECjbb2005 bops
spec4.txt:           throughput =     244035.60 SPECjbb2005 bops

Manual NUMACTL results are:

[root@perf74 SPECjbb]# more r7_36_numactl_specjbb4.txt
spec1.txt:           throughput =     291430.22 SPECjbb2005 bops
spec2.txt:           throughput =     283550.85 SPECjbb2005 bops
spec3.txt:           throughput =     284028.71 SPECjbb2005 bops
spec4.txt:           throughput =     282919.37 SPECjbb2005 bops

AUTONUMA27 - 3.6.0-0.24.autonuma27.test.x86_64
[root@perf74 SPECjbb]# more r7_36_auto27_specjbb4.txt
spec1.txt:           throughput =     261835.01 SPECjbb2005 bops
spec2.txt:           throughput =     269053.06 SPECjbb2005 bops
spec3.txt:           throughput =     261230.50 SPECjbb2005 bops
spec3.txt:           throughput =     274386.81 SPECjbb2005 bops

Tuned SCHED_NUMA from Friday 10/4/2012 with fixes from Peter, Rik and 
Larry:

[root@perf74 SPECjbb]# more r7_36_schednuma_specjbb4.txt
spec1.txt:           throughput =     222349.74 SPECjbb2005 bops
spec2.txt:           throughput =     232988.59 SPECjbb2005 bops
spec3.txt:           throughput =     223386.03 SPECjbb2005 bops
spec4.txt:           throughput =     227438.11 SPECjbb2005 bops

-- 
All rights reversed.
