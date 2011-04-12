Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab1DLR0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:26:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34771 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab1DLR03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:26:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=bJbDYNUv6QZgITbKrFgFUiGMX0Zxe9xCROybbdt67NGF2bGKrEreW4eB+S7kYM0LJG
         CLQe64aVZeybxXr493ME6dffIVQ9ra9CP081bH0sqv/PZet3xH7yLDl/Taf3/i8c5gYv
         bdxqk1MwDIqXt0GAbMNIx8zuJDlGz6dnDKac8=
Date: Tue, 12 Apr 2011 20:26:23 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add kstrto*_from_user()
Message-ID: <20110412172623.GA19330@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are quite a lot of code which does
copy_from_user() + strict_strto*() or simple_strto*() combo in
slightly different ways.

Before doing conversions all over tree, let's get final API correct.

Enter kstrtoull_from_user() and friends.

Typical code which uses them looks very simple:

	TYPE val;
	int rv;

	rv = kstrtoTYPE_from_user(buf, count, 0, &val);
	if (rv < 0)
		return rv;
	[use val]
	return count;

There is tiny semantics difference from plain kstrto*() API --
the latter allows any amount of leading zeroes, while the former copies
data into buffer on stack and thus allows leading zeroes as long as it
fits into buffer.

This shouldn't be a problem for typical usecase "echo 42 > /proc/x".

The point is in making reading one integer from userspace _very_ simple
and very bug free.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/kernel.h |   31 +++++++++++++++++++++++++++++++
 lib/kstrtox.c          |   26 ++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -248,6 +248,37 @@ int __must_check kstrtos16(const char *s, unsigned int base, s16 *res);
 int __must_check kstrtou8(const char *s, unsigned int base, u8 *res);
 int __must_check kstrtos8(const char *s, unsigned int base, s8 *res);
 
+int __must_check kstrtoull_from_user(const char __user *s, size_t count, unsigned int base, unsigned long long *res);
+int __must_check kstrtoll_from_user(const char __user *s, size_t count, unsigned int base, long long *res);
+int __must_check kstrtoul_from_user(const char __user *s, size_t count, unsigned int base, unsigned long *res);
+int __must_check kstrtol_from_user(const char __user *s, size_t count, unsigned int base, long *res);
+int __must_check kstrtouint_from_user(const char __user *s, size_t count, unsigned int base, unsigned int *res);
+int __must_check kstrtoint_from_user(const char __user *s, size_t count, unsigned int base, int *res);
+int __must_check kstrtou16_from_user(const char __user *s, size_t count, unsigned int base, u16 *res);
+int __must_check kstrtos16_from_user(const char __user *s, size_t count, unsigned int base, s16 *res);
+int __must_check kstrtou8_from_user(const char __user *s, size_t count, unsigned int base, u8 *res);
+int __must_check kstrtos8_from_user(const char __user *s, size_t count, unsigned int base, s8 *res);
+
+static inline int __must_check kstrtou64_from_user(const char __user *s, size_t count, unsigned int base, u64 *res)
+{
+	return kstrtoull_from_user(s, count, base, res);
+}
+
+static inline int __must_check kstrtos64_from_user(const char __user *s, size_t count, unsigned int base, s64 *res)
+{
+	return kstrtoll_from_user(s, count, base, res);
+}
+
+static inline int __must_check kstrtou32_from_user(const char __user *s, size_t count, unsigned int base, u32 *res)
+{
+	return kstrtouint_from_user(s, count, base, res);
+}
+
+static inline int __must_check kstrtos32_from_user(const char __user *s, size_t count, unsigned int base, s32 *res)
+{
+	return kstrtoint_from_user(s, count, base, res);
+}
+
 extern unsigned long simple_strtoul(const char *,char **,unsigned int);
 extern long simple_strtol(const char *,char **,unsigned int);
 extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
--- a/lib/kstrtox.c
+++ b/lib/kstrtox.c
@@ -17,6 +17,7 @@
 #include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/types.h>
+#include <asm/uaccess.h>
 
 static inline char _tolower(const char c)
 {
@@ -222,3 +223,28 @@ int kstrtos8(const char *s, unsigned int base, s8 *res)
 	return 0;
 }
 EXPORT_SYMBOL(kstrtos8);
+
+#define kstrto_from_user(f, g, type)					\
+int f(const char __user *s, size_t count, unsigned int base, type *res)	\
+{									\
+	/* sign, base 2 representation, newline, terminator */		\
+	char buf[1 + sizeof(type) * 8 + 1 + 1];				\
+									\
+	count = min(count, sizeof(buf) - 1);				\
+	if (copy_from_user(buf, s, count))				\
+		return -EFAULT;						\
+	buf[count] = '\0';						\
+	return g(buf, base, res);					\
+}									\
+EXPORT_SYMBOL(f)
+
+kstrto_from_user(kstrtoull_from_user,	kstrtoull,	unsigned long long);
+kstrto_from_user(kstrtoll_from_user,	kstrtoll,	long long);
+kstrto_from_user(kstrtoul_from_user,	kstrtoul,	unsigned long);
+kstrto_from_user(kstrtol_from_user,	kstrtol,	long);
+kstrto_from_user(kstrtouint_from_user,	kstrtouint,	unsigned int);
+kstrto_from_user(kstrtoint_from_user,	kstrtoint,	int);
+kstrto_from_user(kstrtou16_from_user,	kstrtou16,	u16);
+kstrto_from_user(kstrtos16_from_user,	kstrtos16,	s16);
+kstrto_from_user(kstrtou8_from_user,	kstrtou8,	u8);
+kstrto_from_user(kstrtos8_from_user,	kstrtos8,	s8);
