Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab1HLRMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:12:05 -0400
Received: from home.keithp.com ([63.227.221.253]:44792 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab1HLRMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:12:02 -0400
From: Keith Packard <keithp@keithp.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied@linux.ie
Subject: Re: i915 suspend crash: BUG: unable to handle kernel NULL pointer deferrence
In-Reply-To: <4E454D75.2090505@gmail.com>
References: <4E44C537.8040101@gmail.com> <yunobzusona.fsf@aiko.keithp.com> <4E454D75.2090505@gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 12 Aug 2011 10:11:57 -0700
Message-ID: <yunliuysgf6.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 12 Aug 2011 08:57:41 -0700, "Justin P. Mattock" <justinmattock@gmai=
l.com> wrote:

> [ 96.384971] [drm:i915_get_vblank_timestamp] *ERROR* Invalid crtc 0

You're not using KMS are you...

UMS mode disables a ton of features in the driver; you've hit a couple
that weren't getting skipped in all cases.

Here's some patches that make sure two of the disabled features are
correctly bypassed. If these work for you, I'll create a couple of
patches, one per bug. Afterwards, you should really consider switching
to KMS...

(meanwhile, thanks for finding bugs in ancient code!)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_ir=
q.c
index 02f96fd..9cbb0cd 100644
=2D-- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -2058,8 +2058,10 @@ void intel_irq_init(struct drm_device *dev)
 		dev->driver->get_vblank_counter =3D gm45_get_vblank_counter;
 	}
=20
=2D
=2D	dev->driver->get_vblank_timestamp =3D i915_get_vblank_timestamp;
+	if (drm_core_check_feature(dev, DRIVER_MODESET))
+		dev->driver->get_vblank_timestamp =3D i915_get_vblank_timestamp;
+	else
+		dev->driver->get_vblank_timestamp =3D NULL;
 	dev->driver->get_scanout_position =3D i915_get_crtc_scanoutpos;
=20
 	if (IS_IVYBRIDGE(dev)) {
diff --git a/drivers/gpu/drm/i915/i915_suspend.c b/drivers/gpu/drm/i915/i91=
5_suspend.c
index 87677d6..f107423 100644
=2D-- a/drivers/gpu/drm/i915/i915_suspend.c
+++ b/drivers/gpu/drm/i915/i915_suspend.c
@@ -871,7 +871,8 @@ int i915_restore_state(struct drm_device *dev)
 	}
 	mutex_unlock(&dev->struct_mutex);
=20
=2D	intel_init_clock_gating(dev);
+	if (drm_core_check_feature(dev, DRIVER_MODESET))
+		intel_init_clock_gating(dev);
=20
 	if (IS_IRONLAKE_M(dev)) {
 		ironlake_enable_drps(dev);


=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFORV7dQp8BWwlsTdMRArpIAJ99XSVjh/KpS6vw3rjX3uGxwDg5IwCg3S3e
GmKCd6K/3fXh8vsZlN1HlKw=
=9alP
-----END PGP SIGNATURE-----
--=-=-=--
