Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab1G3WeZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 18:34:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38528 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab1G3WeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 18:34:14 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [PATCH v2 1/2] random: Add support for architectural random hooks
Date: Sat, 30 Jul 2011 15:26:22 -0700
Message-Id: <1312064783-9033-2-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1312064783-9033-1-git-send-email-hpa@zytor.com>
References: <1311971867-25124-1-git-send-email-hpa@linux.intel.com>
 <1312064783-9033-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Add support for architecture-specific hooks into either the blocking
or the nonblocking random pools.  These hooks are defined to produce a
single random "unsigned long" and return true (nonzero) on success.

They could also potentialy be used to inject randomness on demand
while continuing to use the pool system, by calling a suitable
injection interface and returning 0.

Note: the "blocking" hook is not actually allowed to block; the
semantic difference is that it is required to produce
/dev/random-quality entropy if available.

Changes in version 2:
- Have a single hook per pool (blocking, nonblocking) that returns an
  unsigned long.  The loops to fill an arbitrary buffer has moved to
  generic code.
- Invoke the nonblocking hook to service get_random_int() if it is
  available.  (Note: we could in theory do this for random32() as
  well, however, the assumption is that random32() is used when speed
  is the only thing that matters, and the current random32()
  implementation is extremely fast.)
- Correct the use of the nonblocking hook to preinitialize the pool
  data buffers.  Version 1 would incorrectly initialize the input pool
  three times.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c  |  134 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/random.h |   14 +++++
 2 files changed, 147 insertions(+), 1 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index d4ddeba..f2ddc6a 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -416,6 +416,7 @@ struct entropy_store {
 	const char *name;
 	struct entropy_store *pull;
 	int limit;
+	arch_random_func_t arch_func; /* Arch-specific shortcut */
 
 	/* read-write data: */
 	spinlock_t lock;
@@ -724,6 +725,104 @@ void add_disk_randomness(struct gendisk *disk)
 
 /*********************************************************************
  *
+ * Helper functions to fill a block from an arch-specific function
+ *
+ *********************************************************************/
+
+/* Clear a variable and make sure it is actually zeroed in memory */
+#define ZERO_VAR(x) do {			\
+	(x) = 0;				\
+	asm volatile("" : : "m" (x));		\
+} while (0)
+
+#ifdef CONFIG_ARCH_RANDOM
+
+static ssize_t func_to_kern(arch_random_func_t func,
+			    void *buf, size_t size)
+{
+	unsigned long *p1 = (unsigned long *)buf;
+	unsigned long rnd;
+	ssize_t ret = 0;
+	int ok;
+
+	while (size >= sizeof *p1) {
+		ok = func(p1);
+		if (unlikely(!ok))
+			goto out;
+		p1++;
+		size -= sizeof *p1;
+		ret  += sizeof *p1;
+	}
+
+	if (size) {
+		ok = func(&rnd);
+		if (unlikely(!ok))
+			goto out;
+		memcpy(p1, &rnd, size);
+		ret += size;
+	}
+
+out:
+	ZERO_VAR(rnd);
+	return ret;
+}
+
+static ssize_t func_to_user(arch_random_func_t func,
+			    void __user *buf, size_t size)
+{
+	char __user *p1 = (char __user *)buf;
+	unsigned long rnd;
+	size_t chunk;
+	ssize_t ret = 0;
+	int ok, err;
+
+	while (size >= sizeof rnd) {
+		ok = func(&rnd);
+		if (unlikely(!ok))
+			goto out;
+		err = copy_to_user(p1, &rnd, sizeof rnd);
+		chunk  = sizeof rnd - err;
+		p1    += chunk;
+		ret   += chunk;
+		size  -= chunk;
+		if (err)
+			goto out;
+	}
+
+	if (size) {
+		ok = func(&rnd);
+		if (unlikely(!ok))
+			goto out;
+		err = copy_to_user(p1, &rnd, size);
+		chunk  = size - err;
+		p1    += chunk;
+		ret   += chunk;
+		size  -= chunk;
+	}
+
+out:
+	ZERO_VAR(rnd);
+	return ret;
+}
+
+#else
+
+static inline ssize_t func_to_kern(arch_random_func_t func,
+				   void *buf, size_t size)
+{
+	return 0;
+}
+
+static inline ssize_t func_to_user(arch_random_func_t func,
+				   void __user *buf, size_t size)
+{
+	return 0;
+}
+
+#endif
+
+/*********************************************************************
+ *
  * Entropy extraction routines
  *
  *********************************************************************/
@@ -862,6 +961,15 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 	__u8 tmp[EXTRACT_SIZE];
 	unsigned long flags;
 
+	if (r->arch_func) {
+		ret = func_to_kern(r->arch_func, buf, nbytes);
+		buf += ret;
+		nbytes -= ret;
+	}
+
+	if (!nbytes)
+		return ret;
+
 	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, min, reserved);
 
@@ -894,6 +1002,15 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
 	ssize_t ret = 0, i;
 	__u8 tmp[EXTRACT_SIZE];
 
+	if (r->arch_func) {
+		ret = func_to_user(r->arch_func, buf, nbytes);
+		buf += ret;
+		nbytes -= ret;
+	}
+
+	if (!nbytes)
+		return ret;
+
 	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, 0, 0);
 
@@ -954,6 +1071,11 @@ static void init_std_data(struct entropy_store *r)
 	r->entropy_count = 0;
 	spin_unlock_irqrestore(&r->lock, flags);
 
+	if (nonblocking_pool.arch_func) {
+		func_to_kern(nonblocking_pool.arch_func,
+			     r->pool, r->poolinfo->POOLBYTES);
+	}
+
 	now = ktime_get_real();
 	mix_pool_bytes(r, &now, sizeof(now));
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
@@ -961,6 +1083,8 @@ static void init_std_data(struct entropy_store *r)
 
 static int rand_initialize(void)
 {
+	arch_setup_random_funcs(&nonblocking_pool.arch_func,
+				&blocking_pool.arch_func);
 	init_std_data(&input_pool);
 	init_std_data(&blocking_pool);
 	init_std_data(&nonblocking_pool);
@@ -1635,8 +1759,16 @@ DEFINE_PER_CPU(__u32 [4], get_random_int_hash);
 unsigned int get_random_int(void)
 {
 	struct keydata *keyptr;
-	__u32 *hash = get_cpu_var(get_random_int_hash);
+	__u32 *hash;
 	int ret;
+	unsigned long tmp;
+
+	if (nonblocking_pool.arch_func) {
+		if (nonblocking_pool.arch_func(&tmp))
+			return tmp;
+	}
+
+	hash = get_cpu_var(get_random_int_hash);
 
 	keyptr = get_keyptr();
 	hash[0] += current->pid + jiffies + get_cycles();
diff --git a/include/linux/random.h b/include/linux/random.h
index fb7ab9d..65a1752 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -10,6 +10,7 @@
 #include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/irqnr.h>
+#include <linux/errno.h>
 
 /* ioctl()'s for the random number generator */
 
@@ -75,7 +76,20 @@ extern const struct file_operations random_fops, urandom_fops;
 unsigned int get_random_int(void);
 unsigned long randomize_range(unsigned long start, unsigned long end, unsigned long len);
 
+typedef int (*arch_random_func_t)(unsigned long *);
+#ifdef CONFIG_ARCH_RANDOM
+void arch_setup_random_funcs(arch_random_func_t *nonblocking,
+			     arch_random_func_t *blocking);
+#else
+static inline void arch_setup_random_funcs(arch_random_func_t *nonblocking,
+					   arch_random_func_t *blocking)
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

