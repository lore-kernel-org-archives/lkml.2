Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab1DFWGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:06:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:50735 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab1DFWGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:06:14 -0400
Date: Wed, 6 Apr 2011 22:05:59 GMT
From: tip-bot for Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: linux-kernel@vger.kernel.org, hans.rosenfeld@amd.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, hans.rosenfeld@amd.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: 1302018656-586370-7-git-send-email-hans.rosenfeld@amd.com
References: 1302018656-586370-7-git-send-email-hans.rosenfeld@amd.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86, xsave: add support for non-lazy xstates
Message-ID: <tip-4182a4d68bac5782bf76743193c1d9f7d17a34a4@git.kernel.org>
Git-Commit-ID: 4182a4d68bac5782bf76743193c1d9f7d17a34a4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 06 Apr 2011 22:05:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4182a4d68bac5782bf76743193c1d9f7d17a34a4
Gitweb:     http://git.kernel.org/tip/4182a4d68bac5782bf76743193c1d9f7d17a34a4
Author:     Hans Rosenfeld <hans.rosenfeld@amd.com>
AuthorDate: Tue, 5 Apr 2011 17:50:54 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 6 Apr 2011 14:15:19 -0700

x86, xsave: add support for non-lazy xstates

Non-lazy xstates are, as the name suggests, extended states that cannot
be saved or restored lazily. The state for AMDs LWP feature is an
example of this.

This patch adds support for this kind of xstates. If any such states are
present and supported on the running system, they will always be enabled
in xstate_mask so that they are always restored in switch_to. Since lazy
allocation of the xstate area won't work when non-lazy xstates are used,
all user tasks will always have a xstate area preallocated.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
Link: http://lkml.kernel.org/r/1302018656-586370-7-git-send-email-hans.rosenfeld@amd.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/i387.h  |   17 +++++++++++++++++
 arch/x86/include/asm/xsave.h |    5 +++--
 arch/x86/kernel/process_32.c |    2 +-
 arch/x86/kernel/process_64.c |    2 +-
 arch/x86/kernel/xsave.c      |    6 +++++-
 5 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 0381578..da55ab6 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -329,6 +329,23 @@ static inline void fpu_copy(struct fpu *dst, struct fpu *src)
 }
 
 extern void fpu_finit(struct fpu *fpu);
+static union thread_xstate __init_xstate, *init_xstate = &__init_xstate;
+
+static inline void fpu_clear(struct fpu *fpu)
+{
+	if (pcntxt_mask & XCNTXT_NONLAZY) {
+		if (!fpu_allocated(fpu)) {
+			BUG_ON(init_xstate == NULL);
+			fpu->state = init_xstate;
+			init_xstate = NULL;
+		}
+		memset(fpu->state, 0, xstate_size);
+		fpu_finit(fpu);
+		set_used_math();
+	} else {
+		fpu_free(fpu);
+	}
+}
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index b8861d4..4ccee3c 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -23,9 +23,10 @@
 /*
  * These are the features that the OS can handle currently.
  */
-#define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
+#define XCNTXT_LAZY	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
+#define XCNTXT_NONLAZY	0
 
-#define XCNTXT_LAZY	XCNTXT_MASK
+#define XCNTXT_MASK	(XCNTXT_LAZY | XCNTXT_NONLAZY)
 
 #ifdef CONFIG_X86_64
 #define REX_PREFIX	"0x48, "
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 8df07c3..a878736 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -257,7 +257,7 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 	/*
 	 * Free the old FP and other extended state
 	 */
-	free_thread_xstate(current);
+	fpu_clear(&current->thread.fpu);
 }
 EXPORT_SYMBOL_GPL(start_thread);
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index cbf1a67..8ff35fc 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -344,7 +344,7 @@ start_thread_common(struct pt_regs *regs, unsigned long new_ip,
 	/*
 	 * Free the old FP and other extended state
 	 */
-	free_thread_xstate(current);
+	fpu_clear(&current->thread.fpu);
 }
 
 void
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index d42810f..56ab3d3 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -16,6 +16,7 @@
  * Supported feature mask by the CPU and the kernel.
  */
 u64 pcntxt_mask;
+EXPORT_SYMBOL(pcntxt_mask);
 
 /*
  * Represents init state for the supported extended state.
@@ -260,7 +261,7 @@ int restore_xstates_sigframe(void __user *buf, unsigned int size)
 	struct task_struct *tsk = current;
 	struct _fpstate_ia32 __user *fp = buf;
 	struct xsave_struct *xsave;
-	u64 xstate_mask = 0;
+	u64 xstate_mask = pcntxt_mask & XCNTXT_NONLAZY;
 	int err;
 
 	if (!buf) {
@@ -477,6 +478,9 @@ static void __init xstate_enable_boot_cpu(void)
 	printk(KERN_INFO "xsave/xrstor: enabled xstate_bv 0x%llx, "
 	       "cntxt size 0x%x\n",
 	       pcntxt_mask, xstate_size);
+
+	if (pcntxt_mask & XCNTXT_NONLAZY)
+		task_thread_info(&init_task)->xstate_mask |= XCNTXT_NONLAZY;
 }
 
 /*
