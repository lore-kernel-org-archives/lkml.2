Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab2AUUxI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 15:53:08 -0500
Received: from home.keithp.com ([63.227.221.253]:44643 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab2AUUxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 15:53:06 -0500
From: Keith Packard <keithp@keithp.com>
To: Lubos Kolouch <lubos.kolouch@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i915 wakes from suspend to RAM with blank screen after commit cd9dde44f47501394b9f0715b6a36a92aa74c0d0
In-Reply-To: <20120121184453.GA2698@nbgentoo>
References: <jfe47e$5dn$1@dough.gmane.org> <86mx9gkjlv.fsf@sumi.keithp.com> <20120121184453.GA2698@nbgentoo>
User-Agent: Notmuch/0.11 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sat, 21 Jan 2012 12:53:00 -0800
Message-ID: <86hazokcb7.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--==-=-=

On Sat, 21 Jan 2012 19:44:53 +0100, Lubos Kolouch <lubos.kolouch@gmail.com> wrote:

> dmesg after boot - http://paste.pocoo.org/show/538343/
> dmesg after failed resume -  http://paste.pocoo.org/show/538344/

Ok, that's weird -- we're choosing a different display port link speed
on resume than at boot time. I have a theory that intel_dp_mode_fixup is
accidentally using the current bpp value when computing the values
needed for the new mode, and that this value may differ between boot and
resume.

Here's a patch to dump some debug info out to test this theory.


--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTxslrDYtFsjWk68qAQghJg/8CS7tuKhL0umzslKhGvJyL4+MuXuVXFfb
WRe0tAR1n8ulBQ/9uEvzu2f13d3MvB9JvNKf+e/xgiSEwnkYD+qF5xVaXIzSU4cq
1n7ChIfkK45qISn8+wxVcOzUFyX0BYhu0sti+CsJABU6YV7x8HRXsPM7J1M9sEaK
TUAnHKPP/wiCX2fM4osZABRqTijLRdiFfuNI6fqPadhtIuCm68cSivji4rcLgTco
V8ztQ6ukd34lSjx8zmXQolD64vWtzqaq9iXev6I+zGK4MVNu7iYcdtbDbjtgz3o5
qw/j5L9ozP5c9k/djiKBbhb3MuPQtBOlliAsW2QtmKEsFdabkjLo5uLC1CHOt/ES
Xbak9W7ejwcHqmZRQmMaMUuKECItdRWtHUpMBAvcXRRb+tejyShhYXDkxwb4icx0
0gZ8CBOP4rJ5X4Cl1o1CcCtQlVRoCTwib+t6Ea5iUK8cdaeqcb751ywZqL4x8h3O
qUtMmH1Lrk4wgrHyW9IIvp3WOXWZ7oAAdu7n/rOODf7q9YmpFAKgEJJZOJUwhBO/
2HAm0eUct8Jpj7w6F1vQwXOGpIqPzbJoQjoYVpWLWDSdM9nlp4u7G7fVPwp/aXWJ
pHJ+V2vOyyfFQlg3aem4iDqo6WxbWSdpTEY7U9rNVE8/l0DS5E9COQEp85uvKkBV
8A587rtsBpo=
=AqYt
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-drm-i915-Output-a-bit-of-debug-info-for-display-port.patch

>From 2b16db9fccc6927f3e09020144d5148acc025f58 Mon Sep 17 00:00:00 2001
From: Keith Packard <keithp@keithp.com>
Date: Sat, 21 Jan 2012 12:48:38 -0800
Subject: [PATCH] drm/i915: Output a bit of debug info for display port
 bandwidth

Something weird is going on with link bandwidth testing; this may
help sort out what's wrong.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index db3b461..796d534 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -697,10 +697,13 @@ intel_dp_mode_fixup(struct drm_encoder *encoder, struct drm_display_mode *mode,
 		mode->clock = intel_dp->panel_fixed_mode->clock;
 	}
 
+	DRM_DEBUG_KMS("using bpp %d to find link_bw and lane_count\n", bpp);
 	for (lane_count = 1; lane_count <= max_lane_count; lane_count <<= 1) {
 		for (clock = 0; clock <= max_clock; clock++) {
 			int link_avail = intel_dp_max_data_rate(intel_dp_link_clock(bws[clock]), lane_count);
 
+			DRM_DEBUG_KMS("lane_count %d clock %d link_avail %d link_required %d\n",
+				      lane_count, clock, link_avail, intel_dp_link_required(intel_dp, mode->clock, bpp));
 			if (intel_dp_link_required(intel_dp, mode->clock, bpp)
 					<= link_avail) {
 				intel_dp->link_bw = bws[clock];
-- 
1.7.8.3


--=-=-=


Please try this on the broken kernel, sending along the dmesg output at
boot and resume time again.

-- 
keith.packard@intel.com

--=-=-=--
