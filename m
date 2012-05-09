Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281Ab2EINKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:10:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376Ab2EINKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:10:49 -0400
Message-ID: <4FAA6CC9.5060106@redhat.com>
Date: Wed, 09 May 2012 10:10:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Greg K H <gregkh@linuxfoundation.org>
Subject: Re: [EDAC ABI v13 09/25] edac: rewrite the sysfs code to use struct
 device
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com> <1334608729-30803-10-git-send-email-mchehab@redhat.com> <20120509123441.GC22737@aftab.osrc.amd.com>
In-Reply-To: <20120509123441.GC22737@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(c/c Greg, as this is related to the kobj->struct device conversion)

Em 09-05-2012 09:34, Borislav Petkov escreveu:
> Inserting latest version:
> 
>> From e8765894c6d43326c9968a3687f5140708ee163f Mon Sep 17 00:00:00 2001
>> From: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Date: Mon, 16 Apr 2012 16:41:11 -0300
>> Subject: [PATCH] edac: rewrite the sysfs code to use struct device
>>
>> The EDAC subsystem uses the old struct sysdev approach,
>> creating all nodes using the raw sysfs API. This is bad,
>> as the API is deprecated.
>>
>> As we'll be changing the EDAC API, let's first port the existing
>> code to struct device.
>>
>> There's one side-back on this patch: all device-specific sysfs
> 
> 	      drawback to
> 
>> nodes won't be created anymore. While it would be possible to
> 
> which device-specific nodes?

I mean driver-specific. The ones that i7core_edac, amd64_edac and 
mpc85xx_edac create (mainly) for debug purposes. 

Everything will compile and run fine, but the core won't create them
anymore, as they're based on kobj.

The next 3 patches on this series will convert each of the above to
use kernel devices, solving this issue.

I'll fix the comment.

> 
>> also port the device-specific code, it is easier and nicer to
>> move the code to the drivers, instead, as the core can get rid
>> of some complex logic that just emulates what the device_add()
>> and device_create_file() already does.
>>
>> The next patches will convert the driver-specific code to use
>> the device-specific calls. Then, the remaining bits of the old
>> sysfs API will be removed.
>>
>> Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
>> Cc: Doug Thompson <norsk5@yahoo.com>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Btw, this patch is b0rked. Here's the EDAC debug output from the second
> node on when booting:
> 
> ...
> [    9.692291] EDAC amd64: F10h detected (node 1).
> [    9.692324] EDAC DEBUG: reserve_mc_sibling_devs: F1: 0000:00:19.1
> [    9.692330] EDAC DEBUG: reserve_mc_sibling_devs: F2: 0000:00:19.2
> [    9.692335] EDAC DEBUG: reserve_mc_sibling_devs: F3: 0000:00:19.3
> [    9.692341] EDAC DEBUG: read_mc_regs:   TOP_MEM:  0x00000000c8000000
> [    9.692347] EDAC DEBUG: read_mc_regs:   TOP_MEM2: 0x0000001038000000
> [    9.692356] EDAC DEBUG: read_dram_ctl_register: F2x110 (DCTSelLow): 0x000005e4, High range addrs at: 0x0
> [    9.692363] EDAC DEBUG: read_dram_ctl_register:   DCTs operate in unganged mode.
> [    9.692369] EDAC DEBUG: read_dram_ctl_register:   Address range split per DCT: no
> [    9.692376] EDAC DEBUG: read_dram_ctl_register:   data interleave for ECC: enabled, DRAM cleared since last warm reset: yes
> [    9.692384] EDAC DEBUG: read_dram_ctl_register:   channel interleave: enabled, interleave bits selector: 0x3
> [    9.692395] EDAC DEBUG: read_mc_regs:   DRAM range[0], base: 0x0000000000000000; limit: 0x0000000437ffffff
> [    9.692404] EDAC DEBUG: read_mc_regs:    IntlvEn=Disabled; Range access: RW IntlvSel=0 DstNode=0
> [    9.692413] EDAC DEBUG: read_mc_regs:   DRAM range[1], base: 0x0000000438000000; limit: 0x0000000837ffffff
> [    9.692422] EDAC DEBUG: read_mc_regs:    IntlvEn=Disabled; Range access: RW IntlvSel=0 DstNode=1
> [    9.692431] EDAC DEBUG: read_mc_regs:   DRAM range[2], base: 0x0000000838000000; limit: 0x0000000c37ffffff
> [    9.692439] EDAC DEBUG: read_mc_regs:    IntlvEn=Disabled; Range access: RW IntlvSel=0 DstNode=2
> [    9.692448] EDAC DEBUG: read_mc_regs:   DRAM range[3], base: 0x0000000c38000000; limit: 0x0000001037ffffff
> [    9.692456] EDAC DEBUG: read_mc_regs:    IntlvEn=Disabled; Range access: RW IntlvSel=0 DstNode=3
> [    9.692469] EDAC DEBUG: read_dct_base_mask:   DCSB0[0]=0x00000001 reg: F2x40
> [    9.692476] EDAC DEBUG: read_dct_base_mask:   DCSB1[0]=0x00000001 reg: F2x140
> [    9.692483] EDAC DEBUG: read_dct_base_mask:   DCSB0[1]=0x00000201 reg: F2x44
> [    9.692489] EDAC DEBUG: read_dct_base_mask:   DCSB1[1]=0x00000201 reg: F2x144
> [    9.692496] EDAC DEBUG: read_dct_base_mask:   DCSB0[2]=0x00000401 reg: F2x48
> [    9.692503] EDAC DEBUG: read_dct_base_mask:   DCSB1[2]=0x00000401 reg: F2x148
> [    9.692510] EDAC DEBUG: read_dct_base_mask:   DCSB0[3]=0x00000601 reg: F2x4c
> [    9.692516] EDAC DEBUG: read_dct_base_mask:   DCSB1[3]=0x00000601 reg: F2x14c
> [    9.692523] EDAC DEBUG: read_dct_base_mask:   DCSB0[4]=0x00000000 reg: F2x50
> [    9.692530] EDAC DEBUG: read_dct_base_mask:   DCSB1[4]=0x00000000 reg: F2x150
> [    9.692537] EDAC DEBUG: read_dct_base_mask:   DCSB0[5]=0x00000000 reg: F2x54
> [    9.692543] EDAC DEBUG: read_dct_base_mask:   DCSB1[5]=0x00000000 reg: F2x154
> [    9.692550] EDAC DEBUG: read_dct_base_mask:   DCSB0[6]=0x00000000 reg: F2x58
> [    9.692557] EDAC DEBUG: read_dct_base_mask:   DCSB1[6]=0x00000000 reg: F2x158
> [    9.692564] EDAC DEBUG: read_dct_base_mask:   DCSB0[7]=0x00000000 reg: F2x5c
> [    9.692570] EDAC DEBUG: read_dct_base_mask:   DCSB1[7]=0x00000000 reg: F2x15c
> [    9.692577] EDAC DEBUG: read_dct_base_mask:     DCSM0[0]=0x01f839e0 reg: F2x60
> [    9.692584] EDAC DEBUG: read_dct_base_mask:     DCSM1[0]=0x01f839e0 reg: F2x160
> [    9.692591] EDAC DEBUG: read_dct_base_mask:     DCSM0[1]=0x01f839e0 reg: F2x64
> [    9.692598] EDAC DEBUG: read_dct_base_mask:     DCSM1[1]=0x01f839e0 reg: F2x164
> [    9.692605] EDAC DEBUG: read_dct_base_mask:     DCSM0[2]=0x00000000 reg: F2x68
> [    9.692612] EDAC DEBUG: read_dct_base_mask:     DCSM1[2]=0x00000000 reg: F2x168
> [    9.692619] EDAC DEBUG: read_dct_base_mask:     DCSM0[3]=0x00000000 reg: F2x6c
> [    9.692625] EDAC DEBUG: read_dct_base_mask:     DCSM1[3]=0x00000000 reg: F2x16c
> [    9.692635] EDAC DEBUG: dump_misc_regs: F3xE8 (NB Cap): 0x62f0df1f
> [    9.692641] EDAC DEBUG: dump_misc_regs:   NB two channel DRAM capable: yes
> [    9.692647] EDAC DEBUG: dump_misc_regs:   ECC capable: yes, ChipKill ECC capable: yes
> [    9.692653] EDAC DEBUG: amd64_dump_dramcfg_low: F2x090 (DRAM Cfg Low): 0x00083100
> [    9.692660] EDAC DEBUG: amd64_dump_dramcfg_low:   DIMM type: buffered; all DIMMs support ECC: yes
> [    9.692666] EDAC DEBUG: amd64_dump_dramcfg_low:   PAR/ERR parity: enabled
> [    9.692671] EDAC DEBUG: amd64_dump_dramcfg_low:   DCT 128bit mode width: 64b
> [    9.692678] EDAC DEBUG: amd64_dump_dramcfg_low:   x4 logical DIMMs present: L0: yes L1: yes L2: no L3: no
> [    9.692685] EDAC DEBUG: dump_misc_regs: F3xB0 (Online Spare): 0x00000000
> [    9.692692] EDAC DEBUG: dump_misc_regs: F1xF0 (DRAM Hole Address): 0xc8000002, base: 0xc8000000, offset: 0x00000000
> [    9.692699] EDAC DEBUG: dump_misc_regs:   DramHoleValid: no
> [    9.692705] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x080 (DRAM Bank Address Mapping): 0x00000088
> [    9.692711] EDAC MC: DCT0 chip selects:
> [    9.692717] EDAC amd64: MC: 0:  2048MB 1:  2048MB
> [    9.692723] EDAC amd64: MC: 2:  2048MB 3:  2048MB
> [    9.692728] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    9.692733] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    9.692738] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x180 (DRAM Bank Address Mapping): 0x00000088
> [    9.692744] EDAC MC: DCT1 chip selects:
> [    9.692749] EDAC amd64: MC: 0:  2048MB 1:  2048MB
> [    9.692754] EDAC amd64: MC: 2:  2048MB 3:  2048MB
> [    9.692759] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    9.692764] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    9.692769] EDAC amd64: using x8 syndromes.
> [    9.692774] EDAC DEBUG: amd64_dump_dramcfg_low: F2x190 (DRAM Cfg Low): 0x00083100
> [    9.692780] EDAC DEBUG: amd64_dump_dramcfg_low:   DIMM type: buffered; all DIMMs support ECC: yes
> [    9.692786] EDAC DEBUG: amd64_dump_dramcfg_low:   PAR/ERR parity: enabled
> [    9.692791] EDAC DEBUG: amd64_dump_dramcfg_low:   DCT 128bit mode width: 64b
> [    9.692798] EDAC DEBUG: amd64_dump_dramcfg_low:   x4 logical DIMMs present: L0: yes L1: yes L2: no L3: no
> [    9.692805] EDAC DEBUG: f1x_early_channel_count: Data width is not 128 bits - need more decoding
> [    9.692812] EDAC amd64: MCT channel count: 2
> [    9.692821] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc(): allocating 30948 bytes for mci data (16 ranks, 16 csrows/channels)
> [    9.692851] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 0: rank0 (0:0:0): row 0, chan 0
> [    9.692863] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 1: rank1 (0:1:0): row 1, chan 0
> [    9.692873] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 2: rank2 (1:0:0): row 2, chan 0
> [    9.692883] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 3: rank3 (1:1:0): row 3, chan 0
> [    9.692893] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 4: rank4 (2:0:0): row 4, chan 0
> [    9.692903] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 5: rank5 (2:1:0): row 5, chan 0
> [    9.692912] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 6: rank6 (3:0:0): row 6, chan 0
> [    9.692922] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 7: rank7 (3:1:0): row 7, chan 0
> [    9.692931] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 8: rank8 (4:0:0): row 0, chan 1
> [    9.692941] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 9: rank9 (4:1:0): row 1, chan 1
> [    9.692951] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 10: rank10 (5:0:0): row 2, chan 1
> [    9.692961] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 11: rank11 (5:1:0): row 3, chan 1
> [    9.692971] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 12: rank12 (6:0:0): row 4, chan 1
> [    9.692980] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 13: rank13 (6:1:0): row 5, chan 1
> [    9.692990] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 14: rank14 (7:0:0): row 6, chan 1
> [    9.692999] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 15: rank15 (7:1:0): row 7, chan 1
> [    9.693010] EDAC DEBUG: init_csrows: node 1, NBCFG=0x4af0005c[ChipKillEccCap: 1|DramEccEn: 1]
> [    9.693017] EDAC DEBUG: init_csrows: ----CSROW 0 VALID for MC node 1
> [    9.693022] EDAC DEBUG: amd64_csrow_nr_pages:   (csrow=0) DBAM map index= 8
> [    9.693029] EDAC DEBUG: amd64_csrow_nr_pages:     nr_pages= 524288  channel-count = 2
> [    9.693035] EDAC amd64: CS0: Registered DDR3 RAM
> [    9.693040] EDAC DEBUG: init_csrows:   for MC node 1 csrow 0:
> [    9.693045] EDAC DEBUG: init_csrows:     nr_pages: 524288
> [    9.693050] EDAC DEBUG: init_csrows: ----CSROW 1 VALID for MC node 1
> [    9.693056] EDAC DEBUG: amd64_csrow_nr_pages:   (csrow=1) DBAM map index= 8
> [    9.693062] EDAC DEBUG: amd64_csrow_nr_pages:     nr_pages= 524288  channel-count = 2
> [    9.693068] EDAC amd64: CS1: Registered DDR3 RAM
> [    9.693072] EDAC DEBUG: init_csrows:   for MC node 1 csrow 1:
> [    9.693077] EDAC DEBUG: init_csrows:     nr_pages: 524288
> [    9.693083] EDAC DEBUG: init_csrows: ----CSROW 2 VALID for MC node 1
> [    9.693089] EDAC DEBUG: amd64_csrow_nr_pages:   (csrow=2) DBAM map index= 8
> [    9.693095] EDAC DEBUG: amd64_csrow_nr_pages:     nr_pages= 524288  channel-count = 2
> [    9.693100] EDAC amd64: CS2: Registered DDR3 RAM
> [    9.693105] EDAC DEBUG: init_csrows:   for MC node 1 csrow 2:
> [    9.693110] EDAC DEBUG: init_csrows:     nr_pages: 524288
> [    9.693116] EDAC DEBUG: init_csrows: ----CSROW 3 VALID for MC node 1
> [    9.693121] EDAC DEBUG: amd64_csrow_nr_pages:   (csrow=3) DBAM map index= 8
> [    9.693128] EDAC DEBUG: amd64_csrow_nr_pages:     nr_pages= 524288  channel-count = 2
> [    9.693133] EDAC amd64: CS3: Registered DDR3 RAM
> [    9.693138] EDAC DEBUG: init_csrows:   for MC node 1 csrow 3:
> [    9.693143] EDAC DEBUG: init_csrows:     nr_pages: 524288
> [    9.693148] EDAC DEBUG: init_csrows: ----CSROW 4 EMPTY for node 1
> [    9.693154] EDAC DEBUG: init_csrows: ----CSROW 5 EMPTY for node 1
> [    9.693159] EDAC DEBUG: init_csrows: ----CSROW 6 EMPTY for node 1
> [    9.693165] EDAC DEBUG: init_csrows: ----CSROW 7 EMPTY for node 1
> [    9.693171] EDAC DEBUG: edac_mc_add_mc: edac_mc_add_mc()
> [    9.693179] EDAC DEBUG: edac_create_sysfs_mci_device: edac_create_sysfs_mci_device() idx=1
> [    9.693193] EDAC DEBUG: edac_create_sysfs_mci_device: edac_create_sysfs_mci_device(): creating device mc1
> [    9.693288] EDAC DEBUG: edac_create_sysfs_mci_device: edac_create_sysfs_mci_device creating dimm0, located at csrow 0 channel 0 
> [    9.693300] EDAC DEBUG: edac_create_sysfs_mci_device: edac_create_sysfs_mci_device creating dimm1, located at csrow 0 channel 1 
> [    9.693312] EDAC DEBUG: edac_create_sysfs_mci_device: edac_create_sysfs_mci_device creating dimm2, located at csrow 1 channel 0 
> [    9.693322] EDAC DEBUG: edac_create_sysfs_mci_device: edac_create_sysfs_mci_device creating dimm3, located at csrow 1 channel 1 
> [    9.693333] EDAC DEBUG: edac_create_sysfs_mci_device: edac_create_sysfs_mci_device creating dimm8, located at csrow 4 channel 0 
> [    9.693344] EDAC DEBUG: edac_create_sysfs_mci_device: edac_create_sysfs_mci_device creating dimm9, located at csrow 4 channel 1 
> [    9.693355] EDAC DEBUG: edac_create_sysfs_mci_device: edac_create_sysfs_mci_device creating dimm10, located at csrow 5 channel 0 
> [    9.693365] EDAC DEBUG: edac_create_sysfs_mci_device: edac_create_sysfs_mci_device creating dimm11, located at csrow 5 channel 1 
> [    9.693379] EDAC DEBUG: edac_create_csrow_object: edac_create_csrow_object(): creating (virtual) csrow node csrow0
> [    9.693417] ------------[ cut here ]------------
> [    9.693434] WARNING: at fs/sysfs/dir.c:481 sysfs_add_one+0x97/0xab()
> [    9.693440] Hardware name: <redacted>
> [    9.693444] sysfs: cannot create duplicate filename '/bus/edac/devices/csrow0'
> [    9.693449] Modules linked in: radeon(+) ttm drm_kms_helper hwmon backlight e1000e amd64_edac_mod(+) ohci_hcd cfbcopyarea cfbimgblt cfbfillrect ehci_hcd edac_core
> [    9.693479] Pid: 1569, comm: work_for_cpu Not tainted 3.3.0+ #4
> [    9.693484] Call Trace:
> [    9.693499]  [<ffffffff8102d50c>] warn_slowpath_common+0x85/0x9d
> [    9.693509]  [<ffffffff8102d5c7>] warn_slowpath_fmt+0x46/0x48
> [    9.693518]  [<ffffffff8114dd94>] sysfs_add_one+0x97/0xab
> [    9.693527]  [<ffffffff8114e542>] sysfs_do_create_link+0x103/0x1a0
> [    9.693538]  [<ffffffff8114e5f2>] sysfs_create_link+0x13/0x15
> [    9.693549]  [<ffffffff812803e1>] bus_add_device+0xd8/0x163
> [    9.693558]  [<ffffffff8127eaa7>] device_add+0x3ca/0x598
> [    9.693567]  [<ffffffff8127e6d5>] ? device_private_init+0x5d/0x65
> [    9.693588]  [<ffffffffa002aacb>] edac_create_sysfs_mci_device+0x228/0x3f3 [edac_core]
> [    9.693604]  [<ffffffffa0028c95>] edac_mc_add_mc+0x5cf/0x711 [edac_core]
> [    9.693622]  [<ffffffffa00f0807>] amd64_probe_one_instance+0x143b/0x1559 [amd64_edac_mod]
> [    9.693634]  [<ffffffff811e7aac>] local_pci_probe+0x4d/0x96
> [    9.693645]  [<ffffffff81042ecf>] ? cwq_dec_nr_in_flight+0x7b/0x7b
> [    9.693654]  [<ffffffff81042ee7>] do_work_for_cpu+0x18/0x2a
> [    9.693663]  [<ffffffff81048d0d>] kthread+0x89/0x91
> [    9.693675]  [<ffffffff8144ca64>] kernel_thread_helper+0x4/0x10
> [    9.693686]  [<ffffffff81444f4a>] ? retint_restore_args+0xe/0xe
> [    9.693695]  [<ffffffff81048c84>] ? kthread_freezable_should_stop+0x57/0x57
> [    9.693704]  [<ffffffff8144ca60>] ? gs_change+0xb/0xb
> [    9.693710] ---[ end trace c72c379fedc94aa5 ]---
> [    9.693741] ------------[ cut here ]------------
> [    9.693751] WARNING: at lib/kobject.c:595 kobject_put+0x37/0x50()
> [    9.693755] Hardware name: <redacted>
> [    9.693761] kobject: '(null)' (ffff880824e4e8bc): is not initialized, yet kobject_put() is being called.
> [    9.693767] Modules linked in: radeon(+) ttm drm_kms_helper hwmon backlight e1000e amd64_edac_mod(+) ohci_hcd cfbcopyarea cfbimgblt cfbfillrect ehci_hcd edac_core
> [    9.693790] Pid: 1569, comm: work_for_cpu Tainted: G        W    3.3.0+ #4
> [    9.693795] Call Trace:
> [    9.693803]  [<ffffffff8102d50c>] warn_slowpath_common+0x85/0x9d
> [    9.693811]  [<ffffffff8102d5c7>] warn_slowpath_fmt+0x46/0x48
> [    9.693820]  [<ffffffff811c7193>] kobject_put+0x37/0x50
> [    9.693829]  [<ffffffff8127d67d>] put_device+0x17/0x19
> [    9.693846]  [<ffffffffa002ac4f>] edac_create_sysfs_mci_device+0x3ac/0x3f3 [edac_core]
> [    9.693862]  [<ffffffffa0028c95>] edac_mc_add_mc+0x5cf/0x711 [edac_core]
> [    9.693877]  [<ffffffffa00f0807>] amd64_probe_one_instance+0x143b/0x1559 [amd64_edac_mod]
> [    9.693888]  [<ffffffff811e7aac>] local_pci_probe+0x4d/0x96
> [    9.693897]  [<ffffffff81042ecf>] ? cwq_dec_nr_in_flight+0x7b/0x7b
> [    9.693905]  [<ffffffff81042ee7>] do_work_for_cpu+0x18/0x2a
> [    9.693913]  [<ffffffff81048d0d>] kthread+0x89/0x91
> [    9.693922]  [<ffffffff8144ca64>] kernel_thread_helper+0x4/0x10
> [    9.693931]  [<ffffffff81444f4a>] ? retint_restore_args+0xe/0xe
> [    9.693940]  [<ffffffff81048c84>] ? kthread_freezable_should_stop+0x57/0x57
> [    9.693950]  [<ffffffff8144ca60>] ? gs_change+0xb/0xb
> [    9.693955] ---[ end trace c72c379fedc94aa6 ]---
> [    9.693968] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [    9.693976] IP: [<ffffffff8104f240>] __wake_up_common+0x2e/0x84
> [    9.693987] PGD 0 
> [    9.693992] Oops: 0000 [#1] SMP 
> [    9.693999] CPU 6 
> [    9.694002] Modules linked in: radeon(+) ttm drm_kms_helper hwmon backlight e1000e amd64_edac_mod(+) ohci_hcd cfbcopyarea cfbimgblt cfbfillrect ehci_hcd edac_core
> [    9.694022] 
> [    9.694028] Pid: 1569, comm: work_for_cpu Tainted: G        W    3.3.0+ #4 AMD <redacted>/<redacted>
> [    9.694037] RIP: 0010:[<ffffffff8104f240>]  [<ffffffff8104f240>] __wake_up_common+0x2e/0x84
> [    9.694048] RSP: 0018:ffff8804256d5c60  EFLAGS: 00010097
> [    9.694054] RAX: ffffffffffffffe8 RBX: 0000000000000000 RCX: 0000000000000000
> [    9.694060] RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff880824e4e96c
> [    9.694067] RBP: ffff8804256d5ca0 R08: 0000000000000000 R09: 00000000fffffffe
> [    9.694073] R10: ffff8804a56d5b6f R11: 0000000000000000 R12: 0000000000000003
> [    9.694079] R13: ffff880824e4e95c R14: 00000000ffffffff R15: 0000000000000000
> [    9.694087] FS:  00007f605e6cc740(0000) GS:ffff880827c00000(0000) knlGS:0000000000000000
> [    9.694095] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    9.694100] CR2: 0000000000000000 CR3: 0000000001a05000 CR4: 00000000000006e0
> [    9.694106] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    9.694113] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    9.694120] Process work_for_cpu (pid: 1569, threadinfo ffff8804256d4000, task ffff880425510000)
> [    9.694125] Stack:
> [    9.694129]  0000000000000282 ffff880824e4e96c 00000000ffffffff ffff880824e4e964
> [    9.694137]  0000000000000282 ffff880824e4e95c 00000000ffffffff 0000000000000018
> [    9.694146]  ffff8804256d5cd0 ffffffff81051d6d ffff8804256d5d00 ffff880824e4e8ac
> [    9.694154] Call Trace:
> [    9.694164]  [<ffffffff81051d6d>] complete_all+0x40/0x53
> [    9.694175]  [<ffffffff8128699c>] device_pm_remove+0x5e/0xbc
> [    9.694183]  [<ffffffff8127e47a>] device_del+0x44/0x172
> [    9.694199]  [<ffffffffa002ac57>] edac_create_sysfs_mci_device+0x3b4/0x3f3 [edac_core]
> [    9.694214]  [<ffffffffa0028c95>] edac_mc_add_mc+0x5cf/0x711 [edac_core]
> [    9.694229]  [<ffffffffa00f0807>] amd64_probe_one_instance+0x143b/0x1559 [amd64_edac_mod]
> [    9.694239]  [<ffffffff811e7aac>] local_pci_probe+0x4d/0x96
> [    9.694249]  [<ffffffff81042ecf>] ? cwq_dec_nr_in_flight+0x7b/0x7b
> [    9.694257]  [<ffffffff81042ee7>] do_work_for_cpu+0x18/0x2a
> [    9.694265]  [<ffffffff81048d0d>] kthread+0x89/0x91
> [    9.694274]  [<ffffffff8144ca64>] kernel_thread_helper+0x4/0x10
> [    9.694283]  [<ffffffff81444f4a>] ? retint_restore_args+0xe/0xe
> [    9.694292]  [<ffffffff81048c84>] ? kthread_freezable_should_stop+0x57/0x57
> [    9.694301]  [<ffffffff8144ca60>] ? gs_change+0xb/0xb
> [    9.694306] Code: e5 41 57 41 56 41 55 41 54 53 48 83 ec 18 66 66 66 66 90 48 8b 47 08 48 83 c7 08 41 89 f4 89 d3 41 89 cf 48 89 7d c8 48 83 e8 18 <4c> 8b 68 18 49 83 ed 18 eb 33 44 8b 30 4c 89 c1 4c 89 45 c0 44 
> [    9.694363] RIP  [<ffffffff8104f240>] __wake_up_common+0x2e/0x84
> [    9.694372]  RSP <ffff8804256d5c60>
> [    9.694376] CR2: 0000000000000000
> [    9.694382] ---[ end trace c72c379fedc94aa7 ]---
> [    9.870234] Console: switching to colour frame buffer device 128x48
> [   13.530549] fb0: radeondrmfb frame buffer device
> [   13.544530] drm: registered panic notifier
> [   13.557928] [drm] Initialized radeon 2.13.0 20080528 for 0000:02:06.0 on minor 0
> [   68.764044] EXT3-fs (sda2): using internal journal
> [   71.182320] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   74.225091] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
> [   74.246314] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   84.480093] eth0: no IPv6 routers present
> [   87.227601] RPC: Registered named UNIX socket transport module.
> [   87.246392] RPC: Registered udp transport module.
> [   87.263673] RPC: Registered tcp transport module.
> [   87.263678] RPC: Registered tcp NFSv4.1 backchannel transport module.

This is fixed by this patch, already acked-by Greg:
	[EDAC ABI v13 17/25] edac: Create a per-Memory Controller bus
	http://git.infradead.org/users/mchehab/edac.git/commit/a2c90149c2e87e51908003b1ba504f92d749f74b

Basically, on devices with multiple controllers, there a separate per-memory controller bus
is needed due to sysfs nodes under /sys/bus.

I opted to keep it on a separate patch, in order to preserve the history, and properly
document why this is needed.

Regards,
Mauro
