Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1DKFUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 01:20:22 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:48129
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753764Ab1DKFUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 01:20:21 -0400
Date: Mon, 11 Apr 2011 07:20:10 +0200
From: Michael Guntsche <mike@it-loops.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.39-rc[12]] hangs during boot
Message-ID: <20110411052010.GA13816@gibson.comsick.at>
References: <20110408052921.GA17375@gibson.comsick.at>
 <20110409094134.GA12807@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110409094134.GA12807@sucs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09 Apr 11 10:41, Sitsofe Wheeler wrote:
> On Fri, Apr 08, 2011 at 07:29:21AM +0200, Michael Guntsche wrote:
> > 
> > On a side note since I read similar reports already. This is a happening
> > with a CONFIG_NO_HZ/TICK_ONESHOT non-PREEMPT kernel.
> 
> Does the problem go away with a PREEMPT kernel?

I can try this not earlier than this thursday. I was able to did some
manual bisecting though. I was tested up to commit

5f6fb454  Merge branch 'irq-core-for-linus'

I first thought that this merge was the main culprit but the kernel
booted. I soon saw the following messages appearing in the console
though.


Apr  8 12:40:26 gibson kernel: ------------[ cut here ]------------
Apr  8 12:40:26 gibson kernel: WARNING: at kernel/futex.c:786 __unqueue_futex.clone.18+0x12/0x14()
Apr  8 12:40:26 gibson kernel: Hardware name: System Product Name
Apr  8 12:40:26 gibson kernel: Modules linked in: lp fuse rpcsec_gss_krb5 nfsd nfs lockd nfs_acl auth_rpcgss sunrpc ipv6 xfs w83627hf hwmon_vid hwmon snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_seq snd_timer snd_seq_device 8250_pnp snd soundcore snd_page_alloc psmouse i2c_i801 serio_raw 8250 serial_core parport_pc evdev parport intel_agp intel_gtt button processor agpgart ext3 jbd mbcache btrfs lzo_compress zlib_deflate crc32c libcrc32c i2c_matroxfb i2c_algo_bit i2c_core usbhid hid uhci_hcd firewire_ohci firewire_core crc_itu_t floppy ehci_hcd skge usbcore unix matroxfb_base matroxfb_DAC1064 matroxfb_accel cfbcopyarea cfbimgblt cfbfillrect matroxfb_Ti3026 matroxfb_g450 g450_pll matroxfb_misc fbcon tileblit font bitblit softcursor fb fbdev [last unloaded: scsi_wait_scan]
Apr  8 12:40:26 gibson kernel: Pid: 3403, comm: mediatomb Not tainted 2.6.38+ #7
Apr  8 12:40:26 gibson kernel: Call Trace:
Apr  8 12:40:26 gibson kernel:  [<c1026229>] ? warn_slowpath_common+0x67/0x8e
Apr  8 12:40:26 gibson kernel:  [<c1045c2b>] ? __unqueue_futex.clone.18+0x12/0x14
Apr  8 12:40:26 gibson kernel:  [<c1045c2b>] ? __unqueue_futex.clone.18+0x12/0x14
Apr  8 12:40:26 gibson kernel:  [<c102626d>] ? warn_slowpath_null+0x1d/0x1f
Apr  8 12:40:26 gibson kernel:  [<c1045c2b>] ? __unqueue_futex.clone.18+0x12/0x14
Apr  8 12:40:26 gibson kernel:  [<c1045e42>] ? wake_futex.clone.19+0x11/0x38
Apr  8 12:40:26 gibson kernel:  [<c1047407>] ? do_futex+0x4ee/0x818
Apr  8 12:40:26 gibson kernel:  [<c1047795>] ? sys_futex+0x64/0xff
Apr  8 12:40:26 gibson kernel:  [<c107094c>] ? sys_brk+0xc4/0xe7
Apr  8 12:40:26 gibson kernel:  [<c120f00d>] ? syscall_call+0x7/0xb
Apr  8 12:40:26 gibson kernel: ---[ end trace 087883b80cc9a767 ]---
Apr  8 12:40:26 gibson kernel: BUG: unable to handle kernel NULL pointer dereference at   (null)
Apr  8 12:40:26 gibson kernel: IP: [<c10473cd>] do_futex+0x4b4/0x818
Apr  8 12:40:26 gibson kernel: *pde = 00000000 
Apr  8 12:40:26 gibson kernel: Oops: 0000 [#1] 
Apr  8 12:40:26 gibson kernel: last sysfs file: /sys/devices/platform/w83627hf.656/beep_enable
Apr  8 12:40:26 gibson kernel: Modules linked in: lp fuse rpcsec_gss_krb5 nfsd nfs lockd nfs_acl auth_rpcgss sunrpc ipv6 xfs w83627hf hwmon_vid hwmon snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_seq snd_timer snd_seq_device 8250_pnp snd soundcore snd_page_alloc psmouse i2c_i801 serio_raw 8250 serial_core parport_pc evdev parport intel_agp intel_gtt button processor agpgart ext3 jbd mbcache btrfs lzo_compress zlib_deflate crc32c libcrc32c i2c_matroxfb i2c_algo_bit i2c_core usbhid hid uhci_hcd firewire_ohci firewire_core crc_itu_t floppy ehci_hcd skge usbcore unix matroxfb_base matroxfb_DAC1064 matroxfb_accel cfbcopyarea cfbimgblt cfbfillrect matroxfb_Ti3026 matroxfb_g450 g450_pll matroxfb_misc fbcon tileblit font bitblit softcursor fb fbdev [last unloaded: scsi_wait_scan]
Apr  8 12:40:26 gibson kernel: 
Apr  8 12:40:26 gibson kernel: Pid: 3401, comm: mediatomb Tainted: G        W   2.6.38+ #7 System manufacturer System Product Name/P4P800SE
Apr  8 12:40:26 gibson kernel: EIP: 0060:[<c10473cd>] EFLAGS: 00010287 CPU: 0
Apr  8 12:40:26 gibson kernel: EIP is at do_futex+0x4b4/0x818
Apr  8 12:40:26 gibson kernel: EAX: f1419754 EBX: 00000000 ECX: 00000000 EDX: 09d48000
Apr  8 12:40:26 gibson kernel: ESI: fffffff4 EDI: c13a7ce0 EBP: f158ff6c ESP: f158fee8
Apr  8 12:40:26 gibson kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Apr  8 12:40:26 gibson kernel: Process mediatomb (pid: 3401, ti=f158e000 task=f1419760 task.ti=f158e000)
Apr  8 12:40:26 gibson kernel: Stack:
Apr  8 12:40:26 gibson kernel:  f146b800 b781d140 f158ff00 b781d140 00000001 c13a7ce0 f158ff28 09d48584
Apr  8 12:40:26 gibson kernel:  00000000 c13a8118 00000001 00000004 00000001 00000000 00000000 04000001
Apr  8 12:40:26 gibson kernel:  f158ffac 00000001 00000000 f158ff44 00000202 00000000 09d48000 f146b800
Apr  8 12:40:26 gibson kernel: Call Trace:
Apr  8 12:40:26 gibson kernel:  [<c1047795>] sys_futex+0x64/0xff
Apr  8 12:40:26 gibson kernel:  [<c1008096>] ? sys_clone+0x2b/0x32
Apr  8 12:40:26 gibson kernel:  [<c10036ed>] ? do_device_not_available+0x0/0x15
Apr  8 12:40:26 gibson kernel:  [<c10036db>] ? math_state_restore+0x24/0x36
Apr  8 12:40:26 gibson kernel:  [<c120f00d>] syscall_call+0x7/0xb
Apr  8 12:40:26 gibson kernel: Code: 83 f8 0b 0f 85 9a 01 00 00 83 cf 02 e9 91 fb ff ff 0f 8c fe 02 00 00 8b 7d 90 8b 17 8d 42 f4 8b 70 0c 39 d7 74 4a 83 ee 0c eb 0f <8b> 56 0c 8d 46 0c 39 c7 74 3b 89 f0 8d 72 f4 83 f8 e4 74 ec 8b 
Apr  8 12:40:26 gibson kernel: EIP: [<c10473cd>] do_futex+0x4b4/0x818 SS:ESP 0068:f158fee8
Apr  8 12:40:26 gibson kernel: CR2: 0000000000000000
Apr  8 12:40:26 gibson kernel: ---[ end trace 087883b80cc9a768 ]---
Apr  8 12:45:43 gibson kernel: BUG: unable to handle kernel NULL pointer dereference at 00000040
Apr  8 12:45:43 gibson kernel: IP: [<c1045edf>] futex_wake+0x76/0x105
Apr  8 12:45:43 gibson kernel: *pde = 00000000 
Apr  8 12:45:43 gibson kernel: Oops: 0000 [#2] 
Apr  8 12:45:43 gibson kernel: last sysfs file: /sys/devices/platform/w83627hf.656/beep_enable
Apr  8 12:45:43 gibson kernel: Modules linked in: lp fuse rpcsec_gss_krb5 nfsd nfs lockd nfs_acl auth_rpcgss sunrpc ipv6 xfs w83627hf hwmon_vid hwmon snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_seq snd_timer snd_seq_device 8250_pnp snd soundcore snd_page_alloc psmouse i2c_i801 serio_raw 8250 serial_core parport_pc evdev parport intel_agp intel_gtt button processor agpgart ext3 jbd mbcache btrfs lzo_compress zlib_deflate crc32c libcrc32c i2c_matroxfb i2c_algo_bit i2c_core usbhid hid uhci_hcd firewire_ohci firewire_core crc_itu_t floppy ehci_hcd skge usbcore unix matroxfb_base matroxfb_DAC1064 matroxfb_accel cfbcopyarea cfbimgblt cfbfillrect matroxfb_Ti3026 matroxfb_g450 g450_pll matroxfb_misc fbcon tileblit font bitblit softcursor fb fbdev [last unloaded: scsi_wait_scan]
Apr  8 12:45:43 gibson kernel: 
Apr  8 12:45:43 gibson kernel: Pid: 4469, comm: mv Tainted: G      D W   2.6.38+ #7 System manufacturer System Product Name/P4P800SE
Apr  8 12:45:43 gibson kernel: EIP: 0060:[<c1045edf>] EFLAGS: 00010207 CPU: 0
Apr  8 12:45:43 gibson kernel: EIP is at futex_wake+0x76/0x105
Apr  8 12:45:43 gibson kernel: EAX: f1419754 EBX: 00000034 ECX: f158fe6c EDX: bff09000
Apr  8 12:45:43 gibson kernel: ESI: c13a7ce0 EDI: ffffffff EBP: eba0bee0 ESP: eba0beb8
Apr  8 12:45:43 gibson kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Apr  8 12:45:43 gibson kernel: Process mv (pid: 4469, ti=eba0a000 task=ece40000 task.ti=eba0a000)
Apr  8 12:45:43 gibson kernel: Stack:
Apr  8 12:45:43 gibson kernel:  00000000 eb8e4400 00000001 ecf6d000 bff09000 ecf6d000 00000f70 00000000
Apr  8 12:45:43 gibson kernel:  bff09f70 00000000 eba0bf6c c1046fce ffffffff 401a9430 eba0bf00 401a9430
Apr  8 12:45:43 gibson kernel:  ecf6d000 eb8e4400 eba0bf28 c106ddb8 ecfd16a4 eb8e4400 00000008 eb9c72c0
Apr  8 12:45:43 gibson kernel: Call Trace:
Apr  8 12:45:43 gibson kernel:  [<c1046fce>] do_futex+0xb5/0x818
Apr  8 12:45:43 gibson kernel:  [<c106ddb8>] ? handle_mm_fault+0x86/0x94
Apr  8 12:45:43 gibson kernel:  [<c106f515>] ? remove_vma+0x3a/0x49
Apr  8 12:45:43 gibson kernel:  [<c1047795>] sys_futex+0x64/0xff
Apr  8 12:45:43 gibson kernel:  [<c106f23d>] ? arch_unmap_area+0x0/0x1c
Apr  8 12:45:43 gibson kernel:  [<c120f00d>] syscall_call+0x7/0xb
Apr  8 12:45:43 gibson kernel: Code: d8 e8 16 f5 ff ff 89 c6 8b 00 8d 48 f4 8b 59 0c 39 c6 0f 84 9d 00 00 00 83 eb 0c 8b 45 ec 89 45 e4 89 c8 89 7d d8 8b 7d 08 eb 0f <8b> 53 0c 8d 43 0c 39 c6 74 5c 89 d8 8d 5a f4 83 f8 e4 74 ec 8b 
Apr  8 12:45:43 gibson kernel: EIP: [<c1045edf>] futex_wake+0x76/0x105 SS:ESP 0068:eba0beb8
Apr  8 12:45:43 gibson kernel: CR2: 0000000000000040
Apr  8 12:45:43 gibson kernel: ---[ end trace 087883b80cc9a769 ]---

Kind regards,
Michael
