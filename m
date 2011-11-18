Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab1KRT0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:26:05 -0500
Received: from home.keithp.com ([63.227.221.253]:37053 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab1KRT0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:26:03 -0500
From: Keith Packard <keithp@keithp.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Daniel Mack <zonque@gmail.com>, Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, harald@redhat.com,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Fix invalid backpanel values for GEN3 or older chips
In-Reply-To: <s5hlirelndd.wl%tiwai@suse.de>
References: <s5hlirgm1kg.wl%tiwai@suse.de> <yunsjlnl1f6.fsf@aiko.keithp.com> <s5hlirelndd.wl%tiwai@suse.de>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 18 Nov 2011 11:25:48 -0800
Message-ID: <861ut5mdvn.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Nov 2011 17:33:50 +0100, Takashi Iwai <tiwai@suse.de> wrote:

> If it's only with 915GM, we'll just need to change IS_PINEVEW() to
> IS_PINEVIEW() || IS_I915GM().  This might be a safer option at this
> moment unless we check all cases or specs...

I read through the hardware docs yesterday and figured out what was
going on. On all pre-gen4 hardware, the maximum backlight value has the
lowest bit (of 16) hard-wired to zero. This means that the possible
backlight duty cycle values are limited to 0 .. 0xfffe.

On older hardware, this was managed by reporting this true range. This
meant that the set_backlight path didn't need any special code; simply
setting the values as provided should have worked just fine.

On Pineview, this was changed (for reasons unknown) to use only 15 bits
for backlight levels. The range of possible values is then
0 .. 0x7fff. In this case, values have to be shifted by one to convert
between the advertised range of 0 .. 0x7fff and the hardware range of
0 .. 0xfffe.

Exposing the range of 0 .. 0xfffe introduces a potential problem --
write a value of 0xffff and the hardware gets mightily confused,
and probably ends up turning the backlight off. Using the range of
0 .. 0x7fff avoids this issue completely.

Using the narrower range does limit the precision of the backlight level
setting, but it seems like 32767 possible values is more than sufficient...

Here's a patch which just uses the pineview version everywhere (and
cleans that up at the same time).

From=20e06789f688dc7ab1331f5f15ad3d60326b5139b4 Mon Sep 17 00:00:00 2001
From: Keith Packard <keithp@keithp.com>
Date: Fri, 18 Nov 2011 11:09:24 -0800
Subject: [PATCH] drm/i915: Treat pre-gen4 backlight duty cycle value
 consistently

For i945 and earlier chips, the backlight frequency value had the low
bit (of 16) fixed to zero. The Pineview code path handled this by just
exposing the backlight range as 15 bits while other chips had the
backlight range limited to 0 .. 0xfffe.

This patch makes everyone take the pineview code path, providing 15
bits of backlight duty cycle range which seems more than sufficient to me.

Signed-off-by: Keith Packard <keithp@keithp.com>
=2D--
 drivers/gpu/drm/i915/intel_panel.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/inte=
l_panel.c
index 21f60b7..04d79fd 100644
=2D-- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -178,13 +178,10 @@ u32 intel_panel_get_max_backlight(struct drm_device *=
dev)
 	if (HAS_PCH_SPLIT(dev)) {
 		max >>=3D 16;
 	} else {
=2D		if (IS_PINEVIEW(dev)) {
+		if (INTEL_INFO(dev)->gen < 4)
 			max >>=3D 17;
=2D		} else {
+		else
 			max >>=3D 16;
=2D			if (INTEL_INFO(dev)->gen < 4)
=2D				max &=3D ~1;
=2D		}
=20
 		if (is_backlight_combination_mode(dev))
 			max *=3D 0xff;
@@ -203,13 +200,12 @@ u32 intel_panel_get_backlight(struct drm_device *dev)
 		val =3D I915_READ(BLC_PWM_CPU_CTL) & BACKLIGHT_DUTY_CYCLE_MASK;
 	} else {
 		val =3D I915_READ(BLC_PWM_CTL) & BACKLIGHT_DUTY_CYCLE_MASK;
=2D		if (IS_PINEVIEW(dev))
+		if (INTEL_INFO(dev)->gen < 4)
 			val >>=3D 1;
=20
 		if (is_backlight_combination_mode(dev)) {
 			u8 lbpc;
=20
=2D			val &=3D ~1;
 			pci_read_config_byte(dev->pdev, PCI_LBPC, &lbpc);
 			val *=3D lbpc;
 		}
@@ -246,11 +242,9 @@ static void intel_panel_actually_set_backlight(struct =
drm_device *dev, u32 level
 	}
=20
 	tmp =3D I915_READ(BLC_PWM_CTL);
=2D	if (IS_PINEVIEW(dev)) {
=2D		tmp &=3D ~(BACKLIGHT_DUTY_CYCLE_MASK - 1);
+	if (INTEL_INFO(dev)->gen < 4)=20
 		level <<=3D 1;
=2D	} else
=2D		tmp &=3D ~BACKLIGHT_DUTY_CYCLE_MASK;
+	tmp &=3D ~BACKLIGHT_DUTY_CYCLE_MASK;
 	I915_WRITE(BLC_PWM_CTL, tmp | level);
 }
=20
=2D-=20
1.7.7.3



=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTsaxPDYtFsjWk68qAQjnCRAApUzHb4I/AeIaAzxr+mVIWHreXo4XtbB8
6Qd69KAJQp9QR8SjURmgY5NRtbr2LU6ja1JLS4POJcJw0EmdUX0u6IJKPnxOQSWh
OrCXD7CulwUmRj9TIIks8I/RD+wN5cZgQvW8+yy3yz2aoXpLGZ9TBVgSBLdJ/+xZ
1ejYnxI2rBPjqhXfTYJ+I9Gf5rd9vJjPoq8nKAO2ME4jisvrcqIHapXmTC/+addo
KazjkGcL1uGBytI5+AE0FPlDfH7JoeAdkKAYy9eQC1ZbvS2P8qbR8afGPRgnZxze
28VSrSoPe5y82GMY9jmF+rdcQcXLqlxs8Lch3B8HozbfE905Bh+G0oHtutOCo1Cu
ViJ9uBdqHOuvp4DdfC3asFmz0kiJZYaK4suhDR3fmeiUSBzR4VvzsBbsp5b3tfrj
V+K+rANy8IdEnJbTJzFG7hnUV+kumChPqSQq08ZX7xkguG3ebQyiFWZubTlclXVS
DcGa9s2AJXpf32gEffncJSxLKJSdGbzNljeziVbZ/NRPfga1m0eMey/VuECzoqHY
A2coDie7o9eCmMnGt5I/2DBIRZooq8qHeUMO/hm8d3/MdxmztX+JZaX1WtT1fy5b
t+DPjs/As6JXWs5fBOVfMd+wuByiG35TJwkVpuNxHqnnFEvqPBHgaExKdSmUCTqw
PmJm9nf+Mxo=
=89dl
-----END PGP SIGNATURE-----
--=-=-=--
