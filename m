Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1HHTxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 15:53:36 -0400
Received: from home.keithp.com ([63.227.221.253]:39560 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab1HHTxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 15:53:35 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 2/4] drm/i915: Leave LVDS registers unlocked
In-Reply-To: <20110808114954.23b62dd3@jbarnes-desktop>
References: <1312653248-3487-1-git-send-email-keithp@keithp.com> <1312653248-3487-3-git-send-email-keithp@keithp.com> <20110808093010.487c4559@jbarnes-desktop> <yunr54vu4lr.fsf@aiko.keithp.com> <20110808114954.23b62dd3@jbarnes-desktop>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 08 Aug 2011 12:53:31 -0700
Message-ID: <yunobzz1xz8.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Aug 2011 11:49:54 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> =
wrote:

> Yep, it's safe and possible to do on pre-PCH as well.  For panel
> fitting we do need to do an actual power cycle when going from
> non-native back to native iirc, but we can still leave them unlocked so
> we don't have to worry about the lock/unlock sequence everywhere.

Hidden in the unlock patch was a call to intel_lvds_disable from
intel_lvds_prepare -- that *always* turns off the LVDS for mode
setting. Do we care enough about LVDS mode setting performance that we
should try leave the optimization in place that doesn't turn off the
backlight when switching between modes?

Here's a replacement which unlocks the regs at init time for all
generations. This also includes the unconditional call to
intel_lvds_disable in the _prepare function. I could back that out if
you like.

From=20c0f946bf41e49d9a10bcc0e4ae18a481bb8cdab3 Mon Sep 17 00:00:00 2001
From: Keith Packard <keithp@keithp.com>
Date: Sat, 6 Aug 2011 10:33:12 -0700
Subject: [PATCH 2/5] drm/i915: Leave LVDS registers unlocked

There's no reason to relock them; it just makes operations more
complex. This fixes DPMS where the panel registers were locked making
the disable not work.

Signed-off-by: Keith Packard <keithp@keithp.com>
=2D--
 drivers/gpu/drm/i915/intel_lvds.c |   53 ++++++++++-----------------------=
---
 1 files changed, 15 insertions(+), 38 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel=
_lvds.c
index 6318828..03a9e6d 100644
=2D-- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -400,53 +400,17 @@ out:
=20
 static void intel_lvds_prepare(struct drm_encoder *encoder)
 {
=2D	struct drm_device *dev =3D encoder->dev;
=2D	struct drm_i915_private *dev_priv =3D dev->dev_private;
 	struct intel_lvds *intel_lvds =3D to_intel_lvds(encoder);
=20
=2D	/* We try to do the minimum that is necessary in order to unlock
=2D	 * the registers for mode setting.
=2D	 *
=2D	 * On Ironlake, this is quite simple as we just set the unlock key
=2D	 * and ignore all subtleties. (This may cause some issues...)
=2D	 *
=2D	 * Prior to Ironlake, we must disable the pipe if we want to adjust
=2D	 * the panel fitter. However at all other times we can just reset
=2D	 * the registers regardless.
+	/* Safest to just always power off for mode setting.
 	 */
=2D
=2D	if (HAS_PCH_SPLIT(dev)) {
=2D		I915_WRITE(PCH_PP_CONTROL,
=2D			   I915_READ(PCH_PP_CONTROL) | PANEL_UNLOCK_REGS);
=2D	} else if (intel_lvds->pfit_dirty) {
=2D		I915_WRITE(PP_CONTROL,
=2D			   (I915_READ(PP_CONTROL) | PANEL_UNLOCK_REGS)
=2D			   & ~POWER_TARGET_ON);
=2D	} else {
=2D		I915_WRITE(PP_CONTROL,
=2D			   I915_READ(PP_CONTROL) | PANEL_UNLOCK_REGS);
=2D	}
+	intel_lvds_disable(intel_lvds);
 }
=20
 static void intel_lvds_commit(struct drm_encoder *encoder)
 {
=2D	struct drm_device *dev =3D encoder->dev;
=2D	struct drm_i915_private *dev_priv =3D dev->dev_private;
 	struct intel_lvds *intel_lvds =3D to_intel_lvds(encoder);
=20
=2D	/* Undo any unlocking done in prepare to prevent accidental
=2D	 * adjustment of the registers.
=2D	 */
=2D	if (HAS_PCH_SPLIT(dev)) {
=2D		u32 val =3D I915_READ(PCH_PP_CONTROL);
=2D		if ((val & PANEL_UNLOCK_REGS) =3D=3D PANEL_UNLOCK_REGS)
=2D			I915_WRITE(PCH_PP_CONTROL, val & 0x3);
=2D	} else {
=2D		u32 val =3D I915_READ(PP_CONTROL);
=2D		if ((val & PANEL_UNLOCK_REGS) =3D=3D PANEL_UNLOCK_REGS)
=2D			I915_WRITE(PP_CONTROL, val & 0x3);
=2D	}
=2D
 	/* Always do a full power on as we do not know what state
 	 * we were left in.
 	 */
@@ -1042,6 +1006,19 @@ out:
 		pwm =3D I915_READ(BLC_PWM_PCH_CTL1);
 		pwm |=3D PWM_PCH_ENABLE;
 		I915_WRITE(BLC_PWM_PCH_CTL1, pwm);
+		/*
+		 * Unlock registers and just
+		 * leave them unlocked
+		 */
+		I915_WRITE(PCH_PP_CONTROL,
+			   I915_READ(PCH_PP_CONTROL) | PANEL_UNLOCK_REGS);
+	} else {
+		/*
+		 * Unlock registers and just
+		 * leave them unlocked
+		 */
+		I915_WRITE(PP_CONTROL,
+			   I915_READ(PP_CONTROL) | PANEL_UNLOCK_REGS);
 	}
 	dev_priv->lid_notifier.notifier_call =3D intel_lid_notify;
 	if (acpi_lid_notifier_register(&dev_priv->lid_notifier)) {
=2D-=20
1.7.5.4



=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOQD67Qp8BWwlsTdMRAuybAJ9FZz9MAo2meVJdLrw7czXdjj005gCcD60T
F7ABSBYFDITGaD0dH6Egg4g=
=gLpG
-----END PGP SIGNATURE-----
--=-=-=--
