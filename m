Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab0ETFoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 01:44:21 -0400
Received: from waste.org ([173.11.57.241]:35289 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756Ab0ETFoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 01:44:20 -0400
Subject: [PATCH] random: simplify fips mode
From: Matt Mackall <mpm@selenic.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Linux Mailing List <linux-kernel@vger.kernel.org>,
       Steven Liu <lingjiujianke@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 May 2010 00:44:17 -0500
Message-ID: <1274334257.11603.1438.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than dynamically allocate 10 bytes, move it to static allocation.
This saves space and avoids the need for error checking.

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r a12387bbcc93 drivers/char/random.c
--- a/drivers/char/random.c	Thu Apr 08 10:02:02 2010 -0700
+++ b/drivers/char/random.c	Thu May 20 00:43:13 2010 -0500
@@ -257,6 +257,7 @@
 #define INPUT_POOL_WORDS 128
 #define OUTPUT_POOL_WORDS 32
 #define SEC_XFER_SIZE 512
+#define EXTRACT_SIZE 10
 
 /*
  * The minimum number of bits of entropy before we wake up a read on
@@ -414,7 +415,7 @@
 	unsigned add_ptr;
 	int entropy_count;
 	int input_rotate;
-	__u8 *last_data;
+	__u8 last_data[EXTRACT_SIZE];
 };
 
 static __u32 input_pool_data[INPUT_POOL_WORDS];
@@ -714,8 +715,6 @@
 }
 #endif
 
-#define EXTRACT_SIZE 10
-
 /*********************************************************************
  *
  * Entropy extraction routines
@@ -862,7 +861,7 @@
 	while (nbytes) {
 		extract_buf(r, tmp);
 
-		if (r->last_data) {
+		if (fips_enabled) {
 			spin_lock_irqsave(&r->lock, flags);
 			if (!memcmp(tmp, r->last_data, EXTRACT_SIZE))
 				panic("Hardware RNG duplicated output!\n");
@@ -951,9 +950,6 @@
 	now = ktime_get_real();
 	mix_pool_bytes(r, &now, sizeof(now));
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
-	/* Enable continuous test in fips mode */
-	if (fips_enabled)
-		r->last_data = kmalloc(EXTRACT_SIZE, GFP_KERNEL);
 }
 
 static int rand_initialize(void)

-- 
Mathematics is the supreme nostalgia of our time.


