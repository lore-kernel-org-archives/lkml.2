Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab2ILSxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:53:40 -0400
Received: from [205.233.59.134] ([205.233.59.134]:35318 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab2ILSxj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:53:39 -0400
Message-ID: <1347475934.15764.90.camel@twins>
Subject: Re: [RFC][PATCH] perf, intel: Don't touch MSR_IA32_DEBUGCTLMSR from
 NMI context
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Date: Wed, 12 Sep 2012 20:52:14 +0200
In-Reply-To: <CABPqkBSgG3RhUH6L-XA6UK-M5dhA1FnEXUACGiiMeG69AKpctg@mail.gmail.com>
References: <1347466967.15764.63.camel@twins>
	 <CABPqkBQsJr_Cp36Df-etOaHhGh8T6XVngraDQt52ZtKahr6KBQ@mail.gmail.com>
	 <1347471446.15764.67.camel@twins> <1347471911.15764.72.camel@twins>
	 <CABPqkBSJu05YztcL435FH_rpcwWAi8czC9uUdiq3M0AjJ+_5Mg@mail.gmail.com>
	 <1347473860.15764.78.camel@twins>
	 <CABPqkBSgG3RhUH6L-XA6UK-M5dhA1FnEXUACGiiMeG69AKpctg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 20:50 +0200, Stephane Eranian wrote:

> > As for BTS, it looks like we don't throttle the thing at all, so we
> > shouldn't ever get to the asymmetric thing, right?
> No you do, in the same function:
> static void intel_pmu_disable_event(struct perf_event *event)
> {
>         struct hw_perf_event *hwc = &event->hw;
>         struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> 
>         if (unlikely(hwc->idx == INTEL_PMC_IDX_FIXED_BTS)) {
>                 intel_pmu_disable_bts();
>                 intel_pmu_drain_bts_buffer();
>                 return;
>         }

Right, but the main event loop in intel_pmu_handle_irq() is over the
MSR_CORE_PERF_GLOBAL_STATUS status bits, BTS is not included in those,
so we'd never end up calling x86_pmu_stop() on the associated event.
