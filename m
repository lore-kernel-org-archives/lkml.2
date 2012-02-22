Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab2BVJDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 04:03:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40671 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab2BVJD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 04:03:27 -0500
Date: Wed, 22 Feb 2012 10:03:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] jump labels: Explain the .config option better
Message-ID: <20120222090318.GB26397@elte.hu>
References: <cover.1329851692.git.jbaron@redhat.com>
 <4F43F9F0.4000605@zytor.com>
 <20120221202019.GB2381@redhat.com>
 <1329856745.25686.72.camel@gandalf.stny.rr.com>
 <20120222073251.GB17291@elte.hu>
 <20120222075334.GA25053@elte.hu>
 <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com>
 <20120222081855.GB25318@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222081855.GB25318@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 - update the help text as it's not only about trace points anymore
    
 - explain the functional effects of the option prominently, 
   treating the implementational details as a second level of 
   information

Additionally we might also consider renaming CONFIG_JUMP_LABEL 
to:

   CONFIG_OPTIMIZE_STATIC_BRANCHES=y

or so, to make it clearer what it's all really about and makes 
it part of the family of similarly named optimizations - but I'm 
not too concerned about that, as CONFIG_JUMP_LABEL does not 
appear in actual static-key usage sites.
    
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/Kconfig |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 4f55c73..5b448a7 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -47,18 +47,29 @@ config KPROBES
 	  If in doubt, say "N".
 
 config JUMP_LABEL
-       bool "Optimize trace point call sites"
+       bool "Optimize very unlikely/likely branches"
        depends on HAVE_ARCH_JUMP_LABEL
        help
+         This option enables a transparent branch optimization that
+	 makes certain almost-always-true or almost-always-false branch
+	 conditions even cheaper to execute within the kernel.
+
+	 Certain performance-sensitive kernel code, such as trace points,
+	 scheduler functionality, networking code and KVM have such
+	 branches and include support for this optimization technique.
+
          If it is detected that the compiler has support for "asm goto",
-	 the kernel will compile trace point locations with just a
-	 nop instruction. When trace points are enabled, the nop will
-	 be converted to a jump to the trace function. This technique
-	 lowers overhead and stress on the branch prediction of the
-	 processor.
-
-	 On i386, options added to the compiler flags may increase
-	 the size of the kernel slightly.
+	 the kernel will compile such branches with just a nop
+	 instruction. When the condition flag is toggled to true, the
+	 nop will be converted to a jump instruction to execute the
+	 conditional block of instructions.
+
+	 This technique lowers overhead and stress on the branch prediction
+	 of the processor and generally makes the kernel faster. The update
+	 of the condition is slower, but those are always very rare.
+
+	 ( On 32-bit x86, the necessary options added to the compiler
+	   flags may increase the size of the kernel slightly. )
 
 config OPTPROBES
 	def_bool y
