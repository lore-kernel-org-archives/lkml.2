Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab1A1K3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 05:29:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51544 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1A1K3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 05:29:31 -0500
Subject: Re: [PATCH] a patch to fix the cpu-offline-online problem caused
 by pm_idle
From: Peter Zijlstra <peterz@infradead.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx <tglx@linutronix.de>
In-Reply-To: <AANLkTikQs1UcfBGf_6shNVtdDSzR+8XzUKcx0amFZXey@mail.gmail.com>
References: <AANLkTinaOQpuJis5HgK316ANxpDS8eZ8Q0S4a44POrp0@mail.gmail.com>
	 <1295894492.28776.470.camel@laptop>
	 <AANLkTimq3jmza-t5iL10wgLLycwdDkJ3mznLQsKHM_Kf@mail.gmail.com>
	 <1295946736.28776.479.camel@laptop>
	 <AANLkTikQs1UcfBGf_6shNVtdDSzR+8XzUKcx0amFZXey@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 11:30:19 +0100
Message-ID: <1296210619.15234.263.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We have seen an extremely slow system under the CPU-OFFLINE-ONLIE test
> on a 4-sockets NHM-EX system.

Slow is OK, cpu-hotplug isn't performance critical by any means.

> The test case of off-line-on-line a cpu 1000 times and its performance
> is dominated by IPI and ipi_handler performance. On NHM-EX, Sending
> IPI not through broadcast is very slow. Needs to wake up processor by
> IPI from deep-c-state also incurs heavy weight delay in set_mtrr
> synchronization in stop_machinecontext. NHM-EX's c3-stop-APIC timer
> adds more trouble to the problem. If I understand the problem
> correctly, We probably need to tweak IPI code in upstream to get a
> clean solution for NHM-EX's slow IPI delivery problem to get
> reschedule tick processed without any delay on CPU which was in deep c state.
> But it needs more time. So A quick fix is provided to make the test pass.

If its slow but working, the test is broken, I don't see a reason to do
anything to the kernel, let alone the below.

> Without the patch the current CPU Office Online feature would not work
> reliably,

But you just said it was slow, that means its reliable, just not fast.

>  since it currently unnecessarily implicitly interact with
> CPU power management.

daft statement at best, because if not for some misguided power
management purpose, what are you actually unplugging cpus for?
(misguided because unplug doesn't actually safe more power than simply
idling the cpu).

> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 083e99d..832bbdc 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -83,6 +83,7 @@ DEFINE_PER_CPU(int, cpu_state) = { 0 };
>  * for idle threads.
>  */
>  #ifdef CONFIG_HOTPLUG_CPU
> +static struct notifier_block pm_idle_cpu_notifier;
>  /*
>   * Needed only for CONFIG_HOTPLUG_CPU because __cpuinitdata is
>   * removed after init for !CONFIG_HOTPLUG_CPU.
> @@ -1162,6 +1163,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
>                 uv_system_init();
>  
>         set_mtrr_aps_delayed_init();
> +       register_hotcpu_notifier(&pm_idle_cpu_notifier);
>  out:
>         preempt_enable();
>  }
> @@ -1469,6 +1471,42 @@ void native_play_dead(void)
>         hlt_play_dead();
>  }
>  
> +static void (*pm_idle_saved)(void);
> +
> +static inline void save_pm_idle(void)
> +{
> +       pm_idle_saved = pm_idle;
> +       pm_idle = default_idle;
> +       cpu_idle_wait();
> +}
> +
> +static inline void restore_pm_idle(void)
> +{
> +       pm_idle = pm_idle_saved;
> +       cpu_idle_wait();
> +}

So you flip the pm_idle pointer protected unter hotplug mutex, but
that's not serialized against module loading, so what happens if you
concurrently load a module that sets another idle policy?

Your changelog is vague at best, so what exactly is the purpose here? We
flip to default_idle(), which uses HLT, which is C1. Then you run
cpu_idle_wait(), which will IPI all cpus, all these CPUs (except one)
could have been in deep C states (C3+) so you get your slow wakeup
anyway. 

There-after you do the normal stop-machine hot-plug dance, which again
will IPI all cpus once, then you flip it back to the saved pm_idle
handler and again IPI all cpus.

You do this unconditionally, so:
  - you don't avoid a slow C3 wakup
  - you make a hotplug do 3 ipi round-trips instead of 1

Could you please explain wtf you're doing any why?




