Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab0ENXD5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 19:03:57 -0400
Received: from mga10.intel.com ([192.55.52.92]:24028 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750865Ab0ENXDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 19:03:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,234,1272870000"; 
   d="scan'208";a="567335655"
Date: Fri, 14 May 2010 16:03:46 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andiry Xu <andiry.xu@amd.com>
Subject: Too many printks leads to hang?
Message-ID: <20100514230346.GA4442@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been trying to track down a bug in some xHCI isochronous patches,
and I made the mistake of turning on full xHCI debugging while I was
using netconsole.  It lead to my system hanging every time I opened the
webcam.  The system was fine when I turned off xHCI driver debugging.

Is it expected that excessive printks from interrupt context could lead
to a system hang?  One of the stack traces I could grab looks like this:

snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event iwlagn i915 snd_seq drm_kms_helper iwlcore psmouse mac80211 snd_timer snd_seq_device drm thinkpad_acpi tpm_tis pcspkr serio_raw iTCO_wdt iTCO_vendor_support cfg80211 led_class snd i2c_algo_bit tpm tpm_bios nvram intel_agp video soundcore snd_page_alloc output uhci_hcd ehci_hcd usbcore [last unloaded: xhci_hcd]
[ 1810.300504] 
[ 1810.300504] Pid: 2852, comm: dd Tainted: G      D    2.6.34-rc7 #468 74663HU/74663HU
[ 1810.300504] RIP: 0010:[<ffffffff81082089>]  [<ffffffff81082089>] lock_acquire+0xb9/0x140
[ 1810.300504] RSP: 0018:ffff88012e263dd8  EFLAGS: 00000246
[ 1810.300504] RAX: ffff880137129fa0 RBX: ffff88012e263e48 RCX: 0000000000000000
[ 1810.300504] RDX: 00000000000001a0 RSI: ffff88013712a6a0 RDI: 0000000000000246
[ 1810.300504] RBP: ffffffff8153ed4e R08: 0000000000000000 R09: 0000000000000000
[ 1810.300504] R10: 00000000000001a1 R11: 0001f6f5abe27598 R12: ffff88012e3d3d90
[ 1810.300504] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 1810.300504] FS:  00007f246e60e6f0(0000) GS:ffff880002680000(0000) knlGS:0000000000000000
[ 1810.300504] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1810.300504] CR2: 0000000000000008 CR3: 00000001371c7000 CR4: 00000000000406a0
[ 1810.300504] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1810.300504] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1810.300504] Process dd (pid: 2852, threadinfo ffff88012e262000, task ffff880137129fa0)
[ 1810.300504] Stack:
[ 1810.300504]  0000000000000000 ffffffff81176400 ffff880100000000 0000000000000000
[ 1810.300504] <0> ffff88012e263e78 ffffffff8104efcb ffff880100000020 0000000000000246
[ 1810.300504] <0> 0000000000000000 ffff88012e3d3d78 ffff88012e3d3d78 ffffffff811817f0
[ 1810.300504] Call Trace:
[ 1810.300504]  [<ffffffff81176400>] ? pde_users_dec+0x20/0x60
[ 1810.300504]  [<ffffffff8104efcb>] ? do_syslog+0x33b/0x520
[ 1810.300504]  [<ffffffff811817f0>] ? kmsg_read+0x0/0x70
[ 1810.300504]  [<ffffffff8153e3cc>] ? _raw_spin_lock+0x2c/0x40
[ 1810.300504]  [<ffffffff81176400>] ? pde_users_dec+0x20/0x60
[ 1810.300504]  [<ffffffff811817f0>] ? kmsg_read+0x0/0x70
[ 1810.300504]  [<ffffffff81176400>] ? pde_users_dec+0x20/0x60
[ 1810.300504]  [<ffffffff811766dc>] ? proc_reg_read+0x8c/0xc0
[ 1810.300504]  [<ffffffff81120435>] ? vfs_read+0xb5/0x1a0
[ 1810.300504]  [<ffffffff8153ed4e>] ? common_interrupt+0xe/0x13
[ 1810.300504]  [<ffffffff811209dc>] ? sys_read+0x4c/0x80
[ 1810.300504]  [<ffffffff81009f02>] ? system_call_fastpath+0x16/0x1b
[ 1810.300504] Code: 09 4c 89 14 24 49 83 f1 01 41 83 e1 01 e8 00 fa ff ff 65 48 8b 04 25 00 cc 00 00 c7 80 e4 06 00 00 00 00 00 00 48 8b 
[ 1810.392922] CPU 1 
[ 1810.392927] Modules linked in: xhci_hcd gspca_spca500 gspca_main snd_usb_audio snd_hwdep snd_usb_lib uvcvideo nls_iso8859_1 nls_cp437 vfat fat usb_storage netconsole configfs aes_x86_64 aes_generic binfmt_misc fbcon tileblit font bitblit softcursor ppdev lp parport snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm arc4 snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event iwlagn i915 snd_seq drm_kms_helper iwlcore psmouse mac80211 snd_timer snd_seq_device drm thinkpad_acpi tpm_tis pcspkr serio_raw iTCO_wdt iTCO_vendor_support cfg80211 led_class snd i2c_algo_bit tpm tpm_bios nvram intel_agp video soundcore snd_page_alloc output uhci_hcd ehci_hcd usbcore [last unloaded: xhci_hcd]
[ 1810.393201] 
[ 1810.393207] Pid: 2852, comm: dd Tainted: G      D    2.6.34-rc7 #468 74663HU/74663HU
[ 1810.393213] RIP: 0010:[<ffffffff81082089>]  [<ffffffff81082089>] lock_acquire+0xb9/0x140
[ 1810.393224] RSP: 0018:ffff88012e263dd8  EFLAGS: 00000246
[ 1810.393229] RAX: ffff880137129fa0 RBX: ffff88012e263e48 RCX: 0000000000000000
[ 1810.393235] RDX: 00000000000001a0 RSI: ffff88013712a6a0 RDI: 0000000000000246
[ 1810.393242] RBP: ffffffff8153ed4e R08: 0000000000000000 R09: 0000000000000000
[ 1810.393250] R10: 00000000000001a1 R11: 0001f6f5abe27598 R12: ffff88012e3d3d90
[ 1810.393255] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 1810.393262] FS:  00007f246e60e6f0(0000) GS:ffff880002680000(0000) knlGS:0000000000000000
[ 1810.393268] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1810.393274] CR2: 0000000000000008 CR3: 00000001371c7000 CR4: 00000000000406a0
[ 1810.393280] DR0: 0buffer hi) = 0x0
[ 1130.322413] xhci_hcd 0000:01:00.0: Offset 0x08 (transfer length) = 0x1000000
[ 1130.322429] xhci_hcd 0000:01:00.0: Offset 0x0C (flags) = 0x1028000
[ 1130.322446] xhci_hcd 0000:01:00.0: Successful bulk transfer!

Sarah Sharp
