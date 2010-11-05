Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab0KEXGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 19:06:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30539 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab0KEXGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 19:06:07 -0400
Message-ID: <4CD48D5E.10309@oracle.com>
Date: Fri, 05 Nov 2010 16:03:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jens Axboe <jaxboe@fusionio.com>, David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.37-rc1 (floppy module load: no device found)
References: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com> <20101103161638.ddc75ace.randy.dunlap@oracle.com> <AANLkTinj2sk==Jw7ZL3RvO_M7iRPW0sQy8dsvabo-V5h@mail.gmail.com>
In-Reply-To: <AANLkTinj2sk==Jw7ZL3RvO_M7iRPW0sQy8dsvabo-V5h@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/10 15:10, Linus Torvalds wrote:
> That first warning says that something stayed on a list even though it
> was released (the 0x6b thing is the kmalloc free poison pattern). And
> the oops looks related to something similar.
> 
> Randy, is this one also related to that ipv6 percpu list corruption?
> IOW, does it go away with
> 
>   http://patchwork.ozlabs.org/patch/69939/
> 
> like one of your other reports did?

The list_debug.c message goes away, but it still gets the GP fault.

> And David - I think we need that patch merged. The error case for when
> the percpu list entry is free'd without unlinking is _so_ annoying
> (random crashes in totally unrelated code) that I think we need to get
> that one closed asap. Hmm?
> 
>                            Linus

New GP fault message, on 2.6.37-rc1-git3 + several patches:

[   93.235463] calling  floppy_module_init+0x0/0x93 [floppy] @ 3220
[   93.243305] Floppy drive(s): fd0 is 1.44M
[   93.235463] calling  floppy_m
[   96.272319] floppy0: no floppy controllers found
[   96.278224] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
[   96.280934] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1.3/devnum
[   96.280934] CPU 1 
[   96.280934] Modules linked in: floppy(+) ipt_MASQUERADE iptable_nat nf_nat af_packet nfsd lockd nfs_acl auth_rpcgss exportfs sco bridge stp llc bnep l2cap crc16 bluetooth rfkill sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 p4_clockmod freq_table speedstep_lib binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm uinput mousedev joydev ppdev snd_intel8x0 snd_ac97_codec ac97_bus snd_seq snd_seq_device snd_pcm usbmouse usbkbd snd_timer led_class snd usbhid iTCO_wdt tg3 hid iTCO_vendor_support dcdbas sg sr_mod i2c_i801 rtc_cmos pcspkr soundcore evdev rtc_core parport_pc rng_core cdrom shpchp snd_page_alloc rtc_lib mac_hid parport pci_hotplug 8250_pnp unix ide_pci_generic ide_core ata_generic pata_acpi ata_piix sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_core firmware_class 
ehci_hcd usbcore nls_base i915 drm_kms_helper intel_agp button intel_gtt video thermal_sys hwmon output [last unloaded: mperf]
[   96.312371] 
[   96.312371] Pid: 3220, comm: modprobe Not tainted 2.6.37-rc1-git3 #1 0HH807/OptiPlex GX620               
[   96.278224] g[   96.312371] RIP: 0010:[<ffffffff810c304b>]  [<ffffffff810c304b>] __lock_acquire+0xd8/0x4e8
eneral protectio[   96.312371] RSP: 0018:ffff88006c8c3d48  EFLAGS: 00010002
n fault: 0000 [#[   96.312371] RAX: 0000000000000002 RBX: 6b6b6b6b6b6b6d13 RCX: 0000000000000000
1] SMP DEBUG_PAG[   96.312371] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 6b6b6b6b6b6b6d13
EALLOC
[   96.312371] RBP: ffff88006c8c3da8 R08: 0000000000000001 R09: 0000000000000001
[   96.312371] R10: ffffffff81814820 R11: ffff88006c8c3e78 R12: 0000000000000000
[   96.312371] R13: ffff88006c9e8000 R14: 0000000000000000 R15: 0000000000000000
[   96.312371] FS:  00007f0fa99786f0(0000) GS:ffff88007c800000(0000) knlGS:0000000000000000
[   96.312371] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   96.312371] CR2: 00007fff7cde9040 CR3: 000000006c8da000 CR4: 00000000000006e0
[   96.312371] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   96.312371] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   96.312371] Process modprobe (pid: 3220, threadinfo ffff88006c8c2000, task ffff88006c9e8000)
[   96.312371] Stack:
[   96.312371]  0000000000000206 ffffffff812b04ee ffff88006c8c3d88 ffffffff811b1f1b
[   96.312371]  ffff88006d2f6ba8 000000006d2f6ba8 ffff88006c8c3d88 0000000000000000
[   96.312371]  ffff88006c9e8000 ffffffff81092644 0000000000000001 0000000000000000
[   96.312371] Call Trace:
[   96.312371]  [<ffffffff812b04ee>] ? disk_release+0x97/0xa3
[   96.312371]  [<ffffffff811b1f1b>] ? __slab_free+0x1b9/0x1d6
[   96.312371]  [<ffffffff81092644>] ? del_timer_sync+0x50/0x15c
[   96.312371]  [<ffffffff810c355b>] lock_acquire+0x100/0x150
[   96.312371]  [<ffffffff81092644>] ? del_timer_sync+0x50/0x15c
[   96.312371]  [<ffffffff81092688>] del_timer_sync+0x94/0x15c
[   96.312371]  [<ffffffff81092644>] ? del_timer_sync+0x50/0x15c
[   96.312371]  [<ffffffff812a6a6a>] blk_sync_queue+0x24/0x55
[   96.312371]  [<ffffffff812a6abd>] blk_cleanup_queue+0x22/0x9b
[   96.312371]  [<ffffffffa0bd90e1>] floppy_init+0x79c/0x7c0 [floppy]
[   96.312371]  [<ffffffff81017b19>] ? read_tsc+0x17/0x29
[   96.312371]  [<ffffffffa0bd9105>] ? floppy_module_init+0x0/0x93 [floppy]
[   96.312371]  [<ffffffffa0bd918d>] floppy_module_init+0x88/0x93 [floppy]
[   96.312371]  [<ffffffffa0bd9105>] ? floppy_module_init+0x0/0x93 [floppy]
[   96.312371]  [<ffffffff810020a6>] do_one_initcall+0x6c/0x1ef
[   96.312371]  [<ffffffff810d529f>] sys_init_module+0xe1/0x2a5
[   96.312371]  [<ffffffff8100ea72>] system_call_fastpath+0x16/0x1b
[   96.312371] Code: 05 63 45 72 01 e8 e4 b1 fb ff 48 ff 05 5f 45 72 01 48 ff 05 60 45 72 01 48 ff 05 69 45 72 01 e9 e3 03 00 00 48 ff 05 55 45 72 01 <48> 81 3b 00 64 0b 82 75 07 48 ff 05 55 45 72 01 83 fe 01 77 13 
[   96.312371] RIP  [<ffffffff810c304b>] __lock_acquire+0xd8/0x4e8
[   96.312371]  RSP <ffff88006c8c3d48>
[   96.312371] ---[ end trace 7bbc73ed1fe8d49d ]---
[   96.280934] last sysfs file: [   96.312371]  ffff88006c9e8000 ffffffff81092644 0000000000000001 0000000000000000
[   96.312371] Call Trace:
[   96.312371] Code: 05 63 45 72 01 e8 e4 b1 fb ff 48 ff 05 5f 45 72 01 48 ff 05 60 45 72 01 48 ff 05 69 45 72 0



-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
