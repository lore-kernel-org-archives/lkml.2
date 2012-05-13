Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab2EMUzG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 16:55:06 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49046 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2EMUzC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 16:55:02 -0400
MIME-Version: 1.0
In-Reply-To: <20120510095044.GA4343@quack.suse.cz>
References: <CADdexAKen1fcZ4Vkbwm=UVKdLai0i_-VCG1jqMDQ5YoytNg95Q@mail.gmail.com>
	<20120510095044.GA4343@quack.suse.cz>
Date: Sun, 13 May 2012 13:55:00 -0700
Message-ID: <CADdexAJvwMmt9uHwDCKLCXG3mU3hx5Uf3y7JdWe_qFOnsFdr5Q@mail.gmail.com>
Subject: Re: [BUG] sync hangs on ext3 filesystem with usb mount on top of
 dm-crypt on top of RAID-1 array
From: Zurk Tech <zurktech@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2 days worth of memtest86+ revealed no errors and the DDR3 DIMMs are a
few months old anyway....
-Z-

On Thu, May 10, 2012 at 2:50 AM, Jan Kara <jack@suse.cz> wrote:
> On Mon 07-05-12 15:44:19, Zurk Tech wrote:
>> I have a RAID-1 array with 2 x 2TB WD caviar greens. I put a luks
>> crypto layer on the array and created an ext3 filesystem on top of
>> that. then i added a mount point and mounted a 3TB usb disk on it. i
>> have sync hanging and when i try to unmount the usb disk i get a :
>> kernel BUG at /build/buildd-linux-2.6_2.6.32-41squeeze2-amd64-NDo8b7/linux-2.6-2.6.32/debian/build/source_amd64_none/fs/dcache.c:670
>> Machine is a bog standard debian squeeze with all latest stable updates.
>> I do the following when it starts up :
>> mdadm --assemble --scan
>> g15stats -d
>> modprobe dm-crypt
>> cryptsetup -v luksOpen /dev/md0 md0
>> e2fsck -y /dev/mapper/md0
>> mount -t ext3 /dev/mapper/md0 /san
>> mount -t ext3 -o ro /dev/sdd1 /san/usb
>> Thanks
>> -Z-
>  So sync was hanging because journal thread has been waiting for IO which
> apparently never finished. This tends to be a driver bug but the kernel
> assertion failure on umount looks more interesting. This message:
>> [1114785.933297] BUG: Dentry ffff880012a49780{i=14363f2,n=Tekniske
>> Manualer} still in use (536870912) [unmount of ext3 sdd1]
>  Shows the filesystem you tried to umount had a dentry whose use count
> (d_count) was 536870912 instead of 0. Since 536870912 is 0x20000000 this is
> very likely caused by buggy memory doing a bit flip so I suggest running
> memtest and replacing the faulty DIMM...
>
>                                                                Honza
>
>> [1114785.933357] ------------[ cut here ]------------
>> [1114785.933371] kernel BUG at
>> /build/buildd-linux-2.6_2.6.32-41squeeze2-amd64-NDo8b7/linux-2.6-2.6.32/debian/build/source_amd64_none/fs/dcache.c:670!
>> [1114785.933395] invalid opcode: 0000 [#1] SMP
>> [1114785.933410] last sysfs file:
>> /sys/devices/virtual/block/md0/md/metadata_version
>> [1114785.935020] CPU 3
>> [1114785.935030] Modules linked in: ext3 jbd sha256_generic aes_x86_64
>> aes_generic cbc raid1 md_mod powernow_k8 cpufreq_conservative
>> cpufreq_userspace cpufreq_stats cpufreq_powersave ppdev lp sco bridge
>> stp bnep rfcomm l2cap crc16 bluetooth rfkill ses enclosure nfsd lockd
>> nfs_acl auth_rpcgss sunrpc exportfs binfmt_misc fuse dm_crypt dm_mod
>> loop snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep
>> snd_pcm snd_seq snd_timer snd_seq_device radeon uinput ttm
>> drm_kms_helper snd soundcore drm pcspkr i2c_algo_bit usb_storage
>> usbhid hid evdev i2c_piix4 i2c_core asus_atk0110 parport_pc parport
>> k10temp edac_core edac_mce_amd button psmouse shpchp pci_hotplug
>> snd_page_alloc wmi processor serio_raw ext2 mbcache sg sr_mod cdrom
>> sd_mod crc_t10dif ata_generic ohci_hcd pata_atiixp ahci libata r8169
>> mii ehci_hcd scsi_mod usbcore nls_base thermal thermal_sys [last
>> unloaded: scsi_wait_scan]
>> [1114785.935323] Pid: 15746, comm: umount Not tainted 2.6.32-5-amd64
>> #1 System Product Name
>> [1114785.935341] RIP: 0010:[<ffffffff810fe56c>]  [<ffffffff810fe56c>]
>> shrink_dcache_for_umount_subtree+0x195/0x26d
>> [1114785.935374] RSP: 0018:ffff88012c427e68  EFLAGS: 00010296
>> [1114785.935387] RAX: 0000000000000083 RBX: ffff880012b4b310 RCX:
>> 00000000000015af
>> [1114785.935403] RDX: 0000000000000000 RSI: 0000000000000092 RDI:
>> 0000000000000246
>> [1114785.935420] RBP: ffff880012a49780 R08: 00000000000133ac R09:
>> 000000000000000a
>> [1114785.935436] R10: 0000000000000000 R11: 0000000100000000 R12:
>> 000000000000002f
>> [1114785.935452] R13: ffff880012a497e0 R14: 0000000000000000 R15:
>> 0000000000000000
>> [1114785.935470] FS:  00007f648532e740(0000) GS:ffff8800088c0000(0000)
>> knlGS:0000000000000000
>> [1114785.935488] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [1114785.935500] CR2: 00007f64849ebdf1 CR3: 000000021ba8b000 CR4:
>> 00000000000006e0
>> [1114785.935517] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> 0000000000000000
>> [1114785.935533] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>> 0000000000000400
>> [1114785.935551] Process umount (pid: 15746, threadinfo
>> ffff88012c426000, task ffff88021c03b170)
>> [1114785.935568] Stack:
>> [1114785.935576]  ffff880039f50270 ffff880039f50000 ffffffffa0513800
>> 0000000000000001
>> [1114785.935595] <0> ffff88021c2f5a00 ffffffff810fe673
>> ffff880039f50000 ffffffff810f0e32
>> [1114785.935619] <0> 0000000000000000 ffff88021eed9040
>> ffffffffa0517780 ffffffff810f0f35
>> [1114785.935647] Call Trace:
>> [1114785.935663]  [<ffffffff810fe673>] ? shrink_dcache_for_umount+0x2f/0x3d
>> [1114785.935680]  [<ffffffff810f0e32>] ? generic_shutdown_super+0x19/0xfa
>> [1114785.935697]  [<ffffffff810f0f35>] ? kill_block_super+0x22/0x3a
>> [1114785.935713]  [<ffffffff810f1605>] ? deactivate_super+0x60/0x77
>> [1114785.935729]  [<ffffffff81103f78>] ? sys_umount+0x2dc/0x30b
>> [1114785.935746]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
>> [1114785.935759] Code: 8b 08 48 8b 45 10 48 85 c0 74 04 48 8b 50 40 48
>> 8d 86 70 02 00 00 48 c7 c7 66 58 3c 81 48 89 ee 48 89 04 24 31 c0 e8
>> 78 c9 1f 00 <0f> 0b eb fe 48 8b 5d 28 48 39 dd 75 04 31 db eb 03 f0 ff
>> 0b 48
>> [1114785.935890] RIP  [<ffffffff810fe56c>]
>> shrink_dcache_for_umount_subtree+0x195/0x26d
>> [1114785.935913]  RSP <ffff88012c427e68>
>> [1114785.936166] ---[ end trace 1179c91d83ddbfb3 ]---
>>
>> cat /proc/cpuinfo
>> processor       : 0
>> vendor_id       : AuthenticAMD
>> cpu family      : 16
>> model           : 4
>> model name      : AMD Phenom(tm) II X4 B55 Processor
>> stepping        : 3
>> cpu MHz         : 800.000
>> cache size      : 512 KB
>> physical id     : 0
>> siblings        : 4
>> core id         : 0
>> cpu cores       : 4
>> apicid          : 0
>> initial apicid  : 0
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 5
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
>> fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
>> nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
>> extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
>> wdt nodeid_msr
>> bogomips        : 6430.12
>> TLB size        : 1024 4K pages
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 48 bits physical, 48 bits virtual
>> power management: ts ttp tm stc 100mhzsteps hwpstate
>>
>> processor       : 1
>> vendor_id       : AuthenticAMD
>> cpu family      : 16
>> model           : 4
>> model name      : AMD Phenom(tm) II X4 B55 Processor
>> stepping        : 3
>> cpu MHz         : 800.000
>> cache size      : 512 KB
>> physical id     : 0
>> siblings        : 4
>> core id         : 1
>> cpu cores       : 4
>> apicid          : 1
>> initial apicid  : 1
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 5
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
>> fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
>> nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
>> extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
>> wdt nodeid_msr
>> bogomips        : 6428.81
>> TLB size        : 1024 4K pages
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 48 bits physical, 48 bits virtual
>> power management: ts ttp tm stc 100mhzsteps hwpstate
>>
>> processor       : 2
>> vendor_id       : AuthenticAMD
>> cpu family      : 16
>> model           : 4
>> model name      : AMD Phenom(tm) II X4 B55 Processor
>> stepping        : 3
>> cpu MHz         : 800.000
>> cache size      : 512 KB
>> physical id     : 0
>> siblings        : 4
>> core id         : 2
>> cpu cores       : 4
>> apicid          : 2
>> initial apicid  : 2
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 5
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
>> fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
>> nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
>> extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
>> wdt nodeid_msr
>> bogomips        : 6428.89
>> TLB size        : 1024 4K pages
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 48 bits physical, 48 bits virtual
>> power management: ts ttp tm stc 100mhzsteps hwpstate
>>
>> processor       : 3
>> vendor_id       : AuthenticAMD
>> cpu family      : 16
>> model           : 4
>> model name      : AMD Phenom(tm) II X4 B55 Processor
>> stepping        : 3
>> cpu MHz         : 800.000
>> cache size      : 512 KB
>> physical id     : 0
>> siblings        : 4
>> core id         : 3
>> cpu cores       : 4
>> apicid          : 3
>> initial apicid  : 3
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 5
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
>> fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
>> nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
>> extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
>> wdt nodeid_msr
>> bogomips        : 6428.84
>> TLB size        : 1024 4K pages
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 48 bits physical, 48 bits virtual
>> power management: ts ttp tm stc 100mhzsteps hwpstate
>>
>> cat /proc/modules
>> ext3 106806 2 - Live 0xffffffffa0500000
>> jbd 37365 1 ext3, Live 0xffffffffa04ed000
>> sha256_generic 8692 2 - Live 0xffffffffa04df000
>> aes_x86_64 7340 2 - Live 0xffffffffa04d1000
>> aes_generic 25714 1 aes_x86_64, Live 0xffffffffa04c5000
>> cbc 2539 1 - Live 0xffffffffa04bf000
>> raid1 18431 1 - Live 0xffffffffa04b4000
>> md_mod 73936 2 raid1, Live 0xffffffffa0497000
>> powernow_k8 10978 1 - Live 0xffffffffa048f000
>> cpufreq_conservative 5162 0 - Live 0xffffffffa0488000
>> cpufreq_userspace 1992 0 - Live 0xffffffffa0482000
>> cpufreq_stats 2740 0 - Live 0xffffffffa047c000
>> cpufreq_powersave 902 0 - Live 0xffffffffa0345000
>> ppdev 5030 0 - Live 0xffffffffa027f000
>> lp 7462 0 - Live 0xffffffffa021f000
>> sco 7225 2 - Live 0xffffffffa01fb000
>> bridge 39678 0 - Live 0xffffffffa0466000
>> stp 1440 1 bridge, Live 0xffffffffa01b4000
>> bnep 9443 2 - Live 0xffffffffa01ea000
>> rfcomm 29645 0 - Live 0xffffffffa045c000
>> l2cap 24752 4 bnep,rfcomm, Live 0xffffffffa0290000
>> crc16 1319 1 l2cap, Live 0xffffffffa0198000
>> bluetooth 41843 6 sco,bnep,rfcomm,l2cap, Live 0xffffffffa044f000
>> rfkill 13060 2 bluetooth, Live 0xffffffffa018f000
>> ses 5144 0 - Live 0xffffffffa016d000
>> enclosure 5519 1 ses, Live 0xffffffffa0141000
>> nfsd 254974 11 - Live 0xffffffffa0401000
>> lockd 57651 1 nfsd, Live 0xffffffffa03f0000
>> nfs_acl 2031 1 nfsd, Live 0xffffffffa0126000
>> auth_rpcgss 33524 1 nfsd, Live 0xffffffffa033a000
>> sunrpc 161717 10 nfsd,lockd,nfs_acl,auth_rpcgss, Live 0xffffffffa03b2000
>> exportfs 3186 1 nfsd, Live 0xffffffffa0116000
>> binfmt_misc 6447 1 - Live 0xffffffffa010d000
>> fuse 50972 1 - Live 0xffffffffa03a3000
>> dm_crypt 10680 1 - Live 0xffffffffa00fa000
>> dm_mod 53994 3 dm_crypt, Live 0xffffffffa0393000
>> loop 11799 0 - Live 0xffffffffa0087000
>> snd_hda_codec_realtek 235698 1 - Live 0xffffffffa0357000
>> snd_hda_intel 20051 0 - Live 0xffffffffa00d2000
>> snd_hda_codec 54244 2 snd_hda_codec_realtek,snd_hda_intel, Live
>> 0xffffffffa0347000
>> snd_hwdep 5380 1 snd_hda_codec, Live 0xffffffffa0044000
>> snd_pcm 60487 2 snd_hda_intel,snd_hda_codec, Live 0xffffffffa0247000
>> snd_seq 42913 0 - Live 0xffffffffa0182000
>> snd_timer 15598 2 snd_pcm,snd_seq, Live 0xffffffffa0077000
>> snd_seq_device 4493 1 snd_seq, Live 0xffffffffa000e000
>> radeon 575020 0 - Live 0xffffffffa029f000
>> uinput 6376 1 - Live 0xffffffffa0298000
>> ttm 40226 1 radeon, Live 0xffffffffa0284000
>> drm_kms_helper 20369 1 radeon, Live 0xffffffffa0278000
>> snd 46542 8 snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq,snd_timer,snd_seq_device,
>> Live 0xffffffffa0261000
>> soundcore 4598 1 snd, Live 0xffffffffa0259000
>> drm 142416 3 radeon,ttm,drm_kms_helper, Live 0xffffffffa0222000
>> pcspkr 1699 0 - Live 0xffffffffa021c000
>> i2c_algo_bit 4209 1 radeon, Live 0xffffffffa0215000
>> usb_storage 40233 1 - Live 0xffffffffa0200000
>> usbhid 33324 0 - Live 0xffffffffa01f0000
>> hid 63273 1 usbhid, Live 0xffffffffa01d8000
>> evdev 7352 10 - Live 0xffffffffa01d1000
>> i2c_piix4 8328 0 - Live 0xffffffffa01c9000
>> i2c_core 15835 5 radeon,drm_kms_helper,drm,i2c_algo_bit,i2c_piix4,
>> Live 0xffffffffa01bd000
>> asus_atk0110 7686 0 - Live 0xffffffffa01b6000
>> parport_pc 18855 1 - Live 0xffffffffa01aa000
>> parport 27954 3 ppdev,lp,parport_pc, Live 0xffffffffa019b000
>> k10temp 2715 0 - Live 0xffffffffa0195000
>> edac_core 29261 0 - Live 0xffffffffa0178000
>> edac_mce_amd 6449 0 - Live 0xffffffffa0171000
>> button 4650 0 - Live 0xffffffffa0169000
>> psmouse 49937 0 - Live 0xffffffffa0154000
>> shpchp 26248 0 - Live 0xffffffffa0146000
>> pci_hotplug 21587 1 shpchp, Live 0xffffffffa0139000
>> snd_page_alloc 6265 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0131000
>> wmi 4323 0 - Live 0xffffffffa0129000
>> processor 29951 1 powernow_k8, Live 0xffffffffa0119000
>> serio_raw 3752 0 - Live 0xffffffffa0113000
>> ext2 52937 1 - Live 0xffffffffa00fe000
>> mbcache 5050 2 ext3,ext2, Live 0xffffffffa00f6000
>> sg 24085 0 - Live 0xffffffffa00e8000
>> sr_mod 12602 0 - Live 0xffffffffa00e2000
>> cdrom 29351 1 sr_mod, Live 0xffffffffa00d8000
>> sd_mod 29953 6 - Live 0xffffffffa00b4000
>> crc_t10dif 1276 1 sd_mod, Live 0xffffffffa0047000
>> ata_generic 3239 0 - Live 0xffffffffa0041000
>> ohci_hcd 19375 0 - Live 0xffffffffa003a000
>> pata_atiixp 3505 0 - Live 0xffffffffa0005000
>> ahci 32886 3 - Live 0xffffffffa00c7000
>> libata 133824 3 ata_generic,pata_atiixp,ahci, Live 0xffffffffa0091000
>> r8169 36872 0 - Live 0xffffffffa006b000
>> mii 3210 1 r8169, Live 0xffffffffa008b000
>> ehci_hcd 32145 0 - Live 0xffffffffa007d000
>> scsi_mod 126789 6 ses,usb_storage,sg,sr_mod,sd_mod,libata, Live
>> 0xffffffffa004a000
>> usbcore 123186 5 usb_storage,usbhid,ohci_hcd,ehci_hcd, Live 0xffffffffa0019000
>> nls_base 6377 1 usbcore, Live 0xffffffffa0012000
>> thermal 11674 0 - Live 0xffffffffa0009000
>> thermal_sys 11942 2 processor,thermal, Live 0xffffffffa0000000
>>
>> cat /proc/ioports
>> 0000-001f : dma1
>> 0020-0021 : pic1
>> 0040-0043 : timer0
>> 0050-0053 : timer1
>> 0060-0060 : keyboard
>> 0064-0064 : keyboard
>> 0070-0071 : rtc0
>> 0080-008f : dma page reg
>> 00a0-00a1 : pic2
>> 00c0-00df : dma2
>> 00f0-00ff : fpu
>> 0170-0177 : 0000:00:14.1
>>   0170-0177 : pata_atiixp
>> 01f0-01f7 : 0000:00:14.1
>>   01f0-01f7 : pata_atiixp
>> 0230-023f : pnp 00:0b
>> 0290-029f : pnp 00:0b
>> 0300-030f : pnp 00:0b
>> 0376-0376 : 0000:00:14.1
>>   0376-0376 : pata_atiixp
>> 0378-037a : parport0
>> 03c0-03df : vga+
>> 03f6-03f6 : 0000:00:14.1
>>   03f6-03f6 : pata_atiixp
>> 03f8-03ff : serial
>> 040b-040b : pnp 00:0a
>> 04d0-04d1 : pnp 00:0a
>> 04d6-04d6 : pnp 00:0a
>> 0800-089f : pnp 00:0a
>>   0800-0803 : ACPI PM1a_EVT_BLK
>>   0804-0805 : ACPI PM1a_CNT_BLK
>>   0808-080b : ACPI PM_TMR
>>   0810-0815 : ACPI CPU throttle
>>   0820-0827 : ACPI GPE0_BLK
>> 0900-090f : pnp 00:0a
>> 0910-091f : pnp 00:0a
>> 0a30-0a3f : pnp 00:0b
>> 0b00-0b3f : pnp 00:0a
>>   0b00-0b0f : pnp 00:0a
>>   0b20-0b3f : pnp 00:0a
>> 0c00-0c01 : pnp 00:0a
>> 0c14-0c14 : pnp 00:0a
>> 0c50-0c51 : pnp 00:0a
>> 0c52-0c52 : pnp 00:0a
>> 0c6c-0c6c : pnp 00:0a
>> 0c6f-0c6f : pnp 00:0a
>> 0cd0-0cd1 : pnp 00:0a
>> 0cd2-0cd3 : pnp 00:0a
>> 0cd4-0cd5 : pnp 00:0a
>> 0cd6-0cd7 : pnp 00:0a
>> 0cd8-0cdf : pnp 00:0a
>> 0cf8-0cff : PCI conf1
>> 8000-800f : 0000:00:11.0
>>   8000-800f : ahci
>> 9000-9003 : 0000:00:11.0
>>   9000-9003 : ahci
>> a000-a007 : 0000:00:11.0
>>   a000-a007 : ahci
>> b000-b003 : 0000:00:11.0
>>   b000-b003 : ahci
>> c000-c007 : 0000:00:11.0
>>   c000-c007 : ahci
>> d000-dfff : PCI Bus 0000:01
>>   d000-d0ff : 0000:01:05.0
>> e000-efff : PCI Bus 0000:02
>>   e800-e8ff : 0000:02:00.0
>>     e800-e8ff : r8169
>> fe00-fefe : pnp 00:0a
>> ff00-ff0f : 0000:00:14.1
>>   ff00-ff0f : pata_atiixp
>>
>> cat /proc/iomem
>> 00000000-0000ffff : reserved
>> 00010000-0009efff : System RAM
>> 0009f000-0009ffff : reserved
>> 000c0000-000ce9ff : Video ROM
>> 000e4000-000fffff : reserved
>>   000f0000-000fffff : System ROM
>> 00100000-cfe7ffff : System RAM
>>   01000000-01302da4 : Kernel code
>>   01302da5-0150310f : Kernel data
>>   015a2000-016d95c3 : Kernel bss
>>   20000000-23ffffff : GART
>> cfe80000-cfe97fff : ACPI Tables
>> cfe98000-cfebffff : ACPI Non-volatile Storage
>> cfec0000-cfefffff : reserved
>> cff00000-cfffffff : RAM buffer
>> d0000000-dfffffff : PCI Bus 0000:01
>>   d0000000-dfffffff : 0000:01:05.0
>> e0000000-efffffff : PCI MMCONFIG 0 [00-ff]
>>   e0000000-efffffff : pnp 00:0c
>> fdf00000-fdffffff : PCI Bus 0000:02
>>   fdff8000-fdffbfff : 0000:02:00.0
>>     fdff8000-fdffbfff : r8169
>>   fdfff000-fdffffff : 0000:02:00.0
>>     fdfff000-fdffffff : r8169
>> fe9f4000-fe9f7fff : 0000:00:14.2
>>   fe9f4000-fe9f7fff : ICH HD audio
>> fe9fa000-fe9fafff : 0000:00:14.5
>>   fe9fa000-fe9fafff : ohci_hcd
>> fe9fb000-fe9fbfff : 0000:00:13.1
>>   fe9fb000-fe9fbfff : ohci_hcd
>> fe9fc000-fe9fcfff : 0000:00:13.0
>>   fe9fc000-fe9fcfff : ohci_hcd
>> fe9fd000-fe9fdfff : 0000:00:12.1
>>   fe9fd000-fe9fdfff : ohci_hcd
>> fe9fe000-fe9fefff : 0000:00:12.0
>>   fe9fe000-fe9fefff : ohci_hcd
>> fe9ff400-fe9ff4ff : 0000:00:13.2
>>   fe9ff400-fe9ff4ff : ehci_hcd
>> fe9ff800-fe9ff8ff : 0000:00:12.2
>>   fe9ff800-fe9ff8ff : ehci_hcd
>> fe9ffc00-fe9fffff : 0000:00:11.0
>>   fe9ffc00-fe9fffff : ahci
>> fea00000-febfffff : PCI Bus 0000:01
>>   fea00000-feafffff : 0000:01:05.0
>>   febe0000-febeffff : 0000:01:05.0
>> fec00000-fec00fff : IOAPIC 0
>> fec10000-fec1001f : pnp 00:0a
>> fed00000-fed003ff : HPET 2
>> fed40000-fed44fff : pnp 00:0a
>> fee00000-fee00fff : Local APIC
>>   fee00000-fee00fff : pnp 00:09
>> ffb80000-ffbfffff : pnp 00:0a
>> ffe00000-ffffffff : reserved
>> 100000000-21fffffff : System RAM
>>
>> lspci -vvv
>> 00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge
>>         Subsystem: ASUSTeK Computer Inc. Device 8388
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>> >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
>>         Latency: 0
>>         Capabilities: [c4] HyperTransport: Slave or Primary Interface
>>                 Command: BaseUnitID=0 UnitCnt=12 MastHost- DefDir- DUL-
>>                 Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC-
>> TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
>>                 Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut-
>> LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
>>                 Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+
>> TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
>>                 Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut-
>> LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
>>                 Revision ID: 3.00
>>                 Link Frequency 0: [b]
>>                 Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
>>                 Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+
>> 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
>>                 Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
>>                 Link Frequency 1: 200MHz
>>                 Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
>>                 Link Frequency Capability 1: 200MHz- 300MHz- 400MHz-
>> 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
>>                 Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE-
>> CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
>>                 Prefetchable memory behind bridge Upper: 00-00
>>                 Bus Number: 00
>>         Capabilities: [54] HyperTransport: UnitID Clumping
>>         Capabilities: [40] HyperTransport: Retry Mode
>>         Capabilities: [9c] HyperTransport: #1a
>>         Capabilities: [f8] HyperTransport: #1c
>>
>> 00:01.0 PCI bridge: ASUSTeK Computer Inc. RS880 PCI to PCI bridge (int
>> gfx) (prog-if 00 [Normal decode])
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 64
>>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
>>         I/O behind bridge: 0000d000-0000dfff
>>         Memory behind bridge: fea00000-febfffff
>>         Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
>>         Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium
>> >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>>         BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>         Capabilities: [44] HyperTransport: MSI Mapping Enable+ Fixed+
>>         Capabilities: [b0] Subsystem: ASUSTeK Computer Inc. Device 8388
>>
>> 00:04.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI
>> bridge (PCIE port 0) (prog-if 00 [Normal decode])
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR+ FastB2B- DisINTx+
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
>>         I/O behind bridge: 0000e000-0000efff
>>         Memory behind bridge: fff00000-000fffff
>>         Prefetchable memory behind bridge: 00000000fdf00000-00000000fdffffff
>>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- <SERR- <PERR-
>>         BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>         Capabilities: [50] Power Management version 3
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>         Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
>> <64ns, L1 <1us
>>                         ExtTag+ RBE+ FLReset-
>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
>> AuxPwr- TransPend-
>>                 LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1,
>> Latency L0 <64ns, L1 <1us
>>                         ClockPM- Surprise- LLActRep+ BwNot+
>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
>> SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
>>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
>> HotPlug- Surprise-
>>                         Slot #4, PowerLimit 25.000W; Interlock- NoCompl+
>>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
>> CmdCplt- HPIrq- LinkChg-
>>                         Control: AttnInd Unknown, PwrInd Unknown,
>> Power- Interlock-
>>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
>> PresDet+ Interlock-
>>                         Changed: MRL- PresDet+ LinkState+
>>                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
>> PMEIntEna- CRSVisible-
>>                 RootCap: CRSVisible-
>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>                 DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
>>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
>>                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
>> SpeedDis-, Selectable De-emphasis: -3.5dB
>>                          Transmit Margin: Normal Operating Range,
>> EnterModifiedCompliance- ComplianceSOS-
>>                          Compliance De-emphasis: -6dB
>>                 LnkSta2: Current De-emphasis Level: -3.5dB
>>         Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
>>                 Address: fee0f00c  Data: 4151
>>         Capabilities: [b0] Subsystem: ASUSTeK Computer Inc. Device 8388
>>         Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
>>         Capabilities: [100 v1] Vendor Specific Information: ID=0001
>> Rev=1 Len=010 <?>
>>         Capabilities: [110 v1] Virtual Channel
>>                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>>                 Arb:    Fixed- WRR32- WRR64- WRR128-
>>                 Ctrl:   ArbSelect=Fixed
>>                 Status: InProgress-
>>                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>>                         Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
>>                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>>                         Status: NegoPending- InProgress-
>>         Kernel driver in use: pcieport
>>
>> 00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA
>> Controller [IDE mode] (prog-if 01 [AHCI 1.0])
>>         Subsystem: ASUSTeK Computer Inc. M4A785TD Motherboard
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 64, Cache Line Size: 64 bytes
>>         Interrupt: pin A routed to IRQ 22
>>         Region 0: I/O ports at c000 [size=8]
>>         Region 1: I/O ports at b000 [size=4]
>>         Region 2: I/O ports at a000 [size=8]
>>         Region 3: I/O ports at 9000 [size=4]
>>         Region 4: I/O ports at 8000 [size=16]
>>         Region 5: Memory at fe9ffc00 (32-bit, non-prefetchable) [size=1K]
>>         Capabilities: [60] Power Management version 2
>>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>         Capabilities: [70] SATA HBA v1.0 InCfgSpace
>>         Kernel driver in use: ahci
>>
>> 00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0
>> Controller (prog-if 10 [OHCI])
>>         Subsystem: ASUSTeK Computer Inc. Device 8389
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 64, Cache Line Size: 64 bytes
>>         Interrupt: pin A routed to IRQ 16
>>         Region 0: Memory at fe9fe000 (32-bit, non-prefetchable) [size=4K]
>>         Kernel driver in use: ohci_hcd
>>
>> 00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1
>> Controller (prog-if 10 [OHCI])
>>         Subsystem: ASUSTeK Computer Inc. Device 8389
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
>> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 64, Cache Line Size: 64 bytes
>>         Interrupt: pin A routed to IRQ 16
>>         Region 0: Memory at fe9fd000 (32-bit, non-prefetchable) [size=4K]
>>         Kernel driver in use: ohci_hcd
>>
>> 00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI
>> Controller (prog-if 20 [EHCI])
>>         Subsystem: ASUSTeK Computer Inc. Device 8389
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
>> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 64, Cache Line Size: 64 bytes
>>         Interrupt: pin B routed to IRQ 17
>>         Region 0: Memory at fe9ff800 (32-bit, non-prefetchable) [size=256]
>>         Capabilities: [c0] Power Management version 2
>>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
>> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>                 Bridge: PM- B3+
>>         Capabilities: [e4] Debug port: BAR=1 offset=00e0
>>         Kernel driver in use: ehci_hcd
>>
>> 00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0
>> Controller (prog-if 10 [OHCI])
>>         Subsystem: ASUSTeK Computer Inc. Device 8389
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 64, Cache Line Size: 64 bytes
>>         Interrupt: pin A routed to IRQ 18
>>         Region 0: Memory at fe9fc000 (32-bit, non-prefetchable) [size=4K]
>>         Kernel driver in use: ohci_hcd
>>
>> 00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1
>> Controller (prog-if 10 [OHCI])
>>         Subsystem: ASUSTeK Computer Inc. Device 8389
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
>> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 64, Cache Line Size: 64 bytes
>>         Interrupt: pin A routed to IRQ 18
>>         Region 0: Memory at fe9fb000 (32-bit, non-prefetchable) [size=4K]
>>         Kernel driver in use: ohci_hcd
>>
>> 00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI
>> Controller (prog-if 20 [EHCI])
>>         Subsystem: ASUSTeK Computer Inc. Device 8389
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
>> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 64, Cache Line Size: 64 bytes
>>         Interrupt: pin B routed to IRQ 19
>>         Region 0: Memory at fe9ff400 (32-bit, non-prefetchable) [size=256]
>>         Capabilities: [c0] Power Management version 2
>>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
>> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>                 Bridge: PM- B3+
>>         Capabilities: [e4] Debug port: BAR=1 offset=00e0
>>         Kernel driver in use: ehci_hcd
>>
>> 00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3c)
>>         Subsystem: ASUSTeK Computer Inc. M4A785TD Motherboard
>>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx+
>>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>> >TAbort- <TAbort+ <MAbort- >SERR- <PERR- INTx-
>>         Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+
>>
>> 00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller
>> (prog-if 8a [Master SecP PriP])
>>         Subsystem: ASUSTeK Computer Inc. Device 8389
>>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 64
>>         Interrupt: pin A routed to IRQ 16
>>         Region 0: I/O ports at 01f0 [size=8]
>>         Region 1: I/O ports at 03f4 [size=1]
>>         Region 2: I/O ports at 0170 [size=8]
>>         Region 3: I/O ports at 0374 [size=1]
>>         Region 4: I/O ports at ff00 [size=16]
>>         Capabilities: [70] MSI: Enable- Count=1/2 Maskable- 64bit-
>>                 Address: 00000000  Data: 0000
>>         Kernel driver in use: pata_atiixp
>>
>> 00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
>>         Subsystem: ASUSTeK Computer Inc. Device 8445
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 64, Cache Line Size: 64 bytes
>>         Interrupt: pin ? routed to IRQ 16
>>         Region 0: Memory at fe9f4000 (64-bit, non-prefetchable) [size=16K]
>>         Capabilities: [50] Power Management version 2
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>         Kernel driver in use: HDA Intel
>>
>> 00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
>>         Subsystem: ASUSTeK Computer Inc. Device 8389
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0
>>
>> 00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
>> (prog-if 01 [Subtractive decode])
>>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 64
>>         Bus: primary=00, secondary=03, subordinate=03, sec-latency=64
>>         I/O behind bridge: 0000f000-00000fff
>>         Memory behind bridge: fff00000-000fffff
>>         Prefetchable memory behind bridge: fff00000-000fffff
>>         Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium
>> >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>>         BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>
>> 00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2
>> Controller (prog-if 10 [OHCI])
>>         Subsystem: ASUSTeK Computer Inc. Device 8389
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 64, Cache Line Size: 64 bytes
>>         Interrupt: pin C routed to IRQ 18
>>         Region 0: Memory at fe9fa000 (32-bit, non-prefetchable) [size=4K]
>>         Kernel driver in use: ohci_hcd
>>
>> 00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor
>> HyperTransport Configuration
>>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Capabilities: [80] HyperTransport: Host or Secondary Interface
>>                 Command: WarmRst+ DblEnd- DevNum=0 ChainSide-
>> HostHide+ Slave- <EOCErr- DUL-
>>                 Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO-
>> <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
>>                 Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut-
>> LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
>>                 Revision ID: 3.00
>>                 Link Frequency: [b]
>>                 Link Error: <Prot- <Ovfl- <EOC- CTLTm-
>>                 Link Frequency Capability: 200MHz+ 300MHz- 400MHz+
>> 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
>>                 Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT-
>> 64bA+ UIDRD- ExtRS- UCnfE-
>>
>> 00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor
>> Address Map
>>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>
>> 00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor
>> DRAM Controller
>>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>
>> 00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor
>> Miscellaneous Control
>>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Capabilities: [f0] Secure device <?>
>>         Kernel driver in use: k10temp
>>
>> 00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor
>> Link Control
>>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>
>> 01:05.0 VGA compatible controller: ATI Technologies Inc 760G [Radeon
>> 3000] (prog-if 00 [VGA controller])
>>         Subsystem: ASUSTeK Computer Inc. Device 8388
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Interrupt: pin A routed to IRQ 18
>>         Region 0: Memory at d0000000 (32-bit, prefetchable) [size=256M]
>>         Region 1: I/O ports at d000 [size=256]
>>         Region 2: Memory at febe0000 (32-bit, non-prefetchable) [size=64K]
>>         Region 5: Memory at fea00000 (32-bit, non-prefetchable) [size=1M]
>>         Expansion ROM at <unassigned> [disabled]
>>         Capabilities: [50] Power Management version 3
>>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>         Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
>>                 Address: 0000000000000000  Data: 0000
>>         Kernel driver in use: radeon
>>
>> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
>> RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)
>>         Subsystem: ASUSTeK Computer Inc. Device 8432
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR+ FastB2B- DisINTx+
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Interrupt: pin A routed to IRQ 25
>>         Region 0: I/O ports at e800 [size=256]
>>         Region 2: Memory at fdfff000 (64-bit, prefetchable) [size=4K]
>>         Region 4: Memory at fdff8000 (64-bit, prefetchable) [size=16K]
>>         Capabilities: [40] Power Management version 3
>>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>>         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
>>                 Address: 00000000fee0f00c  Data: 4161
>>         Capabilities: [70] Express (v2) Endpoint, MSI 01
>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
>> <512ns, L1 <64us
>>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>                         MaxPayload 128 bytes, MaxReadReq 4096 bytes
>>                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
>> AuxPwr+ TransPend-
>>                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
>> Latency L0 unlimited, L1 <64us
>>                         ClockPM+ Surprise- LLActRep- BwNot-
>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
>> SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>                 DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
>>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
>>                 LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
>> SpeedDis-, Selectable De-emphasis: -6dB
>>                          Transmit Margin: Normal Operating Range,
>> EnterModifiedCompliance- ComplianceSOS-
>>                          Compliance De-emphasis: -6dB
>>                 LnkSta2: Current De-emphasis Level: -6dB
>>         Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
>>                 Vector table: BAR=4 offset=00000000
>>                 PBA: BAR=4 offset=00000800
>>         Capabilities: [d0] Vital Product Data
>>                 No end tag found
>>         Capabilities: [100 v1] Advanced Error Reporting
>>                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
>> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>>                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
>> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>>                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
>> UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>>                 CESta:  RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>>                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>>                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
>>         Capabilities: [140 v1] Virtual Channel
>>                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>>                 Arb:    Fixed- WRR32- WRR64- WRR128-
>>                 Ctrl:   ArbSelect=Fixed
>>                 Status: InProgress-
>>                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>>                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>>                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>>                         Status: NegoPending- InProgress-
>>         Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
>>         Kernel driver in use: r8169
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
