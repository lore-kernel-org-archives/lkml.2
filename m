Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681Ab0IJByE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 21:54:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:48290 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757659Ab0IJByB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 21:54:01 -0400
Date: Fri, 10 Sep 2010 01:47:35 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1283563039-3466-6-git-send-email-brgerst@gmail.com>
References: <1283563039-3466-6-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86-64, fpu: Disable preemption when using TS_USEDFPU
Message-ID: <tip-a4d4fbc7735bba6654b20f859135f9d3f8fe7f76@git.kernel.org>
Git-Commit-ID: a4d4fbc7735bba6654b20f859135f9d3f8fe7f76
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 01:47:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a4d4fbc7735bba6654b20f859135f9d3f8fe7f76
Gitweb:     http://git.kernel.org/tip/a4d4fbc7735bba6654b20f859135f9d3f8fe7f76
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Fri, 3 Sep 2010 21:17:12 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 9 Sep 2010 14:16:45 -0700

x86-64, fpu: Disable preemption when using TS_USEDFPU

Consolidates code and fixes the below race for 64-bit.

commit 9fa2f37bfeb798728241cc4a19578ce6e4258f25
Author: torvalds <torvalds>
Date:   Tue Sep 2 07:37:25 2003 +0000

    Be a lot more careful about TS_USEDFPU and preemption

    We had some races where we testecd (or set) TS_USEDFPU together
    with sequences that depended on the setting (like clearing or
    setting the TS flag in %cr0) and we could be preempted in between,
    which screws up the FPU state, since preemption will itself change
    USEDFPU and the TS flag.

    This makes it a lot more explicit: the "internal" low-level FPU
    functions ("__xxxx_fpu()") all require preemption to be disabled,
    and the exported "real" functions will make sure that is the case.

    One case - in __switch_to() - was switched to the non-preempt-safe
    internal version, since the scheduler itself has already disabled
    preemption.

    BKrev: 3f5448b5WRiQuyzAlbajs3qoQjSobw

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1283563039-3466-6-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/i387.h  |   15 ---------------
 arch/x86/kernel/process_64.c |    2 +-
 2 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 88065e3..8b40a83 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -387,19 +387,6 @@ static inline void irq_ts_restore(int TS_state)
 		stts();
 }
 
-#ifdef CONFIG_X86_64
-
-static inline void save_init_fpu(struct task_struct *tsk)
-{
-	__save_init_fpu(tsk);
-	stts();
-}
-
-#define unlazy_fpu	__unlazy_fpu
-#define clear_fpu	__clear_fpu
-
-#else  /* CONFIG_X86_32 */
-
 /*
  * These disable preemption on their own and are safe
  */
@@ -425,8 +412,6 @@ static inline void clear_fpu(struct task_struct *tsk)
 	preempt_enable();
 }
 
-#endif	/* CONFIG_X86_64 */
-
 /*
  * i387 state interaction
  */
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3d9ea53..b3d7a3a 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -424,7 +424,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	load_TLS(next, cpu);
 
 	/* Must be after DS reload */
-	unlazy_fpu(prev_p);
+	__unlazy_fpu(prev_p);
 
 	/* Make sure cpu is ready for new context */
 	if (preload_fpu)
