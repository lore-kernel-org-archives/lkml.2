Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324Ab1D1Pni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:43:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59749 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933296Ab1D1Pnc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:43:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=onNbOJZl25ekD7SEmthnue3VpXYvIEbxfaefSGFCdbBZKSYcjLlfcT3MTD78LsDc6K
         Gci1XWMRDDAMWuU/liAi36mtNBKbT02vLMGPwbsID7N/iokZ/kO+IWasnXhRfpADImg/
         xTRVJGucdwR0Oyw1NSKaT/Jp6P1cwfqvYwdKM=
MIME-Version: 1.0
In-Reply-To: <20110429000304.3D60.A69D9226@jp.fujitsu.com>
References: <20110429000304.3D60.A69D9226@jp.fujitsu.com>
Date: Thu, 28 Apr 2011 12:43:31 -0300
Message-ID: <BANLkTi=FwXMo=qRAS=1ORDF28kxXiR=G3Q@mail.gmail.com>
Subject: Re: [PATCH] s390: convert old cpumask API into new one
From: Thiago Farina <tfransosi@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 12:01 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Adapt new API.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: linux390@de.ibm.com
> Cc: linux-s390@vger.kernel.org
> ---
>  arch/s390/include/asm/tlbflush.h |    2 +-
>  arch/s390/kernel/smp.c           |   24 ++++++++++++------------
>  arch/s390/kernel/time.c          |    4 ++--
>  arch/s390/kernel/topology.c      |   16 ++++++++--------
>  4 files changed, 23 insertions(+), 23 deletions(-)
>
> diff --git a/arch/s390/include/asm/tlbflush.h b/arch/s390/include/asm/tlbflush.h
> index 4fdcefc..b7a4f2e 100644
> --- a/arch/s390/include/asm/tlbflush.h
> +++ b/arch/s390/include/asm/tlbflush.h
> @@ -50,7 +50,7 @@ static inline void __tlb_flush_full(struct mm_struct *mm)
>        /*
>         * If the process only ran on the local cpu, do a local flush.
>         */
> -       local_cpumask = cpumask_of_cpu(smp_processor_id());
> +       cpumask_copy(&local_cpumask, cpumask_of(smp_processor_id()));
>        if (cpumask_equal(mm_cpumask(mm), &local_cpumask))
>                __tlb_flush_local();
>        else
> diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
> index 63c7d9f..4cc09b8 100644
> --- a/arch/s390/kernel/smp.c
> +++ b/arch/s390/kernel/smp.c
> @@ -335,7 +335,7 @@ static int smp_rescan_cpus_sigp(cpumask_t avail)
>                smp_cpu_polarization[logical_cpu] = POLARIZATION_UNKNWN;
>                if (!cpu_stopped(logical_cpu))
>                        continue;
> -               cpu_set(logical_cpu, cpu_present_map);
> +               set_cpu_present(logical_cpu, true);
>                smp_cpu_state[logical_cpu] = CPU_STATE_CONFIGURED;
>                logical_cpu = cpumask_next(logical_cpu, &avail);
>                if (logical_cpu >= nr_cpu_ids)
> @@ -367,7 +367,7 @@ static int smp_rescan_cpus_sclp(cpumask_t avail)
>                        continue;
>                __cpu_logical_map[logical_cpu] = cpu_id;
>                smp_cpu_polarization[logical_cpu] = POLARIZATION_UNKNWN;
> -               cpu_set(logical_cpu, cpu_present_map);
> +               set_cpu_present(logical_cpu, true);
>                if (cpu >= info->configured)
>                        smp_cpu_state[logical_cpu] = CPU_STATE_STANDBY;
>                else
> @@ -385,7 +385,7 @@ static int __smp_rescan_cpus(void)
>  {
>        cpumask_t avail;
>
> -       cpus_xor(avail, cpu_possible_map, cpu_present_map);
> +       cpumask_xor(&avail, cpu_possible_mask, cpu_present_mask);
>        if (smp_use_sigp_detection)
>                return smp_rescan_cpus_sigp(avail);
>        else
> @@ -467,7 +467,7 @@ int __cpuinit start_secondary(void *cpuvoid)
>        notify_cpu_starting(smp_processor_id());
>        /* Mark this cpu as online */
>        ipi_call_lock();
> -       cpu_set(smp_processor_id(), cpu_online_map);
> +       set_cpu_online(smp_processor_id(), true);
>        ipi_call_unlock();
>        /* Switch on interrupts */
>        local_irq_enable();
> @@ -644,7 +644,7 @@ int __cpu_disable(void)
>        struct ec_creg_mask_parms cr_parms;
>        int cpu = smp_processor_id();
>
> -       cpu_clear(cpu, cpu_online_map);
> +       set_cpu_online(cpu, false);
>
>        /* Disable pfault pseudo page faults on this cpu. */
>        pfault_fini();
> @@ -738,8 +738,8 @@ void __init smp_prepare_boot_cpu(void)
>        BUG_ON(smp_processor_id() != 0);
>
>        current_thread_info()->cpu = 0;
> -       cpu_set(0, cpu_present_map);
> -       cpu_set(0, cpu_online_map);
> +       set_cpu_present(0, true);
> +       set_cpu_online(0, true);
>        S390_lowcore.percpu_offset = __per_cpu_offset[0];
>        current_set[0] = current;
>        smp_cpu_state[0] = CPU_STATE_CONFIGURED;
> @@ -1016,21 +1016,21 @@ int __ref smp_rescan_cpus(void)
>
>        get_online_cpus();
>        mutex_lock(&smp_cpu_state_mutex);
> -       newcpus = cpu_present_map;
> +       cpumask_copy(&newcpus, cpu_present_mask);
>        rc = __smp_rescan_cpus();
>        if (rc)
>                goto out;
> -       cpus_andnot(newcpus, cpu_present_map, newcpus);
> -       for_each_cpu_mask(cpu, newcpus) {
> +       cpumask_andnot(&newcpus, cpu_present_mask, &newcpus);
> +       for_each_cpu(cpu,&newcpus) {
please, could you add a space between cpu and ,&newcpus?

>                rc = smp_add_present_cpu(cpu);
>                if (rc)
> -                       cpu_clear(cpu, cpu_present_map);
> +                       set_cpu_present(cpu, false);
>        }
>        rc = 0;
>  out:
>        mutex_unlock(&smp_cpu_state_mutex);
>        put_online_cpus();
> -       if (!cpus_empty(newcpus))
> +       if (!cpumask_empty(&newcpus))
>                topology_schedule_update();
>        return rc;
>  }
> diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
> index 87be655..a59557f 100644
> --- a/arch/s390/kernel/time.c
> +++ b/arch/s390/kernel/time.c
> @@ -810,7 +810,7 @@ static int etr_sync_clock_stop(struct etr_aib *aib, int port)
>        etr_sync.etr_port = port;
>        get_online_cpus();
>        atomic_set(&etr_sync.cpus, num_online_cpus() - 1);
> -       rc = stop_machine(etr_sync_clock, &etr_sync, &cpu_online_map);
> +       rc = stop_machine(etr_sync_clock, &etr_sync, cpu_online_mask);
>        put_online_cpus();
>        return rc;
>  }
> @@ -1579,7 +1579,7 @@ static void stp_work_fn(struct work_struct *work)
>        memset(&stp_sync, 0, sizeof(stp_sync));
>        get_online_cpus();
>        atomic_set(&stp_sync.cpus, num_online_cpus() - 1);
> -       stop_machine(stp_sync_clock, &stp_sync, &cpu_online_map);
> +       stop_machine(stp_sync_clock, &stp_sync, cpu_online_mask);
>        put_online_cpus();
>
>        if (!check_sync_clock())
> diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
> index 94b06c3..2eafb8c 100644
> --- a/arch/s390/kernel/topology.c
> +++ b/arch/s390/kernel/topology.c
> @@ -52,20 +52,20 @@ static cpumask_t cpu_group_map(struct mask_info *info, unsigned int cpu)
>  {
>        cpumask_t mask;
>
> -       cpus_clear(mask);
> +       cpumask_clear(&mask);
>        if (!topology_enabled || !MACHINE_HAS_TOPOLOGY) {
>                cpumask_copy(&mask, cpumask_of(cpu));
>                return mask;
>        }
>        while (info) {
> -               if (cpu_isset(cpu, info->mask)) {
> +               if (cpumask_test_cpu(cpu, &info->mask)) {
>                        mask = info->mask;
>                        break;
>                }
>                info = info->next;
>        }
> -       if (cpus_empty(mask))
> -               mask = cpumask_of_cpu(cpu);
> +       if (cpumask_empty(&mask))
> +               cpumask_copy(&mask, cpumask_of(cpu));
>        return mask;
>  }
>
> @@ -85,10 +85,10 @@ static void add_cpus_to_mask(struct topology_cpu *tl_cpu,
>                        if (cpu_logical_map(lcpu) != rcpu)
>                                continue;
>  #ifdef CONFIG_SCHED_BOOK
> -                       cpu_set(lcpu, book->mask);
> +                       cpumask_set_cpu(lcpu, &book->mask);
>                        cpu_book_id[lcpu] = book->id;
>  #endif
> -                       cpu_set(lcpu, core->mask);
> +                       cpumask_set_cpu(lcpu, &core->mask);
>                        cpu_core_id[lcpu] = core->id;
>                        smp_cpu_polarization[lcpu] = tl_cpu->pp;
>                }
> @@ -101,13 +101,13 @@ static void clear_masks(void)
>
>        info = &core_info;
>        while (info) {
> -               cpus_clear(info->mask);
> +               cpumask_clear(&info->mask);
>                info = info->next;
>        }
>  #ifdef CONFIG_SCHED_BOOK
>        info = &book_info;
>        while (info) {
> -               cpus_clear(info->mask);
> +               cpumask_clear(&info->mask);
>                info = info->next;
>        }
>  #endif
> --
> 1.7.3.1
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
