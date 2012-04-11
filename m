Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982Ab2DKBeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 21:34:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897Ab2DKBeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 21:34:06 -0400
Date: Tue, 10 Apr 2012 22:29:38 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        KVM <kvm@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>
Subject: Re: [PATCH RFC V6 0/11] Paravirtualized ticketlocks
Message-ID: <20120411012938.GC7245@amt.cnet>
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com>
 <4F7616F5.4070000@zytor.com>
 <alpine.LFD.2.02.1203302333560.2542@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1203302333560.2542@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 12:07:58AM +0200, Thomas Gleixner wrote:
> On Fri, 30 Mar 2012, H. Peter Anvin wrote:
> 
> > What is the current status of this patchset?  I haven't looked at it too
> > closely because I have been focused on 3.4 up until now...
> 
> The real question is whether these heuristics are the correct approach
> or not.
> 
> If I look at it from the non virtualized kernel side then this is ass
> backwards. We know already that we are holding a spinlock which might
> cause other (v)cpus going into eternal spin. The non virtualized
> kernel solves this by disabling preemption and therefor getting out of
> the critical section as fast as possible,
> 
> The virtualization problem reminds me a lot of the problem which RT
> kernels are observing where non raw spinlocks are turned into
> "sleeping spinlocks" and therefor can cause throughput issues for non
> RT workloads.
> 
> Though the virtualized situation is even worse. Any preempted guest
> section which holds a spinlock is prone to cause unbound delays.
> 
> The paravirt ticketlock solution can only mitigate the problem, but
> not solve it. With massive overcommit there is always a way to trigger
> worst case scenarious unless you are educating the scheduler to cope
> with that.
> 
> So if we need to fiddle with the scheduler and frankly that's the only
> way to get a real gain (the numbers, which are achieved by this
> patches, are not that impressive) then the question arises whether we
> should turn the whole thing around.
> 
> I know that Peter is going to go berserk on me, but if we are running
> a paravirt guest then it's simple to provide a mechanism which allows
> the host (aka hypervisor) to check that in the guest just by looking
> at some global state.
> 
> So if a guest exits due to an external event it's easy to inspect the
> state of that guest and avoid to schedule away when it was interrupted
> in a spinlock held section. That guest/host shared state needs to be
> modified to indicate the guest to invoke an exit when the last nested
> lock has been released.

Remember that the host is scheduling other processes than vcpus of guests. 

The case where a higher priority task (whatever that task is) interrupts
a vcpu which holds a spinlock should be frequent, in a overcommit
scenario. Whenever that is the case, other vcpus _must_ be able to stop
spinning. 

Now extrapolate that to guests with large number of vcpus. There is no
replacement for sleep-in-hypervisor-instead-of-spin.

> Of course this needs to be time bound, so a rogue guest cannot
> monopolize the cpu forever, but that's the least to worry about
> problem simply because a guest which does not get out of a spinlocked
> region within a certain amount of time is borked and elegible to
> killing anyway.
> 
> Thoughts ?
> 
> Thanks,
> 
> 	tglx
