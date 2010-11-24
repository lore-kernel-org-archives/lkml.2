Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab0KXRob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 12:44:31 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56469 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab0KXRo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 12:44:29 -0500
From: Borislav Petkov <bp@amd64.org>
To: <hpa@zytor.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: <x86@kernel.org>, kvm@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/2] x86, lib: Add a wbinvd helper for an arbitrary cpu set
Date: Wed, 24 Nov 2010 18:44:03 +0100
Message-Id: <1290620644-27423-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add a wbinvd helper for an arbitrary set of CPUs.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/smp.h |    4 +++-
 arch/x86/lib/cache-smp.c   |   12 ++++++++++++
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 4c2f63c..f7805f1 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -141,6 +141,7 @@ void native_cpu_die(unsigned int cpu);
 void native_play_dead(void);
 void play_dead_common(void);
 void wbinvd_on_cpu(int cpu);
+void wbinvd_on_cpus(const struct cpumask *);
 int wbinvd_on_all_cpus(void);
 
 void native_send_call_func_ipi(const struct cpumask *mask);
@@ -155,7 +156,8 @@ static inline int num_booting_cpus(void)
 	return cpumask_weight(cpu_callout_mask);
 }
 #else /* !CONFIG_SMP */
-#define wbinvd_on_cpu(cpu)     wbinvd()
+#define wbinvd_on_cpu(cpu)	wbinvd()
+#define wbinvd_on_cpus(mask)	wbinvd()
 static inline int wbinvd_on_all_cpus(void)
 {
 	wbinvd();
diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
index a3c6688..7778d56 100644
--- a/arch/x86/lib/cache-smp.c
+++ b/arch/x86/lib/cache-smp.c
@@ -12,6 +12,18 @@ void wbinvd_on_cpu(int cpu)
 }
 EXPORT_SYMBOL(wbinvd_on_cpu);
 
+void wbinvd_on_cpus(const struct cpumask *mask)
+{
+	int this_cpu = get_cpu();
+
+	if (cpumask_test_cpu(this_cpu, mask))
+		wbinvd();
+
+	smp_call_function_many(mask, __wbinvd, NULL, 1);
+	put_cpu();
+}
+EXPORT_SYMBOL(wbinvd_on_cpus);
+
 int wbinvd_on_all_cpus(void)
 {
 	return on_each_cpu(__wbinvd, NULL, 1);
-- 
1.7.3.1.50.g1e633

