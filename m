Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab1KGOrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 09:47:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932626Ab1KGOrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 09:47:14 -0500
Message-ID: <4EB7EF4F.3090907@redhat.com>
Date: Mon, 07 Nov 2011 16:46:39 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Subject: Re: [PATCHv2 2/9] KVM: Expose a version 2 architectural PMU to a
 guests
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>  <1320323618-10375-3-git-send-email-gleb@redhat.com> <1320676467.18053.43.camel@twins>
In-Reply-To: <1320676467.18053.43.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 04:34 PM, Peter Zijlstra wrote:
> On Thu, 2011-11-03 at 14:33 +0200, Gleb Natapov wrote:
> > +static void kvm_perf_overflow_intr(struct perf_event *perf_event,
> > +               struct perf_sample_data *data, struct pt_regs *regs)
> > +{
> > +       struct kvm_pmc *pmc = perf_event->overflow_handler_context;
> > +       struct kvm_pmu *pmu = &pmc->vcpu->arch.pmu;
> > +       if (!test_and_set_bit(pmc->idx, (unsigned long *)&pmu->reprogram_pmi)) {
> > +               kvm_perf_overflow(perf_event, data, regs);
> > +               kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
> > +               /*
> > +                * Inject PMI. If vcpu was in a guest mode during NMI PMI
> > +                * can be ejected on a guest mode re-entry. Otherwise we can't
> > +                * be sure that vcpu is not halted, so we should kick it, but
> > +                * this is impossible from NMI context. Do it from irq work
> > +                * instead.
> > +                */
> > +               if (!kvm_is_in_guest())
> > +                       irq_work_queue(&pmc->vcpu->arch.pmu.irq_work);
> > +               else
> > +                       kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
> > +       }
> > +} 
>
> I'm not sure I get this, since the counters are vcpu task bound and only
> count while the guest is running as per (144d31e6f19) how can we get an
> NMI outside of guest context with the vcpu not halted?

PMI skew.  Do we know how bad it can get?

-- 
error compiling committee.c: too many arguments to function

