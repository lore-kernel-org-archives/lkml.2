Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab2CWVDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 17:03:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40633 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab2CWVDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 17:03:21 -0400
Date: Fri, 23 Mar 2012 14:02:55 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Ingo Molnar <mingo@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: [PATCH] x86: stop recursive fault in print_context_stack after stack
 overflow
Message-ID: <alpine.LSU.2.00.1203231355040.1940@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After printing out the first line of a stack backtrace,
print_context_stack() calls print_ftrace_graph_addr() to check if it's
making a graph of function calls, usually not the case.  But unfortunate
ordering of assignments causes this to oops if an earlier stack overflow
corrupted threadinfo->task.  Reorder to avoid that irritation.

(The fact that there was a stack overflow may often be more interesting
than the stack that can now be shown; but integrating that information
with this stacktrace is awkward, so leave it to overflow reporting.)

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 arch/x86/kernel/dumpstack.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- linux.git/arch/x86/kernel/dumpstack.c	2012-03-18 16:15:34.000000000 -0700
+++ linux/arch/x86/kernel/dumpstack.c	2012-03-23 10:43:28.196084684 -0700
@@ -37,13 +37,16 @@ print_ftrace_graph_addr(unsigned long ad
 			const struct stacktrace_ops *ops,
 			struct thread_info *tinfo, int *graph)
 {
-	struct task_struct *task = tinfo->task;
+	struct task_struct *task;
 	unsigned long ret_addr;
-	int index = task->curr_ret_stack;
+	int index;
 
 	if (addr != (unsigned long)return_to_handler)
 		return;
 
+	task = tinfo->task;
+	index = task->curr_ret_stack;
+
 	if (!task->ret_stack || index < *graph)
 		return;
 
