Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab2HGDvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:51:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59730 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757346Ab2HGDic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:32 -0400
Message-Id: <20120807032757.729008929@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:06 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>,
        "Theodore Tso" <tytso@mit.edu>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Matt Mackall <mpm@selenic.com>, Tony Luck <tony.luck@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 11/70] random: Use arch_get_random_int instead of cycle counter if avail
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/random.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 6035ab8..85da874 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -624,8 +624,8 @@ static struct timer_rand_state input_timer_state;
 static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 {
 	struct {
-		cycles_t cycles;
 		long jiffies;
+		unsigned cycles;
 		unsigned num;
 	} sample;
 	long delta, delta2, delta3;
@@ -637,7 +637,11 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
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
 


