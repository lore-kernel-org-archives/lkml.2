Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab1G0AfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:35:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:52724 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369Ab1G0AfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="30471005"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: jim876@xs4all.nl, jakub@redhat.com, andi@firstfloor.org,
        schwab@linux-m68k.org, torvalds@linux-foundation.org,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] [8/98] Fix gcc 4.5.1 miscompiling drivers/char/i8k.c (again)
Message-Id: <20110727003500.2034B2403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jim Bos <jim876@xs4all.nl>

[ upstream commit 22d3243de86bc92d874abb7c5b185d5c47aba323 ]

The fix in commit 6b4e81db2552 ("i8k: Tell gcc that *regs gets
clobbered") to work around the gcc miscompiling i8k.c to add "+m
(*regs)" caused register pressure problems and a build failure.

Changing the 'asm' statement to 'asm volatile' instead should prevent
that and works around the gcc bug as well, so we can remove the "+m".

[ Background on the gcc bug: a memory clobber fails to mark the function
  the asm resides in as non-pure (aka "__attribute__((const))"), so if
  the function does nothing else that triggers the non-pure logic, gcc
  will think that that function has no side effects at all. As a result,
  callers will be mis-compiled.

  Adding the "+m" made gcc see that it's not a pure function, and so
  does "asm volatile". The problem was never really the need to mark
  "*regs" as changed, since the memory clobber did that part - the
  problem was just a bug in the gcc "pure" function analysis  - Linus ]

Signed-off-by: Jim Bos <jim876@xs4all.nl>
Acked-by: Jakub Jelinek <jakub@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/char/i8k.c
===================================================================
--- linux-2.6.35.y.orig/drivers/char/i8k.c
+++ linux-2.6.35.y/drivers/char/i8k.c
@@ -119,7 +119,7 @@ static int i8k_smm(struct smm_regs *regs
 	int eax = regs->eax;
 
 #if defined(CONFIG_X86_64)
-	asm("pushq %%rax\n\t"
+	asm volatile("pushq %%rax\n\t"
 		"movl 0(%%rax),%%edx\n\t"
 		"pushq %%rdx\n\t"
 		"movl 4(%%rax),%%ebx\n\t"
@@ -141,11 +141,11 @@ static int i8k_smm(struct smm_regs *regs
 		"lahf\n\t"
 		"shrl $8,%%eax\n\t"
 		"andl $1,%%eax\n"
-		:"=a"(rc), "+m" (*regs)
+		:"=a"(rc)
 		:    "a"(regs)
 		:    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #else
-	asm("pushl %%eax\n\t"
+	asm volatile("pushl %%eax\n\t"
 	    "movl 0(%%eax),%%edx\n\t"
 	    "push %%edx\n\t"
 	    "movl 4(%%eax),%%ebx\n\t"
@@ -167,7 +167,7 @@ static int i8k_smm(struct smm_regs *regs
 	    "lahf\n\t"
 	    "shrl $8,%%eax\n\t"
 	    "andl $1,%%eax\n"
-	    :"=a"(rc), "+m" (*regs)
+	    :"=a"(rc)
 	    :    "a"(regs)
 	    :    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #endif
