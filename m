Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab1KGPM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:12:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab1KGPMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:12:17 -0500
Date: Mon, 7 Nov 2011 17:11:55 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Subject: Re: [PATCHv2 2/9] KVM: Expose a version 2 architectural PMU to a
 guests
Message-ID: <20111107151155.GC8670@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
 <1320323618-10375-3-git-send-email-gleb@redhat.com>
 <1320676467.18053.43.camel@twins>
 <4EB7EF4F.3090907@redhat.com>
 <1320677949.18053.54.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320677949.18053.54.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 03:59:08PM +0100, Peter Zijlstra wrote:
> On Mon, 2011-11-07 at 16:46 +0200, Avi Kivity wrote:
> > On 11/07/2011 04:34 PM, Peter Zijlstra wrote:
> > > On Thu, 2011-11-03 at 14:33 +0200, Gleb Natapov wrote:
> > > > +static void kvm_perf_overflow_intr(struct perf_event *perf_event,
> > > > +               struct perf_sample_data *data, struct pt_regs *regs)
> > > > +{
> > > > +       struct kvm_pmc *pmc = perf_event->overflow_handler_context;
> > > > +       struct kvm_pmu *pmu = &pmc->vcpu->arch.pmu;
> > > > +       if (!test_and_set_bit(pmc->idx, (unsigned long *)&pmu->reprogram_pmi)) {
> > > > +               kvm_perf_overflow(perf_event, data, regs);
> > > > +               kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
> > > > +               /*
> > > > +                * Inject PMI. If vcpu was in a guest mode during NMI PMI
> > > > +                * can be ejected on a guest mode re-entry. Otherwise we can't
> > > > +                * be sure that vcpu is not halted, so we should kick it, but
> > > > +                * this is impossible from NMI context. Do it from irq work
> > > > +                * instead.
> > > > +                */
> > > > +               if (!kvm_is_in_guest())
> > > > +                       irq_work_queue(&pmc->vcpu->arch.pmu.irq_work);
> > > > +               else
> > > > +                       kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
> > > > +       }
> > > > +} 
> > >
> > > I'm not sure I get this, since the counters are vcpu task bound and only
> > > count while the guest is running as per (144d31e6f19) how can we get an
> > > NMI outside of guest context with the vcpu not halted?
> > 
> > PMI skew.  Do we know how bad it can get?
> 
I checked and we do get them. Not often. Something like once per second of
"perf record" run in a guest.

> You're talking about the PMI getting asserted before leaving guest mode
> but not getting ran until after we left guest mode?
> 
> But in that case we know the guest is stopped, right? So we can simply
> set that REQ_PMI bit and have guest entry sort things, no?
If exit reason was HALT a guest will not attempt a reentry unless MPI or
other event is injected. We can't eject event in NMI context so we
schedule irq work in this case.

--
			Gleb.
