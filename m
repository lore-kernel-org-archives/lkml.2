Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab2GCIVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 04:21:08 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:59186 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab2GCIU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 04:20:58 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: peterz@infradead.org, mingo@elte.hu, avi@redhat.com,
        raghukt@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, jeremy@goop.org,
        vatsa@linux.vnet.ibm.com, hpa@zytor.com
Subject: Re: [PATCH v2 3/7] KVM: Add paravirt kvm_flush_tlb_others
In-Reply-To: <20120703075535.GA13291@amt.cnet>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com> <20120604050629.4560.85284.stgit@abhimanyu.in.ibm.com> <20120703075535.GA13291@amt.cnet>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Tue, 03 Jul 2012 13:49:49 +0530
Message-ID: <87txxpcl3u.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12070222-1396-0000-0000-0000017F2E87
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2012 04:55:35 -0300, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > 
> >    if (!zero_mask)
> > 	   goto again;
> 
> Can you please measure increased vmentry/vmexit overhead? x86/vmexit.c 
> of git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git should 
> help.
>
Sure will get back with the result.

> > +	/* 
> > +	 * Guest might have seen us offline and would have set
> > +	 * flush_on_enter. 
> > +	 */
> > +	kvm_read_guest_cached(vcpu->kvm, ghc, vs, 2*sizeof(__u32));
> > +	if (vs->flush_on_enter) 
> > +		kvm_x86_ops->tlb_flush(vcpu);
> 
> 
> So flush_tlb_page which was an invlpg now flushes the entire TLB. Did
> you take that into account?
> 
When the vcpu is sleeping/pre-empted out, multiple request for flush_tlb
could have happened. And now when we are here, it is cleaning up all the
TLB.

One other approach would be to queue the addresses, that brings us with
the question: how many request to queue? This would require us adding
more syncronization between guest and host for updating the area where
these addresses is shared.

> > +again:
> > +		for_each_cpu(cpu, to_cpumask(f->flush_cpumask)) {
> > +			v_state = &per_cpu(vcpu_state, cpu);
> > +
> > +			if (!v_state->state) {
> 
> Should use ACCESS_ONCE to make sure the value is not register cached.
> \
> > +				v_state->flush_on_enter = 1;
> > +				smp_mb();
> > +				if (!v_state->state)
> 
> And here.
> 
Sure will add this check for both in my next version.

> > +					cpumask_clear_cpu(cpu, to_cpumask(f->flush_cpumask));
> > +			}
> > +		}
> > +
> > +		if (cpumask_empty(to_cpumask(f->flush_cpumask)))
> > +			goto out;
> > +
> > +		apic->send_IPI_mask(to_cpumask(f->flush_cpumask),
> > +				    INVALIDATE_TLB_VECTOR_START + sender);
> > +
> > +		loop = 1000;
> > +		while (!cpumask_empty(to_cpumask(f->flush_cpumask)) && --loop)
> > +			cpu_relax();
> > +
> > +		if (!cpumask_empty(to_cpumask(f->flush_cpumask)))
> > +			goto again;
> 
> Is this necessary in addition to the in-guest-mode/out-guest-mode
> detection? If so, why?
> 
The "case 3" where we initially saw the vcpu was running, and a flush
ipi is send to the vcpu. During this time the vcpu might be pre-empted,
so we come out of the loop=1000 with !empty flushmask. We then re-verify
the flushmask against the current running vcpu and make sure that the
vcpu that was pre-empted is un-marked and we can proceed out of the
kvm_flush_tlb_others_ipi without waiting for sleeping/pre-empted vcpus.

Regards
Nikunj

