Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab2LCOZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:25:56 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33258 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab2LCOZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:25:54 -0500
MIME-Version: 1.0
X-Originating-IP: [121.7.72.46]
In-Reply-To: <s5ha9tv1j2a.wl%tiwai@suse.de>
References: <CAMVG2st4KZOYk9qMK6FFRnJt0bCEz-0nFsQAa4zXc+sed_eVhQ@mail.gmail.com>
	<s5hwqx69kuk.wl%tiwai@suse.de>
	<s5ha9tv1j2a.wl%tiwai@suse.de>
Date: Mon, 3 Dec 2012 22:25:52 +0800
Message-ID: <CAMVG2svAdYxJqj=7oA8XpYfaV6MP14Ff_DR3ZwVG0cm-FV_0sA@mail.gmail.com>
Subject: Re: switcheroo registration vs switching race...
From: Daniel J Blueman <daniel@quora.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Seth Forshee <seth.forshee@canonical.com>, Dave Airlie <airlied@linux.ie>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 December 2012 19:17, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 28 Nov 2012 09:45:39 +0100,
> Takashi Iwai wrote:
>>
>> At Wed, 28 Nov 2012 11:45:07 +0800,
>> Daniel J Blueman wrote:
>> >
>> > Hi Seth, Dave, Takashi,
>> >
>> > If I power down the unused discrete GPU before lightdm starts by
>> > fiddling with the sysfs file [1] in the upstart script, I see a race
>> > manifesting as the discrete GPU's HDA controller timing out to
>> > commands [2].
>> >
>> > Adding some debug, I see that the registered audio devices are put
>> > into D3 before the GPU is, but it turns out that the discrete (and
>> > internal) GPU's HDA controller gets registered a bit later, so the
>> > list is empty. The symptom is since the HDA driver it's talking to
>> > hardware which is now in D3.
>> >
>> > We could add a mutex to nouveau to allow us to wait for the DGPU HDA
>> > controller, but perhaps this should be solved at a higher level in the
>> > vgaswitcheroo code; what do you think?
>>
>> Maybe it's a side effect for the recent effort to fix another race in
>> the probe.  A part of them problem is that the registration is done at
>> the very last of probing.
>>
>> Instead of delaying the registration, how about the patch below?
>
> Ping.  If this really works, I'd like to queue it for 3.8 merge, at
> least...

Ping ack; I was trying to find time to understand another race that
occurs with GPU probing after switching, but is separate from the
situation before switching, here.

In the context of writing the switch, it looks like struct azx isn't
allocated by the time azx_vs_set_state accesses it [1,2]; racing with
azx_codec_create?

The full dmesg output is at: http://quora.org/2012/hda-switch-oops.txt

Thanks,
  Daniel

--- [1]

BUG: unable to handle kernel NULL pointer dereference at 0000000000000170
IP: [<ffffffffa01e4006>] azx_vs_set_state+0x26/0x1a0 [snd_hda_intel]
PGD 26323d067 PUD 264f58067 PMD 0
Oops: 0000 [#1] SMP
Modules linked in: snd_hda_codec_hdmi snd_hda_codec_cirrus rfcomm bnep
nls_iso8859_1 joydev hid_apple bcm5974 nouveau coretemp kvm_intel b43
kvm uvcvideo videobuf2_core videobuf2_vmalloc videobuf2_memops
ghash_clmulni_intel smsc75xx usbnet mii ttm snd_hda_intel(+)
snd_hda_codec snd_hwdep ssb i915 snd_pcm mxm_wmi snd_timer apple_gmux
applesmc mei lpc_ich microcode hwmon mfd_core input_polldev bcma snd
drm_kms_helper snd_page_alloc video apple_bl sdhci_pci sdhci mmc_core
CPU 1
Pid: 967, comm: sh Not tainted 3.7.0-rc7-expert+ #8 Apple Inc.
MacBookPro10,1/Mac-C3EC7CD22292981F
RIP: 0010:[<ffffffffa01e4006>] [<ffffffffa01e4006>]
azx_vs_set_state+0x26/0x1a0 [snd_hda_intel]
RSP: 0018:ffff88025198de48 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff880251960a00 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880265b41098
RBP: ffff88025198de68 R08: 0000000000000003 R09: 0000000000001000
R10: 00007fffe481b730 R11: 0000000000000246 R12: ffff880265b41098
R13: 0000000000000000 R14: ffff88025198df50 R15: 0000000000000000
FS: 00007f4961480700(0000) GS:ffff88026f240000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000170 CR3: 0000000263cd3000 CR4: 00000000001407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process sh (pid: 967, threadinfo ffff88025198c000, task ffff88025d635820)
Stack:
 ffff88025d635820 ffff880251960a00 0000000000000000 ffff88025198de98
 ffff88025198de88 ffffffff812b8e77 ffff880263ef1740 0000000000000004
 ffff88025198def8 ffffffff812b947c ffff88020a46464f ffffffff81107982
Call Trace:
 [<ffffffff812b8e77>] set_audio_state+0x67/0x70
 [<ffffffff812b947c>] vga_switcheroo_debugfs_write+0xbc/0x380
 [<ffffffff81107982>] ? __alloc_fd+0x42/0x110
 [<ffffffff81107aa9>] ? __fd_install+0x29/0x60
 [<ffffffff810ed703>] vfs_write+0xa3/0x160
 [<ffffffff810eda0d>] sys_write+0x4d/0xa0
 [<ffffffff810283f9>] ? do_page_fault+0x9/0x10
 [<ffffffff814b7ed6>] system_call_fastpath+0x1a/0x1f
Code: 00 00 00 00 00 55 48 89 e5 48 83 ec 20 4c 89 65 f0 4c 8d a7 98
00 00 00 4c 89 e7 48 89 5d e8 4c 89 6d f8 41 89 f5 e8 fa a4 0d e1 <48>
8b 98 70 01 00 00 0f b6 83 dd 01 00 00 a8 10 75 34 45 85 ed
RIP [<ffffffffa01e4006>] azx_vs_set_state+0x26/0x1a0 [snd_hda_intel]
 RSP <ffff88025198de48>
CR2: 0000000000000170

--- [2]

$ gdb ./sound/pci/hda/snd-hda-intel.ko
(gdb) list *(azx_vs_set_state+0x26)
0x3036 is in azx_vs_set_state (sound/pci/hda/hda_intel.c:2628).
2623
2624    static void azx_vs_set_state(struct pci_dev *pci,
2625                     enum vga_switcheroo_state state)
2626    {
2627        struct snd_card *card = pci_get_drvdata(pci);
2628        struct azx *chip = card->private_data;
2629        bool disabled;
2630
2631        if (chip->init_failed)
2632            return;
--
Daniel J Blueman
