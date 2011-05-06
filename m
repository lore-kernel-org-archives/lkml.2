Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab1EFA6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:58:54 -0400
Received: from kroah.org ([198.145.64.141]:36690 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083Ab1EFAYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:37 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:08 2011
Message-Id: <20110506002208.831680946@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jim Bos <jim876@xs4all.nl>, Jakub Jelinek <jakub@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: [037/143] Fix gcc 4.5.1 miscompiling drivers/char/i8k.c (again)
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jim Bos <jim876@xs4all.nl>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/i8k.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
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


