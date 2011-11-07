Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab1KGOfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 09:35:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33595 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab1KGOf3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 09:35:29 -0500
Subject: Re: [PATCHv2 2/9] KVM: Expose a version 2 architectural PMU to a
 guests
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Date: Mon, 07 Nov 2011 15:34:27 +0100
In-Reply-To: <1320323618-10375-3-git-send-email-gleb@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
	 <1320323618-10375-3-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320676467.18053.43.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 14:33 +0200, Gleb Natapov wrote:
> +static void kvm_perf_overflow_intr(struct perf_event *perf_event,
> +               struct perf_sample_data *data, struct pt_regs *regs)
> +{
> +       struct kvm_pmc *pmc = perf_event->overflow_handler_context;
> +       struct kvm_pmu *pmu = &pmc->vcpu->arch.pmu;
> +       if (!test_and_set_bit(pmc->idx, (unsigned long *)&pmu->reprogram_pmi)) {
> +               kvm_perf_overflow(perf_event, data, regs);
> +               kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
> +               /*
> +                * Inject PMI. If vcpu was in a guest mode during NMI PMI
> +                * can be ejected on a guest mode re-entry. Otherwise we can't
> +                * be sure that vcpu is not halted, so we should kick it, but
> +                * this is impossible from NMI context. Do it from irq work
> +                * instead.
> +                */
> +               if (!kvm_is_in_guest())
> +                       irq_work_queue(&pmc->vcpu->arch.pmu.irq_work);
> +               else
> +                       kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
> +       }
> +} 

I'm not sure I get this, since the counters are vcpu task bound and only
count while the guest is running as per (144d31e6f19) how can we get an
NMI outside of guest context with the vcpu not halted?
