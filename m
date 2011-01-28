Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab1A1OjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:39:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:59966 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287Ab1A1OjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:39:05 -0500
Date: Fri, 28 Jan 2011 14:38:46 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1295789862-25482-6-git-send-email-tj@kernel.org>
References: <1295789862-25482-6-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86: Always use x86_cpu_to_logical_apicid for cpu -> logical apic id
Message-ID: <tip-6f802c4bfa2acf1bffa8341fe9084da0205d581d@git.kernel.org>
Git-Commit-ID: 6f802c4bfa2acf1bffa8341fe9084da0205d581d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 28 Jan 2011 14:38:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f802c4bfa2acf1bffa8341fe9084da0205d581d
Gitweb:     http://git.kernel.org/tip/6f802c4bfa2acf1bffa8341fe9084da0205d581d
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Sun, 23 Jan 2011 14:37:31 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 28 Jan 2011 14:54:05 +0100

x86: Always use x86_cpu_to_logical_apicid for cpu -> logical apic id

Currently, cpu -> logical apic id translation is done by
apic->cpu_to_logical_apicid() callback which may or may not use
x86_cpu_to_logical_apicid.  This is unnecessary as it should
always equal logical_smp_processor_id() which is known early
during CPU bring up.

Initialize x86_cpu_to_logical_apicid after apic->init_apic_ldr()
in setup_local_APIC() and always use x86_cpu_to_logical_apicid
for cpu -> logical apic id mapping.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: eric.dumazet@gmail.com
Cc: yinghai@kernel.org
Cc: brgerst@gmail.com
Cc: gorcunov@gmail.com
Cc: penberg@kernel.org
Cc: shaohui.zheng@intel.com
Cc: rientjes@google.com
LKML-Reference: <1295789862-25482-6-git-send-email-tj@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/apic.c |    8 ++++++++
 arch/x86/kernel/apic/ipi.c  |    8 ++++----
 arch/x86/kernel/smpboot.c   |    7 +++----
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 126d5a3..ae08246 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1248,6 +1248,14 @@ void __cpuinit setup_local_APIC(void)
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
index df934e4..ca20f6b 100644
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
