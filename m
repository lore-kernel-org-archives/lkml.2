Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab2JHQeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 12:34:14 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60180 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab2JHQeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 12:34:11 -0400
MIME-Version: 1.0
X-Originating-IP: [116.14.92.167]
In-Reply-To: <s5hvceli0ht.wl%tiwai@suse.de>
References: <CAMVG2st1-3kz-KRrm-zXZOGw8=QnyYbB3n5e8Z36xAbmD4b5RQ@mail.gmail.com>
	<s5hvceli0ht.wl%tiwai@suse.de>
Date: Tue, 9 Oct 2012 00:34:09 +0800
Message-ID: <CAMVG2ss7hmJAEt-vEsNBmTVDWMYCPyPo0UC34DKDBnr7t5gn8g@mail.gmail.com>
Subject: Re: [3.6-rc7] switcheroo race with Intel HDA...
From: Daniel J Blueman <daniel@quora.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Dave Airlie <airlied@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 October 2012 20:58, Takashi Iwai <tiwai@suse.de> wrote:
> At Tue, 25 Sep 2012 13:20:05 +0800,
> Daniel J Blueman wrote:
>> On my Macbook with a discrete Nvidia GPU, there is a race between
>> selecting the integrated GPU and putting the discrete GPU into D3 [1],
>> reliably causing a kernel oops [2].
>>
>> Introducing a delay of ~1s between the calls prevents this. When the
>> second 'OFF' write path executes, it looks like struct azx at
>> card->private_data hasn't yet been allocated yet [3], so there is
>> likely some locking missing.
>
> It's rather pci_get_drvdata() returning NULL (i.e. card is NULL, thus
> card->private_data causes Oops).  Could you check the patch like below
> and see whether you get a kernel warning (but no Oops) or the problem
> gets fixed by shifting the assignment of pci drvdata?
[...]

Good patching. Calling pci_set_drvdata later prevents the oops in HDA,
though we see unexpected 0x0 responses in the response ring buffer
[1], which we don't see when there's a >~1.5s delay between IGD and
OFF.

Thanks,
  Daniel

--- [1]

snd_hda_intel 0000:00:1b.0: enabling device (0000 -> 0002)
snd_hda_intel 0000:00:1b.0: irq 55 for MSI/MSI-X
vga_switcheroo: enabled
input: HDA Intel PCH Headphone as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input11
snd_hda_intel 0000:01:00.1: enabling device (0000 -> 0002)
{echo IGD >/sys/kernel/debug/vgaswitcheroo/switch}
{echo OFF >/sys/kernel/debug/vgaswitcheroo/switch}
hda_intel: Disabling MSI
hda-intel: 0000:01:00.1: Handle VGA-switcheroo audio client
hda-intel: Disabling 0000:01:00.1 via VGA-switcheroo
VGA switcheroo: switched nouveau off
[drm] nouveau 0000:01:00.0: Disabling display...
[drm] nouveau 0000:01:00.0: Disabling fbcon...
[drm] nouveau 0000:01:00.0: Unpinning framebuffer(s)...
[drm] nouveau 0000:01:00.0: Evicting buffers...
[drm] nouveau 0000:01:00.0: Idling channels...
[drm] nouveau 0000:01:00.0: Suspending GPU objects...
[drm] nouveau 0000:01:00.0: And we're gone!
hda-intel: spurious response 0x0:0x0, last cmd=0x1f0004
{repeats 220 times}
hda-intel: spurious response 0x0:0x0, last cmd=0x1f0004
HDMI: failed to get afg sub nodes
-- 
Daniel J Blueman
