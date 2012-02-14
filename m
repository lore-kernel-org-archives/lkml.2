Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835Ab2BNJtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 04:49:41 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:45085 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759682Ab2BNJti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 04:49:38 -0500
Message-ID: <4F3A2DFB.5000209@linux.vnet.ibm.com>
Date: Tue, 14 Feb 2012 15:18:43 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, mikey@neuling.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, gregkh@linuxfoundation.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-kernel@vger.kernel.org,
        Milton Miller <miltonm@bga.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        arjanvandeven@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: smp: Start up non-boot CPUs asynchronously
References: <20120130205444.22f5e26a@infradead.org> <20120131125232.GD4408@elte.hu>	<20120131054155.371e8307@infradead.org> <20120131143130.GF13676@elte.hu>	<20120131072216.1ce78e50@infradead.org> <20120131161207.GA18357@elte.hu> <20120131082439.575978c0@infradead.org> <4F3A1891.8060001@linux.vnet.ibm.com>
In-Reply-To: <4F3A1891.8060001@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12021409-3864-0000-0000-00000161ED8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2012 01:47 PM, Srivatsa S. Bhat wrote:

> On 01/31/2012 09:54 PM, Arjan van de Ven wrote:
> 
>> From ee65be59057c920042747d46dc174c5a5a56c744 Mon Sep 17 00:00:00 2001
>> From: Arjan van de Ven <arjan@linux.intel.com>
>> Date: Mon, 30 Jan 2012 20:44:51 -0800
>> Subject: [PATCH] smp: Start up non-boot CPUs asynchronously
>>
>> The starting of the "not first" CPUs actually takes a lot of boot time
>> of the kernel... upto "minutes" on some of the bigger SGI boxes.
>> Right now, this is a fully sequential operation with the rest of the kernel
>> boot.
>>
>> This patch turns this bringup of the other cpus into an asynchronous operation.
>> With some other changes (not in this patch) this can save significant kernel
>> boot time (upto 40% on my laptop!!).
>> Basically now CPUs could get brought up in parallel to disk enumeration, graphic
>> mode bringup etc etc etc.
>>
>> Note that the implementation in this patch still waits for all CPUs to
>> be brought up before starting userspace; I would love to remove that
>> restriction over time (technically that is simple), but that becomes
>> then a change in behavior... I'd like to see more discussion on that
>> being a good idea before I write that patch.
>>
>> Second note on version 2 of the patch:
>> This patch does currently not save any boot time, due to a situation
>> where the cpu hotplug lock gets taken for write by the cpu bringup code,
>> which starves out readers of this lock throughout the kernel.
>> Ingo specifically requested this behavior to expose this lock problem.
>>
>> CC: Milton Miller <miltonm@bga.com>
>> CC: Andrew Morton <akpm@linux-foundation.org>
>> CC: Ingo Molnar <mingo@elte.hu>
>>
>> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
>> ---
>>  kernel/smp.c |   21 ++++++++++++++++++++-
>>  1 files changed, 20 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/smp.c b/kernel/smp.c
>> index db197d6..ea48418 100644
>> --- a/kernel/smp.c
>> +++ b/kernel/smp.c
>> @@ -12,6 +12,8 @@
>>  #include <linux/gfp.h>
>>  #include <linux/smp.h>
>>  #include <linux/cpu.h>
>> +#include <linux/async.h>
>> +#include <linux/delay.h>
>>
>>  #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
>>  static struct {
>> @@ -664,17 +666,34 @@ void __init setup_nr_cpu_ids(void)
>>  	nr_cpu_ids = find_last_bit(cpumask_bits(cpu_possible_mask),NR_CPUS) + 1;
>>  }
>>
>> +void __init async_cpu_up(void *data, async_cookie_t cookie)
>> +{
>> +	unsigned long nr = (unsigned long) data;
>> +	/*
>> +	 * we can only up one cpu at a time, as enforced by the hotplug
>> +	 * lock; it's better to wait for all earlier CPUs to be done before
>> +	 * we bring up ours, so that the bring up order is predictable.
>> +	 */
>> +	async_synchronize_cookie(cookie);
>> +	cpu_up(nr);
>> +}
>> +
>>  /* Called by boot processor to activate the rest. */
>>  void __init smp_init(void)
>>  {
>>  	unsigned int cpu;
>>
>>  	/* FIXME: This should be done in userspace --RR */
>> +
>> +	/*
>> +	 * But until we do this in userspace, we're going to do this
>> +	 * in parallel to the rest of the kernel boot up.-- Arjan
>> +	 */
>>  	for_each_present_cpu(cpu) {
>>  		if (num_online_cpus() >= setup_max_cpus)
>>  			break;
>>  		if (!cpu_online(cpu))
>> -			cpu_up(cpu);
>> +			async_schedule(async_cpu_up, (void *) cpu);
>>  	}
>>
>>  	/* Any cleanup work */
> 
> 
> If I understand correctly, with this patch, the booting of non-boot CPUs
> will happen in parallel with the rest of the kernel boot, but bringing up
> of individual CPU is still serialized (due to hotplug lock).
> 
> If that is correct, I see several issues with this patch:
> 
> 1. In smp_init(), after the comment "Any cleanup work" (see above), we print:
> printk(KERN_INFO "Brought up %ld CPUs\n", (long)num_online_cpus());
> So this can potentially print less than expected number of CPUs and might
> surprise users.
> 
> 2. Just below that we have smp_cpus_done(setup_max_cpus); and this translates
> to native_smp_cpus_done() under x86, which calls impress_friends().
> And that means, the bogosum calculation and the total activated processor
> count which is printed, may get messed up.
> 
> 3. sched_init_smp() is called immediately after smp_init(). And that calls
> init_sched_domains(cpu_active_mask). Of course, it registers a hotplug
> notifier callback to handle hot-added cpus.. but with this patch, boot up can
> actually become unnecessarily slow at this point - what could have been done
> in one go with an appropriately filled up cpu_active_mask, needs to be done
> again and again using notifier callbacks. IOW, building sched domains can
> potentially become a bottleneck, especially if there are lots and lots of
> cpus in the machine.
> 
> 4. There is an unhandled race condition (tiny window) in sched_init_smp():
> 
> get_online_cpus();
> ...
> init_sched_domains(cpu_active_mask);
> ...
> put_online_cpus();
>                                            <<<<<<<<<<<<<<<<<<<<<<<< There!
> 
> hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
> hotcpu_notifier(cpuset_cpu_inactive, CPU_PRI_CPUSET_INACTIVE);
> 
> At the point shown above, some non-boot cpus can get booted up, without
> being noticed by the scheduler.
> 
> 5. And in powerpc, it creates a new race condition, as explained in
> https://lkml.org/lkml/2012/2/13/383
> (Of course, we can fix it trivially by using get/put_online_cpus().)
> 


Actually, this one is trickier than that, to get it perfectly right.
[see point 8 below].

6. I also observed that in powerpc, a distinction is made implicitly between
a cpu booting for the first time vs a soft CPU online event. That is, for
freshly booted cpus, the following 3 functions are called:
(Refer arch/powerpc/kernel/sysfs.c: topology_init)

	register_cpu(c, cpu);
	device_create_file(&c->dev, &dev_attr_physical_id);
	register_cpu_online(cpu);

However, for a soft CPU Online event, only the last function is called.
(And that looks correct because it matches properly with what is done
upon CPU offline - only unregister_cpu_online() is called).

IOW, with this patch it becomes necessary to carefully examine all code
with such implicit assumptions and modify them to handle the async boot up
properly.

7. And whichever code between smp_init() and async_synchronize_full() didn't
care about CPU hotplug till today but depended on all cpus being online must
suddenly start worrying about CPU Hotplug. They must register a cpu notifier
and handle callbacks etc etc.. Or if they are not worth that complexity, they
should atleast be redesigned or moved around - like the print statements that
tell how many cpus came up, for example.

8. And we should provide a way in which a piece of code can easily "catch" all
CPU_ONLINE/UP_PREPARE events without missing any of them due to race
conditions. Of course register_cpu_notifier() and friends are provided for
that purpose, but they can't be used as it is in this boot up code..
And calling register_cpu_notifier() within get/put_online_cpus() would be a
disaster since that could lead to ABBA deadlock between cpu_add_remove_lock
and cpu_hotplug.lock

> There could be many more things that this patch breaks.. I haven't checked
> thoroughly.
> 

Regards,
Srivatsa S. Bhat

