Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760568Ab2ILSuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:50:32 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42139 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab2ILSu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:50:29 -0400
MIME-Version: 1.0
In-Reply-To: <1347473860.15764.78.camel@twins>
References: <1347466967.15764.63.camel@twins>
	<CABPqkBQsJr_Cp36Df-etOaHhGh8T6XVngraDQt52ZtKahr6KBQ@mail.gmail.com>
	<1347471446.15764.67.camel@twins>
	<1347471911.15764.72.camel@twins>
	<CABPqkBSJu05YztcL435FH_rpcwWAi8czC9uUdiq3M0AjJ+_5Mg@mail.gmail.com>
	<1347473860.15764.78.camel@twins>
Date: Wed, 12 Sep 2012 20:50:28 +0200
Message-ID: <CABPqkBSgG3RhUH6L-XA6UK-M5dhA1FnEXUACGiiMeG69AKpctg@mail.gmail.com>
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

On Wed, Sep 12, 2012 at 8:17 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-09-12 at 20:00 +0200, Stephane Eranian wrote:
>> On Wed, Sep 12, 2012 at 7:45 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Wed, 2012-09-12 at 19:37 +0200, Peter Zijlstra wrote:
>> >> Ah, so I do think EIO will re-enable LBR,
>> >
>> > OK, it does not, but the:
>> >
>> >>  also the handler is wrapped in
>> >> x86_pmu::{dis,en}able_all() which does end up calling
>> >> intel_pmu_lbr_{dis,en}able_all().
>> >
>> > Thing does the re-enable for us,
>> >
>>
>> >>  However that leaves the MSR in the
>> >> exact same state on exit as it was on enter, so that's not a problem for
>> >> the: read-modify-write change.
>> >
>> > in a safe way.
>> Well, I think it does even when we have to stop events (x86_pmu_stop)
>> because the buffer is full. Looks like we always re-enable lbr.
>
> How so, without the proposed patch, the intel_pmu_disable_event() can do
> intel_pmu_lbr_disable() which decrements cpuc->lbr_users, so the final
> intel_pmu_enable_all()->intel_pmu_lbr_enable_all() will be a NOP,
> leaving LBR disabled, where we entered the NMI with LBR enabled.
>
You're right. I looked at the wrong x86_pmu struct.
So yes, it is not symmetrical in all cases. So that's a problem
for the race condition.

>>  So looks like the handler is a wash for debugctl.
>
> As for BTS, it looks like we don't throttle the thing at all, so we
> shouldn't ever get to the asymmetric thing, right?
No you do, in the same function:
static void intel_pmu_disable_event(struct perf_event *event)
{
        struct hw_perf_event *hwc = &event->hw;
        struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);

        if (unlikely(hwc->idx == INTEL_PMC_IDX_FIXED_BTS)) {
                intel_pmu_disable_bts();
                intel_pmu_drain_bts_buffer();
                return;
        }
