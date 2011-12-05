Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab1LENTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:19:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57390 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab1LENTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:19:24 -0500
Date: Mon, 5 Dec 2011 05:19:06 -0800
From: tip-bot for Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Message-ID: <tip-55af77969fbd7a841838220ea2287432e0da8ae5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rdunlap@xenotime.net, tglx@linutronix.de, mingo@elte.hu,
        mitsuo.hayasaka.hu@hitachi.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rdunlap@xenotime.net,
        mitsuo.hayasaka.hu@hitachi.com, mingo@elte.hu
In-Reply-To: <20111129060836.11076.12323.stgit@ltc219.sdl.hitachi.co.jp>
References: <20111129060836.11076.12323.stgit@ltc219.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Panic on detection of stack overflow
Git-Commit-ID: 55af77969fbd7a841838220ea2287432e0da8ae5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:19:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55af77969fbd7a841838220ea2287432e0da8ae5
Gitweb:     http://git.kernel.org/tip/55af77969fbd7a841838220ea2287432e0da8ae5
Author:     Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
AuthorDate: Tue, 29 Nov 2011 15:08:36 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 11:37:47 +0100

x86: Panic on detection of stack overflow

Currently, messages are just output on the detection of stack
overflow, which is not sufficient for systems that need a
high reliability. This is because in general the overflow may
corrupt data, and the additional corruption may occur due to
reading them unless systems stop.

This patch adds the sysctl parameter
kernel.panic_on_stackoverflow and causes a panic when detecting
the overflows of kernel, IRQ and exception stacks except user
stack according to the parameter. It is disabled by default.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: http://lkml.kernel.org/r/20111129060836.11076.12323.stgit@ltc219.sdl.hitachi.co.jp
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
index 928a7e9..42552b0 100644
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
index ae27196..f487f25 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -803,6 +803,15 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
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
