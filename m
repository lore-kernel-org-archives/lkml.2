Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944Ab2HVJx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 05:53:26 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45180 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875Ab2HVJxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 05:53:22 -0400
Date: Wed, 22 Aug 2012 12:53:16 +0300
From: Ido Yariv <ido@wizery.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH v2 2/2] x86/pat: Avoid contention on cpa_lock if possible
Message-ID: <20120822095316.GA16110@WorkStation.localnet>
References: <1344445299-22142-1-git-send-email-ido@wizery.com>
 <1344445299-22142-2-git-send-email-ido@wizery.com>
 <20120822084702.GA21764@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822084702.GA21764@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Wed, Aug 22, 2012 at 10:47:02AM +0200, Ingo Molnar wrote:
> 
> * Ido Yariv <ido@wizery.com> wrote:
> 
> > vSMP Foundation does not require to serialize CPA by guaranteeing that
> > the most recent TLB entry will always be used.
> > 
> > To avoid needless contention on cpa_lock, do not lock/unlock it if it
> > isn't necessary.
> > 
> > Based on work by Shai Fultheim <shai@scalemp.com>.
> > 
> > Signed-off-by: Ido Yariv <ido@wizery.com>
> > Acked-by: Shai Fultheim <shai@scalemp.com>
> > ---
> > Changes from v1:
> > - Use a synthetic CPUID bit and a use static_cpu_has() as suggested by
> >   H. Peter Avnin
> > 
> >  arch/x86/include/asm/cpufeature.h |    1 +
> >  arch/x86/kernel/vsmp_64.c         |   10 ++++++++++
> >  arch/x86/mm/pageattr.c            |   30 +++++++++++++++++++++---------
> >  3 files changed, 32 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> > index 6b7ee5f..92303a0 100644
> > --- a/arch/x86/include/asm/cpufeature.h
> > +++ b/arch/x86/include/asm/cpufeature.h
> > @@ -97,6 +97,7 @@
> >  #define X86_FEATURE_EXTD_APICID	(3*32+26) /* has extended APICID (8 bits) */
> >  #define X86_FEATURE_AMD_DCM     (3*32+27) /* multi-node processor */
> >  #define X86_FEATURE_APERFMPERF	(3*32+28) /* APERFMPERF */
> > +#define X86_FEATURE_NO_CPA_LOCK	(3*32+29) /* Serializing cpa is not required */
> 
> Patch looks mostly good, but could we please use some more 
> hardware-ish name, instead of referring to a kernel lock?

Sure thing. How about X86_FEATURE_TLB_RELIABLE?

Thanks,
Ido.

>From fc3adcd1a9a86d65836d461bc22f54955ba3fc82 Mon Sep 17 00:00:00 2001
From: Ido Yariv <ido@wizery.com>
Date: Mon, 11 Jun 2012 15:17:56 +0300
Subject: [PATCH v3] x86/pat: Avoid contention on cpa_lock if possible

vSMP Foundation does not require to serialize CPA by guaranteeing that
the most recent TLB entry will always be used.

To avoid needless contention on cpa_lock, do not lock/unlock it if it
isn't necessary.

Based on work by Shai Fultheim <shai@scalemp.com>.

Signed-off-by: Ido Yariv <ido@wizery.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/vsmp_64.c         |   10 ++++++++++
 arch/x86/mm/pageattr.c            |   30 +++++++++++++++++++++---------
 3 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 6b7ee5f..9b3d075 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -97,6 +97,7 @@
 #define X86_FEATURE_EXTD_APICID	(3*32+26) /* has extended APICID (8 bits) */
 #define X86_FEATURE_AMD_DCM     (3*32+27) /* multi-node processor */
 #define X86_FEATURE_APERFMPERF	(3*32+28) /* APERFMPERF */
+#define X86_FEATURE_TLB_RELIABLE (3*32+29) /* Serializing cpa is not required */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index f655f2c..6e245d8 100644
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
+	set_cpu_cap(c, X86_FEATURE_TLB_RELIABLE);
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
index a718e0d..bc4720e 100644
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
+	if (debug_pagealloc || static_cpu_has(X86_FEATURE_TLB_RELIABLE))
+		return;
+
+	spin_lock(&_cpa_lock);
+}
+
+static inline void cpa_unlock(void)
+{
+	if (debug_pagealloc || static_cpu_has(X86_FEATURE_TLB_RELIABLE))
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

