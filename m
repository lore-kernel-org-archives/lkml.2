Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab2ISRGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:06:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53966 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab2ISRGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:06:20 -0400
Date: Wed, 19 Sep 2012 10:05:58 -0700
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-e26a44a2d618a491d5c6a2a8aaf66ee03a94739f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, jbeulich@suse.com, JBeulich@suse.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, JBeulich@suse.com, jbeulich@suse.com,
        tglx@linutronix.de
In-Reply-To: <5058741E020000780009C014@nat28.tlf.novell.com>
References: <5058741E020000780009C014@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Use REP BSF unconditionally
Git-Commit-ID: e26a44a2d618a491d5c6a2a8aaf66ee03a94739f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 19 Sep 2012 10:06:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e26a44a2d618a491d5c6a2a8aaf66ee03a94739f
Gitweb:     http://git.kernel.org/tip/e26a44a2d618a491d5c6a2a8aaf66ee03a94739f
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Tue, 18 Sep 2012 12:16:14 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Sep 2012 17:26:08 +0200

x86: Use REP BSF unconditionally

Make "REP BSF" unconditional, as per the suggestion of hpa
and Linus, this removes the insane BSF_PREFIX conditional
and simplifies the logic.

Suggested-by: "H. Peter Anvin" <hpa@zytor.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/5058741E020000780009C014@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/bitops.h |   19 ++-----------------
 1 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index b2af664..6dfd019 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -347,19 +347,6 @@ static int test_bit(int nr, const volatile unsigned long *addr);
 	 ? constant_test_bit((nr), (addr))	\
 	 : variable_test_bit((nr), (addr)))
 
-#if (defined(CONFIG_X86_GENERIC) || defined(CONFIG_GENERIC_CPU)) \
-    && !defined(CONFIG_CC_OPTIMIZE_FOR_SIZE)
-/*
- * Since BSF and TZCNT have sufficiently similar semantics for the purposes
- * for which we use them here, BMI-capable hardware will decode the prefixed
- * variant as 'tzcnt ...' and may execute that faster than 'bsf ...', while
- * older hardware will ignore the REP prefix and decode it as 'bsf ...'.
- */
-# define BSF_PREFIX "rep;"
-#else
-# define BSF_PREFIX
-#endif
-
 /**
  * __ffs - find first set bit in word
  * @word: The word to search
@@ -368,7 +355,7 @@ static int test_bit(int nr, const volatile unsigned long *addr);
  */
 static inline unsigned long __ffs(unsigned long word)
 {
-	asm(BSF_PREFIX "bsf %1,%0"
+	asm("rep; bsf %1,%0"
 		: "=r" (word)
 		: "rm" (word));
 	return word;
@@ -382,14 +369,12 @@ static inline unsigned long __ffs(unsigned long word)
  */
 static inline unsigned long ffz(unsigned long word)
 {
-	asm(BSF_PREFIX "bsf %1,%0"
+	asm("rep; bsf %1,%0"
 		: "=r" (word)
 		: "r" (~word));
 	return word;
 }
 
-#undef BSF_PREFIX
-
 /*
  * __fls: find last set bit in word
  * @word: The word to search
