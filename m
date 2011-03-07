Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab1CGRti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 12:49:38 -0500
Received: from science.horizon.com ([71.41.210.146]:39122 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755483Ab1CGRtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 12:49:36 -0500
Date: 7 Mar 2011 12:49:34 -0500
Message-ID: <20110307174934.15811.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: penberg@kernel.org
Subject: Re: [PATCH] Make /proc/slabinfo 0400
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux@horizon.com
In-Reply-To: <20110307141948.11415.qmail@science.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To go with my earlier code, here's a (proof of concept) more efficient
random number generator for a series of small values.  A bit more code,
but a lot less calls to half_md4_transform.

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 773007d..6b3fd4e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1658,6 +1658,84 @@ unsigned int get_random_int(void)
 	return ret;
 }
 
+struct random_mod_state {
+	unsigned int x, lim;	/* Invariant: 0 <= x < lim, and random */
+	__u8 const *seed;
+	unsigned len;
+};
+
+void
+get_random_mod_start(struct random_mod_state *s)
+{
+	s->x = 0;
+	s->lim = 0;
+	s->len = 0;
+
+	preempt_disable();	/* For access to percpu variables */
+}
+
+/*
+ * Return a random 0 <= x < m.  This is exacctly uniformly distributed,
+ * which "random() % m" is not, and it is economical with seed entropy.
+ * For example, this can shuffle 27 elements (27! > 2^93) with only
+ * one call to half_md4_transform.
+ *
+ * This is limited to 24-bit moduli m; larger values risk overflow.
+ */
+unsigned
+get_random_mod(struct random_mod_state *s, unsigned m)
+{
+        unsigned x = s->x, lim = x->lim;
+
+        for (;;) {
+		unsigned k;
+
+		/* Ensure lim >= m */
+		while (lim < m) {
+			/* Invoke underlying random bit source */
+			if (!s->len--) {
+				__u32 *h = __get_cpu_var(get_random_int_hash);
+				struct keydata const *keyptr = get_keyptr();
+				cycles_t c = get_cycles();
+
+				/* Throw in some extra seed material */
+				h[0] += (__u32)c;
+				h[1] += (__u32)(c>>16>>16); /* 32-bit safe */
+				h[2] += current->pid + jiffies;
+
+				half_md4_transform(h, keyptr->secret);
+
+				/* And use last 12 bytes as random numbers */
+				s->seed = (__u8 *)(h + 1);
+				s->len = 11;	/* Pre-decremented */
+			}
+			/* Add one byte to state */
+			x = x<<8 | *s->seed++;
+			lim <<= 8;
+		}
+		/*
+		 * Core loop.  We occasionally have to discard and regenerate
+		 * to ensure uniformity.
+		 */
+		k = lim % m;
+		if (x >= k) {
+			x -= k;		lim -= k;
+			/* Final result: Return x % m, keep x / m */
+			s->x = x/m;	s->lim = lim/m;
+			return x % m;
+		}
+		/* Non-uniform: keep fractional part and try again */
+		lim = k;
+	}
+}
+
+void
+get_random_mod_stop(struct random_mod_state *s)
+{
+	(void)s;
+	preempt_enable();	/* Drop lock on s->seed */
+}
+
 /*
  * randomize_range() returns a start address such that
  *
