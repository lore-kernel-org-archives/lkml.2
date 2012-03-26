Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab2CZLac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 07:30:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254Ab2CZLa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 07:30:29 -0400
Date: Mon, 26 Mar 2012 13:30:38 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC dontapply] kvm_para: add mmio word store hypercall
Message-ID: <20120326113037.GC15207@redhat.com>
References: <20120325220518.GA27879@redhat.com>
 <4F703536.3040904@redhat.com>
 <20120326100829.GA14506@redhat.com>
 <4F7041EE.10305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7041EE.10305@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 12:16:14PM +0200, Avi Kivity wrote:
> On 03/26/2012 12:08 PM, Michael S. Tsirkin wrote:
> >
> > > > +		gpa = hc_gpa(vcpu, a1, a2);
> > > > +		if (!write_mmio(vcpu, gpa, 2, &a0) && run) {
> > > 
> > > What's this && run thing?
> >
> > I'm not sure - copied this from another other place in emulation:
> > arch/x86/kvm/x86.c:4953:                if (!write_mmio(vcpu, gpa, 2, &a0) && run)
> >
> > I assumed there's some way to trigger emulation while VCPU does not run.
> > No?
> 
> Not the way you initialize run above.

Thanks for pointing this out, I'll drop the test.

> >
> > > 
> > > > +			run->exit_reason = KVM_EXIT_MMIO;
> > > > +			run->mmio.phys_addr = gpa;
> > > > +			memcpy(run->mmio.data, &a0, 2);
> > > > +			run->mmio.len = 2;
> > > > +			run->mmio.is_write = 1;
> > > > +                        r = 0;
> > > > +		}
> > > > +		goto noret;
> > > 
> > > What if the address is in RAM?
> > > Note the guest can't tell if a piece of memory is direct mapped or
> > > implemented as mmio.
> >
> > True but doing hypercalls for memory which can be
> > mapped directly is bad for performance - it's
> > the reverse of what we are trying to do here.
> 
> It's bad, but the guest can't tell.
> 
> Suppose someone implements virtio in hardware and we pass it through to
> a guest.  It should continue working, no?

Why would we want hypercalls then?

As I see it, virtio device would have a capability
that tells the guest to use hypercalls for access.
An actual PCI device won't expose this capability,
as would a device on a host which lacks the hypercall.


> > The intent is to use this for virtio where we can explicitly let the
> > guest know whether using a hypercall is safe.
> >
> > Acceptable?  What do you suggest?
> 
> It's iffy.

Question is, do we want a bunch of dead code sitting there
just in case? And what are the chances it'll work correctly
when we need it to?

> What's the performance gain from this thing?

I'll test and post separately.

> 
> -- 
> error compiling committee.c: too many arguments to function
