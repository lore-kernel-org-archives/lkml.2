Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1HHSkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:40:13 -0400
Received: from home.keithp.com ([63.227.221.253]:44090 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab1HHSkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:40:11 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 1/4] drm/i915: Wait for LVDS panel power sequence
In-Reply-To: <20110808092719.4f62983d@jbarnes-desktop>
References: <1312653248-3487-1-git-send-email-keithp@keithp.com> <1312653248-3487-2-git-send-email-keithp@keithp.com> <20110808092719.4f62983d@jbarnes-desktop>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 08 Aug 2011 11:40:06 -0700
Message-ID: <yunty9ru4qh.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Aug 2011 09:27:19 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> =
wrote:

> ...to catch places like this where the wrong register gets used. :)

Ouch! There are only two places we *should* have these loops, one when
turning it off, another when turning it on. There's a couple of loops
which just need to be removed.

Here's a replacement patch:

From=20436f2b19cf17c43e4d5ad55b47aeb3660c2af9b9 Mon Sep 17 00:00:00 2001
From: Keith Packard <keithp@keithp.com>
Date: Sat, 6 Aug 2011 10:30:45 -0700
Subject: [PATCH] drm/i915: Wait for LVDS panel power sequence

During mode setting, check to make sure the panel power sequencing has
completed before doing further operations on the device. This
uncovered errors with DPMS not turning the device off as it was left locked.

Signed-off-by: Keith Packard <keithp@keithp.com>
=2D--
 drivers/gpu/drm/i915/intel_lvds.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel=
_lvds.c
index 2e8ddfc..6318828 100644
=2D-- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -72,14 +72,16 @@ static void intel_lvds_enable(struct intel_lvds *intel_=
lvds)
 {
 	struct drm_device *dev =3D intel_lvds->base.base.dev;
 	struct drm_i915_private *dev_priv =3D dev->dev_private;
=2D	u32 ctl_reg, lvds_reg;
+	u32 ctl_reg, lvds_reg, stat_reg;
=20
 	if (HAS_PCH_SPLIT(dev)) {
 		ctl_reg =3D PCH_PP_CONTROL;
 		lvds_reg =3D PCH_LVDS;
+		stat_reg =3D PCH_PP_STATUS;
 	} else {
 		ctl_reg =3D PP_CONTROL;
 		lvds_reg =3D LVDS;
+		stat_reg =3D PP_STATUS;
 	}
=20
 	I915_WRITE(lvds_reg, I915_READ(lvds_reg) | LVDS_PORT_EN);
@@ -94,17 +96,16 @@ static void intel_lvds_enable(struct intel_lvds *intel_=
lvds)
 		DRM_DEBUG_KMS("applying panel-fitter: %x, %x\n",
 			      intel_lvds->pfit_control,
 			      intel_lvds->pfit_pgm_ratios);
=2D		if (wait_for((I915_READ(PP_STATUS) & PP_ON) =3D=3D 0, 1000)) {
=2D			DRM_ERROR("timed out waiting for panel to power off\n");
=2D		} else {
=2D			I915_WRITE(PFIT_PGM_RATIOS, intel_lvds->pfit_pgm_ratios);
=2D			I915_WRITE(PFIT_CONTROL, intel_lvds->pfit_control);
=2D			intel_lvds->pfit_dirty =3D false;
=2D		}
+
+		I915_WRITE(PFIT_PGM_RATIOS, intel_lvds->pfit_pgm_ratios);
+		I915_WRITE(PFIT_CONTROL, intel_lvds->pfit_control);
+		intel_lvds->pfit_dirty =3D false;
 	}
=20
 	I915_WRITE(ctl_reg, I915_READ(ctl_reg) | POWER_TARGET_ON);
 	POSTING_READ(lvds_reg);
+	if (wait_for((I915_READ(stat_reg) & PP_ON) !=3D 0, 1000))
+		DRM_ERROR("timed out waiting for panel to power on\n");
=20
 	intel_panel_enable_backlight(dev);
 }
@@ -113,24 +114,25 @@ static void intel_lvds_disable(struct intel_lvds *int=
el_lvds)
 {
 	struct drm_device *dev =3D intel_lvds->base.base.dev;
 	struct drm_i915_private *dev_priv =3D dev->dev_private;
=2D	u32 ctl_reg, lvds_reg;
+	u32 ctl_reg, lvds_reg, stat_reg;
=20
 	if (HAS_PCH_SPLIT(dev)) {
 		ctl_reg =3D PCH_PP_CONTROL;
 		lvds_reg =3D PCH_LVDS;
+		stat_reg =3D PCH_PP_STATUS;
 	} else {
 		ctl_reg =3D PP_CONTROL;
 		lvds_reg =3D LVDS;
+		stat_reg =3D PP_STATUS;
 	}
=20
 	intel_panel_disable_backlight(dev);
=20
 	I915_WRITE(ctl_reg, I915_READ(ctl_reg) & ~POWER_TARGET_ON);
+	if (wait_for((I915_READ(stat_reg) & PP_ON) =3D=3D 0, 1000))
+		DRM_ERROR("timed out waiting for panel to power off\n");
=20
 	if (intel_lvds->pfit_control) {
=2D		if (wait_for((I915_READ(PP_STATUS) & PP_ON) =3D=3D 0, 1000))
=2D			DRM_ERROR("timed out waiting for panel to power off\n");
=2D
 		I915_WRITE(PFIT_CONTROL, 0);
 		intel_lvds->pfit_dirty =3D true;
 	}
=2D-=20
1.7.5.4

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOQC2GQp8BWwlsTdMRAmGTAKDPO/R0pOl2f4QKse3cCATi9KA4XgCcDGq6
iD+qCDBpYq+FIBcYhgfqZSw=
=aocf
-----END PGP SIGNATURE-----
--=-=-=--
