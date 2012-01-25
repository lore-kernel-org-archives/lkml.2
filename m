Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab2AYWpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 17:45:49 -0500
Received: from home.keithp.com ([63.227.221.253]:60173 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab2AYWps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 17:45:48 -0500
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: [Intel-gfx] [PATCH 1/2] drm/i915: Force explicit bpp selection for intel_dp_link_required
In-Reply-To: <20120125215054.GI3896@phenom.ffwll.local>
References: <1327508186-26704-1-git-send-email-keithp@keithp.com> <1327508186-26704-2-git-send-email-keithp@keithp.com> <20120125125116.5cea2c4b@jbarnes-desktop> <86aa5bcwhs.fsf@sumi.keithp.com> <20120125215054.GI3896@phenom.ffwll.local>
User-Agent: Notmuch/0.11 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 25 Jan 2012 14:45:44 -0800
Message-ID: <867h0fcsfb.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Jan 2012 22:50:55 +0100, Daniel Vetter <daniel@ffwll.ch> wrote:

> I think we could compute this in crtc->mode_fixup (crtc->prepare doesn't
> have the mode and adjusted_mode arguments). We could then store the
> computed bpc and dithering in one of the private fields. We'd still have
> to loop over all encoders, but alas ...

Alas, intel_crtc_mode_fixup is called *after* the intel_dp_mode_fixup. So,
we'd either need to change drm_crtc_helper, or have
intel_crtc_mode_fixup call down into intel_dp.c to set the link
parameters. In either case, ick.

> Afaics we'll still correctly fall back to 6bpc (undithered for 16bpp
> obviously) and hence things should keep on working.

Right, the problem is that the DP link parameters will be set to support
24bpp color, so we'll use a higher clock/lane-count than strictly
necessary as intel_dp_mode_fixup doesn't take the frame buffer format
into consideration when computing the link values.

> Yeah, there are a few rough corners with the bpc computation in patch 2.
> I'll try to throw around a few ideas that crossed my mind while reading
> through it in a reply there.

Thanks. I'm not happy with it either.

In short, I think we can (and should) apply the simple first patch to
drm-intel-fixes so that at least displays work consistently, and then
come up with a nicer patch that computes correct link parameters, and
also supports 10bpc formats.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTyCGGDYtFsjWk68qAQiwGQ/+OnHQicFscqdf7T+p1TnIm74/pEQDQ5r1
m73b2tbdOjugKeEhr7yCmKzKgZYEF1Je5JmY9spKhoKZrU1GZfHjGeAGcbl4gEzI
x6RRCfnR1CINmtoWwyCGq64h2zHGmc1ImzL/AEjC9w7lnXAoyF/7xKMbQv656Aa2
v0C3AT9uUCz6RrH5wqDbx82Yu1777iJdNd0+/Bpnnc0K/C4nhmkPCoeNNwepOegw
D86VfyopS93GmdYoYuCaVQTUtKGjKYWltv4TO9TmfIJX2+IBKR0L4ScASjuLeSZ+
WyYADq95mr0fIbqgoZNm7mBGUVnEfy5A1+UbZ6STYPAcuLQfykrYpzB7r09YJciw
Gh1dczqv2sRHFhZCeNhOpBHr95cVv2PWLVsmAeqBygFUJ2d9y3mkxwN7lRlQztS/
iHBfyMNOCU010NSWoNS7vEVxHhgexxudE68oDV9O00IHlzTob9zBVuT7nPsSvICn
VUb3Aq4YFanPpAbOF8/r1qWuUm7Q+1CWVUdF+vrlPyA7geWhXxRFC7WSMD+gD04U
KUoecTvZYwjdAtK1BBC7J0iDCORhBVwjIEB+EGZdOMmFQH/3AzgP2b4FZ3v6a2zn
yN1AMniaKaB/oYKw/9e2u4VaIuGTXnLua/wnd487K+C39ynZXUly/AeTDmlAF7tL
Z2x9BqgH04o=
=S+rK
-----END PGP SIGNATURE-----
--=-=-=--
