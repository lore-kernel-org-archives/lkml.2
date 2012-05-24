Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964904Ab2EXRLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:11:31 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:35434 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864Ab2EXRLa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:11:30 -0400
MIME-Version: 1.0
In-Reply-To: <4FBE64D0.7040507@gmail.com>
References: <4FBE5FA6.5050802@gmail.com>
	<CABPqkBT7dKa3P2hk=_pismGdPHuseWMbCKhUzz1sQNDemb133A@mail.gmail.com>
	<4FBE64D0.7040507@gmail.com>
Date: Thu, 24 May 2012 19:11:28 +0200
Message-ID: <CABPqkBQc=XAfGY8_Rex4Hy91eBtwxtGzpfT0RaskBDDcSv1C4w@mail.gmail.com>
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

On Thu, May 24, 2012 at 6:41 PM, David Ahern <dsahern@gmail.com> wrote:
> On 5/24/12 10:35 AM, Stephane Eranian wrote:
>>
>> Well, no. There is no connection between BTS and LBR and you're creating
>> one.
>
>
> Ok. That was not clear to me from skimming the manual.
> Then should it be tied to X86_FEATURE_DTES64?
>
No, it is unrelated to the Debug Store.
There is really nothing you can use to figure that out, not event IA32_DEBUGCTL.
I wish Intel had something in PERF_CAPABILITIES, but LBR was
originally considered
as a debug feature, I think. To the point that it is described in the
debug section not in
vol 3b with performance monitoring.

> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> index 520b426..1090ae6 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -640,6 +640,9 @@ void intel_pmu_lbr_init_core(void)
>  /* nehalem/westmere */
>  void intel_pmu_lbr_init_nhm(void)
>  {
> +   if (!boot_cpu_has(X86_FEATURE_DTES64))
> +       return;
> +
>    x86_pmu.lbr_nr     = 16;
>    x86_pmu.lbr_tos    = MSR_LBR_TOS;
>    x86_pmu.lbr_from   = MSR_LBR_NHM_FROM;
>
>
>
>> Where is the wrmsr coming from? What we need to do is ensure that LBR is
>> not
>> touched if we don't actually use it.
>
>
> e.g., intel_pmu_lbr_init_nhm sets up lbr_nr, lbr_from, lbr_to and from, etc.
> Fhat I can tell intel_pmu_lbr_reset() gets invoked some where during the VM
> boot; I haven't traced how/when yet.
>
> David
