Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab2EHXPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 19:15:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:47432 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab2EHXPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 19:15:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="138405377"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        oleg@redhat.com
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        suresh@aristanetworks.com
Subject: [PATCH 2/3] x86, xsave: remove thread_has_fpu() bug check in __sanitize_i387_state()
Date: Tue,  8 May 2012 16:18:04 -0700
Message-Id: <1336519085-27450-3-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1336519085-27450-1-git-send-email-suresh.b.siddha@intel.com>
References: <1336421341.19423.4.camel@sbsiddha-desk.sc.intel.com>
 <1336519085-27450-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code paths like fork(), exit() and signal handling flush the fpu
state explicitly to the structures in memory.

BUG_ON() in __sanitize_i387_state() is checking that the fpu state
is not live any more. But for preempt kernels, task can be scheduled
out and in at any place and the preload_fpu logic during context switch
can make the fpu registers live again.

Similarly during core dump, thread dumping the core can schedule out
and in for page-allocations etc in non-preempt case.

So remove the paranoid check, even though it caught a bug in the
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

