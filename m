Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965885Ab2EQAT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 20:19:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57015 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965369Ab2EQAT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 20:19:27 -0400
Date: Wed, 16 May 2012 17:19:15 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-1dcc8d7ba235a316a056f993e88f0d18b92c60d9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, suresh.b.siddha@intel.com,
        oleg@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, oleg@redhat.com, hpa@linux.intel.com
In-Reply-To: <1336692811-30576-4-git-send-email-suresh.b.siddha@intel.com>
References: <1336692811-30576-4-git-send-email-suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: drop the fpu state during thread exit
Git-Commit-ID: 1dcc8d7ba235a316a056f993e88f0d18b92c60d9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 16 May 2012 17:19:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1dcc8d7ba235a316a056f993e88f0d18b92c60d9
Gitweb:     http://git.kernel.org/tip/1dcc8d7ba235a316a056f993e88f0d18b92c60d9
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 16 May 2012 15:03:54 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 16 May 2012 15:20:59 -0700

x86, fpu: drop the fpu state during thread exit

There is no need to save any active fpu state to the task structure
memory if the task is dead. Just drop the state instead.

For example, this saved some 1770 xsave's during the system boot
of a two socket Xeon system.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1336692811-30576-4-git-send-email-suresh.b.siddha@intel.com
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
