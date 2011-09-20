Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab1ITRSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:18:09 -0400
Received: from home.keithp.com ([63.227.221.253]:60222 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab1ITRSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:18:07 -0400
From: Keith Packard <keithp@keithp.com>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.1-rc5 is the worst
In-Reply-To: <CAC9WiBgn2cr7zY8_9j7SEwQ+rPye9s3cM+Ex4WUxam78qAZhRQ@mail.gmail.com>
References: <CAC9WiBjoO50H5ZQEShbdZ=64ZXz6Q-OdD+VSD-YrBry3hvdJJQ@mail.gmail.com> <yunbousl9f5.fsf@aiko.keithp.com> <CAC9WiBgn2cr7zY8_9j7SEwQ+rPye9s3cM+Ex4WUxam78qAZhRQ@mail.gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 20 Sep 2011 10:18:02 -0700
Message-ID: <yun1uvbf7zp.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sun, 11 Sep 2011 20:33:14 +0200, Francis Moreau <francis.moro@gmail.com>=
 wrote:

> Ok this seems to fix the issue.

I've posted a patch that disables fbc by default on Ironlake machines;
I'd like to have it tested to make sure it actually does what it's
supposed to do, and resolves the issue for you without a special kernel
command line argument. If it does, I'll make sure this lands in 3.1

From=20e3d529ddfc9cec12f05e1dde0a0bf0469e15db04 Mon Sep 17 00:00:00 2001
From: Keith Packard <keithp@keithp.com>
Date: Mon, 19 Sep 2011 21:34:19 -0700
Subject: [PATCH] drm/i915: FBC off for ironlake, otherwise on by default

Make the default FBC behaviour chipset specific, allowing us to turn
it on by default for everything except Ironlake where it has been
seen to cause trouble with screen updates.

Signed-off-by: Keith Packard <keithp@keithp.com>
=2D--
 drivers/gpu/drm/i915/i915_drv.c      |    4 ++--
 drivers/gpu/drm/i915/intel_display.c |   10 +++++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_dr=
v.c
index ce045a8..f07e425 100644
=2D-- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -67,11 +67,11 @@ module_param_named(i915_enable_rc6, i915_enable_rc6, in=
t, 0600);
 MODULE_PARM_DESC(i915_enable_rc6,
 		"Enable power-saving render C-state 6 (default: true)");
=20
=2Dunsigned int i915_enable_fbc __read_mostly =3D 1;
+unsigned int i915_enable_fbc __read_mostly =3D -1;
 module_param_named(i915_enable_fbc, i915_enable_fbc, int, 0600);
 MODULE_PARM_DESC(i915_enable_fbc,
 		"Enable frame buffer compression for power savings "
=2D		"(default: false)");
+		"(default: -1 (use per-chip default))");
=20
 unsigned int i915_lvds_downclock __read_mostly =3D 0;
 module_param_named(lvds_downclock, i915_lvds_downclock, int, 0400);
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/in=
tel_display.c
index 9fb4a40..bc05deb 100644
=2D-- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1799,6 +1799,7 @@ static void intel_update_fbc(struct drm_device *dev)
 	struct drm_framebuffer *fb;
 	struct intel_framebuffer *intel_fb;
 	struct drm_i915_gem_object *obj;
+	int enable_fbc;
=20
 	DRM_DEBUG_KMS("\n");
=20
@@ -1839,7 +1840,14 @@ static void intel_update_fbc(struct drm_device *dev)
 	intel_fb =3D to_intel_framebuffer(fb);
 	obj =3D intel_fb->obj;
=20
=2D	if (!i915_enable_fbc) {
+	enable_fbc =3D i915_enable_fbc;
+	if (enable_fbc < 0) {
+		DRM_DEBUG_KMS("fbc set to per-chip default\n");
+		enable_fbc =3D 1;
+		if (INTEL_INFO(dev)->gen =3D=3D 5)
+			enable_fbc =3D 0;
+	}
+	if (!enable_fbc) {
 		DRM_DEBUG_KMS("fbc disabled per module param (default off)\n");
 		dev_priv->no_fbc_reason =3D FBC_MODULE_PARAM;
 		goto out_disable;
=2D-=20
1.7.6.3

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOeMrKQp8BWwlsTdMRAtxDAJwJvYz0ng3wiDV5ae2rp8jSHk/qPgCgrzH2
4UvGO/a58Ms3EYuoGIx1MEw=
=dGcz
-----END PGP SIGNATURE-----
--=-=-=--
