Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab0FCTeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 15:34:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010Ab0FCTeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 15:34:11 -0400
Date: Thu, 3 Jun 2010 21:32:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: unify save_stack_address() and
	save_stack_address_nosched()
Message-ID: <20100603193243.GA31534@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup. Factor the common code in save_stack_address() and
save_stack_address_nosched().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 arch/x86/kernel/stacktrace.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

--- 34-rc1/arch/x86/kernel/stacktrace.c~UNIFY_SAVE_STACKS	2010-06-03 21:29:52.000000000 +0200
+++ 34-rc1/arch/x86/kernel/stacktrace.c	2010-06-03 21:30:57.000000000 +0200
@@ -23,13 +23,16 @@ static int save_stack_stack(void *data, 
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
@@ -38,22 +41,15 @@ static void save_stack_address(void *dat
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

