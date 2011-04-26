Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab1DZFCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 01:02:15 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34362 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab1DZFCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 01:02:12 -0400
Message-ID: <4DB651C2.3080906@linux.vnet.ibm.com>
Date: Tue, 26 Apr 2011 13:01:54 +0800
From: Cheng Xu <chengxu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: real-time scheduler problem
Content-Type: multipart/mixed;
 boundary="------------010709060702010600020801"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010709060702010600020801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

[1.] PROBLEM: a scheduler bug followed by kernel hang, involving more 
than one real-time thread bound to a CPU that is going offline

[2.] I have an IBM JS22 blade (2 POWER-6 CPUs, 4 cores per CPU), running 
RHEL5.5, with 2.6.39-rc4 kernel. When running multiple real-time threads 
on every logical CPUs, the system will bug when I turns off one CPU, 
say, CPU 4 by issuing command
echo 0 > /sys/devices/system/cpu/cpu4/online

Sometimes, I need to issue a sequence of CPU offline/online commands to 
make the bug show up, like
echo 0 > /sys/devices/system/cpu/cpu4/online
echo 1 > /sys/devices/system/cpu/cpu4/online
echo 0 > /sys/devices/system/cpu/cpu4/online
echo 1 > /sys/devices/system/cpu/cpu4/online

The bug is constantly reproducible in kernel version 2.6.38 and 
2.6.39-rc4. All the log below is based on 2.6.39-rc4 version.

[3.] Keywords: scheduler

[4.] Kernel version:
Linux version 2.6.39-rc4 (chengxu@p6.cn.ibm.com) (gcc version 4.4.0 
20090514 (Red Hat 4.4.0-6) (GCC) ) #1 SMP PREEMPT Mon Apr 25 13:58:04 
EDT 2011

[5.] Output of Oops.. message
------------[ cut here ]------------
kernel BUG at /home/chengxu/linux-2.6.39-rc4/kernel/sched_rt.c:467!
Oops: Exception in kernel mode, sig: 5 [#1]
PREEMPT SMP NR_CPUS=8 NUMA pSeries
last sysfs file: /sys/devices/system/cpu/cpu4/online
Modules linked in:
NIP: c000000000077658 LR: c000000000077654 CTR: c00000000007aa10
REGS: c00000005e58b090 TRAP: 0700   Not tainted  (2.6.39-rc4)
MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 24848882  XER: 00000000
TASK = c0000000645be250[2000] 'bash' THREAD: c00000005e588000 CPU: 2
GPR00: c000000000077654 c00000005e58b310 c00000000101b540 0000000000000002
GPR04: 0000000000000000 1778000000000000 0000000000000000 0000000000000008
GPR08: c0000000645bede0 0000000000000000 0001300000000000 c000000000323814
GPR12: 0000000044848882 c000000001fb0500 00000000100d0000 0000000000000000
GPR16: 0000000000000001 c0000000011c1f80 c000000000f18418 c0000000121e7620
GPR20: 0000000000000008 c0000000121e6f80 c0000000121e7690 ffffffffffffffff
GPR24: c00000005e58b380 c0000000121e7620 c000000063cc2008 c000000001092fe4
GPR28: c0000000011befd8 c0000000121e6f80 c000000000f9afc8 fffffffffa0a1f00
NIP [c000000000077658] .__disable_runtime+0x1e8/0x2b0
LR [c000000000077654] .__disable_runtime+0x1e4/0x2b0
Call Trace:
[c00000005e58b310] [c000000000077654] .__disable_runtime+0x1e4/0x2b0 
(unreliable)
[c00000005e58b400] [c00000000007aa9c] .rq_offline_rt+0x8c/0xc0
[c00000005e58b480] [c00000000006f298] .set_rq_offline+0x68/0xe0
[c00000005e58b510] [c00000000007d098] .rq_attach_root+0x1f8/0x210
[c00000005e58b5b0] [c00000000007df9c] .cpu_attach_domain+0x1ac/0x250
[c00000005e58b680] [c00000000007f514] .partition_sched_domains+0x304/0x3d0
[c00000005e58b770] [c000000000101bec] .cpuset_update_active_cpus+0x7c/0xa0
[c00000005e58b810] [c00000000007d834] .cpuset_cpu_inactive+0x24/0x40
[c00000005e58b880] [c0000000006a0f74] .notifier_call_chain+0xf4/0x190
[c00000005e58b930] [c000000000091948] .__cpu_notify+0x38/0x80
[c00000005e58b9b0] [c000000000157944] ._cpu_down+0x104/0x310
[c00000005e58ba90] [c000000000157b94] .cpu_down+0x44/0x70
[c00000005e58bb20] [c00000000055c868] .store_online+0x78/0x120
[c00000005e58bbc0] [c0000000003d05ac] .sysdev_store+0x3c/0x50
[c00000005e58bc30] [c00000000025a5f0] .sysfs_write_file+0xf0/0x200
[c00000005e58bce0] [c0000000001c9d1c] .vfs_write+0xec/0x1e0
[c00000005e58bd80] [c0000000001c9f38] .SyS_write+0x58/0xd0
[c00000005e58be30] [c00000000000958c] syscall_exit+0x0/0x40
Instruction dump:
60000000 60000000 e8150698 7e639b78 7c1f0050 3be00000 f8150698 4862459d
60000000 7f23cb78 48623751 60000000 <0b1f0000> fafd0698 7f23cb78 4862457d
---[ end trace 0f9ad3cca4aeb68c ]---
note: bash[2000] exited with preempt_count 3
BUG: spinlock lockup on CPU#1, syslogd/2129, c0000000121e6e00
Call Trace:
[c00000005e0732c0] [c000000000014738] .show_stack+0x68/0x1b0 (unreliable)
[c00000005e073370] [c000000000323954] .do_raw_spin_lock+0x1b4/0x1c0
[c00000005e073410] [c00000000069adf4] ._raw_spin_lock+0x54/0x70
[c00000005e0734a0] [c0000000000767cc] .task_rq_lock+0x6c/0xd0
[c00000005e073540] [c00000000008a0e4] .try_to_wake_up+0x74/0x720
[c00000005e073620] [c0000000003afd78] .hvc_kick+0x28/0x40
[c00000005e0736a0] [c0000000003b0358] .hvc_open+0x88/0x1b0
[c00000005e073740] [c00000000038f19c] .tty_open+0x32c/0x680
[c00000005e073840] [c0000000001cf484] .chrdev_open+0x194/0x3f0
[c00000005e073910] [c0000000001c6f50] .__dentry_open+0x220/0x4f0
[c00000005e0739e0] [c0000000001dbe80] .do_last+0x100/0xa50
[c00000005e073ab0] [c0000000001dd95c] .path_openat+0xfc/0x4b0
[c00000005e073bc0] [c0000000001dde48] .do_filp_open+0x48/0xc0
[c00000005e073d00] [c0000000001c6bf8] .do_sys_open+0x138/0x230
[c00000005e073dc0] [c000000000228b44] .compat_sys_open+0x24/0x40
[c00000005e073e30] [c00000000000958c] syscall_exit+0x0/0x40
BUG: spinlock lockup on CPU#5, rtsched/2088, c0000000011befd8
Call Trace:
[c000000065b275e0] [c000000000014738] .show_stack+0x68/0x1b0 (unreliable)
[c000000065b27690] [c000000000323954] .do_raw_spin_lock+0x1b4/0x1c0
[c000000065b27730] [c00000000069adf4] ._raw_spin_lock+0x54/0x70
[c000000065b277c0] [c000000000077338] .balance_runtime+0xf8/0x230
[c000000065b27890] [c00000000007b194] .update_curr_rt+0x1a4/0x260
[c000000065b27940] [c00000000007b274] .task_tick_rt+0x24/0x160
[c000000065b279d0] [c0000000000813b4] .scheduler_tick+0x104/0x500
[c000000065b27a90] [c0000000000a5b44] .update_process_times+0x74/0xa0
[c000000065b27b20] [c0000000000d38e4] .tick_sched_timer+0x84/0x100
[c000000065b27bc0] [c0000000000c4124] .__run_hrtimer+0xc4/0x4b0
[c000000065b27c80] [c0000000000c4858] .hrtimer_interrupt+0x118/0x2a0
[c000000065b27d80] [c00000000001d67c] .timer_interrupt+0x12c/0x410
[c000000065b27e30] [c00000000000371c] decrementer_common+0x11c/0x180
BUG: spinlock lockup on CPU#7, rtsched/2106, c0000000121e6e00
Call Trace:
[c000000065f477f0] [c000000000014738] .show_stack+0x68/0x1b0 (unreliable)
[c000000065f478a0] [c000000000323954] .do_raw_spin_lock+0x1b4/0x1c0
[c000000065f47940] [c00000000069adf4] ._raw_spin_lock+0x54/0x70
[c000000065f479d0] [c000000000081314] .scheduler_tick+0x64/0x500
[c000000065f47a90] [c0000000000a5b44] .update_process_times+0x74/0xa0
[c000000065f47b20] [c0000000000d38e4] .tick_sched_timer+0x84/0x100
[c000000065f47bc0] [c0000000000c4124] .__run_hrtimer+0xc4/0x4b0
[c000000065f47c80] [c0000000000c4858] .hrtimer_interrupt+0x118/0x2a0
[c000000065f47d80] [c00000000001d67c] .timer_interrupt+0x12c/0x410
[c000000065f47e30] [c00000000000371c] decrementer_common+0x11c/0x180
BUG: spinlock lockup on CPU#6, login/1975, c0000000121e6e00
Call Trace:
[c000000063eff1d0] [c000000000014738] .show_stack+0x68/0x1b0 (unreliable)
[c000000063eff280] [c000000000323954] .do_raw_spin_lock+0x1b4/0x1c0
[c000000063eff320] [c00000000069adf4] ._raw_spin_lock+0x54/0x70
[c000000063eff3b0] [c0000000000767cc] .task_rq_lock+0x6c/0xd0
[c000000063eff450] [c00000000008a0e4] .try_to_wake_up+0x74/0x720
[c000000063eff530] [c00000000006efdc] .__wake_up_common+0x8c/0xf0
[c000000063eff5e0] [c0000000000760dc] .__wake_up+0x4c/0x80
[c000000063eff680] [c000000000105598] .audit_log_end+0xb8/0x170
[c000000063eff710] [c000000000106484] .audit_receive+0x494/0xc70
[c000000063eff870] [c0000000005b2b24] .netlink_unicast+0x3f4/0x480
[c000000063eff940] [c0000000005b3908] .netlink_sendmsg+0x288/0x410
[c000000063effa30] [c000000000560a40] .sock_sendmsg+0x100/0x140
[c000000063effc10] [c0000000005612c0] .SyS_sendto+0xf0/0x150
[c000000063effd90] [c0000000005a0b98] .compat_sys_socketcall+0x1f8/0x340
[c000000063effe30] [c00000000000958c] syscall_exit+0x0/0x40
BUG: spinlock lockup on CPU#2, rtsched/2061, c0000000011befd8
Call Trace:
[c000000061f475e0] [c000000000014738] .show_stack+0x68/0x1b0 (unreliable)
[c000000061f47690] [c000000000323954] .do_raw_spin_lock+0x1b4/0x1c0
[c000000061f47730] [c00000000069adf4] ._raw_spin_lock+0x54/0x70
[c000000061f477c0] [c000000000077338] .balance_runtime+0xf8/0x230
[c000000061f47890] [c00000000007b194] .update_curr_rt+0x1a4/0x260
[c000000061f47940] [c00000000007b274] .task_tick_rt+0x24/0x160
[c000000061f479d0] [c0000000000813b4] .scheduler_tick+0x104/0x500
[c000000061f47a90] [c0000000000a5b44] .update_process_times+0x74/0xa0
[c000000061f47b20] [c0000000000d38e4] .tick_sched_timer+0x84/0x100
[c000000061f47bc0] [c0000000000c4124] .__run_hrtimer+0xc4/0x4b0
[c000000061f47c80] [c0000000000c4858] .hrtimer_interrupt+0x118/0x2a0
[c000000061f47d80] [c00000000001d67c] .timer_interrupt+0x12c/0x410
[c000000061f47e30] [c00000000000371c] decrementer_common+0x11c/0x180
BUG: spinlock lockup on CPU#3, rtsched/2064, c0000000011befd8
Call Trace:
[c00000005ed0f5e0] [c000000000014738] .show_stack+0x68/0x1b0 (unreliable)
[c00000005ed0f690] [c000000000323954] .do_raw_spin_lock+0x1b4/0x1c0
[c00000005ed0f730] [c00000000069adf4] ._raw_spin_lock+0x54/0x70
[c00000005ed0f7c0] [c000000000077338] .balance_runtime+0xf8/0x230
[c00000005ed0f890] [c00000000007b194] .update_curr_rt+0x1a4/0x260
[c00000005ed0f940] [c00000000007b274] .task_tick_rt+0x24/0x160
[c00000005ed0f9d0] [c0000000000813b4] .scheduler_tick+0x104/0x500
[c00000005ed0fa90] [c0000000000a5b44] .update_process_times+0x74/0xa0
[c00000005ed0fb20] [c0000000000d38e4] .tick_sched_timer+0x84/0x100
[c00000005ed0fbc0] [c0000000000c4124] .__run_hrtimer+0xc4/0x4b0
[c00000005ed0fc80] [c0000000000c4858] .hrtimer_interrupt+0x118/0x2a0
[c00000005ed0fd80] [c00000000001d67c] .timer_interrupt+0x12c/0x410
[c00000005ed0fe30] [c00000000000371c] decrementer_common+0x11c/0x180
INFO: rcu_preempt_state detected stalls on CPUs/tasks: { 6 7} (detected 
by 4, t=6502 jiffies)
INFO: rcu_preempt_state detected stalls on CPUs/tasks: { 6 7} (detected 
by 0, t=26041 jiffies)
INFO: rcu_preempt_state detected stalls on CPUs/tasks: { 6 7} (detected 
by 4, t=45581 jiffies)

[6.] schell script or example program which triggers the problem:
please see attachment

[7.] Environment

[7.1] Software
# output of scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux p6.cn.ibm.com 2.6.39-rc4 #1 SMP PREEMPT Mon Apr 25 13:58:04 EDT 
2011 ppc64 ppc64 ppc64 GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17.50.0.6
util-linux             2.13-pre7
mount                  2.13-pre7
module-init-tools      3.3-pre2
e2fsprogs              1.39
pcmciautils            014
quota-tools            3.13.
PPP                    2.4.4
isdn4k-utils           3.9
Linux C Library        2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
oprofile               0.9.4
Sh-utils               5.97
udev                   095
Modules Loaded

[7.2] Processor information

processor       : 0
cpu             : POWER6 (raw), altivec supported
clock           : 4005.000000MHz
revision        : 3.1 (pvr 003e 0301)

processor       : 1
cpu             : POWER6 (raw), altivec supported
clock           : 4005.000000MHz
revision        : 3.1 (pvr 003e 0301)

processor       : 2
cpu             : POWER6 (raw), altivec supported
clock           : 4005.000000MHz
revision        : 3.1 (pvr 003e 0301)

processor       : 3
cpu             : POWER6 (raw), altivec supported
clock           : 4005.000000MHz
revision        : 3.1 (pvr 003e 0301)

processor       : 4
cpu             : POWER6 (raw), altivec supported
clock           : 4005.000000MHz
revision        : 3.1 (pvr 003e 0301)

processor       : 5
cpu             : POWER6 (raw), altivec supported
clock           : 4005.000000MHz
revision        : 3.1 (pvr 003e 0301)

processor       : 6
cpu             : POWER6 (raw), altivec supported
clock           : 4005.000000MHz
revision        : 3.1 (pvr 003e 0301)

processor       : 7
cpu             : POWER6 (raw), altivec supported
clock           : 4005.000000MHz
revision        : 3.1 (pvr 003e 0301)

timebase        : 512000000
platform        : pSeries
model           : IBM,7998-61X
machine         : CHRP IBM,7998-61X

[7.3.] Module information
EMPTY

[7.4.] Loaded driver and hardware information
/proc/ioports
00100000-0010ffff : /pci@800000020000200
00220000-0022ffff : /pci@800000020000201
00340000-0034ffff : /pci@800000020000202
   0034fc00-0034fcff : 0002:00:01.0

/proc/iomem
3c0000000000-3c007fffffff : /pci@800000020000200
   3c007efa0000-3c007efbffff : 0000:00:01.0
   3c007efc0000-3c007effffff : 0000:00:01.0
     3c007efc0000-3c007effffff : ipr
   3c007f000000-3c007fffffff : 0000:00:01.0
     3c007f000000-3c007fffffff : ipr
3c0080000000-3c00ffffffff : /pci@800000020000201
   3c00ffffd000-3c00ffffd0ff : 0001:00:01.2
     3c00ffffd000-3c00ffffd0ff : ehci_hcd
   3c00ffffe000-3c00ffffefff : 0001:00:01.0
     3c00ffffe000-3c00ffffefff : ohci_hcd
   3c00fffff000-3c00ffffffff : 0001:00:01.1
     3c00fffff000-3c00ffffffff : ohci_hcd
3c0100000000-3c017fffffff : /pci@800000020000202
   3c0177fd0000-3c0177fdffff : 0002:00:01.0
   3c0177fe0000-3c0177ffffff : 0002:00:01.0
   3c0178000000-3c017fffffff : 0002:00:01.0
     3c0178000000-3c017808c9ff : offb

[7.5.] PCI information
0000:00:01.0 RAID bus controller: IBM Obsidian chipset SCSI controller 
(rev 02)
         Subsystem: IBM PCI-X DDR 3Gb SAS Adapter (572A/572C)
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr+ Stepping- SERR+ FastB2B-
         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 144, Cache Line Size: 128 bytes
         Interrupt: pin A routed to IRQ 289
         BIST result: 00
         Region 0: Memory at 3c007efc0000 (64-bit, non-prefetchable) 
[size=256K]
         Region 2: Memory at 3c007f000000 (64-bit, prefetchable) [size=16M]
         Expansion ROM at 3c007efa0000 [disabled] [size=128K]
         Capabilities: [50] Message Signalled Interrupts: 64bit+ 
Queue=0/0 Enable-
                 Address: 0000000000000000  Data: 0000
         Capabilities: [78] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [80] PCI-X non-bridge device
                 Command: DPERE+ ERO- RBC=4096 OST=2
                 Status: Dev=ff:1f.0 64bit+ 133MHz+ SCD- USC- DC=simple 
DMMRBC=4096 DMOST=2 DMCRS=64 RSCEM- 266MHz+ 533MHz-
         Capabilities: [98] Vital Product Data

0001:00:01.0 USB Controller: NEC Corporation USB (rev 43) (prog-if 10 
[OHCI])
         Subsystem: NEC Corporation Hama USB 2.0 CardBus
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr+ Stepping- SERR+ FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 72 (250ns min, 10500ns max), Cache Line Size: 128 bytes
         Interrupt: pin A routed to IRQ 305
         Region 0: Memory at 3c00ffffe000 (32-bit, non-prefetchable) 
[size=4K]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME+

0001:00:01.1 USB Controller: NEC Corporation USB (rev 43) (prog-if 10 
[OHCI])
         Subsystem: NEC Corporation Hama USB 2.0 CardBus
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr+ Stepping- SERR+ FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 72 (250ns min, 10500ns max), Cache Line Size: 128 bytes
         Interrupt: pin B routed to IRQ 306
         Region 0: Memory at 3c00fffff000 (32-bit, non-prefetchable) 
[size=4K]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME+

0001:00:01.2 USB Controller: NEC Corporation USB 2.0 (rev 04) (prog-if 
20 [EHCI])
         Subsystem: NEC Corporation USB 2.0
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr+ Stepping- SERR+ FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 72 (4000ns min, 8500ns max), Cache Line Size: 128 bytes
         Interrupt: pin C routed to IRQ 307
         Region 0: Memory at 3c00ffffd000 (32-bit, non-prefetchable) 
[size=256]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0002:00:01.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 
02) (prog-if 00 [VGA controller])
         Subsystem: ATI Technologies Inc ES1000
         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping+ SERR+ FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Interrupt: pin A routed to IRQ 321
         Region 0: Memory at 3c0178000000 (32-bit, prefetchable) [size=128M]
         Region 1: I/O ports at ffc00 [size=256]
         Region 2: Memory at 3c0177fd0000 (32-bit, non-prefetchable) 
[size=64K]
         Expansion ROM at 3c0177fe0000 [disabled] [size=128K]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

[7.6.] SCSI information
Attached devices:
Host: scsi0 Channel: 03 Id: 00 Lun: 00
   Vendor: IBM-ESXS Model: ST936701SS       Rev: B51B
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi0 Channel: 08 Id: 00 Lun: 00
   Vendor: IBM      Model: VSBPD1BB   SAS   Rev:   01
   Type:   Enclosure                        ANSI  SCSI revision: 02
Host: scsi0 Channel: 255 Id: 255 Lun: 255
   Vendor: IBM      Model: 572C001SISIOA    Rev: 0150
   Type:   No Device                        ANSI  SCSI revision: 03


--------------010709060702010600020801
Content-Type: text/plain;
 name="dotconfig"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dotconfig"

#
# Automatically generated make config: don't edit
# Linux/powerpc 2.6.39-rc4 Kernel Configuration
# Mon Apr 25 13:35:05 2011
#
CONFIG_PPC64=y

#
# Processor support
#
CONFIG_PPC_BOOK3S_64=y
# CONFIG_PPC_BOOK3E_64 is not set
CONFIG_PPC_BOOK3S=y
CONFIG_POWER4_ONLY=y
CONFIG_POWER4=y
# CONFIG_TUNE_CELL is not set
CONFIG_PPC_FPU=y
CONFIG_ALTIVEC=y
CONFIG_VSX=y
CONFIG_PPC_STD_MMU=y
CONFIG_PPC_STD_MMU_64=y
CONFIG_PPC_MM_SLICES=y
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_PPC_HAVE_PMU_SUPPORT=y
CONFIG_PPC_PERF_CTRS=y
CONFIG_SMP=y
CONFIG_NR_CPUS=8
CONFIG_64BIT=y
CONFIG_WORD_SIZE=64
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_MMU=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NR_IRQS=512
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_LOCKBREAK=y
CONFIG_ARCH_HAS_ILOG2_U32=y
CONFIG_ARCH_HAS_ILOG2_U64=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_BIT_LE=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_NO_VIRT_TO_BUS=y
CONFIG_PPC=y
CONFIG_EARLY_PRINTK=y
CONFIG_COMPAT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_PPC_OF=y
CONFIG_PPC_UDBG_16550=y
# CONFIG_GENERIC_TBSYNC is not set
CONFIG_AUDIT_ARCH=y
CONFIG_GENERIC_BUG=y
# CONFIG_DEFAULT_UIMAGE is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_PPC_DCR_NATIVE is not set
# CONFIG_PPC_DCR_MMIO is not set
# CONFIG_PPC_OF_PLATFORM_PCI is not set
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_FHANDLE is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_SHOW_LEVEL=y
# CONFIG_SPARSE_IRQ is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_TRACE=y
CONFIG_RCU_FANOUT=6
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=19
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED=y
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
CONFIG_MM_OWNER=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
# CONFIG_EMBEDDED is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_PERF_COUNTERS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_SYSCALL_WRAPPERS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y
CONFIG_PPC_MSI_BITMAP=y

#
# Platform support
#
CONFIG_PPC_PSERIES=y
CONFIG_PPC_SPLPAR=y
CONFIG_EEH=y
CONFIG_PSERIES_MSI=y
CONFIG_PSERIES_ENERGY=y
CONFIG_SCANLOG=y
CONFIG_LPARCFG=y
CONFIG_PPC_SMLPAR=y
CONFIG_CMM=y
CONFIG_DTL=y
# CONFIG_PPC_ISERIES is not set
# CONFIG_PPC_PMAC is not set
# CONFIG_PPC_MAPLE is not set
CONFIG_PPC_PASEMI=y

#
# PA Semi PWRficient options
#
CONFIG_PPC_PASEMI_IOMMU=y
# CONFIG_PPC_PASEMI_IOMMU_DMA_FORCE is not set
# CONFIG_PPC_PASEMI_MDIO is not set
# CONFIG_PPC_PS3 is not set
# CONFIG_PPC_CELL is not set
# CONFIG_PPC_CELL_NATIVE is not set
# CONFIG_PPC_IBM_CELL_BLADE is not set
# CONFIG_PPC_CELLEB is not set
# CONFIG_PPC_CELL_QPACE is not set
# CONFIG_PQ2ADS is not set
CONFIG_KVM_GUEST=y
CONFIG_PPC_NATIVE=y
CONFIG_PPC_OF_BOOT_TRAMPOLINE=y
# CONFIG_UDBG_RTAS_CONSOLE is not set
CONFIG_XICS=y
# CONFIG_IPIC is not set
CONFIG_MPIC=y
# CONFIG_MPIC_WEIRD is not set
CONFIG_PPC_I8259=y
# CONFIG_U3_DART is not set
CONFIG_PPC_RTAS=y
CONFIG_RTAS_ERROR_LOGGING=y
CONFIG_PPC_RTAS_DAEMON=y
CONFIG_RTAS_PROC=y
CONFIG_RTAS_FLASH=y
# CONFIG_MMIO_NVRAM is not set
# CONFIG_MPIC_U3_HT_IRQS is not set
CONFIG_MPIC_BROKEN_REGREAD=y
CONFIG_IBMVIO=y
CONFIG_IBMEBUS=y
# CONFIG_PPC_MPC106 is not set
# CONFIG_PPC_970_NAP is not set
# CONFIG_PPC_INDIRECT_IO is not set
# CONFIG_GENERIC_IOMAP is not set
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPU Frequency drivers
#
CONFIG_PPC_PASEMI_CPUFREQ=y
# CONFIG_FSL_ULI1575 is not set
CONFIG_SIMPLE_GPIO=y

#
# Kernel options
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_HUGETLB_PAGE_SIZE_VARIABLE=y
CONFIG_IOMMU_HELPER=y
CONFIG_SWIOTLB=y
CONFIG_HOTPLUG_CPU=y
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_HAS_WALK_MEMORY=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_PHYP_DUMP is not set
CONFIG_IRQ_ALL_CPUS=y
CONFIG_NUMA=y
CONFIG_NODES_SHIFT=8
CONFIG_MAX_ACTIVE_REGIONS=256
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SYS_SUPPORTS_HUGETLBFS=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_PPC_HAS_HASH_64K=y
# CONFIG_PPC_4K_PAGES is not set
CONFIG_PPC_64K_PAGES=y
CONFIG_FORCE_MAX_ZONEORDER=9
CONFIG_PPC_SUBPAGE_PROT=y
CONFIG_SCHED_SMT=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_EXTRA_TARGETS=""
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_SECCOMP is not set
CONFIG_ISA_DMA_API=y

#
# Bus options
#
CONFIG_ZONE_DMA=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
# CONFIG_PPC_INDIRECT_PCI is not set
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_SYSCALL=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_STUB=y
CONFIG_PCI_IOV=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_ELECTRA_CF is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
CONFIG_HOTPLUG_PCI_RPA=y
CONFIG_HOTPLUG_PCI_RPA_DLPAR=y
# CONFIG_HAS_RAPIDIO is not set
# CONFIG_RAPIDIO is not set
CONFIG_RELOCATABLE=y
CONFIG_PAGE_OFFSET=0xc000000000000000
CONFIG_KERNEL_START=0xc000000000000000
CONFIG_PHYSICAL_START=0x00000000
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_IP_MROUTE=y
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_SIT is not set
# CONFIG_IPV6_TUNNEL is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
# CONFIG_IPV6_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
# CONFIG_NF_CONNTRACK is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
# CONFIG_NETFILTER_XT_MARK is not set

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_AUDIT is not set
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
# CONFIG_NETFILTER_XT_TARGET_LED is not set
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_ADDRTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DEVGROUP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_HL is not set
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
# CONFIG_IP_NF_QUEUE is not set
# CONFIG_IP_NF_IPTABLES is not set
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV6 is not set
# CONFIG_IP6_NF_QUEUE is not set
# CONFIG_IP6_NF_IPTABLES is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_INGRESS is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
CONFIG_NET_DROP_MONITOR=y
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
# CONFIG_MTD_DEBUG is not set
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_PARTITIONS=y
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_OF_PARTS=y
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
# CONFIG_MTD_CHAR is not set
# CONFIG_MTD_BLKDEVS is not set
# CONFIG_MTD_BLOCK is not set
# CONFIG_MTD_BLOCK_RO is not set
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set
# CONFIG_MTD_SWAP is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_PCMCIA is not set
# CONFIG_MTD_GPIO_ADDR is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_UBI is not set
CONFIG_DTC=y
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
CONFIG_PROC_DEVICETREE=y
CONFIG_OF_FLATTREE=y
CONFIG_OF_EARLY_FLATTREE=y
CONFIG_OF_DYNAMIC=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_DEVICE=y
CONFIG_OF_GPIO=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_PCI=y
# CONFIG_PARPORT is not set
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_MISC_DEVICES=y
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
CONFIG_SCSI_BNX2_ISCSI=y
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
# CONFIG_MEGARAID_MM is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_IBMVSCSI=y
# CONFIG_SCSI_IBMVFC is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_IPR=y
CONFIG_SCSI_IPR_TRACE=y
CONFIG_SCSI_IPR_DUMP=y
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_PCMCIA_AHA152X is not set
# CONFIG_PCMCIA_FDOMAIN is not set
# CONFIG_PCMCIA_QLOGIC is not set
# CONFIG_PCMCIA_SYM53C500 is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
# CONFIG_SCSI_DH_HP_SW is not set
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARASAN_CF is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
# CONFIG_MD_RAID1 is not set
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_RAID is not set
# CONFIG_DM_LOG_USERSPACE is not set
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_DM_FLAKEY is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
# CONFIG_WINDFARM is not set
CONFIG_NETDEVICES=y
# CONFIG_IFB is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_ARCNET is not set
# CONFIG_MII is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM63XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
# CONFIG_ETHOC is not set
# CONFIG_DNET is not set
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
# CONFIG_TULIP is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
# CONFIG_ULI526X is not set
# CONFIG_PCMCIA_XIRCOM is not set
# CONFIG_HP100 is not set
# CONFIG_IBMVETH is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_KSZ884X_PCI is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
CONFIG_BNX2=y
CONFIG_CNIC=y
# CONFIG_XILINX_LL_TEMAC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_STMMAC_ETH is not set
# CONFIG_PCH_GBE is not set
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_EHEA=y
# CONFIG_ENIC is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGBEVF is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NIU is not set
# CONFIG_PASEMI_MAC is not set
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_BNA is not set
# CONFIG_SFC is not set
# CONFIG_BE2NET is not set
# CONFIG_TR is not set
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_HOSTAP is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_IPHETH is not set
CONFIG_NET_PCMCIA=y
# CONFIG_PCMCIA_3C589 is not set
# CONFIG_PCMCIA_3C574 is not set
# CONFIG_PCMCIA_FMVJ18X is not set
# CONFIG_PCMCIA_PCNET is not set
# CONFIG_PCMCIA_NMCLAN is not set
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_PCMCIA_AXNET is not set
CONFIG_WAN=y
# CONFIG_HDLC is not set
# CONFIG_DLCI is not set

#
# CAIF transport drivers
#
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
# CONFIG_SKFP is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_NET_FC=y
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_VMXNET3 is not set
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
# CONFIG_ISDN_CAPI is not set
# CONFIG_ISDN_DRV_GIGASET is not set
# CONFIG_HYSDN is not set
# CONFIG_MISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_XILINX_XPS_PS2 is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_DEVKMEM is not set
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
# CONFIG_SERIAL_ICOM is not set
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_OF_PLATFORM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_CONSOLE=y
CONFIG_HVC_RTAS=y
# CONFIG_HVC_UDBG is not set
# CONFIG_HVCS is not set
CONFIG_IBM_BSR=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_PASEMI is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
# CONFIG_I2C is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_ARCH_REQUIRE_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set

#
# Memory mapped GPIO expanders:
#
# CONFIG_GPIO_BASIC_MMIO is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_XILINX=y
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_WATCHDOG_RTAS is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_MFD_SUPPORT=y
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_BQ24022 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
# CONFIG_DRM is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_WMT_GE_ROPS is not set
# CONFIG_FB_SVGALIB is not set
CONFIG_FB_MACMODES=y
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_OF=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
# CONFIG_FB_MATROX_I2C is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_UDL is not set
CONFIG_FB_IBM_GXT4500=y
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
# CONFIG_HID_3M_PCT is not set
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
# CONFIG_HID_CANDO is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWII_FF is not set
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MOSART is not set
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=y
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_QUANTA is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_ROCCAT_ARVO is not set
# CONFIG_HID_ROCCAT_KONE is not set
# CONFIG_HID_ROCCAT_KONEPLUS is not set
# CONFIG_HID_ROCCAT_KOVAPLUS is not set
# CONFIG_HID_ROCCAT_PYRA is not set
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
# CONFIG_HID_STANTUM is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_HCD_PPC_OF=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PPC_OF_BE=y
CONFIG_USB_OHCI_HCD_PPC_OF_LE=y
CONFIG_USB_OHCI_HCD_PPC_OF=y
CONFIG_USB_OHCI_HCD_PCI=y
CONFIG_USB_OHCI_BIG_ENDIAN_DESC=y
CONFIG_USB_OHCI_BIG_ENDIAN_MMIO=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set
# CONFIG_USB_UAS is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_NFC_DEVICES is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_GENERIC=y
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_TIMB_DMA is not set
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_STAGING=y
# CONFIG_STAGING_EXCLUDE_BUILD is not set
# CONFIG_DIGIEPCA is not set
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
# CONFIG_COMPUTONE is not set
# CONFIG_ET131X is not set
# CONFIG_USB_IP_COMMON is not set
# CONFIG_ECHO is not set
# CONFIG_BRCM80211 is not set
# CONFIG_COMEDI is not set
# CONFIG_ASUS_OLED is not set
# CONFIG_R8187SE is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTL8192E is not set
# CONFIG_R8712U is not set
# CONFIG_RTS_PSTOR is not set
# CONFIG_TRANZPORT is not set
# CONFIG_POHMELFS is not set
# CONFIG_IDE_PHISON is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_VME_BUS is not set
# CONFIG_DX_SEP is not set
# CONFIG_IIO is not set
# CONFIG_XVMALLOC is not set
# CONFIG_ZRAM is not set
# CONFIG_WLAGS49_H2 is not set
# CONFIG_WLAGS49_H25 is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
CONFIG_MACH_NO_WESTBRIDGE=y
# CONFIG_USB_ENESTORAGE is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set

#
# Altera FPGA firmware download module
#

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
# CONFIG_CEPH_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_UTF8 is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_LAST_BIT=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_NLATTR=y
# CONFIG_AVERAGE is not set

#
# Kernel hacking
#
# CONFIG_PRINTK_TIME is not set
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_DETECTOR_RUNNABLE=y
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_LKDTM is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
CONFIG_BUILD_DOCSRC=y
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_KGDB_TESTS=y
# CONFIG_KGDB_TESTS_ON_BOOT is not set
# CONFIG_KGDB_KDB is not set
# CONFIG_TEST_KSTRTOX is not set
CONFIG_PPC_DISABLE_WERROR=y
CONFIG_PRINT_STACK_DEPTH=64
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HCALL_STATS=y
CONFIG_PPC_EMULATED_STATS=y
# CONFIG_CODE_PATCHING_SELFTEST is not set
# CONFIG_FTR_FIXUP_SELFTEST is not set
CONFIG_MSI_BITMAP_SELFTEST=y
CONFIG_XMON=y
# CONFIG_XMON_DEFAULT is not set
CONFIG_XMON_DISASSEMBLY=y
CONFIG_DEBUGGER=y
# CONFIG_VIRQ_DEBUG is not set
CONFIG_BOOTX_TEXT=y
# CONFIG_PPC_EARLY_DEBUG is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_PATH is not set
CONFIG_LSM_MMAP_MIN_ADDR=65535
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_IMA is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="selinux"
CONFIG_KEYS_COMPAT=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
# CONFIG_PPC_CLOCK is not set
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM_BOOK3S_64 is not set
# CONFIG_VHOST_NET is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set


--------------010709060702010600020801
Content-Type: application/gzip;
 name="rtsched.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="rtsched.tar.gz"

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
--------------010709060702010600020801--

