Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab0LBTpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 14:45:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758042Ab0LBTpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 14:45:46 -0500
Date: Thu, 2 Dec 2010 14:41:29 -0500
From: Rik van Riel <riel@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: [RFC PATCH 0/3] directed yield for Pause Loop Exiting
Message-ID: <20101202144129.4357fe00@annuminas.surriel.com>
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

Scheduler people, please flame me with anything I may have done
wrong, so I can do it right for a next version :)

-- 
All rights reversed.
