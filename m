Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab1AYLuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:50:55 -0500
Received: from mailout10.t-online.de ([194.25.134.21]:37888 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1AYLuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:50:54 -0500
Message-ID: <4D3EB90C.9020901@t-online.de>
Date: Tue, 25 Jan 2011 12:50:36 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: jesse.barnes@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG/REGRESSION] DRM / i915 / 2.6.37 and 2.6.38-rc*: DVI output
 gets disabled/reenabled under load
References: <4D3DC997.5040605@t-online.de> <0d30dc$krk6f6@orsmga001.jf.intel.com>
In-Reply-To: <0d30dc$krk6f6@orsmga001.jf.intel.com>
Content-Type: multipart/mixed;
 boundary="------------020700030605080709040608"
X-ID: T5MbGuZOYh2-Dt8Azu0gqprRegub1-yB4khn7AP9Gix0d0kBxkBL7hiLc3LvdCKZIS
X-TOI-MSGID: a294dab5-4fde-4bbf-b1af-07ed8fba4323
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020700030605080709040608
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Am 24.01.2011 20:13, schrieb Chris Wilson:
> On Mon, 24 Jan 2011 19:48:55 +0100, Knut Petersen <Knut_Petersen@t-online.de> wrote:
>   
>> On an AOpen i915GMm-HFS I see the following problem:
>> The LCD panel connected to DVI-1 gets disabled and then reenabled
>> under high system load (e.g. -j 15 kernel compile) if I am working on the
>> framebuffer console (no problems in X).
>>     
> DVI detection is essentially retrieving the EDID by bitbanging on the DDC.
> This is timing sensitive and I suspect that is being interrupted by the
> system activity causing the EDID data to be returned corrupted. Is that
> supported by any warnings in dmesg? Does increasing the drm.debug level to
> 0x6 reveal any more significant information?
>
>   

KERNEL 2.6.36.3
==============
Attached to this msg is LOG 2.6.36.3. Everything looks fine, every 10
seconds
an additional message group is added. No distortions.

KERNEL 2.6.38-rc2
================

LOG-2.6.38-rc2 is different. The kernel is a pure kernel 2.6.38-rc2 with one
exception: I changed  DRM_OUTPUT_POLL_PERIOD  to 3*HZ to increase
error probability.

At log time [  678.598641]  you can see the status change of the VGA-2
connector (there is no physical VGA-2 connector on that mobo).

After that a hotplug event is generated. Ok, that could be reasonable,
but as
you see the other connectors are also affected by that event. I cannot
tell the
exact moment, but during processing that hotplug event there is a period
with
no (or maybe a distorted) signal on the DVI-1 connector.

Both logs where taken on a busy system doing a make -j 15 kernel compile,
debuglevel 15, framebuffer console, no X running.

I admit that I had not the time to study the code and hardware
references in detail,
but a few questions / thoughts come to my mind.

1: I suspect that it is not a timing problem because only VGA-2 (no
physical connector)
is affected. The status of VGA-1 and DVI-1 (with physical connectors) 
seems to
be absolutely stable. Guess: Maybe a hardware problem like missing
termination ?
There are  few systems with 2 real VGA connectors ... there could be
more systems with
that problem if my guess is right.

2: We should not care if connector status changes between "unknown" and
"disconnected". We should only care about status changes from/to "connected"
and generate hotplug events only in that case. That should solve my
problem and
would break nothing. Am I right?

3: It's wrong that a status change on one connector generates a hotplug
event
that affects all connectors ...


I think LOG-2.6.38-rc2 shows a sign of an additional bug
===========================================
[  681.527815] [drm:drm_target_preferred], found mode 1280x1024
[  681.531482] [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config

Is 4096x4096 really reasonable? I don't think so, at least not for my
hardware.

After connecting a monitor to both the DVI and VGA connectors it can use
xrandr
to set different viewing areas for the monitors. But although X also
reports that
maximum 4096x4096 screen size it is not usable. X will crash as soon as
I try to use a combined x-resolution above 2048. I remember that I read
somewhere
that this is a hardware limit of my hardware. Is X taking the maximum
screen resolution
from the kernel? I think so. So the kernel should not use a screen
config that is beyond
hardware limits.
 
lspci:

00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML
Express Processor to DRAM Controller (rev 04)
00:02.0 VGA compatible controller: Intel Corporation Mobile
915GM/GMS/910GML Express Graphics Controller (rev 04)
00:02.1 Display controller: Intel Corporation Mobile 915GM/GMS/910GML
Express Graphics Controller (rev 04)
00:1b.0 Audio device: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) High Definition Audio Controller (rev 04)
00:1c.0 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) PCI Express Port 1 (rev 04)
00:1c.1 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) PCI Express Port 2 (rev 04)
00:1c.2 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) PCI Express Port 3 (rev 04)
00:1c.3 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) PCI Express Port 4 (rev 04)
00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #1 (rev 04)
00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #2 (rev 04)
00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #3 (rev 04)
00:1d.3 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #4 (rev 04)
00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB2 EHCI Controller (rev 04)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev d4)
00:1f.0 ISA bridge: Intel Corporation 82801FBM (ICH6M) LPC Interface
Bridge (rev 04)
00:1f.1 IDE interface: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) IDE Controller (rev 04)
00:1f.2 IDE interface: Intel Corporation 82801FBM (ICH6M) SATA
Controller (rev 04)
00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
SMBus Controller (rev 04)
02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E
Gigabit Ethernet Controller (rev 19)
03:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E
Gigabit Ethernet Controller (rev 19)
05:03.0 FireWire (IEEE 1394): Agere Systems FW322/323 (rev 61)

Knut

--------------020700030605080709040608
Content-Type: text/plain;
 name="LOG-2.6.36.3"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="LOG-2.6.36.3"

[  181.512921] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  181.615155] [drm:intel_sdvo_debug_response], SDVOB: R: 01 00                   (Success)
[  181.615165] [drm:intel_sdvo_detect], SDVO response 1 0
[  181.615172] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  181.739341] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  182.611632] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  182.919915] [drm:intel_sdvo_debug_response], SDVOC: R: 00 00                   (Success)
[  182.919927] [drm:intel_sdvo_detect], SDVO response 0 0

[  192.933002] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  192.990014] [drm:intel_sdvo_debug_response], SDVOB: R: 01 00                   (Success)
[  192.990026] [drm:intel_sdvo_detect], SDVO response 1 0
[  192.990033] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  193.027223] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  193.402792] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  193.515538] [drm:intel_sdvo_debug_response], SDVOC: R: 00 00                   (Success)
[  193.515548] [drm:intel_sdvo_detect], SDVO response 0 0

[  203.526039] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  203.582862] [drm:intel_sdvo_debug_response], SDVOB: R: 01 00                   (Success)
[  203.582874] [drm:intel_sdvo_detect], SDVO response 1 0
[  203.582881] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  203.631752] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  204.021732] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  204.161781] [drm:intel_sdvo_debug_response], SDVOC: R: 00 00                   (Success)
[  204.161793] [drm:intel_sdvo_detect], SDVO response 0 0

[  214.181105] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  214.225049] [drm:intel_sdvo_debug_response], SDVOB: R: 01 00                   (Success)
[  214.225060] [drm:intel_sdvo_detect], SDVO response 1 0
[  214.225067] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  214.279828] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  214.667666] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  214.748316] [drm:intel_sdvo_debug_response], SDVOC: R: 00 00                   (Success)
[  214.748327] [drm:intel_sdvo_detect], SDVO response 0 0

--------------020700030605080709040608
Content-Type: text/plain;
 name="LOG-2.6.38-rc2"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="LOG-2.6.38-rc2"

[  671.152494] [drm:output_poll_execute], [CONNECTOR:5:VGA-1] status updated from 2 to 2
[  671.155709] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  671.163757] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[  671.184024] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[  671.187225] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  671.203937] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  671.360941] [drm:output_poll_execute], [CONNECTOR:8:DVI-D-1] status updated from 1 to 1
[  671.368025] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  671.392324] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[  671.395585] [drm:output_poll_execute], [CONNECTOR:44:VGA-2] status updated from 3 to 3

[  674.428925] [drm:output_poll_execute], [CONNECTOR:5:VGA-1] status updated from 2 to 2
[  674.450552] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  674.467370] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[  674.494216] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[  674.500046] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  674.525550] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  674.664722] [drm:output_poll_execute], [CONNECTOR:8:DVI-D-1] status updated from 1 to 1
[  674.667916] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  674.721883] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[  674.736528] [drm:output_poll_execute], [CONNECTOR:44:VGA-2] status updated from 3 to 3

[  677.748021] [drm:output_poll_execute], [CONNECTOR:5:VGA-1] status updated from 2 to 2
[  677.751234] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  677.772763] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[  677.803463] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[  677.827596] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  677.866445] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  678.303984] [drm:output_poll_execute], [CONNECTOR:8:DVI-D-1] status updated from 1 to 1
[  678.346999] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  678.553774] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  678.581302] [drm:intel_sdvo_detect], SDVO response 0 0 [2]
[  678.598641] [drm:output_poll_execute], [CONNECTOR:44:VGA-2] status updated from 3 to 2

[  678.604871] [drm:drm_sysfs_hotplug_event], generating hotplug event
[  678.618793] [drm:drm_fb_helper_hotplug_event], 
[  678.628888] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[  678.654238] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[  678.663275] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[  678.680374] [drm:drm_calc_vbltimestamp_from_scanoutpos], crtc 1 : v 5 p(329,361)@ 1295947882.912751 -> 1295947882.907025 [e 2 us, 0 rep]
[  678.708771] [drm:intel_update_fbc], 
[  678.718017] [drm:intel_update_watermarks], plane B (pipe 0) clock: 108000
[  678.725996] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[  678.733867] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[  678.741717] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[  678.749794] [drm:intel_calculate_wm], FIFO watermark level: 26
[  678.756453] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[  678.759577] [drm:intel_calculate_wm], FIFO watermark level: -5
[  678.769618] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 1
[  678.777813] [drm:i9xx_update_wm], self-refresh entries: 80
[  678.785658] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 1, C: 2, SR 15
[  678.800023] [drm:drm_vblank_get], enabling vblank on crtc 1, ret: -22
[  678.803328] [drm:intel_crtc_mode_set], Mode for pipe B:
[  678.808800] [drm:drm_mode_debug_printmodeline], Modeline 0:"640x480" 0 31500 640 664 704 832 480 489 491 520 0x10 0xa
[  678.824024] [drm:intel_pipe_set_base], No FB bound
[  678.827132] [drm:intel_update_watermarks], plane B (pipe 0) clock: 108000
[  678.837557] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[  678.848017] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[  678.851051] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[  678.866902] [drm:intel_calculate_wm], FIFO watermark level: 26
[  678.870126] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[  678.884043] [drm:intel_calculate_wm], FIFO watermark level: -5
[  678.887050] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 1
[  678.898538] [drm:i9xx_update_wm], self-refresh entries: 80
[  678.904580] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 1, C: 2, SR 15
[  678.907503] [drm:drm_crtc_helper_set_mode], [ENCODER:6:DAC-6] set [MODE:0:640x480]
[  678.917001] [drm:intel_update_watermarks], plane B (pipe 0) clock: 108000
[  678.919944] [drm:intel_update_watermarks], plane A (pipe 1) clock: 31500
[  678.932035] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[  678.934922] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[  678.946432] [drm:intel_calculate_wm], FIFO entries required for mode: 10
[  678.953805] [drm:intel_calculate_wm], FIFO watermark level: 16
[  678.961781] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[  678.977092] [drm:intel_calculate_wm], FIFO watermark level: -5
[  678.979854] [drm:i9xx_update_wm], FIFO watermarks - A: 16, B: 1
[  678.988110] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 16, B: 1, C: 2, SR 1
[  678.990879] [drm:intel_update_fbc], 
[  679.004941] [drm:drm_calc_timestamping_constants], crtc 4: hwmode: htotal 832, vtotal 520, vdisplay 480
[  679.007723] [drm:drm_calc_timestamping_constants], crtc 4: clock 31500 kHz framedur 13734240 linedur 26412, pixeldur 31
[  679.037015] [drm:intel_crt_load_detect], starting load-detect on CRT
[  679.068052] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[  679.083385] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] disconnected
[  679.112709] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1]
[  679.115522] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  679.131696] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[  679.171012] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[  679.177632] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  679.209267] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  679.566246] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  679.633527] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  680.003280] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1] probed modes :
[  680.032347] [drm:drm_mode_debug_printmodeline], Modeline 61:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[  680.035247] [drm:drm_mode_debug_printmodeline], Modeline 65:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[  680.060059] [drm:drm_mode_debug_printmodeline], Modeline 62:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[  680.062824] [drm:drm_mode_debug_printmodeline], Modeline 63:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[  680.097908] [drm:drm_mode_debug_printmodeline], Modeline 64:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[  680.112033] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:SVIDEO-1]
[  680.114768] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  680.321398] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  680.349479] [drm:intel_sdvo_detect], SDVO response 0 0 [8]
[  680.357345] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:SVIDEO-1] disconnected
[  680.369126] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:SVIDEO-2]
[  680.371855] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  680.417190] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[  680.419880] [drm:intel_sdvo_debug_write], SDVOC: W: 11 00 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[  680.450190] [drm:intel_sdvo_write_cmd], command returns response Invalid arg [3]
[  680.468113] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:44:VGA-2]
[  680.470894] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  680.511776] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[  680.524023] [drm:intel_sdvo_debug_write], SDVOC: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  680.556503] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:45:SVIDEO-3]
[  680.559416] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[  680.572068] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[  680.589252] [drm:drm_calc_vbltimestamp_from_scanoutpos], crtc 1 : v 5 p(127,386)@ 1295947884.821631 -> 1295947884.811432 [e 2 us, 0 rep]
[  680.624239] [drm:intel_update_fbc], 
[  680.627278] [drm:intel_update_watermarks], plane B (pipe 0) clock: 108000
[  680.639009] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[  680.648029] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[  680.650937] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[  680.662810] [drm:intel_calculate_wm], FIFO watermark level: 26
[  680.669489] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[  680.682378] [drm:intel_calculate_wm], FIFO watermark level: -5
[  680.693302] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 1
[  680.701239] [drm:i9xx_update_wm], self-refresh entries: 80
[  680.714881] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 1, C: 2, SR 15
[  680.721110] [drm:drm_vblank_get], enabling vblank on crtc 1, ret: -22
[  680.737117] [drm:intel_crtc_mode_set], Mode for pipe B:
[  680.760451] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[  680.778107] [drm:intel_pipe_set_base], No FB bound
[  680.790444] [drm:intel_update_watermarks], plane B (pipe 0) clock: 108000
[  680.804030] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[  680.807079] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[  680.832023] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[  680.835064] [drm:intel_calculate_wm], FIFO watermark level: 26
[  680.855509] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[  680.861940] [drm:intel_calculate_wm], FIFO watermark level: -5
[  680.878730] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 1
[  680.888062] [drm:i9xx_update_wm], self-refresh entries: 80
[  680.919017] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 1, C: 2, SR 15
[  680.926102] [drm:drm_crtc_helper_set_mode], [ENCODER:46:TV-46] set [MODE:0:NTSC 480i]
[  681.024988] [drm:intel_update_watermarks], plane B (pipe 0) clock: 108000
[  681.049767] [drm:intel_update_watermarks], plane A (pipe 1) clock: 107520
[  681.068044] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[  681.071009] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[  681.097603] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[  681.116322] [drm:intel_calculate_wm], FIFO watermark level: -8
[  681.119205] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[  681.145340] [drm:intel_calculate_wm], FIFO watermark level: -5
[  681.168046] [drm:i9xx_update_wm], FIFO watermarks - A: 1, B: 1
[  681.170864] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 1, B: 1, C: 2, SR 1
[  681.202547] [drm:intel_update_fbc], 
[  681.223374] [drm:drm_calc_timestamping_constants], crtc 4: hwmode: htotal 1712, vtotal 1104, vdisplay 1024
[  681.227767] [drm:drm_calc_timestamping_constants], crtc 4: clock 108000 kHz framedur 17499504 linedur 15851, pixeldur 9
[  681.308034] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[  681.345456] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:45:SVIDEO-3] disconnected
[  681.392038] [drm:drm_setup_crtcs], 
[  681.416137] [drm:drm_enable_connectors], connector 5 enabled? no
[  681.419072] [drm:drm_enable_connectors], connector 8 enabled? yes
[  681.448859] [drm:drm_enable_connectors], connector 10 enabled? no
[  681.451740] [drm:drm_enable_connectors], connector 27 enabled? no
[  681.477439] [drm:drm_enable_connectors], connector 44 enabled? no
[  681.493210] [drm:drm_enable_connectors], connector 45 enabled? no
[  681.495922] [drm:drm_target_preferred], looking for cmdline mode on connector 8
[  681.518773] [drm:drm_target_preferred], looking for preferred mode on connector 8
[  681.527815] [drm:drm_target_preferred], found mode 1280x1024
[  681.531482] [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
[  681.553389] [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 3
[  681.571369] [drm:drm_crtc_helper_set_config], 
[  681.578657] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:67] #connectors=1 (x y) (0 0)
[  681.592922] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[  681.595533] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[  681.615169] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[  681.623390] [drm:drm_mode_debug_printmodeline], Modeline 66:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[  681.631568] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[  681.651445] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[  681.679492] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[  681.733722] [drm:drm_calc_vbltimestamp_from_scanoutpos], crtc 0 : v 5 p(1041,424)@ 1295947885.966098 -> 1295947885.959461 [e 2 us, 0 rep]
[  681.807832] [drm:intel_update_fbc], 
[  681.811159] [drm:intel_update_watermarks], plane A (pipe 1) clock: 107520
[  681.827995] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[  681.830579] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[  681.850640] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[  681.854871] [drm:intel_calculate_wm], FIFO watermark level: -8
[  681.868920] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[  681.871448] [drm:intel_calculate_wm], FIFO watermark level: 29
[  681.878698] [drm:i9xx_update_wm], FIFO watermarks - A: 1, B: 29
[  681.909170] [drm:i9xx_update_wm], self-refresh entries: 80
[  681.911737] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 1, B: 29, C: 2, SR 15
[  681.936353] [drm:drm_vblank_get], enabling vblank on crtc 0, ret: -22
[  681.939077] [drm:intel_crtc_mode_set], Mode for pipe A:
[  681.964047] [drm:drm_mode_debug_printmodeline], Modeline 66:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[  681.984036] [drm:intel_pipe_set_base_atomic], Writing base 00020000 00000000 0 0 5120
[  681.986572] [drm:intel_update_fbc], 
[  682.020049] [drm:intel_update_watermarks], plane A (pipe 1) clock: 107520
[  682.022589] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[  682.038559] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[  682.048026] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[  682.050571] [drm:intel_calculate_wm], FIFO watermark level: -8
[  682.074684] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[  682.083768] [drm:intel_calculate_wm], FIFO watermark level: 29
[  682.087276] [drm:i9xx_update_wm], FIFO watermarks - A: 1, B: 29
[  682.106667] [drm:i9xx_update_wm], self-refresh entries: 80
[  682.116042] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 1, B: 29, C: 2, SR 15
[  682.118579] [drm:drm_crtc_helper_set_mode], [ENCODER:7:TMDS-7] set [MODE:66:1280x1024]
[  682.142852] [drm:intel_sdvo_debug_write], SDVOB: W: 07 01 00 00 00             (SDVO_CMD_SET_IN_OUT_MAP)
[  682.178355] [drm:intel_sdvo_debug_write], SDVOB: W: 11 01 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[  682.211647] [drm:intel_sdvo_debug_write], SDVOB: W: 11 01 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[  682.243067] [drm:intel_sdvo_debug_write], SDVOB: W: 16 30 2A 00 98 51 00 2A 40 (SDVO_CMD_SET_OUTPUT_TIMINGS_PART1)
[  682.301011] [drm:intel_sdvo_debug_write], SDVOB: W: 17 30 70 13 00 1E 00 00 00 (SDVO_CMD_SET_OUTPUT_TIMINGS_PART2)
[  682.345382] [drm:intel_sdvo_debug_write], SDVOB: W: 10 00                      (SDVO_CMD_SET_TARGET_INPUT)
[  682.376561] [drm:intel_sdvo_debug_write], SDVOB: W: 9F 00                      (SDVO_CMD_SET_ENCODE)
[  682.397544] [drm:intel_sdvo_write_cmd], command returns response Not supported [2]
[  682.408047] [drm:intel_sdvo_debug_write], SDVOB: W: 14 30 2A 00 98 51 00 2A 40 (SDVO_CMD_SET_INPUT_TIMINGS_PART1)
[  682.455723] [drm:intel_sdvo_debug_write], SDVOB: W: 15 30 70 13 00 1E 00 00 00 (SDVO_CMD_SET_INPUT_TIMINGS_PART2)
[  682.499532] [drm:intel_sdvo_debug_write], SDVOB: W: 21 01                      (SDVO_CMD_SET_CLOCK_RATE_MULT)
[  682.530029] [drm:intel_update_watermarks], plane B (pipe 0) clock: 108000
[  682.536183] [drm:intel_update_watermarks], plane A (pipe 1) clock: 107520
[  682.548049] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[  682.550524] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[  682.564886] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[  682.567304] [drm:intel_calculate_wm], FIFO watermark level: -8
[  682.575026] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[  682.584028] [drm:intel_calculate_wm], FIFO watermark level: -5
[  682.586487] [drm:i9xx_update_wm], FIFO watermarks - A: 1, B: 1
[  682.601206] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 1, B: 1, C: 2, SR 1
[  682.603914] [drm:intel_update_fbc], 
[  682.640163] [drm:intel_sdvo_debug_write], SDVOB: W: 03                         (SDVO_CMD_GET_TRAINED_INPUTS)
[  682.667224] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01
[  682.695589] [drm:intel_sdvo_debug_write], SDVOB: W: 05 01 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[  682.723567] [drm:drm_calc_timestamping_constants], crtc 3: hwmode: htotal 1688, vtotal 1066, vdisplay 1024
[  682.742433] [drm:drm_calc_timestamping_constants], crtc 3: clock 108000 kHz framedur 16660514 linedur 15629, pixeldur 9
[  682.751532] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[  682.786425] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[  682.808050] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:8:DVI-D-1] set DPMS on
[  682.810762] [drm:drm_crtc_helper_set_config], 
[  682.835094] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:67] #connectors=0 (x y) (0 0)
[  682.840599] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[  682.843204] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[  682.859924] [drm:intel_sdvo_debug_write], SDVOC: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[  682.891197] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on

[  682.926640] [drm:output_poll_execute], [CONNECTOR:5:VGA-1] status updated from 2 to 2
[  682.932969] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  682.964877] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[  682.987600] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[  683.008411] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  683.030942] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  683.221578] [drm:output_poll_execute], [CONNECTOR:8:DVI-D-1] status updated from 1 to 1
[  683.236022] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  683.263025] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
[  683.269816] [drm:output_poll_execute], [CONNECTOR:44:VGA-2] status updated from 3 to 3

--------------020700030605080709040608--
