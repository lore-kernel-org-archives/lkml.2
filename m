Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab0HPRbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 13:31:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:40333 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292Ab0HPRbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 13:31:02 -0400
Date: Mon, 16 Aug 2010 17:30:40 GMT
From: tip-bot for Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, stable@kernel.org, shaohua.li@intel.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, stable@kernel.org, tglx@linutronix.de,
        shaohua.li@intel.com
In-Reply-To: <1280217994.32400.76.camel@sli10-desk.sh.intel.com>
References: <1280217994.32400.76.camel@sli10-desk.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing: Fix an unallocated memory access in function_graph
Message-ID: <tip-575570f02761bd680ba5731c1dfd4701062e7fb2@git.kernel.org>
Git-Commit-ID: 575570f02761bd680ba5731c1dfd4701062e7fb2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 16 Aug 2010 17:30:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  575570f02761bd680ba5731c1dfd4701062e7fb2
Gitweb:     http://git.kernel.org/tip/575570f02761bd680ba5731c1dfd4701062e7fb2
Author:     Shaohua Li <shaohua.li@intel.com>
AuthorDate: Tue, 27 Jul 2010 16:06:34 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 6 Aug 2010 12:19:15 -0400

tracing: Fix an unallocated memory access in function_graph

With CONFIG_DEBUG_PAGEALLOC, I observed an unallocated memory access in
function_graph trace. It appears we find a small size entry in ring buffer,
but we access it as a big size entry. The access overflows the page size
and touches an unallocated page.

Cc: <stable@kernel.org>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
LKML-Reference: <1280217994.32400.76.camel@sli10-desk.sh.intel.com>
[ Added a comment to explain the problem - SDR ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 79f4bac..b4c179a 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -507,7 +507,15 @@ get_return_for_leaf(struct trace_iterator *iter,
 			 * if the output fails.
 			 */
 			data->ent = *curr;
-			data->ret = *next;
+			/*
+			 * If the next event is not a return type, then
+			 * we only care about what type it is. Otherwise we can
+			 * safely copy the entire event.
+			 */
+			if (next->ent.type == TRACE_GRAPH_RET)
+				data->ret = *next;
+			else
+				data->ret.ent.type = next->ent.type;
 		}
 	}
 
