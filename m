Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab1KSSc3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 13:32:29 -0500
Received: from home.keithp.com ([63.227.221.253]:34861 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab1KSSc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 13:32:28 -0500
From: Keith Packard <keithp@keithp.com>
To: Eugeni Dodonov <eugeni@dodonov.net>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: By default, enable RC6 on IVB and SNB when reasonable
In-Reply-To: <CAC7LmnuWLA1LFQa-Vg4StOryo_wd1KjwaQ7m+Yb8Nhek7f=Qjw@mail.gmail.com>
References: <1321684889-18691-1-git-send-email-keithp@keithp.com> <CAC7LmnuWLA1LFQa-Vg4StOryo_wd1KjwaQ7m+Yb8Nhek7f=Qjw@mail.gmail.com>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sat, 19 Nov 2011 10:32:19 -0800
Message-ID: <86aa7sklos.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 19 Nov 2011 07:25:09 -0200, Eugeni Dodonov <eugeni@dodonov.net> wro=
te:

> Just one question I caught on 2nd read. Shouldn't we have #else within
> this #ifdef block, to return 1? Otherwise, if CONFIG_INTEL_IOMMU is
> not defined, we'll always disable rc6.

Oops! Thanks for catching this. Here's a new version of that function
(the rest of the patch is the same). This one has explicit conditions
for Ironlake and Sandybridge (when CONFIG_INTEL_IOMMU is set), allowing
the Ivybridge and Sandybridge-without-IOMMU cases to take the default
path. This will also cause all future chips to enable rc6 by default.
=20
+static bool intel_enable_rc6(struct drm_device *dev)
+{
+	/*
+	 * Respect the kernel parameter if it is set
+	 */
+	if (i915_enable_rc6 >=3D 0)
+		return i915_enable_rc6;
+
+	/*
+	 * Disable RC6 on Ironlake
+	 */
+	if (INTEL_INFO(dev)->gen =3D=3D 5)
+		return 0;
+
+#ifdef CONFIG_INTEL_IOMMU
+	/*
+	 * Enable rc6 on Sandybridge if DMA remapping is disabled
+	 */
+	if (INTEL_INFO(dev)->gen =3D=3D 6)
+		return no_iommu || dmar_disabled;
+#endif
+	return 1;
+}
+

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTsf2MzYtFsjWk68qAQimkA/+PHQuw1bwykPAajUbKmr8KF4Kt8FQGatY
SglrUTDTZoH5jIQcCXZjWuZUL6laMyUYkcPTxfKyHSA26XwCVP9V7Z26zPzG1fFl
t9kuUvsShx90x4mlPXQmBFfH3ppS/yclkur5jvgd0jVXKdhLLDY1vRq9L7ro6VGK
VxtmA8mnX95d6u3Nc9gX1buYhMq1C6yGJUB4Mku/a4rbEgj0Ti0u+/8D1OG2KGB4
Rzu9qhpTTNSRZ4sSqxUXsGteZPIGolXdo23+sLdLT53d/Du04dgbg39vPobpRg1s
PlNndJi6JfXaUGSIdr4UAvGw9ixySJ6bMyajCARo2Lfjkrb4kc8ZBA6IIXS3Qpbj
WuW9sb0eiTTvUTZg1i4HxuMEgaxA8IsyV1ZPCNtVBRDQNA3aASCF2PgR7cHS7oU+
lDJ2XHfXvA1N88CL0uMQc9vIy3E5mcKvZsCAyH6lzD/KyFBJC1Th+KCQWHyXI2sw
REB5ZUvzsBPq7ayVCduG8sHmyzT3RWF2O9IAhC06R9kLiSgbdVi3hXgdVZkzl3Aa
dRqjKUbTeQRP9YE3ifIERfkwvG213h536W5xi4UBcxLpNjw5OhWTi3wfFAii3xhN
GQsB6wepp8eSpZ/wxRhqBC2IqhPx9iO872bgPBsF8daiaqI1eKq/oueVcHgyBYxh
5tdvPE0gIyU=
=HW9U
-----END PGP SIGNATURE-----
--=-=-=--
