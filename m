Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723Ab2JESQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 14:16:21 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60282 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab2JESQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 14:16:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ben Guthro <ben@guthro.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Xiaoyan Zhang <xiaoyan.zhang@intel.com>,
        Kent Yoder <key@linux.vnet.ibm.com>
References: <CAOvdn6X+vPT6PH+mmhocR7pdJP4HLE8RFbVtScGFakzFci3=hQ@mail.gmail.com>
Date: Fri, 05 Oct 2012 11:16:06 -0700
In-Reply-To: <CAOvdn6X+vPT6PH+mmhocR7pdJP4HLE8RFbVtScGFakzFci3=hQ@mail.gmail.com>
	(Ben Guthro's message of "Fri, 5 Oct 2012 13:29:25 -0400")
Message-ID: <87zk40ss2h.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19JHHQF6xJBMO8Sho0WAIUjtM39iIWv4WA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ben Guthro <ben@guthro.net>
X-Spam-Relay-Country: 
Subject: Re: Possible regression: BUG in fs/sysfs/group.c:65
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Guthro <ben@guthro.net> writes:

> I am seeing a regression in today's (Oct 5) kernel - 2 WARNINGS, and a
> BUG below that seems to occur upon resuming from S3.
>
> I can start a bisection with 3.6 - but wanted to check to see if
> anyone else is also experiencing this failure...

I took a quick look and this is a deterministic failure.  The same
file is being added to sysfs twice.

Since the routine causing this failure appears to be sys_add_ppi I
expect the commit that added this failure mode is the commit below.

Xiaoyan Zhang, Kent Yoder can you guys look at this see why the tpm
code is adding itself multiple times into sysfs?

Thanks,
Eric

commit f84fdff0fdcda7e509ce530e0ee612233a2104fb
Author: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
Date:   Wed Aug 22 18:47:22 2012 +0800

    driver: add PPI support in tpm driver
    
    The Physical Presence Interface enables the OS and the BIOS to cooperate and
    provides a simple and straightforward platform user experience for
    administering the TPM without sacrificing security.
    
    V2: separate the patch out in a separate source file,
        add #ifdef CONFIG_ACPI so it compiles out on ppc,
        use standard error instead of ACPI error as return code of show/store fns.
    V3: move #ifdef CONFIG_ACPI from .c file to .h file.
    V4: move tpm_ppi code from tpm module to tpm_bios module.
    V5: modify sys_add_ppi() so that ppi_attr_grp doesn't need to be exported
    
    Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
    Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>


> I'm not sure that it matters in this case, but this is running as a
> Xen dom0 pvops kernel.
>
> Regards
> Ben Guthro
>
>
> [ 1554.684622] ------------[ cut here ]------------
> [ 1554.684634] WARNING: at
> /data/home/bguthro/dev/unstable/linux/fs/sysfs/dir.c:536
> sysfs_add_one+0xc0/0xf0()
> [ 1554.684636] Hardware name: 2765T6U
> [ 1554.684638] sysfs: cannot create duplicate filename '/devices/pnp0/00:0c/ppi'
> [ 1554.684640] Modules linked in: tpm_tis(+) tpm tpm_bios ehci_hcd
> ebtable_filter ebtables ip_tables x_tables zram(C) zsmalloc(C) bridge
> stp llc snd_hda_codec_conexant arc4 i915 snd_hda_intel iwldvm
> snd_hda_codec mac80211 pcmcia hid_generic drm_kms_helper yenta_socket
> snd_hwdep snd_pcm iwlwifi drm pcmcia_rsrc snd_timer pcmcia_core usbhid
> thinkpad_acpi coretemp snd_page_alloc cfg80211 psmouse hid
> i2c_algo_bit intel_agp serio_raw microcode intel_gtt snd soundcore
> video nvram ahci libahci e1000e [last unloaded: tpm_bios]
> [ 1554.684681] Pid: 3492, comm: modprobe Tainted: G         C   3.6.0-orc #3
> [ 1554.684683] Call Trace:
> [ 1554.684691]  [<ffffffff810539cf>] warn_slowpath_common+0x7f/0xc0
> [ 1554.684695]  [<ffffffff81053ac6>] warn_slowpath_fmt+0x46/0x50
> [ 1554.684699]  [<ffffffff811d0bb0>] sysfs_add_one+0xc0/0xf0
> [ 1554.684702]  [<ffffffff811d0d9c>] create_dir+0x7c/0xd0
> [ 1554.684706]  [<ffffffff811d1116>] sysfs_create_dir+0x86/0xe0
> [ 1554.684712]  [<ffffffff812bffec>] kobject_add_internal+0x9c/0x210
> [ 1554.684716]  [<ffffffff812c05e7>] kobject_add+0x67/0xc0
> [ 1554.684720]  [<ffffffff812c090e>] kobject_create_and_add+0x3e/0x80
> [ 1554.684725]  [<ffffffffa00d7898>] sys_add_ppi+0x18/0x40 [tpm_bios]
> [ 1554.684731]  [<ffffffffa0100aee>] tpm_register_hardware+0x22e/0x3c0 [tpm]
> [ 1554.684736]  [<ffffffffa0109b7a>] tpm_tis_init+0x44/0x601 [tpm_tis]
> [ 1554.684741]  [<ffffffffa010a225>] tpm_tis_pnp_init+0xee/0x10d [tpm_tis]
> [ 1554.684746]  [<ffffffffa010a137>] ? tpm_tis_init+0x601/0x601 [tpm_tis]
> [ 1554.684751]  [<ffffffff81348180>] pnp_device_probe+0x70/0xf0
> [ 1554.684757]  [<ffffffff813a6f4a>] ? driver_sysfs_add+0x7a/0xb0
> [ 1554.684761]  [<ffffffff813a722b>] driver_probe_device+0x7b/0x240
> [ 1554.684764]  [<ffffffff813a749b>] __driver_attach+0xab/0xb0
> [ 1554.684768]  [<ffffffff813a73f0>] ? driver_probe_device+0x240/0x240
> [ 1554.684772]  [<ffffffff813a5646>] bus_for_each_dev+0x56/0x90
> [ 1554.684776]  [<ffffffff813a6d5e>] driver_attach+0x1e/0x20
> [ 1554.684779]  [<ffffffff813a68d0>] bus_add_driver+0x190/0x290
> [ 1554.684784]  [<ffffffffa010d000>] ? 0xffffffffa010cfff
> [ 1554.684787]  [<ffffffff813a79fa>] driver_register+0x7a/0x160
> [ 1554.684791]  [<ffffffffa010d000>] ? 0xffffffffa010cfff
> [ 1554.684795]  [<ffffffff81347eb1>] pnp_register_driver+0x21/0x30
> [ 1554.684800]  [<ffffffffa010d01d>] init_tis+0x1d/0xc5 [tpm_tis]
> [ 1554.684805]  [<ffffffff8107d6f3>] ? __blocking_notifier_call_chain+0x63/0x80
> [ 1554.684809]  [<ffffffff8100203f>] do_one_initcall+0x3f/0x170
> [ 1554.684814]  [<ffffffff810b562f>] sys_init_module+0x8f/0x200
> [ 1554.684819]  [<ffffffff815a46e9>] system_call_fastpath+0x16/0x1b
> [ 1554.684822] ---[ end trace b394e16efa725e57 ]---
> [ 1554.684825] ------------[ cut here ]------------
> [ 1554.684829] WARNING: at
> /data/home/bguthro/dev/unstable/linux/lib/kobject.c:196
> kobject_add_internal+0x1f4/0x210()
> [ 1554.684830] Hardware name: 2765T6U
> [ 1554.684832] kobject_add_internal failed for ppi with -EEXIST, don't
> try to register things with the same name in the same directory.
> [ 1554.684834] Modules linked in: tpm_tis(+) tpm tpm_bios ehci_hcd
> ebtable_filter ebtables ip_tables x_tables zram(C) zsmalloc(C) bridge
> stp llc snd_hda_codec_conexant arc4 i915 snd_hda_intel iwldvm
> snd_hda_codec mac80211 pcmcia hid_generic drm_kms_helper yenta_socket
> snd_hwdep snd_pcm iwlwifi drm pcmcia_rsrc snd_timer pcmcia_core usbhid
> thinkpad_acpi coretemp snd_page_alloc cfg80211 psmouse hid
> i2c_algo_bit intel_agp serio_raw microcode intel_gtt snd soundcore
> video nvram ahci libahci e1000e [last unloaded: tpm_bios]
> [ 1554.684870] Pid: 3492, comm: modprobe Tainted: G        WC   3.6.0-orc #3
> [ 1554.684872] Call Trace:
> [ 1554.684876]  [<ffffffff810539cf>] warn_slowpath_common+0x7f/0xc0
> [ 1554.684880]  [<ffffffff81053ac6>] warn_slowpath_fmt+0x46/0x50
> [ 1554.684884]  [<ffffffff811d0431>] ? release_sysfs_dirent+0x61/0xe0
> [ 1554.684888]  [<ffffffff812c0144>] kobject_add_internal+0x1f4/0x210
> [ 1554.684892]  [<ffffffff812c05e7>] kobject_add+0x67/0xc0
> [ 1554.684897]  [<ffffffff812c090e>] kobject_create_and_add+0x3e/0x80
> [ 1554.684901]  [<ffffffffa00d7898>] sys_add_ppi+0x18/0x40 [tpm_bios]
> [ 1554.684906]  [<ffffffffa0100aee>] tpm_register_hardware+0x22e/0x3c0 [tpm]
> [ 1554.684911]  [<ffffffffa0109b7a>] tpm_tis_init+0x44/0x601 [tpm_tis]
> [ 1554.684916]  [<ffffffffa010a225>] tpm_tis_pnp_init+0xee/0x10d [tpm_tis]
> [ 1554.684921]  [<ffffffffa010a137>] ? tpm_tis_init+0x601/0x601 [tpm_tis]
> [ 1554.684925]  [<ffffffff81348180>] pnp_device_probe+0x70/0xf0
> [ 1554.684929]  [<ffffffff813a6f4a>] ? driver_sysfs_add+0x7a/0xb0
> [ 1554.684933]  [<ffffffff813a722b>] driver_probe_device+0x7b/0x240
> [ 1554.684936]  [<ffffffff813a749b>] __driver_attach+0xab/0xb0
> [ 1554.684940]  [<ffffffff813a73f0>] ? driver_probe_device+0x240/0x240
> [ 1554.684944]  [<ffffffff813a5646>] bus_for_each_dev+0x56/0x90
> [ 1554.684947]  [<ffffffff813a6d5e>] driver_attach+0x1e/0x20
> [ 1554.684951]  [<ffffffff813a68d0>] bus_add_driver+0x190/0x290
> [ 1554.684955]  [<ffffffffa010d000>] ? 0xffffffffa010cfff
> [ 1554.684958]  [<ffffffff813a79fa>] driver_register+0x7a/0x160
> [ 1554.684962]  [<ffffffffa010d000>] ? 0xffffffffa010cfff
> [ 1554.684966]  [<ffffffff81347eb1>] pnp_register_driver+0x21/0x30
> [ 1554.684970]  [<ffffffffa010d01d>] init_tis+0x1d/0xc5 [tpm_tis]
> [ 1554.684974]  [<ffffffff8107d6f3>] ? __blocking_notifier_call_chain+0x63/0x80
> [ 1554.684978]  [<ffffffff8100203f>] do_one_initcall+0x3f/0x170
> [ 1554.684981]  [<ffffffff810b562f>] sys_init_module+0x8f/0x200
> [ 1554.684985]  [<ffffffff815a46e9>] system_call_fastpath+0x16/0x1b
> [ 1554.684987] ---[ end trace b394e16efa725e58 ]---
> [ 1554.684990] kobject_create_and_add: kobject_add error: -17
> [ 1554.685002] ------------[ cut here ]------------
> [ 1554.685040] kernel BUG at
> /data/home/bguthro/dev/unstable/linux/fs/sysfs/group.c:65!
> [ 1554.685086] invalid opcode: 0000 [#1] SMP
> [ 1554.685118] Modules linked in: tpm_tis(+) tpm tpm_bios ehci_hcd
> ebtable_filter ebtables ip_tables x_tables zram(C) zsmalloc(C) bridge
> stp llc snd_hda_codec_conexant arc4 i915 snd_hda_intel iwldvm
> snd_hda_codec mac80211 pcmcia hid_generic drm_kms_helper yenta_socket
> snd_hwdep snd_pcm iwlwifi drm pcmcia_rsrc snd_timer pcmcia_core usbhid
> thinkpad_acpi coretemp snd_page_alloc cfg80211 psmouse hid
> i2c_algo_bit intel_agp serio_raw microcode intel_gtt snd soundcore
> video nvram ahci libahci e1000e [last unloaded: tpm_bios]
> [ 1554.685524] CPU 0
> [ 1554.685540] Pid: 3492, comm: modprobe Tainted: G        WC
> 3.6.0-orc #3 LENOVO 2765T6U/2765T6U
> [ 1554.685593] RIP: e030:[<ffffffff811d29f9>]  [<ffffffff811d29f9>]
> internal_create_group+0x1e9/0x210
> [ 1554.686670] RSP: e02b:ffff880002a4fbd8  EFLAGS: 00010246
> [ 1554.686706] RAX: 0000000000000000 RBX: ffff880002ecc000 RCX: 000000000000a9c8
> [ 1554.686747] RDX: ffffffffa00d8ec0 RSI: 0000000000000000 RDI: 0000000000000000
> [ 1554.686788] RBP: ffff880002a4fc28 R08: 0000000000016640 R09: ffffea00009d7000
> [ 1554.686829] R10: ffffffff812bfec9 R11: 6464615f646e615f R12: ffff88002871cc10
> [ 1554.686870] R13: ffff880002ecc220 R14: ffffffffa00d8ec0 R15: 0000000000000000
> [ 1554.686915] FS:  00007f33000ba700(0000) GS:ffff88002dc00000(0000)
> knlGS:0000000000000000
> [ 1554.686963] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 1554.686996] CR2: 00007fac43cd0000 CR3: 000000000298a000 CR4: 0000000000002660
> [ 1554.687038] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1554.687079] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 1554.687121] Process modprobe (pid: 3492, threadinfo
> ffff880002a4e000, task ffff880025c52d20)
> [ 1554.687170] Stack:
> [ 1554.687184]  ffffffffa00d8b38 0000000000000000 ffff880002a4fc08
> ffffffff812bfd7c
> [ 1554.687238]  000000005b2d2d2d ffff880002ecc000 ffff88002871cc10
> ffff880002ecc220
> [ 1554.687292]  ffff8800275c0e90 ffff880002ecc130 ffff880002a4fc38
> ffffffff811d2a53
> [ 1554.687345] Call Trace:
> [ 1554.687366]  [<ffffffff812bfd7c>] ? kobject_put+0x2c/0x60
> [ 1554.687400]  [<ffffffff811d2a53>] sysfs_create_group+0x13/0x20
> [ 1554.687439]  [<ffffffffa00d78a7>] sys_add_ppi+0x27/0x40 [tpm_bios]
> [ 1554.687480]  [<ffffffffa0100aee>] tpm_register_hardware+0x22e/0x3c0 [tpm]
> [ 1554.687523]  [<ffffffffa0109b7a>] tpm_tis_init+0x44/0x601 [tpm_tis]
> [ 1554.687562]  [<ffffffffa010a225>] tpm_tis_pnp_init+0xee/0x10d [tpm_tis]
> [ 1554.687604]  [<ffffffffa010a137>] ? tpm_tis_init+0x601/0x601 [tpm_tis]
> [ 1554.687645]  [<ffffffff81348180>] pnp_device_probe+0x70/0xf0
> [ 1554.687681]  [<ffffffff813a6f4a>] ? driver_sysfs_add+0x7a/0xb0
> [ 1554.687718]  [<ffffffff813a722b>] driver_probe_device+0x7b/0x240
> [ 1554.687756]  [<ffffffff813a749b>] __driver_attach+0xab/0xb0
> [ 1554.687795]  [<ffffffff813a73f0>] ? driver_probe_device+0x240/0x240
> [ 1554.687832]  [<ffffffff813a5646>] bus_for_each_dev+0x56/0x90
> [ 1554.687868]  [<ffffffff813a6d5e>] driver_attach+0x1e/0x20
> [ 1554.687902]  [<ffffffff813a68d0>] bus_add_driver+0x190/0x290
> [ 1554.687939]  [<ffffffffa010d000>] ? 0xffffffffa010cfff
> [ 1554.687973]  [<ffffffff813a79fa>] driver_register+0x7a/0x160
> [ 1554.688009]  [<ffffffffa010d000>] ? 0xffffffffa010cfff
> [ 1554.688042]  [<ffffffff81347eb1>] pnp_register_driver+0x21/0x30
> [ 1554.688080]  [<ffffffffa010d01d>] init_tis+0x1d/0xc5 [tpm_tis]
> [ 1554.688117]  [<ffffffff8107d6f3>] ? __blocking_notifier_call_chain+0x63/0x80
> [ 1554.688161]  [<ffffffff8100203f>] do_one_initcall+0x3f/0x170
> [ 1554.688197]  [<ffffffff810b562f>] sys_init_module+0x8f/0x200
> [ 1554.688233]  [<ffffffff815a46e9>] system_call_fastpath+0x16/0x1b
> [ 1554.688269] Code: 45 b0 0f 84 60 ff ff ff 48 8b 7d c8 89 45 b0 e8
> 8e e7 ff ff 4c 8b 6d c8 8b 45 b0 e9 48 ff ff ff 48 83 7f 30 00 0f 85
> 57 fe ff ff <0f> 0b be c3 00 00 00 48 c7 c7 f8 7e 7e 81 e8 04 10 e8 ff
> e9 80
> [ 1554.688576] RIP  [<ffffffff811d29f9>] internal_create_group+0x1e9/0x210
> [ 1554.688621]  RSP <ffff880002a4fbd8>
> [ 1554.704039] ---[ end trace b394e16efa725e59 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
