Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab0FOK7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 06:59:14 -0400
Received: from www.tglx.de ([62.245.132.106]:43494 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab0FOK7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 06:59:13 -0400
Date: Tue, 15 Jun 2010 12:58:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Len Brown <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Xiaotian Feng <dfeng@redhat.com>, Wu Fengguang <wfg@linux.intel.com>
Subject: acpi: Fix bogus preemption logic
Message-ID: <alpine.LFD.2.00.1006151252250.4290@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI_PREEMPTION_POINT() logic was introduced in commit 8bd108d
(ACPICA: add preemption point after each opcode parse). The follow up
commits abe1dfab6, 138d15692, c084ca70 tried to fix the preemption
logic back and forth, but nobody noticed that the usage of
in_atomic_preempt_off() in that context is wrong.

The check which guards the call of cond_resched() is:

    if (!in_atomic_preempt_off() && !irqs_disabled())

in_atomic_preempt_off() is not intended for general use as the comment
above the macro definition clearly says:

 * Check whether we were atomic before we did preempt_disable():
 * (used by the scheduler, *after* releasing the kernel lock)

On a CONFIG_PREEMPT=n kernel the usage of in_atomic_preempt_off()
works by accident, but with CONFIG_PREEMPT=y it's just broken.

The whole purpose of the ACPI_PREEMPTION_POINT() is to reduce the
latency on a CONFIG_PREEMPT=n kernel, so make ACPI_PREEMPTION_POINT()
depend on CONFIG_PREEMPT=n and remove the in_atomic_preempt_off()
check.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/acpi/platform/aclinux.h |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6/include/acpi/platform/aclinux.h
===================================================================
--- linux-2.6.orig/include/acpi/platform/aclinux.h
+++ linux-2.6/include/acpi/platform/aclinux.h
@@ -148,13 +148,17 @@ static inline void *acpi_os_acquire_obje
 #define ACPI_ALLOCATE_ZEROED(a) acpi_os_allocate_zeroed(a)
 #define ACPI_FREE(a)            kfree(a)
 
-/* Used within ACPICA to show where it is safe to preempt execution */
-#include <linux/hardirq.h>
+#ifndef CONFIG_PREEMPT
+/*
+ * Used within ACPICA to show where it is safe to preempt execution
+ * when CONFIG_PREEMPT=n
+ */
 #define ACPI_PREEMPTION_POINT() \
 	do { \
-		if (!in_atomic_preempt_off() && !irqs_disabled()) \
+		if (!irqs_disabled()) \
 			cond_resched(); \
 	} while (0)
+#endif
 
 #endif /* __KERNEL__ */
 
