Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab2IJLYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 07:24:49 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:52576 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab2IJLYs convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 10 Sep 2012 07:24:48 -0400
Message-Id: <504DEA1B020000780009A277@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 10 Sep 2012 12:24:43 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: prefer tzcnt over bsf
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following a relatively recent compiler change, make use of the fact
that for non-zero input BSF and TZCNT produce the same result, and that
CPUs not knowing of TZCNT will treat the instruction as BSF (i.e.
ignore what looks like a REP prefix to them). The assumption here is
that TZCNT would never have worse performance than BSF.

For the moment, only do this when the respective generic-CPU option is
selected (as there are no specific-CPU options covering the CPUs
supporting TZCNT), and don't do that when size optimization was
requested.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/include/asm/bitops.h |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- 3.6-rc5/arch/x86/include/asm/bitops.h
+++ 3.6-rc5-x86-bsf-tzcnt/arch/x86/include/asm/bitops.h
@@ -347,6 +347,19 @@ static int test_bit(int nr, const volati
 	 ? constant_test_bit((nr), (addr))	\
 	 : variable_test_bit((nr), (addr)))
 
+#if (defined(CONFIG_X86_GENERIC) || defined(CONFIG_GENERIC_CPU)) \
+    && !defined(CONFIG_CC_OPTIMIZE_FOR_SIZE)
+/*
+ * Since BSF and TZCNT have sufficiently similar semantics for the purposes
+ * for which we use them here, BMI-capable hardware will decode the prefixed
+ * variant as 'tzcnt ...' and may execute that faster than 'bsf ...', while
+ * older hardware will ignore the REP prefix and decode it as 'bsf ...'.
+ */
+# define BSF_PREFIX "rep;"
+#else
+# define BSF_PREFIX
+#endif
+
 /**
  * __ffs - find first set bit in word
  * @word: The word to search
@@ -355,7 +368,7 @@ static int test_bit(int nr, const volati
  */
 static inline unsigned long __ffs(unsigned long word)
 {
-	asm("bsf %1,%0"
+	asm(BSF_PREFIX "bsf %1,%0"
 		: "=r" (word)
 		: "rm" (word));
 	return word;
@@ -369,12 +382,14 @@ static inline unsigned long __ffs(unsign
  */
 static inline unsigned long ffz(unsigned long word)
 {
-	asm("bsf %1,%0"
+	asm(BSF_PREFIX "bsf %1,%0"
 		: "=r" (word)
 		: "r" (~word));
 	return word;
 }
 
+#undef BSF_PREFIX
+
 /*
  * __fls: find last set bit in word
  * @word: The word to search



