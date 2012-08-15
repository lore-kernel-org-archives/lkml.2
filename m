Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab2HOUBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:01:25 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63145 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab2HOTwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 144/165] random: Add support for architectural random hooks
Date: Wed, 15 Aug 2012 15:48:08 -0400
Message-ID: <1345060109-9187-145-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 63d77173266c1791f1553e9e8ccea65dc87c4485 upstream.

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
[PG: .34 already had "unsigned int ret" in get_random_int, so the
 diffstat here is slightly smaller than that of 63d7717. ]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/random.c  | 23 +++++++++++++++++++++--
 include/linux/random.h | 13 +++++++++++++
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 1e07bbe..6da0696 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -925,7 +925,21 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
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
 
@@ -1309,9 +1323,14 @@ late_initcall(random_int_secret_init);
 DEFINE_PER_CPU(__u32 [MD5_DIGEST_WORDS], get_random_int_hash);
 unsigned int get_random_int(void)
 {
-	__u32 *hash = get_cpu_var(get_random_int_hash);
+	__u32 *hash;
 	unsigned int ret;
 
+	if (arch_get_random_int(&ret))
+		return ret;
+
+	hash = get_cpu_var(get_random_int_hash);
+
 	hash[0] += current->pid + jiffies + get_cycles();
 	md5_transform(hash, random_int_secret);
 	ret = hash[0];
diff --git a/include/linux/random.h b/include/linux/random.h
index 2948046..0bf2936 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -63,6 +63,19 @@ unsigned long randomize_range(unsigned long start, unsigned long end, unsigned l
 u32 random32(void);
 void srandom32(u32 seed);
 
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
1.7.12.rc2

