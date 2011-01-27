Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab1A0N4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 08:56:04 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53846 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab1A0N4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 08:56:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iksXEfgttr4BvTXEx4vZhk3tuUENoX48OuTvT9yG4BHI8GIjCcvFjsdZvTtQu2QsaE
         pXF+p0b+NSO640wt2rlAwflJe0kDu7J0ok6GObR5G761IiZjaFsvCU6Sz2SWAFSLL60t
         UVxNB/gttMOYqvOwJT02xUFnl/yq3VU0loo3Y=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH -mm 3/6] s390: convert little-endian bitops macros to static inline functions
Date: Thu, 27 Jan 2011 22:56:20 +0900
Message-Id: <1296136583-13815-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296136583-13815-1-git-send-email-akinobu.mita@gmail.com>
References: <1296136583-13815-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This patch is intended to be folded into the patch in -mm:
s390-introduce-little-endian-bitops.patch)

The little-endian bitops on s390 are written as preprocessor
macros with the cast to "unsigned long *".
This means that even non-pointers will be accepted without an error, and
that is a Very Bad Thing.

This converts the little-endian bitops macros to static inline functions
with proper prototypes.

Suggested-by: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/include/asm/bitops.h |   48 ++++++++++++++++++++++++++++-----------
 1 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/arch/s390/include/asm/bitops.h b/arch/s390/include/asm/bitops.h
index 6528b22..e1c8f3a 100644
--- a/arch/s390/include/asm/bitops.h
+++ b/arch/s390/include/asm/bitops.h
@@ -742,20 +742,40 @@ static inline int sched_find_first_bit(unsigned long *b)
  *    23 22 21 20 19 18 17 16 31 30 29 28 27 26 25 24
  */
 
-#define __set_bit_le(nr, addr)	\
-	__set_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)(addr))
-#define __clear_bit_le(nr, addr)	\
-	__clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)(addr))
-#define __test_and_set_bit_le(nr, addr)	\
-	__test_and_set_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)(addr))
-#define test_and_set_bit_le(nr, addr)	\
-	test_and_set_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)(addr))
-#define __test_and_clear_bit_le(nr, addr)	\
-	__test_and_clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)(addr))
-#define test_and_clear_bit_le(nr, addr)	\
-	test_and_clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)(addr))
-#define test_bit_le(nr, addr)	\
-	test_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)(addr))
+static inline void __set_bit_le(unsigned long nr, void *addr)
+{
+	__set_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
+}
+
+static inline void __clear_bit_le(unsigned long nr, void *addr)
+{
+	__clear_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
+}
+
+static inline int __test_and_set_bit_le(unsigned long nr, void *addr)
+{
+	return __test_and_set_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
+}
+
+static inline int test_and_set_bit_le(unsigned long nr, void *addr)
+{
+	return test_and_set_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
+}
+
+static inline int __test_and_clear_bit_le(unsigned long nr, void *addr)
+{
+	return __test_and_clear_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
+}
+
+static inline int test_and_clear_bit_le(unsigned long nr, void *addr)
+{
+	return test_and_clear_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
+}
+
+static inline int test_bit_le(unsigned long nr, const void *addr)
+{
+	return test_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
+}
 
 static inline int find_first_zero_bit_le(void *vaddr, unsigned int size)
 {
-- 
1.7.3.4

