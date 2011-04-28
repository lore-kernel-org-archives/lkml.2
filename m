Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1D1Fz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 01:55:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:60553 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab1D1Fz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 01:55:26 -0400
Date: Thu, 28 Apr 2011 05:55:14 GMT
From: tip-bot for Hans Rosenfeld <hans.rosenfeld@amd.com>
Message-ID: <tip-300c6120b4653043e8a80b24e0483c0d223c5aac@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hans.rosenfeld@amd.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, hans.rosenfeld@amd.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1303914395-841373-1-git-send-email-hans.rosenfeld@amd.com>
References: <1303914395-841373-1-git-send-email-hans.rosenfeld@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86, xsave: fix non-lazy allocation of the xsave area
Git-Commit-ID: 300c6120b4653043e8a80b24e0483c0d223c5aac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 28 Apr 2011 05:55:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  300c6120b4653043e8a80b24e0483c0d223c5aac
Gitweb:     http://git.kernel.org/tip/300c6120b4653043e8a80b24e0483c0d223c5aac
Author:     Hans Rosenfeld <hans.rosenfeld@amd.com>
AuthorDate: Wed, 27 Apr 2011 16:26:34 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 27 Apr 2011 18:03:45 -0700

x86, xsave: fix non-lazy allocation of the xsave area

A single static xsave area just for init is not enough, since there are
more user processes that are directly executed by kernel threads. Add a
call to a new arch-specific function to flush_old_exec(), which will in
turn call fpu_alloc() to allocate a xsave area if necessary.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
Link: http://lkml.kernel.org/r/1303914395-841373-1-git-send-email-hans.rosenfeld@amd.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/i387.h        |    6 ------
 arch/x86/include/asm/thread_info.h |    2 ++
 arch/x86/kernel/process.c          |    7 +++++++
 fs/exec.c                          |    8 ++++++++
 4 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index f410d16..41f1d7e 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -327,15 +327,9 @@ static inline void fpu_copy(struct fpu *dst, struct fpu *src)
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
index d46cbe4..a70f620 100644
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
