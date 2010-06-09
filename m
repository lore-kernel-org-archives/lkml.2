Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab0FISRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:17:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:49103 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757605Ab0FISRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:17:46 -0400
Date: Wed, 9 Jun 2010 18:17:19 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       arjan@linux.intel.com, vegard.nossum@gmail.com, fweisbec@gmail.com,
       roland@redhat.com, tglx@linutronix.de, oleg@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, vegard.nossum@gmail.com, fweisbec@gmail.com,
       roland@redhat.com, tglx@linutronix.de, oleg@redhat.com, mingo@elte.hu
In-Reply-To: <20100603193243.GA31534@redhat.com>
References: <20100603193243.GA31534@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Unify save_stack_address() and save_stack_address_nosched()
Message-ID: <tip-018378c55b03f88ff513aba4e0e93b8d4a9cf241@git.kernel.org>
Git-Commit-ID: 018378c55b03f88ff513aba4e0e93b8d4a9cf241
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 18:17:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  018378c55b03f88ff513aba4e0e93b8d4a9cf241
Gitweb:     http://git.kernel.org/tip/018378c55b03f88ff513aba4e0e93b8d4a9cf241
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Thu, 3 Jun 2010 21:32:43 +0200
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Wed, 9 Jun 2010 17:32:19 +0200

x86: Unify save_stack_address() and save_stack_address_nosched()

Cleanup. Factor the common code in save_stack_address() and
save_stack_address_nosched().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20100603193243.GA31534@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/stacktrace.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index abc321d..b53c525 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -23,13 +23,16 @@ static int save_stack_stack(void *data, char *name)
 	return 0;
 }
 
-static void save_stack_address(void *data, unsigned long addr, int reliable)
+static void
+__save_stack_address(void *data, unsigned long addr, bool reliable, bool nosched)
 {
 	struct stack_trace *trace = data;
 #ifdef CONFIG_FRAME_POINTER
 	if (!reliable)
 		return;
 #endif
+	if (nosched && in_sched_functions(addr))
+		return;
 	if (trace->skip > 0) {
 		trace->skip--;
 		return;
@@ -38,22 +41,15 @@ static void save_stack_address(void *data, unsigned long addr, int reliable)
 		trace->entries[trace->nr_entries++] = addr;
 }
 
+static void save_stack_address(void *data, unsigned long addr, int reliable)
+{
+	return __save_stack_address(data, addr, reliable, false);
+}
+
 static void
 save_stack_address_nosched(void *data, unsigned long addr, int reliable)
 {
-	struct stack_trace *trace = data;
-#ifdef CONFIG_FRAME_POINTER
-	if (!reliable)
-		return;
-#endif
-	if (in_sched_functions(addr))
-		return;
-	if (trace->skip > 0) {
-		trace->skip--;
-		return;
-	}
-	if (trace->nr_entries < trace->max_entries)
-		trace->entries[trace->nr_entries++] = addr;
+	return __save_stack_address(data, addr, reliable, true);
 }
 
 static const struct stacktrace_ops save_stack_ops = {
