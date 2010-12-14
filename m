Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab0LNJkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 04:40:52 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40635 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311Ab0LNJkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 04:40:47 -0500
Date: Tue, 14 Dec 2010 10:40:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Deucher <alexdeucher@gmail.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: BUG: sleeping function called from invalid context at
 arch/x86/mm/fault.c:1081
Message-ID: <20101214094040.GA2790@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alex Deucher <alexdeucher@gmail.com>, x86@kernel.org,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The oops below happened today with v2.6.37-rc5-62-g6313e3c with the
following hpet oneline fix which should be unrelated (tglx has an
equivalent one in -tip/urgent already):

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ae03cab..0388a70 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -408,7 +408,7 @@ static int hpet_next_event(unsigned long delta,
         */
        res = (s32)(cnt - hpet_readl(HPET_COUNTER));
 
-       return res < 8 ? -ETIME : 0;
+       return res < 128 ? -ETIME : 0;
 }
 
 static void hpet_legacy_set_mode(enum clock_event_mode mode,
--

SysRq was still functioning though and I was able to sync+reboot
therefore the oops is from /var/log/syslog. Any ideas?

--
Dec 14 10:17:26 liondog kernel: [12312.144385] BUG: sleeping function called from invalid context at arch/x86/mm/fault.c:1081
Dec 14 10:17:26 liondog kernel: [12312.144390] in_atomic(): 0, irqs_disabled(): 1, pid: 1930, name: Xorg
Dec 14 10:17:26 liondog kernel: [12312.144393] no locks held by Xorg/1930.
Dec 14 10:17:26 liondog kernel: [12312.144394] irq event stamp: 959429057
Dec 14 10:17:26 liondog kernel: [12312.144396] hardirqs last  enabled at (959429057): [<ffffffff81021d4e>] do_page_fault+0xa5/0x3a7
Dec 14 10:17:26 liondog kernel: [12312.144402] hardirqs last disabled at (959429056): [<ffffffff8144f403>] error_sti+0x5/0x6
Dec 14 10:17:26 liondog kernel: [12312.144407] softirqs last  enabled at (959429046): [<ffffffff81041f38>] __do_softirq+0x2b4/0x304
Dec 14 10:17:26 liondog kernel: [12312.144412] softirqs last disabled at (959429021): [<ffffffff8100324c>] call_softirq+0x1c/0x28
Dec 14 10:17:26 liondog kernel: [12312.144417] Pid: 1930, comm: Xorg Not tainted 2.6.37-rc5-00063-g779049f #1
Dec 14 10:17:26 liondog kernel: [12312.144419] Call Trace:
Dec 14 10:17:26 liondog kernel: [12312.144424]  [<ffffffff81068dc0>] ? print_irqtrace_events+0xd0/0xd4
Dec 14 10:17:26 liondog kernel: [12312.144429]  [<ffffffff81030cc8>] __might_sleep+0x11c/0x120
Dec 14 10:17:26 liondog kernel: [12312.144432]  [<ffffffff81021e69>] do_page_fault+0x1c0/0x3a7
Dec 14 10:17:26 liondog kernel: [12312.144436]  [<ffffffff8144b861>] ? schedule+0xafa/0xb85
Dec 14 10:17:26 liondog kernel: [12312.144438]  [<ffffffff8144f403>] ? error_sti+0x5/0x6
Dec 14 10:17:26 liondog kernel: [12312.144441]  [<ffffffff81069fa2>] ? trace_hardirqs_off_caller+0x1f/0x10e
Dec 14 10:17:26 liondog kernel: [12312.144444]  [<ffffffff8144dbfb>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Dec 14 10:17:26 liondog kernel: [12312.144448]  [<ffffffff8124f16c>] ? radeon_cp_idle+0x0/0xa6
Dec 14 10:17:26 liondog kernel: [12312.144451]  [<ffffffff8144f21f>] page_fault+0x1f/0x30
Dec 14 10:17:26 liondog kernel: [12312.144454]  [<ffffffff8124f16c>] ? radeon_cp_idle+0x0/0xa6
Dec 14 10:17:26 liondog kernel: [12312.144457]  [<ffffffff8106d1da>] ? __lock_acquire+0x19d/0x173f
Dec 14 10:17:26 liondog kernel: [12312.144460]  [<ffffffff81069d4a>] ? put_lock_stats+0xe/0x29
Dec 14 10:17:26 liondog kernel: [12312.144464]  [<ffffffff8144c1ea>] ? __mutex_unlock_slowpath+0x105/0x129
Dec 14 10:17:26 liondog kernel: [12312.144467]  [<ffffffff8106b29d>] ? trace_hardirqs_on+0xd/0xf
Dec 14 10:17:26 liondog kernel: [12312.144469]  [<ffffffff81021e19>] ? do_page_fault+0x170/0x3a7
Dec 14 10:17:26 liondog kernel: [12312.144472]  [<ffffffff8106e8c9>] lock_acquire+0x14d/0x192
Dec 14 10:17:26 liondog kernel: [12312.144475]  [<ffffffff81021e19>] ? do_page_fault+0x170/0x3a7
Dec 14 10:17:26 liondog kernel: [12312.144477]  [<ffffffff8124f16c>] ? radeon_cp_idle+0x0/0xa6
Dec 14 10:17:26 liondog kernel: [12312.144481]  [<ffffffff8105ea37>] down_read_trylock+0x56/0x5f
Dec 14 10:17:26 liondog kernel: [12312.144484]  [<ffffffff81021e19>] ? do_page_fault+0x170/0x3a7
Dec 14 10:17:26 liondog kernel: [12312.144486]  [<ffffffff81021e19>] do_page_fault+0x170/0x3a7
Dec 14 10:17:26 liondog kernel: [12312.144490]  [<ffffffff810f6159>] ? do_vfs_ioctl+0x4d0/0x51f
Dec 14 10:17:26 liondog kernel: [12312.144493]  [<ffffffff8144f403>] ? error_sti+0x5/0x6
Dec 14 10:17:26 liondog kernel: [12312.144495]  [<ffffffff8144dbfb>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Dec 14 10:17:26 liondog kernel: [12312.144498]  [<ffffffff8144f21f>] page_fault+0x1f/0x30
Dec 14 10:17:26 liondog kernel: [12312.144509] BUG: unable to handle kernel paging request at 00000110850fc085
Dec 14 10:17:26 liondog kernel: [12312.144512] IP: [<ffffffff8106d1da>] __lock_acquire+0x19d/0x173f
Dec 14 10:17:26 liondog kernel: [12312.144516] PGD 0 
Dec 14 10:17:26 liondog kernel: [12312.144518] Oops: 0000 [#1] PREEMPT SMP 
Dec 14 10:17:26 liondog kernel: [12312.144521] last sysfs file: /sys/devices/system/cpu/cpu3/cpufreq/scaling_cur_freq
Dec 14 10:17:26 liondog kernel: [12312.144524] CPU 1 
Dec 14 10:17:26 liondog kernel: [12312.144526] Modules linked in: tun ip6table_filter ip6_tables iptable_filter ip_tables x_tables powernow_k8 mperf cpufreq_ondemand cpufreq_powersave cpufreq_userspace cpufreq_conservative cpufreq_stats freq_table binfmt_misc kvm_amd kvm fuse ipv6 vfat fat 8250_pnp 8250 serial_core ohci_hcd edac_core k10temp
Dec 14 10:17:26 liondog kernel: [12312.144548] 
Dec 14 10:17:26 liondog kernel: [12312.144551] Pid: 1930, comm: Xorg Not tainted 2.6.37-rc5-00063-g779049f #1 M3A78 PRO/System Product Name
Dec 14 10:17:26 liondog kernel: [12312.144553] RIP: 0010:[<ffffffff8106d1da>]  [<ffffffff8106d1da>] __lock_acquire+0x19d/0x173f
Dec 14 10:17:26 liondog kernel: [12312.144557] RSP: 0000:ffff88022d1b3cb8  EFLAGS: 00013087
Dec 14 10:17:26 liondog kernel: [12312.144559] RAX: ffffffff819bb000 RBX: ffff88022d09da00 RCX: ffffffff821c6b40
Dec 14 10:17:26 liondog kernel: [12312.144561] RDX: 00000110850fc085 RSI: 0000000000000000 RDI: 8000000000000000
Dec 14 10:17:26 liondog kernel: [12312.144563] RBP: ffff88022d1b3d88 R08: 0000000000000002 R09: 0000000000000000
Dec 14 10:17:26 liondog kernel: [12312.144564] R10: ffffffff8124f16c R11: 0000000000001128 R12: ffff88022f445b90
Dec 14 10:17:26 liondog kernel: [12312.144566] R13: 0000000000000000 R14: 00000110850fc085 R15: 0000000000000002
Dec 14 10:17:26 liondog kernel: [12312.144569] FS:  00007f2fe2941700(0000) GS:ffff8800cf000000(0000) knlGS:00000000f6a4c740
Dec 14 10:17:26 liondog kernel: [12312.144571] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Dec 14 10:17:26 liondog kernel: [12312.144572] CR2: 00000110850fc085 CR3: 000000022b965000 CR4: 00000000000006e0
Dec 14 10:17:26 liondog kernel: [12312.144574] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec 14 10:17:26 liondog kernel: [12312.144576] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Dec 14 10:17:26 liondog kernel: [12312.144578] Process Xorg (pid: 1930, threadinfo ffff88022d1b2000, task ffff88022f445b90)
Dec 14 10:17:26 liondog kernel: [12312.144580] Stack:
Dec 14 10:17:26 liondog kernel: [12312.144581]  0000000000000046 0000000000000001 ffff88022d1b3ce8 0000000081032b75
Dec 14 10:17:26 liondog kernel: [12312.144585]  ffff880200000001 0000000000000001 ffff88022d1b3cf8 ffffffff81069d4a
Dec 14 10:17:26 liondog kernel: [12312.144589]  ffff88022d1b3d18 ffff88022f445b90 ffff88022f445b90 ffffffff8144c1ea
Dec 14 10:17:26 liondog kernel: [12312.144593] Call Trace:
Dec 14 10:17:26 liondog kernel: [12312.144596]  [<ffffffff81069d4a>] ? put_lock_stats+0xe/0x29
Dec 14 10:17:26 liondog kernel: [12312.144599]  [<ffffffff8144c1ea>] ? __mutex_unlock_slowpath+0x105/0x129
Dec 14 10:17:26 liondog kernel: [12312.144602]  [<ffffffff8106b29d>] ? trace_hardirqs_on+0xd/0xf
Dec 14 10:17:26 liondog kernel: [12312.144605]  [<ffffffff81021e19>] ? do_page_fault+0x170/0x3a7
Dec 14 10:17:26 liondog kernel: [12312.144608]  [<ffffffff8106e8c9>] lock_acquire+0x14d/0x192
Dec 14 10:17:26 liondog kernel: [12312.144610]  [<ffffffff81021e19>] ? do_page_fault+0x170/0x3a7
Dec 14 10:17:26 liondog kernel: [12312.144613]  [<ffffffff8124f16c>] ? radeon_cp_idle+0x0/0xa6
Dec 14 10:17:26 liondog kernel: [12312.144616]  [<ffffffff8105ea37>] down_read_trylock+0x56/0x5f
Dec 14 10:17:26 liondog kernel: [12312.144619]  [<ffffffff81021e19>] ? do_page_fault+0x170/0x3a7
Dec 14 10:17:26 liondog kernel: [12312.144621]  [<ffffffff81021e19>] do_page_fault+0x170/0x3a7
Dec 14 10:17:26 liondog kernel: [12312.144624]  [<ffffffff810f6159>] ? do_vfs_ioctl+0x4d0/0x51f
Dec 14 10:17:26 liondog kernel: [12312.144627]  [<ffffffff8144f403>] ? error_sti+0x5/0x6
Dec 14 10:17:26 liondog kernel: [12312.144630]  [<ffffffff8144dbfb>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Dec 14 10:17:26 liondog kernel: [12312.144632]  [<ffffffff8144f21f>] page_fault+0x1f/0x30
Dec 14 10:17:26 liondog kernel: [12312.144634] Code: 01 00 00 74 33 80 3d 25 1b c7 00 01 74 2a be a6 02 00 00 48 c7 c7 d1 8b 5e 81 e8 af dc fc ff c6 05 0b 1b c7 00 01 eb 10 49 89 d6 <49> 8b 16 49 39 ce 0f 18 0a 75 bc eb 09 4d 85 f6 0f 85 2e 03 00 
Dec 14 10:17:26 liondog kernel: [12312.144671] RIP  [<ffffffff8106d1da>] __lock_acquire+0x19d/0x173f
Dec 14 10:17:26 liondog kernel: [12312.144674]  RSP <ffff88022d1b3cb8>
Dec 14 10:17:26 liondog kernel: [12312.144676] CR2: 00000110850fc085
Dec 14 10:17:26 liondog kernel: [12312.144678] ---[ end trace b215ad3559f4bac0 ]---
Dec 14 10:17:26 liondog kernel: [12312.218747] general protection fault: 0000 [#2] PREEMPT SMP 
Dec 14 10:17:26 liondog kernel: [12312.218754] last sysfs file: /sys/devices/system/cpu/cpu3/cpufreq/scaling_cur_freq
Dec 14 10:17:26 liondog kernel: [12312.218757] CPU 1 
Dec 14 10:17:26 liondog kernel: [12312.218758] Modules linked in: tun ip6table_filter ip6_tables iptable_filter ip_tables x_tables powernow_k8 mperf cpufreq_ondemand cpufreq_powersave cpufreq_userspace cpufreq_conservative cpufreq_stats freq_table binfmt_misc kvm_amd kvm fuse ipv6 vfat fat 8250_pnp 8250 serial_core ohci_hcd edac_core k10temp
Dec 14 10:17:26 liondog kernel: [12312.218783] 
Dec 14 10:17:26 liondog kernel: [12312.218787] Pid: 1930, comm: Xorg Tainted: G      D     2.6.37-rc5-00063-g779049f #1 M3A78 PRO/System Product Name
Dec 14 10:17:26 liondog kernel: [12312.218789] RIP: 0010:[<ffffffff8124bee0>]  [<ffffffff8124bee0>] radeon_read_ring_rptr+0x30/0x34
Dec 14 10:17:26 liondog kernel: [12312.218797] RSP: 0000:ffff88022d1b3730  EFLAGS: 00013202
Dec 14 10:17:26 liondog kernel: [12312.218799] RAX: ffff88022a8e55d8 RBX: ffff88022fc252d0 RCX: ffffc90011380000
Dec 14 10:17:26 liondog kernel: [12312.218801] RDX: 000000000000002c RSI: 6b6b6b6b6b6b6b6b RDI: ffff88022fc252d0
Dec 14 10:17:26 liondog kernel: [12312.218804] RBP: ffff88022d1b3730 R08: ffffffff81231039 R09: ffffea00079555a0
Dec 14 10:17:26 liondog kernel: [12312.218806] R10: ffff88022d1b3778 R11: ffff88022d1b37a8 R12: 0000000000000010
Dec 14 10:17:26 liondog kernel: [12312.218807] R13: ffff88022fc2b0d8 R14: ffff88022fc25450 R15: ffff88022fc2b2e0
Dec 14 10:17:26 liondog kernel: [12312.218810] FS:  00007f2fe2941700(0000) GS:ffff8800cf000000(0000) knlGS:00000000f6a4c740
Dec 14 10:17:26 liondog kernel: [12312.218812] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Dec 14 10:17:26 liondog kernel: [12312.218814] CR2: 00000110850fc085 CR3: 00000000016a1000 CR4: 00000000000006e0
Dec 14 10:17:26 liondog kernel: [12312.218816] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec 14 10:17:26 liondog kernel: [12312.218818] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Dec 14 10:17:26 liondog kernel: [12312.218820] Process Xorg (pid: 1930, threadinfo ffff88022d1b2000, task ffff88022f445b90)
Dec 14 10:17:26 liondog kernel: [12312.218821] Stack:
Dec 14 10:17:26 liondog kernel: [12312.218823]  ffff88022d1b3740 ffffffff8124befa ffff88022d1b3758 ffffffff8124c625
Dec 14 10:17:26 liondog kernel: [12312.218827]  ffff88022fc252d0 ffff88022d1b3778 ffffffff8125e6f6 ffff88022fc252d0
Dec 14 10:17:26 liondog kernel: [12312.218832]  ffff88022fc2b0d8 ffff88022d1b3798 ffffffff8124f5b4 ffff88022fc25450
Dec 14 10:17:26 liondog kernel: [12312.218835] Call Trace:
Dec 14 10:17:26 liondog kernel: [12312.218840]  [<ffffffff8124befa>] radeon_get_ring_head+0x16/0x41
Dec 14 10:17:26 liondog kernel: [12312.218843]  [<ffffffff8124c625>] radeon_commit_ring+0x4d/0x9c
Dec 14 10:17:26 liondog kernel: [12312.218847]  [<ffffffff8125e6f6>] r600_do_cp_idle+0xf5/0x102
Dec 14 10:17:26 liondog kernel: [12312.218850]  [<ffffffff8124f5b4>] radeon_do_release+0x63/0x1ad
Dec 14 10:17:26 liondog kernel: [12312.218853]  [<ffffffff81259217>] radeon_driver_lastclose+0x52/0x5b
Dec 14 10:17:26 liondog kernel: [12312.218857]  [<ffffffff812306a3>] drm_lastclose+0x4f/0x28c
Dec 14 10:17:26 liondog kernel: [12312.218860]  [<ffffffff81231088>] drm_release+0x59d/0x5d8
Dec 14 10:17:26 liondog kernel: [12312.218865]  [<ffffffff810e859a>] fput+0x126/0x1e6
Dec 14 10:17:26 liondog kernel: [12312.218868]  [<ffffffff810e50e7>] filp_close+0x5d/0x67
Dec 14 10:17:26 liondog kernel: [12312.218873]  [<ffffffff8103ce8f>] put_files_struct+0x12d/0x254
Dec 14 10:17:26 liondog kernel: [12312.218876]  [<ffffffff8103cd89>] ? put_files_struct+0x27/0x254
Dec 14 10:17:26 liondog kernel: [12312.218880]  [<ffffffff81032b75>] ? sub_preempt_count+0xa3/0xb7
Dec 14 10:17:26 liondog kernel: [12312.218883]  [<ffffffff8103d001>] exit_files+0x4b/0x53
Dec 14 10:17:26 liondog kernel: [12312.218886]  [<ffffffff8103eb49>] do_exit+0x296/0x765
Dec 14 10:17:26 liondog kernel: [12312.218889]  [<ffffffff8103bd07>] ? kmsg_dump+0x13b/0x155
Dec 14 10:17:26 liondog kernel: [12312.218892]  [<ffffffff81006286>] oops_end+0x8e/0x93
Dec 14 10:17:26 liondog kernel: [12312.218896]  [<ffffffff8102195a>] no_context+0x1fc/0x20b
Dec 14 10:17:26 liondog kernel: [12312.218898]  [<ffffffff81021afe>] __bad_area_nosemaphore+0x195/0x1b8
Dec 14 10:17:26 liondog kernel: [12312.218901]  [<ffffffff81021b7d>] bad_area+0x47/0x4e
Dec 14 10:17:26 liondog kernel: [12312.218904]  [<ffffffff81021ec0>] do_page_fault+0x217/0x3a7
Dec 14 10:17:26 liondog kernel: [12312.218908]  [<ffffffff8144b861>] ? schedule+0xafa/0xb85
Dec 14 10:17:26 liondog kernel: [12312.218911]  [<ffffffff8144f403>] ? error_sti+0x5/0x6
Dec 14 10:17:26 liondog kernel: [12312.218915]  [<ffffffff81069fa2>] ? trace_hardirqs_off_caller+0x1f/0x10e
Dec 14 10:17:26 liondog kernel: [12312.218918]  [<ffffffff8144dbfb>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Dec 14 10:17:26 liondog kernel: [12312.218921]  [<ffffffff8124f16c>] ? radeon_cp_idle+0x0/0xa6
Dec 14 10:17:26 liondog kernel: [12312.218923]  [<ffffffff8144f21f>] page_fault+0x1f/0x30
Dec 14 10:17:26 liondog kernel: [12312.218926]  [<ffffffff8124f16c>] ? radeon_cp_idle+0x0/0xa6
Dec 14 10:17:26 liondog kernel: [12312.218930]  [<ffffffff8106d1da>] ? __lock_acquire+0x19d/0x173f
Dec 14 10:17:26 liondog kernel: [12312.218933]  [<ffffffff81069d4a>] ? put_lock_stats+0xe/0x29
Dec 14 10:17:26 liondog kernel: [12312.218936]  [<ffffffff8144c1ea>] ? __mutex_unlock_slowpath+0x105/0x129
Dec 14 10:17:26 liondog kernel: [12312.218939]  [<ffffffff8106b29d>] ? trace_hardirqs_on+0xd/0xf
Dec 14 10:17:26 liondog kernel: [12312.218942]  [<ffffffff81021e19>] ? do_page_fault+0x170/0x3a7
Dec 14 10:17:26 liondog kernel: [12312.218945]  [<ffffffff8106e8c9>] lock_acquire+0x14d/0x192
Dec 14 10:17:26 liondog kernel: [12312.218947]  [<ffffffff81021e19>] ? do_page_fault+0x170/0x3a7
Dec 14 10:17:26 liondog kernel: [12312.218950]  [<ffffffff8124f16c>] ? radeon_cp_idle+0x0/0xa6
Dec 14 10:17:26 liondog kernel: [12312.218954]  [<ffffffff8105ea37>] down_read_trylock+0x56/0x5f
Dec 14 10:17:26 liondog kernel: [12312.218957]  [<ffffffff81021e19>] ? do_page_fault+0x170/0x3a7
Dec 14 10:17:26 liondog kernel: [12312.218960]  [<ffffffff81021e19>] do_page_fault+0x170/0x3a7
Dec 14 10:17:26 liondog kernel: [12312.218964]  [<ffffffff810f6159>] ? do_vfs_ioctl+0x4d0/0x51f
Dec 14 10:17:26 liondog kernel: [12312.218967]  [<ffffffff8144f403>] ? error_sti+0x5/0x6
Dec 14 10:17:26 liondog kernel: [12312.218969]  [<ffffffff8144dbfb>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Dec 14 10:17:26 liondog kernel: [12312.218973]  [<ffffffff8144f21f>] page_fault+0x1f/0x30
Dec 14 10:17:26 liondog kernel: [12312.218975] Code: 66 66 66 90 f6 87 1a 04 00 00 08 48 8b 87 10 01 00 00 74 0a 89 f6 48 03 70 18 8b 06 eb 0f c1 ee 02 89 f6 48 c1 e6 02 48 03 70 18 <8b> 06 c9 c3 55 48 89 e5 66 66 66 66 90 83 7f 74 00 74 09 31 f6 
Dec 14 10:17:26 liondog kernel: [12312.219015] RIP  [<ffffffff8124bee0>] radeon_read_ring_rptr+0x30/0x34
Dec 14 10:17:26 liondog kernel: [12312.219018]  RSP <ffff88022d1b3730>
Dec 14 10:17:26 liondog kernel: [12312.219037] ---[ end trace b215ad3559f4bac1 ]---
Dec 14 10:17:26 liondog kernel: [12312.219039] Fixing recursive fault but reboot is needed!
Dec 14 10:18:27 liondog kernel: [12372.372053] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount show-blocked-tasks(W) dump-ftrace-buffer(Z) 
Dec 14 10:18:27 liondog kernel: [12373.142367] SysRq : Emergency Sync
Dec 14 10:18:27 liondog kernel: [12373.158134] Emergency Sync complete
Dec 14 10:18:29 liondog kernel: [12374.271069] SysRq : Emergency Remount R/O

-- 
Regards/Gruss,
    Boris.
