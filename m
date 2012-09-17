Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab2IQNzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:55:55 -0400
Received: from mail.anarazel.de ([217.115.131.40]:46559 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab2IQNzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:55:54 -0400
From: Andres Freund <andres@anarazel.de>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: Re: radeon: Regression between v3.6-rc4 and v3.6-rc6: unable to allocate a PPLL
Date: Mon, 17 Sep 2012 15:55:42 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc6-andres-dirty; KDE/4.8.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
References: <201209171329.15699.andres@anarazel.de> <A3397C8B8B789E45844E7EC5DEAD89D02C433367@sausexdag03.amd.com>
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D02C433367@sausexdag03.amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209171555.43008.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 17, 2012 03:16:56 PM Deucher, Alexander wrote:
> > -----Original Message-----
> > From: Andres Freund [mailto:andres@anarazel.de]
> > Sent: Monday, September 17, 2012 7:29 AM
> > To: LKML; Deucher, Alexander; David Airlie;
> > dri-devel@lists.freedesktop.org Subject: radeon: Regression between
> > v3.6-rc4 and v3.6-rc6: unable to allocate a PPLL
> > 
> > Hi,
> > 
> > While debugging another issue I upgraded from v3.6-rc4 to latest git
> > (which exactly is v3.6-rc6). After X started up one of my three monitors
> > blacked out. A look into the kernel log revealed:
> > [drm:radeon_atom_pick_pll] *ERROR* unable to allocate a PPLL
> 
> What 3 monitors are you using (DVI, HDMI, DP, VGA)? Note that there are
> only 2 PLLs for non-DP monitors, so if you are trying to use more than 2
> non-DP monitors, it's not supported right now and if it worked before, it
> was random luck.  If you want to use 3+ monitors, only 2 can be non-DP,
> the rest need to be DP.  If you use a DP to DVI/HDMI adapter, it must be
> active (looks like DP to the GPU), passive adapters just pass through
> native DVI/HDMI.  That said, I've got a set of patches for 3.7 to allow
> PLL sharing properly for non-DP displays, but it's too invasive for
> -fixes.
2DVI, 1DP via an supposedly active converter. I can try a native DP cable, its 
just too short, so I will have to move the monitor to the ground ;)

Can I check its really an active connector?

The patchset you referenced is in alexdeucher/drm-next-3.7-wip if I saw that 
correctly? Will test it with a passive connector I have lying arround.

The only somewhat relevant thing in the log seems to be

[    2.011401] [drm] ring test on 0 succeeded in 3 usecs
[    2.011897] [drm] ib test on ring 0 succeeded in 0 usecs
[    2.012596] [drm] Radeon Display Connectors
[    2.012784] [drm] Connector 0:
[    2.012972] [drm]   DP-1
[    2.013157] [drm]   HPD4
[    2.013340] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 
0x643c
[    2.013608] [drm]   Encoders:
[    2.013787] [drm]     DFP1: INTERNAL_UNIPHY2
[    2.013978] [drm] Connector 1:
[    2.014163] [drm]   HDMI-A-1
[    2.014346] [drm]   HPD3
[    2.014548] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468 0x646c 
0x646c
[    2.014816] [drm]   Encoders:
[    2.015005] [drm]     DFP2: INTERNAL_UNIPHY2
[    2.015194] [drm] Connector 2:
[    2.015376] [drm]   DVI-D-1
[    2.015561] [drm]   HPD1
[    2.015745] [drm]   DDC: 0x6480 0x6480 0x6484 0x6484 0x6488 0x6488 0x648c 
0x648c
[    2.016015] [drm]   Encoders:
[    2.016203] [drm]     DFP3: INTERNAL_UNIPHY1
[    2.016389] [drm] Connector 3:
[    2.016574] [drm]   DVI-I-1
[    2.016759] [drm]   HPD6
[    2.016942] [drm]   DDC: 0x6470 0x6470 0x6474 0x6474 0x6478 0x6478 0x647c 
0x647c
[    2.017214] [drm]   Encoders:
[    2.017401] [drm]     DFP4: INTERNAL_UNIPHY

xrand doesn't seem to have anything relevant:
$ xrandr --verbose|grep -E 'Screen|connected|CRTC'
Screen 0: minimum 320 x 200, current 4960 x 1920, maximum 16384 x 16384
DVI-1 connected 2560x1600+1200+0 (0x59) normal (normal left inverted right x 
axis y axis) 641mm x 401mm
	CRTC:       0
	CRTCs:      1 2 0 3 4 5
DisplayPort-0 connected 1200x1920+0+0 (0x60) left (normal left inverted right x 
axis y axis) 518mm x 324mm
	CRTC:       1
	CRTCs:      1 2 0 3 4 5
HDMI-0 disconnected (normal left inverted right x axis y axis)
	CRTCs:      1 2 0 3 4 5
DVI-0 connected 1200x1920+3760+0 (0x60) left (normal left inverted right x axis 
y axis) 518mm x 324mm
	CRTC:       2
	CRTCs:      1 2 0 3 4 5

Greetings,

Andres
