Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab1AEDwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 22:52:39 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:57604 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab1AEDwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 22:52:37 -0500
Date: Wed, 5 Jan 2011 04:52:22 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Matt Mackall <mpm@selenic.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Harald Welte <HaraldWelte@viatech.com>,
        Michal Ludvig <michal@logix.cz>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Message-ID: <20110105035222.GA8762@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Harald Welte <HaraldWelte@viatech.com>,
	Michal Ludvig <michal@logix.cz>
References: <20101231022550.GA2512@darkside.kls.lan>
 <20101231024653.GA24879@gondor.apana.org.au>
 <20101231085103.GA31935@darkside.kls.lan>
 <20110104043338.GA27604@gondor.apana.org.au>
 <20110104121957.GA27114@darkside.kls.lan>
 <20110104123824.GA31557@gondor.apana.org.au>
 <20110104125722.GC27114@darkside.kls.lan>
 <20110104224238.GA4978@gondor.apana.org.au>
 <20110104230644.GJ27114@darkside.kls.lan>
 <20110105003020.GA5751@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20110105003020.GA5751@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 05, 2011 at 11:30:20AM +1100, Herbert Xu wrote:
> OK, so xstore really is producing crap.  Can you try this path
> (also against vanilla) to print out some extra info?

All right, here is what happens...

On top of your 3rd patch:

--- linux-source-2.6.37-rc7/drivers/char/hw_random/via-rng.c.hxu3	2011-01-0=
5 04:13:09.452322117 +0100
+++ linux-source-2.6.37-rc7/drivers/char/hw_random/via-rng.c	2011-01-05 03:=
59:33.169316276 +0100
@@ -97,6 +97,10 @@ static int via_rng_data_present(struct h
 	u32 bytes_out;
 	int i;
=20
+	printk(KERN_DEBUG "buf=3D%p + %zu, via_rng_datum=3D%p\n",
+			buf, sizeof(buf), via_rng_datum);
+
+
 	/* We choose the recommended 1-byte-per-instruction RNG rate,
 	 * for greater randomness at the expense of speed.  Larger
 	 * values 2, 4, or 8 bytes-per-instruction yield greater

gives:

[  103.276337] buf=3Df6e23f28 + 28, via_rng_datum=3Df6e23f30
[  103.276351] f6e23f38 0x0 0x8
[  103.276371] buf=3Df6e23f28 + 28, via_rng_datum=3Df6e23f30
[  103.276380] f6e23f38 0xffffffff 0x8
=2E..

According to the VIA PadLock Programming Guide, XSTORE increments EDI by
the number of bytes stored.
This did obviously not matter as long as the buffer was "sufficiently
distant", but now you have the buffer close on the stack and I believe,
the optimizer crops up, hence the EDI increment begins to matter.

IMHO EDI (and EDX - for completeness :)) should be put on the asm
clobber-list, but if I try to do it, I always get:
error: can't find a register in class 'DIREG' while reloading 'asm'
error: 'asm' operand has impossible constraints

So... I have the reason - solution is up to you :)

Btw: the 8 bytes increment (as well as the 8 in EAX 4:0) proves that
XSTOR indeed writes more than 32bit :)


g'nite
   Mario
--=20
The only thing to be scared of, son, is tomorrow.
I don't live for tomorrow. Never saw the fun in it.
                       -- Denny Crane, Boston Legal

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTSPq9hS+e2HeSPbpAQIi2gf/TsnTxgNFdqGKUFY3tFLYpDx1SyJ39OgF
BlSZZoidVkrmKQrYZqxmWcDDheqM+3x9fBmEoUTn3v19490+OMwNUPj/2BTN9irK
w06BA9wwhfGhWULd2yWjpaSj8A7VPzXiDCWytMV5K8fEre9hdNGY17v978Bprx/z
GvKML8kzqBXjd4cG9tVwG7f212LMSgTwwalh9dfQM+YtK1nFhxjk5WTDKc9tG+/2
PSiWwpara+oUl4JX7/phvchoivrGd7xegbtDtL0AxZax2bSKtx7RG8xQWNI/DzVW
qxsixKBoThfAB6HHE8wELra0R1isFU8jhPLqlt8KPpbwmR8UeeuoKg==
=Vz/q
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
