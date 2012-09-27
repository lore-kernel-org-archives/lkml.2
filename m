Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab2I0GqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:46:11 -0400
Received: from mail.anarazel.de ([217.115.131.40]:36968 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab2I0GqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:46:09 -0400
From: Andres Freund <andres@anarazel.de>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: Re: radeon: Regression between v3.6-rc4 and v3.6-rc6: unable to allocate a PPLL
Date: Thu, 27 Sep 2012 08:46:00 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc7-andres-00112-g2710a2b-dirty; KDE/4.8.4; x86_64; ; )
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
References: <201209171329.15699.andres@anarazel.de> <201209261541.09835.andres@anarazel.de> <A3397C8B8B789E45844E7EC5DEAD89D02C435787@sausexdag03.amd.com>
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D02C435787@sausexdag03.amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209270846.00376.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 26, 2012 03:42:40 PM Deucher, Alexander wrote:
> > -----Original Message-----
> > From: Andres Freund [mailto:andres@anarazel.de]
> > Sent: Wednesday, September 26, 2012 9:41 AM
> > To: Dan Carpenter
> > Cc: Deucher, Alexander; LKML; David Airlie;
> > dri-devel@lists.freedesktop.org Subject: Re: radeon: Regression between
> > v3.6-rc4 and v3.6-rc6: unable to allocate a PPLL
> > 
> > On Wednesday, September 26, 2012 03:00:09 PM Dan Carpenter wrote:
> > > This is fixed now?
> > 
> > Its been reverted in 2f1f4d9b60396d2df4cff829bd5376ffc8ed9a2c which is in
> > rc6.
> > 
> > On Monday, September 17, 2012 09:30:12 PM Deucher, Alexander wrote:
> > Sorry, I somehow accidentally marked your  email as read and thus didn't
> > notice it.
> > 
> > > I think I see the problem.  I think it's a limitation of the current
> > > current
> > 
> > modesetting API.  The current API sets up each display independently
> > which doesn't work so well if there are resource restrictions.  There
> > shouldn't be any contention on your board since you are only using 2
> > non-DP displays.  It looks like X is mapping different crtcs to displays
> > than the kernel fb.
> > 
> > Initially the kernel set up the follow:
> > > > [    2.134901] [drm] crtc 0 using pll 0x2
> > > > [    2.362257] [drm] crtc 1 using pll 0x1
> > > > [    2.386709] [drm] crtc 2 using pll 0x0
> > > 
> > > Crtc 0 -> DCPLL -> DP
> > > Crtc 1 -> PPLL2 -> DVI
> > > Crtc 2 -> PPLL1 -> DVI
> > > 
> > > When X loads, it tried to set a different crtc to display mapping:
> > > > [   60.679310] [drm] crtc 0 using pll 0xff
> > > > [   60.789183] [drm] crtc 1 using pll 0x2
> > > > [   60.819594] [drm] crtc 2 using pll 0x1
> > > 
> > > Crtc 0 -> INVALID -> DVI 0
> > > Crtc 1 -> DCPLL -> DP
> > > Crtc 2 -> PPLL2 -> DVI 1
> > > 
> > > Crtc 0 should have used PPLL1 or PPLL2, but they were already in use by
> > > crtc 1 and crtc  2 from the previous modeset.  Since the modeset API is
> > > not atomic, it doesn't have the whole picture.  I'm not sure of a good
> > > solution right now prior to the new atomic modeset API that is under
> > > discussion.  I guess we can revert the patch for 3.6.  For 3.7 I guess
> > > we need to validate the actual connector to make sure we aren't trying
> > > to set a different configuration relating to the same connector
> > > without first tearing down the first one.  In the interim, you should
> > > be able to work around it by disabling the non-DP outputs and then
> > > bringing than back up.
> > 
> > Thanks! That explanation makes sense. I can work around it just fine,
> > starting X multiple times works which coincides nicely with your
> > explanation.
> > 
> > The code in the 3.7 branch doesn't do that extended validation yet,
> > rigth? If you want/need you can CC for testing once thats ready.
> 
> It should handle it now.  If you could test it that would be great.
Ok, just to be sure I tested Linus' tree and everything works fine there.

Unfortunately thats not the case with a straight merge of alexdeucher/drm-
next-3.7-wip. When gdm started *the first time* the DVI-connected (uhm, same 
sink type? Thats the saphire magic allowing more monitors on that type of 
graphics card?) I got a "unable to allocate a PPLL" error again. Logging 
in/starting a new X seems to fix that.

I have no clue, but the ppll allocation looks a bit funny:

[    1.845444] [drm] Initialized drm 1.1.0 20060810
[    1.869015] [drm] radeon defaulting to kernel modesetting.
[    1.892300] [drm] radeon kernel modesetting enabled.
[    1.915260] fb: conflicting fb hw usage radeondrmfb vs VGA16 VGA - removing 
generic driver
[    1.984746] [drm] initializing kernel modesetting (BARTS 0x1002:0x6738 
0x174B:0x174B).
[    1.985248] [drm] register mmio base: 0xFBEC0000
[    1.985448] [drm] register mmio size: 131072
[    1.986784] [drm] Detected VRAM RAM=1024M, BAR=256M
[    1.986975] [drm] RAM width 256bits DDR
[    1.988070] [drm] radeon: 1024M of VRAM memory ready
[    1.988271] [drm] radeon: 512M of GTT memory ready.
[    1.988478] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.988679] [drm] Driver supports precise vblank timestamp query.
[    1.989150] [drm] radeon: irq initialized.
[    1.989353] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    1.990123] [drm] probing gen 2 caps for device 8086:340a = 2/0
[    1.990321] [drm] enabling PCIE gen 2 link speeds, disable with 
radeon.pcie_gen2=0
[    1.990825] [drm] Loading BARTS Microcode
[    3.246281] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[    3.263969] [drm] ring test on 0 succeeded in 3 usecs
[    3.264466] [drm] ib test on ring 0 succeeded in 0 usecs
[    3.265168] [drm] Radeon Display Connectors
[    3.265357] [drm] Connector 0:
[    3.265544] [drm]   DP-1
[    3.265746] [drm]   HPD4
[    3.265939] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 
0x643c
[    3.266206] [drm]   Encoders:
[    3.266397] [drm]     DFP1: INTERNAL_UNIPHY2
[    3.266581] [drm] Connector 1:
[    3.266764] [drm]   HDMI-A-1
[    3.266950] [drm]   HPD3
[    3.267134] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468 0x646c 
0x646c
[    3.267405] [drm]   Encoders:
[    3.267593] [drm]     DFP2: INTERNAL_UNIPHY2
[    3.267781] [drm] Connector 2:
[    3.267966] [drm]   DVI-D-1
[    3.268151] [drm]   HPD1
[    3.268335] [drm]   DDC: 0x6480 0x6480 0x6484 0x6484 0x6488 0x6488 0x648c 
0x648c
[    3.268609] [drm]   Encoders:
[    3.268795] [drm]     DFP3: INTERNAL_UNIPHY1
[    3.268982] [drm] Connector 3:
[    3.269180] [drm]   DVI-I-1
[    3.269366] [drm]   HPD6
[    3.269551] [drm]   DDC: 0x6470 0x6470 0x6474 0x6474 0x6478 0x6478 0x647c 
0x647c
[    3.269827] [drm]   Encoders:
[    3.270011] [drm]     DFP4: INTERNAL_UNIPHY
[    3.270197] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    3.270487] [drm] Internal thermal controller with fan control
[    3.271844] [drm] radeon: power management initialized
[    3.282342] [drm] DP sink type 0x13
[    3.393981] [drm] fb mappable at 0xD0142000
[    3.394107] [drm] vram apper at 0xD0000000
[    3.394235] [drm] size 16384000
[    3.394362] [drm] fb depth is 24
[    3.394487] [drm]    pitch is 10240
[    3.394674] fbcon: radeondrmfb (fb0) is primary device
[    3.395218] [drm] crtc 0 using pll 0x2
[    3.622463] [drm] crtc 1 using pll 0x1
[    3.646905] [drm] crtc 2 using pll 0x0
[    3.732561] fb0: radeondrmfb frame buffer device
[    3.732585] drm: registered panic notifier
[    3.732610] [drm] Initialized radeon 2.24.0 20080528 for 0000:08:00.0 on 
minor 0
[   63.352921] [drm] DP sink type 0x13
[   63.499399] [drm] DP sink type 0x13
[   64.574889] [drm:radeon_atom_pick_pll] *ERROR* unable to allocate a PPLL
[   64.574895] [drm:drm_crtc_helper_set_config] *ERROR* failed to set mode on 
[CRTC:10]
[   64.574921] [drm] crtc 0 using pll 0x2
[   64.621784] [drm] crtc 1 using pll 0x2
[   64.712236] [drm] crtc 2 using pll 0x1
[   66.075266] [drm] DP sink type 0x13
[   76.365428] [drm] DP sink type 0x13
[   77.217333] [drm] DP sink type 0x13
[  163.510596] [drm] DP sink type 0x13
[  163.637010] [drm] DP sink type 0x13
[  163.734771] [drm] crtc 0 using pll 0x0
[  163.794607] [drm] crtc 0 using pll 0x2
[  163.860506] [drm] crtc 1 using pll 0x0
[  163.912786] [drm] crtc 2 using pll 0x1
[  167.204356] [drm] DP sink type 0x13
[  477.651100] [drm] DP sink type 0x13

Greetings,

Andres
