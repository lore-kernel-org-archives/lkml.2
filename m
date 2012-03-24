Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab2CXH5I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 03:57:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60539 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2CXH5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 03:57:05 -0400
Date: Sat, 24 Mar 2012 00:56:53 -0700
From: tip-bot for Hugh Dickins <hughd@google.com>
Message-ID: <tip-65c0ff4079c011232e795e62c74a0a95512b7ac3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        hughd@google.com, namhyung@gmail.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hughd@google.com, namhyung@gmail.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <20120323225648.15DD5A033B@akpm.mtv.corp.google.com>
References: <20120323225648.15DD5A033B@akpm.mtv.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86:
  Stop recursive fault in print_context_stack after stack overflow
Git-Commit-ID: 65c0ff4079c011232e795e62c74a0a95512b7ac3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 24 Mar 2012 00:56:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  65c0ff4079c011232e795e62c74a0a95512b7ac3
Gitweb:     http://git.kernel.org/tip/65c0ff4079c011232e795e62c74a0a95512b7ac3
Author:     Hugh Dickins <hughd@google.com>
AuthorDate: Fri, 23 Mar 2012 14:02:55 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 24 Mar 2012 08:15:04 +0100

x86: Stop recursive fault in print_context_stack after stack overflow

After printing out the first line of a stack backtrace,
print_context_stack() calls print_ftrace_graph_addr() to check
if it's making a graph of function calls, usually not the case.

But unfortunate ordering of assignments causes this to oops if
an earlier stack overflow corrupted threadinfo->task.  Reorder
to avoid that irritation.

( The fact that there was a stack overflow may often be more
  interesting than the stack that can now be shown; but
  integrating that information with this stacktrace is awkward,
  so leave it to overflow reporting. )

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/20120323225648.15DD5A033B@akpm.mtv.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/dumpstack.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 4025fe4..90bf130 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -37,13 +37,16 @@ print_ftrace_graph_addr(unsigned long addr, void *data,
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
 
