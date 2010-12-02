Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab0LBWmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 17:42:06 -0500
Received: from sous-sol.org ([216.99.217.87]:42837 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752844Ab0LBWmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 17:42:04 -0500
Date: Thu, 2 Dec 2010 14:41:22 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/3] directed yield for Pause Loop Exiting
Message-ID: <20101202224122.GT10050@sequoia.sous-sol.org>
References: <20101202144129.4357fe00@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101202144129.4357fe00@annuminas.surriel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rik van Riel (riel@redhat.com) wrote:
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

Seems like simply increasing the spin window help in that case?  Or is
it just too contended a lock (I think they use mcs locks, so I can see a
single wrong sleep causing real contention problems).

> In other workloads a pause can also be counter-productive, with
> spinlock detection resulting in one guest giving up its CPU time
> to the others.  Instead of spinning, it ends up simply not running
> much at all.
> 
> This patch series aims to fix that, by having a VCPU that spins
> give the remainder of its timeslice to another VCPU in the same
> guest before yielding the CPU - one that is runnable but got 
> preempted, hopefully the lock holder.
