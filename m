Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab1K2GDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 01:03:07 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58271 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1K2GDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 01:03:04 -0500
X-AuditID: b753bd60-9785eba00000359c-98-4ed47595f1c3
X-AuditID: b753bd60-9785eba00000359c-98-4ed47595f1c3
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH -v2 3/4] x86: panic on detection of stack overflow
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 29 Nov 2011 15:08:36 +0900
Message-ID: <20111129060836.11076.12323.stgit@ltc219.sdl.hitachi.co.jp>
In-Reply-To: <20111129060806.11076.74583.stgit@ltc219.sdl.hitachi.co.jp>
References: <20111129060806.11076.74583.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, messages are just output on the detection of stack
overflow, which is not sufficient for systems that need a
high reliability. This is because in general the overflow may
corrupt data, and the additional corruption may occur due to
reading them unless systems stop.

This patch adds the sysctl parameter kernel.panic_on_stackoverflow
and causes a panic when detecting the overflows of kernel, IRQ
and exception stacks except user stack according to the parameter.
It is disabled by default.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 Documentation/sysctl/kernel.txt |   14 ++++++++++++++
 arch/x86/kernel/irq_32.c        |    2 ++
 arch/x86/kernel/irq_64.c        |    5 +++++
 include/linux/kernel.h          |    1 +
 kernel/sysctl.c                 |    9 +++++++++
 5 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 1f24636..6d8cd8b 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -49,6 +49,7 @@ show up in /proc/sys/kernel:
 - panic
 - panic_on_oops
 - panic_on_unrecovered_nmi
+- panic_on_stackoverflow
 - pid_max
 - powersave-nap               [ PPC only ]
 - printk
@@ -393,6 +394,19 @@ Controls the kernel's behaviour when an oops or BUG is encountered.
 
 ==============================================================
 
+panic_on_stackoverflow:
+
+Controls the kernel's behavior when detecting the overflows of
+kernel, IRQ and exception stacks except a user stack.
+This file shows up if CONFIG_DEBUG_STACKOVERFLOW is enabled.
+
+0: try to continue operation.
+
+1: panic immediately.
+
+==============================================================
+
+
 pid_max:
 
 PID allocation wrap value.  When the kernel's next PID value
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 7209070..e16e99eb 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -43,6 +43,8 @@ static void print_stack_overflow(void)
 {
 	printk(KERN_WARNING "low stack detected by irq handler\n");
 	dump_stack();
+	if (sysctl_panic_on_stackoverflow)
+		panic("low stack detected by irq handler - check messages\n");
 }
 
 #else
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 11ae893..5448bf6 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -26,6 +26,8 @@ EXPORT_PER_CPU_SYMBOL(irq_stat);
 DEFINE_PER_CPU(struct pt_regs *, irq_regs);
 EXPORT_PER_CPU_SYMBOL(irq_regs);
 
+int sysctl_panic_on_stackoverflow;
+
 /*
  * Probabilistic stack overflow check:
  *
@@ -65,6 +67,9 @@ static inline void stack_overflow_check(struct pt_regs *regs)
 		current->comm, curbase, regs->sp,
 		irq_stack_top, irq_stack_bottom,
 		estack_top, estack_bottom);
+
+	if (sysctl_panic_on_stackoverflow)
+		panic("low stack detected by irq handler - check messages\n");
 #endif
 }
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e8b1597..ff83683 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -341,6 +341,7 @@ extern int panic_timeout;
 extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
 extern int panic_on_io_nmi;
+extern int sysctl_panic_on_stackoverflow;
 extern const char *print_tainted(void);
 extern void add_taint(unsigned flag);
 extern int test_taint(unsigned flag);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ae27196..99a3815 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -803,6 +803,15 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#if defined(CONFIG_DEBUG_STACKOVERFLOW)
+	{
+		.procname	= "panic_on_stackoverflow",
+		.data		= &sysctl_panic_on_stackoverflow,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
 	{
 		.procname	= "bootloader_type",
 		.data		= &bootloader_type,

