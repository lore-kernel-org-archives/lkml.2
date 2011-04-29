Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab1D2Xuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 19:50:54 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:55759 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab1D2Xuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 19:50:52 -0400
Message-ID: <4DBB4E85.4040303@linux.vnet.ibm.com>
Date: Sat, 30 Apr 2011 07:49:25 +0800
From: Cheng Xu <chengxu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: real-time scheduler problem
References: <4DB651C2.3080906@linux.vnet.ibm.com>
In-Reply-To: <4DB651C2.3080906@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks this problem starts from kernel version 2.6.38. Version 
2.6.37.6 is good; 2.6.38rc1 and all following versions have this bug.

Still on 2.6.39rc4, if we rollback sched_rc.c to 2.6.37.6, the bugs 
disappear.


On 2011-4-26 13:01, Cheng Xu wrote:
> [1.] PROBLEM: a scheduler bug followed by kernel hang, involving more 
> than one real-time thread bound to a CPU that is going offline
>
> [2.] I have an IBM JS22 blade (2 POWER-6 CPUs, 4 cores per CPU), 
> running RHEL5.5, with 2.6.39-rc4 kernel. When running multiple 
> real-time threads on every logical CPUs, the system will bug when I 
> turns off one CPU, say, CPU 4 by issuing command
> echo 0 > /sys/devices/system/cpu/cpu4/online
>
> Sometimes, I need to issue a sequence of CPU offline/online commands 
> to make the bug show up, like
> echo 0 > /sys/devices/system/cpu/cpu4/online
> echo 1 > /sys/devices/system/cpu/cpu4/online
> echo 0 > /sys/devices/system/cpu/cpu4/online
> echo 1 > /sys/devices/system/cpu/cpu4/online
>
> The bug is constantly reproducible in kernel version 2.6.38 and 
> 2.6.39-rc4. All the log below is based on 2.6.39-rc4 version.
>
> [3.] Keywords: scheduler
>
> [4.] Kernel version:
> Linux version 2.6.39-rc4 (chengxu@p6.cn.ibm.com) (gcc version 4.4.0 
> 20090514 (Red Hat 4.4.0-6) (GCC) ) #1 SMP PREEMPT Mon Apr 25 13:58:04 
> EDT 2011
>
> [5.] Output of Oops.. message
> ------------[ cut here ]------------
> kernel BUG at /home/chengxu/linux-2.6.39-rc4/kernel/sched_rt.c:467!
> Oops: Exception in kernel mode, sig: 5 [#1]
> PREEMPT SMP NR_CPUS=8 NUMA pSeries
> last sysfs file: /sys/devices/system/cpu/cpu4/online
> Modules linked in:
> NIP: c000000000077658 LR: c000000000077654 CTR: c00000000007aa10
> REGS: c00000005e58b090 TRAP: 0700   Not tainted  (2.6.39-rc4)
> MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 24848882  XER: 00000000
> TASK = c0000000645be250[2000] 'bash' THREAD: c00000005e588000 CPU: 2
> GPR00: c000000000077654 c00000005e58b310 c00000000101b540 
> 0000000000000002
> GPR04: 0000000000000000 1778000000000000 0000000000000000 
> 0000000000000008
> GPR08: c0000000645bede0 0000000000000000 0001300000000000 
> c000000000323814
> GPR12: 0000000044848882 c000000001fb0500 00000000100d0000 
> 0000000000000000
> GPR16: 0000000000000001 c0000000011c1f80 c000000000f18418 
> c0000000121e7620
> GPR20: 0000000000000008 c0000000121e6f80 c0000000121e7690 
> ffffffffffffffff
> GPR24: c00000005e58b380 c0000000121e7620 c000000063cc2008 
> c000000001092fe4
> GPR28: c0000000011befd8 c0000000121e6f80 c000000000f9afc8 
> fffffffffa0a1f00
> NIP [c000000000077658] .__disable_runtime+0x1e8/0x2b0
> LR [c000000000077654] .__disable_runtime+0x1e4/0x2b0
> Call Trace:
> [c00000005e58b310] [c000000000077654] .__disable_runtime+0x1e4/0x2b0 
> (unreliable)
> [c00000005e58b400] [c00000000007aa9c] .rq_offline_rt+0x8c/0xc0
> [c00000005e58b480] [c00000000006f298] .set_rq_offline+0x68/0xe0
> [c00000005e58b510] [c00000000007d098] .rq_attach_root+0x1f8/0x210
> [c00000005e58b5b0] [c00000000007df9c] .cpu_attach_domain+0x1ac/0x250
> [c00000005e58b680] [c00000000007f514] 
> .partition_sched_domains+0x304/0x3d0
> [c00000005e58b770] [c000000000101bec] 
> .cpuset_update_active_cpus+0x7c/0xa0
> [c00000005e58b810] [c00000000007d834] .cpuset_cpu_inactive+0x24/0x40
> [c00000005e58b880] [c0000000006a0f74] .notifier_call_chain+0xf4/0x190
> [c00000005e58b930] [c000000000091948] .__cpu_notify+0x38/0x80
> [c00000005e58b9b0] [c000000000157944] ._cpu_down+0x104/0x310
> [c00000005e58ba90] [c000000000157b94] .cpu_down+0x44/0x70
> [c00000005e58bb20] [c00000000055c868] .store_online+0x78/0x120
> [c00000005e58bbc0] [c0000000003d05ac] .sysdev_store+0x3c/0x50
> [c00000005e58bc30] [c00000000025a5f0] .sysfs_write_file+0xf0/0x200
> [c00000005e58bce0] [c0000000001c9d1c] .vfs_write+0xec/0x1e0
> [c00000005e58bd80] [c0000000001c9f38] .SyS_write+0x58/0xd0
> [c00000005e58be30] [c00000000000958c] syscall_exit+0x0/0x40
> Instruction dump:
> 60000000 60000000 e8150698 7e639b78 7c1f0050 3be00000 f8150698 4862459d
> 60000000 7f23cb78 48623751 60000000 <0b1f0000> fafd0698 7f23cb78 4862457d
> ---[ end trace 0f9ad3cca4aeb68c ]---
> note: bash[2000] exited with preempt_count 3
> BUG: spinlock lockup on CPU#1, syslogd/2129, c0000000121e6e00
> Call Trace:
> [c00000005e0732c0] [c000000000014738] .show_stack+0x68/0x1b0 (unreliable)
> [c00000005e073370] [c000000000323954] .do_raw_spin_lock+0x1b4/0x1c0
> [c00000005e073410] [c00000000069adf4] ._raw_spin_lock+0x54/0x70
> [c00000005e0734a0] [c0000000000767cc] .task_rq_lock+0x6c/0xd0
> [c00000005e073540] [c00000000008a0e4] .try_to_wake_up+0x74/0x720
> [c00000005e073620] [c0000000003afd78] .hvc_kick+0x28/0x40
> [c00000005e0736a0] [c0000000003b0358] .hvc_open+0x88/0x1b0
> [c00000005e073740] [c00000000038f19c] .tty_open+0x32c/0x680
> [c00000005e073840] [c0000000001cf484] .chrdev_open+0x194/0x3f0
> [c00000005e073910] [c0000000001c6f50] .__dentry_open+0x220/0x4f0
> [c00000005e0739e0] [c0000000001dbe80] .do_last+0x100/0xa50
> [c00000005e073ab0] [c0000000001dd95c] .path_openat+0xfc/0x4b0
> [c00000005e073bc0] [c0000000001dde48] .do_filp_open+0x48/0xc0
> [c00000005e073d00] [c0000000001c6bf8] .do_sys_open+0x138/0x230
> [c00000005e073dc0] [c000000000228b44] .compat_sys_open+0x24/0x40
> [c00000005e073e30] [c00000000000958c] syscall_exit+0x0/0x40
> BUG: spinlock lockup on CPU#5, rtsched/2088, c0000000011befd8
> Call Trace:
> [c000000065b275e0] [c000000000014738] .show_stack+0x68/0x1b0 (unreliable)
> [c000000065b27690] [c000000000323954] .do_raw_spin_lock+0x1b4/0x1c0
> [c000000065b27730] [c00000000069adf4] ._raw_spin_lock+0x54/0x70
> [c000000065b277c0] [c000000000077338] .balance_runtime+0xf8/0x230
> [c000000065b27890] [c00000000007b194] .update_curr_rt+0x1a4/0x260
> [c000000065b27940] [c00000000007b274] .task_tick_rt+0x24/0x160
> [c000000065b279d0] [c0000000000813b4] .scheduler_tick+0x104/0x500
> [c000000065b27a90] [c0000000000a5b44] .update_process_times+0x74/0xa0
> [c000000065b27b20] [c0000000000d38e4] .tick_sched_timer+0x84/0x100
> [c000000065b27bc0] [c0000000000c4124] .__run_hrtimer+0xc4/0x4b0
> [c000000065b27c80] [c0000000000c4858] .hrtimer_interrupt+0x118/0x2a0
> [c000000065b27d80] [c00000000001d67c] .timer_interrupt+0x12c/0x410
> [c000000065b27e30] [c00000000000371c] decrementer_common+0x11c/0x180
> BUG: spinlock lockup on CPU#7, rtsched/2106, c0000000121e6e00
> Call Trace:
> [c000000065f477f0] [c000000000014738] .show_stack+0x68/0x1b0 (unreliable)
> [c000000065f478a0] [c000000000323954] .do_raw_spin_lock+0x1b4/0x1c0
> [c000000065f47940] [c00000000069adf4] ._raw_spin_lock+0x54/0x70
> [c000000065f479d0] [c000000000081314] .scheduler_tick+0x64/0x500
> [c000000065f47a90] [c0000000000a5b44] .update_process_times+0x74/0xa0
> [c000000065f47b20] [c0000000000d38e4] .tick_sched_timer+0x84/0x100
> [c000000065f47bc0] [c0000000000c4124] .__run_hrtimer+0xc4/0x4b0
> [c000000065f47c80] [c0000000000c4858] .hrtimer_interrupt+0x118/0x2a0
> [c000000065f47d80] [c00000000001d67c] .timer_interrupt+0x12c/0x410
> [c000000065f47e30] [c00000000000371c] decrementer_common+0x11c/0x180
> BUG: spinlock lockup on CPU#6, login/1975, c0000000121e6e00
> Call Trace:
> [c000000063eff1d0] [c000000000014738] .show_stack+0x68/0x1b0 (unreliable)
> [c000000063eff280] [c000000000323954] .do_raw_spin_lock+0x1b4/0x1c0
> [c000000063eff320] [c00000000069adf4] ._raw_spin_lock+0x54/0x70
> [c000000063eff3b0] [c0000000000767cc] .task_rq_lock+0x6c/0xd0
> [c000000063eff450] [c00000000008a0e4] .try_to_wake_up+0x74/0x720
> [c000000063eff530] [c00000000006efdc] .__wake_up_common+0x8c/0xf0
> [c000000063eff5e0] [c0000000000760dc] .__wake_up+0x4c/0x80
> [c000000063eff680] [c000000000105598] .audit_log_end+0xb8/0x170
> [c000000063eff710] [c000000000106484] .audit_receive+0x494/0xc70
> [c000000063eff870] [c0000000005b2b24] .netlink_unicast+0x3f4/0x480
> [c000000063eff940] [c0000000005b3908] .netlink_sendmsg+0x288/0x410
> [c000000063effa30] [c000000000560a40] .sock_sendmsg+0x100/0x140
> [c000000063effc10] [c0000000005612c0] .SyS_sendto+0xf0/0x150
> [c000000063effd90] [c0000000005a0b98] .compat_sys_socketcall+0x1f8/0x340
> [c000000063effe30] [c00000000000958c] syscall_exit+0x0/0x40
> BUG: spinlock lockup on CPU#2, rtsched/2061, c0000000011befd8
> Call Trace:
> [c000000061f475e0] [c000000000014738] .show_stack+0x68/0x1b0 (unreliable)
> [c000000061f47690] [c000000000323954] .do_raw_spin_lock+0x1b4/0x1c0
> [c000000061f47730] [c00000000069adf4] ._raw_spin_lock+0x54/0x70
> [c000000061f477c0] [c000000000077338] .balance_runtime+0xf8/0x230
> [c000000061f47890] [c00000000007b194] .update_curr_rt+0x1a4/0x260
> [c000000061f47940] [c00000000007b274] .task_tick_rt+0x24/0x160
> [c000000061f479d0] [c0000000000813b4] .scheduler_tick+0x104/0x500
> [c000000061f47a90] [c0000000000a5b44] .update_process_times+0x74/0xa0
> [c000000061f47b20] [c0000000000d38e4] .tick_sched_timer+0x84/0x100
> [c000000061f47bc0] [c0000000000c4124] .__run_hrtimer+0xc4/0x4b0
> [c000000061f47c80] [c0000000000c4858] .hrtimer_interrupt+0x118/0x2a0
> [c000000061f47d80] [c00000000001d67c] .timer_interrupt+0x12c/0x410
> [c000000061f47e30] [c00000000000371c] decrementer_common+0x11c/0x180
> BUG: spinlock lockup on CPU#3, rtsched/2064, c0000000011befd8
> Call Trace:
> [c00000005ed0f5e0] [c000000000014738] .show_stack+0x68/0x1b0 (unreliable)
> [c00000005ed0f690] [c000000000323954] .do_raw_spin_lock+0x1b4/0x1c0
> [c00000005ed0f730] [c00000000069adf4] ._raw_spin_lock+0x54/0x70
> [c00000005ed0f7c0] [c000000000077338] .balance_runtime+0xf8/0x230
> [c00000005ed0f890] [c00000000007b194] .update_curr_rt+0x1a4/0x260
> [c00000005ed0f940] [c00000000007b274] .task_tick_rt+0x24/0x160
> [c00000005ed0f9d0] [c0000000000813b4] .scheduler_tick+0x104/0x500
> [c00000005ed0fa90] [c0000000000a5b44] .update_process_times+0x74/0xa0
> [c00000005ed0fb20] [c0000000000d38e4] .tick_sched_timer+0x84/0x100
> [c00000005ed0fbc0] [c0000000000c4124] .__run_hrtimer+0xc4/0x4b0
> [c00000005ed0fc80] [c0000000000c4858] .hrtimer_interrupt+0x118/0x2a0
> [c00000005ed0fd80] [c00000000001d67c] .timer_interrupt+0x12c/0x410
> [c00000005ed0fe30] [c00000000000371c] decrementer_common+0x11c/0x180
> INFO: rcu_preempt_state detected stalls on CPUs/tasks: { 6 7} 
> (detected by 4, t=6502 jiffies)
> INFO: rcu_preempt_state detected stalls on CPUs/tasks: { 6 7} 
> (detected by 0, t=26041 jiffies)
> INFO: rcu_preempt_state detected stalls on CPUs/tasks: { 6 7} 
> (detected by 4, t=45581 jiffies)
>
> [6.] schell script or example program which triggers the problem:
> please see attachment
>
> [7.] Environment
>
> [7.1] Software
> # output of scripts/ver_linux
> If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
>
> Linux p6.cn.ibm.com 2.6.39-rc4 #1 SMP PREEMPT Mon Apr 25 13:58:04 EDT 
> 2011 ppc64 ppc64 ppc64 GNU/Linux
>
> Gnu C                  4.1.2
> Gnu make               3.81
> binutils               2.17.50.0.6
> util-linux             2.13-pre7
> mount                  2.13-pre7
> module-init-tools      3.3-pre2
> e2fsprogs              1.39
> pcmciautils            014
> quota-tools            3.13.
> PPP                    2.4.4
> isdn4k-utils           3.9
> Linux C Library        2.5
> Dynamic linker (ldd)   2.5
> Procps                 3.2.7
> Net-tools              1.60
> Kbd                    1.12
> oprofile               0.9.4
> Sh-utils               5.97
> udev                   095
> Modules Loaded
>
> [7.2] Processor information
>
> processor       : 0
> cpu             : POWER6 (raw), altivec supported
> clock           : 4005.000000MHz
> revision        : 3.1 (pvr 003e 0301)
>
> processor       : 1
> cpu             : POWER6 (raw), altivec supported
> clock           : 4005.000000MHz
> revision        : 3.1 (pvr 003e 0301)
>
> processor       : 2
> cpu             : POWER6 (raw), altivec supported
> clock           : 4005.000000MHz
> revision        : 3.1 (pvr 003e 0301)
>
> processor       : 3
> cpu             : POWER6 (raw), altivec supported
> clock           : 4005.000000MHz
> revision        : 3.1 (pvr 003e 0301)
>
> processor       : 4
> cpu             : POWER6 (raw), altivec supported
> clock           : 4005.000000MHz
> revision        : 3.1 (pvr 003e 0301)
>
> processor       : 5
> cpu             : POWER6 (raw), altivec supported
> clock           : 4005.000000MHz
> revision        : 3.1 (pvr 003e 0301)
>
> processor       : 6
> cpu             : POWER6 (raw), altivec supported
> clock           : 4005.000000MHz
> revision        : 3.1 (pvr 003e 0301)
>
> processor       : 7
> cpu             : POWER6 (raw), altivec supported
> clock           : 4005.000000MHz
> revision        : 3.1 (pvr 003e 0301)
>
> timebase        : 512000000
> platform        : pSeries
> model           : IBM,7998-61X
> machine         : CHRP IBM,7998-61X
>
> [7.3.] Module information
> EMPTY
>
> [7.4.] Loaded driver and hardware information
> /proc/ioports
> 00100000-0010ffff : /pci@800000020000200
> 00220000-0022ffff : /pci@800000020000201
> 00340000-0034ffff : /pci@800000020000202
>   0034fc00-0034fcff : 0002:00:01.0
>
> /proc/iomem
> 3c0000000000-3c007fffffff : /pci@800000020000200
>   3c007efa0000-3c007efbffff : 0000:00:01.0
>   3c007efc0000-3c007effffff : 0000:00:01.0
>     3c007efc0000-3c007effffff : ipr
>   3c007f000000-3c007fffffff : 0000:00:01.0
>     3c007f000000-3c007fffffff : ipr
> 3c0080000000-3c00ffffffff : /pci@800000020000201
>   3c00ffffd000-3c00ffffd0ff : 0001:00:01.2
>     3c00ffffd000-3c00ffffd0ff : ehci_hcd
>   3c00ffffe000-3c00ffffefff : 0001:00:01.0
>     3c00ffffe000-3c00ffffefff : ohci_hcd
>   3c00fffff000-3c00ffffffff : 0001:00:01.1
>     3c00fffff000-3c00ffffffff : ohci_hcd
> 3c0100000000-3c017fffffff : /pci@800000020000202
>   3c0177fd0000-3c0177fdffff : 0002:00:01.0
>   3c0177fe0000-3c0177ffffff : 0002:00:01.0
>   3c0178000000-3c017fffffff : 0002:00:01.0
>     3c0178000000-3c017808c9ff : offb
>
> [7.5.] PCI information
> 0000:00:01.0 RAID bus controller: IBM Obsidian chipset SCSI controller 
> (rev 02)
>         Subsystem: IBM PCI-X DDR 3Gb SAS Adapter (572A/572C)
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr+ Stepping- SERR+ FastB2B-
>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 144, Cache Line Size: 128 bytes
>         Interrupt: pin A routed to IRQ 289
>         BIST result: 00
>         Region 0: Memory at 3c007efc0000 (64-bit, non-prefetchable) 
> [size=256K]
>         Region 2: Memory at 3c007f000000 (64-bit, prefetchable) 
> [size=16M]
>         Expansion ROM at 3c007efa0000 [disabled] [size=128K]
>         Capabilities: [50] Message Signalled Interrupts: 64bit+ 
> Queue=0/0 Enable-
>                 Address: 0000000000000000  Data: 0000
>         Capabilities: [78] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [80] PCI-X non-bridge device
>                 Command: DPERE+ ERO- RBC=4096 OST=2
>                 Status: Dev=ff:1f.0 64bit+ 133MHz+ SCD- USC- DC=simple 
> DMMRBC=4096 DMOST=2 DMCRS=64 RSCEM- 266MHz+ 533MHz-
>         Capabilities: [98] Vital Product Data
>
> 0001:00:01.0 USB Controller: NEC Corporation USB (rev 43) (prog-if 10 
> [OHCI])
>         Subsystem: NEC Corporation Hama USB 2.0 CardBus
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr+ Stepping- SERR+ FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium 
> >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 72 (250ns min, 10500ns max), Cache Line Size: 128 bytes
>         Interrupt: pin A routed to IRQ 305
>         Region 0: Memory at 3c00ffffe000 (32-bit, non-prefetchable) 
> [size=4K]
>         Capabilities: [40] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME+
>
> 0001:00:01.1 USB Controller: NEC Corporation USB (rev 43) (prog-if 10 
> [OHCI])
>         Subsystem: NEC Corporation Hama USB 2.0 CardBus
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr+ Stepping- SERR+ FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium 
> >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 72 (250ns min, 10500ns max), Cache Line Size: 128 bytes
>         Interrupt: pin B routed to IRQ 306
>         Region 0: Memory at 3c00fffff000 (32-bit, non-prefetchable) 
> [size=4K]
>         Capabilities: [40] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME+
>
> 0001:00:01.2 USB Controller: NEC Corporation USB 2.0 (rev 04) (prog-if 
> 20 [EHCI])
>         Subsystem: NEC Corporation USB 2.0
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr+ Stepping- SERR+ FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium 
> >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 72 (4000ns min, 8500ns max), Cache Line Size: 128 bytes
>         Interrupt: pin C routed to IRQ 307
>         Region 0: Memory at 3c00ffffd000 (32-bit, non-prefetchable) 
> [size=256]
>         Capabilities: [40] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> 0002:00:01.0 VGA compatible controller: ATI Technologies Inc ES1000 
> (rev 02) (prog-if 00 [VGA controller])
>         Subsystem: ATI Technologies Inc ES1000
>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping+ SERR+ FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
> >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         Interrupt: pin A routed to IRQ 321
>         Region 0: Memory at 3c0178000000 (32-bit, prefetchable) 
> [size=128M]
>         Region 1: I/O ports at ffc00 [size=256]
>         Region 2: Memory at 3c0177fd0000 (32-bit, non-prefetchable) 
> [size=64K]
>         Expansion ROM at 3c0177fe0000 [disabled] [size=128K]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> [7.6.] SCSI information
> Attached devices:
> Host: scsi0 Channel: 03 Id: 00 Lun: 00
>   Vendor: IBM-ESXS Model: ST936701SS       Rev: B51B
>   Type:   Direct-Access                    ANSI  SCSI revision: 05
> Host: scsi0 Channel: 08 Id: 00 Lun: 00
>   Vendor: IBM      Model: VSBPD1BB   SAS   Rev:   01
>   Type:   Enclosure                        ANSI  SCSI revision: 02
> Host: scsi0 Channel: 255 Id: 255 Lun: 255
>   Vendor: IBM      Model: 572C001SISIOA    Rev: 0150
>   Type:   No Device                        ANSI  SCSI revision: 03
>

