Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab2HMWD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:03:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35533 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab2HMWDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:03:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 14/44] random: Add support for architectural random hooks
Date: Mon, 13 Aug 2012 15:02:21 -0700
Message-Id: <20120813220143.399307850@linuxfoundation.org>
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

From: "H. Peter Anvin" <hpa@zytor.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/random.c  |   23 +++++++++++++++++++++--
 include/linux/random.h |   13 +++++++++++++
 2 files changed, 34 insertions(+), 2 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -932,7 +932,21 @@ static ssize_t extract_entropy_user(stru
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
 
@@ -1318,9 +1332,14 @@ late_initcall(random_int_secret_init);
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
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -91,6 +91,19 @@ static inline void prandom32_seed(struct
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


