Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab0K0PXV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 10:23:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:37980 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab0K0PW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 10:22:56 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/16] x86: Implement cpu_to_logical_apicid() for summit_32
Date: Sat, 27 Nov 2010 16:21:59 +0100
Message-Id: <1290871325-3055-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290871325-3055-1-git-send-email-tj@kernel.org>
References: <1290871325-3055-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 27 Nov 2010 15:22:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out logical apic id calculation from summit_init_apic_ldr() and
use it for the cpu_to_logical_apicid() callback.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/apic/summit_32.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index fc8bf8a..50d5e3b 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -196,18 +196,8 @@ static unsigned long summit_check_apicid_present(int bit)
 
 static int summit_cpu_to_logical_apicid(int cpu)
 {
-	/*
-	 * This is stub implementation which causes static percpu area
-	 * layout to ignore NUMA affinity.
-	 */
-	return BAD_APICID;
-}
-
-static void summit_init_apic_ldr(void)
-{
-	unsigned long val, id;
 	int count = 0;
-	u8 my_id = (u8)hard_smp_processor_id();
+	u8 my_id = early_per_cpu(x86_cpu_to_apicid, cpu);
 	u8 my_cluster = APIC_CLUSTER(my_id);
 #ifdef CONFIG_SMP
 	u8 lid;
@@ -223,7 +213,15 @@ static void summit_init_apic_ldr(void)
 	/* We only have a 4 wide bitmap in cluster mode.  If a deranged
 	 * BIOS puts 5 CPUs in one APIC cluster, we're hosed. */
 	BUG_ON(count >= XAPIC_DEST_CPUS_SHIFT);
-	id = my_cluster | (1UL << count);
+	return my_cluster | (1UL << count);
+}
+
+static void summit_init_apic_ldr(void)
+{
+	int cpu = smp_processor_id();
+	unsigned long id = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+	unsigned long val;
+
 	apic_write(APIC_DFR, SUMMIT_APIC_DFR_VALUE);
 	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
 	val |= SET_APIC_LOGICAL_ID(id);
-- 
1.7.1

