Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab0KBPdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 11:33:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:32772 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674Ab0KBPdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 11:33:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,282,1286175600"; 
   d="scan'208";a="622756769"
Subject: Re: [DRAFT PATCH 2/3] perf: Implement Nehalem uncore pmu
From: Lin Ming <ming.m.lin@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "paulus@samba.org" <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimyTYNczZqV5gPmKfL6iYjNf3wpYYFi+5US8bP3@mail.gmail.com>
References: <1288682905.12061.109.camel@minggr.sh.intel.com>
	 <AANLkTimyTYNczZqV5gPmKfL6iYjNf3wpYYFi+5US8bP3@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 23:33:43 +0800
Message-Id: <1288712023.2457.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-02 at 22:53 +0800, Stephane Eranian wrote:
> Lin,
> 
> On Tue, Nov 2, 2010 at 8:28 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> > For the background of Nehalem uncore pmu, see Intel SDM Volume 3B
> > "30.6.2 Performance Monitoring Facility in the Uncore"
> >
> > 1. data structure
> >
> > struct node_hw_events {
> >        struct perf_event *events[UNCORE_NUM_COUNTERS];
> >        int n_events;
> >        struct spinlock lock;
> >        int enabled;
> > };
> >
> > struct node_hw_events is the per node structure.
> > "lock" protects add/delete events to uncore pmu.
> >
> > struct uncore_cpu_hw_events {
> >        unsigned long active_mask[BITS_TO_LONGS(UNCORE_NUM_COUNTERS)];
> > };
> >
> > struct uncore_cpu_hw_events is the per logical cpu structure.
> > "active_mask" represents the counters used by the cpu.
> > For example, if bit 3, 6 are set for cpuX, then it means uncore counter
> > 3 and 6 are used by cpuX.
> >
> I would advise you allocate your uncore_events[] table dynamically
> using kmalloc_node(). That way you avoid unnecessary remote
> memory accesses.

Good point. Will do this.

> 
> Furthermore, the patch is missing support for the fixed uncore counter. It is
> very useful as it allows measuring some reference cycles at the socket

Yes, I'll add fixed uncore counter and possibly also the uncore
address/opcode match thing.

> level. You have 8+1 counter total. You need to define some encoding
> for UNC_CPU_CLK.

Could you explain a bit more? What's the encoding for UNC_CPU_CLK?

> 
> Another tidbit is about handling of exclude_*. Uncore PMU does measure
> at all priv level all the time. I think it would be wise to fail if
> the user passes
> anything different from exclude_* = 0. Otherwise you think you are measuring
> at some levels but in reality you are not.

Yes, will do this.

> 
> 
> > 2. Uncore pmu NMI handling
> >
> > Every core in the socket can be programmed to receive uncore counter
> > overflow interrupt.
> >
> > In this draft implementation, each core handles the overflow interrupt
> > caused by the counters with bit set in "active_mask".
> >
> Seems like in your model, interrupting all cores is the only solution given
> that you can program uncore events from any cores on the socket.

Do you see some potential problem with this model?

And do you have some ideas about the issue I mentioned in PATCH 0/3?
Copy it here.

4. Issues

How to eliminate the duplicate counter values accumulated by multi child
processes on the same socket?

perf stat -e ru0101 -- make -j4

Assume the 4 "make" child processes are running on the same socket and
counting uncore raw event "0101", and the counter value read by them are
val0, val1, val2, val3.

Then the final counter result given by "perf stat" will be "val0 + val1
+ val2 + val3".

But this is obvious wrong, because the uncore counter is shared by all
cores in the socket, so the final result should not be accumulated.

Many thanks,
Lin Ming

> 
> 
> > ---
> >  arch/x86/include/asm/msr-index.h              |    1 +
> >  arch/x86/kernel/cpu/perf_event.c              |    7 +-
> >  arch/x86/kernel/cpu/perf_event_intel_uncore.c |  280 +++++++++++++++++++++++++
> >  arch/x86/kernel/cpu/perf_event_intel_uncore.h |   80 +++++++
> >  4 files changed, 367 insertions(+), 1 deletions(-)
> >  create mode 100644 arch/x86/kernel/cpu/perf_event_intel_uncore.c
> >  create mode 100644 arch/x86/kernel/cpu/perf_event_intel_uncore.h
> >
> > diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> > index 3ea3dc4..816fb4b 100644
> > --- a/arch/x86/include/asm/msr-index.h
> > +++ b/arch/x86/include/asm/msr-index.h
> > @@ -81,6 +81,7 @@
> >  #define DEBUGCTLMSR_BTS_OFF_OS         (1UL <<  9)
> >  #define DEBUGCTLMSR_BTS_OFF_USR                (1UL << 10)
> >  #define DEBUGCTLMSR_FREEZE_LBRS_ON_PMI (1UL << 11)
> > +#define DEBUGCTLMSR_ENABLE_UNCORE_PMI  (1UL << 13)
> >
> >  #define MSR_IA32_MC0_CTL               0x00000400
> >  #define MSR_IA32_MC0_STATUS            0x00000401
> > diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> > index 7cea0f4..cca07b4 100644
> > --- a/arch/x86/kernel/cpu/perf_event.c
> > +++ b/arch/x86/kernel/cpu/perf_event.c
> > @@ -1215,6 +1215,8 @@ struct pmu_nmi_state {
> >
> >  static DEFINE_PER_CPU(struct pmu_nmi_state, pmu_nmi);
> >
> > +static int uncore_pmu_handle_irq(struct pt_regs *regs);
> > +
> >  static int __kprobes
> >  perf_event_nmi_handler(struct notifier_block *self,
> >                         unsigned long cmd, void *__args)
> > @@ -1249,7 +1251,8 @@ perf_event_nmi_handler(struct notifier_block *self,
> >
> >        apic_write(APIC_LVTPC, APIC_DM_NMI);
> >
> > -       handled = x86_pmu.handle_irq(args->regs);
> > +       handled = uncore_pmu_handle_irq(args->regs);
> > +       handled += x86_pmu.handle_irq(args->regs);
> >        if (!handled)
> >                return NOTIFY_DONE;
> >
> > @@ -1305,6 +1308,7 @@ x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
> >  #include "perf_event_intel_lbr.c"
> >  #include "perf_event_intel_ds.c"
> >  #include "perf_event_intel.c"
> > +#include "perf_event_intel_uncore.c"
> >
> >  static int __cpuinit
> >  x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
> > @@ -1360,6 +1364,7 @@ void __init init_hw_perf_events(void)
> >
> >        switch (boot_cpu_data.x86_vendor) {
> >        case X86_VENDOR_INTEL:
> > +               init_uncore_pmu();
> >                err = intel_pmu_init();
> >                break;
> >        case X86_VENDOR_AMD:
> > diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> > new file mode 100644
> > index 0000000..fafa0f9
> > --- /dev/null
> > +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> > @@ -0,0 +1,280 @@
> > +#include "perf_event_intel_uncore.h"
> > +
> > +static struct node_hw_events uncore_events[MAX_NUMNODES];
> > +static DEFINE_PER_CPU(struct uncore_cpu_hw_events, uncore_cpu_hw_events);
> > +static bool uncore_pmu_initialized;
> > +
> > +static void uncore_pmu_enable_event(struct perf_event *event)
> > +{
> > +       struct hw_perf_event *hwc = &event->hw;
> > +
> > +       wrmsrl(hwc->config_base + hwc->idx, hwc->config | UNCORE_EVENTSEL_ENABLE);
> > +}
> > +
> > +static void uncore_pmu_disable_event(struct perf_event *event)
> > +{
> > +       struct hw_perf_event *hwc = &event->hw;
> > +
> > +       wrmsrl(hwc->config_base + hwc->idx, hwc->config);
> > +}
> > +
> > +static void uncore_pmu_disable_events(void)
> > +{
> > +       struct uncore_cpu_hw_events *cpuc = &__get_cpu_var(uncore_cpu_hw_events);
> > +       int node = numa_node_id();
> > +       int bit;
> > +
> > +       for_each_set_bit(bit, cpuc->active_mask, UNCORE_NUM_COUNTERS)
> > +               uncore_pmu_disable_event(uncore_events[node].events[bit]);
> > +}
> > +
> > +static void uncore_pmu_enable_events(void)
> > +{
> > +       struct uncore_cpu_hw_events *cpuc = &__get_cpu_var(uncore_cpu_hw_events);
> > +       int node = numa_node_id();
> > +       int bit;
> > +
> > +       for_each_set_bit(bit, cpuc->active_mask, UNCORE_NUM_COUNTERS)
> > +               uncore_pmu_disable_event(uncore_events[node].events[bit]);
> > +}
> > +
> > +static void uncore_pmu_global_enable(void)
> > +{
> > +       u64 ctrl;
> > +
> > +       /* (0xFULL << 48): all 4 cores will receive NMI */
> > +       ctrl = ((1 << UNCORE_NUM_COUNTERS) - 1) | (0xFULL << 48);
> > +
> > +       wrmsrl(MSR_UNCORE_PERF_GLOBAL_CTRL, ctrl);
> > +}
> > +
> > +static void uncore_perf_event_destroy(struct perf_event *event)
> > +{
> > +       atomic_dec(&active_events);
> > +}
> > +
> > +static int uncore_pmu_event_init(struct perf_event *event)
> > +{
> > +       struct hw_perf_event *hwc = &event->hw;
> > +
> > +       if (!uncore_pmu_initialized)
> > +               return -ENOENT;
> > +
> > +       switch (event->attr.type) {
> > +       case PERF_TYPE_UNCORE:
> > +               break;
> > +
> > +       default:
> > +               return -ENOENT;
> > +       }
> > +
> > +       atomic_inc(&active_events);
> > +
> > +       event->destroy = uncore_perf_event_destroy;
> > +
> > +       hwc->idx = -1;
> > +       hwc->config = (event->attr.config & UNCORE_RAW_EVENT_MASK) | UNCORE_EVENTSEL_PMI;
> > +       hwc->config_base = MSR_UNCORE_PERFEVTSEL0;
> > +       hwc->event_base = MSR_UNCORE_PMC0;
> > +
> > +       return 0;
> > +}
> > +
> > +static void uncore_pmu_start(struct perf_event *event, int flags)
> > +{
> > +       if (flags & PERF_EF_RELOAD)
> > +               x86_perf_event_set_period(event);
> > +
> > +       uncore_pmu_enable_event(event);
> > +
> > +       perf_event_update_userpage(event);
> > +}
> > +
> > +static void uncore_pmu_stop(struct perf_event *event, int flags)
> > +{
> > +       struct uncore_cpu_hw_events *cpuc = &__get_cpu_var(uncore_cpu_hw_events);
> > +       struct hw_perf_event *hwc = &event->hw;
> > +
> > +       if (__test_and_clear_bit(hwc->idx, cpuc->active_mask))
> > +               uncore_pmu_disable_event(event);
> > +
> > +       if (flags & PERF_EF_UPDATE)
> > +               x86_perf_event_update(event, UNCORE_CNTVAL_BITS);
> > +}
> > +
> > +static int uncore_pmu_add(struct perf_event *event, int flags)
> > +{
> > +       struct uncore_cpu_hw_events *cpuc = &__get_cpu_var(uncore_cpu_hw_events);
> > +       int node = numa_node_id();
> > +       int ret = 1;
> > +       int i;
> > +       u64 ctrl;
> > +
> > +       spin_lock(&uncore_events[node].lock);
> > +
> > +       for (i = 0; i < UNCORE_NUM_COUNTERS; i++) {
> > +               if (!uncore_events[node].events[i]) {
> > +                       uncore_events[node].events[i] = event;
> > +                       uncore_events[node].n_events++;
> > +
> > +                       event->hw.idx = i;
> > +                       __set_bit(i, cpuc->active_mask);
> > +                       if (flags & PERF_EF_START)
> > +                               uncore_pmu_start(event, PERF_EF_RELOAD);
> > +                       ret = 0;
> > +                       break;
> > +               }
> > +       }
> > +
> > +       /*
> > +        * PMI delivery due to an uncore counter overflow is enabled by
> > +        * setting IA32_DEBUG_CTL.Offcore_PMI_EN to 1.
> > +        */
> > +       if (uncore_events[node].n_events == 1) {
> > +               rdmsrl(MSR_IA32_DEBUGCTLMSR, ctrl);
> > +               wrmsrl(MSR_IA32_DEBUGCTLMSR, ctrl | DEBUGCTLMSR_ENABLE_UNCORE_PMI);
> > +       }
> > +
> > +       if (unlikely(!uncore_events[node].enabled)) {
> > +               uncore_pmu_global_enable();
> > +               uncore_events[node].enabled = 1;
> > +       }
> > +
> > +       spin_unlock(&uncore_events[node].lock);
> > +
> > +       return ret;
> > +}
> > +
> > +static void uncore_pmu_del(struct perf_event *event, int flags)
> > +{
> > +       int node = numa_node_id();
> > +       struct hw_perf_event *hwc = &event->hw;
> > +       int i;
> > +
> > +       spin_lock(&uncore_events[node].lock);
> > +
> > +       for (i = 0; i < UNCORE_NUM_COUNTERS; i++) {
> > +               if (uncore_events[node].events[i] == event) {
> > +                       uncore_events[node].events[hwc->idx] = NULL;
> > +                       uncore_events[node].n_events--;
> > +
> > +                       uncore_pmu_stop(event, PERF_EF_UPDATE);
> > +                       break;
> > +               }
> > +       }
> > +
> > +       spin_unlock(&uncore_events[node].lock);
> > +}
> > +
> > +static void uncore_pmu_read(struct perf_event *event)
> > +{
> > +       x86_perf_event_update(event, UNCORE_CNTVAL_BITS);
> > +}
> > +
> > +static struct pmu uncore_pmu = {
> > +       .event_init     = uncore_pmu_event_init,
> > +       .add            = uncore_pmu_add,
> > +       .del            = uncore_pmu_del,
> > +       .start          = uncore_pmu_start,
> > +       .stop           = uncore_pmu_stop,
> > +       .read           = uncore_pmu_read,
> > +};
> > +
> > +
> > +static inline u64 uncore_pmu_get_status(void)
> > +{
> > +       struct uncore_cpu_hw_events *cpuc = &__get_cpu_var(uncore_cpu_hw_events);
> > +       u64 status;
> > +
> > +       rdmsrl(MSR_UNCORE_PERF_GLOBAL_STATUS, status);
> > +
> > +       return status & (*(u64 *)cpuc->active_mask |
> > +               MSR_UNCORE_PERF_GLOBAL_STATUS_OVF_PMI | MSR_UNCORE_PERF_GLOBAL_STATUS_CHG);
> > +}
> > +
> > +static inline void uncore_pmu_ack_status(u64 ack)
> > +{
> > +       wrmsrl(MSR_UNCORE_PERF_GLOBAL_OVF_CTRL, ack);
> > +}
> > +
> > +static int uncore_pmu_save_and_restart(struct perf_event *event)
> > +{
> > +       x86_perf_event_update(event, UNCORE_CNTVAL_BITS);
> > +       return x86_perf_event_set_period(event);
> > +}
> > +
> > +int uncore_pmu_handle_irq(struct pt_regs *regs)
> > +{
> > +       struct perf_sample_data data;
> > +       struct node_hw_events *uncore_node;
> > +       int node;
> > +       int bit;
> > +       u64 status;
> > +       int handled = 0;
> > +
> > +       perf_sample_data_init(&data, 0);
> > +
> > +       node = numa_node_id();
> > +       uncore_node = &uncore_events[node];
> > +
> > +       status = uncore_pmu_get_status();
> > +       if (!status) {
> > +               apic_write(APIC_LVTPC, APIC_DM_NMI);
> > +
> > +               return 1;
> > +       }
> > +
> > +       uncore_pmu_disable_events();
> > +again:
> > +       uncore_pmu_ack_status(status);
> > +
> > +       for_each_set_bit(bit, (unsigned long *)&status, UNCORE_NUM_COUNTERS) {
> > +               struct perf_event *event = uncore_node->events[bit];
> > +
> > +               handled++;
> > +
> > +               if (!uncore_pmu_save_and_restart(event))
> > +                       continue;
> > +
> > +               data.period = event->hw.last_period;
> > +
> > +               if (perf_event_overflow(event, 1, &data, regs))
> > +                       uncore_pmu_stop(event, 0);
> > +       }
> > +
> > +       /*
> > +        * Repeat if there is more work to be done:
> > +        */
> > +       status = uncore_pmu_get_status();
> > +       if (status)
> > +               goto again;
> > +
> > +       uncore_pmu_enable_events();
> > +       return handled;
> > +}
> > +
> > +void __init init_uncore_pmu(void)
> > +{
> > +       union cpuid01_eax eax;
> > +       unsigned int unused;
> > +       unsigned int model;
> > +       int i;
> > +
> > +       if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
> > +               return;
> > +
> > +       cpuid(1, &eax.full, &unused, &unused, &unused);
> > +
> > +       /* Check CPUID signatures: 06_1AH, 06_1EH, 06_1FH */
> > +       model = eax.split.model | (eax.split.ext_model << 4);
> > +       if (eax.split.family != 6 || (model != 0x1A && model != 0x1E && model != 0x1F))
> > +               return;
> > +
> > +       pr_cont("Nehalem uncore pmu, \n");
> > +
> > +       for (i = 0; i < MAX_NUMNODES; i++)
> > +               spin_lock_init(&uncore_events[i].lock);
> > +
> > +       perf_pmu_register(&uncore_pmu);
> > +       uncore_pmu_initialized = true;
> > +}
> > diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
> > new file mode 100644
> > index 0000000..33b9b5e
> > --- /dev/null
> > +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
> > @@ -0,0 +1,80 @@
> > +#include <linux/perf_event.h>
> > +#include <linux/capability.h>
> > +#include <linux/notifier.h>
> > +#include <linux/hardirq.h>
> > +#include <linux/kprobes.h>
> > +#include <linux/module.h>
> > +#include <linux/kdebug.h>
> > +#include <linux/sched.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/slab.h>
> > +#include <linux/highmem.h>
> > +#include <linux/cpu.h>
> > +#include <linux/bitops.h>
> > +
> > +#include <asm/apic.h>
> > +#include <asm/stacktrace.h>
> > +#include <asm/nmi.h>
> > +#include <asm/compat.h>
> > +
> > +#define MSR_UNCORE_PERF_GLOBAL_CTRL    0x391
> > +#define MSR_UNCORE_PERF_GLOBAL_STATUS  0x392
> > +#define MSR_UNCORE_PERF_GLOBAL_OVF_CTRL        0x393
> > +#define MSR_UNCORE_FIXED_CTR0          0x394
> > +#define MSR_UNCORE_FIXED_CTR_CTRL      0x395
> > +#define MSR_UNCORE_ADDR_OPCODE_MATCH   0x396
> > +
> > +#define MSR_UNCORE_PERF_GLOBAL_CTRL_PMI_CORE0 (1ULL << 48)
> > +#define MSR_UNCORE_PERF_GLOBAL_CTRL_PMI_FRZ (1ULL << 63)
> > +
> > +#define MSR_UNCORE_PERF_GLOBAL_STATUS_OVF_PMI  (1ULL << 61)
> > +#define MSR_UNCORE_PERF_GLOBAL_STATUS_CHG       (1ULL << 63)
> > +
> > +#define MSR_UNCORE_PMC0                        0x3b0
> > +
> > +#define MSR_UNCORE_PERFEVTSEL0         0x3c0
> > +
> > +#define UNCORE_EVENTSEL_EVENT                  0x000000FFULL
> > +#define UNCORE_EVENTSEL_UMASK                  0x0000FF00ULL
> > +#define UNCORE_EVENTSEL_OCC_CTR_RST            (1ULL << 17)
> > +#define UNCORE_EVENTSEL_EDGE                   (1ULL << 18)
> > +#define UNCORE_EVENTSEL_PMI                    (1ULL << 20)
> > +#define UNCORE_EVENTSEL_ENABLE                 (1ULL << 22)
> > +#define UNCORE_EVENTSEL_INV                    (1ULL << 23)
> > +#define UNCORE_EVENTSEL_CMASK                  0xFF000000ULL
> > +
> > +#define UNCORE_RAW_EVENT_MASK          \
> > +       (UNCORE_EVENTSEL_EVENT |        \
> > +        UNCORE_EVENTSEL_UMASK |        \
> > +        UNCORE_EVENTSEL_EDGE  |        \
> > +        UNCORE_EVENTSEL_INV   |        \
> > +        UNCORE_EVENTSEL_CMASK)
> > +
> > +#define UNCORE_CNTVAL_BITS     48
> > +
> > +#define UNCORE_NUM_COUNTERS 8
> > +
> > +union cpuid01_eax {
> > +       struct {
> > +               unsigned int stepping:4;
> > +               unsigned int model:4;
> > +               unsigned int family:4;
> > +               unsigned int type:2;
> > +               unsigned int reserve:2;
> > +               unsigned int ext_model:4;
> > +               unsigned int ext_family:4;
> > +       } split;
> > +       unsigned int full;
> > +};
> > +
> > +struct node_hw_events {
> > +       struct perf_event *events[UNCORE_NUM_COUNTERS]; /* in counter order */
> > +       int n_events;
> > +       struct spinlock lock;
> > +       int enabled;
> > +};
> > +
> > +struct uncore_cpu_hw_events {
> > +       unsigned long active_mask[BITS_TO_LONGS(UNCORE_NUM_COUNTERS)];
> > +};
> > +
> > --
> > 1.7.1
> >
> >
> >
> >
> >


