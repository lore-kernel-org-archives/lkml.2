Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab1AZWZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 17:25:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223Ab1AZWZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 17:25:45 -0500
Date: Wed, 26 Jan 2011 16:56:57 -0500
From: Rik van Riel <riel@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: [RFC -v7 PATCH 0/7] directed yield for Pause Loop Exiting
Message-ID: <20110126165657.2ddd2ac9@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running SMP virtual machines, it is possible for one VCPU to be
spinning on a spinlock, while the VCPU that holds the spinlock is not
currently running, because the host scheduler preempted it to run
something else.

Both Intel and AMD CPUs have a feature that detects when a virtual
CPU is spinning on a lock and will trap to the host.

The current KVM code sleeps for a bit whenever that happens, which
results in eg. a 64 VCPU Windows guest taking forever and a bit to
boot up.  This is because the VCPU holding the lock is actually
running and not sleeping, so the pause is counter-productive.

In other workloads a pause can also be counter-productive, with
spinlock detection resulting in one guest giving up its CPU time
to the others.  Instead of spinning, it ends up simply not running
much at all.

This patch series aims to fix that, by having a VCPU that spins
give the remainder of its timeslice to another VCPU in the same
guest before yielding the CPU - one that is runnable but got 
preempted, hopefully the lock holder.

v7:
- move the vcpu to pid mapping to inside the vcpu->mutex
- rename ->yield to ->skip
- merge patch 5 into patch 4
v6:
- implement yield_task_fair in a way that works with task groups,
  this allows me to actually get a performance improvement!
- fix another race Avi pointed out, the code should be good now
v5:
- fix the race condition Avi pointed out, by tracking vcpu->pid
- also allows us to yield to vcpu tasks that got preempted while in qemu
  userspace
v4:
- change to newer version of Mike Galbraith's yield_to implementation
- chainsaw out some code from Mike that looked like a great idea, but
  turned out to give weird interactions in practice
v3:
- more cleanups
- change to Mike Galbraith's yield_to implementation
- yield to spinning VCPUs, this seems to work better in some
  situations and has little downside potential
v2:
- make lots of cleanups and improvements suggested
- do not implement timeslice scheduling or fairness stuff
  yet, since it is not entirely clear how to do that right
  (suggestions welcome)


Benchmark results:

Two 4-CPU KVM guests are pinned to the same 4 physical CPUs.

One guest runs the AMQP performance test, the other guest runs
0, 2 or 4 infinite loops, for CPU overcommit factors of 0, 1.5
and 4.

The AMQP perftest is run 30 times, with message payloads of 8 and 16 bytes.

size8	no overcommit	1.5x overcommit		2x overcommit

no PLE	223801		135137			104951
PLE	224135		141105			118744

size16	no overcommit	1.5x overcommit		2x overcommit

no PLE	222424		126175			105299
PLE	222534		138082			132945

Note: this is with the KVM guests NOT running inside cgroups.  There
seems to be a CPU load balancing issue with cgroup fair group scheduling,
which often results in one guest getting only 80% CPU time and the other
guest 320%.  That will have to be fixed to get meaningful results with
cgroups.

CPU time division between the AMQP guest and the infinite loop guest
were not exactly fair, but the guests got close to the same amount
of CPU time in each test run.

There is a substantial amount of randomness in CPU time division between
guests, but the performance improvement is consistent between multiple
runs.

-- 
All rights reversed.
