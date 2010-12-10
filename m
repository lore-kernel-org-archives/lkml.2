Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750790Ab0LJFDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 00:03:54 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:37906 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab0LJFDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 00:03:53 -0500
Date: Fri, 10 Dec 2010 10:33:44 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/3] directed yield for Pause Loop Exiting
Message-ID: <20101210050344.GR3158@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101202144129.4357fe00@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101202144129.4357fe00@annuminas.surriel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rik van Riel <riel@redhat.com> [2010-12-02 14:41:29]:

> When running SMP virtual machines, it is possible for one VCPU to be
> spinning on a spinlock, while the VCPU that holds the spinlock is not
> currently running, because the host scheduler preempted it to run
> something else.
> 
> Both Intel and AMD CPUs have a feature that detects when a virtual
> CPU is spinning on a lock and will trap to the host.
> 
> The current KVM code sleeps for a bit whenever that happens, which
> results in eg. a 64 VCPU Windows guest taking forever and a bit to
> boot up.  This is because the VCPU holding the lock is actually
> running and not sleeping, so the pause is counter-productive.
> 
> In other workloads a pause can also be counter-productive, with
> spinlock detection resulting in one guest giving up its CPU time
> to the others.  Instead of spinning, it ends up simply not running
> much at all.
> 
> This patch series aims to fix that, by having a VCPU that spins
> give the remainder of its timeslice to another VCPU in the same
> guest before yielding the CPU - one that is runnable but got 
> preempted, hopefully the lock holder.
> 
> Scheduler people, please flame me with anything I may have done
> wrong, so I can do it right for a next version :)
>

This is a good problem statement, there are other things to consider
as well

1. If a hard limit feature is enabled underneath, donating the
timeslice would probably not make too much sense in that case
2. The implict assumption is that spinning is bad, but for locks
held for short durations, the assumption is not true. I presume
by the problem statement above, the h/w does the detection of
when to pause, but that is not always correct as you suggest above.
3. With respect to donating timeslices, don't scheduler cgroups
and job isolation address that problem today?
 
-- 
	Three Cheers,
	Balbir
