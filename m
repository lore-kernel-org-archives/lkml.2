Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1K2LDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:03:50 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:5689 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab1K2LDt convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 29 Nov 2011 06:03:49 -0500
Message-Id: <4ED4CA230200007800064065@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 29 Nov 2011 11:03:46 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: reduce amount of redundant code generated for
 invalidate_interruptNN
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously these up to 32 entry points, consisting of all the same code
except for their very first instruction, consumed 0x70 bytes per
instance. Just like for device interrupt entry points, fold them
together so that they all use a single instance of the code after having
pushed their vector indicator (resulting in 0x10 bytes per instance, to
retain 16-byte alignment of the individual entry points).

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/kernel/entry_64.S |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- 3.2-rc3/arch/x86/kernel/entry_64.S
+++ 3.2-rc3-x86_64-entry-invalidate-intr/arch/x86/kernel/entry_64.S
@@ -953,6 +953,7 @@ END(common_interrupt)
 ENTRY(\sym)
 	INTR_FRAME
 	pushq_cfi $~(\num)
+.Lcommon_\sym:
 	interrupt \do_sym
 	jmp ret_from_intr
 	CFI_ENDPROC
@@ -976,13 +977,21 @@ apicinterrupt X86_PLATFORM_IPI_VECTOR \
 	x86_platform_ipi smp_x86_platform_ipi
 
 #ifdef CONFIG_SMP
-.irp idx,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, \
+	ALIGN
+	INTR_FRAME
+.irp idx,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, \
 	16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
 .if NUM_INVALIDATE_TLB_VECTORS > \idx
-apicinterrupt (INVALIDATE_TLB_VECTOR_START)+\idx \
-	invalidate_interrupt\idx smp_invalidate_interrupt
+ENTRY(invalidate_interrupt\idx)
+	pushq_cfi $~(INVALIDATE_TLB_VECTOR_START+\idx)
+	jmp .Lcommon_invalidate_interrupt0
+	CFI_ADJUST_CFA_OFFSET -8
+END(invalidate_interrupt\idx)
 .endif
 .endr
+	CFI_ENDPROC
+apicinterrupt INVALIDATE_TLB_VECTOR_START, \
+	invalidate_interrupt0, smp_invalidate_interrupt
 #endif
 
 apicinterrupt THRESHOLD_APIC_VECTOR \



