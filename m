Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab1G0M7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 08:59:20 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:36503 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab1G0M6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 08:58:18 -0400
Message-Id: <20110727125808.516079721@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Wed, 27 Jul 2011 14:55:11 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: vgoyal@redhat.com
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch v2 07/10] s390: Use diagnose 308 for system reset
References: <20110727125504.491183728@linux.vnet.ibm.com>
Content-Disposition: inline; filename=s390-kdump-arch-diag308_reset.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

The diagnose 308 call is the prefered method for clearing all ongoing I/O.
Therefore if it is available we use it instead of doing a manual reset.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/s390/include/asm/ipl.h |    1 +
 arch/s390/kernel/base.S     |   36 ++++++++++++++++++++++++++++++++++++
 arch/s390/kernel/ipl.c      |    6 ++++++
 3 files changed, 43 insertions(+)

--- a/arch/s390/include/asm/ipl.h
+++ b/arch/s390/include/asm/ipl.h
@@ -167,5 +167,6 @@ enum diag308_rc {
 };
 
 extern int diag308(unsigned long subcode, void *addr);
+extern void diag308_reset(void);
 
 #endif /* _ASM_S390_IPL_H */
--- a/arch/s390/kernel/base.S
+++ b/arch/s390/kernel/base.S
@@ -76,6 +76,42 @@ s390_base_pgm_handler_fn:
 	.quad	0
 	.previous
 
+#
+# Calls diag 308 subcode 1 and continues execution
+#
+# The following conditions must be ensured before calling this function:
+# * Prefix register = 0
+# * Lowcore protection is disabled
+#
+ENTRY(diag308_reset)
+	larl	%r4,.Lctlregs		# Save control registers
+	stctg	%c0,%c15,0(%r4)
+	larl	%r4,.Lrestart_psw	# Setup restart PSW at absolute 0
+	lghi	%r3,0
+	lg	%r4,0(%r4)		# Save PSW
+	sturg	%r4,%r3			# Use sturg, because of large pages
+	lghi	%r1,1
+	diag	%r1,%r1,0x308
+.Lrestart_part2:
+	lhi	%r0,0			# Load r0 with zero
+	lhi	%r1,2			# Use mode 2 = ESAME (dump)
+	sigp	%r1,%r0,0x12		# Switch to ESAME mode
+	sam64				# Switch to 64 bit addressing mode
+	larl	%r4,.Lctlregs		# Restore control registers
+	lctlg	%c0,%c15,0(%r4)
+	br	%r14
+.align 16
+.Lrestart_psw:
+	.long	0x00080000,0x80000000 + .Lrestart_part2
+
+	.section .bss
+.align 8
+.Lctlregs:
+	.rept	16
+	.quad	0
+	.endr
+	.previous
+
 #else /* CONFIG_64BIT */
 
 ENTRY(s390_base_mcck_handler)
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1996,6 +1996,12 @@ static void do_reset_calls(void)
 {
 	struct reset_call *reset;
 
+#ifdef CONFIG_64BIT
+	if (diag308_set_works) {
+		diag308_reset();
+		return;
+	}
+#endif
 	list_for_each_entry(reset, &rcall, list)
 		reset->fn();
 }

