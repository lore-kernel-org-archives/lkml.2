Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab2EXQf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:35:27 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53514 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2EXQfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:35:25 -0400
MIME-Version: 1.0
In-Reply-To: <4FBE5FA6.5050802@gmail.com>
References: <4FBE5FA6.5050802@gmail.com>
Date: Thu, 24 May 2012 18:35:23 +0200
Message-ID: <CABPqkBT7dKa3P2hk=_pismGdPHuseWMbCKhUzz1sQNDemb133A@mail.gmail.com>
Subject: Re: perf, x86: only do lbr init if bts is available
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 6:19 PM, David Ahern <dsahern@gmail.com> wrote:
> KVM recently added support for a version 2 PMU. When passing -cpu host as
> the CPU model for the guest we get an abnormal configuration from perf's
> perspective in that the guest identifies the processor as a Westmere or
> Nehalem (etc):
>
> [    0.013998] Performance Events: Westmere events, Intel PMU driver.
>
>
> but yet the processor does not have the debug store mechanisms
> (X86_FEATURE_DTES64 is not set) meaning there is no PEBS or BTS.
>
> Right now the LBR init functions are run based on processor model which
> leads to attempts to write to LBR MSRs generating messages like:
>
> [ 1170.125605] kvm: 6873: cpu0 unhandled rdmsr: 0x345
> [ 1170.135354] kvm_set_msr_common: 54 callbacks suppressed
> [ 1170.135612] kvm: 6873: cpu0 unhandled wrmsr: 0x680 data 0
> [ 1170.135900] kvm: 6873: cpu0 unhandled wrmsr: 0x6c0 data 0
> [ 1170.136163] kvm: 6873: cpu0 unhandled wrmsr: 0x681 data 0
> [ 1170.136437] kvm: 6873: cpu0 unhandled wrmsr: 0x6c1 data 0
> [ 1170.136703] kvm: 6873: cpu0 unhandled wrmsr: 0x682 data 0
> [ 1170.136968] kvm: 6873: cpu0 unhandled wrmsr: 0x6c2 data 0
> [ 1170.137227] kvm: 6873: cpu0 unhandled wrmsr: 0x683 data 0
> [ 1170.137502] kvm: 6873: cpu0 unhandled wrmsr: 0x6c3 data 0
> [ 1170.137797] kvm: 6873: cpu0 unhandled wrmsr: 0x684 data 0
> [ 1170.138061] kvm: 6873: cpu0 unhandled wrmsr: 0x6c4 data 0
>
>
> MSR 0x345 is MSR_IA32_PERF_CAPABILITIES; the 0x6XX MSRs are LBR from/to.
>
> Question: is something like this acceptable/make sense -- to only setup lbr
> values if the BTS is detected?
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c
> b/arch/x86/kernel/cpu/perf_event_intel.c
> index 166546e..7ba4afa 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1783,7 +1784,8 @@ __init int intel_pmu_init(void)
>        memcpy(hw_cache_extra_regs, nehalem_hw_cache_extra_regs,
>               sizeof(hw_cache_extra_regs));
>
> -       intel_pmu_lbr_init_nhm();
> +       if (x86_pmu.bts)
> +           intel_pmu_lbr_init_nhm();
>
Well, no. There is no connection between BTS and LBR and you're creating one.

Where is the wrmsr coming from? What we need to do is ensure that LBR is not
touched if we don't actually use it.

>        x86_pmu.event_constraints = intel_nehalem_event_constraints;
>        x86_pmu.pebs_constraints = intel_nehalem_pebs_event_constraints;
>
> David
