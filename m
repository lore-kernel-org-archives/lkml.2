Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab2H0RFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:05:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34332 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab2H0RFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:05:38 -0400
Date: Mon, 27 Aug 2012 10:05:23 -0700
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-781d06248234e221edb560a18461d65808a8a942@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andi@firstfloor.org, rostedt@goodmis.org, srostedt@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, rostedt@goodmis.org, srostedt@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20120807194059.773895870@goodmis.org>
References: <20120807194059.773895870@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace:
  Do not test frame pointers if -mfentry is used
Git-Commit-ID: 781d06248234e221edb560a18461d65808a8a942
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Aug 2012 10:05:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  781d06248234e221edb560a18461d65808a8a942
Gitweb:     http://git.kernel.org/tip/781d06248234e221edb560a18461d65808a8a942
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 9 Feb 2011 13:27:22 -0500
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 23 Aug 2012 11:25:29 -0400

ftrace: Do not test frame pointers if -mfentry is used

The function graph has a test to check if the frame pointer is
corrupted, which can happen with various options of gcc with mcount.
But this is not an issue with -mfentry as -mfentry does not need nor use
frame pointers for function graph tracing.

Link: http://lkml.kernel.org/r/20120807194059.773895870@goodmis.org

Acked-by: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index ce27c8b..99b4378 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -143,7 +143,7 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret,
 		return;
 	}
 
-#ifdef CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST
+#if defined(CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST) && !defined(CC_USING_FENTRY)
 	/*
 	 * The arch may choose to record the frame pointer used
 	 * and check it here to make sure that it is what we expect it
@@ -154,6 +154,9 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret,
 	 *
 	 * Currently, x86_32 with optimize for size (-Os) makes the latest
 	 * gcc do the above.
+	 *
+	 * Note, -mfentry does not use frame pointers, and this test
+	 *  is not needed if CC_USING_FENTRY is set.
 	 */
 	if (unlikely(current->ret_stack[index].fp != frame_pointer)) {
 		ftrace_graph_stop();
