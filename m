Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761333Ab2FHWLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 18:11:30 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:39110 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2FHWL3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 18:11:29 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CA+55aFyASr5Jfok7vVKXg9=n_pBGyjLZf3MmRik90y8qXRNo3g@mail.gmail.com>
References: <alpine.DEB.2.00.1206080952010.15272@skynet.skynet.ie>
	<CA+55aFyASr5Jfok7vVKXg9=n_pBGyjLZf3MmRik90y8qXRNo3g@mail.gmail.com>
Date: Sat, 9 Jun 2012 00:11:28 +0200
Message-ID: <CAKMK7uGzfdOiHy2yt7fNDJZJSmc_HD3iH-nsZegetkNndPssqA@mail.gmail.com>
Subject: Re: [git pull] drm intel + exynos fixes
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 11:57 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> This breaks things for me. Bisect says:
>
> 9e612a008fa7fe493a473454def56aa321479495 is the first bad commit
> commit 9e612a008fa7fe493a473454def56aa321479495
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Thu May 31 13:08:53 2012 +0100
>
>    drm/i915/crt: Do not rely upon the HPD presence pin
>
>    Whilst most monitors do wire up the HPD presence pin, it seems quite a
>    few KVM do not. Therefore if we simply rely on the HPD pin being
>    asserted to indicate a connected monitor we fail miserable, so fall back
>    to performing a DCC query for the EDID.
>
>    Reported-and-tested-by: Matthieu LAVIE <boiteamadmax@hotmail.com>
>    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=50501
>    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>
> And the symptoms are that it boots in what appears to be the correct
> mode for my monitor (1920x1200), but when X starts it changes to
> 1024x768 mode.
>
> Which is not good, and not useful.
>
> The bad kernel has this in Xorg.0.log:
>
>  [    12.796] (II) intel(0): EDID for output VGA1
>  [    12.796] (II) intel(0): Printing probed modes for output VGA1
>  [    12.796] (II) intel(0): Modeline "1024x768"x60.0   65.00  1024
> 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz e)
>  [    12.796] (II) intel(0): Modeline "800x600"x60.3   40.00  800 840
> 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz e)
>  [    12.796] (II) intel(0): Modeline "800x600"x56.2   36.00  800 824
> 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz e)
>  [    12.796] (II) intel(0): Modeline "848x480"x60.0   33.75  848 864
> 976 1088  480 486 494 517 +hsync +vsync (31.0 kHz e)
>  [    12.796] (II) intel(0): Modeline "640x480"x59.9   25.18  640 656
> 752 800  480 489 492 525 -hsync -vsync (31.5 kHz e)
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

I've looked again through the code and with this patch we can fall
through to the gen2/3 load detect code, which likely results totally
bogus results for anything never (where we've previously relied
exclusively on the hotplug pins). Sorry for not catching this when
I've reviewed this patch for -fixes. Hence for the revert:

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

-Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
