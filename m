Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964997Ab2HWReR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:34:17 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43535 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964886Ab2HWReM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:34:12 -0400
MIME-Version: 1.0
Date: Thu, 23 Aug 2012 13:34:09 -0400
Message-ID: <CAEhu1-6wq1YsNiscGMwP4ud0Q+MrViRzv=kcWCQSBNc8c68N5Q@mail.gmail.com>
Subject: Possible mptsas regression post 3.5.0
From: John Drescher <drescherjm@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Over the last few weeks I have done some reliability testing with
mdraid6 on a machine with 2 lsi mptsas controllers and 13 SATA I
drives. My testing involved physically hot removing a drive forcing
the raid to grab a spare and rebuild. This worked great for the 5 or
so times I did this on gentoo-sources-3.5.0 and lower. However any
attempt to do this on gentoo-sources-3.5.1 or even the 3.6-rc2 git
resulted in a total lockup of the array. I originally thought this was
a mdadm regression and posted about that last week here:

https://lkml.org/lkml/2012/8/17/503

I have since enabled additional kernel debugging options and get the
following output:

[ 1629.132138] md: data-check of RAID array md0
[ 1629.132152] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 1629.132165] md: using maximum available idle IO bandwidth (but not
more than                  200000 KB/sec) for data-check.
[ 1629.132192] md: using 128k window, over a total of 1048512k.
[ 1649.849873] md: md0: data-check done.
[ 2170.325379] mptbase: ioc1: LogInfo(0x31110d00): Originator={PL},
Code={Reset}                 , SubCode(0x0d00) cb_idx mptbase_reply
[ 2174.695292] sd 1:0:3:0: [sdk] Synchronizing SCSI cache
[ 2174.695335] sd 1:0:3:0: [sdk]
[ 2174.695342] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[ 2185.534172] md: super_written gets error=-19, uptodate=0
[ 2185.534191] md/raid:md1: Disk failure on sdk2, disabling device.
[ 2185.534191] md/raid:md1: Operation continuing on 11 devices.
[ 2199.154901] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u:3:6089]
[ 2199.154916] Modules linked in: netconsole configfs w83627ehf
hwmon_vid ipmi_s                 i ipmi_devintf ipmi_msghandler
autofs4 coretemp hwmon kvm_intel kvm e1000e lpc_i                 ch
mfd_core i2c_i801 pcspkr microcode i2c_core video button xts gf128mul
aes_x86                 _64 aes_generic cbc sha256_generic dm_snapshot
dm_crypt dm_mirror dm_region_hash                  dm_log
scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd usb_storage ehci_hcd
megaraid                 _sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahc                 i libahci
pata_marvell pata_mpiix libata
[ 2199.155324] CPU 0
[ 2199.155330] Modules linked in:[ 2199.156397]  netconsole configfs
w83627ehf h                 wmon_vid ipmi_si ipmi_devintf
ipmi_msghandler autofs4 coretemp hwmon kvm_intel k                 vm
e1000e lpc_ich mfd_core i2c_i801 pcspkr microcode i2c_core video
button xts g                 f128mul aes_x86_64 aes_generic cbc
sha256_generic e1000 nfs lockd fscache auth_r                 pcgss
nfs_acl sunrpc reiserfs multipath linear raid0 dm_raid dm_snapshot
dm_cryp                 t dm_mirror dm_region_hash dm_log
scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd usb
_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom s                 d_mod sata_mv ata_piix ahci libahci
pata_marvell pata_mpiix libata

[ 2199.157086] Pid: 6089, comm: kworker/u:3 Not tainted
3.5.1-gentoo-dbg-lock-1                  #2 To be filled by O.E.M. To
be filled by O.E.M./P8B-X series
[ 2199.157221] RIP: 0010:[<ffffffff815c84a2>]  [<ffffffff815c84a2>]
_raw_spin_un                 lock_irqrestore+0x32/0x40
[ 2199.157344] RSP: 0018:ffff880221dadaa0  EFLAGS: 00000282
[ 2199.157405] RAX: 0000000000000000 RBX: ffff880221dada50 RCX: 000000000000b828
[ 2199.157471] RDX: 0000000000002e40 RSI: ffff880226600000 RDI: ffff8802233f2090
[ 2199.157536] RBP: ffff880221dadab0 R08: 0000000000000001 R09: 0000000000000000
[ 2199.157602] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88021e1bc460
[ 2199.157670] R13: 0000000000000082 R14: ffff880221dada20 R15: ffff8802233f20a8
[ 2199.157737] FS:  0000000000000000(0000) GS:ffff880226600000(0000)
knlGS:00000                 00000000000
[ 2199.157854] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2199.157917] CR2: 00007f42a5fb2070 CR3: 0000000001a0b000 CR4: 00000000000407f0
[ 2199.157983] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2199.158048] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2199.158114] Process kworker/u:3 (pid: 6089, threadinfo
ffff880221dac000, task                  ffff88021e1bc460)
[ 2199.158230] Stack:
[ 2199.158285]  ffff88021eb50000 ffff8802233f1ff0 ffff880221dadb00
ffffffff81417                 98a
[ 2199.158408]  0000000000000282 ffff8802233f2000 0000000000000046
ffff8802221e6                 800
[ 2199.158533]  0000000000000008 ffff880222156630 ffff88021eb0b000
1221000005000                 000
[ 2199.158662] Call Trace:
[ 2199.158725]  [<ffffffff8141798a>] scsi_remove_target+0xda/0x1f0
[ 2199.158793]  [<ffffffff81421f45>] sas_rphy_remove+0x55/0x60
[ 2199.158859]  [<ffffffff81421f61>] sas_rphy_delete+0x11/0x20
[ 2199.158925]  [<ffffffff81421f95>] sas_port_delete+0x25/0x160
[ 2199.158989]  [<ffffffff81454b03>] mptsas_del_end_device+0x183/0x270
[ 2199.159054]  [<ffffffff81458fbc>] mptsas_hotplug_work+0x1ec/0x920
[ 2199.159120]  [<ffffffff8145324b>] ? mptsas_free_fw_event+0x6b/0xb0
[ 2199.159187]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2199.159251]  [<ffffffff8145a7b0>] mptsas_firmware_event_work+0xbc0/0xfa0
[ 2199.159319]  [<ffffffff81080d1f>] ? __lock_acquire.isra.27+0x29f/0xb30
[ 2199.159388]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2199.159456]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2199.159524]  [<ffffffff8104c484>] process_one_work+0x184/0x460
[ 2199.159591]  [<ffffffff8104c426>] ? process_one_work+0x126/0x460
[ 2199.159658]  [<ffffffff8104cd5e>] worker_thread+0x15e/0x350
[ 2199.159724]  [<ffffffff8104cc00>] ? manage_workers.isra.32+0x220/0x220
[ 2199.159792]  [<ffffffff81051fad>] kthread+0x9d/0xb0
[ 2199.159854]  [<ffffffff815cfed4>] kernel_thread_helper+0x4/0x10
[ 2199.159917]  [<ffffffff81051f10>] ? __init_kthread_worker+0x70/0x70
[ 2199.159981]  [<ffffffff815cfed0>] ? gs_change+0xb/0xb
[ 2199.160040] Code: 10 48 8b 55 08 48 89 5d f0 48 89 f3 4c 89 65 f8
be 01 00 00                  00 49 89 fc 48 8d 7f 18 e8 58 a6 ab ff 4c
89 e7 e8 d0 8f d8 ff 53 9d <48> 8b 5d                  f0 4c 8b 65 f8
c9 c3 0f 1f 40 00 55 be 01 00 00 00 48
[ 2227.091437] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u:3:6089]
[ 2227.091506] Modules linked in: netconsole configfs w83627ehf
hwmon_vid ipmi_s                 i ipmi_devintf ipmi_msghandler
autofs4 coretemp hwmon kvm_intel kvm e1000e lpc_i                 ch
mfd_core i2c_i801 pcspkr microcode i2c_core video button xts gf128mul
aes_x86                 _64 aes_generic cbc sha256_generic e1000 nfs
lockd fscache auth_rpcgss nfs_acl s                 unrpc reiserfs
multipath linear raid0 dm_raid dm_snapshot dm_crypt dm_mirror dm_
           region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd
uhci_hcd usb_storage ehci_h                 cd megaraid_sas
megaraid_mbox megaraid_mm megaraid sr_mod cdrom sd_mod sata_mv a
          ta_piix ahci libahci pata_marvell pata_mpiix libata
[ 2227.092148] CPU 0
[ 2227.092153] Modules linked in:[ 2227.092209]  netconsole configfs
w83627ehf h                 wmon_vid ipmi_si ipmi_devintf
ipmi_msghandler autofs4 coretemp hwmon kvm_intel k                 vm
e1000e lpc_ich mfd_core i2c_i801 pcspkr microcode i2c_core video
button xts g                 f128mul aes_x86_64 aes_generic cbc
sha256_generic e1000 nfs lockd fscache auth_r                 pcgss
nfs_acl sunrpc reiserfs multipath linear raid0 dm_raid dm_snapshot
dm_cryp                 t dm_mirror dm_region_hash dm_log
scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd usb
_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom s                 d_mod sata_mv ata_piix ahci libahci
pata_marvell pata_mpiix libata

[ 2227.092869] Pid: 6089, comm: kworker/u:3 Not tainted
3.5.1-gentoo-dbg-lock-1                  #2 To be filled by O.E.M. To
be filled by O.E.M./P8B-X series
[ 2227.092997] RIP: 0010:[<ffffffff8140b69a>]  [<ffffffff8140b69a>]
scsi_is_host                 _device+0xa/0x20
[ 2227.093112] RSP: 0018:ffff880221dada88  EFLAGS: 00000246
[ 2227.093173] RAX: 0000000000000000 RBX: ffff880221dada20 RCX: 000000000000b828
[ 2227.093238] RDX: 0000000000002e40 RSI: ffff880226600000 RDI: ffff8802233f22c8
[ 2227.093302] RBP: ffff880221dadab0 R08: 0000000000000001 R09: 0000000000000000
[ 2227.093367] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88021e1bcb48
[ 2227.093431] R13: 0000000000000082 R14: ffff88021e1bc460 R15: ffffffff81061ea5
[ 2227.093496] FS:  0000000000000000(0000) GS:ffff880226600000(0000)
knlGS:00000                 00000000000
[ 2227.093616] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2227.093679] CR2: 00007f42a5fb2070 CR3: 0000000001a0b000 CR4: 00000000000407f0
[ 2227.093744] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2227.093808] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2227.093874] Process kworker/u:3 (pid: 6089, threadinfo
ffff880221dac000, task                  ffff88021e1bc460)
[ 2227.093992] Stack:
[ 2227.094048]  ffffffff81415171 ffff880221dadab0 ffff88021eb50000
ffff8802233f1                 ff0
[ 2227.094176]  ffff8802233f2000 ffff880221dadb00 ffffffff81417a74
0000000000000                 282
[ 2227.094304]  ffff8802233f2000 0000000000000046 ffff8802221e6800
0000000000000                 008
[ 2227.094434] Call Trace:
[ 2227.094493]  [<ffffffff81415171>] ? scsi_target_reap+0x31/0x100
[ 2227.094558]  [<ffffffff81417a74>] scsi_remove_target+0x1c4/0x1f0
[ 2227.094623]  [<ffffffff81421f45>] sas_rphy_remove+0x55/0x60
[ 2227.094687]  [<ffffffff81421f61>] sas_rphy_delete+0x11/0x20
[ 2227.094751]  [<ffffffff81421f95>] sas_port_delete+0x25/0x160
[ 2227.094815]  [<ffffffff81454b03>] mptsas_del_end_device+0x183/0x270
[ 2227.094881]  [<ffffffff81458fbc>] mptsas_hotplug_work+0x1ec/0x920
[ 2227.094949]  [<ffffffff8145324b>] ? mptsas_free_fw_event+0x6b/0xb0
[ 2227.095017]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2227.095083]  [<ffffffff8145a7b0>] mptsas_firmware_event_work+0xbc0/0xfa0
[ 2227.095151]  [<ffffffff81080d1f>] ? __lock_acquire.isra.27+0x29f/0xb30
[ 2227.095220]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2227.095288]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2227.095353]  [<ffffffff8104c484>] process_one_work+0x184/0x460
[ 2227.095415]  [<ffffffff8104c426>] ? process_one_work+0x126/0x460
[ 2227.095478]  [<ffffffff8104cd5e>] worker_thread+0x15e/0x350
[ 2227.095541]  [<ffffffff8104cc00>] ? manage_workers.isra.32+0x220/0x220
[ 2227.095608]  [<ffffffff81051fad>] kthread+0x9d/0xb0
[ 2227.095672]  [<ffffffff815cfed4>] kernel_thread_helper+0x4/0x10
[ 2227.095739]  [<ffffffff81051f10>] ? __init_kthread_worker+0x70/0x70
[ 2227.095807]  [<ffffffff815cfed0>] ? gs_change+0xb/0xb
[ 2227.095870] Code: 90 0f b7 06 55 48 89 e5 5d 39 87 74 fc ff ff 0f
94 c0 0f b6                  c0 c3 66 66 2e 0f 1f 84 00 00 00 00 00 31
c0 48 81 7f 58 20 d0 a4 81 <55> 48 89                  e5 5d 0f 94 c0
c3 66 66 66 66 2e 0f 1f 84 00 00 00 00
[ 2234.564238] INFO: rcu_sched self-detected stall on CPU
[ 2234.564302]  0: (18001 ticks this GP) idle=c6b/140000000000001/0
[ 2234.564364]   (t=18001 jiffies)
[ 2234.564422] sending NMI to all CPUs:
[ 2234.564480] NMI backtrace for cpu 0
[ 2234.564537] CPU 0
[ 2234.564543] Modules linked in:[ 2234.564599]  netconsole configfs
w83627ehf h                 wmon_vid ipmi_si ipmi_devintf
ipmi_msghandler autofs4 coretemp hwmon kvm_intel k                 vm
e1000e lpc_ich mfd_core i2c_i801 pcspkr microcode i2c_core video
button xts g                 f128mul aes_x86_64 aes_generic cbc
sha256_generic e1000 nfs lockd fscache auth_r                 pcgss
linear raid0 dm_raid dm_snapshot dm_crypt dm_mirror dm_region_hash
dm_log                  scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas meg                 araid_mbox
megaraid_mm megaraid sr_mod cdrom sd_mod sata_mv ata_piix ahci libahc
               i pata_marvell pata_mpiix libata

[ 2234.565384] Pid: 6089, comm: kworker/u:3 Not tainted
3.5.1-gentoo-dbg-lock-1                  #2 To be filled by O.E.M. To
be filled by O.E.M./P8B-X series
[ 2234.565524] RIP: 0010:[<ffffffff8134a31f>]  [<ffffffff8134a31f>]
delay_tsc+0x                 2f/0x60
[ 2234.565646] RSP: 0018:ffff880226603dd8  EFLAGS: 00000046
[ 2234.565709] RAX: 00000000d36df40c RBX: 0000000000002710 RCX: 0000000000000000
[ 2234.565778] RDX: 0000000000000020 RSI: 00000000d36df3ec RDI: 000000000030b803
[ 2234.565847] RBP: ffff880226603dd8 R08: 0000000000000000 R09: 0000000000000000
[ 2234.565916] R10: 00000000000005f6 R11: 0000000000000001 R12: ffffffff81a27d00
[ 2234.565985] R13: ffffffff81a27e00 R14: ffffffff8107efb0 R15: ffff88022660d978
[ 2234.566053] FS:  0000000000000000(0000) GS:ffff880226600000(0000)
knlGS:00000                 00000000000
[ 2234.566174] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2234.566240] CR2: 00007f42a5fb2070 CR3: 0000000001a0b000 CR4: 00000000000407f0
[ 2234.566310] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2234.566379] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2234.566447] Process kworker/u:3 (pid: 6089, threadinfo
ffff880221dac000, task                  ffff88021e1bc460)
[ 2234.566569] Stack:
[ 2234.566627]  ffff880226603de8 ffffffff8134a24a ffff880226603df8
ffffffff8134a                 27e
[ 2234.566754]  ffff880226603e18 ffffffff8101fcaa 0000000000000001
ffff8802267cd                 dc0
[ 2234.566882]  ffff880226603e68 ffffffff810b24f9 ffff880226603e78
ffffffff8105e                 120
[ 2234.567006] Call Trace:
[ 2234.567062]  <IRQ>
[ 2234.567068]  [<ffffffff8134a24a>] __delay+0xa/0x10
[ 2234.567187]  [<ffffffff8134a27e>] __const_udelay+0x2e/0x30
[ 2234.567255]  [<ffffffff8101fcaa>] arch_trigger_all_cpu_backtrace+0x6a/0x90
[ 2234.567413]  [<ffffffff810b24f9>] __rcu_pending+0x199/0x4d0
[ 2234.567481]  [<ffffffff8105e120>] ? account_system_time+0x130/0x200
[ 2234.567550]  [<ffffffff8105e09a>] ? account_system_time+0xaa/0x200
[ 2234.567618]  [<ffffffff8107efb0>] ? tick_init_highres+0x20/0x20
[ 2234.567686]  [<ffffffff810b3258>] rcu_check_callbacks+0xb8/0xf0
[ 2234.567754]  [<ffffffff81041443>] update_process_times+0x43/0x80
[ 2234.567822]  [<ffffffff8107f008>] tick_sched_timer+0x58/0x150
[ 2234.567890]  [<ffffffff81055f7c>] __run_hrtimer.isra.32+0x5c/0x100
[ 2234.568972]  [<ffffffff8105666b>] hrtimer_interrupt+0xfb/0x250
[ 2234.569036]  [<ffffffff8101ef54>] smp_apic_timer_interrupt+0x64/0xa0
[ 2234.569101]  [<ffffffff815cf687>] apic_timer_interrupt+0x67/0x70
[ 2234.569164]  <EOI>
[ 2234.569170]  [<ffffffff815c84a2>] ? _raw_spin_unlock_irqrestore+0x32/0x40
[ 2234.569295]  [<ffffffff814151bd>] scsi_target_reap+0x7d/0x100
[ 2234.569362]  [<ffffffff81417a74>] scsi_remove_target+0x1c4/0x1f0
[ 2234.569429]  [<ffffffff81421f45>] sas_rphy_remove+0x55/0x60
[ 2234.569495]  [<ffffffff81421f61>] sas_rphy_delete+0x11/0x20
[ 2234.569562]  [<ffffffff81421f95>] sas_port_delete+0x25/0x160
[ 2234.569628]  [<ffffffff81454b03>] mptsas_del_end_device+0x183/0x270
[ 2234.569694]  [<ffffffff81458fbc>] mptsas_hotplug_work+0x1ec/0x920
[ 2234.569761]  [<ffffffff8145324b>] ? mptsas_free_fw_event+0x6b/0xb0
[ 2234.569827]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2234.569891]  [<ffffffff8145a7b0>] mptsas_firmware_event_work+0xbc0/0xfa0
[ 2234.569957]  [<ffffffff81080d1f>] ? __lock_acquire.isra.27+0x29f/0xb30
[ 2234.570024]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2234.570090]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2234.570156]  [<ffffffff8104c484>] process_one_work+0x184/0x460
[ 2234.570220]  [<ffffffff8104c426>] ? process_one_work+0x126/0x460
[ 2234.570287]  [<ffffffff8104cd5e>] worker_thread+0x15e/0x350
[ 2234.570353]  [<ffffffff8104cc00>] ? manage_workers.isra.32+0x220/0x220
[ 2234.570422]  [<ffffffff81051fad>] kthread+0x9d/0xb0
[ 2234.570487]  [<ffffffff815cfed4>] kernel_thread_helper+0x4/0x10
[ 2234.570556]  [<ffffffff81051f10>] ? __init_kthread_worker+0x70/0x70
[ 2234.570625]  [<ffffffff815cfed0>] ? gs_change+0xb/0xb
[ 2234.570687] Code: 04 25 08 ce 00 00 48 89 e5 0f 1f 00 0f ae e8 0f
31 89 c6 eb                  16 0f 1f 80 00 00 00 00 f3 90 65 8b 0c 25
08 ce 00 00 41 39 c8 75 12 <0f> 1f 00                  0f ae e8 0f 31
89 c2 29 f2 39 fa 72 e1 5d c3 29 c6 01
[ 2234.571087] NMI backtrace for cpu 4
[ 2234.571149] CPU 4
[ 2234.571155] Modules linked in:[ 2234.571213]  netconsole configfs
w83627ehf h                 wmon_vid ipmi_si ipmi_devintf
ipmi_msghandler autofs4 coretemp hwmon kvm_intel k                 vm
e1000e lpc_ich mfd_core i2c_i801 pcspkr microcode i2c_core video
button xts g                 f128mul aes_x86_64 aes_generic cbc
sha256_generic e1000 nfs lockd fscache auth_r                 pcgss
nfs_acl sunrpc reiserfs multipath linear raid0 dm_raid dm_snapshot
dm_cryp                 t dm_mirror dm_region_hash dm_log
scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd usb
_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom s                 d_mod sata_mv ata_piix ahci libahci
pata_marvell pata_mpiix libata

[ 2234.572022] Pid: 0, comm: swapper/4 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To                  be filled by O.E.M. To
be filled by O.E.M./P8B-X series
[ 2234.572157] RIP: 0010:[<ffffffff8101d508>]  [<ffffffff8101d508>]
mwait_idle_w                 ith_hints+0x58/0x70
[ 2234.572279] RSP: 0018:ffff8802235a3e58  EFLAGS: 00000046
[ 2234.572342] RAX: 0000000000000020 RBX: ffff8802232452e8 RCX: 0000000000000001
[ 2234.572411] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[ 2234.572481] RBP: ffff8802235a3e58 R08: ffff8802235a3fd8 R09: 0000000000000000
[ 2234.572550] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000003
[ 2234.572618] R13: ffff880223245000 R14: ffff880223245020 R15: 12ad09af1b03210f
[ 2234.572688] FS:  0000000000000000(0000) GS:ffff880226e00000(0000)
knlGS:00000                 00000000000
[ 2234.572808] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2234.572874] CR2: 00007fab1b8e3000 CR3: 0000000001a0b000 CR4: 00000000000407e0
[ 2234.572943] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2234.573011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2234.573078] Process swapper/4 (pid: 0, threadinfo ffff8802235a2000,
task ffff                 88022359a230)
[ 2234.573200] Stack:
[ 2234.573258]  ffff8802235a3e68 ffffffff8101d54d ffff8802235a3ec8
ffffffff813d8                 3bd
[ 2234.573386]  ffffffff81a17b40 00000000ffffffff 0000000000000000
0000000000000                 001
[ 2234.573512]  ffff8802235a3ee8 ffff880223245020 ffffffff81a48b10
00000000fffff                 ff0
[ 2234.573636] Call Trace:
[ 2234.573693]  [<ffffffff8101d54d>] acpi_processor_ffh_cstate_enter+0x2d/0x30
[ 2234.573761]  [<ffffffff813d83bd>] acpi_idle_enter_bm+0x1dc/0x293
[ 2234.573830]  [<ffffffff814d5e29>] cpuidle_enter+0x19/0x20
[ 2234.573897]  [<ffffffff814d63fb>] cpuidle_idle_call+0x8b/0xf0
[ 2234.573966]  [<ffffffff8100a6da>] cpu_idle+0x5a/0xc0
[ 2234.574034]  [<ffffffff815b7e21>] start_secondary+0x212/0x214
[ 2234.574099] Code: 8b 04 25 f0 b8 00 00 49 8d 80 38 e0 ff ff 48 89
d1 0f 01 c8                  0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09
48 89 f8 48 89 f1 0f 01 c9 <5d> c3 66                  0f 1f 44 00 00
0f ae ba 38 e0 ff ff eb c0 0f 1f 80 00
[ 2234.578736] NMI backtrace for cpu 5
[ 2234.578797] CPU 5
[ 2234.578803] Modules linked in:[ 2234.578859]  netconsole configfs
w83627ehf h                 wmon_vid ipmi_si ipmi_devintf
ipmi_msghandler autofs4 coretemp hwmon kvm_intel k                 vm
e1000e lpc_ich mfd_core i2c_i801 pcspkr microcode i2c_core video
button xts g                 f128mul aes_x86_64 aes_generic cbc
sha256_generic e1000 nfs lockd fscache auth_r                 pcgss
nfs_acl sunrpc reiserfs multipath linear raid0 dm_raid dm_snapshot
dm_cryp                 t dm_mirror dm_region_hash dm_log
scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd usb
_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom s                 d_mod sata_mv ata_piix ahci libahci
pata_marvell pata_mpiix libata

[ 2234.579587] Pid: 0, comm: swapper/5 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To                  be filled by O.E.M. To
be filled by O.E.M./P8B-X series
[ 2234.579721] RIP: 0010:[<ffffffff8101d508>]  [<ffffffff8101d508>]
mwait_idle_w                 ith_hints+0x58/0x70
[ 2234.579846] RSP: 0018:ffff8802235a5e58  EFLAGS: 00000046
[ 2234.579908] RAX: 0000000000000020 RBX: ffff880223245ae8 RCX: 0000000000000001
[ 2234.579975] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[ 2234.580041] RBP: ffff8802235a5e58 R08: ffff8802235a5fd8 R09: 0000000000000000
[ 2234.580108] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000003
[ 2234.580175] R13: ffff880223245800 R14: ffff880223245820 R15: 12ad09af1b034d34
[ 2234.580241] FS:  0000000000000000(0000) GS:ffff880227000000(0000)
knlGS:00000                 00000000000
[ 2234.580361] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2234.580427] CR2: 00007f62e1b73000 CR3: 0000000001a0b000 CR4: 00000000000407e0
[ 2234.580495] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2234.580563] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2234.580631] Process swapper/5 (pid: 0, threadinfo ffff8802235a4000,
task ffff                 88022359c460)
[ 2234.580751] Stack:
[ 2234.580809]  ffff8802235a5e68 ffffffff8101d54d ffff8802235a5ec8
ffffffff813d8                 3bd
[ 2234.580937]  ffffffff81a17b40 00000000ffffffff 0000000000000000
0000000000000                 001
[ 2234.581062]  ffff8802235a5ee8 ffff880223245820 ffffffff81a48b10
00000000fffff                 ff0
[ 2234.581188] Call Trace:
[ 2234.581248]  [<ffffffff8101d54d>] acpi_processor_ffh_cstate_enter+0x2d/0x30
[ 2234.581318]  [<ffffffff813d83bd>] acpi_idle_enter_bm+0x1dc/0x293
[ 2234.581387]  [<ffffffff814d5e29>] cpuidle_enter+0x19/0x20
[ 2234.581454]  [<ffffffff814d63fb>] cpuidle_idle_call+0x8b/0xf0
[ 2234.581521]  [<ffffffff8100a6da>] cpu_idle+0x5a/0xc0
[ 2234.581586]  [<ffffffff815b7e21>] start_secondary+0x212/0x214
[ 2234.581652] Code: 8b 04 25 f0 b8 00 00 49 8d 80 38 e0 ff ff 48 89
d1 0f 01 c8                  0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09
48 89 f8 48 89 f1 0f 01 c9 <5d> c3 66                  0f 1f 44 00 00
0f ae ba 38 e0 ff ff eb c0 0f 1f 80 00
[ 2234.582056] NMI backtrace for cpu 1
[ 2234.582116] CPU 1
[ 2234.582121] Modules linked in:[ 2234.582180]  netconsole configfs
w83627ehf h                 wmon_vid ipmi_si ipmi_devintf
ipmi_msghandler autofs4 coretemp hwmon kvm_intel k                 vm
e1000e lpc_ich mfd_core i2c_i801 pcspkr microcode i2c_core video
button xts g                 f128mul aes_x86_64 aes_generic cbc
sha256_generic e1000 nfs lockd fscache auth_r                 pcgss
nfs_acl sunrpc reiserfs multipath linear raid0 dm_raid dm_snapshot
dm_cryp                 t dm_mirror dm_region_hash dm_log
scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd usb
_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom s                 d_mod sata_mv ata_piix ahci libahci
pata_marvell pata_mpiix libata

[ 2234.582880] Pid: 0, comm: swapper/1 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To                  be filled by O.E.M. To
be filled by O.E.M./P8B-X series
[ 2234.583014] RIP: 0010:[<ffffffff8101d508>]  [<ffffffff8101d508>]
mwait_idle_w                 ith_hints+0x58/0x70
[ 2234.583138] RSP: 0000:ffff88022350de58  EFLAGS: 00000046
[ 2234.583202] RAX: 0000000000000020 RBX: ffff8802226f02e8 RCX: 0000000000000001
[ 2234.583271] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[ 2234.583336] RBP: ffff88022350de58 R08: ffff88022350dfd8 R09: 0000000000000000
[ 2234.583401] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000003
[ 2234.583466] R13: ffff8802226f0000 R14: ffff8802226f0020 R15: 12ad09af1b0364fa
[ 2234.583531] FS:  0000000000000000(0000) GS:ffff880226800000(0000)
knlGS:00000                 00000000000
[ 2234.583644] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2234.583710] CR2: 00007fab1b4b89e8 CR3: 0000000001a0b000 CR4: 00000000000407e0
[ 2234.583778] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2234.583843] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2234.583911] Process swapper/1 (pid: 0, threadinfo ffff88022350c000,
task ffff                 880223592230)
[ 2234.584031] Stack:
[ 2234.584088]  ffff88022350de68 ffffffff8101d54d ffff88022350dec8
ffffffff813d8                 3bd
[ 2234.584213]  ffffffff81a17b40 00000000ffffffff 0000000000000000
0000000000000                 001
[ 2234.584336]  ffff88022350dee8 ffff8802226f0020 ffffffff81a48b10
00000000fffff                 ff0
[ 2234.584457] Call Trace:
[ 2234.584514]  [<ffffffff8101d54d>] acpi_processor_ffh_cstate_enter+0x2d/0x30
[ 2234.584579]  [<ffffffff813d83bd>] acpi_idle_enter_bm+0x1dc/0x293
[ 2234.584643]  [<ffffffff814d5e29>] cpuidle_enter+0x19/0x20
[ 2234.584709]  [<ffffffff814d63fb>] cpuidle_idle_call+0x8b/0xf0
[ 2234.584775]  [<ffffffff8100a6da>] cpu_idle+0x5a/0xc0
[ 2234.584840]  [<ffffffff815b7e21>] start_secondary+0x212/0x214
[ 2234.584905] Code: 8b 04 25 f0 b8 00 00 49 8d 80 38 e0 ff ff 48 89
d1 0f 01 c8                  0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09
48 89 f8 48 89 f1 0f 01 c9 <5d> c3 66                  0f 1f 44 00 00
0f ae ba 38 e0 ff ff eb c0 0f 1f 80 00
[ 2234.585263] NMI backtrace for cpu 2
[ 2234.585268]  0: (18001 ticks this GP) idle=c6b/140000000000001/0
[ 2234.585269]  (detected by 1, t=18007 jiffies)
[ 2234.585270] INFO: Stall ended before state dump start
[ 2234.585266] INFO: rcu_sched detected stalls on CPUs/tasks:
[ 2234.585508] CPU 2 [ 2234.585575] Modules linked in: netconsole
configfs w8362                 7ehf hwmon_vid ipmi_si ipmi_devintf
ipmi_msghandler autofs4 coretemp hwmon kvm_i                 ntel kvm
e1000e lpc_ich mfd_core i2c_i801 pcspkr microcode i2c_core video
button                  xts gf128mul aes_x86_64 aes_generic cbc
sha256_generic e1000 nfs lockd fscache                  auth_rpcgss
nfs_acl sunrpc reiserfs multipath linear raid0 dm_raid dm_snapshot d
              m_crypt dm_mirror dm_region_hash dm_log scsi_wait_scan
sl811_hcd ohci_hcd uhci_h                 cd usb_storage ehci_hcd
megaraid_sas megaraid_mbox megaraid_mm megaraid sr_mod c
  drom sd_mod sata_mv ata_piix ahci libahci pata_marvell pata_mpiix
libata

[ 2234.587328] Pid: 0, comm: swapper/2 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To                  be filled by O.E.M. To
be filled by O.E.M./P8B-X series
[ 2234.587464] RIP: 0010:[<ffffffff8101d508>]  [<ffffffff8101d508>]
mwait_idle_w                 ith_hints+0x58/0x70
[ 2234.587588] RSP: 0018:ffff88022350fe58  EFLAGS: 00000046
[ 2234.587651] RAX: 0000000000000020 RBX: ffff8802232202e8 RCX: 0000000000000001
[ 2234.587719] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[ 2234.587785] RBP: ffff88022350fe58 R08: ffff88022350ffd8 R09: 0000000000000000
[ 2234.587853] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000003
[ 2234.587920] R13: ffff880223220000 R14: ffff880223220020 R15: 12ad09af1b03638a
[ 2234.587987] FS:  0000000000000000(0000) GS:ffff880226a00000(0000)
knlGS:00000                 00000000000
[ 2234.588102] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2234.588170] CR2: 00007fab1b4b89e8 CR3: 0000000001a0b000 CR4: 00000000000407e0
[ 2234.588239] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2234.588308] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2234.588376] Process swapper/2 (pid: 0, threadinfo ffff88022350e000,
task ffff                 880223594460)
[ 2234.588492] Stack:
[ 2234.588548]  ffff88022350fe68 ffffffff8101d54d ffff88022350fec8
ffffffff813d8                 3bd
[ 2234.588672]  ffffffff81a17b40 00000000ffffffff 0000000000000000
0000000000000                 001
[ 2234.588797]  ffff88022350fee8 ffff880223220020 ffffffff81a48b10
00000000fffff                 ff0
[ 2234.588922] Call Trace:
[ 2234.588981]  [<ffffffff8101d54d>] acpi_processor_ffh_cstate_enter+0x2d/0x30
[ 2234.589048]  [<ffffffff813d83bd>] acpi_idle_enter_bm+0x1dc/0x293
[ 2234.589115]  [<ffffffff814d5e29>] cpuidle_enter+0x19/0x20
[ 2234.589182]  [<ffffffff814d63fb>] cpuidle_idle_call+0x8b/0xf0
[ 2234.589250]  [<ffffffff8100a6da>] cpu_idle+0x5a/0xc0
[ 2234.589315]  [<ffffffff815b7e21>] start_secondary+0x212/0x214
[ 2234.589381] Code: 8b 04 25 f0 b8 00 00 49 8d 80 38 e0 ff ff 48 89
d1 0f 01 c8                  0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09
48 89 f8 48 89 f1 0f 01 c9 <5d> c3 66                  0f 1f 44 00 00
0f ae ba 38 e0 ff ff eb c0 0f 1f 80 00
[ 2234.589784] NMI backtrace for cpu 6
[ 2234.589846] CPU 6
[ 2234.589851] Modules linked in:[ 2234.589910]  netconsole configfs
w83627ehf h                 wmon_vid ipmi_si ipmi_devintf
ipmi_msghandler autofs4 coretemp hwmon kvm_intel k                 vm
e1000e lpc_ich mfd_core i2c_i801 pcspkr microcode i2c_core video
button xts g                 f128mul aes_x86_64 aes_generic cbc
sha256_generic e1000 nfs lockd fscache auth_r                 pcgss
nfs_acl sunrpc reiserfs multipath linear raid0 dm_raid dm_snapshot
dm_cryp                 t dm_mirror dm_region_hash dm_log
scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd usb
_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom s                 d_mod sata_mv ata_piix ahci libahci
pata_marvell pata_mpiix libata

[ 2234.590608] Pid: 0, comm: swapper/6 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To                  be filled by O.E.M. To
be filled by O.E.M./P8B-X series
[ 2234.590743] RIP: 0010:[<ffffffff8101d508>]  [<ffffffff8101d508>]
mwait_idle_w                 ith_hints+0x58/0x70
[ 2234.590867] RSP: 0018:ffff8802235a7e58  EFLAGS: 00000046
[ 2234.590929] RAX: 0000000000000020 RBX: ffff8802232462e8 RCX: 0000000000000001
[ 2234.590995] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[ 2234.591060] RBP: ffff8802235a7e58 R08: ffff8802235a7fd8 R09: 0000000000000000
[ 2234.591126] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000003
[ 2234.591193] R13: ffff880223246000 R14: ffff880223246020 R15: 12ad09af1b0354ad
[ 2234.591259] FS:  0000000000000000(0000) GS:ffff880227200000(0000)
knlGS:00000                 00000000000
[ 2234.591379] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2234.591445] CR2: 00007fab1b4b89e8 CR3: 0000000001a0b000 CR4: 00000000000407e0
[ 2234.591513] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2234.591580] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2234.591649] Process swapper/6 (pid: 0, threadinfo ffff8802235a6000,
task ffff                 8802235a8000)
[ 2234.591765] Stack:
[ 2234.591821]  ffff8802235a7e68 ffffffff8101d54d ffff8802235a7ec8
ffffffff813d8                 3bd
[ 2234.591941]  ffffffff81a17b40 00000000ffffffff 0000000000000000
0000000000000                 001
[ 2234.592061]  ffff8802235a7ee8 ffff880223246020 ffffffff81a48b10
00000000fffff                 ff0
[ 2234.592180] Call Trace:
[ 2234.592236]  [<ffffffff8101d54d>] acpi_processor_ffh_cstate_enter+0x2d/0x30
[ 2234.592301]  [<ffffffff813d83bd>] acpi_idle_enter_bm+0x1dc/0x293
[ 2234.592365]  [<ffffffff814d5e29>] cpuidle_enter+0x19/0x20
[ 2234.592427]  [<ffffffff814d63fb>] cpuidle_idle_call+0x8b/0xf0
[ 2234.592489]  [<ffffffff8100a6da>] cpu_idle+0x5a/0xc0
[ 2234.592550]  [<ffffffff815b7e21>] start_secondary+0x212/0x214
[ 2234.592612] Code: 8b 04 25 f0 b8 00 00 49 8d 80 38 e0 ff ff 48 89
d1 0f 01 c8                  0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09
48 89 f8 48 89 f1 0f 01 c9 <5d> c3 66                  0f 1f 44 00 00
0f ae ba 38 e0 ff ff eb c0 0f 1f 80 00
[ 2234.592963] NMI backtrace for cpu 3
[ 2234.593023] CPU 3
[ 2234.593029] Modules linked in:[ 2234.593086]  netconsole configfs
w83627ehf h                 wmon_vid ipmi_si ipmi_devintf
ipmi_msghandler autofs4 coretemp hwmon kvm_intel k                 vm
e1000e lpc_ich mfd_core i2c_i801 pcspkr microcode i2c_core video
button xts g                 f128mul aes_x86_64 aes_generic cbc
sha256_generic e1000 nfs lockd fscache auth_r                 pcgss
nfs_acl sunrpc reiserfs multipath linear raid0 dm_raid dm_snapshot
dm_cryp                 t dm_mirror dm_region_hash dm_log
scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd usb
_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom s                 d_mod sata_mv ata_piix ahci libahci
pata_marvell pata_mpiix libata

[ 2234.593806] Pid: 0, comm: swapper/3 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To                  be filled by O.E.M. To
be filled by O.E.M./P8B-X series
[ 2234.593936] RIP: 0010:[<ffffffff8101d508>]  [<ffffffff8101d508>]
mwait_idle_w                 ith_hints+0x58/0x70
[ 2234.594059] RSP: 0018:ffff8802235a1e58  EFLAGS: 00000046
[ 2234.594124] RAX: 0000000000000020 RBX: ffff8802233a82e8 RCX: 0000000000000001
[ 2234.594192] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[ 2234.594260] RBP: ffff8802235a1e58 R08: ffff8802235a1fd8 R09: 0000000000000000
[ 2234.594330] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000003
[ 2234.594399] R13: ffff8802233a8000 R14: ffff8802233a8020 R15: 12ad09af1b036dbc
[ 2234.594468] FS:  0000000000000000(0000) GS:ffff880226c00000(0000)
knlGS:00000                 00000000000
[ 2234.594588] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2234.594653] CR2: 00007fab1b4b89e8 CR3: 0000000001a0b000 CR4: 00000000000407e0
[ 2234.594719] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2234.594787] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2234.594856] Process swapper/3 (pid: 0, threadinfo ffff8802235a0000,
task ffff                 880223598000)
[ 2234.594975] Stack:
[ 2234.595033]  ffff8802235a1e68 ffffffff8101d54d ffff8802235a1ec8
ffffffff813d8                 3bd
[ 2234.595162]  ffffffff81a17b40 00000000ffffffff 0000000000000000
0000000000000                 001
[ 2234.595290]  ffff8802235a1ee8 ffff8802233a8020 ffffffff81a48b10
00000000fffff                 ff0
[ 2234.595418] Call Trace:
[ 2234.595477]  [<ffffffff8101d54d>] acpi_processor_ffh_cstate_enter+0x2d/0x30
[ 2234.595546]  [<ffffffff813d83bd>] acpi_idle_enter_bm+0x1dc/0x293
[ 2234.595612]  [<ffffffff814d5e29>] cpuidle_enter+0x19/0x20
[ 2234.595678]  [<ffffffff814d63fb>] cpuidle_idle_call+0x8b/0xf0
[ 2234.595744]  [<ffffffff8100a6da>] cpu_idle+0x5a/0xc0
[ 2234.595809]  [<ffffffff815b7e21>] start_secondary+0x212/0x214
[ 2234.595873] Code: 8b 04 25 f0 b8 00 00 49 8d 80 38 e0 ff ff 48 89
d1 0f 01 c8                  0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09
48 89 f8 48 89 f1 0f 01 c9 <5d> c3 66                  0f 1f 44 00 00
0f ae ba 38 e0 ff ff eb c0 0f 1f 80 00
[ 2234.596280] NMI backtrace for cpu 7
[ 2234.596339] CPU 7
[ 2234.596344] Modules linked in:[ 2234.596402]  netconsole configfs
w83627ehf h                 wmon_vid ipmi_si ipmi_devintf
ipmi_msghandler autofs4 coretemp hwmon kvm_intel k                 vm
e1000e lpc_ich mfd_core i2c_i801 pcspkr microcode i2c_core video
button xts g                 f128mul aes_x86_64 aes_generic cbc
sha256_generic e1000 nfs lockd fscache auth_r                 pcgss
nfs_acl sunrpc reiserfs multipath linear raid0 dm_raid dm_snapshot
dm_cryp                 t dm_mirror dm_region_hash dm_log
scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd usb
_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom s                 d_mod sata_mv ata_piix ahci libahci
pata_marvell pata_mpiix libata

[ 2234.597108] Pid: 0, comm: swapper/7 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To                  be filled by O.E.M. To
be filled by O.E.M./P8B-X series
[ 2234.597236] RIP: 0010:[<ffffffff8101d508>]  [<ffffffff8101d508>]
mwait_idle_w                 ith_hints+0x58/0x70
[ 2234.597354] RSP: 0018:ffff8802235b1e58  EFLAGS: 00000046
[ 2234.597415] RAX: 0000000000000020 RBX: ffff880223246ae8 RCX: 0000000000000001
[ 2234.597482] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[ 2234.597550] RBP: ffff8802235b1e58 R08: ffff8802235b1fd8 R09: 0000000000000000
[ 2234.597618] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000003
[ 2234.597686] R13: ffff880223246800 R14: ffff880223246820 R15: 12ad09af1b035836
[ 2234.597754] FS:  0000000000000000(0000) GS:ffff880227400000(0000)
knlGS:00000                 00000000000
[ 2234.597873] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2234.597938] CR2: 000000000062b2c8 CR3: 0000000001a0b000 CR4: 00000000000407e0
[ 2234.598005] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2234.598073] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2234.598138] Process swapper/7 (pid: 0, threadinfo ffff8802235b0000,
task ffff                 8802235aa230)
[ 2234.598254] Stack:
[ 2234.598310]  ffff8802235b1e68 ffffffff8101d54d ffff8802235b1ec8
ffffffff813d8                 3bd
[ 2234.598434]  ffffffff81a17b40 00000000ffffffff 0000000000000000
0000000000000                 001
[ 2234.598561]  ffff8802235b1ee8 ffff880223246820 ffffffff81a48b10
00000000fffff                 ff0
[ 2234.598688] Call Trace:
[ 2234.598747]  [<ffffffff8101d54d>] acpi_processor_ffh_cstate_enter+0x2d/0x30
[ 2234.598815]  [<ffffffff813d83bd>] acpi_idle_enter_bm+0x1dc/0x293
[ 2234.598882]  [<ffffffff814d5e29>] cpuidle_enter+0x19/0x20
[ 2234.598946]  [<ffffffff814d63fb>] cpuidle_idle_call+0x8b/0xf0
[ 2234.599010]  [<ffffffff8100a6da>] cpu_idle+0x5a/0xc0
[ 2234.599074]  [<ffffffff815b7e21>] start_secondary+0x212/0x214
[ 2234.599137] Code: 8b 04 25 f0 b8 00 00 49 8d 80 38 e0 ff ff 48 89
d1 0f 01 c8                  0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09
48 89 f8 48 89 f1 0f 01 c9 <5d> c3 66                  0f 1f 44 00 00
0f ae ba 38 e0 ff ff eb c0 0f 1f 80 00
[ 2234.594787] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2234.594856] Process swapper/3 (pid: 0, threadinfo ffff8802235a0000,
task ffff880223598000)
[ 2234.594975] Stack:
[ 2234.595033]  ffff8802235a1e68 ffffffff8101d54d ffff8802235a1ec8
ffffffff813d83bd
[ 2234.595162]  ffffffff81a17b40 00000000ffffffff 0000000000000000
0000000000000001
[ 2234.595290]  ffff8802235a1ee8 ffff8802233a8020 ffffffff81a48b10
00000000fffffff0
[ 2234.595418] Call Trace:
[ 2234.595477]  [<ffffffff8101d54d>] acpi_processor_ffh_cstate_enter+0x2d/0x30
[ 2234.595546]  [<ffffffff813d83bd>] acpi_idle_enter_bm+0x1dc/0x293
[ 2234.595612]  [<ffffffff814d5e29>] cpuidle_enter+0x19/0x20
[ 2234.595678]  [<ffffffff814d63fb>] cpuidle_idle_call+0x8b/0xf0
[ 2234.595744]  [<ffffffff8100a6da>] cpu_idle+0x5a/0xc0
[ 2234.595809]  [<ffffffff815b7e21>] start_secondary+0x212/0x214
[ 2234.595873] Code: 8b 04 25 f0 b8 00 00 49 8d 80 38 e0 ff ff 48 89
d1 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89
f1 0f 01 c9 <5d> c3 66 0f 1f 44 00 00 0f ae ba 38 e0 ff ff eb c0 0f 1f
80 00
[ 2234.596280] NMI backtrace for cpu 7
[ 2234.596339] CPU 7
[ 2234.596344] Modules linked in:[ 2234.596402]  netconsole configfs
w83627ehf hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4
coretemp hwmon kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr
microcode i2c_core video button xts gf128mul aes_x86_64 aes_generic
cbc sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc
reiserfs multipath linear raid0 dm_raid dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata

[ 2234.597108] Pid: 0, comm: swapper/7 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To be filled by O.E.M. To be filled by
O.E.M./P8B-X series
[ 2234.597236] RIP: 0010:[<ffffffff8101d508>]  [<ffffffff8101d508>]
mwait_idle_with_hints+0x58/0x70
[ 2234.597354] RSP: 0018:ffff8802235b1e58  EFLAGS: 00000046
[ 2234.597415] RAX: 0000000000000020 RBX: ffff880223246ae8 RCX: 0000000000000001
[ 2234.597482] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[ 2234.597550] RBP: ffff8802235b1e58 R08: ffff8802235b1fd8 R09: 0000000000000000
[ 2234.597618] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000003
[ 2234.597686] R13: ffff880223246800 R14: ffff880223246820 R15: 12ad09af1b035836
[ 2234.597754] FS:  0000000000000000(0000) GS:ffff880227400000(0000)
knlGS:0000000000000000
[ 2234.597873] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2234.597938] CR2: 000000000062b2c8 CR3: 0000000001a0b000 CR4: 00000000000407e0
[ 2234.598005] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2234.598073] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2234.598138] Process swapper/7 (pid: 0, threadinfo ffff8802235b0000,
task ffff8802235aa230)
[ 2234.598254] Stack:
[ 2234.598310]  ffff8802235b1e68 ffffffff8101d54d ffff8802235b1ec8
ffffffff813d83bd
[ 2234.598434]  ffffffff81a17b40 00000000ffffffff 0000000000000000
0000000000000001
[ 2234.598561]  ffff8802235b1ee8 ffff880223246820 ffffffff81a48b10
00000000fffffff0
[ 2234.598688] Call Trace:
[ 2234.598747]  [<ffffffff8101d54d>] acpi_processor_ffh_cstate_enter+0x2d/0x30
[ 2234.598815]  [<ffffffff813d83bd>] acpi_idle_enter_bm+0x1dc/0x293
[ 2234.598882]  [<ffffffff814d5e29>] cpuidle_enter+0x19/0x20
[ 2234.598946]  [<ffffffff814d63fb>] cpuidle_idle_call+0x8b/0xf0
[ 2234.599010]  [<ffffffff8100a6da>] cpu_idle+0x5a/0xc0
[ 2234.599074]  [<ffffffff815b7e21>] start_secondary+0x212/0x214
[ 2234.599137] Code: 8b 04 25 f0 b8 00 00 49 8d 80 38 e0 ff ff 48 89
d1 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89
f1 0f 01 c9 <5d> c3 66 0f 1f 44 00 00 0f ae ba 38 e0 ff ff eb c0 0f 1f
80 00
[ 2259.018905] BUG: soft lockup - CPU#0 stuck for 22s! [kworker/u:3:6089]
[ 2259.018973] Modules linked in: netconsole configfs w83627ehf
hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4 coretemp hwmon
kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr microcode
i2c_core video button xts gf128mul aes_x86_64 aes_generic cbc
sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata
[ 2259.020627] CPU 0
[ 2259.020632] Modules linked in:[ 2259.020689]  netconsole configfs
w83627ehf hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4
coretemp hwmon kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr
microcode i2c_core video button xts gf128mul aes_x86_64 aes_generic
cbc sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc
reiserfs multipath linear raid0 dm_raid dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata

[ 2259.021357] Pid: 6089, comm: kworker/u:3 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To be filled by O.E.M. To be filled by
O.E.M./P8B-X series
[ 2259.021493] RIP: 0010:[<ffffffff815c84a2>]  [<ffffffff815c84a2>]
_raw_spin_unlock_irqrestore+0x32/0x40
[ 2259.021615] RSP: 0018:ffff880221dada70  EFLAGS: 00000286
[ 2259.021678] RAX: 0000000000000000 RBX: ffff880221dada20 RCX: 000000000000b828
[ 2259.021744] RDX: 0000000000002e40 RSI: ffff880226600000 RDI: ffff8802233f2090
[ 2259.021811] RBP: ffff880221dada80 R08: 0000000000000001 R09: 0000000000000000
[ 2259.021877] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88021e1bc460
[ 2259.021943] R13: 0000000000000082 R14: ffff880221dad9f0 R15: ffff8802233f20a8
[ 2259.022012] FS:  0000000000000000(0000) GS:ffff880226600000(0000)
knlGS:0000000000000000
[ 2259.022132] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2259.022195] CR2: 00007f42a5fb2070 CR3: 0000000001a0b000 CR4: 00000000000407f0
[ 2259.022260] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2259.022326] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2259.022392] Process kworker/u:3 (pid: 6089, threadinfo
ffff880221dac000, task ffff88021e1bc460)
[ 2259.022512] Stack:
[ 2259.022569]  ffff88021eb50000 ffff8802233f2000 ffff880221dadab0
ffffffff814151bd
[ 2259.022695]  ffff880221dadab0 ffff88021eb50000 ffff8802233f1ff0
ffff8802233f2000
[ 2259.022820]  ffff880221dadb00 ffffffff81417a74 0000000000000282
ffff8802233f2000
[ 2259.023045] Call Trace:
[ 2259.023103]  [<ffffffff814151bd>] scsi_target_reap+0x7d/0x100
[ 2259.023165]  [<ffffffff81417a74>] scsi_remove_target+0x1c4/0x1f0
[ 2259.023228]  [<ffffffff81421f45>] sas_rphy_remove+0x55/0x60
[ 2259.023291]  [<ffffffff81421f61>] sas_rphy_delete+0x11/0x20
[ 2259.023357]  [<ffffffff81421f95>] sas_port_delete+0x25/0x160
[ 2259.023422]  [<ffffffff81454b03>] mptsas_del_end_device+0x183/0x270
[ 2259.023488]  [<ffffffff81458fbc>] mptsas_hotplug_work+0x1ec/0x920
[ 2259.023556]  [<ffffffff8145324b>] ? mptsas_free_fw_event+0x6b/0xb0
[ 2259.023623]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2259.023690]  [<ffffffff8145a7b0>] mptsas_firmware_event_work+0xbc0/0xfa0
[ 2259.023758]  [<ffffffff81080d1f>] ? __lock_acquire.isra.27+0x29f/0xb30
[ 2259.023825]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2259.023891]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2259.023955]  [<ffffffff8104c484>] process_one_work+0x184/0x460
[ 2259.024018]  [<ffffffff8104c426>] ? process_one_work+0x126/0x460
[ 2259.024081]  [<ffffffff8104cd5e>] worker_thread+0x15e/0x350
[ 2259.024143]  [<ffffffff8104cc00>] ? manage_workers.isra.32+0x220/0x220
[ 2259.024208]  [<ffffffff81051fad>] kthread+0x9d/0xb0
[ 2259.024270]  [<ffffffff815cfed4>] kernel_thread_helper+0x4/0x10
[ 2259.024336]  [<ffffffff81051f10>] ? __init_kthread_worker+0x70/0x70
[ 2259.024404]  [<ffffffff815cfed0>] ? gs_change+0xb/0xb
[ 2259.024468] Code: 10 48 8b 55 08 48 89 5d f0 48 89 f3 4c 89 65 f8
be 01 00 00 00 49 89 fc 48 8d 7f 18 e8 58 a6 ab ff 4c 89 e7 e8 d0 8f
d8 [ 2286.955440] BUG: soft lockup - CPU#0 stuck for 22s!
[kworker/u:3:6089]
[ 2286.955508] Modules linked in: netconsole configfs w83627ehf
hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4 coretemp hwmon
kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr microcode
i2c_core video button xts gf128mul aes_x86_64 aes_generic cbc
sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata
[ 2286.956139] CPU 0
[ 2286.956144] Modules linked in:[ 2286.956203]  netconsole configfs
w83627ehf hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4
coretemp hwmon kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr
microcode i2c_core video button xts gf128mul aes_x86_64 aes_generic
cbc sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc
reiserfs multipath linear raid0 dm_raid dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata

[ 2286.956879] Pid: 6089, comm: kworker/u:3 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To be filled by O.E.M. To be filled by
O.E.M./P8B-X series
[ 2286.957014] RIP: 0010:[<ffffffff81415148>]  [<ffffffff81415148>]
scsi_target_reap+0x8/0x100
[ 2286.957138] RSP: 0018:ffff880221dadaa0  EFLAGS: 00000282
[ 2286.957203] RAX: 0000000000000000 RBX: ffff880221dada50 RCX: 000000000000b828
[ 2286.957271] RDX: 0000000000002e40 RSI: ffff880226600000 RDI: ffff88021eb50000
[ 2286.957338] RBP: ffff880221dadab0 R08: 0000000000000001 R09: 0000000000000000
[ 2286.957405] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88021e1bc460
[ 2286.957474] R13: 0000000000000082 R14: ffff880221dada20 R15: ffff8802233f20a8
[ 2286.957542] FS:  0000000000000000(0000) GS:ffff880226600000(0000)
knlGS:0000000000000000
[ 2286.957661] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2286.957724] CR2: 00007f42a5fb2070 CR3: 0000000001a0b000 CR4: 00000000000407f0
[ 2286.957791] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2286.957859] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2286.957927] Process kworker/u:3 (pid: 6089, threadinfo
ffff880221dac000, task ffff88021e1bc460)
[ 2286.958047] Stack:
[ 2286.958105]  ffff8802233f1ff0 ffff8802233f2000 ffff880221dadb00
ffffffff81417a74
[ 2286.958231]  0000000000000282 ffff8802233f2000 0000000000000046
ffff8802221e6800
[ 2286.958356]  0000000000000008 ffff880222156630 ffff88021eb0b000
1221000005000000
[ 2286.958483] Call Trace:
[ 2286.958542]  [<ffffffff81417a74>] scsi_remove_target+0x1c4/0x1f0
[ 2286.958610]  [<ffffffff81421f45>] sas_rphy_remove+0x55/0x60
[ 2286.958677]  [<ffffffff81421f61>] sas_rphy_delete+0x11/0x20
[ 2286.958742]  [<ffffffff81421f95>] sas_port_delete+0x25/0x160
[ 2286.958810]  [<ffffffff81454b03>] mptsas_del_end_device+0x183/0x270
[ 2286.958876]  [<ffffffff81458fbc>] mptsas_hotplug_work+0x1ec/0x920
[ 2286.958944]  [<ffffffff8145324b>] ? mptsas_free_fw_event+0x6b/0xb0
[ 2286.959011]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2286.959075]  [<ffffffff8145a7b0>] mptsas_firmware_event_work+0xbc0/0xfa0
[ 2286.959140]  [<ffffffff81080d1f>] ? __lock_acquire.isra.27+0x29f/0xb30
[ 2286.959205]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2286.959272]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2286.959339]  [<ffffffff8104c484>] process_one_work+0x184/0x460
[ 2286.959405]  [<ffffffff8104c426>] ? process_one_work+0x126/0x460
[ 2286.959473]  [<ffffffff8104cd5e>] worker_thread+0x15e/0x350
[ 2286.959539]  [<ffffffff8104cc00>] ? manage_workers.isra.32+0x220/0x220
[ 2286.959606]  [<ffffffff81051fad>] kthread+0x9d/0xb0
[ 2286.959672]  [<ffffffff815cfed4>] kernel_thread_helper+0x4/0x10
[ 2286.959740]  [<ffffffff81051f10>] ? __init_kthread_worker+0x70/0x70
[ 2286.959807]  [<ffffffff815cfed0>] ? gs_change+0xb/0xb
[ 2286.959870] Code: 95 50 ff ff ff e8 ec 81 1a 00 b9 01 00 00 00 4c
8b 95 50 ff ff ff e9 56 f5 ff ff 0f 1f 84 00 00 00 00 00 55 48 89 e5
41 55 41 54 <53> 48 89 fb 48 83 ec 08 4c 8b 67 28 eb 13 66 2e 0f 1f 84
00 00
[ 2314.891975] BUG: soft lockup - CPU#0 stuck for 22s! [kworker/u:3:6089]
[ 2314.892043] Modules linked in: netconsole configfs w83627ehf
hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4 coretemp hwmon
kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr microcode
i2c_core video button xts gf128mul aes_x86_64 aes_generic cbc
sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc
reiserfs multipath linear raid0 dm_raid dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata
[ 2314.892761] CPU 0
[ 2314.892766] Modules linked in:[ 2314.892897]  netconsole configfs
w83627ehf hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4
coretemp hwmon kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr
microcode i2c_core video button xts gf128mul aes_x86_64 aes_generic
cbc sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc
reiserfs multipath linear raid0 dm_raid dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata

[ 2314.893578] Pid: 6089, comm: kworker/u:3 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To be filled by O.E.M. To be filled by
O.E.M./P8B-X series
[ 2314.893792] RIP: 0010:[<ffffffff815c84a2>]  [<ffffffff815c84a2>]
_raw_spin_unlock_irqrestore+0x32/0x40
[ 2314.893912] RSP: 0018:ffff880221dada70  EFLAGS: 00000286
[ 2314.893974] RAX: 0000000000000000 RBX: ffff880221dada20 RCX: 000000000000b828
[ 2314.894040] RDX: 0000000000002e40 RSI: ffff880226600000 RDI: ffff8802233f2090
[ 2314.894104] RBP: ffff880221dada80 R08: 0000000000000001 R09: 0000000000000000
[ 2314.894170] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88021e1bc460
[ 2314.894236] R13: 0000000000000082 R14: ffff880221dad9f0 R15: ffff8802233f20a8
[ 2314.894302] FS:  0000000000000000(0000) GS:ffff880226600000(0000)
knlGS:0000000000000000
[ 2314.894423] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2314.894489] CR2: 00007f42a5fb2070 CR3: 0000000001a0b000 CR4: 00000000000407f0
[ 2314.894558] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2314.894626] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2314.894694] Process kworker/u:3 (pid: 6089, threadinfo
ffff880221dac000, task ffff88021e1bc460)
[ 2314.894813] Stack:
[ 2314.894869]  ffff88021eb50000 ffff8802233f2000 ffff880221dadab0
ffffffff814151bd
[ 2314.894995]  ffff880221dadab0 ffff88021eb50000 ffff8802233f1ff0
ffff8802233f2000
[ 2314.895121]  ffff880221dadb00 ffffffff81417a74 0000000000000282
ffff8802233f2000
[ 2314.895240] Call Trace:
[ 2314.895296]  [<ffffffff814151bd>] scsi_target_reap+0x7d/0x100
[ 2314.895358]  [<ffffffff81417a74>] scsi_remove_target+0x1c4/0x1f0
[ 2314.895420]  [<ffffffff81421f45>] sas_rphy_remove+0x55/0x60
[ 2314.895482]  [<ffffffff81421f61>] sas_rphy_delete+0x11/0x20
[ 2314.896521]  [<ffffffff81421f95>] sas_port_delete+0x25/0x160
[ 2314.896583]  [<ffffffff81454b03>] mptsas_del_end_device+0x183/0x270
[ 2314.896647]  [<ffffffff81458fbc>] mptsas_hotplug_work+0x1ec/0x920
[ 2314.896783]  [<ffffffff8145324b>] ? mptsas_free_fw_event+0x6b/0xb0
[ 2314.896850]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2314.896915]  [<ffffffff8145a7b0>] mptsas_firmware_event_work+0xbc0/0xfa0
[ 2314.896982]  [<ffffffff81080d1f>] ? __lock_acquire.isra.27+0x29f/0xb30
[ 2314.897047]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2314.897113]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2314.897178]  [<ffffffff8104c484>] process_one_work+0x184/0x460
[ 2314.897242]  [<ffffffff8104c426>] ? process_one_work+0x126/0x460
[ 2314.897305]  [<ffffffff8104cd5e>] worker_thread+0x15e/0x350
[ 2314.897367]  [<ffffffff8104cc00>] ? manage_workers.isra.32+0x220/0x220
[ 2314.897432]  [<ffffffff81051fad>] kthread+0x9d/0xb0
[ 2314.897496]  [<ffffffff815cfed4>] kernel_thread_helper+0x4/0x10
[ 2314.897563]  [<ffffffff81051f10>] ? __init_kthread_worker+0x70/0x70
[ 2314.897631]  [<ffffffff815cfed0>] ? gs_change+0xb/0xb
[ 2314.897691] Code: 10 48 8b 55 08 48 89 5d f0 48 89 f3 4c 89 65 f8
be 01 00 00 00 49 89 fc 48 8d 7f 18 e8 58 a6 ab ff 4c 89 e7 e8 d0 8f
d8 ff 53 9d <48> 8b 5d f0 4c 8b 65 f8 c9 c3 0f 1f 40 00 55 be 01 00 00
00 48
[ 2342.828510] BUG: soft lockup - CPU#0 stuck for 22s! [kworker/u:3:6089]
[ 2342.828574] Modules linked in: netconsole configfs w83627ehf
hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4 coretemp hwmon
kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr microcode
i2c_core video button xts gf128mul aes_x86_64 aes_generic cbc
sha256_generic dm_mirror dm_region_hash dm_log scsi_wait_scan
sl811_hcd ohci_hcd uhci_hcd usb_storage ehci_hcd megaraid_sas
megaraid_mbox megaraid_mm megaraid sr_mod cdrom sd_mod sata_mv
ata_piix ahci libahci pata_marvell pata_mpiix libata
[ 2342.829192] CPU 0
[ 2342.829197] Modules linked in:[ 2342.829254]  netconsole configfs
w83627ehf hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4
coretemp hwmon kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr
microcode i2c_core video button xts gf128mul aes_x86_64 aes_generic
cbc sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc
reiserfs multipath linear raid0 dm_raid dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata

[ 2342.830039] Pid: 6089, comm: kworker/u:3 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To be filled by O.E.M. To be filled by
O.E.M./P8B-X series
[ 2342.830168] RIP: 0010:[<ffffffff815c84a2>]  [<ffffffff815c84a2>]
_raw_spin_unlock_irqrestore+0x32/0x40
[ 2342.830290] RSP: 0018:ffff880221dadaa0  EFLAGS: 00000282
[ 2342.830353] RAX: 0000000000000000 RBX: ffff880221dada50 RCX: 000000000000b828
[ 2342.830420] RDX: 0000000000002e40 RSI: ffff880226600000 RDI: ffff8802233f2090
[ 2342.830488] RBP: ffff880221dadab0 R08: 0000000000000001 R09: 0000000000000000
[ 2342.830556] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88021e1bc460
[ 2342.830623] R13: 0000000000000082 R14: ffff880221dada20 R15: ffff8802233f20a8
[ 2342.830691] FS:  0000000000000000(0000) GS:ffff880226600000(0000)
knlGS:0000000000000000
[ 2342.830812] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2342.830874] CR2: 00007f42a5fb2070 CR3: 0000000001a0b000 CR4: 00000000000407f0
[ 2342.830939] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2342.831005] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2342.831071] Process kworker/u:3 (pid: 6089, threadinfo
ffff880221dac000, task ffff88021e1bc460)
[ 2342.831188] Stack:
[ 2342.831244]  ffff88021eb50000 ffff8802233f1ff0 ffff880221dadb00
ffffffff81417a6c
[ 2342.831370]  0000000000000282 ffff8802233f2000 0000000000000046
ffff8802221e6800
[ 2342.831495]  0000000000000008 ffff880222156630 ffff88021eb0b000
1221000005000000
[ 2342.831623] Call Trace:
[ 2342.831683]  [<ffffffff81417a6c>] scsi_remove_target+0x1bc/0x1f0
[ 2342.831749]  [<ffffffff81421f45>] sas_rphy_remove+0x55/0x60
[ 2342.831814]  [<ffffffff81421f61>] sas_rphy_delete+0x11/0x20
[ 2342.831878]  [<ffffffff81421f95>] sas_port_delete+0x25/0x160
[ 2342.831942]  [<ffffffff81454b03>] mptsas_del_end_device+0x183/0x270
[ 2342.832009]  [<ffffffff81458fbc>] mptsas_hotplug_work+0x1ec/0x920
[ 2342.832076]  [<ffffffff8145324b>] ? mptsas_free_fw_event+0x6b/0xb0
[ 2342.832144]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2342.832210]  [<ffffffff8145a7b0>] mptsas_firmware_event_work+0xbc0/0xfa0
[ 2342.832277]  [<ffffffff81080d1f>] ? __lock_acquire.isra.27+0x29f/0xb30
[ 2342.832345]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2342.832412]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2342.832479]  [<ffffffff8104c484>] process_one_work+0x184/0x460
[ 2342.832545]  [<ffffffff8104c426>] ? process_one_work+0x126/0x460
[ 2342.832610]  [<ffffffff8104cd5e>] worker_thread+0x15e/0x350
[ 2342.832676]  [<ffffffff8104cc00>] ? manage_workers.isra.32+0x220/0x220
[ 2342.832744]  [<ffffffff81051fad>] kthread+0x9d/0xb0
[ 2342.832808]  [<ffffffff815cfed4>] kernel_thread_helper+0x4/0x10
[ 2342.832875]  [<ffffffff81051f10>] ? __init_kthread_worker+0x70/0x70
[ 2342.832943]  [<ffffffff815cfed0>] ? gs_change+0xb/0xb
[ 2342.833007] Code: 10 48 8b 55 08 48 89 5d f0 48 89 f3 4c 89 65 f8
be 01 00 00 00 49 89 fc 48 8d 7f 18 e8 58 a6 ab ff 4c 89 e7 e8 d0 8f
d8 ff 53 9d <48> 8b 5d f0 4c 8b 65 f8 c9 c3 0f 1f 40 00 55 be 01 00 00
00 48
[ 2370.765046] BUG: soft lockup - CPU#0 stuck for 22s! [kworker/u:3:6089]
[ 2370.765113] Modules linked in: netconsole configfs w83627ehf
hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4 coretemp hwmon
kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr microcode
i2c_core video button xts gf128mul aes_x86_64 aes_generic cbc
sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc
reiserfs multipath linear raid0 dm_raid dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata
[ 2370.765747] CPU 0
[ 2370.765752] Modules linked in:[ 2370.765810]  netconsole configfs
w83627ehf hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4
coretemp hwmon kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr
microcode i2c_core video button xts gf128mul aes_x86_64 aes_generic
cbc sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc
reiserfs multipath linear raid0 dm_raid dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata

[ 2370.766490] Pid: 6089, comm: kworker/u:3 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To be filled by O.E.M. To be filled by
O.E.M./P8B-X series
[ 2370.766625] RIP: 0010:[<ffffffff815c84a2>]  [<ffffffff815c84a2>]
_raw_spin_unlock_irqrestore+0x32/0x40
[ 2370.766750] RSP: 0018:ffff880221dada70  EFLAGS: 00000286
[ 2370.766815] RAX: 0000000000000000 RBX: ffff880221dada20 RCX: 000000000000b828
[ 2370.766884] RDX: 0000000000002e40 RSI: ffff880226600000 RDI: ffff8802233f2090
[ 2370.766954] RBP: ffff880221dada80 R08: 0000000000000001 R09: 0000000000000000
[ 2370.767021] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88021e1bc460
[ 2370.767087] R13: 0000000000000082 R14: ffff880221dad9f0 R15: ffff8802233f20a8
[ 2370.767152] FS:  0000000000000000(0000) GS:ffff880226600000(0000)
knlGS:0000000000000000
[ 2370.767267] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2370.767331] CR2: 00007f42a5fb2070 CR3: 0000000001a0b000 CR4: 00000000000407f0
[ 2370.767398] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2370.767465] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2370.767534] Process kworker/u:3 (pid: 6089, threadinfo
ffff880221dac000, task ffff88021e1bc460)
[ 2370.767655] Stack:
[ 2370.767712]  ffff88021eb50000 ffff8802233f2000 ffff880221dadab0
ffffffff814151bd
[ 2370.767837]  ffff880221dadab0 ffff88021eb50000 ffff8802233f1ff0
ffff8802233f2000
[ 2370.767960]  ffff880221dadb00 ffffffff81417a74 0000000000000282
ffff8802233f2000
[ 2370.768084] Call Trace:
[ 2370.768143]  [<ffffffff814151bd>] scsi_target_reap+0x7d/0x100
[ 2370.768209]  [<ffffffff81417a74>] scsi_remove_target+0x1c4/0x1f0
[ 2370.768275]  [<ffffffff81421f45>] sas_rphy_remove+0x55/0x60
[ 2370.768341]  [<ffffffff81421f61>] sas_rphy_delete+0x11/0x20
[ 2370.768405]  [<ffffffff81421f95>] sas_port_delete+0x25/0x160
[ 2370.768470]  [<ffffffff81454b03>] mptsas_del_end_device+0x183/0x270
[ 2370.768537]  [<ffffffff81458fbc>] mptsas_hotplug_work+0x1ec/0x920
[ 2370.768603]  [<ffffffff8145324b>] ? mptsas_free_fw_event+0x6b/0xb0
[ 2370.768669]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2370.768736]  [<ffffffff8145a7b0>] mptsas_firmware_event_work+0xbc0/0xfa0
[ 2370.768805]  [<ffffffff81080d1f>] ? __lock_acquire.isra.27+0x29f/0xb30
[ 2370.768873]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2370.768938]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2370.769004]  [<ffffffff8104c484>] process_one_work+0x184/0x460
[ 2370.769068]  [<ffffffff8104c426>] ? process_one_work+0x126/0x460
[ 2370.769135]  [<ffffffff8104cd5e>] worker_thread+0x15e/0x350
[ 2370.769201]  [<ffffffff8104cc00>] ? manage_workers.isra.32+0x220/0x220
[ 2370.769269]  [<ffffffff81051fad>] kthread+0x9d/0xb0
[ 2370.769333]  [<ffffffff815cfed4>] kernel_thread_helper+0x4/0x10
[ 2370.769399]  [<ffffffff81051f10>] ? __init_kthread_worker+0x70/0x70
[ 2370.769465]  [<ffffffff815cfed0>] ? gs_change+0xb/0xb
[ 2370.769528] Code: 10 48 8b 55 08 48 89 5d f0 48 89 f3 4c 89 65 f8
be 01 00 00 00 49 89 fc 48 8d 7f 18 e8 58 a6 ab ff 4c 89 e7 e8 d0 8f
d8 ff 53 9d <48> 8b 5d f0 4c 8b 65 f8 c9 c3 0f 1f 40 00 55 be 01 00 00
00 48
[ 2395.531904] INFO: task md1_raid6:4897 blocked for more than 120 seconds.
[ 2395.531972] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2395.532089] md1_raid6       D ffff88022229a230     0  4897      2 0x00000000
[ 2395.532162]  ffff8802201eba60 0000000000000046 ffff880226dd16d8
ffff8802201ebfd8
[ 2395.532290]  ffff8802201ebfd8 0000000000004000 ffff880223598000
ffff88022229a230
[ 2395.532417]  ffff8802201eba00 ffffffff81348f1c ffff8802201effff
0000000000000086
[ 2395.532543] Call Trace:
[ 2395.532600]  [<ffffffff81348f1c>] ? vsnprintf+0x35c/0x600
[ 2395.532663]  [<ffffffff81347652>] ? put_dec+0x72/0x90
[ 2395.532726]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2395.532792]  [<ffffffff815c6d94>] schedule+0x24/0x70
[ 2395.532856]  [<ffffffff815c4725>] schedule_timeout+0x1a5/0x220
[ 2395.532922]  [<ffffffff8108039c>] ? lock_release_holdtime.part.9+0x1c/0x1a0
[ 2395.532991]  [<ffffffff815c6c28>] wait_for_common+0xc8/0x160
[ 2395.533057]  [<ffffffff8105fb90>] ? try_to_wake_up+0x300/0x300
[ 2395.533124]  [<ffffffff810b2270>] ? call_rcu_bh+0x20/0x20
[ 2395.533189]  [<ffffffff815c6d68>] wait_for_completion+0x18/0x20
[ 2395.533256]  [<ffffffff8104ee28>] wait_rcu_gp+0x48/0x50
[ 2395.533320]  [<ffffffff8104ee30>] ? wait_rcu_gp+0x50/0x50
[ 2395.534390]  [<ffffffff815c6b8b>] ? wait_for_common+0x2b/0x160
[ 2395.534455]  [<ffffffff810b1559>] synchronize_sched+0x29/0x30
[ 2395.534519]  [<ffffffff814ab948>] raid5_remove_disk+0x118/0x190
[ 2395.534583]  [<ffffffff814bf847>] md_check_recovery+0x4d7/0x720
[ 2395.534649]  [<ffffffff814b3a2e>] raid5d+0x3e/0x6c0
[ 2395.534715]  [<ffffffff8108039c>] ? lock_release_holdtime.part.9+0x1c/0x1a0
[ 2395.534784]  [<ffffffff814b916e>] md_thread+0x10e/0x140
[ 2395.534849]  [<ffffffff810527c0>] ? __init_waitqueue_head+0x60/0x60
[ 2395.534915]  [<ffffffff814b9060>] ? md_register_thread+0x100/0x100
[ 2395.534980]  [<ffffffff81051fad>] kthread+0x9d/0xb0
[ 2395.535043]  [<ffffffff815cfed4>] kernel_thread_helper+0x4/0x10
[ 2395.535108]  [<ffffffff81051f10>] ? __init_kthread_worker+0x70/0x70
[ 2395.535173]  [<ffffffff815cfed0>] ? gs_change+0xb/0xb
[ 2395.535240] 1 lock held by md1_raid6/4897:
[ 2395.535298]  #0:  (&mddev->reconfig_mutex){......}, at:
[<ffffffff814bf454>] md_check_recovery+0xe4/0x720
[ 2395.535427] INFO: task btrfs-transacti:4919 blocked for more than
120 seconds.
[ 2395.535543] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2395.535659] btrfs-transacti D 0000000000000002     0  4919      2 0x00000000
[ 2395.535730]  ffff8802213d98c0 0000000000000046 ffff8802213d97d0
ffff8802213d9fd8
[ 2395.535857]  ffff8802213d9fd8 0000000000004000 ffff880223592230
ffff88021eb5c460
[ 2395.535982]  ffff8802213d9810 ffffffff81061ea5 ffff8802201ec2f0
0000000000000082
[ 2395.536104] Call Trace:
[ 2395.536161]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2395.536226]  [<ffffffff8108039c>] ? lock_release_holdtime.part.9+0x1c/0x1a0
[ 2395.536293]  [<ffffffff81077e18>] ? ktime_get_ts+0xa8/0xe0
[ 2395.536358]  [<ffffffff810c6360>] ? __lock_page+0x70/0x70
[ 2395.536422]  [<ffffffff815c6d94>] schedule+0x24/0x70
[ 2395.536488]  [<ffffffff815c6e6a>] io_schedule+0x8a/0xd0
[ 2395.536552]  [<ffffffff810c6369>] sleep_on_page+0x9/0x10
[ 2395.536617]  [<ffffffff815c4857>] __wait_on_bit+0x57/0x80
[ 2395.536683]  [<ffffffff810c5e49>] ? find_get_pages_tag+0x29/0x1c0
[ 2395.536750]  [<ffffffff810c6530>] wait_on_page_bit+0x70/0x80
[ 2395.536816]  [<ffffffff81052800>] ? autoremove_wake_function+0x40/0x40
[ 2395.536882]  [<ffffffff810c66a4>] filemap_fdatawait_range+0x104/0x190
[ 2395.536947]  [<ffffffff812bb8b6>] btrfs_wait_ordered_range+0x66/0x120
[ 2395.537011]  [<ffffffff812dbc2b>] __btrfs_write_out_cache+0x84b/0xa40
[ 2395.537077]  [<ffffffff812dbeb3>] btrfs_write_out_cache+0x93/0xf0
[ 2395.537143]  [<ffffffff815c8466>] ? _raw_spin_unlock+0x26/0x30
[ 2395.537209]  [<ffffffff8128c933>] btrfs_write_dirty_block_groups+0x503/0x5f0
[ 2395.537278]  [<ffffffff815c11ff>] commit_cowonly_roots+0x10d/0x1de
[ 2395.537346]  [<ffffffff8129d8bf>] ? btrfs_commit_transaction+0x5bf/0xa40
[ 2395.537414]  [<ffffffff8129d91e>] btrfs_commit_transaction+0x61e/0xa40
[ 2395.537482]  [<ffffffff810527c0>] ? __init_waitqueue_head+0x60/0x60
[ 2395.537550]  [<ffffffff8129e1cb>] ? start_transaction+0x8b/0x2a0
[ 2395.537618]  [<ffffffff81295dc5>] transaction_kthread+0x255/0x2d0
[ 2395.537685]  [<ffffffff81295b70>] ? cleaner_kthread+0x1c0/0x1c0
[ 2395.537749]  [<ffffffff81051fad>] kthread+0x9d/0xb0
[ 2395.537810]  [<ffffffff815cfed4>] kernel_thread_helper+0x4/0x10
[ 2395.537874]  [<ffffffff81051f10>] ? __init_kthread_worker+0x70/0x70
[ 2395.537939]  [<ffffffff815cfed0>] ? gs_change+0xb/0xb
[ 2395.538002] 3 locks held by btrfs-transacti/4919:
[ 2395.538064]  #0:  (&fs_info->transaction_kthread_mutex){......},
at: [<ffffffff81295c47>] transaction_kthread+0xd7/0x2d0
[ 2395.538200]  #1:  (&fs_info->reloc_mutex){......}, at:
[<ffffffff8129d841>] btrfs_commit_transaction+0x541/0xa40
[ 2395.538337]  #2:  (&fs_info->tree_log_mutex){......}, at:
[<ffffffff8129d8bf>] btrfs_commit_transaction+0x5bf/0xa40
[ 2395.538475] INFO: task syslog-ng:6102 blocked for more than 120 seconds.
[ 2395.538546] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2395.538662] syslog-ng       D ffff8802226fb120     0  6102   5632 0x00000000
[ 2395.538732]  ffff8801e7cc5a98 0000000000000046 ffff8801e7cc59b8
ffff8801e7cc5fd8
[ 2395.538855]  ffff8801e7cc5fd8 0000000000004000 ffff88022359c460
ffff88021da40000
[ 2395.538979]  ffff8801e7cc59d8 0000000000000092 ffff88021da40000
ffff88021da40000
[ 2395.539108] Call Trace:
[ 2395.539168]  [<ffffffff8108039c>] ? lock_release_holdtime.part.9+0x1c/0x1a0
[ 2395.539235]  [<ffffffff815c6d94>] schedule+0x24/0x70
[ 2395.539300]  [<ffffffff8129cca5>] wait_current_trans.isra.31+0xa5/0xf0
[ 2395.539368]  [<ffffffff810527c0>] ? __init_waitqueue_head+0x60/0x60
[ 2395.539436]  [<ffffffff8129e328>] start_transaction+0x1e8/0x2a0
[ 2395.539503]  [<ffffffff8129e430>] btrfs_join_transaction+0x10/0x20
[ 2395.539569]  [<ffffffff812a8d70>] btrfs_dirty_inode+0x50/0xd0
[ 2395.539632]  [<ffffffff812a9017>] btrfs_update_time+0x57/0x90
[ 2395.539697]  [<ffffffff8103a4c1>] ? current_fs_time+0x11/0x50
[ 2395.539761]  [<ffffffff81121d30>] update_time+0x20/0xc0
[ 2395.539826]  [<ffffffff8112542d>] ? mnt_clone_write+0xd/0x30
[ 2395.539891]  [<ffffffff81121e64>] file_update_time+0x94/0xf0
[ 2395.539958]  [<ffffffff812ad370>] btrfs_file_aio_write+0x1c0/0x4b0
[ 2395.540026]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2395.540092]  [<ffffffff81080d1f>] ? __lock_acquire.isra.27+0x29f/0xb30
[ 2395.540159]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2395.540224]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2395.540289]  [<ffffffff812ad1b0>] ? __btrfs_buffered_write+0x320/0x320
[ 2395.540356]  [<ffffffff81108ee3>] do_sync_readv_writev+0xd3/0x110
[ 2395.540421]  [<ffffffff81080d1f>] ? __lock_acquire.isra.27+0x29f/0xb30
[ 2395.540490]  [<ffffffff8108039c>] ? lock_release_holdtime.part.9+0x1c/0x1a0
[ 2395.540558]  [<ffffffff8110901a>] ? rw_copy_check_uvector+0x7a/0x130
[ 2395.540624]  [<ffffffff81109198>] do_readv_writev+0xc8/0x1d0
[ 2395.540686]  [<ffffffff8108039c>] ? lock_release_holdtime.part.9+0x1c/0x1a0
[ 2395.540751]  [<ffffffff811092da>] vfs_writev+0x3a/0x50
[ 2395.540812]  [<ffffffff81109448>] sys_writev+0x48/0xc0
[ 2395.540874]  [<ffffffff815cebe2>] system_call_fastpath+0x16/0x1b
[ 2395.540936] 1 lock held by syslog-ng/6102:
[ 2395.540994]  #0:  (&sb->s_type->i_mutex_key#9){......}, at:
[<ffffffff812ad27f>] btrfs_file_aio_write+0xcf/0x4b0
[ 2395.544657] INFO: task flush-btrfs-1:5733 blocked for more than 120 seconds.
[ 2395.544722] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2395.544836] flush-btrfs-1   D ffff8802226fb120     0  5733      2 0x00000000
[ 2395.544904]  ffff88021b8356d0 0000000000000046 ffff88021b8355f0
ffff88021b835fd8
[ 2395.545028]  ffff88021b835fd8 0000000000004000 ffff880223592230
ffff88021ecda230
[ 2395.545155]  ffff88021b835610 0000000000000086 ffff88021ecda230
ffff88021ecda230
[ 2395.548997] Call Trace:
[ 2395.549056]  [<ffffffff8108039c>] ? lock_release_holdtime.part.9+0x1c/0x1a0
[ 2395.549121]  [<ffffffff815c6d94>] schedule+0x24/0x70
[ 2395.549182]  [<ffffffff8129cca5>] wait_current_trans.isra.31+0xa5/0xf0
[ 2395.549248]  [<ffffffff810527c0>] ? __init_waitqueue_head+0x60/0x60
[ 2395.549313]  [<ffffffff8129e328>] start_transaction+0x1e8/0x2a0
[ 2395.549379]  [<ffffffff8129e430>] btrfs_join_transaction+0x10/0x20
[ 2395.549443]  [<ffffffff812a463f>] cow_file_range+0x7f/0x480
[ 2395.549508]  [<ffffffff8108039c>] ? lock_release_holdtime.part.9+0x1c/0x1a0
[ 2395.549578]  [<ffffffff815c8466>] ? _raw_spin_unlock+0x26/0x30
[ 2395.549644]  [<ffffffff812a56dc>] run_delalloc_range+0x34c/0x370
[ 2395.549712]  [<ffffffff812c0ef0>] __extent_writepage+0x5d0/0x710
[ 2395.549778]  [<ffffffff810c5f3f>] ? find_get_pages_tag+0x11f/0x1c0
[ 2395.554072]  [<ffffffff810c5e49>] ? find_get_pages_tag+0x29/0x1c0
[ 2395.554138]  [<ffffffff812c12ea>]
extent_write_cache_pages.isra.37.constprop.50+0x2ba/0x410
[ 2395.554254]  [<ffffffff8112d9ce>] ? writeback_sb_inodes+0x12e/0x380
[ 2395.554317]  [<ffffffff8112d9ce>] ? writeback_sb_inodes+0x12e/0x380
[ 2395.554383]  [<ffffffff812c1674>] extent_writepages+0x44/0x60
[ 2395.554447]  [<ffffffff812a1990>] ? btrfs_writepage+0x70/0x70
[ 2395.554512]  [<ffffffff812a0dc3>] btrfs_writepages+0x23/0x30
[ 2395.554579]  [<ffffffff810d02be>] do_writepages+0x1e/0x30
[ 2395.554645]  [<ffffffff8112d17e>] __writeback_single_inode.isra.28+0x3e/0x120
[ 2395.554714]  [<ffffffff8112dacb>] writeback_sb_inodes+0x22b/0x380
[ 2395.554782]  [<ffffffff8112dcb6>] __writeback_inodes_wb+0x96/0xc0
[ 2395.554851]  [<ffffffff8112deab>] wb_writeback+0x1cb/0x1e0
[ 2395.554914]  [<ffffffff8112df57>] wb_check_old_data_flush+0x97/0xa0
[ 2395.554977]  [<ffffffff8112e2f8>] wb_do_writeback+0xc8/0x140
[ 2395.555039]  [<ffffffff8112e3e2>] bdi_writeback_thread+0x72/0x150
[ 2395.555103]  [<ffffffff8112e370>] ? wb_do_writeback+0x140/0x140
[ 2395.555171]  [<ffffffff81051fad>] kthread+0x9d/0xb0
[ 2395.555232]  [<ffffffff815cfed4>] kernel_thread_helper+0x4/0x10
[ 2395.555295]  [<ffffffff81051f10>] ? __init_kthread_worker+0x70/0x70
[ 2395.555358]  [<ffffffff815cfed0>] ? gs_change+0xb/0xb
[ 2395.555418] 1 lock held by flush-btrfs-1/5733:
[ 2395.555476]  #0:  (&type->s_umount_key#26){......}, at:
[<ffffffff8110b72f>] grab_super_passive+0x3f/0x90
[ 2395.555609] INFO: task systemd-udevd:6100 blocked for more than 120 seconds.
[ 2395.555673] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2395.555784] systemd-udevd   D 0000000000000002     0  6100      1 0x00000004
[ 2395.555852]  ffff8801e7cdb958 0000000000000046 ffff8801e7cdb868
ffff8801e7cdbfd8
[ 2395.555971]  ffff8801e7cdbfd8 0000000000004000 ffff8802235a8000
ffff88021da42230
[ 2395.556090]  ffff8801e7cdb8a8 ffffffff81061ea5 ffff8802201ec2f0
0000000000000096
[ 2395.556209] Call Trace:
[ 2395.556265]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2395.556328]  [<ffffffff8108039c>] ? lock_release_holdtime.part.9+0x1c/0x1a0
[ 2395.556393]  [<ffffffff81077e18>] ? ktime_get_ts+0xa8/0xe0
[ 2395.556455]  [<ffffffff810c6360>] ? __lock_page+0x70/0x70
[ 2395.556522]  [<ffffffff815c6d94>] schedule+0x24/0x70
[ 2395.556585]  [<ffffffff815c6e6a>] io_schedule+0x8a/0xd0
[ 2395.556647]  [<ffffffff810c6369>] sleep_on_page+0x9/0x10
[ 2395.556710]  [<ffffffff815c4857>] __wait_on_bit+0x57/0x80
[ 2395.556772]  [<ffffffff810c6530>] wait_on_page_bit+0x70/0x80
[ 2395.556838]  [<ffffffff81052800>] ? autoremove_wake_function+0x40/0x40
[ 2395.556905]  [<ffffffff812c30bd>] read_extent_buffer_pages+0x31d/0x360
[ 2395.556973]  [<ffffffff81295140>] ? verify_parent_transid+0x170/0x170
[ 2395.557041]  [<ffffffff812c1ac0>] ? num_extent_pages+0x20/0x20
[ 2395.557108]  [<ffffffff81297390>]
btree_read_extent_buffer_pages.constprop.114+0xc0/0x130
[ 2395.557229]  [<ffffffff81297ca5>] read_tree_block+0x35/0x50
[ 2395.557296]  [<ffffffff8127d648>] read_block_for_search.isra.44+0x128/0x3c0
[ 2395.557365]  [<ffffffff8127ce8f>] ?
generic_bin_search.constprop.48+0xdf/0x160
[ 2395.558494]  [<ffffffff8127fb46>] btrfs_search_slot+0x3f6/0x920
[ 2395.558559]  [<ffffffff8131c2c6>] ? chksum_update+0x16/0x30
[ 2395.558622]  [<ffffffff812918aa>] btrfs_lookup_xattr+0x7a/0xc0
[ 2395.558688]  [<ffffffff812ba23b>] __btrfs_getxattr+0x7b/0x150
[ 2395.558753]  [<ffffffff812ba6bc>] btrfs_getxattr+0x5c/0x80
[ 2395.558818]  [<ffffffff8130e2f5>] get_vfs_caps_from_disk+0x55/0xf0
[ 2395.558886]  [<ffffffff815c8466>] ? _raw_spin_unlock+0x26/0x30
[ 2395.558951]  [<ffffffff8130e437>] cap_bprm_set_creds+0xa7/0x4b0
[ 2395.559017]  [<ffffffff8110dd78>] prepare_binprm+0xb8/0x1e0
[ 2395.559082]  [<ffffffff8110f984>] do_execve_common.isra.41+0x344/0x470
[ 2395.559148]  [<ffffffff8110f77a>] ? do_execve_common.isra.41+0x13a/0x470
[ 2395.559215]  [<ffffffff8110fac6>] do_execve+0x16/0x20
[ 2395.559278]  [<ffffffff8100a5d2>] sys_execve+0x42/0x70
[ 2395.559341]  [<ffffffff815cf03c>] stub_execve+0x6c/0xc0
[ 2395.559403] 1 lock held by systemd-udevd/6100:
[ 2395.559462]  #0:  (&sig->cred_guard_mutex){......}, at:
[<ffffffff8110f5a1>] prepare_bprm_creds+0x31/0x80
[ 2395.559590] INFO: task systemd-udevd:6101 blocked for more than 120 seconds.
[ 2395.559654] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2395.559771] systemd-udevd   D ffffffff810c6360     0  6101      1 0x00000004
[ 2395.559842]  ffff8801e7d23958 0000000000000046 ffff8801e7d23868
ffff8801e7d23fd8
[ 2395.559965]  ffff8801e7d23fd8 0000000000004000 ffff88022359c460
ffff88021f2c8000
[ 2395.560091]  ffff8801e7d238a8 ffffffff81061ea5 0000000000000046
0000000000000096
[ 2395.560216] Call Trace:
[ 2395.561063]  [<ffffffff812c1ac0>] ? num_extent_pages+0x20/0x20
[ 2395.561129]  [<ffffffff81297390>]
btree_read_extent_buffer_pages.constprop.114+0xc0/0x130
[ 2395.561249]  [<ffffffff81297ca5>] read_tree_block+0x35/0x50
[ 2395.561314]  [<ffffffff8127d648>] read_block_for_search.isra.44+0x128/0x3c0
[ 2395.561382]  [<ffffffff8127ce8f>] ?
generic_bin_search.constprop.48+0xdf/0x160
[ 2395.561502]  [<ffffffff8127fb46>] btrfs_search_slot+0x3f6/0x920
[ 2395.561569]  [<ffffffff8131c2c6>] ? chksum_update+0x16/0x30
[ 2395.561635]  [<ffffffff812918aa>] btrfs_lookup_xattr+0x7a/0xc0
[ 2395.561700]  [<ffffffff812ba23b>] __btrfs_getxattr+0x7b/0x150
[ 2395.561765]  [<ffffffff812ba6bc>] btrfs_getxattr+0x5c/0x80
[ 2395.561831]  [<ffffffff8130e2f5>] get_vfs_caps_from_disk+0x55/0xf0
[ 2395.561895]  [<ffffffff815c8466>] ? _raw_spin_unlock+0x26/0x30
[ 2395.561961]  [<ffffffff8130e437>] cap_bprm_set_creds+0xa7/0x4b0
[ 2395.562028]  [<ffffffff8110dd78>] prepare_binprm+0xb8/0x1e0
[ 2395.562094]  [<ffffffff8110f984>] do_execve_common.isra.41+0x344/0x470
[ 2395.562162]  [<ffffffff8110f77a>] ? do_execve_common.isra.41+0x13a/0x470
[ 2395.562230]  [<ffffffff8110fac6>] do_execve+0x16/0x20
[ 2395.562295]  [<ffffffff8100a5d2>] sys_execve+0x42/0x70
[ 2395.562359]  [<ffffffff815cf03c>] stub_execve+0x6c/0xc0
[ 2395.562423] 1 lock held by systemd-udevd/6101:
[ 2395.562485]  #0:  (&sig->cred_guard_mutex){......}, at:
[<ffffffff8110f5a1>] prepare_bprm_creds+0x31/0x80
[ 2398.701581] BUG: soft lockup - CPU#0 stuck for 22s! [kworker/u:3:6089]
[ 2398.701646] Modules linked in: netconsole configfs w83627ehf
hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4 coretemp hwmon
kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr microcode
i2c_core video button xts gf128mul aes_x86_64 aes_generic cbc
sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc
reiserfs multipath linear raid0 dm_raid dm_mirror dm_region_hash
dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd usb_storage ehci_hcd
megaraid_sas megaraid_mbox megaraid_mm megaraid sr_mod cdrom sd_mod
sata_mv ata_piix ahci libahci pata_marvell pata_mpiix libata
[ 2398.702295] CPU 0
[ 2398.702300] Modules linked in:[ 2398.702360]  netconsole configfs
w83627ehf hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4
coretemp hwmon kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr
microcode i2c_core video button xts gf128mul aes_x86_64 aes_generic
cbc sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc
reiserfs multipath linear raid0 dm_raid dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata

[ 2398.703120] Pid: 6089, comm: kworker/u:3 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To be filled by O.E.M. To be filled by
O.E.M./P8B-X series
[ 2398.703254] RIP: 0010:[<ffffffff815c84a2>]  [<ffffffff815c84a2>]
_raw_spin_unlock_irqrestore+0x32/0x40
[ 2398.703378] RSP: 0018:ffff880221dadaa0  EFLAGS: 00000282
[ 2398.703442] RAX: 0000000000000000 RBX: ffff880221dada50 RCX: 000000000000b828
[ 2398.703507] RDX: 0000000000002e40 RSI: ffff880226600000 RDI: ffff8802233f2090
[ 2398.703572] RBP: ffff880221dadab0 R08: 0000000000000001 R09: 0000000000000000
[ 2398.703637] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88021e1bc460
[ 2398.703702] R13: 0000000000000082 R14: ffff880221dada20 R15: ffff8802233f20a8
[ 2398.703768] FS:  0000000000000000(0000) GS:ffff880226600000(0000)
knlGS:0000000000000000
[ 2398.703885] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2398.703951] CR2: 00007f42a5fb2070 CR3: 0000000001a0b000 CR4: 00000000000407f0
[ 2398.704021] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2398.704090] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2398.704158] Process kworker/u:3 (pid: 6089, threadinfo
ffff880221dac000, task ffff88021e1bc460)
[ 2398.704280] Stack:
[ 2398.704335]  ffff88021eb50000 ffff8802233f1ff0 ffff880221dadb00
ffffffff8141798a
[ 2398.704456]  0000000000000282 ffff8802233f2000 0000000000000046
ffff8802221e6800
[ 2398.704578]  0000000000000008 ffff880222156630 ffff88021eb0b000
1221000005000000
[ 2398.704703] Call Trace:
[ 2398.704763]  [<ffffffff8141798a>] scsi_remove_target+0xda/0x1f0
[ 2398.704830]  [<ffffffff81421f45>] sas_rphy_remove+0x55/0x60
[ 2398.704895]  [<ffffffff81421f61>] sas_rphy_delete+0x11/0x20
[ 2398.704962]  [<ffffffff81421f95>] sas_port_delete+0x25/0x160
[ 2398.705028]  [<ffffffff81454b03>] mptsas_del_end_device+0x183/0x270
[ 2398.705095]  [<ffffffff81458fbc>] mptsas_hotplug_work+0x1ec/0x920
[ 2398.705161]  [<ffffffff8145324b>] ? mptsas_free_fw_event+0x6b/0xb0
[ 2398.705228]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2398.705293]  [<ffffffff8145a7b0>] mptsas_firmware_event_work+0xbc0/0xfa0
[ 2398.705360]  [<ffffffff81080d1f>] ? __lock_acquire.isra.27+0x29f/0xb30
[ 2398.705426]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2398.705491]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2398.705558]  [<ffffffff8104c484>] process_one_work+0x184/0x460
[ 2398.705625]  [<ffffffff8104c426>] ? process_one_work+0x126/0x460
[ 2398.705693]  [<ffffffff8104cd5e>] worker_thread+0x15e/0x350
[ 2398.705846]  [<ffffffff8104cc00>] ? manage_workers.isra.32+0x220/0x220
[ 2398.705914]  [<ffffffff81051fad>] kthread+0x9d/0xb0
[ 2398.705979]  [<ffffffff815cfed4>] kernel_thread_helper+0x4/0x10
[ 2398.706042]  [<ffffffff81051f10>] ? __init_kthread_worker+0x70/0x70
[ 2398.706106]  [<ffffffff815cfed0>] ? gs_change+0xb/0xb
[ 2398.706166] Code: 10 48 8b 55 08 48 89 5d f0 48 89 f3 4c 89 65 f8
be 01 00 00 00 49 89 fc 48 8d 7f 18 e8 58 a6 ab ff 4c 89 e7 e8 d0 8f
d8 ff 53 9d <48> 8b 5d f0 4c 8b 65 f8 c9 c3 0f 1f 40 00 55 be 01 00 00
00 48
[ 2414.189490] INFO: rcu_sched self-detected stall on CPU
[ 2414.189555]  0: (72002 ticks this GP) idle=c6b/140000000000001/0
[ 2414.189622]   (t=72011 jiffies)
[ 2414.189685] sending NMI to all CPUs:
[ 2414.189747] NMI backtrace for cpu 0
[ 2414.189809] CPU 0
[ 2414.189815] Modules linked in:[ 2414.189874]  netconsole configfs
w83627ehf hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4
coretemp hwmon kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr
microcode i2c_core video button xts gf128mul aes_x86_64 aes_generic
cbc sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc
reiserfs multipath linear raid0 dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata

[ 2414.190592] Pid: 6089, comm: kworker/u:3 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To be filled by O.E.M. To be filled by
O.E.M./P8B-X series
[ 2414.190721] RIP: 0010:[<ffffffff8134a305>]  [<ffffffff8134a305>]
delay_tsc+0x15/0x60
[ 2414.190836] RSP: 0018:ffff880226603dd8  EFLAGS: 00000803
[ 2414.190897] RAX: 00000000a83aedcc RBX: 0000000000002710 RCX: 00000000032bf93c
[ 2414.190962] RDX: 000000000000072e RSI: 0000000000000002 RDI: 000000000030b803
[ 2414.191027] RBP: ffff880226603dd8 R08: 0000000000000000 R09: 0000000000000000
[ 2414.191092] R10: 0000000000000915 R11: 0000000000000001 R12: ffffffff81a27d00
[ 2414.191158] R13: ffffffff81a27e00 R14: ffffffff8107efb0 R15: ffff88022660d978
[ 2414.191223] FS:  0000000000000000(0000) GS:ffff880226600000(0000)
knlGS:0000000000000000
[ 2414.191337] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2414.191399] CR2: 00007f42a5fb2070 CR3: 0000000001a0b000 CR4: 00000000000407f0
[ 2414.191464] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2414.191529] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2414.191595] Process kworker/u:3 (pid: 6089, threadinfo
ffff880221dac000, task ffff88021e1bc460)
[ 2414.191710] Stack:
[ 2414.191764]  ffff880226603de8 ffffffff8134a24a ffff880226603df8
ffffffff8134a27e
[ 2414.191884]  ffff880226603e18 ffffffff8101fcaa 0000000000000001
ffff8802267cddc0
[ 2414.192004]  ffff880226603e68 ffffffff810b24f9 ffff880226603e78
ffffffff8105e120
[ 2414.192125] Call Trace:
[ 2414.192182]  <IRQ>
[ 2414.192188]  [<ffffffff8134a24a>] __delay+0xa/0x10
[ 2414.192312]  [<ffffffff8134a27e>] __const_udelay+0x2e/0x30
[ 2414.192379]  [<ffffffff8101fcaa>] arch_trigger_all_cpu_backtrace+0x6a/0x90
[ 2414.192448]  [<ffffffff810b24f9>] __rcu_pending+0x199/0x4d0
[ 2414.192515]  [<ffffffff8105e120>] ? account_system_time+0x130/0x200
[ 2414.193591]  [<ffffffff8105e09a>] ? account_system_time+0xaa/0x200
[ 2414.193755]  [<ffffffff8107efb0>] ? tick_init_highres+0x20/0x20
[ 2414.193819]  [<ffffffff810b3258>] rcu_check_callbacks+0xb8/0xf0
[ 2414.193883]  [<ffffffff81041443>] update_process_times+0x43/0x80
[ 2414.193950]  [<ffffffff8107f008>] tick_sched_timer+0x58/0x150
[ 2414.194017]  [<ffffffff81055f7c>] __run_hrtimer.isra.32+0x5c/0x100
[ 2414.194086]  [<ffffffff8105666b>] hrtimer_interrupt+0xfb/0x250
[ 2414.194152]  [<ffffffff8101ef54>] smp_apic_timer_interrupt+0x64/0xa0
[ 2414.194218]  [<ffffffff815cf687>] apic_timer_interrupt+0x67/0x70
[ 2414.194284]  <EOI>
[ 2414.194290]  [<ffffffff815c84a2>] ? _raw_spin_unlock_irqrestore+0x32/0x40
[ 2414.194413]  [<ffffffff8141798a>] scsi_remove_target+0xda/0x1f0
[ 2414.194478]  [<ffffffff81421f45>] sas_rphy_remove+0x55/0x60
[ 2414.194543]  [<ffffffff81421f61>] sas_rphy_delete+0x11/0x20
[ 2414.194607]  [<ffffffff81421f95>] sas_port_delete+0x25/0x160
[ 2414.194671]  [<ffffffff81454b03>] mptsas_del_end_device+0x183/0x270
[ 2414.194737]  [<ffffffff81458fbc>] mptsas_hotplug_work+0x1ec/0x920
[ 2414.194803]  [<ffffffff8145324b>] ? mptsas_free_fw_event+0x6b/0xb0
[ 2414.194868]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2414.194932]  [<ffffffff8145a7b0>] mptsas_firmware_event_work+0xbc0/0xfa0
[ 2414.195001]  [<ffffffff81080d1f>] ? __lock_acquire.isra.27+0x29f/0xb30
[ 2414.195070]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2414.195139]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2414.195206]  [<ffffffff8104c484>] process_one_work+0x184/0x460
[ 2414.195272]  [<ffffffff8104c426>] ? process_one_work+0x126/0x460
[ 2414.195338]  [<ffffffff8104cd5e>] worker_thread+0x15e/0x350
[ 2414.195403]  [<ffffffff8104cc00>] ? manage_workers.isra.32+0x220/0x220
[ 2414.195469]  [<ffffffff81051fad>] kthread+0x9d/0xb0
[ 2414.195531]  [<ffffffff815cfed4>] kernel_thread_helper+0x4/0x10
[ 2414.195597]  [<ffffffff81051f10>] ? __init_kthread_worker+0x70/0x70
[ 2414.195662]  [<ffffffff815cfed0>] ? gs_change+0xb/0xb
[ 2414.195725] Code: 15 59 fe 6e 00 5d c3 66 66 66 66 66 66 2e 0f 1f
84 00 00 00 00 00 55 65 44 8b 04 25 08 ce 00 00 48 89 e5 0f 1f 00 0f
ae e8 0f 31 <89> c6 eb 16 0f 1f 80 00 00 00 00 f3 90 65 8b 0c 25 08 ce
00 00
[ 2414.196130] NMI backtrace for cpu 4
[ 2414.196193] CPU 4
[ 2414.196199] Modules linked in:[ 2414.196260]  netconsole configfs
w83627ehf hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4
coretemp hwmon kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr
microcode i2c_core video button xts gf128mul aes_x86_64 aes_generic
cbc sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc
reiserfs multipath linear raid0 dm_raid dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata

[ 2414.197055] Pid: 0, comm: swapper/4 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To be filled by O.E.M. To be filled by
O.E.M./P8B-X series
[ 2414.197191] RIP: 0010:[<ffffffff8101d508>]  [<ffffffff8101d508>]
mwait_idle_with_hints+0x58/0x70
[ 2414.197316] RSP: 0018:ffff8802235a3e58  EFLAGS: 00000046
[ 2414.197381] RAX: 0000000000000020 RBX: ffff8802232452e8 RCX: 0000000000000001
[ 2414.197450] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[ 2414.197518] RBP: ffff8802235a3e58 R08: ffff8802235a3fd8 R09: 0000000000000000
[ 2414.197584] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000003
[ 2414.197652] R13: ffff880223245000 R14: ffff880223245020 R15: 12ad09d905d58240
[ 2414.197720] FS:  0000000000000000(0000) GS:ffff880226e00000(0000)
knlGS:0000000000000000
[ 2414.197837] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2414.197902] CR2: 00007fab1b8e3000 CR3: 0000000001a0b000 CR4: 00000000000407e0
[ 2414.197971] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2414.198040] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2414.198109] Process swapper/4 (pid: 0, threadinfo ffff8802235a2000,
task ffff88022359a230)
[ 2414.198229] Stack:
[ 2414.198287]  ffff8802235a3e68 ffffffff8101d54d ffff8802235a3ec8
ffffffff813d83bd
[ 2414.198414]  ffffffff81a17b40 00000000ffffffff 0000000000000000
0000000000000001
[ 2414.198540]  ffff8802235a3ee8 ffff880223245020 ffffffff81a48b10
00000000fffffff0
[ 2414.198667] Call Trace:
[ 2414.198728]  [<ffffffff8101d54d>] acpi_processor_ffh_cstate_enter+0x2d/0x30
[ 2414.198799]  [<ffffffff813d83bd>] acpi_idle_enter_bm+0x1dc/0x293
[ 2414.198868]  [<ffffffff814d5e29>] cpuidle_enter+0x19/0x20
[ 2414.198934]  [<ffffffff814d63fb>] cpuidle_idle_call+0x8b/0xf0
[ 2414.199000]  [<ffffffff8100a6da>] cpu_idle+0x5a/0xc0
[ 2414.199065]  [<ffffffff815b7e21>] start_secondary+0x212/0x214
[ 2414.199133] Code: 8b 04 25 f0 b8 00 00 49 8d 80 38 e0 ff ff 48 89
d1 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89
f1 0f 01 c9 <5d> c3 66 0f 1f 44 00 00 0f ae ba 38 e0 ff ff eb c0 0f 1f
80 00
[ 2414.203841] NMI backtrace for cpu 1
[ 2414.203904] CPU 1
[ 2414.203910] Modules linked in:[ 2414.203969]  netconsole configfs
w83627ehf hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4
coretemp hwmon kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr
microcode i2c_core video button xts gf128mul aes_x86_64 aes_generic
cbc sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc
reiserfs multipath linear raid0 dm_raid dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata

[ 2414.204711] Pid: 0, comm: swapper/1 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To be filled by O.E.M. To be filled by
O.E.M./P8B-X series
[ 2414.204846] RIP: 0010:[<ffffffff8101d508>]  [<ffffffff8101d508>]
mwait_idle_with_hints+0x58/0x70
[ 2414.204963] RSP: 0000:ffff88022350de58  EFLAGS: 00000046
[ 2414.205024] RAX: 0000000000000020 RBX: ffff8802226f02e8 RCX: 0000000000000001
[ 2414.205090] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[ 2414.205155] RBP: ffff88022350de58 R08: ffff88022350dfd8 R09: 0000000000000000
[ 2414.205220] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000003
[ 2414.205285] R13: ffff8802226f0000 R14: ffff8802226f0020 R15: 12ad09d905d5cea0
[ 2414.205351] FS:  0000000000000000(0000) GS:ffff880226800000(0000)
knlGS:0000000000000000
[ 2414.205464] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2414.205526] CR2: 00007fab1b4b89e8 CR3: 0000000001a0b000 CR4: 00000000000407e0
[ 2414.205591] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2414.205656] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2414.205721] Process swapper/1 (pid: 0, threadinfo ffff88022350c000,
task ffff880223592230)
[ 2414.205835] Stack:
[ 2414.205888]  ffff88022350de68 ffffffff8101d54d ffff88022350dec8
ffffffff813d83bd
[ 2414.206009]  ffffffff81a17b40 00000000ffffffff 0000000000000000
0000000000000001
[ 2414.206129]  ffff88022350dee8 ffff8802226f0020 ffffffff81a48b10
00000000fffffff0
[ 2414.206250] Call Trace:
[ 2414.206307]  [<ffffffff8101d54d>] acpi_processor_ffh_cstate_enter+0x2d/0x30
[ 2414.206373]  [<ffffffff813d83bd>] acpi_idle_enter_bm+0x1dc/0x293
[ 2414.206439]  [<ffffffff814d5e29>] cpuidle_enter+0x19/0x20
[ 2414.206503]  [<ffffffff814d63fb>] cpuidle_idle_call+0x8b/0xf0
[ 2414.206568]  [<ffffffff8100a6da>] cpu_idle+0x5a/0xc0
[ 2414.206632]  [<ffffffff815b7e21>] start_secondary+0x212/0x214
[ 2414.206698] Code: 8b 04 25 f0 b8 00 00 49 8d 80 38 e0 ff ff 48 89
d1 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89
f1 0f 01 c9 <5d> c3 66 0f 1f 44 00 00 0f ae ba 38 e0 ff ff eb c0 0f 1f
80 00
[ 2414.207105] NMI backtrace for cpu 5
[ 2414.207112]  0: (72002 ticks this GP) idle=c6b/140000000000001/0
[ 2414.207118]  (detected by 1, t=72016 jiffies)
[ 2414.207119] INFO: Stall ended before state dump start
[ 2414.207110] INFO: rcu_sched detected stalls on CPUs/tasks:
[ 2414.207362] CPU 5 [ 2414.207429] Modules linked in: netconsole
configfs w83627ehf hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler
autofs4 coretemp hwmon kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801
pcspkr microcode i2c_core video button xts gf128mul aes_x86_64
aes_generic cbc sha256_generic e1000 nfs lockd fscache auth_rpcgss
nfs_acl sunrpc reiserfs multipath linear raid0 dm_raid dm_snapshot
dm_crypt dm_mirror dm_region_hash dm_log scsi_wait_scan sl811_hcd
ohci_hcd uhci_hcd usb_storage ehci_hcd megaraid_sas megaraid_mbox
sd_mod sata_mv ata_piix ahci libahci pata_marvell pata_mpiix libata

[ 2414.208132] Pid: 0, comm: swapper/5 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To be filled by O.E.M. To be filled by
O.E.M./P8B-X series
[ 2414.208266] RIP: 0010:[<ffffffff8101d508>]  [<ffffffff8101d508>]
mwait_idle_with_hints+0x58/0x70
[ 2414.208390] RSP: 0018:ffff8802235a5e58  EFLAGS: 00000046
[ 2414.208450] RAX: 0000000000000020 RBX: ffff880223245ae8 RCX: 0000000000000001
[ 2414.208517] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[ 2414.208583] RBP: ffff8802235a5e58 R08: ffff8802235a5fd8 R09: 0000000000000000
[ 2414.208652] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000003
[ 2414.208720] R13: ffff880223245800 R14: ffff880223245820 R15: 12ad09d905d5c080
[ 2414.208788] FS:  0000000000000000(0000) GS:ffff880227000000(0000)
knlGS:0000000000000000
[ 2414.208905] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2414.208968] CR2: 00007f62e1b73000 CR3: 0000000001a0b000 CR4: 00000000000407e0
[ 2414.209034] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2414.209099] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2414.209164] Process swapper/5 (pid: 0, threadinfo ffff8802235a4000,
task ffff88022359c460)
[ 2414.209282] Stack:
[ 2414.209339]  ffff8802235a5e68 ffffffff8101d54d ffff8802235a5ec8
ffffffff813d83bd
[ 2414.209467]  ffffffff81a17b40 00000000ffffffff 0000000000000000
0000000000000001
[ 2414.209595]  ffff8802235a5ee8 ffff880223245820 ffffffff81a48b10
00000000fffffff0
[ 2414.209721] Call Trace:
[ 2414.209781]  [<ffffffff8101d54d>] acpi_processor_ffh_cstate_enter+0x2d/0x30
[ 2414.209848]  [<ffffffff813d83bd>] acpi_idle_enter_bm+0x1dc/0x293
[ 2414.209911]  [<ffffffff814d5e29>] cpuidle_enter+0x19/0x20
[ 2414.209973]  [<ffffffff814d63fb>] cpuidle_idle_call+0x8b/0xf0
[ 2414.210038]  [<ffffffff8100a6da>] cpu_idle+0x5a/0xc0
[ 2414.210103]  [<ffffffff815b7e21>] start_secondary+0x212/0x214
[ 2414.210168] Code: 8b 04 25 f0 b8 00 00 49 8d 80 38 e0 ff ff 48 89
d1 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89
f1 0f 01 c9 <5d> c3 66 0f 1f 44 00 00 0f ae ba 38 e0 ff ff eb c0 0f 1f
80 00
[ 2414.210530] NMI backtrace for cpu 2
[ 2414.210595] CPU 2
[ 2414.210601] Modules linked in:[ 2414.210660]  netconsole configfs
w83627ehf hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4
coretemp hwmon kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr
microcode i2c_core video button xts gf128mul aes_x86_64 aes_generic
cbc sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc
reiserfs multipath linear raid0 dm_raid dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata

[ 2414.212413] Pid: 0, comm: swapper/2 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To be filled by O.E.M. To be filled by
O.E.M./P8B-X series
[ 2414.212549] RIP: 0010:[<ffffffff8101d508>]  [<ffffffff8101d508>]
mwait_idle_with_hints+0x58/0x70
[ 2414.212673] RSP: 0018:ffff88022350fe58  EFLAGS: 00000046
[ 2414.212738] RAX: 0000000000000020 RBX: ffff8802232202e8 RCX: 0000000000000001
[ 2414.212807] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[ 2414.212876] RBP: ffff88022350fe58 R08: ffff88022350ffd8 R09: 0000000000000000
[ 2414.212942] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000003
[ 2414.213008] R13: ffff880223220000 R14: ffff880223220020 R15: 12ad09d905d5cd61
[ 2414.213074] FS:  0000000000000000(0000) GS:ffff880226a00000(0000)
knlGS:0000000000000000
[ 2414.213187] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2414.213249] CR2: 00007fab1b4b89e8 CR3: 0000000001a0b000 CR4: 00000000000407e0
[ 2414.213317] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2414.213384] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2414.213453] Process swapper/2 (pid: 0, threadinfo ffff88022350e000,
task ffff880223594460)
[ 2414.213573] Stack:
[ 2414.213630]  ffff88022350fe68 ffffffff8101d54d ffff88022350fec8
ffffffff813d83bd
[ 2414.213757]  ffffffff81a17b40 00000000ffffffff 0000000000000000
0000000000000001
[ 2414.213883]  ffff88022350fee8 ffff880223220020 ffffffff81a48b10
00000000fffffff0
[ 2414.214006] Call Trace:
[ 2414.214064]  [<ffffffff8101d54d>] acpi_processor_ffh_cstate_enter+0x2d/0x30
[ 2414.214136]  [<ffffffff813d83bd>] acpi_idle_enter_bm+0x1dc/0x293
[ 2414.214205]  [<ffffffff814d5e29>] cpuidle_enter+0x19/0x20
[ 2414.214272]  [<ffffffff814d63fb>] cpuidle_idle_call+0x8b/0xf0
[ 2414.214338]  [<ffffffff8100a6da>] cpu_idle+0x5a/0xc0
[ 2414.214403]  [<ffffffff815b7e21>] start_secondary+0x212/0x214
[ 2414.214468] Code: 8b 04 25 f0 b8 00 00 49 8d 80 38 e0 ff ff 48 89
d1 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89
f1 0f 01 c9 <5d> c3 66 0f 1f 44 00 00 0f ae ba 38 e0 ff ff eb c0 0f 1f
80 00
[ 2414.214870] NMI backtrace for cpu 6
[ 2414.214933] CPU 6
[ 2414.214937] Modules linked in:[ 2414.214996]  netconsole configfs
w83627ehf hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4
coretemp hwmon kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr
microcode i2c_core video button xts gf128mul aes_x86_64 aes_generic
cbc sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc
reiserfs multipath linear raid0 dm_raid dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata

[ 2414.215699] Pid: 0, comm: swapper/6 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To be filled by O.E.M. To be filled by
O.E.M./P8B-X series
[ 2414.215827] RIP: 0010:[<ffffffff8101d508>]  [<ffffffff8101d508>]
mwait_idle_with_hints+0x58/0x70
[ 2414.215948] RSP: 0018:ffff8802235a7e58  EFLAGS: 00000046
[ 2414.216013] RAX: 0000000000000020 RBX: ffff8802232462e8 RCX: 0000000000000001
[ 2414.216081] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[ 2414.216148] RBP: ffff8802235a7e58 R08: ffff8802235a7fd8 R09: 0000000000000000
[ 2414.216215] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000003
[ 2414.216283] R13: ffff880223246000 R14: ffff880223246020 R15: 12ad09d905d5bf6a
[ 2414.216352] FS:  0000000000000000(0000) GS:ffff880227200000(0000)
knlGS:0000000000000000
[ 2414.216472] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2414.216535] CR2: 00007fab1b4b89e8 CR3: 0000000001a0b000 CR4: 00000000000407e0
[ 2414.216601] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2414.216667] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2414.216734] Process swapper/6 (pid: 0, threadinfo ffff8802235a6000,
task ffff8802235a8000)
[ 2414.216852] Stack:
[ 2414.216909]  ffff8802235a7e68 ffffffff8101d54d ffff8802235a7ec8
ffffffff813d83bd
[ 2414.217036]  ffffffff81a17b40 00000000ffffffff 0000000000000000
0000000000000001
[ 2414.217164]  ffff8802235a7ee8 ffff880223246020 ffffffff81a48b10
00000000fffffff0
[ 2414.217292] Call Trace:
[ 2414.217349]  [<ffffffff8101d54d>] acpi_processor_ffh_cstate_enter+0x2d/0x30
[ 2414.217415]  [<ffffffff813d83bd>] acpi_idle_enter_bm+0x1dc/0x293
[ 2414.217480]  [<ffffffff814d5e29>] cpuidle_enter+0x19/0x20
[ 2414.217544]  [<ffffffff814d63fb>] cpuidle_idle_call+0x8b/0xf0
[ 2414.217609]  [<ffffffff8100a6da>] cpu_idle+0x5a/0xc0
[ 2414.217672]  [<ffffffff815b7e21>] start_secondary+0x212/0x214
[ 2414.217736] Code: 8b 04 25 f0 b8 00 00 49 8d 80 38 e0 ff ff 48 89
d1 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89
f1 0f 01 c9 <5d> c3 66 0f 1f 44 00 00 0f ae ba 38 e0 ff ff eb c0 0f 1f
80 00
[ 2414.218098] NMI backtrace for cpu 3
[ 2414.218162] CPU 3
[ 2414.218168] Modules linked in:[ 2414.218229]  netconsole configfs
w83627ehf hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4
coretemp hwmon kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr
microcode i2c_core video button xts gf128mul aes_x86_64 aes_generic
cbc sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc
reiserfs multipath linear raid0 dm_raid dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata

[ 2414.218958] Pid: 0, comm: swapper/3 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To be filled by O.E.M. To be filled by
O.E.M./P8B-X series
[ 2414.219094] RIP: 0010:[<ffffffff8101d508>]  [<ffffffff8101d508>]
mwait_idle_with_hints+0x58/0x70
[ 2414.219211] RSP: 0018:ffff8802235a1e58  EFLAGS: 00000046
[ 2414.219273] RAX: 0000000000000020 RBX: ffff8802233a82e8 RCX: 0000000000000001
[ 2414.219337] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[ 2414.219402] RBP: ffff8802235a1e58 R08: ffff8802235a1fd8 R09: 0000000000000000
[ 2414.219467] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000003
[ 2414.219532] R13: ffff8802233a8000 R14: ffff8802233a8020 R15: 12ad09d905d5d777
[ 2414.219598] FS:  0000000000000000(0000) GS:ffff880226c00000(0000)
knlGS:0000000000000000
[ 2414.219711] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2414.219773] CR2: 00007fab1b4b89e8 CR3: 0000000001a0b000 CR4: 00000000000407e0
[ 2414.219838] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2414.219903] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2414.219968] Process swapper/3 (pid: 0, threadinfo ffff8802235a0000,
task ffff880223598000)
[ 2414.220081] Stack:
[ 2414.220135]  ffff8802235a1e68 ffffffff8101d54d ffff8802235a1ec8
ffffffff813d83bd
[ 2414.220256]  ffffffff81a17b40 00000000ffffffff 0000000000000000
0000000000000001
[ 2414.220377]  ffff8802235a1ee8 ffff8802233a8020 ffffffff81a48b10
00000000fffffff0
[ 2414.220497] Call Trace:
[ 2414.220554]  [<ffffffff8101d54d>] acpi_processor_ffh_cstate_enter+0x2d/0x30
[ 2414.220621]  [<ffffffff813d83bd>] acpi_idle_enter_bm+0x1dc/0x293
[ 2414.220685]  [<ffffffff814d5e29>] cpuidle_enter+0x19/0x20
[ 2414.220752]  [<ffffffff814d63fb>] cpuidle_idle_call+0x8b/0xf0
[ 2414.220820]  [<ffffffff8100a6da>] cpu_idle+0x5a/0xc0
[ 2414.220882]  [<ffffffff815b7e21>] start_secondary+0x212/0x214
[ 2414.220944] Code: 8b 04 25 f0 b8 00 00 49 8d 80 38 e0 ff ff 48 89
d1 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89
f1 0f 01 c9 <5d> c3 66 0f 1f 44 00 00 0f ae ba 38 e0 ff ff eb c0 0f 1f
80 00
[ 2414.221341] NMI backtrace for cpu 7
[ 2414.221402] CPU 7
[ 2414.221407] Modules linked in:[ 2414.221466]  netconsole configfs
w83627ehf hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4
coretemp hwmon kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr
microcode i2c_core video button xts gf128mul aes_x86_64 aes_generic
cbc sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc
reiserfs multipath linear raid0 dm_raid dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata

[ 2414.222173] Pid: 0, comm: swapper/7 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To be filled by O.E.M. To be filled by
O.E.M./P8B-X series
[ 2414.222301] RIP: 0010:[<ffffffff8101d508>]  [<ffffffff8101d508>]
mwait_idle_with_hints+0x58/0x70
[ 2414.222423] RSP: 0018:ffff8802235b1e58  EFLAGS: 00000046
[ 2414.222490] RAX: 0000000000000020 RBX: ffff880223246ae8 RCX: 0000000000000001
[ 2414.222559] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[ 2414.222626] RBP: ffff8802235b1e58 R08: ffff8802235b1fd8 R09: 0000000000000000
[ 2414.222693] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000003
[ 2414.222762] R13: ffff880223246800 R14: ffff880223246820 R15: 12ad09d905d5c2a0
[ 2414.222829] FS:  0000000000000000(0000) GS:ffff880227400000(0000)
knlGS:0000000000000000
[ 2414.222943] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2414.223005] CR2: 000000000062b2c8 CR3: 0000000001a0b000 CR4: 00000000000407e0
[ 2414.223070] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2414.223135] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2414.223200] Process swapper/7 (pid: 0, threadinfo ffff8802235b0000,
task ffff8802235aa230)
[ 2414.223321] Stack:
[ 2414.223378]  ffff8802235b1e68 ffffffff8101d54d ffff8802235b1ec8
ffffffff813d83bd
[ 2414.223504]  ffffffff81a17b40 00000000ffffffff 0000000000000000
0000000000000001
[ 2414.223629]  ffff8802235b1ee8 ffff880223246820 ffffffff81a48b10
00000000fffffff0
[ 2414.223750] Call Trace:
[ 2414.223808]  [<ffffffff8101d54d>] acpi_processor_ffh_cstate_enter+0x2d/0x30
[ 2414.223875]  [<ffffffff813d83bd>] acpi_idle_enter_bm+0x1dc/0x293
[ 2414.223942]  [<ffffffff814d5e29>] cpuidle_enter+0x19/0x20
[ 2414.224007]  [<ffffffff814d63fb>] cpuidle_idle_call+0x8b/0xf0
[ 2414.224073]  [<ffffffff8100a6da>] cpu_idle+0x5a/0xc0
[ 2414.224139]  [<ffffffff815b7e21>] start_secondary+0x212/0x214
[ 2414.224205] Code: 8b 04 25 f0 b8 00 00 49 8d 80 38 e0 ff ff 48 89
d1 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89
f1 0f 01 c9 <5d> c3 66 0f 1f 44 00 00 0f ae ba 38 e0 ff ff eb c0 0f 1f
80 00
[ 2438.610917] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u:3:6089]
[ 2438.611999] Modules linked in: netconsole configfs w83627ehf
hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4 coretemp hwmon
kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr microcode
i2c_core video button xts gf128mul aes_x86_64 aes_generic cbc
sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata
[ 2438.612629] CPU 0
[ 2438.612634] Modules linked in:[ 2438.612691]  netconsole configfs
w83627ehf hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4
coretemp hwmon kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr
microcode i2c_core video button xts gf128mul aes_x86_64 aes_generic
cbc sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc
reiserfs multipath linear raid0 dm_raid dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata

[ 2438.613360] Pid: 6089, comm: kworker/u:3 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To be filled by O.E.M. To be filled by
O.E.M./P8B-X series
[ 2438.613494] RIP: 0010:[<ffffffff815c84a2>]  [<ffffffff815c84a2>]
_raw_spin_unlock_irqrestore+0x32/0x40
[ 2438.613618] RSP: 0018:ffff880221dadaa0  EFLAGS: 00000282
[ 2438.613683] RAX: 0000000000000000 RBX: ffff880221dada50 RCX: 000000000000b828
[ 2438.613752] RDX: 0000000000002e40 RSI: ffff880226600000 RDI: ffff8802233f2090
[ 2438.613819] RBP: ffff880221dadab0 R08: 0000000000000001 R09: 0000000000000000
[ 2438.613888] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88021e1bc460
[ 2438.613953] R13: 0000000000000082 R14: ffff880221dada20 R15: ffff8802233f20a8
[ 2438.614020] FS:  0000000000000000(0000) GS:ffff880226600000(0000)
knlGS:0000000000000000
[ 2438.614137] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2438.614200] CR2: 00007f42a5fb2070 CR3: 0000000001a0b000 CR4: 00000000000407f0
[ 2438.614265] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2438.614333] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2438.614403] Process kworker/u:3 (pid: 6089, threadinfo
ffff880221dac000, task ffff88021e1bc460)
[ 2438.614524] Stack:
[ 2438.614583]  ffff88021eb50000 ffff8802233f1ff0 ffff880221dadb00
ffffffff8141798a
[ 2438.614710]  0000000000000282 ffff8802233f2000 0000000000000046
ffff8802221e6800
[ 2438.614833]  0000000000000008 ffff880222156630 ffff88021eb0b000
1221000005000000
[ 2438.614956] Call Trace:
[ 2438.615014]  [<ffffffff8141798a>] scsi_remove_target+0xda/0x1f0
[ 2438.615079]  [<ffffffff81421f45>] sas_rphy_remove+0x55/0x60
[ 2438.615144]  [<ffffffff81421f61>] sas_rphy_delete+0x11/0x20
[ 2438.615210]  [<ffffffff81421f95>] sas_port_delete+0x25/0x160
[ 2438.615272]  [<ffffffff81454b03>] mptsas_del_end_device+0x183/0x270
[ 2438.615335]  [<ffffffff81458fbc>] mptsas_hotplug_work+0x1ec/0x920
[ 2438.615399]  [<ffffffff8145324b>] ? mptsas_free_fw_event+0x6b/0xb0
[ 2438.615462]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2438.615525]  [<ffffffff8145a7b0>] mptsas_firmware_event_work+0xbc0/0xfa0
[ 2438.615589]  [<ffffffff81080d1f>] ? __lock_acquire.isra.27+0x29f/0xb30
[ 2438.615654]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2438.615717]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2438.615781]  [<ffffffff8104c484>] process_one_work+0x184/0x460
[ 2438.615945]  [<ffffffff8104c426>] ? process_one_work+0x126/0x460
[ 2438.616008]  [<ffffffff8104cd5e>] worker_thread+0x15e/0x350
[ 2438.616070]  [<ffffffff8104cc00>] ? manage_workers.isra.32+0x220/0x220
[ 2438.616135]  [<ffffffff81051fad>] kthread+0x9d/0xb0
[ 2438.616196]  [<ffffffff815cfed4>] kernel_thread_helper+0x4/0x10
[ 2438.616259]  [<ffffffff81051f10>] ? __init_kthread_worker+0x70/0x70
[ 2438.616322]  [<ffffffff815cfed0>] ? gs_change+0xb/0xb
[ 2438.616382] Code: 10 48 8b 55 08 48 89 5d f0 48 89 f3 4c 89 65 f8
be 01 00 00 00 49 89 fc 48 8d 7f 18 e8 58 a6 ab ff 4c 89 e7 e8 d0 8f
d8 ff 53 9d <48> 8b 5d f0 4c 8b 65 f8 c9 c3 0f 1f 40 00 55 be 01 00 00
00 48
[ 2466.547452] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u:3:6089]
[ 2466.547516] Modules linked in: netconsole configfs w83627ehf
hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4 coretemp hwmon
kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr microcode
i2c_core video button xts gf128mul aes_x86_64 aes_generic cbc
sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl dm_crypt
dm_mirror dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd
uhci_hcd usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm
megaraid sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci
pata_marvell pata_mpiix libata
[ 2466.548132] CPU 0
[ 2466.548137] Modules linked in:[ 2466.548192]  netconsole configfs
w83627ehf hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4
coretemp hwmon kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr
microcode i2c_core video button xts gf128mul aes_x86_64 aes_generic
cbc sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc
reiserfs multipath linear raid0 dm_raid dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata

[ 2466.548852] Pid: 6089, comm: kworker/u:3 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To be filled by O.E.M. To be filled by
O.E.M./P8B-X series
[ 2466.548980] RIP: 0010:[<ffffffff815c84a2>]  [<ffffffff815c84a2>]
_raw_spin_unlock_irqrestore+0x32/0x40
[ 2466.549104] RSP: 0018:ffff880221dadaa0  EFLAGS: 00000282
[ 2466.549166] RAX: 0000000000000000 RBX: ffff880221dada50 RCX: 000000000000b828
[ 2466.549231] RDX: 0000000000002e40 RSI: ffff880226600000 RDI: ffff8802233f2090
[ 2466.549297] RBP: ffff880221dadab0 R08: 0000000000000001 R09: 0000000000000000
[ 2466.549365] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88021e1bc460
[ 2466.549431] R13: 0000000000000082 R14: ffff880221dada20 R15: ffff8802233f20a8
[ 2466.549498] FS:  0000000000000000(0000) GS:ffff880226600000(0000)
knlGS:0000000000000000
[ 2466.549619] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2466.549684] CR2: 00007f42a5fb2070 CR3: 0000000001a0b000 CR4: 00000000000407f0
[ 2466.549752] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2466.549821] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2466.549890] Process kworker/u:3 (pid: 6089, threadinfo
ffff880221dac000, task ffff88021e1bc460)
[ 2466.550007] Stack:
[ 2466.550157]  ffff88021eb50000 ffff8802233f1ff0 ffff880221dadb00
ffffffff8141798a
[ 2466.550281]  0000000000000282 ffff8802233f2000 0000000000000046
ffff8802221e6800
[ 2466.550406]  0000000000000008 ffff880222156630 ffff88021eb0b000
1221000005000000
[ 2466.550534] Call Trace:
[ 2466.550595]  [<ffffffff8141798a>] scsi_remove_target+0xda/0x1f0
[ 2466.550663]  [<ffffffff81421f45>] sas_rphy_remove+0x55/0x60
[ 2466.550729]  [<ffffffff81421f61>] sas_rphy_delete+0x11/0x20
[ 2466.550795]  [<ffffffff81421f95>] sas_port_delete+0x25/0x160
[ 2466.550859]  [<ffffffff81454b03>] mptsas_del_end_device+0x183/0x270
[ 2466.550924]  [<ffffffff81458fbc>] mptsas_hotplug_work+0x1ec/0x920
[ 2466.550989]  [<ffffffff8145324b>] ? mptsas_free_fw_event+0x6b/0xb0
[ 2466.551055]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2466.551120]  [<ffffffff8145a7b0>] mptsas_firmware_event_work+0xbc0/0xfa0
[ 2466.551187]  [<ffffffff81080d1f>] ? __lock_acquire.isra.27+0x29f/0xb30
[ 2466.551253]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2466.551321]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2466.551388]  [<ffffffff8104c484>] process_one_work+0x184/0x460
[ 2466.551456]  [<ffffffff8104c426>] ? process_one_work+0x126/0x460
[ 2466.551522]  [<ffffffff8104cd5e>] worker_thread+0x15e/0x350
[ 2466.551588]  [<ffffffff8104cc00>] ? manage_workers.isra.32+0x220/0x220
[ 2466.551657]  [<ffffffff81051fad>] kthread+0x9d/0xb0
[ 2466.551722]  [<ffffffff815cfed4>] kernel_thread_helper+0x4/0x10
[ 2466.551788]  [<ffffffff81051f10>] ? __init_kthread_worker+0x70/0x70
[ 2466.551856]  [<ffffffff815cfed0>] ? gs_change+0xb/0xb
[ 2466.551918] Code: 10 48 8b 55 08 48 89 5d f0 48 89 f3 4c 89 65 f8
be 01 00 00 00 49 89 fc 48 8d 7f 18 e8 58 a6 ab ff 4c 89 e7 e8 d0 8f
d8 ff 53 9d <48> 8b 5d f0 4c 8b 65 f8 c9 c3 0f 1f 40 00 55 be 01 00 00
00 48
[ 2494.483987] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u:3:6089]
[ 2494.484055] Modules linked in: netconsole configfs w83627ehf
hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4 coretemp hwmon
kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr microcode
i2c_core video button xts gf128mul aes_x86_64 aes_generic cbc
sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata
[ 2494.484688] CPU 0
[ 2494.484693] Modules linked in:[ 2494.484751]  netconsole configfs
w83627ehf hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4
coretemp hwmon kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr
microcode i2c_core video button xts gf128mul aes_x86_64 aes_generic
cbc sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc
reiserfs multipath linear raid0 dm_raid dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata

[ 2494.485442] Pid: 6089, comm: kworker/u:3 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To be filled by O.E.M. To be filled by
O.E.M./P8B-X series
[ 2494.485574] RIP: 0010:[<ffffffff815c84a2>]  [<ffffffff815c84a2>]
_raw_spin_unlock_irqrestore+0x32/0x40
[ 2494.485696] RSP: 0018:ffff880221dada70  EFLAGS: 00000286
[ 2494.485761] RAX: 0000000000000000 RBX: ffff880221dada20 RCX: 000000000000b828
[ 2494.485829] RDX: 0000000000002e40 RSI: ffff880226600000 RDI: ffff8802233f2090
[ 2494.485898] RBP: ffff880221dada80 R08: 0000000000000001 R09: 0000000000000000
[ 2494.485967] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88021e1bc460
[ 2494.486035] R13: 0000000000000082 R14: ffff880221dad9f0 R15: ffff8802233f20a8
[ 2494.486102] FS:  0000000000000000(0000) GS:ffff880226600000(0000)
knlGS:0000000000000000
[ 2494.486221] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2494.486284] CR2: 00007f42a5fb2070 CR3: 0000000001a0b000 CR4: 00000000000407f0
[ 2494.486349] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2494.486414] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2494.486480] Process kworker/u:3 (pid: 6089, threadinfo
ffff880221dac000, task ffff88021e1bc460)
[ 2494.486603] Stack:
[ 2494.486660]  ffff88021eb50000 ffff8802233f2000 ffff880221dadab0
ffffffff814151bd
[ 2494.486787]  ffff880221dadab0 ffff88021eb50000 ffff8802233f1ff0
ffff8802233f2000
[ 2494.486915]  ffff880221dadb00 ffffffff81417a74 0000000000000282
ffff8802233f2000
[ 2494.487042] Call Trace:
[ 2494.488118]  [<ffffffff814151bd>] scsi_target_reap+0x7d/0x100
[ 2494.488182]  [<ffffffff81417a74>] scsi_remove_target+0x1c4/0x1f0
[ 2494.488347]  [<ffffffff81421f45>] sas_rphy_remove+0x55/0x60
[ 2494.488411]  [<ffffffff81421f61>] sas_rphy_delete+0x11/0x20
[ 2494.488476]  [<ffffffff81421f95>] sas_port_delete+0x25/0x160
[ 2494.488541]  [<ffffffff81454b03>] mptsas_del_end_device+0x183/0x270
[ 2494.488607]  [<ffffffff81458fbc>] mptsas_hotplug_work+0x1ec/0x920
[ 2494.488674]  [<ffffffff8145324b>] ? mptsas_free_fw_event+0x6b/0xb0
[ 2494.488740]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2494.488805]  [<ffffffff8145a7b0>] mptsas_firmware_event_work+0xbc0/0xfa0
[ 2494.488873]  [<ffffffff81080d1f>] ? __lock_acquire.isra.27+0x29f/0xb30
[ 2494.488940]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2494.489006]  [<ffffffff81459bf0>] ? mptsas_expander_add+0x140/0x140
[ 2494.489072]  [<ffffffff8104c484>] process_one_work+0x184/0x460
[ 2494.489135]  [<ffffffff8104c426>] ? process_one_work+0x126/0x460
[ 2494.489199]  [<ffffffff8104cd5e>] worker_thread+0x15e/0x350
[ 2494.489262]  [<ffffffff8104cc00>] ? manage_workers.isra.32+0x220/0x220
[ 2494.489327]  [<ffffffff81051fad>] kthread+0x9d/0xb0
[ 2494.489389]  [<ffffffff815cfed4>] kernel_thread_helper+0x4/0x10
[ 2494.489453]  [<ffffffff81051f10>] ? __init_kthread_worker+0x70/0x70
[ 2494.489518]  [<ffffffff815cfed0>] ? gs_change+0xb/0xb
[ 2494.489581] Code: 10 48 8b 55 08 48 89 5d f0 48 89 f3 4c 89 65 f8
be 01 00 00 00 49 89 fc 48 8d 7f 18 e8 58 a6 ab ff 4c 89 e7 e8 d0 8f
d8 ff 53 9d <48> 8b 5d f0 4c 8b 65 f8 c9 c3 0f 1f 40 00 55 be 01 00 00
00 48
[ 2515.289833] INFO: task md1_raid6:4897 blocked for more than 120 seconds.
[ 2515.289903] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2515.290018] md1_raid6       D ffff88022229a230     0  4897      2 0x00000000
[ 2515.290087]  ffff8802201eba60 0000000000000046 ffff880226dd16d8
ffff8802201ebfd8
[ 2515.290210]  ffff8802201ebfd8 0000000000004000 ffff880223598000
ffff88022229a230
[ 2515.290334]  ffff8802201eba00 ffffffff81348f1c ffff8802201effff
0000000000000086
[ 2515.290462] Call Trace:
[ 2515.290523]  [<ffffffff81348f1c>] ? vsnprintf+0x35c/0x600
[ 2515.290587]  [<ffffffff81347652>] ? put_dec+0x72/0x90
[ 2515.290650]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2515.290714]  [<ffffffff815c6d94>] schedule+0x24/0x70
[ 2515.290776]  [<ffffffff815c4725>] schedule_timeout+0x1a5/0x220
[ 2515.290841]  [<ffffffff8108039c>] ? lock_release_holdtime.part.9+0x1c/0x1a0
[ 2515.290906]  [<ffffffff815c6c28>] wait_for_common+0xc8/0x160
[ 2515.290970]  [<ffffffff8105fb90>] ? try_to_wake_up+0x300/0x300
[ 2515.291035]  [<ffffffff810b2270>] ? call_rcu_bh+0x20/0x20
[ 2515.291100]  [<ffffffff815c6d68>] wait_for_completion+0x18/0x20
[ 2515.291166]  [<ffffffff8104ee28>] wait_rcu_gp+0x48/0x50
[ 2515.291232]  [<ffffffff8104ee30>] ? wait_rcu_gp+0x50/0x50
[ 2515.291298]  [<ffffffff815c6b8b>] ? wait_for_common+0x2b/0x160
[ 2515.291366]  [<ffffffff810b1559>] synchronize_sched+0x29/0x30
[ 2515.291431]  [<ffffffff814ab948>] raid5_remove_disk+0x118/0x190
[ 2515.291497]  [<ffffffff814bf847>] md_check_recovery+0x4d7/0x720
[ 2515.291564]  [<ffffffff814b3a2e>] raid5d+0x3e/0x6c0
[ 2515.291629]  [<ffffffff8108039c>] ? lock_release_holdtime.part.9+0x1c/0x1a0
[ 2515.291697]  [<ffffffff814b916e>] md_thread+0x10e/0x140
[ 2515.291763]  [<ffffffff810527c0>] ? __init_waitqueue_head+0x60/0x60
[ 2515.291829]  [<ffffffff814b9060>] ? md_register_thread+0x100/0x100
[ 2515.291894]  [<ffffffff81051fad>] kthread+0x9d/0xb0
[ 2515.291958]  [<ffffffff815cfed4>] kernel_thread_helper+0x4/0x10
[ 2515.292025]  [<ffffffff81051f10>] ? __init_kthread_worker+0x70/0x70
[ 2515.292093]  [<ffffffff815cfed0>] ? gs_change+0xb/0xb
[ 2515.292157] 1 lock held by md1_raid6/4897:
[ 2515.292218]  #0:  (&mddev->reconfig_mutex){......}, at:
[<ffffffff814bf454>] md_check_recovery+0xe4/0x720
[ 2515.292354] INFO: task btrfs-transacti:4919 blocked for more than
120 seconds.
[ 2515.292470] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2515.292586] btrfs-transacti D 0000000000000002     0  4919      2 0x00000000
[ 2515.292657]  ffff8802213d98c0 0000000000000046 ffff8802213d97d0
ffff8802213d9fd8
[ 2515.292782]  ffff8802213d9fd8 0000000000004000 ffff880223592230
ffff88021eb5c460
[ 2515.292909]  ffff8802213d9810 ffffffff81061ea5 ffff8802201ec2f0
0000000000000082
[ 2515.293034] Call Trace:
[ 2515.293093]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2515.293163]  [<ffffffff8108039c>] ? lock_release_holdtime.part.9+0x1c/0x1a0
[ 2515.293232]  [<ffffffff81077e18>] ? ktime_get_ts+0xa8/0xe0
[ 2515.293295]  [<ffffffff810c6360>] ? __lock_page+0x70/0x70
[ 2515.293357]  [<ffffffff815c6d94>] schedule+0x24/0x70
[ 2515.293419]  [<ffffffff815c6e6a>] io_schedule+0x8a/0xd0
[ 2515.293485]  [<ffffffff810c6369>] sleep_on_page+0x9/0x10
[ 2515.293549]  [<ffffffff815c4857>] __wait_on_bit+0x57/0x80
[ 2515.293616]  [<ffffffff810c5e49>] ? find_get_pages_tag+0x29/0x1c0
[ 2515.293684]  [<ffffffff810c6530>] wait_on_page_bit+0x70/0x80
[ 2515.293750]  [<ffffffff81052800>] ? autoremove_wake_function+0x40/0x40
[ 2515.293818]  [<ffffffff810c66a4>] filemap_fdatawait_range+0x104/0x190
[ 2515.293887]  [<ffffffff812bb8b6>] btrfs_wait_ordered_range+0x66/0x120
[ 2515.293953]  [<ffffffff812dbc2b>] __btrfs_write_out_cache+0x84b/0xa40
[ 2515.294020]  [<ffffffff812dbeb3>] btrfs_write_out_cache+0x93/0xf0
[ 2515.294086]  [<ffffffff815c8466>] ? _raw_spin_unlock+0x26/0x30
[ 2515.294149]  [<ffffffff8128c933>] btrfs_write_dirty_block_groups+0x503/0x5f0
[ 2515.294214]  [<ffffffff815c11ff>] commit_cowonly_roots+0x10d/0x1de
[ 2515.294280]  [<ffffffff8129d8bf>] ? btrfs_commit_transaction+0x5bf/0xa40
[ 2515.294349]  [<ffffffff8129d91e>] btrfs_commit_transaction+0x61e/0xa40
[ 2515.294415]  [<ffffffff810527c0>] ? __init_waitqueue_head+0x60/0x60
[ 2515.294481]  [<ffffffff8129e1cb>] ? start_transaction+0x8b/0x2a0
[ 2515.294548]  [<ffffffff81295dc5>] transaction_kthread+0x255/0x2d0
[ 2515.294615]  [<ffffffff81295b70>] ? cleaner_kthread+0x1c0/0x1c0
[ 2515.294681]  [<ffffffff81051fad>] kthread+0x9d/0xb0
[ 2515.294745]  [<ffffffff815cfed4>] kernel_thread_helper+0x4/0x10
[ 2515.294812]  [<ffffffff81051f10>] ? __init_kthread_worker+0x70/0x70
[ 2515.294880]  [<ffffffff815cfed0>] ? gs_change+0xb/0xb
[ 2515.294943] 3 locks held by btrfs-transacti/4919:
[ 2515.295003]  #0:  (&fs_info->transaction_kthread_mutex){......},
at: [<ffffffff81295c47>] transaction_kthread+0xd7/0x2d0
[ 2515.295136]  #1:  (&fs_info->reloc_mutex){......}, at:
[<ffffffff8129d841>] btrfs_commit_transaction+0x541/0xa40
[ 2515.295266]  #2:  (&fs_info->tree_log_mutex){......}, at:
[<ffffffff8129d8bf>] btrfs_commit_transaction+0x5bf/0xa40
[ 2515.295403] INFO: task syslog-ng:6102 blocked for more than 120 seconds.
[ 2515.295472] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2515.295592] syslog-ng       D ffff8802226fb120     0  6102   5632 0x00000000
[ 2515.295664]  ffff8801e7cc5a98 0000000000000046 ffff8801e7cc59b8
ffff8801e7cc5fd8
[ 2515.295789]  ffff8801e7cc5fd8 0000000000004000 ffff88022359c460
ffff88021da40000
[ 2515.295911]  ffff8801e7cc59d8 0000000000000092 ffff88021da40000
ffff88021da40000
[ 2515.296034] Call Trace:
[ 2515.296092]  [<ffffffff8108039c>] ? lock_release_holdtime.part.9+0x1c/0x1a0
[ 2515.296161]  [<ffffffff815c6d94>] schedule+0x24/0x70
[ 2515.296227]  [<ffffffff8129cca5>] wait_current_trans.isra.31+0xa5/0xf0
[ 2515.296296]  [<ffffffff810527c0>] ? __init_waitqueue_head+0x60/0x60
[ 2515.296365]  [<ffffffff8129e328>] start_transaction+0x1e8/0x2a0
[ 2515.296432]  [<ffffffff8129e430>] btrfs_join_transaction+0x10/0x20
[ 2515.296502]  [<ffffffff812a8d70>] btrfs_dirty_inode+0x50/0xd0
[ 2515.296568]  [<ffffffff812a9017>] btrfs_update_time+0x57/0x90
[ 2515.296633]  [<ffffffff8103a4c1>] ? current_fs_time+0x11/0x50
[ 2515.296696]  [<ffffffff81121d30>] update_time+0x20/0xc0
[ 2515.296757]  [<ffffffff8112542d>] ? mnt_clone_write+0xd/0x30
[ 2515.296822]  [<ffffffff81121e64>] file_update_time+0x94/0xf0
[ 2515.296886]  [<ffffffff812ad370>] btrfs_file_aio_write+0x1c0/0x4b0
[ 2515.296949]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2515.297013]  [<ffffffff81080d1f>] ? __lock_acquire.isra.27+0x29f/0xb30
[ 2515.297077]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2515.297139]  [<ffffffff81061ea5>] ? sched_clock_cpu+0xc5/0x120
[ 2515.297202]  [<ffffffff812ad1b0>] ? __btrfs_buffered_write+0x320/0x320
[ 2515.297266]  [<ffffffff81108ee3>] do_sync_readv_writev+0xd3/0x110
[ 2515.297329]  [<ffffffff81080d1f>] ? __lock_acquire.isra.27+0x29f/0xb30
[ 2515.297394]  [<ffffffff8108039c>] ? lock_release_holdtime.part.9+0x1c/0x1a0
[ 2515.297459]  [<ffffffff8110901a>] ? rw_copy_check_uvector+0x7a/0x130
[ 2515.297523]  [<ffffffff81109198>] do_readv_writev+0xc8/0x1d0
[ 2515.297585]  [<ffffffff8108039c>] ? lock_release_holdtime.part.9+0x1c/0x1a0
[ 2515.297650]  [<ffffffff811092da>] vfs_writev+0x3a/0x50
[ 2515.297711]  [<ffffffff81109448>] sys_writev+0x48/0xc0
[ 2515.297772]  [<ffffffff815cebe2>] system_call_fastpath+0x16/0x1b
[ 2515.297835] 1 lock held by syslog-ng/6102:
[ 2515.301738]  #0:  (&sb->s_type->i_mutex_key#9){......}, at:
[<ffffffff812ad27f>] btrfs_file_aio_write+0xcf/0x4b0
[ 2515.301939] INFO: task flush-btrfs-1:5733 blocked for more than 120 seconds.
[ 2515.302007] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2515.302127] flush-btrfs-1   D ffff8802226fb120     0  5733      2 0x00000000
[ 2515.302195]  ffff88021b8356d0 0000000000000046 ffff88021b8355f0
ffff88021b835fd8
[ 2515.302316]  ffff88021b835fd8 0000000000004000 ffff880223592230
ffff88021ecda230
[ 2515.302441]  ffff88021b835610 0000000000000086 ffff88021ecda230
ffff88021ecda230
[ 2515.305963] Call Trace:
[ 2515.306023]  [<ffffffff8108039c>] ? lock_release_holdtime.part.9+0x1c/0x1a0
[ 2515.306093]  [<ffffffff815c6d94>] schedule+0x24/0x70
[ 2515.306157]  [<ffffffff8129cca5>] wait_current_trans.isra.31+0xa5/0xf0
[ 2515.306225]  [<ffffffff810527c0>] ? __init_waitqueue_head+0x60/0x60
[ 2515.306292]  [<ffffffff8129e328>] start_transaction+0x1e8/0x2a0
[ 2515.306358]  [<ffffffff8129e430>] btrfs_join_transaction+0x10/0x20
[ 2515.306424]  [<ffffffff812a463f>] cow_file_range+0x7f/0x480
[ 2515.306493]  [<ffffffff8108039c>] ? lock_release_holdtime.part.9+0x1c/0x1a0
[ 2515.306562]  [<ffffffff815c8466>] ? _raw_spin_unlock+0x26/0x30
[ 2515.306628]  [<ffffffff812a56dc>] run_delalloc_range+0x34c/0x370
[ 2515.306694]  [<ffffffff812c0ef0>] __extent_writepage+0x5d0/0x710
[ 2515.306761]  [<ffffffff810c5f3f>] ? find_get_pages_tag+0x11f/0x1c0
[ 2515.311059]  [<ffffffff810c5e49>] ? find_get_pages_tag+0x29/0x1c0
[ 2515.311127]  [<ffffffff812c12ea>]
extent_write_cache_pages.isra.37.constprop.50+0x2ba/0x410
[ 2515.311241]  [<ffffffff8112d9ce>] ? writeback_sb_inodes+0x12e/0x380
[ 2515.311305]  [<ffffffff8112d9ce>] ? writeback_sb_inodes+0x12e/0x380
[ 2515.311368]  [<ffffffff812c1674>] extent_writepages+0x44/0x60
[ 2515.312404]  [<ffffffff812a1990>] ? btrfs_writepage+0x70/0x70
[ 2515.312465]  [<ffffffff812a0dc3>] btrfs_writepages+0x23/0x30
[ 2515.312527]  [<ffffffff810d02be>] do_writepages+0x1e/0x30
[ 2515.312589]  [<ffffffff8112d17e>] __writeback_single_inode.isra.28+0x3e/0x120
[ 2515.312655]  [<ffffffff8112dacb>] writeback_sb_inodes+0x22b/0x380
[ 2515.312719]  [<ffffffff8112dcb6>] __writeback_inodes_wb+0x96/0xc0
[ 2515.312783]  [<ffffffff8112deab>] wb_writeback+0x1cb/0x1e0
[ 2515.312847]  [<ffffffff8112df57>] wb_check_old_data_flush+0x97/0xa0
[ 2515.312911]  [<ffffffff8112e2f8>] wb_do_writeback+0xc8/0x140
[ 2515.312975]  [<ffffffff8112e3e2>] bdi_writeback_thread+0x72/0x150
[ 2515.313038]  [<ffffffff8112e370>] ? wb_do_writeback+0x140/0x140
[ 2515.313108]  [<ffffffff81051fad>] kthread+0x9d/0xb0
[ 2515.313170]  [<ffffffff815cfed4>] kernel_thread_helper+0x4/0x10
[ 2515.313233]  [<ffffffff81051f10>] ? __init_kthread_worker+0x70/0x70
[ 2515.313300]  [<ffffffff815cfed0>] ? gs_change+0xb/0xb
[ 2515.313364] 1 lock held by flush-btrfs-1/5733:
[ 2515.313426]  #0:  (&type->s_umount_key#26){......}, at:
[<ffffffff8110b72f>] grab_super_passive+0x3f/0x90
[ 2522.420522] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u:3:6089]
[ 2522.420588] Modules linked in: netconsole configfs w83627ehf
hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4 coretemp hwmon
kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr microcode
i2c_core video button xts gf128mul aes_x86_64 aes_generic cbc
sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata
[ 2522.421297] CPU 0
[ 2522.421303] Modules linked in:[ 2522.421359]  netconsole configfs
w83627ehf hwmon_vid ipmi_si ipmi_devintf ipmi_msghandler autofs4
coretemp hwmon kvm_intel kvm e1000e lpc_ich mfd_core i2c_i801 pcspkr
microcode i2c_core video button xts gf128mul aes_x86_64 aes_generic
cbc sha256_generic e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc
reiserfs multipath linear raid0 dm_raid dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd
usb_storage ehci_hcd megaraid_sas megaraid_mbox megaraid_mm megaraid
sr_mod cdrom sd_mod sata_mv ata_piix ahci libahci pata_marvell
pata_mpiix libata

[ 2522.422112] Pid: 6089, comm: kworker/u:3 Not tainted
3.5.1-gentoo-dbg-lock-1 #2 To be filled by O.E.M. To be filled by
O.E.M./P8B-X series
[ 2522.422245] RIP: 0010:[<ffffffff81415150>]  [<ffffffff81415150>]
scsi_target_reap+0x10/0x100
[ 2522.422361] RSP: 0018:ffff880221dada90  EFLAGS: 00000286
[ 2522.422502] RAX: 0000000000000000 RBX: ffff88021e1bc460 RCX: 000000000000b828
[ 2522.422569] RDX: 0000000000002e40 RSI: ffff880226600000 RDI: ffff88021eb50000
[ 2522.422635] RBP: ffff880221dadab0 R08: 0000000000000001 R09: 0000000000000000
[ 2522.422702] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880221dada20
[ 2522.422771] R13: ffff8802233f20a8 R14: ffff88021e1bcb48 R15: 0000000000000082
[ 2522.422840] FS:  0000000000000000(0000) GS:ffff880226600000(0000)
knlGS:0000000000000000
[ 2522.422960] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2522.423026] CR2: 00007f42a5fb2070 CR3: 0000000001a0b000 CR4: 00000000000407f0
[ 2522.423093] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2522.423161] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2522.423228] Process kworker/u:3 (pid: 6089, threadinfo
ffff880221dac000, task ffff88021e1bc460)

-- 
John M. Drescher
