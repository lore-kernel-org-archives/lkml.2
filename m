Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab2K1DpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 22:45:11 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38021 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab2K1DpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 22:45:09 -0500
MIME-Version: 1.0
X-Originating-IP: [220.255.156.126]
Date: Wed, 28 Nov 2012 11:45:07 +0800
Message-ID: <CAMVG2st4KZOYk9qMK6FFRnJt0bCEz-0nFsQAa4zXc+sed_eVhQ@mail.gmail.com>
Subject: switcheroo registration vs switching race...
From: Daniel J Blueman <daniel@quora.org>
To: Seth Forshee <seth.forshee@canonical.com>, Dave Airlie <airlied@linux.ie>,
        Takashi Iwai <tiwai@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth, Dave, Takashi,

If I power down the unused discrete GPU before lightdm starts by
fiddling with the sysfs file [1] in the upstart script, I see a race
manifesting as the discrete GPU's HDA controller timing out to
commands [2].

Adding some debug, I see that the registered audio devices are put
into D3 before the GPU is, but it turns out that the discrete (and
internal) GPU's HDA controller gets registered a bit later, so the
list is empty. The symptom is since the HDA driver it's talking to
hardware which is now in D3.

We could add a mutex to nouveau to allow us to wait for the DGPU HDA
controller, but perhaps this should be solved at a higher level in the
vgaswitcheroo code; what do you think?

Thanks,
  Daniel

--- [1]

echo OFF >/sys/kernel/debug/vgaswitcheroo/switch

--- [2]

snd_hda_intel 0000:00:1b.0: enabling device (0000 -> 0002)
snd_hda_intel 0000:00:1b.0: irq 51 for MSI/MSI-X
input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
input: HDA Intel PCH Headphone as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input11
nouveau [  VBIOS][0000:01:00.0] ... appears to be valid
nouveau [  VBIOS][0000:01:00.0] using image from PRAMIN
nouveau [  VBIOS][0000:01:00.0] BIT signature found
nouveau [  VBIOS][0000:01:00.0] version 80.07.26.04
nouveau [   MXM][0000:01:00.0] no VBIOS data, nothing to do
nouveau [   PFB][0000:01:00.0] RAM type: GDDR5
nouveau [   PFB][0000:01:00.0] RAM size: 1024 MiB
nouveau W[ PGRAPH][0000:01:00.0] disabled, PGRAPH=1 to enable
vga_switcheroo: enabled
[TTM] Zone kernel: Available graphics memory: 4076308 kiB
[TTM] Zone  dma32: Available graphics memory: 2097152 kiB
[TTM] Initializing pool allocator
[TTM] Initializing DMA pool allocator
nouveau [   DRM] VRAM: 1024 MiB
nouveau [   DRM] GART: 512 MiB
nouveau [   DRM] BIT BIOS found
nouveau [   DRM] Bios version 80.07.26.04
nouveau [   DRM] TMDS table version 2.0
nouveau [   DRM] DCB version 4.0
nouveau [   DRM] DCB outp 00: 048101b6 0f230010
nouveau [   DRM] DCB outp 01: 018212d6 0f220020
nouveau [   DRM] DCB outp 02: 01021212 00020020
nouveau [   DRM] DCB outp 03: 088324c6 0f220010
nouveau [   DRM] DCB outp 04: 08032402 00020010
nouveau [   DRM] DCB outp 05: 02843862 00020010
nouveau [   DRM] DCB conn 00: 00020047
nouveau [   DRM] DCB conn 01: 02208146
nouveau [   DRM] DCB conn 02: 01104246
nouveau [   DRM] DCB conn 03: 00410361
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] No driver support for vblank timestamp query.
nouveau W[   DRM] voltage table 0x50 unknown
nouveau [   DRM] 4 available performance level(s)
nouveau [   DRM] 1: core 209MHz shader 419MHz memory 405MHz voltage 520mV
nouveau [   DRM] 2: core 390MHz shader 780MHz memory 1080MHz voltage 610mV
nouveau [   DRM] 3: core 1000MHz shader 2000MHz memory 1080MHz voltage 630mV
nouveau [   DRM] 4: core 1254MHz shader 2508MHz memory 1080MHz voltage 630mV
nouveau [   DRM] c:
nouveau E[   DRM] failed to create kernel channel, -22
No connectors reported connected with modes
[drm] Cannot find any crtc or sizes - going 1024x768
nouveau [   DRM] allocated 1024x768 fb: 0x60000, bo ffff880264974400
fb1: nouveaufb frame buffer device
[drm] Initialized nouveau 1.1.0 20120801 for 0000:01:00.0 on minor 1
snd_hda_intel 0000:01:00.1: enabling device (0000 -> 0002)
hda-intel: 0000:01:00.1: Handle VGA-switcheroo audio client
snd_hda_intel 0000:01:00.1: irq 52 for MSI/MSI-X
VGA switcheroo: switched nouveau off
nouveau [   DRM] suspending fbcon...
nouveau [   DRM] suspending display...
nouveau [   DRM] unpinning framebuffer(s)...
nouveau [   DRM] evicting buffers...
nouveau [   DRM] suspending client object trees...
input: HDA NVidia HDMI/DP,pcm=8 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input12
input: HDA NVidia HDMI/DP,pcm=7 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input13
input: HDA NVidia HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input14
nouveau E[   I2C][0000:01:00.0] AUXCH(3): begin idle timeout 0xffffffff
nouveau E[   I2C][0000:01:00.0] AUXCH(2): begin idle timeout 0xffffffff
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: spurious response 0x0:0x0, last cmd=0x170503
hda-intel: azx_get_response timeout, switching to polling mode: last
cmd=0x001f0500
hda-intel: No response from codec, disabling MSI: last cmd=0x001f0500
hda_intel: azx_get_response timeout, switching to single_cmd mode:
last cmd=0x001f0500
hda-codec: out of range cmd 0:0:4:707:ffffffff
hda-codec: out of range cmd 0:0:4:707:fffffffc
hda-codec: out of range cmd 0:0:4:707:ffffffff
hda-codec: out of range cmd 0:0:4:707:fffffffc
hda-codec: out of range cmd 0:0:4:707:ffffffbf
hda-codec: out of range cmd 0:0:4:707:ffffffff
hda-codec: out of range cmd 0:0:4:707:fffffffc
hda-codec: out of range cmd 0:0:4:707:ffffffff
hda-codec: out of range cmd 0:0:4:707:fffffffc
hda-codec: out of range cmd 0:0:4:707:ffffffbf
hda-codec: out of range cmd 0:0:5:707:ffffffff
hda-codec: out of range cmd 0:0:5:707:fffffffc
hda-codec: out of range cmd 0:0:5:707:ffffffff
hda-codec: out of range cmd 0:0:5:707:fffffffc
hda-codec: out of range cmd 0:0:5:707:ffffffbf
hda-codec: out of range cmd 0:0:5:707:ffffffff
hda-codec: out of range cmd 0:0:5:707:fffffffc
hda-codec: out of range cmd 0:0:5:707:ffffffff
hda-codec: out of range cmd 0:0:5:707:fffffffc
hda-codec: out of range cmd 0:0:5:707:ffffffbf
hda-codec: out of range cmd 0:0:7:707:ffffffff
hda-codec: out of range cmd 0:0:7:707:fffffffc
hda-codec: out of range cmd 0:0:7:707:ffffffff
hda-codec: out of range cmd 0:0:7:707:fffffffc
hda-codec: out of range cmd 0:0:7:707:ffffffbf
hda-codec: out of range cmd 0:0:7:707:ffffffff
hda-codec: out of range cmd 0:0:7:707:fffffffc
hda-codec: out of range cmd 0:0:7:707:ffffffff
hda-codec: out of range cmd 0:0:7:707:fffffffc
hda-codec: out of range cmd 0:0:7:707:ffffffbf
hda-codec: out of range cmd 0:0:4:707:ffffffff
hda-codec: out of range cmd 0:0:4:707:fffffffc
hda-codec: out of range cmd 0:0:4:707:ffffffff
hda-codec: out of range cmd 0:0:4:707:fffffffc
azx_single_send_cmd: 179 callbacks suppressed
hda-codec: out of range cmd 0:0:4:707:ffffffbf
hda-codec: out of range cmd 0:0:4:707:ffffffff
hda-codec: out of range cmd 0:0:4:707:fffffffc
hda-codec: out of range cmd 0:0:4:707:ffffffff
hda-codec: out of range cmd 0:0:4:707:fffffffc
hda-codec: out of range cmd 0:0:4:707:ffffffbf
hda-codec: out of range cmd 0:0:4:707:ffffffff
hda-codec: out of range cmd 0:0:4:707:fffffffc
hda-codec: out of range cmd 0:0:4:707:ffffffff
hda-codec: out of range cmd 0:0:4:707:fffffffc
hda-codec: out of range cmd 0:0:4:707:ffffffbf
hda-codec: out of range cmd 0:0:5:707:ffffffff
hda-codec: out of range cmd 0:0:5:707:fffffffc
hda-codec: out of range cmd 0:0:5:707:ffffffff
hda-codec: out of range cmd 0:0:5:707:fffffffc
hda-codec: out of range cmd 0:0:5:707:ffffffbf
hda-codec: out of range cmd 0:0:5:707:ffffffff
hda-codec: out of range cmd 0:0:5:707:fffffffc
hda-codec: out of range cmd 0:0:5:707:ffffffff
hda-codec: out of range cmd 0:0:5:707:fffffffc
hda-codec: out of range cmd 0:0:5:707:ffffffbf
hda-codec: out of range cmd 0:0:7:707:ffffffff
hda-codec: out of range cmd 0:0:7:707:fffffffc
hda-codec: out of range cmd 0:0:7:707:ffffffff
hda-codec: out of range cmd 0:0:7:707:fffffffc
hda-codec: out of range cmd 0:0:7:707:ffffffbf
hda-codec: out of range cmd 0:0:7:707:ffffffff
hda-codec: out of range cmd 0:0:7:707:fffffffc
hda-codec: out of range cmd 0:0:7:707:ffffffff
hda-codec: out of range cmd 0:0:7:707:fffffffc
hda-codec: out of range cmd 0:0:7:707:ffffffbf
--
Daniel J Blueman
