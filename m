Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab2CGKys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 05:54:48 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:35698 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab2CGKyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 05:54:46 -0500
Message-ID: <4F573E74.5040504@oss.ntt.co.jp>
Date: Wed, 07 Mar 2012 19:54:44 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Don Zickus <dzickus@redhat.com>, linux-tip-commits@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, mingo@elte.hu,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de, vgoyal@redhat.com
Subject: [PATCH 1/2] boot: ignore early NMIs
References: <CAE9FiQVPnO8-tuPoio0Wxv=8rjdm2tJbBk3+3ystueyYtZn9BA@mail.gmail.com> <20120216172735.GX9751@redhat.com> <CAE9FiQVhbAM9vjx-uFcuc0ndsUp0aez9_TsQHStje5G5iwYbag@mail.gmail.com> <20120216215603.GH9751@redhat.com> <m1y5s2ku36.fsf@fess.ebiederm.org> <m1fwe9bpk2.fsf@fess.ebiederm.org> <20120217195430.GO9751@redhat.com> <m1y5s07rn3.fsf@fess.ebiederm.org> <20120220151419.GU9751@redhat.com> <m1obss39a4.fsf@fess.ebiederm.org> <20120221135934.GF26998@redhat.com> <m1ipip6xe8.fsf@fess.ebiederm.org> <4F573E1C.2060909@oss.ntt.co.jp>
In-Reply-To: <4F573E1C.2060909@oss.ntt.co.jp>
Content-Type: multipart/mixed;
 boundary="------------000801010101070406040206"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000801010101070406040206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------000801010101070406040206
Content-Type: text/x-patch;
 name="ignore-early-nmis.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ignore-early-nmis.patch"

Subject: [PATCH] boot: ignore early NMIs

From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

NMIs very early in the boot process are rarely critical (usually
it just means that there was a spurious bit flip somewhere in the
hardware, or that this is a kdump kernel and we received an NMI
generated in the previous context), so the current behavior of
halting the system when one occurs is probably a bit over the top.

This patch changes the early IDT so that NMIs are ignored and the
kernel can, hopefully, continue executing other code. Harsher
measures (panic, etc) are defered to the final NMI handler, which
can actually make an informed decision.

This issue presented itself in our environment as seemingly
random hangs in kdump.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-3.3-rc6-orig/arch/x86/kernel/head64.c linux-3.3-rc6/arch/x86/kernel/head64.c
--- linux-3.3-rc6-orig/arch/x86/kernel/head64.c	2012-03-07 15:49:01.834241787 +0900
+++ linux-3.3-rc6/arch/x86/kernel/head64.c	2012-03-07 18:39:03.173732875 +0900
@@ -71,7 +71,7 @@ void __init x86_64_start_kernel(char * r
 				(__START_KERNEL & PGDIR_MASK)));
 	BUILD_BUG_ON(__fix_to_virt(__end_of_fixed_addresses) <= MODULES_END);
 
-	/* clear bss before set_intr_gate with early_idt_handler */
+	/* clear bss before set_intr_gate with early_idt_handlers */
 	clear_bss();
 
 	/* Make NULL pointers segfault */
@@ -79,13 +79,8 @@ void __init x86_64_start_kernel(char * r
 
 	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
 
-	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
-#ifdef CONFIG_EARLY_PRINTK
+	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++)
 		set_intr_gate(i, &early_idt_handlers[i]);
-#else
-		set_intr_gate(i, early_idt_handler);
-#endif
-	}
 	load_idt((const struct desc_ptr *)&idt_descr);
 
 	if (console_loglevel == 10)
diff -urNp linux-3.3-rc6-orig/arch/x86/kernel/head_64.S linux-3.3-rc6/arch/x86/kernel/head_64.S
--- linux-3.3-rc6-orig/arch/x86/kernel/head_64.S	2012-03-07 15:49:01.838241839 +0900
+++ linux-3.3-rc6/arch/x86/kernel/head_64.S	2012-03-07 18:41:21.811516876 +0900
@@ -270,18 +270,29 @@ bad_address:
 	jmp bad_address
 
 	.section ".init.text","ax"
-#ifdef CONFIG_EARLY_PRINTK
 	.globl early_idt_handlers
 early_idt_handlers:
-	i = 0
+	vector = 0
 	.rept NUM_EXCEPTION_VECTORS
-	movl $i, %esi
-	jmp early_idt_handler
-	i = i + 1
+	/*
+	 * NMIs (vector 2) this early in the boot process are rarely critical
+	 * (usually it just means that there was a spurious bit flip somewhere
+	 * in the hardware, or that this is a kdump kernel and we received an
+	 * NMI generated in the previous context), so we ignore them here and
+	 * try to continue (see early_nmi_handler implementation below).
+	 * Harsher measures (panic, etc) are defered to the final NMI handler,
+	 * which can actually make an informed decision.
+	 */
+	.if vector == 2
+	jmp early_nmi_handler
+	.else
+	movl $vector, %esi
+	jmp early_exception_handler
+	.endif
+	vector = vector + 1
 	.endr
-#endif
 
-ENTRY(early_idt_handler)
+early_exception_handler:
 #ifdef CONFIG_EARLY_PRINTK
 	cmpl $2,early_recursion_flag(%rip)
 	jz  1f
@@ -315,6 +326,9 @@ ENTRY(early_idt_handler)
 1:	hlt
 	jmp 1b
 
+early_nmi_handler:
+	iretq
+
 #ifdef CONFIG_EARLY_PRINTK
 early_recursion_flag:
 	.long 0

--------------000801010101070406040206--
