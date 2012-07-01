Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab2GARVR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 13:21:17 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:34949 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071Ab2GARVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 13:21:13 -0400
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-kernel@vger.kernel.org
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au,
        davem@davemloft.net, plagnioj@jcrosoft.com, nicolas@eukrea.com,
        eric@eukrea.com
Subject: [PATCH 5/5] crypto: add new tests to tcrypt
Date: Sun,  1 Jul 2012 19:19:47 +0200
Message-Id: <1341163187-14946-6-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1341163187-14946-1-git-send-email-eric@eukrea.com>
References: <1341163187-14946-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Royer <nicolas@eukrea.com>

- set sg buffers size equals to message size
- add cfb & ofb tests for AES, DES & TDES

Signed-off-by: Nicolas Royer <nicolas@eukrea.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Eric Bénard <eric@eukrea.com>
Tested-by: Eric Bénard <eric@eukrea.com>
---
 crypto/tcrypt.c |   50 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 8f147bf..a9296bd 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -809,7 +809,7 @@ static void test_acipher_speed(const char *algo, int enc, unsigned int sec,
 			       struct cipher_speed_template *template,
 			       unsigned int tcount, u8 *keysize)
 {
-	unsigned int ret, i, j, iv_len;
+	unsigned int ret, i, j, k, iv_len;
 	struct tcrypt_result tresult;
 	const char *key;
 	char iv[128];
@@ -883,11 +883,23 @@ static void test_acipher_speed(const char *algo, int enc, unsigned int sec,
 			}
 
 			sg_init_table(sg, TVMEMSIZE);
-			sg_set_buf(sg, tvmem[0] + *keysize,
+
+			k = *keysize + *b_size;
+			if (k > PAGE_SIZE) {
+				sg_set_buf(sg, tvmem[0] + *keysize,
 				   PAGE_SIZE - *keysize);
-			for (j = 1; j < TVMEMSIZE; j++) {
-				sg_set_buf(sg + j, tvmem[j], PAGE_SIZE);
-				memset(tvmem[j], 0xff, PAGE_SIZE);
+				k -= PAGE_SIZE;
+				j = 1;
+				while (k > PAGE_SIZE) {
+					sg_set_buf(sg + j, tvmem[j], PAGE_SIZE);
+					memset(tvmem[j], 0xff, PAGE_SIZE);
+					j++;
+					k -= PAGE_SIZE;
+				}
+				sg_set_buf(sg + j, tvmem[j], k);
+				memset(tvmem[j], 0xff, k);
+			} else {
+				sg_set_buf(sg, tvmem[0] + *keysize, *b_size);
 			}
 
 			iv_len = crypto_ablkcipher_ivsize(tfm);
@@ -1512,6 +1524,14 @@ static int do_test(int m)
 				   speed_template_16_24_32);
 		test_acipher_speed("ctr(aes)", DECRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
+		test_acipher_speed("cfb(aes)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		test_acipher_speed("cfb(aes)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		test_acipher_speed("ofb(aes)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		test_acipher_speed("ofb(aes)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
 		break;
 
 	case 501:
@@ -1527,6 +1547,18 @@ static int do_test(int m)
 		test_acipher_speed("cbc(des3_ede)", DECRYPT, sec,
 				   des3_speed_template, DES3_SPEED_VECTORS,
 				   speed_template_24);
+		test_acipher_speed("cfb(des3_ede)", ENCRYPT, sec,
+				   des3_speed_template, DES3_SPEED_VECTORS,
+				   speed_template_24);
+		test_acipher_speed("cfb(des3_ede)", DECRYPT, sec,
+				   des3_speed_template, DES3_SPEED_VECTORS,
+				   speed_template_24);
+		test_acipher_speed("ofb(des3_ede)", ENCRYPT, sec,
+				   des3_speed_template, DES3_SPEED_VECTORS,
+				   speed_template_24);
+		test_acipher_speed("ofb(des3_ede)", DECRYPT, sec,
+				   des3_speed_template, DES3_SPEED_VECTORS,
+				   speed_template_24);
 		break;
 
 	case 502:
@@ -1538,6 +1570,14 @@ static int do_test(int m)
 				   speed_template_8);
 		test_acipher_speed("cbc(des)", DECRYPT, sec, NULL, 0,
 				   speed_template_8);
+		test_acipher_speed("cfb(des)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8);
+		test_acipher_speed("cfb(des)", DECRYPT, sec, NULL, 0,
+				   speed_template_8);
+		test_acipher_speed("ofb(des)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8);
+		test_acipher_speed("ofb(des)", DECRYPT, sec, NULL, 0,
+				   speed_template_8);
 		break;
 
 	case 503:
-- 
1.7.7.6

