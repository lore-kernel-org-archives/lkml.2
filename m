Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688Ab0ESBm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:42:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:41230 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962Ab0ESBkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:23 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/7] x86,kgdb: Implement early hardware breakpoint debugging
Date: Tue, 18 May 2010 20:39:58 -0500
Message-Id: <1274233202-3734-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233202-3734-1-git-send-email-jason.wessel@windriver.com>
References: <1274233202-3734-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:40:08.0110 (UTC) FILETIME=[368C54E0:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not possible to use the hw_breakpoint.c API prior to mm_init(),
but it is possible to use hardware breakpoints with the kernel
debugger.

Prior to smp_init() it is possible to simply write to the dr registers
of the boot cpu directly.  This can be used up until the
kgdb_arch_late() is invoked, at which point the standard hw_breakpoint.c
API will get used.

CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c |   30 ++++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 2b71ec4..4f4af75 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -199,6 +199,8 @@ static struct hw_breakpoint {
 	struct perf_event	**pev;
 } breakinfo[4];
 
+static unsigned long early_dr7;
+
 static void kgdb_correct_hw_break(void)
 {
 	int breakno;
@@ -210,6 +212,14 @@ static void kgdb_correct_hw_break(void)
 		int cpu = raw_smp_processor_id();
 		if (!breakinfo[breakno].enabled)
 			continue;
+		if (dbg_is_early) {
+			set_debugreg(breakinfo[breakno].addr, breakno);
+			early_dr7 |= encode_dr7(breakno,
+						breakinfo[breakno].len,
+						breakinfo[breakno].type);
+			set_debugreg(early_dr7, 7);
+			continue;
+		}
 		bp = *per_cpu_ptr(breakinfo[breakno].pev, cpu);
 		info = counter_arch_bp(bp);
 		if (bp->attr.disabled != 1)
@@ -224,7 +234,8 @@ static void kgdb_correct_hw_break(void)
 		if (!val)
 			bp->attr.disabled = 0;
 	}
-	hw_breakpoint_restore();
+	if (!dbg_is_early)
+		hw_breakpoint_restore();
 }
 
 static int hw_break_reserve_slot(int breakno)
@@ -233,6 +244,9 @@ static int hw_break_reserve_slot(int breakno)
 	int cnt = 0;
 	struct perf_event **pevent;
 
+	if (dbg_is_early)
+		return 0;
+
 	for_each_online_cpu(cpu) {
 		cnt++;
 		pevent = per_cpu_ptr(breakinfo[breakno].pev, cpu);
@@ -258,6 +272,9 @@ static int hw_break_release_slot(int breakno)
 	struct perf_event **pevent;
 	int cpu;
 
+	if (dbg_is_early)
+		return 0;
+
 	for_each_online_cpu(cpu) {
 		pevent = per_cpu_ptr(breakinfo[breakno].pev, cpu);
 		if (dbg_release_bp_slot(*pevent))
@@ -302,7 +319,11 @@ static void kgdb_remove_all_hw_break(void)
 		bp = *per_cpu_ptr(breakinfo[i].pev, cpu);
 		if (bp->attr.disabled == 1)
 			continue;
-		arch_uninstall_hw_breakpoint(bp);
+		if (dbg_is_early)
+			early_dr7 &= ~encode_dr7(i, breakinfo[i].len,
+						 breakinfo[i].type);
+		else
+			arch_uninstall_hw_breakpoint(bp);
 		bp->attr.disabled = 1;
 	}
 }
@@ -379,6 +400,11 @@ void kgdb_disable_hw_debug(struct pt_regs *regs)
 	for (i = 0; i < 4; i++) {
 		if (!breakinfo[i].enabled)
 			continue;
+		if (dbg_is_early) {
+			early_dr7 &= ~encode_dr7(i, breakinfo[i].len,
+						 breakinfo[i].type);
+			continue;
+		}
 		bp = *per_cpu_ptr(breakinfo[i].pev, cpu);
 		if (bp->attr.disabled == 1)
 			continue;
-- 
1.6.3.3

