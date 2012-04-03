Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab2DCUf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 16:35:26 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:56723 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2DCUfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 16:35:24 -0400
Date: Wed, 4 Apr 2012 02:05:00 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 00/39] [RFC] AutoNUMA alpha10
Message-ID: <20120403203500.GA14386@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12040320-2674-0000-0000-000003EE6E35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrea Arcangeli <aarcange@redhat.com> [2012-03-26 19:45:47]:

> This is the result of the first round of cleanups of the AutoNUMA patch.

I happened to test numasched and autonuma against a Java benchmark and
here are some results (higher scores are better).

Base            : 1 (std. dev : 91%)
Numa sched      : 2.17 (std. dev : 15%)
Autonuma        : 2.56 (std. dev : 10.7%)

Numa sched is ~200% better compared to "base" case. Autonuma is ~18% better 
compared to numasched. Note the high standard deviation in base case.

Also given the differences in base kernel versions for both, this is
admittedly not a apple-2-apple comparison. Getting both patches onto
common code base would help do that type of comparison!

Details:

Base = tip (ee415e2) + numasched patches posted on 3/16.
       qemu-kvm 0.12.1

Numa sched = tip (ee415e2) + numasched patches posted on 3/16.
             Modified version of qemu-kvm 1.0.50 that creates memsched groups

Autonuma = Autonuma alpha10 (SHA1 4596315). qemu-kvm 0.12.1

Machine with 2 Quad-core (w/ HT) Intel Nehalem CPUs. Two NUMA nodes each with
8GB memory.

3 VMs are created:
	VM1 and VM2, each with 4vcpus, 3GB memory and 1024 cpu.shares.
        Each of them runs memory hogs to consume total of 2.5 GB total
	memory (2.5GB memory first written to and then continuously read in a
	loop)

        VM3 of 8vcpus, 4GB memory and 2048 cpu.shares. Runs
	SPECJbb2000 benchmark w/ 8 warehouses (and consuming 2GB heap)

Benchmark was repeated 5 times. Each run consisted of launching VM1 first, 
waiting for it to initialize (wrt memory footprint), launching VM2 next, waiting
for it to initialize before launching VM3 and the benchmark inside VM3. At the 
end of benchmark, all VMs are destroyed and process repeated.

- vatsa

