Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab2INGXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:23:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49097 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab2INGXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:23:41 -0400
Date: Thu, 13 Sep 2012 23:23:25 -0700
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-5870661c091e827973674cc3469b50c959008c2b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, jbeulich@suse.com, JBeulich@suse.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, JBeulich@suse.com, jbeulich@suse.com,
        tglx@linutronix.de
In-Reply-To: <504DEA1B020000780009A277@nat28.tlf.novell.com>
References: <504DEA1B020000780009A277@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Prefer TZCNT over BFS
Git-Commit-ID: 5870661c091e827973674cc3469b50c959008c2b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:23:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5870661c091e827973674cc3469b50c959008c2b
Gitweb:     http://git.kernel.org/tip/5870661c091e827973674cc3469b50c959008c2b
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Mon, 10 Sep 2012 12:24:43 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 13 Sep 2012 17:44:01 +0200

x86: Prefer TZCNT over BFS

Following a relatively recent compiler change, make use of the
fact that for non-zero input BSF and TZCNT produce the same
result, and that CPUs not knowing of TZCNT will treat the
instruction as BSF (i.e. ignore what looks like a REP prefix to
them). The assumption here is that TZCNT would never have worse
performance than BSF.

For the moment, only do this when the respective generic-CPU
option is selected (as there are no specific-CPU options
covering the CPUs supporting TZCNT), and don't do that when size
optimization was requested.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/504DEA1B020000780009A277@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/bitops.h |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index ebaee69..b2af664 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -347,6 +347,19 @@ static int test_bit(int nr, const volatile unsigned long *addr);
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
@@ -355,7 +368,7 @@ static int test_bit(int nr, const volatile unsigned long *addr);
  */
 static inline unsigned long __ffs(unsigned long word)
 {
-	asm("bsf %1,%0"
+	asm(BSF_PREFIX "bsf %1,%0"
 		: "=r" (word)
 		: "rm" (word));
 	return word;
@@ -369,12 +382,14 @@ static inline unsigned long __ffs(unsigned long word)
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
