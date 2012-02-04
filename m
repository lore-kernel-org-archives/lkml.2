Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab2BDLkE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 06:40:04 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51019 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2BDLkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 06:40:01 -0500
Date: Sat, 4 Feb 2012 11:41:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael D Labriola <michael.d.labriola@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, David Airlie <airlied@linux.ie>,
        Michael D Labriola <mlabriol@gdeb.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: gma500: invalid frequency for monitor
Message-ID: <20120204114101.28b90fdf@pyramind.ukuu.org.uk>
In-Reply-To: <85aa4zs1q8.fsf@gmail.com>
References: <85aa4zs1q8.fsf@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My system boots up, loads drm, loads gma500_gfx, and then my monitor's
> OSD says "Out of Frequency".  Pretty much the same behavior with the
> old psb_gfx module and the new gma500_gfx module.

They are all basically the same logic until the most recent release which
at least queries the monitor for the actual system ports it knows how to.
> 
> My system is configured with a LVDS-VGA adapter board, which is
> plugged into the VGA port on a 1680x1050 LCD.  The BIOS for the Ocelot
> is configured for a 1280x1024 LVDS panel, which seems like a
> resolution my monitor should be able to handle.  I've attached
> relevant kernel log with drm.debug set to 999.

I don't have a setup with an LVDS-VGA adapter board to test, but my guess
would be that even if we pick a mode the panel can do we'll pick a clock
rate that it cannot.

> I think my setup is correct, because the vesa frambuffer seems to work
> correctly.  All is well unless I load the gma500_gfx driver and let it
> set the mode.

What mode is the vesa driver using and if you set the same mode what
happens ?

> [  110.197942] ioremap error for 0x7f7f8000-0x7f7fb000, requested 0x10, got 0x0

That is expected

> [  110.206418] [drm:drm_mode_debug_printmodeline], Modeline 0:"1280x1024" 0 108000 1280 1328 1440 1688 1024 1025 1028 1072 0x8 0x0

So we picked 1280x1024

> [  110.257714] [drm:drm_sysfs_connector_add], adding "LVDS-1" to sysfs
> [  110.257932] [drm:drm_sysfs_hotplug_event], generating hotplug event
> [  110.269604] [drm:psb_intel_sdvo_read_byte], i2c transfer returned -6
> [  110.269633] [drm:psb_intel_sdvo_init], No SDVO device found on SDVOB

We found the LVDS, we found nothing on the SDVO

> [  110.561304] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
> [  110.586242] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
> [  110.586274] [drm:drm_mode_debug_printmodeline], Modeline 10:"1280x1024" 40 71500 1280 1328 1440 1688 1024 1025 1028 1072 0x8 0x0

And we probed a 1280x1024 mode with a clock of 71.5 (which might be a bit
high for the panel ?)

> [  110.637467] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
> [  110.637484] [drm:drm_crtc_helper_set_config], modes are different, full mode set

We didn't have a mode before, we have one now.

> [  110.637500] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
> [  110.637529] [drm:drm_mode_debug_printmodeline], Modeline 11:"1280x1024" 40 71500 1280 1328 1440 1688 1024 1025 1028 1072 0x8 0x0
> [  110.637564] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
> [  110.637580] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
> [  110.637599] [drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:4]

Do a full load

> [  110.637618] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
> [  110.637634] [drm:drm_mode_debug_printmodeline], Modeline 11:"1280x1024" 40 71500 1280 1328 1440 1688 1024 1025 1028 1072 0x8 0x0
> [  110.637678] [drm:drm_crtc_helper_set_mode], [CRTC:4]
> [  110.658501] [drm:drm_mode_debug_printmodeline], Modeline 11:"1280x1024" 40 71500 1280 1328 1440 1688 1024 1025 1028 1072 0x8 0x0
> [  110.699109] [drm:drm_crtc_helper_set_mode], [ENCODER:8:LVDS-8] set [MODE:11:1280x1024]
> [  110.977395] [drm:drm_calc_timestamping_constants], crtc 4: hwmode: htotal 1688, vtotal 1072, vdisplay 1024
> [  110.977415] [drm:drm_calc_timestamping_constants], crtc 4: clock 71500 kHz framedur 25307776 linedur 23608, pixeldur 13

We set it all up and seem happy.

> [  110.977439] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
> [  110.977453] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:7:LVDS-1] set DPMS on
> [  111.032366] Console: switching to colour frame buffer device 160x64
> [  111.064932] fb0: psbfb frame buffer device
> [  111.064944] drm: registered panic notifier
> [  111.066827] gma500 0000:00:02.0: Backlight lvds set brightness 7a120000
> [  111.066860] [drm] Initialized gma500 1.0.0 2011-06-06 for 0000:00:02.0 on minor 0

Do you have a different monitor around to try and also hand setting lower
modes ?

