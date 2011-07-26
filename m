Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab1GZFyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 01:54:32 -0400
Received: from home.keithp.com ([63.227.221.253]:46445 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab1GZFy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 01:54:26 -0400
From: Keith Packard <keithp@keithp.com>
To: Andrew Lutomirski <luto@mit.edu>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Hold struct_mutex during hotplug processing
In-Reply-To: <CAObL_7EqL+1rhP=9go0EnCrVwWoZqgpVw0ZmLYa99vvFBJTmGQ@mail.gmail.com>
References: <1311613829-4990-1-git-send-email-keithp@keithp.com> <20110725103732.623d7b65@jbarnes-desktop> <CAObL_7EqL+1rhP=9go0EnCrVwWoZqgpVw0ZmLYa99vvFBJTmGQ@mail.gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 25 Jul 2011 22:54:19 -0700
Message-ID: <yunsjpt7fjo.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Jul 2011 22:52:15 -0400, Andrew Lutomirski <luto@mit.edu> wrote:

> Doesn't help :(

Oh, it helps, just not this issue :-)

> When I do 'xset dpms force off', one of two things happens.  Either
> the display comes back all by itself or it never comes back until I
> power cycle it.

Oh. Right. Actual DPMS, as in power savings. So, I think Jesse and I
were both wrong -- we *do* need to track DPMS in the DP driver so that
we can skip link retraining when DPMS is off. The rest of the connection
is disabled, so doing the link retraining may well confuse the DP system
badly. Turning the monitor off and back on will generate suitable hot
plug messages and presumably clean things up once the rest of the stack
is running again.

> If the display is generating a hotplug event after the dpms code drops
> the link, then with "drm/i915/dp: remove DPMS mode tracking from DP"
> applied the driver will try to bring the display back up.  Maybe my
> display can't handle coming back up that quickly after being told to
> go to sleep, or maybe there's another bug.

Indeed you are correct -- we don't gate the retraining on whether the
monitor is supposed to be running or not.

> Is the original patch supposed to bring the display up if the user
> unplugs it and re-plugs it?  If so, why?

Yes. In the absence of an external agent listening to the hotplug events
(which is hard to arrange these days, unless you're running an X
environment that doesn't watch for monitor hot-plug), the kernel will
see the hot-plug event, decide that because the monitor is supposed to
be running (has a CRTC assigned), it will go ahead and try to retrain
the DP link.

> And shouldn't a dpms off
> command at least stick until a hotplug event reports that the display
> isn't there?

The DPMS off should stick until DPMS is set back on -- hotplug shouldn't
have any effect on DPMS.

Here's a patch which reverts the DPMS tracking, and then fixes the bug
that it had -- you wouldn't get retraining on hotplug after the driver
had been initialized because nothing in the mode setting path would set
the dpms_mode to DRM_MODE_DPMS_ON, so the hotplug code would bail every
time. With that fixed, this patch should work for you *and* for others.

Care to give it a try?

From=2059b920597999381fab70c485c161dd50590e561a Mon Sep 17 00:00:00 2001
From: Keith Packard <keithp@keithp.com>
Date: Mon, 25 Jul 2011 22:37:51 -0700
Subject: [PATCH] Revert and fix "drm/i915/dp: remove DPMS mode tracking from
 DP"

This reverts commit 885a50147f00a8a80108904bf58a18af357717f3.

We actually *do* need to track DPMS state so that on hotplug, we don't
retrain the link until DPMS is disabled.

However, that code had a small bug -- it wouldn't set the dpms_mode at
mode set time, and so link retraining would not actually occur on
monitor hotplug until the monitor had gone through a DPMS off/DPMS on
cycle. Setting dpms_mode to DRM_MODE_DPMS_ON in intel_dp_commit fixes that.

Signed-off-by: Keith Packard <keithp@keithp.com>
=2D--
 drivers/gpu/drm/i915/intel_dp.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_d=
p.c
index 9f134d2..4493641 100644
=2D-- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -50,6 +50,7 @@ struct intel_dp {
 	bool has_audio;
 	int force_audio;
 	uint32_t color_range;
+	int dpms_mode;
 	uint8_t link_bw;
 	uint8_t lane_count;
 	uint8_t dpcd[8];
@@ -1011,6 +1012,8 @@ static void intel_dp_commit(struct drm_encoder *encod=
er)
=20
 	if (is_edp(intel_dp))
 		ironlake_edp_backlight_on(dev);
+
+	intel_dp->dpms_mode =3D DRM_MODE_DPMS_ON;
 }
=20
 static void
@@ -1045,6 +1048,7 @@ intel_dp_dpms(struct drm_encoder *encoder, int mode)
 		if (is_edp(intel_dp))
 			ironlake_edp_backlight_on(dev);
 	}
+	intel_dp->dpms_mode =3D mode;
 }
=20
 /*
@@ -1591,6 +1595,9 @@ intel_dp_get_dpcd(struct intel_dp *intel_dp)
 static void
 intel_dp_check_link_status(struct intel_dp *intel_dp)
 {
+	if (intel_dp->dpms_mode !=3D DRM_MODE_DPMS_ON)
+		return;
+
 	if (!intel_dp->base.base.crtc)
 		return;
=20
@@ -1939,6 +1946,7 @@ intel_dp_init(struct drm_device *dev, int output_reg)
 		return;
=20
 	intel_dp->output_reg =3D output_reg;
+	intel_dp->dpms_mode =3D -1;
=20
 	intel_connector =3D kzalloc(sizeof(struct intel_connector), GFP_KERNEL);
 	if (!intel_connector) {
=2D-=20
1.7.5.4



=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOLlaLQp8BWwlsTdMRAqwOAKC+4Ze1SyfxVCQrwpusdZVBUYmFhQCfTzxa
Qlw7bVu+VXh0AgLruRaS2u0=
=d8Jy
-----END PGP SIGNATURE-----
--=-=-=--
