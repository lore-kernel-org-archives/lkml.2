Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab0JVU5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 16:57:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:36321 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757396Ab0JVU5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 16:57:08 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Dongdong Deng <dongdong.deng@windriver.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 08/11] debug_core: disable hw_breakpoints on all cores in kgdb_cpu_enter()
Date: Fri, 22 Oct 2010 15:56:28 -0500
Message-Id: <1287780991-7476-9-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1287780991-7476-1-git-send-email-jason.wessel@windriver.com>
References: <1287780991-7476-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 22 Oct 2010 20:56:54.0502 (UTC) FILETIME=[A86C4860:01CB722B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongdong Deng <dongdong.deng@windriver.com>

The slave cpus do not have the hw breakpoints disabled upon entry to
the debug_core and as a result could cause unrecoverable recursive
faults on badly placed breakpoints, or get out of sync with the arch
specific hw breakpoint operations.

This patch addresses the problem by invoking kgdb_disable_hw_debug()
earlier in kgdb_enter_cpu for each cpu that enters the debug core.

The hw breakpoint dis/enable flow should be:

master_debug_cpu   slave_debug_cpu
         \              /
          kgdb_cpu_enter
                |
        kgdb_disable_hw_debug --> uninstall pre-enabled hw_breakpoint
                |
 do add/rm dis/enable operates to hw_breakpoints on master_debug_cpu..
                |
        correct_hw_break --> correct/install the enabled hw_breakpoint
                |
           leave_kgdb

Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/debug_core.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 5a3b04d..bb94977 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -485,6 +485,9 @@ static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs)
 	int error;
 	int i, cpu;
 	int trace_on = 0;
+
+	kgdb_disable_hw_debug(ks->linux_regs);
+
 acquirelock:
 	/*
 	 * Interrupts will be restored by the 'trap return' code, except when
@@ -569,8 +572,6 @@ return_normal:
 	if (dbg_io_ops->pre_exception)
 		dbg_io_ops->pre_exception();
 
-	kgdb_disable_hw_debug(ks->linux_regs);
-
 	/*
 	 * Get the passive CPU lock which will hold all the non-primary
 	 * CPU in a spin state while the debugger is active
@@ -661,6 +662,8 @@ kgdb_restore:
 		else
 			kgdb_sstep_pid = 0;
 	}
+	if (arch_kgdb_ops.correct_hw_break)
+		arch_kgdb_ops.correct_hw_break();
 	if (trace_on)
 		tracing_on();
 	/* Free kgdb_active */
-- 
1.6.3.3

