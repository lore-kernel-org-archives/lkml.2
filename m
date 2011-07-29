Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab1G2UiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 16:38:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:40579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab1G2UiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 16:38:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,288,1309762800"; 
   d="scan'208";a="33645165"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 1/2] random: Add support for architectural random hooks
Date: Fri, 29 Jul 2011 13:37:46 -0700
Message-Id: <1311971867-25124-2-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311971867-25124-1-git-send-email-hpa@linux.intel.com>
References: <1311971867-25124-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Add support for architecture-specific hooks into either the blocking
or the nonblocking random pools.  These hooks are defined to return
the number of bytes of randomness produced (similar to a read() system
call.)  They could also potentialy be used to inject randomness on
demand while continuing to use the pool system, by calling a suitable
injection interface and returning 0.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c  |   26 ++++++++++++++++++++++++++
 include/linux/random.h |   18 ++++++++++++++++++
 2 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index d4ddeba..ca8a86c 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -416,6 +416,7 @@ struct entropy_store {
 	const char *name;
 	struct entropy_store *pull;
 	int limit;
+	struct get_entropy_funcs arch; /* Arch-specific shortcut */
 
 	/* read-write data: */
 	spinlock_t lock;
@@ -862,6 +863,15 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 	__u8 tmp[EXTRACT_SIZE];
 	unsigned long flags;
 
+	if (r->arch.get_entropy_krnl) {
+		ret = r->arch.get_entropy_krnl(buf, nbytes);
+		buf += ret;
+		nbytes -= ret;
+	}
+
+	if (!nbytes)
+		return ret;
+
 	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, min, reserved);
 
@@ -894,6 +904,15 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
 	ssize_t ret = 0, i;
 	__u8 tmp[EXTRACT_SIZE];
 
+	if (r->arch.get_entropy_user) {
+		ret = r->arch.get_entropy_user(buf, nbytes);
+		buf += ret;
+		nbytes -= ret;
+	}
+
+	if (!nbytes)
+		return ret;
+
 	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, 0, 0);
 
@@ -954,6 +973,11 @@ static void init_std_data(struct entropy_store *r)
 	r->entropy_count = 0;
 	spin_unlock_irqrestore(&r->lock, flags);
 
+	if (nonblocking_pool.arch.get_entropy_krnl) {
+		nonblocking_pool.arch.get_entropy_krnl(input_pool_data,
+						       sizeof input_pool_data);
+	}
+
 	now = ktime_get_real();
 	mix_pool_bytes(r, &now, sizeof(now));
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
@@ -961,6 +985,8 @@ static void init_std_data(struct entropy_store *r)
 
 static int rand_initialize(void)
 {
+	arch_setup_random_funcs(&nonblocking_pool.arch,
+				&blocking_pool.arch);
 	init_std_data(&input_pool);
 	init_std_data(&blocking_pool);
 	init_std_data(&nonblocking_pool);
diff --git a/include/linux/random.h b/include/linux/random.h
index fb7ab9d..12bb392 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -10,6 +10,7 @@
 #include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/irqnr.h>
+#include <linux/errno.h>
 
 /* ioctl()'s for the random number generator */
 
@@ -75,7 +76,24 @@ extern const struct file_operations random_fops, urandom_fops;
 unsigned int get_random_int(void);
 unsigned long randomize_range(unsigned long start, unsigned long end, unsigned long len);
 
+struct get_entropy_funcs {
+	ssize_t (*get_entropy_krnl)(void *buf, size_t nbytes);
+	ssize_t (*get_entropy_user)(void __user *buf, size_t nbytes);
+};
+
+#ifdef CONFIG_ARCH_RANDOM
+void arch_setup_random_funcs(struct get_entropy_funcs *nbp,
+			     struct get_entropy_funcs *bp);
+#else
+static inline void arch_setup_random_funcs(struct get_entropy_funcs *nbp,
+					   struct get_entropy_funcs *bp)
+{
+	/* Nothing to do */
+}
+#endif
+
 u32 random32(void);
+
 void srandom32(u32 seed);
 
 u32 prandom32(struct rnd_state *);
-- 
1.7.6

