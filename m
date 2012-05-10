Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab2EJXa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:30:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:30440 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757554Ab2EJXa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:30:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164690655"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        oleg@redhat.com
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        suresh@aristanetworks.com
Subject: [PATCH v2 3/4] x86, xsave: remove thread_has_fpu() bug check in __sanitize_i387_state()
Date: Thu, 10 May 2012 16:33:30 -0700
Message-Id: <1336692811-30576-3-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1336692811-30576-1-git-send-email-suresh.b.siddha@intel.com>
References: <CA+55aFwNST_Lhou1h9JWkg348BET7CbqNX50XYPOFNbXioXdxg@mail.gmail.com>
 <1336692811-30576-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
-- 
1.7.6.5

