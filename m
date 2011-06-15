Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab1FOQim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 12:38:42 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:51973 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab1FOQij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 12:38:39 -0400
From: Eric Anholt <eric@anholt.net>
To: Daniel J Blueman <daniel.blueman@gmail.com>,
        Ben Widawsky <ben@bwidawsk.net>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [Intel-gfx] [PATCH 3.0-rc3] i915: Fix gen6 (SNB) GPU stalling
In-Reply-To: <BANLkTin1fqKMzutfOyLNegOGOuSQu-4jpA@mail.gmail.com>
References: <1308070307-2630-1-git-send-email-daniel.blueman@gmail.com> <20110615044359.GA27884@snipes.kumite> <BANLkTin1fqKMzutfOyLNegOGOuSQu-4jpA@mail.gmail.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 15 Jun 2011 09:38:30 -0700
Message-ID: <87sjrbkq2h.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Jun 2011 13:04:51 +0800, Daniel J Blueman <daniel.blueman@gmail.=
com> wrote:
> The render HWSTAM is tweaked in preinstall, but we need to tweak the
> blitter HWSTAM (new to gen6).

This still doesn't *really* make sense -- HWSTAM is supposed to be
masking updates to the status page's copy of the IIR, which we never
read, and not be involved in masking updates to the MMIO I[IS]R.  So it
seems to me that this is just happening to get lucky and serialize in
the hardware for the way that we do actually read IIR (through MMIO).
And hey, we should be using the status page copy instead of MMIO some
day anyway, so that's more reason to do this patch even if we don't like
workarounds.

> To me, it makes sense to reset the blitter HWSTAM register to what the
> driver expects, in case anything before the i915 module loads and
> adjusts it for a particular purpose (including debug); the render
> HWSTAM is set this way too. I could add a comment to both perhaps?
>=20
> Updating the blitter HWSTAM in the postinstall was a marginally safer
> choice, as there'll not be any potential race with a blitter user
> interrupt getting emitted before we're ready (which wouldn't have been
> tested), but the risk is probably so low that it could just go into
> the preinstall.

The GPU is idle before our driver shows up, so there's no risk (there's
a bunch of leftover paranoia in the driver from the DRI1 days, none of
which ever made much sense).

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk344AYACgkQHUdvYGzw6vftFQCcC2rI3PeYFe5r5Iad+A6qCpZx
j+UAn0Hrem/d3pY/PqmnaPqwr76WUnVH
=8fyp
-----END PGP SIGNATURE-----
--=-=-=--
