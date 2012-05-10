Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab2EJXa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:30:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:18333 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932879Ab2EJXad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:30:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164690668"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        oleg@redhat.com
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        suresh@aristanetworks.com
Subject: [PATCH v2 4/4] x86, fpu: drop the fpu state during thread exit
Date: Thu, 10 May 2012 16:33:31 -0700
Message-Id: <1336692811-30576-4-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1336692811-30576-1-git-send-email-suresh.b.siddha@intel.com>
References: <CA+55aFwNST_Lhou1h9JWkg348BET7CbqNX50XYPOFNbXioXdxg@mail.gmail.com>
 <1336692811-30576-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to save any active fpu state to the task structure
memory if the task is dead. Just drop the state instead.

For example, this saved some 1770 xsave's during the system boot
of a two socket Xeon system.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/process.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index b7e1e0e..1219fe2 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -87,6 +87,16 @@ void arch_task_cache_init(void)
 				  SLAB_PANIC | SLAB_NOTRACK, NULL);
 }
 
+static inline void drop_fpu(struct task_struct *tsk)
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
@@ -109,6 +119,8 @@ void exit_thread(void)
 		put_cpu();
 		kfree(bp);
 	}
+
+	drop_fpu(me);
 }
 
 void show_regs(struct pt_regs *regs)
@@ -149,12 +161,7 @@ void flush_thread(void)
 
 	flush_ptrace_hw_breakpoint(tsk);
 	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
-	/*
-	 * Forget coprocessor state..
-	 */
-	tsk->fpu_counter = 0;
-	clear_fpu(tsk);
-	clear_used_math();
+	drop_fpu(tsk);
 }
 
 static void hard_disable_TSC(void)
-- 
1.7.6.5

