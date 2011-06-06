Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab1FFUWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:22:01 -0400
Received: from home.keithp.com ([63.227.221.253]:54419 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081Ab1FFUWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:22:00 -0400
From: Keith Packard <keithp@keithp.com>
To: Melchior FRANZ <melchior.franz@gmail.com>, linux-kernel@vger.kernel.org
Cc: Nick Bowler <nbowler@elliptictech.com>, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression: Borked display on second output with Intel G45 in 3.0-rc2
In-Reply-To: <201106061920.07144@rk-nord.at>
References: <20110606171253.GA2925@elliptictech.com> <201106061920.07144@rk-nord.at>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 06 Jun 2011 13:21:53 -0700
Message-ID: <yunaadu1zj2.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Jun 2011 19:20:06 +0200, Melchior FRANZ <melchior.franz@gmail.com=
> wrote:

> That's apparently the bug that I've submitted a patch for on 2011/5/31:
> https://lkml.org/lkml/2011/5/31/393
> I assume/hope it's still in someone's queue.

Yeah, we "shouldn't" need to call intel_enable_plane from
i9xx_crtc_mode_set as it is called immediately afterwards from
i9xx_crtc_enable.

In any case, there's a bogus call in ironlake_crtc_mode_set which
clearly belongs in i9xx_crtc_mode_set:

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/in=
tel_display.c
index 81a9059..aa43e7b 100644
=2D-- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4687,6 +4687,7 @@ static int i9xx_crtc_mode_set(struct drm_crtc *crtc,
=20
 	I915_WRITE(DSPCNTR(plane), dspcntr);
 	POSTING_READ(DSPCNTR(plane));
+	intel_enable_plane(dev_priv, plane, pipe);
=20
 	ret =3D intel_pipe_set_base(crtc, x, y, old_fb);
=20
@@ -5217,8 +5218,6 @@ static int ironlake_crtc_mode_set(struct drm_crtc *cr=
tc,
=20
 	I915_WRITE(DSPCNTR(plane), dspcntr);
 	POSTING_READ(DSPCNTR(plane));
=2D	if (!HAS_PCH_SPLIT(dev))
=2D		intel_enable_plane(dev_priv, plane, pipe);
=20
 	ret =3D intel_pipe_set_base(crtc, x, y, old_fb);
=20
We need to figure out why this call (in i9xx_crtc_mode_set) is required,
but that will require finding hardware that reproduces the bug and
fixing it there.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN7TbhQp8BWwlsTdMRAiqQAJ40Tr4L6/tmo4ZuU3LVsgXKNUIbtACdGugo
jz46IpDmn9W4nes7VP/09hc=
=bZY2
-----END PGP SIGNATURE-----
--=-=-=--
