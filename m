Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067Ab1FBHeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 03:34:14 -0400
Received: from smtp30.kymp.net ([80.248.96.181]:53347 "EHLO smtp.kymp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758964Ab1FBHeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 03:34:09 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jun 2011 03:34:06 EDT
X-IronPort-AV: E=Sophos;i="4.65,308,1304283600"; 
   d="txt'?scan'208";a="67372608"
Date: Thu, 2 Jun 2011 10:24:11 +0300
From: Mika Bostrom <bostik+lkml@bostik.iki.fi>
To: linux-kernel@vger.kernel.org, jack@suse.cz
Cc: Mika Bostrom <bostik@bostik.iki.fi>
Subject: Reproducible OOPS with UDF on flash
Message-ID: <20110602072411.GA26739@bostik.iki.fi>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

  Hello hackers. I found a reliable way to oops the kernel - both
2.6.38.6 and 2.6.39 are affected.

  The setup is this:
- debian unstable
- configured udisks + usbmount to automount thumb drives
- attached a thumbdrive with UDF filesystem on it
- checked that drive was mounted
- removed drive
=3D=3D> OOPS

  The oops only happens with UDF. A vfat filesystem doesn't cause any
problems.

  Okay, I know that UDF on flash is somewhat of a rare thing but I
happen to like it. System is rather old core2duo running 32-bit system:
% cat /proc/version=20
Linux version 2.6.38.6 (bostik@odin) (gcc version 4.6.1 20110507
(prerelease) (Debian 4.6.0-7) ) #2 SMP PREEMPT Sun May 15 08:07:07 EEST
2011

  Dmesg attached.


  This is what my .config says about USB:
% zgrep USB /proc/config.gz | grep -v ^#
CONFIG_BT_HCIBTUSB=3Dm
CONFIG_BT_HCIBFUSB=3Dm
CONFIG_USB_USBNET=3Dm
CONFIG_USB_NET_AX8817X=3Dm
CONFIG_USB_NET_CDCETHER=3Dm
CONFIG_USB_NET_CDC_NCM=3Dm
CONFIG_USB_NET_NET1080=3Dm
CONFIG_USB_NET_ZAURUS=3Dm
CONFIG_SND_USB=3Dy
CONFIG_USB_HID=3Dm
CONFIG_USB_HIDDEV=3Dy
CONFIG_USB_SUPPORT=3Dy
CONFIG_USB_ARCH_HAS_HCD=3Dy
CONFIG_USB_ARCH_HAS_OHCI=3Dy
CONFIG_USB_ARCH_HAS_EHCI=3Dy
CONFIG_USB=3Dm
CONFIG_USB_DEVICEFS=3Dy
CONFIG_USB_DEVICE_CLASS=3Dy
CONFIG_USB_MON=3Dm
CONFIG_USB_EHCI_HCD=3Dm
CONFIG_USB_EHCI_ROOT_HUB_TT=3Dy
CONFIG_USB_UHCI_HCD=3Dm
CONFIG_USB_ACM=3Dm
CONFIG_USB_STORAGE=3Dm

  And this is what it says about UDF:
% zgrep UDF /proc/config.gz            =20
CONFIG_UDF_FS=3Dm
CONFIG_UDF_NLS=3Dy

  When mounted, the UDF filesystem produces this:
/dev/sdf1 on /media/usb0 type udf (rw,noexec,nodev,noatime,nodiratime)

  And when it is removed, I get a series of four consecutive oops
messages. The oopses are attached.
- oops.txt is the original one
- oops2.txt is the first reproduction on 2.6.38.6
- oops3.txt is the reproduction on 2.6.39

  I have included the immediately preceding log lines from usbmount for
context. Is there any other information I could provide?

  Output of lspci -vvv, filtered to USB controllers only:

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI C=
ontroller #4 (rev 02) (prog-if 00 [UHCI])
  Subsystem: Intel Corporation Device 514d
  Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
  Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0
  Interrupt: pin A routed to IRQ 16
  Region 4: I/O ports at 20c0 [size=3D32]
  Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI C=
ontroller #5 (rev 02) (prog-if 00 [UHCI])
  Subsystem: Intel Corporation Device 514d
  Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
  Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0
  Interrupt: pin B routed to IRQ 21
  Region 4: I/O ports at 20a0 [size=3D32]
  Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI =
Controller #2 (rev 02) (prog-if 20 [EHCI])
  Subsystem: Intel Corporation Device 514d
  Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
  Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0
  Interrupt: pin C routed to IRQ 18
  Region 0: Memory at e0325c00 (32-bit, non-prefetchable) [size=3D1K]
  Capabilities: [50] Power Management version 2
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA PME(D0+,D1-,D2-,D3hot+=
,D3cold+)
    Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
  Capabilities: [58] Debug port: BAR=3D1 offset=3D00a0
  Kernel driver in use: ehci_hcd

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI C=
ontroller #1 (rev 02) (prog-if 00 [UHCI])
  Subsystem: Intel Corporation Device 514d
  Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
  Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0
  Interrupt: pin A routed to IRQ 23
  Region 4: I/O ports at 2080 [size=3D32]
  Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI C=
ontroller #2 (rev 02) (prog-if 00 [UHCI])
  Subsystem: Intel Corporation Device 514d
  Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
  Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0
  Interrupt: pin B routed to IRQ 19
  Region 4: I/O ports at 2060 [size=3D32]
  Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI C=
ontroller #3 (rev 02) (prog-if 00 [UHCI])
  Subsystem: Intel Corporation Device 514d
  Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
  Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0
  Interrupt: pin C routed to IRQ 18
  Region 4: I/O ports at 2040 [size=3D32]
  Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI =
Controller #1 (rev 02) (prog-if 20 [EHCI])
  Subsystem: Intel Corporation Device 514d
  Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
  Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0
  Interrupt: pin A routed to IRQ 23
  Region 0: Memory at e0325800 (32-bit, non-prefetchable) [size=3D1K]
  Capabilities: [50] Power Management version 2
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA PME(D0+,D1-,D2-,D3hot+=
,D3cold+)
    Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
  Capabilities: [58] Debug port: BAR=3D1 offset=3D00a0
  Kernel driver in use: ehci_hcd



--=20
 Mika Bostr=F6m                       Individualisti, eksistentialisti,
 www.iki.fi/bostik                  rationalisti ja mulkvisti
 GPG: 0x2AED22CC; 6FC9 8375 31B7 3BA2 B5DC  484E F19F 8AD6 2AED 22CC

--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="oops.txt"

Jun  1 20:45:18 odin usbmount[12856]: executing command: mount -tudf -onoexec,nodev,noatime,nodiratime /dev/sdf1 /media/usb0
Jun  1 20:45:18 odin kernel: UDF-fs: No anchor found
Jun  1 20:45:18 odin kernel: UDF-fs: Rescanning with blocksize 2048
Jun  1 20:45:18 odin kernel: UDF-fs INFO UDF: Mounting volume 'LinuxUDF', timestamp 2009/04/30 07:14 (1000)
Jun  1 20:45:18 odin usbmount[12856]: executing command: run-parts /etc/usbmount/mount.d
Jun  1 20:45:56 odin kernel: usb 2-1.1: USB disconnect, address 12
Jun  1 20:45:56 odin usbmount[12931]: executing command: umount -l /media/usb0
Jun  1 20:45:56 odin kernel: *pdpt = 00000000062d3001 *pde = 0000000000000000 
Jun  1 20:45:56 odin kernel: Modules linked in: udf crc_itu_t vfat fat vboxnetadp vboxnetflt fuse ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables bridge ipv6 stp llc vboxdrv coretemp hwmon krng eseqiv rng aes_i586 aes_generic xts gf128mul cryptomgr aead dm_crypt crypto_hash crypto_blkcipher crypto_algapi dm_mod usb_storage raid1 md_mod hid_microsoft i915 fbcon font usbhid bitblit snd_hda_codec_idt snd_hda_intel snd_hda_codec softcursor snd_pcm_oss drm_kms_helper snd_mixer_oss drm fb fbdev snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi sr_mod cdrom i2c_algo_bit cfbcopyarea snd_seq_midi_event ata_generic video snd_seq intel_agp pata_marvell uhci_hcd ide_pci_generic snd_timer snd_seq_device e1000e backlight intel_gtt agpgart cfbimgblt cfbfillrect ehci_hcd snd evdev psmouse serio_raw i2c_i801 usbcore soundcore snd_page_alloc i2c_core processor button
Jun  1 20:45:56 odin kernel: 
Jun  1 20:45:56 odin kernel: Pid: 12936, comm: umount Not tainted 2.6.38.6 #2                  /DG965OT
Jun  1 20:45:56 odin kernel: EIP: 0060:[<c11daaaf>] EFLAGS: 00010002 CPU: 1
Jun  1 20:45:56 odin kernel: EIP is at __percpu_counter_add+0x1f/0xe0
Jun  1 20:45:56 odin kernel: EAX: 00000000 EBX: f526f390 ECX: 00000000 EDX: 00000001
Jun  1 20:45:56 odin kernel: ESI: f57785c0 EDI: e6e70758 EBP: ec94be9c ESP: ec94be84
Jun  1 20:45:56 odin kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Jun  1 20:45:56 odin kernel:  ec94be94 e6e70748 f57785c0 f41166c0 f57785c0 e6e70758 ec94beb0 c1083323
Jun  1 20:45:56 odin kernel:  00000010 f57785c0 e6e70748 ec94bec8 c10cd6d7 00000000 f2269000 c7dae858
Jun  1 20:45:56 odin kernel:  c7dae800 ec94bed4 c10cd7a5 eb9cfc80 ec94bef4 fb3f8a81 c7dae810 eb9cfce4
Jun  1 20:45:56 odin kernel:  [<c1083323>] account_page_dirtied+0x63/0x90
Jun  1 20:45:56 odin kernel:  [<c10cd6d7>] __set_page_dirty+0x37/0xb0
Jun  1 20:45:56 odin kernel:  [<c10cd7a5>] mark_buffer_dirty+0x55/0x80
Jun  1 20:45:56 odin kernel:  [<fb3f8a81>] udf_close_lvid+0xb1/0xe0 [udf]
Jun  1 20:45:56 odin kernel:  [<fb3f8ee5>] udf_put_super+0xa5/0xc0 [udf]
Jun  1 20:45:56 odin kernel:  [<c10aad39>] generic_shutdown_super+0x59/0xd0
Jun  1 20:45:56 odin kernel:  [<c10aadd4>] kill_block_super+0x24/0x70
Jun  1 20:45:56 odin kernel:  [<c10ab0a5>] deactivate_locked_super+0x35/0x60
Jun  1 20:45:56 odin kernel:  [<c10abcc2>] deactivate_super+0x42/0x60
Jun  1 20:45:56 odin kernel:  [<c10c2302>] mntput_no_expire+0x82/0xd0
Jun  1 20:45:56 odin kernel:  [<c10c2d30>] sys_umount+0x60/0x330
Jun  1 20:45:56 odin kernel:  [<c1002bd0>] sysenter_do_call+0x12/0x26
Jun  1 20:45:56 odin kernel: Modules linked in: udf crc_itu_t vfat fat vboxnetadp vboxnetflt fuse ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables bridge ipv6 stp llc vboxdrv coretemp hwmon krng eseqiv rng aes_i586 aes_generic xts gf128mul cryptomgr aead dm_crypt crypto_hash crypto_blkcipher crypto_algapi dm_mod usb_storage raid1 md_mod hid_microsoft i915 fbcon font usbhid bitblit snd_hda_codec_idt snd_hda_intel snd_hda_codec softcursor snd_pcm_oss drm_kms_helper snd_mixer_oss drm fb fbdev snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi sr_mod cdrom i2c_algo_bit cfbcopyarea snd_seq_midi_event ata_generic video snd_seq intel_agp pata_marvell uhci_hcd ide_pci_generic snd_timer snd_seq_device e1000e backlight intel_gtt agpgart cfbimgblt cfbfillrect ehci_hcd snd evdev psmouse serio_raw i2c_i801 usbcore soundcore snd_page_alloc i2c_core processor button
Jun  1 20:45:56 odin kernel: Pid: 12936, comm: umount Not tainted 2.6.38.6 #2
Jun  1 20:45:56 odin kernel: Call Trace:
Jun  1 20:45:56 odin kernel:  [<c131ef0f>] ? __schedule_bug+0x55/0x5b
Jun  1 20:45:56 odin kernel:  [<c1322eaf>] ? schedule+0x41f/0x8b0
Jun  1 20:45:56 odin kernel:  [<c1320218>] ? __slab_free+0xa6/0x122
Jun  1 20:45:56 odin kernel:  [<f87b7589>] ? i915_gem_retire_requests_ring+0xe9/0x1e0 [i915]
Jun  1 20:45:56 odin kernel:  [<f87b7477>] ? i915_gem_object_move_to_inactive+0x97/0xc0 [i915]
Jun  1 20:45:56 odin kernel:  [<f87b7630>] ? i915_gem_retire_requests_ring+0x190/0x1e0 [i915]
Jun  1 20:45:56 odin kernel:  [<c103eff6>] ? lock_timer_base.isra.28+0x26/0x50
Jun  1 20:45:56 odin kernel:  [<c13236f0>] ? schedule_timeout+0x100/0x1b0
Jun  1 20:45:56 odin kernel:  [<c103ecf0>] ? process_timeout+0x0/0x10
Jun  1 20:45:56 odin kernel:  [<c13237b5>] ? schedule_timeout_uninterruptible+0x15/0x20
Jun  1 20:45:56 odin kernel:  [<c103f4f5>] ? msleep+0x15/0x20
Jun  1 20:45:56 odin kernel:  [<f87c2ae3>] ? intel_wait_for_vblank+0x73/0xc0 [i915]
Jun  1 20:45:56 odin kernel:  [<f87c391b>] ? intel_pipe_set_base+0xbb/0x210 [i915]
Jun  1 20:45:56 odin kernel:  [<f8587f70>] ? drm_get_connector_name+0x40/0x50 [drm]
Jun  1 20:45:56 odin kernel:  [<f85c9ca5>] ? drm_crtc_helper_set_config+0x705/0x980 [drm_kms_helper]
Jun  1 20:45:56 odin kernel:  [<f85c6640>] ? drm_fb_helper_pan_display+0x70/0xb0 [drm_kms_helper]
Jun  1 20:45:56 odin kernel:  [<f85c65d0>] ? drm_fb_helper_pan_display+0x0/0xb0 [drm_kms_helper]
Jun  1 20:45:56 odin kernel:  [<f8536399>] ? fb_pan_display+0xb9/0x170 [fb]
Jun  1 20:45:56 odin kernel:  [<f867b2ec>] ? bit_update_start+0x1c/0x40 [bitblit]
Jun  1 20:45:56 odin kernel:  [<f8740e5c>] ? fbcon_switch+0x39c/0x520 [fbcon]
Jun  1 20:45:56 odin kernel:  [<c1228e1b>] ? redraw_screen+0x12b/0x210
Jun  1 20:45:56 odin kernel:  [<f8740325>] ? fbcon_blank+0x235/0x300 [fbcon]
Jun  1 20:45:56 odin kernel:  [<c1324d4e>] ? _raw_spin_unlock+0x1e/0x30
Jun  1 20:45:56 odin kernel:  [<c12288e0>] ? vt_console_print+0x0/0x340
Jun  1 20:45:56 odin kernel:  [<c1034164>] ? __call_console_drivers+0x64/0x80
Jun  1 20:45:56 odin kernel:  [<c1324d80>] ? _raw_spin_unlock_irqrestore+0x20/0x30
Jun  1 20:45:56 odin kernel:  [<c1051345>] ? up+0x25/0x40
Jun  1 20:45:56 odin kernel:  [<c1324d80>] ? _raw_spin_unlock_irqrestore+0x20/0x30
Jun  1 20:45:56 odin kernel:  [<c10344e9>] ? console_unlock+0x199/0x1e0
Jun  1 20:45:56 odin kernel:  [<c103eff6>] ? lock_timer_base.isra.28+0x26/0x50
Jun  1 20:45:56 odin kernel:  [<c1324d80>] ? _raw_spin_unlock_irqrestore+0x20/0x30
Jun  1 20:45:56 odin kernel:  [<c103f21f>] ? mod_timer+0xef/0x1c0
Jun  1 20:45:56 odin kernel:  [<c12299cb>] ? do_unblank_screen+0x9b/0x190
Jun  1 20:45:56 odin kernel:  [<c1229aca>] ? unblank_screen+0xa/0x10
Jun  1 20:45:56 odin kernel:  [<c11d68e5>] ? bust_spinlocks+0x15/0x40
Jun  1 20:45:56 odin kernel:  [<c10062f3>] ? oops_end+0x13/0x90
Jun  1 20:45:56 odin kernel:  [<c131f136>] ? printk+0x18/0x1a
Jun  1 20:45:56 odin kernel:  [<c131eb9c>] ? no_context+0x173/0x17b
Jun  1 20:45:56 odin kernel:  [<c131ecb8>] ? __bad_area_nosemaphore+0x114/0x11c
Jun  1 20:45:56 odin kernel:  [<c107bd5d>] ? find_get_pages_tag+0xed/0x110
Jun  1 20:45:56 odin kernel:  [<c131ecd2>] ? bad_area_nosemaphore+0x12/0x14
Jun  1 20:45:56 odin kernel:  [<c1020d3a>] ? do_page_fault+0x24a/0x400
Jun  1 20:45:56 odin kernel:  [<c1082f4a>] ? write_cache_pages+0xaa/0x310
Jun  1 20:45:56 odin kernel:  [<c107bd5d>] ? find_get_pages_tag+0xed/0x110
Jun  1 20:45:56 odin kernel:  [<c1020af0>] ? do_page_fault+0x0/0x400
Jun  1 20:45:56 odin kernel:  [<c13257de>] ? error_code+0x5a/0x60
Jun  1 20:45:56 odin kernel:  [<c1020af0>] ? do_page_fault+0x0/0x400
Jun  1 20:45:56 odin kernel:  [<c11daaaf>] ? __percpu_counter_add+0x1f/0xe0
Jun  1 20:45:56 odin kernel:  [<c1083323>] ? account_page_dirtied+0x63/0x90
Jun  1 20:45:56 odin kernel:  [<c10cd6d7>] ? __set_page_dirty+0x37/0xb0
Jun  1 20:45:56 odin kernel:  [<c10cd7a5>] ? mark_buffer_dirty+0x55/0x80
Jun  1 20:45:56 odin kernel:  [<fb3f8a81>] ? udf_close_lvid+0xb1/0xe0 [udf]
Jun  1 20:45:56 odin kernel:  [<fb3f8ee5>] ? udf_put_super+0xa5/0xc0 [udf]
Jun  1 20:45:56 odin kernel:  [<c10aad39>] ? generic_shutdown_super+0x59/0xd0
Jun  1 20:45:56 odin kernel:  [<c10aadd4>] ? kill_block_super+0x24/0x70
Jun  1 20:45:56 odin kernel:  [<c10ab0a5>] ? deactivate_locked_super+0x35/0x60
Jun  1 20:45:56 odin kernel:  [<c10abcc2>] ? deactivate_super+0x42/0x60
Jun  1 20:45:56 odin kernel:  [<c10c2302>] ? mntput_no_expire+0x82/0xd0
Jun  1 20:45:56 odin kernel:  [<c10c2d30>] ? sys_umount+0x60/0x330
Jun  1 20:45:56 odin kernel:  [<c1002bd0>] ? sysenter_do_call+0x12/0x26
Jun  1 20:45:56 odin kernel: ---[ end trace f41401e27ff95692 ]---
Jun  1 20:45:56 odin kernel: ------------[ cut here ]------------
Jun  1 20:45:56 odin kernel: WARNING: at kernel/exit.c:910 do_exit+0x60d/0x6c0()
Jun  1 20:45:56 odin kernel: Hardware name:         
Jun  1 20:45:56 odin kernel: Modules linked in: udf crc_itu_t vfat fat vboxnetadp vboxnetflt fuse ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables bridge ipv6 stp llc vboxdrv coretemp hwmon krng eseqiv rng aes_i586 aes_generic xts gf128mul cryptomgr aead dm_crypt crypto_hash crypto_blkcipher crypto_algapi dm_mod usb_storage raid1 md_mod hid_microsoft i915 fbcon font usbhid bitblit snd_hda_codec_idt snd_hda_intel snd_hda_codec softcursor snd_pcm_oss drm_kms_helper snd_mixer_oss drm fb fbdev snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi sr_mod cdrom i2c_algo_bit cfbcopyarea snd_seq_midi_event ata_generic video snd_seq intel_agp pata_marvell uhci_hcd ide_pci_generic snd_timer snd_seq_device e1000e backlight intel_gtt agpgart cfbimgblt cfbfillrect ehci_hcd snd evdev psmouse serio_raw i2c_i801 usbcore soundcore snd_page_alloc i2c_core processor button
Jun  1 20:45:56 odin kernel: Pid: 12936, comm: umount Tainted: G      D     2.6.38.6 #2
Jun  1 20:45:56 odin kernel: Call Trace:
Jun  1 20:45:56 odin kernel:  [<c103401d>] ? warn_slowpath_common+0x6d/0xa0
Jun  1 20:45:56 odin kernel:  [<c10377bd>] ? do_exit+0x60d/0x6c0
Jun  1 20:45:56 odin kernel:  [<c10377bd>] ? do_exit+0x60d/0x6c0
Jun  1 20:45:56 odin kernel:  [<c103406d>] ? warn_slowpath_null+0x1d/0x20
Jun  1 20:45:56 odin kernel:  [<c10377bd>] ? do_exit+0x60d/0x6c0
Jun  1 20:45:56 odin kernel:  [<c1035688>] ? kmsg_dump+0xa8/0xd0
Jun  1 20:45:56 odin kernel:  [<c131f136>] ? printk+0x18/0x1a
Jun  1 20:45:56 odin kernel:  [<c100634a>] ? oops_end+0x6a/0x90
Jun  1 20:45:56 odin kernel:  [<c131f136>] ? printk+0x18/0x1a
Jun  1 20:45:56 odin kernel:  [<c131eb9c>] ? no_context+0x173/0x17b
Jun  1 20:45:56 odin kernel:  [<c131ecb8>] ? __bad_area_nosemaphore+0x114/0x11c
Jun  1 20:45:56 odin kernel:  [<c107bd5d>] ? find_get_pages_tag+0xed/0x110
Jun  1 20:45:56 odin kernel:  [<c131ecd2>] ? bad_area_nosemaphore+0x12/0x14
Jun  1 20:45:56 odin kernel:  [<c1020d3a>] ? do_page_fault+0x24a/0x400
Jun  1 20:45:56 odin kernel:  [<c1082f4a>] ? write_cache_pages+0xaa/0x310
Jun  1 20:45:56 odin kernel:  [<c107bd5d>] ? find_get_pages_tag+0xed/0x110
Jun  1 20:45:56 odin kernel:  [<c1020af0>] ? do_page_fault+0x0/0x400
Jun  1 20:45:56 odin kernel:  [<c13257de>] ? error_code+0x5a/0x60
Jun  1 20:45:56 odin kernel:  [<c1020af0>] ? do_page_fault+0x0/0x400
Jun  1 20:45:56 odin kernel:  [<c11daaaf>] ? __percpu_counter_add+0x1f/0xe0
Jun  1 20:45:56 odin kernel:  [<c1083323>] ? account_page_dirtied+0x63/0x90
Jun  1 20:45:56 odin kernel:  [<c10cd6d7>] ? __set_page_dirty+0x37/0xb0
Jun  1 20:45:56 odin kernel:  [<c10cd7a5>] ? mark_buffer_dirty+0x55/0x80
Jun  1 20:45:56 odin kernel:  [<fb3f8a81>] ? udf_close_lvid+0xb1/0xe0 [udf]
Jun  1 20:45:56 odin kernel:  [<fb3f8ee5>] ? udf_put_super+0xa5/0xc0 [udf]
Jun  1 20:45:56 odin kernel:  [<c10aad39>] ? generic_shutdown_super+0x59/0xd0
Jun  1 20:45:56 odin kernel:  [<c10aadd4>] ? kill_block_super+0x24/0x70
Jun  1 20:45:56 odin kernel:  [<c10ab0a5>] ? deactivate_locked_super+0x35/0x60
Jun  1 20:45:56 odin kernel:  [<c10abcc2>] ? deactivate_super+0x42/0x60
Jun  1 20:45:56 odin kernel:  [<c10c2302>] ? mntput_no_expire+0x82/0xd0
Jun  1 20:45:56 odin kernel:  [<c10c2d30>] ? sys_umount+0x60/0x330
Jun  1 20:45:56 odin kernel:  [<c1002bd0>] ? sysenter_do_call+0x12/0x26
Jun  1 20:45:56 odin kernel: ---[ end trace f41401e27ff95693 ]---
Jun  1 20:45:56 odin kernel: note: umount[12936] exited with preempt_count 2
Jun  1 20:45:56 odin kernel: Modules linked in: udf crc_itu_t vfat fat vboxnetadp vboxnetflt fuse ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables bridge ipv6 stp llc vboxdrv coretemp hwmon krng eseqiv rng aes_i586 aes_generic xts gf128mul cryptomgr aead dm_crypt crypto_hash crypto_blkcipher crypto_algapi dm_mod usb_storage raid1 md_mod hid_microsoft i915 fbcon font usbhid bitblit snd_hda_codec_idt snd_hda_intel snd_hda_codec softcursor snd_pcm_oss drm_kms_helper snd_mixer_oss drm fb fbdev snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi sr_mod cdrom i2c_algo_bit cfbcopyarea snd_seq_midi_event ata_generic video snd_seq intel_agp pata_marvell uhci_hcd ide_pci_generic snd_timer snd_seq_device e1000e backlight intel_gtt agpgart cfbimgblt cfbfillrect ehci_hcd snd evdev psmouse serio_raw i2c_i801 usbcore soundcore snd_page_alloc i2c_core processor button
Jun  1 20:45:56 odin kernel: Pid: 12936, comm: umount Tainted: G      D W   2.6.38.6 #2
Jun  1 20:45:56 odin kernel: Call Trace:
Jun  1 20:45:56 odin kernel:  [<c131ef0f>] ? __schedule_bug+0x55/0x5b
Jun  1 20:45:56 odin kernel:  [<c1322eaf>] ? schedule+0x41f/0x8b0
Jun  1 20:45:56 odin kernel:  [<c11d2185>] ? put_dec+0x85/0x90
Jun  1 20:45:56 odin kernel:  [<c1085197>] ? lru_add_drain+0x87/0x90
Jun  1 20:45:56 odin kernel:  [<c102e596>] ? __cond_resched+0x16/0x30
Jun  1 20:45:56 odin kernel:  [<c1323445>] ? _cond_resched+0x25/0x30
Jun  1 20:45:56 odin kernel:  [<c1093192>] ? unmap_vmas+0x5e2/0x750
Jun  1 20:45:56 odin kernel:  [<c12288e0>] ? vt_console_print+0x0/0x340
Jun  1 20:45:56 odin kernel:  [<c1098f38>] ? exit_mmap+0xb8/0x160
Jun  1 20:45:56 odin kernel:  [<c1031c66>] ? mmput+0x26/0xb0
Jun  1 20:45:56 odin kernel:  [<c1035b8a>] ? exit_mm+0xea/0x120
Jun  1 20:45:56 odin kernel:  [<c10376d3>] ? do_exit+0x523/0x6c0
Jun  1 20:45:56 odin kernel:  [<c131f136>] ? printk+0x18/0x1a
Jun  1 20:45:56 odin kernel:  [<c100634a>] ? oops_end+0x6a/0x90
Jun  1 20:45:56 odin kernel:  [<c131f136>] ? printk+0x18/0x1a
Jun  1 20:45:56 odin kernel:  [<c131eb9c>] ? no_context+0x173/0x17b
Jun  1 20:45:56 odin kernel:  [<c131ecb8>] ? __bad_area_nosemaphore+0x114/0x11c
Jun  1 20:45:56 odin kernel:  [<c107bd5d>] ? find_get_pages_tag+0xed/0x110
Jun  1 20:45:56 odin kernel:  [<c131ecd2>] ? bad_area_nosemaphore+0x12/0x14
Jun  1 20:45:56 odin kernel:  [<c1020d3a>] ? do_page_fault+0x24a/0x400
Jun  1 20:45:56 odin kernel:  [<c1082f4a>] ? write_cache_pages+0xaa/0x310
Jun  1 20:45:56 odin kernel:  [<c107bd5d>] ? find_get_pages_tag+0xed/0x110
Jun  1 20:45:56 odin kernel:  [<c1020af0>] ? do_page_fault+0x0/0x400
Jun  1 20:45:56 odin kernel:  [<c13257de>] ? error_code+0x5a/0x60
Jun  1 20:45:56 odin kernel:  [<c1020af0>] ? do_page_fault+0x0/0x400
Jun  1 20:45:56 odin kernel:  [<c11daaaf>] ? __percpu_counter_add+0x1f/0xe0
Jun  1 20:45:56 odin kernel:  [<c1083323>] ? account_page_dirtied+0x63/0x90
Jun  1 20:45:56 odin kernel:  [<c10cd6d7>] ? __set_page_dirty+0x37/0xb0
Jun  1 20:45:56 odin kernel:  [<c10cd7a5>] ? mark_buffer_dirty+0x55/0x80
Jun  1 20:45:56 odin kernel:  [<fb3f8a81>] ? udf_close_lvid+0xb1/0xe0 [udf]
Jun  1 20:45:56 odin kernel:  [<fb3f8ee5>] ? udf_put_super+0xa5/0xc0 [udf]
Jun  1 20:45:56 odin kernel:  [<c10aad39>] ? generic_shutdown_super+0x59/0xd0
Jun  1 20:45:56 odin kernel:  [<c10aadd4>] ? kill_block_super+0x24/0x70
Jun  1 20:45:56 odin kernel:  [<c10ab0a5>] ? deactivate_locked_super+0x35/0x60
Jun  1 20:45:56 odin kernel:  [<c10abcc2>] ? deactivate_super+0x42/0x60
Jun  1 20:45:56 odin kernel:  [<c10c2302>] ? mntput_no_expire+0x82/0xd0
Jun  1 20:45:56 odin kernel:  [<c10c2d30>] ? sys_umount+0x60/0x330
Jun  1 20:45:56 odin kernel:  [<c1002bd0>] ? sysenter_do_call+0x12/0x26

--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="oops2.txt"

Jun  1 21:00:18 odin usbmount[2972]: executing command: mount -tudf -onoexec,nodev,noatime,nodiratime /dev/sdf1 /media/usb0
Jun  1 21:00:18 odin kernel: UDF-fs: No anchor found
Jun  1 21:00:18 odin kernel: UDF-fs: Rescanning with blocksize 2048
Jun  1 21:00:18 odin kernel: UDF-fs INFO UDF: Mounting volume 'LinuxUDF', timestamp 2009/04/30 07:14 (1000)
Jun  1 21:00:18 odin usbmount[2972]: executing command: run-parts /etc/usbmount/mount.d
Jun  1 21:00:51 odin kernel: usb 2-1.1: USB disconnect, address 7
Jun  1 21:00:51 odin usbmount[3034]: executing command: umount -l /media/usb0
Jun  1 21:00:51 odin kernel: *pdpt = 00000000312a1001 *pde = 0000000000000000 
Jun  1 21:00:51 odin kernel: Modules linked in: udf crc_itu_t vboxnetadp vboxnetflt fuse ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables bridge ipv6 stp llc vboxdrv coretemp hwmon krng eseqiv rng aes_i586 aes_generic xts gf128mul cryptomgr aead dm_crypt crypto_hash crypto_blkcipher crypto_algapi dm_mod usb_storage raid1 md_mod hid_microsoft fbcon font bitblit softcursor snd_hda_codec_idt i915 snd_hda_intel drm_kms_helper usbhid snd_hda_codec drm snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss fb fbdev i2c_algo_bit sr_mod cdrom snd_seq_midi snd_rawmidi snd_seq_midi_event ata_generic cfbcopyarea e1000e snd_seq psmouse pata_marvell evdev snd_timer snd_seq_device video backlight cfbimgblt cfbfillrect ide_pci_generic serio_raw uhci_hcd i2c_i801 snd ehci_hcd i2c_core intel_agp intel_gtt agpgart usbcore soundcore snd_page_alloc button processor
Jun  1 21:00:51 odin kernel: 
Jun  1 21:00:51 odin kernel: Pid: 3037, comm: umount Not tainted 2.6.38.6 #2                  /DG965OT
Jun  1 21:00:51 odin kernel: EIP: 0060:[<c11daaaf>] EFLAGS: 00010002 CPU: 1
Jun  1 21:00:51 odin kernel: EIP is at __percpu_counter_add+0x1f/0xe0
Jun  1 21:00:51 odin kernel: EAX: 00000000 EBX: f526a8b0 ECX: 00000000 EDX: 00000001
Jun  1 21:00:51 odin kernel: ESI: f5d27f80 EDI: f4c23b58 EBP: eee99e9c ESP: eee99e84
Jun  1 21:00:51 odin kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Jun  1 21:00:51 odin kernel:  eee99e94 f4c23b48 f5d27f80 f40a9360 f5d27f80 f4c23b58 eee99eb0 c1083323
Jun  1 21:00:51 odin kernel:  00000010 f5d27f80 f4c23b48 eee99ec8 c10cd6d7 00000000 f08cd770 f557c858
Jun  1 21:00:51 odin kernel:  f557c800 eee99ed4 c10cd7a5 f4677d00 eee99ef4 fa59da81 f557c810 f4677d64
Jun  1 21:00:51 odin kernel:  [<c1083323>] account_page_dirtied+0x63/0x90
Jun  1 21:00:51 odin kernel:  [<c10cd6d7>] __set_page_dirty+0x37/0xb0
Jun  1 21:00:51 odin kernel:  [<c10cd7a5>] mark_buffer_dirty+0x55/0x80
Jun  1 21:00:51 odin kernel:  [<fa59da81>] udf_close_lvid+0xb1/0xe0 [udf]
Jun  1 21:00:51 odin kernel:  [<fa59dee5>] udf_put_super+0xa5/0xc0 [udf]
Jun  1 21:00:51 odin kernel:  [<c10aad39>] generic_shutdown_super+0x59/0xd0
Jun  1 21:00:51 odin kernel:  [<c108f555>] ? pcpu_free_area+0x145/0x190
Jun  1 21:00:51 odin kernel:  [<c10aadd4>] kill_block_super+0x24/0x70
Jun  1 21:00:51 odin kernel:  [<c10ab0a5>] deactivate_locked_super+0x35/0x60
Jun  1 21:00:51 odin kernel:  [<c10abcc2>] deactivate_super+0x42/0x60
Jun  1 21:00:51 odin kernel:  [<c10c2302>] mntput_no_expire+0x82/0xd0
Jun  1 21:00:51 odin kernel:  [<c10c2d30>] sys_umount+0x60/0x330
Jun  1 21:00:51 odin kernel:  [<c1002bd0>] sysenter_do_call+0x12/0x26
Jun  1 21:00:51 odin kernel: Modules linked in: udf crc_itu_t vboxnetadp vboxnetflt fuse ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables bridge ipv6 stp llc vboxdrv coretemp hwmon krng eseqiv rng aes_i586 aes_generic xts gf128mul cryptomgr aead dm_crypt crypto_hash crypto_blkcipher crypto_algapi dm_mod usb_storage raid1 md_mod hid_microsoft fbcon font bitblit softcursor snd_hda_codec_idt i915 snd_hda_intel drm_kms_helper usbhid snd_hda_codec drm snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss fb fbdev i2c_algo_bit sr_mod cdrom snd_seq_midi snd_rawmidi snd_seq_midi_event ata_generic cfbcopyarea e1000e snd_seq psmouse pata_marvell evdev snd_timer snd_seq_device video backlight cfbimgblt cfbfillrect ide_pci_generic serio_raw uhci_hcd i2c_i801 snd ehci_hcd i2c_core intel_agp intel_gtt agpgart usbcore soundcore snd_page_alloc button processor
Jun  1 21:00:51 odin kernel: Pid: 3037, comm: umount Not tainted 2.6.38.6 #2
Jun  1 21:00:51 odin kernel: Call Trace:
Jun  1 21:00:51 odin kernel:  [<c131ef0f>] ? __schedule_bug+0x55/0x5b
Jun  1 21:00:51 odin kernel:  [<c1322eaf>] ? schedule+0x41f/0x8b0
Jun  1 21:00:51 odin kernel:  [<f8ea9589>] ? i915_gem_retire_requests_ring+0xe9/0x1e0 [i915]
Jun  1 21:00:51 odin kernel:  [<f8ea9477>] ? i915_gem_object_move_to_inactive+0x97/0xc0 [i915]
Jun  1 21:00:51 odin kernel:  [<f8ea9630>] ? i915_gem_retire_requests_ring+0x190/0x1e0 [i915]
Jun  1 21:00:51 odin kernel:  [<c103eff6>] ? lock_timer_base.isra.28+0x26/0x50
Jun  1 21:00:51 odin kernel:  [<c13236f0>] ? schedule_timeout+0x100/0x1b0
Jun  1 21:00:51 odin kernel:  [<c103ecf0>] ? process_timeout+0x0/0x10
Jun  1 21:00:51 odin kernel:  [<c13237b5>] ? schedule_timeout_uninterruptible+0x15/0x20
Jun  1 21:00:51 odin kernel:  [<c103f4f5>] ? msleep+0x15/0x20
Jun  1 21:00:51 odin kernel:  [<f8eb4ae3>] ? intel_wait_for_vblank+0x73/0xc0 [i915]
Jun  1 21:00:51 odin kernel:  [<f8eb591b>] ? intel_pipe_set_base+0xbb/0x210 [i915]
Jun  1 21:00:51 odin kernel:  [<f8d0ff70>] ? drm_get_connector_name+0x40/0x50 [drm]
Jun  1 21:00:51 odin kernel:  [<f8e11ca5>] ? drm_crtc_helper_set_config+0x705/0x980 [drm_kms_helper]
Jun  1 21:00:51 odin kernel:  [<f8e0e640>] ? drm_fb_helper_pan_display+0x70/0xb0 [drm_kms_helper]
Jun  1 21:00:51 odin kernel:  [<f8e0e5d0>] ? drm_fb_helper_pan_display+0x0/0xb0 [drm_kms_helper]
Jun  1 21:00:51 odin kernel:  [<f87ae399>] ? fb_pan_display+0xb9/0x170 [fb]
Jun  1 21:00:51 odin kernel:  [<f8f222ec>] ? bit_update_start+0x1c/0x40 [bitblit]
Jun  1 21:00:51 odin kernel:  [<f8fb7e5c>] ? fbcon_switch+0x39c/0x520 [fbcon]
Jun  1 21:00:51 odin kernel:  [<c1228e1b>] ? redraw_screen+0x12b/0x210
Jun  1 21:00:51 odin kernel:  [<f8fb7325>] ? fbcon_blank+0x235/0x300 [fbcon]
Jun  1 21:00:51 odin kernel:  [<c12288e0>] ? vt_console_print+0x0/0x340
Jun  1 21:00:51 odin kernel:  [<c1034164>] ? __call_console_drivers+0x64/0x80
Jun  1 21:00:51 odin kernel:  [<c1051345>] ? up+0x25/0x40
Jun  1 21:00:51 odin kernel:  [<c10344e9>] ? console_unlock+0x199/0x1e0
Jun  1 21:00:51 odin kernel:  [<c103eff6>] ? lock_timer_base.isra.28+0x26/0x50
Jun  1 21:00:51 odin kernel:  [<c103f21f>] ? mod_timer+0xef/0x1c0
Jun  1 21:00:51 odin kernel:  [<c12299cb>] ? do_unblank_screen+0x9b/0x190
Jun  1 21:00:51 odin kernel:  [<c1229aca>] ? unblank_screen+0xa/0x10
Jun  1 21:00:51 odin kernel:  [<c11d68e5>] ? bust_spinlocks+0x15/0x40
Jun  1 21:00:51 odin kernel:  [<c10062f3>] ? oops_end+0x13/0x90
Jun  1 21:00:51 odin kernel:  [<c131f136>] ? printk+0x18/0x1a
Jun  1 21:00:51 odin kernel:  [<c131eb9c>] ? no_context+0x173/0x17b
Jun  1 21:00:51 odin kernel:  [<c131ecb8>] ? __bad_area_nosemaphore+0x114/0x11c
Jun  1 21:00:51 odin kernel:  [<c107bd5d>] ? find_get_pages_tag+0xed/0x110
Jun  1 21:00:51 odin kernel:  [<c131ecd2>] ? bad_area_nosemaphore+0x12/0x14
Jun  1 21:00:51 odin kernel:  [<c1020d3a>] ? do_page_fault+0x24a/0x400
Jun  1 21:00:51 odin kernel:  [<c1082f4a>] ? write_cache_pages+0xaa/0x310
Jun  1 21:00:51 odin kernel:  [<c107bd5d>] ? find_get_pages_tag+0xed/0x110
Jun  1 21:00:51 odin kernel:  [<c1020af0>] ? do_page_fault+0x0/0x400
Jun  1 21:00:51 odin kernel:  [<c13257de>] ? error_code+0x5a/0x60
Jun  1 21:00:51 odin kernel:  [<c1020af0>] ? do_page_fault+0x0/0x400
Jun  1 21:00:51 odin kernel:  [<c11daaaf>] ? __percpu_counter_add+0x1f/0xe0
Jun  1 21:00:51 odin kernel:  [<c1083323>] ? account_page_dirtied+0x63/0x90
Jun  1 21:00:51 odin kernel:  [<c10cd6d7>] ? __set_page_dirty+0x37/0xb0
Jun  1 21:00:51 odin kernel:  [<c10cd7a5>] ? mark_buffer_dirty+0x55/0x80
Jun  1 21:00:51 odin kernel:  [<fa59da81>] ? udf_close_lvid+0xb1/0xe0 [udf]
Jun  1 21:00:51 odin kernel:  [<fa59dee5>] ? udf_put_super+0xa5/0xc0 [udf]
Jun  1 21:00:51 odin kernel:  [<c10aad39>] ? generic_shutdown_super+0x59/0xd0
Jun  1 21:00:51 odin kernel:  [<c108f555>] ? pcpu_free_area+0x145/0x190
Jun  1 21:00:51 odin kernel:  [<c10aadd4>] ? kill_block_super+0x24/0x70
Jun  1 21:00:51 odin kernel:  [<c10ab0a5>] ? deactivate_locked_super+0x35/0x60
Jun  1 21:00:51 odin kernel:  [<c10abcc2>] ? deactivate_super+0x42/0x60
Jun  1 21:00:51 odin kernel:  [<c10c2302>] ? mntput_no_expire+0x82/0xd0
Jun  1 21:00:51 odin kernel:  [<c10c2d30>] ? sys_umount+0x60/0x330
Jun  1 21:00:51 odin kernel:  [<c1002bd0>] ? sysenter_do_call+0x12/0x26
Jun  1 21:00:51 odin kernel: ---[ end trace 07c1ee91702bb2c1 ]---
Jun  1 21:00:51 odin kernel: ------------[ cut here ]------------
Jun  1 21:00:51 odin kernel: WARNING: at kernel/exit.c:910 do_exit+0x60d/0x6c0()
Jun  1 21:00:51 odin kernel: Hardware name:         
Jun  1 21:00:51 odin kernel: Modules linked in: udf crc_itu_t vboxnetadp vboxnetflt fuse ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables bridge ipv6 stp llc vboxdrv coretemp hwmon krng eseqiv rng aes_i586 aes_generic xts gf128mul cryptomgr aead dm_crypt crypto_hash crypto_blkcipher crypto_algapi dm_mod usb_storage raid1 md_mod hid_microsoft fbcon font bitblit softcursor snd_hda_codec_idt i915 snd_hda_intel drm_kms_helper usbhid snd_hda_codec drm snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss fb fbdev i2c_algo_bit sr_mod cdrom snd_seq_midi snd_rawmidi snd_seq_midi_event ata_generic cfbcopyarea e1000e snd_seq psmouse pata_marvell evdev snd_timer snd_seq_device video backlight cfbimgblt cfbfillrect ide_pci_generic serio_raw uhci_hcd i2c_i801 snd ehci_hcd i2c_core intel_agp intel_gtt agpgart usbcore soundcore snd_page_alloc button processor
Jun  1 21:00:51 odin kernel: Pid: 3037, comm: umount Tainted: G      D     2.6.38.6 #2
Jun  1 21:00:51 odin kernel: Call Trace:
Jun  1 21:00:51 odin kernel:  [<c103401d>] ? warn_slowpath_common+0x6d/0xa0
Jun  1 21:00:51 odin kernel:  [<c10377bd>] ? do_exit+0x60d/0x6c0
Jun  1 21:00:51 odin kernel:  [<c10377bd>] ? do_exit+0x60d/0x6c0
Jun  1 21:00:51 odin kernel:  [<c103406d>] ? warn_slowpath_null+0x1d/0x20
Jun  1 21:00:51 odin kernel:  [<c10377bd>] ? do_exit+0x60d/0x6c0
Jun  1 21:00:51 odin kernel:  [<c1035688>] ? kmsg_dump+0xa8/0xd0
Jun  1 21:00:51 odin kernel:  [<c131f136>] ? printk+0x18/0x1a
Jun  1 21:00:51 odin kernel:  [<c100634a>] ? oops_end+0x6a/0x90
Jun  1 21:00:51 odin kernel:  [<c131f136>] ? printk+0x18/0x1a
Jun  1 21:00:51 odin kernel:  [<c131eb9c>] ? no_context+0x173/0x17b
Jun  1 21:00:51 odin kernel:  [<c131ecb8>] ? __bad_area_nosemaphore+0x114/0x11c
Jun  1 21:00:51 odin kernel:  [<c107bd5d>] ? find_get_pages_tag+0xed/0x110
Jun  1 21:00:51 odin kernel:  [<c131ecd2>] ? bad_area_nosemaphore+0x12/0x14
Jun  1 21:00:51 odin kernel:  [<c1020d3a>] ? do_page_fault+0x24a/0x400
Jun  1 21:00:51 odin kernel:  [<c1082f4a>] ? write_cache_pages+0xaa/0x310
Jun  1 21:00:51 odin kernel:  [<c107bd5d>] ? find_get_pages_tag+0xed/0x110
Jun  1 21:00:51 odin kernel:  [<c1020af0>] ? do_page_fault+0x0/0x400
Jun  1 21:00:51 odin kernel:  [<c13257de>] ? error_code+0x5a/0x60
Jun  1 21:00:51 odin kernel:  [<c1020af0>] ? do_page_fault+0x0/0x400
Jun  1 21:00:51 odin kernel:  [<c11daaaf>] ? __percpu_counter_add+0x1f/0xe0
Jun  1 21:00:51 odin kernel:  [<c1083323>] ? account_page_dirtied+0x63/0x90
Jun  1 21:00:51 odin kernel:  [<c10cd6d7>] ? __set_page_dirty+0x37/0xb0
Jun  1 21:00:51 odin kernel:  [<c10cd7a5>] ? mark_buffer_dirty+0x55/0x80
Jun  1 21:00:51 odin kernel:  [<fa59da81>] ? udf_close_lvid+0xb1/0xe0 [udf]
Jun  1 21:00:51 odin kernel:  [<fa59dee5>] ? udf_put_super+0xa5/0xc0 [udf]
Jun  1 21:00:51 odin kernel:  [<c10aad39>] ? generic_shutdown_super+0x59/0xd0
Jun  1 21:00:51 odin kernel:  [<c108f555>] ? pcpu_free_area+0x145/0x190
Jun  1 21:00:51 odin kernel:  [<c10aadd4>] ? kill_block_super+0x24/0x70
Jun  1 21:00:51 odin kernel:  [<c10ab0a5>] ? deactivate_locked_super+0x35/0x60
Jun  1 21:00:51 odin kernel:  [<c10abcc2>] ? deactivate_super+0x42/0x60
Jun  1 21:00:51 odin kernel:  [<c10c2302>] ? mntput_no_expire+0x82/0xd0
Jun  1 21:00:51 odin kernel:  [<c10c2d30>] ? sys_umount+0x60/0x330
Jun  1 21:00:51 odin kernel:  [<c1002bd0>] ? sysenter_do_call+0x12/0x26
Jun  1 21:00:51 odin kernel: ---[ end trace 07c1ee91702bb2c2 ]---
Jun  1 21:00:51 odin kernel: note: umount[3037] exited with preempt_count 2
Jun  1 21:00:51 odin kernel: Modules linked in: udf crc_itu_t vboxnetadp vboxnetflt fuse ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables bridge ipv6 stp llc vboxdrv coretemp hwmon krng eseqiv rng aes_i586 aes_generic xts gf128mul cryptomgr aead dm_crypt crypto_hash crypto_blkcipher crypto_algapi dm_mod usb_storage raid1 md_mod hid_microsoft fbcon font bitblit softcursor snd_hda_codec_idt i915 snd_hda_intel drm_kms_helper usbhid snd_hda_codec drm snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss fb fbdev i2c_algo_bit sr_mod cdrom snd_seq_midi snd_rawmidi snd_seq_midi_event ata_generic cfbcopyarea e1000e snd_seq psmouse pata_marvell evdev snd_timer snd_seq_device video backlight cfbimgblt cfbfillrect ide_pci_generic serio_raw uhci_hcd i2c_i801 snd ehci_hcd i2c_core intel_agp intel_gtt agpgart usbcore soundcore snd_page_alloc button processor
Jun  1 21:00:51 odin kernel: Pid: 3037, comm: umount Tainted: G      D W   2.6.38.6 #2
Jun  1 21:00:51 odin kernel: Call Trace:
Jun  1 21:00:51 odin kernel:  [<c131ef0f>] ? __schedule_bug+0x55/0x5b
Jun  1 21:00:51 odin kernel:  [<c1322eaf>] ? schedule+0x41f/0x8b0
Jun  1 21:00:51 odin kernel:  [<c11d2185>] ? put_dec+0x85/0x90
Jun  1 21:00:51 odin kernel:  [<c1085197>] ? lru_add_drain+0x87/0x90
Jun  1 21:00:51 odin kernel:  [<c102e596>] ? __cond_resched+0x16/0x30
Jun  1 21:00:51 odin kernel:  [<c1323445>] ? _cond_resched+0x25/0x30
Jun  1 21:00:51 odin kernel:  [<c1093192>] ? unmap_vmas+0x5e2/0x750
Jun  1 21:00:51 odin kernel:  [<c12288e0>] ? vt_console_print+0x0/0x340
Jun  1 21:00:51 odin kernel:  [<c1098f38>] ? exit_mmap+0xb8/0x160
Jun  1 21:00:51 odin kernel:  [<c1031c66>] ? mmput+0x26/0xb0
Jun  1 21:00:51 odin kernel:  [<c1035b8a>] ? exit_mm+0xea/0x120
Jun  1 21:00:51 odin kernel:  [<c10376d3>] ? do_exit+0x523/0x6c0
Jun  1 21:00:51 odin kernel:  [<c131f136>] ? printk+0x18/0x1a
Jun  1 21:00:51 odin kernel:  [<c100634a>] ? oops_end+0x6a/0x90
Jun  1 21:00:51 odin kernel:  [<c131f136>] ? printk+0x18/0x1a
Jun  1 21:00:51 odin kernel:  [<c131eb9c>] ? no_context+0x173/0x17b
Jun  1 21:00:51 odin kernel:  [<c131ecb8>] ? __bad_area_nosemaphore+0x114/0x11c
Jun  1 21:00:51 odin kernel:  [<c107bd5d>] ? find_get_pages_tag+0xed/0x110
Jun  1 21:00:51 odin kernel:  [<c131ecd2>] ? bad_area_nosemaphore+0x12/0x14
Jun  1 21:00:51 odin kernel:  [<c1020d3a>] ? do_page_fault+0x24a/0x400
Jun  1 21:00:51 odin kernel:  [<c1082f4a>] ? write_cache_pages+0xaa/0x310
Jun  1 21:00:51 odin kernel:  [<c107bd5d>] ? find_get_pages_tag+0xed/0x110
Jun  1 21:00:51 odin kernel:  [<c1020af0>] ? do_page_fault+0x0/0x400
Jun  1 21:00:51 odin kernel:  [<c13257de>] ? error_code+0x5a/0x60
Jun  1 21:00:51 odin kernel:  [<c1020af0>] ? do_page_fault+0x0/0x400
Jun  1 21:00:51 odin kernel:  [<c11daaaf>] ? __percpu_counter_add+0x1f/0xe0
Jun  1 21:00:51 odin kernel:  [<c1083323>] ? account_page_dirtied+0x63/0x90
Jun  1 21:00:51 odin kernel:  [<c10cd6d7>] ? __set_page_dirty+0x37/0xb0
Jun  1 21:00:51 odin kernel:  [<c10cd7a5>] ? mark_buffer_dirty+0x55/0x80
Jun  1 21:00:51 odin kernel:  [<fa59da81>] ? udf_close_lvid+0xb1/0xe0 [udf]
Jun  1 21:00:51 odin kernel:  [<fa59dee5>] ? udf_put_super+0xa5/0xc0 [udf]
Jun  1 21:00:51 odin kernel:  [<c10aad39>] ? generic_shutdown_super+0x59/0xd0
Jun  1 21:00:51 odin kernel:  [<c108f555>] ? pcpu_free_area+0x145/0x190
Jun  1 21:00:51 odin kernel:  [<c10aadd4>] ? kill_block_super+0x24/0x70
Jun  1 21:00:51 odin kernel:  [<c10ab0a5>] ? deactivate_locked_super+0x35/0x60
Jun  1 21:00:51 odin kernel:  [<c10abcc2>] ? deactivate_super+0x42/0x60
Jun  1 21:00:51 odin kernel:  [<c10c2302>] ? mntput_no_expire+0x82/0xd0
Jun  1 21:00:51 odin kernel:  [<c10c2d30>] ? sys_umount+0x60/0x330
Jun  1 21:00:51 odin kernel:  [<c1002bd0>] ? sysenter_do_call+0x12/0x26

--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="oops3.txt"

Jun  1 21:23:42 odin usbmount[2846]: executing command: mount -tudf -onoexec,nodev,noatime,nodiratime /dev/sdf1 /media/usb0
Jun  1 21:23:42 odin kernel: UDF-fs: No anchor found
Jun  1 21:23:42 odin kernel: UDF-fs: Rescanning with blocksize 2048
Jun  1 21:23:42 odin kernel: UDF-fs INFO UDF: Mounting volume 'LinuxUDF', timestamp 2009/04/30 07:14 (1000)
Jun  1 21:23:42 odin usbmount[2846]: executing command: run-parts /etc/usbmount/mount.d
Jun  1 21:24:18 odin kernel: usb 2-1.1: USB disconnect, device number 7
Jun  1 21:24:18 odin usbmount[2911]: executing command: umount -l /media/usb0
Jun  1 21:24:18 odin kernel: *pdpt = 000000002d887001 *pde = 0000000000000000 
Jun  1 21:24:18 odin kernel: Modules linked in: udf crc_itu_t fuse ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables bridge ipv6 stp llc coretemp hwmon krng eseqiv rng aes_i586 aes_generic xts gf128mul cryptomgr aead usb_storage dm_crypt crypto_hash crypto_blkcipher crypto_algapi dm_mod hid_microsoft raid1 md_mod usbhid fbcon font bitblit softcursor i915 drm_kms_helper snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy sr_mod drm fb fbdev snd_seq_oss cdrom snd_seq_midi i2c_algo_bit cfbcopyarea video ata_generic snd_rawmidi snd_seq_midi_event i2c_i801 backlight pata_marvell ide_pci_generic evdev e1000e psmouse intel_agp serio_raw snd_seq cfbimgblt intel_gtt i2c_core snd_timer snd_seq_device uhci_hcd cfbfillrect agpgart ehci_hcd snd usbcore soundcore snd_page_alloc button processor
Jun  1 21:24:18 odin kernel: 
Jun  1 21:24:18 odin kernel: Pid: 2915, comm: umount Not tainted 2.6.39 #1                  /DG965OT
Jun  1 21:24:18 odin kernel: EIP: 0060:[<c11dce7f>] EFLAGS: 00010002 CPU: 1
Jun  1 21:24:18 odin kernel: EIP is at __percpu_counter_add+0x1f/0xe0
Jun  1 21:24:18 odin kernel: EAX: 00000000 EBX: f51ba844 ECX: 00000000 EDX: 00000001
Jun  1 21:24:18 odin kernel: ESI: f56a6f40 EDI: f4c4dd58 EBP: eecfde9c ESP: eecfde84
Jun  1 21:24:18 odin kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Jun  1 21:24:18 odin kernel:  eecfdea0 f4c4dd48 f56a6f40 ed19aaa0 f56a6f40 f4c4dd58 eecfdeb0 c1084df3
Jun  1 21:24:18 odin kernel:  00000010 f56a6f40 f4c4dd48 eecfdec8 c10cfdd7 00000000 f089d070 c14fa858
Jun  1 21:24:18 odin kernel:  c14fa800 eecfded4 c10cfea5 f443b380 eecfdef4 fa105d11 c14fa810 f443b3e4
Jun  1 21:24:18 odin kernel:  [<c1084df3>] account_page_dirtied+0x63/0x90
Jun  1 21:24:18 odin kernel:  [<c10cfdd7>] __set_page_dirty+0x37/0xb0
Jun  1 21:24:18 odin kernel:  [<c10cfea5>] mark_buffer_dirty+0x55/0x80
Jun  1 21:24:18 odin kernel:  [<fa105d11>] udf_close_lvid+0xb1/0xe0 [udf]
Jun  1 21:24:18 odin kernel:  [<fa106175>] udf_put_super+0xa5/0xc0 [udf]
Jun  1 21:24:18 odin kernel:  [<c10ace39>] generic_shutdown_super+0x59/0xd0
Jun  1 21:24:18 odin kernel:  [<c10aced4>] kill_block_super+0x24/0x70
Jun  1 21:24:18 odin kernel:  [<c10ad1a5>] deactivate_locked_super+0x35/0x60
Jun  1 21:24:18 odin kernel:  [<c10ada12>] deactivate_super+0x42/0x60
Jun  1 21:24:18 odin kernel:  [<c10c48c2>] mntput_no_expire+0x82/0xd0
Jun  1 21:24:18 odin kernel:  [<c10c5370>] sys_umount+0x60/0x330
Jun  1 21:24:18 odin kernel:  [<c1003af5>] ? math_state_restore+0x25/0x40
Jun  1 21:24:18 odin kernel:  [<c132c490>] sysenter_do_call+0x12/0x26
Jun  1 21:24:18 odin kernel: <64> 8b 30 89 f7 c1 ff 1f 01 d6 89 45 f0 8b 45 08 11 cf 89 c2 89 
Jun  1 21:24:18 odin kernel: ---[ end trace 76d71f835b036375 ]---
Jun  1 21:24:18 odin kernel: ------------[ cut here ]------------
Jun  1 21:24:18 odin kernel: WARNING: at kernel/exit.c:910 do_exit+0x670/0x6f0()
Jun  1 21:24:18 odin kernel: Hardware name:         
Jun  1 21:24:18 odin kernel: Modules linked in: udf crc_itu_t fuse ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables bridge ipv6 stp llc coretemp hwmon krng eseqiv rng aes_i586 aes_generic xts gf128mul cryptomgr aead usb_storage dm_crypt crypto_hash crypto_blkcipher crypto_algapi dm_mod hid_microsoft raid1 md_mod usbhid fbcon font bitblit softcursor i915 drm_kms_helper snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy sr_mod drm fb fbdev snd_seq_oss cdrom snd_seq_midi i2c_algo_bit cfbcopyarea video ata_generic snd_rawmidi snd_seq_midi_event i2c_i801 backlight pata_marvell ide_pci_generic evdev e1000e psmouse intel_agp serio_raw snd_seq cfbimgblt intel_gtt i2c_core snd_timer snd_seq_device uhci_hcd cfbfillrect agpgart ehci_hcd snd usbcore soundcore snd_page_alloc button processor
Jun  1 21:24:18 odin kernel: Pid: 2915, comm: umount Tainted: G      D     2.6.39 #1
Jun  1 21:24:18 odin kernel: Call Trace:
Jun  1 21:24:18 odin kernel:  [<c1325e10>] ? printk+0x18/0x1a
Jun  1 21:24:18 odin kernel:  [<c10343bd>] warn_slowpath_common+0x6d/0xa0
Jun  1 21:24:18 odin kernel:  [<c1037ce0>] ? do_exit+0x670/0x6f0
Jun  1 21:24:18 odin kernel:  [<c1037ce0>] ? do_exit+0x670/0x6f0
Jun  1 21:24:18 odin kernel:  [<c103440d>] warn_slowpath_null+0x1d/0x20
Jun  1 21:24:18 odin kernel:  [<c1037ce0>] do_exit+0x670/0x6f0
Jun  1 21:24:18 odin kernel:  [<c1035b48>] ? kmsg_dump+0xa8/0xd0
Jun  1 21:24:18 odin kernel:  [<c1325e10>] ? printk+0x18/0x1a
Jun  1 21:24:18 odin kernel:  [<c1005a9a>] oops_end+0x6a/0x90
Jun  1 21:24:18 odin kernel:  [<c1325e10>] ? printk+0x18/0x1a
Jun  1 21:24:18 odin kernel:  [<c1325876>] no_context+0x173/0x17b
Jun  1 21:24:18 odin kernel:  [<c107d665>] ? find_get_pages_tag+0xf5/0x120
Jun  1 21:24:18 odin kernel:  [<c1325992>] __bad_area_nosemaphore+0x114/0x11c
Jun  1 21:24:18 odin kernel:  [<c108461a>] ? tag_pages_for_writeback+0x5a/0xa0
Jun  1 21:24:18 odin kernel:  [<c1086212>] ? pagevec_lookup_tag+0x22/0x30
Jun  1 21:24:18 odin kernel:  [<c13259ac>] bad_area_nosemaphore+0x12/0x14
Jun  1 21:24:18 odin kernel:  [<c1020c7a>] do_page_fault+0x24a/0x400
Jun  1 21:24:18 odin kernel:  [<c107d665>] ? find_get_pages_tag+0xf5/0x120
Jun  1 21:24:18 odin kernel:  [<c1020a30>] ? vmalloc_sync_all+0x10/0x10
Jun  1 21:24:18 odin kernel:  [<c132c23e>] error_code+0x5a/0x60
Jun  1 21:24:18 odin kernel:  [<c1020a30>] ? vmalloc_sync_all+0x10/0x10
Jun  1 21:24:18 odin kernel:  [<c11dce7f>] ? __percpu_counter_add+0x1f/0xe0
Jun  1 21:24:18 odin kernel:  [<c1084df3>] account_page_dirtied+0x63/0x90
Jun  1 21:24:18 odin kernel:  [<c10cfdd7>] __set_page_dirty+0x37/0xb0
Jun  1 21:24:18 odin kernel:  [<c10cfea5>] mark_buffer_dirty+0x55/0x80
Jun  1 21:24:18 odin kernel:  [<fa105d11>] udf_close_lvid+0xb1/0xe0 [udf]
Jun  1 21:24:18 odin kernel:  [<fa106175>] udf_put_super+0xa5/0xc0 [udf]
Jun  1 21:24:18 odin kernel:  [<c10ace39>] generic_shutdown_super+0x59/0xd0
Jun  1 21:24:18 odin kernel:  [<c10aced4>] kill_block_super+0x24/0x70
Jun  1 21:24:18 odin kernel:  [<c10ad1a5>] deactivate_locked_super+0x35/0x60
Jun  1 21:24:18 odin kernel:  [<c10ada12>] deactivate_super+0x42/0x60
Jun  1 21:24:18 odin kernel:  [<c10c48c2>] mntput_no_expire+0x82/0xd0
Jun  1 21:24:18 odin kernel:  [<c10c5370>] sys_umount+0x60/0x330
Jun  1 21:24:18 odin kernel:  [<c1003af5>] ? math_state_restore+0x25/0x40
Jun  1 21:24:18 odin kernel:  [<c132c490>] sysenter_do_call+0x12/0x26
Jun  1 21:24:18 odin kernel: ---[ end trace 76d71f835b036376 ]---
Jun  1 21:24:18 odin kernel: note: umount[2915] exited with preempt_count 2
Jun  1 21:24:18 odin kernel: Modules linked in: udf crc_itu_t fuse ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables bridge ipv6 stp llc coretemp hwmon krng eseqiv rng aes_i586 aes_generic xts gf128mul cryptomgr aead usb_storage dm_crypt crypto_hash crypto_blkcipher crypto_algapi dm_mod hid_microsoft raid1 md_mod usbhid fbcon font bitblit softcursor i915 drm_kms_helper snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy sr_mod drm fb fbdev snd_seq_oss cdrom snd_seq_midi i2c_algo_bit cfbcopyarea video ata_generic snd_rawmidi snd_seq_midi_event i2c_i801 backlight pata_marvell ide_pci_generic evdev e1000e psmouse intel_agp serio_raw snd_seq cfbimgblt intel_gtt i2c_core snd_timer snd_seq_device uhci_hcd cfbfillrect agpgart ehci_hcd snd usbcore soundcore snd_page_alloc button processor
Jun  1 21:24:18 odin kernel: Pid: 2915, comm: umount Tainted: G      D W   2.6.39 #1
Jun  1 21:24:18 odin kernel: Call Trace:
Jun  1 21:24:18 odin kernel:  [<c1325e10>] ? printk+0x18/0x1a
Jun  1 21:24:18 odin kernel:  [<c1325be9>] __schedule_bug+0x55/0x5b
Jun  1 21:24:18 odin kernel:  [<c1329a01>] schedule+0x481/0x920
Jun  1 21:24:18 odin kernel:  [<c10300da>] ? wake_up_state+0xa/0x10
Jun  1 21:24:18 odin kernel:  [<c1041063>] ? signal_wake_up+0x23/0x40
Jun  1 21:24:18 odin kernel:  [<c1041174>] ? complete_signal+0xf4/0x1f0
Jun  1 21:24:18 odin kernel:  [<c132b900>] ? _raw_spin_unlock_irqrestore+0x20/0x30
Jun  1 21:24:18 odin kernel:  [<c104222e>] ? send_sigqueue+0xae/0x110
Jun  1 21:24:18 odin kernel:  [<c10197f6>] ? lapic_next_event+0x16/0x20
Jun  1 21:24:18 odin kernel:  [<c1086e28>] ? lru_add_drain+0xa8/0xb0
Jun  1 21:24:18 odin kernel:  [<c102f946>] __cond_resched+0x16/0x30
Jun  1 21:24:18 odin kernel:  [<c132a095>] _cond_resched+0x25/0x30
Jun  1 21:24:18 odin kernel:  [<c1094e72>] unmap_vmas+0x5e2/0x750
Jun  1 21:24:18 odin kernel:  [<c109ad18>] exit_mmap+0xb8/0x160
Jun  1 21:24:18 odin kernel:  [<c1032126>] mmput+0x26/0xb0
Jun  1 21:24:18 odin kernel:  [<c103604a>] exit_mm+0xea/0x120
Jun  1 21:24:18 odin kernel:  [<c1037bb3>] do_exit+0x543/0x6f0
Jun  1 21:24:18 odin kernel:  [<c1325e10>] ? printk+0x18/0x1a
Jun  1 21:24:18 odin kernel:  [<c1005a9a>] oops_end+0x6a/0x90
Jun  1 21:24:18 odin kernel:  [<c1325e10>] ? printk+0x18/0x1a
Jun  1 21:24:18 odin kernel:  [<c1325876>] no_context+0x173/0x17b
Jun  1 21:24:18 odin kernel:  [<c107d665>] ? find_get_pages_tag+0xf5/0x120
Jun  1 21:24:18 odin kernel:  [<c1325992>] __bad_area_nosemaphore+0x114/0x11c
Jun  1 21:24:18 odin kernel:  [<c108461a>] ? tag_pages_for_writeback+0x5a/0xa0
Jun  1 21:24:18 odin kernel:  [<c1086212>] ? pagevec_lookup_tag+0x22/0x30
Jun  1 21:24:18 odin kernel:  [<c13259ac>] bad_area_nosemaphore+0x12/0x14
Jun  1 21:24:18 odin kernel:  [<c1020c7a>] do_page_fault+0x24a/0x400
Jun  1 21:24:18 odin kernel:  [<c107d665>] ? find_get_pages_tag+0xf5/0x120
Jun  1 21:24:18 odin kernel:  [<c1020a30>] ? vmalloc_sync_all+0x10/0x10
Jun  1 21:24:18 odin kernel:  [<c132c23e>] error_code+0x5a/0x60
Jun  1 21:24:18 odin kernel:  [<c1020a30>] ? vmalloc_sync_all+0x10/0x10
Jun  1 21:24:18 odin kernel:  [<c11dce7f>] ? __percpu_counter_add+0x1f/0xe0
Jun  1 21:24:18 odin kernel:  [<c1084df3>] account_page_dirtied+0x63/0x90
Jun  1 21:24:18 odin kernel:  [<c10cfdd7>] __set_page_dirty+0x37/0xb0
Jun  1 21:24:18 odin kernel:  [<c10cfea5>] mark_buffer_dirty+0x55/0x80
Jun  1 21:24:18 odin kernel:  [<fa105d11>] udf_close_lvid+0xb1/0xe0 [udf]
Jun  1 21:24:18 odin kernel:  [<fa106175>] udf_put_super+0xa5/0xc0 [udf]
Jun  1 21:24:18 odin kernel:  [<c10ace39>] generic_shutdown_super+0x59/0xd0
Jun  1 21:24:18 odin kernel:  [<c10aced4>] kill_block_super+0x24/0x70
Jun  1 21:24:18 odin kernel:  [<c10ad1a5>] deactivate_locked_super+0x35/0x60
Jun  1 21:24:18 odin kernel:  [<c10ada12>] deactivate_super+0x42/0x60
Jun  1 21:24:18 odin kernel:  [<c10c48c2>] mntput_no_expire+0x82/0xd0
Jun  1 21:24:18 odin kernel:  [<c10c5370>] sys_umount+0x60/0x330
Jun  1 21:24:18 odin kernel:  [<c1003af5>] ? math_state_restore+0x25/0x40
Jun  1 21:24:18 odin kernel:  [<c132c490>] sysenter_do_call+0x12/0x26
Jun  1 21:24:18 odin kernel: Modules linked in: udf crc_itu_t fuse ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables bridge ipv6 stp llc coretemp hwmon krng eseqiv rng aes_i586 aes_generic xts gf128mul cryptomgr aead usb_storage dm_crypt crypto_hash crypto_blkcipher crypto_algapi dm_mod hid_microsoft raid1 md_mod usbhid fbcon font bitblit softcursor i915 drm_kms_helper snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy sr_mod drm fb fbdev snd_seq_oss cdrom snd_seq_midi i2c_algo_bit cfbcopyarea video ata_generic snd_rawmidi snd_seq_midi_event i2c_i801 backlight pata_marvell ide_pci_generic evdev e1000e psmouse intel_agp serio_raw snd_seq cfbimgblt intel_gtt i2c_core snd_timer snd_seq_device uhci_hcd cfbfillrect agpgart ehci_hcd snd usbcore soundcore snd_page_alloc button processor
Jun  1 21:24:18 odin kernel: Pid: 2915, comm: umount Tainted: G      D W   2.6.39 #1
Jun  1 21:24:18 odin kernel: Call Trace:
Jun  1 21:24:18 odin kernel:  [<c1325e10>] ? printk+0x18/0x1a
Jun  1 21:24:18 odin kernel:  [<c1325be9>] __schedule_bug+0x55/0x5b
Jun  1 21:24:18 odin kernel:  [<c1329a01>] schedule+0x481/0x920
Jun  1 21:24:18 odin kernel:  [<c119f7fc>] ? xfs_release+0x17c/0x240
Jun  1 21:24:18 odin kernel:  [<c108420d>] ? __free_pages+0x2d/0x40
Jun  1 21:24:18 odin kernel:  [<c102f946>] __cond_resched+0x16/0x30
Jun  1 21:24:18 odin kernel:  [<c132a095>] _cond_resched+0x25/0x30
Jun  1 21:24:18 odin kernel:  [<c1037570>] put_files_struct+0x80/0xd0
Jun  1 21:24:18 odin kernel:  [<c1037660>] exit_files+0x40/0x50
Jun  1 21:24:18 odin kernel:  [<c1037bc6>] do_exit+0x556/0x6f0
Jun  1 21:24:18 odin kernel:  [<c1325e10>] ? printk+0x18/0x1a
Jun  1 21:24:18 odin kernel:  [<c1005a9a>] oops_end+0x6a/0x90
Jun  1 21:24:18 odin kernel:  [<c1325e10>] ? printk+0x18/0x1a
Jun  1 21:24:18 odin kernel:  [<c1325876>] no_context+0x173/0x17b
Jun  1 21:24:18 odin kernel:  [<c107d665>] ? find_get_pages_tag+0xf5/0x120
Jun  1 21:24:18 odin kernel:  [<c1325992>] __bad_area_nosemaphore+0x114/0x11c
Jun  1 21:24:18 odin kernel:  [<c108461a>] ? tag_pages_for_writeback+0x5a/0xa0
Jun  1 21:24:18 odin kernel:  [<c1086212>] ? pagevec_lookup_tag+0x22/0x30
Jun  1 21:24:18 odin kernel:  [<c13259ac>] bad_area_nosemaphore+0x12/0x14
Jun  1 21:24:18 odin kernel:  [<c1020c7a>] do_page_fault+0x24a/0x400
Jun  1 21:24:18 odin kernel:  [<c107d665>] ? find_get_pages_tag+0xf5/0x120
Jun  1 21:24:18 odin kernel:  [<c1020a30>] ? vmalloc_sync_all+0x10/0x10
Jun  1 21:24:18 odin kernel:  [<c132c23e>] error_code+0x5a/0x60
Jun  1 21:24:18 odin kernel:  [<c1020a30>] ? vmalloc_sync_all+0x10/0x10
Jun  1 21:24:18 odin kernel:  [<c11dce7f>] ? __percpu_counter_add+0x1f/0xe0
Jun  1 21:24:18 odin kernel:  [<c1084df3>] account_page_dirtied+0x63/0x90
Jun  1 21:24:18 odin kernel:  [<c10cfdd7>] __set_page_dirty+0x37/0xb0
Jun  1 21:24:18 odin kernel:  [<c10cfea5>] mark_buffer_dirty+0x55/0x80
Jun  1 21:24:18 odin kernel:  [<fa105d11>] udf_close_lvid+0xb1/0xe0 [udf]
Jun  1 21:24:18 odin kernel:  [<fa106175>] udf_put_super+0xa5/0xc0 [udf]
Jun  1 21:24:18 odin kernel:  [<c10ace39>] generic_shutdown_super+0x59/0xd0
Jun  1 21:24:18 odin kernel:  [<c10aced4>] kill_block_super+0x24/0x70
Jun  1 21:24:18 odin kernel:  [<c10ad1a5>] deactivate_locked_super+0x35/0x60
Jun  1 21:24:18 odin kernel:  [<c10ada12>] deactivate_super+0x42/0x60
Jun  1 21:24:18 odin kernel:  [<c10c48c2>] mntput_no_expire+0x82/0xd0
Jun  1 21:24:18 odin kernel:  [<c10c5370>] sys_umount+0x60/0x330
Jun  1 21:24:18 odin kernel:  [<c1003af5>] ? math_state_restore+0x25/0x40
Jun  1 21:24:18 odin kernel:  [<c132c490>] sysenter_do_call+0x12/0x26

--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="dmesg.txt"
Content-Transfer-Encoding: quoted-printable

stered
Fast TSC calibration using PIT
Detected 1798.546 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.=
. 3597.09 BogoMIPS (lpj=3D1798546)
pid_max: default: 32768 minimum: 301
Security Framework initialized
Mount-cache hash table entries: 512
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
Initializing cgroup subsys blkio
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20110112
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
CPU0: Intel(R) Core(TM)2 CPU          4300  @ 1.80GHz stepping 02
Performance Events: PEBS fmt0-, Core2 events, Intel PMU driver.
PEBS disabled due to CPU errata.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
CPU 1 irqstacks, hard=3Df5068000 soft=3Df506a000
Booting Node   0, Processors  #1 Ok.
Initializing CPU#1
Brought up 2 CPUs
Total of 2 processors activated (7193.40 BogoMIPS).
devtmpfs: initialized
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 0xf0000000-0xf7ffffff] =
(base 0xf0000000)
PCI: not using MMCONFIG
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 0xf0000000-0xf7ffffff] =
(base 0xf0000000)
PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved in ACPI motherboard=
 resources
PCI: Using MMCONFIG for extended config space
ACPI: No dock devices found.
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=3Duse=
_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (igno=
red)
pci_root PNP0A03:00: host bridge window [mem 0x000e0000-0x000effff] (igno=
red)
pci_root PNP0A03:00: host bridge window [mem 0xf8000000-0xfeafffff] (igno=
red)
pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xefffffff] (igno=
red)
pci 0000:00:00.0: [8086:29a0] type 0 class 0x000600
pci 0000:00:02.0: [8086:29a2] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0xe0200000-0xe02fffff]
pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:02.0: reg 20: [io  0x2110-0x2117]
pci 0000:00:02.1: [8086:29a3] type 0 class 0x000380
pci 0000:00:02.1: reg 10: [mem 0xe0100000-0xe01fffff]
pci 0000:00:03.0: [8086:29a4] type 0 class 0x000780
pci 0000:00:03.0: reg 10: [mem 0xe0326100-0xe032610f 64bit]
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:19.0: [8086:104b] type 0 class 0x000200
pci 0000:00:19.0: reg 10: [mem 0xe0300000-0xe031ffff]
pci 0000:00:19.0: reg 14: [mem 0xe0324000-0xe0324fff]
pci 0000:00:19.0: reg 18: [io  0x20e0-0x20ff]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.0: [8086:2834] type 0 class 0x000c03
pci 0000:00:1a.0: reg 20: [io  0x20c0-0x20df]
pci 0000:00:1a.1: [8086:2835] type 0 class 0x000c03
pci 0000:00:1a.1: reg 20: [io  0x20a0-0x20bf]
pci 0000:00:1a.7: [8086:283a] type 0 class 0x000c03
pci 0000:00:1a.7: reg 10: [mem 0xe0325c00-0xe0325fff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: [8086:284b] type 0 class 0x000403
pci 0000:00:1b.0: reg 10: [mem 0xe0320000-0xe0323fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: [8086:283f] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: [8086:2841] type 1 class 0x000604
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: [8086:2843] type 1 class 0x000604
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.3: [8086:2845] type 1 class 0x000604
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1c.4: [8086:2847] type 1 class 0x000604
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1d.0: [8086:2830] type 0 class 0x000c03
pci 0000:00:1d.0: reg 20: [io  0x2080-0x209f]
pci 0000:00:1d.1: [8086:2831] type 0 class 0x000c03
pci 0000:00:1d.1: reg 20: [io  0x2060-0x207f]
pci 0000:00:1d.2: [8086:2832] type 0 class 0x000c03
pci 0000:00:1d.2: reg 20: [io  0x2040-0x205f]
pci 0000:00:1d.7: [8086:2836] type 0 class 0x000c03
pci 0000:00:1d.7: reg 10: [mem 0xe0325800-0xe0325bff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
pci 0000:00:1f.0: [8086:2812] type 0 class 0x000601
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
pci 0000:00:1f.2: [8086:2821] type 0 class 0x000106
pci 0000:00:1f.2: reg 10: [io  0x2108-0x210f]
pci 0000:00:1f.2: reg 14: [io  0x211c-0x211f]
pci 0000:00:1f.2: reg 18: [io  0x2100-0x2107]
pci 0000:00:1f.2: reg 1c: [io  0x2118-0x211b]
pci 0000:00:1f.2: reg 20: [io  0x2020-0x203f]
pci 0000:00:1f.2: reg 24: [mem 0xe0325000-0xe03257ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: [8086:283e] type 0 class 0x000c05
pci 0000:00:1f.3: reg 10: [mem 0xe0326000-0xe03260ff]
pci 0000:00:1f.3: reg 20: [io  0x2000-0x201f]
pci 0000:00:1c.0: PCI bridge to [bus 01-01]
pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.0:   bridge window [mem 0xe0400000-0xe04fffff]
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disab=
led)
pci 0000:02:00.0: [11ab:6101] type 0 class 0x000101
pci 0000:02:00.0: reg 10: [io  0x1018-0x101f]
pci 0000:02:00.0: reg 14: [io  0x1024-0x1027]
pci 0000:02:00.0: reg 18: [io  0x1010-0x1017]
pci 0000:02:00.0: reg 1c: [io  0x1020-0x1023]
pci 0000:02:00.0: reg 20: [io  0x1000-0x100f]
pci 0000:02:00.0: reg 24: [mem 0xe0000000-0xe00001ff]
pci 0000:02:00.0: supports D1
pci 0000:02:00.0: PME# supported from D0 D1 D3hot
pci 0000:02:00.0: PME# disabled
pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable =
it with 'pcie_aspm=3Dforce'
pci 0000:00:1c.1: PCI bridge to [bus 02-02]
pci 0000:00:1c.1:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.1:   bridge window [mem 0xe0000000-0xe00fffff]
pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disab=
led)
pci 0000:00:1c.2: PCI bridge to [bus 03-03]
pci 0000:00:1c.2:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.2:   bridge window [mem 0xe0500000-0xe05fffff]
pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disab=
led)
pci 0000:00:1c.3: PCI bridge to [bus 04-04]
pci 0000:00:1c.3:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.3:   bridge window [mem 0xe0600000-0xe06fffff]
pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disab=
led)
pci 0000:00:1c.4: PCI bridge to [bus 05-05]
pci 0000:00:1c.4:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.4:   bridge window [mem 0xe0700000-0xe07fffff]
pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disab=
led)
pci 0000:00:1e.0: PCI bridge to [bus 06-06] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disab=
led)
pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode=
)
pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xfffffffff] (subtracti=
ve decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=3Dio+mem,loc=
ks=3Dnone
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000008f000 - 000000000008ffff=20
reserve RAM buffer: 00000000cf58f000 - 00000000cfffffff=20
reserve RAM buffer: 00000000cf649000 - 00000000cfffffff=20
reserve RAM buffer: 00000000cf6f2000 - 00000000cfffffff=20
reserve RAM buffer: 00000000cf700000 - 00000000cfffffff=20
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
Switched to NOHz mode on CPU #0
Switched to NOHz mode on CPU #1
pnp 00:00: [bus 00-ff]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000e0000-0x000effff window]
pnp 00:00: [mem 0xf8000000-0xfeafffff window]
pnp 00:00: [mem 0xd0000000-0xefffffff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp 00:01: [mem 0xf0000000-0xf7ffffff]
pnp 00:01: [mem 0xfed13000-0xfed13fff]
pnp 00:01: [mem 0xfed14000-0xfed17fff]
pnp 00:01: [mem 0xfed18000-0xfed18fff]
pnp 00:01: [mem 0xfed19000-0xfed19fff]
pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
pnp 00:01: [mem 0xfed20000-0xfed3ffff]
pnp 00:01: [mem 0xfed45000-0xfed99fff]
pnp 00:01: [mem 0x000c0000-0x000dffff]
pnp 00:01: [mem 0x000e0000-0x000fffff]
system 00:01: [mem 0xf0000000-0xf7ffffff] has been reserved
system 00:01: [mem 0xfed13000-0xfed13fff] has been reserved
system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:01: [mem 0xfed45000-0xfed99fff] has been reserved
system 00:01: [mem 0x000c0000-0x000dffff] could not be reserved
system 00:01: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:02: [io  0x0000-0x000f]
pnp 00:02: [io  0x0081-0x0083]
pnp 00:02: [io  0x0087]
pnp 00:02: [io  0x0089-0x008b]
pnp 00:02: [io  0x008f]
pnp 00:02: [io  0x00c0-0x00df]
pnp 00:02: [dma 4]
pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:03: [io  0x0070-0x0071]
pnp 00:03: [io  0x0074-0x0077]
pnp 00:03: [irq 8]
pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:04: [io  0x00f0]
pnp 00:04: [irq 13]
pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:05: [io  0x0061]
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:06: [io  0x0500-0x053f]
pnp 00:06: [io  0x0400-0x047f]
pnp 00:06: [io  0x0092]
pnp 00:06: [io  0x0680-0x06ff]
pnp 00:06: [io  0x0010-0x001f]
pnp 00:06: [io  0x0072-0x0073]
pnp 00:06: [io  0x0080]
pnp 00:06: [io  0x0084-0x0086]
pnp 00:06: [io  0x0088]
pnp 00:06: [io  0x008c-0x008e]
pnp 00:06: [io  0x0090-0x009f]
system 00:06: [io  0x0500-0x053f] has been reserved
system 00:06: [io  0x0400-0x047f] has been reserved
system 00:06: [io  0x0680-0x06ff] has been reserved
system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:07: [io  0x0060]
pnp 00:07: [io  0x0064]
system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:08: [mem 0xfec00000-0xfec000ff]
pnp 00:08: Plug and Play ACPI device, IDs PNP0003 (active)
pnp 00:09: [mem 0xfed00000-0xfed03fff]
pnp 00:09: Plug and Play ACPI device, IDs PNP0103 (active)
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
pci 0000:00:1c.0: BAR 9: assigned [mem 0xe0800000-0xe09fffff 64bit pref]
pci 0000:00:1c.1: BAR 9: assigned [mem 0xe0a00000-0xe0bfffff 64bit pref]
pci 0000:00:1c.2: BAR 9: assigned [mem 0xe0c00000-0xe0dfffff 64bit pref]
pci 0000:00:1c.3: BAR 9: assigned [mem 0xe0e00000-0xe0ffffff 64bit pref]
pci 0000:00:1c.4: BAR 9: assigned [mem 0xe1000000-0xe11fffff 64bit pref]
pci 0000:00:1c.0: BAR 7: assigned [io  0x3000-0x3fff]
pci 0000:00:1c.2: BAR 7: assigned [io  0x4000-0x4fff]
pci 0000:00:1c.3: BAR 7: assigned [io  0x5000-0x5fff]
pci 0000:00:1c.4: BAR 7: assigned [io  0x6000-0x6fff]
pci 0000:00:1c.0: PCI bridge to [bus 01-01]
pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.0:   bridge window [mem 0xe0400000-0xe04fffff]
pci 0000:00:1c.0:   bridge window [mem 0xe0800000-0xe09fffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 02-02]
pci 0000:00:1c.1:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.1:   bridge window [mem 0xe0000000-0xe00fffff]
pci 0000:00:1c.1:   bridge window [mem 0xe0a00000-0xe0bfffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 03-03]
pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
pci 0000:00:1c.2:   bridge window [mem 0xe0500000-0xe05fffff]
pci 0000:00:1c.2:   bridge window [mem 0xe0c00000-0xe0dfffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 04-04]
pci 0000:00:1c.3:   bridge window [io  0x5000-0x5fff]
pci 0000:00:1c.3:   bridge window [mem 0xe0600000-0xe06fffff]
pci 0000:00:1c.3:   bridge window [mem 0xe0e00000-0xe0ffffff 64bit pref]
pci 0000:00:1c.4: PCI bridge to [bus 05-05]
pci 0000:00:1c.4:   bridge window [io  0x6000-0x6fff]
pci 0000:00:1c.4:   bridge window [mem 0xe0700000-0xe07fffff]
pci 0000:00:1c.4:   bridge window [mem 0xe1000000-0xe11fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 06-06]
pci 0000:00:1e.0:   bridge window [io  disabled]
pci 0000:00:1e.0:   bridge window [mem disabled]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xfffffffff]
pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:01: resource 1 [mem 0xe0400000-0xe04fffff]
pci_bus 0000:01: resource 2 [mem 0xe0800000-0xe09fffff 64bit pref]
pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:02: resource 1 [mem 0xe0000000-0xe00fffff]
pci_bus 0000:02: resource 2 [mem 0xe0a00000-0xe0bfffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:03: resource 1 [mem 0xe0500000-0xe05fffff]
pci_bus 0000:03: resource 2 [mem 0xe0c00000-0xe0dfffff 64bit pref]
pci_bus 0000:04: resource 0 [io  0x5000-0x5fff]
pci_bus 0000:04: resource 1 [mem 0xe0600000-0xe06fffff]
pci_bus 0000:04: resource 2 [mem 0xe0e00000-0xe0ffffff 64bit pref]
pci_bus 0000:05: resource 0 [io  0x6000-0x6fff]
pci_bus 0000:05: resource 1 [mem 0xe0700000-0xe07fffff]
pci_bus 0000:05: resource 2 [mem 0xe1000000-0xe11fffff 64bit pref]
pci_bus 0000:06: resource 4 [io  0x0000-0xffff]
pci_bus 0000:06: resource 5 [mem 0x00000000-0xfffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS 64 bytes, default 64
microcode: CPU0 sig=3D0x6f2, pf=3D0x1, revision=3D0x51
microcode: CPU1 sig=3D0x6f2, pf=3D0x1, revision=3D0x51
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, =
Peter Oruba
highmem bounce pool size: 64 pages
SGI XFS with ACLs, security attributes, large block/inode numbers, no deb=
ug enabled
msgmni has been set to 1696
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
pcieport 0000:00:1c.1: setting latency timer to 64
pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
pcieport 0000:00:1c.2: setting latency timer to 64
pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
pcieport 0000:00:1c.3: setting latency timer to 64
pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
pcieport 0000:00:1c.4: setting latency timer to 64
pcieport 0000:00:1c.4: irq 44 for MSI/MSI-X
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
loop: module loaded
Uniform Multi-Platform E-IDE driver
ide-gd driver 1.18
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA =
mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum part ccc ems=20
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xe0325000 port 0xe0325100 irq 45
ata2: SATA max UDMA/133 abar m2048@0xe0325000 port 0xe0325180 irq 45
ata3: SATA max UDMA/133 abar m2048@0xe0325000 port 0xe0325200 irq 45
ata4: SATA max UDMA/133 abar m2048@0xe0325000 port 0xe0325280 irq 45
ata5: SATA max UDMA/133 abar m2048@0xe0325000 port 0xe0325300 irq 45
ata6: SATA max UDMA/133 abar m2048@0xe0325000 port 0xe0325380 irq 45
i8042: PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP bic registered
NET: Registered protocol family 17
Using IPI No-Shortcut mode
registered taskstats version 1
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata6.00: ATA-8: WDC WD15EARS-00S8B1, 80.00A80, max UDMA/133
ata6.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata5.00: ATA-8: WDC WD15EARS-00S8B1, 80.00A80, max UDMA/133
ata5.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata6.00: configured for UDMA/133
ata5.00: configured for UDMA/133
ata1.00: ATA-7: WDC WD2500AAKS-00SBA0, 12.01B01, max UDMA/133
ata1.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500AAKS-0 12.0 PQ: 0 ANSI=
: 5
sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't supp=
ort DPO or FUA
ata2.00: ATA-7: WDC WD2500AAKS-00SBA0, 12.01B01, max UDMA/133
ata2.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata2.00: configured for UDMA/133
scsi 1:0:0:0: Direct-Access     ATA      WDC WD2500AAKS-0 12.0 PQ: 0 ANSI=
: 5
sd 1:0:0:0: [sdb] 488397168 512-byte logical blocks: (250 GB/232 GiB)
scsi 4:0:0:0: Direct-Access     ATA      WDC WD15EARS-00S 80.0 PQ: 0 ANSI=
: 5
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't supp=
ort DPO or FUA
sd 4:0:0:0: [sdc] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
scsi 5:0:0:0: Direct-Access     ATA      WDC WD15EARS-00S 80.0 PQ: 0 ANSI=
: 5
sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't supp=
ort DPO or FUA
sd 5:0:0:0: [sdd] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
sd 5:0:0:0: [sdd] Write Protect is off
sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't supp=
ort DPO or FUA
 sdb: sdb1 sdb2
sd 1:0:0:0: [sdb] Attached SCSI disk
 sdc: sdc1
sd 4:0:0:0: [sdc] Attached SCSI disk
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 >
sd 0:0:0:0: [sda] Attached SCSI disk
 sdd: sdd1
sd 5:0:0:0: [sdd] Attached SCSI disk
XFS mounting filesystem sda5
Ending clean XFS mount for filesystem: sda5
VFS: Mounted root (xfs filesystem) readonly on device 8:5.
devtmpfs: mounted
Freeing unused kernel memory: 332k freed
Refined TSC clocksource calibration: 1798.203 MHz.
Switching to clocksource tsc
<30>udevd[659]: starting version 170
ACPI: acpi_idle registered with cpuidle
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/in=
put0
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0325c00
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe0325800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 965G Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K map=
pable
agpgart-intel 0000:00:00.0: detected 8192K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x000020c0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x000020a0
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002080
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002060
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
e1000e: Intel(R) PRO/1000 Network Driver - 1.2.20-k2
e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
pata_marvell 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pata_marvell 0000:02:00.0: setting latency timer to 64
scsi6 : pata_marvell
scsi7 : pata_marvell
ata7: PATA max UDMA/100 cmd 0x1018 ctl 0x1024 bmdma 0x1000 irq 17
ata8: DUMMY
usb 2-1: new high speed USB device using ehci_hcd and address 2
hub 2-1:1.0: USB hub found
hub 2-1:1.0: 4 ports detected
ata7.00: ATAPI: HL-DT-ST DVDRAM GSA-H12L, VL01, max UDMA/66
ata7.00: configured for UDMA/66
scsi 6:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-H12L  VL01 PQ: 0 ANSI=
: 5
e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:19:d1:39:e5:=
b1
e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:00:19.0: eth0: MAC: 6, PHY: 6, PBA No: FFFFFF-0FF
<30>udevd[674]: renamed network interface eth0 to eth1
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 6:0:0:0: Attached scsi CD-ROM sr0
[drm] Initialized drm 1.1.0 20060810
usb 4-2: new full speed USB device using uhci_hcd and address 2
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
usb 5-2: new low speed USB device using uhci_hcd and address 2
mtrr: no more MTRRs available
[drm] MTRR allocation failed.  Graphics performance may suffer.
i915 0000:00:02.0: irq 47 for MSI/MSI-X
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=3Dio+mem,deco=
des=3Dio+mem:owns=3Dio+mem
[drm] initialized overlay support
generic-usb 0003:051D:0002.0001: hiddev0: USB HID v1.00 Device [American =
Power Conversion Back-UPS RS 550GI FW:857.L1 .I USB FW:L1  ] on usb-0000:=
00:1a.1-2/input0
input: Logitech USB RECEIVER as /devices/pci0000:00/0000:00:1d.0/usb5/5-2=
/5-2:1.0/input/input2
generic-usb 0003:046D:C50E.0002: input: USB HID v1.11 Mouse [Logitech USB=
 RECEIVER] on usb-0000:00:1d.0-2/input0
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
fbcon: inteldrmfb (fb0) is primary device
usb 6-1: new low speed USB device using uhci_hcd and address 2
Console: switching to colour frame buffer device 240x75
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
hda_intel: position_fix set to 1 for device 8086:2503
HDA Intel 0000:00:1b.0: irq 48 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
input: Microsoft Natural=C2=AE Ergonomic Keyboard 4000 as /devices/pci000=
0:00/0000:00:1d.1/usb6/6-1/6-1:1.0/input/input3
microsoft 0003:045E:00DB.0003: input: USB HID v1.11 Keyboard [Microsoft N=
atural=C2=AE Ergonomic Keyboard 4000] on usb-0000:00:1d.1-1/input0
input: Microsoft Natural=C2=AE Ergonomic Keyboard 4000 as /devices/pci000=
0:00/0000:00:1d.1/usb6/6-1/6-1:1.1/input/input4
microsoft 0003:045E:00DB.0004: input: USB HID v1.11 Device [Microsoft Nat=
ural=C2=AE Ergonomic Keyboard 4000] on usb-0000:00:1d.1-1/input1
md: md0 stopped.
md: bind<sdd1>
md: bind<sdc1>
usb 6-2: new full speed USB device using uhci_hcd and address 3
md: raid1 personality registered for level 1
bio: create slab <bio-1> at 1
md/raid1:md0: active with 2 out of 2 mirrors
md0: detected capacity change from 0 to 1500298077184
 md0: unknown partition table
usb 2-1.4: new high speed USB device using ehci_hcd and address 6
Initializing USB Mass Storage driver...
scsi8 : usb-storage 2-1.4:1.0
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@red=
hat.com
scsi 8:0:0:0: Direct-Access     Multi    Flash Reader     1.00 PQ: 0 ANSI=
: 0
sd 8:0:0:0: [sde] Attached SCSI removable disk
coretemp coretemp.0: TjMax is assumed as 100 C!
coretemp coretemp.1: TjMax is assumed as 100 C!
vboxdrv: Found 2 processor cores.
vboxdrv: fAsync=3D0 offMin=3D0x288 offMax=3D0x12a2
vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
vboxdrv: Successfully loaded version 4.0.4_OSE (interface 0x00160000).
Adding 1951892k swap on /dev/mapper/cswap.  Priority:-1 extents:1 across:=
1951892k=20
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda1): using internal journal
EXT3-fs (sda1): mounted filesystem with writeback data mode
XFS mounting filesystem sda9
Ending clean XFS mount for filesystem: sda9
XFS mounting filesystem sda7
Ending clean XFS mount for filesystem: sda7
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda8): using internal journal
EXT3-fs (sda8): mounted filesystem with writeback data mode
e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
NET: Registered protocol family 10
ADDRCONF(NETDEV_UP): eth1: link is not ready
Bridge firewalling registered
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
fuse init (API version 7.16)
microcode: CPU0 updated to revision 0x5d, date =3D 2010-10-02
microcode: CPU1 updated to revision 0x5d, date =3D 2010-10-02
e1000e: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready

--Dxnq1zWXvFF0Q93v--
