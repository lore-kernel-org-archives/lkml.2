Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab2AYVR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 16:17:57 -0500
Received: from home.keithp.com ([63.227.221.253]:45285 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab2AYVR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 16:17:56 -0500
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: [Intel-gfx] [PATCH 1/2] drm/i915: Force explicit bpp selection for intel_dp_link_required
In-Reply-To: <20120125125116.5cea2c4b@jbarnes-desktop>
References: <1327508186-26704-1-git-send-email-keithp@keithp.com> <1327508186-26704-2-git-send-email-keithp@keithp.com> <20120125125116.5cea2c4b@jbarnes-desktop>
User-Agent: Notmuch/0.11 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 25 Jan 2012 13:17:51 -0800
Message-ID: <86aa5bcwhs.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Jan 2012 12:51:16 -0800, Jesse Barnes <jbarnes@virtuousgeek.org>=
 wrote:

> Yeah, looks like I got this wrong when I added the pipe bpp field.
> Wonder if there's a good way to catch this sort of bug with an assert
> so we don't get the order mixed up again...

Ideally, we'd figure out a way to compute this only once. I think the
only relevant piece of data here is what bpc the pipe should run at, and
that can be computed at any time during the mode set. We'd then be able
to compare the pipe bpc with the frame buffer bpp to decide when to
dither in the crtc mode set code.

> The big downside here is that we'll be very pessimistic about the link
> bw requirements for say 16 or 8bpp modes.

Right, with this patch, we'll choose link parameters capable of
supporting 8bpc, even for 16bpp video modes. Note that 8bpp video modes
need 8bpc links as they have colormaps with 8bpc data in them.

> I see you have another patch to address some of this, but I wonder if
> we have enough info to calculate the bpp at prepare time so it's set
> early on for use by both the crtc and encoder code?

fixup gets exactly the same info as mode set, so it should end up with
exactly the same resulting bpc, which will set the link bandwidth to
support 6bpc mode if that's all that is needed.

One problem with the patch is that the pre-PCH mode set path doesn't use
intel_choose_pipe_bpp_dither, so the condition for 6bpc mode is
duplicated in i9xx_crtc_mode_set and intel_dp_mode_fixup.

If crtc->fixup was called before encoder->fixup, we could have computed
bpp in the crtc->fixup function and then used it in encoder->fixup.

Alternatively, crtc->fixup could call into the DP code to set the
link_bw, lane_count and adjusted_mode->clock values after it sets the
bpp, but that seems to break the abstraction even more.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTyBxfzYtFsjWk68qAQjOHxAAqNrw4//RLKkk3wrDHRsa6EjpT7JrCaQF
Jqgp4jq8Yj9F0Ez7jEPNt+1bL3EEG2U/UtzjhutNNXFvzp2aZ9FU81rThkAsR3d4
Gx+a6t5rYFjFbIO2y+bEsKOdLNDJBqhOqqVzq0qoEAzGGWh0yBlHvAzwmKyjtkWP
iPyLW+gMy+OPzqEPlOeKO1QJ0dIqM2uYIDCR1WVqthBcaMXg88T6VdLKhkD4sSjb
LvX+0UXwsmdpodZW2dY6nNEPQcZs4sLZ5fXx4VbHKKCyfTGbfRMa/s+H3DVnZ1R+
2YFJGs1e8QMVhux+nIJIBAvwOl1uctRYGioguTNf2dlA2895NFqSwoR0Xd4O2J5F
NwyuHaxiRQXVphSln55F9AJdstyOo5MsnCS2KgpWUOT0ARsSbIO6aRhhMcoaF67J
f4B+2gsv1gZurGAcQIuT/BHCHGFNYqICdTz9xlaDn3kIWBmpnr6Yzk2uYnXF173Y
ROQky9IzNSGEyVkbmavXk9t8S4gQzj+RloEhgA2eL0maKo9AwqR2f0e+AEHgSqAB
1B/BkoGtD7arWUCfjqL3mMOuqrvdFWTPt33eweTmzR5JE54bQFxnQ9mRbR8a0nXE
LkSWD7UklcuY6DIJPo2hrI8dKR9Rdan3PUSBY7ID/bBOYQxDYQNvpuzh50Y4/FmY
b03+sAquUUA=
=q+Y2
-----END PGP SIGNATURE-----
--=-=-=--
