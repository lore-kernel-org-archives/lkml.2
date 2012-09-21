Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166Ab2IUUA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 16:00:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50853 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226Ab2IUUA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:00:26 -0400
Date: Fri, 21 Sep 2012 13:00:15 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-9cebed423c84a56b871327dd77e555d1d2186a6b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1348256595-29119-5-git-send-email-hpa@linux.intel.com>
References: <1348256595-29119-5-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/smap] x86, alternative: Use .pushsection/.popsection
Git-Commit-ID: 9cebed423c84a56b871327dd77e555d1d2186a6b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 21 Sep 2012 13:00:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9cebed423c84a56b871327dd77e555d1d2186a6b
Gitweb:     http://git.kernel.org/tip/9cebed423c84a56b871327dd77e555d1d2186a6b
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 21 Sep 2012 12:43:08 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 21 Sep 2012 12:45:25 -0700

x86, alternative: Use .pushsection/.popsection

.section/.previous doesn't nest.  Use .pushsection/.popsection in
<asm/alternative.h> so that they can be properly nested.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1348256595-29119-5-git-send-email-hpa@linux.intel.com
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
