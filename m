Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab2CIKBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 05:01:54 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:52135 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab2CIKBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 05:01:53 -0500
Message-ID: <4F59D510.8020400@oss.ntt.co.jp>
Date: Fri, 09 Mar 2012 19:01:52 +0900
From: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Don Zickus <dzickus@redhat.com>, akpm@linux-foundation.org,
        linux-tip-commits@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, mingo@elte.hu, vgoyal@redhat.com
Subject: [PATCH 3/3] boot: add early NMI counter
References: <CAE9FiQVPnO8-tuPoio0Wxv=8rjdm2tJbBk3+3ystueyYtZn9BA@mail.gmail.com> <20120216172735.GX9751@redhat.com> <CAE9FiQVhbAM9vjx-uFcuc0ndsUp0aez9_TsQHStje5G5iwYbag@mail.gmail.com> <20120216215603.GH9751@redhat.com> <m1y5s2ku36.fsf@fess.ebiederm.org> <m1fwe9bpk2.fsf@fess.ebiederm.org> <20120217195430.GO9751@redhat.com> <m1y5s07rn3.fsf@fess.ebiederm.org> <20120220151419.GU9751@redhat.com> <m1obss39a4.fsf@fess.ebiederm.org> <20120221135934.GF26998@redhat.com> <m1ipip6xe8.fsf@fess.ebiederm.org> <4F573E1C.2060909@oss.ntt.co.jp> <4F573E74.5040504@oss.ntt.co.jp> <m1eht31z8e.fsf@fess.ebiederm.org> <4F58495B.5080308@oss.ntt.co.jp> <m1r4x3yrsv.fsf@fess.ebiederm.org> <4F59CDE5.8010400@oss.ntt.co.jp> <4F59D2AE.1020509@oss.ntt.co.jp> <4F59D380.6040404@oss.ntt.co.jp>
In-Reply-To: <4F59D380.6040404@oss.ntt.co.jp>
Content-Type: multipart/mixed;
 boundary="------------010706040304060904030708"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010706040304060904030708
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



--------------010706040304060904030708
Content-Type: text/x-patch;
 name="add-early-nmi-counter.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="add-early-nmi-counter.patch"

Subject: [PATCH 3/3] boot: add early NMI counter

From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

We currently ignore early NMIs but it would be nice to be able to
know whether they actually occurred.

This patch adds an early NMI counter, whose count is moved over to
the per-cpu NMI counter before the kernel frees the init sections.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-3.3-rc6-orig/arch/x86/include/asm/processor.h linux-3.3-rc6/arch/x86/include/asm/processor.h
--- linux-3.3-rc6-orig/arch/x86/include/asm/processor.h	2012-03-09 17:48:04.547492663 +0900
+++ linux-3.3-rc6/arch/x86/include/asm/processor.h	2012-03-09 18:37:32.060194673 +0900
@@ -402,6 +402,11 @@ DECLARE_PER_CPU(char *, irq_stack_ptr);
 DECLARE_PER_CPU(unsigned int, irq_count);
 extern unsigned long kernel_eflags;
 extern asmlinkage void ignore_sysret(void);
+/*
+ * early_nmi_count is in the .init.text ELF section so it can only be accessed
+ * before the init sections are freed by the kernel.
+ */
+extern unsigned int early_nmi_count;
 #else	/* X86_64 */
 #ifdef CONFIG_CC_STACKPROTECTOR
 /*
diff -urNp linux-3.3-rc6-orig/arch/x86/kernel/head_64.S linux-3.3-rc6/arch/x86/kernel/head_64.S
--- linux-3.3-rc6-orig/arch/x86/kernel/head_64.S	2012-03-09 18:36:18.051281524 +0900
+++ linux-3.3-rc6/arch/x86/kernel/head_64.S	2012-03-09 18:38:47.673129036 +0900
@@ -340,6 +340,7 @@ early_exception_handler:
 	jmp 1b
 
 early_nmi_handler:
+	incl early_nmi_count(%rip)
 	iretq
 
 #ifdef CONFIG_EARLY_PRINTK
@@ -351,6 +352,9 @@ early_idt_msg:
 early_idt_ripmsg:
 	.asciz "RIP %s\n"
 #endif /* CONFIG_EARLY_PRINTK */
+	.globl early_nmi_count
+early_nmi_count:
+	.long 0
 	.previous
 
 #define NEXT_PAGE(name) \
diff -urNp linux-3.3-rc6-orig/arch/x86/kernel/traps.c linux-3.3-rc6/arch/x86/kernel/traps.c
--- linux-3.3-rc6-orig/arch/x86/kernel/traps.c	2012-03-09 17:48:04.567492912 +0900
+++ linux-3.3-rc6/arch/x86/kernel/traps.c	2012-03-09 18:39:23.665574123 +0900
@@ -719,6 +719,7 @@ void __init trap_init(void)
 	x86_init.irqs.trap_init();
 
 #ifdef CONFIG_X86_64
+	percpu_add(irq_stat.__nmi_count, early_nmi_count);
 	memcpy(&nmi_idt_table, &idt_table, IDT_ENTRIES * 16);
 	set_nmi_gate(1, &debug);
 	set_nmi_gate(3, &int3);

--------------010706040304060904030708--
