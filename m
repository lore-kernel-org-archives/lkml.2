Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab1BHTxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 14:53:05 -0500
Received: from smtp-out.google.com ([74.125.121.67]:53235 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab1BHTxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 14:53:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=F+QBdQvNWxAN/9NnjLjtNhYadoPw1SwNW4NnRfCP6GnmJBgeEP8A9A5n90DH4mKEee
         XJLnU/CBDNstoHh3MOOw==
Date: Tue, 8 Feb 2011 11:52:45 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Suppress spurious vblank interrupts
In-Reply-To: <20110202091838.5efaa660@jbarnes-desktop>
Message-ID: <alpine.LSU.2.00.1102081132160.1591@sister.anvils>
References: <849307$bc24ct@azsmga001.ch.intel.com> <1296471462-8578-1-git-send-email-chris@chris-wilson.co.uk> <alpine.LSU.2.00.1102010909270.1586@sister.anvils> <20110201094643.366bc073@jbarnes-desktop> <20110201100833.3219687e@jbarnes-desktop>
 <AANLkTim4kL9OjBDiQQ1MBfOCzThxmDonBic11N45NKxj@mail.gmail.com> <20110201113238.60b33ff9@jbarnes-desktop> <AANLkTikwfHd6t95-jhbXCy1ciW3OV+HVYVikZNs5LHfz@mail.gmail.com> <20110202091838.5efaa660@jbarnes-desktop>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1820850924-1297194777=:1591"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1820850924-1297194777=:1591
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 2 Feb 2011, Jesse Barnes wrote:
> On Tue, 1 Feb 2011 19:37:09 -0800
> Hugh Dickins <hughd@google.com> wrote:
>=20
> > On Tue, Feb 1, 2011 at 11:32 AM, Jesse Barnes <jbarnes@virtuousgeek.org=
> wrote:
> >=20
> > > What I find strange is that you're seeing flip pending interrupts. =
=C2=A0Are
> > > your symptoms affected if you remove the
> > > I915_DISPLAY_PLANE_[AB]_FLIP_PENDING_INTERRUPT lines from
> > > I915_INTERRUPT_ENABLE_FIX at the top of i915_irq.c?
> >=20
> > No.  The first time it looked like yes it fixed it; but when I
> > rebooted again, same symptoms and same underruns back: this thing is
> > very erratic.
> >=20
> > > Do you see any calls to drm_mode_page_flip_ioctl() in your environmen=
t?
> >=20
> > None at all.
> >=20
> > Sometime I should do a bisection between v2.6.36 and v2.6.37 to see
> > what started the underruns; but I can't promise when "sometime" will
> > arrive.
>=20
> But presumably the FLIP_PENDING_INTERRUPT bits are stuck on in your
> case, otherwise we wouldn't be getting to flip prepare/finish at all.
>=20
> Some updated docs indicate those bits may not be reliable on 965
> (though earlier ones did), so we may need to disable the flip code
> entirely on 965 if we can't figure out what's going wrong on your
> config...

Sometime arrived, I did a bisection between v2.6.36 and v2.6.37,
and my "pipe a underrun"s on 965 begin with 29e1316ab129 drm/i915/tv:
Sleep before checking for state changes (appended below).

But that's a necessary patch for me: without it both VESA framebuffer
and X mistake the size and shape of the laptop screen, and my windows
don't fit in properly.

I experimented a little with intel_tv.c on 2.6.38-rc3 and rc4.
Indeed, just deleting that intel_wait_for_vblank() stops the underruns,
but leaves the display missized.  Replacing it by msleep(20), as used to
be done, behaves the same as with intel_wait_for_vblank() there: underruns
with correctly sized display.  "#if 0"ing all of intel_tv_detect_type(),
just returning -1 from it, gives no underruns and correctly sized display.

I was going to work with the latter, when my original unflushed text
problem resurfaced again (just as it had later done when trying Chris's
"Suppress spurious vblank interrupts" patch).  It appears that the
underruns, while mysterious and worrisome, have litte or nothing to do
with the unflushed text problem which is making 2.6.38-rc unusable.

For the moment I've gone back to my patch moving intel_display.c's
do_gettimeofday() call into the block where it's needed; though that
too disappointed eventually before.  It all rather stinks of something
uninitialized somewhere.

Hugh

commit 29e1316ab129f2d3a9ea874e7c9a4cb936f43542
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Sep 22 19:10:09 2010 +0100

    drm/i915/tv: Sleep before checking for state changes.
   =20
    We need to wait for the PLLs to settle prior to detecting the state
    changes. The BIOS writers guide suggests waiting for the next vblank.
   =20
    Reported-by: Carlos R. Mafra <crmafra2@gmail.com>
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_t=
v.c
index 49ab11c..106560b 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1271,8 +1271,12 @@ intel_tv_detect_type (struct intel_tv *intel_tv)
 =09I915_WRITE(TV_DAC, tv_dac);
 =09POSTING_READ(TV_DAC);
=20
+=09intel_wait_for_vblank(intel_tv->base.base.dev,
+=09=09=09      to_intel_crtc(intel_tv->base.base.crtc)->pipe);
+
 =09type =3D -1;
 =09if (wait_for((tv_dac =3D I915_READ(TV_DAC)) & TVDAC_STATE_CHG, 20) =3D=
=3D 0) {
+=09=09DRM_DEBUG_KMS("TV detected: %x, %x\n", tv_ctl, tv_dac);
 =09=09/*
 =09=09 *  A B C
 =09=09 *  0 1 1 Composite
@@ -1289,8 +1293,7 @@ intel_tv_detect_type (struct intel_tv *intel_tv)
 =09=09=09DRM_DEBUG_KMS("Detected Component TV connection\n");
 =09=09=09type =3D DRM_MODE_CONNECTOR_Component;
 =09=09} else {
-=09=09=09DRM_DEBUG_KMS("Unrecognised TV connection: %x\n",
-=09=09=09=09      tv_dac);
+=09=09=09DRM_DEBUG_KMS("Unrecognised TV connection\n");
 =09=09}
 =09}
=20
--8323584-1820850924-1297194777=:1591--
