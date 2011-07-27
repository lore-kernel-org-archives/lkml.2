Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab1G0M7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 08:59:17 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:50233 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab1G0M6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 08:58:18 -0400
Message-Id: <20110727125808.367205861@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Wed, 27 Jul 2011 14:55:10 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: vgoyal@redhat.com
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch v2 06/10] s390: Export store_status() function
References: <20110727125504.491183728@linux.vnet.ibm.com>
Content-Disposition: inline; filename=s390-kdump-arch-store-status.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

For kdump we need a store status function to save the registers for the
current CPU. Therefore this patch exports a function "store_status()".
In addition to that now also floating point registers are saved correctly.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/s390/kernel/reipl64.S |   80 +++++++++++++++++++++++++++++++++------------
 1 file changed, 60 insertions(+), 20 deletions(-)

--- a/arch/s390/kernel/reipl64.S
+++ b/arch/s390/kernel/reipl64.S
@@ -1,5 +1,5 @@
 /*
- *    Copyright IBM Corp 2000,2009
+ *    Copyright IBM Corp 2000,2011
  *    Author(s): Holger Smolinski <Holger.Smolinski@de.ibm.com>,
  *		 Denis Joseph Barrow,
  */
@@ -8,6 +8,64 @@
 #include <asm/asm-offsets.h>
 
 #
+# store_status
+#
+# Prerequisites to run this function:
+# - Prefix register is set to zero
+# - Original prefix register is stored in "dump_prefix_page"
+# - Lowcore protection is off
+#
+ENTRY(store_status)
+	/* Save register one and load save area base */
+	stg	%r1,__LC_SAVE_AREA_64(%r0)
+	lghi	%r1,SAVE_AREA_BASE
+	/* General purpose registers */
+	stmg	%r0,%r15,__LC_GPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	lg	%r2,__LC_SAVE_AREA_64(%r0)
+	stg	%r2,__LC_GPREGS_SAVE_AREA-SAVE_AREA_BASE+8(%r1)
+	/* Control registers */
+	stctg	%c0,%c15,__LC_CREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	/* Access registers */
+	stam	%a0,%a15,__LC_AREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	/* Floating point registers */
+	std	%f0, 0x00 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f1, 0x08 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f2, 0x10 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f3, 0x18 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f4, 0x20 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f5, 0x28 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f6, 0x30 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f7, 0x38 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f8, 0x40 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f9, 0x48 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f10,0x50 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f11,0x58 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f12,0x60 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f13,0x68 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f14,0x70 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	std	%f15,0x78 + __LC_FPREGS_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	/* Floating point control register */
+	stfpc	__LC_FP_CREG_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	/* CPU timer */
+	stpt	__LC_CPU_TIMER_SAVE_AREA-SAVE_AREA_BASE(%r1)
+	/* Saved prefix register */
+	larl	%r2,dump_prefix_page
+	mvc	__LC_PREFIX_SAVE_AREA-SAVE_AREA_BASE(4,%r1),0(%r2)
+	/* Clock comparator - seven bytes */
+	larl	%r2,.Lclkcmp
+	stckc	0(%r2)
+	mvc	__LC_CLOCK_COMP_SAVE_AREA-SAVE_AREA_BASE + 1(7,%r1),1(%r2)
+	/* Program status word */
+	epsw	%r2,%r3
+	st	%r2,__LC_PSW_SAVE_AREA-SAVE_AREA_BASE + 0(%r1)
+	st	%r3,__LC_PSW_SAVE_AREA-SAVE_AREA_BASE + 4(%r1)
+	larl	%r2,store_status
+	stg	%r2,__LC_PSW_SAVE_AREA-SAVE_AREA_BASE + 8(%r1)
+	br	%r14
+.align	8
+.Lclkcmp:	.quad	0x0000000000000000
+
+#
 # do_reipl_asm
 # Parameter: r2 = schid of reipl device
 #
@@ -15,22 +73,7 @@
 ENTRY(do_reipl_asm)
 		basr	%r13,0
 .Lpg0:		lpswe	.Lnewpsw-.Lpg0(%r13)
-.Lpg1:		# do store status of all registers
-
-		stg	%r1,.Lregsave-.Lpg0(%r13)
-		lghi	%r1,0x1000
-		stmg	%r0,%r15,__LC_GPREGS_SAVE_AREA-0x1000(%r1)
-		lg	%r0,.Lregsave-.Lpg0(%r13)
-		stg	%r0,__LC_GPREGS_SAVE_AREA-0x1000+8(%r1)
-		stctg	%c0,%c15,__LC_CREGS_SAVE_AREA-0x1000(%r1)
-		stam	%a0,%a15,__LC_AREGS_SAVE_AREA-0x1000(%r1)
-		lg	%r10,.Ldump_pfx-.Lpg0(%r13)
-		mvc	__LC_PREFIX_SAVE_AREA-0x1000(4,%r1),0(%r10)
-		stfpc	__LC_FP_CREG_SAVE_AREA-0x1000(%r1)
-		stckc	.Lclkcmp-.Lpg0(%r13)
-		mvc	__LC_CLOCK_COMP_SAVE_AREA-0x1000(7,%r1),.Lclkcmp-.Lpg0(%r13)
-		stpt	__LC_CPU_TIMER_SAVE_AREA-0x1000(%r1)
-		stg	%r13, __LC_PSW_SAVE_AREA-0x1000+8(%r1)
+.Lpg1:		brasl	%r14,store_status
 
 		lctlg	%c6,%c6,.Lall-.Lpg0(%r13)
 		lgr	%r1,%r2
@@ -67,10 +110,7 @@ ENTRY(do_reipl_asm)
 		st	%r14,.Ldispsw+12-.Lpg0(%r13)
 		lpswe	.Ldispsw-.Lpg0(%r13)
 		.align	8
-.Lclkcmp:	.quad	0x0000000000000000
 .Lall:		.quad	0x00000000ff000000
-.Ldump_pfx:	.quad	dump_prefix_page
-.Lregsave:	.quad	0x0000000000000000
 		.align	16
 /*
  * These addresses have to be 31 bit otherwise

