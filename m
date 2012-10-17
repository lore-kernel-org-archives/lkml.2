Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab2JQQ5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 12:57:38 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:44541 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab2JQQ5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 12:57:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: hpa@zytor.com, david.vrabel@citrix.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [RFC PATCH] paravirt: Remove paravirt_rdtscp as all platforms use the native version anyhow.
Date: Wed, 17 Oct 2012 12:45:26 -0400
Message-Id: <1350492326-22658-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic case uses native_read_tscp, the Xen case uses
native_read_tscp, llguest does not even have it defined.

There is not even any user of this call. The only one that
could potentially be is the __vdso_getcpu, but that runs
within vDSO so it cannot run in kernel space.

Suggested-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/msr.h            |    4 ++--
 arch/x86/include/asm/paravirt.h       |   21 ---------------------
 arch/x86/include/asm/paravirt_types.h |    1 -
 arch/x86/kernel/paravirt.c            |    1 -
 arch/x86/xen/enlighten.c              |    2 --
 5 files changed, 2 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 813ed10..ba064dd 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -202,6 +202,8 @@ do {							\
 
 #define rdpmcl(counter, val) ((val) = native_read_pmc(counter))
 
+#endif	/* !CONFIG_PARAVIRT */
+
 #define rdtscp(low, high, aux)					\
 do {                                                            \
 	unsigned long long _val = native_read_tscp(&(aux));     \
@@ -211,8 +213,6 @@ do {                                                            \
 
 #define rdtscpll(val, aux) (val) = native_read_tscp(&(aux))
 
-#endif	/* !CONFIG_PARAVIRT */
-
 #define wrmsrl_safe(msr, val) wrmsr_safe((msr), (u32)(val),		\
 					     (u32)((val) >> 32))
 
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index a0facf3..c2520b8 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -215,27 +215,6 @@ do {						\
 
 #define rdpmcl(counter, val) ((val) = paravirt_read_pmc(counter))
 
-static inline unsigned long long paravirt_rdtscp(unsigned int *aux)
-{
-	return PVOP_CALL1(u64, pv_cpu_ops.read_tscp, aux);
-}
-
-#define rdtscp(low, high, aux)				\
-do {							\
-	int __aux;					\
-	unsigned long __val = paravirt_rdtscp(&__aux);	\
-	(low) = (u32)__val;				\
-	(high) = (u32)(__val >> 32);			\
-	(aux) = __aux;					\
-} while (0)
-
-#define rdtscpll(val, aux)				\
-do {							\
-	unsigned long __aux; 				\
-	val = paravirt_rdtscp(&__aux);			\
-	(aux) = __aux;					\
-} while (0)
-
 static inline void paravirt_alloc_ldt(struct desc_struct *ldt, unsigned entries)
 {
 	PVOP_VCALL2(pv_cpu_ops.alloc_ldt, ldt, entries);
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 142236e..d6cf0d2 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -157,7 +157,6 @@ struct pv_cpu_ops {
 
 	u64 (*read_tsc)(void);
 	u64 (*read_pmc)(int counter);
-	unsigned long long (*read_tscp)(unsigned int *aux);
 
 	/*
 	 * Atomically enable interrupts and return to userspace.  This
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 17fff18..012d6c1 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -355,7 +355,6 @@ struct pv_cpu_ops pv_cpu_ops = {
 	.write_msr = native_write_msr_safe,
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
-	.read_tscp = native_read_tscp,
 	.load_tr_desc = native_load_tr_desc,
 	.set_ldt = native_set_ldt,
 	.load_gdt = native_load_gdt,
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 586d838..355341f 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1176,8 +1176,6 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
 
-	.read_tscp = native_read_tscp,
-
 	.iret = xen_iret,
 	.irq_enable_sysexit = xen_sysexit,
 #ifdef CONFIG_X86_64
-- 
1.7.7.6

