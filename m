Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab1GMR3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 13:29:06 -0400
Received: from mail.candelatech.com ([208.74.158.172]:39582 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab1GMR3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 13:29:03 -0400
Message-ID: <4E1DD5DF.2040408@candelatech.com>
Date: Wed, 13 Jul 2011 10:29:03 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: BUG spinlock lockup, rtc related, 3.0-rc7+
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is on the same nfs testing machine I've been posting about.  This
has some additional nfs patches included, running tests to mount, do io, unmount
over and over again.  Seems that the NFS bugs might be finally fixed, but
system is still un-stable in general when under load.

This info was printed after several other warnings that I previously posted
to lkml.

This one appears to lock up the machine pretty badly though...can't ssh into
it anymore, and similar messages keep spewing every few minutes.

I *think* the BUG at the end of this email is the important part, but
maybe it's just a symptom of something else...

lockdep has already been disabled due to the issues it finds in
scheduling (already being discussed on LKML in a different thread).


INFO: rcu_preempt_state detected stalls on CPUs/tasks: { 0 4} (detected by 2, t=65002 jiffies)
sending NMI to all CPUs:
NMI backtrace for cpu 4
CPU 4
Modules linked in: 8021q garp xt_addrtype xt_TPROXY nf_tproxy_core xt_socket nf_defrag_ipv6 xt_set ip_set nfnetlink xt_connlimit macvlan ip6table_filter 
ip6_tables ebtable_nat ebtables pktgen fuse iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi stp llc nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipv6 
kvm_intel kvm uinput i5k_amb i5000_edac ioatdma pcspkr iTCO_wdt e1000e dca iTCO_vendor_support edac_core microcode shpchp i2c_i801 floppy radeon ttm 
drm_kms_helper drm hwmon i2c_algo_bit i2c_core [last unloaded: xt_connmark]

Pid: 18179, comm: btserver Tainted: G        W   3.0.0-rc7+ #23 Supermicro X7DBU/X7DBU
RIP: 0010:[<ffffffff8107b4f8>]  [<ffffffff8107b4f8>] lock_acquire+0x107/0x14b
RSP: 0018:ffff8800adaf1c18  EFLAGS: 00000092
RAX: ffff8800a8a61150 RBX: ffff88012fc0e940 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88012fc0e958
RBP: ffff8800adaf1c88 R08: 0000000000000002 R09: 0000000000000001
R10: ffff88010bfebc10 R11: ffff8800adaf1ce8 R12: 0000000000000000
R13: ffffffff8106aed5 R14: 0000000000000002 R15: 0000000000000000
FS:  00007fd787ebb740(0000) GS:ffff88012fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fb80b67f000 CR3: 0000000001a03000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btserver (pid: 18179, threadinfo ffff8800adaf0000, task ffff8800a8a61150)
Stack:
  0000000000000000 ffffffff8106aed5 ffff880000000000 ffffffff8122c805
  ffff8800adaf1c88 0000000000000000 ffff88012fc0e958 0000000000000046
  ffff880124ee6a40 ffff88012fc0e940 0000000000000082 ffff8800adaf1d10
Call Trace:
  [<ffffffff8106aed5>] ? lock_hrtimer_base+0x25/0x4b
  [<ffffffff8122c805>] ? __delay+0xa/0xc
  [<ffffffff8147e7e5>] _raw_spin_lock_irqsave+0x4e/0x60
  [<ffffffff8106aed5>] ? lock_hrtimer_base+0x25/0x4b
  [<ffffffff8106aed5>] lock_hrtimer_base+0x25/0x4b
  [<ffffffff8106af50>] hrtimer_try_to_cancel+0x15/0x46
  [<ffffffff8106af95>] hrtimer_cancel+0x14/0x20
  [<ffffffff81370abf>] rtc_irq_set_state+0x8b/0xaf
  [<ffffffff81371c10>] rtc_dev_release+0x35/0x58
  [<ffffffff8111b07c>] fput+0x117/0x1b2
  [<ffffffff81117b56>] filp_close+0x6d/0x78
  [<ffffffff8104c2f7>] put_files_struct+0xca/0x190
  [<ffffffff8104c403>] exit_files+0x46/0x4e
  [<ffffffff8104deb7>] do_exit+0x2b5/0x760
  [<ffffffff8111b108>] ? fput+0x1a3/0x1b2
  [<ffffffff8122d744>] ? lockdep_sys_exit_thunk+0x35/0x67
  [<ffffffff8104e3e0>] do_group_exit+0x7e/0xa9
  [<ffffffff8104e41d>] sys_exit_group+0x12/0x16
  [<ffffffff81484fd2>] system_call_fastpath+0x16/0x1b
Code: 6c 24 08 49 c1 e9 09 4c 89 24 24 49 83 f1 01 41 83 e1 01 e8 27 ed ff ff 65 48 8b 04 25 00 cd 00 00 c7 80 dc 05 00 00 00 00 00 00
  8b 7d c8 57 9d 66 66 90 66 90 eb 28 65 48 8b 04 25 08 cd 00
Call Trace:
  [<ffffffff8106aed5>] ? lock_hrtimer_base+0x25/0x4b
  [<ffffffff8122c805>] ? __delay+0xa/0xc
  [<ffffffff8147e7e5>] _raw_spin_lock_irqsave+0x4e/0x60
  [<ffffffff8106aed5>] ? lock_hrtimer_base+0x25/0x4b
  [<ffffffff8106aed5>] lock_hrtimer_base+0x25/0x4b
  [<ffffffff8106af50>] hrtimer_try_to_cancel+0x15/0x46
  [<ffffffff8106af95>] hrtimer_cancel+0x14/0x20
  [<ffffffff81370abf>] rtc_irq_set_state+0x8b/0xaf
  [<ffffffff81371c10>] rtc_dev_release+0x35/0x58
  [<ffffffff8111b07c>] fput+0x117/0x1b2
  [<ffffffff81117b56>] filp_close+0x6d/0x78
  [<ffffffff8104c2f7>] put_files_struct+0xca/0x190
  [<ffffffff8104c403>] exit_files+0x46/0x4e
  [<ffffffff8104deb7>] do_exit+0x2b5/0x760
  [<ffffffff8111b108>] ? fput+0x1a3/0x1b2
  [<ffffffff8122d744>] ? lockdep_sys_exit_thunk+0x35/0x67
  [<ffffffff8104e3e0>] do_group_exit+0x7e/0xa9
  [<ffffffff8104e41d>] sys_exit_group+0x12/0x16
  [<ffffffff81484fd2>] system_call_fastpath+0x16/0x1b
NMI backtrace for cpu 0
CPU 0
Modules linked in: 8021q garp xt_addrtype xt_TPROXY nf_tproxy_core xt_socket nf_defrag_ipv6 xt_set ip_set nfnetlink xt_connlimit macvlan ip6table_filter 
ip6_tables ebtable_nat ebtables pktgen fuse iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi stp llc nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipv6 
kvm_intel kvm uinput i5k_amb i5000_edac ioatdma pcspkr iTCO_wdt e1000e dca iTCO_vendor_support edac_core microcode shpchp i2c_i801 floppy radeon ttm 
drm_kms_helper drm hwmon i2c_algo_bit i2c_core [last unloaded: xt_connmark]

Pid: 0, comm: swapper Tainted: G        W   3.0.0-rc7+ #23 Supermicro X7DBU/X7DBU
RIP: 0010:[<ffffffff81481e7b>]  [<ffffffff81481e7b>] do_page_fault+0x374/0x374
RSP: 0018:ffff88012fc03d90  EFLAGS: 00000012
RAX: 0000000000000030 RBX: ffffffff9843ab14 RCX: 000000009843ab44
RDX: 000000000000841f RSI: 0000000000000000 RDI: 0000000000000001
RBP: ffff88012fc03dc8 R08: 0000000000000001 R09: 0000000000000001
R10: ffff88012fc03f88 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000000 R14: ffffffff81a00010 R15: ffffffff9843ab44
FS:  0000000000000000(0000) GS:ffff88012fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003d2a203020 CR3: 0000000001a03000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff81a00000, task ffffffff81a0b020)
Stack:
  ffffffff8122c909 0000000000000002 ffff880124ee6b90 ffffffff81a0b020
  000000007735ab70 ffffffff81a0b398 00000000306c9b30 ffff88012fc03dd8
  ffffffff8122c805 ffff88012fc03e28 ffffffff81231e96 ffff880124ee6ba8
Call Trace:
  <IRQ>
  [<ffffffff8122c909>] ? delay_tsc+0xb7/0xde
  [<ffffffff8122c805>] __delay+0xa/0xc
  [<ffffffff81231e96>] do_raw_spin_lock+0xd2/0x13c
  [<ffffffff8147e7ed>] _raw_spin_lock_irqsave+0x56/0x60
  [<ffffffff81370d51>] ? rtc_handle_legacy_irq+0x5c/0xb3
  [<ffffffff8147ed33>] ? _raw_spin_unlock_irqrestore+0x6b/0x79
  [<ffffffff81370d51>] rtc_handle_legacy_irq+0x5c/0xb3
  [<ffffffff8106a9a0>] hrtimer_interrupt+0xe5/0x1c0
  [<ffffffff810232bc>] smp_apic_timer_interrupt+0x80/0x93
  [<ffffffff81485a13>] apic_timer_interrupt+0x13/0x20
  <EOI>
  [<ffffffff8101165c>] ? mwait_idle+0x86/0xc8
  [<ffffffff81011665>] ? mwait_idle+0x8f/0xc8
  [<ffffffff8101165c>] ? mwait_idle+0x86/0xc8
  [<ffffffff81009e87>] cpu_idle+0x5e/0xb5
  [<ffffffff81465cbc>] rest_init+0xd0/0xd7
  [<ffffffff81465bec>] ? csum_partial_copy_generic+0x16c/0x16c
  [<ffffffff81aa9c76>] start_kernel+0x3bd/0x3c8
  [<ffffffff81aa92cd>] x86_64_start_reservations+0xb8/0xbc
  [<ffffffff81aa93d2>] x86_64_start_kernel+0x101/0x110
Code: ff ff ff e9 23 ff ff ff 48 85 db 48 89 d9 0f 85 70 ff ff ff e9 4e ff ff ff 48 81 c4 d8 00 00 00 5b 41 5c 41 5d 41 5e 41 5f c9 c3
  48 89 e5 53 89 fb 48 83 ec 08 83 3d 77 3b 7c 00 00 75 60 65
Call Trace:
  <IRQ>  [<ffffffff8122c909>] ? delay_tsc+0xb7/0xde
  [<ffffffff8122c805>] __delay+0xa/0xc
  [<ffffffff81231e96>] do_raw_spin_lock+0xd2/0x13c
  [<ffffffff8147e7ed>] _raw_spin_lock_irqsave+0x56/0x60
  [<ffffffff81370d51>] ? rtc_handle_legacy_irq+0x5c/0xb3
  [<ffffffff8147ed33>] ? _raw_spin_unlock_irqrestore+0x6b/0x79
  [<ffffffff81370d51>] rtc_handle_legacy_irq+0x5c/0xb3
  [<ffffffff81370dfa>] rtc_pie_update_irq+0x52/0x5e
  [<ffffffff8106a57c>] __run_hrtimer+0xbe/0x1be
  [<ffffffff81370da8>] ? rtc_handle_legacy_irq+0xb3/0xb3
  [<ffffffff8106a9a0>] hrtimer_interrupt+0xe5/0x1c0
  [<ffffffff810232bc>] smp_apic_timer_interrupt+0x80/0x93
  [<ffffffff81485a13>] apic_timer_interrupt+0x13/0x20
  <EOI>  [<ffffffff8101165c>] ? mwait_idle+0x86/0xc8
  [<ffffffff81011665>] ? mwait_idle+0x8f/0xc8
  [<ffffffff8101165c>] ? mwait_idle+0x86/0xc8
  [<ffffffff81009e87>] cpu_idle+0x5e/0xb5
  [<ffffffff81465cbc>] rest_init+0xd0/0xd7
  [<ffffffff81465bec>] ? csum_partial_copy_generic+0x16c/0x16c
  [<ffffffff81aa9c76>] start_kernel+0x3bd/0x3c8
  [<ffffffff81aa92cd>] x86_64_start_reservations+0xb8/0xbc
  [<ffffffff81aa93d2>] x86_64_start_kernel+0x101/0x110
NMI backtrace for cpu 6
CPU 6
Modules linked in: 8021q garp xt_addrtype xt_TPROXY nf_tproxy_core xt_socket nf_defrag_ipv6 xt_set ip_set nfnetlink xt_connlimit macvlan ip6table_filter 
ip6_tables ebtable_nat ebtables pktgen fuse iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi stp llc nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipv6 
kvm_intel kvm uinput i5k_amb i5000_edac ioatdma pcspkr iTCO_wdt e1000e dca iTCO_vendor_support edac_core microcode shpchp i2c_i801 floppy radeon ttm 
drm_kms_helper drm hwmon i2c_algo_bit i2c_core [last unloaded: xt_connmark]

Pid: 0, comm: kworker/0:1 Tainted: G        W   3.0.0-rc7+ #23 Supermicro X7DBU/X7DBU
RIP: 0010:[<ffffffff81011665>]  [<ffffffff81011665>] mwait_idle+0x8f/0xc8
RSP: 0018:ffff8801288f7f08  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff8801288f6000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffffffff8101165c
RBP: ffff8801288f7f08 R08: 0000000000000000 R09: 0000000000000001
R10: ffff88012fcd2940 R11: 0000000000000000 R12: ffffffff81a8e730
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88012fd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000020cd2a0 CR3: 0000000122956000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/0:1 (pid: 0, threadinfo ffff8801288f6000, task ffff8801288e5690)
Stack:
  ffff8801288f7f28 ffffffff81009e87 ffffffff81a8e740 0000000000000003
  ffff8801288f7f48 ffffffff814780e9 0000000000000000 0000000000000000
  0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
  [<ffffffff81009e87>] cpu_idle+0x5e/0xb5
  [<ffffffff814780e9>] start_secondary+0x1a3/0x1a8
Code: 25 08 cd 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 a8 f4 ff ff 85 c0 75 10 e8 22 7e 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 0c e8 12 7e 06 00 fb 
66 66 90 66 66 90 e8 8c 19 22 00 89 c7
Call Trace:
  [<ffffffff81009e87>] cpu_idle+0x5e/0xb5
  [<ffffffff814780e9>] start_secondary+0x1a3/0x1a8
NMI backtrace for cpu 2
CPU 2
Modules linked in: 8021q garp xt_addrtype xt_TPROXY nf_tproxy_core xt_socket nf_defrag_ipv6 xt_set ip_set nfnetlink xt_connlimit macvlan ip6table_filter 
ip6_tables ebtable_nat ebtables pktgen fuse iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi stp llc nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipv6 
kvm_intel kvm uinput i5k_amb i5000_edac ioatdma pcspkr iTCO_wdt e1000e dca iTCO_vendor_support edac_core microcode shpchp i2c_i801 floppy radeon ttm 
drm_kms_helper drm hwmon i2c_algo_bit i2c_core [last unloaded: xt_connmark]

Pid: 0, comm: kworker/0:1 Tainted: G        W   3.0.0-rc7+ #23 Supermicro X7DBU/X7DBU
RIP: 0010:[<ffffffff8122c86b>]  [<ffffffff8122c86b>] delay_tsc+0x19/0xde
RSP: 0018:ffff88012fc83d78  EFLAGS: 00000096
RAX: 000000003aa2de00 RBX: 0000000000000001 RCX: ffff88012fc83ce8
RDX: 00000000001e8497 RSI: 0000000000000002 RDI: 0000000000000001
RBP: ffff88012fc83da8 R08: ffffffff81c65b9c R09: 0000000000000000
R10: 0000000000000000 R11: ffffffffffffffff R12: 00000000001e8498
R13: ffffffff81a20780 R14: ffffffff81a20d80 R15: 000000000000fdea
FS:  0000000000000000(0000) GS:ffff88012fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003d298732a0 CR3: 0000000123221000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/0:1 (pid: 0, threadinfo ffff88012886e000, task ffff8801288622a0)
Stack:
  ffff88012fc83da8 0000000000000001 ffff88012fc8eec0 ffffffff81a20780
  ffffffff81a20d80 000000000000fdea ffff88012fc83db8 ffffffff8122c82f
  ffff88012fc83dd8 ffffffff8102373b ffff88012fc83db8 ffffffff81a20600
Call Trace:
  <IRQ>
  [<ffffffff8122c82f>] __const_udelay+0x28/0x2a
  [<ffffffff8102373b>] arch_trigger_all_cpu_backtrace+0x61/0x76
  [<ffffffff810a8964>] __rcu_pending+0x2bf/0x402
  [<ffffffff810a8bf8>] rcu_check_callbacks+0x151/0x163
  [<ffffffff81057f5f>] update_process_times+0x3c/0x72
  [<ffffffff81075ccc>] tick_sched_timer+0x6c/0x96
  [<ffffffff8106a57c>] __run_hrtimer+0xbe/0x1be
  [<ffffffff81075c60>] ? tick_nohz_handler+0xde/0xde
  [<ffffffff8106a9a0>] hrtimer_interrupt+0xe5/0x1c0
  [<ffffffff810232bc>] smp_apic_timer_interrupt+0x80/0x93
  [<ffffffff81485a13>] apic_timer_interrupt+0x13/0x20
  <EOI>
  [<ffffffff8101165c>] ? mwait_idle+0x86/0xc8
  [<ffffffff81011665>] ? mwait_idle+0x8f/0xc8
  [<ffffffff8101165c>] ? mwait_idle+0x86/0xc8
  [<ffffffff81009e87>] cpu_idle+0x5e/0xb5
  [<ffffffff814780e9>] start_secondary+0x1a3/0x1a8
Code: ff c9 c3 55 48 8d 3c bf 48 89 e5 e8 b7 ff ff ff c9 c3 55 48 89 e5 41 57 41 56 41 55 41 54 49 89 fc bf 01 00 00 00 53 48 83 ec 08 <e8> b1 56 25 00 e8 8f 67 
00 00 41 89 c5 66 66 90 0f ae e8 e8 a2
Call Trace:
  <IRQ>  [<ffffffff8122c82f>] __const_udelay+0x28/0x2a
  [<ffffffff8102373b>] arch_trigger_all_cpu_backtrace+0x61/0x76
  [<ffffffff810a8964>] __rcu_pending+0x2bf/0x402
  [<ffffffff810a8bf8>] rcu_check_callbacks+0x151/0x163
  [<ffffffff81057f5f>] update_process_times+0x3c/0x72
  [<ffffffff81075ccc>] tick_sched_timer+0x6c/0x96
  [<ffffffff8106a57c>] __run_hrtimer+0xbe/0x1be
  [<ffffffff81075c60>] ? tick_nohz_handler+0xde/0xde
  [<ffffffff8106a9a0>] hrtimer_interrupt+0xe5/0x1c0
  [<ffffffff810232bc>] smp_apic_timer_interrupt+0x80/0x93
  [<ffffffff81485a13>] apic_timer_interrupt+0x13/0x20
  <EOI>  [<ffffffff8101165c>] ? mwait_idle+0x86/0xc8
  [<ffffffff81011665>] ? mwait_idle+0x8f/0xc8
  [<ffffffff8101165c>] ? mwait_idle+0x86/0xc8
  [<ffffffff81009e87>] cpu_idle+0x5e/0xb5
  [<ffffffff814780e9>] start_secondary+0x1a3/0x1a8
NMI backtrace for cpu 7
CPU 7
Modules linked in: 8021q garp xt_addrtype xt_TPROXY nf_tproxy_core xt_socket nf_defrag_ipv6 xt_set ip_set nfnetlink xt_connlimit macvlan ip6table_filter 
ip6_tables ebtable_nat ebtables pktgen fuse iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi stp llc nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipv6 
kvm_intel kvm uinput i5k_amb i5000_edac ioatdma pcspkr iTCO_wdt e1000e dca iTCO_vendor_support edac_core microcode shpchp i2c_i801 floppy radeon ttm 
drm_kms_helper drm hwmon i2c_algo_bit i2c_core [last unloaded: xt_connmark]

Pid: 0, comm: kworker/0:1 Tainted: G        W   3.0.0-rc7+ #23 Supermicro X7DBU/X7DBU
RIP: 0010:[<ffffffff81011665>]  [<ffffffff81011665>] mwait_idle+0x8f/0xc8
RSP: 0018:ffff880128917f08  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff880128916000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffffffff8101165c
RBP: ffff880128917f08 R08: 0000000000000000 R09: 0000000000000001
R10: ffff88012fd92940 R11: 0000000000000000 R12: ffffffff81a8e730
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88012fdc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f6907ad5000 CR3: 00000001258a0000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/0:1 (pid: 0, threadinfo ffff880128916000, task ffff880128904540)
Stack:
  ffff880128917f28 ffffffff81009e87 ffffffff81a8e740 0000000000000007
  ffff880128917f48 ffffffff814780e9 0000000000000000 0000000000000000
  0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
  [<ffffffff81009e87>] cpu_idle+0x5e/0xb5
  [<ffffffff814780e9>] start_secondary+0x1a3/0x1a8
Code: 25 08 cd 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 a8 f4 ff ff 85 c0 75 10 e8 22 7e 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 0c e8 12 7e 06 00 fb 
66 66 90 66 66 90 e8 8c 19 22 00 89 c7
Call Trace:
  [<ffffffff81009e87>] cpu_idle+0x5e/0xb5
  [<ffffffff814780e9>] start_secondary+0x1a3/0x1a8
NMI backtrace for cpu 5
CPU 5
Modules linked in: 8021q garp xt_addrtype xt_TPROXY nf_tproxy_core xt_socket nf_defrag_ipv6 xt_set ip_set nfnetlink xt_connlimit macvlan ip6table_filter 
ip6_tables ebtable_nat ebtables pktgen fuse iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi stp llc nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipv6 
kvm_intel kvm uinput i5k_amb i5000_edac ioatdma pcspkr iTCO_wdt e1000e dca iTCO_vendor_support edac_core microcode shpchp i2c_i801 floppy radeon ttm 
drm_kms_helper drm hwmon i2c_algo_bit i2c_core [last unloaded: xt_connmark]

Pid: 0, comm: kworker/0:1 Tainted: G        W   3.0.0-rc7+ #23 Supermicro X7DBU/X7DBU
RIP: 0010:[<ffffffff81011665>]  [<ffffffff81011665>] mwait_idle+0x8f/0xc8
RSP: 0018:ffff8801288dbf08  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff8801288da000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffffffff8101165c
RBP: ffff8801288dbf08 R08: 0000000000000000 R09: 0000000000000001
R10: ffff88012fd92940 R11: 0000000000000000 R12: ffffffff81a8e730
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88012fd40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000011042a0 CR3: 000000012292e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/0:1 (pid: 0, threadinfo ffff8801288da000, task ffff8801288ae7e0)
Stack:
  ffff8801288dbf28 ffffffff81009e87 ffffffff81a8e740 0000000000000006
  ffff8801288dbf48 ffffffff814780e9 0000000000000000 0000000000000000
  0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
  [<ffffffff81009e87>] cpu_idle+0x5e/0xb5
  [<ffffffff814780e9>] start_secondary+0x1a3/0x1a8
Code: 25 08 cd 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 a8 f4 ff ff 85 c0 75 10 e8 22 7e 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 0c e8 12 7e 06 00 fb 
66 66 90 66 66 90 e8 8c 19 22 00 89 c7
Call Trace:
  [<ffffffff81009e87>] cpu_idle+0x5e/0xb5
  [<ffffffff814780e9>] start_secondary+0x1a3/0x1a8
NMI backtrace for cpu 3
CPU 3
Modules linked in: 8021q garp xt_addrtype xt_TPROXY nf_tproxy_core xt_socket nf_defrag_ipv6 xt_set ip_set nfnetlink xt_connlimit macvlan ip6table_filter 
ip6_tables ebtable_nat ebtables pktgen fuse iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi stp llc nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipv6 
kvm_intel kvm uinput i5k_amb i5000_edac ioatdma pcspkr iTCO_wdt e1000e dca iTCO_vendor_support edac_core microcode shpchp i2c_i801 floppy radeon ttm 
drm_kms_helper drm hwmon i2c_algo_bit i2c_core [last unloaded: xt_connmark]

Pid: 0, comm: kworker/0:1 Tainted: G        W   3.0.0-rc7+ #23 Supermicro X7DBU/X7DBU
RIP: 0010:[<ffffffff81011665>]  [<ffffffff81011665>] mwait_idle+0x8f/0xc8
RSP: 0018:ffff880128887f08  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff880128886000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffffffff8101165c
RBP: ffff880128887f08 R08: 0000000000000000 R09: 0000000000000001
R10: ffff88012fc92940 R11: 0000000000000000 R12: ffffffff81a8e730
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88012fcc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f1e4f355000 CR3: 0000000123162000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/0:1 (pid: 0, threadinfo ffff880128886000, task ffff880128889150)
Stack:
  ffff880128887f28 ffffffff81009e87 ffffffff81a8e740 0000000000000005
  ffff880128887f48 ffffffff814780e9 0000000000000000 0000000000000000
  0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
  [<ffffffff81009e87>] cpu_idle+0x5e/0xb5
  [<ffffffff814780e9>] start_secondary+0x1a3/0x1a8
Code: 25 08 cd 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 a8 f4 ff ff 85 c0 75 10 e8 22 7e 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 0c e8 12 7e 06 00 fb 
66 66 90 66 66 90 e8 8c 19 22 00 89 c7
Call Trace:
  [<ffffffff81009e87>] cpu_idle+0x5e/0xb5
  [<ffffffff814780e9>] start_secondary+0x1a3/0x1a8
NMI backtrace for cpu 1
CPU 1
Modules linked in: 8021q garp xt_addrtype xt_TPROXY nf_tproxy_core xt_socket nf_defrag_ipv6 xt_set ip_set nfnetlink xt_connlimit macvlan ip6table_filter 
ip6_tables ebtable_nat ebtables pktgen fuse iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi stp llc nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipv6 
kvm_intel kvm uinput i5k_amb i5000_edac ioatdma pcspkr iTCO_wdt e1000e dca iTCO_vendor_support edac_core microcode shpchp i2c_i801 floppy radeon ttm 
drm_kms_helper drm hwmon i2c_algo_bit i2c_core [last unloaded: xt_connmark]

Pid: 0, comm: kworker/0:0 Tainted: G        W   3.0.0-rc7+ #23 Supermicro X7DBU/X7DBU
RIP: 0010:[<ffffffff81011665>]  [<ffffffff81011665>] mwait_idle+0x8f/0xc8
RSP: 0018:ffff88012884bf08  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff88012884a000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffffffff8101165c
RBP: ffff88012884bf08 R08: 0000000000000000 R09: 0000000000000001
R10: ffff88012fc92940 R11: 0000000000000000 R12: ffffffff81a8e730
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88012fc40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000010fb708 CR3: 0000000122956000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/0:0 (pid: 0, threadinfo ffff88012884a000, task ffff88012881b3f0)
Stack:
  ffff88012884bf28 ffffffff81009e87 ffffffff81a8e740 0000000000000004
  ffff88012884bf48 ffffffff814780e9 0000000000000000 0000000000000000
  0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
  [<ffffffff81009e87>] cpu_idle+0x5e/0xb5
  [<ffffffff814780e9>] start_secondary+0x1a3/0x1a8
Code: 25 08 cd 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 a8 f4 ff ff 85 c0 75 10 e8 22 7e 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 0c e8 12 7e 06 00 fb 
66 66 90 66 66 90 e8 8c 19 22 00 89 c7
Call Trace:
  [<ffffffff81009e87>] cpu_idle+0x5e/0xb5
  [<ffffffff814780e9>] start_secondary+0x1a3/0x1a8

^GMessage from syslogd@localhost at Jul 13 07:21:13 ...
  kernel:Stack:
^GMessage from syslogd@localhost at Jul 13 07:21:13 ...
  kernel:Call Trace:

^GMessage from syslogd@localhost at Jul 13 07:21:13 ...
  kernel:Code: 6c 24 08 49 c1 e9 09 4c 89 24 24 49 83 f1 01 41 83 e1 01 e8 27 ed ff ff 65 48 8b 04 25 00 cd 00 00 c7 80 dc 05 00 00 00 00 00 00

^GMessage from syslogd@localhost at Jul 13 07:21:13 ...
  kernel:Stack:

^GMessage from syslogd@localhost at Jul 13 07:21:13 ...
  kernel:Call Trace:

^GMessage from syslogd@localhost at Jul 13 07:21:13 ...
  kernel: <IRQ>

^GMessage from syslogd@localhost at Jul 13 07:21:13 ...
  kernel: <EOI>

^GMessage from syslogd@localhost at Jul 13 07:21:13 ...
  kernel:Code: ff ff ff e9 23 ff ff ff 48 85 db 48 89 d9 0f 85 70 ff ff ff e9 4e ff ff ff 48 81 c4 d8 00 00 00 5b 41 5c 41 5d 41 5e 41 5f c9 c3

^GMessage from syslogd@localhost at Jul 13 07:21:13 ...
  kernel:Stack:

^GMessage from syslogd@localhost at Jul 13 07:21:13 ...
  kernel:Call Trace:

^GMessage from syslogd@localhost at Jul 13 07:21:13 ...
  kernel:Code: 25 08 cd 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 a8 f4 ff ff 85 c0 75 10 e8 22 7e 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 0c e8 12 7e 
06 00 fb 66 66 90 66 66 90 e8 8c 19 22 00 89 c7

^GMessage from syslogd@localhost at Jul 13 07:21:14 ...
  kernel:Stack:

^GMessage from syslogd@localhost at Jul 13 07:21:14 ...
  kernel:Call Trace:

^GMessage from syslogd@localhost at Jul 13 07:21:14 ...
  kernel: <IRQ>
^GMessage from syslogd@localhost at Jul 13 07:21:14 ...
  kernel: <EOI>

^GMessage from syslogd@localhost at Jul 13 07:21:14 ...
  kernel:Code: ff c9 c3 55 48 8d 3c bf 48 89 e5 e8 b7 ff ff ff c9 c3 55 48 89 e5 41 57 41 56 41 55 41 54 49 89 fc bf 01 00 00 00 53 48 83 ec 08 <e8> b1 56 25 00 
e8 8f 67 00 00 41 89 c5 66 66 90 0f ae e8 e8 a2

^GMessage from syslogd@localhost at Jul 13 07:21:14 ...
  kernel:Stack:

^GMessage from syslogd@localhost at Jul 13 07:21:14 ...
  kernel:Call Trace:

^GMessage from syslogd@localhost at Jul 13 07:21:14 ...
  kernel:Code: 25 08 cd 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 a8 f4 ff ff 85 c0 75 10 e8 22 7e 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 0c e8 12 7e 
06 00 fb 66 66 90 66 66 90 e8 8c 19 22 00 89 c7

^GMessage from syslogd@localhost at Jul 13 07:21:15 ...
  kernel:Stack:

^GMessage from syslogd@localhost at Jul 13 07:21:15 ...
  kernel:Call Trace:

^GMessage from syslogd@localhost at Jul 13 07:21:15 ...
  kernel:Code: 25 08 cd 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 a8 f4 ff ff 85 c0 75 10 e8 22 7e 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 0c e8 12 7e 
06 00 fb 66 66 90 66 66 90 e8 8c 19 22 00 89 c7

^GMessage from syslogd@localhost at Jul 13 07:21:15 ...
  kernel:Stack:

^GMessage from syslogd@localhost at Jul 13 07:21:15 ...
  kernel:Call Trace:

^GMessage from syslogd@localhost at Jul 13 07:21:15 ...
  kernel:Code: 25 08 cd 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 a8 f4 ff ff 85 c0 75 10 e8 22 7e 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 0c e8 12 7e 
06 00 fb 66 66 90 66 66 90 e8 8c 19 22 00 89 c7

^GMessage from syslogd@localhost at Jul 13 07:21:16 ...
  kernel:Stack:

^GMessage from syslogd@localhost at Jul 13 07:21:16 ...
  kernel:Call Trace:
^GMessage from syslogd@localhost at Jul 13 07:21:16 ...
  kernel:Code: 25 08 cd 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 a8 f4 ff ff 85 c0 75 10 e8 22 7e 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 0c e8 12 7e 
06 00 fb 66 66 90 66 66 90 e8 8c 19 22 00 89 c7
BUG: spinlock lockup on CPU#0, swapper/0, ffff880124ee6b90
Pid: 0, comm: swapper Tainted: G        W   3.0.0-rc7+ #23
Call Trace:
  <IRQ>  [<ffffffff81231ed0>] do_raw_spin_lock+0x10c/0x13c
  [<ffffffff8147e7ed>] _raw_spin_lock_irqsave+0x56/0x60
  [<ffffffff81370d51>] ? rtc_handle_legacy_irq+0x5c/0xb3
  [<ffffffff8147ed33>] ? _raw_spin_unlock_irqrestore+0x6b/0x79
  [<ffffffff81370d51>] rtc_handle_legacy_irq+0x5c/0xb3
  [<ffffffff81370dfa>] rtc_pie_update_irq+0x52/0x5e
  [<ffffffff8106a57c>] __run_hrtimer+0xbe/0x1be
  [<ffffffff81370da8>] ? rtc_handle_legacy_irq+0xb3/0xb3
  [<ffffffff8106a9a0>] hrtimer_interrupt+0xe5/0x1c0
  [<ffffffff810232bc>] smp_apic_timer_interrupt+0x80/0x93
  [<ffffffff81485a13>] apic_timer_interrupt+0x13/0x20
  <EOI>  [<ffffffff8101165c>] ? mwait_idle+0x86/0xc8
  [<ffffffff81011665>] ? mwait_idle+0x8f/0xc8
  [<ffffffff8101165c>] ? mwait_idle+0x86/0xc8
  [<ffffffff81009e87>] cpu_idle+0x5e/0xb5
  [<ffffffff81465cbc>] rest_init+0xd0/0xd7
  [<ffffffff81465bec>] ? csum_partial_copy_generic+0x16c/0x16c
  [<ffffffff81aa9c76>] start_kernel+0x3bd/0x3c8
  [<ffffffff81aa92cd>] x86_64_start_reservations+0xb8/0xbc
  [<ffffffff81aa93d2>] x86_64_start_kernel+0x101/0x110


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

