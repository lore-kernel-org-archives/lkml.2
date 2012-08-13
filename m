Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab2HMWEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:04:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58152 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab2HMWEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:04:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        "Theodore Tso" <tytso@mit.edu>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Matt Mackall <mpm@selenic.com>, Tony Luck <tony.luck@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 16/44] random: Use arch_get_random_int instead of cycle counter if avail
Date: Mon, 13 Aug 2012 15:02:23 -0700
Message-Id: <20120813220143.578443311@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813220142.113186818@linuxfoundation.org>
References: <20120813220142.113186818@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/random.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -624,8 +624,8 @@ static struct timer_rand_state input_tim
 static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 {
 	struct {
-		cycles_t cycles;
 		long jiffies;
+		unsigned cycles;
 		unsigned num;
 	} sample;
 	long delta, delta2, delta3;
@@ -637,7 +637,11 @@ static void add_timer_randomness(struct
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
 


