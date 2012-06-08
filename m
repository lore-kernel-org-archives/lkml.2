Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab2FHWNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 18:13:33 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:46799 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750795Ab2FHWNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 18:13:32 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [git pull] drm intel + exynos fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CA+55aFyASr5Jfok7vVKXg9=n_pBGyjLZf3MmRik90y8qXRNo3g@mail.gmail.com>
References: <alpine.DEB.2.00.1206080952010.15272@skynet.skynet.ie> <CA+55aFyASr5Jfok7vVKXg9=n_pBGyjLZf3MmRik90y8qXRNo3g@mail.gmail.com>
Date: Fri, 08 Jun 2012 23:12:30 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1339193608_596134@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2012 14:57:31 -0700, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> This breaks things for me. Bisect says:
> 
> 9e612a008fa7fe493a473454def56aa321479495 is the first bad commit
> commit 9e612a008fa7fe493a473454def56aa321479495
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Thu May 31 13:08:53 2012 +0100
> 
>     drm/i915/crt: Do not rely upon the HPD presence pin
> 
>     Whilst most monitors do wire up the HPD presence pin, it seems quite a
>     few KVM do not. Therefore if we simply rely on the HPD pin being
>     asserted to indicate a connected monitor we fail miserable, so fall back
>     to performing a DCC query for the EDID.
> 
>     Reported-and-tested-by: Matthieu LAVIE <boiteamadmax@hotmail.com>
>     Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=50501
>     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>     Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> And the symptoms are that it boots in what appears to be the correct
> mode for my monitor (1920x1200), but when X starts it changes to
> 1024x768 mode.
> 
> Which is not good, and not useful.
> 
> The bad kernel has this in Xorg.0.log:
> 
>  [    12.796] (II) intel(0): EDID for output VGA1
>  [    12.796] (II) intel(0): Printing probed modes for output VGA1
>  [    12.796] (II) intel(0): Modeline "1024x768"x60.0   65.00  1024
> 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz e)
>  [    12.796] (II) intel(0): Modeline "800x600"x60.3   40.00  800 840
> 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz e)
>  [    12.796] (II) intel(0): Modeline "800x600"x56.2   36.00  800 824
> 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz e)
>  [    12.796] (II) intel(0): Modeline "848x480"x60.0   33.75  848 864
> 976 1088  480 486 494 517 +hsync +vsync (31.0 kHz e)
>  [    12.796] (II) intel(0): Modeline "640x480"x59.9   25.18  640 656
> 752 800  480 489 492 525 -hsync -vsync (31.5 kHz e)
> 
> which is pure and utter garbage. I think it's the "default modes" for
> the non-EDID case, and has nothing to do with actual hardware.
> 
> The good kernel doesn't have those incorrect and bogus probed modes,
> and just has the correct HDMI1 (that the bad kernel *also* has, of
> course).
> 
> I have reverted that commit as obviously broken, since I'm not going
> to release an -rc2 that doesn't even work for me (and since it *is*
> obviously broken).

Shock, horror, that's how it is meant to work when we cannot determine
whether or not there is actually an output attached to the VGA. The hw
autodetect falsely declares some VGA connections, notably through KVM
switches, as disconnected and so we need to do a manual probe to confirm
the flaky hw. The first phase of that probe is to request the EDID from
the monitor, not all monitors supply one and less through a KVM switch,
so we cannot rely on a negative result from that test. (Absence of
evidence is not evidence of absence and all that.) So it falls back to
load-detection, which in your case it cannot do since all the available
pipes are assigned and so it just reports the VGA connection as unknown.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
