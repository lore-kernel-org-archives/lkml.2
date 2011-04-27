Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab1D0O0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:26:52 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.186]:12980
	"EHLO CH1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752305Ab1D0O0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:26:50 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LKBESG-01-GUU-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>
CC: <brgerst@gmail.com>, <tglx@linutronix.de>, <mingo@elte.hu>,
        <suresh.b.siddha@intel.com>, <eranian@google.com>,
        <robert.richter@amd.com>, <Andreas.Herrmann3@amd.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 1/2] x86, xsave: fix non-lazy allocation of the xsave area
Date: Wed, 27 Apr 2011 16:26:34 +0200
Message-ID: <1303914395-841373-1-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <2be7032a-e4b6-4ce7-af53-532d77dbfb48@email.android.com>
References: <2be7032a-e4b6-4ce7-af53-532d77dbfb48@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A single static xsave area just for init is not enough, since there are
more user processes that are directly executed by kernel threads. Add a
call to a new arch-specific function to flush_old_exec(), which will in
turn call fpu_alloc() to allocate a xsave area if necessary.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/i387.h        |    6 ------
 arch/x86/include/asm/thread_info.h |    2 ++
 arch/x86/kernel/process.c          |    7 +++++++
 fs/exec.c                          |    8 ++++++++
 4 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 989c0ac..0448f45 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -329,15 +329,9 @@ static inline void fpu_copy(struct fpu *dst, struct fpu *src)
 }
 
 extern void fpu_finit(struct fpu *fpu);
-static union thread_xstate __init_xstate, *init_xstate = &__init_xstate;
 
 static inline void fpu_clear(struct fpu *fpu)
 {
-	if (!fpu_allocated(fpu)) {
-		BUG_ON(init_xstate == NULL);
-		fpu->state = init_xstate;
-		init_xstate = NULL;
-	}
 	memset(fpu->state, 0, xstate_size);
 	fpu_finit(fpu);
 	set_used_math();
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 0e691c6..07c8cfe 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -265,6 +265,8 @@ static inline void set_restore_sigmask(void)
 extern void arch_task_cache_init(void);
 extern void free_thread_info(struct thread_info *ti);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
+extern int arch_prealloc_fpu(struct task_struct *tsk);
+#define arch_prealloc_fpu arch_prealloc_fpu
 #define arch_task_cache_init arch_task_cache_init
 #endif
 #endif /* _ASM_X86_THREAD_INFO_H */
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 0382f98..3edfbf2 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -26,6 +26,13 @@
 struct kmem_cache *task_xstate_cachep;
 EXPORT_SYMBOL_GPL(task_xstate_cachep);
 
+int arch_prealloc_fpu(struct task_struct *tsk)
+{
+	if (!fpu_allocated(&tsk->thread.fpu))
+		return fpu_alloc(&tsk->thread.fpu);
+	return 0;
+}
+
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
 	int ret;
diff --git a/fs/exec.c b/fs/exec.c
index 5e62d26..932b9ad 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1022,10 +1022,18 @@ void set_task_comm(struct task_struct *tsk, char *buf)
 	perf_event_comm(tsk);
 }
 
+#if !defined(arch_prealloc_fpu)
+#define arch_prealloc_fpu(tsk) (0)
+#endif
+
 int flush_old_exec(struct linux_binprm * bprm)
 {
 	int retval;
 
+	retval = arch_prealloc_fpu(current);
+	if (retval)
+		goto out;
+
 	/*
 	 * Make sure we have a private signal table and that
 	 * we are unassociated from the previous thread group.
-- 
1.5.6.5


