Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab1E3NQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 09:16:57 -0400
Received: from smtp-out.google.com ([74.125.121.67]:47051 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab1E3NQ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 09:16:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x4H8Nzbb4km/pcoHUC1YADXc1bo0uVDWBBobMfL9G7DsAkNRhoFKCzhesldBepXXDt
         stpwPAnpLwufuUTrMpRw==
MIME-Version: 1.0
In-Reply-To: <1306761074.1200.2975.camel@twins>
References: <20110523161252.GA11607@quad>
	<1306761074.1200.2975.camel@twins>
Date: Mon, 30 May 2011 15:16:50 +0200
Message-ID: <BANLkTim5N_KhF1GHjTcvb-OAbO1_J=r7tA@mail.gmail.com>
Subject: Re: [PATCH 2/3] perf_events: fix validation of events using an extra
 reg (v3)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, Lin Ming <ming.m.lin@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 3:11 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Mon, 2011-05-23 at 18:12 +0200, Stephane Eranian wrote:
> > +static struct cpu_hw_events *allocate_fake_cpuc(void)
> > +{
> > +       struct cpu_hw_events *cpuc;
> > +       int cpu = smp_processor_id();
> > +
> > +       cpuc = kzalloc(sizeof(*cpuc), GFP_KERNEL);
> > +       if (!cpuc)
> > +               return ERR_PTR(-ENOMEM);
> > +
> > +       /* only needed, if we have extra_regs */
> > +       if (x86_pmu.extra_regs) {
> > +               cpuc->shared_regs = allocate_shared_regs(cpu);
> > +               if (!cpuc->shared_regs)
> > +                       goto error;
> > +       }
> > +       return cpuc;
> > +error:
> > +       free_fake_cpuc(cpuc);
> > +       return ERR_PTR(-ENOMEM);
> > +}
>
> Ingo found a case where that use of allocate_shared_regs() failed to
> compile but didn't provide a .config. I suspect its CONFIG_CPU_SUP_INTEL
> and the below should fix it. I will try to push that again later today.
>
Yes, it is quite possible. I think you are right about the cause of
this problem.
The alloate routine is in the Intel-specific code. If you don't
compile for Intel
then you will get an undefined symbol. It is not clear to me why you would
compile with Intel support, though.

> ---
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 41178c8..cf90e31 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1528,4 +1623,9 @@ static int intel_pmu_init(void)
>        return 0;
>  }
>
> +static struct intel_shared_regs *allocate_shared_regs(int cpu)
> +{
> +       return NULL;
> +}
> +
>  #endif /* CONFIG_CPU_SUP_INTEL */
>
