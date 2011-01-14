Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab1ANIGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 03:06:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757076Ab1ANIGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 03:06:20 -0500
Date: Fri, 14 Jan 2011 03:02:09 -0500
From: Rik van Riel <riel@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, dshaks@redhat.com
Subject: [RFC -v5 PATCH 0/4] directed yield for Pause Loop Exiting
Message-ID: <20110114030209.53765a0a@annuminas.surriel.com>
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


Benchmark "results":

Two 4-CPU KVM guests are pinned to the same 4 physical CPUs.

One guest runs the AMQP performance test, the other guest runs
0, 2 or 4 infinite loops, for CPU overcommit factors of 0, 1.5
and 4.

The AMQP perftest is run 30 times, with 8 and 16 threads.

8thr	no overcommit	1.5x overcommit		2x overcommit

no PLE	198918		132625			90523.5
PLE	213904		127507			95098.5

16thr	no overcommit	1.5x overcommit		2x overcommit

no PLE	197526		127941			87187.8
PLE	210696		136874			87005.9	

Note: there seems to be something wrong with CPU balancing,
possibly related to cgroups.  The AMQP guest only got about
80% CPU time (of 400% total) when running with 2x overcommit,
as opposed to the expected 200%.  Without PLE, the guest
seems to get closer to 100% CPU time, which is still far
below the expected.

Without overcommit, the AMQP guest gets about 340-350%
CPU time without the PLE code, and around 380% CPU time
with the PLE code kicking the scheduler around.

Unfortunately, it looks like this test ended up more as a 
demonstration of other scheduler issues, than as a performance 
test of the PLE code.
 
-- 
All rights reversed.
