Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab1A1Ojv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:39:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:59994 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716Ab1A1Oju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:39:50 -0500
Date: Fri, 28 Jan 2011 14:39:30 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1295789862-25482-8-git-send-email-tj@kernel.org>
References: <1295789862-25482-8-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86: Add apic->x86_32_early_logical_apicid()
Message-ID: <tip-acb8bc09c6185e4d3d582d0076aaa6a89f19d8c5@git.kernel.org>
Git-Commit-ID: acb8bc09c6185e4d3d582d0076aaa6a89f19d8c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 28 Jan 2011 14:39:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  acb8bc09c6185e4d3d582d0076aaa6a89f19d8c5
Gitweb:     http://git.kernel.org/tip/acb8bc09c6185e4d3d582d0076aaa6a89f19d8c5
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Sun, 23 Jan 2011 14:37:33 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 28 Jan 2011 14:54:06 +0100

x86: Add apic->x86_32_early_logical_apicid()

On x86_32, the mapping between cpu and logical apic ID differs
depending on the specific apic implementation in use.  The
mapping is initialized while bringing up CPUs; however, this
makes early inits ignore memory topology.

Add a x86_32 specific apic->x86_32_early_logical_apicid() which
is called early during boot to query the mapping.  The mapping
is later verified against the result of init_apic_ldr().  The
method is allowed to return BAD_APICID if it can't be determined
early.

noop variant which always returns BAD_APICID is implemented and
added to all x86_32 apic implementations.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: eric.dumazet@gmail.com
Cc: yinghai@kernel.org
Cc: brgerst@gmail.com
Cc: gorcunov@gmail.com
Cc: penberg@kernel.org
Cc: shaohui.zheng@intel.com
Cc: rientjes@google.com
LKML-Reference: <1295789862-25482-8-git-send-email-tj@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
index ae08246..3127079 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1250,8 +1250,13 @@ void __cpuinit setup_local_APIC(void)
 
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
@@ -1991,7 +1996,10 @@ void __cpuinit generic_processor_info(int apicid, int version)
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
