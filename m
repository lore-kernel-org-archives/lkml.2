Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab1K2NJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 08:09:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:51179 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356Ab1K2NJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 08:09:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="80868917"
From: Keith Packard <keith.packard@intel.com>
To: Jerker Buud <b.jerker@gmail.com>,
        Patrik Kullman <patrik.kullman@gmail.com>
Subject: Re: drivers/gpu/drm/i915/intel_dp.c problem with commit dc22ee6fc18ce0f15424e753e8473c306ece95c1
In-Reply-To: <CACVkyFdhpU1sQb-T-pXYkV8Ot27+LYxV_=FGd=aPLLyrD3-1dg@mail.gmail.com>
References: <CACVkyFdhpU1sQb-T-pXYkV8Ot27+LYxV_=FGd=aPLLyrD3-1dg@mail.gmail.com>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Sat, 26 Nov 2011 11:27:11 -0800
Message-ID: <86k46m8z1s.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 26 Nov 2011 09:50:41 -0800, Jerker Buud <b.jerker@gmail.com> wrote:

> 245,247c245,246
> <       if (!is_edp(intel_dp) &&
> <           (intel_dp_link_required(intel_dp, mode->clock)
> <            > intel_dp_max_data_rate(max_link_clock, max_lanes)))
> ---
> >       if (intel_dp_link_required(intel_dp, mode->clock)
> >           > intel_dp_max_data_rate(max_link_clock, max_lanes))

Ok, I think I understand why this change is required.

These machines are 'optimized' to provide the bare minimum connection
necessary between the CPU and the eDP panel -- a single lane is hooked
up, which is just enough to run the link at 18bpp, but not enough to run
it at 24bpp.

The problem here (in intel_dp_link_required) is that this is being
called to see which modes can be supported on the panel. Without the
CRTC being configured with the appropriate bpp value, this code assumes
24bpp.

I thought Adam Jackson had some code around that automatically switched
From=2024bpp to 18bpp when the link didn't have enough bandwidth for
24bpp, but I can't find that now.

In any case, I think we need to centralize the bpp selection inside
intel_dp.c instead of having it in both places. Then, we can make that
depend on the requested mode as well as the machine configuration.

Here's a patch which uses the VBT configured bpp value in this case. I'd
love to hear whether this suffices to resolve your problem.

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_d=
p.c
index 294f557..3e15479 100644
=2D-- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -212,10 +212,16 @@ intel_dp_link_required(struct intel_dp *intel_dp, int=
 pixel_clock)
 {
 	struct drm_crtc *crtc =3D intel_dp->base.base.crtc;
 	struct intel_crtc *intel_crtc =3D to_intel_crtc(crtc);
=2D	int bpp =3D 24;
+	struct drm_device *dev =3D intel_dp->base.base.dev;
+	struct drm_i915_private *dev_priv =3D dev->dev_private;
+	int bpp;
=20
 	if (intel_crtc)
 		bpp =3D intel_crtc->bpp;
+	else if (intel_dp->base.type =3D=3D INTEL_OUTPUT_EDP)
+		bpp =3D dev_priv->edp.bpp;
+	else
+		bpp =3D 24;
=20
 	return (pixel_clock * bpp + 9) / 10;
 }

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTtE9jzYtFsjWk68qAQjxChAA0Q28ficEMzuyf2sUE6FfkSyKAy/ykmU+
/LTK+9UShE8AeZ0h5g5Dd5inj2vqqgpFBL8OkZEGoDxcs1nCQVDeuNoPoW9uuenY
bKTwZbwXEe8Ms9gAahuqv2Drygwu7djIjF0IFD93lI1uvc59oH+ql2LNpdWyfsgU
GQ+J3M3Z3Zn8SAmNko9fLbpeI61rMKhIMYbcMGUfCqF/sTN38XqW15ZNINeIk9+6
GkHG+mqzWTSFRPjPYop4UB90jcFHy2sVtFCLAaauHvd0Gm+g2bByuB5vR9fMIxQR
1YLOAU/8f89oFvTTMBVygebUfjDC7PNNIux8WVMtSxr5F8SRHpZYAJkW6mfY4XOX
ETxnPHufBm3fBhBG5fPt0yCq59Ecvut0tcJP+GLKIFhkVcr5Ys5gl2mxuvGRSG8g
e4UNVTCBVjvj3etTVP5Q3ojPUiwa1uiuSTi/gVNvyMKZxtR3CSVMBWIY7RL1VPn3
oQ9CX50y9PVycNQ9XM3YXIawAkJUzjSq6jkWpsw9tS+3whT86zsZNlkxZM3vZp5r
t4YySL0DAb7TQXvpEk3PM2W17y6gBUa/Xb6Qr7p0WSzquGY4FSQxuAj1/roDg8GI
3go3GMnTxpA2F8a4+WakSwvqD120kOFrmPJTNcbGZ5ihW7hVDZvo2CKSAmx2LRcR
kcpefyeyQSU=
=NbGF
-----END PGP SIGNATURE-----
--=-=-=--
