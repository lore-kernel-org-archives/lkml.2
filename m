Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab2I0KIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:08:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab2I0KIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:08:15 -0400
Date: Thu, 27 Sep 2012 12:08:06 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
Message-ID: <20120927100806.GK23096@redhat.com>
References: <50607F1F.2040704@redhat.com>
 <5060851E.1030404@redhat.com>
 <506166B4.4010207@linux.vnet.ibm.com>
 <5061713D.5060406@redhat.com>
 <20120927074405.GE23096@redhat.com>
 <50641569.9060305@redhat.com>
 <20120927091112.GG23096@redhat.com>
 <50641D84.2020807@redhat.com>
 <20120927095824.GJ23096@redhat.com>
 <506424CA.600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506424CA.600@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 12:04:58PM +0200, Avi Kivity wrote:
> On 09/27/2012 11:58 AM, Gleb Natapov wrote:
> > 
> >> >  
> >> >> btw, we can have secondary effects.  A vcpu can be waiting for a lock in
> >> >> the host kernel, or for a host page fault.  There's no point in boosting
> >> >> anything for that.  Or a vcpu in userspace can be waiting for a lock
> >> >> that is held by another thread, which has been preempted. 
> >> > Do you mean userspace spinlock? Because otherwise task that's waits on
> >> > a kernel lock will sleep in the kernel.
> >> 
> >> I meant a kernel mutex.
> >> 
> >> vcpu 0: take guest spinlock
> >> vcpu 0: vmexit
> >> vcpu 0: spin_lock(some_lock)
> >> vcpu 1: take same guest spinlock
> >> vcpu 1: PLE vmexit
> >> vcpu 1: wtf?
> >> 
> >> Waiting on a host kernel spinlock is not too bad because we expect to be
> >> out shortly.  Waiting on a host kernel mutex can be a lot worse.
> >> 
> > We can't do much about it without PV spinlock since there is not
> > information about what vcpu holds which guest spinlock, no?
> 
> It doesn't help.  If the lock holder is waiting for another lock in the
> host kernel, boosting it doesn't help even if we know who it is.  We
> need to boost the real lock holder, but we have no idea who it is (and
> even if we did, we often can't do anything about it).
> 
Without PV lock we will boost random preempted vcpu instead of going to
sleep in the situation you described.

--
			Gleb.
