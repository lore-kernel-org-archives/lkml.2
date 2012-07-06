Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab2GFWpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 18:45:11 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37429 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532Ab2GFWpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 18:45:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: ewust@umich.edu, zakir@umich.edu, nadiah@cs.ucsd.edu, jhalderm@umich.edu,
        "Theodore Ts'o" <tytso@mit.edu>, stable@vger.kernel.org
Subject: [PATCH 07/12] random: use the arch-specific rng in xfer_secondary_pool
Date: Fri,  6 Jul 2012 18:44:59 -0400
Message-Id: <1341614704-24965-8-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1341614704-24965-1-git-send-email-tytso@mit.edu>
References: <1341614704-24965-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the CPU supports a hardware random number generator, use it in
xfer_secondary_pool(), where it will significantly improve things and
where we can afford it.

Also, remove the use of the arch-specific rng in
add_timer_randomness(), since the call is significantly slower than
get_cycles(), and we're much better off using it in
xfer_secondary_pool() anyway.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 drivers/char/random.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index e867409..c39bdc4 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -702,11 +702,7 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 		goto out;
 
 	sample.jiffies = jiffies;
-
-	/* Use arch random value, fall back to cycles */
-	if (!arch_get_random_int(&sample.cycles))
-		sample.cycles = get_cycles();
-
+	sample.cycles = get_cycles();
 	sample.num = num;
 	mix_pool_bytes(&input_pool, &sample, sizeof(sample), NULL);
 
@@ -838,7 +834,11 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
  */
 static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 {
-	__u32 tmp[OUTPUT_POOL_WORDS];
+	union {
+		__u32	tmp[OUTPUT_POOL_WORDS];
+		long	hwrand[4];
+	} u;
+	int	i;
 
 	if (r->pull && r->entropy_count < nbytes * 8 &&
 	    r->entropy_count < r->poolinfo->POOLBITS) {
@@ -849,17 +849,22 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 		/* pull at least as many as BYTES as wakeup BITS */
 		bytes = max_t(int, bytes, random_read_wakeup_thresh / 8);
 		/* but never more than the buffer size */
-		bytes = min_t(int, bytes, sizeof(tmp));
+		bytes = min_t(int, bytes, sizeof(u.tmp));
 
 		DEBUG_ENT("going to reseed %s with %d bits "
 			  "(%d of %d requested)\n",
 			  r->name, bytes * 8, nbytes * 8, r->entropy_count);
 
-		bytes = extract_entropy(r->pull, tmp, bytes,
+		bytes = extract_entropy(r->pull, u.tmp, bytes,
 					random_read_wakeup_thresh / 8, rsvd);
-		mix_pool_bytes(r, tmp, bytes, NULL);
+		mix_pool_bytes(r, u.tmp, bytes, NULL);
 		credit_entropy_bits(r, bytes*8);
 	}
+	for (i = 0; i < 4; i++)
+		if (arch_get_random_long(&u.hwrand[i]))
+			break;
+	if (i)
+		mix_pool_bytes(r, &u.hwrand, sizeof(u.hwrand), 0);
 }
 
 /*
-- 
1.7.11.1.108.gb129051

