Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab2IUTpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:45:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:26130 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119Ab2IUTnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:43:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,464,1344236400"; 
   d="scan'208";a="225201994"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 04/11] x86, alternative: Use .pushsection/.popsection
Date: Fri, 21 Sep 2012 12:43:08 -0700
Message-Id: <1348256595-29119-5-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

.section/.previous doesn't nest.  Use .pushsection/.popsection in
<asm/alternative.h> so that they can be properly nested.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/alternative-asm.h |    4 ++--
 arch/x86/include/asm/alternative.h     |   32 ++++++++++++++++----------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/alternative-asm.h b/arch/x86/include/asm/alternative-asm.h
index 952bd01..018d29f 100644
--- a/arch/x86/include/asm/alternative-asm.h
+++ b/arch/x86/include/asm/alternative-asm.h
@@ -5,10 +5,10 @@
 #ifdef CONFIG_SMP
 	.macro LOCK_PREFIX
 672:	lock
-	.section .smp_locks,"a"
+	.pushsection .smp_locks,"a"
 	.balign 4
 	.long 672b - .
-	.previous
+	.popsection
 	.endm
 #else
 	.macro LOCK_PREFIX
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 7078068..87bc00d 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -29,10 +29,10 @@
 
 #ifdef CONFIG_SMP
 #define LOCK_PREFIX_HERE \
-		".section .smp_locks,\"a\"\n"	\
-		".balign 4\n"			\
-		".long 671f - .\n" /* offset */	\
-		".previous\n"			\
+		".pushsection .smp_locks,\"a\"\n"	\
+		".balign 4\n"				\
+		".long 671f - .\n" /* offset */		\
+		".popsection\n"				\
 		"671:"
 
 #define LOCK_PREFIX LOCK_PREFIX_HERE "\n\tlock; "
@@ -99,30 +99,30 @@ static inline int alternatives_text_reserved(void *start, void *end)
 /* alternative assembly primitive: */
 #define ALTERNATIVE(oldinstr, newinstr, feature)			\
 	OLDINSTR(oldinstr)						\
-	".section .altinstructions,\"a\"\n"				\
+	".pushsection .altinstructions,\"a\"\n"				\
 	ALTINSTR_ENTRY(feature, 1)					\
-	".previous\n"							\
-	".section .discard,\"aw\",@progbits\n"				\
+	".popsection\n"							\
+	".pushsection .discard,\"aw\",@progbits\n"			\
 	DISCARD_ENTRY(1)						\
-	".previous\n"							\
-	".section .altinstr_replacement, \"ax\"\n"			\
+	".popsection\n"							\
+	".pushsection .altinstr_replacement, \"ax\"\n"			\
 	ALTINSTR_REPLACEMENT(newinstr, feature, 1)			\
-	".previous"
+	".popsection"
 
 #define ALTERNATIVE_2(oldinstr, newinstr1, feature1, newinstr2, feature2)\
 	OLDINSTR(oldinstr)						\
-	".section .altinstructions,\"a\"\n"				\
+	".pushsection .altinstructions,\"a\"\n"				\
 	ALTINSTR_ENTRY(feature1, 1)					\
 	ALTINSTR_ENTRY(feature2, 2)					\
-	".previous\n"							\
-	".section .discard,\"aw\",@progbits\n"				\
+	".popsection\n"							\
+	".pushsection .discard,\"aw\",@progbits\n"			\
 	DISCARD_ENTRY(1)						\
 	DISCARD_ENTRY(2)						\
-	".previous\n"							\
-	".section .altinstr_replacement, \"ax\"\n"			\
+	".popsection\n"							\
+	".pushsection .altinstr_replacement, \"ax\"\n"			\
 	ALTINSTR_REPLACEMENT(newinstr1, feature1, 1)			\
 	ALTINSTR_REPLACEMENT(newinstr2, feature2, 2)			\
-	".previous"
+	".popsection"
 
 /*
  * This must be included *after* the definition of ALTERNATIVE due to
-- 
1.7.6.5

