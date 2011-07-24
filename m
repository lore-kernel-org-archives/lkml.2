Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab1GXNNX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 09:13:23 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:52330 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab1GXNNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 09:13:19 -0400
X-Greylist: delayed 551 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jul 2011 09:13:18 EDT
Date: Sun, 24 Jul 2011 10:04:00 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [REGRESSION] [BISECTED] Unable to use 3D with Radeon 2100 and UI
 freezes with Firefox
Message-ID: <20110724130336.GA2116@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Thomas and other people,

After experiencing problems with many post 2.6.38 kernels with X when I used
Firefox to see any webpage that used some of the new HTML5 features (Firefox
freeze completely X and I could only log in remotely with SSH), I took some
time to see where things went wrong and, to cut a long story short, I
bisected the kernel and I found that a commit of yours was the first one
that introduced a problem with my system:

,----
| rbrito:~/linux-2.6$ git bisect bad
| fa27271bc8d230355c1f24ddea103824fdc12de6 is the first bad commit
| commit fa27271bc8d230355c1f24ddea103824fdc12de6
| Author: Thomas Gleixner <tglx@linutronix.de>
| Date:   Mon Feb 7 09:10:39 2011 +0100
| 
|     genirq: Fixup poll handling
|     
|     try_one_irq() contains redundant code and lots of useless checks for
|     shared interrupts. Check for shared before setting IRQ_INPROGRESS and
|     then call handle_IRQ_event() while pending. Shorter version with the
|     same functionality.
|     
|     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
| 
| :040000 040000 c95a9924689379c833a9e658222f7c0885f6cef7 96bbb50baa3f05f576c845c0e7c981d1e785cde9 M	kernel
| rbrito:~/linux-2.6$ 
`----

Here I have the dmesg output slightly edited with the points that I think
that are the most relevant to the problem. Please note that my understanding
of devices/hardware is next to nothing and I may have cut important parts.

,----[ dmesg.txt ]
| (...)
| [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.38-rc5+ root=UUID=c1b72bf3-c292-411d-832a-0b92510b158f ro irqpoll
| (...)
| [    0.663091] Freeing initrd memory: 2980k freed
| [    0.663981] PCI-DMA: Disabling AGP.
| [    0.664115] PCI-DMA: aperture base @ cc000000 size 65536 KB
| [    0.664153] PCI-DMA: using GART IOMMU.
| [    0.664191] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
| [    0.668361] HugeTLB registered 2 MB page size, pre-allocated 0 pages
| (...)
| [    1.037417] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
| [    1.037457] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
| [    1.037500] usb usb4: Product: OHCI Host Controller
| [    1.037537] usb usb4: Manufacturer: Linux 2.6.38-rc5+ ohci_hcd
| [    1.037575] usb usb4: SerialNumber: 0000:00:12.1
| [    1.037705] hub 4-0:1.0: USB hub found
| [    1.037747] hub 4-0:1.0: 3 ports detected
| [    1.037856] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
| [    1.037907] ohci_hcd 0000:00:13.0: OHCI Host Controller
| [    1.037948] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
| [    1.066725] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe8fc000
| (...)
| [    4.326808] [drm] Initialized drm 1.1.0 20060810
| [    4.484586] Error: Driver 'pcspkr' is already registered, aborting...
| [    4.583911] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
| [    4.684976] [drm] radeon kernel modesetting enabled.
| [    4.685072] pci 0000:00:01.0: can't derive routing for PCI INT A
| [    4.685110] radeon 0000:01:05.0: PCI INT A: no GSI - using ISA IRQ 10
| [    4.686557] [drm] initializing kernel modesetting (RS740 0x1002:0x796E).
| [    4.686616] [drm] register mmio base: 0xFEAF0000
| [    4.686653] [drm] register mmio size: 65536
| [    4.690479] ATOM BIOS: ATI
| [    4.690525] radeon 0000:01:05.0: VRAM: 128M 0x00000000D8000000 - 0x00000000DFFFFFFF (128M used)
| [    4.690569] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
| [    4.690612] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
| [    4.690649] [drm] Driver supports precise vblank timestamp query.
| [    4.690698] [drm] radeon: irq initialized.
| [    4.692957] [drm] Detected VRAM RAM=128M, BAR=128M
| [    4.693000] [drm] RAM width 128bits DDR
| [    4.693108] [TTM] Zone  kernel: Available graphics memory: 1964188 kiB.
| [    4.693146] [TTM] Initializing pool allocator.
| [    4.693197] [drm] radeon: 128M of VRAM memory ready
| [    4.693234] [drm] radeon: 512M of GTT memory ready.
| [    4.693274] [drm] GART: num cpu pages 131072, num gpu pages 131072
| [    4.719431] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
| [    4.730617] radeon 0000:01:05.0: WB enabled
| [    4.730694] [drm] Loading RS690/RS740 Microcode
| [    4.739563] hda_codec: ALC662 rev1: BIOS auto-probing.
| [    4.744345] input: HDA ATI SB Headphone as /devices/pci0000:00/0000:00:14.2/sound/card0/input5
| [    4.891800] [drm] radeon: ring at 0x00000000A0001000
| [    4.891855] [drm] ring test succeeded in 1 usecs
| [    4.891977] [drm] radeon: ib pool ready.
| [    4.892049] [drm] ib test succeeded in 0 usecs
| [    4.892086] [drm] Enabling audio support
| [    4.892126] failed to evaluate ATIF got AE_BAD_PARAMETER
| [    4.892342] [drm] Radeon Display Connectors
| [    4.892379] [drm] Connector 0:
| [    4.892415] [drm]   VGA
| [    4.892451] [drm]   DDC: 0x7e50 0x7e40 0x7e54 0x7e44 0x7e58 0x7e48 0x7e5c 0x7e4c
| [    4.892493] [drm]   Encoders:
| [    4.892528] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
| [    4.892565] [drm] Connector 1:
| [    4.892600] [drm]   DVI-D
| [    4.892636] [drm]   HPD2
| [    4.892672] [drm]   DDC: 0x7e40 0x7e60 0x7e44 0x7e64 0x7e48 0x7e68 0x7e4c 0x7e6c
| [    4.892713] [drm]   Encoders:
| [    4.892749] [drm]     DFP2: INTERNAL_DDI
| [    4.892785] [drm] Connector 2:
| [    4.892820] [drm]   DVI-D
| [    4.892856] [drm]   DDC: 0x7e40 0x7e50 0x7e44 0x7e54 0x7e48 0x7e58 0x7e4c 0x7e5c
| [    4.892897] [drm]   Encoders:
| [    4.892933] [drm]     DFP3: INTERNAL_LVTM1
| [    5.297287] [drm] fb mappable at 0xF0040000
| [    5.297349] [drm] vram apper at 0xF0000000
| [    5.297411] [drm] size 8294400
| [    5.297472] [drm] fb depth is 24
| [    5.297533] [drm]    pitch is 7680
| [    5.298384] fbcon: radeondrmfb (fb0) is primary device
| [    5.633639] Console: switching to colour frame buffer device 240x67
| [    5.944521] fb0: radeondrmfb frame buffer device
| [    5.944622] drm: registered panic notifier
| [    5.944746] [drm] Initialized radeon 2.8.0 20080528 for 0000:01:05.0 on minor 0
| [    6.125400] kvm: Nested Virtualization enabled
| [    6.125541] kvm: Nested Paging enabled
| [    6.668075] Adding 7426044k swap on /dev/sda5.  Priority:-1 extents:1 across:7426044k 
| [    6.671288] EXT4-fs (sda1): re-mounted. Opts: (null)
| [    6.799172] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
| [    6.934291] loop: module loaded
| [    7.815455] irq 18: nobody cared (try booting with the "irqpoll" option)
| [    7.815568] Pid: 907, comm: rpcbind Not tainted 2.6.38-rc5+ #14
| [    7.815663] Call Trace:
| [    7.815704]  <IRQ>  [<ffffffff81266aeb>] ? __report_bad_irq+0x35/0x9a
| [    7.815819]  [<ffffffff8106aaad>] ? note_interrupt+0x103/0x172
| [    7.815915]  [<ffffffff8106b481>] ? handle_fasteoi_irq+0xa3/0xcf
| [    7.816014]  [<ffffffff81004606>] ? handle_irq+0x1a/0x1e
| [    7.816102]  [<ffffffff81004355>] ? do_IRQ+0x42/0x98
| [    7.816185]  [<ffffffff8126c5d3>] ? ret_from_intr+0x0/0xe
| [    7.816672]  <EOI>  [<ffffffff810a46b5>] ? virt_to_head_page+0x7/0x2b
| [    7.816672]  [<ffffffff81001e17>] ? system_call_after_swapgs+0x17/0x65
| [    7.816672]  [<ffffffff81001e7b>] ? system_call_fastpath+0x16/0x1b
| [    7.816672] handlers:
| [    7.816672] [<ffffffffa002e880>] (usb_hcd_irq+0x0/0x56 [usbcore])
| [    7.816672] [<ffffffffa002e880>] (usb_hcd_irq+0x0/0x56 [usbcore])
| [    7.816672] [<ffffffffa002e880>] (usb_hcd_irq+0x0/0x56 [usbcore])
| [    7.816672] Disabling IRQ #18
`----

I have copious amounts of data that I can send (including a description of
my hardware), but to avoid information overload, I will just keep send here
the git bisect log:

,----[ git bisect log ]
| git bisect start
| # bad: [61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf] Linux 2.6.39
| git bisect bad 61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf
| # good: [521cb40b0c44418a4fd36dc633f575813d59a43d] Linux 2.6.38
| git bisect good 521cb40b0c44418a4fd36dc633f575813d59a43d
| # bad: [0df0914d414a504b975f3cc66ace0c16ef55b7f3] Merge branch 'omap-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6
| git bisect bad 0df0914d414a504b975f3cc66ace0c16ef55b7f3
| # bad: [6445ced8670f37cfc2c5e24a9de9b413dbfc788d] Merge branch 'staging-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6
| git bisect bad 6445ced8670f37cfc2c5e24a9de9b413dbfc788d
| # bad: [2e270d84223262a38d4755c61d55f5c73ea89e56] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6
| git bisect bad 2e270d84223262a38d4755c61d55f5c73ea89e56
| # good: [3904afb41d4316f7a2968c615d689e19149a4f84] Merge branch 'x86-debug-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
| git bisect good 3904afb41d4316f7a2968c615d689e19149a4f84
| # bad: [bd2895eeade5f11f3e5906283c630bbdb4b57454] Merge branch 'for-2.6.39' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq
| git bisect bad bd2895eeade5f11f3e5906283c630bbdb4b57454
| # bad: [d5d42399bd7b66bd6b55363b311810504110c967] Merge branch 'x86-mem-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
| git bisect bad d5d42399bd7b66bd6b55363b311810504110c967
| # bad: [d4d5e08960844a062da8387ee5f16ca7a33200d0] genirq: Add IRQCHIP_SET_TYPE_MASKED flag
| git bisect bad d4d5e08960844a062da8387ee5f16ca7a33200d0
| # bad: [a7ae4de5c8ae8110556f0f9c7241093ef984605c] genirq: Use handle_irq_event() in handle_fasteoi_irq()
| git bisect bad a7ae4de5c8ae8110556f0f9c7241093ef984605c
| # good: [2b879eaf095878430c38cbd95e5c0fc4ce65ad8e] genirq: Remove redundant thread affinity setting
| git bisect good 2b879eaf095878430c38cbd95e5c0fc4ce65ad8e
| # bad: [3b56f0585fd4c02d047dc406668cb40159b2d340] genirq: Remove bogus conditional
| git bisect bad 3b56f0585fd4c02d047dc406668cb40159b2d340
| # bad: [c7259cd7af757ddcd65701c37099dcddae2054f0] genirq: Do not poll disabled, percpu and timer interrupts
| git bisect bad c7259cd7af757ddcd65701c37099dcddae2054f0
| # good: [b738a50a202639614c98b5763b01bf9201779e50] genirq: Warn when handler enables interrupts
| git bisect good b738a50a202639614c98b5763b01bf9201779e50
| # bad: [fa27271bc8d230355c1f24ddea103824fdc12de6] genirq: Fixup poll handling
| git bisect bad fa27271bc8d230355c1f24ddea103824fdc12de6
`----

I see that the commit in question is one in a long chain of the genirq
facelift. Could I help with getting this fixed for this desktop of mine?
Apparently, the rewrite/shorter version didn't preserve all the same
behaviour...

I hope that I did my homework right bisecting, recompiling, etc. the
kernel. If not, please advise.

I am willing to test with whatever you want me to.


Thanks, Rogério Brito.

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
