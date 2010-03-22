Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab0CVTSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:18:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:36517 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab0CVTS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:18:26 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 7/8] debug_core: Turn off tracing while in the debugger
Date: Mon, 22 Mar 2010 14:17:28 -0500
Message-Id: <1269285449-1424-8-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1269285449-1424-7-git-send-email-jason.wessel@windriver.com>
References: <1269285449-1424-1-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-2-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-3-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-4-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-5-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-6-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-7-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 22 Mar 2010 19:17:41.0502 (UTC) FILETIME=[57C211E0:01CAC9F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel debugger should turn off kernel tracing any time the
debugger is active and restore it on resume.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/debug/debug_core.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index f471268..ab2a43f 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -449,6 +449,7 @@ static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs)
 	int sstep_tries = 100;
 	int error = 0;
 	int i, cpu;
+	int trace_on = 0;
 acquirelock:
 	/*
 	 * Interrupts will be restored by the 'trap return' code, except when
@@ -483,6 +484,8 @@ return_normal:
 			 */
 			if (arch_kgdb_ops.correct_hw_break)
 				arch_kgdb_ops.correct_hw_break();
+			if (trace_on)
+				tracing_on();
 			atomic_dec(&cpu_in_kgdb[cpu]);
 			touch_softlockup_watchdog_sync();
 			clocksource_touch_watchdog();
@@ -558,6 +561,9 @@ return_normal:
 	kgdb_single_step = 0;
 	kgdb_contthread = current;
 	exception_level = 0;
+	trace_on = tracing_is_on();
+	if (trace_on)
+		tracing_off();
 
 	/* Talk to debugger with gdbserial protocol */
 	error = gdb_serial_stub(ks);
@@ -589,6 +595,8 @@ kgdb_restore:
 		else
 			kgdb_sstep_pid = 0;
 	}
+	if (trace_on)
+		tracing_on();
 	/* Free kgdb_active */
 	atomic_set(&kgdb_active, -1);
 	touch_softlockup_watchdog_sync();
-- 
1.6.4.rc1

