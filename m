Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1BAPsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 10:48:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab1BAPsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:48:50 -0500
Subject: Re: [PATCH v2 2/6] KVM-HV: KVM Steal time implementation
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <4D4563EB.3000203@redhat.com>
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>
	 <1296244340-15173-3-git-send-email-glommer@redhat.com>
	 <4D4563EB.3000203@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Tue, 01 Feb 2011 13:48:40 -0200
Message-ID: <1296575320.5081.8.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-30 at 15:13 +0200, Avi Kivity wrote:
> On 01/28/2011 09:52 PM, Glauber Costa wrote:
> > To implement steal time, we need the hypervisor to pass the guest information
> > about how much time was spent running other processes outside the VM.
> > This is per-vcpu, and using the kvmclock structure for that is an abuse
> > we decided not to make.
> >
> > In this patchset, I am introducing a new msr, KVM_MSR_STEAL_TIME, that
> > holds the memory area address containing information about steal time
> >
> > This patch contains the hypervisor part for it. I am keeping it separate from
> > the headers to facilitate backports to people who wants to backport the kernel
> > part but not the hypervisor, or the other way around.
> >
> >
> > @@ -1528,16 +1528,23 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
> >   		vcpu->arch.time_page =
> >   				gfn_to_page(vcpu->kvm, data>>  PAGE_SHIFT);
> >
> > -		if (is_error_page(vcpu->arch.time_page)) {
> > -			kvm_release_page_clean(vcpu->arch.time_page);
> > -			vcpu->arch.time_page = NULL;
> > -		}
> >   		break;
> >   	}
> 
> Unrelated?

Indeed, leftover from another patch. Thanks

> > @@ -2106,6 +2120,25 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >   			kvm_migrate_timers(vcpu);
> >   		vcpu->cpu = cpu;
> >   	}
> > +
> > +	if (vcpu->arch.this_time_out) {
> > +		u64 to = (get_kernel_ns() - vcpu->arch.this_time_out);
> > +		/*
> > +		 * using nanoseconds introduces noise, which accumulates easily
> > +		 * leading to big steal time values. We want, however, to keep the
> > +		 * interface nanosecond-based for future-proofness.
> > +		 */
> > +		to /= NSEC_PER_USEC;
> > +		to *= NSEC_PER_USEC;
> 
> Seems there is a real problem and that this is just papering it over.  
> I'd like to understand the root cause.
Okay, my self-explanation seemed reasonable to me, but since both you
and Peter dislike it, I think it is important enough to get a more
thorough investigation before a second round. But in this case,
I keep that using nanoseconds may then not be the best approach here. We
also have to keep in mind that the host and guest clocks may be running
at different resolutions.

> 
> > +		vcpu->arch.time_out += to;
> > +		kvm_write_guest(vcpu->kvm, (gpa_t)&st->steal,
> > +				&vcpu->arch.time_out, sizeof(st->steal));
> 
> Error check.

Fair.

> > +		vcpu->arch.sversion += 2;
> 
> Doesn't survive live migration.  You need to use the version from the 
> guest area.
Why not? Who said versions need to always increase? If current version
is 102324, and we live migrate and it becomes 0, what is the problem?
next update will make it two, that will at most force another read loop
in the guest.
The only properties we have to maintain are: 
1) Value is even (checked)
2) Value does not change between a read (checked).

Reading the value from the guest just slows it down, imho.


