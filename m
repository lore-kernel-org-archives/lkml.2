Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab0HGMck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 08:32:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:32979 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762008Ab0HGMci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 08:32:38 -0400
Message-ID: <4C5D5225.2000104@kernel.org>
Date: Sat, 07 Aug 2010 14:31:33 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        x86@kernel.org
Subject: [PATCH] x86: add missing __percpu markups in arch/x86/lib/msr*
References: <1281119187-12640-5-git-send-email-namhyung@gmail.com>
In-Reply-To: <1281119187-12640-5-git-send-email-namhyung@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 07 Aug 2010 12:31:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

msr_info->msrs is a percpu pointer but was missing __percpu markup.
Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
Thomas, can you please route this through x86 tree?

Thanks.

 arch/x86/include/asm/msr.h |   14 +++++++-------
 arch/x86/lib/msr-smp.c     |    8 +++++---
 arch/x86/lib/msr.c         |    6 +++---
 3 files changed, 15 insertions(+), 13 deletions(-)

Index: percpu/arch/x86/include/asm/msr.h
===================================================================
--- percpu.orig/arch/x86/include/asm/msr.h
+++ percpu/arch/x86/include/asm/msr.h
@@ -30,7 +30,7 @@ struct msr {
 struct msr_info {
 	u32 msr_no;
 	struct msr reg;
-	struct msr *msrs;
+	struct msr __percpu *msrs;
 	int err;
 };

@@ -256,14 +256,14 @@ do {

 #define write_rdtscp_aux(val) wrmsr(MSR_TSC_AUX, (val), 0)

-struct msr *msrs_alloc(void);
-void msrs_free(struct msr *msrs);
+struct msr __percpu *msrs_alloc(void);
+void msrs_free(struct msr __percpu *msrs);

 #ifdef CONFIG_SMP
 int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
-void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs);
-void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs);
+void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr __percpu *msrs);
+void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr __percpu *msrs);
 int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 regs[8]);
@@ -280,12 +280,12 @@ static inline int wrmsr_on_cpu(unsigned
 	return 0;
 }
 static inline void rdmsr_on_cpus(const struct cpumask *m, u32 msr_no,
-				struct msr *msrs)
+				struct msr __percpu *msrs)
 {
        rdmsr_on_cpu(0, msr_no, &(msrs[0].l), &(msrs[0].h));
 }
 static inline void wrmsr_on_cpus(const struct cpumask *m, u32 msr_no,
-				struct msr *msrs)
+				struct msr __percpu *msrs)
 {
        wrmsr_on_cpu(0, msr_no, msrs[0].l, msrs[0].h);
 }
Index: percpu/arch/x86/lib/msr-smp.c
===================================================================
--- percpu.orig/arch/x86/lib/msr-smp.c
+++ percpu/arch/x86/lib/msr-smp.c
@@ -64,7 +64,7 @@ int wrmsr_on_cpu(unsigned int cpu, u32 m
 EXPORT_SYMBOL(wrmsr_on_cpu);

 static void __rwmsr_on_cpus(const struct cpumask *mask, u32 msr_no,
-			    struct msr *msrs,
+			    struct msr __percpu *msrs,
 			    void (*msr_func) (void *info))
 {
 	struct msr_info rv;
@@ -91,7 +91,8 @@ static void __rwmsr_on_cpus(const struct
  * @msrs:       array of MSR values
  *
  */
-void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
+void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no,
+		   struct msr __percpu *msrs)
 {
 	__rwmsr_on_cpus(mask, msr_no, msrs, __rdmsr_on_cpu);
 }
@@ -105,7 +106,8 @@ EXPORT_SYMBOL(rdmsr_on_cpus);
  * @msrs:       array of MSR values
  *
  */
-void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
+void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no,
+		   struct msr __percpu *msrs)
 {
 	__rwmsr_on_cpus(mask, msr_no, msrs, __wrmsr_on_cpu);
 }
Index: percpu/arch/x86/lib/msr.c
===================================================================
--- percpu.orig/arch/x86/lib/msr.c
+++ percpu/arch/x86/lib/msr.c
@@ -2,9 +2,9 @@
 #include <linux/preempt.h>
 #include <asm/msr.h>

-struct msr *msrs_alloc(void)
+struct msr __percpu *msrs_alloc(void)
 {
-	struct msr *msrs = NULL;
+	struct msr __percpu *msrs = NULL;

 	msrs = alloc_percpu(struct msr);
 	if (!msrs) {
@@ -16,7 +16,7 @@ struct msr *msrs_alloc(void)
 }
 EXPORT_SYMBOL(msrs_alloc);

-void msrs_free(struct msr *msrs)
+void msrs_free(struct msr __percpu *msrs)
 {
 	free_percpu(msrs);
 }
