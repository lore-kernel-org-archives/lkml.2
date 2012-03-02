Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030499Ab2CBT6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 14:58:23 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:33442 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030456Ab2CBT6V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 14:58:21 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "dzickus@redhat.com" <dzickus@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Fri, 2 Mar 2012 14:58:15 -0500
Subject: kernel 3.3.0-rc5 bug
Thread-Topic: kernel 3.3.0-rc5 bug
Thread-Index: Acz4ro4OfBpphwBkSsm/ZOA5MD3AfA==
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2DACAECA75@USINDEVS01.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1203020167
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,

I found a bug of your patch switching from IPI to NMI while testing upstream kernel, 3.3.0-rc5.

I made kernel panic with NMI switch by setting unknown_nmi_panic=1.
And following call trace happened.

<snip>
	<4> <EOI>  <NMI>  [<ffffffff814fbf70>] ? __schedule+0x660/0x730 
	<4> [<ffffffff814fbee7>] ? __schedule+0x5d7/0x730 
	<4> [<ffffffff81081c0a>] __cond_resched+0x2a/0x40 
	<4> [<ffffffff814fc0d0>] _cond_resched+0x30/0x40 
	<4> [<ffffffff81154bc5>] kmem_cache_alloc_trace+0xe5/0x190 
	<4> [<ffffffff81031830>] ? native_smp_send_reschedule+0x60/0x60
	<4> [<ffffffff81016dda>] register_nmi_handler+0x6a/0x170 
	<4> [<ffffffff81031b9a>] native_nmi_stop_other_cpus+0x8a/0x110
<snip>

Currently, kzalloc() is called in register_nmi_handler().
We have to remove kzalloc() from register_nmi_handler() because kzalloc() may sleep.
 It should not call in nmi.

I think going back to notifier_chain is reasonable.
Notifier_chain has worked in kdump path reliably.

Seiji



 * all call trace

<snip>
<4> [<ffffffff814e2d85>] rest_init+0x75/0x80 <4> [<ffffffff81affe49>] start_kernel+0x3e5/0x3f0 <4> [<ffffffff81aff346>] x86_64_start_reservations+0x131/0x136
<4> [<ffffffff81aff44e>] x86_64_start_kernel+0x103/0x112 <4>---[ end trace 360b93c08d22ad1c ]--- <4>------------[ cut here ]------------
<4>WARNING: at kernel/rcutree.c:368 rcu_idle_enter_common+0xd9/0xf0() <4>Hardware name: PowerEdge T310 <4>Modules linked in: ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat xt_CHECKSUM iptable_mangle bridge stp llc autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 vfat fat dm_mirror dm_region_hash dm_log dm_mod vhost_net macvtap macvlan tun kvm_intel kvm uinput sg hed dcdbas microcode pcspkr i7core_edac edac_core iTCO_wdt iTCO_vendor_support bnx2 ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_generic ata_piix [last unloaded: scsi_wait_scan]
<4>Pid: 0, comm: swapper/0 Tainted: G        W    3.3.0-rc5+ #2
<4>Call Trace:
<4> <IRQ>  [<ffffffff8104d77f>] warn_slowpath_common+0x7f/0xc0 <4> [<ffffffff8104d7da>] warn_slowpath_null+0x1a/0x20 <4> [<ffffffff810d4a79>] rcu_idle_enter_common+0xd9/0xf0 <4> [<ffffffff810d4b0b>] rcu_irq_exit+0x7b/0xb0 <4> [<ffffffff81054379>] irq_exit+0x79/0xe0 <4> [<ffffffff81507086>] do_IRQ+0x66/0xePoweroff#2 Part24
0
<4> [<ffffffff814fd22e>] common_interrupt+0x6e/0x6e <4> <EOI>  <NMI>  [<ffffffff814fbf70>] ? __schedule+0x660/0x730 <4> [<ffffffff814fbee7>] ? __schedule+0x5d7/0x730 <4> [<ffffffff81081c0a>] __cond_resched+0x2a/0x40 <4> [<ffffffff814fc0d0>] _cond_resched+0x30/0x40 <4> [<ffffffff81154bc5>] kmem_cache_alloc_trace+0xe5/0x190 <4> [<ffffffff81031830>] ? native_smp_send_reschedule+0x60/0x60
<4> [<ffffffff81016dda>] register_nmi_handler+0x6a/0x170 <4> [<ffffffff81031b9a>] native_nmi_stop_other_cpus+0x8a/0x110
<4> [<ffffffff814fa2f6>] panic+0xc8/0x1cf <4> [<ffffffff814fa43e>] ? printk+0x41/0x43 <4> [<ffffffff814fe27f>] unknown_nmi_error+0xdf/0xe0 <4> [<ffffffff814fe3b9>] default_do_nmi+0x139/0x220 <4> [<ffffffff814fe548>] do_nmi+0xa8/0xf0 <4> [<ffffffff814fd844>] restart_nmi+0x1a/0x1e <4> [<ffffffff812a5b0f>] ? intel_idle+0xaf/0x150 <4> [<ffffffff812a5b0f>] ? intel_idle+0xaf/0x150 <4> [<ffffffff812a5b0f>] ? intel_idle+0xaf/0x150 <4> <<EOE>>  [<ffffffff813f85e2>] ? menu_select+0x182/0x390 <4> [<ffffffff813f738d>] cpuidle_idle_call+0xdd/0x220 <4> [<ffffffff8101319f>] cpu_idle+0xcf/0x120 <4> [<ffffffff814e2d85>] rest_init+0x75/0x80 <4> [<ffffffff81affe49>] start_kernel+0x3e5/0x3f0Poweroff#2 Part19

<4> [<ffffffff81aff346>] x86_64_start_reservations+0x131/0x136
<4> [<ffffffff81aff44e>] x86_64_start_kernel+0x103/0x112 <4>---[ end trace 360b93c08d22ad1d ]--- <0>Dumping ftrace buffer:
<0>   (ftrace buffer empty)
<4>------------[ cut here ]------------
<4>WARNING: at kernel/rcutree.c:455 rcu_idle_exit_common+0xa5/0xe0() <4>Hardware name: PowerEdge T310 <4>Current pid: 1824 comm: rsyslogd / Idle pid: 0 comm: swapper/0 <4>Modules linked in: ebtable_nat ebtables ipt_MASQUEPRADE iptable_nat nf_nat xt_CHECKSUM iptable_mangle bridge stp llc autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 vfat fat dm_mirror dm_region_hash dm_log dm_mod vhost_net macvtap macvlan tun kvm_intel kvm uinput sg hed dcdbas microcode pcspkr i7core_edac edac_core iTCO_wdt iTCO_vendor_support bnx2 ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_generic ata_piix [last unloaded: scsi_wait_scan]
<4>Pid: 1824, comm: rsyslogd Tainted: G        W    3.3.0-rc5+ #2
<4>Call Trace:
<4> <IRQ>  [<ffffffff8104d77f>] warn_slowpath_common+0x7f/0xc0 <4> [<ffffffff8104d876>] warn_slowpath_fmt+0x46/0x50 <4> [<ffffffff810d4825>] rcu_idle_exit_common+0xa5/0xe0 <4> [<ffffffff810d48da>] rcu_irq_enter+0x7a/0xa0 <4> [<ffffffff8105449b>] irq_enter+0x1b/0x80 <4> [<ffffffff8150705e>] do_IRQ+0x3e/0xe0 <4> [<ffffffff814fd22e>] common_interrupt+0x6e/0x6e <4> <EOI>  [<ffffffff81258109>] ? flex_array_get_ptr+0x9/0x20 <4> [<ffffffff812064c4>] ? ebitmap_get_bit+0x34/0x70 <4> [<ffffffff8120f434>] constraint_expr_eval+0x444/0x460 <4> [<ffffffff8120ff1e>] context_struct_compute_av+0x2ee/0x420
<4> [<ffffffff81210545>] security_compute_av+0xf5/0x2c0 <4> [<ffffffff811fa138>] avc_has_perm_noaudit+0xd8/0x140 <4> [<ffffffff811fa1eb>] avc_has_perm_flags+0x4b/0xa0 <4> [<ffffffff811fc8c0>] current_has_perm+0x40/0x50 <4> [<ffffffff811fc9ec>] selinux_task_create+0x1c/0x20 <4> [<ffffffff811f7246>] security_task_create+0x16/0x20 <4> [<ffffffff8104bc48>] copy_process+0x98/0xf10 <4> [<ffffffff8104cd24>] do_fork+0x54/0x310 <4> [<ffffffff8101bfb8>] sys_clone+0x28/0x30 <4> [<ffffffff81505673>] stub_clone+0x13/0x20 <4> [<ffffffff81505369>] ? system_call_fastpath+0x16/0x1b <4>---[ end trace 360b93c08d22ad1e ]--- <4>------------[ cut here ]------------
<4>WARNING: at kernel/rcutree.c:361 rcu_idle_enter_common+0xaf/0xf0() <4>Hardware name: PowerEdge T310 <4>Current pid: 1824 comm: rsyslogd / Idle pid: 0 comm: swapper/0 <4>Modules linked in: ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat xt_CHECKSUM iptable_mangle bridge stp llc autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 vfat fat dm_mirror dm_region_hash dm_log dm_mod vhost_net macvtap macvlan tun kvm_intel kvm uinput sg hed dcdbas microcode pcspkr i7core_edac edac_core iTCO_wdt iTCO_vendor_support bnx2 ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_generic ata_piix [last unloaded: scsi_wait_scan]
<4>Pid: 1824, comm: rsyslogd Tainted: G        W    3.3.0-rc5+ #2
<4>Call Trace:
<4> <IRQ>  [<ffffffff8104d77f>] warn_slowpath_common+0x7f/0xc0 <4> [<ffffffff8104d876>] warn_slowpath_fmt+0x46/0x50 <4> [<ffffffff810d4a4f>] rcu_idle_enter_common+0xaf/0xf0 <4> [<ffffffff810d4b0b>] rcu_irq_exit+0x7b/0xb0 <4> [<ffffffff81054379>] irq_exit+0x79/0xe0 <4> [<ffffffff81507086>] do_IRQ+0x66/0xe0 <4> [<ffffffff814fd22e>] common_interrupt+0x6e/0x6e <4> <EOI>  [<ffffffff81258109>] ? flex_array_get_ptr+0x9/0x20 <4> [<ffffffff812064c4>] ? ebitmap_get_bit+0x34/0x70 <4> [<ffffffff8120f434>] constraint_expr_eval+0x444/0x460 <4> [<ffffffff8120ff1e>] context_struct_compute_av+0x2ee/0x420
<4> [<ffffffff81210545>] security_compute_av+0xf5/0x2c0 <4> [<ffffffff811fa138>] avc_has_perm_noaudit+0xd8/0x140 <4> [<ffffffff811fa1eb>] avc_has_perm_flags+0x4b/0xa0 <4> [<ffffffff811fc8c0>] current_has_perm+0x40/0x50 <4> [<ffffffff811fc9ec>] selinux_task_create+0x1c/0x20 <4> [<ffffffff811f7246>] security_task_create+0x16/0x20 <4> [<ffffffff8104bc48>] copy_process+0x98/0xf10 <4> [<ffffffff8104cd24>] do_fork+0x54/0x310 <4> [<ffffffff8101bfb8>] sys_clone+0x28/0x30 <4> [<ffffffff81505673>] stub_clone+0x13/0x20 <4> [<ffffffff81505369>] ? system_call_fastpath+0x16/0x1b <4>---[ end trace 360b93c08d22ad1f ]--- <0>Rebooting in 10 seconds..
<snip>
