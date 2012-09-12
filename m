Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab2ILTAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 15:00:44 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58416 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718Ab2ILTAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:00:41 -0400
MIME-Version: 1.0
In-Reply-To: <1347475934.15764.90.camel@twins>
References: <1347466967.15764.63.camel@twins>
	<CABPqkBQsJr_Cp36Df-etOaHhGh8T6XVngraDQt52ZtKahr6KBQ@mail.gmail.com>
	<1347471446.15764.67.camel@twins>
	<1347471911.15764.72.camel@twins>
	<CABPqkBSJu05YztcL435FH_rpcwWAi8czC9uUdiq3M0AjJ+_5Mg@mail.gmail.com>
	<1347473860.15764.78.camel@twins>
	<CABPqkBSgG3RhUH6L-XA6UK-M5dhA1FnEXUACGiiMeG69AKpctg@mail.gmail.com>
	<1347475934.15764.90.camel@twins>
Date: Wed, 12 Sep 2012 21:00:39 +0200
Message-ID: <CABPqkBSZ3ATLnkzUdXkcZ85ufXj1eS4aVTu26F7OaCLZoz_7Nw@mail.gmail.com>
Subject: Re: [RFC][PATCH] perf, intel: Don't touch MSR_IA32_DEBUGCTLMSR from
 NMI context
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 8:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-09-12 at 20:50 +0200, Stephane Eranian wrote:
>
>> > As for BTS, it looks like we don't throttle the thing at all, so we
>> > shouldn't ever get to the asymmetric thing, right?
>> No you do, in the same function:
>> static void intel_pmu_disable_event(struct perf_event *event)
>> {
>>         struct hw_perf_event *hwc = &event->hw;
>>         struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
>>
>>         if (unlikely(hwc->idx == INTEL_PMC_IDX_FIXED_BTS)) {
>>                 intel_pmu_disable_bts();
>>                 intel_pmu_drain_bts_buffer();
>>                 return;
>>         }
>
> Right, but the main event loop in intel_pmu_handle_irq() is over the
> MSR_CORE_PERF_GLOBAL_STATUS status bits, BTS is not included in those,
> so we'd never end up calling x86_pmu_stop() on the associated event.

True, it does not use a counter. But it interrupts when the buffer becomes full.
We catch this at the beginning of intel_pmu_handle_irq(). I think there is an
issue there with throtlling. Could be that the BTS buffer + workload could
caused PMU interrupts at a rate > max_rate. But yeah, it does not go
into the ovfl_status loop, so it cannot be stopped in an asymmetrical
way.
