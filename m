Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934558Ab2FHV5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 17:57:55 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63565 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760172Ab2FHV5x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 17:57:53 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1206080952010.15272@skynet.skynet.ie>
References: <alpine.DEB.2.00.1206080952010.15272@skynet.skynet.ie>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 8 Jun 2012 14:57:31 -0700
X-Google-Sender-Auth: 5aKpA7_eLzHa3cfJaJOwT_SINTo
Message-ID: <CA+55aFyASr5Jfok7vVKXg9=n_pBGyjLZf3MmRik90y8qXRNo3g@mail.gmail.com>
Subject: Re: [git pull] drm intel + exynos fixes
To: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This breaks things for me. Bisect says:

9e612a008fa7fe493a473454def56aa321479495 is the first bad commit
commit 9e612a008fa7fe493a473454def56aa321479495
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Thu May 31 13:08:53 2012 +0100

    drm/i915/crt: Do not rely upon the HPD presence pin

    Whilst most monitors do wire up the HPD presence pin, it seems quite a
    few KVM do not. Therefore if we simply rely on the HPD pin being
    asserted to indicate a connected monitor we fail miserable, so fall back
    to performing a DCC query for the EDID.

    Reported-and-tested-by: Matthieu LAVIE <boiteamadmax@hotmail.com>
    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=50501
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

And the symptoms are that it boots in what appears to be the correct
mode for my monitor (1920x1200), but when X starts it changes to
1024x768 mode.

Which is not good, and not useful.

The bad kernel has this in Xorg.0.log:

 [    12.796] (II) intel(0): EDID for output VGA1
 [    12.796] (II) intel(0): Printing probed modes for output VGA1
 [    12.796] (II) intel(0): Modeline "1024x768"x60.0   65.00  1024
1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz e)
 [    12.796] (II) intel(0): Modeline "800x600"x60.3   40.00  800 840
968 1056  600 601 605 628 +hsync +vsync (37.9 kHz e)
 [    12.796] (II) intel(0): Modeline "800x600"x56.2   36.00  800 824
896 1024  600 601 603 625 +hsync +vsync (35.2 kHz e)
 [    12.796] (II) intel(0): Modeline "848x480"x60.0   33.75  848 864
976 1088  480 486 494 517 +hsync +vsync (31.0 kHz e)
 [    12.796] (II) intel(0): Modeline "640x480"x59.9   25.18  640 656
752 800  480 489 492 525 -hsync -vsync (31.5 kHz e)

which is pure and utter garbage. I think it's the "default modes" for
the non-EDID case, and has nothing to do with actual hardware.

The good kernel doesn't have those incorrect and bogus probed modes,
and just has the correct HDMI1 (that the bad kernel *also* has, of
course).

I have reverted that commit as obviously broken, since I'm not going
to release an -rc2 that doesn't even work for me (and since it *is*
obviously broken).

                      Linus

On Fri, Jun 8, 2012 at 1:53 AM, Dave Airlie <airlied@linux.ie> wrote:
>
> Hi Linus,
>
> a bunch of fixes for Intel and exynos, nothing too major, a new intel PCI
> Id, and a fix for CRT detection.
>
> Dave.
>
> The following changes since commit 7aaa61b3476462b69f1ac7669fcca8d608ce3cb5:
>
>  drm/radeon/kms: add new SI PCI ids (2012-06-05 15:11:12 +0100)
>
> are available in the git repository at:
>
>  git://people.freedesktop.org/~airlied/linux drm-fixes
>
> for you to fetch changes up to 2d5c7cd35f1addb812e0b1709b3c727f1a58ca9c:
>
>  Merge branch 'exynos-drm-fixes' of git://git.infradead.org/users/kmpark/linux-samsung into drm-fixes (2012-06-08 09:42:51 +0100)
>
> ----------------------------------------------------------------
>
> Adam Jackson (1):
>      drm/i915: pch_irq_handler -> {ibx, cpt}_irq_handler
>
> Chris Wilson (3):
>      drm/i915: Reset last_retired_head when resetting ring
>      drm/i915/crt: Do not rely upon the HPD presence pin
>      drm/i915: Mark the ringbuffers as being in the GTT domain
>
> Daniel Vetter (2):
>      drm/i915: hold forcewake around ring hw init
>      drm/i915: fix up ivb plane 3 pageflips
>
> Dave Airlie (2):
>      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
>      Merge branch 'exynos-drm-fixes' of git://git.infradead.org/users/kmpark/linux-samsung into drm-fixes
>
> Eugeni Dodonov (1):
>      char/agp: add another Ironlake host bridge
>
> Inki Dae (1):
>      drm/exynos: fixed size type.
>
> Laurent Pinchart (4):
>      drm/exynos: DRIVER_BUS_PLATFORM is not a driver feature
>      drm/exynos: Don't cast GEM object to Exynos GEM object when not needed
>      drm/exynos: Keep a reference to frame buffer GEM objects
>      drm/exynos: Remove dummy encoder get_crtc operation implementation
>
> Seung-Woo Kim (1):
>      drm/exynos: fixed blending for hdmi graphic layer
>
> Ville Syrjälä (1):
>      drm/exynos: Use DRM_FORMAT_{NV12, YUV420} instead of DRM_FORMAT_{NV12M, YUV420M}
>
>  drivers/char/agp/intel-agp.c                |    1 +
>  drivers/char/agp/intel-agp.h                |    1 +
>  drivers/gpu/drm/exynos/exynos_drm_drv.c     |    4 +--
>  drivers/gpu/drm/exynos/exynos_drm_encoder.c |    7 -----
>  drivers/gpu/drm/exynos/exynos_drm_fb.c      |   19 ++++++++----
>  drivers/gpu/drm/exynos/exynos_drm_fb.h      |    4 +--
>  drivers/gpu/drm/exynos/exynos_drm_gem.c     |    9 ++----
>  drivers/gpu/drm/exynos/exynos_mixer.c       |   12 ++++----
>  drivers/gpu/drm/i915/i915_drv.c             |   13 +++++---
>  drivers/gpu/drm/i915/i915_drv.h             |    3 ++
>  drivers/gpu/drm/i915/i915_irq.c             |   38 +++++++++++++++++++++--
>  drivers/gpu/drm/i915/i915_reg.h             |   43 +++++++++++++++++++++++++--
>  drivers/gpu/drm/i915/intel_crt.c            |    8 +++--
>  drivers/gpu/drm/i915/intel_display.c        |   19 +++++++++++-
>  drivers/gpu/drm/i915/intel_ringbuffer.c     |   21 +++++++++++--
>  include/drm/exynos_drm.h                    |    4 ++-
>  16 files changed, 161 insertions(+), 45 deletions(-)
