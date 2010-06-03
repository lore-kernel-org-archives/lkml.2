Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab0FCTED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 15:04:03 -0400
Received: from mail.vyatta.com ([76.74.103.46]:54792 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab0FCTEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 15:04:00 -0400
Date: Thu, 3 Jun 2010 12:03:13 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: floppy driver assumes INITIAL_JIFFIES == 0
Message-ID: <20100603120313.10a73b20@nehalam>
In-Reply-To: <alpine.LFD.2.00.1006031013060.8175@i5.linux-foundation.org>
References: <20100603101501.5e5d7148@nehalam>
	<alpine.LFD.2.00.1006031013060.8175@i5.linux-foundation.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010 10:28:17 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 3 Jun 2010, Stephen Hemminger wrote:
> > 
> > The driver is a complex mess of spaghetti state. Does one of the original
> > authors have more background to fix this?
> 
> Doubtful. There are no "original authors" left really. Yes, I technically 
> wrote the original driver, but it has gotten seriously rewritten a couple 
> of times - sadly always just expanding on the cruftyness.
> 
> I do wonder a bit why you even care. You can't even buy non-USB floppy 
> drives any more (and even the USB ones are really really hard to find), 
> and judging by my experiences, they don't last long enough for there to be 
> much of a legacy base.
> 
> But please post the oops. I don't think it should ever be valid to oops 
> even if it gets confused about first_read_date or last_checked. Some 
> hacking around for them being "in the future" would be trivial enough.
> 
> But most of them shouldn't matter. The whole 'first_read_date', for 
> example, is purely used for some randomness - it tries to use the 
> 'revolutions per second' to decide when to stop the drive, but that's just 
> some voodoo programming and has no real meaning, afaik.
> 
> The oops would be interesting just to see _which_ case it is that we care 
> about the time so much (clearly _too_ much).
> 
> 		Linus

Example warning from 2.6.32 (VMware based regression system)

[  195.061209] floppy0: disk absent or changed during operation
[  195.061655] end_request: I/O error, dev fd0, sector 2
[  195.063860] Buffer I/O error on device fd0, logical block 1
[  195.064650] lost page write due to I/O error on fd0
[  195.067456] floppy0: disk absent or changed during operation
[  195.067468] end_request: I/O error, dev fd0, sector 2
[  195.068518] Buffer I/O error on device fd0, logical block 1
[  195.069618] lost page write due to I/O error on fd0
[  195.077148] ------------[ cut here ]------------
[  195.077647] WARNING: at fs/buffer.c:1159 mark_buffer_dirty+0x20/0x7a()
[  195.077699] Hardware name: VMware Virtual Platform
[  195.077743] Modules linked in: iptable_nat iptable_filter ip6table_filter ip6table_raw ip6_tables xt_NOTRACK iptable_
raw ip_tables x_tables nf_nat_pptp nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_h323 nf_conntrack_h323 nf_nat_sip nf_
conntrack_sip nf_nat_proto_gre nf_nat_tftp nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_tftp nf_connt
rack_ftp nf_conntrack ipv6 container ac button processor parport_pc parport psmouse serio_raw intel_agp shpchp i2c_piix4
 pci_hotplug agpgart i2c_core pcspkr evdev vfat fat ext2 mbcache battery squashfs loop unionfs nls_utf8 isofs nls_base a
sync_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx md_mod sg sr_mod cdrom ata_piix sd_mod crc_t10dif
 pata_acpi ata_generic mptspi mptscsih libata mptbase scsi_transport_spi floppy e1000 scsi_mod thermal fan thermal_sys [
last unloaded: raid10]
[  195.078800] Pid: 3118, comm: umount Not tainted 2.6.32-1-586-vyatta #1
[  195.078825] Call Trace:
[  195.079041]  [<c102bfdf>] ? warn_slowpath_common+0x5e/0x8a
[  195.079107]  [<c102c015>] ? warn_slowpath_null+0xa/0xc
[  195.079112]  [<c10bd987>] ? mark_buffer_dirty+0x20/0x7a
[  195.079296]  [<d085d37d>] ? ext2_sync_fs+0x5e/0x70 [ext2]
[  195.079302]  [<c10bc15f>] ? __sync_filesystem+0x51/0x60
[  195.079335]  [<c10a49cb>] ? generic_shutdown_super+0x19/0xc7
[  195.079339]  [<c10a4a93>] ? kill_block_super+0x1a/0x2c
[  195.079382]  [<c10d2e82>] ? vfs_quota_off+0x0/0xd
[  195.079386]  [<c10a4ff2>] ? deactivate_super+0x4b/0x61
[  195.079391]  [<c10b4f2a>] ? sys_umount+0x28c/0x2b2
[  195.079394]  [<c10b4f5b>] ? sys_oldumount+0xb/0xe
[  195.079398]  [<c10029b5>] ? syscall_call+0x7/0xb
[  195.079469] ---[ end trace 89a1db2950506e4b ]---
[  195.079594] floppy0: disk absent or changed during operation
[  195.079598] end_request: I/O error, dev fd0, sector 2
[  195.080630] Buffer I/O error on device fd0, logical block 1
[  195.080997] lost page write due to I/O error on fd0
[  195.084480] floppy0: disk absent or changed during operation
[  195.084487] end_request: I/O error, dev fd0, sector 2
[  195.085761] Buffer I/O error on device fd0, logical block 1
[  195.086906] lost page write due to I/O error on fd0
[  317.428247] Netfilter messages via NETLINK v0.30.
[  317.480612] ctnetlink v0.93: registering with nfnetlink.
[  506.734183] NET: Registered protocol family 15

On 2.6.32 example (KVM with livecd + empty floppy image) and debugging
forced on:

[    6.795067] floppy0: reschedule timeout lock fdc
[    6.796628] floppy: poll_drive
[    6.797602] floppy0: setting NEWCHANGE in poll_drive
[    6.798949] floppy0: calling disk change from floppy_ready
[    6.800538] floppy0: checking disk change line for drive 0
[    6.802171] floppy0: jiffies=4294893996
[    6.803439] floppy0: disk change line=0
[    6.804595] floppy0: flags=24
[    6.805579] rw_command:  dtime=720
[    6.806633] floppy0: reschedule timeout do wakeup
[    6.808198] FAT: utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
[    6.810797] floppy: do_fd_request
[    6.811832] floppy0: do_fd_request
[    6.812917] floppy0: reschedule timeout redo fd request
[    6.814656] floppy0: checking disk change line for drive 0
[    6.818855] floppy0: jiffies=4294894000
[    6.820509] floppy0: disk change line=0
[    6.822154] floppy0: flags=20
[    6.823463] floppy0: reschedule timeout request done 1
[    6.825272] unlock_fdc
[    7.038143] udevd version 125 started
[    7.841449] input: PC Speaker as /class/input/input2
[    7.850997] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
[    7.895128]   alloc irq_desc for 24 on node -1
[    7.896068]   alloc kstat_irqs on node -1
[    7.897640] virtio-pci 0000:00:03.0: irq 24 for MSI/MSI-X
[    7.898998]   alloc irq_desc for 25 on node -1
[    7.900213]   alloc kstat_irqs on node -1
[    7.901382] virtio-pci 0000:00:03.0: irq 25 for MSI/MSI-X
[    7.903096]   alloc irq_desc for 26 on node -1
[    7.904351]   alloc kstat_irqs on node -1
[    7.905550] virtio-pci 0000:00:03.0: irq 26 for MSI/MSI-X
[    8.126101] input: Power Button as /class/input/input3
[    8.127620] ACPI: Power Button [PWRF]
[    8.160496] processor LNXCPU:00: registered as cooling_device0
[    8.237244] input: ImExPS/2 Generic Explorer Mouse as /class/input/input4
[    9.724066] floppy0: calling disk change from set_dor
[    9.726342] floppy0: checking disk change line for drive 0
[    9.728740] floppy0: jiffies=4294894728
[    9.730566] floppy0: disk change line=0
[    9.732371] floppy0: flags=20
[   14.040103] end_request: I/O error, dev fd0, sector 2176
[   14.041418] Buffer I/O error on device fd0, logical block 272
[   14.042737] BUG: unable to handle kernel NULL pointer dereference at 00000040
[   14.044052] IP: [<e08c2903>] floppy_ready+0x46f/0x4e3 [floppy]
[   14.044052] *pde = 00000000 
[   14.044052] Oops: 0000 [#1] SMP 
[   14.044052] last sysfs file: /sys/class/net/lo/operstate
[   14.044052] Modules linked in: ipv6 processor button psmouse virtio_net i2c_piix4 serio_raw pcspkr i2c_core evdev joydev vfat fat ext2 mbcache battery squashfs loop unionfs nls_utf8 isofs usbhid hid raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 multipath linear md_mod sg sr_mod cdrom ata_piix virtio_blk pata_acpi ata_generic uhci_hcd libata virtio_pci virtio_ring usbcore nls_base floppy scsi_mod virtio thermal fan thermal_sys [last unloaded: scsi_wait_scan]
[   14.044052] 
[   14.044052] Pid: 6, comm: events/0 Not tainted (2.6.32-1-586-vyatta #1) Bochs
[   14.044052] EIP: 0060:[<e08c2903>] EFLAGS: 00010246 CPU: 0
[   14.044052] EIP is at floppy_ready+0x46f/0x4e3 [floppy]
[   14.044052] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
[   14.044052] ESI: 00000202 EDI: df03ffb0 EBP: e08c626c ESP: df03ff68
[   14.044052]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   14.044052] Process events/0 (pid: 6, ti=df03e000 task=df0254a0 task.ti=df03e000)
[   14.044052] Stack:
[   14.044052]  df03ff00 e08bf4bd e08c46d5 e08c5715 c1c07f80 e08c6268 c103c31f df0256b4
[   14.044052] <0> df0254a0 c1c07f8c c1c07f84 e08c2d1c df0254a0 00000000 df0254a0 c103f00e
[   14.044052] <0> df03ffa8 df03ffa8 df023f58 c1c07f80 c103c1e1 00000000 c103eddb 00000000
[   14.044052] Call Trace:
[   14.044052]  [<e08bf4bd>] ? debugt+0x2c/0x30 [floppy]
[   14.044052]  [<c103c31f>] ? worker_thread+0x13e/0x1b6
[   14.044052]  [<e08c2d1c>] ? seek_interrupt+0x0/0xf8 [floppy]
[   14.044052]  [<c103f00e>] ? autoremove_wake_function+0x0/0x2d
[   14.044052]  [<c103c1e1>] ? worker_thread+0x0/0x1b6
[   14.044052]  [<c103eddb>] ? kthread+0x61/0x66
[   14.044052]  [<c103ed7a>] ? kthread+0x0/0x66
[   14.044052]  [<c10034a7>] ? kernel_thread_helper+0x7/0x10
[   14.044052] Code: 20 eb 18 0f b6 05 c8 7b 8c e0 6b c0 34 8d 90 e0 6d 8c e0 3e 80 a0 e0 6d 8c e0 df 0f b6 05 c8 7b 8c e0 8b 15 00 72 8c e0 6b c0 34 <8b> 5a 40 0f bf 80 f2 6d 8c e0 39 c3 74 56 80 3a 00 79 51 b8 0f 
[   14.044052] EIP: [<e08c2903>] floppy_ready+0x46f/0x4e3 [floppy] SS:ESP 0068:df03ff68
[   14.044052] CR2: 0000000000000040
[   14.109388] ---[ end trace 0efe46cb49bca248 ]---
[   14.110462] Kernel panic - not syncing: Fatal exception
[   14.111639] Pid: 6, comm: events/0 Tainted: G      D    2.6.32-1-586-vyatta #1
[   14.113449] Call Trace:
[   14.114235]  [<c1226541>] ? panic+0x38/0xd8
[   14.115342]  [<c1005764>] ? oops_end+0x6c/0x76
[   14.116420]  [<c10190a9>] ? no_context+0x105/0x10e
[   14.120248]  [<c10191f3>] ? __bad_area_nosemaphore+0x141/0x14c
[   14.121656]  [<c1062823>] ? __rcu_process_callbacks+0x67/0x1fa
[   14.123439]  [<c10629e9>] ? rcu_process_callbacks+0x33/0x39
[   14.125750]  [<c1030f02>] ? __do_softirq+0x110/0x147
[   14.127760]  [<c103103b>] ? irq_exit+0x36/0x58
[   14.129666]  [<c101381f>] ? smp_apic_timer_interrupt+0x6c/0x76
[   14.131942]  [<c100329a>] ? apic_timer_interrupt+0x2a/0x30
[   14.133878]  [<c1019378>] ? do_page_fault+0x0/0x270
[   14.135045]  [<c1019208>] ? bad_area_nosemaphore+0xa/0xc
[   14.136327]  [<c12280d6>] ? error_code+0x66/0x70
[   14.137427]  [<e08c007b>] ? raw_cmd_done+0xc2/0x118 [floppy]
[   14.138679]  [<c1019378>] ? do_page_fault+0x0/0x270
[   14.139815]  [<e08c2903>] ? floppy_ready+0x46f/0x4e3 [floppy]
[   14.141151]  [<e08bf4bd>] ? debugt+0x2c/0x30 [floppy]
[   14.142318]  [<c103c31f>] ? worker_thread+0x13e/0x1b6
[   14.143520]  [<e08c2d1c>] ? seek_interrupt+0x0/0xf8 [floppy]
[   14.144819]  [<c103f00e>] ? autoremove_wake_function+0x0/0x2d
[   14.146202]  [<c103c1e1>] ? worker_thread+0x0/0x1b6
[   14.147327]  [<c103eddb>] ? kthread+0x61/0x66
[   14.148495]  [<c103ed7a>] ? kthread+0x0/0x66
[   14.149549]  [<c10034a7>] ? kernel_thread_helper+0x7/0x10


On 2.6.31 another example:
[    2.034647] Uniform CD-ROM driver Revision: 3.20
[    2.036041] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.043056] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    2.083934] md: linear personality registered for level -1
[    2.089263] md: multipath personality registered for level -4
[    2.094470] md: raid0 personality registered for level 0
[    2.100858] md: raid1 personality registered for level 1
[    2.102420] usb 1-1: new full speed USB device using uhci_hcd and address 2
[    2.107393] xor: automatically using best checksumming function: pIII_sse
[    2.128069]    pIII_sse  :  9200.000 MB/sec
[    2.129289] xor: using function: pIII_sse (9200.000 MB/sec)
[    2.131952] async_tx: api initialized (sync-only)
[    2.200106] raid6: int32x1   1001 MB/s
[    2.268093] raid6: int32x2   1017 MB/s
[    2.336128] raid6: int32x4    698 MB/s
[    2.404073] raid6: int32x8    669 MB/s
[    2.472041] raid6: mmxx1     3167 MB/s
[    2.540072] raid6: mmxx2     3686 MB/s
[    2.608068] raid6: sse1x1    2875 MB/s
[    2.676077] raid6: sse1x2    3303 MB/s
[    2.744063] raid6: sse2x1    5762 MB/s
[    2.812037] raid6: sse2x2    6508 MB/s
[    2.813162] raid6: using algorithm sse2x2 (6508 MB/s)
[    2.819556] md: raid6 personality registered for level 6
[    2.821279] md: raid5 personality registered for level 5
[    2.822816] md: raid4 personality registered for level 4
[    2.847176] md: raid10 personality registered for level 10
[    2.910253] ISO 9660 Extensions: Microsoft Joliet Level 3
[    2.914298] ISO 9660 Extensions: RRIP_1991A
[    2.923609] Registering unionfs 2.5.3 (for 2.6.31)
[    2.937957] loop: module loaded
[    2.949895] usb 1-1: New USB device found, idVendor=0627, idProduct=0001
[    2.951870] usb 1-1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.956341] usb 1-1: Product: QEMU USB Tablet
[    2.957564] usb 1-1: Manufacturer: QEMU 0.12.3
[    2.959162] usb 1-1: SerialNumber: 1
[    2.960399] usb 1-1: configuration #1 chosen from 1 choice
[    3.011128] usbcore: registered new interface driver hiddev
[    3.038588] input: QEMU 0.12.3 QEMU USB Tablet as /class/input/input1
[    3.041509] generic-usb 0003:0627:0001.0001: input,hidraw0: USB HID v0.01 Pointer [QEMU 0.12.3 QEMU USB Tablet] on usb-0000:00:01.2-1/input0
[    3.046497] usbcore: registered new interface driver usbhid
[    3.048891] usbhid: v2.6:USB HID core driver
[    3.113265] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    4.592572] floppy0: long rw: 1e instead of f
[    4.594671] rs=1 s=1
[    4.595999] rh=0 h=0
[    4.597317] rt=1 t=0
[    4.598514] heads=2 eoc=0
[    4.599891] spt=15 st=0 ss=1
[    4.601472] in_sector_offset=0
[    7.600014] 
[    7.600677] floppy driver state
[    7.601581] -------------------
[    7.602438] now=4294894196 last interrupt=4294894195 diff=1 last called handler=e085c053
[    7.604380] timeout_message=floppy start
[    7.605365] last output bytes:
[    7.606212]  0 80 4294894195
[    7.607022]  8 80 4294894195
[    7.607832] 48 80 4294894195
[    7.608651]  f 80 4294894195
[    7.609460]  0 80 4294894195
[    7.610275]  8 80 4294894195
[    7.611102] 48 80 4294894195
[    7.611971]  f 80 4294894195
[    7.612791]  0 80 4294894195
[    7.613600]  8 80 4294894195
[    7.614408] 48 80 4294894195
[    7.615224]  f 80 4294894195
[    7.616047]  0 80 4294894195
[    7.616848]  8 80 4294894195
[    7.617649] 48 80 4294894195
[    7.618456]  f 80 4294894195
[    7.619267]  0 80 4294894195
[    7.620092]  8 80 4294894195
[    7.620903] 48 80 4294894195
[    7.621769]  f 80 4294894195
[    7.622581] last result at 4294894195
[    7.623581] last redo_fd_request at 4294893446
[    7.624731] 20  1 
[    7.625595] status=80
[    7.626305] fdc_busy=1
[    7.627026] do_floppy=e085c053
[    7.627856] cont=e08615dc
[    7.628637] current_req=df813d48
[    7.629567] command_status=-1
[    7.630464] 
[    7.631041] floppy0: floppy timeout called
[    7.632137] end_request: I/O error, dev fd0, sector 2176
[    7.634932] Buffer I/O error on device fd0, logical block 272
[    7.636493] BUG: unable to handle kernel NULL pointer dereference at 00000004
[    7.638225] IP: [<e0858d46>] reset_interrupt+0x41/0x45 [floppy]
[    7.639660] *pde = 00000000 
[    7.640243] Oops: 0000 [#1] SMP 
[    7.640243] last sysfs file: /sys/block/loop0/size
[    7.640243] Modules linked in: vfat fat ext2 mbcache battery squashfs usbhid hid loop unionfs nls_utf8 isofs raid10 raid456 raid6_pq async_xor async_memcpy async_tx xor raid1 raid0 multipath linear md_mod sg sr_mod cdrom virtio_blk ata_piix pata_acpi ata_generic uhci_hcd libata virtio_pci virtio_ring virtio usbcore nls_base scsi_mod floppy thermal fan thermal_sys [last unloaded: scsi_wait_scan]
[    7.640243] 
[    7.640243] Pid: 6, comm: events/0 Not tainted (2.6.31-1-586-vyatta #1) Bochs
[    7.640243] EIP: 0060:[<e0858d46>] EFLAGS: 00010246 CPU: 0
[    7.640243] EIP is at reset_interrupt+0x41/0x45 [floppy]
[    7.640243] EAX: 00000000 EBX: c183be80 ECX: c183be84 EDX: 00000080
[    7.640243] ESI: e08615c4 EDI: df03ffb0 EBP: e08615c8 ESP: df03ff88
[    7.640243]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    7.640243] Process events/0 (pid: 6, ti=df03e000 task=df02d450 task.ti=df03e000)
[    7.640243] Stack:
[    7.640243]  c10377cb c183be8c c183be84 e0858d05 df02d450 00000000 df02d450 c103ac36
[    7.640243] <0> df03ffa8 df03ffa8 df02bf58 c183be80 c1037692 00000000 c103a995 00000000
[    7.640243] <0> 00000000 00000000 df03ffd0 df03ffd0 c103a927 00000000 00000000 c10034c7
[    7.640243] Call Trace:
[    7.640243]  [<c10377cb>] ? worker_thread+0x139/0x1b6
[    7.640243]  [<e0858d05>] ? reset_interrupt+0x0/0x45 [floppy]
[    7.640243]  [<c103ac36>] ? autoremove_wake_function+0x0/0x2d
[    7.640243]  [<c1037692>] ? worker_thread+0x0/0x1b6
[    7.640243]  [<c103a995>] ? kthread+0x6e/0x73
[    7.640243]  [<c103a927>] ? kthread+0x0/0x73
[    7.640243]  [<c10034c7>] ? kernel_thread_helper+0x7/0x10
[    7.640243] Code: 05 f6 80 20 2f 86 e0 04 74 1c a1 04 2f 86 e0 ff 70 08 68 d5 dc 85 e0 e8 44 32 9b e0 a1 04 2f 86 e0 ff 50 08 58 5a a1 04 2f 86 e0 <ff> 50 04 c3 e8 92 fe ff ff 83 ca ff 85 c0 78 14 25 e0 00 00 00 
[    7.640243] EIP: [<e0858d46>] reset_interrupt+0x41/0x45 [floppy] SS:ESP 0068:df03ff88
[    7.640243] CR2: 0000000000000004
[    7.696611] ---[ end trace 3fb89013086fe1da ]---


-- 
