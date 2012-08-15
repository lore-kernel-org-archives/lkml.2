Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab2HOUBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:01:22 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63146 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab2HOTwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, Tony Luck <tony.luck@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 147/165] random: Use arch_get_random_int instead of cycle counter if avail
Date: Wed, 15 Aug 2012 15:48:11 -0400
Message-ID: <1345060109-9187-148-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit cf833d0b9937874b50ef2867c4e8badfd64948ce upstream.

We still don't use rdrand in /dev/random, which just seems stupid. We
accept the *cycle*counter* as a random input, but we don't accept
rdrand? That's just broken.

Sure, people can do things in user space (write to /dev/random, use
rdrand in addition to /dev/random themselves etc etc), but that
*still* seems to be a particularly stupid reason for saying "we
shouldn't bother to try to do better in /dev/random".

And even if somebody really doesn't trust rdrand as a source of random
bytes, it seems singularly stupid to trust the cycle counter *more*.

So I'd suggest the attached patch. I'm not going to even bother
arguing that we should add more bits to the entropy estimate, because
that's not the point - I don't care if /dev/random fills up slowly or
not, I think it's just stupid to not use the bits we can get from
rdrand and mix them into the strong randomness pool.

Link: http://lkml.kernel.org/r/CA%2B55aFwn59N1=m651QAyTy-1gO1noGbK18zwKDwvwqnravA84A@mail.gmail.com
Acked-by: "David S. Miller" <davem@davemloft.net>
Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/random.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index df4eb6d..ed86cae 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -617,8 +617,8 @@ static struct timer_rand_state input_timer_state;
 static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 {
 	struct {
-		cycles_t cycles;
 		long jiffies;
+		unsigned cycles;
 		unsigned num;
 	} sample;
 	long delta, delta2, delta3;
@@ -630,7 +630,11 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 		goto out;
 
 	sample.jiffies = jiffies;
-	sample.cycles = get_cycles();
+
+	/* Use arch random value, fall back to cycles */
+	if (!arch_get_random_int(&sample.cycles))
+		sample.cycles = get_cycles();
+
 	sample.num = num;
 	mix_pool_bytes(&input_pool, &sample, sizeof(sample));
 
-- 
1.7.12.rc2

