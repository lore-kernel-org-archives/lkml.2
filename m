Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab1EFQy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 12:54:27 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:37384 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab1EFQyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 12:54:22 -0400
Date: Fri, 6 May 2011 22:24:12 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org
Subject: [Bug] Kdump does not work when panic triggered due to MCE
Message-ID: <20110506165412.GB2719@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	I wanted to test the behaviour of kdump when panic is triggered
due to MCE on x86 and found that kdump is not captured.

While the kdump service is configured and running and non-MCE panics
(such as those triggered through to /proc/sysrq-trigger) successfully
capture a kdump, any fatal MCE error injected through the mce-inject
tool causes a reboot of the machine.

The code has been traced (using early_serial_putc()) to enter the kexec
path i.e. panic()->crash_kexec()->machine_kexec()->relocate_kernel()
but is untraceable further.

Kdump works fine when the same the similar test is carried out inside a
KVM guest.

Has anybody tested this before? Or have found kdump working when fatal
MCEs have actually occurred?

Thanks,
K.Prasad

Relevant Screen logs
---------------------

login: root
Password: 
Last login: Fri May  6 11:16:52 from 9.77.122.190

# uname -a
Linux elm3a97.beaverton.ibm.com 2.6.39-rc6.prasad_kdump+ #1 SMP Fri May 6 07:47:31 EDT 2011 i686 i686 i386 GNU/Linux
# lsmod | grep mce
mce_inject              2355  0 [permanent]
# service kdump status
Kdump is operational
# mce-inject /home/prasadkr/mce/mce-test/cases/soft-inj/panic_ucr/data/srar_over
Triggering MCE exception on CPU 0
Disabling lock debugging due to kernel taint
[Hardware Error]: CPU 0: Machine Check Exception: 6 Bank 2: f580000000000000
[Hardware Error]: RIP 73:<000000001eadbabe> 
[Hardware Error]: TSC 21dde8717030 ADDR 1234 
[Hardware Error]: PROCESSOR 0:106a5 TIME 1304696989 SOCKET 0 APIC 0
[Hardware Error]: No human readable MCE decoding support on this CPU type.
[Hardware Error]: Run the message through 'mcelog --ascii' to decode.
[Hardware Error]: Machine check: Overflowed uncorrected
Kernel panic - not syncing: Fatal Machine check
Pid: 0, comm: kworker/0:0 Tainted: G   M    W   2.6.39-rc6.prasad_kdump+ #1
------------[ cut here ]------------
kernel BUG at arch/x86/kernel/traps.c:436!
invalid opcode: 0000 [#1] SMP 
last sysfs file: /sys/devices/system/cpu/cpu15/cache/index2/shared_cpu_map
Modules linked in: mce_inject autofs4 cpufreq_ondemand acpi_cpufreq mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log dm_mod cdc_ether usbnet mii microcode sg i2c_i801 serio_raw pcspkr iTCO_wdt iTCO_vendor_support bnx2x libcrc32c mdio ioatdma dca i7core_edac edac_core bnx2 ext4 jbd2 sd_mod crc_t10dif pata_acpi ata_generic ata_piix mptsas mptscsih mptbase scsi_transport_sas [last unloaded: scsi_wait_scan]

Pid: 0, comm: kworker/0:1 Tainted: G   M    W   2.6.39-rc6.prasad_kdump+ #1 IBM IBM System x -[7839AC1]-/46C7890     
EIP: 0060:[<c0860da9>] EFLAGS: 00010006 CPU: 12
EIP is at do_nmi+0x89/0xa0
EAX: e9ba9c9c EBX: e9ba9c9c ECX: 04010000 EDX: e9ba8000
ESI: 0000000c EDI: 00000af0 EBP: e9ba9c94 ESP: e9ba9c90
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process kworker/0:1 (pid: 0, ti=e9ba8000 task=e9ba70d0 task.ti=e9ba8000)
Stack:
 0000000c e9ba9ce8 c0860678 0000000c 00000010 000021dd 0000000c 00000af0
 e9ba9ce8 f0eca855 c0aa007b 0000007b e9ba00d8 c08600e0 f0eca855 c06048fd
 00000060 00000246 f0eca5dd 004b9910 0000000c 0000000c e9ba9cf0 c06048be
Call Trace:
 [<c0860678>] nmi_stack_correct+0x2f/0x34
 [<c08600e0>] ? invalidate_interrupt23+0x3c/0x3c
 [<c06048fd>] ? delay_tsc+0x3d/0x70
 [<c06048be>] __const_udelay+0x1e/0x20
 [<c041c9b5>] wait_for_panic+0x25/0x50
 [<c041cd78>] mce_timed_out+0x48/0x90
 [<c041cf39>] mce_end+0x59/0x100
 [<c041db2b>] do_machine_check+0x3db/0x6a0
 [<c0476600>] ? __hrtimer_start_range_ns+0xa0/0x470
 [<f7e15064>] raise_exception+0x34/0xa0 [mce_inject]
 [<c040f978>] ? sched_clock+0x8/0x10
 [<c0478735>] ? sched_clock_cpu+0x145/0x190
 [<c0489cc0>] ? __lock_acquire+0x2c0/0x490
 [<f7e151a1>] mce_raise_notify+0x61/0x70 [mce_inject]
 [<c0863393>] notifier_call_chain+0x43/0x60
 [<c086340b>] __atomic_notifier_call_chain+0x5b/0x80
 [<c08633b0>] ? notifier_call_chain+0x60/0x60
 [<c086344a>] atomic_notifier_call_chain+0x1a/0x20
 [<c086347d>] notify_die+0x2d/0x30
 [<c0860ac2>] default_do_nmi+0x32/0x290
 [<c048a312>] ? __lock_release+0x72/0x180
 [<c04809ea>] ? clockevents_notify+0x3a/0xf0
 [<c0860da7>] do_nmi+0x87/0xa0
 [<c0860678>] nmi_stack_correct+0x2f/0x34
 [<c048007b>] ? leaps_between+0x3b/0x90
 [<c065521c>] ? intel_idle+0x8c/0x100
 [<c077a32d>] cpuidle_idle_call+0x8d/0x210
 [<c0409b0b>] cpu_idle+0x9b/0xd0
 [<c0858714>] start_secondary+0xdd/0xe3
Code: 5e 2f c2 ff 89 e0 25 00 e0 ff ff 8b 50 14 f7 c2 00 00 00 04 74 1e 81 ea 00 00 01 04 89 50 14 5b 5d c3 89 d8 e8 e9 fc ff ff eb c2 <0f> 0b 90 8d 74 26 00 eb f9 0f 0b eb fe 8d 76 00 8d bc 27 00 00 
EIP: [<c0860da9>] do_nmi+0x89/0xa0 SS:ESP 0068:e9ba9c90
Call Trace:
 [<c085c638>] panic+0x57/0x165
 [<c041cd10>] mce_panic+0x1c0/0x1e0
 [<c041ced0>] mce_reign+0x110/0x120
 [<c041cfca>] mce_end+0xea/0x100
 [<c041db2b>] do_machine_check+0x3db/0x6a0
 [<c0476600>] ? __hrtimer_start_range_ns+0xa0/0x470
 [<f7e15064>] raise_exception+0x34/0xa0 [mce_inject]
 [<c040f978>] ? sched_clock+0x8/0x10
 [<c0478735>] ? sched_clock_cpu+0x145/0x190
 [<c0489cc0>] ? __lock_acquire+0x2c0/0x490
 [<f7e151a1>] mce_raise_notify+0x61/0x70 [mce_inject]
 [<c0863393>] nx30
 [<c0860ac2>] default_do_nmi+0x32/0x290
 [<c048a312>] ? __lock_release+0x72/0x180
 [<c04809ea>] ? clockevents_notify+0x3a/0xf0
 [<c0860da7>] do_nmi+0x87/0xa0
 [<c0860678>] nmi_stack_correct+0x2f/0x34
 [<c048007b>] ? leaps_between+0x3b/0x90
 [<c065521c>] ? intel_idle+0x8c/0x100
 [<c077a32d>] cpuidle_idle_call+0x8d/0x210
 [<c0409b0b>] cpu_idle+0x9b/0xd0
 [<c0858714>] start_secondary+0xdd/0xe3
Rebooting in 1 seconds..

