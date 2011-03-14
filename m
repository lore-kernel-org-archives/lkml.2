Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab1CPC2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 22:28:14 -0400
Received: from science.horizon.com ([71.41.210.146]:44031 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751117Ab1CPC2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 22:28:07 -0400
Message-ID: <20110316022804.27701.qmail@science.horizon.com>
MBOX-Line: From e074f29248f9528e12f0c9d05e278eb5b300f2a5 Mon Sep 17 00:00:00 2001
From: George Spelvin <linux@horizon.com>
Date: Mon, 14 Mar 2011 14:26:31 -0400
Subject: [PATCH 4/8] drivers/char/random: Add get_random_mod() functions
To: penberg@cs.helsinki.fi, herbert@gondor.hengli.com.au, mpm@selenic.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a function for generating random numbers modulo small
integers, with uniform distribution and parsimonious use of seed
material.
---
 drivers/char/random.c  |   63 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/random.h |   14 ++++++++++
 2 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 113508e..fc36a98 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1626,6 +1626,8 @@ EXPORT_SYMBOL(secure_dccp_sequence_number);
  */
 struct cpu_random {
 	u32 hash[4];
+	u32 lim, x;
+	int avail;	/* Trailing bytes of hash[] available for seed */
 };
 DEFINE_PER_CPU(struct cpu_random, get_random_int_data);
 static u32 __get_random_int(u32 *hash)
@@ -1646,10 +1648,71 @@ unsigned int get_random_int(void)
 	struct cpu_random *r = &get_cpu_var(get_random_int_data);
 	u32 ret = __get_random_int(r->hash);
 
+	r->avail = 8;
 	put_cpu_var(r);
 	return ret;
 }
 
+struct cpu_random *
+get_random_mod_start(void)
+{
+	struct cpu_random *r = &get_cpu_var(get_random_int_data);
+
+	if (r->x >= r->lim) {
+		r->x = 0;
+		r->lim = 1;
+		r->avail = 0;
+	}
+	return r;
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
+get_random_mod(struct cpu_random *r, unsigned m)
+{
+	unsigned x = r->x, lim = r->lim;
+
+	BUG_ON(m >= 0x1000000);
+	do {
+		BUG_ON(x >= lim);
+
+		/* Ensure lim >= m */
+		while (lim < m) {
+			/* Invoke underlying random bit source, if needed. */
+			if (!r->avail) {
+				/* Generate 12 more bytes of seed */
+				(void)__get_random_int(r->hash);
+				r->avail = 12;
+			}
+			/* Add one byte of seed material. */
+			x = (x << 8) |
+				((u8 *)r->hash)[sizeof r->hash - r->avail--];
+			lim <<= 8;
+		}
+		/* Now check for uniformity, and loop if necessary. */
+		r->lim = lim / m;
+		lim %= m;
+	} while (unlikely(x < lim));
+
+	x -= lim;
+	/* We now have 0 <= x < m * r->lim, so x % m is uniform */
+	r->x = x / m;	/* Remainder available for future use */
+	return x % m;
+}
+
+void
+get_random_mod_stop(struct cpu_random *r)
+{
+	put_cpu_var(r);
+}
+
 /*
  * randomize_range() returns a start address such that
  *
diff --git a/include/linux/random.h b/include/linux/random.h
index fb7ab9d..2e1c227 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -75,6 +75,20 @@ extern const struct file_operations random_fops, urandom_fops;
 unsigned int get_random_int(void);
 unsigned long randomize_range(unsigned long start, unsigned long end, unsigned long len);
 
+
+/*
+ * These functions generate a sequence of values modulo a small integer m.
+ * They are intended for shuffling operations.  "m" must be no more
+ * than 24 bits, or they will BUG().  (Rather than suffering an internal
+ * overflow.)
+ * They use per-CPU data, so preemption is disabled in the _start
+ * function and re-enabled in _stop.
+ */
+struct cpu_random;	/* Opaque to acllers of this interface */
+struct cpu_random *get_random_mod_start(void);
+unsigned get_random_mod(struct cpu_random *r, unsigned m);
+void get_random_mod_stop(struct cpu_random *r);
+
 u32 random32(void);
 void srandom32(u32 seed);
 
-- 
1.7.4.1

