Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab1LEIV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 03:21:28 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40904 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab1LEIUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 03:20:51 -0500
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steffen Persvold <sp@numascale.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Daniel J Blueman <daniel@numascale-asia.com>
Subject: [PATCH 2/3] v2: Add x86_init platform override to fix up core numbering
Date: Mon,  5 Dec 2011 16:20:37 +0800
Message-Id: <1323073238-32686-2-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323073238-32686-1-git-send-email-daniel@numascale-asia.com>
References: <4ED9199A.3060108@numascale-asia.com>
 <1323073238-32686-1-git-send-email-daniel@numascale-asia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an x86_init vector for handling inconsistent core numbering. This is
useful for multi-fabric platforms, such as Numascale NumaConnect.

v2:
 - use struct x86_cpuinit_ops
 - provide default fall-back function to warn

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 arch/x86/include/asm/x86_init.h |    3 +++
 arch/x86/kernel/cpu/amd.c       |    7 +++++++
 arch/x86/kernel/cpu/common.c    |    5 +++++
 arch/x86/kernel/x86_init.c      |    1 +
 4 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 1971e65..1ac860a 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -7,6 +7,7 @@
 struct mpc_bus;
 struct mpc_cpu;
 struct mpc_table;
+struct cpuinfo_x86;
 
 /**
  * struct x86_init_mpparse - platform specific mpparse ops
@@ -147,6 +148,7 @@ struct x86_init_ops {
  */
 struct x86_cpuinit_ops {
 	void (*setup_percpu_clockev)(void);
+	void (*fixup_cpu_id)(struct cpuinfo_x86 *c, int node);
 };
 
 /**
@@ -186,5 +188,6 @@ extern struct x86_msi_ops x86_msi;
 
 extern void x86_init_noop(void);
 extern void x86_init_uint_noop(unsigned int unused);
+extern void x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int node);
 
 #endif
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index c7e46cb..619377a 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -353,6 +353,13 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 	if (node == NUMA_NO_NODE)
 		node = per_cpu(cpu_llc_id, cpu);
 
+	/*
+	 * If core numbers are inconsistent, it's likely a multi-fabric platform,
+	 * so invoke platform-specific handler
+	 */
+	if (c->phys_proc_id != node)
+		x86_cpuinit.fixup_cpu_id(c, node);
+
 	if (!node_online(node)) {
 		/*
 		 * Two possibilities here:
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index aa003b1..c91c793 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1141,6 +1141,15 @@ static void dbg_restore_debug_regs(void)
 #endif /* ! CONFIG_KGDB */
 
 /*
+ * Prints an error where the NUMA and configured core-number mismatch and the
+ * platform didn't override this to fix it up
+ */
+void __cpuinit x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int node)
+{
+	pr_err("NUMA core number %d differs from configured core number %d\n", node, c->phys_proc_id);
+}
+
+/*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
  * and IDT. We reload them nevertheless, this function acts as adiff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index c1d6cd5..91f83e2 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -92,6 +92,7 @@ struct x86_init_ops x86_init __initdata = {
 
 struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {
 	.setup_percpu_clockev		= setup_secondary_APIC_clock,
+	.fixup_cpu_id			= x86_default_fixup_cpu_id,
 };
 
 static void default_nmi_init(void) { };
-- 
1.7.5.4

