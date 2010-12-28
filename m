Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab0L1LtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 06:49:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59564 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab0L1LtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 06:49:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=E3KLeImvYa8ZoqIAgZIth7USKNmcmExOYCVInfmRjoLNRhDWboHlS9Ss0BQxaOKEzk
         3ifVSgXUa62EZGdAaPV6LAAEJfwygtEGdP6k2tqfyJcPIyNFjyUj2bdHt+O9E9/0+7lP
         Pb64ZnrMBrweLf8VQ2ngFIhdF2TsX90IkZbr0=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org, shaohui.zheng@intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/16] x86: Add apic->x86_32_early_logical_apicid()
Date: Tue, 28 Dec 2010 12:48:40 +0100
Message-Id: <1293536929-31683-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293536929-31683-1-git-send-email-tj@kernel.org>
References: <1293536929-31683-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86_32, the mapping between cpu and logical apic ID differs
depending on the specific apic implementation in use.  The mapping is
initialized while bringing up CPUs; however, this makes early inits
ignore memory topology.

Add a x86_32 specific apic->x86_32_early_logical_apicid() which is
called early during boot to query the mapping.  The mapping is later
verified against the result of init_apic_ldr().  The method is allowed
to return BAD_APICID if it can't be determined early.

noop variant which always returns BAD_APICID is implemented and added
to all x86_32 apic implementations.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/apic.h      |   19 +++++++++++++++++++
 arch/x86/kernel/apic/apic.c      |   12 ++++++++++--
 arch/x86/kernel/apic/apic_noop.c |    4 ++++
 arch/x86/kernel/apic/bigsmp_32.c |    2 ++
 arch/x86/kernel/apic/es7000_32.c |    4 ++++
 arch/x86/kernel/apic/numaq_32.c  |    2 ++
 arch/x86/kernel/apic/probe_32.c  |    2 ++
 arch/x86/kernel/apic/summit_32.c |    2 ++
 8 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index d1aa0c3..efb073b 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -354,6 +354,20 @@ struct apic {
 	void (*icr_write)(u32 low, u32 high);
 	void (*wait_icr_idle)(void);
 	u32 (*safe_wait_icr_idle)(void);
+
+#ifdef CONFIG_X86_32
+	/*
+	 * Called very early during boot from get_smp_config().  It should
+	 * return the logical apicid.  x86_[bios]_cpu_to_apicid is
+	 * initialized before this function is called.
+	 *
+	 * If logical apicid can't be determined that early, the function
+	 * may return BAD_APICID.  Logical apicid will be configured after
+	 * init_apic_ldr() while bringing up CPUs.  Note that NUMA affinity
+	 * won't be applied properly during early boot in this case.
+	 */
+	int (*x86_32_early_logical_apicid)(int cpu);
+#endif
 };
 
 /*
@@ -501,6 +515,11 @@ extern struct apic apic_noop;
 
 extern struct apic apic_default;
 
+static inline int noop_x86_32_early_logical_apicid(int cpu)
+{
+	return BAD_APICID;
+}
+
 /*
  * Set up the logical destination ID.
  *
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 8ad231c..6a82dc6 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1254,8 +1254,13 @@ void __cpuinit setup_local_APIC(void)
 
 #ifdef CONFIG_X86_32
 	/*
-	 * APIC LDR is initialized.  Fetch and store logical_apic_id.
+	 * APIC LDR is initialized.  If logical_apicid mapping was
+	 * initialized during get_smp_config(), make sure it matches the
+	 * actual value.
 	 */
+	i = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+	WARN_ON(i != BAD_APICID && i != logical_smp_processor_id());
+	/* always use the value from LDR */
 	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
 		logical_smp_processor_id();
 #endif
@@ -1994,7 +1999,10 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	early_per_cpu(x86_cpu_to_apicid, cpu) = apicid;
 	early_per_cpu(x86_bios_cpu_apicid, cpu) = apicid;
 #endif
-
+#ifdef CONFIG_X86_32
+	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
+		apic->x86_32_early_logical_apicid(cpu);
+#endif
 	set_cpu_possible(cpu, true);
 	set_cpu_present(cpu, true);
 }
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index f3d19b2..0309c58 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -191,4 +191,8 @@ struct apic apic_noop = {
 	.icr_write			= noop_apic_icr_write,
 	.wait_icr_idle			= noop_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= noop_safe_apic_wait_icr_idle,
+
+#ifdef CONFIG_X86_32
+	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
+#endif
 };
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 4c62592..dd32a9b 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -251,4 +251,6 @@ struct apic apic_bigsmp = {
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
+
+	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
 };
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 6840681..0ffc1ec 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -682,6 +682,8 @@ struct apic __refdata apic_es7000_cluster = {
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
+
+	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
 };
 
 struct apic __refdata apic_es7000 = {
@@ -744,4 +746,6 @@ struct apic __refdata apic_es7000 = {
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
+
+	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
 };
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 2b434d5..f1a8b12 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -539,4 +539,6 @@ struct apic __refdata apic_numaq = {
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
+
+	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
 };
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 24a6828..40be7c3 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -166,6 +166,8 @@ struct apic apic_default = {
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
+
+	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
 };
 
 extern struct apic apic_numaq;
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 1ef4c14..172c498 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -552,4 +552,6 @@ struct apic apic_summit = {
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
+
+	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
 };
-- 
1.7.1

