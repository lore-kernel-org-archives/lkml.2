Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980Ab2CMAXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:23:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:48184 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758923Ab2CMAX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:28 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jim Bos <jim876@xs4all.nl>,
        Andi Kleen <andi@firstfloor.org>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 113/196] Fix gcc 4.5.1 miscompiling drivers/char/i8k.c (again)
Date: Mon, 12 Mar 2012 20:20:26 -0400
Message-Id: <1331598109-31424-68-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Bos <jim876@xs4all.nl>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 22d3243de86bc92d874abb7c5b185d5c47aba323 upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/i8k.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 828fd24..4365717 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -119,7 +119,7 @@ static int i8k_smm(struct smm_regs *regs)
 	int eax = regs->eax;
 
 #if defined(CONFIG_X86_64)
-	asm("pushq %%rax\n\t"
+	asm volatile("pushq %%rax\n\t"
 		"movl 0(%%rax),%%edx\n\t"
 		"pushq %%rdx\n\t"
 		"movl 4(%%rax),%%ebx\n\t"
@@ -141,11 +141,11 @@ static int i8k_smm(struct smm_regs *regs)
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
@@ -167,7 +167,7 @@ static int i8k_smm(struct smm_regs *regs)
 	    "lahf\n\t"
 	    "shrl $8,%%eax\n\t"
 	    "andl $1,%%eax\n"
-	    :"=a"(rc), "+m" (*regs)
+	    :"=a"(rc)
 	    :    "a"(regs)
 	    :    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #endif
-- 
1.7.9.3

