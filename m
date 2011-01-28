Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab1A1OlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:41:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:60036 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770Ab1A1OlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:41:02 -0500
Date: Fri, 28 Jan 2011 14:40:35 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1295789862-25482-11-git-send-email-tj@kernel.org>
References: <1295789862-25482-11-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86: Implement x86_32_early_logical_apicid() for summit_32
Message-ID: <tip-3b39d937843e071c59b3aeecbf7de4750f095b12@git.kernel.org>
Git-Commit-ID: 3b39d937843e071c59b3aeecbf7de4750f095b12
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 28 Jan 2011 14:40:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b39d937843e071c59b3aeecbf7de4750f095b12
Gitweb:     http://git.kernel.org/tip/3b39d937843e071c59b3aeecbf7de4750f095b12
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Sun, 23 Jan 2011 14:37:36 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 28 Jan 2011 14:54:07 +0100

x86: Implement x86_32_early_logical_apicid() for summit_32

Factor out logical apic id calculation from
summit_init_apic_ldr() and use it for the
x86_32_early_logical_apicid() callback.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: eric.dumazet@gmail.com
Cc: yinghai@kernel.org
Cc: brgerst@gmail.com
Cc: gorcunov@gmail.com
Cc: penberg@kernel.org
Cc: shaohui.zheng@intel.com
Cc: rientjes@google.com
LKML-Reference: <1295789862-25482-11-git-send-email-tj@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
