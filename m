Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab0CWOzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:55:18 -0400
Received: from smtp-out.google.com ([74.125.121.35]:26298 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab0CWOzQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:55:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=h47tkTpS1WaP6WL3869wgcWkYSQXmjrs/oD1gORhkdZXOUrcUrP+0ZzF4M+KD0hvN
	JddFblt/WlIoiwWxD6mwA==
MIME-Version: 1.0
In-Reply-To: <1269353485.5109.48.camel@twins>
References: <4ba0a646.25e2660a.1b25.531c@mx.google.com>
	 <1268869631.9440.282.camel@laptop>
	 <bd4cb8901003171733k95fcf50mf6de78bf503d9a7b@mail.gmail.com>
	 <1269353485.5109.48.camel@twins>
Date: Tue, 23 Mar 2010 15:55:11 +0100
Message-ID: <bd4cb8901003230755k41414173n302d7d626a6126b1@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix bug in AMD per-cpu initialization
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo <mingo@elte.hu>, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com,
       "hpa@zytor.com" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Manfred Spraul <manfred@colorfullife.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 3:11 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-03-18 at 01:33 +0100, Stephane Eranian wrote:
>> On Thu, Mar 18, 2010 at 12:47 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Wed, 2010-03-17 at 10:40 +0200, Stephane Eranian wrote:
>> >>       On AMD processors, we need to allocate a data structure per Northbridge
>> >>       to handle certain events.
>> >>
>> >>       On CPU initialization, we need to query the Northbridge id and check
>> >>       whether the structure is already allocated or not. We use the
>> >>       amd_get_nb_id() function to request the Northbridge identification.
>> >>
>> >>       The recent cleanup of the CPU online/offline initialization introduced
>> >>       a bug. AMD cpu initialization is invoked on CPU_UP_PREPARE callback.
>> >>       This is before the CPU Northbridge id is calculated. Therefore no
>> >>       processor had a Northbridge structure allocated except the boot
>> >>       processor. That was causing bogus NB event scheduling.
>> >>
>> >>       This patch uses the CPU_ONLINE callback to initialize the AMD
>> >>       Northbridge structure. This way amd_get_nb_id() returns valid
>> >>       information.
>> >>
>> >>       The x86_cpu_up() callback was added. Could not call it cpu_online
>> >>       because of existing macro.
>> >>
>> >>       Signed-off-by: Stephane Eranian <eranian@google.com>
>> >
>> >
>> > No, ONLINE is not exposed for a good reason, its always wrong.
>> >
>> > Use prepare to allocate data, and starting to initialize stuff on the
>> > cpu proper once its up. Online is after the cpu is up and running and we
>> > are already scheduling stuff on it so its too late to initialize things.
>> >
>> >
>> I can't because amd_get_nb_id() returns garbage for the CPU
>> when you call from CPU_STARTING. So looks like initialization
>> of cpu_llc_id needs to be moved way earlier. I don't want to have
>> to duplicate that code.
>
> Crap, you're right, either notify_cpu_starting() is done too early or
> smp_store_cpu_info() is done too late.
>
> Since smp_store_cpu_info() relies on the result of calibrate_delay() we
> can't easily change that order, but since there really isn't any other
> CPU_STARTING user in tree (I appear to have created the first?!) we can
> easily move that notifier thing later.
>
What's the point of CPU_ONLINE vs. CPU_STARTING if you're saying the
former is never right? Why not move CPU_ONLINE to the right place and drop
CPU_STARTING?



> (What's up with that IRQ-enable over calibrate_delay(), can't we simply
> enable the NMI watchdog later?)
>
> So I guess something like the below should work:
>
> ---
> arch/x86/kernel/smpboot.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 06d98ae..6808b93 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -242,8 +242,6 @@ static void __cpuinit smp_callin(void)
> end_local_APIC_setup();
> map_cpu_to_logical_apicid();
>
> - notify_cpu_starting(cpuid);
> -
> /*
> * Need to setup vector mappings before we enable interrupts.
> */
> @@ -264,6 +262,8 @@ static void __cpuinit smp_callin(void)
> */
> smp_store_cpu_info(cpuid);
>
> + notify_cpu_starting(cpuid);
> +
> /*
> * Allow the master to continue.
> */
>
>
> Which then allows us to write something like:
>
> ---
>
>  arch/x86/kernel/cpu/perf_event.c     |    8 ++-
>  arch/x86/kernel/cpu/perf_event_amd.c |   69 ++++++++++++++++++---------------
>  2 files changed, 43 insertions(+), 34 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index f571f51..4db6eaf 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -209,7 +209,7 @@ struct x86_pmu {
>        struct event_constraint *event_constraints;
>        void            (*quirks)(void);
>
> -       void            (*cpu_prepare)(int cpu);
> +       int             (*cpu_prepare)(int cpu);
>        void            (*cpu_starting)(int cpu);
>        void            (*cpu_dying)(int cpu);
>        void            (*cpu_dead)(int cpu);
> @@ -1330,11 +1330,12 @@ static int __cpuinit
>  x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
>  {
>        unsigned int cpu = (long)hcpu;
> +       int ret = NOTIFY_OK;
>
>        switch (action & ~CPU_TASKS_FROZEN) {
>        case CPU_UP_PREPARE:
>                if (x86_pmu.cpu_prepare)
> -                       x86_pmu.cpu_prepare(cpu);
> +                       ret = x86_pmu.cpu_prepare(cpu);
>                break;
>
>        case CPU_STARTING:
> @@ -1347,6 +1348,7 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
>                        x86_pmu.cpu_dying(cpu);
>                break;
>
> +       case CPU_UP_CANCELED:
>        case CPU_DEAD:
>                if (x86_pmu.cpu_dead)
>                        x86_pmu.cpu_dead(cpu);
> @@ -1356,7 +1358,7 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
>                break;
>        }
>
> -       return NOTIFY_OK;
> +       return ret;
>  }
>
>  static void __init pmu_check_apic(void)
> diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
> index bdd8f8e..b78c6c5 100644
> --- a/arch/x86/kernel/cpu/perf_event_amd.c
> +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> @@ -293,51 +293,55 @@ static struct amd_nb *amd_alloc_nb(int cpu, int nb_id)
>        return nb;
>  }
>
> -static void amd_pmu_cpu_online(int cpu)
> +static int amd_pmu_cpu_prepare(int cpu)
>  {
> -       struct cpu_hw_events *cpu1, *cpu2;
> -       struct amd_nb *nb = NULL;
> +       struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
> +
> +       WARN_ON_ONCE(cpuc->amd_nb);
> +
> +       if (boot_cpu_data.x86_max_cores < 2)
> +               return NOTIFY_OK;
> +
> +       cpuc->amd_nb = amd_alloc_nb(cpu, -1);
> +       if (!cpuc->amd_nb)
> +               return NOTIFY_BAD;
> +
> +       return NOTIFY_OK;
> +}
> +
> +static void amd_pmu_cpu_starting(int cpu)
> +{
> +       struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
> +       struct amd_nb *nb;
>        int i, nb_id;
>
>        if (boot_cpu_data.x86_max_cores < 2)
>                return;
>
> -       /*
> -        * function may be called too early in the
> -        * boot process, in which case nb_id is bogus
> -        */
>        nb_id = amd_get_nb_id(cpu);
> -       if (nb_id == BAD_APICID)
> -               return;
> -
> -       cpu1 = &per_cpu(cpu_hw_events, cpu);
> -       cpu1->amd_nb = NULL;
> +       WARN_ON_ONCE(nb_id == BAD_APICID);
>
>        raw_spin_lock(&amd_nb_lock);
>
>        for_each_online_cpu(i) {
> -               cpu2 = &per_cpu(cpu_hw_events, i);
> -               nb = cpu2->amd_nb;
> -               if (!nb)
> +               nb = per_cpu(cpu_hw_events, i).amd_nb;
> +               if (WARN_ON_ONCE(!nb))
>                        continue;
> -               if (nb->nb_id == nb_id)
> -                       goto found;
> -       }
>
> -       nb = amd_alloc_nb(cpu, nb_id);
> -       if (!nb) {
> -               pr_err("perf_events: failed NB allocation for CPU%d\n", cpu);
> -               raw_spin_unlock(&amd_nb_lock);
> -               return;
> +               if (nb->nb_id == nb_id) {
> +                       kfree(cpuc->amd_nb);
> +                       cpuc->amd_nb = nb;
> +                       break;
> +               }
>        }
> -found:
> -       nb->refcnt++;
> -       cpu1->amd_nb = nb;
> +
> +       cpuc->amd_nb->nb_id = nb_id;
> +       cpuc->amd_nb->refcnt++;
>
>        raw_spin_unlock(&amd_nb_lock);
>  }
>
> -static void amd_pmu_cpu_offline(int cpu)
> +static void amd_pmu_cpu_dead(int cpu)
>  {
>        struct cpu_hw_events *cpuhw;
>
> @@ -349,8 +353,10 @@ static void amd_pmu_cpu_offline(int cpu)
>        raw_spin_lock(&amd_nb_lock);
>
>        if (cpuhw->amd_nb) {
> -               if (--cpuhw->amd_nb->refcnt == 0)
> -                       kfree(cpuhw->amd_nb);
> +               struct amd_nb *nb = cpuhw->amd_nb;
> +
> +               if (nb->nb_id == -1 || --nb->refcnt == 0)
> +                       kfree(nb);
>
>                cpuhw->amd_nb = NULL;
>        }
> @@ -381,8 +387,9 @@ static __initconst struct x86_pmu amd_pmu = {
>        .get_event_constraints  = amd_get_event_constraints,
>        .put_event_constraints  = amd_put_event_constraints,
>
> -       .cpu_prepare            = amd_pmu_cpu_online,
> -       .cpu_dead               = amd_pmu_cpu_offline,
> +       .cpu_prepare            = amd_pmu_cpu_prepare,
> +       .cpu_starting           = amd_pmu_cpu_starting,
> +       .cpu_dead               = amd_pmu_cpu_dead,
>  };
>
>  static __init int amd_pmu_init(void)
>
>



-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
