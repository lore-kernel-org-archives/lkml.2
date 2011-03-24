Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589Ab1CXE7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 00:59:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:37422 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761Ab1CXE7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 00:59:14 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
To: Ingo Molnar <mingo@redhat.com>
Subject: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock if possible
Date: Thu, 24 Mar 2011 10:26:01 +0530
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-desktop; KDE/4.4.4; x86_64; ; )
Cc: Nick Piggin <npiggin@kernel.dk>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Beulich <JBeulich@novell.com>, Jack Steiner <steiner@sgi.com>,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103241026.01624.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86_64 SMP with lots of CPU atomic instructions which assert the LOCK #
signal can stall other CPUs. And as the number of cores increase this penalty
scales proportionately. So it is best to try and avoid atomic instructions
wherever possible. test_and_set_bit_lock() can avoid using LOCK_PREFIX if it
finds the bit set already.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 903683b..26a42ff 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -203,19 +203,6 @@ static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
 }
 
 /**
- * test_and_set_bit_lock - Set a bit and return its old value for lock
- * @nr: Bit to set
- * @addr: Address to count from
- *
- * This is the same as test_and_set_bit on x86.
- */
-static __always_inline int
-test_and_set_bit_lock(int nr, volatile unsigned long *addr)
-{
-	return test_and_set_bit(nr, addr);
-}
-
-/**
  * __test_and_set_bit - Set a bit and return its old value
  * @nr: Bit to set
  * @addr: Address to count from
@@ -339,6 +326,25 @@ static int test_bit(int nr, const volatile unsigned long *addr);
 	 : variable_test_bit((nr), (addr)))
 
 /**
+ * test_and_set_bit_lock - Set a bit and return its old value for lock
+ * @nr: Bit to set
+ * @addr: Address to count from
+ *
+ * This is the same as test_and_set_bit on x86. But atomic operation is
+ * avoided, if the bit was already set.
+ */
+static __always_inline int
+test_and_set_bit_lock(int nr, volatile unsigned long *addr)
+{
+#ifdef CONFIG_SMP
+	barrier();
+	if (test_bit(nr, addr))
+		return 1;
+#endif
+	return test_and_set_bit(nr, addr);
+}
+
+/**
  * __ffs - find first set bit in word
  * @word: The word to search
  *
