Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741Ab1EUADC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:03:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:33151 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028Ab1EUACL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:02:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,244,1304319600"; 
   d="scan'208";a="1807301"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, airlied@linux.ie,
        Andi Kleen <ak@linux.intel.com>, x86@kernel.org
Subject: [PATCH 10/12] X86: Move alloc_intr_gate out of line
Date: Fri, 20 May 2011 17:01:20 -0700
Message-Id: <1305936082-21304-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
References: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This saves about 2.5k text on a non force inline kernel.

Cc: x86@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/desc.h |   16 +---------------
 arch/x86/kernel/irqinit.c   |   20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 617bd56..0f6f5c7 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -337,21 +337,7 @@ extern int first_system_vector;
 /* used_vectors is BITMAP for irq is not managed by percpu vector_irq */
 extern unsigned long used_vectors[];
 
-static inline void alloc_system_vector(int vector)
-{
-	if (!test_bit(vector, used_vectors)) {
-		set_bit(vector, used_vectors);
-		if (first_system_vector > vector)
-			first_system_vector = vector;
-	} else
-		BUG();
-}
-
-static inline void alloc_intr_gate(unsigned int n, void *addr)
-{
-	alloc_system_vector(n);
-	set_intr_gate(n, addr);
-}
+void alloc_intr_gate(unsigned int n, void *addr);
 
 /*
  * This routine sets up an interrupt gate at directory privilege level 3.
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index f470e4e..514a522 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -162,6 +162,26 @@ void setup_vector_irq(int cpu)
 	__setup_vector_irq(cpu);
 }
 
+static void alloc_system_vector(int vector)
+{
+	if (!test_bit(vector, used_vectors)) {
+		set_bit(vector, used_vectors);
+		if (first_system_vector > vector)
+			first_system_vector = vector;
+	} else
+		BUG();
+}
+
+/*
+ * This could be made __init if xen didn't abuse it in its
+ * suspend path!
+ */
+void alloc_intr_gate(unsigned int n, void *addr)
+{
+	alloc_system_vector(n);
+	set_intr_gate(n, addr);
+}
+
 static void __init smp_intr_init(void)
 {
 #ifdef CONFIG_SMP
-- 
1.7.4.4

