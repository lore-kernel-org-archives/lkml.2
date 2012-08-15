Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab2HOUDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:03:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:37309 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab2HOTwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 141/165] random: simplify fips mode
Date: Wed, 15 Aug 2012 15:48:05 -0400
Message-ID: <1345060109-9187-142-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e954bc91bdd4bb08b8325478c5004b24a23a3522 upstream.

Rather than dynamically allocate 10 bytes, move it to static allocation.
This saves space and avoids the need for error checking.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[PG: adding this simplifies required updates to random for .34 stable]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/random.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index ccdadd9..1e07bbe 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -257,6 +257,7 @@
 #define INPUT_POOL_WORDS 128
 #define OUTPUT_POOL_WORDS 32
 #define SEC_XFER_SIZE 512
+#define EXTRACT_SIZE 10
 
 /*
  * The minimum number of bits of entropy before we wake up a read on
@@ -414,7 +415,7 @@ struct entropy_store {
 	unsigned add_ptr;
 	int entropy_count;
 	int input_rotate;
-	__u8 *last_data;
+	__u8 last_data[EXTRACT_SIZE];
 };
 
 static __u32 input_pool_data[INPUT_POOL_WORDS];
@@ -714,8 +715,6 @@ void add_disk_randomness(struct gendisk *disk)
 }
 #endif
 
-#define EXTRACT_SIZE 10
-
 /*********************************************************************
  *
  * Entropy extraction routines
@@ -862,7 +861,7 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 	while (nbytes) {
 		extract_buf(r, tmp);
 
-		if (r->last_data) {
+		if (fips_enabled) {
 			spin_lock_irqsave(&r->lock, flags);
 			if (!memcmp(tmp, r->last_data, EXTRACT_SIZE))
 				panic("Hardware RNG duplicated output!\n");
@@ -951,9 +950,6 @@ static void init_std_data(struct entropy_store *r)
 	now = ktime_get_real();
 	mix_pool_bytes(r, &now, sizeof(now));
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
-	/* Enable continuous test in fips mode */
-	if (fips_enabled)
-		r->last_data = kmalloc(EXTRACT_SIZE, GFP_KERNEL);
 }
 
 static int rand_initialize(void)
-- 
1.7.12.rc2

