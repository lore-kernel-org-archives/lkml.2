Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab1KBRfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:35:53 -0400
Received: from home.keithp.com ([63.227.221.253]:35273 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755735Ab1KBRfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:35:52 -0400
From: Keith Packard <keithp@keithp.com>
To: Adam Jackson <ajax@redhat.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 3/7] drm/i915: Treat PCH eDP like DP in most places
In-Reply-To: <4EB161F1.5090003@redhat.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-4-git-send-email-keithp@keithp.com> <4EB161F1.5090003@redhat.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 02 Nov 2011 10:35:35 -0700
Message-ID: <yun62j2whp4.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 02 Nov 2011 11:29:53 -0400, Adam Jackson <ajax@redhat.com> wrote:

> Redundant.  You've already done the link_configuration |=3D above in the=
=20
> common code.  You can drop the second if chunk altogether.

Here's the new version of that chunk of patch:

@@ -850,32 +864,45 @@ intel_dp_mode_set(struct drm_encoder *encoder, struct=
 drm_display_mode *mode,
                intel_dp->DP |=3D DP_AUDIO_OUTPUT_ENABLE;
                intel_write_eld(encoder, adjusted_mode);
        }
=2D
        memset(intel_dp->link_configuration, 0, DP_LINK_CONFIGURATION_SIZE);
        intel_dp->link_configuration[0] =3D intel_dp->link_bw;
        intel_dp->link_configuration[1] =3D intel_dp->lane_count;
        intel_dp->link_configuration[8] =3D DP_SET_ANSI_8B10B;
=2D
        /*
         * Check for DPCD version > 1.1 and enhanced framing support
         */
        if (intel_dp->dpcd[DP_DPCD_REV] >=3D 0x11 &&
            (intel_dp->dpcd[DP_MAX_LANE_COUNT] & DP_ENHANCED_FRAME_CAP)) {
                intel_dp->link_configuration[1] |=3D DP_LANE_COUNT_ENHANCED=
_FRAME_EN;
=2D               intel_dp->DP |=3D DP_ENHANCED_FRAMING;
        }
=20
=2D       /* CPT DP's pipe select is decided in TRANS_DP_CTL */
=2D       if (intel_crtc->pipe =3D=3D 1 && !HAS_PCH_CPT(dev))
=2D               intel_dp->DP |=3D DP_PIPEB_SELECT;
+       /* Split out the IBX/CPU vs CPT settings */
=20
=2D       if (is_cpu_edp(intel_dp)) {
=2D               /* don't miss out required setting for eDP */
=2D               intel_dp->DP |=3D DP_PLL_ENABLE;
=2D               if (adjusted_mode->clock < 200000)
=2D                       intel_dp->DP |=3D DP_PLL_FREQ_160MHZ;
=2D               else
=2D                       intel_dp->DP |=3D DP_PLL_FREQ_270MHZ;
+       if (!HAS_PCH_CPT(dev) || is_cpu_edp(intel_dp)) {
+               intel_dp->DP |=3D intel_dp->color_range;
+
+               if (adjusted_mode->flags & DRM_MODE_FLAG_PHSYNC)
+                       intel_dp->DP |=3D DP_SYNC_HS_HIGH;
+               if (adjusted_mode->flags & DRM_MODE_FLAG_PVSYNC)
+                       intel_dp->DP |=3D DP_SYNC_VS_HIGH;
+               intel_dp->DP |=3D DP_LINK_TRAIN_OFF;
+
+               if (intel_dp->link_configuration[1] & DP_LANE_COUNT_ENHANCE=
D_FRAME_EN)
+                       intel_dp->DP |=3D DP_ENHANCED_FRAMING;
+
+               if (intel_crtc->pipe =3D=3D 1)
+                       intel_dp->DP |=3D DP_PIPEB_SELECT;
+
+               if (is_cpu_edp(intel_dp)) {
+                       /* don't miss out required setting for eDP */
+                       intel_dp->DP |=3D DP_PLL_ENABLE;
+                       if (adjusted_mode->clock < 200000)
+                               intel_dp->DP |=3D DP_PLL_FREQ_160MHZ;
+                       else
+                               intel_dp->DP |=3D DP_PLL_FREQ_270MHZ;
+               }
+       } else {
+               intel_dp->DP |=3D DP_LINK_TRAIN_OFF_CPT;
        }
 }
=20
=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrF/ZzYtFsjWk68qAQghkQ//UowE2VuwnVOZ2SGaZp5hiFdN3uXf2rJF
aLdmEzcdFXt6cb/MV50KPnhYoOGvW+WiDjFngaFGdL472vIhDM2kuiH2wvSq/ofk
Vno+jydjX9L+qPGnXUletohzMfSj1DevTx1s8XSwdEX34SBG0/VOLNpxlKImWC/t
E5TsiJ8iRsaXSfdS5RGDNAbe99Kt/l7LBcEluS/CiNyeJygeYwZrucH0sd3VQDCE
qNRQniT7KmK0W91CVSAan5bgtUezz4WIyl+q0h6eqp2imlENVTsAwNedWvI3FRUY
kP7u+CaAOOtaR7oT9m27qEjZakNo6n4VFT/96cxnQ57ouE+A4H24nL2813aylog0
MYpLtpFkXdu5pjlpp9OsJZPTFNmQwh2jRAPCS0ZVSH8bGj++5CS4aFViSpjZkDE3
QSI5nSV1iJme/KXN1FQGtq2SUGqEF25dhcp1wygXW4xskALxkEzp9uGrYy4W/rG2
Am16lAFtCI/++6s5N78X2KN/AhKTB8ZXPHlpEkYb7pUUn6zH9VQvzoARMm+/I9ZZ
WFKZEIwjGnekRpMKaQnVGIiEghovZIpgqwRujbcAVEQvJZUMmftt+qbvkcTvFhVm
cSNxgdRCDn1Ct7Z0/zxVVcMKq51iNEEheoUCw5YTOFzfbAQCVBrI8VhwtRHGMgz+
boowNXOWoGQ=
=5YC8
-----END PGP SIGNATURE-----
--=-=-=--
