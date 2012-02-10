Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab2BJDHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 22:07:54 -0500
Received: from mail2.shareable.org ([80.68.89.115]:33871 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab2BJDHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 22:07:53 -0500
Date: Fri, 10 Feb 2012 03:07:51 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
Message-ID: <20120210030751.GA9586@jl-vm1.vm.bytemark.co.uk>
References: <4F2AB552.2070909@redhat.com>
 <4F2B41D6.8020603@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2B41D6.8020603@codemonkey.ws>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> >The new API will do away with the IOAPIC/PIC/PIT emulation and defer
> >them to userspace.
> 
> I'm a big fan of this.

I agree with getting rid of unnecessary emulations.
(Why were those things emulated in the first place?)

But it would be good to retain some way to "plugin" device emulations
in the kernel, separate from KVM core with a well-defined API boundary.

Then it wouldn't matter to the KVM core whether there's PIT emulation
or whatever; that would just be a separate module.  Perhaps even with
its own /dev device and maybe not tightly bound to KVM,

> >Note: this may cause a regression for older guests that don't
> >support MSI or kvmclock.  Device assignment will be done using
> >VFIO, that is, without direct kvm involvement.

I don't like the sound of regressions.

I tend to think of a VM as something that needs to have consistent
behaviour over a long time, for keeping working systems running for
years despite changing hardware, or reviving old systems to test
software and make patches for things in long-term maintenance etc.

But I haven't noticed problems from upgrading kernelspace-KVM yet,
only upgrading the userspace parts.  If a kernel upgrade is risky,
that makes upgrading host kernels difficult and "all or nothing" for
all the guests within.

However it looks like you mean only the performance characteristics
will change because of moving things back to userspace?

> >Local APICs will be mandatory, but it will be possible to hide them from
> >the guest.  This means that it will no longer be possible to emulate an
> >APIC in userspace, but it will be possible to virtualize an APIC-less
> >core - userspace will play with the LINT0/LINT1 inputs (configured as
> >EXITINT and NMI) to queue interrupts and NMIs.
> 
> I think this makes sense.  An interesting consequence of this is
> that it's no longer necessary to associate the VCPU context with an
> MMIO/PIO operation.  I'm not sure if there's an obvious benefit to
> that but it's interesting nonetheless.

Would that be useful for using VCPUs to run sandboxed userspace code
with ability to trap and control the whole environment (as opposed to
guest OSes, or ptrace which is rather incomplete and unsuitable for
sandboxing code meant for other OSes)?

Thanks,
-- Jamie
