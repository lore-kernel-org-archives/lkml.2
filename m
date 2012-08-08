Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030453Ab2HHRDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:03:22 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60277 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758928Ab2HHRDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:03:19 -0400
From: Ido Yariv <ido@wizery.com>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Shai Fultheim <shai@scalemp.com>, Ido Yariv <ido@wizery.com>
Subject: [PATCH v2 2/2] x86/pat: Avoid contention on cpa_lock if possible
Date: Wed,  8 Aug 2012 20:01:39 +0300
Message-Id: <1344445299-22142-2-git-send-email-ido@wizery.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1344445299-22142-1-git-send-email-ido@wizery.com>
References: <1344445299-22142-1-git-send-email-ido@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vSMP Foundation does not require to serialize CPA by guaranteeing that
the most recent TLB entry will always be used.

To avoid needless contention on cpa_lock, do not lock/unlock it if it
isn't necessary.

Based on work by Shai Fultheim <shai@scalemp.com>.

Signed-off-by: Ido Yariv <ido@wizery.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
---
Changes from v1:
- Use a synthetic CPUID bit and a use static_cpu_has() as suggested by
  H. Peter Avnin

 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/vsmp_64.c         |   10 ++++++++++
 arch/x86/mm/pageattr.c            |   30 +++++++++++++++++++++---------
 3 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 6b7ee5f..92303a0 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -97,6 +97,7 @@
 #define X86_FEATURE_EXTD_APICID	(3*32+26) /* has extended APICID (8 bits) */
 #define X86_FEATURE_AMD_DCM     (3*32+27) /* multi-node processor */
 #define X86_FEATURE_APERFMPERF	(3*32+28) /* APERFMPERF */
+#define X86_FEATURE_NO_CPA_LOCK	(3*32+29) /* Serializing cpa is not required */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index f655f2c..994359b 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -235,9 +235,19 @@ static void __init vsmp_platform_setup(void)
 	set_vsmp_pv_ops();
 }
 
+static void __cpuinit vsmp_set_cpu_features(struct cpuinfo_x86 *c)
+{
+	/*
+	 * vSMP guarantees that the most recent TLB entry will always be used,
+	 * so we can avoid serializing cpa
+	 */
+	set_cpu_cap(c, X86_FEATURE_NO_CPA_LOCK);
+}
+
 const __refconst struct hypervisor_x86 x86_hyper_vsmp = {
 	.name			= "ScaleMP vSMP Foundation",
 	.detect			= detect_vsmp_box,
 	.init_platform		= vsmp_platform_setup,
+	.set_cpu_features	= vsmp_set_cpu_features,
 };
 EXPORT_SYMBOL(x86_hyper_vsmp);
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 931930a..95fbb41 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -46,7 +46,7 @@ struct cpa_data {
  * entries change the page attribute in parallel to some other cpu
  * splitting a large page entry along with changing the attribute.
  */
-static DEFINE_SPINLOCK(cpa_lock);
+static DEFINE_SPINLOCK(_cpa_lock);
 
 #define CPA_FLUSHTLB 1
 #define CPA_ARRAY 2
@@ -110,6 +110,22 @@ static inline unsigned long highmap_end_pfn(void)
 # define debug_pagealloc 0
 #endif
 
+static inline void cpa_lock(void)
+{
+	if (debug_pagealloc || static_cpu_has(X86_FEATURE_NO_CPA_LOCK))
+		return;
+
+	spin_lock(&_cpa_lock);
+}
+
+static inline void cpa_unlock(void)
+{
+	if (debug_pagealloc || static_cpu_has(X86_FEATURE_NO_CPA_LOCK))
+		return;
+
+	spin_unlock(&_cpa_lock);
+}
+
 static inline int
 within(unsigned long addr, unsigned long start, unsigned long end)
 {
@@ -509,11 +525,9 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	pgprot_t ref_prot;
 	struct page *base;
 
-	if (!debug_pagealloc)
-		spin_unlock(&cpa_lock);
+	cpa_unlock();
 	base = alloc_pages(GFP_KERNEL | __GFP_NOTRACK, 0);
-	if (!debug_pagealloc)
-		spin_lock(&cpa_lock);
+	cpa_lock();
 	if (!base)
 		return -ENOMEM;
 
@@ -801,11 +815,9 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
 		if (cpa->flags & (CPA_ARRAY | CPA_PAGES_ARRAY))
 			cpa->numpages = 1;
 
-		if (!debug_pagealloc)
-			spin_lock(&cpa_lock);
+		cpa_lock();
 		ret = __change_page_attr(cpa, checkalias);
-		if (!debug_pagealloc)
-			spin_unlock(&cpa_lock);
+		cpa_unlock();
 		if (ret)
 			return ret;
 
-- 
1.7.7.6

