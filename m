Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab0JKPtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 11:49:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:38724 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755348Ab0JKPtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 11:49:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,314,1283756400"; 
   d="scan'208,223";a="562809514"
Date: Mon, 11 Oct 2010 16:48:56 +0100
From: tadeusz.struk@intel.com
To: herbert@gondor.hengli.com.au
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        aidan.o.mahony@intel.com, gabriele.paoloni@intel.com,
        adrian.hoban@intel.com, tadeusz.struk@intel.com
Subject: [PATCH 3/3] Extending the RC4106 AES-GCM test vectors
Message-ID: <4CB331E8.mail9HX11RWQS@intel.com>
User-Agent: nail 10.6 11/15/03
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 587c5f011d8608bef97e7711fe87900225ce8722 Mon Sep 17 00:00:00 2001
From: Adrian Hoban <ahoban@allen.ir.intel.com>
Date: Fri, 10 Sep 2010 18:12:57 +0100
Subject: [PATCH 3/3] Extending the RC4106 AES-GCM test vectors

Updated RFC4106 AES-GCM testing. Some test vectors were taken from
http://csrc.nist.gov/groups/ST/toolkit/BCM/documents/proposedmodes/
gcm/gcm-test-vectors.tar.gz

Signed-off-by: Adrian Hoban <adrian.hoban@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
Signed-off-by: Gabriele Paoloni <gabriele.paoloni@intel.com>
Signed-off-by: Aidan O'Mahony <aidan.o.mahony@intel.com>
---
 crypto/tcrypt.c  |   11 ++
 crypto/testmgr.c |   24 ++++
 crypto/testmgr.h |  361 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 396 insertions(+), 0 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 3ca68f9..9aac5e5 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -8,6 +8,13 @@
  * Copyright (c) 2002 Jean-Francois Dive <jef@linuxbe.org>
  * Copyright (c) 2007 Nokia Siemens Networks
  *
+ * Updated RFC4106 AES-GCM testing.
+ *    Authors: Aidan O'Mahony (aidan.o.mahony@intel.com)
+ *             Adrian Hoban <adrian.hoban@intel.com>
+ *             Gabriele Paoloni <gabriele.paoloni@intel.com>
+ *             Tadeusz Struk (tadeusz.struk@intel.com)
+ *             Copyright (c) 2010, Intel Corporation.
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
  * Software Foundation; either version 2 of the License, or (at your option)
@@ -980,6 +987,10 @@ static int do_test(int m)
 		ret += tcrypt_test("ansi_cprng");
 		break;
 
+	case 151:
+		ret += tcrypt_test("rfc4106(gcm(aes))");
+		break;
+
 	case 200:
 		test_cipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index fa8c8f7..27ea9fe 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -6,6 +6,13 @@
  * Copyright (c) 2007 Nokia Siemens Networks
  * Copyright (c) 2008 Herbert Xu <herbert@gondor.apana.org.au>
  *
+ * Updated RFC4106 AES-GCM testing.
+ *    Authors: Aidan O'Mahony (aidan.o.mahony@intel.com)
+ *             Adrian Hoban <adrian.hoban@intel.com>
+ *             Gabriele Paoloni <gabriele.paoloni@intel.com>
+ *             Tadeusz Struk (tadeusz.struk@intel.com)
+ *    Copyright (c) 2010, Intel Corporation.
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
  * Software Foundation; either version 2 of the License, or (at your option)
@@ -2242,6 +2249,23 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "rfc4106(gcm(aes))",
+		.test = alg_test_aead,
+		.suite = {
+			.aead = {
+				.enc = {
+					.vecs = aes_gcm_rfc4106_enc_tv_template,
+					.count = AES_GCM_4106_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = aes_gcm_rfc4106_dec_tv_template,
+					.count = AES_GCM_4106_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+
+
 		.alg = "rfc4309(ccm(aes))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 74e3537..834af7f 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -6,6 +6,15 @@
  * Copyright (c) 2007 Nokia Siemens Networks
  * Copyright (c) 2008 Herbert Xu <herbert@gondor.apana.org.au>
  *
+ * Updated RFC4106 AES-GCM testing. Some test vectors were taken from
+ * http://csrc.nist.gov/groups/ST/toolkit/BCM/documents/proposedmodes/
+ * gcm/gcm-test-vectors.tar.gz
+ *     Authors: Aidan O'Mahony (aidan.o.mahony@intel.com)
+ *              Adrian Hoban <adrian.hoban@intel.com>
+ *              Gabriele Paoloni <gabriele.paoloni@intel.com>
+ *              Tadeusz Struk (tadeusz.struk@intel.com)
+ *     Copyright (c) 2010, Intel Corporation.
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
  * Software Foundation; either version 2 of the License, or (at your option)
@@ -2947,6 +2956,8 @@ static struct cipher_testvec cast6_dec_tv_template[] = {
 #define AES_CTR_3686_DEC_TEST_VECTORS 6
 #define AES_GCM_ENC_TEST_VECTORS 9
 #define AES_GCM_DEC_TEST_VECTORS 8
+#define AES_GCM_4106_ENC_TEST_VECTORS 7
+#define AES_GCM_4106_DEC_TEST_VECTORS 7
 #define AES_CCM_ENC_TEST_VECTORS 7
 #define AES_CCM_DEC_TEST_VECTORS 7
 #define AES_CCM_4309_ENC_TEST_VECTORS 7
@@ -5829,6 +5840,356 @@ static struct aead_testvec aes_gcm_dec_tv_template[] = {
 	}
 };
 
+static struct aead_testvec aes_gcm_rfc4106_enc_tv_template[] = {
+        { /* Generated using Crypto++ */
+		.key    = zeroed_string,
+		.klen	= 20,
+                .iv     = zeroed_string,
+                .input  = zeroed_string,
+                .ilen   = 16,
+                .assoc  = zeroed_string,
+                .alen   = 8,
+		.result	= "\x03\x88\xDA\xCE\x60\xB6\xA3\x92"
+                          "\xF3\x28\xC2\xB9\x71\xB2\xFE\x78"
+                          "\x97\xFE\x4C\x23\x37\x42\x01\xE0"
+                          "\x81\x9F\x8D\xC5\xD7\x41\xA0\x1B",
+		.rlen	= 32,
+        },{
+		.key    = "\xfe\xff\xe9\x92\x86\x65\x73\x1c"
+			  "\x6d\x6a\x8f\x94\x67\x30\x83\x08"
+                          "\x00\x00\x00\x00",
+		.klen	= 20,
+                .iv     = "\x00\x00\x00\x00\x00\x00\x00\x01"
+                          "\x00\x00\x00\x00",
+                .input  = zeroed_string,
+                .ilen   = 16,
+                .assoc  = zeroed_string,
+                .alen   = 8,
+		.result	= "\xC0\x0D\x8B\x42\x0F\x8F\x34\x18"
+                          "\x88\xB1\xC5\xBC\xC5\xB6\xD6\x28"
+                          "\x6A\x9D\xDF\x11\x5E\xFE\x5E\x9D"
+                          "\x2F\x70\x44\x92\xF7\xF2\xE3\xEF",
+		.rlen	= 32,
+
+        }, {
+		.key    = "\xfe\xff\xe9\x92\x86\x65\x73\x1c"
+			  "\x6d\x6a\x8f\x94\x67\x30\x83\x08"
+                          "\x00\x00\x00\x00",
+		.klen	= 20,
+                .iv     = zeroed_string,
+                .input  = "\x01\x01\x01\x01\x01\x01\x01\x01"
+                          "\x01\x01\x01\x01\x01\x01\x01\x01",
+                .ilen   = 16,
+                .assoc  = zeroed_string,
+                .alen   = 8,
+		.result	= "\x4B\xB1\xB5\xE3\x25\x71\x70\xDE"
+                          "\x7F\xC9\x9C\xA5\x14\x19\xF2\xAC"
+                          "\x0B\x8F\x88\x69\x17\xE6\xB4\x3C"
+                          "\xB1\x68\xFD\x14\x52\x64\x61\xB2",
+		.rlen	= 32,
+        }, {
+		.key    = "\xfe\xff\xe9\x92\x86\x65\x73\x1c"
+			  "\x6d\x6a\x8f\x94\x67\x30\x83\x08"
+                          "\x00\x00\x00\x00",
+		.klen	= 20,
+                .iv     = zeroed_string,
+                .input  = "\x01\x01\x01\x01\x01\x01\x01\x01"
+                          "\x01\x01\x01\x01\x01\x01\x01\x01",
+                .ilen   = 16,
+                .assoc  = "\x01\x01\x01\x01\x01\x01\x01\x01",
+                .alen   = 8,
+		.result	= "\x4B\xB1\xB5\xE3\x25\x71\x70\xDE"
+                          "\x7F\xC9\x9C\xA5\x14\x19\xF2\xAC"
+                          "\x90\x92\xB7\xE3\x5F\xA3\x9A\x63"
+                          "\x7E\xD7\x1F\xD8\xD3\x7C\x4B\xF5",
+		.rlen	= 32,
+        }, {
+		.key    = "\xfe\xff\xe9\x92\x86\x65\x73\x1c"
+			  "\x6d\x6a\x8f\x94\x67\x30\x83\x08"
+                          "\x00\x00\x00\x00",
+		.klen	= 20,
+                .iv     = "\x00\x00\x00\x00\x00\x00\x00\x01"
+                          "\x00\x00\x00\x00",
+                .input  = "\x01\x01\x01\x01\x01\x01\x01\x01"
+                          "\x01\x01\x01\x01\x01\x01\x01\x01",
+                .ilen   = 16,
+                .assoc  = "\x01\x01\x01\x01\x01\x01\x01\x01",
+                .alen   = 8,
+		.result	= "\xC1\x0C\x8A\x43\x0E\x8E\x35\x19"
+                          "\x89\xB0\xC4\xBD\xC4\xB7\xD7\x29"
+                          "\x64\x50\xF9\x32\x13\xFB\x74\x61"
+                          "\xF4\xED\x52\xD3\xC5\x10\x55\x3C",
+		.rlen	= 32,
+        }, {
+		.key    = "\xfe\xff\xe9\x92\x86\x65\x73\x1c"
+			  "\x6d\x6a\x8f\x94\x67\x30\x83\x08"
+                          "\x00\x00\x00\x00",
+		.klen	= 20,
+                .iv     = "\x00\x00\x00\x00\x00\x00\x00\x01"
+                          "\x00\x00\x00\x00",
+                .input  = "\x01\x01\x01\x01\x01\x01\x01\x01"
+                          "\x01\x01\x01\x01\x01\x01\x01\x01"
+                          "\x01\x01\x01\x01\x01\x01\x01\x01"
+                          "\x01\x01\x01\x01\x01\x01\x01\x01"
+                          "\x01\x01\x01\x01\x01\x01\x01\x01"
+                          "\x01\x01\x01\x01\x01\x01\x01\x01"
+                          "\x01\x01\x01\x01\x01\x01\x01\x01"
+                          "\x01\x01\x01\x01\x01\x01\x01\x01",
+                .ilen   = 64,
+                .assoc  = "\x01\x01\x01\x01\x01\x01\x01\x01",
+                .alen   = 8,
+		.result	= "\xC1\x0C\x8A\x43\x0E\x8E\x35\x19"
+                          "\x89\xB0\xC4\xBD\xC4\xB7\xD7\x29"
+                          "\x98\x14\xA1\x42\x37\x80\xFD\x90"
+                          "\x68\x12\x01\xA8\x91\x89\xB9\x83"
+                          "\x5B\x11\x77\x12\x9B\xFF\x24\x89"
+                          "\x94\x5F\x18\x12\xBA\x27\x09\x39"
+                          "\x99\x96\x76\x42\x15\x1C\xCD\xCB"
+                          "\xDC\xD3\xDA\x65\x73\xAF\x80\xCD"
+                          "\xD2\xB6\xC2\x4A\x76\xC2\x92\x85"
+                          "\xBD\xCF\x62\x98\x58\x14\xE5\xBD",
+		.rlen	= 80,
+        }, {
+		.key    = "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+                          "\x00\x00\x00\x00",
+		.klen	= 20,
+                .iv     = "\x00\x00\x45\x67\x89\xab\xcd\xef"
+                          "\x00\x00\x00\x00",
+                .input  = "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff",
+                .ilen   = 192,
+                .assoc  = "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+                          "\xaa\xaa\xaa\xaa",
+                .alen   = 12,
+		.result	= "\xC1\x76\x33\x85\xE2\x9B\x5F\xDE"
+			  "\xDE\x89\x3D\x42\xE7\xC9\x69\x8A"
+			  "\x44\x6D\xC3\x88\x46\x2E\xC2\x01"
+			  "\x5E\xF6\x0C\x39\xF0\xC4\xA5\x82"
+			  "\xCD\xE8\x31\xCC\x0A\x4C\xE4\x44"
+			  "\x41\xA9\x82\x6F\x22\xA1\x23\x1A"
+			  "\xA8\xE3\x16\xFD\x31\x5C\x27\x31"
+			  "\xF1\x7F\x01\x63\xA3\xAF\x70\xA1"
+			  "\xCF\x07\x57\x41\x67\xD0\xC4\x42"
+			  "\xDB\x18\xC6\x4C\x4C\xE0\x3D\x9F"
+			  "\x05\x07\xFB\x13\x7D\x4A\xCA\x5B"
+			  "\xF0\xBF\x64\x7E\x05\xB1\x72\xEE"
+			  "\x7C\x3B\xD4\xCD\x14\x03\xB2\x2C"
+			  "\xD3\xA9\xEE\xFA\x17\xFC\x9C\xDF"
+			  "\xC7\x75\x40\xFF\xAE\xAD\x1E\x59"
+			  "\x2F\x30\x24\xFB\xAD\x6B\x10\xFA"
+			  "\x6C\x9F\x5B\xE7\x25\xD5\xD0\x25"
+			  "\xAC\x4A\x4B\xDA\xFC\x7A\x85\x1B"
+			  "\x7E\x13\x06\x82\x08\x17\xA4\x35"
+			  "\xEC\xC5\x8D\x63\x96\x81\x0A\x8F"
+			  "\xA3\x05\x38\x95\x20\x1A\x47\x04"
+			  "\x6F\x6D\xDA\x8F\xEF\xC1\x76\x35"
+			  "\x6B\xC7\x4D\x0F\x94\x12\xCA\x3E"
+			  "\x2E\xD5\x03\x2E\x86\x7E\xAA\x3B"
+			  "\x37\x08\x1C\xCF\xBA\x5D\x71\x46"
+			  "\x80\x72\xB0\x4C\x82\x0D\x60\x3C",
+		.rlen	= 208,
+	}
+};
+
+static struct aead_testvec aes_gcm_rfc4106_dec_tv_template[] = {
+        { /* Generated using Crypto++ */
+		.key    = zeroed_string,
+		.klen	= 20,
+                .iv     = zeroed_string,
+		.input	= "\x03\x88\xDA\xCE\x60\xB6\xA3\x92"
+                          "\xF3\x28\xC2\xB9\x71\xB2\xFE\x78"
+                          "\x97\xFE\x4C\x23\x37\x42\x01\xE0"
+                          "\x81\x9F\x8D\xC5\xD7\x41\xA0\x1B",
+		.ilen	= 32,
+                .assoc  = zeroed_string,
+                .alen   = 8,
+                .result = zeroed_string,
+                .rlen   = 16,
+
+        },{
+		.key    = "\xfe\xff\xe9\x92\x86\x65\x73\x1c"
+			  "\x6d\x6a\x8f\x94\x67\x30\x83\x08"
+                          "\x00\x00\x00\x00",
+		.klen	= 20,
+                .iv     = "\x00\x00\x00\x00\x00\x00\x00\x01"
+                          "\x00\x00\x00\x00",
+		.input	= "\xC0\x0D\x8B\x42\x0F\x8F\x34\x18"
+                          "\x88\xB1\xC5\xBC\xC5\xB6\xD6\x28"
+                          "\x6A\x9D\xDF\x11\x5E\xFE\x5E\x9D"
+                          "\x2F\x70\x44\x92\xF7\xF2\xE3\xEF",
+		.ilen	= 32,
+                .assoc  = zeroed_string,
+                .alen   = 8,
+                .result = zeroed_string,
+                .rlen   = 16,
+        }, {
+		.key    = "\xfe\xff\xe9\x92\x86\x65\x73\x1c"
+			  "\x6d\x6a\x8f\x94\x67\x30\x83\x08"
+                          "\x00\x00\x00\x00",
+		.klen	= 20,
+                .iv     = zeroed_string,
+		.input	= "\x4B\xB1\xB5\xE3\x25\x71\x70\xDE"
+                          "\x7F\xC9\x9C\xA5\x14\x19\xF2\xAC"
+                          "\x0B\x8F\x88\x69\x17\xE6\xB4\x3C"
+                          "\xB1\x68\xFD\x14\x52\x64\x61\xB2",
+		.ilen	= 32,
+                .assoc  = zeroed_string,
+                .alen   = 8,
+                .result = "\x01\x01\x01\x01\x01\x01\x01\x01"
+                          "\x01\x01\x01\x01\x01\x01\x01\x01",
+                .rlen   = 16,
+        }, {
+		.key    = "\xfe\xff\xe9\x92\x86\x65\x73\x1c"
+			  "\x6d\x6a\x8f\x94\x67\x30\x83\x08"
+                          "\x00\x00\x00\x00",
+		.klen	= 20,
+                .iv     = zeroed_string,
+		.input	= "\x4B\xB1\xB5\xE3\x25\x71\x70\xDE"
+                          "\x7F\xC9\x9C\xA5\x14\x19\xF2\xAC"
+                          "\x90\x92\xB7\xE3\x5F\xA3\x9A\x63"
+                          "\x7E\xD7\x1F\xD8\xD3\x7C\x4B\xF5",
+		.ilen	= 32,
+                .assoc  = "\x01\x01\x01\x01\x01\x01\x01\x01",
+                .alen   = 8,
+                .result = "\x01\x01\x01\x01\x01\x01\x01\x01"
+                          "\x01\x01\x01\x01\x01\x01\x01\x01",
+                .rlen   = 16,
+
+        }, {
+		.key    = "\xfe\xff\xe9\x92\x86\x65\x73\x1c"
+			  "\x6d\x6a\x8f\x94\x67\x30\x83\x08"
+                          "\x00\x00\x00\x00",
+		.klen	= 20,
+                .iv     = "\x00\x00\x00\x00\x00\x00\x00\x01"
+                          "\x00\x00\x00\x00",
+		.input	= "\xC1\x0C\x8A\x43\x0E\x8E\x35\x19"
+                          "\x89\xB0\xC4\xBD\xC4\xB7\xD7\x29"
+                          "\x64\x50\xF9\x32\x13\xFB\x74\x61"
+                          "\xF4\xED\x52\xD3\xC5\x10\x55\x3C",
+		.ilen	= 32,
+                .assoc  = "\x01\x01\x01\x01\x01\x01\x01\x01",
+                .alen   = 8,
+                .result = "\x01\x01\x01\x01\x01\x01\x01\x01"
+                          "\x01\x01\x01\x01\x01\x01\x01\x01",
+                .rlen   = 16,
+        }, {
+		.key    = "\xfe\xff\xe9\x92\x86\x65\x73\x1c"
+			  "\x6d\x6a\x8f\x94\x67\x30\x83\x08"
+                          "\x00\x00\x00\x00",
+		.klen	= 20,
+                .iv     = "\x00\x00\x00\x00\x00\x00\x00\x01"
+                          "\x00\x00\x00\x00",
+		.input	= "\xC1\x0C\x8A\x43\x0E\x8E\x35\x19"
+                          "\x89\xB0\xC4\xBD\xC4\xB7\xD7\x29"
+                          "\x98\x14\xA1\x42\x37\x80\xFD\x90"
+                          "\x68\x12\x01\xA8\x91\x89\xB9\x83"
+                          "\x5B\x11\x77\x12\x9B\xFF\x24\x89"
+                          "\x94\x5F\x18\x12\xBA\x27\x09\x39"
+                          "\x99\x96\x76\x42\x15\x1C\xCD\xCB"
+                          "\xDC\xD3\xDA\x65\x73\xAF\x80\xCD"
+                          "\xD2\xB6\xC2\x4A\x76\xC2\x92\x85"
+                          "\xBD\xCF\x62\x98\x58\x14\xE5\xBD",
+		.ilen	= 80,
+                .assoc  = "\x01\x01\x01\x01\x01\x01\x01\x01",
+                .alen   = 8,
+                .result = "\x01\x01\x01\x01\x01\x01\x01\x01"
+                          "\x01\x01\x01\x01\x01\x01\x01\x01"
+                          "\x01\x01\x01\x01\x01\x01\x01\x01"
+                          "\x01\x01\x01\x01\x01\x01\x01\x01"
+                          "\x01\x01\x01\x01\x01\x01\x01\x01"
+                          "\x01\x01\x01\x01\x01\x01\x01\x01"
+                          "\x01\x01\x01\x01\x01\x01\x01\x01"
+                          "\x01\x01\x01\x01\x01\x01\x01\x01",
+                .rlen   = 64,
+        }, {
+		.key    = "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+                          "\x00\x00\x00\x00",
+		.klen	= 20,
+                .iv     = "\x00\x00\x45\x67\x89\xab\xcd\xef"
+                          "\x00\x00\x00\x00",
+		.input	= "\xC1\x76\x33\x85\xE2\x9B\x5F\xDE"
+			  "\xDE\x89\x3D\x42\xE7\xC9\x69\x8A"
+			  "\x44\x6D\xC3\x88\x46\x2E\xC2\x01"
+			  "\x5E\xF6\x0C\x39\xF0\xC4\xA5\x82"
+			  "\xCD\xE8\x31\xCC\x0A\x4C\xE4\x44"
+			  "\x41\xA9\x82\x6F\x22\xA1\x23\x1A"
+			  "\xA8\xE3\x16\xFD\x31\x5C\x27\x31"
+			  "\xF1\x7F\x01\x63\xA3\xAF\x70\xA1"
+			  "\xCF\x07\x57\x41\x67\xD0\xC4\x42"
+			  "\xDB\x18\xC6\x4C\x4C\xE0\x3D\x9F"
+			  "\x05\x07\xFB\x13\x7D\x4A\xCA\x5B"
+			  "\xF0\xBF\x64\x7E\x05\xB1\x72\xEE"
+			  "\x7C\x3B\xD4\xCD\x14\x03\xB2\x2C"
+			  "\xD3\xA9\xEE\xFA\x17\xFC\x9C\xDF"
+			  "\xC7\x75\x40\xFF\xAE\xAD\x1E\x59"
+			  "\x2F\x30\x24\xFB\xAD\x6B\x10\xFA"
+			  "\x6C\x9F\x5B\xE7\x25\xD5\xD0\x25"
+			  "\xAC\x4A\x4B\xDA\xFC\x7A\x85\x1B"
+			  "\x7E\x13\x06\x82\x08\x17\xA4\x35"
+			  "\xEC\xC5\x8D\x63\x96\x81\x0A\x8F"
+			  "\xA3\x05\x38\x95\x20\x1A\x47\x04"
+			  "\x6F\x6D\xDA\x8F\xEF\xC1\x76\x35"
+			  "\x6B\xC7\x4D\x0F\x94\x12\xCA\x3E"
+			  "\x2E\xD5\x03\x2E\x86\x7E\xAA\x3B"
+			  "\x37\x08\x1C\xCF\xBA\x5D\x71\x46"
+			  "\x80\x72\xB0\x4C\x82\x0D\x60\x3C",
+		.ilen	= 208,
+                .assoc  = "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+                          "\xaa\xaa\xaa\xaa",
+                .alen   = 12,
+                .result = "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff"
+                          "\xff\xff\xff\xff\xff\xff\xff\xff",
+                .rlen   = 192,
+
+	}
+};
+
 static struct aead_testvec aes_ccm_enc_tv_template[] = {
 	{ /* From RFC 3610 */
 		.key	= "\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7"
-- 
1.5.3.rc5

--------------------------------------------------------------
Intel Shannon Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263
Business address: Dromore House, East Park, Shannon, Co. Clare

This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). Any review or distribution by others is strictly prohibited. If you are not the intended recipient, please contact the sender and delete all copies.


