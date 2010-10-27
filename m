Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760686Ab0J0KVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:21:01 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:40262 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753180Ab0J0KU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:20:58 -0400
Date: Wed, 27 Oct 2010 12:03:24 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        Kartikey Mahendra Bhatt <kartik_me@hotmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: cast5: simplify if-statements
Message-ID: <20101027120324.0b12a8b8@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that by factoring out common rounds from the
branches of the if-statements in the encryption and
decryption functions, the executable file size goes down
significantly, for crypto/cast5.ko from 26688 bytes
to 24336 bytes (amd64).

On my test system, I saw a slight speedup. This is the
first time I'm doing such a benchmark - I found a similar
one on the crypto mailing list, and I hope I did it right?

Before:
# cryptsetup create dm-test /dev/hda2 -c cast5-cbc-plain -s 128
Passsatz eingeben: 
# dd if=/dev/zero of=/dev/mapper/dm-test bs=1M count=50
52428800 Bytes (52 MB) kopiert, 2,43484 s, 21,5 MB/s
# dd if=/dev/zero of=/dev/mapper/dm-test bs=1M count=50
52428800 Bytes (52 MB) kopiert, 2,4089 s, 21,8 MB/s
# dd if=/dev/zero of=/dev/mapper/dm-test bs=1M count=50
52428800 Bytes (52 MB) kopiert, 2,41091 s, 21,7 MB/s

After:
# cryptsetup create dm-test /dev/hda2 -c cast5-cbc-plain -s 128
Passsatz eingeben: 
# dd if=/dev/zero of=/dev/mapper/dm-test bs=1M count=50
52428800 Bytes (52 MB) kopiert, 2,38128 s, 22,0 MB/s
# dd if=/dev/zero of=/dev/mapper/dm-test bs=1M count=50
52428800 Bytes (52 MB) kopiert, 2,29486 s, 22,8 MB/s
# dd if=/dev/zero of=/dev/mapper/dm-test bs=1M count=50
52428800 Bytes (52 MB) kopiert, 2,37162 s, 22,1 MB/s

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 crypto/cast5.c |   74 ++++++++++++++++++-------------------------------------
 1 files changed, 24 insertions(+), 50 deletions(-)

diff --git a/crypto/cast5.c b/crypto/cast5.c
index a1d2294..4a230dd 100644
--- a/crypto/cast5.c
+++ b/crypto/cast5.c
@@ -604,36 +604,23 @@ static void cast5_encrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf)
 	 * Rounds 3, 6, 9, 12, and 15 use f function Type 3.
 	 */
 
+	t = l; l = r; r = t ^ F1(r, Km[0], Kr[0]);
+	t = l; l = r; r = t ^ F2(r, Km[1], Kr[1]);
+	t = l; l = r; r = t ^ F3(r, Km[2], Kr[2]);
+	t = l; l = r; r = t ^ F1(r, Km[3], Kr[3]);
+	t = l; l = r; r = t ^ F2(r, Km[4], Kr[4]);
+	t = l; l = r; r = t ^ F3(r, Km[5], Kr[5]);
+	t = l; l = r; r = t ^ F1(r, Km[6], Kr[6]);
+	t = l; l = r; r = t ^ F2(r, Km[7], Kr[7]);
+	t = l; l = r; r = t ^ F3(r, Km[8], Kr[8]);
+	t = l; l = r; r = t ^ F1(r, Km[9], Kr[9]);
+	t = l; l = r; r = t ^ F2(r, Km[10], Kr[10]);
+	t = l; l = r; r = t ^ F3(r, Km[11], Kr[11]);
 	if (!(c->rr)) {
-		t = l; l = r; r = t ^ F1(r, Km[0], Kr[0]);
-		t = l; l = r; r = t ^ F2(r, Km[1], Kr[1]);
-		t = l; l = r; r = t ^ F3(r, Km[2], Kr[2]);
-		t = l; l = r; r = t ^ F1(r, Km[3], Kr[3]);
-		t = l; l = r; r = t ^ F2(r, Km[4], Kr[4]);
-		t = l; l = r; r = t ^ F3(r, Km[5], Kr[5]);
-		t = l; l = r; r = t ^ F1(r, Km[6], Kr[6]);
-		t = l; l = r; r = t ^ F2(r, Km[7], Kr[7]);
-		t = l; l = r; r = t ^ F3(r, Km[8], Kr[8]);
-		t = l; l = r; r = t ^ F1(r, Km[9], Kr[9]);
-		t = l; l = r; r = t ^ F2(r, Km[10], Kr[10]);
-		t = l; l = r; r = t ^ F3(r, Km[11], Kr[11]);
 		t = l; l = r; r = t ^ F1(r, Km[12], Kr[12]);
 		t = l; l = r; r = t ^ F2(r, Km[13], Kr[13]);
 		t = l; l = r; r = t ^ F3(r, Km[14], Kr[14]);
 		t = l; l = r; r = t ^ F1(r, Km[15], Kr[15]);
-	} else {
-		t = l; l = r; r = t ^ F1(r, Km[0], Kr[0]);
-		t = l; l = r; r = t ^ F2(r, Km[1], Kr[1]);
-		t = l; l = r; r = t ^ F3(r, Km[2], Kr[2]);
-		t = l; l = r; r = t ^ F1(r, Km[3], Kr[3]);
-		t = l; l = r; r = t ^ F2(r, Km[4], Kr[4]);
-		t = l; l = r; r = t ^ F3(r, Km[5], Kr[5]);
-		t = l; l = r; r = t ^ F1(r, Km[6], Kr[6]);
-		t = l; l = r; r = t ^ F2(r, Km[7], Kr[7]);
-		t = l; l = r; r = t ^ F3(r, Km[8], Kr[8]);
-		t = l; l = r; r = t ^ F1(r, Km[9], Kr[9]);
-		t = l; l = r; r = t ^ F2(r, Km[10], Kr[10]);
-		t = l; l = r; r = t ^ F3(r, Km[11], Kr[11]);
 	}
 
 	/* c1...c64 <-- (R16,L16).  (Exchange final blocks L16, R16 and
@@ -663,32 +650,19 @@ static void cast5_decrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf)
 		t = l; l = r; r = t ^ F3(r, Km[14], Kr[14]);
 		t = l; l = r; r = t ^ F2(r, Km[13], Kr[13]);
 		t = l; l = r; r = t ^ F1(r, Km[12], Kr[12]);
-		t = l; l = r; r = t ^ F3(r, Km[11], Kr[11]);
-		t = l; l = r; r = t ^ F2(r, Km[10], Kr[10]);
-		t = l; l = r; r = t ^ F1(r, Km[9], Kr[9]);
-		t = l; l = r; r = t ^ F3(r, Km[8], Kr[8]);
-		t = l; l = r; r = t ^ F2(r, Km[7], Kr[7]);
-		t = l; l = r; r = t ^ F1(r, Km[6], Kr[6]);
-		t = l; l = r; r = t ^ F3(r, Km[5], Kr[5]);
-		t = l; l = r; r = t ^ F2(r, Km[4], Kr[4]);
-		t = l; l = r; r = t ^ F1(r, Km[3], Kr[3]);
-		t = l; l = r; r = t ^ F3(r, Km[2], Kr[2]);
-		t = l; l = r; r = t ^ F2(r, Km[1], Kr[1]);
-		t = l; l = r; r = t ^ F1(r, Km[0], Kr[0]);
-	} else {
-		t = l; l = r; r = t ^ F3(r, Km[11], Kr[11]);
-		t = l; l = r; r = t ^ F2(r, Km[10], Kr[10]);
-		t = l; l = r; r = t ^ F1(r, Km[9], Kr[9]);
-		t = l; l = r; r = t ^ F3(r, Km[8], Kr[8]);
-		t = l; l = r; r = t ^ F2(r, Km[7], Kr[7]);
-		t = l; l = r; r = t ^ F1(r, Km[6], Kr[6]);
-		t = l; l = r; r = t ^ F3(r, Km[5], Kr[5]);
-		t = l; l = r; r = t ^ F2(r, Km[4], Kr[4]);
-		t = l; l = r; r = t ^ F1(r, Km[3], Kr[3]);
-		t = l; l = r; r = t ^ F3(r, Km[2], Kr[2]);
-		t = l; l = r; r = t ^ F2(r, Km[1], Kr[1]);
-		t = l; l = r; r = t ^ F1(r, Km[0], Kr[0]);
 	}
+	t = l; l = r; r = t ^ F3(r, Km[11], Kr[11]);
+	t = l; l = r; r = t ^ F2(r, Km[10], Kr[10]);
+	t = l; l = r; r = t ^ F1(r, Km[9], Kr[9]);
+	t = l; l = r; r = t ^ F3(r, Km[8], Kr[8]);
+	t = l; l = r; r = t ^ F2(r, Km[7], Kr[7]);
+	t = l; l = r; r = t ^ F1(r, Km[6], Kr[6]);
+	t = l; l = r; r = t ^ F3(r, Km[5], Kr[5]);
+	t = l; l = r; r = t ^ F2(r, Km[4], Kr[4]);
+	t = l; l = r; r = t ^ F1(r, Km[3], Kr[3]);
+	t = l; l = r; r = t ^ F3(r, Km[2], Kr[2]);
+	t = l; l = r; r = t ^ F2(r, Km[1], Kr[1]);
+	t = l; l = r; r = t ^ F1(r, Km[0], Kr[0]);
 
 	dst[0] = cpu_to_be32(r);
 	dst[1] = cpu_to_be32(l);
-- 
1.7.2.2
