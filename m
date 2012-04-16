Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab2DPPua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:50:30 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46797 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab2DPPu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:50:28 -0400
Date: Mon, 16 Apr 2012 11:44:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>
Subject: Re: [PATCH RFC V6 0/11] Paravirtualized ticketlocks
Message-ID: <20120416154429.GB4654@phenom.dumpdata.com>
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com>
 <4F7616F5.4070000@zytor.com>
 <alpine.LFD.2.02.1203302333560.2542@ionos>
 <20120331040745.GC14030@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120331040745.GC14030@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4F8C3F95.00E5,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 09:37:45AM +0530, Srivatsa Vaddagiri wrote:
> * Thomas Gleixner <tglx@linutronix.de> [2012-03-31 00:07:58]:
> 
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
> I had attempted something like that long back:
> 
> http://lkml.org/lkml/2010/6/3/4
> 
> The issue is with ticketlocks though. VCPUs could go into a spin w/o
> a lock being held by anybody. Say VCPUs 1-99 try to grab a lock in
> that order (on a host with one cpu). VCPU1 wins (after VCPU0 releases it)
> and releases the lock. VCPU1 is next eligible to take the lock. If 
> that is not scheduled early enough by host, then remaining vcpus would keep 
> spinning (even though lock is technically not held by anybody) w/o making 
> forward progress.
> 
> In that situation, what we really need is for the guest to hint to host
> scheduler to schedule VCPU1 early (via yield_to or something similar). 
> 
> The current pv-spinlock patches however does not track which vcpu is
> spinning at what head of the ticketlock. I suppose we can consider 
> that optimization in future and see how much benefit it provides (over
> plain yield/sleep the way its done now).

Right. I think Jeremy played around with this some time?
> 
> Do you see any issues if we take in what we have today and address the
> finer-grained optimization as next step?

I think that is the proper course - these patches show
that on baremetal we don't incur performance regressions and in
virtualization case we benefit greatly. Since these are the basic
building blocks of a kernel - taking it slow and just adding
this set of patches for v3.5 is a good idea - and then building on top
of that for further refinement.

> 
> - vatsa 
