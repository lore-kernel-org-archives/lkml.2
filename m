Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab0KNAUJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 19:20:09 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:32457 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab0KNAUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 19:20:03 -0500
Message-ID: <4CDF2AF3.20902@kernel.org>
Date: Sat, 13 Nov 2010 16:18:59 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Nikanth Karthikesan <knikanth@suse.de>,
        David Rientjes <rientjes@google.com>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [BUG 2.6.27-rc1] find_busiest_group() LOCKUP
References: <20101111100628.GA24728@localhost> <1289478978.2084.74.camel@laptop> <20101111124015.GA9706@localhost> <1289480656.2084.80.camel@laptop> <20101113084018.GA23098@localhost> <1289644224.2084.521.camel@laptop> <20101113120030.GA31517@localhost> <1289653078.2084.675.camel@laptop> <20101113131042.GA5522@localhost> <4CDEE314.6090107@kernel.org> <20101113235746.GA9458@localhost>
In-Reply-To: <20101113235746.GA9458@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2010 03:57 PM, Wu Fengguang wrote:
> On Sun, Nov 14, 2010 at 03:12:20AM +0800, Yinghai Lu wrote:
>> On 11/13/2010 05:10 AM, Wu Fengguang wrote:
>>> On Sat, Nov 13, 2010 at 08:57:58PM +0800, Peter Zijlstra wrote:
>>>> On Sat, 2010-11-13 at 20:00 +0800, Wu Fengguang wrote:
>>>>> On Sat, Nov 13, 2010 at 06:30:24PM +0800, Peter Zijlstra wrote:
>>>>>> On Sat, 2010-11-13 at 16:40 +0800, Wu Fengguang wrote:
>>>>>>>> Will try and figure out how the heck that's happening, Ingo any clue?
>>>>>>>
>>>>>>> It's back to normal on 2.6.37-rc1 when reverting commit 50f2d7f682f9
>>>>>>> ("x86, numa: Assign CPUs to nodes in round-robin manner on fake NUMA").
>>>>>>>
>>>>>>> The interesting part is, the commit was introduced in 
>>>>>>> 2.6.36-rc7..2.6.36, however 2.6.36 boots OK, while 2.6.37-rc1 panics.
>>>>>>
>>>>>> Argh, that commit again..
>>>>>>
>>>>>> Does this fix it: http://lkml.org/lkml/2010/11/12/8
>>>>>
>>>>> No it still panics. Here is the dmesg.
>>>>
>>>> OK, I'll let Nikanth have a look, if all else fails we can always
>>>> revert that patch.
>>>
>>> It's the same bug.
>>>
>>> Just tried another machine, I get the same divide error.  The patch
>>> posted in lkml/2010/11/12/8 does not fix it. But after reverting
>>> commit 50f2d7f682f9, it boots OK.
>>>
>>> Thanks,
>>> Fengguang
>>> ---
>>> PS. dmesg with divide error
>>>
>>> [    0.000000] console [ttyS0] enabled, bootconsole disabled
>>> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
>>> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
>>> [    0.000000] ... MAX_LOCK_DEPTH:          48
>>> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
>>> [    0.000000] ... CLASSHASH_SIZE:          4096
>>> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
>>> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
>>> [    0.000000] ... CHAINHASH_SIZE:          16384
>>> [    0.000000]  memory used by lock dependency info: 6367 kB
>>> [    0.000000]  per task-struct memory footprint: 2688 bytes
>>> [    0.000000] allocated 167772160 bytes of page_cgroup
>>> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
>>> [    0.000000] ODEBUG: 15 of 15 active objects replaced
>>> [    0.000000] hpet clockevent registered
>>> [    0.001000] Fast TSC calibration using PIT
>>> [    0.002000] Detected 2800.469 MHz processor.
>>> [    0.000010] Calibrating delay loop (skipped), value calculated using timer frequency.. 5600.93 BogoMIPS (lpj=2800469)
>>> [    0.010818] pid_max: default: 32768 minimum: 301
>>> [    0.021745] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
>>> [    0.035657] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
>>> [    0.044553] Mount-cache hash table entries: 256
>>> [    0.049469] Initializing cgroup subsys debug
>>> [    0.053834] Initializing cgroup subsys ns
>>> [    0.057940] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
>>> [    0.066968] Initializing cgroup subsys cpuacct
>>> [    0.071511] Initializing cgroup subsys memory
>>> [    0.075988] Initializing cgroup subsys devices
>>> [    0.080527] Initializing cgroup subsys freezer
>>> [    0.085107] CPU: Physical Processor ID: 0
>>> [    0.089209] CPU: Processor Core ID: 0
>>> [    0.092974] mce: CPU supports 9 MCE banks
>>> [    0.097095] CPU0: Thermal monitoring enabled (TM1)
>>> [    0.101990] using mwait in idle threads.
>>> [    0.106006] Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
>>> [    0.113535] ... version:                3
>>> [    0.117641] ... bit width:              48
>>> [    0.121828] ... generic registers:      4
>>> [    0.125926] ... value mask:             0000ffffffffffff
>>> [    0.131328] ... max period:             000000007fffffff
>>> [    0.136734] ... fixed-purpose events:   3
>>> [    0.140839] ... event mask:             000000070000000f
>>> [    0.147297] ACPI: Core revision 20101013
>>> [    0.175646] ftrace: allocating 24175 entries in 95 pages
>>> [    0.190912] Setting APIC routing to flat
>>> [    0.195562] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>>> [    0.211643] CPU0: Intel(R) Xeon(R) CPU           X5660  @ 2.80GHz stepping 01
>>> [    0.325243] lockdep: fixing up alternatives.
>>> [    0.330242] Booting Node   0, Processors  #1lockdep: fixing up alternatives.
>>> [    0.430140]  #2lockdep: fixing up alternatives.
>>> [    0.526962]  #3lockdep: fixing up alternatives.
>>> [    0.623755]  #4lockdep: fixing up alternatives.
>>> [    0.720588]  Ok.
>>> [    0.722525] Booting Node   1, Processors  #5lockdep: fixing up alternatives.
>>> [    0.822389]  Ok.
>>> [    0.824327] Booting Node   0, Processors  #6
>>> [    0.919089] TSC synchronization [CPU#0 -> CPU#6]:
>>> [    0.924155] Measured 296 cycles TSC warp between CPUs, turning off TSC clock.
>>> [    0.003999] Marking TSC unstable due to check_tsc_sync_source failed
>>> [    0.557048] lockdep: fixing up alternatives.
>>> [    0.558041]  Ok.
>>> [    0.559004] Booting Node   1, Processors  #7 Ok.
>>> [    0.632157] Brought up 8 CPUs
>>> [    0.633006] Total of 8 processors activated (44799.46 BogoMIPS).
>>
>> assume that when you have 
>> CONFIG_NR_CPUS=16
>> instead of
>> CONFIG_NR_CPUS=8
>>
>> it will boot ok?
> 
> No. But it boots OK with CONFIG_NR_CPUS=64: it actually has 24 CPUs, a bit more
> than your expectation :)
> 
> This also boots the other 16 CPU box that used to lockup in find_busiest_group().

please check attached patch, it should fix the problem.

Thanks

	Yinghai

[PATCH] x86, acpi: Handle all SRAT cpu entries even have cpu num limitaion

Recent Intel new system have different order in MADT, aka will list all thread0
at first, then all thread1.
But SRAT table still old order, it will list cpus in one socket all together.

If the user have compiled limited NR_CPUS or boot with nr_cpus=, could have missed
to put some cpus apic id to node mapping into apicid_to_node[].

for example for 4 sockets system with 64 cpus with nr_cpus=32 will get crash...

[    9.106288] Total of 32 processors activated (136190.88 BogoMIPS).
[    9.235021] divide error: 0000 [#1] SMP 
[    9.235315] last sysfs file: 
[    9.235481] CPU 1 
[    9.235592] Modules linked in:
[    9.245398] 
[    9.245478] Pid: 2, comm: kthreadd Not tainted 2.6.37-rc1-tip-yh-01782-ge92ef79-dirty #274      /Sun Fire x4800
[    9.265415] RIP: 0010:[<ffffffff81075a8f>]  [<ffffffff81075a8f>] select_task_rq_fair+0x4f0/0x623
[    9.265835] RSP: 0000:ffff88103f8d1c40  EFLAGS: 00010046
[    9.285550] RAX: 0000000000000000 RBX: ffff88103f887de0 RCX: 0000000000000000
[    9.305356] RDX: 0000000000000000 RSI: 0000000000000200 RDI: 0000000000000200
[    9.305711] RBP: ffff88103f8d1d10 R08: 0000000000000200 R09: ffff88103f887e38
[    9.325709] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
[    9.326038] R13: ffff88107e80dfb0 R14: 0000000000000001 R15: ffff88103f887e40
[    9.345655] FS:  0000000000000000(0000) GS:ffff88107e800000(0000) knlGS:0000000000000000
[    9.365503] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    9.365776] CR2: 0000000000000000 CR3: 0000000002417000 CR4: 00000000000006e0
[    9.385583] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    9.405368] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    9.405713] Process kthreadd (pid: 2, threadinfo ffff88103f8d0000, task ffff88305c8aa2d0)
[    9.425563] Stack:
[    9.425668]  ffff88103f8d1cb0 0000000000000046 0000000000000000 0000000200000000
[    9.445509]  0000000000000000 0000000100000000 0000000000000046 ffffffff82bd1ce0
[    9.465350]  000000015c8aa2d0 00000000001d2540 00000000001d2540 0000007d3f8d1d28
[    9.465763] Call Trace:
[    9.465875]  [<ffffffff810747c3>] wake_up_new_task+0x3c/0x10e
[    9.485486]  [<ffffffff8107b2e3>] do_fork+0x28c/0x35f
[    9.485753]  [<ffffffff810ab832>] ? __lock_acquire+0x1801/0x1813
[    9.505474]  [<ffffffff8106f2bd>] ? finish_task_switch+0x80/0xf4
[    9.525264]  [<ffffffff8106f286>] ? finish_task_switch+0x49/0xf4
[    9.525575]  [<ffffffff8109da72>] ? local_clock+0x2b/0x3c
[    9.545281]  [<ffffffff8103da76>] kernel_thread+0x70/0x72
[    9.545544]  [<ffffffff81097c83>] ? kthread+0x0/0xa8
[    9.545797]  [<ffffffff81037990>] ? kernel_thread_helper+0x0/0x10
[    9.565519]  [<ffffffff81098099>] kthreadd+0xe8/0x12b
[    9.585185]  [<ffffffff81037994>] kernel_thread_helper+0x4/0x10
[    9.585485]  [<ffffffff81cd793c>] ? restore_args+0x0/0x30
[    9.605192]  [<ffffffff81097fb1>] ? kthreadd+0x0/0x12b
[    9.605479]  [<ffffffff81037990>] ? kernel_thread_helper+0x0/0x10
[    9.625295] Code: a0 be 00 02 00 00 ff c2 48 63 d2 e8 f8 67 3b 00 3b 05 86 8e 52 01 48 89 c7 89 45 c8 7c c1 48 8b 45 b0 8b 4b 08 31 d2 48 c1 e0 0a <48> f7 f1 45 85 e4 75 08 48 3b 45 b8 72 08 eb 0d 48 89 45 a8 eb 
[    9.645938] RIP  [<ffffffff81075a8f>] select_task_rq_fair+0x4f0/0x623
[    9.665356]  RSP <ffff88103f8d1c40>
[    9.665568] ---[ end trace 2296156d35fdfc87 ]---

So let just parse all cpu entries in SRAT.

Also add apicid checking with MAX_LOCAL_APIC, in case We could out of boundaries of
apicid_to_node[].

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/acpi/boot.c |    7 +++++++
 arch/x86/mm/srat_64.c       |    8 ++++++++
 drivers/acpi/numa.c         |   14 ++++++++++++--
 3 files changed, 27 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -198,6 +198,13 @@ static void __cpuinit acpi_register_lapi
 {
 	unsigned int ver = 0;
 
+#ifdef CONFIG_X86_64
+	if (id >= (MAX_APICS-1)) {
+		printk(KERN_INFO PREFIX "skipped apicid that is too big\n");
+		return;
+	}
+#endif
+
 	if (!enabled) {
 		++disabled_cpus;
 		return;
Index: linux-2.6/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_64.c
+++ linux-2.6/arch/x86/mm/srat_64.c
@@ -134,6 +134,10 @@ acpi_numa_x2apic_affinity_init(struct ac
 	}
 
 	apic_id = pa->apic_id;
+	if (apic_id >= MAX_LOCAL_APIC) {
+		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u skipped that apicid too big\n", pxm, apic_id, node);
+		return;
+	}
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
@@ -168,6 +172,10 @@ acpi_numa_processor_affinity_init(struct
 		apic_id = (pa->apic_id << 8) | pa->local_sapic_eid;
 	else
 		apic_id = pa->apic_id;
+	if (apic_id >= MAX_LOCAL_APIC) {
+		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
+		return;
+	}
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
Index: linux-2.6/drivers/acpi/numa.c
===================================================================
--- linux-2.6.orig/drivers/acpi/numa.c
+++ linux-2.6/drivers/acpi/numa.c
@@ -275,13 +275,23 @@ acpi_table_parse_srat(enum acpi_srat_typ
 int __init acpi_numa_init(void)
 {
 	int ret = 0;
+	int nr_cpu_entries = nr_cpu_ids;
+
+#ifdef CONFIG_X86_64
+	/*
+	 * Should not limit number with cpu num that will handle,
+	 * SRAT cpu entries could have different order with that in MADT.
+	 * So go over all cpu entries in SRAT to get apicid to node mapping.
+	 */
+	nr_cpu_entries = MAX_LOCAL_APIC;
+#endif
 
 	/* SRAT: Static Resource Affinity Table */
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY,
-				     acpi_parse_x2apic_affinity, nr_cpu_ids);
+				     acpi_parse_x2apic_affinity, nr_cpu_entries);
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
-				     acpi_parse_processor_affinity, nr_cpu_ids);
+				     acpi_parse_processor_affinity, nr_cpu_entries);
 		ret = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
 					    acpi_parse_memory_affinity,
 					    NR_NODE_MEMBLKS);
