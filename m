Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855Ab0GWPbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:31:18 -0400
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:44614 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760753Ab0GWPbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:31:14 -0400
Date: Fri, 23 Jul 2010 17:31:02 +0200
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: b43 wireless driver inhibits access to /dev/hwrng
Message-ID: <20100723153101.GA12795@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org
References: <20100722225212.GA19361@darkside.kls.lan>
 <20100723143219.GA2426@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20100723143219.GA2426@tuxdriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 23, 2010 at 10:32:19AM -0400, John W. Linville wrote:
> The hwrng driver is provided by the b43 hardware, which is shutdown
> when the network interface is down.  I'm not sure how one could expect
> this to work.

Nope. It's provided by the VIA PadLock hardware (through the via-rng
driver). I'm not sure how one could expect this not to work when the
network interface provided by the b43 driver is down.

Well, maybe let's try to become a bit less offensive... :)
Probably there are two Hardware RNGs on that machine: one provided by
VIA PadLock through via-rng, one provided by BCM4312 through b43:
	hw_random/via-rng.c:    err =3D hwrng_register(&via_rng);
	b43/main.c: err =3D hwrng_register(&wl->rng);

But at least now it's a bit more likely that the problem is located in
the rng core which should not render /dev/hwrng inaccessible when only
one of the RNGs unregisters.

However, what I don't fully understand is: I find only one way where b43
unregisters its RNG, which is via
	b43_remove() -> b43_rng_exit() -> hwrng_unregister()
And, I'm really not sure if I got this right, but... I guess,
b43_remove() is only called when the module is removed from the kernel
and not when the network interface is shut down.

So, maybe it's not really rng core's fault?
I guess, b43 just stops delivering data through b43_rng_read() when the
hardware is shut down and instead returns ENODEV (which is btw. what I
get when I'm trying to read /dev/hwrng while b43 is down), and the rng
core just delivers this error up when it's trying to deliver the read
request to the b43 RNG.


Mario
--=20
User sind wie ideale Gase - sie verteilen sich gleichmaessig ueber alle Pla=
tten

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTEm1tRS+e2HeSPbpAQKGnAgAjmDccp1hW1LHzsGdtAPTrzyF18GwnBLx
SWsMznz2Y3AcBiN975wn7hVrWmoci1LeLJXE7Sq5DGG6psiQC9Dk9+wVRRSxCEgW
tZz+iECNysRQeRHRi78LzesaabwJYDul9HwuydDSdhZAZ/fS4EXkWwel+zwvHaev
P/PTbkNATTcONDjdA5yJ8bsZA9StH+833ShCQoB/r1sHXZr3eDd4yE9dTFWTUfdw
uNnEi6vFzCfzouIZasT3PnYCcQl8/LMRbv1QgRtABUDTj4TYhqJ4oxvhAG3+pLdf
wTz1VOHMtT74CcsSz1406XLBQOoiBDl8EI9EToCFmj7rY2XqBfQAig==
=cDbt
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
