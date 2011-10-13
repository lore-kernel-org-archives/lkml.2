Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab1JMXI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 19:08:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:61259 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421Ab1JMXI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 19:08:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="62778875"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, x86@kernel.org
Subject: [PATCH 08/12] X86: Move alloc_intr_gate out of line
Date: Thu, 13 Oct 2011 16:08:48 -0700
Message-Id: <1318547332-23155-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1318547332-23155-1-git-send-email-andi@firstfloor.org>
References: <1318547332-23155-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This saves about 2.5k text on a non force inline kernel.

Cc: x86@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/desc.h |   17 +----------------
 arch/x86/kernel/irqinit.c   |   20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 41935fa..f7183e1 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -336,22 +336,7 @@ extern int first_system_vector;
 /* used_vectors is BITMAP for irq is not managed by percpu vector_irq */
 extern unsigned long used_vectors[];
 
-static inline void alloc_system_vector(int vector)
-{
-	if (!test_bit(vector, used_vectors)) {
-		set_bit(vector, used_vectors);
-		if (first_system_vector > vector)
-			first_system_vector = vector;
-	} else {
-		BUG();
-	}
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
index b3300e6..b6e769b 100644
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

