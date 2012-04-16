Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2DPQhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:37:15 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:49856 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2DPQhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:37:13 -0400
X-IronPort-AV: E=Sophos;i="4.75,430,1330905600"; 
   d="scan'208";a="11961147"
Message-ID: <1334594195.14560.236.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH RFC V6 0/11] Paravirtualized ticketlocks
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        "the arch/x86 maintainers" <x86@kernel.org>, KVM <kvm@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Andi Kleen" <andi@firstfloor.org>, Avi Kivity <avi@redhat.com>,
        "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Attilio Rao <attilio.rao@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "Stephan Diestelhorst" <stephan.diestelhorst@amd.com>
Date: Mon, 16 Apr 2012 17:36:35 +0100
In-Reply-To: <20120416154429.GB4654@phenom.dumpdata.com>
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com>
	 <4F7616F5.4070000@zytor.com>	<alpine.LFD.2.02.1203302333560.2542@ionos>
	 <20120331040745.GC14030@linux.vnet.ibm.com>
	 <20120416154429.GB4654@phenom.dumpdata.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-16 at 16:44 +0100, Konrad Rzeszutek Wilk wrote:
> On Sat, Mar 31, 2012 at 09:37:45AM +0530, Srivatsa Vaddagiri wrote:
> > * Thomas Gleixner <tglx@linutronix.de> [2012-03-31 00:07:58]:
> > 
> > > I know that Peter is going to go berserk on me, but if we are running
> > > a paravirt guest then it's simple to provide a mechanism which allows
> > > the host (aka hypervisor) to check that in the guest just by looking
> > > at some global state.
> > > 
> > > So if a guest exits due to an external event it's easy to inspect the
> > > state of that guest and avoid to schedule away when it was interrupted
> > > in a spinlock held section. That guest/host shared state needs to be
> > > modified to indicate the guest to invoke an exit when the last nested
> > > lock has been released.
> > 
> > I had attempted something like that long back:
> > 
> > http://lkml.org/lkml/2010/6/3/4
> > 
> > The issue is with ticketlocks though. VCPUs could go into a spin w/o
> > a lock being held by anybody. Say VCPUs 1-99 try to grab a lock in
> > that order (on a host with one cpu). VCPU1 wins (after VCPU0 releases it)
> > and releases the lock. VCPU1 is next eligible to take the lock. If 
> > that is not scheduled early enough by host, then remaining vcpus would keep 
> > spinning (even though lock is technically not held by anybody) w/o making 
> > forward progress.
> > 
> > In that situation, what we really need is for the guest to hint to host
> > scheduler to schedule VCPU1 early (via yield_to or something similar). 
> > 
> > The current pv-spinlock patches however does not track which vcpu is
> > spinning at what head of the ticketlock. I suppose we can consider 
> > that optimization in future and see how much benefit it provides (over
> > plain yield/sleep the way its done now).
> 
> Right. I think Jeremy played around with this some time?

5/11 "xen/pvticketlock: Xen implementation for PV ticket locks" tracks
which vcpus are waiting for a lock in "cpumask_t waiting_cpus" and
tracks which lock each is waiting for in per-cpu "lock_waiting". This is
used in xen_unlock_kick to kick the right CPU. There's a loop over only
the waiting cpus to figure out who to kick.

> > 
> > Do you see any issues if we take in what we have today and address the
> > finer-grained optimization as next step?
> 
> I think that is the proper course - these patches show
> that on baremetal we don't incur performance regressions and in
> virtualization case we benefit greatly. Since these are the basic
> building blocks of a kernel - taking it slow and just adding
> this set of patches for v3.5 is a good idea - and then building on top
> of that for further refinement.
> 
> > 
> > - vatsa 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel


