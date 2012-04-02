Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab2DBJ0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 05:26:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:48752 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab2DBJ0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:26:42 -0400
Date: Mon, 2 Apr 2012 11:26:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Avi Kivity <avi@redhat.com>
cc: "H. Peter Anvin" <hpa@zytor.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>
Subject: Re: [PATCH RFC V6 0/11] Paravirtualized ticketlocks
In-Reply-To: <4F7858C0.90405@redhat.com>
Message-ID: <alpine.LFD.2.02.1204021117560.2542@ionos>
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com> <4F7616F5.4070000@zytor.com> <alpine.LFD.2.02.1203302333560.2542@ionos> <4F7858C0.90405@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2012, Avi Kivity wrote:
> On 03/31/2012 01:07 AM, Thomas Gleixner wrote:
> > On Fri, 30 Mar 2012, H. Peter Anvin wrote:
> >
> > > What is the current status of this patchset?  I haven't looked at it too
> > > closely because I have been focused on 3.4 up until now...
> >
> > The real question is whether these heuristics are the correct approach
> > or not.
> >
> > If I look at it from the non virtualized kernel side then this is ass
> > backwards. We know already that we are holding a spinlock which might
> > cause other (v)cpus going into eternal spin. The non virtualized
> > kernel solves this by disabling preemption and therefor getting out of
> > the critical section as fast as possible,
> >
> > The virtualization problem reminds me a lot of the problem which RT
> > kernels are observing where non raw spinlocks are turned into
> > "sleeping spinlocks" and therefor can cause throughput issues for non
> > RT workloads.
> >
> > Though the virtualized situation is even worse. Any preempted guest
> > section which holds a spinlock is prone to cause unbound delays.
> >
> > The paravirt ticketlock solution can only mitigate the problem, but
> > not solve it. With massive overcommit there is always a way to trigger
> > worst case scenarious unless you are educating the scheduler to cope
> > with that.
> >
> > So if we need to fiddle with the scheduler and frankly that's the only
> > way to get a real gain (the numbers, which are achieved by this
> > patches, are not that impressive) then the question arises whether we
> > should turn the whole thing around.
> >
> > I know that Peter is going to go berserk on me, but if we are running
> > a paravirt guest then it's simple to provide a mechanism which allows
> > the host (aka hypervisor) to check that in the guest just by looking
> > at some global state.
> >
> > So if a guest exits due to an external event it's easy to inspect the
> > state of that guest and avoid to schedule away when it was interrupted
> > in a spinlock held section. That guest/host shared state needs to be
> > modified to indicate the guest to invoke an exit when the last nested
> > lock has been released.
> 
> Interesting idea (I think it has been raised before btw, don't recall by
> who).

Someoen posted a pointer to that old thread.

> One thing about it is that it can give many false positives.  Consider a
> fine-grained spinlock that is being accessed by many threads.  That is,
> the lock is taken and released with high frequency, but there is no
> contention, because each vcpu is accessing a different instance.  So the
> host scheduler will needlessly delay preemption of vcpus that happen to
> be holding a lock, even though this gains nothing.

You're talking about per cpu locks, right? I can see the point there,
but per cpu stuff might be worth annotating to avoid this.
 
> A second issue may happen with a lock that is taken and released with
> high frequency, with a high hold percentage.  The host scheduler may
> always sample the guest in a held state, leading it to conclude that
> it's exceeding its timeout when in fact the lock is held for a short
> time only.

Well, no. You can avoid that.

host		VCPU
		spin_lock()
		 modify_global_state()
   	exit
check_global_state()
mark_global_state()
reschedule vcpu

		spin_unlock()
		 check_global_state()
		  trigger_exit()

So when an exit occures in the locked section, then the host can mark
the global state to tell the guest to issue a trap on unlock.
 
> > Of course this needs to be time bound, so a rogue guest cannot
> > monopolize the cpu forever, but that's the least to worry about
> > problem simply because a guest which does not get out of a spinlocked
> > region within a certain amount of time is borked and elegible to
> > killing anyway.
> 
> Hopefully not killing!  Just because a guest doesn't scale well, or even
> if it's deadlocked, doesn't mean it should be killed.  Just preempt it.

:)
 
> > Thoughts ?
> 
> It's certainly interesting.  Maybe a combination is worthwhile - prevent
> lockholder preemption for a short period of time AND put waiters to
> sleep in case that period is insufficient to release the lock.

Right, but as Srivatsa pointed out this still needs the ticket lock
ordering support to avoid that guests are completely starved.

Thanks,

	tglx
