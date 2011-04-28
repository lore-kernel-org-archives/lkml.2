Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab1D1PKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:10:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45633 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932882Ab1D1PKC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:10:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tTyKwhvwosW5Yh4MmsnpFmQkJtxRAzx1vjUW2SsoC/5a1iFOFfVb1hHecFHIwZ6p26
         5gkZNLZ+JV6lDnohrtU7MXZgaq8+K/nP37ybiYwTvYoIqUzec26qkUsTDathATxdgQgh
         6yKVyUWBRxZ/DKLVFn+Otggxul68YRqk1ULwE=
MIME-Version: 1.0
In-Reply-To: <20110429000619.3D63.A69D9226@jp.fujitsu.com>
References: <20110429000619.3D63.A69D9226@jp.fujitsu.com>
Date: Thu, 28 Apr 2011 12:10:01 -0300
Message-ID: <BANLkTikq2vorpoNzSCZ1B7z=gvtCNv0L=A@mail.gmail.com>
Subject: Re: [PATCH] cris: convert old cpumask API into new one
From: Thiago Farina <tfransosi@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 12:04 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Adapt new API.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Mikael Starvik <starvik@axis.com>
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: linux-cris-kernel@axis.com
>
> ---
>  arch/cris/arch-v32/kernel/irq.c |    4 ++--
>  arch/cris/arch-v32/kernel/smp.c |   33 ++++++++++++++++++---------------
>  2 files changed, 20 insertions(+), 17 deletions(-)
>
> diff --git a/arch/cris/arch-v32/kernel/irq.c b/arch/cris/arch-v32/kernel/irq.c
> index 68a1a59..5ebe6e8 100644
> --- a/arch/cris/arch-v32/kernel/irq.c
> +++ b/arch/cris/arch-v32/kernel/irq.c
> @@ -266,11 +266,11 @@ static int irq_cpu(int irq)
>
>
>        /* Let the interrupt stay if possible */
> -       if (cpu_isset(cpu, irq_allocations[irq - FIRST_IRQ].mask))
> +       if (cpumask_test_cpu(cpu, &irq_allocations[irq - FIRST_IRQ].mask))
>                goto out;
>
>        /* IRQ must be moved to another CPU. */
> -       cpu = first_cpu(irq_allocations[irq - FIRST_IRQ].mask);
> +       cpu = cpumask_first(&irq_allocations[irq - FIRST_IRQ].mask);
>        irq_allocations[irq - FIRST_IRQ].cpu = cpu;
>  out:
>        spin_unlock_irqrestore(&irq_lock, flags);
> diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
> index 66cc756..54467ec 100644
> --- a/arch/cris/arch-v32/kernel/smp.c
> +++ b/arch/cris/arch-v32/kernel/smp.c
> @@ -81,7 +81,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
>
>        /* Mark all possible CPUs as present */
>        for (i = 0; i < max_cpus; i++)
> -           cpu_set(i, phys_cpu_present_map);
> +           cpumask_set_cpu(i, &phys_cpu_present_map);
>  }
>
>  void __devinit smp_prepare_boot_cpu(void)
> @@ -98,7 +98,7 @@ void __devinit smp_prepare_boot_cpu(void)
>        SUPP_REG_WR(RW_MM_TLB_PGD, pgd);
>
>        set_cpu_online(0, true);
> -       cpu_set(0, phys_cpu_present_map);
> +       cpumask_set_cpu(0, &phys_cpu_present_map);
>        set_cpu_possible(0, true);
>  }
>
> @@ -112,8 +112,9 @@ smp_boot_one_cpu(int cpuid)
>  {
>        unsigned timeout;
>        struct task_struct *idle;
> -       cpumask_t cpu_mask = CPU_MASK_NONE;
> +       cpumask_t cpu_mask;
>
> +       cpumask_clear(&cpu_mask);
>        idle = fork_idle(cpuid);
>        if (IS_ERR(idle))
>                panic("SMP: fork failed for CPU:%d", cpuid);
> @@ -125,10 +126,10 @@ smp_boot_one_cpu(int cpuid)
>        cpu_now_booting = cpuid;
>
>        /* Kick it */
> -       cpu_set(cpuid, cpu_online_map);
> -       cpu_set(cpuid, cpu_mask);
> +       set_cpu_online(cpuid, true);
> +       cpumask_set_cpu(cpuid, &cpu_mask);
>        send_ipi(IPI_BOOT, 0, cpu_mask);
> -       cpu_clear(cpuid, cpu_online_map);
> +       set_cpu_online(cpuid, false);
>
>        /* Wait for CPU to come online */
>        for (timeout = 0; timeout < 10000; timeout++) {
> @@ -176,7 +177,7 @@ void __init smp_callin(void)
>        notify_cpu_starting(cpu);
>        local_irq_enable();
>
> -       cpu_set(cpu, cpu_online_map);
> +       set_cpu_online(cpu, true);
>        cpu_idle();
>  }
>
> @@ -214,8 +215,9 @@ int __cpuinit __cpu_up(unsigned int cpu)
>
>  void smp_send_reschedule(int cpu)
>  {
> -       cpumask_t cpu_mask = CPU_MASK_NONE;
> -       cpu_set(cpu, cpu_mask);
> +       cpumask_t cpu_mask;
> +       cpumask_clear(&cpu_mask);
> +       cpumask_set_cpu(cpu, &cpu_mask);
>        send_ipi(IPI_SCHEDULE, 0, cpu_mask);
>  }
>
> @@ -232,7 +234,7 @@ void flush_tlb_common(struct mm_struct* mm, struct vm_area_struct* vma, unsigned
>
>        spin_lock_irqsave(&tlbstate_lock, flags);
>        cpu_mask = (mm == FLUSH_ALL ? cpu_all_mask : *mm_cpumask(mm));
> -       cpu_clear(smp_processor_id(), cpu_mask);
> +       cpumask_clear_cpu(smp_processor_id(), &cpu_mask);
>        flush_mm = mm;
>        flush_vma = vma;
>        flush_addr = addr;
> @@ -277,10 +279,10 @@ int send_ipi(int vector, int wait, cpumask_t cpu_mask)
>        int ret = 0;
>
>        /* Calculate CPUs to send to. */
> -       cpus_and(cpu_mask, cpu_mask, cpu_online_map);
> +       cpumask_and(&cpu_mask, &cpu_mask, cpu_online_mask);
>
>        /* Send the IPI. */
> -       for_each_cpu_mask(i, cpu_mask)
> +       for_each_cpu(i,&cpu_mask)

please, could you add a space between i,&cpu_mask?

>        {
>                ipi.vector |= vector;
>                REG_WR(intr_vect, irq_regs[i], rw_ipi, ipi);
> @@ -288,7 +290,7 @@ int send_ipi(int vector, int wait, cpumask_t cpu_mask)
>
>        /* Wait for IPI to finish on other CPUS */
>        if (wait) {
> -               for_each_cpu_mask(i, cpu_mask) {
> +               for_each_cpu(i,&cpu_mask) {

please, could you add a space between i,&cpu_mask?

>                         int j;
>                         for (j = 0 ; j < 1000; j++) {
>                                ipi = REG_RD(intr_vect, irq_regs[i], rw_ipi);
> @@ -314,11 +316,12 @@ int send_ipi(int vector, int wait, cpumask_t cpu_mask)
>  */
>  int smp_call_function(void (*func)(void *info), void *info, int wait)
>  {
> -       cpumask_t cpu_mask = CPU_MASK_ALL;
> +       cpumask_t cpu_mask;
>        struct call_data_struct data;
>        int ret;
>
> -       cpu_clear(smp_processor_id(), cpu_mask);
> +       cpumask_setall(&cpu_mask);
> +       cpumask_clear_cpu(smp_processor_id(), &cpu_mask);
>
>        WARN_ON(irqs_disabled());
>
