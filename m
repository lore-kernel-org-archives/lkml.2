Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab2FGWBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 18:01:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52456 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558Ab2FGWBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 18:01:35 -0400
Date: Thu, 7 Jun 2012 15:01:23 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-2c929ce6f1ed1302be225512b433e6a6554f71a4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <1338562358-28182-5-git-send-email-bp@amd64.org>
References: <1338562358-28182-5-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu, amd: Deprecate AMD-specific MSR variants
Git-Commit-ID: 2c929ce6f1ed1302be225512b433e6a6554f71a4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 07 Jun 2012 15:01:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c929ce6f1ed1302be225512b433e6a6554f71a4
Gitweb:     http://git.kernel.org/tip/2c929ce6f1ed1302be225512b433e6a6554f71a4
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Fri, 1 Jun 2012 16:52:38 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 7 Jun 2012 11:43:30 -0700

x86, cpu, amd: Deprecate AMD-specific MSR variants

Now that all users of {rd,wr}msr_amd_safe have been fixed, deprecate its
use by making them private to amd.c and adding warnings when used on
anything else beside K8.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1338562358-28182-5-git-send-email-bp@amd64.org
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/msr.h |   27 ---------------------------
 arch/x86/kernel/cpu/amd.c  |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 81860cc..cb33b5f 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -211,33 +211,6 @@ do {                                                            \
 
 #endif	/* !CONFIG_PARAVIRT */
 
-static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
-{
-	u32 gprs[8] = { 0 };
-	int err;
-
-	gprs[1] = msr;
-	gprs[7] = 0x9c5a203a;
-
-	err = rdmsr_safe_regs(gprs);
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
-	return wrmsr_safe_regs(gprs);
-}
-
 #define checking_wrmsrl(msr, val) wrmsr_safe((msr), (u32)(val),		\
 					     (u32)((val) >> 32))
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 80ccd99..c928eb2 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -19,6 +19,39 @@
 
 #include "cpu.h"
 
+static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
+{
+	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
+	u32 gprs[8] = { 0 };
+	int err;
+
+	WARN_ONCE((c->x86 != 0xf), "%s should only be used on K8!\n", __func__);
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
+	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
+	u32 gprs[8] = { 0 };
+
+	WARN_ONCE((c->x86 != 0xf), "%s should only be used on K8!\n", __func__);
+
+	gprs[0] = (u32)val;
+	gprs[1] = msr;
+	gprs[2] = val >> 32;
+	gprs[7] = 0x9c5a203a;
+
+	return wrmsr_safe_regs(gprs);
+}
+
 #ifdef CONFIG_X86_32
 /*
  *	B step AMD K6 before B 9730xxxx have hardware bugs that can cause
