Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab0ENDSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 23:18:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:3164 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab0ENDSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 23:18:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,226,1272870000"; 
   d="scan'208";a="567057704"
From: Sheng Yang <sheng@linux.intel.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 2/3] x86: Export FPU API for KVM use
Date: Fri, 14 May 2010 11:16:52 +0800
Message-Id: <1273807013-4792-3-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273807013-4792-1-git-send-email-sheng@linux.intel.com>
References: <1273807013-4792-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also add some more constants.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---

Do we need to rename "task_xstate_cachep"? It's not only for task struct now.

 arch/x86/include/asm/i387.h  |    2 ++
 arch/x86/include/asm/xsave.h |    3 +++
 arch/x86/kernel/i387.c       |    3 ++-
 arch/x86/kernel/process.c    |    1 +
 4 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 989d3b7..f19bdf9 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -503,6 +503,8 @@ static inline void fpu_copy(struct fpu *dst, struct fpu *src)
 	memcpy(dst->state, src->state, xstate_size);
 }
 
+extern void fpu_finit(struct fpu *fpu);
+
 #endif /* __ASSEMBLY__ */
 
 #define PSHUFB_XMM5_XMM0 .byte 0x66, 0x0f, 0x38, 0x00, 0xc5
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 2c4390c..29ee4e4 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -13,6 +13,9 @@
 
 #define FXSAVE_SIZE	512
 
+#define XSTATE_YMM_SIZE 256
+#define XSTATE_YMM_OFFSET (512 + 64)
+
 /*
  * These are the features that the OS can handle currently.
  */
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 86cef6b..c4444bc 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -107,7 +107,7 @@ void __cpuinit fpu_init(void)
 }
 #endif	/* CONFIG_X86_64 */
 
-static void fpu_finit(struct fpu *fpu)
+void fpu_finit(struct fpu *fpu)
 {
 #ifdef CONFIG_X86_32
 	if (!HAVE_HWFP) {
@@ -132,6 +132,7 @@ static void fpu_finit(struct fpu *fpu)
 		fp->fos = 0xffff0000u;
 	}
 }
+EXPORT_SYMBOL_GPL(fpu_finit);
 
 /*
  * The _current_ task is using the FPU for the first time
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 8bcc21f..373fec9 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -28,6 +28,7 @@ unsigned long idle_nomwait;
 EXPORT_SYMBOL(idle_nomwait);
 
 struct kmem_cache *task_xstate_cachep;
+EXPORT_SYMBOL(task_xstate_cachep);
 
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
-- 
1.7.0.1

