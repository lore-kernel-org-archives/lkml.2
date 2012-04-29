Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab2D2NUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 09:20:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab2D2NUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 09:20:46 -0400
Date: Sun, 29 Apr 2012 16:20:30 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alexander Graf <agraf@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KVM <kvm@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        X86 <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Xen <xen-devel@lists.xensource.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC V6 1/5] kvm hypervisor : Add a hypercall to KVM
 hypervisor to support pv-ticketlocks
Message-ID: <20120429132030.GB15413@redhat.com>
References: <20120423095937.30893.14776.sendpatchset@codeblue.in.ibm.com>
 <20120423095947.30893.84029.sendpatchset@codeblue.in.ibm.com>
 <20120424095923.GS15413@redhat.com>
 <4F9D3F8B.9010805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9D3F8B.9010805@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2012 at 04:18:03PM +0300, Avi Kivity wrote:
> On 04/24/2012 12:59 PM, Gleb Natapov wrote:
> > >  
> > > +/*
> > > + * kvm_pv_kick_cpu_op:  Kick a vcpu.
> > > + *
> > > + * @apicid - apicid of vcpu to be kicked.
> > > + */
> > > +static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
> > > +{
> > > +	struct kvm_vcpu *vcpu = NULL;
> > > +	int i;
> > > +
> > > +	kvm_for_each_vcpu(i, vcpu, kvm) {
> > > +		if (!kvm_apic_present(vcpu))
> > > +			continue;
> > > +
> > > +		if (kvm_apic_match_dest(vcpu, 0, 0, apicid, 0))
> > > +			break;
> > > +	}
> > > +	if (vcpu) {
> > > +		/*
> > > +		 * Setting unhalt flag here can result in spurious runnable
> > > +		 * state when unhalt reset does not happen in vcpu_block.
> > > +		 * But that is harmless since that should soon result in halt.
> > > +		 */
> > > +		vcpu->arch.pv.pv_unhalted = 1;
> > > +		/* We need everybody see unhalt before vcpu unblocks */
> > > +		smp_mb();
> > > +		kvm_vcpu_kick(vcpu);
> > > +	}
> > > +}
> > This is too similar to kvm_irq_delivery_to_apic(). Why not reuse it. We
> > can use one of reserved delivery modes as PV delivery mode. We will
> > disallow guest to trigger it through apic interface, so this will not be
> > part of ABI and can be changed at will.
> >
> 
> I'm not thrilled about this.  Those delivery modes will eventually
> become unreserved.  We can have a kvm_lookup_apic_id() that is shared
> among implementations.
> 
This is only internal implementation. If they become unreserved we will
use something else.

--
			Gleb.
