Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab1KGPUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:20:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab1KGPUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:20:03 -0500
Date: Mon, 7 Nov 2011 17:19:44 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, kvm@vger.kernel.org,
        mtosatti@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        acme@ghostprotocols.net
Subject: Re: [PATCHv2 2/9] KVM: Expose a version 2 architectural PMU to a
 guests
Message-ID: <20111107151944.GE8670@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
 <1320323618-10375-3-git-send-email-gleb@redhat.com>
 <1320676467.18053.43.camel@twins>
 <4EB7EF4F.3090907@redhat.com>
 <1320677949.18053.54.camel@twins>
 <4EB7F58D.6080102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB7F58D.6080102@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 05:13:17PM +0200, Avi Kivity wrote:
> On 11/07/2011 04:59 PM, Peter Zijlstra wrote:
> > > > > +                */
> > > > > +               if (!kvm_is_in_guest())
> > > > > +                       irq_work_queue(&pmc->vcpu->arch.pmu.irq_work);
> > > > > +               else
> > > > > +                       kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
> > > > > +       }
> > > > > +} 
> > > >
> > > > I'm not sure I get this, since the counters are vcpu task bound and only
> > > > count while the guest is running as per (144d31e6f19) how can we get an
> > > > NMI outside of guest context with the vcpu not halted?
> > > 
> > > PMI skew.  Do we know how bad it can get?
> >
> > You're talking about the PMI getting asserted before leaving guest mode
> > but not getting ran until after we left guest mode?
> 
> Yes (here, "guest mode" is not the hardware guest mode, but what
> kvm_is_in_guest() returns).
> 
> > But in that case we know the guest is stopped, right? So we can simply
> > set that REQ_PMI bit and have guest entry sort things, no?
> 
> Unless there is no guest entry, due to the guest sleeping.
> 
> Consider the sequence:
> 
> guest:
>    nop
> hardware:
>    counter overflow; PMI sent to APIC
> guest:
>    hlt
> hardware:
>    begin vmexit due to HLT
> host:
>    process vmexit
>    mark as outside guest mode (i.e. kvm_is_in_guest() now returns false)
>    schedule(), since the guest is sleeping (and assume no interrupts
> pending)
> hardware:
>    APIC finally posts NMI
> host:
>    process NMI; set KVM_REQ_PMI
>    iret
> host:
>    happily do other things, ignoring that we need to post a PMI to the guest
> 
> note, this needs a fairly huge PMI skew to happen.
> 
No, it need not. It is enough to get exit reason as hlt instead of nmi
for a vcpu to go to blocking state instead of reentering guest mode.
Note that we do not check request flags in kvm_arch_vcpu_runnable().

> (btw, like userspace, kvm PMIs may as well be ordinary interrupts. 
> Should we consider some logic to only make them NMIs if some counter
> requires it?  NMI costs are set to increase dramatically with the
> check-all-possible-sources patchset).
> 
> -- 
> error compiling committee.c: too many arguments to function

--
			Gleb.
