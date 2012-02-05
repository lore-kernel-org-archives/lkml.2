Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab2BEK6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 05:58:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432Ab2BEK6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 05:58:08 -0500
Date: Sun, 5 Feb 2012 12:58:04 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [RFC] Next gen kvm api
Message-ID: <20120205105804.GS23536@redhat.com>
References: <4F2AB552.2070909@redhat.com>
 <20120205093723.GQ23536@redhat.com>
 <4F2E4F8B.8090504@redhat.com>
 <20120205095153.GA29265@redhat.com>
 <4F2E5245.3070400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2E5245.3070400@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 05, 2012 at 11:56:21AM +0200, Avi Kivity wrote:
> On 02/05/2012 11:51 AM, Gleb Natapov wrote:
> > On Sun, Feb 05, 2012 at 11:44:43AM +0200, Avi Kivity wrote:
> > > On 02/05/2012 11:37 AM, Gleb Natapov wrote:
> > > > On Thu, Feb 02, 2012 at 06:09:54PM +0200, Avi Kivity wrote:
> > > > > Device model
> > > > > ------------
> > > > > Currently kvm virtualizes or emulates a set of x86 cores, with or
> > > > > without local APICs, a 24-input IOAPIC, a PIC, a PIT, and a number of
> > > > > PCI devices assigned from the host.  The API allows emulating the local
> > > > > APICs in userspace.
> > > > > 
> > > > > The new API will do away with the IOAPIC/PIC/PIT emulation and defer
> > > > > them to userspace.  Note: this may cause a regression for older guests
> > > > > that don't support MSI or kvmclock.  Device assignment will be done
> > > > > using VFIO, that is, without direct kvm involvement.
> > > > > 
> > > > So are we officially saying that KVM is only for modern guest
> > > > virtualization? 
> > > 
> > > No, but older guests may have reduced performance in some workloads
> > > (e.g. RHEL4 gettimeofday() intensive workloads).
> > > 
> > Reduced performance is what I mean. Obviously old guests will continue working.
> 
> I'm not happy about it either.
> 
It is not only about old guests either. In RHEL we pretend to not
support HPET because when some guests detect it they are accessing
its mmio frequently for certain workloads. For Linux guests we can
avoid that by using kvmclock. For Windows guests I hope we will have
enlightenment timers  + RTC, but what about other guests? *BSD? How often
they access HPET when it is available? We will probably have to move
HPET into the kernel if we want to make it usable.

So what is the criteria for device to be emulated in userspace vs kernelspace
in new API? Never? What about vhost-net then? Only if a device works in MSI
mode? This may work for HPET case, but looks like artificial limitation
since the problem with HPET is not interrupt latency, but mmio space
access. 

And BTW, what about enlightenment timers for Windows? Are we going to
implement them in userspace or kernel?
 
> > > > Also my not so old host kernel uses MSI only for NIC.
> > > > SATA and USB are using IOAPIC (though this is probably more HW related
> > > > than kernel version related).
> > > 
> > > For devices emulated in userspace, it doesn't matter where the IOAPIC
> > > is.  It only matters for kernel provided devices (PIT, assigned devices,
> > > vhost-net).
> > > 
> > What about EOI that will have to do additional exit to userspace for each
> > interrupt delivered?
> 
> I think the ioapic EOI is asynchronous wrt the core, yes?  So the vcpu
Probably, do not see what problem can async EOI may cause.

> can just post the EOI broadcast on the apic-bus socketpair, waking up
> the thread handling the ioapic, and continue running.  This trades off
> vcpu latency for using more host resources.
> 
Sounds good. This will increase IOAPIC interrupt latency though since next
interrupt (same GSI) can't be delivered until EOI is processed.

--
			Gleb.
