Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab2JNImm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 04:42:42 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:32929 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab2JNImj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 04:42:39 -0400
Date: Sun, 14 Oct 2012 10:41:38 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: dmarkh@cfl.rr.com
Cc: markh@compro.net, linux-kernel@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: Intel graphics drm issue?
Message-ID: <20121014104138.7e8a9c59@neptune.home>
In-Reply-To: <5079BE5C.8020401@cfl.rr.com>
References: <507812E8.3060607@compro.net>
	<20121012231459.166e29fd@neptune.home>
	<5079B97C.7020401@cfl.rr.com>
	<5079BE5C.8020401@cfl.rr.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sat, 13 October 2012 Mark Hounschell <dmarkh@cfl.rr.com> wrote:
> On 10/13/2012 02:57 PM, Mark Hounschell wrote:
> > On 10/12/2012 05:14 PM, Bruno Prémont wrote:
> >>> TV - LG 42lb9df
> >>> PC - intel DH77DF motherboard
> >>
> > I have another AMD based PC here with an nvidia card and HDMI port. Using
> > the nvidia driver, it boots up with no output to the tv until X starts.
> > Once X starts I get my kdm login screen. All is well except the resolution
> > is 800x600 and I have no VTs. I suspect if I had a properly configured
> > xorg.conf file, my resolution would be what I defined in it and work.
> >
> > Using the nouveau driver, I get nothing but "no signal" on the tv.  Just
> > like the the intel box, except no EDID messages in the log file. I've
> > attached a dmesg outputs for each config.
> >
> > Back on the Intel machine. I boot up with a normal monitor connected to the
> > DVI port of the PC. Then at the kdm login screen, I disconnect the DVI
> > cable from the PC and connect the TV to the PCs DVI port using a DVI/HDMI
> > adapter. I get a beautiful 1600x1200 resolution screen on the TV. This does
> > not happen using the PC HDMI port.
> >
> 
> One other thing I failed to mention. If i connect the TV HDMI to the Intel 
> boards DVI port using the adapter, at power up I get all the BIOS messages 
> and can enter the BIOS and all is fine. But when I let it boot all the way 
> up like this, I get nothing but "no signal" after leaving BIOS mode. 
> Turning the tv on/off, cable plug/unplug does not help.

Did you also try the DVI-HDMI adapter cable with the nVidia card?

But will all that info I would say the issues is at the side of you TV that
just does not provide (valid) EDID information, thus the driver does not know
what the display supports.

The 1600x1200 when switching DVI displays on Intel would seem like the driver
just kept on display what it had, not reconfiguring anything.

For the 800x600 of nVidia, that kind of the default fallback when display
capabilities are unknown as any remotely recent display should alt least be
capable to understand that.


Your best solution is probably to write an EDID blob (or reuse one you find
somewhere) that provides at least one mode matching your TV's native mode
(probably full-HD).

Google suggested the following document:
http://www.jordansmanuals.com/ServiceManuals%5CLG%5CTV%5CLCD%5C42LB9DF%5C42LB9DF%20Service%20Manual.pdf
which on page 13/14 shows the full EDID blob for the various HDMI outputs of the
TV. You may want to read that document, convert the EDID blobs to 512 bytes binary
files and hell DRM core to use the right one via module/kernel cmdline option:

 drm_kms_helper.edid_firmware=edid/lg42lb9df.edid
or
 modprobe drm-kms-helper edid_firmware=edid/lg42lb9df.edid

where
 /lib/firmware/edid/lg42lb9df.edid
is the 512-bytes EDID blob created according to data from above manual.
(note, that will only work for intel, radeon and nouveau drivers but will
 not work for closed drivers of AMD/nVidia)

PS: If you didn't already do so, try all of the HDMI connectors or the TV and
if available, also two distinct HDMI cables of different brand.

Bruno


> Mark
> 
> > I have no control over the tv with regards to stand-by mode. Off is standby
> > mode, on is on.
> >
> >>> [    2.434378] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
> >>> [    2.477539] checking generic (e0000000 3ff0000) vs hw (e0000000
> >>> 10000000)
> >>> [    2.477541] fb: conflicting fb hw usage inteldrmfb vs VESA VGA -
> >>> removing generic driver
> >>> [    2.477549] Console: switching to colour dummy device 80x25
> >>> [    2.477831] fbcon: inteldrmfb (fb0) is primary device
> >>> [    2.637915] Console: switching to colour frame buffer device 128x48
> >>> [    2.679625] fb0: inteldrmfb frame buffer device
> >>> [    2.679626] drm: registered panic notifier
> >>> [    2.691536] acpi device:4b: registered as cooling_device9
> >>> [    2.691660] input: Video Bus as
> >>> /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
> >>> [    2.691698] ACPI: Video Device [GFX0] (multi-head: yes  rom: no
> >>> post: no)
> >>> [    2.691709] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on
> >>> minor 0
> >>
> >>> geexbox:/home/mplayer # lspci
> >>> 00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core
> >>> processor DRAM Controller (rev 09)
> >>> ...
> >>> 00:02.0 VGA compatible controller: Intel Corporation Xeon E3-1200 v2/3rd
> >>> Gen Core processor Graphics Controller (rev 09)
> >>> ...
> >>
> >> Note, usually `lspci -nn` is more informative as it also provides
> >> vendor/device
> >> IDs in addition to nice names.
> >
> > # lspci -nn
> > 00:00.0 Host bridge [0600]: Intel Corporation Xeon E3-1200 v2/3rd Gen Core
> > processor DRAM Controller [8086:0150] (rev 09)
> > 00:01.0 PCI bridge [0604]: Intel Corporation Xeon E3-1200 v2/3rd Gen Core
> > processor PCI Express Root Port [8086:0151] (rev 09)
> > 00:02.0 VGA compatible controller [0300]: Intel Corporation Xeon E3-1200
> > v2/3rd Gen Core processor Graphics Controller [8086:0162] (rev 09)
> > 00:14.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series
> > Chipset Family USB xHCI Host Controller [8086:1e31] (rev 04)
> > 00:16.0 Communication controller [0780]: Intel Corporation 7 Series/C210
> > Series Chipset Family MEI Controller #1 [8086:1e3a] (rev 04)
> > 00:19.0 Ethernet controller [0200]: Intel Corporation 82579V Gigabit
> > Network Connection [8086:1503] (rev 04)
> > 00:1a.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series
> > Chipset Family USB Enhanced Host Controller #2 [8086:1e2d] (rev 04)
> > 00:1c.0 PCI bridge [0604]: Intel Corporation 7 Series/C210 Series Chipset
> > Family PCI Express Root Port 1 [8086:1e10] (rev c4)
> > 00:1c.7 PCI bridge [0604]: Intel Corporation 7 Series/C210 Series Chipset
> > Family PCI Express Root Port 8 [8086:1e1e] (rev c4)
> > 00:1d.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series
> > Chipset Family USB Enhanced Host Controller #1 [8086:1e26] (rev 04)
> > 00:1f.0 ISA bridge [0601]: Intel Corporation H77 Express Chipset LPC
> > Controller [8086:1e4a] (rev 04)
> > 00:1f.2 SATA controller [0106]: Intel Corporation 7 Series/C210 Series
> > Chipset Family 6-port SATA Controller [AHCI mode] [8086:1e02] (rev 04)
> > 00:1f.3 SMBus [0c05]: Intel Corporation 7 Series/C210 Series Chipset Family
> > SMBus Controller [8086:1e22] (rev 04)
> > 01:00.0 PCI bridge [0604]: PLX Technology, Inc. PEX8112 x1 Lane PCI
> > Express-to-PCI Bridge [10b5:8112] (rev aa)
> > 02:04.0 Multimedia audio controller [0401]: C-Media Electronics Inc CMI8788
> > [Oxygen HD Audio] [13f6:8788]
> >
> >
> > I can do more to help if asked.
> >
> > Regards
> > Mark
> 
> 
