Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab1F2Pj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:39:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756869Ab1F2PiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:38:03 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: [PATCH v3 6/9] KVM-GST: Add a pv_ops stub for steal time
Date: Wed, 29 Jun 2011 11:29:45 -0400
Message-Id: <1309361388-30163-7-git-send-email-glommer@redhat.com>
In-Reply-To: <1309361388-30163-1-git-send-email-glommer@redhat.com>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a function pointer in one of the many paravirt_ops
structs, to allow guests to register a steal time function.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Rik van Riel <riel@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <aliguori@us.ibm.com>
CC: Eric B Munson <emunson@mgebm.net>
---
 arch/x86/include/asm/paravirt.h       |    9 +++++++++
 arch/x86/include/asm/paravirt_types.h |    1 +
 arch/x86/kernel/paravirt.c            |    9 +++++++++
 3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index ebbc4d8..a7d2db9 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -230,6 +230,15 @@ static inline unsigned long long paravirt_sched_clock(void)
 	return PVOP_CALL0(unsigned long long, pv_time_ops.sched_clock);
 }
 
+struct jump_label_key;
+extern struct jump_label_key paravirt_steal_enabled;
+extern struct jump_label_key paravirt_steal_rq_enabled;
+
+static inline u64 paravirt_steal_clock(int cpu)
+{
+	return PVOP_CALL1(u64, pv_time_ops.steal_clock, cpu);
+}
+
 static inline unsigned long long paravirt_read_pmc(int counter)
 {
 	return PVOP_CALL1(u64, pv_cpu_ops.read_pmc, counter);
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 8288509..2c76521 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -89,6 +89,7 @@ struct pv_lazy_ops {
 
 struct pv_time_ops {
 	unsigned long long (*sched_clock)(void);
+	unsigned long long (*steal_clock)(int cpu);
 	unsigned long (*get_tsc_khz)(void);
 };
 
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 869e1ae..613a793 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -202,6 +202,14 @@ static void native_flush_tlb_single(unsigned long addr)
 	__native_flush_tlb_single(addr);
 }
 
+struct jump_label_key paravirt_steal_enabled;
+struct jump_label_key paravirt_steal_rq_enabled;
+
+static u64 native_steal_clock(int cpu)
+{
+	return 0;
+}
+
 /* These are in entry.S */
 extern void native_iret(void);
 extern void native_irq_enable_sysexit(void);
@@ -307,6 +315,7 @@ struct pv_init_ops pv_init_ops = {
 
 struct pv_time_ops pv_time_ops = {
 	.sched_clock = native_sched_clock,
+	.steal_clock = native_steal_clock,
 };
 
 struct pv_irq_ops pv_irq_ops = {
-- 
1.7.3.4

