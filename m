Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab2BAVjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:39:03 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48879 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757250Ab2BAVJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:09:48 -0500
X-Sasl-enc: OVKkkEhKWiRZgHL8i0Tvs1Qx11GJ0X8x7Xy3Ja4EQHZC 1328130586
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:46 2012
Message-Id: <20120201210046.221886343@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andreas Schwab <schwab@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [26/89] m68k: Fix assembler constraint to prevent overeager gcc optimisation
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Schwab <schwab@linux-m68k.org>

commit 2a3535069e33d8b416f406c159ce924427315303 upstream.

Passing the address of a variable as an operand to an asm statement
doesn't mark the value of this variable as used, so gcc may optimize its
initialisation away.  Fix this by using the "m" constraint instead.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/m68k/atari/config.c      |    8 ++++----
 arch/m68k/kernel/process_mm.c |    4 ++--
 arch/m68k/kernel/process_no.c |    4 ++--
 arch/m68k/kernel/traps.c      |   36 +++++++++++++++++-------------------
 arch/m68k/mm/cache.c          |    6 +++---
 5 files changed, 28 insertions(+), 30 deletions(-)

--- a/arch/m68k/atari/config.c
+++ b/arch/m68k/atari/config.c
@@ -414,9 +414,9 @@ void __init config_atari(void)
 					 * FDC val = 4 -> Supervisor only */
 		asm volatile ("\n"
 			"	.chip	68030\n"
-			"	pmove	%0@,%/tt1\n"
+			"	pmove	%0,%/tt1\n"
 			"	.chip	68k"
-			: : "a" (&tt1_val));
+			: : "m" (tt1_val));
 	} else {
 	        asm volatile ("\n"
 			"	.chip	68040\n"
@@ -569,10 +569,10 @@ static void atari_reset(void)
 			: "d0");
 	} else
 		asm volatile ("\n"
-			"	pmove	%0@,%%tc\n"
+			"	pmove	%0,%%tc\n"
 			"	jmp	%1@"
 			: /* no outputs */
-			: "a" (&tc_val), "a" (reset_addr));
+			: "m" (tc_val), "a" (reset_addr));
 }
 
 
--- a/arch/m68k/kernel/process_mm.c
+++ b/arch/m68k/kernel/process_mm.c
@@ -189,8 +189,8 @@ void flush_thread(void)
 	current->thread.fs = __USER_DS;
 	if (!FPU_IS_EMU)
 		asm volatile (".chip 68k/68881\n\t"
-			      "frestore %0@\n\t"
-			      ".chip 68k" : : "a" (&zero));
+			      "frestore %0\n\t"
+			      ".chip 68k" : : "m" (zero));
 }
 
 /*
--- a/arch/m68k/kernel/process_no.c
+++ b/arch/m68k/kernel/process_no.c
@@ -163,8 +163,8 @@ void flush_thread(void)
 #ifdef CONFIG_FPU
 	if (!FPU_IS_EMU)
 		asm volatile (".chip 68k/68881\n\t"
-			      "frestore %0@\n\t"
-			      ".chip 68k" : : "a" (&zero));
+			      "frestore %0\n\t"
+			      ".chip 68k" : : "m" (zero));
 #endif
 }
 
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -552,13 +552,13 @@ static inline void bus_error030 (struct
 
 #ifdef DEBUG
 		asm volatile ("ptestr %3,%2@,#7,%0\n\t"
-			      "pmove %%psr,%1@"
-			      : "=a&" (desc)
-			      : "a" (&temp), "a" (addr), "d" (ssw));
+			      "pmove %%psr,%1"
+			      : "=a&" (desc), "=m" (temp)
+			      : "a" (addr), "d" (ssw));
 #else
 		asm volatile ("ptestr %2,%1@,#7\n\t"
-			      "pmove %%psr,%0@"
-			      : : "a" (&temp), "a" (addr), "d" (ssw));
+			      "pmove %%psr,%0"
+			      : "=m" (temp) : "a" (addr), "d" (ssw));
 #endif
 		mmusr = temp;
 
@@ -605,20 +605,18 @@ static inline void bus_error030 (struct
 			       !(ssw & RW) ? "write" : "read", addr,
 			       fp->ptregs.pc, ssw);
 			asm volatile ("ptestr #1,%1@,#0\n\t"
-				      "pmove %%psr,%0@"
-				      : /* no outputs */
-				      : "a" (&temp), "a" (addr));
+				      "pmove %%psr,%0"
+				      : "=m" (temp)
+				      : "a" (addr));
 			mmusr = temp;
 
 			printk ("level 0 mmusr is %#x\n", mmusr);
 #if 0
-			asm volatile ("pmove %%tt0,%0@"
-				      : /* no outputs */
-				      : "a" (&tlong));
+			asm volatile ("pmove %%tt0,%0"
+				      : "=m" (tlong));
 			printk("tt0 is %#lx, ", tlong);
-			asm volatile ("pmove %%tt1,%0@"
-				      : /* no outputs */
-				      : "a" (&tlong));
+			asm volatile ("pmove %%tt1,%0"
+				      : "=m" (tlong));
 			printk("tt1 is %#lx\n", tlong);
 #endif
 #ifdef DEBUG
@@ -668,13 +666,13 @@ static inline void bus_error030 (struct
 
 #ifdef DEBUG
 	asm volatile ("ptestr #1,%2@,#7,%0\n\t"
-		      "pmove %%psr,%1@"
-		      : "=a&" (desc)
-		      : "a" (&temp), "a" (addr));
+		      "pmove %%psr,%1"
+		      : "=a&" (desc), "=m" (temp)
+		      : "a" (addr));
 #else
 	asm volatile ("ptestr #1,%1@,#7\n\t"
-		      "pmove %%psr,%0@"
-		      : : "a" (&temp), "a" (addr));
+		      "pmove %%psr,%0"
+		      : "=m" (temp) : "a" (addr));
 #endif
 	mmusr = temp;
 
--- a/arch/m68k/mm/cache.c
+++ b/arch/m68k/mm/cache.c
@@ -52,9 +52,9 @@ static unsigned long virt_to_phys_slow(u
 		unsigned long *descaddr;
 
 		asm volatile ("ptestr %3,%2@,#7,%0\n\t"
-			      "pmove %%psr,%1@"
-			      : "=a&" (descaddr)
-			      : "a" (&mmusr), "a" (vaddr), "d" (get_fs().seg));
+			      "pmove %%psr,%1"
+			      : "=a&" (descaddr), "=m" (mmusr)
+			      : "a" (vaddr), "d" (get_fs().seg));
 		if (mmusr & (MMU_I|MMU_B|MMU_L))
 			return 0;
 		descaddr = phys_to_virt((unsigned long)descaddr);


