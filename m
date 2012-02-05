Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab2BEJ40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 04:56:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab2BEJ4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 04:56:25 -0500
Message-ID: <4F2E5245.3070400@redhat.com>
Date: Sun, 05 Feb 2012 11:56:21 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <20120205093723.GQ23536@redhat.com> <4F2E4F8B.8090504@redhat.com> <20120205095153.GA29265@redhat.com>
In-Reply-To: <20120205095153.GA29265@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2012 11:51 AM, Gleb Natapov wrote:
> On Sun, Feb 05, 2012 at 11:44:43AM +0200, Avi Kivity wrote:
> > On 02/05/2012 11:37 AM, Gleb Natapov wrote:
> > > On Thu, Feb 02, 2012 at 06:09:54PM +0200, Avi Kivity wrote:
> > > > Device model
> > > > ------------
> > > > Currently kvm virtualizes or emulates a set of x86 cores, with or
> > > > without local APICs, a 24-input IOAPIC, a PIC, a PIT, and a number of
> > > > PCI devices assigned from the host.  The API allows emulating the local
> > > > APICs in userspace.
> > > > 
> > > > The new API will do away with the IOAPIC/PIC/PIT emulation and defer
> > > > them to userspace.  Note: this may cause a regression for older guests
> > > > that don't support MSI or kvmclock.  Device assignment will be done
> > > > using VFIO, that is, without direct kvm involvement.
> > > > 
> > > So are we officially saying that KVM is only for modern guest
> > > virtualization? 
> > 
> > No, but older guests may have reduced performance in some workloads
> > (e.g. RHEL4 gettimeofday() intensive workloads).
> > 
> Reduced performance is what I mean. Obviously old guests will continue working.

I'm not happy about it either.

> > > Also my not so old host kernel uses MSI only for NIC.
> > > SATA and USB are using IOAPIC (though this is probably more HW related
> > > than kernel version related).
> > 
> > For devices emulated in userspace, it doesn't matter where the IOAPIC
> > is.  It only matters for kernel provided devices (PIT, assigned devices,
> > vhost-net).
> > 
> What about EOI that will have to do additional exit to userspace for each
> interrupt delivered?

I think the ioapic EOI is asynchronous wrt the core, yes?  So the vcpu
can just post the EOI broadcast on the apic-bus socketpair, waking up
the thread handling the ioapic, and continue running.  This trades off
vcpu latency for using more host resources.


-- 
error compiling committee.c: too many arguments to function

