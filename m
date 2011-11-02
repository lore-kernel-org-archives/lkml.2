Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab1KBVNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 17:13:18 -0400
Received: from home.keithp.com ([63.227.221.253]:46871 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab1KBVNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 17:13:16 -0400
From: Keith Packard <keithp@keithp.com>
To: Adam Jackson <ajax@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 3/7] drm/i915: Treat PCH eDP like DP in most places
In-Reply-To: <4EB1A9A7.8070900@redhat.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-4-git-send-email-keithp@keithp.com> <20111102092019.3a635632@jbarnes-desktop> <4EB17A50.6050804@redhat.com> <yun8vnywhvh.fsf@aiko.keithp.com> <4EB19BB4.6030505@redhat.com> <yunipn2uw70.fsf@aiko.keithp.com> <4EB1A9A7.8070900@redhat.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 02 Nov 2011 14:13:12 -0700
Message-ID: <yun7h3iut1z.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 02 Nov 2011 16:35:51 -0400, Adam Jackson <ajax@redhat.com> wrote:

> It is?  The DP 1.1a text for lane count is "For Rev.1.1, only the=20
> following three values are supported. All other values are reserved."

Yeah, if you look at the MAX_LINK_RATE field, we assume that it has a
useful value. I'll bet they were thinking of letting the spec support
things like alternate clock rates or 3 lanes or something, and the 1.1
version just tied things down to allow only sensible values there.

How about we just always use the DPCD value?

commit e0fafa5dee031ef6174eadb005a5f01d13da931d
Author: Keith Packard <keithp@keithp.com>
Date:   Wed Nov 2 13:03:47 2011 -0700

    drm/i915: Use DPCD value for max DP lanes.
=20=20=20=20
    The BIOS VBT value for an eDP panel has been shown to be incorrect on
    one machine, and we haven't found any machines where the DPCD value
    was wrong, so we'll use the DPCD value everywhere.
=20=20=20=20
    Signed-off-by: Keith Packard <keithp@keithp.com>

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_d=
p.c
index 02b56ce..5056d29 100644
=2D-- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -154,16 +154,12 @@ intel_edp_link_config(struct intel_encoder *intel_enc=
oder,
 static int
 intel_dp_max_lane_count(struct intel_dp *intel_dp)
 {
=2D       int max_lane_count =3D 4;
=2D
=2D       if (intel_dp->dpcd[DP_DPCD_REV] >=3D 0x11) {
=2D               max_lane_count =3D intel_dp->dpcd[DP_MAX_LANE_COUNT] & 0x=
1f;
=2D               switch (max_lane_count) {
=2D               case 1: case 2: case 4:
=2D                       break;
=2D               default:
=2D                       max_lane_count =3D 4;
=2D               }
+       int max_lane_count =3D intel_dp->dpcd[DP_MAX_LANE_COUNT] & 0x1f;
+       switch (max_lane_count) {
+       case 1: case 2: case 4:
+               break;
+       default:
+               max_lane_count =3D 4;
        }
        return max_lane_count;
 }
@@ -765,12 +761,11 @@ intel_dp_set_m_n(struct drm_crtc *crtc, struct drm_di=
splay_mode *mode,
                        continue;
=20
                intel_dp =3D enc_to_intel_dp(encoder);
=2D               if (intel_dp->base.type =3D=3D INTEL_OUTPUT_DISPLAYPORT |=
| is_pch_edp(intel_dp)) {
+               if (intel_dp->base.type =3D=3D INTEL_OUTPUT_DISPLAYPORT ||
+                   intel_dp->base.type =3D=3D INTEL_OUTPUT_EDP)
+               {
                        lane_count =3D intel_dp->lane_count;
                        break;
=2D               } else if (is_cpu_edp(intel_dp)) {
=2D                       lane_count =3D dev_priv->edp.lanes;
=2D                       break;
                }
        }

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrGyaDYtFsjWk68qAQjD8RAApkOLkoPdBgl9JdsSOEDqg2yB7PzsYMZd
eB9UKRDfJ3fhz4oinMdtObZozvhnLXyHjHGIhbPemwJU8jHYpM08GyawAo5jgBQI
5t7ad6uTQ7uu/4nYg3g0JEmtbRaUtsmU9rKWdG9EqCHQo4NaI7Y4WsNvOrAhdxxt
LAJ8zv1mxyqyns8GH2RNfKqVemw5hhxtA1vbDfVUzhfLJWa3z3qKpJlC1Gtk2QKa
rCnAxCEnf79ib2LjvJp0c81dNDS1DJqgaN3aE/fQsTNU06bgJVJ4Sos1ysLaqAMG
tshJsdWXQHDZTixfwLNmTahO7xumxRODU99Pr5EIaARvrEc/nNCtO6k+FUAuSdB1
sRRKPiiwkVdKNuI5qfqZTF9+/CZEdeVNoKfSFjrUyjkJ6EZT2osNyXhizBeqqynu
G9ws9RuvahfY9AUBBlyOM2FN4jimwa3OQZwYatpmK0JHZrLB2irliyoxIo28xr2p
dC4PR/OiJkUOYxcnxLiaotMAa1Vk8b2CqLz3iv+8ftdBPnEhiU/RJRFujsPFB3sm
kOPMd/r32EnUWx5EwseBdAjN2tToH0uAlQdk+SkXIb0V1B9MRZMilomQyJlgJWH7
c4OBSMOOOcSe+PcUWpDaZG596waIb3q+kx/4/FUK41Iba/T3gf1wS8Sc9SqELNAo
STmEvh2R/Uw=
=Cl/H
-----END PGP SIGNATURE-----
--=-=-=--
