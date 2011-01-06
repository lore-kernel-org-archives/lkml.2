Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab1AFNPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 08:15:42 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:33857 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab1AFNPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 08:15:40 -0500
Date: Thu, 6 Jan 2011 14:15:16 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Matt Mackall <mpm@selenic.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Harald Welte <HaraldWelte@viatech.com>,
        Michal Ludvig <michal@logix.cz>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Message-ID: <20110106131516.GB8803@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Harald Welte <HaraldWelte@viatech.com>,
	Michal Ludvig <michal@logix.cz>
References: <20110104121957.GA27114@darkside.kls.lan>
 <20110104123824.GA31557@gondor.apana.org.au>
 <20110104125722.GC27114@darkside.kls.lan>
 <20110104224238.GA4978@gondor.apana.org.au>
 <20110104230644.GJ27114@darkside.kls.lan>
 <20110105003020.GA5751@gondor.apana.org.au>
 <20110105035222.GA8762@darkside.kls.lan>
 <20110105054735.GA7773@gondor.apana.org.au>
 <20110105131621.GA24769@darkside.kls.lan>
 <20110106061241.GA18939@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mojUlQ0s9EVzWg2t"
Content-Disposition: inline
In-Reply-To: <20110106061241.GA18939@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mojUlQ0s9EVzWg2t
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Herbert,

On Thu, Jan 06, 2011 at 05:12:41PM +1100, Herbert Xu wrote:
> On Wed, Jan 05, 2011 at 02:16:22PM +0100, Mario 'BitKoenig' Holbe wrote:
> > attached. I hope I got the gcc call right. However, I prefer the objdump
> > output anyways, so this one is attached as well.
> I see what you mean now.
> Please let me know if this patch (still against vanilla) helps.

The patch helps. No crashes, meaningful random data - perfect.
I still have 2 small annotations...

1. Having ECX on the clobber-list is not really necessary.
XSTORE doesn't touch ECX at all.
REP XSTORE would touch it, but for this ECX would be an input anyways.

2. Would you mind doing the same for EDX as you did for EDI?
This doesn't really change anything currently, but will probably help
avoiding a debug-session like ours somewhere in the future :)

A patch that does both is attached - to apply on top of your patch, if
you like. I tested this patch - it passed all my tests: no crashes,
meaningful random data.


Thanks for your help & regards
   Mario
--=20
It is a capital mistake to theorize before one has data.
Insensibly one begins to twist facts to suit theories instead of theories
to suit facts.                   -- Sherlock Holmes by Arthur Conan Doyle

--RnlQjJ0d97Da+TV1
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="via-rng4-edx+unclobber.patch"
Content-Transfer-Encoding: quoted-printable

--- linux-source-2.6.37-rc7/drivers/char/hw_random/via-rng.c.hxu4	2011-01-0=
6 09:40:44.879334924 +0100
+++ linux-source-2.6.37-rc7/drivers/char/hw_random/via-rng.c	2011-01-06 13:=
07:25.031181409 +0100
@@ -81,13 +81,7 @@
 	ts_state =3D irq_ts_save();
=20
 	asm(".byte 0x0F,0xA7,0xC0 /* xstore %%edi (addr=3D%0) */"
-		: "=3Dm" (*addr), "=3Da" (eax_out), "+D" (addr)
-		: "d" (edx_in)
-#ifdef CONFIG_64BIT
-		: "%rcx");
-#else
-		: "%ecx");
-#endif
+		: "=3Dm" (*addr), "=3Da" (eax_out), "+D" (addr), "+d" (edx_in));
=20
 	irq_ts_restore(ts_state);
 	return eax_out;

--RnlQjJ0d97Da+TV1--

--mojUlQ0s9EVzWg2t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTSXAZBS+e2HeSPbpAQInlAf/emUhLcWAdIt68sfXDth+pNrUEwEKSCac
4uW7PMH5kAG5kcJarInDNK93foTIRrPh+27qsztnYF1HHCrt/IalKgZR1pox1wA9
QIi1Rz1LL8Srha8aHtlNmysi83Cj1HOqjWqWmNBXd9MwCWyXsiSwxgj7uNw4ZAmz
rEVgAB5rfAcWictbkJSg/qqi4MXHQU0rDr9CTm5G8Bslh98/Iy75aQddMIja4ROZ
9FrcblK0vPagH45x2pl7O6u8Vke8aYSR07kw95UMVfJrQIhyc86yuw0N8bR3P5qz
vNs2bd3DweMgZzjOWeRHKMJFjCtSDKivy84lg2V1zuzaN6dd7bp1cg==
=rL/i
-----END PGP SIGNATURE-----

--mojUlQ0s9EVzWg2t--
