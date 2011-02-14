Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab1BNSHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:07:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:45644 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab1BNSHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:07:40 -0500
Date: Mon, 14 Feb 2011 13:52:44 GMT
From: tip-bot for Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        eric.dumazet@gmail.com, andi@firstfloor.org, shaohua.li@intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, eric.dumazet@gmail.com, tglx@linutronix.de,
        shaohua.li@intel.com, mingo@elte.hu
In-Reply-To: <1295232722.1949.707.camel@sli10-conroe>
References: <1295232722.1949.707.camel@sli10-conroe>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Cleanup vector usage
Message-ID: <tip-60f6e65d7887c257392313755f95540ef5e7ea89@git.kernel.org>
Git-Commit-ID: 60f6e65d7887c257392313755f95540ef5e7ea89
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Feb 2011 18:06:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60f6e65d7887c257392313755f95540ef5e7ea89
Gitweb:     http://git.kernel.org/tip/60f6e65d7887c257392313755f95540ef5e7ea89
Author:     Shaohua Li <shaohua.li@intel.com>
AuthorDate: Mon, 17 Jan 2011 10:52:02 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Feb 2011 13:03:07 +0100

x86: Cleanup vector usage

Cleanup the vector usage and make them continuous if possible.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
LKML-Reference: <1295232722.1949.707.camel@sli10-conroe>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/irq_vectors.h |   40 ++++++++++++++++++-----------------
 1 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 6af0894..42f0d4a 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_X86_IRQ_VECTORS_H
 #define _ASM_X86_IRQ_VECTORS_H
 
+#include <linux/threads.h>
 /*
  * Linux IRQ vector layout.
  *
@@ -16,8 +17,8 @@
  *  Vectors   0 ...  31 : system traps and exceptions - hardcoded events
  *  Vectors  32 ... 127 : device interrupts
  *  Vector  128         : legacy int80 syscall interface
- *  Vectors 129 ... 237 : device interrupts
- *  Vectors 238 ... 255 : special interrupts
+ *  Vectors 129 ... 229 : device interrupts
+ *  Vectors 230 ... 255 : special interrupts
  *
  * 64-bit x86 has per CPU IDT tables, 32-bit has one shared IDT table.
  *
@@ -96,37 +97,38 @@
 #define THRESHOLD_APIC_VECTOR		0xf9
 #define REBOOT_VECTOR			0xf8
 
-/* f0-f7 used for spreading out TLB flushes: */
-#define INVALIDATE_TLB_VECTOR_END	0xf7
-#define INVALIDATE_TLB_VECTOR_START	0xf0
-#define NUM_INVALIDATE_TLB_VECTORS	   8
-
-/*
- * Local APIC timer IRQ vector is on a different priority level,
- * to work around the 'lost local interrupt if more than 2 IRQ
- * sources per level' errata.
- */
-#define LOCAL_TIMER_VECTOR		0xef
-
 /*
  * Generic system vector for platform specific use
  */
-#define X86_PLATFORM_IPI_VECTOR		0xed
+#define X86_PLATFORM_IPI_VECTOR		0xf7
 
 /*
  * IRQ work vector:
  */
-#define IRQ_WORK_VECTOR			0xec
+#define IRQ_WORK_VECTOR			0xf6
 
-#define UV_BAU_MESSAGE			0xea
+#define UV_BAU_MESSAGE			0xf5
 
 /*
  * Self IPI vector for machine checks
  */
-#define MCE_SELF_VECTOR			0xeb
+#define MCE_SELF_VECTOR			0xf4
 
 /* Xen vector callback to receive events in a HVM domain */
-#define XEN_HVM_EVTCHN_CALLBACK		0xe9
+#define XEN_HVM_EVTCHN_CALLBACK		0xf3
+
+/*
+ * Local APIC timer IRQ vector is on a different priority level,
+ * to work around the 'lost local interrupt if more than 2 IRQ
+ * sources per level' errata.
+ */
+#define LOCAL_TIMER_VECTOR		0xef
+
+/* f0-f7 used for spreading out TLB flushes: */
+#define NUM_INVALIDATE_TLB_VECTORS	   8
+#define INVALIDATE_TLB_VECTOR_END	0xee
+#define INVALIDATE_TLB_VECTOR_START	\
+	(INVALIDATE_TLB_VECTOR_END - NUM_INVALIDATE_TLB_VECTORS + 1)
 
 #define NR_VECTORS			 256
 
