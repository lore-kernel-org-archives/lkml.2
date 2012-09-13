Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676Ab2IMLtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 07:49:15 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45546 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757503Ab2IMLtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 07:49:14 -0400
MIME-Version: 1.0
In-Reply-To: <1347531789.15764.124.camel@twins>
References: <1347466967.15764.63.camel@twins>
	<1347531789.15764.124.camel@twins>
Date: Thu, 13 Sep 2012 13:49:12 +0200
Message-ID: <CABPqkBQk2TsnyZF52rvcH9wKO=P7=RAgTTjYPQjeAjOFUob4_g@mail.gmail.com>
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

On Thu, Sep 13, 2012 at 12:23 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-09-12 at 18:22 +0200, Peter Zijlstra wrote:
>> Oleg and Sebastian found that touching MSR_IA32_DEBUGCTLMSR from NMI
>> context is problematic since the only way to change the various
>> unrelated bits in there is:
>>
>>   debugctl = get_debugctlmsr()
>>   /* frob flags in debugctl */
>>   update_debugctlmsr(debugctl);
>>
>> Which is entirely unsafe if we prod at the MSR from NMI context.
>>
>> In particular the path that is responsible is:
>>
>>   x86_pmu_handle_irq() (NMI handler)
>>     x86_pmu_stop()
>>       x86_pmu.disable -> intel_pmu_disable_event()
>>         intel_pmu_lbr_disable()
>>           __intel_pmu_lbr_disable()
>>             wrmsrl(MSR_IA32_DEBUGCTLMSR,... );
>>
>> So remove intel_pmu_lbr_{en,dis}able() from
>> intel_pmu_{en,dis}able_event() and stick them in
>> intel_{get,put}_event_constraints() which are only ever called from
>> regular contexts.
>>
>> We combine intel_pmu_needs_lbr_smpl(), which tells us if the events
>> wants LBR data, with event->hw.branch_reg.alloc, which given
>> intel_shared_regs_constraints() is set if our event got the shared
>> resource, to give us a correctly balanced condition in
>> {get,put}_event_constraints() for intel_pmu_lbr_{en,dis}able().
>>
>> Also change core_pmu to only use x86_get_event_constraints since it
>> doesn't support any of the fancy DS (BTS,PEBS), LBR and OFFCORE features
>> that make up intel_{get,put}_event_constraints.
>
> OK, so with the added stipulation that touching the MSR from the NMI
> isn't a problem as long as we ensure we leave the MSR in the same state
> that we found it in, and the above is the only path found so far that
> could cause this to be violated, the patch is fine?
>
Should be, though it is pretty ugly to stash all of this in the
put/get constraints.

I will run some tests.

I wonder what this does when you come in to get/put with a fake cpuc. You don't
want to perturb the local lbr which may be in use.

> In particular we could note that both LBR and BTS use the DEBUGCTL MSR,
> but BTS doesn't throttle, so the LBR code is the only thing needing
> attention as per the above description.
>
>
