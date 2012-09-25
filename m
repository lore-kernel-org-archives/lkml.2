Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab2IYFUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 01:20:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59085 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab2IYFUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 01:20:07 -0400
MIME-Version: 1.0
X-Originating-IP: [115.42.131.38]
Date: Tue, 25 Sep 2012 13:20:05 +0800
Message-ID: <CAMVG2st1-3kz-KRrm-zXZOGw8=QnyYbB3n5e8Z36xAbmD4b5RQ@mail.gmail.com>
Subject: [3.6-rc7] switcheroo race with Intel HDA...
From: Daniel J Blueman <daniel@quora.org>
To: Dave Airlie <airlied@redhat.com>, Takashi Iwai <tiwai@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my Macbook with a discrete Nvidia GPU, there is a race between
selecting the integrated GPU and putting the discrete GPU into D3 [1],
reliably causing a kernel oops [2].

Introducing a delay of ~1s between the calls prevents this. When the
second 'OFF' write path executes, it looks like struct azx at
card->private_data hasn't yet been allocated yet [3], so there is
likely some locking missing.

I'm happy to perform further testing and debug of course...

Thanks,
  Daniel

--- [1]

echo IGD > /sys/kernel/debug/vgaswitcheroo/switch
echo OFF > /sys/kernel/debug/vgaswitcheroo/switch

--- [2]

BUG: unable to handle kernel NULL pointer dereference at 0000000000000170
IP: [<ffffffffa01ba936>] azx_vs_set_state+0x26/0x178 [snd_hda_intel]
PGD 259c26067 PUD 25a0fd067 PMD 0
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
Modules linked in: snd_hda_codec_hdmi bnep rfcomm b43 joydev nfsd ssb
nfs_acl auth_rpcgss binfmt_misc nfs lockd sunrpc uvcvideo bcm5974
videobuf2_core videobuf2_vmalloc videobuf2_memops coretemp kvm_intel
snd_hda_codec_cirrus kvm applesmc input_polldev microcode bcma lpc_ich
mfd_core mei snd_hda_intel(+) snd_hda_codec snd_hwdep snd_pcm
snd_timer snd snd_page_alloc nls_iso8859_1 apple_gmux mac_hid apple_bl
btrfs hid_apple sdhci_pci ghash_clmulni_intel tg3 sdhci i915 nouveau
ttm drm_kms_helper hwmon mxm_wmi video
CPU 2
Pid: 961, comm: sh Not tainted 3.6.0-rc7 #2 Apple Inc.
MacBookPro10,1/Mac-C3EC7CD22292981F
RIP: 0010:[<ffffffffa01ba936>] [<ffffffffa01ba936>]
azx_vs_set_state+0x26/0x178 [snd_hda_intel]
RSP: 0018:ffff880264271e48 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff88025a2f5280 RCX: 0000000000000000
RDX: 0000000000000006 RSI: 0000000000000000 RDI: ffff880265479098
RBP: ffff880264271e68 R08: 2222222222222222 R09: 2222222222222222
R10: 0000000000000000 R11: 0000000000000000 R12: ffff880265479098
R13: 0000000000000000 R14: ffff880264271f50 R15: 0000000000000000
FS: 00007fa4fe183700(0000) GS:ffff88026f280000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000170 CR3: 00000002641a7000 CR4: 00000000001407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process sh (pid: 961, threadinfo ffff880264270000, task ffff880264503a00)
Stack:
 2222222222222222 ffff88025a2f5280 0000000000000000 ffff880264271e98
 ffff880264271e88 ffffffff812e83a7 ffff8802622835c0 0000000000000004
 ffff880264271ef8 ffffffff812e89ac ffff88020a46464f ffff880264503a00
Call Trace:
 [<ffffffff812e83a7>] set_audio_state+0x67/0x70
 [<ffffffff812e89ac>] vga_switcheroo_debugfs_write+0xbc/0x380
 [<ffffffff81108773>] vfs_write+0xa3/0x160
 [<ffffffff81108a75>] sys_write+0x45/0xa0
 [<ffffffff815231a6>] system_call_fastpath+0x1a/0x1f
Code: 00 00 00 00 00 55 48 89 e5 48 83 ec 20 4c 89 65 f0 4c 8d a7 98
00 00 00 4c 89 e7 48 89 5d e8 4c 89 6d f8 41 89 f5 e8 2a 35 13 e1 <48>
8b 98 70 01 00 00 0f b6 83 55 02 00 00 a8 08 75 34 45 85 ed
RIP [<ffffffffa01ba936>] azx_vs_set_state+0x26/0x178 [snd_hda_intel]
 RSP <ffff880264271e48>
CR2: 0000000000000170

--- [3]

(gdb) list *(azx_vs_set_state+0x26)
0x2936 is in azx_vs_set_state (sound/pci/hda/hda_intel.c:2505).
2500	
2501	static void azx_vs_set_state(struct pci_dev *pci,
2502				   enum vga_switcheroo_state state)
2503	{
2504		struct snd_card *card = pci_get_drvdata(pci);
2505		struct azx *chip = card->private_data;
2506		bool disabled;
2507	
2508		if (chip->init_failed)
2509			return;
-- 
Daniel J Blueman
