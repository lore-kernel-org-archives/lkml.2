Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab0L1LtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 06:49:11 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59564 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab0L1LtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 06:49:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=XTpqwAxHlamv1JG0et9nAFRrsB0PgK3i5FhmZx/cbnEEl2Ha2hPQprQ2DxKjBUswcH
         y3K/j2ysb0sdiRmlU75e7CjtSylMkgLIgEal2mtL2fPJkGbizx9/zcmm4iLKF0Rkfb1J
         dhBl/Z5BGbFEf1YN2+qLl7GvYlp9B34mA3QbA=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org, shaohui.zheng@intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/16] x86: Always use x86_cpu_to_logical_apicid for cpu -> logical apic id
Date: Tue, 28 Dec 2010 12:48:38 +0100
Message-Id: <1293536929-31683-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293536929-31683-1-git-send-email-tj@kernel.org>
References: <1293536929-31683-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, cpu -> logical apic id translation is done by
apic->cpu_to_logical_apicid() callback which may or may not use
x86_cpu_to_logical_apicid.  This is unnecessary as it should always
equal logical_smp_processor_id() which is known early during CPU bring
up.

Initialize x86_cpu_to_logical_apicid after apic->init_apic_ldr() in
setup_local_APIC() and always use x86_cpu_to_logical_apicid for cpu ->
logical apic id mapping.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/apic/apic.c |    8 ++++++++
 arch/x86/kernel/apic/ipi.c  |    8 ++++----
 arch/x86/kernel/smpboot.c   |    7 +++----
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index ba78b1e..8ad231c 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1252,6 +1252,14 @@ void __cpuinit setup_local_APIC(void)
 	 */
 	apic->init_apic_ldr();
 
+#ifdef CONFIG_X86_32
+	/*
+	 * APIC LDR is initialized.  Fetch and store logical_apic_id.
+	 */
+	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
+		logical_smp_processor_id();
+#endif
+
 	/*
 	 * Set Task Priority to 'accept all'. We never change this
 	 * later on.
diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
index 5037736..cce91bf 100644
--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -73,8 +73,8 @@ void default_send_IPI_mask_sequence_logical(const struct cpumask *mask,
 	local_irq_save(flags);
 	for_each_cpu(query_cpu, mask)
 		__default_send_IPI_dest_field(
-			apic->cpu_to_logical_apicid(query_cpu), vector,
-			apic->dest_logical);
+			early_per_cpu(x86_cpu_to_logical_apicid, query_cpu),
+			vector, apic->dest_logical);
 	local_irq_restore(flags);
 }
 
@@ -92,8 +92,8 @@ void default_send_IPI_mask_allbutself_logical(const struct cpumask *mask,
 		if (query_cpu == this_cpu)
 			continue;
 		__default_send_IPI_dest_field(
-			apic->cpu_to_logical_apicid(query_cpu), vector,
-			apic->dest_logical);
+			early_per_cpu(x86_cpu_to_logical_apicid, query_cpu),
+			vector, apic->dest_logical);
 		}
 	local_irq_restore(flags);
 }
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index eb04f30..0768761 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -168,19 +168,18 @@ static void unmap_cpu_to_node(int cpu)
 static void map_cpu_to_logical_apicid(void)
 {
 	int cpu = smp_processor_id();
-	int apicid = logical_smp_processor_id();
-	int node = apic->apicid_to_node(apicid);
+	int logical_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+	int node;
 
+	node = apic->apicid_to_node(logical_apicid);
 	if (!node_online(node))
 		node = first_online_node;
 
-	early_per_cpu(x86_cpu_to_logical_apicid, cpu) = apicid;
 	map_cpu_to_node(cpu, node);
 }
 
 void numa_remove_cpu(int cpu)
 {
-	early_per_cpu(x86_cpu_to_logical_apicid, cpu) = BAD_APICID;
 	unmap_cpu_to_node(cpu);
 }
 #else
-- 
1.7.1

