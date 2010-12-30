Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab0L3Rtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 12:49:52 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46520 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab0L3Rtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 12:49:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=SFIYHsqv0FqkcuVik/wSO5cnU0QZRlGlXY3AaOZ9WgS2DZ/oUss2FUhUHiuI+TsOoP
         v6d2BNDUWVIQnaV1I4uBzd+1ZavdjCjp1lQyzOTiFjJaWBWKvX+W0DHbB06GsgXwEV7d
         TdyIqokIZBdilM2oPRhGPsAY1aGdsUhkF7iMg=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org, shaohui.zheng@intel.com, rientjes@google.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/16] x86: Implement x86_32_early_logical_apicid() for summit_32
Date: Thu, 30 Dec 2010 18:49:23 +0100
Message-Id: <1293731369-10851-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293731369-10851-1-git-send-email-tj@kernel.org>
References: <1293731369-10851-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out logical apic id calculation from summit_init_apic_ldr() and
use it for the x86_32_early_logical_apicid() callback.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/apic/summit_32.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 172c498..8c91473 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -194,11 +194,10 @@ static unsigned long summit_check_apicid_present(int bit)
 	return 1;
 }
 
-static void summit_init_apic_ldr(void)
+static int summit_early_logical_apicid(int cpu)
 {
-	unsigned long val, id;
 	int count = 0;
-	u8 my_id = (u8)hard_smp_processor_id();
+	u8 my_id = early_per_cpu(x86_cpu_to_apicid, cpu);
 	u8 my_cluster = APIC_CLUSTER(my_id);
 #ifdef CONFIG_SMP
 	u8 lid;
@@ -214,7 +213,15 @@ static void summit_init_apic_ldr(void)
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
@@ -553,5 +560,5 @@ struct apic apic_summit = {
 	.wait_icr_idle			= native_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 
-	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
+	.x86_32_early_logical_apicid	= summit_early_logical_apicid,
 };
-- 
1.7.1

