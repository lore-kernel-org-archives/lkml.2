Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab1LSO7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 09:59:05 -0500
Received: from service87.mimecast.com ([91.220.42.44]:44248 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab1LSO63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 09:58:29 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [RFC PATCH v2 6/6] ARM: Remove __ARCH_WANT_INTERRUPTS_ON_CTXSW on pre-ARMv6 CPUs
Date: Mon, 19 Dec 2011 14:57:53 +0000
Message-Id: <1324306673-4282-7-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1324306673-4282-1-git-send-email-catalin.marinas@arm.com>
References: <1324306673-4282-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 19 Dec 2011 14:58:10.0855 (UTC) FILETIME=[A010A370:01CCBE5E]
X-MC-Unique: 111121914582402201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pBJEx9qR031003

This patch removes the __ARCH_WANT_INTERRUPTS_ON_CTXSW definition for
ARMv5 and earlier processors. On such processors, the context switch
requires a full cache flush. To avoid high interrupt latencies, this
patch defers the mm switching to the post-lock switch hook if the
interrupts are disabled.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Frank Rowand <frank.rowand@am.sony.com>
---
 arch/arm/include/asm/mmu_context.h |   30 +++++++++++++++++++++++++-----
 arch/arm/include/asm/system.h      |    9 ---------
 2 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/arch/arm/include/asm/mmu_context.h b/arch/arm/include/asm/mmu_context.h
index fd6eeba..4ac7809 100644
--- a/arch/arm/include/asm/mmu_context.h
+++ b/arch/arm/include/asm/mmu_context.h
@@ -104,19 +104,39 @@ static inline void finish_arch_post_lock_switch(void)
 
 #else	/* !CONFIG_CPU_HAS_ASID */
 
+#ifdef CONFIG_MMU
+
 static inline void check_and_switch_context(struct mm_struct *mm,
 					    struct task_struct *tsk)
 {
-#ifdef CONFIG_MMU
 	if (unlikely(mm->context.kvm_seq != init_mm.context.kvm_seq))
 		__check_kvm_seq(mm);
-	cpu_switch_mm(mm->pgd, mm);
-#endif
+
+	if (irqs_disabled())
+		/*
+		 * Defer the cpu_switch_mm() call and continue running with
+		 * the old mm. Since we only support UP systems on non-ASID
+		 * CPUs, the old mm will remain valid until the
+		 * finish_arch_post_lock_switch() call.
+		 */
+		set_ti_thread_flag(task_thread_info(tsk), TIF_SWITCH_MM);
+	else
+		cpu_switch_mm(mm->pgd, mm);
 }
 
-#define init_new_context(tsk,mm)	0
+#define finish_arch_post_lock_switch \
+	finish_arch_post_lock_switch
+static inline void finish_arch_post_lock_switch(void)
+{
+	if (test_and_clear_thread_flag(TIF_SWITCH_MM)) {
+		struct mm_struct *mm = current->mm;
+		cpu_switch_mm(mm->pgd, mm);
+	}
+}
 
-#define finish_arch_post_lock_switch()	do { } while (0)
+#endif	/* CONFIG_MMU */
+
+#define init_new_context(tsk,mm)	0
 
 #endif	/* CONFIG_CPU_HAS_ASID */
 
diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/system.h
index 3daebde..ac7fade 100644
--- a/arch/arm/include/asm/system.h
+++ b/arch/arm/include/asm/system.h
@@ -218,15 +218,6 @@ static inline void set_copro_access(unsigned int val)
 }
 
 /*
- * switch_mm() may do a full cache flush over the context switch,
- * so enable interrupts over the context switch to avoid high
- * latency.
- */
-#ifndef CONFIG_CPU_HAS_ASID
-#define __ARCH_WANT_INTERRUPTS_ON_CTXSW
-#endif
-
-/*
  * switch_to(prev, next) should switch from task `prev' to `next'
  * `prev' will never be the same as `next'.  schedule() itself
  * contains the memory barrier to tell GCC not to cache `current'.

