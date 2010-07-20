Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967517Ab0GTBwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 21:52:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:44408 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967455Ab0GTBwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 21:52:39 -0400
Date: Tue, 20 Jul 2010 01:52:22 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100719230205.604014179@sbs-t61.sc.intel.com>
References: <20100719230205.604014179@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86, xsave: Use xsaveopt in context-switch path when supported
Message-ID: <tip-6bad06b768920e278c7cedfdda56a0b4c6a35ee9@git.kernel.org>
Git-Commit-ID: 6bad06b768920e278c7cedfdda56a0b4c6a35ee9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Jul 2010 01:52:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6bad06b768920e278c7cedfdda56a0b4c6a35ee9
Gitweb:     http://git.kernel.org/tip/6bad06b768920e278c7cedfdda56a0b4c6a35ee9
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 19 Jul 2010 16:05:52 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 19 Jul 2010 17:52:24 -0700

x86, xsave: Use xsaveopt in context-switch path when supported

xsaveopt is a more optimized form of xsave specifically designed
for the context switch usage. xsaveopt doesn't save the state that's not
modified from the prior xrstor. And if a specific feature state gets
modified to the init state, then xsaveopt just updates the header bit
in the xsave memory layout without updating the corresponding memory
layout.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20100719230205.604014179@sbs-t61.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/i387.h  |    2 +-
 arch/x86/include/asm/xsave.h |    9 ++++++---
 arch/x86/kernel/cpu/common.c |    8 ++++++++
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index bb370fd..59bd93a 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -60,7 +60,7 @@ extern int restore_i387_xstate_ia32(void __user *buf);
 
 static __always_inline __pure bool use_xsaveopt(void)
 {
-	return 0;
+	return static_cpu_has(X86_FEATURE_XSAVEOPT);
 }
 
 static __always_inline __pure bool use_xsave(void)
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 0c72adc..ec86c5f 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -125,8 +125,11 @@ static inline void fpu_xsave(struct fpu *fpu)
 {
 	/* This, however, we can work around by forcing the compiler to select
 	   an addressing mode that doesn't require extended registers. */
-	__asm__ __volatile__(".byte " REX_PREFIX "0x0f,0xae,0x27"
-			     : : "D" (&(fpu->state->xsave)),
-				 "a" (-1), "d"(-1) : "memory");
+	alternative_input(
+		".byte " REX_PREFIX "0x0f,0xae,0x27",
+		".byte " REX_PREFIX "0x0f,0xae,0x37",
+		X86_FEATURE_XSAVEOPT,
+		[fx] "D" (&fpu->state->xsave), "a" (-1), "d" (-1) :
+		"memory");
 }
 #endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c735830..3f715ef 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -140,10 +140,18 @@ EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 static int __init x86_xsave_setup(char *s)
 {
 	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
+	setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
 	return 1;
 }
 __setup("noxsave", x86_xsave_setup);
 
+static int __init x86_xsaveopt_setup(char *s)
+{
+	setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
+	return 1;
+}
+__setup("noxsaveopt", x86_xsaveopt_setup);
+
 #ifdef CONFIG_X86_32
 static int cachesize_override __cpuinitdata = -1;
 static int disable_x86_serial_nr __cpuinitdata = 1;
