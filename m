Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab2GEEPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 00:15:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab2GEEPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 00:15:02 -0400
Date: Wed, 4 Jul 2012 23:09:10 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Cc: peterz@infradead.org, mingo@elte.hu, avi@redhat.com,
        raghukt@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, jeremy@goop.org,
        vatsa@linux.vnet.ibm.com, hpa@zytor.com
Subject: Re: [PATCH v2 3/7] KVM: Add paravirt kvm_flush_tlb_others
Message-ID: <20120705020910.GB3652@amt.cnet>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com>
 <20120604050629.4560.85284.stgit@abhimanyu.in.ibm.com>
 <20120703075535.GA13291@amt.cnet>
 <87txxpcl3u.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txxpcl3u.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 01:49:49PM +0530, Nikunj A Dadhania wrote:
> On Tue, 3 Jul 2012 04:55:35 -0300, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > > 
> > >    if (!zero_mask)
> > > 	   goto again;
> > 
> > Can you please measure increased vmentry/vmexit overhead? x86/vmexit.c 
> > of git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git should 
> > help.
> >
> Sure will get back with the result.
> 
> > > +	/* 
> > > +	 * Guest might have seen us offline and would have set
> > > +	 * flush_on_enter. 
> > > +	 */
> > > +	kvm_read_guest_cached(vcpu->kvm, ghc, vs, 2*sizeof(__u32));
> > > +	if (vs->flush_on_enter) 
> > > +		kvm_x86_ops->tlb_flush(vcpu);
> > 
> > 
> > So flush_tlb_page which was an invlpg now flushes the entire TLB. Did
> > you take that into account?
> > 
> When the vcpu is sleeping/pre-empted out, multiple request for flush_tlb
> could have happened. And now when we are here, it is cleaning up all the
> TLB.

Yes, cases where there are sufficient exits transforming one TLB entry
invalidation into full TLB invalidation should go unnoticed.

> One other approach would be to queue the addresses, that brings us with
> the question: how many request to queue? This would require us adding
> more syncronization between guest and host for updating the area where
> these addresses is shared.

Sounds unnecessarily complicated.

> > > +again:
> > > +		for_each_cpu(cpu, to_cpumask(f->flush_cpumask)) {
> > > +			v_state = &per_cpu(vcpu_state, cpu);
> > > +
> > > +			if (!v_state->state) {
> > 
> > Should use ACCESS_ONCE to make sure the value is not register cached.
> > \
> > > +				v_state->flush_on_enter = 1;
> > > +				smp_mb();
> > > +				if (!v_state->state)
> > 
> > And here.
> > 
> Sure will add this check for both in my next version.
> 
> > > +					cpumask_clear_cpu(cpu, to_cpumask(f->flush_cpumask));
> > > +			}
> > > +		}
> > > +
> > > +		if (cpumask_empty(to_cpumask(f->flush_cpumask)))
> > > +			goto out;
> > > +
> > > +		apic->send_IPI_mask(to_cpumask(f->flush_cpumask),
> > > +				    INVALIDATE_TLB_VECTOR_START + sender);
> > > +
> > > +		loop = 1000;
> > > +		while (!cpumask_empty(to_cpumask(f->flush_cpumask)) && --loop)
> > > +			cpu_relax();
> > > +
> > > +		if (!cpumask_empty(to_cpumask(f->flush_cpumask)))
> > > +			goto again;
> > 
> > Is this necessary in addition to the in-guest-mode/out-guest-mode
> > detection? If so, why?
> > 
> The "case 3" where we initially saw the vcpu was running, and a flush
> ipi is send to the vcpu. During this time the vcpu might be pre-empted,
> so we come out of the loop=1000 with !empty flushmask. We then re-verify
> the flushmask against the current running vcpu and make sure that the
> vcpu that was pre-empted is un-marked and we can proceed out of the
> kvm_flush_tlb_others_ipi without waiting for sleeping/pre-empted vcpus.
> 
> Regards
> Nikunj
