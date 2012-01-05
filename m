Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab2AEP1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:27:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58775 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab2AEP1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:27:48 -0500
Date: Thu, 5 Jan 2012 16:25:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/rdrand change for v3.3
Message-ID: <20120105152548.GA11797@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-rdrand-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-rdrand-for-linus


out-of-topic modifications in x86-rdrand-for-linus:
---------------------------------------------------
drivers/char/random.c              # cf833d0: random: Use arch_get_random_int i

 Thanks,

	Ingo

------------------>
Linus Torvalds (1):
      random: Use arch_get_random_int instead of cycle counter if avail


 drivers/char/random.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

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
 
