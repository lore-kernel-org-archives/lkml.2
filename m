Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab1DOQre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 12:47:34 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:38056 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753287Ab1DOQrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 12:47:32 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJPDB2-01-133-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>
CC: <brgerst@gmail.com>, <tglx@linutronix.de>, <mingo@elte.hu>,
        <suresh.b.siddha@intel.com>, <eranian@google.com>,
        <robert.richter@amd.com>, <Andreas.Herrmann3@amd.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 1/1] x86, xsave: fix non-lazy allocation of the xsave area
Date: Fri, 15 Apr 2011 18:47:22 +0200
Message-ID: <1302886042-612207-1-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <4DA63012.2090307@zytor.com>
References: <4DA63012.2090307@zytor.com>
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
 arch/x86/include/asm/i387.h |    6 ------
 arch/x86/kernel/process.c   |    7 +++++++
 fs/exec.c                   |    9 +++++++++
 3 files changed, 16 insertions(+), 6 deletions(-)

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
index 5e62d26..c5b5c1e 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1022,10 +1022,19 @@ void set_task_comm(struct task_struct *tsk, char *buf)
 	perf_event_comm(tsk);
 }
 
+int __attribute__((weak)) arch_prealloc_fpu(struct task_struct *tsk)
+{
+	return 0;
+}
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


