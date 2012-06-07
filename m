Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094Ab2FGV7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 17:59:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52410 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933036Ab2FGV7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 17:59:01 -0400
Date: Thu, 7 Jun 2012 14:58:45 -0700
From: tip-bot for Andre Przywara <andre.przywara@amd.com>
Message-ID: <tip-1f975f78c84c852e09463a2dfa57e3174e5c719e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, andre.przywara@amd.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, andre.przywara@amd.com, tglx@linutronix.de
In-Reply-To: <1338562358-28182-2-git-send-email-bp@amd64.org>
References: <1338562358-28182-2-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, pvops: Remove hooks for {rd,wr}msr_safe_regs
Git-Commit-ID: 1f975f78c84c852e09463a2dfa57e3174e5c719e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 07 Jun 2012 14:58:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f975f78c84c852e09463a2dfa57e3174e5c719e
Gitweb:     http://git.kernel.org/tip/1f975f78c84c852e09463a2dfa57e3174e5c719e
Author:     Andre Przywara <andre.przywara@amd.com>
AuthorDate: Fri, 1 Jun 2012 16:52:35 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 7 Jun 2012 11:41:08 -0700

x86, pvops: Remove hooks for {rd,wr}msr_safe_regs

There were paravirt_ops hooks for the full register set variant of
{rd,wr}msr_safe which are actually not used by anyone anymore. Remove
them to make the code cleaner and avoid silent breakages when the pvops
members were uninitialized. This has been boot-tested natively and under
Xen with PVOPS enabled and disabled on one machine.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Link: http://lkml.kernel.org/r/1338562358-28182-2-git-send-email-bp@amd64.org
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/msr.h            |   67 ++++++++++++++-------------------
 arch/x86/include/asm/paravirt.h       |   39 -------------------
 arch/x86/include/asm/paravirt_types.h |    2 -
 arch/x86/kernel/paravirt.c            |    2 -
 arch/x86/lib/msr-reg-export.c         |    4 +-
 arch/x86/lib/msr-reg.S                |   10 ++--
 arch/x86/xen/enlighten.c              |    2 -
 7 files changed, 35 insertions(+), 91 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 084ef95..81860cc 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -115,8 +115,8 @@ notrace static inline int native_write_msr_safe(unsigned int msr,
 
 extern unsigned long long native_read_tsc(void);
 
-extern int native_rdmsr_safe_regs(u32 regs[8]);
-extern int native_wrmsr_safe_regs(u32 regs[8]);
+extern int rdmsr_safe_regs(u32 regs[8]);
+extern int wrmsr_safe_regs(u32 regs[8]);
 
 static __always_inline unsigned long long __native_read_tsc(void)
 {
@@ -187,43 +187,6 @@ static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
 	return err;
 }
 
-static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
-{
-	u32 gprs[8] = { 0 };
-	int err;
-
-	gprs[1] = msr;
-	gprs[7] = 0x9c5a203a;
-
-	err = native_rdmsr_safe_regs(gprs);
-
-	*p = gprs[0] | ((u64)gprs[2] << 32);
-
-	return err;
-}
-
-static inline int wrmsrl_amd_safe(unsigned msr, unsigned long long val)
-{
-	u32 gprs[8] = { 0 };
-
-	gprs[0] = (u32)val;
-	gprs[1] = msr;
-	gprs[2] = val >> 32;
-	gprs[7] = 0x9c5a203a;
-
-	return native_wrmsr_safe_regs(gprs);
-}
-
-static inline int rdmsr_safe_regs(u32 regs[8])
-{
-	return native_rdmsr_safe_regs(regs);
-}
-
-static inline int wrmsr_safe_regs(u32 regs[8])
-{
-	return native_wrmsr_safe_regs(regs);
-}
-
 #define rdtscl(low)						\
 	((low) = (u32)__native_read_tsc())
 
@@ -248,6 +211,32 @@ do {                                                            \
 
 #endif	/* !CONFIG_PARAVIRT */
 
+static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
+{
+	u32 gprs[8] = { 0 };
+	int err;
+
+	gprs[1] = msr;
+	gprs[7] = 0x9c5a203a;
+
+	err = rdmsr_safe_regs(gprs);
+
+	*p = gprs[0] | ((u64)gprs[2] << 32);
+
+	return err;
+}
+
+static inline int wrmsrl_amd_safe(unsigned msr, unsigned long long val)
+{
+	u32 gprs[8] = { 0 };
+
+	gprs[0] = (u32)val;
+	gprs[1] = msr;
+	gprs[2] = val >> 32;
+	gprs[7] = 0x9c5a203a;
+
+	return wrmsr_safe_regs(gprs);
+}
 
 #define checking_wrmsrl(msr, val) wrmsr_safe((msr), (u32)(val),		\
 					     (u32)((val) >> 32))
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 6cbbabf..ebb0cdb 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -128,21 +128,11 @@ static inline u64 paravirt_read_msr(unsigned msr, int *err)
 	return PVOP_CALL2(u64, pv_cpu_ops.read_msr, msr, err);
 }
 
-static inline int paravirt_rdmsr_regs(u32 *regs)
-{
-	return PVOP_CALL1(int, pv_cpu_ops.rdmsr_regs, regs);
-}
-
 static inline int paravirt_write_msr(unsigned msr, unsigned low, unsigned high)
 {
 	return PVOP_CALL3(int, pv_cpu_ops.write_msr, msr, low, high);
 }
 
-static inline int paravirt_wrmsr_regs(u32 *regs)
-{
-	return PVOP_CALL1(int, pv_cpu_ops.wrmsr_regs, regs);
-}
-
 /* These should all do BUG_ON(_err), but our headers are too tangled. */
 #define rdmsr(msr, val1, val2)			\
 do {						\
@@ -176,9 +166,6 @@ do {						\
 	_err;					\
 })
 
-#define rdmsr_safe_regs(regs)	paravirt_rdmsr_regs(regs)
-#define wrmsr_safe_regs(regs)	paravirt_wrmsr_regs(regs)
-
 static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
 {
 	int err;
@@ -186,32 +173,6 @@ static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
 	*p = paravirt_read_msr(msr, &err);
 	return err;
 }
-static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
-{
-	u32 gprs[8] = { 0 };
-	int err;
-
-	gprs[1] = msr;
-	gprs[7] = 0x9c5a203a;
-
-	err = paravirt_rdmsr_regs(gprs);
-
-	*p = gprs[0] | ((u64)gprs[2] << 32);
-
-	return err;
-}
-
-static inline int wrmsrl_amd_safe(unsigned msr, unsigned long long val)
-{
-	u32 gprs[8] = { 0 };
-
-	gprs[0] = (u32)val;
-	gprs[1] = msr;
-	gprs[2] = val >> 32;
-	gprs[7] = 0x9c5a203a;
-
-	return paravirt_wrmsr_regs(gprs);
-}
 
 static inline u64 paravirt_read_tsc(void)
 {
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 8e8b9a4..8613cbb 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -153,9 +153,7 @@ struct pv_cpu_ops {
 	/* MSR, PMC and TSR operations.
 	   err = 0/-EFAULT.  wrmsr returns 0/-EFAULT. */
 	u64 (*read_msr)(unsigned int msr, int *err);
-	int (*rdmsr_regs)(u32 *regs);
 	int (*write_msr)(unsigned int msr, unsigned low, unsigned high);
-	int (*wrmsr_regs)(u32 *regs);
 
 	u64 (*read_tsc)(void);
 	u64 (*read_pmc)(int counter);
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 9ce8859..17fff18 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -352,9 +352,7 @@ struct pv_cpu_ops pv_cpu_ops = {
 #endif
 	.wbinvd = native_wbinvd,
 	.read_msr = native_read_msr_safe,
-	.rdmsr_regs = native_rdmsr_safe_regs,
 	.write_msr = native_write_msr_safe,
-	.wrmsr_regs = native_wrmsr_safe_regs,
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
 	.read_tscp = native_read_tscp,
diff --git a/arch/x86/lib/msr-reg-export.c b/arch/x86/lib/msr-reg-export.c
index a311cc5..8d6ef78 100644
--- a/arch/x86/lib/msr-reg-export.c
+++ b/arch/x86/lib/msr-reg-export.c
@@ -1,5 +1,5 @@
 #include <linux/module.h>
 #include <asm/msr.h>
 
-EXPORT_SYMBOL(native_rdmsr_safe_regs);
-EXPORT_SYMBOL(native_wrmsr_safe_regs);
+EXPORT_SYMBOL(rdmsr_safe_regs);
+EXPORT_SYMBOL(wrmsr_safe_regs);
diff --git a/arch/x86/lib/msr-reg.S b/arch/x86/lib/msr-reg.S
index 69fa106..f6d13ee 100644
--- a/arch/x86/lib/msr-reg.S
+++ b/arch/x86/lib/msr-reg.S
@@ -6,13 +6,13 @@
 
 #ifdef CONFIG_X86_64
 /*
- * int native_{rdmsr,wrmsr}_safe_regs(u32 gprs[8]);
+ * int {rdmsr,wrmsr}_safe_regs(u32 gprs[8]);
  *
  * reg layout: u32 gprs[eax, ecx, edx, ebx, esp, ebp, esi, edi]
  *
  */
 .macro op_safe_regs op
-ENTRY(native_\op\()_safe_regs)
+ENTRY(\op\()_safe_regs)
 	CFI_STARTPROC
 	pushq_cfi %rbx
 	pushq_cfi %rbp
@@ -45,13 +45,13 @@ ENTRY(native_\op\()_safe_regs)
 
 	_ASM_EXTABLE(1b, 3b)
 	CFI_ENDPROC
-ENDPROC(native_\op\()_safe_regs)
+ENDPROC(\op\()_safe_regs)
 .endm
 
 #else /* X86_32 */
 
 .macro op_safe_regs op
-ENTRY(native_\op\()_safe_regs)
+ENTRY(\op\()_safe_regs)
 	CFI_STARTPROC
 	pushl_cfi %ebx
 	pushl_cfi %ebp
@@ -92,7 +92,7 @@ ENTRY(native_\op\()_safe_regs)
 
 	_ASM_EXTABLE(1b, 3b)
 	CFI_ENDPROC
-ENDPROC(native_\op\()_safe_regs)
+ENDPROC(\op\()_safe_regs)
 .endm
 
 #endif
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index e74df95..60f1131 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1116,9 +1116,7 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.wbinvd = native_wbinvd,
 
 	.read_msr = native_read_msr_safe,
-	.rdmsr_regs = native_rdmsr_safe_regs,
 	.write_msr = xen_write_msr_safe,
-	.wrmsr_regs = native_wrmsr_safe_regs,
 
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
