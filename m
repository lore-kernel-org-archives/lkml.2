Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab1F1Ctw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 22:49:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36107 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab1F1CsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 22:48:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=vJbHibTRazww0ClD5oLLp2IhVVA1C7v++cKuXDglXpBc9x5GRZP9yWLlNRxQ1Ajza
	u6vzOm+eYwXIeTuF0mFZg==
From: Todd Poynor <toddpoynor@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Todd Poynor <toddpoynor@google.com>
Subject: [PATCH 1/3] Move x86_64 idle notifiers to generic
Date: Mon, 27 Jun 2011 19:46:28 -0700
Message-Id: <1309229190-25006-2-git-send-email-toddpoynor@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1309229190-25006-1-git-send-email-toddpoynor@google.com>
References: <1309229190-25006-1-git-send-email-toddpoynor@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the x86_64 idle notifiers originally by Andi Kleen and Venkatesh
Pallipadi to generic.

Change-Id: Idf29cda15be151f494ff245933c12462643388d5
Signed-off-by: Todd Poynor <toddpoynor@google.com>
---
 arch/x86/include/asm/idle.h  |    7 -------
 arch/x86/kernel/process_64.c |   18 ++----------------
 include/linux/cpu.h          |    7 +++++++
 kernel/cpu.c                 |   20 ++++++++++++++++++++
 4 files changed, 29 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/idle.h b/arch/x86/include/asm/idle.h
index f49253d7..f1e4268 100644
--- a/arch/x86/include/asm/idle.h
+++ b/arch/x86/include/asm/idle.h
@@ -1,13 +1,6 @@
 #ifndef _ASM_X86_IDLE_H
 #define _ASM_X86_IDLE_H
 
-#define IDLE_START 1
-#define IDLE_END 2
-
-struct notifier_block;
-void idle_notifier_register(struct notifier_block *n);
-void idle_notifier_unregister(struct notifier_block *n);
-
 #ifdef CONFIG_X86_64
 void enter_idle(void);
 void exit_idle(void);
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ca6f7ab..63c8aed 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -56,31 +56,17 @@ asmlinkage extern void ret_from_fork(void);
 DEFINE_PER_CPU(unsigned long, old_rsp);
 static DEFINE_PER_CPU(unsigned char, is_idle);
 
-static ATOMIC_NOTIFIER_HEAD(idle_notifier);
-
-void idle_notifier_register(struct notifier_block *n)
-{
-	atomic_notifier_chain_register(&idle_notifier, n);
-}
-EXPORT_SYMBOL_GPL(idle_notifier_register);
-
-void idle_notifier_unregister(struct notifier_block *n)
-{
-	atomic_notifier_chain_unregister(&idle_notifier, n);
-}
-EXPORT_SYMBOL_GPL(idle_notifier_unregister);
-
 void enter_idle(void)
 {
 	percpu_write(is_idle, 1);
-	atomic_notifier_call_chain(&idle_notifier, IDLE_START, NULL);
+	idle_notifier_call_chain(IDLE_START);
 }
 
 static void __exit_idle(void)
 {
 	if (x86_test_and_clear_bit_percpu(0, is_idle) == 0)
 		return;
-	atomic_notifier_call_chain(&idle_notifier, IDLE_END, NULL);
+	idle_notifier_call_chain(IDLE_END);
 }
 
 /* Called from interrupts to signify idle end */
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 5f09323..97f1ca7 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -174,4 +174,11 @@ static inline int disable_nonboot_cpus(void) { return 0; }
 static inline void enable_nonboot_cpus(void) {}
 #endif /* !CONFIG_PM_SLEEP_SMP */
 
+#define IDLE_START 1
+#define IDLE_END 2
+
+void idle_notifier_register(struct notifier_block *n);
+void idle_notifier_unregister(struct notifier_block *n);
+void idle_notifier_call_chain(unsigned long val);
+
 #endif /* _LINUX_CPU_H_ */
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 12b7458..4047707 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -594,3 +594,23 @@ void init_cpu_online(const struct cpumask *src)
 {
 	cpumask_copy(to_cpumask(cpu_online_bits), src);
 }
+
+static ATOMIC_NOTIFIER_HEAD(idle_notifier);
+
+void idle_notifier_register(struct notifier_block *n)
+{
+	atomic_notifier_chain_register(&idle_notifier, n);
+}
+EXPORT_SYMBOL_GPL(idle_notifier_register);
+
+void idle_notifier_unregister(struct notifier_block *n)
+{
+	atomic_notifier_chain_unregister(&idle_notifier, n);
+}
+EXPORT_SYMBOL_GPL(idle_notifier_unregister);
+
+void idle_notifier_call_chain(unsigned long val)
+{
+	atomic_notifier_call_chain(&idle_notifier, val, NULL);
+}
+EXPORT_SYMBOL_GPL(idle_notifier_call_chain);
-- 
1.7.3.1

