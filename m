Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171Ab1LPIVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 03:21:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56987 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760058Ab1LPIVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 03:21:15 -0500
Date: Fri, 16 Dec 2011 09:19:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Beulich <JBeulich@suse.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] x86: Use -m-omit-leaf-frame-pointer to shrink text size
Message-ID: <20111216081915.GA28288@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch turns on -momit-leaf-frame-pointer on x86 builds and 
thus shrinks .text noticeably. On a defconfig-ish kernel:

   text	   data	    bss	    dec	    hex	filename
   9843902	1935808	3649536	15429246	 eb6e7e	vmlinux.before
   9813764	1935792	3649536	15399092	 eaf8b4	vmlinux.after

That's 0.3% off text size.

The actual win is larger than this percentage suggests: many 
small, hot helper functions such as find_next_bit(), 
do_raw_spin_lock() or most of the list_*() functions are leaf 
functions and are now shorter by 2 instructions.

Probably a good chunk of the framepointers related runtime 
overhead on common workloads is eliminated via this patch, as 
small leaf functions execute more often than larger parent 
functions.

The call-chains are still intact for quality backtraces and for 
call-chain profiling (perf record -g), as the backtrace walker 
can deduct the full backtrace from the RIP of a leaf function 
and the parent chain.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Makefile |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux/arch/x86/Makefile
===================================================================
--- linux.orig/arch/x86/Makefile
+++ linux/arch/x86/Makefile
@@ -72,6 +72,14 @@ else
         KBUILD_CFLAGS += -maccumulate-outgoing-args
 endif
 
+#
+# This shrinks many small functions, we don't actually
+# need their frame pointer, in backtraces the RIP will
+# identify the function and the stack frame walker will
+# find the parent function:
+#
+KBUILD_CFLAGS += $(call cc-option,-momit-leaf-frame-pointer)
+
 ifdef CONFIG_CC_STACKPROTECTOR
 	cc_has_sp := $(srctree)/scripts/gcc-x86_$(BITS)-has-stack-protector.sh
         ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(KBUILD_CPPFLAGS) $(biarch)),y)
