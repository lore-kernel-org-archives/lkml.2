Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab2JDUHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 16:07:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10565 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab2JDUHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 16:07:34 -0400
X-Authority-Analysis: v=2.0 cv=fb8vOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=T5v1fc8_-g4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=YIIzJC-knJ0A:10 a=HOMt1y6fO105lUbJlDAA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349381251.6755.35.camel@gandalf.local.home>
Subject: Re: [PATCH RT] softirq: Init softirq local lock after per cpu
 section is set up
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: RT <linux-rt-users@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, John Kacur <jkacur@redhat.com>,
        Carsten Emde <cbe@osadl.org>, vomlehn@texas.net
Date: Thu, 04 Oct 2012 16:07:31 -0400
In-Reply-To: <1349362924.6755.18.camel@gandalf.local.home>
References: <1349362924.6755.18.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-04 at 11:02 -0400, Steven Rostedt wrote:

> void __init softirq_early_init(void)
> {
> 	local_irq_lock_init(local_softirq_lock);
> }
> 
> Where:
> 
> #define local_irq_lock_init(lvar)					\
> 	do {								\
> 		int __cpu;						\
> 		for_each_possible_cpu(__cpu)				\
> 			spin_lock_init(&per_cpu(lvar, __cpu).lock);	\
> 	} while (0)
> 
> As the softirq lock is a local_irq_lock, which is a per_cpu lock, the
> initialization is done to all per_cpu versions of the lock. But lets
> look at where the softirq_early_init() is called from.
> 
> In init/main.c: start_kernel()
> 
> /*
>  * Interrupts are still disabled. Do necessary setups, then
>  * enable them
>  */
> 	softirq_early_init();
> 	tick_init();
> 	boot_cpu_init();
> 	page_address_init();
> 	printk(KERN_NOTICE "%s", linux_banner);
> 	setup_arch(&command_line);
> 	mm_init_owner(&init_mm, &init_task);
> 	mm_init_cpumask(&init_mm);
> 	setup_command_line(command_line);
> 	setup_nr_cpu_ids();
> 	setup_per_cpu_areas();
> 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
> 
> One of the first things that is called is the initialization of the
> softirq lock. But if you look further down, we see the per_cpu areas
> have not been set up yet. Thus initializing a local_irq_lock() before
> the per_cpu section is set up, may not work as it is initializing the
> per cpu locks before the per cpu exists.
> 
> By moving the softirq_early_init() right after setup_per_cpu_areas(),
> the kernel boots fine.
> 

I investigated why this still works on x86, and found this. By adding
some printks:

void __init softirq_early_init(void)
{
	int __cpu;
	printk("init softirq locks\n");
	local_irq_lock_init(local_softirq_lock);

	printk("list locks\n");
	for_each_possible_cpu(__cpu)
		printk("local_softirq_lock[%d].node_list=%p\n", __cpu,
		       per_cpu(local_softirq_lock,__cpu).lock.lock.wait_list.node_list.prev);
}

The output was:

Initializing cgroup subsys cpu
init softirq locks
list locks
Linux version 3.2.30-test-rt45+ (rostedt@goliath) (gcc version 4.6.0 (GCC) ) #262 SMP PREEMPT RT Thu Oct 4 15:48:16 EDT 2012
Command line: ro root=/dev/mapper/VG01-F13x64 rd_LVM_LV=VG01/F13x64 rd_NO_LUKS rd_NO_MD rd_NO_DM console=ttyS0,115200 ignore_loglevel selinux=0 earlyprintk=ttyS0,115200 ftrace_dump
_on_oops


Note, it printed "list locks" but never printed anything for that loop.
Seems that before the per_cpu area is initialized, the
for_each_possible_cpu() does not execute. To confirm this, I added that
same loop in spawn_ksoftirq() and it shows this:

... fixed-purpose events:   3
... event mask:             0000000700000003
local_softirq_lock[0].node_list=          (null)
local_softirq_lock[1].node_list=          (null)
local_softirq_lock[2].node_list=          (null)
local_softirq_lock[3].node_list=          (null)
NMI watchdog enabled, takes one hw-pmu counter.
Booting Node   0, Processors  #1
smpboot cpu 1: start_ip = 98000

Yep, the node_list was never initialized.

This doesn't crash x86 because it is saved by:

static inline void init_lists(struct rt_mutex *lock)
{
	if (unlikely(!lock->wait_list.node_list.prev))
		plist_head_init(&lock->wait_list);
}

and the first time something blocks on the lock, the wait_list is
initialized.


The reason that it crashes on powerpc, is because the
for_each_possible_cpu() actually does loop:

(on powerpc box)

Initializing cgroup subsys cpuset^M
Initializing cgroup subsys cpu
init softirq locks
list locks^M
local_softirq_lock[0].node_list=c000000000781f00
local_softirq_lock[1].node_list=c000000000781f00
Linux version 3.2.30-test-rt45-dirty (rostedt@goliath) (gcc version 4.6.0 (GCC) ) #24 SMP PREEMPT RT Thu Oct 4 15:55:07 EDT 2012^M
[0000] : CF000012^M

The problem is that the per_cpu() returns the same pointer for each CPU
passed to it (as you can see, the node_list pointer is the same). As the
node_list was initialized, but to the wrong pointer, the init_lists()
above will not correct the problem as it did with x86. When the
wait_list starts to be used, it will soon become corrupted.

Moving the init to after the per_cpu setup, I get this:

pcpu-alloc: s84096 r0 d46976 u524288 alloc=1*1048576
pcpu-alloc: [0] 0 1 
init softirq locks
list locks
local_softirq_lock[0].node_list=c000000001001f00
local_softirq_lock[1].node_list=c000000001081f00
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 16370

As you can see, the node_lists are now unique per_cpu.

-- Steve


