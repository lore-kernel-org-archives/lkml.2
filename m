Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187Ab1KSEsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 23:48:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51623 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860Ab1KSEsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 23:48:36 -0500
X-Authority-Analysis: v=2.0 cv=Pdt9d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=SC2tYg6JpKMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=JfrnYn6hAAAA:8 a=D_SbEOMbAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=lloFcT3eAIHtXWpK8c0A:9 a=3U65bstVgrKabBQJk2UA:7 a=QEXdDO2ut3YA:10 a=3Rfx1nUSh_UA:10 a=7KbvKZvEaC0A:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=9RJONRCCih3qF3nDB14A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111119044833.696636681@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 18 Nov 2011 23:45:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        stable-rt@vger.kernel.org
Subject: [PATCH 3/5] x86: crypto: Reduce preempt disabled regions
References: <20111119044510.811163517@goodmis.org>
Content-Disposition: inline; filename=0003-x86-crypto-Reduce-preempt-disabled-regions.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Peter Zijlstra <peterz@infradead.org>

Restrict the preempt disabled regions to the actual floating point
operations and enable preemption for the administrative actions.

This is necessary on RT to avoid that kfree and other operations are
called with preemption disabled.

Reported-and-tested-by: Carsten Emde <cbe@osadl.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/crypto/aesni-intel_glue.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-int=
el_glue.c
index feee8ff..81ec77c 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -288,14 +288,14 @@ static int ecb_encrypt(struct blkcipher_desc *desc,
 	err =3D blkcipher_walk_virt(desc, &walk);
 	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
=20
-	kernel_fpu_begin();
 	while ((nbytes =3D walk.nbytes)) {
+		kernel_fpu_begin();
 		aesni_ecb_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
-			      nbytes & AES_BLOCK_MASK);
+				nbytes & AES_BLOCK_MASK);
+		kernel_fpu_end();
 		nbytes &=3D AES_BLOCK_SIZE - 1;
 		err =3D blkcipher_walk_done(desc, &walk, nbytes);
 	}
-	kernel_fpu_end();
=20
 	return err;
 }
@@ -312,14 +312,14 @@ static int ecb_decrypt(struct blkcipher_desc *desc,
 	err =3D blkcipher_walk_virt(desc, &walk);
 	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
=20
-	kernel_fpu_begin();
 	while ((nbytes =3D walk.nbytes)) {
+		kernel_fpu_begin();
 		aesni_ecb_dec(ctx, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes & AES_BLOCK_MASK);
+		kernel_fpu_end();
 		nbytes &=3D AES_BLOCK_SIZE - 1;
 		err =3D blkcipher_walk_done(desc, &walk, nbytes);
 	}
-	kernel_fpu_end();
=20
 	return err;
 }
@@ -358,14 +358,14 @@ static int cbc_encrypt(struct blkcipher_desc *desc,
 	err =3D blkcipher_walk_virt(desc, &walk);
 	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
=20
-	kernel_fpu_begin();
 	while ((nbytes =3D walk.nbytes)) {
+		kernel_fpu_begin();
 		aesni_cbc_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes & AES_BLOCK_MASK, walk.iv);
+		kernel_fpu_end();
 		nbytes &=3D AES_BLOCK_SIZE - 1;
 		err =3D blkcipher_walk_done(desc, &walk, nbytes);
 	}
-	kernel_fpu_end();
=20
 	return err;
 }
@@ -382,14 +382,14 @@ static int cbc_decrypt(struct blkcipher_desc *desc,
 	err =3D blkcipher_walk_virt(desc, &walk);
 	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
=20
-	kernel_fpu_begin();
 	while ((nbytes =3D walk.nbytes)) {
+		kernel_fpu_begin();
 		aesni_cbc_dec(ctx, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes & AES_BLOCK_MASK, walk.iv);
+		kernel_fpu_end();
 		nbytes &=3D AES_BLOCK_SIZE - 1;
 		err =3D blkcipher_walk_done(desc, &walk, nbytes);
 	}
-	kernel_fpu_end();
=20
 	return err;
 }
@@ -444,18 +444,20 @@ static int ctr_crypt(struct blkcipher_desc *desc,
 	err =3D blkcipher_walk_virt_block(desc, &walk, AES_BLOCK_SIZE);
 	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
=20
-	kernel_fpu_begin();
 	while ((nbytes =3D walk.nbytes) >=3D AES_BLOCK_SIZE) {
+		kernel_fpu_begin();
 		aesni_ctr_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes & AES_BLOCK_MASK, walk.iv);
+		kernel_fpu_end();
 		nbytes &=3D AES_BLOCK_SIZE - 1;
 		err =3D blkcipher_walk_done(desc, &walk, nbytes);
 	}
 	if (walk.nbytes) {
+		kernel_fpu_begin();
 		ctr_crypt_final(ctx, &walk);
+		kernel_fpu_end();
 		err =3D blkcipher_walk_done(desc, &walk, 0);
 	}
-	kernel_fpu_end();
=20
 	return err;
 }
--=20
1.7.7.1



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOxzUhAAoJEIy3vGnGbaoAhKsP/3w3pfq7HqF+YzalWvAAu9bG
V6paI2BaRZKoicveJGNpszBliV0uTNIkM1ygLWKO7Q5BbHVOENRhPbQw3f1+vSiE
viDJS6vner9yoCeMkPw8JMjuH4Yo6cAE02bDPs2Wz5GaTfzpMZAec4suLYAn6nDu
+RNKuFKIszTExLvXkTsdk/maaYGit1q6ZzBW3KO1YMHwa1cncVcFaDGwPqTJjwty
iTdgtckw44EHdBElqDkBF4iLwU8FA5F3pFOmgwBbEs3ththjyWLyuhjkmwlMz0fI
BIs9wYlICNqSxvDQWAd+8qp/AVT8wcwQnwfwUuq3gUvggMOjLLb2R9lTGsCE3zIR
iLAOPMCKzs1B9arEiyBw+uQu7/2IzrbZMerNxNsD9JlZREwm5u4Fg52FWq+fuBO1
ZiW3S/yn7rVAIuKZeVSY2xcFO0zKfa1NbaAqIQw3uXvllNeovXfENWombMlxIw/3
PQX1vUP3nBWFThSH8p7Nax6ZACC7Dp/KZS80xTNWUt0G9wWffmmoWXTASdzszw27
ZYtZXgv4ne/ubjyAodM8jfUBLc7DNrHTujS2KfrtFBhaU2At7Tt0+YI9BEwfYGS5
hgsNi+8/aizcqmZOLoOGmMmP+QOnenQZRCYvO9eKjQq1Xi6qMJLb1iqtRO/pf9VG
1lFFCNIes2q3Fc2wyrxu
=JIwr
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
