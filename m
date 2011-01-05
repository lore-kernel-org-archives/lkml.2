Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab1AEFo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 00:44:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:34426 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab1AEFoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 00:44:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,276,1291622400"; 
   d="scan'208";a="693690462"
Subject: Re: [PATCH 4/7] perf: Check if HT is supported and enabled
From: Lin Ming <ming.m.lin@intel.com>
To: Stephane Eranian <eranian@google.com>, "Luck, Tony" <tony.luck@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTima_wh1Nd2E-zQAcymmux1O0e1GzVEdnhLEMOo5@mail.gmail.com>
References: <1293464211.2695.104.camel@localhost>
	 <AANLkTimp9VgD4qhOVmq-k1Ckzti9eeV8pf6Jvt5YB6nx@mail.gmail.com>
	 <1293526288.2457.4.camel@minggr.sh.intel.com>
	 <1294052312.2016.50.camel@laptop>	<4D222926.9010206@zytor.com>
	 <1294139419.2016.115.camel@laptop>
	 <AANLkTinGmgB7YhRjnsGMjj2knDuJ8XFps9oyW4+EGOr5@mail.gmail.com>
	 <1294148675.2016.139.camel@laptop>
	 <AANLkTima_wh1Nd2E-zQAcymmux1O0e1GzVEdnhLEMOo5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Jan 2011 13:45:20 +0800
Message-ID: <1294206320.9261.23.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 21:52 +0800, Stephane Eranian wrote:
> On Tue, Jan 4, 2011 at 2:44 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Tue, 2011-01-04 at 14:38 +0100, Stephane Eranian wrote:
> >> My solution at the time (2.6.30) was to do:
> >>         ht_enabled = cpumask_weight(__get_cpu_var(cpu_sibling_map)) > 1;
> >
> > Won't that report a machine a HT disabled when you offline a sibling?
> 
> I think you're right. I was not dealing with hotplug CPU.
> 
> > Which kinda defeats the purpose of our usage here, since we need to know
> > it before either sibling comes online.
> 
> Then, it seems the only hope is to peek at a MSR that reports the BIOS setting.
> But I don't know which one it is.
> 
> Couldn't you simply over-provision, and then when the CPU is online, use my
> ht_enabled statement to figure out whether or not you need to handle the sharing
> issue?

I got an idea from Tony,

> If this is worth doing, then perhaps you could write a routine
> to check if another HT thread on this same core has already been
> brought online ... i.e. defer the allocation to when you see the
> second thread. If HT is off, then you'll never see a second thread
> so you'll avoid the allocation

We can't defer the allocation to CPU_UP_PREPARE
notifier(intel_pmu_cpu_prepare), because the thread cpumask for that
booting cpu has not been setup yet.

So below code defers the allocation to CPU_STARTING
notifier(intel_pmu_cpu_starting).

static bool ht_enabled(int cpu)
{
        struct cpumask *siblings = topology_thread_cpumask(cpu);

        if (!cpu_has(&boot_cpu_data, X86_FEATURE_HT))
                return false;

        return cpus_weight(*siblings) > 1;
}

static void intel_pmu_cpu_starting(int cpu)
{
        struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
        struct intel_percore *pc;
        int core_id = topology_core_id(cpu);
        int i;

        init_debug_store_on_cpu(cpu);
        /*
         * Deal with CPUs that don't clear their LBRs on power-up.
         */
        intel_pmu_lbr_reset();

        if (!ht_enabled(cpu))
                return;

        cpuc->per_core = kzalloc_node(sizeof(struct intel_percore),
                                      GFP_KERNEL, cpu_to_node(cpu));
        if (!cpuc->per_core)
                return;

        raw_spin_lock_init(&cpuc->per_core->lock);
        pc = cpuc->per_core;

        for_each_cpu(i, topology_thread_cpumask(cpu)) {
                cpuc = &per_cpu(cpu_hw_events, cpu);

                cpuc->per_core = pc;
                cpuc->per_core->core_id = core_id;
                cpuc->per_core->refcnt++;
        }
}

But when unplug/plug 2 HT threads, I got a BUG.

BUG: sleeping function called from invalid context at /opt/linux-2.6/mm/slub.c:793
in_atomic(): 0, irqs_disabled(): 1, pid: 0, name: kworker/0:1
INFO: lockdep is turned off.
irq event stamp: 0
hardirqs last  enabled at (0): [<          (null)>]           (null)
hardirqs last disabled at (0): [<ffffffff8106b4f0>] copy_process+0x59d/0x11a7
softirqs last  enabled at (0): [<ffffffff8106b4f0>] copy_process+0x59d/0x11a7
softirqs last disabled at (0): [<          (null)>]           (null)
Pid: 0, comm: kworker/0:1 Tainted: G        W   2.6.37-rc7-tip-mlin+ #267
Call Trace:
 [<ffffffff81060144>] ? __might_sleep+0xe9/0xee
 [<ffffffff81113e14>] ? kmem_cache_alloc_node_notrace+0x49/0xdd
 [<ffffffff8103f24d>] ? intel_pmu_cpu_starting+0xa8/0x18b
 [<ffffffff8103f24d>] ? intel_pmu_cpu_starting+0xa8/0x18b
 [<ffffffff8104669c>] ? generic_set_all+0x25f/0x294
 [<ffffffff81735d76>] ? x86_pmu_notifier+0x4b/0x52
 [<ffffffff81742e23>] ? notifier_call_chain+0x5e/0x92
 [<ffffffff8108cc55>] ? __raw_notifier_call_chain+0x9/0xb
 [<ffffffff8106e834>] ? __cpu_notify+0x1b/0x2d
 [<ffffffff8106e854>] ? cpu_notify+0xe/0x10
 [<ffffffff81739d43>] ? notify_cpu_starting+0x24/0x26
 [<ffffffff817381b4>] ? start_secondary+0x122/0x193


