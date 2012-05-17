Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965602Ab2EQASl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 20:18:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56996 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964975Ab2EQASi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 20:18:38 -0400
Date: Wed, 16 May 2012 17:18:26 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-d75f1b391f5ef73016d14bc6f7e4725820ebaa5b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, suresh.b.siddha@intel.com,
        oleg@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, oleg@redhat.com, hpa@linux.intel.com
In-Reply-To: <1336692811-30576-3-git-send-email-suresh.b.siddha@intel.com>
References: <1336692811-30576-3-git-send-email-suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, xsave: remove thread_has_fpu()
  bug check in __sanitize_i387_state()
Git-Commit-ID: d75f1b391f5ef73016d14bc6f7e4725820ebaa5b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 16 May 2012 17:18:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d75f1b391f5ef73016d14bc6f7e4725820ebaa5b
Gitweb:     http://git.kernel.org/tip/d75f1b391f5ef73016d14bc6f7e4725820ebaa5b
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 16 May 2012 15:03:53 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 16 May 2012 15:17:17 -0700

x86, xsave: remove thread_has_fpu() bug check in __sanitize_i387_state()

Code paths like fork(), exit() and signal handling flush the fpu
state explicitly to the structures in memory.

BUG_ON() in __sanitize_i387_state() is checking that the fpu state
is not live any more. But for preempt kernels, task can be scheduled
out and in at any place and the preload_fpu logic during context switch
can make the fpu registers live again.

For example, consider a 64-bit Task which uses fpu frequently and as such
you will find its fpu_counter mostly non-zero. During its time slice, kernel
used fpu by doing kernel_fpu_begin/kernel_fpu_end(). After this, in the same
scheduling slice, task-A got a signal to handle. Then during the signal
setup path we got preempted when we are just before the sanitize_i387_state()
in arch/x86/kernel/xsave.c:save_i387_xstate(). And when we come back we
will have the fpu registers live that can hit the bug_on.

Similarly during core dump, other threads can context-switch in and out
(because of spurious wakeups while waiting for the coredump to finish in
 kernel/exit.c:exit_mm()) and the main thread dumping core can run into this
bug when it finds some other thread with its fpu registers live on some other cpu.

So remove the paranoid check for now, even though it caught a bug in the
multi-threaded core dump case (fixed in the previous patch).

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1336692811-30576-3-git-send-email-suresh.b.siddha@intel.com
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/xsave.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index e62728e..bd18149 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -48,8 +48,6 @@ void __sanitize_i387_state(struct task_struct *tsk)
 	if (!fx)
 		return;
 
-	BUG_ON(__thread_has_fpu(tsk));
-
 	xstate_bv = tsk->thread.fpu.state->xsave.xsave_hdr.xstate_bv;
 
 	/*
