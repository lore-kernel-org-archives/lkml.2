Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab2GESaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 14:30:15 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37076 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644Ab2GESaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 14:30:13 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu, zakir@umich.edu,
        greg@kroah.com, mpm@selenic.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 06/10] random: use the arch-specific rng in xfer_secondary_pool
Date: Thu,  5 Jul 2012 14:12:09 -0400
Message-Id: <1341511933-11169-7-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1341511933-11169-1-git-send-email-tytso@mit.edu>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
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
Cc: stable@kernel.org
---
 drivers/char/random.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 59ddcce..7f95f91 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -695,8 +695,8 @@ static struct timer_rand_state input_timer_state;
 static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 {
 	struct {
+		cycles_t cycles;
 		long jiffies;
-		unsigned cycles;
 		unsigned num;
 	} sample;
 	long delta, delta2, delta3;
@@ -708,11 +708,7 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 		goto out;
 
 	sample.jiffies = jiffies;
-
-	/* Use arch random value, fall back to cycles */
-	if (!arch_get_random_int(&sample.cycles))
-		sample.cycles = get_cycles();
-
+	sample.cycles = get_cycles();
 	sample.num = num;
 	mix_pool_bytes(&input_pool, &sample, sizeof(sample));
 
@@ -831,7 +827,8 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
  */
 static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 {
-	__u32 tmp[OUTPUT_POOL_WORDS];
+	__u32	tmp[OUTPUT_POOL_WORDS];
+	int	i, hwrand[4];
 
 	if (r->pull && r->entropy_count < nbytes * 8 &&
 	    r->entropy_count < r->poolinfo->POOLBITS) {
@@ -853,6 +850,11 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 		mix_pool_bytes(r, tmp, bytes);
 		credit_entropy_bits(r, bytes*8, 0);
 	}
+	for (i = 0; i < 4; i++)
+		if (arch_get_random_int(&hwrand[i]))
+			break;
+	if (i)
+		mix_pool_bytes(r, &hwrand, sizeof(hwrand));
 }
 
 /*
-- 
1.7.11.1.108.gb129051

