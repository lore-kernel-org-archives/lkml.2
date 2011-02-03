Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab1BCBUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 20:20:01 -0500
Received: from tomato.cardboardbox.org.uk ([174.143.157.65]:51362 "EHLO
	tomato.cardboardbox.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751711Ab1BCBT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 20:19:59 -0500
X-Greylist: delayed 2209 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Feb 2011 20:19:59 EST
Message-ID: <4D49FA15.40600@0x0f.com>
Date: Thu, 03 Feb 2011 00:43:01 +0000
From: Daniel Palmer <me@0x0f.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PATA_ARTOP doesn't detect connected disk on Landisk
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please CC me as I only subscribe to the digest.. LKML-proper would kill 
my mail server.

I'm running 2.6.35 on an I-O Data Landisk machine. So far I can't get a 
newer kernel to output anything to the serial console, the artop driver 
hasn't changed from what I can tell . The model is a HDL-???U so it has 
an PATA interface on the board for it's internal drive.  You can see 
photos of the same board here: 
http://su-u.jp/juju/%CA%AC%B2%F2%A4%B7%A4%C6%A4%DF%A4%E8%A4%A6/LANDISK.html

The original drive has died so I've replaced it with a CF adapter and 
4GB card.
Unfortunately the original drive was dead when I got the machine, so I 
haven't tested it with a standard drive.

I'm not sure if this problem is Landisk-specific or even specific to my 
Landisk.

When the machine boots SH IPL+g loads, detects the ARTOP (Its called 
A-Card here, they seem to be the same thing) controller and probes the 
disk and sh-lilo loads:

A-Card ATP865 ATA controller found.
PCIC initialization done.
MASTER:48bit LBA mode non support
Disk drive detected: SanDisk SDCFH-004G HDX 5.04      ALZ012210190202
LBA: 00778E30
DiskSize: 4011614208Byte
PIO MODE1
Set Transfer Mode result: 50
A-Card ATP865 ATA controller found.
 > b
Set Transfer Mode result: 50
Initialize Device Parameters result: 50
IDLE result: 50
LILO boot:

   1 : CF
   2 : USB


So I hit 1, which is my config for kernel from the CF and root is a 
partition on the CF card, the kernel loads and starts booting. I don't 
think there's any initramfs support in sh-lilo so everything that is 
needed to get root mounted is compiled into the kernel. And this happens..

push-switch: version 0.1.1 loaded
TCP cubic registered
NET: Registered protocol family 17
rs5c313 rs5c313: setting system clock to 2011-02-03 02:58:27 UTC 
(1296701907)
Waiting 20sec before mounting root device...
ata1: link is slow to respond, please be patient (ready=0)
ata1: SRST failed (errno=-16)
ata1: link is slow to respond, please be patient (ready=0)
ata1: SRST failed (errno=-16)
ata1: link is slow to respond, please be patient (ready=0)
ata1: SRST failed (errno=-16)
ata1: SRST failed (errno=-16)
ata1: reset failed, giving up
VFS: Cannot open root device "sda3" or unknown-block(0,0)
Please append a correct "root=" boot option; here are the available 
partitions:
Kernel panic - not syncing: VFS: Unable to mount root fs on 
unknown-block(0,0)
Stack: (0x8fc1df10 to 0x8fc1e000)
df00:                                     8c26eaaa 8c26eb40 8c130fc0 
8fc1df30
df20: 8c31bd28 00008001 8c26eb40 8c33628c 8fc1df3c 00000000 8c30d814 
6e6b6e75

Something is happening that is stopping the CF card from getting probed.
I've discovered though if I compile the Artop driver as a module, boot 
with root on a USB drive, unload the module, pull the card out, push it 
back in and reload the driver the CF card is detected any the partitions 
are probed and I can mount the fs just fine.

I've also discovered that if I pull the card just as the kernel starts 
booting and ram it back in really quickly the kernel will load up, 
detect the CF card and mount root. Timing has to be perfect though. If I 
do it too late the kernel panics straight away.

I'm guessing it's some sort of reset problem? I haven't ruled out that 
it could be some weirdness with my CF adapter. I don't have another to 
test at the moment. I have tried OpenBSD/Landisk on the same machine 
with the same CF card and it boots no problems. Shame it's unusably slow.

I'm going to mess around with the driver when I get some free time. 
Hopefully I can work out what is happening.
I have appended my serial output from when the machine boots correctly.


Cheers,

Daniel





SH IPL+g version 0.9, Copyright (C) 2000 Free Software Foundation, Inc.

This software comes with ABSOLUTELY NO WARRANTY; for details type `w'.
This is free software, and you are welcome to redistribute it under
certain conditions; type `l' for details.

2002/09/09 Making.  2003/10/16 I-O DATA NSD NWG Update.
266:133:33 on base clock 22.22MHz and SDRAM 4 burst. ATA boot.

A-Card ATP865 ATA controller found.
PCIC initialization done.
MASTER:48bit LBA mode non support
Disk drive detected: SanDisk SDCFH-004G HDX 5.04      ALZ012210190202
LBA: 00778E30
DiskSize: 4011614208Byte
PIO MODE1
Set Transfer Mode result: 50
A-Card ATP865 ATA controller found.
 > b
Set Transfer Mode result: 50
Initialize Device Parameters result: 50
IDLE result: 50
LILO boot:

   1 : CF
   2 : USB

Select boot image -> 1
Loading CF...................................done.
Setting GDB trap vector to 80000100
Linux version 2.6.35.10 (daniel@kyoro) (gcc version 4.4.5 (Debian 
4.4.5-10) ) #19 Tue Feb 1 10:49:40 GMT 2011
Boot params:
... MOUNT_ROOT_RDONLY - 00000001
... RAMDISK_FLAGS     - 00000000
... ORIG_ROOT_DEV     - 00000301
... LOADER_TYPE       - 00000001
... INITRD_START      - 00000000
... INITRD_SIZE       - 00000000
Memory limited to 64MB
Booting machvec: LANDISK
Node 0: start_pfn = 0xc000, low = 0x10000
Zone PFN ranges:
   Normal   0x0000c000 -> 0x00010000
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
     0: 0x0000c000 -> 0x00010000
I-O DATA DEVICE, INC. "LANDISK Series" support.
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16256
Kernel command line: ro BOOT_FILE=/boot/zImage mem=64M 
console=ttySC1,9600 root=/dev/sda3 rootdelay=20
PID hash table entries: 256 (order: -2, 1024 bytes)
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
PVR=04050005 CVR=20480000 PRR=00000113
I-cache : n_ways=2 n_sets=256 way_incr=8192
I-cache : entry_mask=0x00001fe0 alias_mask=0x00001000 n_aliases=2
D-cache : n_ways=2 n_sets=512 way_incr=16384
D-cache : entry_mask=0x00003fe0 alias_mask=0x00003000 n_aliases=4
Memory: 61596k/65536k available (2503k kernel code, 669k data, 108k init)
virtual kernel memory layout:
     fixmap  : 0xdfff7000 - 0xdffff000   (  32 kB)
     vmalloc : 0xc0000000 - 0xdfff5000   ( 511 MB)
     lowmem  : 0x8c000000 - 0x90000000   (  64 MB) (cached)
             : 0xa0000000 - 0xc0000000   ( 512 MB) (uncached)
       .init : 0x8c31b000 - 0x8c336000   ( 108 kB)
       .data : 0x8c272db0 - 0x8c31a5a0   ( 669 kB)
       .text : 0x8c001000 - 0x8c272db0   (2503 kB)
Hierarchical RCU implementation.
         RCU-based detection of stalled CPUs is disabled.
         Verbose stalled-CPUs detection is disabled.
NR_IRQS:256 nr_irqs:256
intc: Registered controller 'sh7750' with 20 IRQs
intc: Registered controller 'sh7750_dma8' with 9 IRQs
intc: Registered controller 'sh7750_tmu34' with 2 IRQs
intc: Registered controller 'sh7750_pci' with 8 IRQs
intc: Registered controller 'landisk' with 8 IRQs
Console: colour dummy device 80x25
  sh_tmu.0: used for clock events
  sh_tmu.0: used for periodic clock events
  sh_tmu.1: used as clock source
Calibrating delay loop (skipped)... 266.66 BogoMIPS PRESET (lpj=533333)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: SH7751R
devtmpfs: initialized
NET: Registered protocol family 16
PCI: Starting intialization.
bio: create slab <bio-0> at 0
vgaarb: loaded
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
DMA: Registering sh_dmac handler (8 channels).
DMA: Registering DMA API.
pci 0000:00:01.0: BAR 6: assigned [mem 0xfd000000-0xfd00ffff pref]
pci 0000:00:02.0: BAR 0: assigned [mem 0xfd010000-0xfd010fff]
pci 0000:00:02.0: BAR 0: set to [mem 0xfd010000-0xfd010fff] (PCI address 
[0xfd010000-0xfd010fff]
pci 0000:00:02.1: BAR 0: assigned [mem 0xfd011000-0xfd011fff]
pci 0000:00:02.1: BAR 0: set to [mem 0xfd011000-0xfd011fff] (PCI address 
[0xfd011000-0xfd011fff]
pci 0000:00:00.0: BAR 0: assigned [io  0x1000-0x10ff]
pci 0000:00:00.0: BAR 0: set to [io  0x1000-0x10ff] (PCI address 
[0x1000-0x10ff]
pci 0000:00:00.0: BAR 1: assigned [mem 0xfd012000-0xfd0120ff]
pci 0000:00:00.0: BAR 1: set to [mem 0xfd012000-0xfd0120ff] (PCI address 
[0xfd012000-0xfd0120ff]
pci 0000:00:02.2: BAR 0: assigned [mem 0xfd012100-0xfd0121ff]
pci 0000:00:02.2: BAR 0: set to [mem 0xfd012100-0xfd0121ff] (PCI address 
[0xfd012100-0xfd0121ff]
pci 0000:00:01.0: BAR 4: assigned [io  0x1400-0x140f]
pci 0000:00:01.0: BAR 4: set to [io  0x1400-0x140f] (PCI address 
[0x1400-0x140f]
pci 0000:00:01.0: BAR 0: assigned [io  0x1410-0x1417]
pci 0000:00:01.0: BAR 0: set to [io  0x1410-0x1417] (PCI address 
[0x1410-0x1417]
pci 0000:00:01.0: BAR 2: assigned [io  0x1418-0x141f]
pci 0000:00:01.0: BAR 2: set to [io  0x1418-0x141f] (PCI address 
[0x1418-0x141f]
pci 0000:00:01.0: BAR 1: assigned [io  0x1420-0x1423]
pci 0000:00:01.0: BAR 1: set to [io  0x1420-0x1423] (PCI address 
[0x1420-0x1423]
pci 0000:00:01.0: BAR 3: assigned [io  0x1424-0x1427]
pci 0000:00:01.0: BAR 3: set to [io  0x1424-0x1427] (PCI address 
[0x1424-0x1427]
Switching to clocksource sh_tmu.1
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 2048 (order: 2, 16384 bytes)
TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
TCP: Hash tables configured (established 2048 bind 2048)
TCP reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
gio: driver initialized
msgmni has been set to 120
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
SuperH SCI(F) driver initialized
sh-sci.0: ttySC0 at MMIO 0xffe00000 (irq = 23) is a sci
sh-sci.1: ttySC1 at MMIO 0xffe80000 (irq = 40) is a scif
console [ttySC1] enabled
loop: module loaded
scsi0 : pata_artop
scsi1 : pata_artop
ata1: PATA max UDMA/133 cmd 0x1410 ctl 0x1420 bmdma 0x1400 irq 6
ata2: PATA max UDMA/133 cmd 0x1418 ctl 0x1424 bmdma 0x1408 irq 6
scsi2 : pata_platform
ata3: PATA max PIO0 ioport cmd 0xc0000040 ctl 0xc000002c irq 10
8139cp: 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
PCI: Enabling device 0000:00:00.0 (0000 -> 0003)
8139cp 0000:00:00.0: eth0: RTL-8139C+ at 0xfd012000, 00:a0:b0:4c:cf:c6, 
IRQ 5
PCI: Setting latency timer of device 0000:00:00.0 to 64
usbmon: debugfs is not available
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
PCI: Enabling device 0000:00:02.2 (0000 -> 0002)
ehci_hcd 0000:00:02.2: EHCI Host Controller
ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.2: Enabling legacy PCI PM
ehci_hcd 0000:00:02.2: irq 5, io mem 0xfd012100
ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 5 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
PCI: Enabling device 0000:00:02.0 (0000 -> 0002)
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 7, io mem 0xfd010000
ata1.00: CFA: SanDisk SDCFH-004G, HDX 5.04, max UDMA/66
ata1.00: 7835184 sectors, multi 0: LBA
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
ata1.00: configured for UDMA/66
scsi 0:0:0:0: Direct-Access     ATA      SanDisk SDCFH-00 HDX  PQ: 0 
ANSI: 5
sd 0:0:0:0: [sda] 7835184 512-byte logical blocks: (4.01 GB/3.73 GiB)
PCI: Enabling device 0000:00:02.1 (0000 -> 0002)
PCI: Setting latency timer of device 0000:00:02.1 to 64
ohci_hcd 0000:00:02.1: OHCI Host Controller
ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:02.1: irq 8, io mem 0xfd011000
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't 
support DPO or FUA
  sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI removable disk
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
mice: PS/2 mouse device common for all mice
rs5c313 rs5c313: rtc core: registered rs5c313 as rtc0
sh_tmu sh_tmu.0: kept as earlytimer
sh_tmu sh_tmu.1: kept as earlytimer
push-switch: version 0.1.1 loaded
TCP cubic registered
NET: Registered protocol family 17
rs5c313 rs5c313: setting system clock to 2011-02-03 03:02:37 UTC 
(1296702157)
Waiting 20sec before mounting root device...
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda3): mounted filesystem with writeback data mode
VFS: Mounted root (ext3 filesystem) readonly on device 8:3.
devtmpfs: mounted
Freeing unused kernel memory: 108k freed
INIT: version 2.88 booting
Using makefile-style concurrent boot in runlevel S.
Starting the hotplug events dispatcher: udevdudev[851]: starting version 
164
.
Synthesizing the initial hotplug events...done.
