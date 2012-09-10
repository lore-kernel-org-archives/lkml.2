Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab2IJLEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 07:04:23 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41850 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab2IJLEV convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 10 Sep 2012 07:04:21 -0400
Message-Id: <504DE550020000780009A258@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 10 Sep 2012 12:04:16 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: adjust types of temporaries used by
 ffs()/fls()/fls64()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 64-bit special cases of the former two (the thrird one is 64-bit
only anyway) don't need to use "long" temporaries, as the result will
always fit in a 32-bit variable, and the functions return plain "int".
This avoids a few REX prefixes, i.e. minimally reduces code size.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/include/asm/bitops.h |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- 3.6-rc5/arch/x86/include/asm/bitops.h
+++ 3.6-rc5-x86_64-bsf-bsr-types/arch/x86/include/asm/bitops.h
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



