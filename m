Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759742Ab2DJXvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 19:51:47 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:20140
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755848Ab2DJXvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 19:51:45 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zzbb2dI1432N98dKzz1202hzzz2fh668h839hd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F84C779.4080208@am.sony.com>
Date: Tue, 10 Apr 2012 16:51:21 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.4-rc2-rt1
References: <alpine.LFD.2.02.1204101642050.2542@ionos> <4F84C690.1010509@am.sony.com>
In-Reply-To: <4F84C690.1010509@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/12 16:47, Frank Rowand wrote:
> On 04/10/12 07:46, Thomas Gleixner wrote:
>> Dear RT Folks,
>>
>> I'm pleased to announce the 3.4-rc2-rt1 release.
>>
>> This is a straight forward update of the 3.2 series to 3.4-rc2. It's
>> slightly smaller than the 3.2 series. I hope to stabilize it fast so I
>> can concentrate on shuffling more parts of RT into 3.5.
> 
> 
> Compile on the ARM panda fails because commit 615399c8 removed the defines of:
> 
>   cpu_online_map
>   cpu_possible_map
> 
> These defines are used by posix-timers-thread-posix-cpu-timers-on-rt.patch
> 
> 
> kernel/posix-cpu-timers.c: In function 'posix_cpu_thread_call':
> kernel/posix-cpu-timers.c:1487: error: 'cpu_online_map' undeclared (first use in this function)
> kernel/posix-cpu-timers.c:1487: error: (Each undeclared identifier is reported only once
> kernel/posix-cpu-timers.c:1487: error: for each function it appears in.)
> kernel/posix-cpu-timers.c: In function 'posix_cpu_thread_init':
> kernel/posix-cpu-timers.c:1515: error: 'cpu_possible_map' undeclared (first use in this function)
> 
> 
> This patch is a temporary workaround, putting back two of the defines removed
> by commit 615399c8.

< snip >

After applying this patch, the ARM panda boots, but with a lock warning.

This is for SMP, CONFIG_PREEMPT_RT_FULL.

I have not even read through the warning message yet, but am sharing it
here:


[    0.183959] CPU1: Booted secondary processor
[    0.253540] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.253601] CPU1: Unknown IPI message 0x1
[    0.253723] 
[    0.253723] =========================================================
[    0.253723] [ INFO: possible irq lock inversion dependency detected ]
[    0.253753] 3.4.0-rc2-rt1 #2 Not tainted
[    0.253753] ---------------------------------------------------------
[    0.253753] swapper/0/1 just changed the state of lock:
[    0.253753]  (wakeupgen_lock.lock.wait_lock){+.....}, at: [<c0460670>] rt_spin_lock_slowlock+0x2c/0x284
[    0.253784] but this lock was taken by another, HARDIRQ-safe lock in the past:
[    0.253814]  (&irq_desc_lock_class){-.....}
[    0.253814] 
[    0.253814] and interrupts could create inverse lock ordering between them.
[    0.253814] 
[    0.253814] 
[    0.253814] other info that might help us debug this:
[    0.253814] Chain exists of:
[    0.253845]   &irq_desc_lock_class --> irq_controller_lock --> wakeupgen_lock.lock.wait_lock
[    0.253845] 
[    0.253845]  Possible interrupt unsafe locking scenario:
[    0.253845] 
[    0.253845]        CPU0                    CPU1
[    0.253845]        ----                    ----
[    0.253845]   lock(wakeupgen_lock.lock.wait_lock);
[    0.253875]                                local_irq_disable();
[    0.253875]                                lock(&irq_desc_lock_class);
[    0.253875]                                lock(irq_controller_lock);
[    0.253875]   <Interrupt>
[    0.253875]     lock(&irq_desc_lock_class);
[    0.253906] 
[    0.253906]  *** DEADLOCK ***
[    0.253906] 
[    0.253906] 2 locks held by swapper/0/1:
[    0.253906]  #0:  (cpu_add_remove_lock){+.+.+.}, at: [<c045be90>] cpu_up+0x3c/0x94
[    0.253936]  #1:  (cpu_hotplug.lock){+.+.+.}, at: [<c0041314>] cpu_hotplug_begin+0x24/0x50
[    0.253936] 
[    0.253967] the shortest dependencies between 2nd lock and 1st lock:
[    0.253967]   -> (&irq_desc_lock_class){-.....} ops: 758 {
[    0.253967]      IN-HARDIRQ-W at:
[    0.253997]                                            [<c008e390>] __lock_acquire+0x8a4/0x1cf0
[    0.254028]                                            [<c008f8dc>] lock_acquire+0x100/0x120
[    0.254028]                                            [<c0461280>] _raw_spin_lock+0x3c/0x4c
[    0.254028]                                            [<c00a2414>] handle_fasteoi_irq+0x14/0x144
[    0.254058]                                            [<c009ef88>] generic_handle_irq+0x30/0x4c
[    0.254089]                                            [<c0015080>] handle_IRQ+0x48/0xa8
[    0.254119]                                            [<c0008494>] gic_handle_irq+0x30/0x70
[    0.254119]                                            [<c04617a4>] __irq_svc+0x44/0x7c
[    0.254119]                                            [<c045b070>] calibrate_delay+0x168/0x290
[    0.254150]                                            [<c06198d4>] start_kernel+0x258/0x340
[    0.254180]                                            [<80008044>] 0x80008044
[    0.254180]      INITIAL USE at:
[    0.254180]                                           [<c008df28>] __lock_acquire+0x43c/0x1cf0
[    0.254211]                                           [<c008f8dc>] lock_acquire+0x100/0x120
[    0.254211]                                           [<c046138c>] _raw_spin_lock_irqsave+0x48/0x5c
[    0.254211]                                           [<c009f200>] __irq_get_desc_lock+0x78/0xa4
[    0.254241]                                           [<c00a1f0c>] irq_modify_status+0x20/0xb4
[    0.254241]                                           [<c009f33c>] irq_set_percpu_devid+0x6c/0x88
[    0.254241]                                           [<c0022578>] gic_irq_domain_map+0x58/0x88
[    0.254272]                                           [<c00a455c>] irq_domain_add_legacy+0x104/0x144
[    0.254302]                                           [<c0620f2c>] gic_init_bases+0xb8/0x2bc
[    0.254302]                                           [<c0625c3c>] gic_init_irq+0x5c/0x7c
[    0.254333]                                           [<c061c8b8>] init_IRQ+0x18/0x24
[    0.254333]                                           [<c0619804>] start_kernel+0x188/0x340
[    0.254333]                                           [<80008044>] 0x80008044
[    0.254364]    }
[    0.254364]    ... key      at: [<c0c2bb88>] irq_desc_lock_class+0x0/0x8
[    0.254364]    ... acquired at:
[    0.254364]    [<c008f8dc>] lock_acquire+0x100/0x120
[    0.254394]    [<c0461280>] _raw_spin_lock+0x3c/0x4c
[    0.254394]    [<c00223ac>] gic_unmask_irq+0x18/0x6c
[    0.254394]    [<c00a1ce8>] irq_enable+0x40/0x50
[    0.254425]    [<c00a2908>] irq_startup+0x64/0x68
[    0.254425]    [<c00a0a98>] __setup_irq+0x3e0/0x434
[    0.254425]    [<c00a0e24>] setup_irq+0x44/0x84
[    0.254425]    [<c0623cbc>] omap2_gp_clockevent_init+0x1d0/0x360
[    0.254455]    [<c0623e60>] omap4_timer_init+0x14/0x64
[    0.254455]    [<c061db5c>] time_init+0x24/0x38
[    0.254455]    [<c061981c>] start_kernel+0x1a0/0x340
[    0.254486]    [<80008044>] 0x80008044
[    0.254486] 
[    0.254486]  -> (irq_controller_lock){......} ops: 4 {
[    0.254486]     INITIAL USE at:
[    0.254486]                                         [<c008df28>] __lock_acquire+0x43c/0x1cf0
[    0.254516]                                         [<c008f8dc>] lock_acquire+0x100/0x120
[    0.254516]                                         [<c0461280>] _raw_spin_lock+0x3c/0x4c
[    0.254516]                                         [<c00223ac>] gic_unmask_irq+0x18/0x6c
[    0.254547]                                         [<c00a1ce8>] irq_enable+0x40/0x50
[    0.254547]                                         [<c00a2908>] irq_startup+0x64/0x68
[    0.254547]                                         [<c00a0a98>] __setup_irq+0x3e0/0x434
[    0.254577]                                         [<c00a0e24>] setup_irq+0x44/0x84
[    0.254577]                                         [<c0623cbc>] omap2_gp_clockevent_init+0x1d0/0x360
[    0.254577]                                         [<c0623e60>] omap4_timer_init+0x14/0x64
[    0.254608]                                         [<c061db5c>] time_init+0x24/0x38
[    0.254608]                                         [<c061981c>] start_kernel+0x1a0/0x340
[    0.254608]                                         [<80008044>] 0x80008044
[    0.254638]   }
[    0.254638]   ... key      at: [<c069ed64>] irq_controller_lock+0x14/0x24
[    0.254669]   ... acquired at:
[    0.254669]    [<c008f8dc>] lock_acquire+0x100/0x120
[    0.254669]    [<c0461280>] _raw_spin_lock+0x3c/0x4c
[    0.254669]    [<c0460670>] rt_spin_lock_slowlock+0x2c/0x284
[    0.254699]    [<c04609d8>] rt_spin_lock+0x18/0x40
[    0.254699]    [<c0028948>] wakeupgen_unmask+0x14/0x8c
[    0.254699]    [<c00223c4>] gic_unmask_irq+0x30/0x6c
[    0.254730]    [<c00a1ce8>] irq_enable+0x40/0x50
[    0.254730]    [<c00a2908>] irq_startup+0x64/0x68
[    0.254730]    [<c00a0a98>] __setup_irq+0x3e0/0x434
[    0.254730]    [<c00a0e24>] setup_irq+0x44/0x84
[    0.254760]    [<c0623cbc>] omap2_gp_clockevent_init+0x1d0/0x360
[    0.254760]    [<c0623e60>] omap4_timer_init+0x14/0x64
[    0.254760]    [<c061db5c>] time_init+0x24/0x38
[    0.254791]    [<c061981c>] start_kernel+0x1a0/0x340
[    0.254791]    [<80008044>] 0x80008044
[    0.254791] 
[    0.254791] -> (wakeupgen_lock.lock.wait_lock){+.....} ops: 7 {
[    0.254821]    HARDIRQ-ON-W at:
[    0.254821]                                        [<c008e1fc>] __lock_acquire+0x710/0x1cf0
[    0.254821]                                        [<c008f8dc>] lock_acquire+0x100/0x120
[    0.254821]                                        [<c0461280>] _raw_spin_lock+0x3c/0x4c
[    0.254852]                                        [<c0460670>] rt_spin_lock_slowlock+0x2c/0x284
[    0.254852]                                        [<c04609d8>] rt_spin_lock+0x18/0x40
[    0.254852]                                        [<c00286c4>] wakeupgen_irqmask_all+0x18/0x10c
[    0.254882]                                        [<c045bb20>] irq_cpu_hotplug_notify+0x38/0x3c
[    0.254882]                                        [<c04634a4>] notifier_call_chain+0x4c/0x8c
[    0.254913]                                        [<c045be30>] _cpu_up+0x128/0x14c
[    0.254913]                                        [<c045bed0>] cpu_up+0x7c/0x94
[    0.254913]                                        [<c0632eec>] smp_init+0x88/0xc4
[    0.254943]                                        [<c061927c>] kernel_init+0x68/0x1d0
[    0.254943]                                        [<c0015170>] kernel_thread_exit+0x0/0x8
[    0.254974]    INITIAL USE at:
[    0.254974]                                       [<c008df28>] __lock_acquire+0x43c/0x1cf0
[    0.254974]                                       [<c008f8dc>] lock_acquire+0x100/0x120
[    0.255004]                                       [<c0461280>] _raw_spin_lock+0x3c/0x4c
[    0.255004]                                       [<c0460670>] rt_spin_lock_slowlock+0x2c/0x284
[    0.255004]                                       [<c04609d8>] rt_spin_lock+0x18/0x40
[    0.255035]                                       [<c0028948>] wakeupgen_unmask+0x14/0x8c
[    0.255035]                                       [<c00223c4>] gic_unmask_irq+0x30/0x6c
[    0.255065]                                       [<c00a1ce8>] irq_enable+0x40/0x50
[    0.255065]                                       [<c00a2908>] irq_startup+0x64/0x68
[    0.255065]                                       [<c00a0a98>] __setup_irq+0x3e0/0x434
[    0.255065]                                       [<c00a0e24>] setup_irq+0x44/0x84
[    0.255096]                                       [<c0623cbc>] omap2_gp_clockevent_init+0x1d0/0x360
[    0.255096]                                       [<c0623e60>] omap4_timer_init+0x14/0x64
[    0.255126]                                       [<c061db5c>] time_init+0x24/0x38
[    0.255126]                                       [<c061981c>] start_kernel+0x1a0/0x340
[    0.255126]                                       [<80008044>] 0x80008044
[    0.255126]  }
[    0.255157]  ... key      at: [<c0670114>] wakeupgen_lock+0x14/0x80
[    0.255157]  ... acquired at:
[    0.255187]    [<c008d174>] check_usage_backwards+0xa4/0x104
[    0.255187]    [<c008c144>] mark_lock+0x26c/0x680
[    0.255187]    [<c008e1fc>] __lock_acquire+0x710/0x1cf0
[    0.255187]    [<c008f8dc>] lock_acquire+0x100/0x120
[    0.255218]    [<c0461280>] _raw_spin_lock+0x3c/0x4c
[    0.255218]    [<c0460670>] rt_spin_lock_slowlock+0x2c/0x284
[    0.255218]    [<c04609d8>] rt_spin_lock+0x18/0x40
[    0.255249]    [<c00286c4>] wakeupgen_irqmask_all+0x18/0x10c
[    0.255249]    [<c045bb20>] irq_cpu_hotplug_notify+0x38/0x3c
[    0.255249]    [<c04634a4>] notifier_call_chain+0x4c/0x8c
[    0.255249]    [<c045be30>] _cpu_up+0x128/0x14c
[    0.255279]    [<c045bed0>] cpu_up+0x7c/0x94
[    0.255279]    [<c0632eec>] smp_init+0x88/0xc4
[    0.255279]    [<c061927c>] kernel_init+0x68/0x1d0
[    0.255310]    [<c0015170>] kernel_thread_exit+0x0/0x8
[    0.255310] 
[    0.255310] 
[    0.255310] stack backtrace:
[    0.255340] [<c001b674>] (unwind_backtrace+0x0/0xf0) from [<c008cf4c>] (print_irq_inversion_bug+0x190/0x210)
[    0.255371] [<c008cf4c>] (print_irq_inversion_bug+0x190/0x210) from [<c008d174>] (check_usage_backwards+0xa4/
0x104)
[    0.255371] [<c008d174>] (check_usage_backwards+0xa4/0x104) from [<c008c144>] (mark_lock+0x26c/0x680)
[    0.255401] [<c008c144>] (mark_lock+0x26c/0x680) from [<c008e1fc>] (__lock_acquire+0x710/0x1cf0)
[    0.255401] [<c008e1fc>] (__lock_acquire+0x710/0x1cf0) from [<c008f8dc>] (lock_acquire+0x100/0x120)
[    0.255401] [<c008f8dc>] (lock_acquire+0x100/0x120) from [<c0461280>] (_raw_spin_lock+0x3c/0x4c)
[    0.255432] [<c0461280>] (_raw_spin_lock+0x3c/0x4c) from [<c0460670>] (rt_spin_lock_slowlock+0x2c/0x284)
[    0.255432] [<c0460670>] (rt_spin_lock_slowlock+0x2c/0x284) from [<c04609d8>] (rt_spin_lock+0x18/0x40)
[    0.255462] [<c04609d8>] (rt_spin_lock+0x18/0x40) from [<c00286c4>] (wakeupgen_irqmask_all+0x18/0x10c)
[    0.255462] [<c00286c4>] (wakeupgen_irqmask_all+0x18/0x10c) from [<c045bb20>] (irq_cpu_hotplug_notify+0x38/0x
3c)
[    0.255493] [<c045bb20>] (irq_cpu_hotplug_notify+0x38/0x3c) from [<c04634a4>] (notifier_call_chain+0x4c/0x8c)
[    0.255493] [<c04634a4>] (notifier_call_chain+0x4c/0x8c) from [<c045be30>] (_cpu_up+0x128/0x14c)
[    0.255523] [<c045be30>] (_cpu_up+0x128/0x14c) from [<c045bed0>] (cpu_up+0x7c/0x94)
[    0.255523] [<c045bed0>] (cpu_up+0x7c/0x94) from [<c0632eec>] (smp_init+0x88/0xc4)
[    0.255554] [<c0632eec>] (smp_init+0x88/0xc4) from [<c061927c>] (kernel_init+0x68/0x1d0)
[    0.255554] [<c061927c>] (kernel_init+0x68/0x1d0) from [<c0015170>] (kernel_thread_exit+0x0/0x8)
[    0.255584] Brought up 2 CPUs
[    0.255584] SMP: Total of 2 processors activated (4022.78 BogoMIPS).

