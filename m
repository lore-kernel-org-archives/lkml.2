Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab1CCF11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 00:27:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:11699 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab1CCF10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 00:27:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,257,1297065600"; 
   d="scan'208";a="663310283"
Subject: Re: [tip:x86/mm] x86: Work around old gas bug
From: Shaohua Li <shaohua.li@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Beulich <JBeulich@novell.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
In-Reply-To: <20110302082453.934f2033.akpm@linux-foundation.org>
References: <201103012352.p21NqRN1006974@imap1.linux-foundation.org>
	 <tip-253d89d3dd6b65595f317e5f1ecef43aa207a3a0@git.kernel.org>
	 <4D6E2B8B02000078000347C0@vpn.id2.novell.com>
	 <20110302104144.GB25608@elte.hu>
	 <20110302082453.934f2033.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 13:27:05 +0800
Message-ID: <1299130025.19589.89.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-03 at 00:24 +0800, Andrew Morton wrote:
> On Wed, 2 Mar 2011 11:41:44 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Meanwhile, what i hate more than ugly code repetition is code that does not build at 
> > all on akpm's test environment ;-)
> 
> I hadn't got around to testing it.  Bad news :(
> 
Andrew,
can you this on your side? this is what Jan proposed. I can only test a
latest binutils here.

Thanks,
Shaohua

---
 arch/x86/include/asm/entry_arch.h |   13 ++++---
 arch/x86/include/asm/hw_irq.h     |   44 ++++++++++++-------------
 arch/x86/kernel/entry_64.S        |   13 ++++---
 arch/x86/kernel/irqinit.c         |   66 +++++++++++++++++++-------------------
 4 files changed, 69 insertions(+), 67 deletions(-)

Index: linux/arch/x86/include/asm/entry_arch.h
===================================================================
--- linux.orig/arch/x86/include/asm/entry_arch.h	2011-03-03 11:24:15.000000000 +0800
+++ linux/arch/x86/include/asm/entry_arch.h	2011-03-03 11:29:01.000000000 +0800
@@ -16,13 +16,14 @@ BUILD_INTERRUPT(call_function_single_int
 BUILD_INTERRUPT(irq_move_cleanup_interrupt,IRQ_MOVE_CLEANUP_VECTOR)
 BUILD_INTERRUPT(reboot_interrupt,REBOOT_VECTOR)
 
-.irp idx,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, \
-	16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
-.if NUM_INVALIDATE_TLB_VECTORS > \idx
-BUILD_INTERRUPT3(invalidate_interrupt\idx,
-		 (INVALIDATE_TLB_VECTOR_START)+\idx,
+.irpc maj, "01"
+  .irpc min, "0123456789abcdef"
+    .if NUM_INVALIDATE_TLB_VECTORS > 0x\maj\min
+BUILD_INTERRUPT3(invalidate_interrupt\maj\min,
+		 (INVALIDATE_TLB_VECTOR_START)+0x\maj\min,
 		 smp_invalidate_interrupt)
-.endif
+    .endif
+  .endr
 .endr
 #endif
 
Index: linux/arch/x86/kernel/entry_64.S
===================================================================
--- linux.orig/arch/x86/kernel/entry_64.S	2011-03-03 11:23:57.000000000 +0800
+++ linux/arch/x86/kernel/entry_64.S	2011-03-03 11:29:04.000000000 +0800
@@ -975,12 +975,13 @@ apicinterrupt X86_PLATFORM_IPI_VECTOR \
 	x86_platform_ipi smp_x86_platform_ipi
 
 #ifdef CONFIG_SMP
-.irp idx,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, \
-	16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
-.if NUM_INVALIDATE_TLB_VECTORS > \idx
-apicinterrupt (INVALIDATE_TLB_VECTOR_START)+\idx \
-	invalidate_interrupt\idx smp_invalidate_interrupt
-.endif
+.irpc maj, "01"
+  .irpc min, "0123456789abcdef"
+    .if NUM_INVALIDATE_TLB_VECTORS > 0x\maj\min
+	apicinterrupt (INVALIDATE_TLB_VECTOR_START)+0x\maj\min \
+		invalidate_interrupt\maj\min smp_invalidate_interrupt
+    .endif
+  .endr
 .endr
 #endif
 
Index: linux/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux.orig/arch/x86/include/asm/hw_irq.h	2011-03-03 11:29:42.000000000 +0800
+++ linux/arch/x86/include/asm/hw_irq.h	2011-03-03 11:31:37.000000000 +0800
@@ -37,16 +37,22 @@ extern void reschedule_interrupt(void);
 extern void mce_self_interrupt(void);
 
 extern void invalidate_interrupt(void);
-extern void invalidate_interrupt0(void);
-extern void invalidate_interrupt1(void);
-extern void invalidate_interrupt2(void);
-extern void invalidate_interrupt3(void);
-extern void invalidate_interrupt4(void);
-extern void invalidate_interrupt5(void);
-extern void invalidate_interrupt6(void);
-extern void invalidate_interrupt7(void);
-extern void invalidate_interrupt8(void);
-extern void invalidate_interrupt9(void);
+extern void invalidate_interrupt00(void);
+extern void invalidate_interrupt01(void);
+extern void invalidate_interrupt02(void);
+extern void invalidate_interrupt03(void);
+extern void invalidate_interrupt04(void);
+extern void invalidate_interrupt05(void);
+extern void invalidate_interrupt06(void);
+extern void invalidate_interrupt07(void);
+extern void invalidate_interrupt08(void);
+extern void invalidate_interrupt09(void);
+extern void invalidate_interrupt0a(void);
+extern void invalidate_interrupt0b(void);
+extern void invalidate_interrupt0c(void);
+extern void invalidate_interrupt0d(void);
+extern void invalidate_interrupt0e(void);
+extern void invalidate_interrupt0f(void);
 extern void invalidate_interrupt10(void);
 extern void invalidate_interrupt11(void);
 extern void invalidate_interrupt12(void);
@@ -57,18 +63,12 @@ extern void invalidate_interrupt16(void)
 extern void invalidate_interrupt17(void);
 extern void invalidate_interrupt18(void);
 extern void invalidate_interrupt19(void);
-extern void invalidate_interrupt20(void);
-extern void invalidate_interrupt21(void);
-extern void invalidate_interrupt22(void);
-extern void invalidate_interrupt23(void);
-extern void invalidate_interrupt24(void);
-extern void invalidate_interrupt25(void);
-extern void invalidate_interrupt26(void);
-extern void invalidate_interrupt27(void);
-extern void invalidate_interrupt28(void);
-extern void invalidate_interrupt29(void);
-extern void invalidate_interrupt30(void);
-extern void invalidate_interrupt31(void);
+extern void invalidate_interrupt1a(void);
+extern void invalidate_interrupt1b(void);
+extern void invalidate_interrupt1c(void);
+extern void invalidate_interrupt1d(void);
+extern void invalidate_interrupt1e(void);
+extern void invalidate_interrupt1f(void);
 
 extern void irq_move_cleanup_interrupt(void);
 extern void reboot_interrupt(void);
Index: linux/arch/x86/kernel/irqinit.c
===================================================================
--- linux.orig/arch/x86/kernel/irqinit.c	2011-03-03 11:32:04.000000000 +0800
+++ linux/arch/x86/kernel/irqinit.c	2011-03-03 11:39:48.000000000 +0800
@@ -165,74 +165,74 @@ static void __init smp_intr_init(void)
 
 	/* IPIs for invalidation */
 #define ALLOC_INVTLB_VEC(NR) \
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+NR, \
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+0x##NR, \
 		invalidate_interrupt##NR)
 
 	switch (NUM_INVALIDATE_TLB_VECTORS) {
 	default:
-		ALLOC_INVTLB_VEC(31);
+		ALLOC_INVTLB_VEC(1f);
 	case 31:
-		ALLOC_INVTLB_VEC(30);
+		ALLOC_INVTLB_VEC(1e);
 	case 30:
-		ALLOC_INVTLB_VEC(29);
+		ALLOC_INVTLB_VEC(1d);
 	case 29:
-		ALLOC_INVTLB_VEC(28);
+		ALLOC_INVTLB_VEC(1c);
 	case 28:
-		ALLOC_INVTLB_VEC(27);
+		ALLOC_INVTLB_VEC(1b);
 	case 27:
-		ALLOC_INVTLB_VEC(26);
+		ALLOC_INVTLB_VEC(1a);
 	case 26:
-		ALLOC_INVTLB_VEC(25);
+		ALLOC_INVTLB_VEC(19);
 	case 25:
-		ALLOC_INVTLB_VEC(24);
+		ALLOC_INVTLB_VEC(18);
 	case 24:
-		ALLOC_INVTLB_VEC(23);
+		ALLOC_INVTLB_VEC(17);
 	case 23:
-		ALLOC_INVTLB_VEC(22);
+		ALLOC_INVTLB_VEC(16);
 	case 22:
-		ALLOC_INVTLB_VEC(21);
+		ALLOC_INVTLB_VEC(15);
 	case 21:
-		ALLOC_INVTLB_VEC(20);
+		ALLOC_INVTLB_VEC(14);
 	case 20:
-		ALLOC_INVTLB_VEC(19);
+		ALLOC_INVTLB_VEC(13);
 	case 19:
-		ALLOC_INVTLB_VEC(18);
+		ALLOC_INVTLB_VEC(12);
 	case 18:
-		ALLOC_INVTLB_VEC(17);
+		ALLOC_INVTLB_VEC(11);
 	case 17:
-		ALLOC_INVTLB_VEC(16);
+		ALLOC_INVTLB_VEC(10);
 	case 16:
-		ALLOC_INVTLB_VEC(15);
+		ALLOC_INVTLB_VEC(0f);
 	case 15:
-		ALLOC_INVTLB_VEC(14);
+		ALLOC_INVTLB_VEC(0e);
 	case 14:
-		ALLOC_INVTLB_VEC(13);
+		ALLOC_INVTLB_VEC(0d);
 	case 13:
-		ALLOC_INVTLB_VEC(12);
+		ALLOC_INVTLB_VEC(0c);
 	case 12:
-		ALLOC_INVTLB_VEC(11);
+		ALLOC_INVTLB_VEC(0b);
 	case 11:
-		ALLOC_INVTLB_VEC(10);
+		ALLOC_INVTLB_VEC(0a);
 	case 10:
-		ALLOC_INVTLB_VEC(9);
+		ALLOC_INVTLB_VEC(09);
 	case 9:
-		ALLOC_INVTLB_VEC(8);
+		ALLOC_INVTLB_VEC(08);
 	case 8:
-		ALLOC_INVTLB_VEC(7);
+		ALLOC_INVTLB_VEC(07);
 	case 7:
-		ALLOC_INVTLB_VEC(6);
+		ALLOC_INVTLB_VEC(06);
 	case 6:
-		ALLOC_INVTLB_VEC(5);
+		ALLOC_INVTLB_VEC(05);
 	case 5:
-		ALLOC_INVTLB_VEC(4);
+		ALLOC_INVTLB_VEC(04);
 	case 4:
-		ALLOC_INVTLB_VEC(3);
+		ALLOC_INVTLB_VEC(03);
 	case 3:
-		ALLOC_INVTLB_VEC(2);
+		ALLOC_INVTLB_VEC(02);
 	case 2:
-		ALLOC_INVTLB_VEC(1);
+		ALLOC_INVTLB_VEC(01);
 	case 1:
-		ALLOC_INVTLB_VEC(0);
+		ALLOC_INVTLB_VEC(00);
 		break;
 	}
 


