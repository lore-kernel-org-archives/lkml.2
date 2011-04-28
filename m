Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623Ab1D1PT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:19:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41281 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab1D1PT4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:19:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wfTYA54nvS1aj/jobbD3Wdu/I45kHkM+RxuwiZZcCquGvD5QdrJpl+vzC7OACn135a
         ICAxEvm6tjir8y/VawSF+fs2ll64nlmZRBjshC2cZ+/c5AHVV21YGTIW+sKLxHd2WGz3
         +Y15p8GcFQ1jSp7pOzm7IUm4r6YRDwMiwr/4E=
MIME-Version: 1.0
In-Reply-To: <20110429000901.3D66.A69D9226@jp.fujitsu.com>
References: <20110429000901.3D66.A69D9226@jp.fujitsu.com>
Date: Thu, 28 Apr 2011 12:19:56 -0300
Message-ID: <BANLkTi=EvC6E_p+XSpzZUvhu0Q_gStROcQ@mail.gmail.com>
Subject: Re: [PATCH] powerpc: convert old cpumask API into new one
From: Thiago Farina <tfransosi@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 12:07 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Adapt new API.
>
> Almost change is trivial. Most important change is the below line
> because we plan to change task->cpus_allowed implementation.
>
> -       ctx->cpus_allowed = current->cpus_allowed;
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: linuxppc-dev@lists.ozlabs.org
> ---
>  arch/powerpc/include/asm/cputhreads.h        |   12 +++++-----
>  arch/powerpc/include/asm/kexec.h             |    2 +-
>  arch/powerpc/kernel/crash.c                  |   32 +++++++++++++-------------
>  arch/powerpc/kernel/setup-common.c           |    4 +-
>  arch/powerpc/kernel/smp.c                    |    4 +-
>  arch/powerpc/kernel/traps.c                  |    2 +-
>  arch/powerpc/mm/numa.c                       |    2 +-
>  arch/powerpc/platforms/cell/beat_smp.c       |    2 +-
>  arch/powerpc/platforms/cell/cbe_regs.c       |   11 +++++----
>  arch/powerpc/platforms/cell/smp.c            |   13 +++++-----
>  arch/powerpc/platforms/cell/spufs/sched.c    |    2 +-
>  arch/powerpc/platforms/pseries/hotplug-cpu.c |    2 +-
>  arch/powerpc/xmon/xmon.c                     |   16 ++++++------
>  13 files changed, 52 insertions(+), 52 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/cputhreads.h b/arch/powerpc/include/asm/cputhreads.h
> index f71bb4c..ce516e5 100644
> --- a/arch/powerpc/include/asm/cputhreads.h
> +++ b/arch/powerpc/include/asm/cputhreads.h
> @@ -37,16 +37,16 @@ extern cpumask_t threads_core_mask;
>  * This can typically be used for things like IPI for tlb invalidations
>  * since those need to be done only once per core/TLB
>  */
> -static inline cpumask_t cpu_thread_mask_to_cores(cpumask_t threads)
> +static inline cpumask_t cpu_thread_mask_to_cores(const struct cpumask *threads)
>  {
>        cpumask_t       tmp, res;
>        int             i;
>
> -       res = CPU_MASK_NONE;
> +       cpumask_clear(&res);
>        for (i = 0; i < NR_CPUS; i += threads_per_core) {
> -               cpus_shift_left(tmp, threads_core_mask, i);
> -               if (cpus_intersects(threads, tmp))
> -                       cpu_set(i, res);
> +               cpumask_shift_left(&tmp, &threads_core_mask, i);
> +               if (cpumask_intersects(threads, &tmp))
> +                       cpumask_set_cpu(i, &res);
>        }
>        return res;
>  }
> @@ -58,7 +58,7 @@ static inline int cpu_nr_cores(void)
>
>  static inline cpumask_t cpu_online_cores_map(void)
>  {
> -       return cpu_thread_mask_to_cores(cpu_online_map);
> +       return cpu_thread_mask_to_cores(cpu_online_mask);
>  }
>
>  #ifdef CONFIG_SMP
> diff --git a/arch/powerpc/include/asm/kexec.h b/arch/powerpc/include/asm/kexec.h
> index f54408d..8a33698 100644
> --- a/arch/powerpc/include/asm/kexec.h
> +++ b/arch/powerpc/include/asm/kexec.h
> @@ -76,7 +76,7 @@ extern void crash_send_ipi(void (*crash_ipi_callback)(struct pt_regs *));
>  extern cpumask_t cpus_in_sr;
>  static inline int kexec_sr_activated(int cpu)
>  {
> -       return cpu_isset(cpu,cpus_in_sr);
> +       return cpumask_test_cpu(cpu, &cpus_in_sr);
>  }
>
>  struct kimage;
> diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
> index 3d3d416..88e294f 100644
> --- a/arch/powerpc/kernel/crash.c
> +++ b/arch/powerpc/kernel/crash.c
> @@ -64,9 +64,9 @@ void crash_ipi_callback(struct pt_regs *regs)
>                return;
>
>        hard_irq_disable();
> -       if (!cpu_isset(cpu, cpus_in_crash))
> +       if (!cpumask_test_cpu(cpu, &cpus_in_crash))
>                crash_save_cpu(regs, cpu);
> -       cpu_set(cpu, cpus_in_crash);
> +       cpumask_set_cpu(cpu, &cpus_in_crash);
>
>        /*
>         * Entered via soft-reset - could be the kdump
> @@ -77,8 +77,8 @@ void crash_ipi_callback(struct pt_regs *regs)
>         * Tell the kexec CPU that entered via soft-reset and ready
>         * to go down.
>         */
> -       if (cpu_isset(cpu, cpus_in_sr)) {
> -               cpu_clear(cpu, cpus_in_sr);
> +       if (cpumask_test_cpu(cpu, &cpus_in_sr)) {
> +               cpumask_clear_cpu(cpu, &cpus_in_sr);
>                atomic_inc(&enter_on_soft_reset);
>        }
>
> @@ -87,7 +87,7 @@ void crash_ipi_callback(struct pt_regs *regs)
>         * This barrier is needed to make sure that all CPUs are stopped.
>         * If not, soft-reset will be invoked to bring other CPUs.
>         */
> -       while (!cpu_isset(crashing_cpu, cpus_in_crash))
> +       while (!cpumask_test_cpu(crashing_cpu, &cpus_in_crash))
>                cpu_relax();
>
>        if (ppc_md.kexec_cpu_down)
> @@ -109,7 +109,7 @@ static void crash_soft_reset_check(int cpu)
>  {
>        unsigned int ncpus = num_online_cpus() - 1;/* Excluding the panic cpu */
>
> -       cpu_clear(cpu, cpus_in_sr);
> +       cpumask_clear_cpu(cpu, &cpus_in_sr);
>        while (atomic_read(&enter_on_soft_reset) != ncpus)
>                cpu_relax();
>  }
> @@ -132,7 +132,7 @@ static void crash_kexec_prepare_cpus(int cpu)
>         */
>        printk(KERN_EMERG "Sending IPI to other cpus...\n");
>        msecs = 10000;
> -       while ((cpus_weight(cpus_in_crash) < ncpus) && (--msecs > 0)) {
> +       while ((cpumask_weight(&cpus_in_crash) < ncpus) && (--msecs > 0)) {
>                cpu_relax();
>                mdelay(1);
>        }
> @@ -144,20 +144,20 @@ static void crash_kexec_prepare_cpus(int cpu)
>         * user to do soft reset such that we get all.
>         * Soft-reset will be used until better mechanism is implemented.
>         */
> -       if (cpus_weight(cpus_in_crash) < ncpus) {
> +       if (cpumask_weight(&cpus_in_crash) < ncpus) {
>                printk(KERN_EMERG "done waiting: %d cpu(s) not responding\n",
> -                       ncpus - cpus_weight(cpus_in_crash));
> +                       ncpus - cpumask_weight(&cpus_in_crash));
>                printk(KERN_EMERG "Activate soft-reset to stop other cpu(s)\n");
> -               cpus_in_sr = CPU_MASK_NONE;
> +               cpumask_clear(&cpus_in_sr);
>                atomic_set(&enter_on_soft_reset, 0);
> -               while (cpus_weight(cpus_in_crash) < ncpus)
> +               while (cpumask_weight(&cpus_in_crash) < ncpus)
>                        cpu_relax();
>        }
>        /*
>         * Make sure all CPUs are entered via soft-reset if the kdump is
>         * invoked using soft-reset.
>         */
> -       if (cpu_isset(cpu, cpus_in_sr))
> +       if (cpumask_test_cpu(cpu, &cpus_in_sr))
>                crash_soft_reset_check(cpu);
>        /* Leave the IPI callback set */
>  }
> @@ -212,7 +212,7 @@ void crash_kexec_secondary(struct pt_regs *regs)
>                         * exited using 'x'(exit and recover) or
>                         * kexec_should_crash() failed for all running tasks.
>                         */
> -                       cpu_clear(cpu, cpus_in_sr);
> +                       cpumask_clear_cpu(cpu, &cpus_in_sr);
>                        local_irq_restore(flags);
>                        return;
>                }
> @@ -226,7 +226,7 @@ void crash_kexec_secondary(struct pt_regs *regs)
>                 * then start kexec boot.
>                 */
>                crash_soft_reset_check(cpu);
> -               cpu_set(crashing_cpu, cpus_in_crash);
> +               cpumask_set_cpu(crashing_cpu, &cpus_in_crash);
>                if (ppc_md.kexec_cpu_down)
>                        ppc_md.kexec_cpu_down(1, 0);
>                machine_kexec(kexec_crash_image);
> @@ -253,7 +253,7 @@ static void crash_kexec_prepare_cpus(int cpu)
>
>  void crash_kexec_secondary(struct pt_regs *regs)
>  {
> -       cpus_in_sr = CPU_MASK_NONE;
> +       cpumask_clear(&cpus_in_sr);
>  }
>  #endif
>
> @@ -345,7 +345,7 @@ void default_machine_crash_shutdown(struct pt_regs *regs)
>        crashing_cpu = smp_processor_id();
>        crash_save_cpu(regs, crashing_cpu);
>        crash_kexec_prepare_cpus(crashing_cpu);
> -       cpu_set(crashing_cpu, cpus_in_crash);
> +       cpumask_set_cpu(crashing_cpu, &cpus_in_crash);
>        crash_kexec_wait_realmode(crashing_cpu);
>
>        machine_kexec_mask_interrupts();
> diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
> index 21f30cb..1475df6 100644
> --- a/arch/powerpc/kernel/setup-common.c
> +++ b/arch/powerpc/kernel/setup-common.c
> @@ -381,7 +381,7 @@ static void __init cpu_init_thread_core_maps(int tpc)
>        int i;
>
>        threads_per_core = tpc;
> -       threads_core_mask = CPU_MASK_NONE;
> +       cpumask_clear(&threads_core_mask);
>
>        /* This implementation only supports power of 2 number of threads
>         * for simplicity and performance
> @@ -390,7 +390,7 @@ static void __init cpu_init_thread_core_maps(int tpc)
>        BUG_ON(tpc != (1 << threads_shift));
>
>        for (i = 0; i < tpc; i++)
> -               cpu_set(i, threads_core_mask);
> +               cpumask_set_cpu(i, &threads_core_mask);
>
>        printk(KERN_INFO "CPU maps initialized for %d thread%s per core\n",
>               tpc, tpc > 1 ? "s" : "");
> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
> index 9f9c204..da584a9 100644
> --- a/arch/powerpc/kernel/smp.c
> +++ b/arch/powerpc/kernel/smp.c
> @@ -507,7 +507,7 @@ int cpu_first_thread_of_core(int core)
>  }
>  EXPORT_SYMBOL_GPL(cpu_first_thread_of_core);
>
> -/* Must be called when no change can occur to cpu_present_map,
> +/* Must be called when no change can occur to cpu_present_mask,
>  * i.e. during cpu online or offline.
>  */
>  static struct device_node *cpu_to_l2cache(int cpu)
> @@ -608,7 +608,7 @@ void __init smp_cpus_done(unsigned int max_cpus)
>         * se we pin us down to CPU 0 for a short while
>         */
>        alloc_cpumask_var(&old_mask, GFP_NOWAIT);
> -       cpumask_copy(old_mask, &current->cpus_allowed);
> +       cpumask_copy(old_mask, tsk_cpus_allowed(current));
>        set_cpus_allowed_ptr(current, cpumask_of(boot_cpuid));
>
>        if (smp_ops && smp_ops->setup_cpu)
> diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
> index 5ddb801..af1f8f4 100644
> --- a/arch/powerpc/kernel/traps.c
> +++ b/arch/powerpc/kernel/traps.c
> @@ -221,7 +221,7 @@ void system_reset_exception(struct pt_regs *regs)
>        }
>
>  #ifdef CONFIG_KEXEC
> -       cpu_set(smp_processor_id(), cpus_in_sr);
> +       cpumask_set_cpu(smp_processor_id(), &cpus_in_sr);
>  #endif
>
>        die("System Reset", regs, SIGABRT);
> diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
> index 5ec1dad..d6cc587 100644
> --- a/arch/powerpc/mm/numa.c
> +++ b/arch/powerpc/mm/numa.c
> @@ -1453,7 +1453,7 @@ int arch_update_cpu_topology(void)
>        unsigned int associativity[VPHN_ASSOC_BUFSIZE] = {0};
>        struct sys_device *sysdev;
>
> -       for_each_cpu_mask(cpu, cpu_associativity_changes_mask) {
> +       for_each_cpu(cpu,&cpu_associativity_changes_mask) {
>                vphn_get_associativity(cpu, associativity);
>                nid = associativity_to_nid(associativity);
>
> diff --git a/arch/powerpc/platforms/cell/beat_smp.c b/arch/powerpc/platforms/cell/beat_smp.c
> index 26efc20..fd3cdb4 100644
> --- a/arch/powerpc/platforms/cell/beat_smp.c
> +++ b/arch/powerpc/platforms/cell/beat_smp.c
> @@ -85,7 +85,7 @@ static void smp_beatic_message_pass(int target, int msg)
>
>  static int __init smp_beatic_probe(void)
>  {
> -       return cpus_weight(cpu_possible_map);
> +       return cpumask_weight(cpu_possible_mask);
>  }
>
>  static void __devinit smp_beatic_setup_cpu(int cpu)
> diff --git a/arch/powerpc/platforms/cell/cbe_regs.c b/arch/powerpc/platforms/cell/cbe_regs.c
> index dbc338f..f3917e7 100644
> --- a/arch/powerpc/platforms/cell/cbe_regs.c
> +++ b/arch/powerpc/platforms/cell/cbe_regs.c
> @@ -45,8 +45,8 @@ static struct cbe_thread_map
>        unsigned int cbe_id;
>  } cbe_thread_map[NR_CPUS];
>
> -static cpumask_t cbe_local_mask[MAX_CBE] = { [0 ... MAX_CBE-1] = CPU_MASK_NONE };
> -static cpumask_t cbe_first_online_cpu = CPU_MASK_NONE;
> +static cpumask_t cbe_local_mask[MAX_CBE] = { [0 ... MAX_CBE-1] = {CPU_BITS_NONE} };
> +static cpumask_t cbe_first_online_cpu = { CPU_BITS_NONE };
>
>  static struct cbe_regs_map *cbe_find_map(struct device_node *np)
>  {
> @@ -159,7 +159,8 @@ EXPORT_SYMBOL_GPL(cbe_cpu_to_node);
>
>  u32 cbe_node_to_cpu(int node)
>  {
> -       return find_first_bit( (unsigned long *) &cbe_local_mask[node], sizeof(cpumask_t));
> +       return cpumask_first(&cbe_local_mask[node]);
> +
>  }
>  EXPORT_SYMBOL_GPL(cbe_node_to_cpu);
>
> @@ -268,9 +269,9 @@ void __init cbe_regs_init(void)
>                                thread->regs = map;
>                                thread->cbe_id = cbe_id;
>                                map->be_node = thread->be_node;
> -                               cpu_set(i, cbe_local_mask[cbe_id]);
> +                               cpumask_set_cpu(i, &cbe_local_mask[cbe_id]);
>                                if(thread->thread_id == 0)
while you are here, could you add a space between if and ( ?

> -                                       cpu_set(i, cbe_first_online_cpu);
> +                                       cpumask_set_cpu(i, &cbe_first_online_cpu);
>                        }
>                }
>
> diff --git a/arch/powerpc/platforms/cell/smp.c b/arch/powerpc/platforms/cell/smp.c
> index f774530..56e8fa0 100644
> --- a/arch/powerpc/platforms/cell/smp.c
> +++ b/arch/powerpc/platforms/cell/smp.c
> @@ -77,7 +77,7 @@ static inline int __devinit smp_startup_cpu(unsigned int lcpu)
>        unsigned int pcpu;
>        int start_cpu;
>
> -       if (cpu_isset(lcpu, of_spin_map))
> +       if (cpumask_test_cpu(lcpu, &of_spin_map))
>                /* Already started by OF and sitting in spin loop */
>                return 1;
>
> @@ -123,7 +123,7 @@ static int __init smp_iic_probe(void)
>  {
>        iic_request_IPIs();
>
> -       return cpus_weight(cpu_possible_map);
> +       return cpumask_weight(cpu_possible_mask);
>  }
>
>  static void __devinit smp_cell_setup_cpu(int cpu)
> @@ -186,13 +186,12 @@ void __init smp_init_cell(void)
>        if (cpu_has_feature(CPU_FTR_SMT)) {
>                for_each_present_cpu(i) {
>                        if (cpu_thread_in_core(i) == 0)
> -                               cpu_set(i, of_spin_map);
> +                               cpumask_set_cpu(i, &of_spin_map);
>                }
> -       } else {
> -               of_spin_map = cpu_present_map;
> -       }
> +       } else
> +               cpumask_copy(&of_spin_map, cpu_present_mask);
>
> -       cpu_clear(boot_cpuid, of_spin_map);
> +       cpumask_clear_cpu(boot_cpuid, &of_spin_map);
>
>        /* Non-lpar has additional take/give timebase */
>        if (rtas_token("freeze-time-base") != RTAS_UNKNOWN_SERVICE) {
> diff --git a/arch/powerpc/platforms/cell/spufs/sched.c b/arch/powerpc/platforms/cell/spufs/sched.c
> index 6520385..32cb4e6 100644
> --- a/arch/powerpc/platforms/cell/spufs/sched.c
> +++ b/arch/powerpc/platforms/cell/spufs/sched.c
> @@ -141,7 +141,7 @@ void __spu_update_sched_info(struct spu_context *ctx)
>         * runqueue. The context will be rescheduled on the proper node
>         * if it is timesliced or preempted.
>         */
> -       ctx->cpus_allowed = current->cpus_allowed;
> +       cpumask_copy(&ctx->cpus_allowed, tsk_cpus_allowed(current));
>
>        /* Save the current cpu id for spu interrupt routing. */
>        ctx->last_ran = raw_smp_processor_id();
> diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
> index ef8c454..7be7c20 100644
> --- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
> +++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
> @@ -280,7 +280,7 @@ static int pseries_add_processor(struct device_node *np)
>        }
>
>        for_each_cpu(cpu, tmp) {
> -               BUG_ON(cpumask_test_cpu(cpu, cpu_present_mask));
> +               BUG_ON(cpu_present(cpu));
>                set_cpu_present(cpu, true);
>                set_hard_smp_processor_id(cpu, *intserv++);
>        }
> diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
> index 33794c1..c160361 100644
> --- a/arch/powerpc/xmon/xmon.c
> +++ b/arch/powerpc/xmon/xmon.c
> @@ -334,7 +334,7 @@ static void release_output_lock(void)
>
>  int cpus_are_in_xmon(void)
>  {
> -       return !cpus_empty(cpus_in_xmon);
> +       return !cpumask_empty(&cpus_in_xmon);
>  }
>  #endif
>
> @@ -373,7 +373,7 @@ static int xmon_core(struct pt_regs *regs, int fromipi)
>
>  #ifdef CONFIG_SMP
>        cpu = smp_processor_id();
> -       if (cpu_isset(cpu, cpus_in_xmon)) {
> +       if (cpumask_test_cpu(cpu, &cpus_in_xmon)) {
>                get_output_lock();
>                excprint(regs);
>                printf("cpu 0x%x: Exception %lx %s in xmon, "
> @@ -396,7 +396,7 @@ static int xmon_core(struct pt_regs *regs, int fromipi)
>        }
>
>        xmon_fault_jmp[cpu] = recurse_jmp;
> -       cpu_set(cpu, cpus_in_xmon);
> +       cpumask_set_cpu(cpu, &cpus_in_xmon);
>
>        bp = NULL;
>        if ((regs->msr & (MSR_IR|MSR_PR|MSR_SF)) == (MSR_IR|MSR_SF))
> @@ -440,7 +440,7 @@ static int xmon_core(struct pt_regs *regs, int fromipi)
>                        smp_send_debugger_break(MSG_ALL_BUT_SELF);
>                        /* wait for other cpus to come in */
>                        for (timeout = 100000000; timeout != 0; --timeout) {
> -                               if (cpus_weight(cpus_in_xmon) >= ncpus)
> +                               if (cpumask_weight(&cpus_in_xmon) >= ncpus)
>                                        break;
>                                barrier();
>                        }
> @@ -484,7 +484,7 @@ static int xmon_core(struct pt_regs *regs, int fromipi)
>                }
>        }
>  leave:
> -       cpu_clear(cpu, cpus_in_xmon);
> +       cpumask_clear_cpu(cpu, &cpus_in_xmon);
>        xmon_fault_jmp[cpu] = NULL;
>  #else
>        /* UP is simple... */
> @@ -630,7 +630,7 @@ static int xmon_iabr_match(struct pt_regs *regs)
>  static int xmon_ipi(struct pt_regs *regs)
>  {
>  #ifdef CONFIG_SMP
> -       if (in_xmon && !cpu_isset(smp_processor_id(), cpus_in_xmon))
> +       if (in_xmon && !cpumask_test_cpu(smp_processor_id(), &cpus_in_xmon))
>                xmon_core(regs, 1);
>  #endif
>        return 0;
> @@ -976,7 +976,7 @@ static int cpu_cmd(void)
>                printf("cpus stopped:");
>                count = 0;
>                for (cpu = 0; cpu < NR_CPUS; ++cpu) {
> -                       if (cpu_isset(cpu, cpus_in_xmon)) {
> +                       if (cpumask_test_cpu(cpu, &cpus_in_xmon)) {
>                                if (count == 0)
>                                        printf(" %x", cpu);
>                                ++count;
> @@ -992,7 +992,7 @@ static int cpu_cmd(void)
>                return 0;
>        }
>        /* try to switch to cpu specified */
> -       if (!cpu_isset(cpu, cpus_in_xmon)) {
> +       if (!cpumask_test_cpu(cpu, &cpus_in_xmon)) {
>                printf("cpu 0x%x isn't in xmon\n", cpu);
>                return 0;
>        }
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
