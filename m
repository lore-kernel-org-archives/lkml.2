Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab1HXNpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:45:30 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:35393 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab1HXNp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:45:27 -0400
Message-ID: <4E550057.9070609@linux.vnet.ibm.com>
Date: Wed, 24 Aug 2011 19:14:55 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: [BUG] Soft-lockup during cpu-hotplug in VFS callpaths
Content-Type: multipart/mixed;
 boundary="------------010000050001050906020207"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010000050001050906020207
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

While running stressful cpu hotplug tests along with kernel compilation
running in background, soft-lockups are detected on multiple CPUs.
Sometimes this also leads to hard lockups and kernel panic.
All the soft-lockups seem to occur at vfsmount_lock_local_cpu() or other VFS
callpaths.


[37108.410813] BUG: soft lockup - CPU#5 stuck for 22s! [cc1:29669]
<snip>
[37108.694781] Call Trace:
[37108.697306]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
[37108.704258]  [<ffffffff81187cb5>] path_init+0x315/0x400
[37108.709558]  [<ffffffff8127c398>] ? __raw_spin_lock_init+0x38/0x70
[37108.715812]  [<ffffffff8118961c>] path_openat+0x8c/0x3f0
[37108.721203]  [<ffffffff81012129>] ? sched_clock+0x9/0x10
[37108.726597]  [<ffffffff8109416d>] ? sched_clock_cpu+0xcd/0x110
[37108.732508]  [<ffffffff810a178d>] ? trace_hardirqs_off+0xd/0x10
[37108.738498]  [<ffffffff8109421f>] ? local_clock+0x6f/0x80
[37108.743970]  [<ffffffff81189a99>] do_filp_open+0x49/0xa0
[37108.749362]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37108.754665]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40
[37108.760575]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37108.765875]  [<ffffffff81179607>] do_sys_open+0x107/0x1e0
[37108.771352]  [<ffffffff810d610f>] ? audit_syscall_entry+0x1bf/0x1f0
[37108.777695]  [<ffffffff81179720>] sys_open+0x20/0x30
[37108.782741]  [<ffffffff8152e202>] system_call_fastpath+0x16/0x1b

Kernel version: 3.0.1, 3.0.3
Hardware: Dual socket quad-core hyper-threaded Intel x86 machine
Scenario:
(a) Stressful cpu hotplug tests + kernel compilation

(b) IRQ balancing had been disabled and all the IRQs  were made to be
    routed to CPU 0 (except the ones that couldn't be routed).

(c) Lockdep was enabled during kernel configuration.

Steps (b) and (c) were done to dig deeper into the issue. However the same
issue was observed by just doing step (a).

Definitely there seems to be a race condition occurring here, because this
issue is hit after sometime, after starting the tests. And the time it
takes to hit the issue increases as we increase the number of debug print
statements. In some cases (especially when the number of debug print
statements were quite high), the stress on the machine had to be increased
in order to hit the issue within measurable time. In my tests, a maximum
of about 2 to 2.5 hours was sufficient, to hit this bug.

Please find the console log attached with this mail.

Any ideas on how to go about fixing this bug?

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab

--------------010000050001050906020207
Content-Type: text/plain;
 name="soft-lockup_log.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="soft-lockup_log.txt"

[37108.410813] BUG: soft lockup - CPU#5 stuck for 22s! [cc1:29669]
[37108.416815] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37108.469864] irq event stamp: 240636
[37108.473431] hardirqs last  enabled at (240635): [<ffffffff81525ad4>] restore_args+0x0/0x30
[37108.481869] hardirqs last disabled at (240636): [<ffffffff8152596a>] save_args+0x6a/0x70
[37108.490132] softirqs last  enabled at (240634): [<ffffffff8106ea2c>] __do_softirq+0x14c/0x250
[37108.498833] softirqs last disabled at (240629): [<ffffffff8152f4bc>] call_softirq+0x1c/0x30
[37108.507355] CPU 5
[37108.509201] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37108.562468]
[37108.564042] Pid: 29669, comm: cc1 Not tainted 3.0.3 #1 IBM BladeCenter HS22V -[7871G2A]-/81Y7641
[37108.573478] RIP: 0010:[<ffffffff81199ec2>]  [<ffffffff81199ec2>] vfsmount_lock_local_lock+0x52/0x60
[37108.582692] RSP: 0018:ffff88033c34fd28  EFLAGS: 00000297
[37108.588080] RAX: ffff88047e9d0340 RBX: ffffffff81525ad4 RCX: 0000000000002387
[37108.595287] RDX: 0000000000002388 RSI: 1208000000000000 RDI: 0000000000000246
[37108.602494] RBP: ffff88033c34fd38 R08: 0000000000000241 R09: fffffffff6fc0241
[37108.609701] R10: 00000000000270d0 R11: 0000000000000000 R12: ffffffff8152ec6e
[37108.616907] R13: ffff88047e800000 R14: ffff88033c34e000 R15: 0000000000000000
[37108.624115] FS:  00007f4c41bd3700(0000) GS:ffff88047e800000(0000) knlGS:0000000000000000
[37108.632359] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[37108.638175] CR2: 00007f4c3af2f000 CR3: 0000000316e20000 CR4: 00000000000006e0
[37108.645383] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[37108.652592] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[37108.659801] Process cc1 (pid: 29669, threadinfo ffff88033c34e000, task ffff8803b3b22840)
[37108.668036] Stack:
[37108.671879]  ffffffff81199e70 ffffffff829cbf7a ffff88033c34fd98 ffffffff81187cb5
[37108.679513]  ffff88033c34fd78 ffffffff8127c398 ffff88046dea1980 ffff88046dea1980
[37108.687147]  ffff88046f7f4ec0 ffff8802eda17000 ffff88033c34fd98 ffff88033c34fe38
[37108.694781] Call Trace:
[37108.697306]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
[37108.704258]  [<ffffffff81187cb5>] path_init+0x315/0x400
[37108.709558]  [<ffffffff8127c398>] ? __raw_spin_lock_init+0x38/0x70
[37108.715812]  [<ffffffff8118961c>] path_openat+0x8c/0x3f0
[37108.721203]  [<ffffffff81012129>] ? sched_clock+0x9/0x10
[37108.726597]  [<ffffffff8109416d>] ? sched_clock_cpu+0xcd/0x110
[37108.732508]  [<ffffffff810a178d>] ? trace_hardirqs_off+0xd/0x10
[37108.738498]  [<ffffffff8109421f>] ? local_clock+0x6f/0x80
[37108.743970]  [<ffffffff81189a99>] do_filp_open+0x49/0xa0
[37108.749362]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37108.754665]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40
[37108.760575]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37108.765875]  [<ffffffff81179607>] do_sys_open+0x107/0x1e0
[37108.771352]  [<ffffffff810d610f>] ? audit_syscall_entry+0x1bf/0x1f0
[37108.777695]  [<ffffffff81179720>] sys_open+0x20/0x30
[37108.782741]  [<ffffffff8152e202>] system_call_fastpath+0x16/0x1b
[37108.788824] Code: c7 04 24 70 9e 19 81 e8 bd dd f0 ff 48 c7 c0 40 03 1d 00 65 48 03 04 25 d0 dc 00 00 ba 00 00 01 00 f0 0f c1 10 0f b7 ca c1 ea 10
[37108.802938]  d1 74 07 f3 90 0f b7 08 eb f5 c9 c3 90 55 48 89 e5 41 54 53
[37108.810555] Call Trace:
[37108.813080]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
[37108.820031]  [<ffffffff81187cb5>] path_init+0x315/0x400
[37108.825332]  [<ffffffff8127c398>] ? __raw_spin_lock_init+0x38/0x70
[37108.831587]  [<ffffffff8118961c>] path_openat+0x8c/0x3f0
[37108.836972]  [<ffffffff81012129>] ? sched_clock+0x9/0x10
[37108.842362]  [<ffffffff8109416d>] ? sched_clock_cpu+0xcd/0x110
[37108.848278]  [<ffffffff810a178d>] ? trace_hardirqs_off+0xd/0x10
[37108.854272]  [<ffffffff8109421f>] ? local_clock+0x6f/0x80
[37108.859750]  [<ffffffff81189a99>] do_filp_open+0x49/0xa0
[37108.865140]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37108.870443]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40
[37108.876354]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37108.881661]  [<ffffffff81179607>] do_sys_open+0x107/0x1e0
[37108.887134]  [<ffffffff810d610f>] ? audit_syscall_entry+0x1bf/0x1f0
[37108.893474]  [<ffffffff81179720>] sys_open+0x20/0x30
[37108.898514]  [<ffffffff8152e202>] system_call_fastpath+0x16/0x1b
[37109.145765] BUG: soft lockup - CPU#1 stuck for 22s! [cc1:29657]
[37109.151765] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37109.204848] irq event stamp: 307814
[37109.208415] hardirqs last  enabled at (307813): [<ffffffff81525ad4>] restore_args+0x0/0x30
[37109.216856] hardirqs last disabled at (307814): [<ffffffff8152596a>] save_args+0x6a/0x70
[37109.225122] softirqs last  enabled at (307812): [<ffffffff8106ea2c>] __do_softirq+0x14c/0x250
[37109.230211] BUG: soft lockup - CPU#2 stuck for 22s! [objdump:29880]
[37109.230214] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37109.230250] irq event stamp: 239336
[37109.230251] hardirqs last  enabled at (239335): [<ffffffff81525ad4>] restore_args+0x0/0x30
[37109.230257] hardirqs last disabled at (239336): [<ffffffff8152596a>] save_args+0x6a/0x70
[37109.230260] softirqs last  enabled at (239334): [<ffffffff8106ea2c>] __do_softirq+0x14c/0x250
[37109.230265] softirqs last disabled at (239329): [<ffffffff8152f4bc>] call_softirq+0x1c/0x30
[37109.230270] CPU 2
[37109.230271] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37109.230305]
[37109.230308] Pid: 29880, comm: objdump Not tainted 3.0.3 #1 IBM BladeCenter HS22V -[7871G2A]-/81Y7641
[37109.230312] RIP: 0010:[<ffffffff8119a3b1>]  [<ffffffff8119a3b1>] vfsmount_lock_global_lock_online+0x71/0xa0
[37109.230319] RSP: 0018:ffff88017b0f5d38  EFLAGS: 00000202
[37109.230322] RAX: 000000000000000b RBX: ffffffff81525ad4 RCX: 000000000000fdf5
[37109.230324] RDX: 000000000000fdf6 RSI: ffff8801f95d0340 RDI: 0000000000000018
[37109.230327] RBP: ffff88017b0f5d68 R08: ffffffff81c1fa40 R09: 0000000000000000
[37109.230329] R10: 00000000000270d0 R11: 0000000000000001 R12: ffffffff8152ec6e
[37109.230332] R13: ffff8801f8a00000 R14: ffff88017b0f4000 R15: 0000000000000000
[37109.230335] FS:  0000000000000000(0000) GS:ffff8801f8a00000(0000) knlGS:0000000000000000
[37109.230338] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[37109.230340] CR2: 000000390baabd60 CR3: 0000000001a03000 CR4: 00000000000006e0
[37109.230343] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[37109.230345] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[37109.230348] Process objdump (pid: 29880, threadinfo ffff88017b0f4000, task ffff8801f1ed86c0)
[37109.230351] Stack:
[37109.230352]  ffffffff8119a85f ffff88010f05da00 ffff8801579d3280 ffff88046f578580
[37109.230357]  ffff88046f5785b8 ffff88010f05da00 ffff88017b0f5d98 ffffffff8119a85f
[37109.230362]  ffff880116443080 0000000000000008 ffff88010f05da00 ffff8801579d3280
[37109.230367] Call Trace:
[37109.230372]  [<ffffffff8119a85f>] ? mntput_no_expire+0x5f/0x140
[37109.230376]  [<ffffffff8119a85f>] mntput_no_expire+0x5f/0x140
[37109.230379]  [<ffffffff8119a95d>] mntput+0x1d/0x30
[37109.230384]  [<ffffffff8117bdff>] __fput+0x17f/0x250
[37109.230387]  [<ffffffff8117bef5>] fput+0x25/0x30
[37109.230393]  [<ffffffff81177cf6>] filp_close+0x66/0xa0
[37109.230398]  [<ffffffff8106a5a8>] close_files+0xc8/0x180
[37109.230402]  [<ffffffff8106a4e0>] ? find_new_reaper+0x100/0x100
[37109.230406]  [<ffffffff8106a7da>] ? exit_files+0x4a/0x60
[37109.230410]  [<ffffffff8106a695>] put_files_struct+0x35/0x130
[37109.230414]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40
[37109.230418]  [<ffffffff8106a7e2>] exit_files+0x52/0x60
[37109.230422]  [<ffffffff8106c4ea>] do_exit+0x18a/0x490
[37109.230428]  [<ffffffff810a619d>] ? trace_hardirqs_on_caller+0x13d/0x180
[37109.230432]  [<ffffffff8106c84e>] do_group_exit+0x5e/0xd0
[37109.230436]  [<ffffffff8106c8d7>] sys_exit_group+0x17/0x20
[37109.230440]  [<ffffffff8152e202>] system_call_fastpath+0x16/0x1b
[37109.230443] Code: ff 4c 8b 25 ba 41 47 00 eb 26 48 63 d0 48 89 de 44 89 e9 48 03 34 d5 c0 52 c1 81 f0 0f c1 0e 0f b7 d1 c1 e9 10 39 ca 74 07 f3 90 <0f> b7 16 eb f5 48 63 35 0b 6d a8 00 83 c0 01 4c 89 e7 48 63 d0
[37109.230471] Call Trace:
[37109.230475]  [<ffffffff8119a85f>] ? mntput_no_expire+0x5f/0x140
[37109.230479]  [<ffffffff8119a85f>] mntput_no_expire+0x5f/0x140
[37109.230483]  [<ffffffff8119a95d>] mntput+0x1d/0x30
[37109.230486]  [<ffffffff8117bdff>] __fput+0x17f/0x250
[37109.230490]  [<ffffffff8117bef5>] fput+0x25/0x30
[37109.230493]  [<ffffffff81177cf6>] filp_close+0x66/0xa0
[37109.230497]  [<ffffffff8106a5a8>] close_files+0xc8/0x180
[37109.230501]  [<ffffffff8106a4e0>] ? find_new_reaper+0x100/0x100
[37109.230505]  [<ffffffff8106a7da>] ? exit_files+0x4a/0x60
[37109.230509]  [<ffffffff8106a695>] put_files_struct+0x35/0x130
[37109.230513]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40
[37109.230517]  [<ffffffff8106a7e2>] exit_files+0x52/0x60
[37109.230520]  [<ffffffff8106c4ea>] do_exit+0x18a/0x490
[37109.230524]  [<ffffffff810a619d>] ? trace_hardirqs_on_caller+0x13d/0x180
[37109.230528]  [<ffffffff8106c84e>] do_group_exit+0x5e/0xd0
[37109.230532]  [<ffffffff8106c8d7>] sys_exit_group+0x17/0x20
[37109.230536]  [<ffffffff8152e202>] system_call_fastpath+0x16/0x1b
[37109.524020] BUG: soft lockup - CPU#0 stuck for 22s! [cc1:29501]
[37109.524022] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37109.524059] irq event stamp: 315444
[37109.524060] hardirqs last  enabled at (315443): [<ffffffff81525ad4>] restore_args+0x0/0x30
[37109.524065] hardirqs last disabled at (315444): [<ffffffff8152596a>] save_args+0x6a/0x70
[37109.524069] softirqs last  enabled at (315442): [<ffffffff8106ea2c>] __do_softirq+0x14c/0x250
[37109.524073] softirqs last disabled at (315437): [<ffffffff8152f4bc>] call_softirq+0x1c/0x30
[37109.524078] CPU 0
[37109.524079] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37109.524112]
[37109.524115] Pid: 29501, comm: cc1 Not tainted 3.0.3 #1 IBM BladeCenter HS22V -[7871G2A]-/81Y7641
[37109.524119] RIP: 0010:[<ffffffff81199ec8>]  [<ffffffff81199ec8>] vfsmount_lock_local_lock+0x58/0x60
[37109.524124] RSP: 0018:ffff88039b7f9d28  EFLAGS: 00000287
[37109.524126] RAX: ffff8801f87d0340 RBX: ffffffff81525ad4 RCX: 0000000000007edf
[37109.524129] RDX: 0000000000007ee0 RSI: 1208000000000000 RDI: 0000000000000246
[37109.524131] RBP: ffff88039b7f9d38 R08: 0000000000000241 R09: fffffffff6fc0241
[37109.524134] R10: 00000000000270d0 R11: 0000000000000000 R12: ffffffff8152ec6e
[37109.524136] R13: ffff8801f8600000 R14: ffff88039b7f8000 R15: 0000000000000000
[37109.524139] FS:  00007f464d9c1700(0000) GS:ffff8801f8600000(0000) knlGS:0000000000000000
[37109.524142] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[37109.524144] CR2: 00007f464637f000 CR3: 000000046ccd2000 CR4: 00000000000006f0
[37109.524147] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[37109.524149] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[37109.524152] Process cc1 (pid: 29501, threadinfo ffff88039b7f8000, task ffff8804144ee8c0)
[37109.524154] Stack:
[37109.524155]  ffffffff81199e70 ffffffff829cbf7a ffff88039b7f9d98 ffffffff81187cb5
[37109.524161]  ffff88039b7f9d78 ffffffff8127c398 ffff8801141f0980 ffff8801141f0980
[37109.524166]  ffff88046c6e9180 ffff880176b90000 ffff88039b7f9d98 ffff88039b7f9e38
[37109.524171] Call Trace:
[37109.524174]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
[37109.524178]  [<ffffffff81187cb5>] path_init+0x315/0x400
[37109.524184]  [<ffffffff8127c398>] ? __raw_spin_lock_init+0x38/0x70
[37109.524188]  [<ffffffff8118961c>] path_openat+0x8c/0x3f0
[37109.524193]  [<ffffffff81012129>] ? sched_clock+0x9/0x10
[37109.524198]  [<ffffffff8109416d>] ? sched_clock_cpu+0xcd/0x110
[37109.524203]  [<ffffffff810a178d>] ? trace_hardirqs_off+0xd/0x10
[37109.524206]  [<ffffffff8109421f>] ? local_clock+0x6f/0x80
[37109.524210]  [<ffffffff81189a99>] do_filp_open+0x49/0xa0
[37109.524213]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37109.524217]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40
[37109.524221]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37109.524225]  [<ffffffff81179607>] do_sys_open+0x107/0x1e0
[37109.524230]  [<ffffffff810d610f>] ? audit_syscall_entry+0x1bf/0x1f0
[37109.524235]  [<ffffffff81179720>] sys_open+0x20/0x30
[37109.524238]  [<ffffffff8152e202>] system_call_fastpath+0x16/0x1b
[37109.524240] Code: 81 e8 bd dd f0 ff 48 c7 c0 40 03 1d 00 65 48 03 04 25 d0 dc 00 00 ba 00 00 01 00 f0 0f c1 10 0f b7 ca c1 ea 10 39 d1 74 07 f3 90 <0f> b7 08 eb f5 c9 c3 90 55 48 89 e5 41 54 53 48 83 ec 10 66 66
[37109.524269] Call Trace:
[37109.524272]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
[37109.524276]  [<ffffffff81187cb5>] path_init+0x315/0x400
[37109.524279]  [<ffffffff8127c398>] ? __raw_spin_lock_init+0x38/0x70
[37109.524283]  [<ffffffff8118961c>] path_openat+0x8c/0x3f0
[37109.524287]  [<ffffffff81012129>] ? sched_clock+0x9/0x10
[37109.524290]  [<ffffffff8109416d>] ? sched_clock_cpu+0xcd/0x110
[37109.524294]  [<ffffffff810a178d>] ? trace_hardirqs_off+0xd/0x10
[37109.524297]  [<ffffffff8109421f>] ? local_clock+0x6f/0x80
[37109.524301]  [<ffffffff81189a99>] do_filp_open+0x49/0xa0
[37109.524304]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37109.524308]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40
[37109.524311]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37109.524315]  [<ffffffff81179607>] do_sys_open+0x107/0x1e0
[37109.524319]  [<ffffffff810d610f>] ? audit_syscall_entry+0x1bf/0x1f0
[37109.524323]  [<ffffffff81179720>] sys_open+0x20/0x30
[37109.524327]  [<ffffffff8152e202>] system_call_fastpath+0x16/0x1b
[37109.615999] BUG: soft lockup - CPU#8 stuck for 23s! [cc1:29811]
[37109.616001] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37109.616036] irq event stamp: 288768
[37109.616038] hardirqs last  enabled at (288767): [<ffffffff81525ad4>] restore_args+0x0/0x30
[37109.616042] hardirqs last disabled at (288768): [<ffffffff8152596a>] save_args+0x6a/0x70
[37109.616046] softirqs last  enabled at (288766): [<ffffffff8106ea2c>] __do_softirq+0x14c/0x250
[37109.616050] softirqs last disabled at (288761): [<ffffffff8152f4bc>] call_softirq+0x1c/0x30
[37109.616054] CPU 8
[37109.616055] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37109.616088]
[37109.616090] Pid: 29811, comm: cc1 Not tainted 3.0.3 #1 IBM BladeCenter HS22V -[7871G2A]-/81Y7641
[37109.616094] RIP: 0010:[<ffffffff81199ec8>]  [<ffffffff81199ec8>] vfsmount_lock_local_lock+0x58/0x60
[37109.616099] RSP: 0018:ffff88019148fd28  EFLAGS: 00000287
[37109.616101] RAX: ffff8801f8fd0340 RBX: ffffffff81525ad4 RCX: 000000000000707f
[37109.616104] RDX: 0000000000007080 RSI: 1208000000000000 RDI: 0000000000000246
[37109.616106] RBP: ffff88019148fd38 R08: 0000000000000241 R09: fffffffff6fc0241
[37109.616109] R10: 00000000000270d0 R11: 0000000000000000 R12: ffffffff8152ec6e
[37109.616111] R13: ffff8801f8e00000 R14: ffff88019148e000 R15: 0000000000000000
[37109.616114] FS:  00007fc65fa7b700(0000) GS:ffff8801f8e00000(0000) knlGS:0000000000000000
[37109.616117] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[37109.616119] CR2: 00007fc659930000 CR3: 000000010b021000 CR4: 00000000000006e0
[37109.616122] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[37109.616125] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[37109.616127] Process cc1 (pid: 29811, threadinfo ffff88019148e000, task ffff880122d288c0)
[37109.616129] Stack:
[37109.616131]  ffffffff81199e70 ffffffff829cbf7a ffff88019148fd98 ffffffff81187cb5
[37109.616136]  ffff88019148fd78 ffffffff8127c398 ffff8801f47ca6c0 ffff8801f47ca6c0
[37109.616141]  ffff880074776540 ffff8800738ae000 ffff88019148fd98 ffff88019148fe38
[37109.616146] Call Trace:
[37109.616149]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
[37109.616153]  [<ffffffff81187cb5>] path_init+0x315/0x400
[37109.616157]  [<ffffffff8127c398>] ? __raw_spin_lock_init+0x38/0x70
[37109.616161]  [<ffffffff8118961c>] path_openat+0x8c/0x3f0
[37109.616164]  [<ffffffff81012129>] ? sched_clock+0x9/0x10
[37109.616168]  [<ffffffff8109416d>] ? sched_clock_cpu+0xcd/0x110
[37109.616172]  [<ffffffff810a178d>] ? trace_hardirqs_off+0xd/0x10
[37109.616175]  [<ffffffff8109421f>] ? local_clock+0x6f/0x80
[37109.616179]  [<ffffffff81189a99>] do_filp_open+0x49/0xa0
[37109.616182]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37109.616186]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40
[37109.616190]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37109.616194]  [<ffffffff81179607>] do_sys_open+0x107/0x1e0
[37109.616198]  [<ffffffff810d610f>] ? audit_syscall_entry+0x1bf/0x1f0
[37109.616202]  [<ffffffff81179720>] sys_open+0x20/0x30
[37109.616206]  [<ffffffff8152e202>] system_call_fastpath+0x16/0x1b
[37109.616208] Code: 81 e8 bd dd f0 ff 48 c7 c0 40 03 1d 00 65 48 03 04 25 d0 dc 00 00 ba 00 00 01 00 f0 0f c1 10 0f b7 ca c1 ea 10 39 d1 74 07 f3 90 <0f> b7 08 eb f5 c9 c3 90 55 48 89 e5 41 54 53 48 83 ec 10 66 66 
[37109.616236] Call Trace:
[37109.616239]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
[37109.616243]  [<ffffffff81187cb5>] path_init+0x315/0x400
[37109.616247]  [<ffffffff8127c398>] ? __raw_spin_lock_init+0x38/0x70
[37109.616250]  [<ffffffff8118961c>] path_openat+0x8c/0x3f0
[37109.616254]  [<ffffffff81012129>] ? sched_clock+0x9/0x10
[37109.616257]  [<ffffffff8109416d>] ? sched_clock_cpu+0xcd/0x110
[37109.616261]  [<ffffffff810a178d>] ? trace_hardirqs_off+0xd/0x10
[37109.616265]  [<ffffffff8109421f>] ? local_clock+0x6f/0x80
[37109.616268]  [<ffffffff81189a99>] do_filp_open+0x49/0xa0
[37109.616272]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37109.616275]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40
[37109.616279]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37109.616283]  [<ffffffff81179607>] do_sys_open+0x107/0x1e0
[37109.616287]  [<ffffffff810d610f>] ? audit_syscall_entry+0x1bf/0x1f0
[37109.616291]  [<ffffffff81179720>] sys_open+0x20/0x30
[37109.616294]  [<ffffffff8152e202>] system_call_fastpath+0x16/0x1b
[37110.125211] BUG: soft lockup - CPU#6 stuck for 22s! [fixdep:29868]
[37110.125212] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37110.125237] irq event stamp: 218696
[37110.125238] hardirqs last  enabled at (218695): [<ffffffff81525ad4>] restore_args+0x0/0x30
[37110.125242] hardirqs last disabled at (218696): [<ffffffff8152596a>] save_args+0x6a/0x70
[37110.125245] softirqs last  enabled at (218694): [<ffffffff8106ea2c>] __do_softirq+0x14c/0x250
[37110.125248] softirqs last disabled at (218679): [<ffffffff8152f4bc>] call_softirq+0x1c/0x30
[37110.125251] CPU 6 
[37110.125252] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37110.125275] 
[37110.125277] Pid: 29868, comm: fixdep Not tainted 3.0.3 #1 IBM BladeCenter HS22V -[7871G2A]-/81Y7641     
[37110.125280] RIP: 0010:[<ffffffff81199ec8>]  [<ffffffff81199ec8>] vfsmount_lock_local_lock+0x58/0x60
[37110.125284] RSP: 0018:ffff88032e819e58  EFLAGS: 00000297
[37110.125286] RAX: ffff88047ebd0340 RBX: ffffffff81525ad4 RCX: 0000000000005aae
[37110.125287] RDX: 0000000000005aaf RSI: 1208000000000000 RDI: 0000000000000246
[37110.125289] RBP: ffff88032e819e68 R08: 0000000000000241 R09: fffffffff6fc0241
[37110.125291] R10: 00000000000270d0 R11: 0000000000000000 R12: ffffffff8152ec6e
[37110.125293] R13: ffff88047ea00000 R14: ffff88032e818000 R15: 0000000000000000
[37110.125295] FS:  00007f93a174a700(0000) GS:ffff88047ea00000(0000) knlGS:0000000000000000
[37110.125297] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[37110.125298] CR2: 00007f93a1748004 CR3: 0000000366591000 CR4: 00000000000006e0
[37110.125300] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[37110.125302] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[37110.125304] Process fixdep (pid: 29868, threadinfo ffff88032e818000, task ffff88036364a400)
[37110.125305] Stack:
[37110.125306]  ffffffff81199e70 ffff88017ad61ac0 ffff88032e819e98 ffffffff8119a82c
[37110.125310]  ffff880433d07380 0000000000000010 ffff88015784a208 ffff88017ad61ac0
[37110.125313]  ffff88032e819ea8 ffffffff8119a95d ffff88032e819ef8 ffffffff8117bdff
[37110.125317] Call Trace:
[37110.125319]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
[37110.125322]  [<ffffffff8119a82c>] mntput_no_expire+0x2c/0x140
[37110.125325]  [<ffffffff8119a95d>] mntput+0x1d/0x30
[37110.125328]  [<ffffffff8117bdff>] __fput+0x17f/0x250
[37110.125331]  [<ffffffff81179807>] ? sys_close+0xb7/0x1a0
[37110.125333]  [<ffffffff8117bef5>] fput+0x25/0x30
[37110.125336]  [<ffffffff81177cf6>] filp_close+0x66/0xa0
[37110.125339]  [<ffffffff81179812>] sys_close+0xc2/0x1a0
[37110.125342]  [<ffffffff8152e202>] system_call_fastpath+0x16/0x1b
[37110.125343] Code: 81 e8 bd dd f0 ff 48 c7 c0 40 03 1d 00 65 48 03 04 25 d0 dc 00 00 ba 00 00 01 00 f0 0f c1 10 0f b7 ca c1 ea 10 39 d1 74 07 f3 90 <0f> b7 08 eb f5 c9 c3 90 55 48 89 e5 41 54 53 48 83 ec 10 66 66 
[37110.125362] Call Trace:
[37110.125365]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
[37110.125368]  [<ffffffff8119a82c>] mntput_no_expire+0x2c/0x140
[37110.125370]  [<ffffffff8119a95d>] mntput+0x1d/0x30
[37110.125372]  [<ffffffff8117bdff>] __fput+0x17f/0x250
[37110.125375]  [<ffffffff81179807>] ? sys_close+0xb7/0x1a0
[37110.125377]  [<ffffffff8117bef5>] fput+0x25/0x30
[37110.125380]  [<ffffffff81177cf6>] filp_close+0x66/0xa0
[37110.125383]  [<ffffffff81179812>] sys_close+0xc2/0x1a0
[37110.125385]  [<ffffffff8152e202>] system_call_fastpath+0x16/0x1b
[37110.823397] BUG: soft lockup - CPU#7 stuck for 23s! [cc1:29131]
[37110.823399] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37110.823424] irq event stamp: 327546
[37110.823426] hardirqs last  enabled at (327545): [<ffffffff81525ad4>] restore_args+0x0/0x30
[37110.823430] hardirqs last disabled at (327546): [<ffffffff8152596a>] save_args+0x6a/0x70
[37110.823433] softirqs last  enabled at (327544): [<ffffffff8106ea2c>] __do_softirq+0x14c/0x250
[37110.823436] softirqs last disabled at (327539): [<ffffffff8152f4bc>] call_softirq+0x1c/0x30
[37110.823439] CPU 7 
[37110.823440] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37110.823463] 
[37110.823465] Pid: 29131, comm: cc1 Not tainted 3.0.3 #1 IBM BladeCenter HS22V -[7871G2A]-/81Y7641     
[37110.823468] RIP: 0010:[<ffffffff81199ec8>]  [<ffffffff81199ec8>] vfsmount_lock_local_lock+0x58/0x60
[37110.823472] RSP: 0018:ffff8802f24ffd28  EFLAGS: 00000297
[37110.823473] RAX: ffff88047edd0340 RBX: ffffffff81525ad4 RCX: 0000000000000c08
[37110.823475] RDX: 0000000000000c09 RSI: 1208000000000000 RDI: 0000000000000246
[37110.823477] RBP: ffff8802f24ffd38 R08: 0000000000000241 R09: fffffffff6fc0241
[37110.823479] R10: 00000000000270d0 R11: 0000000000000000 R12: ffffffff8152ec6e
[37110.823480] R13: ffff88047ec00000 R14: ffff8802f24fe000 R15: 0000000000000000
[37110.823483] FS:  00007fae99083700(0000) GS:ffff88047ec00000(0000) knlGS:0000000000000000
[37110.823485] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[37110.823486] CR2: 00007fae90cbf000 CR3: 000000033c813000 CR4: 00000000000006e0
[37110.823488] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[37110.823490] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[37110.823492] Process cc1 (pid: 29131, threadinfo ffff8802f24fe000, task ffff880326bee3c0)
[37110.823493] Stack:
[37110.823494]  ffffffff81199e70 ffffffff829cbf7a ffff8802f24ffd98 ffffffff81187cb5
[37110.823498]  ffff8802f24ffd78 ffffffff8127c398 ffff88035689d6c0 ffff88035689d6c0
[37110.823501]  ffff88046c73f380 ffff8803989c7000 ffff8802f24ffd98 ffff8802f24ffe38
[37110.823505] Call Trace:
[37110.823508]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
[37110.823510]  [<ffffffff81187cb5>] path_init+0x315/0x400
[37110.823514]  [<ffffffff8127c398>] ? __raw_spin_lock_init+0x38/0x70
[37110.823516]  [<ffffffff8118961c>] path_openat+0x8c/0x3f0
[37110.823519]  [<ffffffff81012129>] ? sched_clock+0x9/0x10
[37110.823522]  [<ffffffff8109416d>] ? sched_clock_cpu+0xcd/0x110
[37110.823525]  [<ffffffff810a178d>] ? trace_hardirqs_off+0xd/0x10
[37110.823527]  [<ffffffff8109421f>] ? local_clock+0x6f/0x80
[37110.823530]  [<ffffffff81189a99>] do_filp_open+0x49/0xa0
[37110.823532]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37110.823535]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40
[37110.823537]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37110.823541]  [<ffffffff81179607>] do_sys_open+0x107/0x1e0
[37110.823544]  [<ffffffff810d610f>] ? audit_syscall_entry+0x1bf/0x1f0
[37110.823547]  [<ffffffff81179720>] sys_open+0x20/0x30
[37110.823550]  [<ffffffff8152e202>] system_call_fastpath+0x16/0x1b
[37110.823551] Code: 81 e8 bd dd f0 ff 48 c7 c0 40 03 1d 00 65 48 03 04 25 d0 dc 00 00 ba 00 00 01 00 f0 0f c1 10 0f b7 ca c1 ea 10 39 d1 74 07 f3 90 <0f> b7 08 eb f5 c9 c3 90 55 48 89 e5 41 54 53 48 83 ec 10 66 66 
[37110.823571] Call Trace:
[37110.823573]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
[37110.823576]  [<ffffffff81187cb5>] path_init+0x315/0x400
[37110.823579]  [<ffffffff8127c398>] ? __raw_spin_lock_init+0x38/0x70
[37110.823581]  [<ffffffff8118961c>] path_openat+0x8c/0x3f0
[37110.823584]  [<ffffffff81012129>] ? sched_clock+0x9/0x10
[37110.823586]  [<ffffffff8109416d>] ? sched_clock_cpu+0xcd/0x110
[37110.823589]  [<ffffffff810a178d>] ? trace_hardirqs_off+0xd/0x10
[37110.823592]  [<ffffffff8109421f>] ? local_clock+0x6f/0x80
[37110.823594]  [<ffffffff81189a99>] do_filp_open+0x49/0xa0
[37110.823596]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37110.823599]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40
[37110.823601]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37110.823604]  [<ffffffff81179607>] do_sys_open+0x107/0x1e0
[37110.823607]  [<ffffffff810d610f>] ? audit_syscall_entry+0x1bf/0x1f0
[37110.823610]  [<ffffffff81179720>] sys_open+0x20/0x30
[37110.823613]  [<ffffffff8152e202>] system_call_fastpath+0x16/0x1b
[37111.592770] softirqs last disabled at (307807): [<ffffffff8152f4bc>] call_softirq+0x1c/0x30
[37111.601298] CPU 1 
[37111.603145] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37111.656445] 
[37111.658021] Pid: 29657, comm: cc1 Not tainted 3.0.3 #1 IBM BladeCenter HS22V -[7871G2A]-/81Y7641     
[37111.667452] RIP: 0010:[<ffffffff81199ec8>]  [<ffffffff81199ec8>] vfsmount_lock_local_lock+0x58/0x60
[37111.676671] RSP: 0018:ffff880116575d28  EFLAGS: 00000297
[37111.682062] RAX: ffff8801f89d0340 RBX: ffffffff81525ad4 RCX: 000000000000ae47
[37111.689269] RDX: 000000000000ae48 RSI: 1208000000000000 RDI: 0000000000000246
[37111.696480] RBP: ffff880116575d38 R08: 0000000000000241 R09: fffffffff6fc0241
[37111.703686] R10: 00000000000270d0 R11: 0000000000000000 R12: ffffffff8152ec6e
[37111.710898] R13: ffff8801f8800000 R14: ffff880116574000 R15: 0000000000000000
[37111.718108] FS:  00007f1315e20700(0000) GS:ffff8801f8800000(0000) knlGS:0000000000000000
[37111.726356] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[37111.732179] CR2: 00007f130e7ef000 CR3: 000000016c3bd000 CR4: 00000000000006e0
[37111.739388] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[37111.746601] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[37111.753811] Process cc1 (pid: 29657, threadinfo ffff880116574000, task ffff88010d3265c0)
[37111.762055] Stack:
[37111.764147]  ffffffff81199e70 ffffffff829cbf7a ffff880116575d98 ffffffff81187cb5
[37111.771789]  ffff880116575d78 ffffffff8127c398 ffff8801f0d46200 ffff8801f0d46200
[37111.779434]  ffff88010d2d1680 ffff8801164c2000 ffff880116575d98 ffff880116575e38
[37111.787075] Call Trace:
[37111.789603]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
[37111.796560]  [<ffffffff81187cb5>] path_init+0x315/0x400
[37111.801864]  [<ffffffff8127c398>] ? __raw_spin_lock_init+0x38/0x70
[37111.808125]  [<ffffffff8118961c>] path_openat+0x8c/0x3f0
[37111.813517]  [<ffffffff81012129>] ? sched_clock+0x9/0x10
[37111.820666]  [<ffffffff8109416d>] ? sched_clock_cpu+0xcd/0x110
[37111.826582]  [<ffffffff810a178d>] ? trace_hardirqs_off+0xd/0x10
[37111.832578]  [<ffffffff8109421f>] ? local_clock+0x6f/0x80
[37111.838056]  [<ffffffff81189a99>] do_filp_open+0x49/0xa0
[37111.843444]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37111.848750]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40
[37111.854664]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37111.859969]  [<ffffffff81179607>] do_sys_open+0x107/0x1e0
[37111.865451]  [<ffffffff810d610f>] ? audit_syscall_entry+0x1bf/0x1f0
[37111.871794]  [<ffffffff81179720>] sys_open+0x20/0x30
[37111.876838]  [<ffffffff8152e202>] system_call_fastpath+0x16/0x1b
[37111.882924] Code: 81 e8 bd dd f0 ff 48 c7 c0 40 03 1d 00 65 48 03 04 25 d0 dc 00 00 ba 00 00 01 00 f0 0f c1 10 0f b7 ca c1 ea 10 39 d1 74 07 f3 90 <0f> b7 08 eb f5 c9 c3 90 55 48 89 e5 41 54 53 48 83 ec 10 66 66 
[37111.903550] Call Trace:
[37111.906078]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
[37111.913033]  [<ffffffff81187cb5>] path_init+0x315/0x400
[37111.918334]  [<ffffffff8127c398>] ? __raw_spin_lock_init+0x38/0x70
[37111.924595]  [<ffffffff8118961c>] path_openat+0x8c/0x3f0
[37111.929990]  [<ffffffff81012129>] ? sched_clock+0x9/0x10
[37111.935384]  [<ffffffff8109416d>] ? sched_clock_cpu+0xcd/0x110
[37111.941299]  [<ffffffff810a178d>] ? trace_hardirqs_off+0xd/0x10
[37111.947298]  [<ffffffff8109421f>] ? local_clock+0x6f/0x80
[37111.952777]  [<ffffffff81189a99>] do_filp_open+0x49/0xa0
[37111.958166]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37111.963470]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40
[37111.969383]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37111.974686]  [<ffffffff81179607>] do_sys_open+0x107/0x1e0
[37111.980164]  [<ffffffff810d610f>] ? audit_syscall_entry+0x1bf/0x1f0
[37111.986505]  [<ffffffff81179720>] sys_open+0x20/0x30
[37111.991552]  [<ffffffff8152e202>] system_call_fastpath+0x16/0x1b
[37112.234768] BUG: soft lockup - CPU#10 stuck for 22s! [cc1:29775]
[37112.240853] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37112.293935] irq event stamp: 328098
[37112.297498] hardirqs last  enabled at (328097): [<ffffffff81525ad4>] restore_args+0x0/0x30
[37112.305937] hardirqs last disabled at (328098): [<ffffffff8152596a>] save_args+0x6a/0x70
[37112.314198] softirqs last  enabled at (328096): [<ffffffff8106ea2c>] __do_softirq+0x14c/0x250
[37112.322902] softirqs last disabled at (328081): [<ffffffff8152f4bc>] call_softirq+0x1c/0x30
[37112.331431] CPU 10 
[37112.333363] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37112.386694] 
[37112.388268] Pid: 29775, comm: cc1 Not tainted 3.0.3 #1 IBM BladeCenter HS22V -[7871G2A]-/81Y7641     
[37112.397701] RIP: 0010:[<ffffffff81199ec8>]  [<ffffffff81199ec8>] vfsmount_lock_local_lock+0x58/0x60
[37112.406919] RSP: 0018:ffff880104e45d28  EFLAGS: 00000297
[37112.412310] RAX: ffff8801f93d0340 RBX: ffffffff81525ad4 RCX: 000000000000f11c
[37112.419519] RDX: 000000000000f11d RSI: 1208000000000000 RDI: 0000000000000246
[37112.426731] RBP: ffff880104e45d38 R08: 0000000000000241 R09: fffffffff6fc0241
[37112.433940] R10: 00000000000270d0 R11: 0000000000000000 R12: ffffffff8152ec6e
[37112.441155] R13: ffff8801f9200000 R14: ffff880104e44000 R15: 0000000000000000
[37112.448371] FS:  00007fd0f07da700(0000) GS:ffff8801f9200000(0000) knlGS:0000000000000000
[37112.456617] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[37112.462439] CR2: 00007fd0e9e24000 CR3: 0000000114791000 CR4: 00000000000006e0
[37112.469651] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[37112.476859] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[37112.484069] Process cc1 (pid: 29775, threadinfo ffff880104e44000, task ffff88010d97c5c0)
[37112.492310] Stack:
[37112.494408]  ffffffff81199e70 ffffffff829cbf7a ffff880104e45d98 ffffffff81187cb5
[37112.502050]  ffff880104e45d78 ffffffff8127c398 ffff88013199c240 ffff88013199c240
[37112.509688]  ffff8801f0aa0a40 ffff880176b63000 ffff880104e45d98 ffff880104e45e38
[37112.517339] Call Trace:
[37112.519872]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
[37112.526826]  [<ffffffff81187cb5>] path_init+0x315/0x400
[37112.532133]  [<ffffffff8127c398>] ? __raw_spin_lock_init+0x38/0x70
[37112.538394]  [<ffffffff8118961c>] path_openat+0x8c/0x3f0
[37112.543788]  [<ffffffff81012129>] ? sched_clock+0x9/0x10
[37112.549182]  [<ffffffff8109416d>] ? sched_clock_cpu+0xcd/0x110
[37112.555094]  [<ffffffff810a178d>] ? trace_hardirqs_off+0xd/0x10
[37112.561088]  [<ffffffff8109421f>] ? local_clock+0x6f/0x80
[37112.566567]  [<ffffffff81189a99>] do_filp_open+0x49/0xa0
[37112.571960]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37112.577264]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40
[37112.583177]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37112.588482]  [<ffffffff81179607>] do_sys_open+0x107/0x1e0
[37112.593960]  [<ffffffff810d610f>] ? audit_syscall_entry+0x1bf/0x1f0
[37112.600301]  [<ffffffff81179720>] sys_open+0x20/0x30
[37112.605348]  [<ffffffff8152e202>] system_call_fastpath+0x16/0x1b
[37112.611433] Code: 81 e8 bd dd f0 ff 48 c7 c0 40 03 1d 00 65 48 03 04 25 d0 dc 00 00 ba 00 00 01 00 f0 0f c1 10 0f b7 ca c1 ea 10 39 d1 74 07 f3 90 <0f> b7 08 eb f5 c9 c3 90 55 48 89 e5 41 54 53 48 83 ec 10 66 66 
[37112.632075] Call Trace:
[37112.634601]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
[37112.641553]  [<ffffffff81187cb5>] path_init+0x315/0x400
[37112.646856]  [<ffffffff8127c398>] ? __raw_spin_lock_init+0x38/0x70
[37112.653118]  [<ffffffff8118961c>] path_openat+0x8c/0x3f0
[37112.658512]  [<ffffffff81012129>] ? sched_clock+0x9/0x10
[37112.663906]  [<ffffffff8109416d>] ? sched_clock_cpu+0xcd/0x110
[37112.669817]  [<ffffffff810a178d>] ? trace_hardirqs_off+0xd/0x10
[37112.675815]  [<ffffffff8109421f>] ? local_clock+0x6f/0x80
[37112.681292]  [<ffffffff81189a99>] do_filp_open+0x49/0xa0
[37112.686685]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37112.691989]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40
[37112.693469] BUG: soft lockup - CPU#3 stuck for 22s! [sh:29882]
[37112.693471] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37112.693496] irq event stamp: 229310
[37112.693497] hardirqs last  enabled at (229309): [<ffffffff81525ad4>] restore_args+0x0/0x30
[37112.693501] hardirqs last disabled at (229310): [<ffffffff8152596a>] save_args+0x6a/0x70
[37112.693504] softirqs last  enabled at (229308): [<ffffffff8106ea2c>] __do_softirq+0x14c/0x250
[37112.693507] softirqs last disabled at (229303): [<ffffffff8152f4bc>] call_softirq+0x1c/0x30
[37112.693510] CPU 3 
[37112.693511] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37112.693534] 
[37112.693535] Pid: 29882, comm: sh Not tainted 3.0.3 #1 IBM BladeCenter HS22V -[7871G2A]-/81Y7641     
[37112.693538] RIP: 0010:[<ffffffff81199ec8>]  [<ffffffff81199ec8>] vfsmount_lock_local_lock+0x58/0x60
[37112.693542] RSP: 0018:ffff880194281c58  EFLAGS: 00000287
[37112.693544] RAX: ffff8801f8dd0340 RBX: ffffffff81525ad4 RCX: 000000000000a85f
[37112.693545] RDX: 000000000000a860 RSI: 1208000000000000 RDI: 0000000000000246
[37112.693547] RBP: ffff880194281c68 R08: 00000000006d2241 R09: fffffe4b77692241
[37112.693549] R10: 00000000000270d0 R11: 0000000000000000 R12: ffffffff8152ec6e
[37112.693551] R13: ffff8801f8c00000 R14: ffff880194280000 R15: 0000000000000000
[37112.693553] FS:  00007fa7cc1d1700(0000) GS:ffff8801f8c00000(0000) knlGS:0000000000000000
[37112.693555] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[37112.693556] CR2: 0000000000a82b20 CR3: 0000000194238000 CR4: 00000000000006e0
[37112.693558] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[37112.693560] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[37112.693562] Process sh (pid: 29882, threadinfo ffff880194280000, task ffff880074e2e280)
[37112.693563] Stack:
[37112.693564]  ffffffff81199e70 ffffffff829cbf7a ffff880194281cc8 ffffffff81187cb5
[37112.693568]  ffff880194281ca8 ffffffff8127c398 ffff88017b05ec80 ffff88017b05ec80
[37112.693571]  ffff8800741462c0 ffff88017522e000 ffff880194281cc8 ffff880194281d68
[37112.693574] Call Trace:
[37112.693577]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
[37112.693580]  [<ffffffff81187cb5>] path_init+0x315/0x400
[37112.693583]  [<ffffffff8127c398>] ? __raw_spin_lock_init+0x38/0x70
[37112.693586]  [<ffffffff8118961c>] path_openat+0x8c/0x3f0
[37112.693588]  [<ffffffff8109416d>] ? sched_clock_cpu+0xcd/0x110
[37112.693592]  [<ffffffff81012dd3>] ? native_sched_clock+0x13/0x60
[37112.693594]  [<ffffffff81012129>] ? sched_clock+0x9/0x10
[37112.693597]  [<ffffffff81189a99>] do_filp_open+0x49/0xa0
[37112.693600]  [<ffffffff810a7b19>] ? __lock_release+0x129/0x190
[37112.693603]  [<ffffffff81182bfc>] ? check_unsafe_exec+0x14c/0x1a0
[37112.693606]  [<ffffffff81182bbc>] ? check_unsafe_exec+0x10c/0x1a0
[37112.693609]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40
[37112.693612]  [<ffffffff81182e02>] open_exec+0x32/0xd0
[37112.693614]  [<ffffffff81182f80>] do_execve_common+0xe0/0x2a0
[37112.693618]  [<ffffffff8113c615>] ? might_fault+0xa5/0xb0
[37112.693621]  [<ffffffff811831ca>] do_execve+0x3a/0x40
[37112.693624]  [<ffffffff810136ca>] sys_execve+0x4a/0x80
[37112.693627]  [<ffffffff8152e6dc>] stub_execve+0x6c/0xc0
[37112.693628] Code: 81 e8 bd dd f0 ff 48 c7 c0 40 03 1d 00 65 48 03 04 25 d0 dc 00 00 ba 00 00 01 00 f0 0f c1 10 0f b7 ca c1 ea 10 39 d1 74 07 f3 90 <0f> b7 08 eb f5 c9 c3 90 55 48 89 e5 41 54 53 48 83 ec 10 66 66 
[37112.693648] Call Trace:
[37112.693650]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
[37112.693652]  [<ffffffff81187cb5>] path_init+0x315/0x400
[37112.693655]  [<ffffffff8127c398>] ? __raw_spin_lock_init+0x38/0x70
[37112.693658]  [<ffffffff8118961c>] path_openat+0x8c/0x3f0
[37112.693660]  [<ffffffff8109416d>] ? sched_clock_cpu+0xcd/0x110
[37112.693663]  [<ffffffff81012dd3>] ? native_sched_clock+0x13/0x60
[37112.693665]  [<ffffffff81012129>] ? sched_clock+0x9/0x10
[37112.693668]  [<ffffffff81189a99>] do_filp_open+0x49/0xa0
[37112.693671]  [<ffffffff810a7b19>] ? __lock_release+0x129/0x190
[37112.693673]  [<ffffffff81182bfc>] ? check_unsafe_exec+0x14c/0x1a0
[37112.693676]  [<ffffffff81182bbc>] ? check_unsafe_exec+0x10c/0x1a0
[37112.693679]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40
[37112.693681]  [<ffffffff81182e02>] open_exec+0x32/0xd0
[37112.693684]  [<ffffffff81182f80>] do_execve_common+0xe0/0x2a0
[37112.693687]  [<ffffffff8113c615>] ? might_fault+0xa5/0xb0
[37112.693689]  [<ffffffff811831ca>] do_execve+0x3a/0x40
[37112.693692]  [<ffffffff810136ca>] sys_execve+0x4a/0x80
[37112.693694]  [<ffffffff8152e6dc>] stub_execve+0x6c/0xc0
[37112.761187] BUG: soft lockup - CPU#9 stuck for 22s! [cc1:29712]
[37112.761189] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37112.761226] irq event stamp: 334968
[37112.761227] hardirqs last  enabled at (334967): [<ffffffff81525ad4>] restore_args+0x0/0x30
[37112.761232] hardirqs last disabled at (334968): [<ffffffff8152596a>] save_args+0x6a/0x70
[37112.761236] softirqs last  enabled at (334966): [<ffffffff8106ea2c>] __do_softirq+0x14c/0x250
[37112.761240] softirqs last disabled at (334951): [<ffffffff8152f4bc>] call_softirq+0x1c/0x30
[37112.761244] CPU 9 
[37112.761245] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37112.761278] 
[37112.761280] Pid: 29712, comm: cc1 Not tainted 3.0.3 #1 IBM BladeCenter HS22V -[7871G2A]-/81Y7641     
[37112.761284] RIP: 0010:[<ffffffff81199ec8>]  [<ffffffff81199ec8>] vfsmount_lock_local_lock+0x58/0x60
[37112.761289] RSP: 0018:ffff88016d3a7d28  EFLAGS: 00000297
[37112.761292] RAX: ffff8801f91d0340 RBX: ffffffff81525ad4 RCX: 00000000000073a4
[37112.761294] RDX: 00000000000073a5 RSI: 1208000000000000 RDI: 0000000000000246
[37112.761297] RBP: ffff88016d3a7d38 R08: 0000000000000241 R09: fffffffff6fc0241
[37112.761299] R10: 00000000000270d0 R11: 0000000000000000 R12: ffffffff8152ec6e
[37112.761302] R13: ffff8801f9000000 R14: ffff88016d3a6000 R15: 0000000000000000
[37112.761305] FS:  00007f5fe6e03700(0000) GS:ffff8801f9000000(0000) knlGS:0000000000000000
[37112.761308] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[37112.761310] CR2: 00007f5fe0abc000 CR3: 000000010d85a000 CR4: 00000000000006e0
[37112.761313] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[37112.761316] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[37112.761318] Process cc1 (pid: 29712, threadinfo ffff88016d3a6000, task ffff880146972780)
[37112.761320] Stack:
[37112.761322]  ffffffff81199e70 ffffffff829cbf7a ffff88016d3a7d98 ffffffff81187cb5
[37112.761327]  ffff88016d3a7d78 ffffffff8127c398 ffff8801f19ac840 ffff8801f19ac840
[37112.761332]  ffff880073ae3440 ffff8801d6d40000 ffff88016d3a7d98 ffff88016d3a7e38
[37112.761337] Call Trace:
[37112.761341]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
[37112.761345]  [<ffffffff81187cb5>] path_init+0x315/0x400
[37112.761349]  [<ffffffff8127c398>] ? __raw_spin_lock_init+0x38/0x70
[37112.761353]  [<ffffffff8118961c>] path_openat+0x8c/0x3f0
[37112.761357]  [<ffffffff81012129>] ? sched_clock+0x9/0x10
[37112.761360]  [<ffffffff8109416d>] ? sched_clock_cpu+0xcd/0x110
[37112.761365]  [<ffffffff810a178d>] ? trace_hardirqs_off+0xd/0x10
[37112.761368]  [<ffffffff8109421f>] ? local_clock+0x6f/0x80
[37112.761372]  [<ffffffff81189a99>] do_filp_open+0x49/0xa0
[37112.761375]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37112.761379]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40
[37112.761383]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37112.761387]  [<ffffffff81179607>] do_sys_open+0x107/0x1e0
[37112.761391]  [<ffffffff810d610f>] ? audit_syscall_entry+0x1bf/0x1f0
[37112.761395]  [<ffffffff81179720>] sys_open+0x20/0x30
[37112.761399]  [<ffffffff8152e202>] system_call_fastpath+0x16/0x1b
[37112.761401] Code: 81 e8 bd dd f0 ff 48 c7 c0 40 03 1d 00 65 48 03 04 25 d0 dc 00 00 ba 00 00 01 00 f0 0f c1 10 0f b7 ca c1 ea 10 39 d1 74 07 f3 90 <0f> b7 08 eb f5 c9 c3 90 55 48 89 e5 41 54 53 48 83 ec 10 66 66 
[37112.761429] Call Trace:
[37112.761433]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
[37112.761436]  [<ffffffff81187cb5>] path_init+0x315/0x400
[37112.761440]  [<ffffffff8127c398>] ? __raw_spin_lock_init+0x38/0x70
[37112.761444]  [<ffffffff8118961c>] path_openat+0x8c/0x3f0
[37112.761447]  [<ffffffff81012129>] ? sched_clock+0x9/0x10
[37112.761451]  [<ffffffff8109416d>] ? sched_clock_cpu+0xcd/0x110
[37112.761454]  [<ffffffff810a178d>] ? trace_hardirqs_off+0xd/0x10
[37112.761458]  [<ffffffff8109421f>] ? local_clock+0x6f/0x80
[37112.761461]  [<ffffffff81189a99>] do_filp_open+0x49/0xa0
[37112.761465]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37112.761468]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40
[37112.761472]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37112.761476]  [<ffffffff81179607>] do_sys_open+0x107/0x1e0
[37112.761480]  [<ffffffff810d610f>] ? audit_syscall_entry+0x1bf/0x1f0
[37112.761484]  [<ffffffff81179720>] sys_open+0x20/0x30
[37112.761488]  [<ffffffff8152e202>] system_call_fastpath+0x16/0x1b
[37112.998790] BUG: soft lockup - CPU#4 stuck for 23s! [cc1:29178]
[37112.998792] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37112.998818] irq event stamp: 328402
[37112.998819] hardirqs last  enabled at (328401): [<ffffffff81525ad4>] restore_args+0x0/0x30
[37112.998823] hardirqs last disabled at (328402): [<ffffffff8152596a>] save_args+0x6a/0x70
[37112.998826] softirqs last  enabled at (328400): [<ffffffff8106ea2c>] __do_softirq+0x14c/0x250
[37112.998829] softirqs last disabled at (328395): [<ffffffff8152f4bc>] call_softirq+0x1c/0x30
[37112.998832] CPU 4 
[37112.998833] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
[37112.998856] 
[37112.998858] Pid: 29178, comm: cc1 Not tainted 3.0.3 #1 IBM BladeCenter HS22V -[7871G2A]-/81Y7641     
[37112.998861] RIP: 0010:[<ffffffff81199ec2>]  [<ffffffff81199ec2>] vfsmount_lock_local_lock+0x52/0x60
[37112.998865] RSP: 0018:ffff8801f30b5d28  EFLAGS: 00000297
[37112.998866] RAX: ffff88047e7d0340 RBX: ffffffff81525ad4 RCX: 00000000000038a9
[37112.998868] RDX: 00000000000038aa RSI: 1208000000000000 RDI: 0000000000000246
[37112.998870] RBP: ffff8801f30b5d38 R08: 0000000000000241 R09: fffffffff6fc0241
[37112.998871] R10: 00000000000270d0 R11: 0000000000000000 R12: ffffffff8152ec6e
[37112.998873] R13: ffff88047e600000 R14: ffff8801f30b4000 R15: 0000000000000000
[37112.998875] FS:  00007f0444f31700(0000) GS:ffff88047e600000(0000) knlGS:0000000000000000
[37112.998877] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[37112.998879] CR2: 00007f043d3b3000 CR3: 00000003bf28e000 CR4: 00000000000006e0
[37112.998880] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[37112.998882] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[37112.998884] Process cc1 (pid: 29178, threadinfo ffff8801f30b4000, task ffff88018cd98340)
[37112.998886] Stack:
[37112.998887]  ffffffff81199e70 ffffffff829cbf7a ffff8801f30b5d98 ffffffff81187cb5
[37112.998891]  ffff8801f30b5d78 ffffffff8127c398 ffff88046deaa0c0 ffff88046deaa0c0
[37112.998894]  ffff8801092f0200 ffff8803811d5000 ffff8801f30b5d98 ffff8801f30b5e38
[37112.998898] Call Trace:
[37112.998900]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
[37112.998903]  [<ffffffff81187cb5>] path_init+0x315/0x400
[37112.998907]  [<ffffffff8127c398>] ? __raw_spin_lock_init+0x38/0x70
[37112.998909]  [<ffffffff8118961c>] path_openat+0x8c/0x3f0
[37112.998912]  [<ffffffff81012129>] ? sched_clock+0x9/0x10
[37112.998915]  [<ffffffff8109416d>] ? sched_clock_cpu+0xcd/0x110
[37112.998918]  [<ffffffff810a178d>] ? trace_hardirqs_off+0xd/0x10
[37112.998920]  [<ffffffff8109421f>] ? local_clock+0x6f/0x80
[37112.998923]  [<ffffffff81189a99>] do_filp_open+0x49/0xa0
[37112.998925]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37112.998928]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40
[37112.998931]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37112.998934]  [<ffffffff81179607>] do_sys_open+0x107/0x1e0
[37112.998937]  [<ffffffff810d610f>] ? audit_syscall_entry+0x1bf/0x1f0
[37112.998940]  [<ffffffff81179720>] sys_open+0x20/0x30
[37112.998943]  [<ffffffff8152e202>] system_call_fastpath+0x16/0x1b
[37112.998944] Code: c7 04 24 70 9e 19 81 e8 bd dd f0 ff 48 c7 c0 40 03 1d 00 65 48 03 04 25 d0 dc 00 00 ba 00 00 01 00 f0 0f c1 10 0f b7 ca c1 ea 10 
[37112.998958]  d1 74 07 f3 90 0f b7 08 eb f5 c9 c3 90 55 48 89 e5 41 54 53 
[37112.998964] Call Trace:
[37112.998967]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
[37112.998969]  [<ffffffff81187cb5>] path_init+0x315/0x400
[37112.998972]  [<ffffffff8127c398>] ? __raw_spin_lock_init+0x38/0x70
[37112.998975]  [<ffffffff8118961c>] path_openat+0x8c/0x3f0
[37112.998977]  [<ffffffff81012129>] ? sched_clock+0x9/0x10
[37112.998980]  [<ffffffff8109416d>] ? sched_clock_cpu+0xcd/0x110
[37112.998983]  [<ffffffff810a178d>] ? trace_hardirqs_off+0xd/0x10
[37112.998985]  [<ffffffff8109421f>] ? local_clock+0x6f/0x80
[37112.998988]  [<ffffffff81189a99>] do_filp_open+0x49/0xa0
[37112.998990]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
[37112.998992]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40


--------------010000050001050906020207--
