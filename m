Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab2BEW1O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:27:14 -0500
Received: from 1wt.eu ([62.212.114.60]:62141 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538Ab2BEW1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:27:06 -0500
Message-Id: <20120205220953.132108866@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:11:15 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jim Bos <jim876@xs4all.nl>, Jakub Jelinek <jakub@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 86/91] Fix gcc 4.5.1 miscompiling drivers/char/i8k.c (again)
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
 1 files changed, 4 insertions(+), 4 deletions(-)

Index: longterm-2.6.27/drivers/char/i8k.c
===================================================================
--- longterm-2.6.27.orig/drivers/char/i8k.c	2012-02-05 22:34:47.002916726 +0100
+++ longterm-2.6.27/drivers/char/i8k.c	2012-02-05 22:34:47.136914619 +0100
@@ -119,7 +119,7 @@
 	int eax = regs->eax;
 
 #if defined(CONFIG_X86_64)
-	asm("pushq %%rax\n\t"
+	asm volatile("pushq %%rax\n\t"
 		"movl 0(%%rax),%%edx\n\t"
 		"pushq %%rdx\n\t"
 		"movl 4(%%rax),%%ebx\n\t"
@@ -141,11 +141,11 @@
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
@@ -167,7 +167,7 @@
 	    "lahf\n\t"
 	    "shrl $8,%%eax\n\t"
 	    "andl $1,%%eax\n"
-	    :"=a"(rc), "+m" (*regs)
+	    :"=a"(rc)
 	    :    "a"(regs)
 	    :    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #endif


