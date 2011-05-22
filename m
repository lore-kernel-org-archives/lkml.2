Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab1EVWWN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 18:22:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51453 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508Ab1EVWWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 18:22:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=MzvXnPmtqOAYgj8ZEg9AwFfRm+UzqIuIrFItnFHotU+L6xm/xfnlHrmMvn1ceJ/mi2
         mJDYHBHo2uplE/fg6KTEl1aOdS7GuwNYL36t+rI8O7555/M3CTGNdzD+CFjE9oRP9Pbi
         /qAPoSa+acs0wHS/dBFYTuu15/vc5kMvh74Nc=
Date: Sun, 22 May 2011 18:22:00 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@natty-nar
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Parag Warudkar <parag.lkml@gmail.com>, Fenghua Yu <fenghua.yu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Dmitry Torokhov <dtor@mail.ru>, linux-kernel@vger.kernel.org
Subject: Re: Resume Issues :Exec of NX page, Synaptics Botchup
In-Reply-To: <BANLkTik9ZmQz1A0PBC4P-9XF-hB6Ywr3uQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1105221817100.1868@natty-nar>
References: <alpine.DEB.2.02.1105221720040.2065@natty-nar> <BANLkTik9ZmQz1A0PBC4P-9XF-hB6Ywr3uQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 22 May 2011, Linus Torvalds wrote:

> 
> Hmm. The "Code: " line is just full of complete garbage, so I think
> the real issue is that you really are trying to execute data.
> 
> And that in turn seems to be because "setup_disablecpuid()" has
> actually been free'd, because it is marked as __init.
> 
> Which is fine at the initial bootup, but not so fine at resume time,
> since it was free'd long long ago by then.
> 
> And it definitely shouldn' t be called at resume time. There's
> something wrong there. That call trace is odd:
> 
>   Call Trace:
>    [<ffffffff8148a119>] ? identify_cpu+0xd8/0x2d8
>    [<ffffffff8148a32d>] identify_secondary_cpu+0x14/0x1b
>    [<ffffffff8148bf0f>] smp_store_cpu_info+0x3c/0x3e
>    [<ffffffff8148c2ef>] start_secondary+0xf7/0x1d2
> 
> because none of those should be calling "setup_disablecpuid()" at all.
> 
> Hmm. In fact, RIP is "setup_disablecpuid+0x40/0x40", ie it is one past
> the _end_ of setup_disablecpuid.
> 
> I suspect that is actually "setup_smep()" that got called, an dthat
> there was some garbage data in there that caused it to jump back a
> bit.
> 
> Does the attached patch fix it?
> 

Now I get a different call trace for the same NX error. (And Synaptics is 
completely dead this time - not attributable to the patch, it was dumb 
luck perhaps that it wored last time.)

[  101.040462] ACPI: Low-level resume complete
[  101.040540] PM: Restoring platform NVS memory
[  101.041216] Extended CMOS year: 2000
[  101.041270] Enabling non-boot CPUs ...
[  101.041422] Booting Node 0 Processor 1 APIC 0x1
[  101.041425] smpboot cpu 1: start_ip = 98000
[  101.200525] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[  101.200530] BUG: unable to handle kernel paging request at ffffffff81ad9a30
[  101.200535] IP: [<ffffffff81ad9a30>] setup_show_msr+0x30/0x30
[  101.200548] PGD 1a05067 PUD 1a09063 PMD 12c922063 PTE 8000000001ad9163
[  101.200555] Oops: 0011 [#1] SMP 
[  101.200560] CPU 1 
[  101.200562] Modules linked in: cryptd aes_x86_64 aes_generic hidp hid rfcomm kvm_intel kvm binfmt_misc bnep parport_pc dm_crypt ppdev joydev snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm arc4 snd_seq_midi snd_rawmidi iwlagn snd_seq_midi_event snd_seq mac80211 snd_timer snd_seq_device intel_ips ideapad_laptop btusb cfg80211 snd soundcore snd_page_alloc uvcvideo videodev bluetooth psmouse serio_raw sparse_keymap v4l2_compat_ioctl32 lp parport i915 drm_kms_helper drm ahci libahci atl1c i2c_algo_bit video
[  101.200617] 
[  101.200622] Pid: 0, comm: kworker/0:0 Not tainted 2.6.39-999-generic #201105210905 LENOVO 0876                            /Base Board Product Name
[  101.200629] RIP: 0010:[<ffffffff81ad9a30>]  [<ffffffff81ad9a30>] setup_show_msr+0x30/0x30
[  101.200636] RSP: 0000:ffff880131269e90  EFLAGS: 00010086
[  101.200639] RAX: 0000000000000001 RBX: ffff880137c53800 RCX: 00000000009ae3bd
[  101.200643] RDX: 00000000bfebfbff RSI: ffff880131269ea8 RDI: ffff880137c53800
[  101.200647] RBP: ffff880131269eb8 R08: 0000000000000001 R09: 0000000000000000
[  101.200650] R10: ffff880131269ea4 R11: ffff880131269ea0 R12: ffff880137c53800
[  101.200654] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  101.200658] FS:  0000000000000000(0000) GS:ffff880137c40000(0000) knlGS:0000000000000000
[  101.200662] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  101.200666] CR2: ffffffff81ad9a30 CR3: 0000000001a03000 CR4: 00000000000006a0
[  101.200669] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  101.200673] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  101.200677] Process kworker/0:0 (pid: 0, threadinfo ffff880131268000, task ffff88013125dbc0)
[  101.200680] Stack:
[  101.200683]  ffffffff815cee70 0000000000000005 009ae3bdbfebfbff 0002065501100800
[  101.200688]  ffff880137c53800 ffff880131269ed8 ffffffff815cef21 000000001cc83c30
[  101.200693]  0000000000000001 ffff880131269ee8 ffffffff815cf0c2 ffff880131269f08
[  101.200699] Call Trace:
[  101.200709]  [<ffffffff815cee70>] ? generic_identify+0x70/0x90
[  101.200715]  [<ffffffff815cef21>] identify_cpu+0x91/0x220
[  101.200720]  [<ffffffff815cf0c2>] identify_secondary_cpu+0x12/0x20
[  101.200726]  [<ffffffff815d1dfe>] smp_store_cpu_info+0x4e/0x60
[  101.200732]  [<ffffffff815d2431>] smp_callin+0xf1/0x150
[  101.200737]  [<ffffffff815d24a2>] start_secondary+0x12/0xd0
[  101.200742]  [<ffffffff815d2490>] ? smp_callin+0x150/0x150
[  101.200745] Code: 7f 00 00 a0 51 e4 31 e2 7f 00 00 e0 52 e4 31 e2 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 80 7b 04 32 e2 7f 00 00 
[  101.200772]  ea e3 31 e2 7f 00 00 a0 ea e3 31 e2 7f 00 00 20 f9 e3 31 e2 
[  101.200786] RIP  [<ffffffff81ad9a30>] setup_show_msr+0x30/0x30
[  101.200791]  RSP <ffff880131269e90>
[  101.200793] CR2: ffffffff81ad9a30
[  101.200799] ---[ end trace 325ed648e5a394e0 ]---
[  101.200804] Kernel panic - not syncing: Attempted to kill the idle task!
[  101.200808] Pid: 0, comm: kworker/0:0 Tainted: G      D     2.6.39-999-generic #201105210905
[  101.200811] Call Trace:
[  101.200818]  [<ffffffff8106138f>] panic+0xbf/0x1f0
[  101.200824]  [<ffffffff810626c8>] ? printk+0x78/0xc0
[  101.200830]  [<ffffffff810663df>] do_exit+0x3ef/0x420
[  101.200838]  [<ffffffff815dacb3>] oops_end+0xf3/0x100
[  101.200843]  [<ffffffff81ad9a30>] ? setup_show_msr+0x30/0x30
[  101.200850]  [<ffffffff8103cf2f>] no_context+0xff/0x110
[  101.200854]  [<ffffffff81ad9a30>] ? setup_show_msr+0x30/0x30
[  101.200860]  [<ffffffff8103d130>] __bad_area_nosemaphore+0x80/0x1d0
[  101.200865]  [<ffffffff8105252c>] ? resched_task+0x2c/0x80
[  101.200870]  [<ffffffff81ad9a30>] ? setup_show_msr+0x30/0x30
[  101.200875]  [<ffffffff8103d343>] bad_area_nosemaphore+0x13/0x20
[  101.200881]  [<ffffffff815dd30f>] do_page_fault+0x13f/0x520
[  101.200889]  [<ffffffff812e4e2f>] ? rb_erase+0xbf/0x140
[  101.200894]  [<ffffffff8100a89b>] ? __switch_to+0xbb/0x2f0
[  101.200900]  [<ffffffff815ce146>] ? init_scattered_cpuid_features+0x76/0x110
[  101.200905]  [<ffffffff81052d60>] ? finish_task_switch+0x70/0xe0
[  101.200910]  [<ffffffff815d9f55>] page_fault+0x25/0x30
[  101.200916]  [<ffffffff81ad9a30>] ? setup_show_msr+0x30/0x30
[  101.200921]  [<ffffffff815cee70>] ? generic_identify+0x70/0x90
[  101.200926]  [<ffffffff815cef21>] identify_cpu+0x91/0x220
[  101.200931]  [<ffffffff815cf0c2>] identify_secondary_cpu+0x12/0x20
[  101.200936]  [<ffffffff815d1dfe>] smp_store_cpu_info+0x4e/0x60
[  101.200941]  [<ffffffff815d2431>] smp_callin+0xf1/0x150
[  101.200946]  [<ffffffff815d24a2>] start_secondary+0x12/0xd0
[  101.200951]  [<ffffffff815d2490>] ? smp_callin+0x150/0x150
[  101.200958] panic occurred, switching back to text console
[  101.560317] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power 25981, limit 18000
[  106.084122] CPU1: Stuck ??
[  106.084275] Error taking CPU1 up: -5
[  106.084398] Booting Node 0 Processor 2 APIC 0x4
[  106.084402] smpboot cpu 2: start_ip = 98000
[  106.236983] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[  106.236988] BUG: unable to handle kernel paging request at ffffffff81ad9a30
[  106.236992] IP: [<ffffffff81ad9a30>] setup_show_msr+0x30/0x30
[  106.237004] PGD 1a05067 PUD 1a09063 PMD 12c922063 PTE 8000000001ad9163
[  106.237009] Oops: 0011 [#2] SMP 
[  106.237013] CPU 2 
[  106.237014] Modules linked in: cryptd aes_x86_64 aes_generic hidp hid rfcomm kvm_intel kvm binfmt_misc bnep parport_pc dm_crypt ppdev joydev snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm arc4 snd_seq_midi snd_rawmidi iwlagn snd_seq_midi_event snd_seq mac80211 snd_timer snd_seq_device intel_ips ideapad_laptop btusb cfg80211 snd soundcore snd_page_alloc uvcvideo videodev bluetooth psmouse serio_raw sparse_keymap v4l2_compat_ioctl32 lp parport i915 drm_kms_helper drm ahci libahci atl1c i2c_algo_bit video
[  106.237056] 
[  106.237060] Pid: 0, comm: kworker/0:1 Tainted: G      D     2.6.39-999-generic #201105210905 LENOVO 0876                            /Base Board Product Name
[  106.237065] RIP: 0010:[<ffffffff81ad9a30>]  [<ffffffff81ad9a30>] setup_show_msr+0x30/0x30
[  106.237070] RSP: 0000:ffff88013128be90  EFLAGS: 00010086
[  106.237072] RAX: 0000000000000004 RBX: ffff880137c93800 RCX: 00000000009ae3bd
[  106.237075] RDX: 00000000bfebfbff RSI: ffff88013128bea8 RDI: ffff880137c93800
[  106.237077] RBP: ffff88013128beb8 R08: 0000000000000001 R09: 0000000000000000
[  106.237080] R10: ffff88013128bea4 R11: ffff88013128bea0 R12: ffff880137c93800
[  106.237082] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  106.237085] FS:  0000000000000000(0000) GS:ffff880137c80000(0000) knlGS:0000000000000000
[  106.237088] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  106.237090] CR2: ffffffff81ad9a30 CR3: 0000000001a03000 CR4: 00000000000006a0
[  106.237093] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  106.237095] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  106.237098] Process kworker/0:1 (pid: 0, threadinfo ffff88013128a000, task ffff880131275bc0)
[  106.237100] Stack:
[  106.237102]  ffffffff815cee70 0000000000000005 009ae3bdbfebfbff 0002065504100800
[  106.237105]  ffff880137c93800 ffff88013128bed8 ffffffff815cef21 00000001ac8600dd
[  106.237109]  0000000000000002 ffff88013128bee8 ffffffff815cf0c2 ffff88013128bf08
[  106.237113] Call Trace:
[  106.237122]  [<ffffffff815cee70>] ? generic_identify+0x70/0x90
[  106.237127]  [<ffffffff815cef21>] identify_cpu+0x91/0x220
[  106.237131]  [<ffffffff815cf0c2>] identify_secondary_cpu+0x12/0x20
[  106.237135]  [<ffffffff815d1dfe>] smp_store_cpu_info+0x4e/0x60
[  106.237139]  [<ffffffff815d2431>] smp_callin+0xf1/0x150
[  106.237143]  [<ffffffff815d24a2>] start_secondary+0x12/0xd0
[  106.237146]  [<ffffffff815d2490>] ? smp_callin+0x150/0x150
[  106.237149] Code: 7f 00 00 a0 51 e4 31 e2 7f 00 00 e0 52 e4 31 e2 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 80 7b 04 32 e2 7f 00 00 
[  106.237168]  ea e3 31 e2 7f 00 00 a0 ea e3 31 e2 7f 00 00 20 f9 e3 31 e2 
[  106.237177] RIP  [<ffffffff81ad9a30>] setup_show_msr+0x30/0x30
[  106.237181]  RSP <ffff88013128be90>
[  106.237182] CR2: ffffffff81ad9a30
[  106.237187] ---[ end trace 325ed648e5a394e1 ]---
[  106.237191] Kernel panic - not syncing: Attempted to kill the idle task!
[  106.237194] Pid: 0, comm: kworker/0:1 Tainted: G      D     2.6.39-999-generic #201105210905
[  106.237196] Call Trace:
[  106.237201]  [<ffffffff8106138f>] panic+0xbf/0x1f0
[  106.237205]  [<ffffffff810626c8>] ? printk+0x78/0xc0
[  106.237210]  [<ffffffff810663df>] do_exit+0x3ef/0x420
[  106.237217]  [<ffffffff815dacb3>] oops_end+0xf3/0x100
[  106.237220]  [<ffffffff81ad9a30>] ? setup_show_msr+0x30/0x30
[  106.237226]  [<ffffffff8103cf2f>] no_context+0xff/0x110
[  106.237229]  [<ffffffff81ad9a30>] ? setup_show_msr+0x30/0x30
[  106.237233]  [<ffffffff8103d130>] __bad_area_nosemaphore+0x80/0x1d0
[  106.237236]  [<ffffffff8105252c>] ? resched_task+0x2c/0x80
[  106.237240]  [<ffffffff81ad9a30>] ? setup_show_msr+0x30/0x30
[  106.237244]  [<ffffffff8103d343>] bad_area_nosemaphore+0x13/0x20
[  106.237248]  [<ffffffff815dd30f>] do_page_fault+0x13f/0x520
[  106.237254]  [<ffffffff812e4e2f>] ? rb_erase+0xbf/0x140
[  106.237258]  [<ffffffff8100a89b>] ? __switch_to+0xbb/0x2f0
[  106.237263]  [<ffffffff815ce146>] ? init_scattered_cpuid_features+0x76/0x110
[  106.237266]  [<ffffffff81052d60>] ? finish_task_switch+0x70/0xe0
[  106.237270]  [<ffffffff815d9f55>] page_fault+0x25/0x30
[  106.237274]  [<ffffffff81ad9a30>] ? setup_show_msr+0x30/0x30
[  106.237277]  [<ffffffff815cee70>] ? generic_identify+0x70/0x90
[  106.237281]  [<ffffffff815cef21>] identify_cpu+0x91/0x220
[  106.237285]  [<ffffffff815cf0c2>] identify_secondary_cpu+0x12/0x20
[  106.237289]  [<ffffffff815d1dfe>] smp_store_cpu_info+0x4e/0x60
[  106.237292]  [<ffffffff815d2431>] smp_callin+0xf1/0x150
[  106.237296]  [<ffffffff815d24a2>] start_secondary+0x12/0xd0
[  106.237300]  [<ffffffff815d2490>] ? smp_callin+0x150/0x150
[  106.237304] panic occurred, switching back to text console
[  111.127185] CPU2: Stuck ??
[  111.127331] Error taking CPU2 up: -5
[  111.127453] Booting Node 0 Processor 3 APIC 0x5
[  111.127456] smpboot cpu 3: start_ip = 98000
[  111.283438] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[  111.283443] BUG: unable to handle kernel paging request at ffffffff81ad9a30
[  111.283448] IP: [<ffffffff81ad9a30>] setup_show_msr+0x30/0x30
[  111.283461] PGD 1a05067 PUD 1a09063 PMD 12c922063 PTE 8000000001ad9163
[  111.283467] Oops: 0011 [#3] SMP 
[  111.283472] CPU 3 
[  111.283474] Modules linked in: cryptd aes_x86_64 aes_generic hidp hid rfcomm kvm_intel kvm binfmt_misc bnep parport_pc dm_crypt ppdev joydev snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm arc4 snd_seq_midi snd_rawmidi iwlagn snd_seq_midi_event snd_seq mac80211 snd_timer snd_seq_device intel_ips ideapad_laptop btusb cfg80211 snd soundcore snd_page_alloc uvcvideo videodev bluetooth psmouse serio_raw sparse_keymap v4l2_compat_ioctl32 lp parport i915 drm_kms_helper drm ahci libahci atl1c i2c_algo_bit video
[  111.283529] 
[  111.283533] Pid: 0, comm: kworker/0:1 Tainted: G      D     2.6.39-999-generic #201105210905 LENOVO 0876                            /Base Board Product Name
[  111.283541] RIP: 0010:[<ffffffff81ad9a30>]  [<ffffffff81ad9a30>] setup_show_msr+0x30/0x30
[  111.283547] RSP: 0000:ffff8801312a1e90  EFLAGS: 00010086
[  111.283551] RAX: 0000000000000005 RBX: ffff880137cd3800 RCX: 00000000009ae3bd
[  111.283554] RDX: 00000000bfebfbff RSI: ffff8801312a1ea8 RDI: ffff880137cd3800
[  111.283558] RBP: ffff8801312a1eb8 R08: 0000000000000001 R09: 0000000000000000
[  111.283562] R10: ffff8801312a1ea4 R11: ffff8801312a1ea0 R12: ffff880137cd3800
[  111.283565] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  111.283569] FS:  0000000000000000(0000) GS:ffff880137cc0000(0000) knlGS:0000000000000000
[  111.283573] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  111.283577] CR2: ffffffff81ad9a30 CR3: 0000000001a03000 CR4: 00000000000006a0
[  111.283581] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  111.283584] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  111.283589] Process kworker/0:1 (pid: 0, threadinfo ffff8801312a0000, task ffff880131295bc0)
[  111.283591] Stack:
[  111.283594]  ffffffff815cee70 0000000000000005 009ae3bdbfebfbff 0002065505100800
[  111.283599]  ffff880137cd3800 ffff8801312a1ed8 ffffffff815cef21 000000033d0ed92e
[  111.283605]  0000000000000003 ffff8801312a1ee8 ffffffff815cf0c2 ffff8801312a1f08
[  111.283610] Call Trace:
[  111.283620]  [<ffffffff815cee70>] ? generic_identify+0x70/0x90
[  111.283626]  [<ffffffff815cef21>] identify_cpu+0x91/0x220
[  111.283631]  [<ffffffff815cf0c2>] identify_secondary_cpu+0x12/0x20
[  111.283637]  [<ffffffff815d1dfe>] smp_store_cpu_info+0x4e/0x60
[  111.283642]  [<ffffffff815d2431>] smp_callin+0xf1/0x150
[  111.283647]  [<ffffffff815d24a2>] start_secondary+0x12/0xd0
[  111.283652]  [<ffffffff815d2490>] ? smp_callin+0x150/0x150
[  111.283656] Code: 7f 00 00 a0 51 e4 31 e2 7f 00 00 e0 52 e4 31 e2 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 80 7b 04 32 e2 7f 00 00 
[  111.283683]  ea e3 31 e2 7f 00 00 a0 ea e3 31 e2 7f 00 00 20 f9 e3 31 e2 
[  111.283696] RIP  [<ffffffff81ad9a30>] setup_show_msr+0x30/0x30
[  111.283702]  RSP <ffff8801312a1e90>
[  111.283704] CR2: ffffffff81ad9a30
[  111.283709] ---[ end trace 325ed648e5a394e2 ]---
[  111.283714] Kernel panic - not syncing: Attempted to kill the idle task!
[  111.283718] Pid: 0, comm: kworker/0:1 Tainted: G      D     2.6.39-999-generic #201105210905
[  111.283721] Call Trace:
[  111.283727]  [<ffffffff8106138f>] panic+0xbf/0x1f0
[  111.283733]  [<ffffffff810626c8>] ? printk+0x78/0xc0
[  111.283739]  [<ffffffff810663df>] do_exit+0x3ef/0x420
[  111.283747]  [<ffffffff815dacb3>] oops_end+0xf3/0x100
[  111.283752]  [<ffffffff81ad9a30>] ? setup_show_msr+0x30/0x30
[  111.283759]  [<ffffffff8103cf2f>] no_context+0xff/0x110
[  111.283763]  [<ffffffff81ad9a30>] ? setup_show_msr+0x30/0x30
[  111.283769]  [<ffffffff8103d130>] __bad_area_nosemaphore+0x80/0x1d0
[  111.283774]  [<ffffffff81ad9a30>] ? setup_show_msr+0x30/0x30
[  111.283779]  [<ffffffff8103d343>] bad_area_nosemaphore+0x13/0x20
[  111.283784]  [<ffffffff815dd30f>] do_page_fault+0x13f/0x520
[  111.283790]  [<ffffffff815dfa3f>] ? kprobe_flush_task+0xaf/0xd0
[  111.283797]  [<ffffffff812e4e2f>] ? rb_erase+0xbf/0x140
[  111.283803]  [<ffffffff8100a89b>] ? __switch_to+0xbb/0x2f0
[  111.283808]  [<ffffffff815ce146>] ? init_scattered_cpuid_features+0x76/0x110
[  111.283814]  [<ffffffff81052d60>] ? finish_task_switch+0x70/0xe0
[  111.283820]  [<ffffffff815d9f55>] page_fault+0x25/0x30
[  111.283825]  [<ffffffff81ad9a30>] ? setup_show_msr+0x30/0x30
[  111.283830]  [<ffffffff815cee70>] ? generic_identify+0x70/0x90
[  111.283835]  [<ffffffff815cef21>] identify_cpu+0x91/0x220
[  111.283840]  [<ffffffff815cf0c2>] identify_secondary_cpu+0x12/0x20
[  111.283845]  [<ffffffff815d1dfe>] smp_store_cpu_info+0x4e/0x60
[  111.283850]  [<ffffffff815d2431>] smp_callin+0xf1/0x150
[  111.283855]  [<ffffffff815d24a2>] start_secondary+0x12/0xd0
[  111.283860]  [<ffffffff815d2490>] ? smp_callin+0x150/0x150
[  111.283867] panic occurred, switching back to text console
[  116.170267] CPU3: Stuck ??
[  116.170412] Error taking CPU3 up: -5
[  116.171864] ACPI: Waking up from system sleep state S3
[  116.320065] i915 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900407)
[  116.320132] pci 0000:00:16.0: restoring config space at offset 0x1 (was 0x180006, writing 0x100006)
[  116.320195] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900006, writing 0x2900002)
[  116.320264] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
[  116.320322] pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0x20003030, writing 0x3030)
[  116.320537] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900006, writing 0x2900002)
[  116.320579] pci 0000:00:1e.0: restoring config space at offset 0xa (was 0xffffffff, writing 0x0)
[  116.320693] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[  116.320876] iwlagn 0000:02:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[  116.320915] iwlagn 0000:02:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xd4400004)
[  116.320926] iwlagn 0000:02:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[  116.320939] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
[  116.321301] PM: early resume of devices complete after 1.349 msecs
[  116.321495] i915 0000:00:02.0: setting latency timer to 64
[  116.477210] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  116.477219] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[  116.477298] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[  116.477305] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[  116.477314] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[  116.477321] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[  116.477330] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[  116.477340] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  116.477408] HDA Intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[  116.477473] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  116.477482] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[  116.477527] pci 0000:00:1e.0: setting latency timer to 64
[  116.477546] ahci 0000:00:1f.2: setting latency timer to 64
[  116.478302] sd 0:0:0:0: [sda] Starting disk
[  116.649881] Extended CMOS year: 2000
[  116.759657] usb 2-1.3: reset high speed USB device number 3 using ehci_hcd
[  116.819555] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  116.821296] ata1.00: configured for UDMA/100
[  116.949576] usb 1-1.4: reset full speed USB device number 3 using ehci_hcd
[  117.061281] btusb 1-1.4:1.0: no reset_resume for driver btusb?
[  117.061291] btusb 1-1.4:1.1: no reset_resume for driver btusb?
[  117.309550] PM: resume of devices complete after 988.860 msecs
[  117.309847] PM: resume devices took 0.990 seconds
[  117.310848] PM: Finishing wakeup.
[  117.310853] Restarting tasks ... done.
[  117.436760] video LNXVIDEO:00: Restoring backlight state
[  118.472852] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  118.490291] atl1c 0000:03:00.0: irq 44 for MSI/MSI-X
[  118.589450] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  119.914042] wlan%d: authenticate with 98:fc:11:8e:c9:ea (try 1)
[  119.918711] wlan%d: authenticated
[  119.919398] wlan%d: associate with 98:fc:11:8e:c9:ea (try 1)
[  119.922614] wlan%d: RX AssocResp from 98:fc:11:8e:c9:ea (capab=0x411 status=0 aid=5)
[  119.922620] wlan%d: associated
[  119.929435] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  120.889703] EXT4-fs (sda6): re-mounted. Opts: errors=remount-ro,commit=0
[  120.916063] EXT4-fs (sda1): re-mounted. Opts: commit=0
[  121.736109] Unable to query Synaptics hardware.
[  130.370008] wlan0: no IPv6 routers present
