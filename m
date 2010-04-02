Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab0DBSeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:34:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:57256 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab0DBSdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:33:02 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 5/5] kgdb: Turn off tracing while in the debugger
Date: Fri,  2 Apr 2010 13:32:25 -0500
Message-Id: <1270233145-29335-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1270233145-29335-5-git-send-email-jason.wessel@windriver.com>
References: <1270233145-29335-1-git-send-email-jason.wessel@windriver.com>
 <1270233145-29335-2-git-send-email-jason.wessel@windriver.com>
 <1270233145-29335-3-git-send-email-jason.wessel@windriver.com>
 <1270233145-29335-4-git-send-email-jason.wessel@windriver.com>
 <1270233145-29335-5-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 02 Apr 2010 18:32:45.0709 (UTC) FILETIME=[E37BF3D0:01CAD292]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel debugger should turn off kernel tracing any time the
debugger is active and restore it on resume.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/kgdb.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 7a56dc9..27e7bb5 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -1365,6 +1365,7 @@ static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs)
 	int sstep_tries = 100;
 	int error = 0;
 	int i, cpu;
+	int trace_on = 0;
 acquirelock:
 	/*
 	 * Interrupts will be restored by the 'trap return' code, except when
@@ -1399,6 +1400,8 @@ return_normal:
 			 */
 			if (arch_kgdb_ops.correct_hw_break)
 				arch_kgdb_ops.correct_hw_break();
+			if (trace_on)
+				tracing_on();
 			atomic_dec(&cpu_in_kgdb[cpu]);
 			touch_softlockup_watchdog_sync();
 			clocksource_touch_watchdog();
@@ -1474,6 +1477,9 @@ return_normal:
 	kgdb_single_step = 0;
 	kgdb_contthread = current;
 	exception_level = 0;
+	trace_on = tracing_is_on();
+	if (trace_on)
+		tracing_off();
 
 	/* Talk to debugger with gdbserial protocol */
 	error = gdb_serial_stub(ks);
@@ -1505,6 +1511,8 @@ kgdb_restore:
 		else
 			kgdb_sstep_pid = 0;
 	}
+	if (trace_on)
+		tracing_on();
 	/* Free kgdb_active */
 	atomic_set(&kgdb_active, -1);
 	touch_softlockup_watchdog_sync();
-- 
1.6.3.1.9.g95405b

