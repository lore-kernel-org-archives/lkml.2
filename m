Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab0I2KHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 06:07:05 -0400
Received: from [150.82.175.143] ([150.82.175.143]:39722 "EHLO
	dhcpa11143.tky.aist.go.jp" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750951Ab0I2KHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 06:07:04 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 1/2] bitops: make asm-generic/bitops/find.h more generic
Date: Wed, 29 Sep 2010 18:08:50 +0900
Message-Id: <1285751331-29148-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.1.231.gd0b16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm-generic/bitops/find.h has the extern declarations of find_next_bit()
and find_next_zero_bit() and the macro definitions of find_first_bit()
and find_first_zero_bit(). It is only usable by the architectures which
enables CONFIG_GENERIC_FIND_NEXT_BIT and disables
CONFIG_GENERIC_FIND_FIRST_BIT.

x86 and tile enable both CONFIG_GENERIC_FIND_NEXT_BIT and
CONFIG_GENERIC_FIND_FIRST_BIT. These architectures cannot include
asm-generic/bitops/find.h in their asm/bitops.h. So ifdefed extern
declarations of find_first_bit and find_first_zero_bit() are put in
linux/bitops.h.

This makes asm-generic/bitops/find.h usable by these architectures
and use it. Also this change is needed for the forthcoming duplicated
extern declarations cleanup.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/bitops.h    |    1 +
 arch/x86/include/asm/bitops.h     |    2 ++
 include/asm-generic/bitops/find.h |   25 +++++++++++++++++++++++++
 include/linux/bitops.h            |   22 ----------------------
 4 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/arch/tile/include/asm/bitops.h b/arch/tile/include/asm/bitops.h
index 6832b4b..6d4f0ff 100644
--- a/arch/tile/include/asm/bitops.h
+++ b/arch/tile/include/asm/bitops.h
@@ -120,6 +120,7 @@ static inline unsigned long __arch_hweight64(__u64 w)
 
 #include <asm-generic/bitops/const_hweight.h>
 #include <asm-generic/bitops/lock.h>
+#include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/minix.h>
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index bafd80d..903683b 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -440,6 +440,8 @@ static inline int fls(int x)
 
 #ifdef __KERNEL__
 
+#include <asm-generic/bitops/find.h>
+
 #include <asm-generic/bitops/sched.h>
 
 #define ARCH_HAS_FAST_MULTIPLIER 1
diff --git a/include/asm-generic/bitops/find.h b/include/asm-generic/bitops/find.h
index 1914e97..30afec0 100644
--- a/include/asm-generic/bitops/find.h
+++ b/include/asm-generic/bitops/find.h
@@ -9,7 +9,32 @@ extern unsigned long find_next_zero_bit(const unsigned long *addr, unsigned
 		long size, unsigned long offset);
 #endif
 
+#ifdef CONFIG_GENERIC_FIND_FIRST_BIT
+
+/**
+ * find_first_bit - find the first set bit in a memory region
+ * @addr: The address to start the search at
+ * @size: The maximum size to search
+ *
+ * Returns the bit number of the first set bit.
+ */
+extern unsigned long find_first_bit(const unsigned long *addr,
+				    unsigned long size);
+
+/**
+ * find_first_zero_bit - find the first cleared bit in a memory region
+ * @addr: The address to start the search at
+ * @size: The maximum size to search
+ *
+ * Returns the bit number of the first cleared bit.
+ */
+extern unsigned long find_first_zero_bit(const unsigned long *addr,
+					 unsigned long size);
+#else /* CONFIG_GENERIC_FIND_FIRST_BIT */
+
 #define find_first_bit(addr, size) find_next_bit((addr), (size), 0)
 #define find_first_zero_bit(addr, size) find_next_zero_bit((addr), (size), 0)
 
+#endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
+
 #endif /*_ASM_GENERIC_BITOPS_FIND_H_ */
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index fc68053..adb0f11 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -136,28 +136,6 @@ static inline unsigned long __ffs64(u64 word)
 }
 
 #ifdef __KERNEL__
-#ifdef CONFIG_GENERIC_FIND_FIRST_BIT
-
-/**
- * find_first_bit - find the first set bit in a memory region
- * @addr: The address to start the search at
- * @size: The maximum size to search
- *
- * Returns the bit number of the first set bit.
- */
-extern unsigned long find_first_bit(const unsigned long *addr,
-				    unsigned long size);
-
-/**
- * find_first_zero_bit - find the first cleared bit in a memory region
- * @addr: The address to start the search at
- * @size: The maximum size to search
- *
- * Returns the bit number of the first cleared bit.
- */
-extern unsigned long find_first_zero_bit(const unsigned long *addr,
-					 unsigned long size);
-#endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
 #ifdef CONFIG_GENERIC_FIND_LAST_BIT
 /**
-- 
1.7.1.231.gd0b16

