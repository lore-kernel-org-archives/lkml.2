Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945Ab1EOMvH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 08:51:07 -0400
Received: from smtpout03.highway.telekom.at ([195.3.96.115]:12053 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753233Ab1EOMvD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 08:51:03 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: i915/kms/backlight-combo mode problem
Date: Sun, 15 May 2011 14:50:42 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.6; KDE/4.6.3; x86_64; ; )
Cc: "Joey Lee" <jlee@novell.com>, "Michael Chang" <MChang@novell.com>,
        chris@chris-wilson.co.uk, dri-devel@lists.freedesktop.org,
        tiwai@suse.de
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com> <BANLkTimQJM3N1WdBhYVOH0UyyOTFcxOfUQ@mail.gmail.com> <4DCE2D4D020000230002C96A@novprvlin0050.provo.novell.com>
In-Reply-To: <4DCE2D4D020000230002C96A@novprvlin0050.provo.novell.com>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105151450.48405@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

* Michael Chang -- Friday 13 May 2011:
> But there's more questions in my mind, made me feel not
> able to proceed any further.. :(

No problem. The reason for inconsistencies in my reports is
simply that I've realized some properties only later. So here's
a new error description, based on ddb503b42960, which is current
HEAD.


On this "Acer Travelmate 5735Z-452G32Mnss" the following happens
since after 2.6.37-rc8, with acpi_osi=Linux:

- the backlight goes dark as soon as KMS takes over early in the
  boot process (the screen contents aren't corrupted, though, and
  under appropriate lighting conditions I can even see the
  (very dark) uncorrupted contents.)

- when I press the "backlight darker" key, the backlight is turned
  on. (No other key does that AFAICS, including "display toggle"
  and "backlight brighter.)

Everything works correctly after that, including backlight adjustment,
BUT:

 - when I close the lid and open it again, the backlight stays black
   again, just like before. Backlight adjustment turns it on, and
   now even the "brighter" key does it sometimes, but not always.)



> 1. is_backlight_combination_mode() really returns 0x4 ..?

>From https://bugzilla.kernel.org/show_bug.cgi?id=31522, comment #8:
"It turned out that on this machine INTEL_INFO(dev)->gen equals 4,
and is_backlight_combination_mode() returns 0x40000000."

That was true when I reported it. But lpbc was always 0 in my tests
back then, and now it's not. 



> I understand your words, but if this is true then Joey Lee provided
> patch should log out some information about changing the LPBC
> 
>   set backlight lbpc = ...
> 
> but I didn't see any of the log output .. :(

You hadn't told me that these patches were meant to be incremental,
so I backed the first logging patch out before applying the other.
Here is the result of ddb503b42960 with both logging patches applied:

boot phase:
[    2.620237] [drm] Initialized drm 1.1.0 20060810
[    2.664806] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.664812] i915 0000:00:02.0: setting latency timer to 64
[    2.726569] [drm:intel_opregion_setup], graphic opregion physical addr: 0x7ba8c018
[    2.726612] [drm:intel_opregion_setup], Public ACPI methods supported
[    2.726615] [drm:intel_opregion_setup], SWSCI supported
[    2.726617] [drm:intel_opregion_setup], ASLE supported
[    2.726650] i915 0000:00:02.0: irq 44 for MSI/MSI-X
[    2.726655] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    2.726656] [drm] Driver supports precise vblank timestamp query.
[    2.753294] [drm:init_status_page], render ring hws offset: 0x00000000
[    2.753431] [drm:init_status_page], bsd ring hws offset: 0x00021000
[    2.753547] [drm:intel_parse_bios], Using VBT from OpRegion: $VBT CANTIGA        d
[    2.797315] [drm:intel_panel_get_backlight], get backlight val = 2890
[    2.797319] [drm:is_backlight_combination_mode], BLM_COMBINATION_MODE = 1073741824
[    2.797322] [drm:intel_panel_get_backlight], get backlight PWM = 0
[    2.797328] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    2.797658] [drm:intel_panel_set_backlight], set backlight PWM = 0
[    2.797661] [drm:is_backlight_combination_mode], BLM_COMBINATION_MODE = 1073741824
[    2.797664] [drm:is_backlight_combination_mode], BLM_COMBINATION_MODE = 1073741824
[    2.797667] [drm:intel_panel_get_max_backlight], max backlight PWM = 736950
[    2.797669] [drm:intel_panel_set_backlight], set backlight max = 736950
[    2.797671] [drm:intel_panel_set_backlight], set backlight lbpc = 1
[    2.797678] [drm:intel_opregion_asle_intr], non asle set request??
[    2.797681] [drm:intel_panel_set_backlight], set backlight tmp(1) = 189401930
[    2.797683] [drm:intel_panel_set_backlight], set backlight tmp(2) = 189399040
[    2.797685] [drm:intel_panel_set_backlight], set backlight level = 0
[    2.905962] scsi 4:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
[    3.040041] [drm:gm45_get_vblank_counter], trying to get vblank count for disabled pipe A
[    3.040047] [drm:gm45_get_vblank_counter], trying to get vblank count for disabled pipe A
[    3.090368] checking generic (80000000 3ff0000) vs hw (80000000 10000000)
[    3.090373] fb: conflicting fb hw usage inteldrmfb vs VESA VGA - removing generic driver
[    3.090392] Console: switching to colour dummy device 80x25
[    3.091058] fbcon: inteldrmfb (fb0) is primary device
[    3.125522] [drm:is_backlight_combination_mode], BLM_COMBINATION_MODE = 1073741824
[    3.125525] [drm:intel_panel_get_max_backlight], max backlight PWM = 736950
[    3.125527] [drm:intel_panel_set_backlight], set backlight PWM = 736950
[    3.125529] [drm:is_backlight_combination_mode], BLM_COMBINATION_MODE = 1073741824
[    3.125531] [drm:is_backlight_combination_mode], BLM_COMBINATION_MODE = 1073741824
[    3.125533] [drm:intel_panel_get_max_backlight], max backlight PWM = 736950
[    3.125535] [drm:intel_panel_set_backlight], set backlight max = 736950
[    3.125537] [drm:intel_panel_set_backlight], set backlight lbpc = 255
[    3.125541] [drm:intel_panel_set_backlight], set backlight tmp(1) = 189399040
[    3.125543] [drm:intel_panel_set_backlight], set backlight tmp(2) = 189399040
[    3.125544] [drm:intel_panel_set_backlight], set backlight level = 2890
[    3.125557] [drm:intel_opregion_asle_intr],
[    3.125559] Console: switching non asle set request??
[    3.125562] to colour frame buffer device 170x48
[    3.128264] fb0: inteldrmfb frame buffer device
[    3.128265] drm: registered panic notifier
[    3.429079] acpi device:07: registered as cooling_device2
[    3.429425] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input6
[    3.429521] ACPI: Video Device [OVGA] (multi-head: yes  rom: no  post: no)
[    3.429980] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    3.806479] sd 4:0:0:0: [sdb] 15720448 512-byte logical blocks: (8.04 GB/7.49 GiB)
[    3.807220] sd 4:0:0:0: [sdb] Write Protect is off
[    3.807222] sd 4:0:0:0: [sdb] Mode Sense: 03 00 00 00
[    3.807225] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[    3.809345] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[    3.813728]  sdb: sdb1
[    3.815475] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[    3.815513] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[    4.786309] md: linear personality registered for level -1
[   84.936637] [drm:is_backlight_combination_mode], BLM_COMBINATION_MODE = 1073741824
[   84.936641] [drm:intel_panel_get_max_backlight], max backlight PWM = 736950
[   84.936644] [drm:intel_panel_set_backlight], set backlight PWM = 72250
[   84.936646] [drm:is_backlight_combination_mode], BLM_COMBINATION_MODE = 1073741824
[   84.936649] [drm:is_backlight_combination_mode], BLM_COMBINATION_MODE = 1073741824
[   84.936652] [drm:intel_panel_get_max_backlight], max backlight PWM = 736950
[   84.936654] [drm:intel_panel_set_backlight], set backlight max = 736950
[   84.936656] [drm:intel_panel_set_backlight], set backlight lbpc = 25
[   84.936660] [drm:intel_panel_set_backlight], set backlight tmp(1) = 189401930
[   84.936662] [drm:intel_panel_set_backlight], set backlight tmp(2) = 189399040
[   84.936664] [drm:intel_panel_set_backlight], set backlight level = 2890
[   84.936669] [drm:intel_opregion_asle_intr], non asle set request??
[   84.936672] [drm:intel_opregion_asle_intr], non asle set request??

brighter:
[  325.356259] [drm:is_backlight_combination_mode], BLM_COMBINATION_MODE = 1073741824
[  325.356268] [drm:intel_panel_get_max_backlight], max backlight PWM = 736950
[  325.356273] [drm:intel_panel_set_backlight], set backlight PWM = 0
[  325.356278] [drm:is_backlight_combination_mode], BLM_COMBINATION_MODE = 1073741824
[  325.356283] [drm:is_backlight_combination_mode], BLM_COMBINATION_MODE = 1073741824
[  325.356288] [drm:intel_panel_get_max_backlight], max backlight PWM = 736950
[  325.356292] [drm:intel_panel_set_backlight], set backlight max = 736950
[  325.356297] [drm:intel_panel_set_backlight], set backlight lbpc = 1
[  325.356302] [drm:intel_panel_set_backlight], set backlight tmp(1) = 189401930
[  325.356307] [drm:intel_panel_set_backlight], set backlight tmp(2) = 189399040
[  325.356311] [drm:intel_panel_set_backlight], set backlight level = 0
[  325.356318] [drm:intel_opregion_asle_intr], non asle set request??
[  325.356324] [drm:intel_opregion_asle_intr], non asle set request??

darker:
[  359.642417] [drm:is_backlight_combination_mode], BLM_COMBINATION_MODE = 1073741824
[  359.642424] [drm:intel_panel_get_max_backlight], max backlight PWM = 736950
[  359.642429] [drm:intel_panel_set_backlight], set backlight PWM = 72250
[  359.642434] [drm:is_backlight_combination_mode], BLM_COMBINATION_MODE = 1073741824
[  359.642439] [drm:is_backlight_combination_mode], BLM_COMBINATION_MODE = 1073741824
[  359.642443] [drm:intel_panel_get_max_backlight], max backlight PWM = 736950
[  359.642448] [drm:intel_panel_set_backlight], set backlight max = 736950
[  359.642452] [drm:intel_panel_set_backlight], set backlight lbpc = 25
[  359.642458] [drm:intel_panel_set_backlight], set backlight tmp(1) = 189399040
[  359.642463] [drm:intel_panel_set_backlight], set backlight tmp(2) = 189399040
[  359.642467] [drm:intel_panel_set_backlight], set backlight level = 2890
[  359.642474] [drm:intel_opregion_asle_intr], non asle set request??
[  359.642480] [drm:intel_opregion_asle_intr], non asle set request??


 
> http://marc.info/?l=linux-kernel&m=130462815211684&w=2
> 
> If you rebase this patch to your currently git commit, will it fixes
> all problems [...]

This patch didn't fix my problems back then, and since an always zeroed lbpc
is apparently not the case, I assume this test wouldn't be very helpful. Of
course, if you insist, then I'll try it again. 

Thanks for your help, and sorry for the confusion.  :-)
m.
