Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab1I1QgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 12:36:24 -0400
Received: from home.keithp.com ([63.227.221.253]:46729 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab1I1QgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 12:36:22 -0400
From: Keith Packard <keithp@keithp.com>
To: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH 6/9] drm/i915: Fix PCH SSC reference clock settings
In-Reply-To: <aefc95$1m20sf@orsmga001.jf.intel.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com> <1317103906-4649-1-git-send-email-keithp@keithp.com> <1317103906-4649-7-git-send-email-keithp@keithp.com> <e0d58a$1mfd94@orsmga002.jf.intel.com> <yunr531981s.fsf@aiko.keithp.com> <aefc95$1m20sf@orsmga001.jf.intel.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 28 Sep 2011 09:36:08 -0700
Message-ID: <yuny5x87hfr.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Sep 2011 10:09:13 +0100, Chris Wilson <chris@chris-wilson.co.uk>=
 wrote:

> My understanding was that we could not enable SSC at all if we had a VGA,
> DVI/HDMI or TV output; DP may or may not work with SSC.

Yeah, which makes no sense at all. If this were true, we'd have to turn
off the LVDS/eDP panel whenever enabling one of the non-SSC outputs.

> The patch says that we will want to enable SSC if we have an SSC capbable
> LVDS or eDP, which is certainly true. And that we can always do so if we
> remember to set a magic bit in refclk to prevent non-SSC capable outputs
> from being upset. I have not seen anything to support that last statement,
> but, then again, I have not seen anything that actually explains what CK5=
05
> is!

CK505 is an Intel specification for external clock synthesizers. Here's
an older one made by Silego:

http://www.silego.com/uploads/Products/product_54/xSLG8SP585r101_10062009.p=
df

There are newer ones which provide the (required?) 120MHz output
specified in the bspec.

However, if you go read:

http://www.advantech.com.tw/embcore/promotions/Whitepaper/2nd_Gen_Intel_Cor=
e_i7_Processors.pdf

you'll see that Cougarpoint is reported to have a fully integrated
clocking solution and not require an external CK505. Which makes the
lack of the display_clock_mode bit in the VBIOS sources a lot more
understandable.

So, I think we should not look for a CK505 on Cougar Point systems, only
on Ibex Peak systems, and that we probably cannot use SSC on Ibex Peak
unless we have a CK505.

> Having said that, this is an obvious improvement over the current
> situation in that we do choose correctly in more circumstances and we do
> not reprogram the refclk whilst active.

I think we can reprogram the refclk after init time, but only if no-one
is using it, which is something we can do later on.

> As an incremental improvement [in my understanding ;-]:
> Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>

Perhaps this patch on top of the existing patch?

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/in=
tel_display.c
index 1cc0962..4bf49eb 100644
=2D-- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5122,6 +5122,8 @@ static void ironlake_init_pch_refclk(struct drm_devic=
e *dev)
 	bool has_cpu_edp =3D false;
 	bool has_pch_edp =3D false;
 	bool has_panel =3D false;
+	bool has_ck505 =3D false;
+	bool can_ssc =3D false;
=20
 	/* We need to take the global config into account */
 	list_for_each_entry(encoder, &mode_config->encoder_list,
@@ -5141,9 +5143,17 @@ static void ironlake_init_pch_refclk(struct drm_devi=
ce *dev)
 		}
 	}
=20
+	if (HAS_PCH_IBX(dev)) {
+		has_ck505 =3D dev_priv->display_clock_mode;
+		can_ssc =3D has_ck505;
+	} else {
+		has_ck505 =3D false;
+		can_ssc =3D true;
+	}
+
 	DRM_DEBUG_KMS("has_panel %d has_lvds %d has_pch_edp %d has_cpu_edp %d has=
_ck505 %d\n",
 		      has_panel, has_lvds, has_pch_edp, has_cpu_edp,
=2D		      dev_priv->display_clock_mode);=20=20
+		      has_ck505);
=20
 	/* Ironlake: try to setup display ref clock before DPLL
 	 * enabling. This is only under driver's control after
@@ -5154,7 +5164,7 @@ static void ironlake_init_pch_refclk(struct drm_devic=
e *dev)
 	/* Always enable nonspread source */
 	temp &=3D ~DREF_NONSPREAD_SOURCE_MASK;
=20
=2D	if (dev_priv->display_clock_mode)
+	if (has_ck505)
 		temp |=3D DREF_NONSPREAD_CK505_ENABLE;
 	else
 		temp |=3D DREF_NONSPREAD_SOURCE_ENABLE;
@@ -5164,7 +5174,7 @@ static void ironlake_init_pch_refclk(struct drm_devic=
e *dev)
 		temp |=3D DREF_SSC_SOURCE_ENABLE;
=20
 		/* SSC must be turned on before enabling the CPU output  */
=2D		if (intel_panel_use_ssc(dev_priv)) {
+		if (intel_panel_use_ssc(dev_priv) && can_ssc) {
 			DRM_DEBUG_KMS("Using SSC on panel\n");
 			temp |=3D DREF_SSC1_ENABLE;
 		}
@@ -5178,7 +5188,7 @@ static void ironlake_init_pch_refclk(struct drm_devic=
e *dev)
=20
 		/* Enable CPU source on CPU attached eDP */
 		if (has_cpu_edp) {
=2D			if (intel_panel_use_ssc(dev_priv)) {
+			if (intel_panel_use_ssc(dev_priv) && can_ssc) {
 				DRM_DEBUG_KMS("Using SSC on eDP\n");
 				temp |=3D DREF_CPU_SOURCE_OUTPUT_DOWNSPREAD;
 			}

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOg0z4Qp8BWwlsTdMRAsK4AKDao9zUaYAKH5v0RX6isZEmkFADiQCgs2SK
x4eQeRhPwMr9aSJJeR1tTAw=
=lmGq
-----END PGP SIGNATURE-----
--=-=-=--
