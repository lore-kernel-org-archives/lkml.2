Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab1GaV1r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 17:27:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60162 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab1GaV1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 17:27:41 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [PATCH v3 1/3] random: Add support for architectural random hooks
Date: Sun, 31 Jul 2011 14:26:54 -0700
Message-Id: <1312147616-29125-2-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1312147616-29125-1-git-send-email-hpa@zytor.com>
References: <CA+55aFy5iRjCigmK-eddkP8Wqy_qFDZRd6PV5d0XFE3p8ws1Bg@mail.gmail.com>
 <1312147616-29125-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Add support for architecture-specific hooks into the kernel-directed
random number generator interfaces.  This patchset does not use the
architecture random number generator interfaces for the
userspace-directed interfaces (/dev/random and /dev/urandom), thus
eliminating the need to distinguish between them based on a pool
pointer.

Changes in version 3:
- Moved the hooks from extract_entropy() to get_random_bytes().
- Changes the hooks to inlines.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c  |   25 ++++++++++++++++++++++---
 include/linux/random.h |   13 +++++++++++++
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index d4ddeba..bb58712 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -932,7 +932,21 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
  */
 void get_random_bytes(void *buf, int nbytes)
 {
-	extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
+	char *p = buf;
+
+	while (nbytes) {
+		unsigned long v;
+		int chunk = min(nbytes, (int)sizeof(unsigned long));
+		
+		if (!arch_get_random_long(&v))
+			break;
+		
+		memcpy(buf, &v, chunk);
+		p += chunk;
+		nbytes -= chunk;
+	}
+
+	extract_entropy(&nonblocking_pool, p, nbytes, 0, 0);
 }
 EXPORT_SYMBOL(get_random_bytes);
 
@@ -1635,8 +1649,13 @@ DEFINE_PER_CPU(__u32 [4], get_random_int_hash);
 unsigned int get_random_int(void)
 {
 	struct keydata *keyptr;
-	__u32 *hash = get_cpu_var(get_random_int_hash);
-	int ret;
+	__u32 *hash;
+	unsigned int ret;
+
+	if (arch_get_random_int(&ret))
+		return ret;
+
+	hash = get_cpu_var(get_random_int_hash);
 
 	keyptr = get_keyptr();
 	hash[0] += current->pid + jiffies + get_cycles();
diff --git a/include/linux/random.h b/include/linux/random.h
index fb7ab9d..079cbba 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -102,6 +102,19 @@ static inline void prandom32_seed(struct rnd_state *state, u64 seed)
 	state->s3 = __seed(i, 15);
 }
 
+#ifdef CONFIG_ARCH_RANDOM
+# include <asm/archrandom.h>
+#else
+static inline int arch_get_random_long(unsigned long *v)
+{
+	return 0;
+}
+static inline int arch_get_random_int(unsigned int *v)
+{
+	return 0;
+}
+#endif
+
 #endif /* __KERNEL___ */
 
 #endif /* _LINUX_RANDOM_H */
-- 
1.7.6

