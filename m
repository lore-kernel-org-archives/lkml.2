Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363Ab0JVU6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 16:58:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:36472 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab0JVU6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 16:58:30 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org
Subject: [PATCH 01/11] x86,kgdb: fix debugger hw breakpoint test regression in 2.6.35
Date: Fri, 22 Oct 2010 15:56:21 -0500
Message-Id: <1287780991-7476-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1287780991-7476-1-git-send-email-jason.wessel@windriver.com>
References: <1287780991-7476-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 22 Oct 2010 20:56:48.0799 (UTC) FILETIME=[A50612F0:01CB722B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HW breakpoints events stopped working correctly with kgdb as a result
of commit: 018cbffe6819f6f8db20a0a3acd9bab9bfd667e4 (Merge commit
'v2.6.33' into perf/core), later commit:
ba773f7c510c0b252145933926c636c439889207 (x86,kgdb: Fix hw breakpoint
regression) allowed breakpoints to propagate to the debugger core but
did not completely address the original regression in functionality
found in 2.6.35.

When the DR_STEP flag is set in dr6 along with any of the DR_TRAP
bits, the kgdb exception handler will enter once from the
hw_breakpoint API call back and again from the die notifier for
do_debug(), which causes the debugger to stop twice and also for the
kgdb regression tests to fail running under kvm with:

echo V2I1 > /sys/module/kgdbts/parameters/kgdbts

To address the problem, the kgdb overflow handler needs to implement
the same logic as the ptrace overflow handler call back with respect
to updating the virtual copy of dr6.  This will allow the kgdb
do_debug() die notifier to properly handle the exception and the
attached debugger, or kgdb test suite, will only receive a single
notification.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: x86@kernel.org
---
 arch/x86/kernel/kgdb.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 852b819..497f973 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -621,7 +621,12 @@ int kgdb_arch_init(void)
 static void kgdb_hw_overflow_handler(struct perf_event *event, int nmi,
 		struct perf_sample_data *data, struct pt_regs *regs)
 {
-	kgdb_ll_trap(DIE_DEBUG, "debug", regs, 0, 0, SIGTRAP);
+	struct task_struct *tsk = current;
+	int i;
+
+	for (i = 0; i < 4; i++)
+		if (breakinfo[i].enabled)
+			tsk->thread.debugreg6 |= (DR_TRAP0 << i);
 }
 
 void kgdb_arch_late(void)
-- 
1.6.3.3

