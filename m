Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829Ab2BJCcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 21:32:12 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54210 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758134Ab2BJCcK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 21:32:10 -0500
MIME-Version: 1.0
Date: Thu, 9 Feb 2012 18:32:07 -0800
Message-ID: <CAKbGBLgVyWC3iuu8n+aQ8UhziSPnbpHVNGtQ=9m-PzvVA1kzdg@mail.gmail.com>
Subject: bisected: 'perf top' causing soft lockups under Xen
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lockup is pretty reliably reproducible (but only under Xen). I've
seen this happen under multiple hardware configurations and multiple
different configs.

Basically run 'perf top', wait around 30 seconds and see if you still
have keyboard interactivity. If I tell perf to exit (via 'q') before
it has a chance to hang completely, I get this in dmesg:

[   88.517195] BUG: soft lockup - CPU#15 stuck for 22s! [perf:2729]
[   88.517264] Modules linked in: rfcomm bnep bluetooth xen_netback
xen_blkback xen_evtchn ip6table_filter xenfs ip6_tables ipt_MASQUERADE
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp
iptable_filter ip_tables x_tables bridge stp parport_pc ppdev nfs arc4
lockd rt2800pci rt2800lib crc_ccitt fscache rt2x00pci rt2x00lib
auth_rpcgss nfs_acl sunrpc mac80211 psmouse snd_hda_codec_hdmi
serio_raw radeon snd_seq_midi snd_rawmidi snd_hda_codec_realtek
snd_seq_midi_event cfg80211 snd_seq snd_hda_intel snd_hda_codec
eeprom_93cx6 snd_hwdep ttm snd_pcm binfmt_misc drm_kms_helper drm
snd_timer snd_seq_device snd soundcore i2c_algo_bit snd_page_alloc
ioatdma i7core_edac edac_core dca lp parport usb_storage usbhid hid
uas e1000e ahci libahci
[   88.517347] CPU 15
[   88.517349] Modules linked in: rfcomm bnep bluetooth xen_netback
xen_blkback xen_evtchn ip6table_filter xenfs ip6_tables ipt_MASQUERADE
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp
iptable_filter ip_tables x_tables bridge stp parport_pc ppdev nfs arc4
lockd rt2800pci rt2800lib crc_ccitt fscache rt2x00pci rt2x00lib
auth_rpcgss nfs_acl sunrpc mac80211 psmouse snd_hda_codec_hdmi
serio_raw radeon snd_seq_midi snd_rawmidi snd_hda_codec_realtek
snd_seq_midi_event cfg80211 snd_seq snd_hda_intel snd_hda_codec
eeprom_93cx6 snd_hwdep ttm snd_pcm binfmt_misc drm_kms_helper drm
snd_timer snd_seq_device snd soundcore i2c_algo_bit snd_page_alloc
ioatdma i7core_edac edac_core dca lp parport usb_storage usbhid hid
uas e1000e ahci libahci
[   88.517418]
[   88.517421] Pid: 2729, comm: perf Not tainted
3.2.0-rc2-00089-gd3507af #3 Supermicro X8DAL/X8DAL
[   88.517426] RIP: e030:[<ffffffff81085985>]  [<ffffffff81085985>]
generic_exec_single+0x7a/0x8f
[   88.517437] RSP: e02b:ffff880b76163a68  EFLAGS: 00000202
[   88.517440] RAX: 0000000000000100 RBX: ffff880b76163ac0 RCX: 0000000000000018
[   88.517442] RDX: 0000000000000018 RSI: 0000000000000100 RDI: 0000000000000000
[   88.517444] RBP: ffff880b76163aa8 R08: 0000000000000100 R09: ffffffff81606460
[   88.517446] R10: ffffffff810dad6c R11: ffff880b62be86c8 R12: 0000000000000017
[   88.517448] R13: ffff880b9f28c780 R14: ffff880b9f28c790 R15: 0000000000000001
[   88.517453] FS:  00007f214a27a720(0000) GS:ffff880b9e1d8000(0000)
knlGS:0000000000000000
[   88.517455] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[   88.517457] CR2: 00007f2146bc4006 CR3: 0000000001a05000 CR4: 0000000000002660
[   88.517460] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   88.517462] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   88.517464] Process perf (pid: 2729, threadinfo ffff880b76162000,
task ffff880b62be8000)
[   88.517466] Stack:
[   88.517514]  ffffffff81007212 ffff880b9f28c780 ffffffff810dad6c
0000000000000017
[   88.517521]  ffffffff810d9f29 0000000000000001 ffff880b76163b28
ffff880b76163ac0
[   88.517527]  ffff880b76163b18 ffffffff81085a86 ffffffff81007212
ffff880b9f28c780
[   88.517533] Call Trace:
[   88.517585]  [<ffffffff81007212>] ? check_events+0x12/0x20
[   88.517591]  [<ffffffff810dad6c>] ? perf_event_release_kernel+0x5e/0x96
[   88.517595]  [<ffffffff810d9f29>] ? perf_exclude_event.part.24+0x36/0x36
[   88.517599]  [<ffffffff81085a86>] smp_call_function_single+0xec/0xfd
[   88.517602]  [<ffffffff81007212>] ? check_events+0x12/0x20
[   88.517605]  [<ffffffff810d9f29>] ? perf_exclude_event.part.24+0x36/0x36
[   88.517612]  [<ffffffff810d89e7>] cpu_function_call+0x34/0x39
[   88.517615]  [<ffffffff810d9a66>] ? event_sched_out.isra.13+0xd0/0xd0
[   88.517619]  [<ffffffff810d9899>] perf_remove_from_context+0x67/0xbe
[   88.517622]  [<ffffffff810dad8a>] perf_event_release_kernel+0x7c/0x96
[   88.517625]  [<ffffffff810dae27>] perf_release+0x83/0x8b
[   88.517630]  [<ffffffff8113023b>] fput+0x114/0x1b5
[   88.517634]  [<ffffffff810071ff>] ? xen_restore_fl_direct_reloc+0x4/0x4
[   88.517640]  [<ffffffff8112d373>] filp_close+0x71/0x7d
[   88.517645]  [<ffffffff810557f2>] put_files_struct+0x78/0xd6
[   88.517648]  [<ffffffff810558eb>] exit_files+0x49/0x51
[   88.517651]  [<ffffffff81055e2d>] do_exit+0x271/0x768
[   88.517655]  [<ffffffff810071ff>] ? xen_restore_fl_direct_reloc+0x4/0x4
[   88.517659]  [<ffffffff8107e2cc>] ? arch_local_irq_restore+0xb/0xd
[   88.517662]  [<ffffffff810565d9>] do_group_exit+0x88/0xb6
[   88.517668]  [<ffffffff81063da9>] get_signal_to_deliver+0x485/0x4b8
[   88.517674]  [<ffffffff8113df39>] ? __pollwait+0xcc/0xcc
[   88.517680]  [<ffffffff8100eefc>] do_signal+0x3e/0x5f2
[   88.517684]  [<ffffffff8100f4f5>] do_notify_resume+0x2c/0x6b
[   88.517689]  [<ffffffff8128a549>] ? lockdep_sys_exit_thunk+0x35/0x67
[   88.517695]  [<ffffffff8150619e>] int_signal+0x12/0x17
[   88.517697] Code: 49 89 5d 08 4c 89 2b 48 89 53 08 48 89 1a e8 f5
9a 47 00 4c 39 6d c8 75 09 44 89 e7 ff 15 74 1b 99 00 45 85 ff 75 04
eb 08 f3 90 <f6> 43 20 01 75 f8 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f
5d c3
[   88.519864] Call Trace:
[   88.519867]  [<ffffffff81007212>] ? check_events+0x12/0x20
[   88.519870]  [<ffffffff810dad6c>] ? perf_event_release_kernel+0x5e/0x96
[   88.519874]  [<ffffffff810d9f29>] ? perf_exclude_event.part.24+0x36/0x36
[   88.519877]  [<ffffffff81085a86>] smp_call_function_single+0xec/0xfd
[   88.519881]  [<ffffffff81007212>] ? check_events+0x12/0x20
[   88.519884]  [<ffffffff810d9f29>] ? perf_exclude_event.part.24+0x36/0x36
[   88.519887]  [<ffffffff810d89e7>] cpu_function_call+0x34/0x39
[   88.519891]  [<ffffffff810d9a66>] ? event_sched_out.isra.13+0xd0/0xd0
[   88.519894]  [<ffffffff810d9899>] perf_remove_from_context+0x67/0xbe
[   88.519897]  [<ffffffff810dad8a>] perf_event_release_kernel+0x7c/0x96
[   88.519900]  [<ffffffff810dae27>] perf_release+0x83/0x8b
[   88.519903]  [<ffffffff8113023b>] fput+0x114/0x1b5
[   88.519907]  [<ffffffff810071ff>] ? xen_restore_fl_direct_reloc+0x4/0x4
[   88.519910]  [<ffffffff8112d373>] filp_close+0x71/0x7d
[   88.519913]  [<ffffffff810557f2>] put_files_struct+0x78/0xd6
[   88.519917]  [<ffffffff810558eb>] exit_files+0x49/0x51
[   88.519920]  [<ffffffff81055e2d>] do_exit+0x271/0x768
[   88.519923]  [<ffffffff810071ff>] ? xen_restore_fl_direct_reloc+0x4/0x4
[   88.519926]  [<ffffffff8107e2cc>] ? arch_local_irq_restore+0xb/0xd
[   88.519930]  [<ffffffff810565d9>] do_group_exit+0x88/0xb6
[   88.519933]  [<ffffffff81063da9>] get_signal_to_deliver+0x485/0x4b8
[   88.519936]  [<ffffffff8113df39>] ? __pollwait+0xcc/0xcc
[   88.519940]  [<ffffffff8100eefc>] do_signal+0x3e/0x5f2
[   88.519943]  [<ffffffff8100f4f5>] do_notify_resume+0x2c/0x6b
[   88.519947]  [<ffffffff8128a549>] ? lockdep_sys_exit_thunk+0x35/0x67
[   88.519950]  [<ffffffff8150619e>] int_signal+0x12/0x17
[  116.525415] BUG: soft lockup - CPU#15 stuck for 22s! [perf:2729]
[  116.525482] Modules linked in: rfcomm bnep bluetooth xen_netback
xen_blkback xen_evtchn ip6table_filter xenfs ip6_tables ipt_MASQUERADE
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp
iptable_filter ip_tables x_tables bridge stp parport_pc ppdev nfs arc4
lockd rt2800pci rt2800lib crc_ccitt fscache rt2x00pci rt2x00lib
auth_rpcgss nfs_acl sunrpc mac80211 psmouse snd_hda_codec_hdmi
serio_raw radeon snd_seq_midi snd_rawmidi snd_hda_codec_realtek
snd_seq_midi_event cfg80211 snd_seq snd_hda_intel snd_hda_codec
eeprom_93cx6 snd_hwdep ttm snd_pcm binfmt_misc drm_kms_helper drm
snd_timer snd_seq_device snd soundcore i2c_algo_bit snd_page_alloc
ioatdma i7core_edac edac_core dca lp parport usb_storage usbhid hid
uas e1000e ahci libahci
[  116.525560] CPU 15
[  116.525562] Modules linked in: rfcomm bnep bluetooth xen_netback
xen_blkback xen_evtchn ip6table_filter xenfs ip6_tables ipt_MASQUERADE
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp
iptable_filter ip_tables x_tables bridge stp parport_pc ppdev nfs arc4
lockd rt2800pci rt2800lib crc_ccitt fscache rt2x00pci rt2x00lib
auth_rpcgss nfs_acl sunrpc mac80211 psmouse snd_hda_codec_hdmi
serio_raw radeon snd_seq_midi snd_rawmidi snd_hda_codec_realtek
snd_seq_midi_event cfg80211 snd_seq snd_hda_intel snd_hda_codec
eeprom_93cx6 snd_hwdep ttm snd_pcm binfmt_misc drm_kms_helper drm
snd_timer snd_seq_device snd soundcore i2c_algo_bit snd_page_alloc
ioatdma i7core_edac edac_core dca lp parport usb_storage usbhid hid
uas e1000e ahci libahci
[  116.525630]
[  116.525633] Pid: 2729, comm: perf Not tainted
3.2.0-rc2-00089-gd3507af #3 Supermicro X8DAL/X8DAL
[  116.525637] RIP: e030:[<ffffffff81085983>]  [<ffffffff81085983>]
generic_exec_single+0x78/0x8f
[  116.525643] RSP: e02b:ffff880b76163a68  EFLAGS: 00000202
[  116.525645] RAX: 0000000000000100 RBX: ffff880b76163ac0 RCX: 0000000000000018
[  116.525647] RDX: 0000000000000018 RSI: 0000000000000100 RDI: 0000000000000000
[  116.525650] RBP: ffff880b76163aa8 R08: 0000000000000100 R09: ffffffff81606460
[  116.525652] R10: ffffffff810dad6c R11: ffff880b62be86c8 R12: 0000000000000017
[  116.525654] R13: ffff880b9f28c780 R14: ffff880b9f28c790 R15: 0000000000000001
[  116.525658] FS:  00007f214a27a720(0000) GS:ffff880b9e1d8000(0000)
knlGS:0000000000000000
[  116.525661] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[  116.525663] CR2: 00007f2146bc4006 CR3: 0000000001a05000 CR4: 0000000000002660
[  116.525665] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  116.525667] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  116.525670] Process perf (pid: 2729, threadinfo ffff880b76162000,
task ffff880b62be8000)
[  116.525672] Stack:
[  116.525719]  ffffffff81007212 ffff880b9f28c780 ffffffff810dad6c
0000000000000017
[  116.525726]  ffffffff810d9f29 0000000000000001 ffff880b76163b28
ffff880b76163ac0
[  116.525731]  ffff880b76163b18 ffffffff81085a86 ffffffff81007212
ffff880b9f28c780
[  116.525737] Call Trace:
[  116.525788]  [<ffffffff81007212>] ? check_events+0x12/0x20
[  116.525792]  [<ffffffff810dad6c>] ? perf_event_release_kernel+0x5e/0x96
[  116.525795]  [<ffffffff810d9f29>] ? perf_exclude_event.part.24+0x36/0x36
[  116.525799]  [<ffffffff81085a86>] smp_call_function_single+0xec/0xfd
[  116.525802]  [<ffffffff81007212>] ? check_events+0x12/0x20
[  116.525805]  [<ffffffff810d9f29>] ? perf_exclude_event.part.24+0x36/0x36
[  116.525809]  [<ffffffff810d89e7>] cpu_function_call+0x34/0x39
[  116.525812]  [<ffffffff810d9a66>] ? event_sched_out.isra.13+0xd0/0xd0
[  116.525816]  [<ffffffff810d9899>] perf_remove_from_context+0x67/0xbe
[  116.525819]  [<ffffffff810dad8a>] perf_event_release_kernel+0x7c/0x96
[  116.525822]  [<ffffffff810dae27>] perf_release+0x83/0x8b
[  116.525826]  [<ffffffff8113023b>] fput+0x114/0x1b5
[  116.525829]  [<ffffffff810071ff>] ? xen_restore_fl_direct_reloc+0x4/0x4
[  116.525833]  [<ffffffff8112d373>] filp_close+0x71/0x7d
[  116.525836]  [<ffffffff810557f2>] put_files_struct+0x78/0xd6
[  116.525839]  [<ffffffff810558eb>] exit_files+0x49/0x51
[  116.525842]  [<ffffffff81055e2d>] do_exit+0x271/0x768
[  116.525846]  [<ffffffff810071ff>] ? xen_restore_fl_direct_reloc+0x4/0x4
[  116.525849]  [<ffffffff8107e2cc>] ? arch_local_irq_restore+0xb/0xd
[  116.525853]  [<ffffffff810565d9>] do_group_exit+0x88/0xb6
[  116.525856]  [<ffffffff81063da9>] get_signal_to_deliver+0x485/0x4b8
[  116.525860]  [<ffffffff8113df39>] ? __pollwait+0xcc/0xcc
[  116.525864]  [<ffffffff8100eefc>] do_signal+0x3e/0x5f2
[  116.525867]  [<ffffffff8100f4f5>] do_notify_resume+0x2c/0x6b
[  116.525871]  [<ffffffff8128a549>] ? lockdep_sys_exit_thunk+0x35/0x67
[  116.525874]  [<ffffffff8150619e>] int_signal+0x12/0x17
[  116.525876] Code: 55 08 49 89 5d 08 4c 89 2b 48 89 53 08 48 89 1a
e8 f5 9a 47 00 4c 39 6d c8 75 09 44 89 e7 ff 15 74 1b 99 00 45 85 ff
75 04 eb 08 <f3> 90 f6 43 20 01 75 f8 48 83 c4 18 5b 41 5c 41 5d 41 5e
41 5f
[  116.528048] Call Trace:
[  116.528051]  [<ffffffff81007212>] ? check_events+0x12/0x20
[  116.528054]  [<ffffffff810dad6c>] ? perf_event_release_kernel+0x5e/0x96
[  116.528057]  [<ffffffff810d9f29>] ? perf_exclude_event.part.24+0x36/0x36
[  116.528061]  [<ffffffff81085a86>] smp_call_function_single+0xec/0xfd
[  116.528064]  [<ffffffff81007212>] ? check_events+0x12/0x20
[  116.528067]  [<ffffffff810d9f29>] ? perf_exclude_event.part.24+0x36/0x36
[  116.528071]  [<ffffffff810d89e7>] cpu_function_call+0x34/0x39
[  116.528074]  [<ffffffff810d9a66>] ? event_sched_out.isra.13+0xd0/0xd0
[  116.528077]  [<ffffffff810d9899>] perf_remove_from_context+0x67/0xbe
[  116.528081]  [<ffffffff810dad8a>] perf_event_release_kernel+0x7c/0x96
[  116.528084]  [<ffffffff810dae27>] perf_release+0x83/0x8b
[  116.528087]  [<ffffffff8113023b>] fput+0x114/0x1b5
[  116.528090]  [<ffffffff810071ff>] ? xen_restore_fl_direct_reloc+0x4/0x4
[  116.528094]  [<ffffffff8112d373>] filp_close+0x71/0x7d
[  116.528097]  [<ffffffff810557f2>] put_files_struct+0x78/0xd6
[  116.528100]  [<ffffffff810558eb>] exit_files+0x49/0x51
[  116.528103]  [<ffffffff81055e2d>] do_exit+0x271/0x768
[  116.528106]  [<ffffffff810071ff>] ? xen_restore_fl_direct_reloc+0x4/0x4
[  116.528110]  [<ffffffff8107e2cc>] ? arch_local_irq_restore+0xb/0xd
[  116.528113]  [<ffffffff810565d9>] do_group_exit+0x88/0xb6
[  116.528116]  [<ffffffff81063da9>] get_signal_to_deliver+0x485/0x4b8
[  116.528120]  [<ffffffff8113df39>] ? __pollwait+0xcc/0xcc
[  116.528123]  [<ffffffff8100eefc>] do_signal+0x3e/0x5f2
[  116.528127]  [<ffffffff8100f4f5>] do_notify_resume+0x2c/0x6b
[  116.528130]  [<ffffffff8128a549>] ? lockdep_sys_exit_thunk+0x35/0x67
[  116.528133]  [<ffffffff8150619e>] int_signal+0x12/0x17
[  122.165408] INFO: rcu_sched detected stall on CPU 15 (t=15000 jiffies)
[  122.165473] sending NMI to all CPUs:
[  122.165483] INFO: rcu_sched detected stall on CPU 23 (t=15000 jiffies)


I did a bit of manual bisection (based on tags) and noticed the issue
was introduced sometime between v3.0 and v3.1-rc1. This is where the
bisection took me:

# bad: [322a8b034003c0d46d39af85bf24fee27b902f48] Linux 3.1-rc1
# good: [02f8c6aee8df3cdc935e9bdd4f2d020306035dbe] Linux 3.0
git bisect start 'v3.1-rc1' 'v3.0'
# bad: [0003230e8200699860f0b10af524dc47bf8aecad] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6
git bisect bad 0003230e8200699860f0b10af524dc47bf8aecad
# good: [72f96e0e38d7e29ba16dcfd824ecaebe38b8293e] Merge branch
'for-linus-core' of
git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending
git bisect good 72f96e0e38d7e29ba16dcfd824ecaebe38b8293e
# bad: [f5fc87905ea075a0b14878086fd4fe38be128844] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap
git bisect bad f5fc87905ea075a0b14878086fd4fe38be128844
# bad: [f5fc87905ea075a0b14878086fd4fe38be128844] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap
git bisect bad f5fc87905ea075a0b14878086fd4fe38be128844
# bad: [bbd9d6f7fbb0305c9a592bf05a32e87eb364a4ff] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6
git bisect bad bbd9d6f7fbb0305c9a592bf05a32e87eb364a4ff
# bad: [4d4abdcb1dee03a4f9d6d2021622ed07e14dfd17] Merge branch
'perf-core-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad 4d4abdcb1dee03a4f9d6d2021622ed07e14dfd17
# bad: [190b57fcb9c5fed5414935a174094f534fc510bc] perf probe: Add
probed module in front of function
git bisect bad 190b57fcb9c5fed5414935a174094f534fc510bc
# bad: [26ca5c11fb45ae2b2ac7e3574b8db6b3a3c7d350] perf: export
perf_event_refresh() to modules
git bisect bad 26ca5c11fb45ae2b2ac7e3574b8db6b3a3c7d350
# bad: [26ca5c11fb45ae2b2ac7e3574b8db6b3a3c7d350] perf: export
perf_event_refresh() to modules
git bisect bad 26ca5c11fb45ae2b2ac7e3574b8db6b3a3c7d350
# good: [b0af8dfdd67699e25083478c63eedef2e72ebd85] Linux 3.0-rc5
git bisect good b0af8dfdd67699e25083478c63eedef2e72ebd85
# good: [b0af8dfdd67699e25083478c63eedef2e72ebd85] Linux 3.0-rc5
git bisect good b0af8dfdd67699e25083478c63eedef2e72ebd85
# good: [af07ce3e77d3b24ab1d71fcc5833d41800f23b2b] Merge branch
'tip/perf/core-2' of
git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace
into perf/core
git bisect good af07ce3e77d3b24ab1d71fcc5833d41800f23b2b
# good: [af07ce3e77d3b24ab1d71fcc5833d41800f23b2b] Merge branch
'tip/perf/core-2' of
git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace
into perf/core
git bisect good af07ce3e77d3b24ab1d71fcc5833d41800f23b2b
# good: [1880c4ae182afb5650c5678949ecfe7ff66a724e] perf, x86: Add
hw_watchdog_set_attr() in a sake of nmi-watchdog on P4
git bisect good 1880c4ae182afb5650c5678949ecfe7ff66a724e
# bad: [ee89cbc2d48150c7c0e9f2aaac00afde99af098c] perf_events: Add
Intel Sandy Bridge offcore_response low-level support
git bisect bad ee89cbc2d48150c7c0e9f2aaac00afde99af098c
# bad: [a7ac67ea021b4603095d2aa458bc41641238f22c] perf: Remove the
perf_output_begin(.sample) argument
git bisect bad a7ac67ea021b4603095d2aa458bc41641238f22c
# bad: [a8b0ca17b80e92faab46ee7179ba9e99ccb61233] perf: Remove the nmi
parameter from the swevent and overflow interface
git bisect bad a8b0ca17b80e92faab46ee7179ba9e99ccb61233


So, it looks like somehow this broke things:

commit a8b0ca17b80e92faab46ee7179ba9e99ccb61233
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Mon Jun 27 14:41:57 2011 +0200

    perf: Remove the nmi parameter from the swevent and overflow interface

    The nmi parameter indicated if we could do wakeups from the current
    context, if not, we would set some state and self-IPI and let the
    resulting interrupt do the wakeup.

    For the various event classes:

      - hardware: nmi=0; PMI is in fact an NMI or we run irq_work_run from
        the PMI-tail (ARM etc.)
      - tracepoint: nmi=0; since tracepoint could be from NMI context.
      - software: nmi=[0,1]; some, like the schedule thing cannot
        perform wakeups, and hence need 0.

    As one can see, there is very little nmi=1 usage, and the down-side of
    not using it is that on some platforms some software events can have a
    jiffy delay in wakeup (when arch_irq_work_raise isn't implemented).

    The up-side however is that we can remove the nmi parameter and save a
    bunch of conditionals in fast paths.

    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Michael Cree <mcree@orcon.net.nz>
    Cc: Will Deacon <will.deacon@arm.com>
    Cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
    Cc: Anton Blanchard <anton@samba.org>
    Cc: Eric B Munson <emunson@mgebm.net>
    Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
    Cc: Paul Mundt <lethal@linux-sh.org>
    Cc: David S. Miller <davem@davemloft.net>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Jason Wessel <jason.wessel@windriver.com>
    Cc: Don Zickus <dzickus@redhat.com>
    Link: http://lkml.kernel.org/n/tip-agjev8eu666tvknpb3iaj0fg@git.kernel.org
    Signed-off-by: Ingo Molnar <mingo@elte.hu>


Relevant maintainers CC'd. Any ideas, folks?
