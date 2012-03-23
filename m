Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab2CWQCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 12:02:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab2CWQCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 12:02:03 -0400
Date: Fri, 23 Mar 2012 17:01:29 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andrew Theurer <habanero@linux.vnet.ibm.com>
Cc: Dan Smith <danms@us.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] AutoNUMA alpha6
Message-ID: <20120323160129.GG6661@redhat.com>
References: <87fwd2d2kp.fsf@danplanet.com>
 <20120321124937.GX24602@redhat.com>
 <87limtboet.fsf@danplanet.com>
 <20120321225242.GL24602@redhat.com>
 <20120322001722.GQ24602@redhat.com>
 <873990buuy.fsf@danplanet.com>
 <20120322142735.GE24602@redhat.com>
 <20120322184925.GT24602@redhat.com>
 <87limsa2hm.fsf@danplanet.com>
 <4F6C857A.3070307@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6C857A.3070307@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 09:15:22AM -0500, Andrew Theurer wrote:
> We are working on the "more interesting benchmarks", starting with KVM 
> workloads.  However, I must warn you all, more interesting = a lot more 
> time to run.  These are a lot more complex in that they have real I/O, 
> and they can be a lot more challenging because there are response time 
> requirements (so fairness is an absolute requirement).  We are getting a 

Awesome effort!

The reason I intended to get THP native migration ASAP was exactly to
avoid having to repeat the complex "long" benchmark later to have a
more reliable figure of what is possible to achieve in the long term.

For both KVM and even for AutoNUMA internals, it's very beneficial to
run with THP on so please keep it on at all times. Very important: you
also should make sure /sys/kernel/debug/kvm/largepages is increasing
along with `grep Anon /proc/meminfo` while KVM allocates anonymous
memory (the official qemu binary is still not patched to align the
guest physical address space I'm afraid).

I changed plans and I'm doing the cleanups and documentation first
because that seems the bigger obstacle now as also pointed out by
Dan. I'll submit a more documented and splitted version of AutoNUMA
(autonuma-dev branch) by early next week.

> baseline right now and re-running with our user-space VM-to-numa-node 
> placement program, which in the past achieved manual binding performance 
> or just slightly lower.  We can then compare to these two solutions.  If 
> there's something specific to collect (perhaps you have a lot of stats 
> or data in debugfs, etc) please let me know.

If you get bad performance you can log debug info with:

echo 1 >/sys/kernel/mm/autonuma/debug

Other than that, the only tweak I would suggest for virt usage is:

echo 15000 >/sys/kernel/mm/autonuma/knuma_scand/scan_sleep_pass_millisecs

and if you notice the THP numbers are too low during the benchmark in
 `grep Anon /proc/meminfo` you can use:

echo 10 >/sys/kernel/mm/transparent_hugepage/khugepaged/scan_sleep_millisecs

With current autonuma and autonuma-dev branches, I already set the
latter to 100 on NUMA hardware (upstream default was an unconditional
10000), but 10 would make khugepaged even faster at rebuilding
THP. Not sure if getting as low as 10 is needed. But I mention it
because 10 was used during specjbb and worked great. I would try with
100 first and lower to 10 as last resort. The workload changes for
virt should not be as fast as with normal host workloads so a value of
100 should be enough. Once we get THP native migration this value can
return to 10000.

Thanks,
Andrea
