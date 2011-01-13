Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab1AMF2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 00:28:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab1AMF2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 00:28:04 -0500
Date: Thu, 13 Jan 2011 00:21:08 -0500
From: Rik van Riel <riel@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [RFC -v4 PATCH 0/3] directed yield for Pause Loop Exiting
Message-ID: <20110113002108.3abdf953@annuminas.surriel.com>
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

-- 
All rights reversed.
