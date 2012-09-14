Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab2INGWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:22:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49087 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab2INGWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:22:47 -0400
Date: Thu, 13 Sep 2012 23:22:30 -0700
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-1edfbb4153bd29bcf8d2236676238d5237972be1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, jbeulich@suse.com, JBeulich@suse.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, JBeulich@suse.com, jbeulich@suse.com,
        tglx@linutronix.de
In-Reply-To: <504DE550020000780009A258@nat28.tlf.novell.com>
References: <504DE550020000780009A258@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86/64: Adjust types of temporaries used by ffs()/
 fls()/fls64()
Git-Commit-ID: 1edfbb4153bd29bcf8d2236676238d5237972be1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:22:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1edfbb4153bd29bcf8d2236676238d5237972be1
Gitweb:     http://git.kernel.org/tip/1edfbb4153bd29bcf8d2236676238d5237972be1
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Mon, 10 Sep 2012 12:04:16 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 13 Sep 2012 17:43:58 +0200

x86/64: Adjust types of temporaries used by ffs()/fls()/fls64()

The 64-bit special cases of the former two (the thrird one is
64-bit only anyway) don't need to use "long" temporaries, as the
result will always fit in a 32-bit variable, and the functions
return plain "int". This avoids a few REX prefixes, i.e.
minimally reduces code size.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/504DE550020000780009A258@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/bitops.h |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 72f5009..ebaee69 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -417,10 +417,9 @@ static inline int ffs(int x)
 	 * We cannot do this on 32 bits because at the very least some
 	 * 486 CPUs did not behave this way.
 	 */
-	long tmp = -1;
 	asm("bsfl %1,%0"
 	    : "=r" (r)
-	    : "rm" (x), "0" (tmp));
+	    : "rm" (x), "0" (-1));
 #elif defined(CONFIG_X86_CMOV)
 	asm("bsfl %1,%0\n\t"
 	    "cmovzl %2,%0"
@@ -459,10 +458,9 @@ static inline int fls(int x)
 	 * We cannot do this on 32 bits because at the very least some
 	 * 486 CPUs did not behave this way.
 	 */
-	long tmp = -1;
 	asm("bsrl %1,%0"
 	    : "=r" (r)
-	    : "rm" (x), "0" (tmp));
+	    : "rm" (x), "0" (-1));
 #elif defined(CONFIG_X86_CMOV)
 	asm("bsrl %1,%0\n\t"
 	    "cmovzl %2,%0"
@@ -490,13 +488,13 @@ static inline int fls(int x)
 #ifdef CONFIG_X86_64
 static __always_inline int fls64(__u64 x)
 {
-	long bitpos = -1;
+	int bitpos = -1;
 	/*
 	 * AMD64 says BSRQ won't clobber the dest reg if x==0; Intel64 says the
 	 * dest reg is undefined if x==0, but their CPU architect says its
 	 * value is written to set it to the same as before.
 	 */
-	asm("bsrq %1,%0"
+	asm("bsrq %1,%q0"
 	    : "+r" (bitpos)
 	    : "rm" (x));
 	return bitpos + 1;
