Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab2EHXPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 19:15:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:37903 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757141Ab2EHXPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 19:15:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="138405397"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        oleg@redhat.com
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        suresh@aristanetworks.com
Subject: [PATCH 3/3] x86, fpu: clear the fpu state during thread exit
Date: Tue,  8 May 2012 16:18:05 -0700
Message-Id: <1336519085-27450-4-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1336519085-27450-1-git-send-email-suresh.b.siddha@intel.com>
References: <1336421341.19423.4.camel@sbsiddha-desk.sc.intel.com>
 <1336519085-27450-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to save any active fpu state to the task structure
memory if the task is dead. Just clear the state instead.

For example, this saved some 1770 xsave's during the system boot
of a two socket Xeon system.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/process.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1d92a5a..1c7566e 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -81,6 +81,16 @@ void arch_task_cache_init(void)
 				  SLAB_PANIC | SLAB_NOTRACK, NULL);
 }
 
+static inline void flush_fpu(struct task_struct *tsk)
+{
+	/*
+	 * Forget coprocessor state..
+	 */
+	tsk->fpu_counter = 0;
+	clear_fpu(tsk);
+	clear_used_math();
+}
+
 /*
  * Free current thread data structures etc..
  */
@@ -103,6 +113,8 @@ void exit_thread(void)
 		put_cpu();
 		kfree(bp);
 	}
+
+	flush_fpu(me);
 }
 
 void show_regs(struct pt_regs *regs)
@@ -143,12 +155,7 @@ void flush_thread(void)
 
 	flush_ptrace_hw_breakpoint(tsk);
 	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
-	/*
-	 * Forget coprocessor state..
-	 */
-	tsk->fpu_counter = 0;
-	clear_fpu(tsk);
-	clear_used_math();
+	flush_fpu(tsk);
 }
 
 static void hard_disable_TSC(void)
-- 
1.7.6.5

