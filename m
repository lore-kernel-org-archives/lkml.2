Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933542Ab2JAXOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:14:49 -0400
Received: from 1wt.eu ([62.212.114.60]:35494 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933084Ab2JAXCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:06 -0400
Message-Id: <20121001225204.223255292@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:33 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 156/180] random: simplify fips mode
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Mackall <mpm@selenic.com>

commit e954bc91bdd4bb08b8325478c5004b24a23a3522 upstream.

Rather than dynamically allocate 10 bytes, move it to static allocation.
This saves space and avoids the need for error checking.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[PG: adding this simplifies required updates to random for .34 stable]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/char/random.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index de325792..0adb8c8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -264,6 +264,7 @@
 #define INPUT_POOL_WORDS 128
 #define OUTPUT_POOL_WORDS 32
 #define SEC_XFER_SIZE 512
+#define EXTRACT_SIZE 10
 
 /*
  * The minimum number of bits of entropy before we wake up a read on
@@ -421,7 +422,7 @@ struct entropy_store {
 	unsigned add_ptr;
 	int entropy_count;
 	int input_rotate;
-	__u8 *last_data;
+	__u8 last_data[EXTRACT_SIZE];
 };
 
 static __u32 input_pool_data[INPUT_POOL_WORDS];
@@ -721,8 +722,6 @@ void add_disk_randomness(struct gendisk *disk)
 }
 #endif
 
-#define EXTRACT_SIZE 10
-
 /*********************************************************************
  *
  * Entropy extraction routines
@@ -869,7 +868,7 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 	while (nbytes) {
 		extract_buf(r, tmp);
 
-		if (r->last_data) {
+		if (fips_enabled) {
 			spin_lock_irqsave(&r->lock, flags);
 			if (!memcmp(tmp, r->last_data, EXTRACT_SIZE))
 				panic("Hardware RNG duplicated output!\n");
@@ -958,9 +957,6 @@ static void init_std_data(struct entropy_store *r)
 	now = ktime_get_real();
 	mix_pool_bytes(r, &now, sizeof(now));
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
-	/* Enable continuous test in fips mode */
-	if (fips_enabled)
-		r->last_data = kmalloc(EXTRACT_SIZE, GFP_KERNEL);
 }
 
 static int rand_initialize(void)
-- 
1.7.2.1.45.g54fbc



