Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab1CPC2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 22:28:16 -0400
Received: from science.horizon.com ([71.41.210.146]:44014 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750981Ab1CPC2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 22:28:07 -0400
Message-ID: <20110316022804.27682.qmail@science.horizon.com>
MBOX-Line: From a27b0d5ad58e74b88ea9d2eeb4a0bc96aa171b74 Mon Sep 17 00:00:00 2001
From: George Spelvin <linux@horizon.com>
Date: Sun, 13 Mar 2011 20:57:01 -0400
Subject: [PATCH 2/8] drivers/char/random: Split out __get_random_int
To: penberg@cs.helsinki.fi, herbert@gondor.hengli.com.au, mpm@selenic.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unlocked function is needed for following work.
No API change.

(Minor functional change while messing with code: all 64 bits of
the cycles counter is used.  No API change.)
---
 drivers/char/random.c |   27 +++++++++++++++++----------
 1 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 4bcc4f2..fdbf7b6 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1621,22 +1621,29 @@ EXPORT_SYMBOL(secure_dccp_sequence_number);
 /*
  * Get a random word for internal kernel use only. Similar to urandom but
  * with the goal of minimal entropy pool depletion. As a result, the random
- * value is not cryptographically secure but for several uses the cost of
- * depleting entropy is too high
+ * value is not strongly cryptographically secure, but for several uses the
+ * cost of depleting entropy is too high.
  */
 DEFINE_PER_CPU(__u32 [4], get_random_int_hash);
-unsigned int get_random_int(void)
+static u32 __get_random_int(u32 *hash)
 {
-	struct keydata *keyptr;
-	__u32 *hash = get_cpu_var(get_random_int_hash);
-	int ret;
+	struct keydata const *keyptr = get_keyptr();
+	cycles_t c = get_cycles();
 
-	keyptr = get_keyptr();
-	hash[0] += current->pid + jiffies + get_cycles();
+	/* Throw in some extra seed material */
+	hash[0] += (__u32)c;
+	hash[1] += (__u32)(c>>16>>16); /* Safe if cycles_it is 32 bits. */
+	hash[2] += current->pid + jiffies;
 
-	ret = half_md4_transform(hash, keyptr->secret);
-	put_cpu_var(get_random_int_hash);
+	return half_md4_transform(hash, keyptr->secret);
+}
 
+unsigned int get_random_int(void)
+{
+	u32 *hash = get_cpu_var(get_random_int_hash);
+	u32 ret = __get_random_int(hash);
+
+	put_cpu_var(get_random_int_hash);
 	return ret;
 }
 
-- 
1.7.4.1

