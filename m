Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab2ACOUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 09:20:34 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52431 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab2ACOU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 09:20:27 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [RFC PATCH 9/9] x86: refactor wbinvd_on_all_cpus to void function
Date: Tue,  3 Jan 2012 16:19:13 +0200
Message-Id: <1325600353-10895-10-git-send-email-gilad@benyossef.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1325600353-10895-1-git-send-email-gilad@benyossef.com>
References: <1325600353-10895-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wbvind_on_all_cpus returns the value from on_each_cpu as return
value.

on_each_cpu always returns a hard coded zero value and none of
the callers to wbinvd_on_all_cpu check for its return value
so we might as well just drop it.

CC: Michal Nazarewicz <mina86@mina86.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org
---
 arch/x86/include/asm/smp.h |    5 ++---
 arch/x86/lib/cache-smp.c   |    3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 73b11bc..989e4a8 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -158,7 +158,7 @@ void native_cpu_die(unsigned int cpu);
 void native_play_dead(void);
 void play_dead_common(void);
 void wbinvd_on_cpu(int cpu);
-int wbinvd_on_all_cpus(void);
+void wbinvd_on_all_cpus(void);
 
 void native_send_call_func_ipi(const struct cpumask *mask);
 void native_send_call_func_single_ipi(int cpu);
@@ -173,10 +173,9 @@ static inline int num_booting_cpus(void)
 }
 #else /* !CONFIG_SMP */
 #define wbinvd_on_cpu(cpu)     wbinvd()
-static inline int wbinvd_on_all_cpus(void)
+static inline void wbinvd_on_all_cpus(void)
 {
 	wbinvd();
-	return 0;
 }
 #endif /* CONFIG_SMP */
 
diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
index 760f7e1..db2eee1 100644
--- a/arch/x86/lib/cache-smp.c
+++ b/arch/x86/lib/cache-smp.c
@@ -12,9 +12,8 @@ void wbinvd_on_cpu(int cpu)
 }
 EXPORT_SYMBOL(wbinvd_on_cpu);
 
-int wbinvd_on_all_cpus(void)
+void wbinvd_on_all_cpus(void)
 {
 	on_each_cpu(__wbinvd, NULL, 1);
-	return 0;
 }
 EXPORT_SYMBOL(wbinvd_on_all_cpus);
-- 
1.7.0.4

