Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab2CGK4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 05:56:51 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:35789 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2CGK4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 05:56:50 -0500
Message-ID: <4F573EF0.1080501@oss.ntt.co.jp>
Date: Wed, 07 Mar 2012 19:56:48 +0900
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
Subject: [PATCH 2/2] boot: add early NMI counter
References: <CAE9FiQVPnO8-tuPoio0Wxv=8rjdm2tJbBk3+3ystueyYtZn9BA@mail.gmail.com> <20120216172735.GX9751@redhat.com> <CAE9FiQVhbAM9vjx-uFcuc0ndsUp0aez9_TsQHStje5G5iwYbag@mail.gmail.com> <20120216215603.GH9751@redhat.com> <m1y5s2ku36.fsf@fess.ebiederm.org> <m1fwe9bpk2.fsf@fess.ebiederm.org> <20120217195430.GO9751@redhat.com> <m1y5s07rn3.fsf@fess.ebiederm.org> <20120220151419.GU9751@redhat.com> <m1obss39a4.fsf@fess.ebiederm.org> <20120221135934.GF26998@redhat.com> <m1ipip6xe8.fsf@fess.ebiederm.org> <4F573E1C.2060909@oss.ntt.co.jp> <4F573E74.5040504@oss.ntt.co.jp>
In-Reply-To: <4F573E74.5040504@oss.ntt.co.jp>
Content-Type: multipart/mixed;
 boundary="------------000002060200070305050706"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000002060200070305050706
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------000002060200070305050706
Content-Type: text/x-patch;
 name="add-early-nmi-counter.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="add-early-nmi-counter.patch"

Subject: [PATCH] boot: add early NMI counter

From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

We currently ignore early NMIs but it would be nice to be able to
know whether they actually occurred.

This patch adds an early NMI counter and exports it trough
/proc/interrupts with the name of ENM (Early NMI).

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-3.3-rc6-orig/arch/x86/include/asm/processor.h linux-3.3-rc6/arch/x86/include/asm/processor.h
--- linux-3.3-rc6-orig/arch/x86/include/asm/processor.h	2012-03-07 15:49:01.826241682 +0900
+++ linux-3.3-rc6/arch/x86/include/asm/processor.h	2012-03-07 18:52:27.668054122 +0900
@@ -402,6 +402,7 @@ DECLARE_PER_CPU(char *, irq_stack_ptr);
 DECLARE_PER_CPU(unsigned int, irq_count);
 extern unsigned long kernel_eflags;
 extern asmlinkage void ignore_sysret(void);
+extern unsigned int early_nmi_count;
 #else	/* X86_64 */
 #ifdef CONFIG_CC_STACKPROTECTOR
 /*
diff -urNp linux-3.3-rc6-orig/arch/x86/kernel/head_64.S linux-3.3-rc6/arch/x86/kernel/head_64.S
--- linux-3.3-rc6-orig/arch/x86/kernel/head_64.S	2012-03-07 18:51:17.583160114 +0900
+++ linux-3.3-rc6/arch/x86/kernel/head_64.S	2012-03-07 18:54:37.205699422 +0900
@@ -327,6 +327,7 @@ early_exception_handler:
 	jmp 1b
 
 early_nmi_handler:
+	incl early_nmi_count(%rip) # exported as ENM in /proc/interrupts
 	iretq
 
 #ifdef CONFIG_EARLY_PRINTK
@@ -340,6 +341,10 @@ early_idt_ripmsg:
 #endif /* CONFIG_EARLY_PRINTK */
 	.previous
 
+	.globl early_nmi_count
+early_nmi_count:
+	.long 0
+
 #define NEXT_PAGE(name) \
 	.balign	PAGE_SIZE; \
 ENTRY(name)
diff -urNp linux-3.3-rc6-orig/arch/x86/kernel/irq.c linux-3.3-rc6/arch/x86/kernel/irq.c
--- linux-3.3-rc6-orig/arch/x86/kernel/irq.c	2012-03-07 15:49:01.838241839 +0900
+++ linux-3.3-rc6/arch/x86/kernel/irq.c	2012-03-07 18:55:14.078179448 +0900
@@ -125,6 +125,7 @@ int arch_show_interrupts(struct seq_file
 #if defined(CONFIG_X86_IO_APIC)
 	seq_printf(p, "%*s: %10u\n", prec, "MIS", atomic_read(&irq_mis_count));
 #endif
+	seq_printf(p, "%*s: %10u\n", prec, "ENM", early_nmi_count);
 	return 0;
 }
 

--------------000002060200070305050706--
