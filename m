Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab2FPTqL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 15:46:11 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:34718 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952Ab2FPTqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 15:46:10 -0400
Subject: [PATCH] x86: cpu: use printk_once
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Sat, 16 Jun 2012 21:45:16 +0200
Message-ID: <1339875916.3269.4.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Use printk_once() instead of extra variables.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 arch/x86/kernel/cpu/common.c   |   12 +++++-------
 arch/x86/kernel/cpu/topology.c |   12 +++---------
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 6b9333b..644c547 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -457,7 +457,6 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 #ifdef CONFIG_X86_HT
 	u32 eax, ebx, ecx, edx;
 	int index_msb, core_bits;
-	static bool printed;
 
 	if (!cpu_has(c, X86_FEATURE_HT))
 		return;
@@ -493,12 +492,11 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 				       ((1 << core_bits) - 1);
 
 out:
-	if (!printed && (c->x86_max_cores * smp_num_siblings) > 1) {
-		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
-		       c->phys_proc_id);
-		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
-		       c->cpu_core_id);
-		printed = 1;
+	if ((c->x86_max_cores * smp_num_siblings) > 1) {
+		printk_once(KERN_INFO  "CPU: Physical Processor ID: %d\n",
+			    c->phys_proc_id);
+		printk_once(KERN_INFO  "CPU: Processor Core ID: %d\n",
+			    c->cpu_core_id);
 	}
 #endif
 }
diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
index 4397e98..2f01ae0 100644
--- a/arch/x86/kernel/cpu/topology.c
+++ b/arch/x86/kernel/cpu/topology.c
@@ -32,7 +32,6 @@ void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
 	unsigned int eax, ebx, ecx, edx, sub_index;
 	unsigned int ht_mask_width, core_plus_mask_width;
 	unsigned int core_select_mask, core_level_siblings;
-	static bool printed;
 
 	if (c->cpuid_level < 0xb)
 		return;
@@ -86,14 +85,9 @@ void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
 
 	c->x86_max_cores = (core_level_siblings / smp_num_siblings);
 
-	if (!printed) {
-		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
-		       c->phys_proc_id);
-		if (c->x86_max_cores > 1)
-			printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
-			       c->cpu_core_id);
-		printed = 1;
-	}
+	printk_once(KERN_INFO  "CPU: Physical Processor ID: %d\n", c->phys_proc_id);
+	if (c->x86_max_cores > 1)
+		printk_once(KERN_INFO  "CPU: Processor Core ID: %d\n", c->cpu_core_id);
 	return;
 #endif
 }
-- 
1.7.4.1



